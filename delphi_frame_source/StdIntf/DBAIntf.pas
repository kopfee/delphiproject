unit DBAIntf;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>DBAIntf
   <What>定义了访问数据源的抽象接口
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

{
  IDBAccess is a basic data access interface for internal usage.
  I recommend : The implements of IHDataset and other interfaces
should be based on IDBAccess.
}

interface

uses SysUtils,Listeners,classes;

type
  //TTriState = (tsUnknown,tsFalse,tsTrue);
  // 支持的字段数据类型
  TDBFieldType = (ftInteger,ftFloat,ftCurrency,ftChar,ftDatetime,ftBinary,ftOther);
  // 对数据类型的补充
  TDBFieldOption = (foFixedChar);
  TDBFieldOptions = set of TDBFieldOption;
  {
    <Class>TDBFieldDef
    <What>定义数据字段属性的类
    <Properties>
      FieldIndex - 字段在结果集中的索引(从左到右)，从1开始编号。
      FieldName - 字段名称
      DisplayName - 字段显示名称
      FieldType - 字段数据类型;
      FieldSize - 原始字段大小（bytes）
      RawType - 原始字段数据类型，由驱动程序提供
      Options - 对数据类型的补充;
      isOnlyDate -  如果是日期时间类型，是否仅包括日期部分
      isOnlyTime - 如果是日期时间类型，是否仅包括时间部分
      autoTrim  - 是否自动去掉字符类型右边的空格
    <Methods>
      -
    <Event>
      -
  }
  TDBFieldDef = class
  private
    FisOnlyDate: boolean;
    FisOnlyTime: boolean;
    FautoTrim: boolean;
    procedure SetIsOnlyDate(const Value: boolean);
    procedure SetIsOnlyTime(const Value: boolean);
  public
    FieldIndex : Integer; // indexed from 1
    FieldName : String;
    DisplayName : String;
    FieldType : TDBFieldType;
    FieldSize : Integer;  // the raw data size
    RawType :   Integer;    // the raw data type defined by the database driver
    Options :   TDBFieldOptions;
    property    isOnlyDate : boolean read FisOnlyDate write SetIsOnlyDate;
    property    isOnlyTime : boolean read FisOnlyTime write SetIsOnlyTime;
    property    autoTrim : boolean read FautoTrim write FautoTrim default true;
    constructor Create;
    procedure   assign(source : TDBFieldDef); virtual;
  end;

  //TDataReadMode = (rmRaw,rmChar);
  {
    <Class>EDBAccessError
    <What>数据源访问错误
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  EDBAccessError = class(Exception);
  {
    <Class>EDBUnsupported
    <What>调用了驱动程序不支持的操作
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  EDBUnsupported = class(EDBAccessError);
  {
    <Class>EDBNoDataset
    <What>返回无结果集
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  EDBNoDataset = class(EDBAccessError);

  {
    <Class>EInvalidDatabase
    <What>无效的数据库
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  EInvalidDatabase = class(Exception);

  {
    <Enum>TDBState
    <What>IDBAccess状态
    <Item>
      dsNotReady - 未连接
      dsReady - 准备好执行新命令
      dsBusy  - 正在处理命令（读取返回数据未完）
  }
  TDBState =(dsNotReady,dsReady,dsBusy);
  // 远过程调用(RPC)参数类型
  TDBParamMode=(pmUnknown,pmInput,pmOutput,pmInputOutput);
  {
    <Enum>TDBResponseType
    <What>数据源返回响应的类型
    <Item>
      rtNone  - 无
      rtDataset - 结果集
      rtReturnValue - 返回值
      rtOutputValue - RPC 输出参数
      rtError - 错误
      rtMessage - 文本信息
  }
  TDBResponseType=(rtNone,rtDataset, rtReturnValue, rtOutputValue, rtError, rtMessage);
  {
    <Enum>TDBEventType
    <What>IDBAccess触发的事件类型
    <Item>
      etOpened - 打开连接
      etClosed  - 关闭连接
      etBeforeExec  - 在执行命令以前
      etAfterExec - 在执行命令以后
      etGone2NextResponse - 处理到下一个响应
      etFinished  - 所有返回的响应处理完
      etDestroy - 实例被删除
  }
  TDBEventType = (etOpened,etClosed,etBeforeExec,etAfterExec,etGone2NextResponse,etFinished,etDestroy);
  {
    <Class>TDBEvent
    <What>IDBAccess触发的事件对象
    <Properties>
      EventType - 事件类型
    <Methods>
      -
    <Event>
      -
  }
  TDBEvent = class(TObjectEvent)
  public
    EventType : TDBEventType;
  end;
  {
    <Interface>IDBAccess
    <What>访问数据源的抽象接口
    <Properties>
      -
    <Methods>
      -
  }
  IDBAccess = interface
    ['{FFAD05C0-8CA8-11D3-AAFA-00C0268E6AE8}']
    // 0) 公共方法，打开/关闭数据源连接，以及获得连接状态
    procedure   open;
    procedure   close;
    function    state : TDBState;
    function    Ready : Boolean;
    function    CmdCount:Integer;
    // 0.1) 处理数据源响应的标准步骤
    function    nextResponse: TDBResponseType;
    function    curResponseType: TDBResponseType;
    procedure   finished;
    function    get_isMessageNotified:boolean;
    procedure   set_isMessageNotified(value:boolean);
    // 0.2) 支持Listener的方法，让外界可以知道内部发生的时间。通过IListener传递的是TDBEvent对象
    procedure   addListener(Listener : IListener);
    procedure   removeListener(Listener : IListener);
    // 0.3) 在标准数据类型(TDBFieldType)和数据源的原始数据类型之间进行的转换方法
    // raw data (base on database driver) to standard data type ( TDBFieldType )
    // return standard data size
    function    rawDataToStd(rawType : Integer; rawBuffer : pointer; rawSize : Integer;
                  stdType : TDBFieldType; stdBuffer:pointer; stdSize:Integer):Integer;
    function    stdDataToRaw(rawType : Integer; rawBuffer : pointer; rawSize : Integer;
                  stdType : TDBFieldType; stdBuffer:pointer; stdSize:Integer):Integer;
    // 0.4) 获得实现该接口的对象的实例
    function    getImplement : TObject;
    // 1) 通过SQL文本对数据源进行访问的方法
    function    GetSQLText : String;
    procedure   SetSQLText(const Value:String);
    property    SQLText : String read GetSQLText write SetSQLText;
    function    GetExtraSQLText : String;
    procedure   SetExtraSQLText(const Value:String);
    property    ExtraSQLText : String read GetExtraSQLText write SetExtraSQLText;
    procedure   exec;
    procedure   execSQL(const ASQLText : String);

    // 2) 处理返回结果集的方法
    // 2.1) 浏览结果集
    //function    hasDataset:TTriState;
    function    nextRow : Boolean;
    function    eof : Boolean;
    // 2.2) 获得字段的定义
    function    fieldCount : Integer;
    function    fieldName(index : Integer) : string;
    function    fieldType(index : Integer) : Integer;  //rawtype
    function    fieldSize(index : Integer) : Integer;
    function    fieldDataLen(index : Integer) : Integer;
    procedure   getFieldDef(index : Integer; FieldDef : TDBFieldDef);
    // 2.3) 读取字段的值
    function    readData(index : Integer; dataType: TDBFieldType; buffer : pointer; buffersize : Integer) : Integer;
    function    readData2(FieldDef : TDBFieldDef; buffer : pointer; buffersize : Integer) : Integer;
    function    readRawData(index : Integer; buffer : pointer; buffersize : Integer) : Integer;
    function    isNull(index:Integer): Boolean;
    // extend data read for data results
    function    fieldAsInteger(index:Integer): Integer;
    function    fieldAsFloat(index:Integer): Double;
    function    fieldAsDateTime(index:Integer): TDateTime;
    function    fieldAsString(index:Integer): String;
    function    fieldAsCurrency(index:Integer): Currency;
    // 2.4) 获取SQLServer, Sybase的COMPUTE字段信息的方法(在其他的驱动中不支持这种访问)
    // Returns the number of COMPUTE clauses in the current set of results
    function    cumputeClauseCount : Integer;
    // if isSupportCompute=false, nextRow will skip compute rows. default is false
    function    GetisSupportCompute : Boolean;
    procedure   setisSupportCompute(value : Boolean);
    property    isSupportCompute : Boolean read GetisSupportCompute write setisSupportCompute;
    function    isThisACumputeRow : Boolean;
    function    ComputeFieldCount : Integer;
    function    ComputeFieldType(index : Integer) : Integer;
    function    ComputeFieldSize(index : Integer) : Integer;
    function    ComputeFieldDataLen(index : Integer) : Integer;
    procedure   getComputeFieldDef(index : Integer; FieldDef : TDBFieldDef);
    function    readComputeData(index : Integer; dataType: TDBFieldType; buffer : pointer; buffersize : Integer) : Integer;
    function    readComputeData2(FieldDef : TDBFieldDef; buffer : pointer; buffersize : Integer) : Integer;
    function    readRawComputeData(index : Integer; buffer : pointer; buffersize : Integer) : Integer;
    function    computeIsNull(index : Integer): boolean;

    // 3) 获取输出参数信息
    //procedure   ReachOutputs;
    //function    hasOutput: TTriState;
    function    outputCount : Integer;
    procedure   getOutputDef(index : Integer; FieldDef : TDBFieldDef);
    function    readOutput(index : Integer; dataType: TDBFieldType; buffer : pointer; buffersize : Integer) : Integer;
    function    readOutput2(FieldDef : TDBFieldDef; buffer : pointer; buffersize : Integer) : Integer;
    function    readRawOutput(index : Integer; buffer : pointer; buffersize : Integer) : Integer;
    function    outputIsNull(index : Integer): boolean;

    // 4) 获取返回参数信息
    //procedure   ReachReturn;
    //function    hasReturn: TTriState;
    function    readReturn(buffer : pointer; buffersize : Integer) : Integer;
    function    returnValue : Integer;

    // 5) 通过RPC（例如存储过程）对数据源进行访问的方法
    procedure   initRPC(rpcname : String; flags : Integer);
    // if value=nil, it is a null value
    procedure   setRPCParam(name : String; mode : TDBParamMode; datatype : TDBFieldType;
                  size : Integer; length : Integer; value : pointer; rawType : Integer);
    procedure   execRPC;

    // 6) 获得数据源返回的信息
    procedure   getMessage(msg : TStrings);
    function    MessageText : string;
    // 7) 获得数据源返回的意外
    function    getError : EDBAccessError;
  end;

const
  // 标准数据长度
  StdDataSize : array[TDBFieldType] of Integer
    = (sizeof(Integer),sizeof(Double),Sizeof(Currency),0,Sizeof(TDatetime),0,0);

implementation

uses safeCode;

{ TDBFieldDef }

procedure TDBFieldDef.assign(source: TDBFieldDef);
begin
  FieldIndex := source.FieldIndex;
  FieldName := source.FieldName;
  DisplayName := source.DisplayName;
  FieldType := source.FieldType;
  FieldSize := source.FieldSize;
  RawType := source.RawType;
  FisOnlyDate := source.FisOnlyDate;
  FisOnlyTime := source.FisOnlyTime;
end;

constructor TDBFieldDef.Create;
begin
  FieldIndex := 0;
  FieldName := '';
  DisplayName := '';
  FieldType := ftOther;
  FieldSize := 0;
  RawType := 0;
  FisOnlyDate := false;
  FisOnlyTime := false;
  Options := [];
  FautoTrim := true;
end;

procedure TDBFieldDef.SetIsOnlyDate(const Value: boolean);
begin
  if FieldType<>ftDatetime then
  begin
    FisOnlyDate := false;
    FisOnlyTime := false;
  end else
  begin
    FisOnlyDate := Value;
    if FisOnlyDate then FisOnlyTime := false;
  end;
end;

procedure TDBFieldDef.SetIsOnlyTime(const Value: boolean);
begin
  if FieldType<>ftDatetime then
  begin
    FisOnlyDate := false;
    FisOnlyTime := false;
  end else
  begin
    FisOnlyTime := Value;
    if FisOnlyTime then FisOnlyDate := false;
  end;
end;

end.
