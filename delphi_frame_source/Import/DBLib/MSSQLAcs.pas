unit MSSQLAcs;

{
  The data access class for MSSQL
}

interface

uses windows,classes,sysUtils,IntfUtils,contnrs,DBAIntf,Listeners, BDAImpEx;

const
  lcMSSQL = 14;

type
  TMSSQLError = class;

  TMSSQLErrorObj = class
  private
    FSeverity: integer;
    FOSErrCode: integer;
    FDBErrCode: integer;
    FOSErrMsg: string;
    FDBErrMsg: string;
    FMessage: string;
  public
    constructor Create(aseverity,aDBErr,aOSErr:integer;
                       const aDBErrStr,aOSErrStr:string);
    property    Severity : integer read FSeverity;
    property    DBErrCode : integer read FDBErrCode;
    property    OSErrCode : integer read FOSErrCode;
    property    DBErrMsg : string read FDBErrMsg;
    property    OSErrMsg : string read FOSErrMsg;
    property    Message : string read FMessage;
  end;

  TMSSQLError = class(EDBAccessError)
  private
    FErrors: TObjectList;
    function getErrors(index:integer): TMSSQLErrorObj;
  public
    Destructor  Destroy;override;
    procedure   AfterConstruction; override;
    function    ServerError : boolean;
    property    Errors[index:integer] : TMSSQLErrorObj read getErrors;
    function    count:integer;
    procedure   AddError(Error : TMSSQLErrorObj);
  end;

  TMSSQLAcs = class(TVCLInterfacedObject,IDBAccess)
  private
    FConnected: boolean;
    FPort: integer;
    FHostName: string;
    FUserName: string;
    FServerName: String;
    FPassword: string;
    FDBLogin : Pointer;
    FOwnLogin: boolean;
    FDBProc : pointer;
    FDatabaseName: string;
    FMessages: TStrings;
    FSQL: TStrings;
    FFieldCount : integer;
    FEof : boolean;
    FTimeout: integer;
    FSQLException : TMSSQLError;
    FisSupportCompute : boolean;
    FComputeID : integer;
    FcumputeClauseCount : integer;
    FComputeFieldCount : integer;
    FisThisACumputeRow : boolean;
    FCmdCount : integer;
    FListenerSupport : TListenerSupport;
    Fstate : TDBState;
    FCurResponseType : TDBResponseType;
    FOutputCount : integer;
    FResponseQueue : TList;
    FDoneReading  : boolean;
    FisMessageNotified: boolean;
    FreadAllRows: boolean;
    procedure   SetConnected(const Value: boolean);
    procedure   DoConnect;
    procedure   DoDisConnect;
    procedure   getLogin;
    procedure   getDBProc;
  protected
    procedure   DoBeforeExecute; dynamic;
    procedure   DoAfterExecute;  dynamic;
    procedure   checkFieldIndex(index : integer);
    procedure   handleSQLError(Error : TMSSQLErrorObj);
    procedure   checkSQLError;
    procedure   checkOpened;
    function    rawTypeToStd(rawType:integer):TDBFieldType;
    procedure   putResponseSignal(ResponseType:TDBResponseType);
    procedure   checkResponseQueue;
    procedure   produceResponseQueue;
    procedure   trigerEvent(EventType : TDBEventType);
  public
    // -1) common
    constructor Create(Counting : boolean=false);
    Destructor  Destroy;override;
    property    DBProc : pointer read FDBProc;
    // connect properties
    property    ServerName  : String read FServerName write FServerName;
    property    HostName    : string read FHostName write FHostName;
    property    Port        : integer read FPort write FPort;
    property    UserName    : string read FUserName write FUserName;
    property    Password    : string read FPassword write FPassword;
    property    DatabaseName: string read FDatabaseName write FDatabaseName;
    property    Timeout     : integer read FTimeout write FTimeout;
    property    Connected   : boolean read FConnected write SetConnected;
    // other
    function    CanClone    : boolean;
    function    CloneNew    : TMSSQLAcs;
    // message
    property    Messages    : TStrings read FMessages;

    // 0) common
    procedure   Open;
    procedure   Close;
    function    state : TDBState;
    function    Ready : boolean;
    function    CmdCount:integer;
    // 0.1) common response process
    function    nextResponse: TDBResponseType;
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
                  stdType : TDBFieldType; stdBuffer:pointer; stdSize:integer):integer;
    function    stdDataToRaw(rawType : Integer; rawBuffer : pointer; rawSize : Integer;
                  stdType : TDBFieldType; stdBuffer:pointer; stdSize:Integer):Integer;
    // 0.4) get implement
    function    getImplement : TObject;

    // 1) sql command supports
    property    SQL         : TStrings read FSQL;
    function    GetSQLText : String;
    procedure   SetSQLText(const Value:string);
    property    SQLText : String read GetSQLText write SetSQLText;
    function    GetExtraSQLText : String;
    procedure   SetExtraSQLText(const Value:string);
    property    ExtraSQLText : String read GetExtraSQLText write SetExtraSQLText;
    procedure   Exec;
    procedure   ExecSQL(const aSQL:string);

    // 2) normal dataset supports
    // 2.1) browse dataset
    //function    hasDataset:TTriState;
    function    nextRow : Boolean;
    function    eof : Boolean;
    property    readAllRows : boolean read FreadAllRows write FreadAllRows default true;
    // 2.2) field definitions
    function    FieldCount  : Integer;
    // field index is fron 1 to FieldCount
    procedure   getFieldDef(index : integer; FieldDef : TDBFieldDef);
    function    FieldName(index : integer) : string;
    function    FieldType(index : integer) : integer;
    function    FieldData(index : integer) : pointer;
    function    FieldSize(index : integer) : integer;
    // FieldIndex : get field index by name(case-insensitive)
    function    FieldIndex(afieldName:pchar): integer;
    function    FieldDataLen(index : integer) : integer;
    // 2.3) read field values
    function    readData(index : Integer; dataType: TDBFieldType; buffer : pointer; buffersize : Integer) : Integer;
    function    readData2(FieldDef : TDBFieldDef; buffer : pointer; buffersize : Integer) : Integer;
    function    readRawData(index : Integer; buffer : pointer; buffersize : Integer) : Integer;
    // extend data read
    function    fieldAsInteger(index:integer): integer;
    function    fieldAsFloat(index:integer): double;
    function    fieldAsDateTime(index:integer): TDateTime;
    function    fieldAsString(index:integer): String;
    function    fieldAsCurrency(index:integer): Currency;
    function    isNull(index:integer): boolean;
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
    procedure   getOutputDef(index : integer; FieldDef : TDBFieldDef);
    function    readOutput(index : Integer; dataType: TDBFieldType; buffer : pointer; buffersize : Integer) : Integer;
    function    readOutput2(FieldDef : TDBFieldDef; buffer : pointer; buffersize : Integer) : Integer;
    function    readRawOutput(index : Integer; buffer : pointer; buffersize : Integer) : Integer;
    function    outputIsNull(index : Integer): boolean;

    // 4) return value supports
    //procedure   ReachReturn;
    //function    hasReturn: TTriState;
    function    readReturn(buffer : pointer; buffersize : Integer) : Integer;
    function    returnValue : integer;

    // 5) RPC Supports
    procedure   initRPC(rpcname : String; flags : Integer);
    procedure   setRPCParam(name : String; mode : TDBParamMode; datatype : TDBFieldType;
                  size : Integer; length : Integer; value : pointer; rawType : Integer);
    procedure   execRPC;

    // 6) Message  Supports
    procedure   getMessage(msg : TStrings);
    function    MessageText : string;
    // 7) Error Supports
    function    getError : EDBAccessError;
  end;

  TMSSQLAcsEx = class(TMSSQLAcs);

