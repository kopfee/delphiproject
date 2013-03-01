unit BDAImpEx;

(*
    Basic Data Access Dataset

    Not like THDataset, THCustomStdDataset is descendent from TDataset

      Code Written By Huang YanLai

  This codes is base on the delphi's demo of TextData.pas
*)

{$I KSConditions.INC }

interface

uses
  DB, Classes, TxtDB, BDAImp, DBAIntf,IntfUtils,listeners,contnrs;

resourcestring
  SInvalidDatabase = '无效的数据库对象';
  SCannotConnectToServer = '无法连接到服务器';
  SNoDatabase = '没有设置数据库对象';
  SCannotGetConnection = '无法获得服务器连接';

const
  lcHDatabase = 13;

type
  THCustomDataset = class;

  { TODO : 在关闭数据库的时候，还应该关闭连接它的Dataset对象，以关闭Dataset对象使用的IDBAccess实例 }
  {
    <Class>THDatabase
    <What>创建IDBAccess实例的类工厂。保存连接参数。同时提供连接缓冲池。
    <Properties>
      Connected - 是否连接到数据源
      minConnection - 最少保持的连接数量。当调用notUseDBAccess的时候，如果缓冲池中连接的数量小于minConnection，那么这个连接被保存。
      maxConnection - <未用>
    <Methods>
      open  - 连接到数据源
      close - 关闭连接
      getDBAccess - 获得一个空闲的IDBAccess。
      notUseDBAccess - 释放一个使用完毕的IDBAccess。这个IDBAccess可以被保存到连接缓冲池中。

      doConnect - 完成连接到数据源的工作：调用newDBAccess获得第一个IDBAccess的实例，保存到缓冲池。
      doDisconnect - 关闭到数据源连接：关闭缓冲池中所有的连接。
      newDBAccess - 创建一个IDBAccess的实例，该实例已经成功连接到数据源。
    <Event>
      OnConnected - 当连接到数据源的时候被触发
      OnDisConnected - 当关闭数据源的时候被触发

  }
  THDatabase = class(TComponent)
  private
    FOnDisConnected: TNotifyEvent;
    FOnConnected: TNotifyEvent;
    procedure   SetConnected(const Value: boolean);
    procedure   SetMaxConnection(const Value: integer);
    procedure   SetminConnection(const Value: integer);
    function    GetDatasetCount: Integer;
    function    GetDatasets(Index: Integer): THCustomDataset;
    procedure   CloseDatasets;
    function    GetPooledConnectionCount: Integer;
  protected
    FPool :     TInterfaceList;
    FConnected: boolean;
    FminConnection: integer;
    FmaxConnection: integer;
    FDatasets : TList;
    // IDBAccess that returned from newDBAccess must have been opened
    function    newDBAccess : IDBAccess; virtual; abstract;
    procedure   doConnect; virtual;
    procedure   doDisconnect; virtual;
    property    OnConnected : TNotifyEvent read FOnConnected write FOnConnected;
    property    OnDisConnected : TNotifyEvent read FOnDisConnected write FOnDisConnected;
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure   AddDataset(Dataset : THCustomDataset);
    procedure   RemoveDataset(Dataset : THCustomDataset);
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    procedure   open;
    procedure   close;
    property    Connected   : boolean read FConnected write SetConnected;

    function    getDBAccess : IDBAccess; virtual;
    procedure   notUseDBAccess(aDBAccess : IDBAccess); virtual;
    // maxConnection : currently not be implemented
    property    maxConnection : integer read FmaxConnection write SetMaxConnection default 0;
    property    minConnection : integer read FminConnection write SetminConnection default 1;
    property    DatasetCount : Integer read GetDatasetCount;
    property    Datasets[Index : Integer] : THCustomDataset read GetDatasets;
    property    PooledConnectionCount : Integer read GetPooledConnectionCount;
  end;

{ TRecInfo }

{   This structure is used to access additional information stored in
  each record buffer which follows the actual record data.

    Buffer: PChar;
   ||
   \/
    --------------------------------------------
    |  Record Data  | Bookmark | Bookmark Flag |
    --------------------------------------------
                    ^-- PRecInfo = Buffer + FRecInfoOfs

  Keep in mind that this is just an example of how the record buffer
  can be used to store additional information besides the actual record
  data.  There is no requirement that TDataSet implementations do it this
  way.

  For the purposes of this demo, the bookmark format used is just an integer
  value.  For an actual implementation the bookmark would most likely be
  a native bookmark type (as with BDE), or a fabricated bookmark for
  data providers which do not natively support bookmarks (this might be
  a variant array of key values for instance).

  The BookmarkFlag is used to determine if the record buffer contains a
  valid bookmark and has special values for when the dataset is positioned
  on the "cracks" at BOF and EOF. }

  PRecInfo = ^TRecInfo;
  TRecInfo = packed record
    Bookmark: Integer;
    BookmarkFlag: TBookmarkFlag;
  end;

