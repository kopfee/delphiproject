unit MSSQLAcsEx;

interface

uses ComObj, ActiveX,Classes,SysUtils,contnrs, // std units
  TxtDB,MSSQLAcs,DBAIntf,IntfUtils,BasicDataAccess_TLB;  // my units

type
  TMSSQLAcsEx = class(TMSSQLAcs,IDBAccess)
  private
    FCmdCount : integer;
  protected
    procedure DoAfterExecute;  override;
  public
    function  Ready : boolean;
    function  GetSQLText : String;
    procedure SetSQLText(const Value:string);
    property  SQLText : String read GetSQLText write SetSQLText;
    function  GetExtraSQLText : String;
    procedure SetExtraSQLText(const Value:string);
    property  ExtraSQLText : String read GetExtraSQLText write SetExtraSQLText;
    function  hasDataset:TTriState;
    procedure getFieldDef(index : integer; FieldDef : TDBFieldDef);
    procedure ReachOutputs;
    function  hasOutput: TTriState;
    function  outputCount : Integer;
    procedure getOutputDef(index : integer; FieldDef : TDBFieldDef);
    function  readOutput(index : Integer; buffer : pointer; buffersize : Integer) : Integer;
    procedure ReachReturn;
    function  hasReturn: TTriState;
    function  readReturn(buffer : pointer; buffersize : Integer) : Integer;
    function  returnValue : integer;
    function  GetreadMode : TDataReadMode;
    procedure SetreadMode(value : TDataReadMode);
    property  readMode : TDataReadMode read GetreadMode Write SetreadMode;
    function  CmdCount:integer;
  published

  end;

  THDataset = class;
  THBasicField = class;
  THField = class;
  THParam = class;

  THFieldKind = (fkNormal,fkCalc);
  THFieldOption = (foRenderBrowse,foRenderPrint);
  THFieldOptions = set of THFieldOption;

  THFieldDef = class(TDBFieldDef)
  private
    function GetisStored: boolean;
  public
    Kind : THFieldKind;
    Options : THFieldOptions;
    constructor Create;
    function    charSize : integer;
    property    isStored : boolean read GetisStored;
  end;

  THDataset = class(TAutoIntfObjectEx,IHDataset)
  private
    FrowsPerReading : Integer;
    FignoreDataset : Boolean;
    FFieldDefs : TObjectList;
    FFields : TObjectList;
    FParamDefs : TObjectList;
    FParams : TObjectList;
    FReturnValue : integer;
    FDBAccess: IDBAccess;
    FTextDB : TTextDataset;
    FReadAll : boolean;
    FDone : boolean;
    procedure   internalBindFields;
    procedure   readData;
    procedure   readRow;
    procedure   readRows;
    procedure   readOutput;
    procedure   readReturn;
    procedure   getCalcFields;
    // return has more data
    function    needData:boolean;
    procedure   checkRead;
    function    GetFields(index: integer): THField;
  protected
    function    findField(const fieldName: WideString): IHField; safecall;
    function    Get_bof: WordBool; safecall;
    function    Get_eof: WordBool; safecall;
    function    Get_fieldCount: Integer; safecall;
    function    Get_fields(index: Integer): IHField; safecall;
    function    Get_outputCount: Integer; safecall;
    function    Get_outputParams(index: Integer): IHParam; safecall;
    function    Get_returnValue: Integer; safecall;
    function    Get_bookmark: Integer; safecall;
    procedure   Set_bookmark(Value: Integer); safecall;
    function    Get_available: WordBool; safecall;
  public
    constructor Create(aDBAccess : IDBAccess);
    Destructor  Destroy;override;
    property    DBAccess : IDBAccess read FDBAccess;
    // fields manage
    procedure   clearFields;
    function    newFieldDef : THFieldDef;
    procedure   bindField(index:integer);
    procedure   addAllExistFields;
    //
    procedure   Open(arowsPerReading : Integer; aignoreDataset : Boolean=false);
    procedure   Close;
    // navigate methods and properties
    property    available: WordBool read Get_available;
    procedure   first; safecall;
    procedure   last; safecall;
    procedure   next; safecall;
    procedure   prior; safecall;
    property    Eof : WordBool read Get_eof;
    property    Bof : WordBool read Get_bof;
    property    bookmark: Integer read Get_bookmark write Set_bookmark;
    // data properties
    property    FieldCount : integer read Get_fieldCount;
    property    outputCount : integer read Get_outputCount;
    property    returnValue : integer read Get_returnValue;
    property    Fields[index : integer] : THField read GetFields;
    function    findField2(const fieldName: String): THField;
    // render
    function    getRender(purpose: THRenderType): IHResultRender; safecall;
  end;

  TGetValueEvent = procedure (Field:THBasicField; var Value:OleVariant) of object;
  TSetValueEvent = procedure (Field:THBasicField; const Value:OleVariant) of object;
  TGetTextEvent  = procedure (Field:THBasicField; var Text:widestring) of object;
  TSetTextEvent  = procedure (Field:THBasicField; const Text:widestring) of object;

  THBasicField = class(TAutoIntfObjectEx,IHField)
  private
    FDataset: THDataset;
    FfieldDef: THFieldDef;
    FstringFormat : string;
    FOnGetDisplayText: TGetTextEvent;
    FOnGetValue: TGetValueEvent;
    FOnSetDisplayText: TSetTextEvent;
    FOnSetValue: TSetValueEvent;
  protected
    function      Get_displayName(): WideString; safecall;
    function      Get_fieldName(): WideString; safecall;
    function      Get_fieldSize(): Integer; safecall;
    function      Get_fieldType(): THFieldType; safecall;
    function      Get_Value(): OleVariant; virtual; safecall;
    procedure     Set_displayName(const Value: WideString); safecall;
    procedure     Set_value(Value: OleVariant); virtual;safecall;
    function      Get_asString: WideString; virtual;safecall;
    procedure     Set_asString(const Value: WideString); virtual;safecall;
    function      Get_asInteger: Integer; virtual;safecall;
    procedure     Set_asInteger(Value: Integer); virtual;safecall;
    function      Get_asFloat: Double; virtual;safecall;
    procedure     Set_asFloat(Value: Double); virtual;safecall;
    function      Get_asDatetime: TDateTime; virtual;safecall;
    procedure     Set_asDatetime(Value: TDateTime); virtual;safecall;
    function      Get_asCurrency: Currency; virtual;safecall;
    procedure     Set_asCurrency(Value: Currency); virtual;safecall;
    function      Get_stringFormat: WideString; safecall;
    procedure     Set_stringFormat(const Value: WideString); safecall;
    function      Get_asDisplayText: WideString; safecall;
    procedure     Set_asDisplayText(const Value: WideString); safecall;
    // ReadData is called by THDataset
    procedure     ReadData; virtual; abstract;
  public
    constructor   Create(ADataset : THDataset;aDef : THFieldDef);
    Destructor    Destroy;override;
    property      dataset : THDataset read FDataset;
    property      fieldDef : THFieldDef read FfieldDef;
    // IHField properties
    property      fieldName: WideString read Get_fieldName;
    property      displayName: WideString read Get_displayName write Set_displayName;
    property      fieldSize: Integer read Get_fieldSize;
    property      fieldType: THFieldType read Get_fieldType;
    property      Value: OleVariant read Get_Value write Set_Value;
    property      asString: WideString read Get_asString write Set_asString;
    property      asInteger: Integer read Get_asInteger write Set_asInteger;
    property      asFloat: Double read Get_asFloat write Set_asFloat;
    property      asDatetime: TDateTime read Get_asDatetime write Set_asDatetime;
    property      asCurrency: Currency read Get_asCurrency write Set_asCurrency;
    property      stringFormat: WideString read Get_stringFormat write Set_stringFormat;
    property      asDisplayText: WideString read Get_asDisplayText write Set_asDisplayText;
    // event
    // get/set value is available only in a calculate field
    property      OnGetValue : TGetValueEvent read FOnGetValue write FOnGetValue;
    property      OnSetValue : TSetValueEvent read FOnSetValue write FOnSetValue;
    //
    property      OnGetDisplayText : TGetTextEvent read FOnGetDisplayText write FOnGetDisplayText;
    property      OnSetDisplayText : TSetTextEvent read FOnSetDisplayText write FOnSetDisplayText;
  end;

  THField = class(THBasicField)
  private
    FTextField : TTextField;
  protected
    function      Get_Value(): OleVariant; override; safecall;
    procedure     Set_value(Value: OleVariant); override; safecall;
    procedure     ReadData; override;
    {function      Get_asString(): WideString; override; safecall;
    procedure     Set_asString(const Value: WideString); override; safecall;
    function      Get_asInteger: Integer; override; safecall;
    procedure     Set_asInteger(Value: Integer); override; safecall;}
  public
    property      TextField : TTextField read FTextField ;
    property      asString : WideString read Get_asString;
  end;

  THParam = class(THBasicField,IHParam)
  private
    FStrValue :   string;
  protected
    function      Get_asString(): WideString; override; safecall;
    function      Get_Value(): OleVariant; override; safecall;
    procedure     ReadData; override;
  public

  end;

  THBasicRander = class(TAutoIntfObjectEx,IHResultRender)
  private

  protected
    FDataset: THDataset;
    FSeq_NO : integer;
    FBookmark : integer;
    FInitParam : OleVariant;
    FFirst : boolean;
    FIDataset : IHDataset;
    FBindedFields : TList;
    function    Get_eof: WordBool; safecall;
    function    Get_seqNo: Integer; safecall;
    function    internalGetData(rows: Integer): string; virtual;abstract;
    procedure   doBindFields(const bindFields: String); virtual;
    procedure   defaultBinding; virtual;
  public
    constructor Create(aDataset : THDataset);
    Destructor  Destroy;override;
    property    Dataset : THDataset read FDataset;

    procedure   prepare(initParam: OleVariant; const bindFields: WideString); virtual;safecall;
    function    getData(rows: Integer): WideString; safecall;
    property    eof: WordBool read Get_eof;
    property    seqNo: Integer read Get_seqNo;
  end;

  THBrowseRender = class(THBasicRander)
  private
    FgridName :  string;
  protected
    procedure   defaultBinding; override;
    function    internalGetData(rows: Integer): string; override;
  public

  end;

  THPrintRender = class(THBasicRander)
  private

  protected
    procedure   defaultBinding; override;
    function    internalGetData(rows: Integer): string; override;
  public

  end;