procedure CheckLibCall(b : boolean; const CallName:string);

function FindAcs(pdbproc : pointer):TMSSQLAcs;

type
  TMSSQLDatabase = class(THDatabase)
  private
    FTimeout: integer;
    FPort: integer;
    FUserName: string;
    FServerName: String;
    FHostName: string;
    FDatabaseName: string;
    FPassword: string;
  protected
    function    newDBAccess : IDBAccess; override;
  public
    
  published
    property    ServerName  : String read FServerName write FServerName;
    property    HostName    : string read FHostName write FHostName;
    property    Port        : integer read FPort write FPort;
    property    UserName    : string read FUserName write FUserName;
    property    Password    : string read FPassword write FPassword;
    property    DatabaseName: string read FDatabaseName write FDatabaseName;
    property    Timeout     : integer read FTimeout write FTimeout;

    property    Connected;
    property    maxConnection;
    property    minConnection;
    property    OnConnected;
    property    OnDisConnected;
  end;

implementation

uses MSSQL,safeCode,logfile;

procedure CheckLibCall(b : boolean; const CallName:string);
begin
  if not b then
    raise TMSSQLError.create(format('Call %s error!',[CallName]));
end;

var
  MSSQLAcsList : TThreadList=nil;

function FindAcs(pdbproc : pointer):TMSSQLAcs;
var
  i : integer;
  List : TList;
begin
  result := nil;
  if MSSQLAcsList<>nil then
  begin
    List := MSSQLAcsList.LockList;
    try
      for i:=0 to List.count-1 do
      begin
        if TMSSQLAcs(List[i]).FDBProc=pdbproc then
        begin
          result := TMSSQLAcs(List[i]);
          break;
        end;
      end;
    finally
      MSSQLAcsList.UnlockList;
    end;
  end;
end;

function StdErrHandler(PDBPROCESS:pointer;
          severity:integer;
          dberr:integer;
          oserr:integer;
          dberrstr:lpcstr;
          oserrstr:lpcstr):integer;cdecl;
var
  acs : TMSSQLAcs;
begin
  result := INT_CANCEL;
  acs :=FindAcs(PDBPROCESS);
  if acs<>nil then
  begin
    acs.handleSQLError(TMSSQLErrorObj.create(
          severity,dberr,oserr,
          string(pchar(dberrstr)),
          string(pchar(oserrstr))));
  end;
end;

function StdMsgHandler(dbproc : PDBPROCESS ; msgno :integer; msgstate :integer ;
               severity : integer ; msgtext,srvname,procname : pchar;
					     line : word):integer;cdecl;
var
  acs : TMSSQLAcs;
begin
  result := 0;
  acs :=FindAcs(dbproc);
  if acs<>nil then
  begin
    acs.FMessages.add(string(pchar(msgtext)));
    acs.putResponseSignal(rtMessage);
  end;
end;

{ TMSSQLErrorObj }

constructor TMSSQLErrorObj.Create(aseverity, aDBErr,
  aOSErr: integer; const aDBErrStr, aOSErrStr: string);
begin
  FMessage := format('MSSQL Error,Severity : %d,DBError(%d,%s),OSError(%d,%s)',
    [aseverity,aDBErr,aDBErrStr,aOSErr,aOSErrStr]);
  FSeverity := aseverity;
  FDBErrCode := aDBErr;
  FDBErrMsg := aDBErrStr;
  FOSErrCode := aOSErr;
  FOSErrMsg := aOSErrStr;
end;


{ TMSSQLError }

procedure TMSSQLError.AddError(Error: TMSSQLErrorObj);
begin
  if Error<>nil then
  begin
    FErrors.add(Error);
    if Message<>'' then Message:=Message+#13#10;
    Message := Message + Error.Message;
  end;
end;

procedure TMSSQLError.AfterConstruction;
begin
  inherited;
  FErrors := TObjectList.Create;

end;


function TMSSQLError.count: integer;
begin
  result := FErrors.Count;
end;

destructor TMSSQLError.Destroy;
begin
  FErrors.free;
  inherited;
end;

function TMSSQLError.getErrors(index:integer): TMSSQLErrorObj;
begin
  result := TMSSQLErrorObj(FErrors[index]);
end;

function TMSSQLError.ServerError: boolean;
begin
  result := FErrors.Count>0;
end;

{ TMSSQLAcs }

