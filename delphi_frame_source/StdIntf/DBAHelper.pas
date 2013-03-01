unit DBAHelper;

interface

uses Windows, Classes, IntfUtils, DBAIntf, Listeners;

const
  lcDBAIntfHelper = 8;

type
  EDBAIntfHelper = class(EDBAccessError);

  TDBAIntfHelper = class(TVCLInterfacedObject,IDBAccess)
  private
    procedure   SetConnected(const Value: boolean);
    procedure   DoConnect;
    procedure   DoDisConnect;
  protected
    FConnected: boolean;
    FSQL: TStrings;
    FMessages: TStrings;
    FCmdCount : integer;
    FListenerSupport : TListenerSupport;
    Fstate : TDBState;
    FCurResponseType : TDBResponseType;
    FOutputCount : integer;
    FResponseQueue : TList;
    FDoneReading  : boolean;
    FisMessageNotified: boolean;
    FreadAllRows: boolean;
    FFieldCount : integer;
    FEof : boolean;
    procedure   trigerEvent(EventType : TDBEventType);
    procedure   DoBeforeExecute; virtual;
    procedure   DoAfterExecute;  virtual;
    procedure   checkFieldIndex(index : integer);
    procedure   checkResponseQueue;
    procedure   putResponseSignal(ResponseType:TDBResponseType);
    // abstract internal methods that must be implemented by sub-class
    // InternalDoConnect be called when connect to server
    procedure   InternalDoConnect; virtual; abstract;
    // InternalDoDisConnect be called when disconnect to server
    procedure   InternalDoDisConnect; virtual; abstract;
    // InternalGetFieldCount be called when current response is a dataset
    function    InternalGetFieldCount : Integer; virtual; abstract;
    // InternalGetOutputCount be called when current response is a output
    function    InternalGetOutputCount : Integer; virtual; abstract;
    // InternalCancelResponse be called when user want not to get more response data.
    procedure   InternalCancelResponse; virtual; abstract;
    // InternalExec;
    procedure   InternalExec; virtual; abstract;
    // InternalExecRPC;
    procedure   InternalExecRPC; virtual; abstract;
    // produceResponseQueue;
    procedure   produceResponseQueue; virtual; abstract;
  public
    constructor Create(Counting : boolean=false);
    destructor  Destroy;override;
    property    Connected   : boolean read FConnected write SetConnected;

    // 0) common
    procedure   Open;
    procedure   Close;
    function    state : TDBState;
    function    Ready : boolean;
    function    CmdCount:integer;
    // 0.1) common response process
    function    nextResponse: TDBResponseType; virtual;
    function    curResponseType: TDBResponseType;
    procedure   finished;
    //function    nextResult : boolean;
    function    get_isMessageNotified:boolean;
    procedure   set_isMessageNotified(value:boolean);
    property    isMessageNotified : boolean read FisMessageNotified write FisMessageNotified default false;
    // 0.2) Listener supports
    procedure   addListener(Listener : IListener);
    procedure   removeListener(Listener : IListener);
    // 0.3) data conversion
    // raw data (base on database driver) to standard data type ( TDBFieldType )
    function    rawDataToStd(rawType : integer; rawBuffer : pointer; rawSize : integer;
                  stdType : TDBFieldType; stdBuffer:pointer; stdSize:integer):integer; virtual; abstract;
    function    stdDataToRaw(rawType : Integer; rawBuffer : pointer; rawSize : Integer;
                  stdType : TDBFieldType; stdBuffer:pointer; stdSize:Integer):Integer; virtual; abstract;
    // 0.4) get implement
    function    getImplement : TObject;

    // 1) sql command supports
    property    SQL : TStrings read FSQL;
    function    GetSQLText : string;
    procedure   SetSQLText(const Value:string);
    property    SQLText : String read GetSQLText write SetSQLText;
    function    GetExtraSQLText : string; virtual;
    procedure   SetExtraSQLText(const Value:string); virtual;
    property    ExtraSQLText : String read GetExtraSQLText write SetExtraSQLText;
    procedure   Exec;
    procedure   ExecSQL(const aSQL:string);

    // 2) normal dataset supports
    // 2.1) browse dataset
    //function    hasDataset:TTriState;
    function    nextRow : Boolean; virtual; abstract;
    function    eof : Boolean;
    property    readAllRows : boolean read FreadAllRows write FreadAllRows default true;
    // 2.2) field definitions
    function    FieldCount  : Integer;
    // field index is fron 1 to FieldCount
    procedure   getFieldDef(index : integer; FieldDef : TDBFieldDef); virtual; abstract;
    function    fieldName(index : Integer) : string; virtual; abstract;
    function    FieldType(index : integer) : integer; virtual; abstract;
    function    FieldSize(index : integer) : integer; virtual; abstract;
    // FieldIndex : get field index by name(case-insensitive)
    function    FieldIndex(afieldName:pchar): integer; virtual; abstract;
    function    FieldDataLen(index : integer) : integer; virtual; abstract;
    // 2.3) read field values
    function    readData(index : Integer; dataType: TDBFieldType; buffer : pointer; buffersize : Integer) : Integer; virtual; abstract;
    function    readData2(FieldDef : TDBFieldDef; buffer : pointer; buffersize : Integer) : Integer;
    function    readRawData(index : Integer; buffer : pointer; buffersize : Integer) : Integer; virtual; abstract;
    // extend data read
    function    fieldAsInteger(index:integer): integer;
    function    fieldAsFloat(index:integer): double;
    function    fieldAsDateTime(index:integer): TDateTime;
    function    fieldAsString(index:integer): String;
    function    fieldAsCurrency(index:integer): Currency;
    function    isNull(index:integer): boolean; virtual; abstract;
    // 2.4) compute row supports for SQLServer, Sybase
    // if isSupportCompute=false, nextRow will skip compute rows. default is false
    function    cumputeClauseCount : integer; // Returns the number of COMPUTE clauses in the current set of results
    function    GetisSupportCompute : boolean;
    procedure   setisSupportCompute(value : boolean);
    property    isSupportCompute : boolean read GetisSupportCompute write setisSupportCompute default false;
    function    isThisACumputeRow : boolean;
    function    ComputeFieldCount : integer;
    function    ComputeFieldType(index : integer) : integer;
    function    ComputeFieldData(index : integer) : pointer;
    function    ComputeFieldSize(index : integer) : integer;
    function    ComputeFieldDataLen(index : integer) : integer;
    procedure   getComputeFieldDef(index : integer; FieldDef : TDBFieldDef);
    function    readComputeData(index : Integer; dataType: TDBFieldType; buffer : pointer; buffersize : Integer) : Integer;
    function    readComputeData2(FieldDef : TDBFieldDef; buffer : pointer; buffersize : Integer) : Integer;
    function    readRawComputeData(index : Integer; buffer : pointer; buffersize : Integer) : Integer;
    function    computeIsNull(index : Integer): boolean;

    // 3) output params supports
    //procedure   ReachOutputs;
    //function    hasOutput: TTriState;
    function    outputCount : Integer;
    procedure   getOutputDef(index : integer; FieldDef : TDBFieldDef); virtual; abstract;
    function    readOutput(index : Integer; dataType: TDBFieldType; buffer : pointer; buffersize : Integer) : Integer; virtual; abstract;
    function    readOutput2(FieldDef : TDBFieldDef; buffer : pointer; buffersize : Integer) : Integer;
    function    readRawOutput(index : Integer; buffer : pointer; buffersize : Integer) : Integer; virtual; abstract;
    function    outputIsNull(index : Integer): boolean; virtual; abstract;

    // 4) return value supports
    //procedure   ReachReturn;
    //function    hasReturn: TTriState;
    function    readReturn(buffer : pointer; buffersize : Integer) : Integer; virtual; abstract;
    function    returnValue : integer; virtual; abstract;

    // 5) RPC Supports
    procedure   initRPC(rpcname : String; flags : Integer); virtual; abstract;
    procedure   setRPCParam(name : String; mode : TDBParamMode; datatype : TDBFieldType;
                  size : Integer; length : Integer; value : pointer; rawType : Integer); virtual; abstract;
    procedure   execRPC;

    // 6) Message  Supports
    procedure   getMessage(msg : TStrings);
    function    MessageText : string;
    // 7) Error Supports
    function    getError : EDBAccessError;
  end;