implementation

uses MSSQL,windows,ComServ,BDACore;

{ TMSSQLAcsEx }

function TMSSQLAcsEx.CmdCount: integer;
begin
  result := FCmdCount;
end;

procedure TMSSQLAcsEx.DoAfterExecute;
begin
  inc(FCmdCount);
  inherited;
end;

function TMSSQLAcsEx.GetExtraSQLText: String;
begin
  result := '';
end;

procedure TMSSQLAcsEx.getFieldDef(index: integer; FieldDef: TDBFieldDef);
begin
  checkFieldIndex(index);
  FieldDef.FieldIndex := index;
  FieldDef.FieldName := fieldName(index);
  FieldDef.DisplayName := FieldDef.FieldName;
  case FieldType(index) of
      SQLINT1,SQLINT2,SQLINT4 : FieldDef.FieldType := ftInteger;
      SQLVARCHAR,SQLCHAR : FieldDef.FieldType := ftChar;
      SQLMONEY,SQLMONEYN,SQLMONEY4 : FieldDef.FieldType := ftCurrency;
      SQLFLT8,SQLFLTN,SQLFLT4,SQLDECIMAL,SQLNUMERIC : FieldDef.FieldType:=ftFloat;
      SQLDATETIME,SQLDATETIMN,SQLDATETIM4 : FieldDef.FieldType:=ftDatetime;
      MSSQL.SQLTEXT,SQLVARBINARY,SQLBINARY,SQLIMAGE,SQLBIT : FieldDef.FieldType := ftBinary;
    else FieldDef.FieldType := ftOther;
  end;
  FieldDef.FieldSize := FieldSize(index);