constructor TMSSQLAcs.Create(Counting : boolean=false);
begin
  inherited;
  FDBLogin := nil;
  FDBProc := nil;
  FOwnLogin := true;
  FMessages := TStringList.Create;
  FSQL := TStringList.Create;
  FSQLException := nil;
  FisSupportCompute := false;
  FListenerSupport := TListenerSupport.create(self);
  Fstate := dsNotReady;
  FResponseQueue := TList.create;
  FisMessageNotified := false;
  FreadAllRows := true;
  if MSSQLAcsList<>nil then
    MSSQLAcsList.Add(self);
end;

destructor TMSSQLAcs.Destroy;
{var
  temp : TObject;}
begin
  writeLog('begin free TMSSQLAcs',lcConstruct_Destroy);
  trigerEvent(etDestroy);
  if MSSQLAcsList<>nil then
    MSSQLAcsList.Remove(self);
  {if FDBProc<>nil then
  begin
    dbclose(FDBProc);
    FDBProc:=nil;
  end;}
  Connected := false;
  if CanClone then
  begin
    dbfreelogin(FDBLogin);
    FDBLogin:=nil;
  end;
  FreeAndNil(FResponseQueue);
  FreeAndNil(FMessages);
  FreeAndNil(FSQL);
  {temp := FListenerSupport;
  FListenerSupport:=nil;
  FreeAndNil(temp);}
  FreeAndNil(FListenerSupport);
  inherited;
end;

// connect and disconnect

procedure TMSSQLAcs.Open;
begin
  Connected := true;
end;

procedure TMSSQLAcs.Close;
begin
  Connected := false;
end;

procedure TMSSQLAcs.SetConnected(const Value: boolean);
begin
  if FConnected <> Value then
  begin
    if Value then DoConnect else DoDisConnect;
  end;
end;

procedure TMSSQLAcs.DoConnect;
begin
  getLogin;
  getDBProc;
  Fstate := dsReady;
  trigerEvent(etOpened);
end;

procedure TMSSQLAcs.DoDisConnect;
begin
  Fstate := dsNotReady;
  dbclose(FDBProc);
  FDBProc:=nil;
  FConnected := false;
  trigerEvent(etClosed);
end;

procedure TMSSQLAcs.getDBProc;
begin
  FDBProc := dbopen(FDBLogin,pchar(FServerName));
  CheckLibCall(FDBProc<>nil,'dbopen');
  if FDatabaseName<>'' then
  begin
    CheckLibCall(dbuse(FDBProc,pchar(FDatabaseName))=MSSQL.SUCCEED,'dbuse');
  end;
  FConnected := true;
  dbprocerrhandle(FDBProc,StdErrHandler);
  dbprocmsghandle(FDBProc,StdMsgHandler);
end;

procedure TMSSQLAcs.getLogin;
begin
  if FOwnLogin then
    if FDBLogin=nil then FDBLogin:=dblogin;
  CheckLibCall(FDBLogin<>nil,'getLogin');
  if FHostName<>'' then
    checkLibCall(dbsetlname(FDBLogin,pchar(FHostName),DBSETHOST)=SUCCEED,'dbsetlname');
  checkLibCall(dbsetlname(FDBLogin,pchar(FUserName),DBSETUSER)=SUCCEED,'dbsetlname');
  checkLibCall(dbsetlname(FDBLogin,pchar(FPassword),DBSETPWD)=SUCCEED,'dbsetlname');
  checkLibCall(dbsetlname(FDBLogin,nil,DBVER60)=SUCCEED,'dbsetlname');
  //checkLibCall(dbsetlname(FDBLogin,@FTimeout,_DBSETLOGINTIME)=SUCCEED,'dbsetlname');
  checkLibCall(dbsetlogintime(FTimeout)=succeed,'dbsetlogintime');
end;

function TMSSQLAcs.CanClone: boolean;
begin
  result := FOwnLogin and (FDBLogin<>nil);
end;

function TMSSQLAcs.CloneNew: TMSSQLAcs;
begin
  result := nil;
end;

procedure TMSSQLAcs.DoAfterExecute;
begin
  trigerEvent(etAfterExec);
end;

procedure TMSSQLAcs.DoBeforeExecute;
begin
  inc(FCmdCount);
  FFieldCount := 0;
  FcumputeClauseCount := 0;
  FComputeFieldCount := 0;
  FisThisACumputeRow := false;
  FMessages.Clear;
  Fstate := dsBusy;
  FCurResponseType := rtNone;
  FResponseQueue.clear;
  FDoneReading := false;
  trigerEvent(etBeforeExec);
end;

procedure TMSSQLAcs.handleSQLError(Error: TMSSQLErrorObj);
begin
  if FSQLException=nil then
    FSQLException := TMSSQLError.Create('');
  FSQLException.AddError(Error);
end;

procedure TMSSQLAcs.checkSQLError;
var
  excp : TMSSQLError;
begin
  if FSQLException<>nil then
  begin
    excp := FSQLException;
    FSQLException := nil;
    raise excp;
  end;
end;

procedure TMSSQLAcs.checkOpened;
begin
  if not FConnected then
    raise TMSSQLError.Create('Not Connected');
end;

// 0) common
function TMSSQLAcs.state: TDBState;
begin
  result := Fstate;
end;

function TMSSQLAcs.Ready: boolean;
begin
  //result := CmdCount>0;
  result := FState<>dsNotReady;
end;

function TMSSQLAcs.CmdCount: integer;
begin
  result := FCmdCount;
end;

// 0.1) common response process
procedure TMSSQLAcs.putResponseSignal(ResponseType:TDBResponseType);
begin
  if (ResponseType=rtMessage) then
    if not FisMessageNotified then
      exit
    else if FResponseQueue.IndexOf(pointer(ResponseType))>=0 then
      exit;
  FResponseQueue.add(pointer(ResponseType));
end;

procedure TMSSQLAcs.checkResponseQueue;
begin
  if (not FDoneReading) and (FResponseQueue.count=0) then
    produceResponseQueue;
end;