{ THCustomStdDataset }

  THCustomStdDataset = class(TDataSet)
  private
    FRecBufSize: Integer;
    FRecInfoOfs: Integer;
    //FCurRec: Integer;
    //FLastBookmark: Integer;
    FBindFieldList : TList;
    FBofCrack,FEofCrack : boolean;
    FGettingNextRecord : Boolean;
  protected
    FData: THDataset;
    { Overriden abstract methods (required) }
    function    AllocRecordBuffer: PChar; override;
    procedure   FreeRecordBuffer(var Buffer: PChar); override;
    procedure   GetBookmarkData(Buffer: PChar; Data: Pointer); override;
    function    GetBookmarkFlag(Buffer: PChar): TBookmarkFlag; override;
    function    GetRecord(Buffer: PChar; GetMode: TGetMode; DoCheck: Boolean): TGetResult; override;
    function    GetRecordSize: Word; override;
    procedure   InternalAddRecord(Buffer: Pointer; Append: Boolean); override;
    procedure   InternalClose; override;
    procedure   InternalDelete; override;
    procedure   InternalFirst; override;
    procedure   InternalGotoBookmark(Bookmark: Pointer); override;
    procedure   InternalHandleException; override;
    procedure   InternalInitFieldDefs; override;
    procedure   InternalInitRecord(Buffer: PChar); override;
    procedure   InternalLast; override;
    procedure   InternalOpen; override;
    procedure   InternalPost; override;
    procedure   InternalSetToRecord(Buffer: PChar); override;
    function    IsCursorOpen: Boolean; override;
    procedure   SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag); override;
    procedure   SetBookmarkData(Buffer: PChar; Data: Pointer); override;
    procedure   SetFieldData(Field: TField; Buffer: Pointer); override;
  protected
    { Additional overrides (optional) }
    function    GetRecordCount: Integer; override;
    function    GetRecNo: Integer; override;
    procedure   SetRecNo(Value: Integer); override;
    procedure   SetData(const Value: THDataset); virtual;
    property    Data : THDataset read FData write SetData;
    function    GetCanModify: Boolean; override;
    procedure   DoOnDataDestroy(sender:TObject); virtual;
  public
    function    GetFieldData(Field: TField; Buffer: Pointer): Boolean; override;
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;  override;
    function    IsSequenced: Boolean; override;
    function    Done : Boolean;
    function    CurrentRecordCount : Integer;
  published
    property    Active;
  end;

  THStdDataset = class(THCustomStdDataset)
  public
    property    Data;
    // standard properties and events
    property    Active;
  published
    property    AutoCalcFields;
    property    BeforeOpen;
    property    AfterOpen;
    property    BeforeClose;
    property    AfterClose;
    property    BeforeScroll;
    property    AfterScroll;
    property    OnCalcFields;
  end;

  TDoneReadingEvent = procedure (sender : THCustomDataset; var finished:boolean) of object;

  THDBAggregateField = class(TCollectionItem)
  private
    FAvailable: Boolean;
    FFieldName: string;
    FAggregateField: THBasicField;
    FAggregateType: THAggregateType;
    procedure   SetAggregateField(const Value: THBasicField);
  protected

  public
    procedure   Assign(Source: TPersistent); override;
    property    Available : Boolean read FAvailable;
    function    AsInteger : Integer;
    function    AsFloat : Double;
    function    AsCurrency : Currency;
    function    AsString : string;
    //function    Value : Variant;
    property    AggregateField : THBasicField read FAggregateField write SetAggregateField;
  published
    property    FieldName : string read FFieldName write FFieldName;
    property    AggregateType : THAggregateType read FAggregateType write FAggregateType;
  end;

  THCustomDataset = class(THCustomStdDataset)
  private
    FDatabase:  THDatabase;
    FDataRef : IUnknown;
    FRowsPerReading: integer;
    FMessageText: string;
    FOnDoneReading: TDoneReadingEvent;
    FAggregateFields: TCollection;
    //FSavedDBAccess : IDBAccess;
    function    GetMaxRows: integer;
    procedure   SetMaxRows(const Value: integer);
    procedure   SetDatabase(const Value: THDatabase);
    procedure   SetAggregateFields(const Value: TCollection);
    function    GetAggregateFieldsSettings: string;
    procedure   SetAggregateFieldsSettings(const Value: string);
  protected
    procedure   RaiseInvalidDatabase;
    function    ValidDatabase(const Value: THDatabase) : Boolean; virtual;
    procedure   DoAfterReadAll(sender : TObject); virtual;
    function    createHDataset : THDataset; virtual;
    procedure   InternalOpen; override;
    procedure   InternalClose; override;
    procedure   CloseDBAccess; dynamic;
    function    getDBAccess : IDBAccess;
    procedure   internalExec; virtual; abstract;
    procedure   doExec;
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
    property    OnDoneReading : TDoneReadingEvent read FOnDoneReading write FOnDoneReading;
    // ExternalExec execute a request, then return the IDBAccess for other object's usa
    function    ExternalExec : IDBAccess; virtual;
    procedure   BindAggregateFields;
    procedure   UnBindAggregateFields;
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    property    MessageText : string read FMessageText;
    procedure   Exec;
    function    AggregateFieldCount : Integer;
    function    AggregateField(Index : Integer): THDBAggregateField; overload;
    function    AggregateField(const FieldName : string; AggregateType : THAggregateType): THDBAggregateField; overload;
    property    AggregateFieldsSettings :  string read GetAggregateFieldsSettings write SetAggregateFieldsSettings;
  published
    property    Database : THDatabase read FDatabase write SetDatabase;
    property    MaxRows : integer read GetMaxRows Write SetMaxRows;
    property    RowsPerReading : integer read FRowsPerReading write FRowsPerReading default 20;
    property    AggregateFields : TCollection read FAggregateFields write SetAggregateFields;
    // standard properties and events
    property    Active;
    property    AutoCalcFields;
    property    BeforeOpen;
    property    AfterOpen;
    property    BeforeClose;
    property    AfterClose;
    property    BeforeScroll;
    property    AfterScroll;
    property    OnCalcFields;
  end;

  THQuery = class(THCustomDataset)
  private
    FSQL: TStrings;
    procedure   SetSQL(const Value: TStrings);
    procedure   SQLChanged(Sender : TObject);
  protected
    procedure   internalExec;  override;
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
  published
    property    SQL : TStrings read FSQL write SetSQL;
    property    OnDoneReading;
  end;

  THRPCParam = class(TCollectionItem)
  private
    FRawType: integer;
    FSize: integer;
    FName: string;
    FDataType: TDBFieldType;
    FMode: TDBParamMode;
    FValue: Variant;
    function GetAsCurrency: currency;
    function GetAsDateTime: TDateTime;
    function GetAsFloat: double;
    function GetAsInteger: integer;
    function GetAsString: string;
    procedure SetAsCurrency(const Value: currency);
    procedure SetAsDateTime(const Value: TDateTime);
    procedure SetAsFloat(const Value: double);
    procedure SetAsInteger(const Value: integer);
    procedure SetAsString(const Value: string);
  protected
    function  GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
    property  AsInteger : integer read GetAsInteger Write SetAsInteger;
    property  AsFloat : double read GetAsFloat Write SetAsFloat;
    property  AsCurrency : currency read GetAsCurrency Write SetAsCurrency;
    property  AsDateTime : TDateTime read GetAsDateTime Write SetAsDateTime;
    property  AsString : string read GetAsString Write SetAsString;
  published
    property  Name: string read FName write FName;
    property  DataType: TDBFieldType read FDataType write FDataType;
    property  Mode : TDBParamMode read FMode write FMode;
    property  Size : integer read FSize write FSize;
    property  Value: Variant read FValue write FValue;
    property  RawType : integer read FRawType write FRawType;
  end;

  THRPCParams = class(TOwnedCollection)
  private
    function    GetItems(index: integer): THRPCParam;
  public
    constructor Create(AOwner: TPersistent);
    property    Items[index:integer] : THRPCParam read GetItems; default;
    function    Add : THRPCParam; overload;
    function    Add(const aname:string) : THRPCParam; overload;
    function    paramByName(const aname:string):THRPCParam;
  end;

procedure initRPCParams(DBAccess:IDBAccess; Params:THRPCParams);

function  getOutput(DBAccess:IDBAccess;index:integer; fieldDef : TDBFieldDef):Variant;

procedure ReadOutputs(acs: IDBAccess; Params:THRPCParams);

