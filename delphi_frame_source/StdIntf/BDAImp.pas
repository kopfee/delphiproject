// calculate auto sum fields when data read a row

unit BDAImp;
{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>BDAImp
   <What>实现根据IDBAccess接口访问数据源的基本对象类。
   <Written By> Huang YanLai (黄燕来)
   <History>
   1.0 基本实现
   1.1 对意外处理进行了修改
   1.2 2001-11-12，专门建立了为IHDataset等接口实现的函数。
   这些函数保留safecall方式，调用对象类里面的普通调用方式的函数。
   这样可以优化不将这些Dataset提供给外部(Scripts)使用的程序。同时对意外处理更好。（以前的方式将意外转换为OLE错误）。
**********************************************}


(*****   Code Written By Huang YanLai   *****)

{$I KSConditions.INC }

interface

uses windows,ComObj, ActiveX,Classes,SysUtils,contnrs, // std units
  TxtDB,DBAIntf,IntfUtils,BasicDataAccess_TLB,Listeners;  // my units

const
  MAX_Integer_Text_Size = 10;
  MAX_Float_Text_Size = 20;
  MAX_Currency_Text_Size = 20;
  MAX_DateTime_Text_Size = 20;

  // Log Catalog
  lcDataset= 10;
  lcRender = 11;