procedure NotSupport(const method:string='');

implementation

uses SysUtils, LogFile;

procedure NotSupport(const method:string='');
begin
  raise EDBUnsupported.create('Not Support Thie Operation '+method);
end;

{ TDBAIntfHelper }

// constructor and destructor

constructor TDBAIntfHelper.Create(Counting : boolean=false);
begin
  inherited;
  FListenerSupport := TListenerSupport.Create(Self);
  FSQL := TStringList.Create;
  FMessages := TStringList.Create;
  Fstate := dsNotReady;
  FResponseQueue := TList.create;
  FisMessageNotified := false;
  FreadAllRows := true;
end;

destructor TDBAIntfHelper.Destroy;
begin
  trigerEvent(etDestroy);
  Connected := False;
  inherited;
  FreeAndNil(FListenerSupport);
  FreeAndNil(FResponseQueue);
  FreeAndNil(FMessages);
  FreeAndNil(FSQL);
end;

// Connect And DisConnect

procedure TDBAIntfHelper.SetConnected(const Value: boolean);
begin
  if FConnected <> Value then
    if Value then
      DoConnect else
      DoDisConnect;
end;

procedure TDBAIntfHelper.DoConnect;
begin
  InternalDoConnect;
  Fstate := dsReady;
  trigerEvent(etOpened);