end;

procedure TMSSQLAcsEx.getOutputDef(index: integer; FieldDef: TDBFieldDef);
begin
  // do nothing
end;

function TMSSQLAcsEx.GetreadMode: TDataReadMode;
begin
  result := rmRaw;
end;

function TMSSQLAcsEx.GetSQLText: String;
begin
  result := SQL.Text;
end;

function TMSSQLAcsEx.hasDataset: TTriState;
begin
  if fieldCount>0 then
    result := tsTrue else
    result := tsFalse;
end;

function TMSSQLAcsEx.hasOutput: TTriState;
begin
  result := tsFalse;
end;

function TMSSQLAcsEx.hasReturn: TTriState;
begin
  result := tsFalse;
end;

function TMSSQLAcsEx.outputCount: Integer;
begin
  result := 0;
end;

procedure TMSSQLAcsEx.ReachOutputs;
begin
  // do nothing
end;

procedure TMSSQLAcsEx.ReachReturn;
begin
  // do nothing
end;

function TMSSQLAcsEx.readOutput(index: Integer; buffer: pointer;
  buffersize: Integer): Integer;
begin
  result := 0;
  // do nothing
end;

function TMSSQLAcsEx.readReturn(buffer: pointer;
  buffersize: Integer): Integer;
begin
  result := 0;
  // do nothing
end;

function TMSSQLAcsEx.Ready: boolean;
begin
  result := CmdCount>0;
end;

function TMSSQLAcsEx.returnValue: integer;
begin
  result := 0;
end;

procedure TMSSQLAcsEx.SetExtraSQLText(const Value: string);
begin
  // do nothing
end;

procedure TMSSQLAcsEx.SetreadMode(value: TDataReadMode);
begin
  if value<>rmRaw then
    raise Exception.create('Only allow raw data!');
end;