const
  maxFailCount = 3;

procedure TMSSQLAcs.produceResponseQueue;
var
  status : integer;
  goNext : boolean;
  errorCount : integer;
  FindResponse : Boolean;
begin
  errorCount := 0;
  repeat
    goNext := false;
    repeat
      FindResponse := True;
      status := dbresults(FDBProc);
      writeLog('after dbresults :'+IntToStr(status),lcMSSQL);
      case status of
        SUCCEED : if dbnumcols(FDBProc)>0 then
                  begin
                    putResponseSignal(rtDataset);
                  end else
                  begin
                    writeLog('Ignore empty(field count=0) Dataset',lcMSSQL);
                    FindResponse := False;
                  end;
        FAIL    : begin
                    inc(errorCount);
                    goNext := errorCount<maxFailCount;
                  end;
        NO_MORE_RPC_RESULTS,NO_MORE_RESULTS :
                  begin
                    // check return value and output values
                    if dbhasretstat(FDBProc) then
                      putResponseSignal(rtReturnValue);
                    if dbnumrets(FDBProc)>0 then
                      putResponseSignal(rtOutputValue);
                    FDoneReading := status=NO_MORE_RESULTS;
                  end;
      end;
    until FindResponse;
    if goNext then
      if dbdead(FDBProc) then
      begin
        FDoneReading := true;
        goNext := false;
      end;
  until (not goNext);
end;

function TMSSQLAcs.nextResponse: TDBResponseType;
var
  skipCount : integer;
begin
  // triger event
  trigerEvent(etGone2NextResponse);
  // reset some status
  FOutputCount:=0;
  FFieldCount := 0;
  FcumputeClauseCount := 0;
  if FCurResponseType=rtMessage then FMessages.Clear
  else if (FCurResponseType=rtDataset) and not Feof and FreadAllRows then
  begin
    skipCount := 0;
    while nextRow do
      inc(skipCount);
    writeLog('skip rows:'+IntToStr(skipCount),lcMSSQL);
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
                      FFieldCount := dbnumcols(FDBProc);
                      Feof := false;
                      FcumputeClauseCount := dbnumcompute(FDBProc);
                    end;
    rtReturnValue : ;
    rtOutputValue  : begin
                      FOutputCount:=dbnumrets(FDBProc);
                    end;
    rtError       : ;
    rtMessage     : ;
  end;
  writeLog('nextResponse:'+IntToStr(Integer(result)),lcMSSQL);
  checkSQLError;
end;

function TMSSQLAcs.curResponseType: TDBResponseType;
begin
  result := FCurResponseType;
end;

procedure TMSSQLAcs.finished;
begin
  if not FDoneReading or (FCurResponseType<>rtNone) or (Fstate <> dsReady) then
  begin
    checkOpened;
    dbcancel(FDBProc);
    FDoneReading:=true;
    FCurResponseType := rtNone;
    Fstate := dsReady;
    trigerEvent(etFinished);
  end;
end;

{
function TMSSQLAcs.nextResult: boolean;
begin
  result := dbresults(FDBProc)=SUCCEED;
  if result then
  begin
    FFieldCount := dbnumcols(FDBProc);
    FcumputeClauseCount := dbnumcompute(FDBProc);
  end else
  begin
    FFieldCount := 0;
    FcumputeClauseCount := 0;
  end;
  checkSQLError;
end;
}
function TMSSQLAcs.get_isMessageNotified: boolean;
begin
  result := FisMessageNotified;
end;

procedure TMSSQLAcs.set_isMessageNotified(value: boolean);
begin
  FisMessageNotified := value;
end;

// 0.2) Listener supports
procedure TMSSQLAcs.addListener(Listener: IListener);
begin
  if FListenerSupport<>nil then FListenerSupport.addListener(Listener);
end;

procedure TMSSQLAcs.removeListener(Listener: IListener);
begin
  if FListenerSupport<>nil then FListenerSupport.removeListener(Listener);
end;

// 0.3) data conversion
function TMSSQLAcs.rawDataToStd(rawType: integer; rawBuffer: pointer;
  rawSize: integer; stdType: TDBFieldType; stdBuffer: pointer;
  stdSize: integer): integer;
var
  len : integer;
  amoney : TDBMoney;
  n : longword;
  DT : TDBDateTime;
  adatetime : TDatetime;
begin
  if rawBuffer<>nil then
  case stdType of
    ftInteger  : begin
                   if stdSize<sizeof(integer) then
                      result:=-1 else
                      begin
                        result := dbconvert(DBProc,
                          rawType,
                          rawBuffer,
                          rawSize,
                          SQLINT4,
                          stdBuffer,
                          sizeof(integer));
                        //result := sizeof(integer);
                      end;
                 end;
    ftFloat    : begin
                   if stdSize<sizeof(double) then
                      result:=-1 else
                      begin
                        result := dbconvert(DBProc,
                          rawType,
                          rawBuffer,
                          rawSize,
                          SQLFLT8,
                          stdBuffer,
                          sizeof(double));
                        //result := sizeof(double);
                      end;
                 end;
    ftCurrency : begin
                   if stdSize<sizeof(Currency) then
                      result:=-1 else
                      begin
                        result:=dbconvert(DBProc,
                          rawType,
                          rawBuffer,
                          rawSize,
                          SQLMONEY,
                          @amoney,
                          sizeof(amoney));
                        if result>0 then
                        begin
                          n := amoney.mhigh;
                          amoney.mhigh := amoney.mlow;
                          amoney.mlow := n;
                          move(amoney,StdBuffer^,sizeof(Currency));
                          result := sizeof(Currency);
                        end;
                      end;
                 end;
    ftChar     : begin
                      begin
                        fillChar(StdBuffer^,stdSize,0);
                        len := rawSize;
                        if len>=stdSize then
                          len := stdSize;
                        move(rawBuffer^,StdBuffer^,len);
                        result := len;
                      end;
                 end;
    ftDatetime : begin
                   if stdSize<sizeof(TDateTime) then
                      result:=-1 else
                      begin
                        result:=dbconvert(DBProc,
                          rawType,
                          rawBuffer,
                          rawSize,
                          SQLDATETIME,
                          @DT,
                          sizeof(DT));
                        if result>0 then
                        begin
                          adatetime := DT.numdays + 2 + DT.nummini/300/(24*60*60);
                          move(adatetime,stdBuffer^,sizeof(TDateTime));
                          result := sizeof(TDateTime);
                        end;
                      end;
                 end;
    else result := -1;
  end else
  begin
    // for null
    FillChar(stdBuffer^,StdSize,0);
    result := 0;
  end;