type
  TDBResponseContent = TObject;

  THDataset = class;
  THBasicField = class;
  THField = class;
  THParam = class;

  THFieldKind = (fkNormal,
    fkCalc,
    fkLookup,
    fkSum,      // represents the last compute row
    fkAggregate   // represents the automatic sumary data (THDataset caculates the sumary)
    );

  THAggregateType = (atNone, atSum, atMax, atMin);

  {
  THFieldOption = (foRenderBrowse,foRenderPrint);
  THFieldOptions = set of THFieldOption;
  }

  THFieldDef = class(TDBFieldDef)
  private
    {
    FAutoSum: boolean;
    FManualSetAutoSum: boolean;
    }
    FExtraDefinition: string;
    FKind: THFieldKind;
    FAggregateType: THAggregateType;
    function    GetisStored: boolean;
    {
    function    GetAutoSum: boolean;
    procedure   SetAutoSum(const Value: boolean);
    }
  public
    //Options : THFieldOptions;
    constructor Create;
    function    charSize : integer;
    procedure   assign(source : TDBFieldDef); override;
    property    isStored : boolean read GetisStored;
    property    Kind : THFieldKind read FKind write FKind;
    property    ExtraDefinition : string read FExtraDefinition write FExtraDefinition;
    //property    AutoSum : boolean read GetAutoSum write SetAutoSum;
    property    AggregateType : THAggregateType read FAggregateType write FAggregateType;
  end;

  THFieldDefs = class(TObjectList)
  private
    function    GetFieldDefs(index: integer): THFieldDef;
  public
    function    findDef(const fieldName: String): THFieldDef;
    property    fieldDefs[index : integer] : THFieldDef read GetFieldDefs; default;
  end;

  THFields = class(TObjectList)
  private
    function  GetFields(index: integer): THBasicField;
  public
    function  findField(const fieldName: String): THBasicField;
    property  fields[index : integer] : THBasicField read GetFields; default;
  end;


  THFindOption = (foCaseInsensitive);
  THFindOptions = set of THFindOption;

  THDataset = class(TAutoIntfObjectEx,IHDataset, IListener)
  private
    FrowsPerReading : Integer;
    FignoreDataset : Boolean;
    FFieldDefs : THFieldDefs;
    FFields : THFields;
    FParamDefs : THFieldDefs;
    FParams : THFields;
    FReturnValue : integer;
    FDBAccess: IDBAccess;
    FTextDB : TTextDataset;
    FReadAll : boolean;
    FDone : boolean;
    FLock: TRTLCriticalSection;
    FSumDefs  : TObjectList;
    FSumFields: THFields;
    FdateTimeFormat: string;
    FdateFormat: string;
    FmoneyFormat: string;
    FtimeFormat: string;
    {
    FAutoSum: boolean;
    FAutoSumFieldDefs : THFieldDefs;
    FAutoSumFields : THFields;
    }
    FfloatFormat: string;
    FFieldCreated : boolean;
    FDatasetID : integer;
    FOutputRead : boolean;
    FReturnRead : boolean;
    FIsReadOutput : boolean;
    FIsReadReturn : boolean;
    FIsReadComputeRow: boolean;
    FmaxRows: Integer;
    FReadingData : Boolean;
    FAfterDoneReading: TNotifyEvent;
    FOnDestroy: TNotifyEvent;
    FAggregateFieldDefs: THFieldDefs;
    FAggregateFields: THFields;
    //FIsFreed : boolean;
    procedure   internalBindFields;
    procedure   internalReadData;
    procedure   readData;
    procedure   readRow;
    procedure   readRows;
    procedure   readComputeRow;
    procedure   readOutput;
    procedure   readReturn;
    procedure   getCalcFields;
    procedure   AggregateOneRow;
    procedure   DoneAggregate;
    // return has more data
    function    needData:boolean;
    procedure   checkRead;
    //function    GetFields(index: integer): THField;
    //function    GetSumFields(index: integer): THParam;
    //procedure   SetAutoSum(const Value: boolean);
    //procedure   internalBindAutoSumFields;
    function    GetRecNo: integer;
    procedure   checkLinked;
    procedure   Notify(Sender : TObject; Event : TObjectEvent);
    procedure   SetDBAccess(const Value: IDBAccess);
    procedure   doDoneReading;
    function    GetCurrentRecordCount: Integer;
    procedure   SetRecNo(const Value: integer);
  protected
    function    findField(const fieldName: WideString): IHField;
    function    findFieldEx(aCatalog: THFieldCatalog; const afieldName: WideString): IHField;
    function    Get_bof: WordBool;
    function    Get_eof: WordBool;
    function    Get_fieldCount: Integer;
    function    Get_fields(index: Integer): IHField;
    function    Get_outputCount: Integer;
    function    Get_outputParams(index: Integer): IHParam;
    function    Get_returnValue: Integer;
    function    Get_bookmark: Integer;
    procedure   Set_bookmark(Value: Integer);
    function    Get_available: WordBool;
    function    Get_sumFieldCount: Integer;
    function    Get_sumFields(index: Integer): IHParam;
    function    Get_moneyFormat: WideString; safecall;
    procedure   Set_moneyFormat(const Value: WideString); safecall;
    function    Get_dateFormat: WideString; safecall;
    procedure   Set_dateFormat(const Value: WideString); safecall;
    function    Get_timeFormat: WideString; safecall;
    procedure   Set_timeFormat(const Value: WideString); safecall;
    function    Get_dateTimeFormat: WideString; safecall;
    procedure   Set_dateTimeFormat(const Value: WideString); safecall;
    function    Get_floatFormat: WideString; safecall;
    procedure   Set_floatFormat(const Value: WideString); safecall;
    function    Get_maxRows: Integer; safecall;
    procedure   Set_maxRows(Value: Integer); safecall;

    // Method resolutions for IHDataset
    procedure   IHDataset.first=HDataset_first;
    procedure   IHDataset.next=HDataset_next;
    procedure   IHDataset.last=HDataset_last;
    procedure   IHDataset.prior=HDataset_prior;
    function    IHDataset.Get_eof=HDataset_Get_eof;
    function    IHDataset.Get_bof=HDataset_Get_bof;
    function    IHDataset.Get_fieldCount=HDataset_Get_fieldCount;
    function    IHDataset.Get_outputCount=HDataset_Get_outputCount;
    function    IHDataset.Get_returnValue=HDataset_Get_returnValue;
    function    IHDataset.Get_bookmark=HDataset_Get_bookmark;
    procedure   IHDataset.Set_bookmark=HDataset_Set_bookmark;
    function    IHDataset.Get_fields=HDataset_Get_fields;
    function    IHDataset.Get_outputParams=HDataset_Get_outputParams;
    function    IHDataset.findField=HDataset_findField;
    function    IHDataset.Get_available=HDataset_Get_available;
    function    IHDataset.Get_sumFieldCount=HDataset_Get_sumFieldCount;
    function    IHDataset.Get_sumFields=HDataset_Get_sumFields;
    function    IHDataset.findFieldEx=HDataset_findFieldEx;

    // for IHDataset only (use safecall)
    procedure   HDataset_first; safecall;
    procedure   HDataset_next; safecall;
    procedure   HDataset_last; safecall;
    procedure   HDataset_prior; safecall;
    function    HDataset_Get_eof: WordBool; safecall;
    function    HDataset_Get_bof: WordBool; safecall;
    function    HDataset_Get_fieldCount: Integer; safecall;
    function    HDataset_Get_outputCount: Integer; safecall;
    function    HDataset_Get_returnValue: Integer; safecall;
    function    HDataset_Get_bookmark: Integer; safecall;
    procedure   HDataset_Set_bookmark(Value: Integer); safecall;
    function    HDataset_Get_fields(index: Integer): IHField; safecall;
    function    HDataset_Get_outputParams(index: Integer): IHParam; safecall;
    function    HDataset_findField(const fieldName: WideString): IHField; safecall;
    function    HDataset_Get_available: WordBool; safecall;
    function    HDataset_Get_sumFieldCount: Integer; safecall;
    function    HDataset_Get_sumFields(index: Integer): IHParam; safecall;
    function    HDataset_findFieldEx(aCatalog: THFieldCatalog; const afieldName: WideString): IHField; safecall;
  public
    constructor Create(aDBAccess : IDBAccess; simpleMode : boolean=false);
    Destructor  Destroy;override;
    procedure   link2Response(autosearch : Boolean=true);
    property    DBAccess : IDBAccess read FDBAccess write SetDBAccess;
    procedure   releaseDBAccess;
    property    IsReadOutput : boolean read FIsReadOutput write FIsReadOutput;
    property    IsReadReturn : boolean read FIsReadReturn write FIsReadReturn;
    property    IsReadComputeRow : boolean read FIsReadComputeRow write FIsReadComputeRow;
    //
    procedure   Open(arowsPerReading : Integer; aignoreDataset : Boolean=false);
    procedure   Close;
    // navigate methods and properties
    property    available: WordBool read Get_available;
    procedure   first;
    procedure   last;
    procedure   next;
    procedure   prior;
    property    Eof : WordBool read Get_eof;
    property    Bof : WordBool read Get_bof;
    property    bookmark: Integer read Get_bookmark write Set_bookmark;
    property    RecNo : integer read GetRecNo write SetRecNo;
    function    empty: boolean;
    property    maxRows: Integer read FmaxRows write FmaxRows;
    // fields manage
    procedure   clearFields;
    function    newFieldDef : THFieldDef;
    procedure   bindField(index:integer); overload;
    procedure   bindField(fieldName:String); overload;
    procedure   addAllExistFields;
    procedure   createFields;

    property    FieldCount : integer read Get_fieldCount;
    property    outputCount : integer read Get_outputCount;
    property    returnValue : integer read Get_returnValue;
    //property    Fields[index : integer] : THField read GetFields;
    property    Fields : THFields read FFields;
    property    fieldDefs : THFieldDefs read FFieldDefs;
    function    findField2(const fieldName: String): THField;
    function    findFieldEx2(aCatalog: THFieldCatalog; const afieldName: WideString): THBasicField;
    // render
    function    getRender(purpose: THRenderType): IHResultRender; safecall;
    // find data methods (will move cursor)
    // @find : from the first record of the data set
    function    find(const KeyFieldName: string; const KeyValue: Variant; Options: THFindOptions): Boolean;
    // @find : find from the current record
    function    findNext(const KeyFieldName: string; const KeyValue: Variant; Options: THFindOptions): Boolean;
    // synchronize
    procedure   lock;
    procedure   unlock;
    // sum for the compute row
    property    SumFieldCount : integer read Get_sumFieldCount;
    property    SumFields : THFields read FSumFields;
    {
    // auto sum calculated by dataset
    property    AutoSum : boolean read FAutoSum write SetAutoSum default false;
    property    AutoSumFields : THFields read FAutoSumFields;
    }
    procedure   ClearAggregateFields;
    function    NewAggregateFieldDef : THFieldDef; overload;
    function    NewAggregateFieldDef(const FieldName : string; AggregatType : THAggregateType) : THFieldDef; overload;
    property    AggregateFieldDefs : THFieldDefs read FAggregateFieldDefs;
    property    AggregateFields : THFields read FAggregateFields;
    procedure   CreateAggregateFields;

    // display format
    property    moneyFormat : string read FmoneyFormat write FmoneyFormat;
    property    dateFormat : string read FdateFormat write FdateFormat;
    property    timeFormat : string read FtimeFormat write FtimeFormat;
    property    dateTimeFormat : string read FdateTimeFormat write FdateTimeFormat;
    property    floatFormat : string read FfloatFormat write FfloatFormat;

    property    TextDB : TTextDataset read FTextDB; // for advanced use only!
    property    AfterDoneReading : TNotifyEvent read FAfterDoneReading write FAfterDoneReading;
    property    OnDestroy : TNotifyEvent read FOnDestroy write FOnDestroy;

    property    Done : Boolean read FDone;
    property    CurrentRecordCount : Integer read GetCurrentRecordCount;
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
    Ftag: integer;
    FExtra: variant;
    FDisplayLength : integer;
  protected
    function      getDataBuffer : pointer; virtual;
    function      Get_displayName(): WideString;
    function      Get_fieldName(): WideString;
    function      Get_fieldSize(): Integer;
    function      Get_fieldType(): THFieldType;
    function      Get_Value(): OleVariant; virtual;
    procedure     Set_displayName(const Value: WideString);
    procedure     Set_value(Value: OleVariant); virtual;
    function      Get_asString: WideString; virtual;
    procedure     Set_asString(const Value: WideString); virtual;
    function      Get_asInteger: Integer; virtual;
    procedure     Set_asInteger(Value: Integer); virtual;
    function      Get_asFloat: Double; virtual;
    procedure     Set_asFloat(Value: Double); virtual;
    function      Get_asDatetime: TDateTime; virtual;
    procedure     Set_asDatetime(Value: TDateTime); virtual;
    function      Get_asCurrency: Currency; virtual;
    procedure     Set_asCurrency(Value: Currency); virtual;
    function      Get_stringFormat: WideString;
    procedure     Set_stringFormat(const Value: WideString);
    function      Get_asDisplayText: WideString;
    procedure     Set_asDisplayText(const Value: WideString);
    // ReadData is called by THDataset
    procedure     ReadData; virtual; abstract;
    function      Get_isNull: WordBool; virtual;
    procedure     Set_isNull(Value: WordBool); virtual;
    procedure     beep; safecall;
    function      Get_isOnlyDate: WordBool; safecall;
    procedure     Set_isOnlyDate(Value: WordBool); safecall;
    function      Get_isOnlyTime: WordBool; safecall;
    procedure     Set_isOnlyTime(Value: WordBool); safecall;
    function      Get_displayLength: Integer; safecall;
    procedure     Set_displayLength(Value: Integer); safecall;

    // Method resolutions for IHField
    function      IHField.Get_fieldName=HField_Get_fieldName;
    function      IHField.Get_displayName=HField_Get_displayName;
    procedure     IHField.Set_displayName=HField_Set_displayName;
    function      IHField.Get_fieldSize=HField_Get_fieldSize;
    function      IHField.Get_fieldType=HField_Get_fieldType;
    function      IHField.Get_Value=HField_Get_Value;
    procedure     IHField.Set_Value=HField_Set_Value;
    function      IHField.Get_asString=HField_Get_asString;
    procedure     IHField.Set_asString=HField_Set_asString;
    function      IHField.Get_asInteger=HField_Get_asInteger;
    procedure     IHField.Set_asInteger=HField_Set_asInteger;
    function      IHField.Get_asFloat=HField_Get_asFloat;
    procedure     IHField.Set_asFloat=HField_Set_asFloat;
    function      IHField.Get_asDatetime=HField_Get_asDatetime;
    procedure     IHField.Set_asDatetime=HField_Set_asDatetime;
    function      IHField.Get_asCurrency=HField_Get_asCurrency;
    procedure     IHField.Set_asCurrency=HField_Set_asCurrency;
    function      IHField.Get_stringFormat=HField_Get_stringFormat;
    procedure     IHField.Set_stringFormat=HField_Set_stringFormat;
    function      IHField.Get_asDisplayText=HField_Get_asDisplayText;
    procedure     IHField.Set_asDisplayText=HField_Set_asDisplayText;
    function      IHField.Get_isNull=HField_Get_isNull;
    procedure     IHField.Set_isNull=HField_Set_isNull;

    // for IHField only (use safecall)
    function      HField_Get_fieldName: WideString; safecall;
    function      HField_Get_displayName: WideString; safecall;
    procedure     HField_Set_displayName(const Value: WideString); safecall;
    function      HField_Get_fieldSize: Integer; safecall;
    function      HField_Get_fieldType: THFieldType; safecall;
    function      HField_Get_Value: OleVariant; safecall;
    procedure     HField_Set_Value(Value: OleVariant); safecall;
    function      HField_Get_asString: WideString; safecall;
    procedure     HField_Set_asString(const Value: WideString); safecall;
    function      HField_Get_asInteger: Integer; safecall;
    procedure     HField_Set_asInteger(Value: Integer); safecall;
    function      HField_Get_asFloat: Double; safecall;
    procedure     HField_Set_asFloat(Value: Double); safecall;
    function      HField_Get_asDatetime: TDateTime; safecall;
    procedure     HField_Set_asDatetime(Value: TDateTime); safecall;
    function      HField_Get_asCurrency: Currency; safecall;
    procedure     HField_Set_asCurrency(Value: Currency); safecall;
    function      HField_Get_stringFormat: WideString; safecall;
    procedure     HField_Set_stringFormat(const Value: WideString); safecall;
    function      HField_Get_asDisplayText: WideString; safecall;
    procedure     HField_Set_asDisplayText(const Value: WideString); safecall;
    function      HField_Get_isNull: WordBool; safecall;
    procedure     HField_Set_isNull(Value: WordBool); safecall;
  public
    constructor   Create(ADataset : THDataset;aDef : THFieldDef); virtual;
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
    property      isNull: WordBool read Get_isNull write Set_isNull;
    property      isOnlyDate: WordBool read Get_isOnlyDate write Set_isOnlyDate;
    property      isOnlyTime: WordBool read Get_isOnlyTime write Set_isOnlyTime;
    property      displayLength: Integer read Get_displayLength write Set_displayLength;
    // event
    // get/set value is available only in a calculate field
    property      OnGetValue : TGetValueEvent read FOnGetValue write FOnGetValue;
    property      OnSetValue : TSetValueEvent read FOnSetValue write FOnSetValue;
    //
    property      OnGetDisplayText : TGetTextEvent read FOnGetDisplayText write FOnGetDisplayText;
    property      OnSetDisplayText : TSetTextEvent read FOnSetDisplayText write FOnSetDisplayText;
    // tag data
    property      tag : integer read Ftag write Ftag;
    property      extra : variant read FExtra write FExtra;
  end;

  THField = class(THBasicField)
  private
    FTextField : TTextField;
  protected
    function      getDataBuffer : pointer; override;
    procedure     ReadData; override;
    function      Get_isNull: WordBool; override;
    procedure     Set_isNull(Value: WordBool); override;
  public
    property      TextField : TTextField read FTextField ;
  end;

  THCalcField = class(THField)

  end;

  THLookupField = class(THField)
  private
    FlinkedField: THField;
    FlookupType: variant;
    procedure     SetlinkedField(const Value: THField);
  public
    constructor   Create(ADataset : THDataset;aDef : THFieldDef); override;
    property      linkedField : THField read FlinkedField write SetlinkedField;
    property      lookupType : variant read FlookupType write FlookupType;
  end;

  THParam = class(THBasicField,IHParam)
  private

  protected
    FBuffer  :    PChar;
    FIsNull  :    boolean;
    procedure     prepareBuffer;
  protected
    procedure     ReadData; override;
    function      getDataBuffer : pointer; override;
    function      Get_isNull: WordBool; override;
    procedure     Set_isNull(Value: WordBool); override;
    // Method resolutions for IHField
    function      IHParam.Get_fieldName=HField_Get_fieldName;
    function      IHParam.Get_displayName=HField_Get_displayName;
    procedure     IHParam.Set_displayName=HField_Set_displayName;
    function      IHParam.Get_fieldSize=HField_Get_fieldSize;
    function      IHParam.Get_fieldType=HField_Get_fieldType;
    function      IHParam.Get_Value=HField_Get_Value;
    procedure     IHParam.Set_Value=HField_Set_Value;
    function      IHParam.Get_asString=HField_Get_asString;
    procedure     IHParam.Set_asString=HField_Set_asString;
    function      IHParam.Get_asInteger=HField_Get_asInteger;
    procedure     IHParam.Set_asInteger=HField_Set_asInteger;
    function      IHParam.Get_asFloat=HField_Get_asFloat;
    procedure     IHParam.Set_asFloat=HField_Set_asFloat;
    function      IHParam.Get_asDatetime=HField_Get_asDatetime;
    procedure     IHParam.Set_asDatetime=HField_Set_asDatetime;
    function      IHParam.Get_asCurrency=HField_Get_asCurrency;
    procedure     IHParam.Set_asCurrency=HField_Set_asCurrency;
    function      IHParam.Get_stringFormat=HField_Get_stringFormat;
    procedure     IHParam.Set_stringFormat=HField_Set_stringFormat;
    function      IHParam.Get_asDisplayText=HField_Get_asDisplayText;
    procedure     IHParam.Set_asDisplayText=HField_Set_asDisplayText;
    function      IHParam.Get_isNull=HField_Get_isNull;
    procedure     IHParam.Set_isNull=HField_Set_isNull;
  public
    Destructor    Destroy;override;
  end;

  THSumParam = class(THParam)
  protected
    procedure     ReadData; override;
  public
    constructor   Create(ADataset : THDataset;aDef : THFieldDef); override;
  end;

  {
    THAggregateField is for automatical data sumary in a dataset
  }
  THAggregateField = class(THParam)
  protected
    FSpeedSum : boolean;
    FFirst : Boolean;
    FBasedField : THBasicField;
    procedure     ReadData; override; //
    procedure     InitAggregate; virtual;
    procedure     AggregateOneRow; virtual; abstract;
    procedure     DoneAggregate; virtual;
    procedure     CheckParamValid; virtual;
  public
    constructor   Create(ADataset : THDataset; aDef : THFieldDef); override;
    property      BasedField : THBasicField read FBasedField;
  end;

  THAggregateIntField = class(THAggregateField)
  private

  protected
    FAggregateValue :   Integer;
    function      getDataBuffer : pointer; override;
    procedure     InitAggregate; override;
    procedure     AggregateOneRow; override;
    procedure     CheckParamValid; override;
  end;

  THAggregateCurField = class(THAggregateField)
  private

  protected
    FAggregateValue :   Currency;
    function      getDataBuffer : pointer; override;
    procedure     InitAggregate; override;
    procedure     AggregateOneRow; override;
    procedure     CheckParamValid; override;
  end;

  THAggregateFloatField = class(THAggregateField)
  private

  protected
    FAggregateValue :   Double;
    function      getDataBuffer : pointer; override;
    procedure     InitAggregate; override;
    procedure     AggregateOneRow; override;
    procedure     CheckParamValid; override;
  end;

  THAggregateStringField = class(THAggregateField)
  private

  protected
    FAggregateValue :   string;
    function      getDataBuffer : pointer; override;
    procedure     InitAggregate; override;
    procedure     AggregateOneRow; override;
    procedure     CheckParamValid; override;
  end;

  THAggregatePercentField = class(THAggregateFloatField)
  private

  protected
    procedure     AggregateOneRow; override;
    procedure     DoneAggregate; override;
  public
    ExtraField : THBasicField;
  end;

  THRenderClass = class of THBasicRander;
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
    FBindedSumFields : TList;
    FSpecialFieldIndexs : TList;
    FSpecialSumFieldIndexs : TList;
    FSumFieldsDesc : string;
    FisRenderSum : boolean;
    function    Get_eof: WordBool; safecall;
    function    Get_seqNo: Integer; safecall;
    function    internalGetData(rows: Integer): string; virtual;abstract;
    procedure   doBindFields(const bindFields: String); virtual;
    //procedure   defaultBinding; virtual;
    procedure   doBindSumFields;
  public
    constructor Create(aDataset : THDataset); virtual;
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
    //procedure   defaultBinding; override;
    function    internalGetData(rows: Integer): string; override;
  public

  end;

  THPrintRender = class(THBasicRander)
  private

  protected
    //procedure   defaultBinding; override;
    function    internalGetData(rows: Integer): string; override;
  public

  end;

  THPrintListRender = class(THBasicRander)
  private

  protected
    //procedure   defaultBinding; override;
    function    internalGetData(rows: Integer): string; override;
  public

  end;

  THListRender = class(THBasicRander)
  private

  protected
    //procedure   defaultBinding; override;
    function    internalGetData(rows: Integer): string; override;
  public

  end;