procedure TMSSQLAcsEx.SetSQLText(const Value: string);
begin
  SQL.Clear;
  SQL.add(value);
end;

const
  MaxOutputValue = 128;
  Bookmark_BOF = -1;
  Bookmark_EOF = -2;

procedure LogCreate(obj : TOBject);
begin
  outputDebugString(pchar(format('%s[%8.8x] create.',[obj.className,integer(obj)])));
end;

procedure LogDestroy(obj : TOBject);
begin
  outputDebugString(pchar(format('%s[%8.8x] Destroy.',[obj.className,integer(obj)])));
end;

{ THFieldDef }

constructor THFieldDef.Create;
begin
  inherited ;
  Options := [foRenderBrowse,foRenderPrint];
end;

function THFieldDef.GetisStored: boolean;
begin
  result := (kind=fkNormal) and (FieldType in [ftInteger,ftFloat,ftChar,ftDatetime,ftCurrency]);
end;


function THFieldDef.charSize: integer;
begin
  case FieldType of
    ftInteger:
                 result := sizeof(Integer);
    ftFloat:     result := sizeof(double);
    ftChar:      result := FieldSize;
    ftDatetime:  result := sizeof(TDateTime);
  else
    result := FieldSize;
  end;
end;


{  THDataset  }

constructor THDataset.Create(aDBAccess: IDBAccess);
begin
  LogCreate(self);
  inherited Create(getBDATypeLib,IHDataset);
  FDBAccess := aDBAccess;
  FFieldDefs := TObjectList.Create;
  FFields := TObjectList.Create;
  FTextDB := TTextDataset.Create;
  FParamDefs := TObjectList.Create;
  FParams := TObjectList.Create;
end;

destructor THDataset.Destroy;
begin
  FParamDefs.free;
  FParams.free;
  FTextDB.free;
  FFieldDefs.free;
  FFields.free;
  inherited;
  LogDestroy(self);
end;

// IHDataset implements
function THDataset.findField(const fieldName: WideString): IHField;
var
  Field : THField;
begin
  Field := findField2(fieldName);
  if Field<>nil then
    result := Field as IHField else
    result := nil;
end;

function THDataset.Get_bof: WordBool;
begin
  result := FTextDB.Bof;
  //if result then assert(FTextDB.cursor<=0);
  assert( not result or (FTextDB.cursor<=0));
end;

function THDataset.Get_eof: WordBool;
begin
  checkRead;
  result := FTextDB.eof;
  //if result then assert(FTextDB.cursor>=FTextDB.count-1);
  assert( not result or (FTextDB.cursor>=FTextDB.count-1) )
end;

function THDataset.Get_fieldCount: Integer;
begin
  result := FFields.Count;
end;

function THDataset.Get_fields(index: Integer): IHField;
begin
  result := THField(FFields[index]) as IHField;
end;

function THDataset.GetFields(index: integer): THField;
begin
  result := THField(FFields[index]);
end;

function THDataset.Get_outputCount: Integer;
begin
  result := FParams.Count;
end;

function THDataset.Get_outputParams(index: Integer): IHParam;
begin
  result := THParam(FParams[index]) as IHParam;
end;

function THDataset.Get_returnValue: Integer;
begin
  result := FReturnValue;
end;

// navigate  operations

procedure THDataset.first;
begin
  FTextDB.first;
end;

procedure THDataset.last;
begin
  //read all data
  FrowsPerReading:=-1;
  readData;
  FTextDB.Last;
end;

procedure THDataset.next;
begin
  CheckRead;
  FTextDB.next;
end;

procedure THDataset.prior;
begin
  FTextDB.prior;
end;

procedure THDataset.clearFields;
begin
  FFieldDefs.Clear;
  FFields.Clear;
  FTextDB.Clear;
  FParamDefs.Clear;
  FParams.Clear;
end;

function THDataset.newFieldDef: THFieldDef;
begin
  result := THFieldDef.Create;
  FFieldDefs.Add(result);
end;

procedure THDataset.bindField(index: integer);
begin
  newFieldDef().FieldIndex := index;
end;

procedure THDataset.addAllExistFields;
var
  fieldsInDB : integer;
  i : integer;
begin
  fieldsInDB := FDBAccess.fieldCount;
  for i:=1 to fieldsInDB do
    bindField(i);
end;

procedure THDataset.internalBindFields;
var
  i : integer;
  FieldDef : THFieldDef;
  DBFieldCount : integer;
  Field : THField;