type
  THReturnValue = class
  private
    FValue: integer;
  published
    property  Value : integer read FValue;
  end;

  THMessage = class
  private
    FText: string;
  public
    property  Text : string read FText;
  end;

  TResponseHandlerEventType = (retOpen,retClose);
  TResponseHandlerEvent = class(TObjectEvent)
  public
    EventType : TResponseHandlerEventType;
  end;

  THCustomResponseHandler = class(Tcomponent,IListener)
  private
    FDBAccess:  IDBAccess;
    FMaxRows:   integer;
    FActive:    boolean;
    procedure   SetDBAccess(const Value: IDBAccess);
    procedure   SetActive(const Value: boolean);
    function    GetDataset(index: integer): THDataset;
  protected
    FResponses : TObjectList;
    FDatasets : TList;
    //FDatasetIntfs : TInterfaceList;
    FListeners : TListenerSupport;
    procedure   Notify(Sender : TObject; Event : TObjectEvent);
    procedure   beforeOpen; virtual;
    procedure   readResponses; virtual;
    property    Active : boolean read FActive write SetActive;
    procedure   DoOpen; virtual;
    procedure   DoClose;
    procedure   TrigerEvent(EventType : TResponseHandlerEventType);
    procedure   DoFinish; virtual;
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    procedure   Open;
    procedure   Close;
    property    DBAccess : IDBAccess read FDBAccess write SetDBAccess;
    // set MaxRows only effect the following THDataset
    property    MaxRows : integer read FMaxRows write FMaxRows default 0;
    property    Responses : TObjectList read FResponses;
    property    Datasets : TList read FDatasets;
    property    Dataset[index:integer] : THDataset read GetDataset; default;
    procedure   addListener(Listener : IListener);
    procedure   removeListener(Listener : IListener);
  end;

  THResponseHandler = class(THCustomResponseHandler)
  private
    FRequestObject: THCustomDataset;
    procedure   SetRequestObject(const Value: THCustomDataset);
  protected
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure   beforeOpen; override;
    procedure   DoFinish; override;
  public

  published
    property    RequestObject : THCustomDataset read FRequestObject write SetRequestObject;
    //
    property    Active;
  end;

  THSimpleDataset = class(THStdDataset,IListener)
  private
    FIndex: integer;
    FResponses: THResponseHandler;
    FAutoActive: boolean;
    procedure   SetIndex(const Value: integer);
    procedure   SetResponses(const Value: THResponseHandler);
  protected
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure   Notify(Sender : TObject; Event : TObjectEvent);
    procedure   InternalOpen; override;
    procedure   InternalClose; override;
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
  published
    property    Responses : THResponseHandler read FResponses write SetResponses;
    property    Index : integer read FIndex write SetIndex;
    property    AutoActive : boolean read FAutoActive write FAutoActive;
    //
    property    Active;
  end;

implementation

uses Windows, SysUtils, Forms,LogFile,safeCode, DebugMemory
  {$ifdef VCL60_UP }
  ,Variants
  {$else}

  {$endif}
;

{ This procedure is used to register this component on the component palette }

const
  FieldTypeMappings : array[TDBFieldType] of TFieldType
    = (db.ftInteger,
      db.ftFloat,
      db.ftCurrency,
      db.ftString,
      db.ftDatetime,
      db.ftUnknown,
      db.ftUnknown);


{ THDatabase }

constructor THDatabase.Create(AOwner: TComponent);
begin
  inherited;
  FPool := TInterfaceList.Create;
  FConnected:=false;
  FmaxConnection:=0;
  FminConnection:=1;
  FDatasets := TList.Create;
end;

destructor THDatabase.Destroy;
begin
  close;
  FreeAndNil(FPool);
  FreeAndNil(FDatasets);
  inherited;
end;

procedure THDatabase.open;
begin
  Connected := true;
end;

procedure THDatabase.close;
begin
  Connected := false;
end;

procedure THDatabase.SetConnected(const Value: boolean);
begin
  if FConnected <> Value then
  begin
    if Value then
    begin
      // connect
      doConnect;
      if Assigned(FOnConnected) then
        FOnConnected(self);
      checkTrue(FConnected,SCannotConnectToServer);
    end else
    begin
      doDisconnect;
      if Assigned(FOnDisConnected) then
        FOnDisConnected(self);
    end;
  end;
end;

procedure THDatabase.doConnect;
var
  acs : IDBAccess;
begin
  acs :=newDBAccess;
  FConnected:= acs<>nil;
  if FConnected then
  begin
    writeLog('pool first',lcHDatabase);
    notUseDBAccess(acs);
  end else
  begin
    writeLog('not connected',lcHDatabase);
  end;
end;

procedure THDatabase.doDisconnect;
begin
  // 关闭所有的数据集
  CloseDatasets;

  // 关闭缓冲的连接
  FPool.Lock;
  try
    FPool.clear;
  finally
    FPool.UnLock;
  end;

  FConnected:=false;
end;

function THDatabase.getDBAccess: IDBAccess;
begin
  open;
  FPool.Lock;
  try
    if FPool.count>0 then
    begin
      result := FPool[0] as IDBAccess;
      FPool.Delete(0);
      writeLog('use pooled dbaccess',lcHDatabase);
    end else
    begin
      result := newDBAccess;
      writeLog('use new dbaccess',lcHDatabase);
    end;
  finally
    FPool.UnLock;
  end;
end;

procedure THDatabase.notUseDBAccess(aDBAccess: IDBAccess);
begin
  //writeLog('start pool',lcHDatabase);
  FPool.Lock;
  //writeLog('start pool2',lcHDatabase);
  try
    if FPool.count<FminConnection then
    begin
      FPool.add(aDBAccess as IUnknown);
      writeLog('pool dbaccess',lcHDatabase);
    end else
    begin
      writeLog('not pool dbaccess',lcHDatabase);
    end;
  finally
    FPool.UnLock;
  end;
end;

procedure THDatabase.SetMaxConnection(const Value: integer);
begin
  if Value>=0 then
    FmaxConnection := Value;
end;

procedure THDatabase.SetminConnection(const Value: integer);
begin
  if value>=0 then
    FminConnection := Value;
end;

function THDatabase.GetDatasetCount: Integer;
begin
  Result := FDatasets.Count;
end;

function THDatabase.GetDatasets(Index: Integer): THCustomDataset;
begin
  Result := THCustomDataset(FDatasets[Index]);
end;

procedure THDatabase.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation=opRemove) and (AComponent is TDataset) and (FDatasets<>nil) then
    FDatasets.Remove(AComponent);
end;

procedure THDatabase.AddDataset(Dataset: THCustomDataset);
begin
  if (Dataset<>nil) and (FDatasets<>nil) then
  begin
    FDatasets.Add(Dataset);
    Dataset.FreeNotification(Self);
  end;
end;

procedure THDatabase.RemoveDataset(Dataset: THCustomDataset);
begin
  if FDatasets<>nil then
    FDatasets.Remove(Dataset);
end;

procedure THDatabase.CloseDatasets;
var
  I : Integer;
begin
  if FDatasets<>nil then
    for I:=0 to FDatasets.Count-1 do
    begin
      TDataset(FDatasets[I]).Active := False;
    end;
end;

function THDatabase.GetPooledConnectionCount: Integer;
begin
  Result := FPool.Count;
end;

{ THCustomStdDataset }

constructor THCustomStdDataset.Create(AOwner: TComponent);
begin
  inherited;
  FBindFieldList := TList.create;
  FData := nil;
end;

destructor THCustomStdDataset.Destroy;
begin
  {must in this order}
  if FData<>nil then FData.OnDestroy:=nil;
  inherited;
  FBindFieldList.free;
end;

{ This method is called by TDataSet.Open and also when FieldDefs need to
  be updated (usually by the DataSet designer).  Everything which is
  allocated or initialized in this method should also be freed or
  uninitialized in the InternalClose method. }