{
 ParseFields
    add field from AllFields into Fields
 FieldsDesc indecates a field by name or by index
 fields are sperated by ';'
 FieldsDesc - eaxmple :
  field1;*field3;#3;*#4
 * : use string(value) replacing asString
 # : identify field by its index
 field1 : identify field by its name
}
procedure ParseFields(
  const FieldsDesc:string;
  AllFields : THFields;
  Fields:TList;
  SpecailList : TList;
  var invalidFieldCount : integer;
  defaultAll : boolean=true;
  addNilField : boolean=true);

procedure RegisterRenderClass(RenderType : THRenderType; RenderClass : THRenderClass);

function  getRenderClass(RenderType : THRenderType):THRenderClass;

{  the following classes are not implement!! }

type
  THParams = class(TObjectList)
  private
    function GetItems(index: integer): THParam;
  public
    property  Items[index:integer] : THParam read GetItems; default;
  end;

const
  AggregateNames : array[THAggregateType] of string
    = (
      '',
      'SUM',
      'MAX',
      'MIN'
    );

function  GetAggregateType(const AggregateName:string) : THAggregateType;

resourcestring
  SFieldDataTypeError = 'Error : Field DataType Error.';

implementation

uses BDACore,SafeCode,LogFile
  {$ifdef VCL60_UP }
  ,Variants
  {$else}

  {$endif}
;

const
  MaxOutputValue = 128;
  Bookmark_BOF = -1;
  Bookmark_EOF = -2;
  Bookmark_BofAndEof = -3;

function  GetAggregateType(const AggregateName:string) : THAggregateType;
var
  I : THAggregateType;
begin
  Result := atNone;
  for I:=Low(THAggregateType) to High(THAggregateType) do
  begin
    if SameText(AggregateNames[I],AggregateName) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

{ THFieldDef }

constructor THFieldDef.Create;
begin
  inherited ;
  //Options := [foRenderBrowse,foRenderPrint];
  {FAutoSum := false;
  FManualSetAutoSum := false;}
end;

function THFieldDef.GetisStored: boolean;
begin
  result := (kind=fkNormal) and (FieldType in [ftInteger,ftFloat,ftChar,ftDatetime,ftCurrency]);
end;

function THFieldDef.charSize: integer;
begin
  {case FieldType of
    ftInteger:
                 result := sizeof(Integer);
    ftFloat:     result := sizeof(double);
    ftChar:      result := FieldSize;
    ftDatetime:  result := sizeof(TDateTime);
  else
    result := FieldSize;
  end;}
  case FieldType of
    ftInteger,ftFloat,ftCurrency,ftDatetime : result := StdDataSize[FieldType];
  else
    result := FieldSize;
  end;
end;
{
function THFieldDef.GetAutoSum: boolean;
begin
  case FieldType of
    ftInteger :
      if FManualSetAutoSum then
        result := FAutoSum else
        result := false;
    ftFloat,ftCurrency :
      if FManualSetAutoSum then
        result := FAutoSum else
        result := true;
  else
    result := false;
  end;
end;

procedure THFieldDef.SetAutoSum(const Value: boolean);
begin
  FManualSetAutoSum := true;
  FAutoSum := value;
end;
}

procedure THFieldDef.assign(source: TDBFieldDef);
begin
  inherited;
  if source is THFieldDef then
  begin
    {FAutoSum := THFieldDef(source).FAutoSum;
    FManualSetAutoSum := THFieldDef(source).FManualSetAutoSum;}
    Kind := THFieldDef(source).Kind;
    ExtraDefinition := THFieldDef(source).ExtraDefinition;
    AggregateType := THFieldDef(source).AggregateType;
  end;
end;

{ THFieldDefs }

function THFieldDefs.findDef(const fieldName: String): THFieldDef;
var
  i : integer;
  FieldDef : THFieldDef;
begin
  result:= nil;
  for i:=0 to count-1 do
  begin
    FieldDef := THFieldDef(Items[i]);
    if CompareText(fieldDef.FieldName,fieldName)=0 then
    begin
      //result:= Field as IHField;
      result:= FieldDef;
      break;
    end;
  end;
end;

function THFieldDefs.GetFieldDefs(index: integer): THFieldDef;
begin
  result := THFieldDef(items[index]);
end;

{ THFields }

function THFields.findField(const fieldName: String): THBasicField;
var
  i : integer;
  Field : THBasicField;
begin
  result:= nil;
  for i:=0 to count-1 do
  begin
    Field := THBasicField(Items[i]);
    if CompareText(Field.fieldDef.FieldName,fieldName)=0 then
    begin
      //result:= Field as IHField;
      result:= Field;
      break;
    end;
  end;
end;


function THFields.GetFields(index: integer): THBasicField;
begin
  result := THBasicField(items[index]);
end;

{  THDataset  }

constructor THDataset.Create(aDBAccess: IDBAccess; simpleMode : boolean=false);
begin
  //LogCreate(self);
  inherited Create(getBDATypeLib,IHDataset);
  //FIsFreed := false;
  FDBAccess := nil;
  DBAccess := aDBAccess;
  FFieldDefs := THFieldDefs.Create;
  FFields := THFields.Create;
  FTextDB := TTextDataset.Create;
  FParamDefs := THFieldDefs.Create;
  FParams := THFields.Create;
  FSumDefs  := TObjectList.create;
  FSumFields:= THFields.create;
  FmoneyFormat := '#,##0.00';
  FdateTimeFormat := 'yyyy/dd/mm hh:nn:ss';
  FdateFormat := 'yyyy/dd/mm';
  FtimeFormat := 'hh:nn:ss';
  FfloatFormat := '0.00';
  {FAutoSum := false;
  FAutoSumFields := nil;
  FAutoSumFieldDefs := nil;}
  FFieldCreated := false;
  FDatasetID := 0;
  FIsReadOutput:=not simpleMode;
  FIsReadReturn:=not simpleMode;
  FIsReadComputeRow:=not simpleMode;
  FAggregateFieldDefs := THFieldDefs.Create;
  FAggregateFields := THFields.Create;
  InitializeCriticalSection(FLock);
end;

destructor THDataset.Destroy;
begin
  writeLog('begin free THDataset',lcConstruct_Destroy);
  if assigned(FOnDestroy) then
    FOnDestroy(self);
  {if FIsFreed then
  begin
    writeLog('Free more than once',lcConstruct_Destroy);
    exit;
  end
  else FIsFreed := true;}
  DBAccess:=nil;
  {FreeAndNil(FAutoSumFields);
  FreeAndNil(FAutoSumFieldDefs);}
  FSumFields.free;
  FSumDefs.free;
  FParamDefs.free;
  FParams.free;
  FTextDB.free;
  FFieldDefs.free;
  FFields.free;
  FAggregateFieldDefs.Free;
  FAggregateFields.Free;
  DeleteCriticalSection(FLock);
  inherited;
  //LogDestroy(self);
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
  assert( not result or (FTextDB.cursor<=0),'THDataset.bof');
end;

function THDataset.Get_eof: WordBool;
begin
  checkRead;
  result := FTextDB.eof;
  //if result then assert(FTextDB.cursor>=FTextDB.count-1);
  assert( not result or (FTextDB.cursor>=FTextDB.count-1),'THDataset.eof')
end;

function THDataset.Get_fieldCount: Integer;
begin
  result := FFields.Count;
end;

function THDataset.Get_fields(index: Integer): IHField;
begin
  result := THField(FFields[index]) as IHField;
end;
{
function THDataset.GetFields(index: integer): THField;
begin
  result := THField(FFields[index]);
end;
}
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
  try
    if not FReadAll then
      readData;
  finally
    FTextDB.Last;
  end;
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
  FFieldCreated := false;
  {
  if FAutoSum then
  begin
    FAutoSumFields.clear;
    FAutoSumFieldDefs.clear;
  end;
  }
  FSumFields.Clear;
  FSumDefs.clear;
  FFieldDefs.Clear;
  FFields.Clear;
  FTextDB.Clear;
  FParamDefs.Clear;
  FParams.Clear;
  ClearAggregateFields;
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

procedure THDataset.bindField(fieldName:String);
begin
  newFieldDef().FieldName := fieldName;
end;

procedure THDataset.addAllExistFields;
var
  fieldsInDB : integer;
  i : integer;
begin
  checkLinked;
  fieldsInDB := DBAccess.fieldCount;
  for i:=1 to fieldsInDB do
    bindField(i);
end;

procedure THDataset.internalBindFields;
var
  i,j : integer;
  FieldDef: THFieldDef;
  DBFieldCount : integer;
  Field : THField;
  bindName : string;
  binded : boolean;
begin
  assert(DBAccess.curResponseType = rtDataset);
  checkTrue(FFieldDefs.count>0,'no defined fields');
  //if DBAccess.curResponseType = rtDataset then
  begin
    FTextDB.BeginCreateField;
    //
    DBFieldCount := DBAccess.fieldCount;
    for i:=0 to FFieldDefs.count-1 do
    begin
      FieldDef := THFieldDef(FFieldDefs[i]);
      if FieldDef.Kind=fkNormal then
      begin
        // bind normal field
        binded := false;
        if (FieldDef.FieldIndex>=1) and
           (FieldDef.FieldIndex<=DBFieldCount) then
          begin
            // bind by index
            DBAccess.getFieldDef(FieldDef.FieldIndex,FieldDef);
            binded := true;
          end else
          if FieldDef.FieldName<>'' then
          begin
            // bind by name
            bindName := FieldDef.FieldName;
            for j:=1 to DBAccess.fieldCount do
            begin
              DBAccess.getFieldDef(j,FieldDef);
              if CompareText(FieldDef.FieldName,bindName)=0 then
              begin
                binded := true;
                break;
              end;
            end;
          end;
        if not binded then break;
        WriteLog(Format('Field[%s] Logic Data Type:%d, Physical Data Type:%d',
          [FieldDef.FieldName,Integer(FieldDef.FieldType),Integer(FieldDef.RawType)]),
          lcDataset);
      end;
      {if FieldDef.isStored then
      begin
        Field := THField.create(self,FieldDef);
        FFields.add(Field);
        with FieldDef do
          Field.FTextField := FTextDB.CreateField(FieldName,DisplayName,charSize);
      end;}
      case FieldDef.Kind of
        fkNormal : Field := THField.create(self,FieldDef);
        fkCalc   : Field := THCalcField.create(self,FieldDef);
        fkLookup : Field := THLookupField.create(self,FieldDef);
      else field:=nil;
      end;
      if field<>nil then
      begin
        FFields.add(Field);
        if FieldDef.isStored then
        with FieldDef do
          Field.FTextField := FTextDB.CreateField(FieldName,DisplayName,charSize);
      end;
    end;
    FTextDB.EndCreateField;
    WriteLog(format('Dataset[%.8x] opened. fields : %d',[integer(self),FFields.count]),lcDataset);
  end{ else
    FTextDB.Clear;}