begin
  if DBAccess.hasDataset=tsTrue then
  begin
    FTextDB.BeginCreateField;
    //
    DBFieldCount := DBAccess.fieldCount;
    for i:=0 to FFieldDefs.count-1 do
    begin
      FieldDef := THFieldDef(FFieldDefs[i]);
      if FieldDef.Kind=fkNormal then
      begin
        if (FieldDef.FieldIndex>=1) and
           (FieldDef.FieldIndex<=DBFieldCount) then
          DBAccess.getFieldDef(FieldDef.FieldIndex,FieldDef);
      end;
      if FieldDef.isStored then
      begin
        Field := THField.create(self,FieldDef);
        FFields.add(Field);
        with FieldDef do
          Field.FTextField := FTextDB.CreateField(FieldName,DisplayName,charSize);
      end;
    end;
    FTextDB.EndCreateField;
  end else
    FTextDB.Clear;
end;


procedure THDataset.getCalcFields;
begin

end;

procedure THDataset.Open(arowsPerReading: Integer;
  aignoreDataset: Boolean=false);
begin
  FrowsPerReading := arowsPerReading;
  FignoreDataset := aignoreDataset;
  internalBindFields;
  FReadAll := false;
  FDone := false;
  readData;
end;

procedure THDataset.readData;
begin
  if not FDone then
  begin
    if FignoreDataset or (FFields.Count<=0) then
    begin
      //FDBAccess.ReachOutputs;
      FReadAll := true;
    end;

    if not FignoreDataset and not FReadall then
      readRows;

    if FReadall then
    begin
      readOutput;
      readReturn;
      FDone := true;
    end;
  end;
end;

procedure THDataset.readRows;
var
  readCount : integer;
begin
  readCount := 0;
  while ((FrowsPerReading<=0) or (readCount<FrowsPerReading)) and FDBAccess.nextRow do
  begin
    readRow;
    inc(readCount);
  end;
  if FDBAccess.eof then FReadAll:=true;
end;

procedure THDataset.readRow;
var
  i : integer;
begin
  FTextDB.Append;
  for i:=0 to FFields.count-1 do
  begin
    THField(FFields[i]).ReadData;
  end;
  getCalcFields;
end;


procedure THDataset.readOutput;
var
  i : integer;
  ParamDef : THFieldDef;
  Param : THParam;
begin
  outputDebugString(pchar(
    format('THDataset[%8.8x] Datarows : %d',[integer(self),FTextDB.count])));
  FDBAccess.ReachOutputs;
  if FDBAccess.hasOutput=tsTrue then
  begin
    for i:=1 to FDBAccess.outputCount do
    begin
      ParamDef := THFieldDef.Create;
      FParamDefs.Add(ParamDef);
      DBAccess.getOutputDef(i,ParamDef);
      Param := THParam.Create(self,ParamDef);
      FParams.add(Param);
      Param.ReadData;
    end;
  end;
end;

procedure THDataset.readReturn;
begin
  FDBAccess.ReachReturn;
  if FDBAccess.hasReturn=tsTrue then
    FReturnValue := FDBAccess.returnValue else
    FReturnValue := 0;
end;

procedure THDataset.Close;
begin
  clearFields;
end;

function  THDataset.needData:boolean;
var
  SaveCursor : integer;
begin
  if not FReadAll then
  begin
    SaveCursor := FTextDB.Cursor;
    readData;
    FTextDB.Cursor := SaveCursor;
  end;

  result := not FReadAll;
end;

procedure THDataset.checkRead;
begin
  if FTextDB.Cursor = FTextDB.Count-1 then
  //if FTextDB.eof then
    needData;
end;

function THDataset.getRender(purpose: THRenderType): IHResultRender;
begin
  if purpose=rtBrowse then
    result := IHResultRender(THBrowseRender.Create(self)) else
    if purpose=rtPrint then
      result := IHResultRender(THPrintRender.Create(self)) else
      result := nil;
end;


function THDataset.Get_bookmark: Integer;
begin
  if bof then result:=Bookmark_BOF else
  if eof then result:=Bookmark_EOF else
  result := FTextDB.Cursor;
end;

procedure THDataset.Set_bookmark(Value: Integer);
begin
  if value=bookmark_BOF then first else
  if value=bookmark_EOF then last else
  FTextDB.Cursor := value;
end;

function THDataset.Get_available: WordBool;
begin
  result := FTextDB.Available;
end;

function THDataset.findField2(const fieldName: String): THField;
var
  i : integer;
  Field : THField;
begin
  result:= nil;
  for i:=0 to FFields.count-1 do
  begin
    Field := THField(FFields[i]);
    if CompareText(Field.fieldDef.FieldName,fieldName)=0 then
    begin
      //result:= Field as IHField;
      result:= Field;
      break;
    end;
  end;
end;

{ THBasicField }

constructor THBasicField.Create(ADataset: THDataset; aDef: THFieldDef);
begin
  LogCreate(self);
  FDataset := ADataset;
  FfieldDef := aDef;
  inherited CreateAggregated(getBDATypeLib,IHField,IUnknown(ADataset));