end;

procedure TDBAIntfHelper.DoDisConnect;
begin
  Fstate := dsNotReady;
  InternalDoDisConnect;
  FConnected := false;
  FDoneReading:=true;
  FCurResponseType := rtNone;
  trigerEvent(etClosed);
end;

// Utility Functions

procedure TDBAIntfHelper.checkFieldIndex(index: integer);
begin
  if (index<=0) or (index>FFieldCount) then
    raise EDBAIntfHelper.create('Field index out of range');
end;

procedure TDBAIntfHelper.trigerEvent(EventType: TDBEventType);
var
  Event : TDBEvent;
begin
  writeLog('trigerEvent'+IntToStr(integer(EventType)),lcDBAIntfHelper);
  Event := TDBEvent.create;
  Event.EventType := EventType;
  FListenerSupport.notifyListeners2(event);
end;

procedure TDBAIntfHelper.DoAfterExecute;
begin
  trigerEvent(etAfterExec);
end;

procedure TDBAIntfHelper.DoBeforeExecute;
begin
  inc(FCmdCount);
  FFieldCount := 0;
  FMessages.Clear;
  Fstate := dsBusy;
  FCurResponseType := rtNone;
  FResponseQueue.clear;
  FDoneReading := false;
  trigerEvent(etBeforeExec);
end;

procedure TDBAIntfHelper.checkResponseQueue;
begin
  if (not FDoneReading) and (FResponseQueue.count=0) then
    produceResponseQueue;
end;

procedure TDBAIntfHelper.putResponseSignal(ResponseType: TDBResponseType);
begin
  if (ResponseType=rtMessage) then
    if not FisMessageNotified then
      exit
    else if FResponseQueue.IndexOf(pointer(ResponseType))>=0 then
      exit;
  FResponseQueue.add(pointer(ResponseType));
end;

// 0) common

procedure TDBAIntfHelper.Open;
begin
  Connected := true;
end;

procedure TDBAIntfHelper.Close;
begin
  Connected := false;
end;

function TDBAIntfHelper.state: TDBState;
begin
  result := Fstate;
end;

function TDBAIntfHelper.Ready: boolean;
begin
  result := FState<>dsNotReady;
end;

function TDBAIntfHelper.CmdCount: integer;
begin
  result := FCmdCount;
end;

// 0.1) common response process
function TDBAIntfHelper.nextResponse: TDBResponseType;
var
  skipCount : integer;
