unit KCDataAccess;

interface

uses Windows,Classes,IntfUtils, DBAIntf, Listeners, DBAHelper, KCDataPack, BDAImpEx;

const
  // 日志类别
  lcKCDataset = 12;
  lcKCDatasetDetail = 19;
  
  OneSecond = 1000;
  OneMinute = 60*OneSecond;

  MinCheckTimeOut         = 5;    // 检查数据是否到达的最小的超时时间(毫秒)
  DefaultCheckDataTimeOut = OneSecond;  // 缺省的检查数据是否到达的超时时间(毫秒)
  DefaultTryReceiveCount  = 2;    // 接收数据时候缺省尝试的次数
  DefaultTryReceiveTimeOut= OneSecond; // 接收数据时候,如果接收到的第一个包是错误的，并且尝试次数大于1，后续尝试每次超时的时间(毫秒)

type
  EKCAccess = class(EDBAIntfHelper);

  TKCAccess = class;

  TKCPackageBuffer = array[0..MAXPACKAGESIZE-1] of Byte;

  TDoProgressEvent = procedure (Sender : TObject; TryCount : Integer; var ContinueReceive : Boolean) of object;
  TWaitDataEvent = procedure (Sender : TObject; var ContinueWait : Boolean) of object;

  {
    <Class>TKCAccess
    <What>实现通过金仕达通讯平台和一个特定的包结构访问数据库的对象。实现了关键的借口。
    <Properties>
      UserID - 用于标志登录用户的ID
      DestNo - 目的服务器编号
      FuncNo - 主功能号
      Priority-通讯优先级
      Timeout - 接收数据时候的超时（毫秒）
      SleepBetweenReceive - 如果受到一个空包，程序将继续发包收包，直到有数据为止。该属性规定在两次传送之间的间隔时间(毫秒)
        允许后台在处理一个长时间的查询的时候，可以先返回一些空包，表示心跳。
      IsCallback - 在接收数据的时候是否采用回调的形式（不断检查数据是否到达，同时回调OnWait）
      MaxTryReceiveCount - 接收数据时候缺省尝试的次数：
        等于1表示如果受到的一个数据包不正确，不再尝试继续接收数据。
        大于1，表示继续尝试接收的次数。
      TryReceiveTimeOut - 接收数据时候,如果接收到的第一个包是错误的，并且尝试次数大于1，后续尝试每次超时的时间(毫秒)
        这个时间可以比Timeout，可以较早的发现数据无法正确到达。
      CheckDataTimeOut - 在回调模式，每次检查数据是否到达的超时时间(毫秒)
    <Methods>
      -
    <Event>
      OnDoProgress - 如果受到一个空包，程序将继续发包收包，直到有数据为止。
        该事件在两次传送之间的被调用，可以用于更新屏幕显示。
        允许后台在处理一个长时间的查询的时候，可以先返回一些空包，表示心跳。
      OnWait       - 在回调模式检查数据是否到达的时候被调用，可以用于更新屏幕显示。
      AfterReceive - 在接收数据包以前被调用
      BeforeReceive- 在接收数据包以后被调用
  }
  TKCAccess = class(TDBAIntfHelper)
  private
    FHandle: THandle;
    FGatewayIP: string;
    FGatewayEncode: Word;
    FGatewayPort: Word;
    FReceiveBuffer : TKCPackageBuffer;
    FSendBuffer : TKCPackageBuffer;
    FReceiveHead : PSTDataHead;
    FReceiveBody : PByte;
    FSendHead : PSTDataHead;
    FSendBody : PByte;
    FReturn : Integer;
    FSendBindingIndexs : TList;
    FSendBindingOffsets : TList;
    FSendBodySize : Integer;
    FSendBufferReady : Boolean;
    FReceiveBufferReady : Boolean;
    FRecordCountInPackage : Integer;
    FHaveMorePackage : Boolean;
    FRecordIndexInPackage : Integer;
    FRecordBuffer : PByte;
    FNextRecordBuffer : PByte;
    FHaveVarCharFields : Boolean;
    FVarFieldStartIndex : Integer;
    FFixedRecordSize : Integer;
    FVarRecordSize : Integer;
    FReceiveBindingIndexs : TList;
    FReceiveBindingOffsets : TList;
    FReceiveBindingDataSizes : TList;
    FLastCmdCount : Integer;
    FPriority: Byte;
    FDestNo: Word;
    FFuncNo: Word;
    FUserID: Integer;
    FTimeout: LongWord;
    FSleepBetweenReceive: Integer;
    FOnDoProgress: TDoProgressEvent;
    FCookie : TSTCookie;
    FOnWait: TWaitDataEvent;
    FIsCallback: Boolean;
    FPackageCounter : LongWord;
    FAfterReceive: TNotifyEvent;
    FBeforeReceive: TNotifyEvent;
    FReceiving : Boolean;
    FMaxTryReceiveCount: Longword;
    FCheckDataTimeOut: Longword;
    FTryReceiveTimeOut: Longword;
    FWaitingFirstReturn : Boolean;
    FGatewayIP2: string;
    FGatewayPort2: Word;
    FConnectedIP: string;
    FConnectedPort: Word;
    procedure   CheckAPICall(Result : Boolean; const APIName:string);
    procedure   SendPackage(BufferSize : Integer);
    procedure   InternalRecievePackage(AnalysePackage : Boolean=True);
    procedure   RecievePackage(AnalysePackage : Boolean=True);
    procedure   CreateFields;
    procedure   CalculateVarParts;
    procedure   GetMorePackage;
    procedure   DoProgress(TryCount : Integer; var ContinueReceive : Boolean);
    procedure   DoWait(var ContinueWait : Boolean);
    procedure   ClearCookie;
    procedure   DumpSendBuffer;
    procedure   DumpReceiveBuffer;
    {$ifdef debug }
    procedure   DumpBuffer(Buffer : PByte);
    {$endif}
  protected
    property    Handle : THandle read FHandle;
    // InternalDoConnect be called when connect to server
    procedure   InternalDoConnect; override;
    // InternalDoDisConnect be called when disconnect to server
    procedure   InternalDoDisConnect; override;
    // InternalGetFieldCount be called when current response is a dataset
    function    InternalGetFieldCount : Integer; override;
    // InternalGetOutputCount be called when current response is a output
    function    InternalGetOutputCount : Integer; override;
    // InternalCancelResponse be called when user want not to get more response data.
    procedure   InternalCancelResponse; override;
    // InternalExec;
    procedure   InternalExec; override;
    // InternalExecRPC;
    procedure   InternalExecRPC; override;
    // produceResponseQueue;
    procedure   produceResponseQueue; override;
  public
    constructor Create(Counting : boolean=false);
    destructor  Destroy;override;
    property    GatewayIP : string read FGatewayIP write FGatewayIP;
    property    GatewayIP2 : string read FGatewayIP2 write FGatewayIP2;
    property    GatewayPort : Word read FGatewayPort write FGatewayPort;
    property    GatewayPort2 : Word read FGatewayPort2 write FGatewayPort2;
    property    GatewayEncode : Word read FGatewayEncode write FGatewayEncode;

    property    ConnectedIP : string read FConnectedIP;
    property    ConnectedPort : Word read FConnectedPort;

    // call
    { TODO : 暂时不支持输入变长的参数。要支持输入变长的参数，可以先把数据保存在结构里面，最后压缩包 }
    procedure   BeginDefineParam;
    function    AddParam(BindIndex : Integer):Integer; overload;
    function    AddParam(const BindName : string):Integer; overload;
    procedure   EndDefineParam;
    function    ParamCount : Integer;
    procedure   SetParamValue(ParamIndex : Integer; const Value : Byte); overload;
    procedure   SetParamValue(ParamIndex : Integer; const Value : Longint); overload;
    procedure   SetParamValue(ParamIndex : Integer; const Value : string); overload;
    procedure   SetParamValue(ParamIndex : Integer; const Value : Double); overload;
    procedure   CallGateway(RequestType : Integer);

    property    UserID : Integer read FUserID write FUserID;
    property    DestNo : Word read FDestNo write FDestNo;
    property    FuncNo : Word read FFuncNo write FFuncNo;
    property    Priority : Byte read FPriority write FPriority default 2;
    property    Timeout : LongWord read FTimeout write FTimeout default OneMinute;
    property    SleepBetweenReceive : Integer read FSleepBetweenReceive write FSleepBetweenReceive default OneSecond;
    property    IsCallback : Boolean read FIsCallback write FIsCallback default False;
    property    MaxTryReceiveCount : Longword read FMaxTryReceiveCount write FMaxTryReceiveCount default DefaultTryReceiveCount;
    property    TryReceiveTimeOut : Longword read FTryReceiveTimeOut write FTryReceiveTimeOut default DefaultTryReceiveTimeOut;
    property    CheckDataTimeOut : Longword read FCheckDataTimeOut write FCheckDataTimeOut default DefaultCheckDataTimeOut;
    property    OnDoProgress : TDoProgressEvent read FOnDoProgress write FOnDoProgress;
    property    OnWait : TWaitDataEvent read FOnWait write FOnWait;
    property    AfterReceive : TNotifyEvent read FAfterReceive write FAfterReceive;
    property    BeforeReceive : TNotifyEvent read FBeforeReceive write FBeforeReceive;

    // for interface
    function    rawDataToStd(rawType : integer; rawBuffer : pointer; rawSize : integer;
                  stdType : TDBFieldType; stdBuffer:pointer; stdSize:integer):integer; override;
    function    stdDataToRaw(rawType : Integer; rawBuffer : pointer; rawSize : Integer;
                  stdType : TDBFieldType; stdBuffer:pointer; stdSize:Integer):Integer; override;
    function    nextRow : Boolean; override;
    procedure   getFieldDef(index : integer; FieldDef : TDBFieldDef); override;
    function    fieldName(index : Integer) : string; override;
    function    FieldType(index : integer) : integer; override;
    function    FieldSize(index : integer) : integer; override;
    function    FieldIndex(afieldName:pchar): integer; override;
    function    FieldDataLen(index : integer) : integer; override;
    function    readData(index : Integer; dataType: TDBFieldType; buffer : pointer; buffersize : Integer) : Integer; override;
    function    readRawData(index : Integer; buffer : pointer; buffersize : Integer) : Integer; override;
    function    isNull(index:integer): boolean; override;
    procedure   getOutputDef(index : integer; FieldDef : TDBFieldDef); override;
    function    readOutput(index : Integer; dataType: TDBFieldType; buffer : pointer; buffersize : Integer) : Integer; override;
    function    readRawOutput(index : Integer; buffer : pointer; buffersize : Integer) : Integer; override;
    function    outputIsNull(index : Integer): boolean; override;
    function    readReturn(buffer : pointer; buffersize : Integer) : Integer; override;
    function    returnValue : integer; override;
    procedure   initRPC(rpcname : String; flags : Integer); override;
    procedure   setRPCParam(name : String; mode : TDBParamMode; datatype : TDBFieldType;
                  size : Integer; length : Integer; value : pointer; rawType : Integer); override;
  end;

  TKCDatabase = class(THDatabase)
  private
    FPriority: Byte;
    FUserID: Integer;
    FFuncNo: Word;
    FDestNo: Word;
    FGatewayIP: string;
    FGatewayEncode: Word;
    FGatewayPort: Word;
    FOnDoProgress: TDoProgressEvent;
    FTimeout: Integer;
    FSleepBetweenReceive: Integer;
    FOnWait: TWaitDataEvent;
    FIsCallback: Boolean;
    FBeforeReceive: TNotifyEvent;
    FAfterReceive: TNotifyEvent;
    FMaxTryReceiveCount: Longword;
    FCheckDataTimeOut: Longword;
    FTryReceiveTimeOut: Longword;
    FGatewayIP2: string;
    FGatewayPort2: Word;
    procedure   DoProgress(Sender : TObject; TryCount : Integer; var ContinueReceive : Boolean);
    procedure   DoWait(Sender : TObject; var ContinueWait : Boolean);
  protected
    function    newDBAccess : IDBAccess; override;
  public
    constructor Create(AOwner : TComponent); override;
    function    getDBAccess : IDBAccess; override;
    procedure   notUseDBAccess(aDBAccess : IDBAccess); override;
  published
    property    GatewayIP : string read FGatewayIP write FGatewayIP;
    property    GatewayIP2 : string read FGatewayIP2 write FGatewayIP2;
    property    GatewayPort : Word read FGatewayPort write FGatewayPort;
    property    GatewayPort2 : Word read FGatewayPort2 write FGatewayPort2;
    property    GatewayEncode : Word read FGatewayEncode write FGatewayEncode;
    property    DestNo : Word read FDestNo write FDestNo;
    property    FuncNo : Word read FFuncNo write FFuncNo;
    property    Priority : Byte read FPriority write FPriority  default 2;
    property    UserID : Integer read FUserID write FUserID;
    property    Timeout : Integer read FTimeout write FTimeout default OneMinute;
    property    SleepBetweenReceive : Integer read FSleepBetweenReceive write FSleepBetweenReceive default OneSecond;
    property    IsCallback : Boolean read FIsCallback write FIsCallback default False;
    property    MaxTryReceiveCount : Longword read FMaxTryReceiveCount write FMaxTryReceiveCount default DefaultTryReceiveCount;
    property    TryReceiveTimeOut : Longword read FTryReceiveTimeOut write FTryReceiveTimeOut default DefaultTryReceiveTimeOut;
    property    CheckDataTimeOut : Longword read FCheckDataTimeOut write FCheckDataTimeOut default DefaultCheckDataTimeOut;
    property    Connected;
    property    MaxConnection;
    property    MinConnection;
    property    OnDoProgress : TDoProgressEvent read FOnDoProgress write FOnDoProgress;
    property    OnWait : TWaitDataEvent read FOnWait write FOnWait;
    property    AfterReceive : TNotifyEvent read FAfterReceive write FAfterReceive;
    property    BeforeReceive : TNotifyEvent read FBeforeReceive write FBeforeReceive;
    property    OnConnected;
    property    OnDisConnected;
  end;

  TDatasetCallback = (cbSetByDatabase, cbNotCallBack, cbCallBack);

  TKCDataset = class(THCustomDataset)
  private
    FRequestType: Integer;
    FParams: THRPCParams;
    FReturnCode: Integer;
    FTimeout: Integer;
    FSleepBetweenReceive: Integer;
    FOnDoProgress: TDoProgressEvent;
    FFuncNo: Word;
    FOnWait: TWaitDataEvent;
    FBeforeReceive: TNotifyEvent;
    FAfterReceive: TNotifyEvent;
    FIsCallback: TDatasetCallback;
    FPriority: Byte;
    procedure   BindingParams(KCAccess : TKCAccess);
    procedure   SetParams(const Value: THRPCParams);
    procedure   DoProgress(Sender : TObject; TryCount : Integer; var ContinueReceive : Boolean);
    procedure   DoWait(Sender : TObject; var ContinueWait : Boolean);
    procedure   DoBeforeReceive(Sender : TObject);
    procedure   DoAfterReceive(Sender : TObject);
  protected
    procedure   InternalExec;  override;
    procedure   CloseDBAccess; override;
    function    ValidDatabase(const Value: THDatabase) : Boolean; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
    property    ReturnCode : Integer read FReturnCode;
  published
    property    FuncNo : Word read FFuncNo write FFuncNo default 0;
    property    RequestType : Integer read FRequestType write FRequestType;
    property    Params: THRPCParams read FParams write SetParams;
    property    Timeout : Integer read FTimeout write FTimeout default -1;
    property    Priority : Byte read FPriority write FPriority  default 0;
    property    SleepBetweenReceive : Integer read FSleepBetweenReceive write FSleepBetweenReceive default -1;
    property    IsCallback : TDatasetCallback read FIsCallback write FIsCallback default cbSetByDatabase;
    property    OnDoProgress : TDoProgressEvent read FOnDoProgress write FOnDoProgress;
    property    OnWait : TWaitDataEvent read FOnWait write FOnWait;
    property    AfterReceive : TNotifyEvent read FAfterReceive write FAfterReceive;
    property    BeforeReceive : TNotifyEvent read FBeforeReceive write FBeforeReceive;
  end;