end;

destructor THBasicField.Destroy;
begin
  inherited;
  LogDestroy(self);
end;

function THBasicField.Get_asCurrency: Currency;
begin
  result := value;
end;

function THBasicField.Get_asDatetime: TDateTime;
begin
  result := value;
end;

function THBasicField.Get_asFloat: Double;
begin
  result := value;
end;

function THBasicField.Get_asInteger: Integer;
begin
  result := value;
end;

function THBasicField.Get_asString: WideString;
var
  intValue : integer;
  floatValue : double;
  dateValue : TDateTime;
  charValue : String;
  currencyValue : Currency;
begin
  case FfieldDef.FieldType of
    ftInteger : if FstringFormat='' then
                  result:=value else
                  begin
                    intValue := value;
                    result := format(FstringFormat,[intValue]);
                  end;
    ftFloat   : if FstringFormat='' then
                  result:=value else
                  begin
                    floatValue := value;
                    result := format(FstringFormat,[floatValue]);
                  end;
    ftCurrency: begin
                  currencyValue := value;
                  if FstringFormat='' then
                    result := FormatCurr('#,##0.00',currencyValue) else
                    result := FormatCurr(FstringFormat,currencyValue);
                end;
    ftChar    : if FstringFormat='' then
                  result:=value else
                  begin
                    charValue := value;
                    result := format(FstringFormat,[charValue]);
                  end;
    ftDatetime: begin
                  dateValue := value;
                  if FstringFormat='' then
                    result := FormatDateTime('yyyy-mm-dd hh:nn:ss',dateValue) else
                    result := FormatDateTime(FstringFormat,dateValue);
                end;
    ftBinary,ftOther : result:='';
  end;
end;

function THBasicField.Get_displayName: WideString;
begin
  result := FfieldDef.DisplayName;
end;

function THBasicField.Get_fieldName: WideString;
begin
  result := FfieldDef.FieldName;
end;

function THBasicField.Get_fieldSize: Integer;
begin
  result := FfieldDef.FieldSize;
end;

function THBasicField.Get_fieldType: THFieldType;
begin
  result := THFieldType(FfieldDef.FieldType);
end;

function THBasicField.Get_stringFormat: WideString;
begin
  result := FstringFormat;
end;

function THBasicField.Get_Value: OleVariant;
begin
  if (FfieldDef.Kind = fkCalc) and assigned(FOnGetValue) then
    FOnGetValue(self,result) else
    result := 0;
end;

procedure THBasicField.Set_asCurrency(Value: Currency);
begin
  Set_value(value);
end;

procedure THBasicField.Set_asDatetime(Value: TDateTime);
begin
  Set_value(value);
end;

procedure THBasicField.Set_asFloat(Value: Double);
begin
  Set_value(value);
end;

procedure THBasicField.Set_asInteger(Value: Integer);
begin
  Set_value(value);
end;

procedure THBasicField.Set_asString(const Value: WideString);
begin
  Set_value(value);
end;

procedure THBasicField.Set_displayName(const Value: WideString);
begin
  FfieldDef.DisplayName := value;
end;

procedure THBasicField.Set_stringFormat(const Value: WideString);
begin
  FstringFormat := value;
end;

function THBasicField.Get_asDisplayText: WideString;
begin
  if Assigned(FOnGetDisplayText) then
    FOnGetDisplayText(self,result) else
    result := asString;
end;

procedure THBasicField.Set_asDisplayText(const Value: WideString);
begin
  if Assigned(FOnSetDisplayText) then
    FOnSetDisplayText(self,value) else
    asString:= value;
end;

procedure THBasicField.Set_value(Value: OleVariant);
begin
  if (FfieldDef.Kind = fkCalc) and assigned(FOnSetValue) then
    FOnSetValue(self,value);
end;

{ THField }

function THField.Get_Value: OleVariant;
var
  intValue : integer;
  floatValue : double;
  dateValue : TDateTime;
  charValue : String;
  buffer : pchar;
  currencyValue : Currency;
begin
  if FfieldDef.Kind=fkNormal then
  begin
    buffer := FTextField.GetDataBuffer;
    case FfieldDef.FieldType of
      ftInteger:  begin
                    move(Buffer^,intValue,sizeof(integer));
                    result := intValue;
                  end;
      ftFloat:    begin
                    move(Buffer^,floatValue,sizeof(double));
                    result := currencyValue;
                  end;
      ftCurrency: begin
                    move(Buffer^,currencyValue,sizeof(currency));
                    result := currencyValue;
                  end;
      ftChar:     begin
                    charValue := FTextField.Value;
                    result := wideString(charValue);
                  end;
      ftDatetime: begin
                    move(Buffer^,dateValue,sizeof(TDateTime));
                    result := dateValue;
                  end;
      ftBinary,ftOther :
        result := NULL;
    end;
  end else
  result := inherited Get_Value;