begin
  // triger event
  trigerEvent(etGone2NextResponse);
  // reset some status
  FOutputCount:=0;
  FFieldCount := 0;
  if FCurResponseType=rtMessage then FMessages.Clear
  else if (FCurResponseType=rtDataset) and not Feof and FreadAllRows then
  begin
    skipCount := 0;
    while nextRow do
      inc(skipCount);
    writeLog('skip rows:'+IntToStr(skipCount),lcDBAIntfHelper);
  end;

  checkResponseQueue;
  // consume Response Queue
  if FResponseQueue.Count=0 then
  begin
    finished;
  end else
  begin
    FCurResponseType := TDBResponseType(FResponseQueue[0]);
    FResponseQueue.Delete(0);
  end;
  result := FCurResponseType;
  case result of
    rtNone        : ;
    rtDataset     : begin
                      FFieldCount := InternalGetFieldCount;
                      Feof := false;
                    end;
    rtReturnValue : ;
    rtOutputValue  : begin
                      FOutputCount:= InternalGetOutputCount;
                    end;
    rtError       : ;
    rtMessage     : ;
  end;
  writeLog('nextResponse:'+IntToStr(Integer(result)),lcDBAIntfHelper);
  //checkSQLError;
end;

function TDBAIntfHelper.curResponseType: TDBResponseType;
begin
  result := FCurResponseType;
end;

procedure TDBAIntfHelper.finished;
begin
  if not FDoneReading or (FCurResponseType<>rtNone) or (Fstate <> dsReady) then
  begin
    if not FConnected then exit;
    try
      if not FDoneReading then
      begin
        // 消除在InternalCancelResponse时候产生错误，循环调用finished的情况。
        FDoneReading:=true;
        InternalCancelResponse;
      end;
    finally
      //checkOpened;
      FDoneReading:=true;
      FCurResponseType := rtNone;
      Fstate := dsReady;
      trigerEvent(etFinished);
    end;
  end;
end;

function TDBAIntfHelper.get_isMessageNotified: boolean;
begin
  result := FisMessageNotified;
end;

procedure TDBAIntfHelper.set_isMessageNotified(value: boolean);
begin
  FisMessageNotified := value;
end;

// 0.2) Listener supports
procedure TDBAIntfHelper.addListener(Listener: IListener);
begin
  if FListenerSupport<>nil then
    FListenerSupport.addListener(Listener);
end;

procedure TDBAIntfHelper.removeListener(Listener: IListener);
begin
  if FListenerSupport<>nil then
    FListenerSupport.removeListener(Listener);
end;

// 0.4) get implement
function TDBAIntfHelper.getImplement: TObject;
begin
  result := self;
end;

// 1) sql command supports
function TDBAIntfHelper.GetSQLText: string;
begin
  result := SQL.Text;
end;

procedure TDBAIntfHelper.SetSQLText(const Value: string);
begin
  SQL.Clear;
  SQL.add(value);
end;

function TDBAIntfHelper.GetExtraSQLText: string;
begin
  Result := '';
end;

procedure TDBAIntfHelper.SetExtraSQLText(const Value: string);
begin
  //
end;

procedure TDBAIntfHelper.Exec;
begin
  DoBeforeExecute;
  InternalExec;
  DoAfterExecute;
end;

procedure TDBAIntfHelper.ExecSQL(const aSQL: string);
begin
  FSQL.clear;
  FSQL.add(asql);
  Exec;
end;

// 2) normal dataset supports
// 2.1) browse dataset
function TDBAIntfHelper.eof: Boolean;
begin
  result := FEof;
end;

// 2.2) field definitions
function TDBAIntfHelper.FieldCount: Integer;
begin
  result := FFieldCount;
end;

// 2.3) read field values
function TDBAIntfHelper.readData2(FieldDef: TDBFieldDef; buffer: pointer;
  buffersize: Integer): Integer;
begin
  result := readData(FieldDef.FieldIndex,FieldDef.FieldType,buffer,buffersize);
end;

// extend data read
function TDBAIntfHelper.fieldAsInteger(index: integer): integer;
begin
  checkFieldIndex(index);
  if isNull(index) then
    result:=0 else
    readData(index,ftInteger,@result,sizeof(result));