procedure RaiseKCAccessError(const FormatStr : string; const Args: array of const); overload;

procedure RaiseKCAccessError(const Msg : string); overload;

procedure KCAccessCheck(OK : Boolean; const FormatStr : string; const Args: array of const); overload;

procedure KCAccessCheck(OK : Boolean; const Msg : string); overload;

{$ifdef TestPackError }
var
  TestPackError : Boolean= False;
{$endif}

implementation

uses SysUtils, DRTPAPI, LogFile, SafeCode;

resourcestring
  EAPICallFail      = '调用%s失败:%s';
  ECannotLoadDLL    = '无法装载DRTPAPI.DLL部件';
  EBindParam        = '无效的绑定参数%s';
  EBindParam2       = '无效的绑定参数%d';
  EDuplicateBind    = '重复绑定参数%d';
  EBindDataTypeError= '数据类型错误(%s)';
  EInvalidHandle    = '无效的句柄';
  EUserCanceled     = '用户取消接收返回数据';
  ETimeout          = '无法接收到返回数据';
  EBadPackage       = '返回数据不正确';
  EInvalidDataType  = '数据类型不正确';
  EInvalidDatabase  = '无效的数据库对象';
  EBadFlag          = '不正确的报文标志';
  EBadData          = '系统错误，错误代码%d';