end;

procedure THDataset.createFields;
begin
  checkTrue(DBAccess<>nil,'DBAccess has been released!(createFields)');
  checkLinked;
  if not FFieldCreated then
  begin
    if fieldDefs.Count=0 then addAllExistFields;

    internalBindFields;

    FFieldCreated := true;

    // new add
    FDatasetID := DBAccess.CmdCount;
  end;
end;

procedure THDataset.Open(arowsPerReading: Integer;
  aignoreDataset: Boolean=false);
begin
  checkTrue(DBAccess<>nil,'DBAccess has been released!(open)');
  FrowsPerReading := arowsPerReading;
  FignoreDataset := aignoreDataset;

  createFields;
  CreateAggregateFields;
  {
  // do not move into "createFields" !
  if not FignoreDataset and AutoSum then
    internalBindAutoSumFields;
  }
  
  FReadAll := false;
  FDone := false;
  FReadingData := False;
  readData;
end;

procedure THDataset.internalReadData;
var
  rt : TDBResponseType;
begin
  if Done then exit;
  checkTrue(DBAccess<>nil,'DBAccess has been released!(readData)');
  if FDatasetID<>DBAccess.CmdCount then
  begin
    FReadAll := true;
    DoneAggregate;
    //Done := true;
    doDoneReading;
    exit;
  end;
  if not Done then
  begin
    if FignoreDataset or (FFields.Count<=0) then
    begin
      //FDBAccess.ReachOutputs;
      FReadAll := true;
    end;

    if not FignoreDataset and not FReadall then
      readRows;

    if not FignoreDataset and FReadall then
      DoneAggregate;

    if FReadall then
    begin
      writeLog(format('THDataset[%8.8x] Datarows : %d',[integer(self),FTextDB.count]),lcDataset);

      if IsReadOutput or IsReadReturn then
      begin
        while (IsReadOutput and not FOutputRead)
          or (IsReadReturn and not FReturnRead) do
        begin
          rt:=DBAccess.nextResponse;
          case rt of
            rtNone:  break;
            rtDataset: ;
            rtReturnValue: readReturn;
            rtOutputValue: readOutput;
            rtError:     ;
            rtMessage:   ;
          end;
        end;
      end;
      //Done := true;
      doDoneReading;
    end;
  end;
end;

procedure THDataset.readData;
begin
  if FReadingData then
  begin
    WriteLog('Re-Enter THDataset.readData',lcDataset);
    Exit;
  end;

  try
    try
      FReadingData := True;
      internalReadData;
    finally
      FReadingData := False;
    end;
  except
    WriteException;
    {
    FReadAll:=true;
    Done := true;
    }
    doDoneReading;
    raise;
  end;
end;

procedure THDataset.readRows;
var
  readCount : integer;
begin
  readCount := 0;
  while ((FrowsPerReading<=0) or (readCount<FrowsPerReading))
      and DBAccess.nextRow
      and ((FmaxRows<=0) or (FTextDB.Count<FMaxRows) ) do
  begin
    if DBAccess.isThisACumputeRow then
    begin
      readComputeRow;
    end else
    begin
      readRow;
      inc(readCount);
    end;
  end;
  if DBAccess.eof or ((FTextDB.Count>=FMaxRows) and (FMaxRows>0))then
    FReadAll:=true;
  WriteLog(format('Dataset[%.8x] read rows : %d',[integer(self),readCount]),lcDataset);
end;

procedure THDataset.readRow;
var
  i : integer;
begin
  FTextDB.Append;
  for i:=0 to FFields.count-1 do
  begin
    if FFields[i] is THField then
      THField(FFields[i]).ReadData;
  end;
  getCalcFields;
  AggregateOneRow;
end;


procedure THDataset.readOutput;
var
  i : integer;
  ParamDef : THFieldDef;
  Param : THParam;
begin
  if FIsReadOutput and (DBAccess.curResponseType =rtOutputValue) then
  begin
    for i:=1 to DBAccess.outputCount do
    begin
      ParamDef := THFieldDef.Create;
      FParamDefs.Add(ParamDef);
      DBAccess.getOutputDef(i,ParamDef);
      Param := THParam.Create(self,ParamDef);
      FParams.add(Param);
      Param.ReadData;
    end;
    FOutputRead:=true;
  end;
end;

procedure THDataset.readReturn;
begin
  if FIsReadReturn and (DBAccess.curResponseType =rtReturnValue) then
  begin
    FReturnValue := DBAccess.returnValue;
    FReturnRead:=true;
  end else
    FReturnValue := 0;
end;

procedure THDataset.getCalcFields;
begin

end;


procedure THDataset.Close;
begin
  clearFields;
end;

function  THDataset.needData:boolean;
var
  SaveCursor : integer;
begin
  // 使用FNeedingData标志避免重入(被间接地递归调用)
  if not FReadAll and not FReadingData then
  begin
    SaveCursor := FTextDB.Cursor;
    try
      readData;
    finally
      FTextDB.Cursor := SaveCursor;
    end;
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
var
  RenderClass : THRenderClass;
begin
  {case purpose of
    rtBrowse : result := IHResultRender(THBrowseRender.Create(self));
    rtPrint  : result := IHResultRender(THPrintRender.Create(self));
    rtList   : result := IHResultRender(THListRender.Create(self));
    rtPrintList : result := IHResultRender(THPrintListRender.Create(self));
    else  result := nil;
  end;}
  RenderClass := getRenderClass(purpose);
  if RenderClass<>nil then
    result := IHResultRender(RenderClass.Create(self)) else
    result := nil;
end;


function THDataset.Get_bookmark: Integer;
begin
  if bof then
    if eof then
      result:=Bookmark_BofAndEof else
      result:=Bookmark_BOF
  else if eof then result:=Bookmark_EOF else
      result := FTextDB.Cursor;
end;

procedure THDataset.Set_bookmark(Value: Integer);
begin
  if value=Bookmark_BofAndEof then
  begin
    checkTrue(FTextDB.Count=0,'Error bookmark!');
    //FTextDB.first;
  end
  else if value=bookmark_BOF then first
  else if value=bookmark_EOF then last
  else FTextDB.Cursor := value;
end;

function THDataset.Get_available: WordBool;
begin
  result := FTextDB.Available;
end;
{
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
}

function THDataset.findField2(const fieldName: String): THField;
begin
  result := THField(FFields.findField(fieldName));
end;

function THDataset.find(const KeyFieldName: string;
  const KeyValue: Variant; Options: THFindOptions): Boolean;
begin
  first;
  result := findNext(KeyFieldName,KeyValue,Options);
end;

function THDataset.findNext(const KeyFieldName: string;
  const KeyValue: Variant; Options: THFindOptions): Boolean;
var
  field : THField;
  buffer : Pchar;
  bufferSize : integer;
  intValue : integer;
  floatValue : double;
  dateValue : TDateTime;
  charValue : String;
  currencyValue : Currency;
  isInsensitive : boolean;
begin
  result := false;
  field := findField2(KeyFieldName);
  if (field<>nil) and (field.fieldDef.Kind=fkNormal) then
  begin
    try
      isInsensitive := false;
      bufferSize := field.TextField.Size+1;
      GetMem(buffer,bufferSize);
      FillChar(buffer^,bufferSize,0);
      try
        case field.fieldDef.FieldType of
          ftInteger : begin
                        assert(sizeof(intValue)+1=bufferSize);
                        intValue := KeyValue;
                        move(intValue,buffer^,sizeof(intValue));
                      end;
          ftFloat   : begin
                        assert(sizeof(floatValue)+1=bufferSize);
                        floatValue := KeyValue;
                        move(floatValue,buffer^,sizeof(floatValue));
                      end;
          ftCurrency: begin
                        assert(sizeof(currencyValue)+1=bufferSize);
                        currencyValue := KeyValue;
                        move(currencyValue,buffer^,sizeof(currencyValue));
                      end;
          ftChar    : begin
                        charValue := KeyValue;
                        if length(charValue)>=bufferSize then abort;
                        move(pchar(charValue)^,buffer^,length(charValue));
                        isInsensitive := foCaseInsensitive in Options;
                      end;
          ftDatetime: begin
                        assert(sizeof(dateValue)+1=bufferSize);
                        dateValue := keyValue;
                        move(dateValue,buffer^,sizeof(dateValue));
                      end;
          else        abort;
        end;
        while not result and not eof do
        begin
          if isInsensitive then
          begin
            result := AnsiStrIComp(Buffer,Field.TextField.GetDataBuffer)=0;
          end else
          begin
            result := compareMem(Buffer,Field.TextField.GetDataBuffer,BufferSize-1);
          end;
          if not result then next;
        end;
      finally
        FreeMem(buffer,bufferSize);
      end;
    except
      // for data convertion
    end;
  end;
end;

procedure THDataset.lock;
begin
  EnterCriticalSection(FLock);
end;

procedure THDataset.unlock;
begin
  LeaveCriticalSection(FLock);
end;
{
function THDataset.GetSumFields(index: integer): THParam;
begin
  result := THParam(FSumFields[index]);
end;
}
procedure THDataset.readComputeRow;
var
  i,count : integer;
  fieldDef: THFieldDef;
  field : THSumParam;
begin
  FSumFields.Clear;
  FSumDefs.Clear;
  count := DBAccess.ComputeFieldCount;
  for i:=1 to count do
  begin
    fieldDef := THFieldDef.create;
    FSumDefs.add(fieldDef);
    DBAccess.getComputeFieldDef(i,fieldDef);
    fieldDef.Kind := fkSum;
    field := THSumParam.Create(self,fieldDef);
    FSumFields.add(field);
    field.ReadData;
  end;
end;

function THDataset.Get_sumFieldCount: Integer;
begin
  Result := FSumFields.count;
end;

function THDataset.Get_sumFields(index: Integer): IHParam;
begin
  Result := IHParam(THParam(FSumFields[index]));
end;

procedure THDataset.releaseDBAccess;
begin
  DBAccess := nil;
  if FFields.Count>0 then
  begin
    FReadAll := true;
  end;
end;

function THDataset.Get_dateFormat: WideString;
begin
  result := FdateFormat;
end;

function THDataset.Get_dateTimeFormat: WideString;
begin
  result := FdateTimeFormat;
end;

function THDataset.Get_moneyFormat: WideString;
begin
  result := FmoneyFormat;
end;

function THDataset.Get_timeFormat: WideString;
begin
  result := FtimeFormat;
end;

procedure THDataset.Set_dateFormat(const Value: WideString);
begin
  FdateFormat := value;
end;

procedure THDataset.Set_dateTimeFormat(const Value: WideString);
begin
  FdateTimeFormat:= value;
end;

procedure THDataset.Set_moneyFormat(const Value: WideString);
begin
  FmoneyFormat:= value;
end;

procedure THDataset.Set_timeFormat(const Value: WideString);
begin
  FtimeFormat:= value;
end;

procedure THDataset.AggregateOneRow;
var
  I : integer;
begin
  if available then
    for I:=0 to AggregateFields.Count-1 do
      if AggregateFields[I]<>nil then
        THAggregateField(AggregateFields[i]).AggregateOneRow;
end;

procedure THDataset.DoneAggregate;
var
  I : integer;
begin
  if available then
    for i:=0 to AggregateFields.count-1 do
      THAggregateField(AggregateFields[i]).DoneAggregate;