end;

function TMSSQLAcs.stdDataToRaw(rawType: Integer; rawBuffer: pointer;
  rawSize: Integer; stdType: TDBFieldType; stdBuffer: pointer;
  stdSize: Integer): Integer;
var
  len : integer;
  amoney : TDBMoney;
  n : longword;
  DT : TDBDateTime;
  adatetime : TDatetime;
begin
  if (stdBuffer<>nil) then
  case stdType of
    ftInteger  : begin
                   if stdSize<sizeof(integer) then
                      result:=-1 else
                      begin
                        result := dbconvert(DBProc,
                          SQLINT4,
                          stdBuffer,
                          sizeof(integer),
                          rawType,
                          rawBuffer,
                          rawSize
                          );
                      end;
                 end;
    ftFloat    : begin
                   if stdSize<sizeof(double) then
                      result:=-1 else
                      begin
                        result := dbconvert(DBProc,
                          SQLFLT8,
                          stdBuffer,
                          sizeof(double),
                          rawType,
                          rawBuffer,
                          rawSize
                          );
                      end;
                 end;
    ftCurrency : begin
                   if stdSize<sizeof(Currency) then
                      result:=-1 else
                      begin
                        move(StdBuffer^,amoney,sizeof(Currency));
                        n := amoney.mhigh;
                        amoney.mhigh := amoney.mlow;
                        amoney.mlow := n;

                        result := dbconvert(DBProc,
                          SQLMONEY,
                          @amoney,
                          sizeof(amoney),
                          rawType,
                          rawBuffer,
                          rawSize
                          );
                      end;
                 end;
    ftChar     : begin
                      begin
                        fillChar(rawBuffer^,rawSize,0);
                        len := stdSize;
                        if len>=rawSize then
                          len := rawSize;
                        move(StdBuffer^,rawBuffer^,len);
                        result := len;
                      end;
                 end;
    ftDatetime : begin
                   if stdSize<sizeof(TDateTime) then
                      result:=-1 else
                      begin
                        move(stdBuffer^,adatetime,sizeof(TDateTime));
                        //adatetime := DT.numdays + 2 + DT.nummini/300/(24*60*60);
                        DT.numdays := Trunc(adatetime)-2;
                        DT.nummini := round((adatetime-DT.numdays-2)*300*24*60*60);
                        result := dbconvert(DBProc,
                          SQLDATETIME,
                          @DT,
                          sizeof(DT),
                          rawType,
                          rawBuffer,
                          rawSize
                          );
                      end;
                 end;
    else result := -1;
  end else
  begin
    // for null
    FillChar(rawBuffer^,rawSize,0);
    result := 0;
  end;
end;

function TMSSQLAcs.rawTypeToStd(rawType: integer): TDBFieldType;
begin
  case RawType of
      SQLINT1,SQLINT2,SQLINT4,SQLINTN,SQLBIT : result := ftInteger;
      SQLVARCHAR,SQLCHAR : result := ftChar;
      SQLMONEY,SQLMONEYN,SQLMONEY4 : result := ftCurrency;
      SQLFLT8,SQLFLTN,SQLFLT4,SQLDECIMAL,SQLNUMERIC : result:=ftFloat;
      SQLDATETIME,SQLDATETIMN,SQLDATETIM4 : result:=ftDatetime;
      MSSQL.SQLTEXT,SQLVARBINARY,SQLBINARY,SQLIMAGE : result := ftBinary;
    else result := ftOther;
  end;
end;

function TMSSQLAcs.getImplement: TObject;
begin
  result := self;
end;

// 1) sql command supports
function TMSSQLAcs.GetSQLText: String;
begin
  result := SQL.Text;
end;

procedure TMSSQLAcs.SetSQLText(const Value: string);
begin
  SQL.Clear;
  SQL.add(value);
end;

function TMSSQLAcs.GetExtraSQLText: String;
begin
  result := '';
end;

procedure TMSSQLAcs.SetExtraSQLText(const Value: string);
begin
  // do nothing
end;

procedure TMSSQLAcs.Exec;
var
  i : integer;
  s : string;
begin
  dbcancel(FDBProc);
  dbcanquery(FDBProc);
  //FreeAndNil(FSQLException);
  DoBeforeExecute;
  for i:=0 to FSQL.count-1 do
  begin
    //dbcmd(FDBProc,pchar(FSQL[i]));
    s :=FSQL[i]+#13#10;
    dbcmd(FDBProc,pchar(s));
  end;

  {if dbsqlexec(FDBProc)=FAIL then
    handleSQLError(nil) else
    nextResult;}
  if dbsqlexec(FDBProc)=FAIL then
    handleSQLError(nil);
  {if dbresults(FDBProc)=SUCCEED then
    FFieldCount := dbnumcols(FDBProc) else}
  DoAfterExecute;
  checkSQLError;
end;

procedure TMSSQLAcs.ExecSQL(const aSQL: string);
begin
  FSQL.clear;
  FSQL.add(asql);
  Exec;
end;

// 2) normal dataset supports
// 2.1) browse dataset
{
function TMSSQLAcs.hasDataset: TTriState;
begin
  if fieldCount>0 then
    result := tsTrue else
    result := tsFalse;
end;
}
function TMSSQLAcs.nextRow: Boolean;
var
  r : integer;