procedure THCustomStdDataset.InternalOpen;
begin
  if Data=nil then
    DatabaseError('No Data!');

  FBindFieldList.clear;
  {FData.first;
  FBofCrack:=true;
  FEofCrack:=false;}
  InternalFirst;
  //FLastBookmark := FData.Count;

  { Initialize our internal position.
    We use -1 to indicate the "crack" before the first record. }
  //FCurRec := -1;

  { Initialize an offset value to find the TRecInfo in each buffer }
  FRecInfoOfs := FData.TextDB.RowSize;

  { Calculate the size of the record buffers.
    Note: This is NOT the same as the RecordSize property which
    only gets the size of the data in the record buffer }
  FRecBufSize := FRecInfoOfs + SizeOf(TRecInfo);

  { Tell TDataSet how big our Bookmarks are (REQUIRED) }
  BookmarkSize := SizeOf(Integer);

  { Initialize the FieldDefs }
  InternalInitFieldDefs;

  { Create TField components when no persistent fields have been created }
  if DefaultFields then CreateFields;

  { Bind the TField components to the physical fields }
  BindFields(True);
end;

procedure THCustomStdDataset.InternalClose;
begin
  (*
  { Write any edits to disk and free the managing string list }
  if FSaveChanges then FData.SaveToFile(FileName);
  FData.Free;
  *)
  FBindFieldList.clear;
  //FData := nil;

  { Destroy the TField components if no persistent fields }
  if DefaultFields then DestroyFields;

  (*
  { Reset these internal flags }
  FLastBookmark := 0;
  FCurRec := -1;
  *)
end;

{ This property is used while opening the dataset.
  It indicates if data is available even though the
  current state is still dsInActive. }

function THCustomStdDataset.IsCursorOpen: Boolean;
begin
  Result := Assigned(FData) and FData.Available;
end;

{ For this simple example we just create one FieldDef, but a more complete
  TDataSet implementation would create multiple FieldDefs based on the
  actual data. }

procedure THCustomStdDataset.InternalInitFieldDefs;
var
  i,j : integer;
  field : THBasicField;
  fieldType : TFieldType;
  fieldSize : integer;
  aFieldName : string;
begin
  FieldDefs.Clear;
  j:=0;
  FBindFieldList.clear;
  for i:=0 to FData.FieldCount-1 do
  begin
    field:=FData.Fields[i];
    fieldType:=FieldTypeMappings[field.fieldDef.FieldType];
    if (fieldType<>db.ftUnknown) and (field is THField) then
    begin
      {WriteLog(format('name : %s, htype:%d, fieldtype:%d, size:%d',
        [field.FieldName,ord(field.fieldDef.FieldType),ord(fieldType),field.fieldSize]),
        lcDataset);}
      if fieldType=db.ftString then
        fieldSize := field.fieldSize else
        fieldSize := 0;
      aFieldName := field.FieldName;
      if aFieldName='' then aFieldName:=format('_f[%d]',[i]);
      FieldDefs.Add(aFieldName,fieldType,fieldSize,false);
      inc(j);
      FBindFieldList.add(Field);
    end;
  end;
  if FData.TextDB.FieldCount<>j then DatabaseError('Implement Error!');
end;

{ This is the exception handler which is called if an exception is raised
  while the component is being stream in or streamed out.  In most cases this
  should be implemented useing the application exception handler as follows. }

procedure THCustomStdDataset.InternalHandleException;
begin
  {if FData.DBAccess<>nil then
  begin
    WriteLog(FData.DBAccess.MessageText,lcDataset);
  end;}
  Application.HandleException(Self);
end;

{ Bookmarks }
{ ========= }

{ In this sample the bookmarks are stored in the Object property of the
  TStringList holding the data.  Positioning to a bookmark just requires
  finding the offset of the bookmark in the TStrings.Objects and using that
  value as the new current record pointer. }

procedure THCustomStdDataset.InternalGotoBookmark(Bookmark: Pointer);
begin
  FData.bookmark:=PInteger(Bookmark)^;
end;

{ This function does the same thing as InternalGotoBookmark, but it takes
  a record buffer as a parameter instead }

procedure THCustomStdDataset.InternalSetToRecord(Buffer: PChar);
begin
  InternalGotoBookmark(@PRecInfo(Buffer + FRecInfoOfs).Bookmark);
end;

{ Bookmark flags are used to indicate if a particular record is the first
  or last record in the dataset.  This is necessary for "crack" handling.
  If the bookmark flag is bfBOF or bfEOF then the bookmark is not actually
  used; InternalFirst, or InternalLast are called instead by TDataSet. }

function THCustomStdDataset.GetBookmarkFlag(Buffer: PChar): TBookmarkFlag;
begin
  Result := PRecInfo(Buffer + FRecInfoOfs).BookmarkFlag;
end;

procedure THCustomStdDataset.SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag);
begin
  PRecInfo(Buffer + FRecInfoOfs).BookmarkFlag := Value;
end;

{ These methods provide a way to read and write bookmark data into the
  record buffer without actually repositioning the current record }

procedure THCustomStdDataset.GetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  PInteger(Data)^ := PRecInfo(Buffer + FRecInfoOfs).Bookmark;
end;

procedure THCustomStdDataset.SetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  PRecInfo(Buffer + FRecInfoOfs).Bookmark := PInteger(Data)^;
end;

{ Record / Field Access }
{ ===================== }

{ This method returns the size of just the data in the record buffer.
  Do not confuse this with RecBufSize which also includes any additonal
  structures stored in the record buffer (such as TRecInfo). }

function THCustomStdDataset.GetRecordSize: Word;
begin
  Result := FRecInfoOfs;
end;

{ TDataSet calls this method to allocate the record buffer.  Here we use
  FRecBufSize which is equal to the size of the data plus the size of the
  TRecInfo structure. }

function THCustomStdDataset.AllocRecordBuffer: PChar;
begin
  //GetMem(Result, FRecBufSize);
  Result := AllocMem(FRecBufSize);
  //AddNew(Result);
  //writeLog('AllocRecordBuffer',lcDebug);
end;

{ Again, TDataSet calls this method to free the record buffer.
  Note: Make sure the value of FRecBufSize does not change before all
  allocated buffers are freed. }

procedure THCustomStdDataset.FreeRecordBuffer(var Buffer: PChar);
begin
  //RemoveOld(Buffer);
  FreeMem(Buffer, FRecBufSize);
  //FreeMem(Buffer);
end;

{ This multi-purpose function does 3 jobs.  It retrieves data for either
  the current, the prior, or the next record.  It must return the status
  (TGetResult), and raise an exception if DoCheck is True. }

function THCustomStdDataset.GetRecord(Buffer: PChar; GetMode: TGetMode;
  DoCheck: Boolean): TGetResult;