procedure RaiseKCAccessError(const FormatStr : string; const Args: array of const); overload;
begin
  raise EKCAccess.CreateFmt(FormatStr, Args);
end;

procedure RaiseKCAccessError(const Msg : string); overload;
begin
  raise EKCAccess.Create(Msg);
end;

procedure KCAccessCheck(OK : Boolean; const FormatStr : string; const Args: array of const); overload;
begin
  if not OK then
    RaiseKCAccessError(FormatStr,Args);
end;

procedure KCAccessCheck(OK : Boolean; const Msg : string); overload;
begin
  if not OK then
    RaiseKCAccessError(Msg);
end;

{ TKCAccess }

constructor TKCAccess.Create(Counting : boolean=false);
begin
  KCAccessCheck(DRTPAPI.DLLLoaded,ECannotLoadDLL);
  inherited;
  FReceiveHead := PSTDataHead(@FReceiveBuffer[0]);
  FReceiveBody := PByte(FReceiveHead);
  Inc(FReceiveBody,SizeOf(FReceiveHead^));
  FSendHead := PSTDataHead(@FSendBuffer[0]);
  FSendBody := PByte(FSendHead);
  FSendBindingIndexs := TList.Create;
  FSendBindingOffsets := TList.Create;
  FReceiveBindingIndexs := TList.Create;
  FReceiveBindingOffsets := TList.Create;
  FReceiveBindingDataSizes := TList.Create;
  FSendBufferReady := False;
  FReceiveBufferReady := False;
  FTimeout := OneMinute;
  FSleepBetweenReceive := OneSecond;
  FIsCallback := False;
  FPackageCounter := 0;
  FPriority := 2;
  FMaxTryReceiveCount := DefaultTryReceiveCount;
  FCheckDataTimeOut := DefaultCheckDataTimeOut;
  FTryReceiveTimeOut := DefaultTryReceiveTimeOut;
  Inc(FSendBody,SizeOf(FSendHead^));
  FGatewayIP := '';
  FGatewayIP2 := '';
  FGatewayEncode := 0;
  FGatewayPort := 0;
  FGatewayPort2 := 0;
  ClearCookie;
end;

destructor TKCAccess.Destroy;
begin
  inherited;
  FreeAndNil(FSendBindingIndexs);
  FreeAndNil(FSendBindingOffsets);
  FreeAndNil(FReceiveBindingIndexs);
  FreeAndNil(FReceiveBindingOffsets);
  FreeAndNil(FReceiveBindingDataSizes);
end;

procedure TKCAccess.InternalDoConnect;

  procedure DoConnect(const AIP : string; APort : Word);
  begin
    FConnectedIP := AIP;
    FConnectedPort := APort;
    WriteLog(Format('IP=%s,Port=%d,Encode=%d',[FConnectedIP,FConnectedPort,GatewayEncode]),lcKCDataset);
    FHandle := DRTPConnect(PChar(FConnectedIP),FConnectedPort,GatewayEncode);
  end;

begin
  DoConnect(GatewayIP,GatewayPort);
  if (FHandle=0) and (GatewayIP2<>'') then
    DoConnect(GatewayIP2,GatewayPort2);
  FConnected := FHandle<>0;
  CheckAPICall(FConnected,'DRTPConnect');
end;

procedure TKCAccess.InternalDoDisConnect;
begin
  if Handle<>0 then
    DRTPClose(Handle);
  FHandle := 0;
end;

procedure TKCAccess.CheckAPICall(Result: Boolean; const APIName: string);
var
  ErrorMsg : array[0..255] of char;
  Msg : string;
begin
  if not Result then
  begin
    if Handle<>0 then
    begin
      FillChar(ErrorMsg,SizeOf(ErrorMsg),0);
      DRTPGetLastError(Handle,PChar(@ErrorMsg),SizeOf(ErrorMsg)-1);
      Msg := PChar(@ErrorMsg);
    end else
      Msg := '';
    try
      WriteLog(Format('%s fail, close TKCAccess',[APIName]),lcKCDataset);
      Connected := False;
    except
      WriteException;
    end;
    raise EKCAccess.Create(Format(EAPICallFail,[APIName,Msg]));
  end;
end;

// call
procedure TKCAccess.BeginDefineParam;
begin
  DoBeforeExecute;
  FSendBindingIndexs.Clear;
  FSendBindingOffsets.Clear;
  FReceiveBindingIndexs.Clear;
  FReceiveBindingOffsets.Clear;
  FReceiveBindingDataSizes.Clear;
  FillChar(FSendBuffer,SizeOf(FSendBuffer),0);
  FillChar(FReceiveBuffer,SizeOf(FReceiveBuffer),0);
  FSendBufferReady := False;
  FReceiveBufferReady := False;
  //KCClearParamBits(FSendHead^.ParamBits);
end;

function TKCAccess.AddParam(const BindName: string): Integer;
var
  I : Integer;
begin
  for I:=0 to PARAMBITS-1 do
  begin
    if SameText(BindName,KCPackDataNames[I]) then
    begin
      Result := AddParam(I);
      Exit;
    end;
  end;
  Result := -1;
  RaiseKCAccessError(EBindParam,[BindName]);
end;