begin
  {//result := dbnextrow(Fdbproc)=SUCCEED;
  result := (FFieldCount>0) and (dbnextrow(Fdbproc)<>NO_MORE_ROWS);
  FEof := not result;
  checkSQLError;}
  checkTrue(FCurResponseType=rtDataset,'must call nextRow after nextResponse');
  FisThisACumputeRow := false;
  FComputeID := 0;
  FComputeFieldCount := 0;
  result := false;
  if FCurResponseType=rtDataset then
  begin
    repeat
      r := dbnextrow(Fdbproc);
      case r of
        REG_ROW : begin
                    result := true;
                    break;
                  end;
        NO_MORE_ROWS :
                  begin
                    result := false;
                    break;
                  end;
        FAIL,BUF_FULL :
                  begin
                    result := false;
                    checkSQLError;
                  end;
        else if r>0 then
                  begin
                    // deal with compute row
                    if FisSupportCompute then
                    begin
                      result := true;
                      FisThisACumputeRow := true;
                      FComputeID := r;
                      FComputeFieldCount := dbnumalts(FDBProc,FComputeID);
                      break;
                    end;
                    // else skip this compute row
                  end;  // else skip this unkown row
      end;
    until false;
  end;
  FEof := not result;
  checkSQLError;
end;

function TMSSQLAcs.eof: Boolean;
begin
  result := FEof;
end;

// 2.2) field definitions
function TMSSQLAcs.FieldCount: Integer;
begin
  result := FFieldCount;
end;

procedure TMSSQLAcs.getFieldDef(index: integer; FieldDef: TDBFieldDef);
begin
  checkFieldIndex(index);
  FieldDef.FieldIndex := index;
  FieldDef.FieldName := fieldName(index);
  FieldDef.DisplayName := FieldDef.FieldName;
  FieldDef.RawType := FieldType(index);
  {case FieldDef.RawType of
      SQLINT1,SQLINT2,SQLINT4 : FieldDef.FieldType := ftInteger;
      SQLVARCHAR,SQLCHAR : FieldDef.FieldType := ftChar;
      SQLMONEY,SQLMONEYN,SQLMONEY4 : FieldDef.FieldType := ftCurrency;
      SQLFLT8,SQLFLTN,SQLFLT4,SQLDECIMAL,SQLNUMERIC : FieldDef.FieldType:=ftFloat;
      SQLDATETIME,SQLDATETIMN,SQLDATETIM4 : FieldDef.FieldType:=ftDatetime;
      MSSQL.SQLTEXT,SQLVARBINARY,SQLBINARY,SQLIMAGE,SQLBIT : FieldDef.FieldType := ftBinary;
    else FieldDef.FieldType := ftOther;
  end;}
  FieldDef.FieldType := rawTypeToStd(FieldDef.RawType);
  FieldDef.FieldSize := FieldSize(index);
  if FieldDef.RawType=SQLCHAR then
    FieldDef.Options := [foFixedChar];
end;

function TMSSQLAcs.FieldSize(index: integer): integer;
begin
  checkFieldIndex(index);
  result := dbcollen(FDBProc,index);
end;

function TMSSQLAcs.FieldName(index: integer): string;
begin
  checkFieldIndex(index);
  result := string(pchar(dbcolname(FDBProc,index)));
end;

function TMSSQLAcs.fieldType(index: integer): integer;
begin
  checkFieldIndex(index);
  result := dbcoltype(FDBProc,index);
end;

function TMSSQLAcs.FieldDataLen(index: integer): integer;
begin
  checkFieldIndex(index);
  result := dbdatlen(FDBProc,index);
end;

function TMSSQLAcs.FieldIndex(afieldName: pchar): integer;
var
  i : integer;
begin
  result := -1;
  for i:=1 to FieldCount do
  begin
    if StrIComp(afieldName,pchar(fieldName(i)))=0 then
    begin
      result := i;
      break;
    end;
  end;
end;

function TMSSQLAcs.fieldData(index: integer): pointer;
begin
  checkFieldIndex(index);
  result := dbdata(FDBProc,index);
end;

// 2.3) read field values
function TMSSQLAcs.readRawData(index: Integer; buffer: pointer;
  buffersize: Integer): Integer;
var
  realSize : integer;
begin
  checkFieldIndex(index);
  realSize := FieldDataLen(index);
  if realSize>buffersize then
    result:=buffersize else
    result:=realSize;
  move(fieldData(index)^,Buffer^,result);
end;

function TMSSQLAcs.fieldAsDateTime(index: integer): TDateTime;
var
  //TimeStamp : TTimeStamp;
  DT : TDBDateTime;
  //n : integer;
begin
  checkFieldIndex(index);
  if isNull(index) then
    result:=0 else
    begin
      //n := sizeof(DT);
      dbconvert(DBProc,
      fieldType(index),
      fieldData(index),
      FieldDataLen(index),
      SQLDATETIME,
      @DT,
      sizeof(DT));
      {TimeStamp.Date := DT.numdays;
      TimeStamp.Time := round(1000*DT.nummini/300);
      result := TimeStampToDateTime(TimeStamp);}
      result := DT.numdays + 2 + DT.nummini/300/(24*60*60);
    end;
end;

function TMSSQLAcs.fieldAsFloat(index: integer): double;
begin
  checkFieldIndex(index);
  if isNull(index) then
    result:=0 else
  dbconvert(DBProc,
    fieldType(index),
    fieldData(index),
    FieldDataLen(index),
    SQLFLT8,
    @result,
    sizeof(result));
end;

function TMSSQLAcs.fieldAsCurrency(index: integer): Currency;
var
  amoney : TDBMoney;
  n : longword;
begin
  checkFieldIndex(index);
  if isNull(index) then
    result:=0 else
    begin
      dbconvert(DBProc,
        fieldType(index),
        fieldData(index),
        FieldDataLen(index),
        SQLMONEY,
        @amoney,
        sizeof(amoney));
      n := amoney.mhigh;
      amoney.mhigh := amoney.mlow;
      amoney.mlow := n;
      move(amoney,result,sizeof(result));
    end;
end;