end;

procedure THField.ReadData;
var
  intValue : integer;
  floatValue : double;
  dateValue : TDateTime;
  charValue : String;
  buffer : pchar;
  currencyValue : Currency;
begin
  if FfieldDef.Kind=fkNormal then
  begin
    buffer := FTextField.GetDataBuffer;
    case FfieldDef.FieldType of
      ftInteger:  begin
                    intValue := FDataset.DBAccess.fieldAsInteger(FfieldDef.FieldIndex);
                    move(intValue,Buffer^,sizeof(integer));
                  end;
      ftFloat:    begin
                    floatValue := FDataset.DBAccess.fieldAsFloat(FfieldDef.FieldIndex);
                    move(floatValue,Buffer^,sizeof(double));
                  end;
      ftCurrency: begin
                    currencyValue :=FDataset.DBAccess.fieldAsCurrency(FfieldDef.FieldIndex);
                    move(currencyValue,Buffer^,sizeof(currency));
                  end;
      ftChar:     begin
                    charValue := FDataset.DBAccess.fieldAsString(FfieldDef.FieldIndex);
                    //move(pchar(charValue)^,Buffer^,length(charValue));
                    FTextField.value := charValue;
                  end;
      ftDatetime: begin
                    dateValue := FDataset.DBAccess.fieldAsDateTime(FfieldDef.FieldIndex);
                    move(dateValue,Buffer^,sizeof(TDateTime));
                  end;
      ftBinary,ftOther :
        FDataset.DBAccess.readData(FfieldDef.FieldIndex,
          Buffer,
          FTextField.Size);
    end;

  end;
end;

procedure THField.Set_value(Value: OleVariant);
var
  intValue : integer;
  floatValue : double;
  dateValue : TDateTime;
  charValue : String;
  buffer : pchar;
  currencyValue : Currency;
begin
  if FfieldDef.Kind=fkNormal then
  begin
    buffer := FTextField.GetDataBuffer;
    case FfieldDef.FieldType of
      ftInteger:  begin
                    intValue := value;
                    move(intValue,Buffer^,sizeof(integer));
                  end;
      ftFloat:    begin
                    floatValue := value;
                    move(floatValue,Buffer^,sizeof(double));
                  end;
      ftCurrency: begin
                    currencyValue :=value;
                    move(currencyValue,Buffer^,sizeof(currency));
                  end;
      ftChar:     begin
                    charValue := value;
                    //move(pchar(charValue)^,Buffer^,length(charValue));
                    FTextField.value := charValue;
                  end;
      ftDatetime: begin
                    dateValue := value;
                    move(dateValue,Buffer^,sizeof(TDateTime));
                  end;
      ftBinary,ftOther : ;
    end;
  end else
  inherited ;
end;

{
function THField.Get_asInteger: Integer;
begin
  move(FTextField.GetDataBuffer^,result,sizeof(result));
end;

function THField.Get_asString: WideString;
begin
  result := FTextField.value;
end;


procedure THField.Set_asInteger(Value: Integer);
begin
  move(value,FTextField.GetDataBuffer^,sizeof(value));
end;

procedure THField.Set_asString(const Value: WideString);
begin
  FTextField.Value := value;
end;
}
{ THParam }

function THParam.Get_asString: WideString;
begin
  result := FStrValue;
end;

function THParam.Get_Value: OleVariant;
begin
  result := FStrValue;
end;

procedure THParam.ReadData;
var
  Buffer : array[0..MaxOutputValue] of char;
begin
  Buffer[MaxOutputValue]:=#0;
  FDataset.DBAccess.readOutput(FFieldDef.FieldIndex,@Buffer[0],MaxOutputValue);
  FStrValue := pchar(@Buffer[0]);
end;


{ THBasicRander }

constructor THBasicRander.Create(aDataset: THDataset);
begin
  LogCreate(self);
  FDataset := aDataset;
  //FDataset._AddRef;
  FIDataset := aDataset as IHDataset;
  FBindedFields := TList.Create;
  inherited Create(getBDATypeLib,IHResultRender);
end;

procedure THBasicRander.prepare(initParam: OleVariant; const bindFields: WideString);
begin
  //FDataset._Release;
  FInitParam := initParam;
  FSeq_NO := 0;
  if FDataset.available then
  begin
    FDataset.first;
    FBookmark := FDataset.bookmark;
  end;
  FFirst := true;
  // bind fields
  FBindedFields.clear;
  doBindFields(bindFields);