function TKCAccess.AddParam(BindIndex: Integer): Integer;
begin
  KCAccessCheck(
    not (KCPackDataTypes[BindIndex] in [kcEmpty,kcVarChar]),
    EBindParam2,
    [BindIndex]);
  KCAccessCheck(
    FSendBindingIndexs.IndexOf(Pointer(BindIndex))<0,
    EDuplicateBind,
    [BindIndex]);
  Result := FSendBindingIndexs.Add(Pointer(BindIndex));
  FSendBindingOffsets.Add(Pointer(0));
end;

procedure TKCAccess.EndDefineParam;
var
  I,J : Integer;
  BindIndex : Integer;
  ByteIndex : Integer;
  Mask : Byte;
begin
  FSendBodySize := 0;
  Assert(FSendBindingIndexs.Count=FSendBindingOffsets.Count);
  for I:=0 to FSendBindingIndexs.Count-1 do
  begin
    BindIndex := Integer(FSendBindingIndexs[I]);
    ByteIndex := BindIndex div BITSPERBYTE;
    Mask := 1;
    Mask := Mask shl (BindIndex mod BITSPERBYTE);
    FSendHead^.ParamBits[ByteIndex] := FSendHead^.ParamBits[ByteIndex] or Mask;
    Inc(FSendBodySize,KCPackDataSizes[BindIndex]);
    for J:=0 to FSendBindingOffsets.Count-1 do
    begin
      if Integer(FSendBindingIndexs[J])>BindIndex then
        FSendBindingOffsets[J]:=Pointer(Integer(FSendBindingOffsets[J])+KCPackDataSizes[BindIndex]);
    end;
  end;
  FSendBufferReady := True;
  {$ifdef debug }
  //KCDumpParamBits(FSendHead^.ParamBits);
  WriteLog('Offsets',lcKCPack);
  for I:=0 to FSendBindingIndexs.Count-1 do
  begin
    WriteLog(Format('%s : %d',[KCPackDataNames[Integer(FSendBindingIndexs[I])],Integer(FSendBindingOffsets[I])]),lcKCPack);
  end;
  {$endif}
end;

function TKCAccess.ParamCount: Integer;
begin
  Result := FSendBindingIndexs.Count;
end;

procedure TKCAccess.SetParamValue(ParamIndex: Integer;
  const Value: Longint);
var
  Data : PByte;
begin
  KCAccessCheck(
    (KCPackDataSizes[Integer(FSendBindingIndexs[ParamIndex])]=SizeOf(Longint))
      and (KCPackDataTypes[Integer(FSendBindingIndexs[ParamIndex])]=KCInteger),
    EBindDataTypeError,
    ['Integer']);
  Data := FSendBody;
  Inc(Data,Integer(FSendBindingOffsets[ParamIndex]));
  Move(Value,Data^,SizeOf(Value));
end;

procedure TKCAccess.SetParamValue(ParamIndex: Integer; const Value: Byte);
var
  Data : PByte;
begin
  KCAccessCheck(
    (KCPackDataSizes[Integer(FSendBindingIndexs[ParamIndex])]=SizeOf(Byte))
      and (KCPackDataTypes[Integer(FSendBindingIndexs[ParamIndex])]=KCInteger),
    EBindDataTypeError,
    ['Byte']);
  Data := FSendBody;
  Inc(Data,Integer(FSendBindingOffsets[ParamIndex]));
  Move(Value,Data^,SizeOf(Value));
end;

procedure TKCAccess.SetParamValue(ParamIndex: Integer;
  const Value: Double);
var
  Data : PByte;
begin
  KCAccessCheck(
    (KCPackDataSizes[Integer(FSendBindingIndexs[ParamIndex])]=SizeOf(Double))
      and (KCPackDataTypes[Integer(FSendBindingIndexs[ParamIndex])]=KCFloat),
    EBindDataTypeError,
    ['Double']);
  Data := FSendBody;
  Inc(Data,Integer(FSendBindingOffsets[ParamIndex]));
  Move(Value,Data^,SizeOf(Value));
end;

procedure TKCAccess.SetParamValue(ParamIndex: Integer;
  const Value: string);
var
  Data : PByte;
begin
  KCAccessCheck(
    KCPackDataTypes[Integer(FSendBindingIndexs[ParamIndex])] in [kcChar,kcBit],
    EBindDataTypeError,
    ['String']);
  Data := FSendBody;
  Inc(Data,Integer(FSendBindingOffsets[ParamIndex]));
  case KCPackDataTypes[Integer(FSendBindingIndexs[ParamIndex])] of
    kcChar : KCPutStr(Data^,KCPackDataSizes[Integer(FSendBindingIndexs[ParamIndex])],Value);
    kcBit : PackChars2Bits(PChar(Value),Length(Value),Data,KCPackDataSizes[Integer(FSendBindingIndexs[ParamIndex])]);
    else Assert(False);
  end;
end;

procedure TKCAccess.CallGateway(RequestType : Integer);
var
  Size : Integer;
begin
  KCAccessCheck(FHandle<>0,EInvalidHandle);
  FReceiving := False;
  FWaitingFirstReturn := True;
  FSendHead^.RequestType := RequestType;
  FSendHead^.FirstFlag := 1;
  FSendHead^.NextFlag := 0;
  FSendHead^.RecCount := 1;
  FSendHead^.RetCode := 0;
  FSendHead^.Cookie := FCookie;
  Size := SizeOf(FSendHead^)+FSendBodySize;
  SendPackage(Size);
  DoAfterExecute;
end;

procedure TKCAccess.produceResponseQueue;
begin
  Assert(FCurResponseType=rtNone);
  Assert(FLastCmdCount<FCmdCount); // 每个请求只返回一个结果集
  FLastCmdCount:=FCmdCount;
  RecievePackage;
  if FReceiveBindingIndexs.Count>0 then
    putResponseSignal(rtDataset) else
  begin
    FEof := True;
    FDoneReading := True;
  end;
end;

procedure TKCAccess.InternalRecievePackage(AnalysePackage: Boolean);
  // 检查数据是否到达
  procedure DoCheckDataArrived(ReceiveTimeOut : Longword);
  var
    TimeOutForCheck : LongWord;
    DataOK : Boolean;
    ContinueWait : Boolean;
    StartTime : LongWord;
    CurTime : LongWord;
  begin
    if IsCallback then
    begin
      // 为DRTPCheckDataArrived获取最短的时间间隔
      TimeOutForCheck := CheckDataTimeOut;
      if (ReceiveTimeOut>0) and (TimeOutForCheck>ReceiveTimeOut) then
        TimeOutForCheck := ReceiveTimeOut;
      if TimeOutForCheck<MinCheckTimeOut then
        TimeOutForCheck := MinCheckTimeOut;
      ContinueWait := True;
      // 记录起始时间
      StartTime := GetTickCount;
      repeat
        // 检查数据是否到达
        DataOK := DRTPCheckDataArrived(FHandle,TimeOutForCheck);
        if not DataOK then
        begin
          // 如果没有到达，检查是否继续等待
          DoWait(ContinueWait);
          // 检查是否被用户取消
          KCAccessCheck(ContinueWait,EUserCanceled);
          if ContinueWait and (ReceiveTimeOut>0) then
          begin
            //检查时间是否超过timeout
            CurTime := GetTickCount;
            if (CurTime-StartTime>ReceiveTimeOut)
              or (CurTime<StartTime) then
              ContinueWait := False;
          end;
        end;
      until DataOK or not ContinueWait;
      // 如果数据没有到达，发生超时错误。
      KCAccessCheck(DataOk,ETimeout);
    end;
  end;

  function  IsPackageOK : Boolean;
  begin
    Result := (FPackageCounter=FReceiveHead^.userdata) and // userdata要符合
      ( (FReceiveHead^.RequestType=FSendHead^.RequestType) or //RequestType要符合
        ((FSendHead^.FirstFlag=0) and (FSendHead^.NextFlag=0)) // 当是取消包的时候可以不要求RequestType
      );
    if FReceiveHead^.RequestType=400000 then
      Result := True;
    {$ifdef TestPackError }
    if Result and TestPackError then
    begin
      Result := False;
      WriteLog('Ignore Data For TestPackError!',lcKCPack);
    end;
    {$endif}
  end;