function TMSSQLAcs.fieldAsInteger(index: integer): integer;
begin
  checkFieldIndex(index);
  if isNull(index) then
    result:=0 else
  dbconvert(DBProc,
    fieldType(index),
    fieldData(index),
    FieldDataLen(index),
    SQLINT4,
    @result,
    sizeof(result));
end;

function TMSSQLAcs.fieldAsString(index: integer): String;
var
  len : integer;
begin
  checkFieldIndex(index);
  if FieldData(index)=nil then
    result:='' else
    begin
      // there is a bug when data is not a really char type
      len := FieldDataLen(index);
      setLength(result,len);
      move(FieldData(index)^,pchar(result)^,len);
    end;
end;

function TMSSQLAcs.isNull(index: integer): boolean;
begin
  checkFieldIndex(index);
  result := FieldData(index)=nil;
end;

function TMSSQLAcs.readData(index: Integer; dataType: TDBFieldType;
  buffer: pointer; buffersize: Integer): Integer;
begin
  result := rawDataToStd(FieldType(index),
        FieldData(index),
        FieldDataLen(index),
        dataType,
        Buffer,
        BufferSize);
end;

function TMSSQLAcs.readData2(FieldDef: TDBFieldDef; buffer: pointer;
  buffersize: Integer): Integer;
begin
  result := rawDataToStd(FieldDef.RawType,
        FieldData(FieldDef.FieldIndex),
        FieldDataLen(FieldDef.FieldIndex),
        FieldDef.FieldType,
        Buffer,
        BufferSize);
end;

procedure TMSSQLAcs.checkFieldIndex(index: integer);
begin
  if (index<=0) or (index>FFieldCount) then
    raise TMSSQLError.create('Field index out of range');
end;

// 2.4) compute row supports for SQLServer, Sybase
function TMSSQLAcs.ComputeFieldCount: integer;
begin
  //result := dbnumalts(FDBProc,FComputeID);
  result := FComputeFieldCount;
end;

function TMSSQLAcs.ComputeFieldData(index: integer): pointer;
begin
  result := dbadata(FDBProc,FComputeID,index);
end;

function TMSSQLAcs.ComputeFieldDataLen(index: integer): integer;
begin
  result := dbadlen(FDBProc,FComputeID,index);
end;

function TMSSQLAcs.ComputeFieldSize(index: integer): integer;
begin
  result := dbaltlen(FDBProc,FComputeID,index);
end;

function TMSSQLAcs.ComputeFieldType(index: integer): integer;
begin
  result := dbalttype(FDBProc,FComputeID,index);
end;

function TMSSQLAcs.cumputeClauseCount: integer;
begin
  result := FcumputeClauseCount;
end;

function TMSSQLAcs.GetisSupportCompute: boolean;
begin
  result := FisSupportCompute;
end;

procedure TMSSQLAcs.setisSupportCompute(value: boolean);
begin
  FisSupportCompute := value;
end;

function TMSSQLAcs.isThisACumputeRow: boolean;
begin
  result := FisThisACumputeRow;
end;

function TMSSQLAcs.readRawComputeData(index: Integer; buffer: pointer;
  buffersize: Integer): Integer;
var
  realSize : integer;
begin
  //checkFieldIndex(index);
  realSize := ComputeFieldDataLen(index);
  if realSize>buffersize then
    result:=buffersize else
    result:=realSize;
  move(ComputefieldData(index)^,Buffer^,result);
end;

function TMSSQLAcs.readComputeData(index: Integer; dataType: TDBFieldType;
  buffer: pointer; buffersize: Integer): Integer;
begin
  result := rawDataToStd(ComputeFieldType(index),
        ComputeFieldData(index),
        ComputeFieldDataLen(index),
        dataType,
        Buffer,
        BufferSize );
end;

function TMSSQLAcs.readComputeData2(FieldDef: TDBFieldDef; buffer: pointer;
  buffersize: Integer): Integer;
begin
  result := rawDataToStd(FieldDef.RawType,
        ComputeFieldData(FieldDef.FieldIndex),
        ComputeFieldDataLen(FieldDef.FieldIndex),
        FieldDef.FieldType,
        Buffer,
        BufferSize);
end;

function TMSSQLAcs.computeIsNull(index: Integer): boolean;
begin
  result := ComputeFieldData(index)=nil;
end;

procedure TMSSQLAcs.getComputeFieldDef(index: integer;
  FieldDef: TDBFieldDef);
begin
  FieldDef.FieldIndex := index;
  FieldDef.FieldName := '';
  FieldDef.DisplayName := '';
  FieldDef.RawType := ComputeFieldType(index);
  case FieldDef.RawType of
      SQLINT1,SQLINT2,SQLINT4,SQLBIT : FieldDef.FieldType := ftInteger;
      SQLVARCHAR,SQLCHAR : FieldDef.FieldType := ftChar;
      SQLMONEY,SQLMONEYN,SQLMONEY4 : FieldDef.FieldType := ftCurrency;
      SQLFLT8,SQLFLTN,SQLFLT4,SQLDECIMAL,SQLNUMERIC : FieldDef.FieldType:=ftFloat;
      SQLDATETIME,SQLDATETIMN,SQLDATETIM4 : FieldDef.FieldType:=ftDatetime;
      MSSQL.SQLTEXT,SQLVARBINARY,SQLBINARY,SQLIMAGE : FieldDef.FieldType := ftBinary;
    else FieldDef.FieldType := ftOther;
  end;
  if FieldDef.RawType=SQLCHAR then
    FieldDef.Options := [foFixedChar];
  FieldDef.FieldSize := ComputeFieldSize(index);
end;

{
procedure TMSSQLAcs.ReachOutputs;
begin
  // do nothing
end;

function TMSSQLAcs.hasOutput: TTriState;
begin
  if FCurResponseType=rtOutputValue then
    result := tsTrue else
    result := tsUnknown;
end;
}

procedure TMSSQLAcs.getOutputDef(index: integer; FieldDef: TDBFieldDef);
begin
  FieldDef.FieldIndex := index;
  FieldDef.FieldName :=  string(pchar(dbretname(FDBProc,index)));
  FieldDef.DisplayName := FieldDef.FieldName;
  FieldDef.RawType := dbrettype(FDBProc,index);
  FieldDef.FieldType := rawTypeToStd(FieldDef.RawType);
  FieldDef.FieldSize := dbretlen(FDBProc,index);
  if FieldDef.RawType=SQLCHAR then
    FieldDef.Options := [foFixedChar];