end;

function TDBAIntfHelper.fieldAsString(index: integer): String;
var
  len : integer;
begin
  checkFieldIndex(index);
  if isNull(index) then
    result:='' else
    begin
      // there ia a bug when data is not a string
      len := FieldDataLen(index);
      setLength(result,len);
      readData(index,ftChar,pchar(result),len);
    end;
end;

function TDBAIntfHelper.fieldAsFloat(index: integer): double;
begin
  checkFieldIndex(index);
  if isNull(index) then
    result:=0 else
    readData(index,ftFloat,@result,sizeof(result));
end;

function TDBAIntfHelper.fieldAsDateTime(index: integer): TDateTime;
begin
  checkFieldIndex(index);
  if isNull(index) then
    result:=0 else
    begin
      readData(index,ftDatetime,@result,sizeof(result));
    end;
end;

function TDBAIntfHelper.fieldAsCurrency(index: integer): Currency;
begin
  checkFieldIndex(index);
  if isNull(index) then
    result:=0 else
    readData(index,ftCurrency,@result,sizeof(result));
end;

// 2.4) compute row supports for SQLServer, Sybase
function TDBAIntfHelper.GetisSupportCompute: boolean;
begin
  result := false;
end;

function TDBAIntfHelper.ComputeFieldCount: integer;
begin
  result :=0;
  NotSupport;
end;

function TDBAIntfHelper.ComputeFieldData(index: integer): pointer;
begin
  Result := nil;
  NotSupport;
end;

function TDBAIntfHelper.ComputeFieldDataLen(index: integer): integer;
begin
  result :=0;
  NotSupport;
end;

function TDBAIntfHelper.ComputeFieldSize(index: integer): integer;
begin
  result :=0;
  NotSupport;
end;

function TDBAIntfHelper.ComputeFieldType(index: integer): integer;
begin
  result :=0;
  NotSupport;
end;

function TDBAIntfHelper.computeIsNull(index: Integer): boolean;
begin
  Result := True;
  NotSupport;
end;

function TDBAIntfHelper.cumputeClauseCount: integer;
begin
  result :=0;
  NotSupport;
end;

procedure TDBAIntfHelper.getComputeFieldDef(index: integer;
  FieldDef: TDBFieldDef);
begin
  NotSupport;
end;

function TDBAIntfHelper.isThisACumputeRow: boolean;
begin
  result := false;
end;

procedure TDBAIntfHelper.setisSupportCompute(value: boolean);
begin
  NotSupport;
end;

function TDBAIntfHelper.readComputeData(index: Integer; dataType: TDBFieldType;
  buffer: pointer; buffersize: Integer): Integer;
begin
  Result := 0;
  NotSupport;
end;

function TDBAIntfHelper.readComputeData2(FieldDef: TDBFieldDef; buffer: pointer;
  buffersize: Integer): Integer;
begin
  Result := 0;
  NotSupport;
end;

function TDBAIntfHelper.readRawComputeData(index: Integer; buffer: pointer;
  buffersize: Integer): Integer;
begin
  Result := 0;
  NotSupport;
end;

// 3) output params supports
function TDBAIntfHelper.outputCount: Integer;
begin
  result := FOutputCount;
end;

function TDBAIntfHelper.readOutput2(FieldDef: TDBFieldDef; buffer: pointer;
  buffersize: Integer): Integer;
begin
  result := readOutput(
      FieldDef.FieldIndex,
      FieldDef.FieldType,
      buffer,
      buffersize);
end;

// 4) return value supports

// 5) RPC Supports
procedure TDBAIntfHelper.execRPC;
begin
  DoBeforeExecute;
  InternalExecRPC;
  DoAfterExecute;
end;

// 6) Message  Supports

procedure TDBAIntfHelper.getMessage(msg: TStrings);
begin
  msg.Assign(FMessages);
end;

function TDBAIntfHelper.MessageText: string;
begin
  result := FMessages.Text;
end;

// 7) Error Supports
function TDBAIntfHelper.getError: EDBAccessError;
begin
  result := nil;
end;

end.
