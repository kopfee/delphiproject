unit LogFile;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> LogFile
   <What> 实现日志文件(一定要设置debug条件)
   <Written By> Huang YanLai
   <History>
**********************************************}

{
  you must use the unit before writelog
}

interface

uses windows;

{
  Notes :
    In the previouse version this unit automatically call OpenLogFile if you uses the unit,
  while in the curren version, if you want write log to file, you must manullay call OpenLogFile
  in initialization section of your main unit.

}

type
  TLogCatalog = byte; //日志类型
  TLogCatalogs = set of TLogCatalog; //日志类型集合

  {
    <Interface>ILogSystem
    <What>日志接口
    <Properties>
      -
    <Methods>
      WriteLog-写日志。注意日志已经被过滤，同时增加了时间戳
      UpdateLogMedia-更新保存日志的媒介
  }
  ILogSystem = interface
    // 写日志。注意日志已经被过滤，同时增加了时间戳
    procedure WriteLog(const S:string; Catalog : byte = 0);
    // 更新保存日志的媒介
    procedure UpdateLogMedia;
  end;

const
  // 标准的日志类型
  lcOther = 0;
  lcConstruct_Destroy = 1;
  lcMemoey = 2;
  lcException = 3;
  lcDebug = 4;
  // application Log Catalog
  lcAppLogStart = 128;
{
  // 下面是来自其他单元定义的日志类型

  // RPDefines
  lcReport = 5;

  // WVCommands.pas
  lcCommand = 6;

  // KCDataPack.pas
  lcKCPack = 7;
  lcKCPackDetail = 13;

  // DBAHelper.pas
  lcDBAIntfHelper = 8;

  // KSFrameWorks
  lcRegisterUI = 9;

  // BDAImp
  lcDataset= 10;
  lcRender = 11;

  // KCDataAccess
  lcKCDataset = 12;

  // BDAImpEx
  lcHDatabase = 13;

  // MSSQLAcs
  lcMSSQL = 14;

  // TxtDBEx
  lcTextDataset = 15;

  // CompUtils
  lcSimulateKey = 16;

  // SrvUtils
  lcSrvApp = 17;

  // KCWVProcBinds
  lcKCProcessor = 18;

  // KCDataAccess
  lcKCDatasetDetail = 19;
}

  LineBreak = #13#10;
  UpdateLogMsg = 'Update Log File.'#13#10;

var
  // 输出到日志的日志类型集合
  LogCatalogs : TLogCatalogs = [0..255];
  // 是否包含时间戳
  isLogTime : Boolean = true;
  // 是否同时使用OutputDebugString输出
  isOutputDebugString : Boolean = True;
  // 当前使用的日志系统
  LogSystem : ILogSystem = nil;

// 打开一个日志文件作为日志系统
procedure OpenLogFile(const alogFileName : string=''; awithDate:Boolean=false; aoverwrite:Boolean=false);

// 写日志
procedure WriteLog(const S:string; Catalog : byte = 0);

// 写意外到日志
procedure WriteException;

//procedure WriteBuffer(Buffer : Pchar; BufferSize : Integer);

type
  TFileLogSystem = class(TInterfacedObject,ILogSystem)
  private

  protected
    FLogLock : TRTLCriticalSection;
    FHLogFile : THandle;
    FLogFileName,FBaseFileName : string;
    FLogFileAvailable : Boolean;
    FLogDay : Integer;
    FWithDate :  Boolean;
    FOverwrite:  Boolean;
    // ILogSystem
    procedure   WriteLog(const S:string; Catalog : byte = 0);
    procedure   UpdateLogMedia;
    // Support Methods
    procedure   GenLogFileName;
    procedure   InternalOpenLogFile;
    procedure   UpdateLogFile;
  public
    constructor Create(const ALogFileName : string=''; AWithDate:Boolean=False; AOverwrite:Boolean=False);
    destructor  Destroy;override;
    property    LogFileName : string read FLogFileName;
    property    BaseFileName : string read FBaseFileName;
    property    LogFileAvailable : Boolean read FLogFileAvailable;
    property    LogDay : Integer read FLogDay;
    property    WithDate :  Boolean read FWithDate;
    property    Overwrite:  Boolean read FOverwrite;
  end;


implementation

uses sysUtils,math;

var
  oldExceptHandler : Pointer;

procedure OpenLogFile(const alogFileName : string=''; awithDate:Boolean=false; aoverwrite:Boolean=false);
var
  FileLogSystem : TFileLogSystem;
begin
  FileLogSystem := TFileLogSystem.Create(alogFileName,awithDate,aoverwrite);
  if FileLogSystem.LogFileAvailable then
    LogSystem := FileLogSystem else
    FreeAndNil(FileLogSystem);
end;

procedure WriteLog(const S:string; Catalog : byte = 0);
var
  s1,s2 : string;
begin
  // 过滤日志
  if not (Catalog in LogCatalogs) then
    Exit;
  // 优化  
  if (LogSystem=nil) and not isOutputDebugString then
    Exit;
  // 增加时间戳
  if isLogTime then
    s2 := formatDateTime('hh:nn:ss ',now)+ s  else
    s2 := s ;
  s1 := s2 + lineBreak;
  if LogSystem<>nil then
    LogSystem.WriteLog(S1,Catalog);
  if isOutputDebugString then
    outputDebugString(pchar(s2));