begin
  if FData.empty then
    Result := grEOF else
  begin
    Result := grOK;
    case GetMode of
      gmNext:
        {if FCurRec >= RecordCount - 1  then
          Result := grEOF else
          Inc(FCurRec);}
        if FBofCrack then
          FBofCrack := false else
          begin
            // 使用FGettingNextRecord标志避免重入(被间接地递归调用)
            if FGettingNextRecord then
            begin
              Result := grEof;
              WriteLog('Re-Enter THCustomStdDataset.GetRecord',lcDebug);
            end
            else
            begin
              FGettingNextRecord := True;
              try
                FData.next;
                if FData.eof then result := grEof
              finally
                FGettingNextRecord := False;
              end;
            end;
          end;
      gmPrior:
        {if FCurRec <= 0 then
          Result := grBOF else
          Dec(FCurRec);}
        if FEofCrack then
          FEofCrack := false else
          begin
            FData.prior;
            if FData.bof then result := grbof;
          end;
      gmCurrent:
        if FBofCrack or FEofCrack then
          Result := grError;
        {if (FCurRec < 0) or (FCurRec >= RecordCount) then
          Result := grError;}
    end;
    {if GetMode<>gmCurrent then
      if FData.eof then
        result := grEof
      else if FData.bof then
        result := grbof;}
    if Result = grOK then
    begin
      (*StrLCopy(Buffer, PChar(FData[FCurRec]), MaxStrLen);*)
      //FData.Cursor:=FCurRec;
      //WriteLog('GetRecord',lcDebug);
      Move(Pchar(FData.TextDB.CurRow)^,Buffer^,FRecInfoOfs);
      with PRecInfo(Buffer + FRecInfoOfs)^ do
      begin
        BookmarkFlag := bfCurrent;
        //Bookmark := FData.bookmark;
        Bookmark := FData.RecNo;
      end;
    end else
      if (Result = grError) and DoCheck then DatabaseError('No Records');
  end;
end;

{ This routine is called to initialize a record buffer.  In this sample,
  we fill the buffer with zero values, but we might have code to initialize
  default values or do other things as well. }

procedure THCustomStdDataset.InternalInitRecord(Buffer: PChar);
begin
  FillChar(Buffer^, RecordSize, 0);
end;

{ Here we copy the data from the record buffer into a field's buffer.
  This function, and SetFieldData, are more complex when supporting
  calculated fields, filters, and other more advanced features.
  See TBDEDataSet for a more complete example. }

function THCustomStdDataset.GetFieldData(Field: TField; Buffer: Pointer): Boolean;
var
  p : Pchar;
  i : integer;
  size : integer;
  cur : Currency;
  f : double;
  hField : THField;
  //txtField : TTxtField;
begin
  p:=ActiveBuffer;
  if FData.empty then
  begin
    result := false;
    exit;
  end;

  {if PRecInfo(p+ FRecInfoOfs)^.BookmarkFlag in [bfBOF, bfEOF] then
  begin
    WriteLog('GetFieldData Bof/Eof Crack',lcDataset);
    result := false;
    exit;
  end;}
  {if Buffer=nil then
    WriteLog('Buffer=nil',lcDebug);}
  (*StrLCopy(Buffer, ActiveBuffer, Field.Size);*)
  i:=Field.FieldNo;
  hField := THField(FBindFieldList[i-1]);
  inc(p,hField.TextField.Offset);
  //move(p^, Buffer^, Field.Size);
  size := hField.fieldSize;
  case Field.DataType of
    db.ftString : StrLCopy(pchar(Buffer), p, Size);
    db.ftCurrency : begin
                      move(p^,cur,sizeof(currency));
                      f:=cur;
                      move(f, Buffer^, Size);
                    end;
    db.ftDateTime : begin
                      Double(Buffer^) := TimeStampToMSecs(DateTimeToTimeStamp(TDateTime(Pointer(p)^)));
                    end;
  else move(p^, Buffer^, Size);
  end;

  inc(p,size);
  Result := PByte(p)^=0;
  {if result then
    writeLog(hField.fieldName+' isNull',lcDebug);}
end;

procedure THCustomStdDataset.SetFieldData(Field: TField; Buffer: Pointer);
{var
  p : Pchar;}
begin
  (*StrLCopy(ActiveBuffer, Buffer, Field.Size);*)
  {
  writeLog('Set : '+Field.fieldName+' '+IntToStr(Field.FieldNo),lcDebug);
  p:=ActiveBuffer;
  inc(p,FData.Fields[Field.FieldNo-1].Offset);
  move(Buffer^, p^,Field.Size);
  DataEvent(deFieldChange, Longint(Field)); }
end;

{ Record Navigation / Editing }
{ =========================== }

{ This method is called by TDataSet.First.  Crack behavior is required.
  That is we must position to a special place *before* the first record.
  Otherwise, we will actually end up on the second record after Resync
  is called. }

procedure THCustomStdDataset.InternalFirst;
begin
  //FCurRec := -1;
  FData.first;
  FBofCrack:=true;
  FEofCrack:=false;
end;

{ Again, we position to the crack *after* the last record here. }

procedure THCustomStdDataset.InternalLast;
begin
  //FCurRec := FData.Count;
  FData.last;
  FBofCrack:=false;
  FEofCrack:=true;
end;

{ This method is called by TDataSet.Post.  Most implmentations would write
  the changes directly to the associated datasource, but here we simply set
  a flag to write the changes when we close the dateset. }

procedure THCustomStdDataset.InternalPost;
begin

end;

{ This method is similar to InternalPost above, but the operation is always
  an insert or append and takes a pointer to a record buffer as well. }

procedure THCustomStdDataset.InternalAddRecord(Buffer: Pointer; Append: Boolean);
begin

end;

{ This method is called by TDataSet.Delete to delete the current record }

procedure THCustomStdDataset.InternalDelete;
begin

end;

{ Optional Methods }
{ ================ }

{ The following methods are optional.  When provided they will allow the
  DBGrid and other data aware controls to track the current cursor postion
  relative to the number of records in the dataset.  Because we are dealing
  with a small, static data store (a stringlist), these are very easy to
  implement.  However, for many data sources (SQL servers), the concept of
  record numbers and record counts do not really apply. }
(*
function THCustomStdDataset.GetRecordCount: Longint;
begin
  Result := FData.Count;
end;

function THCustomStdDataset.GetRecNo: Longint;
begin
  UpdateCursorPos;
  if (FCurRec = -1) and (RecordCount > 0) then
    Result := 1 else
    Result := FCurRec + 1;
end;

procedure THCustomStdDataset.SetRecNo(Value: Integer);
begin
  if (Value >= 0) and (Value < FData.Count) then
  begin
    FCurRec := Value - 1;
    Resync([]);
  end;
end;
*)
function THCustomStdDataset.GetCanModify: Boolean;
begin
  result := false;
end;

function THCustomStdDataset.IsSequenced: Boolean;
begin
  //Result := False;
  //Result := (FData<>nil) and FData.Done;
  Result := (FData<>nil);
end;

function THCustomStdDataset.GetRecordCount: Integer;
begin
  if IsSequenced then
    if FData.Done then
      Result := FData.CurrentRecordCount
    else
      Result := FData.CurrentRecordCount+1
  else
    Result := -1;
end;

function THCustomStdDataset.GetRecNo: Integer;
begin
  if IsSequenced then
  begin
    UpdateCursorPos;
    if FData.RecNo<0 then
      Result := 1 else
      Result := FData.RecNo + 1;
  end else
    Result := inherited GetRecNo;
end;

procedure THCustomStdDataset.SetRecNo(Value: Integer);
begin
  if IsSequenced then
  begin
    FData.RecNo := Value-1;
    Resync([]);
  end else
    inherited;
end;

function THCustomStdDataset.CurrentRecordCount: Integer;
begin
  if Data<>nil then
    Result := Data.CurrentRecordCount else
    Result := 0;
end;

function THCustomStdDataset.Done: Boolean;
begin
  if Data<>nil then
    Result := Data.Done else
    Result := True;