var
  DataSuccessfullyReceived : Boolean;
  ReceiveTimeOut : Longword;
  {$ifdef NoCheckPkNo}

  {$else}
  TryReceiveCount : Longword;
  {$endif}
begin
  {$ifdef NoCheckPkNo}

  {$else}
  TryReceiveCount := 0;
  {$endif}
  ReceiveTimeOut := TimeOut;
  // 循环接收，直到收到正确的数据包或者错误次数过多，产生意外
  repeat
    // 检查数据是否到达
    DoCheckDataArrived(ReceiveTimeOut);
    // 接收数据
    CheckAPICall(DRTPReceive(FHandle,PChar(FReceiveHead),SizeOf(FReceiveBuffer),Timeout)>0,'DRTPReceive');
    // 检查数据包编号
    {$ifdef NoCheckPkNo}
    DataSuccessfullyReceived := True;
    {$else}
    if IsPackageOK then
    begin
      WriteLog('Successfully Received At Time '+IntToStr(GetTickCount),lcKCPack);
      DataSuccessfullyReceived := True; // 成功接受到正确的数据包
    end
    else
    begin
      // 收到错误的包
      WriteLog('Badly Received At Time '+IntToStr(GetTickCount),lcKCPack);
      DumpReceiveBuffer;
      DataSuccessfullyReceived := False;
      Inc(TryReceiveCount);
      ReceiveTimeOut := TryReceiveTimeOut;
      // 如果(包编号过大或者)连续接收的错误包数目过多，接收失败
      if {(FPackageCounter<FReceiveHead^.userdata) or }(TryReceiveCount>=MaxTryReceiveCount) then
        RaiseKCAccessError(EBadPackage);
    end;
    {$endif}
  until DataSuccessfullyReceived;
  // 收到正确的数据包
  FCookie := FReceiveHead^.Cookie;

  if AnalysePackage then
  begin
    // 分析接受到的数据报
    DumpReceiveBuffer;
    FReceiveBufferReady := True;
    FReturn := FReceiveHead^.RetCode;
    FHaveMorePackage := FReceiveHead^.NextFlag=1;
    FRecordCountInPackage := FReceiveHead^.RecCount;
    FRecordIndexInPackage := 0;
    FNextRecordBuffer := FReceiveBody;
    //FRecordBuffer := FReceiveBody;
    if FWaitingFirstReturn then
    begin
      // 如果等待第一个返回包，返回包标志正确=1，那么创建字段，否则错误
      if FReceiveHead^.FirstFlag=1 then
        CreateFields else
        RaiseKCAccessError(EBadFlag);
    end else
    begin
      // 如果不是第一个包，但是返回包标志=1，说明数据错误。
      if FReceiveHead^.FirstFlag=1 then
        RaiseKCAccessError(EBadData,[FReturn]);
    end;
  end;
end;

procedure TKCAccess.RecievePackage(AnalysePackage : Boolean=True);
begin
  FReceiveBufferReady := False;
  try
    try
      // 触发接收前的事件，例如完成禁止数据敏感控件的更新
      if IsCallback and Assigned(BeforeReceive) then
      begin
        WriteLog('BeforeReceive',lcKCPack);
        BeforeReceive(Self);
      end;
      InternalRecievePackage(AnalysePackage);
    finally
      FWaitingFirstReturn := False;
      // 触发接收后的事件，例如完成恢复数据敏感控件的更新
      if IsCallback and Assigned(AfterReceive) then
      begin
        WriteLog('AfterReceive',lcKCPack);
        AfterReceive(Self);
      end;
    end;
    if FSendHead.Cookie.UserID<>0 then
      UserID := FSendHead.Cookie.UserID;
  except
    // 如果发生错误，结束接收
    WriteLog('RecievePackage fail, close TKCAccess',lcKCDataset);
    Connected := False;
    FHaveMorePackage := False;
    FDoneReading := True;
    finished;
    raise;
  end;
end;

procedure TKCAccess.CreateFields;
var
  I,J : Integer;
  Mask : Byte;
  Count : Integer;
  AOffset : Integer;
begin
  Count := 0;
  AOffset := 0;
  FReceiveBindingIndexs.Clear;
  FReceiveBindingOffsets.Clear;
  FReceiveBindingDataSizes.Clear;
  FHaveVarCharFields := False;
  FFixedRecordSize := 0;
  FVarFieldStartIndex := 0;
  for I:=0 to ParamBitsSize-1 do
  begin
    Mask := 1;
    for J:=0 to BITSPERBYTE-1 do
    begin
      if (FReceiveHead^.ParamBits[I] and Mask)<>0 then
      begin
        Assert(KCPackDataTypes[Count]<>kcEmpty);
        FReceiveBindingIndexs.Add(Pointer(Count));
        FReceiveBindingOffsets.Add(Pointer(AOffset));
        FReceiveBindingDataSizes.Add(Pointer(KCPackDataSizes[Count]));
        if KCPackDataTypes[Count]<>kcVarChar then
        begin
          Assert(not FHaveVarCharFields); // 变长字段必须在最后面。(变长字段后面不能有定长字段)
          Inc(AOffset,KCPackDataSizes[Count]);
        end
        else if not FHaveVarCharFields then
        begin
          FVarFieldStartIndex := FReceiveBindingIndexs.Count-1;
          FHaveVarCharFields := True;
        end;
      end;
      Mask := Mask shl 1;
      Inc(Count);
    end;
  end;
  FFixedRecordSize := AOffset;
  if FReceiveBindingIndexs.Count=0 then
  begin
    WriteLog('No Fields',lcKCPack);
  end;
end;

procedure TKCAccess.GetMorePackage;
var
  TryCount : Integer;
  ContinueReceive : Boolean;
begin
  Assert(FHaveMorePackage);
  TryCount := 0;
  ContinueReceive := True;
  FSendHead.FirstFlag := 0;
  FSendHead.NextFlag := 1;
  FSendHead.RecCount := 0;
  repeat
    // 回调用户定义的函数，提供一个处理Windows消息和中断请求的机会。
    if TryCount>0 then
    begin
      DoProgress(TryCount, ContinueReceive);
      if not ContinueReceive then
      begin
        FHaveMorePackage := False;
        Break;
      end;
    end;
    {
    KCClearParamBits(FSendHead^.ParamBits);
    SendPackage(SizeOf(FSendHead^));
    }
    // 发送的时候附带Cookie，保留请求的参数
    FSendHead^.Cookie := FCookie;
    SendPackage(SizeOf(FSendHead^)+FSendBodySize);
    RecievePackage;
    Inc(TryCount);
  until (FRecordCountInPackage>0) or not FHaveMorePackage;
end;