end;

{
procedure THDataset.AggregateOneRow;
var
  I : integer;
begin
  assert(FAutoSumFields<>nil);
  assert(FAutoSumFieldDefs<>nil);
  if available then
  begin
    for i:=0 to FAutoSumFields.count-1 do
      THAggregateField(FAutoSumFields[i]).AggregateOneRow;
  end;
end;

procedure THDataset.DoneAggregate;
var
  I : integer;
begin
  assert(FAutoSumFields<>nil);
  assert(FAutoSumFieldDefs<>nil);
  if available then
    for i:=0 to FAutoSumFields.count-1 do
      THAggregateField(FAutoSumFields[i]).DoneAggregate;
end;

procedure THDataset.SetAutoSum(const Value: boolean);
begin
  if FAutoSum <> Value then
  begin
    FAutoSum := Value;
    if FAutoSum then
    begin
      FAutoSumFields := THFields.create;
      FAutoSumFieldDefs := THFieldDefs.Create;
    end else
    begin
      FreeAndNil(FAutoSumFields);
      FreeAndNil(FAutoSumFieldDefs);
    end;
  end;
end;

procedure THDataset.internalBindAutoSumFields;
var
  i : integer;
  aAutoSumField : THAggregateField;
  fieldDef : THFieldDef;
begin
  assert(FAutoSumFields<>nil);
  assert(FAutoSumFieldDefs<>nil);
  FAutoSumFieldDefs.clear;
  FAutoSumFields.Clear;
  if available then
  begin
    // bind Auto Sum Fields
    for i:=0 to FieldCount-1 do
    begin
      aAutoSumField:=nil;
      if Fields[i].fieldDef.AutoSum then
        case Fields[i].fieldDef.FieldType of
          ftInteger :
            begin
              fieldDef := THFieldDef.Create;
              fieldDef.assign(Fields[i].fieldDef);
              fieldDef.Kind := fkAggregate;
              FAutoSumFieldDefs.add(fieldDef);
              aAutoSumField:=THAggregateIntField.create(self,fieldDef);
            end;
          ftFloat   :
            begin
              fieldDef := THFieldDef.Create;
              fieldDef.assign(Fields[i].fieldDef);
              fieldDef.Kind := fkAggregate;
              FAutoSumFieldDefs.add(fieldDef);
              aAutoSumField:=THAggregateFloatField.create(self,Fields[i].fieldDef);
            end;
          ftCurrency:
            begin
              fieldDef := THFieldDef.Create;
              fieldDef.assign(Fields[i].fieldDef);
              fieldDef.Kind := fkAggregate;
              FAutoSumFieldDefs.add(fieldDef);
              aAutoSumField:=THAggregateCurField.create(self,Fields[i].fieldDef);
            end;
        end;

      if aAutoSumField<>nil then
      begin
        aAutoSumField.BasedField := Fields[i];
        FAutoSumFields.add(aAutoSumField);
        aAutoSumField.InitAggregate;
      end;
    end;
  end;
end;

procedure THDataset.internalBindAutoSumFields;
var
  i,k : integer;
  aAutoSumField : THAggregateField;
  fieldDef : THFieldDef;
  fieldname1,fieldname2 : string;
  field1,field2 : THBasicField;
begin
  assert(FAutoSumFields<>nil);
  assert(FAutoSumFieldDefs<>nil);
  FAutoSumFieldDefs.clear;
  FAutoSumFields.Clear;
  if available then
  begin
    // bind Auto Sum Fields
    for i:=0 to FieldCount-1 do
    begin
      aAutoSumField:=nil;
      if Fields[i].fieldDef.AutoSum then
      begin
        assert(Fields[i].fieldDef.FieldType in [ftInteger,ftFloat,ftCurrency]);
        fieldDef := THFieldDef.Create;
        fieldDef.assign(Fields[i].fieldDef);
        fieldDef.Kind := fkAggregate;
        FAutoSumFieldDefs.add(fieldDef);
        fieldDef.ExtraDefinition := trim(fieldDef.ExtraDefinition);
        if pos('/',fieldDef.ExtraDefinition)>0 then
        begin
          fieldDef.FieldType := ftFloat;
          aAutoSumField:=THAggregatePercentField.create(self,fieldDef);
        end
        else
        case Fields[i].fieldDef.FieldType of
          ftInteger :
              aAutoSumField:=THAggregateIntField.create(self,fieldDef);
          ftFloat   :
              aAutoSumField:=THAggregateFloatField.create(self,fieldDef);
          ftCurrency:
              aAutoSumField:=THAggregateCurField.create(self,fieldDef);
        end;
        assert(aAutoSumField<>nil);
        aAutoSumField.BasedField := Fields[i];
        FAutoSumFields.add(aAutoSumField);
        //aAutoSumField.InitAggregate;
      end;
    end;
    for i:=0 to FAutoSumFields.count-1 do
    begin
      aAutoSumField:=THAggregateField(FAutoSumFields[i]);
      if aAutoSumField is THAggregatePercentField then
      begin
        fieldDef := aAutoSumField.fieldDef;
        k := pos('/',fieldDef.ExtraDefinition);
        fieldname1 := trim(copy(fieldDef.ExtraDefinition,1,k-1));
        fieldname2 := trim(copy(fieldDef.ExtraDefinition,k+1,length(fieldDef.ExtraDefinition)));
        field1 := FAutoSumFields.findField(fieldName1);
        field2 := FAutoSumFields.findField(fieldName2);
        THAggregatePercentField(aAutoSumField).BasedField := field1;
        THAggregatePercentField(aAutoSumField).ExtraField := field2;
      end;
      aAutoSumField.initSum;
    end;
  end;
end;
}

function THDataset.Get_floatFormat: WideString;
begin
  result := FfloatFormat;
end;

procedure THDataset.Set_floatFormat(const Value: WideString);
begin
  FfloatFormat := value;
end;

function THDataset.findFieldEx(aCatalog: THFieldCatalog;
  const afieldName: WideString): IHField;
var
  field : THBasicField;
begin
  field := findFieldEx2(aCatalog,afieldName);
  if field<>nil then
    result := field as IHField else
    result := nil;
end;

function THDataset.findFieldEx2(aCatalog: THFieldCatalog;
  const afieldName: WideString): THBasicField;
begin
  case aCatalog of
    fcResult : result := FFields.findField(afieldName);
    fcParam  : result := FParams.findField(afieldName);
    fcSum    : result := FSumFields.findField(afieldName);
    //fcAutoSum: result := FAutoSumFields.findField(afieldName);
  else result:=nil;
  end;
end;

function THDataset.empty: boolean;
begin
  result := bof and eof; 
end;

function THDataset.GetRecNo: integer;
begin
  result := FTextDB.Cursor;
end;

procedure THDataset.link2Response(autosearch: Boolean);
var
  rt : TDBResponseType;
begin
  if DBAccess.curResponseType<>rtDataset then
  begin
    if autosearch then
    begin
      rt := DBAccess.nextResponse;
      while not (rt in [rtNone,rtDataset]) do
      begin
        rt := DBAccess.nextResponse;
      end;
      if rt<>rtDataset then
        raise EDBNoDataset.create('there is no dataset');
    end else
      raise EDBNoDataset.create('there is no dataset');
  end;
end;

procedure THDataset.checkLinked;
begin
  link2Response(true);
end;

procedure THDataset.Notify(Sender: TObject; Event: TObjectEvent);
begin
  if (event is TDBEvent)  then
  begin
    if TDBEvent(event).EventType=etGone2NextResponse then
    begin
      // if it is searching response, not FReadAll!
      FReadAll := FFields.Count>0;
    end else
      FReadAll := true;
    case TDBEvent(event).EventType of
      etClosed,etFinished : doDoneReading;//Done := true;
      etDestroy : DBAccess:=nil;
    end;
  end;
end;

procedure THDataset.SetDBAccess(const Value: IDBAccess);
{var
  temp : IDBAccess;}
begin
  if FDBAccess <> Value then
  begin
    if FDBAccess<>nil then
    begin
      {temp := FDBAccess;
      FDBAccess:=nil;
      temp.removeListener(self);
      temp:=nil;}
      DBAccess.removeListener(self);
    end;
    doDoneReading;
    FDBAccess := Value;
    if DBAccess<>nil then
      DBAccess.addListener(self);
  end;
end;

function THDataset.Get_maxRows: Integer;
begin
  result := FmaxRows;
end;

procedure THDataset.Set_maxRows(Value: Integer);
begin
  FmaxRows:=value;
end;

procedure THDataset.doDoneReading;
begin
  if not Done then
  begin
    FReadAll:=true;
    FDone := true;
    if assigned(FAfterDoneReading) then
      FAfterDoneReading(self);
  end;
end;

function THDataset.GetCurrentRecordCount: Integer;
begin
  Result := FTextDB.Count;
end;

procedure THDataset.SetRecNo(const Value: integer);
begin
  //Assert(Done);
  while not Done and (Value>FTextDB.Count-1) do
    needData;
  FTextDB.Cursor := Value;
  {
  if Done or (Value<=FTextDB.Count-1) then
    FTextDB.Cursor := Value
  else
  begin

  end;
  }
end;

procedure THDataset.ClearAggregateFields;
begin
  FAggregateFieldDefs.Clear;
  FAggregateFields.Clear;
end;

function THDataset.NewAggregateFieldDef: THFieldDef;
begin
  Result := THFieldDef.Create;
  Result.Kind := fkAggregate;
  FAggregateFieldDefs.Add(Result);
end;

function THDataset.NewAggregateFieldDef(const FieldName: string;
  AggregatType: THAggregateType): THFieldDef;
begin
  Result := NewAggregateFieldDef;
  Result.FieldName := FieldName;
  Result.AggregateType := AggregatType;
end;

procedure THDataset.CreateAggregateFields;
var
  I : Integer;
  FieldDef,BasedFieldDef : THFieldDef;
  AggregateField : THAggregateField;
begin
  if AggregateFields.Count=0 then
  begin
    for I:=0 to AggregateFieldDefs.Count-1 do
    begin
      FieldDef := AggregateFieldDefs.fieldDefs[I];
      BasedFieldDef := fieldDefs.findDef(FieldDef.FieldName);
      AggregateField := nil;
      if (BasedFieldDef<>nil) and (FieldDef.AggregateType<>atNone) then
      begin
        FieldDef.FieldType := BasedFieldDef.FieldType;
        FieldDef.FieldSize := BasedFieldDef.FieldSize;
        FieldDef.Options := BasedFieldDef.Options;
        case FieldDef.FieldType of
          ftInteger : AggregateField := THAggregateIntField.Create(Self,FieldDef);
          ftFloat   : AggregateField := THAggregateFloatField.Create(Self,FieldDef);
          ftCurrency: AggregateField := THAggregateCurField.Create(Self,FieldDef);
          ftChar    : AggregateField := THAggregateStringField.Create(Self,FieldDef);
        end;
      end;
      AggregateFields.Add(AggregateField);
      if AggregateField<>nil then
        AggregateField.InitAggregate;
    end;
  end;
end;

function THDataset.HDataset_findField(
  const fieldName: WideString): IHField;
begin
  Result := findField(fieldName);
end;

function THDataset.HDataset_findFieldEx(aCatalog: THFieldCatalog;
  const afieldName: WideString): IHField;
begin
  Result := findFieldEx(aCatalog,afieldName);
end;

procedure THDataset.HDataset_first;
begin
  First;
end;

function THDataset.HDataset_Get_available: WordBool;
begin
  Result := Get_available;
end;

function THDataset.HDataset_Get_bof: WordBool;
begin
  Result := Get_bof;
end;

function THDataset.HDataset_Get_bookmark: Integer;
begin
  Result := Get_bookmark;
end;

function THDataset.HDataset_Get_eof: WordBool;
begin
  Result := Get_eof;
end;