end;

{
procedure WriteBuffer(Buffer : Pchar; BufferSize : Integer);
var
  wbytes : DWORD;
begin
  if FLogFileAvailable then
  begin
    EnterCriticalSection(FLogLock);
    try
      WriteFile(FHLogFile,Buffer^,BufferSize,wbytes,nil);
    finally
      LeaveCriticalSection(FLogLock);
    end;
  end;
end;
}
procedure MyExceptHandler(ExceptObject: TObject; ExceptAddr: Pointer); far;
begin
  if ExceptObject is Exception then
    WriteLog(ExceptObject.className+' '+Exception(ExceptObject).Message,lcException) else
    WriteLog(ExceptObject.className,lcException);
end;

procedure WriteException;
var
  obj : TObject;
begin
  obj := ExceptObject;
  if obj<>nil then
  begin
    if obj is Exception then
      WriteLog(obj.className+' '+Exception(obj).Message,lcException) else
      WriteLog(obj.className,lcException);
  end;
end;

{ TFileLogSystem }

constructor TFileLogSystem.Create(const ALogFileName: string; AWithDate,
  AOverwrite: Boolean);
var
  ModuleName: array[0..255] of Char;
  p : Pchar;
begin
  inherited Create;
  try
    InitializeCriticalSection(FLogLock);

    FillChar(ModuleName,sizeof(ModuleName),0);
    if (aLogFileName<>'') then
      move(pchar(aLogFileName)^,ModuleName,SizeOf(ModuleName)-1)  else
      begin
        GetModuleFileName(0, ModuleName, SizeOf(ModuleName)-1-4); // -4 for '.log'
        // change extension
        P := AnsiStrRScan(ModuleName, '.');
        if p=nil then
          p:=StrEnd(ModuleName);
        move('.log',p^,4);
      end;

    FWithDate := awithDate;
    if FWithDate then
    begin
      P := AnsiStrRScan(ModuleName, '.');
      if p=nil then
        p:=StrEnd(ModuleName);
      move(p[0],p[2],StrLen(p));
      move('%s',p[0],2);
    end;
    FBaseFileName:=string(ModuleName);

    FOverwrite:=aoverwrite;
    InternalOpenLogFile;
  except
    FLogFileAvailable := false;
  end;
end;

procedure TFileLogSystem.WriteLog(const S: string; Catalog: byte);
var
  wbytes : DWORD;
begin
  if FLogFileAvailable then
  begin
    EnterCriticalSection(FLogLock);
    try
      WriteFile(FHLogFile,pchar(s)^,length(s),wbytes,nil);
    finally
      LeaveCriticalSection(FLogLock);
    end;
  end;
end;

procedure TFileLogSystem.GenLogFileName;
var
  DateStr : string;
  thisTime : TDatetime;
begin
  if FWithDate then
  begin
    thisTime := now;
    FLogDay := Floor(thistime);
    DateStr := FormatDateTime('yymmdd',thisTime);
    FLogFileName := format(FBaseFileName,[DateStr]);
  end else
  begin
    FLogFileName := FBaseFileName;
  end;
end;

procedure TFileLogSystem.InternalOpenLogFile;
var
  openMode : Integer;
begin
  genLogFileName;
  if FOverwrite then
    openMode := CREATE_ALWAYS else
    openMode := OPEN_ALWAYS;
  FHLogFile := CreateFile(pchar(FLogFileName),
              GENERIC_WRITE,
              FILE_SHARE_READ	or FILE_SHARE_WRITE,
              nil,
              openMode,
              FILE_ATTRIBUTE_NORMAL or FILE_FLAG_WRITE_THROUGH,
              0);
  FLogFileAvailable := FHLogFile<>INVALID_HANDLE_VALUE;
  if FLogFileAvailable and not FOverwrite then
    SetFilePointer(FHLogFile,0,nil,FILE_END) else
    SetFilePointer(FHLogFile,0,nil,FILE_BEGIN);
end;

procedure TFileLogSystem.UpdateLogFile;
var
  wbytes : DWORD;
begin
  if FWithDate and (FLogDay<Floor(now)) then
  try
    EnterCriticalSection(FLogLock);
    try
      if FHLogFile<>INVALID_HANDLE_VALUE then
      begin
        WriteFile(FHLogFile,UpdateLogMsg,length(UpdateLogMsg),wbytes,nil);
        CloseHandle(FHLogFile);
      end;
      internalOpenLogFile;
    except
      FLogFileAvailable := false;
    end;
  finally
    LeaveCriticalSection(FLogLock);
  end;
end;

destructor TFileLogSystem.Destroy;
begin
  if FLogFileAvailable then
  begin
    if FHLogFile<>INVALID_HANDLE_VALUE then
      CloseHandle(FHLogFile);
  end;
  DeleteCriticalSection(FLogLock);
  inherited;
end;

procedure TFileLogSystem.UpdateLogMedia;
begin
  UpdateLogFile;
end;

initialization
  oldExceptHandler := ExceptProc;
  ExceptProc := @MyExceptHandler;

finalization
  ExceptProc := oldExceptHandler;

end.