end;

{ THCustomDataset }

constructor THCustomDataset.Create(AOwner: TComponent);
begin
  inherited;
  FData := createHDataset;
  FDataRef := FData; // save FData
  FRowsPerReading := 20;
  FData.AfterDoneReading := DoAfterReadAll;
  FAggregateFields := TOwnedCollection.Create(Self,THDBAggregateField);
  FDatabase := nil;
  //FSavedDBAccess := nil;
end;

function THCustomDataset.createHDataset: THDataset;
begin
  result := THDataset.Create(nil,true);
end;

destructor THCustomDataset.Destroy;
begin
  //FData.OnDestroy:=nil;
  Database := nil;
  inherited;
  //FSavedDBAccess := nil;
  FDataRef := nil; // free FData
  FreeAndNil(FAggregateFields);
end;

procedure THCustomDataset.CloseDBAccess;
var
  Temp : IDBAccess;
begin
  if FData.DBAccess<>nil then
  begin
    // 使用Temp保存需要关闭的数据源连接接口实例。
    Temp := FData.DBAccess;
    // 停止对这个数据源连接接口实例的侦听
    FData.DBAccess:=nil;
    // 关闭这个数据源连接接口实例。
    Temp.finished;
    if FDatabase<>nil then
      FDatabase.notUseDBAccess(Temp);
  end;
end;

procedure THCustomDataset.DoAfterReadAll(sender: TObject);
var
  doFinished : boolean;
begin
  doFinished := true;
  if assigned(OnDoneReading) then
    OnDoneReading(self,doFinished);
  if doFinished then
    CloseDBAccess;
end;

function THCustomDataset.getDBAccess: IDBAccess;
begin
  {if FSavedDBAccess = nil then
  begin
    CheckObject(FDatabase,'No Database');
    result := FDatabase.getDBAccess;
    FSavedDBAccess := result;
    CheckTrue(result<>nil,'Cannot get DBAccess from Database');
  end else
    result := FSavedDBAccess;}
  CheckObject(FDatabase,SNoDatabase);
  result := FDatabase.getDBAccess;
  CheckTrue(result<>nil,SCannotGetConnection);
end;

procedure THCustomDataset.InternalClose;
begin
  UnBindAggregateFields;
  FData.Close;
  CloseDBAccess;
  inherited;
end;

procedure THCustomDataset.InternalOpen;
begin
  doExec;
  //FData.Close;
  FData.link2Response(true);
  FData.addAllExistFields;
  FData.createFields;
  BindAggregateFields;
  FData.Open(FRowsPerReading);
  inherited;
end;

function THCustomDataset.GetMaxRows: integer;
begin
  result := FData.maxRows;
end;

procedure THCustomDataset.SetMaxRows(const Value: integer);
begin
  FData.maxRows:=value;
end;

procedure THCustomDataset.doExec;
begin
  FMessageText:='';
  try
    internalExec;
  except
    if FData.DBAccess<>nil then
    begin
      FMessageText:=FData.DBAccess.MessageText;
      CloseDBAccess;
    end;
    raise;
  end;
end;

procedure THCustomDataset.SetDatabase(const Value: THDatabase);
begin
  if FDatabase <> Value then
  begin
    if Value<>nil then
    begin
      if not ValidDatabase(Value) then
        RaiseInvalidDatabase;
    end;
    if FDatabase<>nil then
      FDatabase.RemoveDataset(Self);
    FDatabase := Value;
    if FDatabase<>nil then
      FDatabase.AddDataset(self);
      //FDatabase.FreeNotification(self);
  end;
end;

procedure THCustomDataset.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent=FDatabase) and (Operation=opRemove) then
    Database:=nil;
end;

procedure THCustomDataset.Exec;
begin
  doExec;
  CloseDBAccess;
end;

function THCustomDataset.ExternalExec: IDBAccess;
begin
  doExec;
  result := FData.DBAccess;
  //FData.DBAccess:=nil;
end;

function  THCustomDataset.ValidDatabase(const Value: THDatabase) : Boolean;
begin
  Result := True;
end;

procedure THCustomDataset.RaiseInvalidDatabase;
begin
  raise EInvalidDatabase.Create(SInvalidDatabase);
end;

procedure THCustomDataset.SetAggregateFields(const Value: TCollection);
begin
  FAggregateFields.Assign(Value);
end;

procedure THCustomDataset.BindAggregateFields;
var
  I : Integer;
begin
  FData.ClearAggregateFields;
  for I:=0 to AggregateFields.Count-1 do
    with THDBAggregateField(AggregateFields.Items[I]) do
    begin
      FData.NewAggregateFieldDef(FieldName,AggregateType);
    end;
  FData.CreateAggregateFields;
  for I:=0 to AggregateFields.Count-1 do
    with THDBAggregateField(AggregateFields.Items[I]) do
    begin
      AggregateField := FData.AggregateFields[I];
    end;
end;

procedure THCustomDataset.UnBindAggregateFields;
var
  I : Integer;
begin
  for I:=0 to AggregateFields.Count-1 do
  begin
    THDBAggregateField(AggregateFields.Items[I]).AggregateField:=nil;
  end;
end;

function THCustomDataset.AggregateField(
  Index: Integer): THDBAggregateField;
begin
  Result := THDBAggregateField(AggregateFields.Items[Index]);
end;

function THCustomDataset.AggregateField(
  const FieldName: string; AggregateType : THAggregateType): THDBAggregateField;
var
  I : Integer;
begin
  Result := nil;
  for I:=0 to AggregateFields.Count-1 do
  begin
    if SameText(THDBAggregateField(AggregateFields.Items[I]).FieldName,FieldName)
      and (THDBAggregateField(AggregateFields.Items[I]).AggregateType=AggregateType) then
    begin
      Result := THDBAggregateField(AggregateFields.Items[I]);
      Break;
    end;
  end;
end;

function THCustomDataset.AggregateFieldCount: Integer;
begin
  Result := AggregateFields.Count;
end;

function THCustomDataset.GetAggregateFieldsSettings: string;
var
  I : Integer;
begin
  Result := '';
  for I:=0 to AggregateFields.Count-1 do
  with THDBAggregateField(AggregateFields.Items[I]) do
  begin
    if I>0 then
      Result := Format('%s,%s(%s)',[Result,AggregateNames[AggregateType],FieldName]) else
      Result := Format('%s(%s)',[AggregateNames[AggregateType],FieldName]);
  end;
end;

procedure THCustomDataset.SetAggregateFieldsSettings(const Value: string);
var
  I,Len : Integer;
  StartIndex : Integer;
  WantedChar : Char;
  FieldName : string;
  AggregateName : string;

  procedure AddAggregateField;
  var
    AggregateType : THAggregateType;
    AggregateField : THDBAggregateField;
  begin
    for AggregateType:=atSum to atMin do
    begin
      if SameText(AggregateName,AggregateNames[AggregateType]) then
      begin
        AggregateField := THDBAggregateField(AggregateFields.Add);
        AggregateField.AggregateType := AggregateType;
        AggregateField.FieldName := FieldName;
        Break;
      end;
    end;
  end;