function THDataset.HDataset_Get_fieldCount: Integer;
begin
  Result := Get_fieldCount;
end;

function THDataset.HDataset_Get_fields(index: Integer): IHField;
begin
  Result := Get_fields(index);
end;

function THDataset.HDataset_Get_outputCount: Integer;
begin
  Result := Get_outputCount;
end;

function THDataset.HDataset_Get_outputParams(index: Integer): IHParam;
begin
  Result := Get_outputParams(index);
end;

function THDataset.HDataset_Get_returnValue: Integer;
begin
  Result := Get_returnValue;
end;

function THDataset.HDataset_Get_sumFieldCount: Integer;
begin
  Result := Get_sumFieldCount;
end;

function THDataset.HDataset_Get_sumFields(index: Integer): IHParam;
begin
  Result := Get_sumFields(index);
end;

procedure THDataset.HDataset_last;
begin
  Last;
end;

procedure THDataset.HDataset_next;
begin
  Next;
end;

procedure THDataset.HDataset_prior;
begin
  Prior;
end;

procedure THDataset.HDataset_Set_bookmark(Value: Integer);
begin
  Set_bookmark(Value);
end;

{ THBasicField }

constructor THBasicField.Create(ADataset: THDataset; aDef: THFieldDef);
begin
  assert(ADataset<>nil);
  assert(aDef<>nil);
  //LogCreate(self);
  FDataset := ADataset;
  FfieldDef := aDef;
  FDisplayLength:=-1;
  ServerExceptionHandler := ADataset.ServerExceptionHandler;
  inherited CreateAggregated(getBDATypeLib,IHField,IUnknown(ADataset));
end;

destructor THBasicField.Destroy;
begin
  inherited;
  //LogDestroy(self);
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
  if not isNull then
  case FfieldDef.FieldType of
    ftInteger : if FstringFormat='' then
                  result:=value else
                  begin
                    intValue := value;
                    result := format(FstringFormat,[intValue]);
                  end;
    ftFloat   : {if FstringFormat='' then
                  result:=value else
                  begin
                    floatValue := value;
                    result := format(FstringFormat,[floatValue]);
                  end;}
                begin
                  floatValue := value;
                  if FstringFormat='' then
                    result := FormatFloat(FDataset.floatFormat,floatValue) else
                    result := FormatFloat(FstringFormat,floatValue);
                end;
    ftCurrency: begin
                  currencyValue := value;
                  if FstringFormat='' then
                    result := FormatCurr(FDataset.moneyFormat,currencyValue) else
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
                  begin
                    if isOnlyDate then
                      result := FormatDateTime(dataset.dateFormat,dateValue) else
                    if isOnlyTime then
                      result := FormatDateTime(dataset.timeFormat,dateValue) else
                      result := FormatDateTime(dataset.dateTimeFormat,dateValue);
                  end else
                    result := FormatDateTime(FstringFormat,dateValue);
                end;
    ftBinary,ftOther : result:='';
  end else
    result := ''; // for null value
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
{
function THBasicField.Get_Value: OleVariant;
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
    //buffer := FTextField.GetDataBuffer;
    if isNull then
      result := Unassigned else
    begin
      buffer := getDataBuffer;
      case FfieldDef.FieldType of
        ftInteger:  begin
                      move(Buffer^,intValue,sizeof(integer));
                      result := intValue;
                    end;
        ftFloat:    begin
                      move(Buffer^,floatValue,sizeof(double));
                      result := floatValue;
                    end;
        ftCurrency: begin
                      move(Buffer^,currencyValue,sizeof(currency));
                      result := currencyValue;
                    end;
        ftChar:     begin
                      charValue := pchar(Buffer);//FTextField.Value;
                      result := wideString(charValue);
                    end;
        ftDatetime: begin
                      move(Buffer^,dateValue,sizeof(TDateTime));
                      result := dateValue;
                    end;
        ftBinary,ftOther :
          result := NULL;
      end;
    end;
  end else
    if assigned(FOnGetValue) then
      FOnGetValue(self,result) else
      result := Unassigned;
end;
}

function THBasicField.Get_Value: OleVariant;
var
  intValue : integer;
  floatValue : double;
  dateValue : TDateTime;
  charValue : String;
  buffer : pchar;
  currencyValue : Currency;
begin
  if assigned(FOnGetValue) then
    FOnGetValue(self,result)
  else if isNull then
    result := Unassigned
  else
  begin
    buffer := getDataBuffer;
    if buffer=nil then
      result := Unassigned
    else
    begin
      case FfieldDef.FieldType of
        ftInteger:  begin
                      move(Buffer^,intValue,sizeof(integer));
                      result := intValue;
                    end;
        ftFloat:    begin
                      move(Buffer^,floatValue,sizeof(double));
                      result := floatValue;
                    end;
        ftCurrency: begin
                      move(Buffer^,currencyValue,sizeof(currency));
                      result := currencyValue;
                    end;
        ftChar:     begin
                      charValue := pchar(Buffer);//FTextField.Value;
                      {
                      if not (foFixedChar in FfieldDef.Options) and FfieldDef.autoTrim then
                        charValue := TrimRight(charValue);
                      }  
                      result := wideString(charValue);
                    end;
        ftDatetime: begin
                      move(Buffer^,dateValue,sizeof(TDateTime));
                      result := dateValue;
                    end;
        ftBinary,ftOther :
          result := NULL;
      end; // case
    end; // else ( buffer valid)
  end; // else (not is null)
end;

procedure THBasicField.Set_value(Value: OleVariant);
var
  intValue : integer;
  floatValue : double;
  dateValue : TDateTime;
  charValue : String;
  buffer : pchar;
  currencyValue : Currency;
  len : integer;
begin
  if FfieldDef.Kind=fkNormal then
  begin
    //buffer := FTextField.GetDataBuffer;
    if VarIsEmpty(value) then
      isNull := true else
    begin
      buffer := getDataBuffer;
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
                      len := length(charValue);
                      if len>FfieldDef.charSize then
                        len := FfieldDef.charSize;
                      move(pchar(charValue)^,Buffer^,len);
                    end;
        ftDatetime: begin
                      dateValue := value;
                      move(dateValue,Buffer^,sizeof(TDateTime));
                    end;
        ftBinary,ftOther : ;
      end;
    end;
  end else
  if assigned(FOnSetValue) then
    FOnSetValue(self,value);
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
{var
  afield : THBasicField;}
begin
  {
  if (FfieldDef<>nil) and (FfieldDef.Kind=fkNormal) and FfieldDef.AutoSum then
  begin
    afield := dataset.findFieldEx2(fcAutoSum,FfieldDef.FieldName);
    assert(afield<>self);
    if (afield<>nil) and (afield.stringFormat=FstringFormat) and (afield.stringFormat<>value) then
      afield.stringFormat := value;
  end;
  }
  FstringFormat := value;
end;

function THBasicField.Get_asDisplayText: WideString;
begin
  if Assigned(FOnGetDisplayText) then
    FOnGetDisplayText(self,result) else
    result := TrimRight(asString);
end;

procedure THBasicField.Set_asDisplayText(const Value: WideString);
begin
  if Assigned(FOnSetDisplayText) then
    FOnSetDisplayText(self,value) else
    asString:= value;
end;


function THBasicField.getDataBuffer: pointer;
begin
  result := nil;
end;

function THBasicField.Get_isNull: WordBool;
begin
  result := false;
end;

procedure THBasicField.Set_isNull(Value: WordBool);
begin
  // nothing
end;

procedure THBasicField.beep;
begin
  sysUtils.beep;
  outputDebugString('beep');
end;

function THBasicField.Get_isOnlyDate: WordBool;
begin
  result := FfieldDef.isOnlyDate;
end;

function THBasicField.Get_isOnlyTime: WordBool;
begin
  result := FfieldDef.isOnlyTime;
end;

procedure THBasicField.Set_isOnlyDate(Value: WordBool);
begin
  FfieldDef.isOnlyDate := value;
end;

procedure THBasicField.Set_isOnlyTime(Value: WordBool);
begin
  FfieldDef.isOnlyTime := value;
end;

function THBasicField.Get_displayLength: Integer;
begin
  if FDisplayLength<=0 then
  begin
    case FfieldDef.FieldType of
          ftInteger:  result:=MAX_Integer_Text_Size;
          ftFloat:    result:=MAX_Float_Text_Size;
          ftCurrency: result:=MAX_Currency_Text_Size;
          ftChar:     result:=FfieldDef.charSize;
          ftDatetime: result:=MAX_DateTime_Text_Size;
          else result:=1;
    end;
  end else
    result:=FDisplayLength;
end;

procedure THBasicField.Set_displayLength(Value: Integer);
begin
  FDisplayLength:=value;
end;

function THBasicField.HField_Get_asCurrency: Currency;
begin
  Result := Get_asCurrency;
end;

function THBasicField.HField_Get_asDatetime: TDateTime;
begin
  Result := Get_asDatetime;
end;

function THBasicField.HField_Get_asDisplayText: WideString;
begin
  Result := Get_asDisplayText;
end;

function THBasicField.HField_Get_asFloat: Double;
begin
  Result := Get_asFloat;
end;

function THBasicField.HField_Get_asInteger: Integer;
begin
  Result := Get_asInteger;
end;

function THBasicField.HField_Get_asString: WideString;
begin
  Result := Get_asString;
end;

function THBasicField.HField_Get_displayName: WideString;
begin
  Result := Get_displayName;
end;

function THBasicField.HField_Get_fieldName: WideString;
begin
  Result := Get_fieldName;
end;

function THBasicField.HField_Get_fieldSize: Integer;
begin
  Result := Get_fieldSize;
end;

function THBasicField.HField_Get_fieldType: THFieldType;
begin
  Result := Get_fieldType;
end;

function THBasicField.HField_Get_isNull: WordBool;
begin
  Result := Get_isNull;
end;

function THBasicField.HField_Get_stringFormat: WideString;
begin
  Result := Get_stringFormat;
end;

function THBasicField.HField_Get_Value: OleVariant;
begin
  Result := Get_Value;
end;

procedure THBasicField.HField_Set_asCurrency(Value: Currency);
begin
  Set_asCurrency(Value);
end;

procedure THBasicField.HField_Set_asDatetime(Value: TDateTime);
begin
  Set_asDatetime(Value);
end;

procedure THBasicField.HField_Set_asDisplayText(const Value: WideString);
begin
  Set_asDisplayText(Value);
end;

procedure THBasicField.HField_Set_asFloat(Value: Double);
begin
  Set_asFloat(Value);
end;

procedure THBasicField.HField_Set_asInteger(Value: Integer);
begin
  Set_asInteger(Value);
end;

procedure THBasicField.HField_Set_asString(const Value: WideString);
begin
  Set_asString(Value);
end;

procedure THBasicField.HField_Set_displayName(const Value: WideString);
begin
  Set_displayName(Value);
end;

procedure THBasicField.HField_Set_isNull(Value: WordBool);
begin
  Set_isNull(Value);
end;

procedure THBasicField.HField_Set_stringFormat(const Value: WideString);
begin
  Set_stringFormat(Value);
end;

procedure THBasicField.HField_Set_Value(Value: OleVariant);
begin
  Set_Value(Value);
end;

{ THField }

function THField.getDataBuffer: pointer;
begin
  if FTextField<>nil then
    result := FTextField.GetDataBuffer else
    result := nil;
end;

(* successful method
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
          FfieldDef.FieldSize {FTextField.Size});
    end;
  end;
end;
*)

procedure THField.ReadData;
var
  buffer : pchar;