end;


function THBasicRander.getData(rows: Integer): WideString;
begin
  if FDataset.available then
  begin
    FDataset.bookmark := FBookmark;
    result := internalGetData(rows);
    FBookmark := FDataset.bookmark;
    FFirst := false;
    inc(FSeq_NO);
  end else
    result := '';
end;

function THBasicRander.Get_eof: WordBool;
begin
  FDataset.bookmark := FBookmark;
  result := FDataset.Eof;
end;

function THBasicRander.Get_seqNo: Integer;
begin
  result := FSeq_No;
end;

destructor THBasicRander.Destroy;
begin
  FBindedFields.free;
  inherited;
  LogDestroy(self);
end;

procedure THBasicRander.doBindFields(const bindFields: String);
var
  restFields : string;
  k,n : integer;
  field : THField;
  fieldDesc : string;
begin
  restFields := Trim(bindFields);
  if restFields='' then
    defaultBinding else
    while restFields<>'' do
    begin
      // bind specified fields
      k := pos(';',restFields);
      if k>0 then
      begin
        fieldDesc := copy(restFields,1,k-1);
        restFields := copy(restFields,k+1,length(restFields));
      end else
      begin
        fieldDesc := restFields;
        restFields := '';
      end;
      fieldDesc := trim(fieldDesc);
      field := nil;
      if fieldDesc<>'' then
        if fieldDesc[1]='#' then
        begin
          try
            n := StrToInt(copy(fieldDesc,2,length(fieldDesc)));
            if (n>=0) and (n<FDataset.FieldCount) then
              field := FDataset.Fields[n];
          except
            // for data convert exception
          end;
        end else
        begin
          field := FDataset.findField2(fieldDesc);
        end;
      if field<>nil then
        FBindedFields.add(field);
    end;
end;

procedure THBasicRander.defaultBinding;
var
  i : integer;
begin
  // bind all available fields
  for i:=0 to FDataset.FieldCount-1 do
    FBindedFields.add(FDataset.Fields[i]);
end;

{ THBrowseRender }

procedure THBrowseRender.defaultBinding;
var
  i : integer;
  field : THField;
begin
  // bind all available fields
  for i:=0 to FDataset.FieldCount-1 do
  begin
    field := FDataset.Fields[i];
    if foRenderBrowse in field.fieldDef.Options then
      FBindedFields.add(field);
  end;
end;

function THBrowseRender.internalGetData(rows: Integer): string;
var
  renderRows : integer;
  i : integer;
  col : integer;
  field : THField;
begin
  renderRows := 0;
  if FFirst then
    try
      FgridName := FInitParam;
    except
      FgridName := 'mygrid';
    end;
  result := '';
  while ((rows<=0) or (renderRows<rows)) and not FDataset.Eof do
  begin
    col := 0;
    for i:=0 to FBindedFields.Count-1 do
    begin
      field := THField(FBindedFields[i]);
      result := format('%s%s[%d][%d]="%s"'#13#10,
          [result,FGridName,renderRows,col,field.asDisplayText]);
      inc(col);
    end;
    inc(renderRows);
    FDataset.next;
  end;
  if  renderRows=0 then result:=FGridName+'=null';
end;

{ THPrintRender }

procedure THPrintRender.defaultBinding;
var
  i : integer;
  field : THField;
begin
  // bind all available fields
  for i:=0 to FDataset.FieldCount-1 do
  begin
    field := FDataset.Fields[i];
    if foRenderPrint in field.fieldDef.Options then
      FBindedFields.add(field);
  end;
end;

function THPrintRender.internalGetData(rows: Integer): string;
var
  renderRows : integer;
  i : integer;
  col : integer;
  field : THField;
begin
  renderRows := 0;

  result := '';
  if FFirst then
  begin
    col := 0;
    for i:=0 to FBindedFields.Count-1 do
    begin
      field :=  THField(FBindedFields[i]);
      if col>0 then result:=result+',';
      with Field.TextField do
        result := format('%s"%s"="%s"[%d]',
        [result,displayName,fieldName,Size]);
      inc(col);
    end;
    result := result + ';'#13#10;
  end;


  while ((rows<=0) or (renderRows<rows)) and not FDataset.Eof do
  begin
    col := 0;
    for i:=0 to FBindedFields.Count-1 do
    begin
      field := THField(FBindedFields[i]);
      if col>0 then result:=result+',';
      result := format('%s"%s"',
        [result,field.asDisplayText]);
      inc(col);
    end;
    result := result + ';'#13#10;
    inc(renderRows);
    FDataset.next;
  end;
  if  renderRows=0 then result:='';
end;

initialization

end.