begin
  AggregateFields.Clear;
  Len := Length(Value);
  WantedChar := '(';
  StartIndex := 1;
  for I:=1 to Len do
  begin
    if Value[I]=WantedChar then
    begin
      case WantedChar of
        '(' : begin
                AggregateName := Trim(Copy(Value,StartIndex,I-StartIndex));
                WantedChar := ')';
                StartIndex := I+1;
              end;
        ')' : begin
                FieldName := Trim(Copy(Value,StartIndex,I-StartIndex));
                WantedChar := ',';
                StartIndex := I+1;
                AddAggregateField;
              end;
        ',' : begin
                WantedChar := '(';
                StartIndex := I+1;
              end;
      end;
    end;
  end;
end;

{ THQuery }

constructor THQuery.Create(AOwner: TComponent);
begin
  inherited;
  FSQL := TStringList.create;
  TStringList(FSQL).OnChange := SQLChanged;
end;

destructor THQuery.Destroy;
begin
  TStringList(FSQL).OnChange := nil;
  FreeAndNil(FSQL);
  inherited;
end;

procedure THQuery.internalExec;
begin
  FData.DBAccess := getDBAccess;
  FData.DBAccess.execSQL(sql.Text);
end;

procedure THQuery.SetSQL(const Value: TStrings);
begin
  FSQL.assign(Value);
end;

procedure THQuery.SQLChanged(Sender: TObject);
begin
  Close;
end;

{ THRPCParam }

procedure THRPCParam.Assign(Source: TPersistent);
begin
  if Source is THRPCParam then
  with THRPCParam(Source)  do
  begin
    self.FName:=Name;
    self.FDataType:=DataType;
    self.FMode:=Mode;
    self.FSize:=size;
    self.FValue:=value;
    self.FRawType:=RawType;
  end
  else inherited;
end;

function THRPCParam.GetAsCurrency: currency;
begin
  result := FValue;
end;

function THRPCParam.GetAsDateTime: TDateTime;
begin
  result := FValue;
end;

function THRPCParam.GetAsFloat: double;
begin
  result := FValue;
end;

function THRPCParam.GetAsInteger: integer;
begin
  result := FValue;
end;

function THRPCParam.GetAsString: string;
begin
  result := FValue;
end;

function THRPCParam.GetDisplayName: string;
begin
  if Name<>'' then
    Result := Name else
    Result := ClassName;
end;

procedure THRPCParam.SetAsCurrency(const Value: currency);
begin
  FValue := value;
end;

procedure THRPCParam.SetAsDateTime(const Value: TDateTime);
begin
  FValue := value;
end;

procedure THRPCParam.SetAsFloat(const Value: double);
begin
  FValue := value;
end;

procedure THRPCParam.SetAsInteger(const Value: integer);
begin
  FValue := value;
end;

procedure THRPCParam.SetAsString(const Value: string);
begin
  FValue := value;
end;

{ THRPCParams }

constructor THRPCParams.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner,THRPCParam);
end;

function THRPCParams.GetItems(index: integer): THRPCParam;
begin
  result := THRPCParam(inherited items[index]);
end;

function THRPCParams.Add: THRPCParam;
begin
  result := THRPCParam.Create(self);
end;

function THRPCParams.Add(const aname: string): THRPCParam;
begin
  result := paramByName(aname);
  if result=nil then
  begin
    result := add;
    result.name := aname;
  end;
end;

function THRPCParams.paramByName(const aname: string): THRPCParam;
var
  i : integer;
begin
  for i:=0 to count-1 do
  begin
    result := items[i];
    if CompareText(result.Name,aname)=0 then exit;
  end;
  result := nil;
end;

procedure initRPCParams(DBAccess:IDBAccess; Params:THRPCParams);
var
  n : integer;
  f : double;
  m : currency;
  d : TDateTime;
  s : string;
  i : integer;
  len : integer;
  param : THRPCParam;
  buffer : pointer;
begin
  for i:=0 to Params.count-1 do
  begin
    param := Params[i];
    len := param.size;
    buffer:=nil;
    if not VarIsNull(param.value) then
    case param.DataType of
      ftInteger:  begin
                    n := param.value;
                    buffer := @n;
                  end;
      ftFloat:    begin
                    f := param.value;
                    buffer := @f;
                  end;
      ftCurrency: begin
                    m := param.value;
                    buffer := @m;
                  end;
      ftChar:     begin
                    s := param.value;
                    len := length(s);
                    buffer := pchar(s);
                  end;
      ftDatetime: begin
                    d := param.value;
                    buffer := @d;
                  end;
    else break;
    end;
    DBAccess.setRPCParam(param.Name,param.mode,param.DataType,
      param.Size,len,buffer,param.RawType);
  end;
end;

function  getOutput(DBAccess:IDBAccess;index:integer; fieldDef : TDBFieldDef):Variant;
var
  n : integer;
  f : double;
  m : currency;
  d : TDateTime;
  s : string;
  len : integer;
  buffer : pointer;
begin
  DBAccess.getOutputDef(index,fieldDef);
  result:=null;
  if not DBAccess.outputIsNull(index) then
  begin
    //buffer := nil;
    len := StdDataSize[fieldDef.FieldType];
    case fieldDef.FieldType of
      ftInteger:  buffer := @n;
      ftFloat:    buffer := @f;
      ftCurrency: buffer := @m;
      ftChar:     begin
                    len := fieldDef.FieldSize;
                    setLength(s,len);
                    buffer := pchar(s);
                  end;
      ftDatetime: buffer := @d;
    else exit;
    end;
    {len :=} DBAccess.readOutput2(fieldDef,buffer,len);
    case fieldDef.FieldType of
      ftInteger:  result := n;
      ftFloat:    result := f;
      ftCurrency: result := m;
      ftChar:     result := string(pchar(s));
      ftDatetime: result := d;
    end;
  end;
end;

procedure ReadOutputs(acs: IDBAccess; Params:THRPCParams);
var
  i : integer;
  count : integer;
  fieldDef : TDBFieldDef;
  value : variant;
  param : THRPCParam;
begin
  count := acs.outputCount;
  fieldDef := TDBFieldDef.create;
  try
    for i:=1 to count do
    begin
      value := getOutput(acs,i,fieldDef);
      param := Params.add(fieldDef.fieldName);
      if param.Mode=pmInput then
        param.Mode:=pmInputOutput else
        param.Mode:=pmOutput;
      param.value := value;  
    end;
  finally
    fieldDef.free;
  end;
end;

{ THCustomResponseHandler }

constructor THCustomResponseHandler.Create(AOwner : TComponent);
begin
  inherited ;
  FDBAccess:=nil;
  FResponses := TObjectList.create;
  FDatasets := TList.create;
  FListeners := TListenerSupport.create(self);
end;

destructor THCustomResponseHandler.Destroy;
begin
  FreeAndNil(FDatasets);
  FreeAndNil(FResponses);
  FreeAndNil(FListeners);
  DBAccess:=nil;
  inherited;
end;

procedure THCustomResponseHandler.Notify(Sender: TObject; Event: TObjectEvent);
begin
  //
end;

procedure THCustomResponseHandler.Open;
begin
  Active := true;
end;

procedure THCustomResponseHandler.beforeOpen;
begin
  Close;
end;