begin
  if FfieldDef.isStored then
  begin
    //buffer := FTextField.GetDataBuffer;
    if FDataset.DBAccess.isNull(FfieldDef.FieldIndex) then
    begin
      isNull:=true;
      //writeLog(FfieldDef.FieldName+' isNull in THField',lcDebug);
    end  else
    begin
      isNull:=false;
      buffer := getDataBuffer;
      case FfieldDef.FieldType of
        ftInteger,ftFloat,ftCurrency,ftChar,ftDatetime:
        begin
          FDataset.DBAccess.readData2(
            FfieldDef,
            Buffer,
            FTextField.Size);
          if (FTextField<>nil) and (FfieldDef.FieldType=ftChar) and not (foFixedChar in FfieldDef.Options) and FfieldDef.autoTrim then
            FTextField.Value := TrimRight(FTextField.Value);
        end;
        ftBinary,ftOther :
          FDataset.DBAccess.readRawData(FfieldDef.FieldIndex,
            Buffer,
            FTextField.Size);
      end;
    end;
  end;
end;

function THField.Get_isNull: WordBool;
begin
  result := (FTextField.ExtraByte<>0);
end;


procedure THField.Set_isNull(Value: WordBool);
begin
  if value<>Get_isNull then
  begin
    if value then
      FTextField.ExtraByte := 1 else
      FTextField.ExtraByte := 0;
    FillChar(FTextField.GetDataBuffer^,FTextField.Size,0);
  end;
end;


// ParseFields add field from AllFields into Fields
// FieldsDesc indecates a field by name or by index
// fields are sperated by ';'
procedure ParseFields(
  const FieldsDesc:string;
  AllFields : THFields;
  Fields:TList;
  SpecailList : TList;
  var invalidFieldCount : integer;
  defaultAll : boolean=true;
  addNilField : boolean=true);
var
  restFields : string;
  i,k,n : integer;
  field : THBasicField;
  fieldDesc : string;
  notUseDisplayText : boolean;
begin
  restFields := Trim(FieldsDesc);
  invalidFieldCount := 0;
  if restFields='' then
  begin
    if defaultAll then
      // if restFields='' and defaultAll, add all available fields
      for i:=0 to AllFields.count-1 do
        Fields.add(AllFields[i]);
  end else
    while restFields<>'' do
    begin
      // bind specified fields
      // seperate a field desc
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
      // check the field
      field := nil;
      // whether use String(value) replacing asDisplayText ?
      notUseDisplayText := false;
      if (fieldDesc<>'') and (fieldDesc[1]='*') then
      begin
        notUseDisplayText := true;
        fieldDesc := copy(fieldDesc,2,length(fieldDesc));
      end;
      if fieldDesc<>'' then
        if fieldDesc[1]='#' then
        begin // bind by index
          try
            n := StrToInt(copy(fieldDesc,2,length(fieldDesc)));
            if (n>=0) and (n<AllFields.Count) then
              field := AllFields[n];
          except
            // for data convert exception
          end;
        end else
        begin // bind by name
          field := AllFields.findField(fieldDesc);
        end;
      if (field=nil) then
      begin
        if addNilField then
        begin
          Fields.add(nil);
          inc(invalidFieldCount);
        end;
      end else
      begin
        Fields.add(field);
        if notUseDisplayText and (SpecailList<>nil) then
          SpecailList.add(Pointer(Fields.count-1));
      end;
    end;
  {WriteLog(format('Render[%.8x] : Binded Fields : %d, Invaliad Field : %d',
    [integer(self),FBindedFields.count,invalidFieldCount]));}
end;

{ THBasicRander }

constructor THBasicRander.Create(aDataset: THDataset);
begin
  //LogCreate(self);
  FDataset := aDataset;
  //FDataset._AddRef;
  FIDataset := aDataset as IHDataset;
  FBindedFields := TList.Create;
  FBindedSumFields := TList.create;
  FSpecialFieldIndexs := TList.create;
  FSpecialSumFieldIndexs := TList.create;
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
  FSpecialFieldIndexs.clear;
  FBindedSumFields.clear;
  FSpecialSumFieldIndexs.clear;

  FisRenderSum := false;
  FSumFieldsDesc := '';
  doBindFields(bindFields);
end;


function THBasicRander.getData(rows: Integer): WideString;
begin
  try
    writeLog(format('Render[%.8x,tid:%.8x] rending data...',[integer(self),GetCurrentThreadId]),lcRender);
    if FDataset.available then
    begin
      FDataset.bookmark := FBookmark;
      result := internalGetData(rows);
      FBookmark := FDataset.bookmark;
      FFirst := false;
      inc(FSeq_NO);
    end else
    begin
      result := '';
      writeLog(format('Render[%.8x,tid:%.8x] dataset not available',[integer(self),GetCurrentThreadId]),lcRender);
    end;
  except
    result := '';
    WriteException;
  end;
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
  FSpecialSumFieldIndexs.free;
  FSpecialFieldIndexs.free;
  FBindedSumFields.free;
  FBindedFields.free;
  inherited;
  //LogDestroy(self);
end;

procedure THBasicRander.doBindFields(const bindFields: String);
var
  restFields : string;
  k : integer;
  invalidFieldCount : integer;
begin
  restFields := Trim(bindFields);
  k := pos('|',restFields);
  if k>0 then
  begin
    // will render sum fields
    FisRenderSum := true;
    FSumFieldsDesc := copy(restFields,k+1,length(restFields));
    restFields := Trim(copy(restFields,1,k-1));
  end;
  FBindedFields.clear;
  FSpecialFieldIndexs.clear;
  ParseFields(restFields,Dataset.Fields,FBindedFields,FSpecialFieldIndexs,invalidFieldCount,true,true);
  WriteLog(format('Render[%.8x] : Binded Fields : %d, Invaliad Field : %d',
    [integer(self),FBindedFields.count,invalidFieldCount]),lcRender);
end;

{
procedure THBasicRander.defaultBinding;
var
  i : integer;
begin
  // bind all available fields
  for i:=0 to FDataset.FieldCount-1 do
    FBindedFields.add(FDataset.Fields[i]);
end;
}
procedure THBasicRander.doBindSumFields;
var
  invalidFieldCount : integer;
begin
  FBindedSumFields.Clear;
  FSpecialSumFieldIndexs.Clear;
  {
  if FDataset.AutoSum and (FDataset.AutoSumFields.count>0) then
    // bind sum field by using FDataset.AutoSumFields
    ParseFields(FSumFieldsDesc,
      FDataset.AutoSumFields,
      FBindedSumFields,
      FSpecialSumFieldIndexs,
      invalidFieldCount,
      true,
      true)
  else }
    // bind sum field by using FDataset.SumFields
    ParseFields(FSumFieldsDesc,
      FDataset.SumFields,
      FBindedSumFields,
      FSpecialSumFieldIndexs,
      invalidFieldCount,
      true,
      true);
  WriteLog(format('Render[%.8x] : Bind Sum Fields : %d, Invaliad Field : %d',
    [integer(self),FBindedSumFields.count,invalidFieldCount]),lcRender);
end;

{ THBrowseRender }
{
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
}
const
  JSNewArray = '%0:s=new Array(%1:d);'#13#10
    + 'for (var i=0;i<%1:d;i++)'#13#10
    + '  %0:s[i]=new Array(%2:d);'#13#10
    + '%3:s';
function THBrowseRender.internalGetData(rows: Integer): string;
var
  renderRows : integer;
  i : integer;
  //col : integer;
  field : THBasicField;
  text : string;
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
    //col := 0;
    for i:=0 to FBindedFields.Count-1 do
    begin
      field := THBasicField(FBindedFields[i]);
      if field<>nil then
        if FSpecialFieldIndexs.IndexOf(pointer(i))>=0 then
          text := String(field.value) else
          text := field.asDisplayText
      else
        text := '';
      result := format('%s%s[%d][%d]="%s";'#13#10,
          [result,FGridName,renderRows,i{col},text])
      //inc(col);
    end;
    inc(renderRows);
    FDataset.next;
  end;
  if  renderRows=0 then
    result := FGridName+'=null;'#13#10 else
    //result := FGridName+'=new Array();'#13#10+result;
    result := format(JSNewArray,[FGridName,renderRows,FBindedFields.Count,result]);
  WriteLog(format('Browse Render[%.8x] : Render Rows : %d',
    [integer(self),renderRows]),lcRender);
  if FDataset.Eof and (FisRenderSum) then
  begin
    // render sum fields
    doBindSumFields;
    if FBindedSumFields.count>0 then
    begin
      Result := format('%s%s_sum=new Array(%d);'#13#10,
        [Result,FGridName,FBindedSumFields.count]);
      //Result := Result + FGridName+'_sum=new Array();'#13#10;
      for i:=0 to FBindedSumFields.count-1 do
      begin
        field := THBasicField(FBindedSumFields[i]);
        if field<>nil then
          if FSpecialSumFieldIndexs.indexof(pointer(i))>=0 then
            result := format('%s%s_sum[%d]="%s";'#13#10,
              [result,FGridName,i,string(field.value)]) else
            result := format('%s%s_sum[%d]="%s";'#13#10,
              [result,FGridName,i,field.asDisplayText])
        else
          result := format('%s%s_sum[%d]=null;'#13#10,
            [result,FGridName,i]);
      end;
    end else
      result := result + FGridName+'_sum=null;'#13#10;
    WriteLog(format('Browse Render[%.8x] : Render Sum Row.',[integer(self)]),lcRender);
  end;
end;

{ THPrintRender }
{
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
}
function THPrintRender.internalGetData(rows: Integer): string;
var
  renderRows : integer;
  i : integer;
  col : integer;
  field : THBasicField;
  text : string;
  textFieldSize : integer;
begin
  { TODO :
1 change the field size to display size
2 add sum feilds }
  renderRows := 0;

  result := '';
  if FFirst then
  begin
    // render field definition
    col := 0;
    for i:=0 to FBindedFields.Count-1 do
    begin
      field :=  THField(FBindedFields[i]);
      if col>0 then result:=result+',';
      if field<>nil then
      begin
        textFieldSize := Field.displayLength;
        with Field do
          result := format('%s"%s"="%s"[%d]',
          [result,
          packString(displayName,HTMLPackChars),
          packString(fieldName,HTMLPackChars),
          textFieldSize]);
      end else
        result := format('%s"%d"="%d"[%d]',
          [result,i,i,1]);
      inc(col);
    end;
    result := result + ';'#13#10;
  end;

  // render data row by row
  while ((rows<=0) or (renderRows<rows)) and not FDataset.Eof do
  begin
    col := 0;
    for i:=0 to FBindedFields.Count-1 do
    begin
      field := THField(FBindedFields[i]);
      if col>0 then result:=result+',';
      if field<>nil then
        if FSpecialFieldIndexs.IndexOf(pointer(i))>=0 then
          text := string(field.value) else
          text := field.asDisplayText
      else
        text := '';
      result := format('%s"%s"',
        [result,packString(text,HTMLPackChars)]);
      inc(col);
    end;
    result := result + ';'#13#10;
    inc(renderRows);
    FDataset.next;
  end;
  //if  renderRows=0 then result:='';
  if FDataset.Eof then result:=result+'.'#13#10;
  WriteLog(format('Print Render[%.8x] : Render Rows : %d',
    [integer(self),renderRows]),lcRender);

  if FDataset.Eof and (FisRenderSum) then
  begin
    // render sum fields
    doBindSumFields;
    if FBindedSumFields.count>0 then
    begin
      for i:=0 to FBindedSumFields.count-1 do
      begin
        field := THBasicField(FBindedSumFields[i]);
        if field<>nil then
          if FSpecialSumFieldIndexs.indexof(pointer(i))>=0 then
            result := format('%s"%s"="%s";'#13#10,
              [result,
              packString(field.fieldName,HTMLPackChars),
              packString(string(field.value),HTMLPackChars)]) else
            result := format('%s"%s"="%s";'#13#10,
              [result,
              packString(field.fieldName,HTMLPackChars),
              packString(field.asDisplayText,HTMLPackChars)]);
      end;
      result:=result+'.'#13#10;
    end;
    WriteLog(format('Print Render[%.8x] : Render Sum Row.',[integer(self)]),lcRender);
  end;