// Dataset
function TKCAccess.nextRow: Boolean;
begin
  // 通过FReceiving标志，避免该方法重入(被间接地递归调用)
  if FReceiving then
  begin
    Result := False;
    WriteLog('Re-Enter TKCAccess.nextRow',lcDebug);
    Exit;
  end;
  FReceiving := True;
  try
    if (FRecordIndexInPackage>=FRecordCountInPackage) and FHaveMorePackage then
      GetMorePackage;

    if FRecordIndexInPackage<FRecordCountInPackage then
    begin
      Result := True;
      FRecordBuffer := FNextRecordBuffer;
      FVarRecordSize:=0;
      CalculateVarParts;
      Inc(FRecordIndexInPackage);
      Inc(FNextRecordBuffer,FFixedRecordSize+FVarRecordSize);
    end
    else
    begin
      Assert(not FHaveMorePackage);
      Result := False;
      FDoneReading := True;
    end;
    FEof := not Result;
  finally
    FReceiving := False;
  end;
end;

// Field
function TKCAccess.InternalGetFieldCount: Integer;
begin
  Result := FReceiveBindingIndexs.Count;
  Assert((Result=FReceiveBindingOffsets.Count) and (Result=FReceiveBindingDataSizes.Count));
end;

function TKCAccess.FieldDataLen(index: integer): integer;
begin
  //Result := KCPackDataSizes[Integer(FReceiveBindingIndexs[Index-1])];
  //Result := FieldSize(Index);
  Result := Integer(FReceiveBindingDataSizes[Index-1]);
  if KCPackDataTypes[Integer(FReceiveBindingIndexs[Index-1])]=kcBit then
    Result := Result * 8;
end;

function TKCAccess.FieldIndex(afieldName: pchar): integer;
var
  I : Integer;
begin
  for I:=0 to FReceiveBindingIndexs.Count-1 do
  begin
    if StrIComp(afieldName,PChar(KCPackDataNames[Integer(FReceiveBindingIndexs[I])]))=0 then
    begin
      Result := I;
      Exit;
    end;
  end;
  Result := -1;
end;

function TKCAccess.fieldName(index: Integer): string;
begin
  Result := KCPackDataNames[Integer(FReceiveBindingIndexs[Index-1])];
end;