end;

function TMSSQLAcs.outputCount: Integer;
begin
  result := FOutputCount;
end;

function TMSSQLAcs.outputIsNull(index: Integer): boolean;
begin
  result := dbretdata(FDBProc,index)=nil;
end;

function TMSSQLAcs.readOutput(index: Integer; dataType: TDBFieldType;
  buffer: pointer; buffersize: Integer): Integer;
begin
  result := rawDataToStd(dbrettype(FDBProc,index),
        dbretdata(FDBProc,index),
        dbretlen(FDBProc,index),
        dataType,
        Buffer,
        BufferSize);
end;

function TMSSQLAcs.readOutput2(FieldDef: TDBFieldDef; buffer: pointer;
  buffersize: Integer): Integer;
begin
  result := rawDataToStd(FieldDef.RawType,
        dbretdata(FDBProc,FieldDef.FieldIndex),
        dbretlen(FDBProc,FieldDef.FieldIndex),
        FieldDef.FieldType,
        Buffer,
        BufferSize);
end;

function TMSSQLAcs.readRawOutput(index: Integer; buffer: pointer;
  buffersize: Integer): Integer;
var
  realSize : integer;
begin
  //checkFieldIndex(index);
  realSize := dbretlen(FDBProc,index);
  if realSize>buffersize then
    result:=buffersize else
    result:=realSize;
  move(dbretdata(FDBProc,index)^,Buffer^,result);
end;

// 4) return value supports
{
function TMSSQLAcs.hasReturn: TTriState;
begin
  if FCurResponseType=rtReturnValue then
    result := tsTrue else
    result := tsUnknown;
end;

procedure TMSSQLAcs.ReachReturn;
begin
  // do nothing
end;
}
function TMSSQLAcs.readReturn(buffer: pointer;
  buffersize: Integer): Integer;
var
  status : integer;
begin
  result := 0;
  if buffersize>=sizeof(integer) then
  begin
    result := sizeof(integer);
    status := dbretstatus(FDBProc);
    move(status,buffer^,result);
  end;
end;

function TMSSQLAcs.returnValue: integer;
begin
  result := dbretstatus(FDBProc);
end;

// 5) RPC Supports
procedure TMSSQLAcs.initRPC(rpcname: String; flags: Integer);
begin
  CheckLibCall(dbrpcinit(FDBProc,pchar(rpcname),flags)=SUCCEED,'dbrpcinit');
end;

procedure TMSSQLAcs.setRPCParam(name: String; mode: TDBParamMode;
  datatype: TDBFieldType; size, length: Integer; value: pointer;
  rawType: Integer);
var
  RawBuffer : PByte;
  status,asize,alength : integer;
begin
  if mode in [pmOutput,pmInputOutput] then
    status:=DBRPCRETURN else
    status:=0;

  GetMem(RawBuffer,size);
  try
    if value<>nil then // not null
      CheckLibCall(stdDataToRaw(rawType,RawBuffer,size,dataType,value,length)>=0,'stdDataToRaw');
    if datatype in [ftInteger,ftFloat,ftCurrency,ftDatetime] then
      // fixed
      if value<>nil then
      begin
        // not null
        asize:=-1;
        alength:=-1;
      end
      else
      begin
        // null
        asize:=-1;
        alength:=0;
      end
    else if value<>nil then // var length
      begin
        // not null
        asize:=size;
        alength:=length;
      end
      else
      begin
        // null
        asize:=0;
        alength:=0;
      end;

    CheckLibCall(dbrpcparam(FDBProc,pchar(name),status,rawType,asize,alength,rawBuffer)=SUCCEED,'dbrpcparam');
  finally
    FreeMem(RawBuffer,size);
  end;
end;

procedure TMSSQLAcs.execRPC;
begin
  dbcancel(FDBProc);
  dbcanquery(FDBProc);
  //FreeAndNil(FSQLException);
  DoBeforeExecute;
  if dbrpcexec(FDBProc)=FAIL then
    handleSQLError(nil){ else
    nextResult};
  DoAfterExecute;
  checkSQLError;
end;

function TMSSQLAcs.getError: EDBAccessError;
begin
  result := FSQLException;
end;

procedure TMSSQLAcs.getMessage(msg: TStrings);
begin
  msg.Assign(FMessages);
end;

function TMSSQLAcs.MessageText: string;
begin
  result := FMessages.Text;
end;


procedure TMSSQLAcs.trigerEvent(EventType: TDBEventType);
var
  Event : TDBEvent;
begin
  writeLog('trigerEvent'+IntToStr(integer(EventType)),lcMSSQL);
  Event := TDBEvent.create;
  Event.EventType := EventType;
  FListenerSupport.notifyListeners2(event);
end;




{ TMSSQLDatabase }

function TMSSQLDatabase.newDBAccess: IDBAccess;
var
  sqlacs : TMSSQLAcs;
begin
  sqlacs := TMSSQLAcs.create(true);
  try
    sqlacs.ServerName := FServerName;
    sqlacs.HostName := FHostName;
    sqlacs.DatabaseName:=DatabaseName;
    sqlacs.Port := FPort;
    sqlacs.UserName := FUserName;
    sqlacs.Password := FPassword;
    sqlacs.Timeout := FTimeout;
    sqlacs.Open;
  except
    freeAndNil(sqlacs);
  end;
  if sqlacs<>nil then
  begin
    result := sqlacs;
    writeLog('new dbaccess ok',lcMSSQL);
  end  else
  begin
    result := nil;
    writeLog('new dbaccess error!',lcMSSQL);
  end;
end;


initialization
  MSSQLAcsList := TThreadList.create;

  dbinit();
  //dberrhandle();

finalization
  dbexit();
  FreeAndNil(MSSQLAcsList);
end.