end;


{ THLookupField }

constructor THLookupField.Create(ADataset: THDataset; aDef: THFieldDef);
begin
  assert(aDef.kind=fkLookup);
  inherited;
end;

procedure THLookupField.SetlinkedField(const Value: THField);
begin
  FlinkedField := Value;
end;

{ THParam }

destructor THParam.Destroy;
begin
  if (FBuffer<>nil) then
  begin
    assert(FfieldDef<>nil);
    FreeMem(FBuffer,FfieldDef.charSize+1);
  end;
  inherited;
end;

function THParam.getDataBuffer: pointer;
begin
  result := FBuffer;
end;

procedure THParam.prepareBuffer;
begin
  if FBuffer=nil then
  begin
    GetMem(FBuffer,FfieldDef.charSize+1);
    FillChar(FBuffer^,FfieldDef.charSize+1,0);
  end;
end;

procedure THParam.ReadData;
begin
  if FfieldDef.Kind=fkNormal then
  begin
    assert(FfieldDef<>nil);
    prepareBuffer;
    //FIsNull := FDataset.DBAccess.
    case FfieldDef.FieldType of
      ftInteger,ftFloat,ftCurrency,ftChar,ftDatetime:
      begin
        FDataset.DBAccess.readOutput2(
          FfieldDef,
          FBuffer,
          FfieldDef.charSize);
      end;
      ftBinary,ftOther :
        FDataset.DBAccess.readRawOutput(FfieldDef.FieldIndex,
          FBuffer,
          FfieldDef.charSize);
    end;
  end;
end;

function THParam.Get_isNull: WordBool;
begin
  result := FIsNull;
end;

procedure THParam.Set_isNull(Value: WordBool);
begin
  FIsNull := Value;
end;

{ THSumParam }

constructor THSumParam.Create(ADataset: THDataset; aDef: THFieldDef);
begin
  assert(aDef.kind=fkSum);
  inherited;
end;

procedure THSumParam.ReadData;
begin
  //if FfieldDef.Kind=fkSum then
  begin
    assert(FfieldDef<>nil);
    prepareBuffer;
    case FfieldDef.FieldType of
      ftInteger,ftFloat,ftCurrency,ftChar,ftDatetime:
      begin
        FDataset.DBAccess.readComputeData2(
          FfieldDef,
          FBuffer,
          FfieldDef.charSize);
      end;
      ftBinary,ftOther :
        FDataset.DBAccess.readRawComputeData(FfieldDef.FieldIndex,
          FBuffer,
          FfieldDef.charSize);
    end;
  end;
end;

{ THListRender }

function THListRender.internalGetData(rows: Integer): string;
var
  listname,listnames,listvalues : string;
  i,renderRows : integer;
  field : THBasicField;
  text : string;
begin
  try
    listname:= FInitParam;
  except
    listname:= 'list';
  end;
  listnames := listname+'_names';
  listvalues := listname+'_values';
  result := '';
  renderRows := 0;
  if not Dataset.Eof then
  begin
    result := format('%s=new Array();%s=new Array();'#13#10,
      [listnames,listvalues]);
    for i:=0 to FBindedFields.count-1 do
    begin
      field := THBasicField(FBindedFields[i]);
      if field<>nil then
      begin
        if FSpecialFieldIndexs.IndexOf(pointer(i))>=0 then
          text := String(field.value) else
          text := field.asDisplayText;
        result := format('%s%s[%d]="%s";%s[%d]="%s";'#13#10,
          [result,listnames,i,field.fieldName,listvalues,i,text]);
      end;
    end;
    Dataset.next;
    inc(renderRows);
  end;
  WriteLog(format('List Render[%.8x] : Render Rows : %d',
      [integer(self),renderRows]),lcRender);
end;

{ THAggregateField }

constructor THAggregateField.Create(ADataset: THDataset; aDef: THFieldDef);
begin
  Assert(aDef.kind=fkAggregate);
  inherited;
  FBasedField := ADataset.findFieldEx2(fcResult,aDef.FieldName);
  CheckObject(FBasedField,'Error : Cannot Find BaseField '+aDef.FieldName);
  CheckParamValid;
end;

procedure THAggregateField.CheckParamValid;
begin
  CheckTrue(BasedField.fieldDef.FieldType=fieldDef.FieldType);
end;

procedure THAggregateField.DoneAggregate;
begin
  // do nothing
end;

procedure THAggregateField.InitAggregate;
begin
  FSpeedSum := (BasedField is THField);
  FFirst := True;
end;

procedure THAggregateField.ReadData;
begin
  // do nothing
  FFirst := False;
end;

type
  PInteger = ^Integer;
  PCurrency = ^Currency;
  PFloat = ^Double;

{ THAggregateIntField }

procedure THAggregateIntField.InitAggregate;
begin
  inherited;
  FAggregateValue := 0;
end;

procedure THAggregateIntField.AggregateOneRow;
var
  FieldValue : Integer;
begin
  if BasedField.isNull then
    Exit;
  if FSpeedSum then
    FieldValue := PInteger(THField(BasedField).getDataBuffer)^ else
    FieldValue := BasedField.asInteger;
  case fieldDef.AggregateType of
    atSum : Inc(FAggregateValue,FieldValue);
    atMax : if FFirst then
              FAggregateValue := FieldValue
            else if FieldValue>FAggregateValue then
              FAggregateValue := FieldValue;
    atMin : if FFirst then
              FAggregateValue := FieldValue
            else if FieldValue<FAggregateValue then
              FAggregateValue := FieldValue;
  end;
  FFirst := False;
end;

function THAggregateIntField.getDataBuffer: pointer;
begin
  Result := @FAggregateValue;
end;

procedure THAggregateIntField.CheckParamValid;
begin
  inherited;
  CheckTrue(fieldDef.FieldType=ftInteger,SFieldDataTypeError);
end;

{ THAggregateCurField }

procedure THAggregateCurField.InitAggregate;
begin
  inherited;
  FAggregateValue := 0;
end;

procedure THAggregateCurField.AggregateOneRow;
var
  FieldValue : Currency;
begin
  if BasedField.isNull then
    Exit;
  if FSpeedSum then
    FieldValue := PCurrency(THField(BasedField).getDataBuffer)^ else
    FieldValue := BasedField.asCurrency;
  case fieldDef.AggregateType of
    atSum : FAggregateValue := FAggregateValue + FieldValue;
    atMax : if FFirst then
              FAggregateValue := FieldValue
            else if FieldValue>FAggregateValue then
              FAggregateValue := FieldValue;
    atMin : if FFirst then
              FAggregateValue := FieldValue
            else if FieldValue<FAggregateValue then
              FAggregateValue := FieldValue;
  end;
  FFirst := False;
end;


function THAggregateCurField.getDataBuffer: pointer;
begin
  Result := @FAggregateValue;
end;

procedure THAggregateCurField.CheckParamValid;
begin
  inherited;
  CheckTrue(fieldDef.FieldType=ftCurrency,SFieldDataTypeError);
end;

{ THAggregateFloatField }

procedure THAggregateFloatField.InitAggregate;
begin
  inherited;
  FAggregateValue := 0;
end;

procedure THAggregateFloatField.AggregateOneRow;
var
  FieldValue : Double;
begin
  if BasedField.isNull then
    Exit;
  if FSpeedSum then
    FieldValue := PFloat(THField(BasedField).getDataBuffer)^ else
    FieldValue := BasedField.asFloat;
  case fieldDef.AggregateType of
    atSum : FAggregateValue := FAggregateValue + FieldValue;
    atMax : if FFirst then
              FAggregateValue := FieldValue
            else if FieldValue>FAggregateValue then
              FAggregateValue := FieldValue;
    atMin : if FFirst then
              FAggregateValue := FieldValue
            else if FieldValue<FAggregateValue then
              FAggregateValue := FieldValue;
  end;
  FFirst := False;
end;

function THAggregateFloatField.getDataBuffer: pointer;
begin
  Result := @FAggregateValue;
end;

procedure THAggregateFloatField.CheckParamValid;
begin
  inherited;
  CheckTrue(fieldDef.FieldType=ftFloat,SFieldDataTypeError);
end;

{ THAggregatePercentField }

procedure THAggregatePercentField.AggregateOneRow;
begin
  // do nothing
end;

procedure THAggregatePercentField.DoneAggregate;
var
  x,y : double;
begin
  if (BasedField<>nil) and (ExtraField<>nil) then
  begin
    x := BasedField.asFloat;
    y := ExtraField.asFloat;
    if abs(y)>1e-4 then
    begin
      try
        FAggregateValue := x * 100 / y;
      except

      end;
    end;
  end;
end;

{ THPrintListRender }

function THPrintListRender.internalGetData(rows: Integer): string;
var
  renderRows : integer;
  i : integer;
  field : THBasicField;
begin
  { TODO :
1 change the field size to display size
2 add sum feilds }
  renderRows := 0;

  result := '';
  // render one row
  if not FDataset.Eof then
  begin
    for i:=0 to FBindedFields.Count-1 do
    begin
        field := THBasicField(FBindedFields[i]);
        if field<>nil then
          if FSpecialFieldIndexs.indexof(pointer(i))>=0 then
            result := format('%s"%s"="%s";'#13#10,
              [result,
              packString(field.fieldName,HTMLPackChars),
              packString(string(field.value),HTMLPackChars)]) else
            result := format('%s"%s"="%s";'#13#10,
              [result,
              packString(field.fieldName,HTMLPackChars),
              packString(field.asDisplayText,HTMLPackChars)]);
    end;
    inc(renderRows);
    FDataset.next;
  end;
  result:=result+'.'#13#10;
  WriteLog(format('PrintList Render[%.8x] : Render Rows : %d',
    [integer(self),renderRows]),lcRender);
end;

var
  RenderTypes : TList=nil;
  RenderClasses : TList=nil;

procedure RegisterRenderClass(RenderType : THRenderType; RenderClass : THRenderClass);
begin
  assert(RenderClass<>nil);
  assert(RenderTypes<>nil);
  assert(RenderClasses<>nil);
  RenderTypes.add(Pointer(RenderType));
  RenderClasses.add(Pointer(RenderClass));
end;

function  getRenderClass(RenderType : THRenderType):THRenderClass;
var
  i : integer;
begin
  i:=RenderTypes.IndexOf(Pointer(RenderType));
  if i>=0 then
    result := THRenderClass(RenderClasses[i]) else
    result := nil;
end;

{ THParams }

function THParams.GetItems(index: integer): THParam;
begin
  Result := nil;
end;

{ THAggregateStringField }

procedure THAggregateStringField.AggregateOneRow;
var
  FieldValue : string;
begin
  if BasedField.isNull then
    Exit;
  FieldValue := BasedField.asString;
  case fieldDef.AggregateType of
    atMax : if FFirst then
              FAggregateValue := FieldValue
            else if FieldValue>FAggregateValue then
              FAggregateValue := FieldValue;
    atMin : if FFirst then
              FAggregateValue := FieldValue
            else if FieldValue<FAggregateValue then
              FAggregateValue := FieldValue;
  end;
  FFirst := False;
end;

procedure THAggregateStringField.CheckParamValid;
begin
  inherited;
  CheckTrue(fieldDef.FieldType=ftChar,SFieldDataTypeError);
end;

function THAggregateStringField.getDataBuffer: pointer;
begin
  Result := PChar(FAggregateValue);
end;

procedure THAggregateStringField.InitAggregate;
begin
  inherited;
  FAggregateValue := '';
end;

initialization
  RenderTypes:=TList.create;
  RenderClasses:=TList.create;
  RegisterRenderClass(rtBrowse,THBrowseRender);
  RegisterRenderClass(rtPrint,THPrintRender);
  RegisterRenderClass(rtList,THListRender);
  RegisterRenderClass(rtPrintList,THPrintListRender);

end.