function TKCAccess.FieldSize(index: integer): integer;
begin
  Result := KCPackDataSizes[Integer(FReceiveBindingIndexs[Index-1])];
  if KCPackDataTypes[Integer(FReceiveBindingIndexs[Index-1])]=kcBit then
    Result := Result * 8;
  {if KCPackDataTypes[Integer(FReceiveBindingIndexs[Index-1])] in [kcChar,kcVarChar] then
    Dec(Result); // exclude #0}
end;

function TKCAccess.FieldType(index: integer): integer;
begin
  Result := Ord(KCPackDataTypes[Integer(FReceiveBindingIndexs[Index-1])]);
end;

procedure TKCAccess.getFieldDef(index: integer; FieldDef: TDBFieldDef);
begin
  FieldDef.FieldIndex := index;
  FieldDef.FieldName := fieldName(index);
  FieldDef.DisplayName := FieldDef.FieldName;
  FieldDef.RawType := FieldType(index);
  case TKCType(FieldDef.RawType) of
      kcChar,kcVarChar,kcBit : FieldDef.FieldType := ftChar;
      kcInteger : FieldDef.FieldType := ftInteger;
      kcFloat : FieldDef.FieldType:=ftFloat;
    else FieldDef.FieldType := ftOther;
  end;
  FieldDef.FieldSize := FieldSize(index);
  FieldDef.Options := []; // both varchar to trim right
end;

// Field Data
function TKCAccess.rawDataToStd(rawType: integer; rawBuffer: pointer;
  rawSize: integer; stdType: TDBFieldType; stdBuffer: pointer;
  stdSize: integer): integer;
var
  len : Integer;
begin
  { TODO : 增加数据类型转换 }
  Result := -1;
  case TKCType(RawType) of
    kcChar,kcVarChar : if (StdType=ftChar) then
                begin
                  fillChar(StdBuffer^,stdSize,0);
                  len := rawSize;
                  if len>=stdSize then
                    len := stdSize;
                  move(rawBuffer^,StdBuffer^,len);
                  result := len;
                end;
    kcInteger : if (StdType=ftInteger) {and (StdSize>=SizeOf(Longint))} then
                begin
                  if RawSize=1 then
                    FillChar(StdBuffer^,StdSize,0);
                  Result := SizeOf(Longint);
                  Move(RawBuffer^,StdBuffer^,rawSize);
                end;
    kcFloat   : if (StdType=ftFloat) and (StdSize>=SizeOf(Double)) then
                begin
                  Result := SizeOf(Double);
                  Move(RawBuffer^,StdBuffer^,Result);
                end;
    kcBit :     begin
                  Assert(StdType=ftChar);
                  Result := UnPackBits2Chars(RawBuffer,stdSize,stdBuffer,stdSize);
                end;
  end;
end;

function TKCAccess.readData(index: Integer; dataType: TDBFieldType;
  buffer: pointer; buffersize: Integer): Integer;
var
  Data : PByte;
  DataSize : Integer;
begin
  Data := FRecordBuffer;
  Inc(Data,Integer(FReceiveBindingOffsets[Index-1]));
  DataSize := Integer(FReceiveBindingDataSizes[Index-1]);
  Result := rawDataToStd(FieldType(index),Data,DataSize,DataType,buffer,buffersize);
end;

function TKCAccess.readRawData(index: Integer; buffer: pointer;
  buffersize: Integer): Integer;
begin
  Result := 0;
  NotSupport;
end;

function TKCAccess.stdDataToRaw(rawType: Integer; rawBuffer: pointer;
  rawSize: Integer; stdType: TDBFieldType; stdBuffer: pointer;
  stdSize: Integer): Integer;
begin
  Result := -1;
  NotSupport;
end;

function TKCAccess.isNull(index: integer): boolean;
begin
  Result := False;
end;

// Return Value
function TKCAccess.readReturn(buffer: pointer;
  buffersize: Integer): Integer;
begin
  if bufferSize>=SizeOf(FReturn) then
    Result := SizeOf(FReturn) else
    Result := buffersize;
  Move(FReturn,Buffer^,Result);
end;

function TKCAccess.returnValue: integer;
begin
  Result := FReturn;
end;

// Other
procedure TKCAccess.InternalCancelResponse;
begin
  WriteLog(Format('======== Cancel[%8.8x] ========',[Integer(Self)]),lcKCPack);
  FSendHead.FirstFlag := 0;
  FSendHead.NextFlag := 0;
  FSendHead.RecCount := 1;
  FSendHead.RetCode := 0;
  FSendHead.Cookie := FCookie;
  SendPackage(SizeOf(FSendHead^)+FSendBodySize);
  RecievePackage(False);
end;

// Not Support
procedure TKCAccess.InternalExec;
begin
  NotSupport;
end;

procedure TKCAccess.getOutputDef(index: integer; FieldDef: TDBFieldDef);
begin
  NotSupport;
end;

function TKCAccess.InternalGetOutputCount: Integer;
begin
  Result := 0;
  NotSupport;
end;

function TKCAccess.outputIsNull(index: Integer): boolean;
begin
  Result := True;
  NotSupport;
end;

function TKCAccess.readOutput(index: Integer; dataType: TDBFieldType;
  buffer: pointer; buffersize: Integer): Integer;
begin
  Result := 0;
  NotSupport;
end;

function TKCAccess.readRawOutput(index: Integer; buffer: pointer;
  buffersize: Integer): Integer;
begin
  Result := 0;
  NotSupport;
end;

procedure TKCAccess.initRPC(rpcname: String; flags: Integer);
begin
  NotSupport;
end;

procedure TKCAccess.setRPCParam(name: String; mode: TDBParamMode;
  datatype: TDBFieldType; size, length: Integer; value: pointer;
  rawType: Integer);
begin
  NotSupport;
end;

procedure TKCAccess.InternalExecRPC;
begin
  NotSupport;
end;

procedure TKCAccess.SendPackage(BufferSize: Integer);
begin
  Inc(FPackageCounter);
  FSendHead.userdata := FPackageCounter;
  FSendHead.Cookie.UserID := UserID;
  DumpSendBuffer;
  WriteLog(Format('Send At Time %d, to Server(IP=%s, Port=%d, Encode=%d, Dest=%d, FuncNo=%d, Priority=%d)',
    [GetTickCount, ConnectedIP, ConnectedPort, GatewayEncode, DestNo, FuncNo, Priority]),
    lcKCPack);
  CheckAPICall(DRTPSend(FHandle,DestNo,FuncNo,PChar(FSendHead),BufferSize,Priority,False),'DRTPSend');
end;

{$ifndef debug }

procedure TKCAccess.DumpSendBuffer(BufferSize : Integer);
begin

end;

procedure TKCAccess.DumpReceiveBuffer(BufferSize: Integer);
begin

end;

{$else}

procedure TKCAccess.DumpSendBuffer;
begin
  WriteLog(Format('======== Dump Send[%8.8x] ========',[Integer(Self)]),lcKCPack);
  DumpBuffer(PByte(FSendHead));
end;

procedure TKCAccess.DumpReceiveBuffer;
begin
  WriteLog(Format('======== Dump Receive[%8.8x] ========',[Integer(Self)]),lcKCPack);
  DumpBuffer(PByte(FReceiveHead));
end;

procedure TKCAccess.DumpBuffer(Buffer : PByte);
var
  Head : PSTDataHead;
  Body : PByte;
  RecordSize : Integer;
  RecordCount : Integer;
  Pack : TSTPack;
begin
  // 如果不对pack记日志，那么退出。（优化程序）
  if not (lcKCPack in LogCatalogs) then
    Exit;
  //WriteLog(Format('Dump Buffer Size=%d',[BufferSize]),lcKCPack);
  Head := PSTDataHead(Buffer);
  WriteLog(Format('RequestType=%d',[Head^.RequestType]),lcKCPack);
  WriteLog(Format('FirstFlag=%d',[Head^.FirstFlag]),lcKCPack);
  WriteLog(Format('NextFlag=%d',[Head^.NextFlag]),lcKCPack);
  WriteLog(Format('RecCount=%d',[Head^.RecCount]),lcKCPack);
  WriteLog(Format('RetCode=%d',[Head^.RetCode]),lcKCPack);
  WriteLog(Format('UserData=%d',[Head^.UserData]),lcKCPack);
  WriteLog(Format('Cookie.UserID=%d',[Head^.Cookie.UserID]),lcKCPack);
  WriteLog(Format('Cookie.hostname=%s',[KCGetStr(Head^.Cookie.HostName,SizeOf(Head^.Cookie.HostName))]),lcKCPack);
  WriteLog(Format('Cookie.queuename=%s',[KCGetStr(Head^.Cookie.queuename,SizeOf(Head^.Cookie.queuename))]),lcKCPack);
  WriteLog(Format('Cookie.queuetype=%d',[Head^.Cookie.queuetype]),lcKCPack);
  RecordCount := Head^.RecCount;
  KCDumpParamBits(Head^.ParamBits);
  Body := Buffer;
  Inc(Body,SizeOf(Head^));
  if lcKCPackDetail in LogCatalogs then
    while RecordCount>0 do
    begin
      RecordSize := KCUnPackData(Head^.ParamBits,Pack,Body);
      KCDumpPack(Pack);
      //Dec(BufferSize,RecordSize);
      Inc(Body,RecordSize);
      Dec(RecordCount);
    end;
end;

{$endif}


procedure TKCAccess.DoProgress(TryCount: Integer; var ContinueReceive : Boolean);
begin
  if FSleepBetweenReceive>0 then
    Sleep(FSleepBetweenReceive);
  if Assigned(FOnDoProgress) then
  begin
    FOnDoProgress(Self,TryCount, ContinueReceive);
  end;
end;

procedure TKCAccess.ClearCookie;
begin
  FillChar(FCookie,SizeOf(FCookie),0);
end;

procedure TKCAccess.CalculateVarParts;
var
  I : Integer;
  FieldIndexInPack : Integer;
  FieldDataSize : Word;
  PData : PChar;
  Offset : Integer;
begin
  // 计算变长部分
  Assert(FVarRecordSize=0);
  if FHaveVarCharFields then
  begin
    // 修改 FVarRecordSize 和 FReceiveBindingOffsets, FReceiveBindingDataSizes
    Assert(FVarFieldStartIndex<=FReceiveBindingIndexs.Count-1);
    PData := PChar(FRecordBuffer);
    Offset := FFixedRecordSize;
    Inc(PData,Offset);
    for I:=FVarFieldStartIndex to FReceiveBindingIndexs.Count-1 do
    begin
      FieldIndexInPack := Integer(FReceiveBindingIndexs[I]);
      Assert(KCPackDataTypes[FieldIndexInPack]=kcVarChar);
      Move(PData^,FieldDataSize,SizeOf(FieldDataSize)); // include #0
      Assert((KCPackDataSizes[FieldIndexInPack]>=FieldDataSize) and (FieldDataSize>0));
      Inc(PData,SizeOf(FieldDataSize));
      Inc(Offset,SizeOf(FieldDataSize));
      FReceiveBindingOffsets[I] := Pointer(Offset);
      FReceiveBindingDataSizes[I] := Pointer(FieldDataSize);
      Inc(Offset,FieldDataSize);
      Inc(PData,FieldDataSize);
      Inc(FVarRecordSize,FieldDataSize+SizeOf(FieldDataSize));
    end;
  end;
end;

procedure TKCAccess.DoWait(var ContinueWait: Boolean);
begin
  if Assigned(FOnWait) then
  begin
    FOnWait(Self, ContinueWait);
  end;
end;

{ TKCDatabase }

constructor TKCDatabase.Create(AOwner: TComponent);
begin
  KCAccessCheck(DRTPAPI.DLLLoaded,ECannotLoadDLL);
  FTimeout := OneMinute;
  FSleepBetweenReceive := OneSecond;
  FIsCallback := False;
  FPriority := 2;
  FMaxTryReceiveCount := DefaultTryReceiveCount;
  FCheckDataTimeOut := DefaultCheckDataTimeOut;
  FTryReceiveTimeOut := DefaultTryReceiveTimeOut;
  FGatewayIP := '';
  FGatewayIP2 := '';
  FGatewayEncode := 0;
  FGatewayPort := 0;
  FGatewayPort2 := 0;
  inherited;
end;

procedure TKCDatabase.DoProgress(Sender: TObject; TryCount: Integer;
  var ContinueReceive: Boolean);
begin
  if Assigned(FOnDoProgress) then
    FOnDoProgress(Sender,TryCount,ContinueReceive);
end;

procedure TKCDatabase.DoWait(Sender: TObject; var ContinueWait: Boolean);
begin
  if Assigned(FOnWait) then
    FOnWait(Sender,ContinueWait);
end;

function TKCDatabase.getDBAccess: IDBAccess;
var
  KCAccess : TKCAccess;
begin
  Result := inherited getDBAccess;
  if Result<>nil then
  begin
    KCAccess := TKCAccess(Result.getImplement);
    // reset DBAccess properties
    if Timeout>=0 then
      KCAccess.Timeout := Timeout;
    if SleepBetweenReceive>=0 then
      KCAccess.SleepBetweenReceive:= SleepBetweenReceive;
    KCAccess.FuncNo := FuncNo;
    KCAccess.IsCallback := IsCallback;
    KCAccess.UserID := UserID;
    KCAccess.Priority := Priority;
    KCAccess.MaxTryReceiveCount := MaxTryReceiveCount;
    KCAccess.TryReceiveTimeOut := TryReceiveTimeOut;
    KCAccess.CheckDataTimeOut := CheckDataTimeOut;
    Result.open;
  end;
end;

function TKCDatabase.newDBAccess: IDBAccess;
var
  KCAccess : TKCAccess;
begin
  KCAccess := TKCAccess.create(true);
  try
    KCAccess.DestNo := DestNo;
    KCAccess.FuncNo := FuncNo;
    KCAccess.Priority := Priority;
    KCAccess.UserID := UserID;
    KCAccess.GatewayIP := GatewayIP;
    KCAccess.GatewayPort := GatewayPort;
    KCAccess.GatewayIP2 := GatewayIP2;
    KCAccess.GatewayPort2 := GatewayPort2;
    KCAccess.GatewayEncode := GatewayEncode;
    KCAccess.Open;
  except
    FreeAndNil(KCAccess);
  end;
  if KCAccess<>nil then
  begin
    Result := KCAccess;
    writeLog('new dbaccess ok',lcKCDataset);
    //writeLog()
  end  else
  begin
    result := nil;
    writeLog('new dbaccess error!',lcKCDataset);
  end;
end;

procedure TKCDatabase.notUseDBAccess(aDBAccess: IDBAccess);
begin
  inherited;
  if (aDBAccess<>nil) and (TKCAccess(aDBAccess.getImplement).UserID<>0) then
  begin
    UserID := TKCAccess(aDBAccess.getImplement).UserID;
  end;
end;

{ TKCDataset }

constructor TKCDataset.Create(AOwner: TComponent);
begin
  KCAccessCheck(DRTPAPI.DLLLoaded,ECannotLoadDLL);
  inherited;
  FParams := THRPCParams.Create(self);
  FTimeout := -1;
  FSleepBetweenReceive := -1;
  FFuncNo := 0;
  FIsCallback := cbSetByDatabase;
  FPriority := 0;
end;

destructor TKCDataset.Destroy;
begin
  inherited;
  FParams.free;
end;

procedure TKCDataset.BindingParams(KCAccess : TKCAccess);
var
  I : Integer;
  Param : THRPCParam;
begin
  KCAccess.BeginDefineParam;
  for I:=0 to Params.Count-1 do
  begin
    Param := Params[I];
    KCAccess.AddParam(Param.Name);
  end;
  KCAccess.EndDefineParam;
  WriteLog(Format('TKCDataset.ParamCount=%d',[Params.Count]),lcKCDatasetDetail);
  for I:=0 to Params.Count-1 do
  begin
    Param := Params[I];
    case Param.DataType of
      ftInteger : KCAccess.SetParamValue(I,Param.AsInteger);
      ftFloat : KCAccess.SetParamValue(I,Param.AsFloat);
      ftChar : KCAccess.SetParamValue(I,Param.AsString);
    else
      RaiseKCAccessError(EInvalidDataType);
    end;
    WriteLog(Format('TKCDataset.%s=%s',[Param.Name,Param.AsString]),lcKCDatasetDetail);
  end;
end;

procedure TKCDataset.InternalExec;
var
  acs : IDBAccess;
  temp : TObject;
  KCAccess : TKCAccess;
begin
  //FreturnStatus:=0;
  acs := getDBAccess;
  temp := acs.getImplement;
  KCAccessCheck(temp is TKCAccess,EInvalidDatabase);
  KCAccess := TKCAccess(temp);
  BindingParams(KCAccess);
  if Timeout>=0 then
    KCAccess.Timeout := TimeOut;
  if SleepBetweenReceive>=0 then
    KCAccess.SleepBetweenReceive := SleepBetweenReceive;
  if FuncNo>0 then
    KCAccess.FuncNo := FuncNo;
  if Priority>0 then
    KCAccess.FuncNo := Priority;
  KCAccess.OnDoProgress := DoProgress;
  KCAccess.OnWait := DoWait;
  KCAccess.AfterReceive := DoAfterReceive;
  KCAccess.BeforeReceive := DoBeforeReceive;
  case IsCallback of
    cbNotCallBack : KCAccess.IsCallback := False;
    cbCallBack :    KCAccess.IsCallback := True;
  end;
  WriteLog(Format('FuncNo=%d,RequestType=%d',[KCAccess.FuncNo,RequestType]),lcKCDatasetDetail);
  KCAccess.CallGateway(RequestType);
  KCAccess.checkResponseQueue;
  FReturnCode := KCAccess.returnValue;
  FData.DBAccess :=  acs;
end;

procedure TKCDataset.SetParams(const Value: THRPCParams);
begin
  FParams := Value;
end;

procedure TKCDataset.CloseDBAccess;
begin
  if FData.DBAccess<>nil then
  begin
    WriteLog('TKCDataset.CloseDBAccess',lcKCDatasetDetail);
    TKCAccess(FData.DBAccess.getImplement).AfterReceive := nil;
    TKCAccess(FData.DBAccess.getImplement).BeforeReceive:= nil;
    TKCAccess(FData.DBAccess.getImplement).OnDoProgress := nil;
    TKCAccess(FData.DBAccess.getImplement).OnWait := nil;
    {
    if (TKCAccess(FData.DBAccess.getImplement).UserID<>0) and (Database<>nil) then
      TKCDatabase(Database).UserID := TKCAccess(FData.DBAccess.getImplement).UserID;
    }
  end;
  inherited;
end;

procedure TKCDataset.DoProgress(Sender: TObject; TryCount: Integer;
  var ContinueReceive: Boolean);
begin
  if Assigned(FOnDoProgress) then
    FOnDoProgress(Self,TryCount,ContinueReceive);
  if ContinueReceive and (Database is TKCDatabase) then
    TKCDatabase(Database).DoProgress(Self,TryCount,ContinueReceive);
end;

function TKCDataset.ValidDatabase(const Value: THDatabase): Boolean;
begin
  Result := Value is TKCDatabase;
end;

procedure TKCDataset.DoWait(Sender: TObject; var ContinueWait: Boolean);
begin
  if Assigned(FOnWait) then
    FOnWait(Self,ContinueWait);
  if ContinueWait and (Database is TKCDatabase) then
    TKCDatabase(Database).DoWait(Self,ContinueWait);
end;

procedure TKCDataset.DoBeforeReceive(Sender : TObject);
begin
  {
  不能使用DisableControls，否则产生严重错误！
  DisableControls;
  Inc(FDisableCouting);
  }
  if Assigned(BeforeReceive) then
    BeforeReceive(Sender);
  if Database<>nil then
  begin
    if Assigned(TKCDatabase(Database).BeforeReceive) then
      TKCDatabase(Database).BeforeReceive(Sender);
  end;
end;

procedure TKCDataset.DoAfterReceive(Sender : TObject);
begin
  {
  不能使用EnableControls，否则产生严重错误！
  EnableControls;
  Dec(FDisableCouting);
  }
  if Assigned(AfterReceive) then
    AfterReceive(Sender);
  if Database<>nil then
  begin
    if Assigned(TKCDatabase(Database).AfterReceive) then
      TKCDatabase(Database).AfterReceive(Sender);
  end;
end;

initialization
  if DRTPAPI.DLLLoaded then
    DRTPInitialize;

finalization
  if DRTPAPI.DLLLoaded then
    DRTPUninitialize;
end.