procedure THCustomResponseHandler.readResponses;
var
  rt : TDBResponseType;
  dataset : THDataset;
  msgObj : THMessage;
  returnObj : THReturnValue;
  outputObj : THRPCParams;
begin
  rt := FDBAccess.curResponseType;
  if rt=rtNone then
    rt := FDBAccess.nextResponse;
  try
    try
      while rt<>rtNone do
      begin
        case rt of
          rtDataset:     begin
                           dataset := THDataset.Create(FDBAccess,true);
                           dataset.maxRows:=FMaxRows;
                           FResponses.add(dataset);
                           FDatasets.add(dataset);
                           IUnknown(dataset)._AddRef; // for FResponses
                           try
                             dataset.Open(-1);
                           finally
                             dataset.DBAccess:=nil;
                           end;
                         end;
          rtReturnValue: begin
                           returnObj := THReturnValue.create;
                           returnObj.FValue := FDBAccess.returnValue;
                           FResponses.add(returnObj);
                         end;
          rtOutputValue: begin
                           outputObj := THRPCParams.create(nil);
                           FResponses.add(outputObj);
                           ReadOutputs(FDBAccess,outputObj);
                         end;
          rtMessage:     begin
                           msgObj:=THMessage.create;
                           FResponses.add(msgObj);
                           msgObj.FText := FDBAccess.MessageText;
                         end;
        end;
      rt := FDBAccess.nextResponse;
      end;
    finally
      DoFinish;
    end;
  except
    close;
    raise;
  end;
end;

procedure THCustomResponseHandler.SetDBAccess(const Value: IDBAccess);
begin
  if FDBAccess <> Value then
  begin
    if FDBAccess<>nil then
      FDBAccess.removeListener(self);
    FDBAccess := Value;
    if FDBAccess<>nil then
      FDBAccess.addListener(self);
  end;
end;

procedure THCustomStdDataset.DoOnDataDestroy(sender: TObject);
begin
  FData:=nil;
end;

procedure THCustomStdDataset.SetData(const Value: THDataset);
begin
  if FData<>nil then
    FData.OnDestroy:=nil;
  FData := Value;
  if FData<>nil then
    FData.OnDestroy:=DoOnDataDestroy;
end;

procedure THCustomResponseHandler.Close;
begin
  active := false;
end;

procedure THCustomResponseHandler.SetActive(const Value: boolean);
begin
  if FActive <> Value then
  begin
    if Value then
      DoOpen else
      DoClose;
  end;
end;

procedure THCustomResponseHandler.DoClose;
begin
  TrigerEvent(retClose);
  FResponses.clear;
  FDatasets.clear;
  FActive:=false;
end;

procedure THCustomResponseHandler.DoOpen;
begin
  beforeOpen;
  readResponses;
  FActive := true;
  TrigerEvent(retOpen);
end;

procedure THCustomResponseHandler.TrigerEvent(
  EventType: TResponseHandlerEventType);
var
  event : TResponseHandlerEvent;
begin
  event := TResponseHandlerEvent.create;
  event.EventType:=EventType;
  FListeners.notifyListeners2(event);
end;

procedure THCustomResponseHandler.addListener(Listener: IListener);
begin
  if FListeners<>nil then FListeners.addListener(Listener);
end;

procedure THCustomResponseHandler.removeListener(Listener: IListener);
begin
  if FListeners<>nil then FListeners.removeListener(Listener);
end;

procedure THCustomResponseHandler.DoFinish;
begin
  FDBAccess.finished;
end;

function THCustomResponseHandler.GetDataset(index: integer): THDataset;
begin
  result := THDataset(FDatasets[index]);
end;

{ THResponseHandler }

procedure THResponseHandler.beforeOpen;
begin
  inherited;
  checkObject(FRequestObject,'No RequestObject');
  DBAccess := FRequestObject.ExternalExec;
  checkTrue(FDBAccess<>nil,'ExternalExec Error');
end;

procedure THResponseHandler.DoFinish;
begin
  inherited;
  checkObject(FRequestObject,'No RequestObject');
  DBAccess:=nil;
  FRequestObject.CloseDBAccess;
end;

procedure THResponseHandler.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent=FRequestObject) and (Operation=opRemove) then
    FRequestObject:=nil;
end;

procedure THResponseHandler.SetRequestObject(const Value: THCustomDataset);
begin
  if FRequestObject <> Value then
  begin
    FRequestObject:=value;
    if FRequestObject<>nil then
      FRequestObject.FreeNotification(self);
  end;
end;

{ THSimpleDataset }

constructor THSimpleDataset.Create(AOwner: TComponent);
begin
  inherited;
  FResponses:=nil;
end;

destructor THSimpleDataset.Destroy;
begin
  Responses:=nil;
  inherited;
end;

procedure THSimpleDataset.InternalClose;
begin
  inherited;
  FData := nil;
end;

procedure THSimpleDataset.InternalOpen;
begin
  CheckObject(FResponses,'No Responses');
  CheckRange(Findex,0,FResponses.Datasets.count-1);
  FData:= (TObject(FResponses.Datasets[Findex]) as THDataset);
  inherited;
end;

procedure THSimpleDataset.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent=FResponses) and (Operation=opRemove) then
  begin
    //active := false;
    Responses:=nil;
  end;
end;

procedure THSimpleDataset.Notify(Sender: TObject; Event: TObjectEvent);
begin
  if Event is TResponseHandlerEvent then
  begin
    case TResponseHandlerEvent(Event).EventType of
      retOpen:  active := AutoActive;
      retClose: active := false;
    end;
  end;
end;

procedure THSimpleDataset.SetIndex(const Value: integer);
begin
  active := false;
  FIndex := Value;
  if AutoActive and (FResponses<>nil) then
    Active:=FResponses.Active;
end;

procedure THSimpleDataset.SetResponses(const Value: THResponseHandler);
begin
  if FResponses <> Value then
  begin
    Active := false;
    if FResponses <> nil then
    begin
      FResponses.removeListener(self);
      FResponses.RemoveFreeNotification(self);
    end;
    FResponses := Value;
    if FResponses<>nil then
    begin
      FResponses.addListener(self);
      FResponses.FreeNotification(self);
    end;
  end;
end;

{ THDBAggregateField }

function THDBAggregateField.AsCurrency: Currency;
begin
  if Available then
    Result := AggregateField.asCurrency else
    Result := 0;
end;

function THDBAggregateField.AsFloat: Double;
begin
  if Available then
    Result := AggregateField.asFloat else
    Result := 0;
end;

function THDBAggregateField.AsInteger: Integer;
begin
  if Available then
    Result := AggregateField.asInteger else
    Result := 0;
end;

procedure THDBAggregateField.Assign(Source: TPersistent);
begin
  if Source is THDBAggregateField then
    with THDBAggregateField(Source) do
    begin
      Self.FieldName := FieldName;
      Self.AggregateType := AggregateType;
    end
  else
    inherited;
end;

function THDBAggregateField.AsString: string;
begin
  if Available then
    Result := AggregateField.asString else
    Result := '';
end;

procedure THDBAggregateField.SetAggregateField(
  const Value: THBasicField);
begin
  FAggregateField := Value;
  FAvailable := FAggregateField<>nil;
end;

end.
