unit SrvUtils;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>SrvUtils
   <What>编写Service程序的工具
   <Written By> Huang YanLai (黄燕来)
   <History>
   1.0 来源于Borland的ScktSrvr.dpr
**********************************************}

interface

uses Windows, SysUtils, Classes, Forms, SvcMgr;

function IsServiceInstalling: Boolean;

function IsStartService(const ServiceName : string): Boolean;

type
  TServiceHelperApplication = class(TComponent)
  private
    FShowMainForm: Boolean;
    FTitle: string;
    FIsService: Boolean;
    FIsInstall: Boolean;
    FServiceName: string;
    FFirstService : Boolean;
    FRunAsService: Boolean;
  protected

  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
    // The following uses the current behaviour of the IDE module manager
    procedure   CreateForm(InstanceClass: TComponentClass; var Reference); virtual;
    procedure   Initialize; virtual;
    procedure   Run; virtual;
    class procedure WriteLog(const Message : string);
    property    Title: string read FTitle write FTitle;
    property    ShowMainForm : Boolean read FShowMainForm write FShowMainForm;
    property    IsInstall : Boolean read FIsInstall;
    property    IsService : Boolean read FIsService;
    property    ServiceName : string read FServiceName write FServiceName;
    property    RunAsService : Boolean read FRunAsService;
  end;

function Application : TServiceHelperApplication;

const
  lcSrvApp = 17;
  
resourcestring
  SAlreadyRunning = '已经运行';
  SNoServiceName = '没有设置服务名称';

implementation

uses WinSvc, SafeCode, LogFile;

var
  FApplication : TServiceHelperApplication;

function IsServiceInstalling: Boolean;
begin
  Result := FindCmdLineSwitch('INSTALL',['-','\','/'], True) or
            FindCmdLineSwitch('UNINSTALL',['-','\','/'], True);
end;

function IsStartService(const ServiceName : string): Boolean;
var
  Mgr, Svc: Integer;
  UserName, ServiceStartName: string;
  Config: Pointer;
  Size: DWord;
begin
  Result := False;
  Mgr := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  if Mgr <> 0 then
  begin
    Svc := OpenService(Mgr, PChar(ServiceName), SERVICE_ALL_ACCESS);
    Result := Svc <> 0;
    if Result then
    begin
      QueryServiceConfig(Svc, nil, 0, Size);
      Config := AllocMem(Size);
      try
        QueryServiceConfig(Svc, Config, Size, Size);
        ServiceStartName := PQueryServiceConfig(Config)^.lpServiceStartName;
        if CompareText(ServiceStartName, 'LocalSystem') = 0 then
          ServiceStartName := 'SYSTEM';
      finally
        Dispose(Config);
      end;
      CloseServiceHandle(Svc);
    end;
    CloseServiceHandle(Mgr);
  end;
  if Result then
  begin
    Size := 256;
    SetLength(UserName, Size);
    GetUserName(PChar(UserName), Size);
    SetLength(UserName, StrLen(PChar(UserName)));
    Result := CompareText(UserName, ServiceStartName) = 0;
  end;
end;

procedure InitApplication;
begin
  FApplication := TServiceHelperApplication.Create(nil);
end;

procedure DoneApplication;
begin
  FApplication.Free;
  FApplication := nil;
end;

function Application : TServiceHelperApplication;
begin
  if FApplication=nil then
    InitApplication;
  Result := FApplication;
end;

{ TServiceHelperApplication }

constructor TServiceHelperApplication.Create(AOwner: TComponent);
begin
  inherited;
  FFirstService := True;
  FShowMainForm := True;
end;

destructor TServiceHelperApplication.Destroy;
begin
  inherited;

end;

procedure TServiceHelperApplication.CreateForm(
  InstanceClass : TComponentClass; var Reference);
begin
  try
    if FRunAsService then
    begin
      SvcMgr.Application.CreateForm(InstanceClass, Reference);
      if FFirstService and (TObject(Reference) is TService) then
      begin
        FFirstService := False;
        TService(Reference).Name := ServiceName;
        if (Title<>'') and (TService(Reference).DisplayName=TService(Reference).Name) then
          TService(Reference).DisplayName := Title;
      end;
    end else
    begin
      Forms.Application.CreateForm(InstanceClass, Reference);
    end;
  except
    WriteException;
    raise;
  end;
end;

procedure TServiceHelperApplication.Initialize;
begin
  WriteLog('TServiceHelperApplication.Initialize '+ServiceName);
  CheckTrue(ServiceName<>'',SNoServiceName);
  FIsInstall := IsServiceInstalling;
  if FIsInstall then
    WriteLog('Install or Uninstall Service');
  FIsService := IsStartService(ServiceName);
  if FIsService then
    WriteLog('Run As Service') else
    WriteLog('Run As Standalone Application');
  FRunAsService := FIsInstall or FIsService;
  if not FIsInstall then
  begin
    CreateMutex(nil, True, PChar(ServiceName));
    if GetLastError = ERROR_ALREADY_EXISTS then
    begin
      WriteLog(SAlreadyRunning+' '+ServiceName);
      MessageBox(0, PChar(SAlreadyRunning), PChar(ServiceName), MB_ICONERROR);
      Halt;
    end;
  end;
  if FRunAsService then
  begin
    SvcMgr.Application.Initialize;
  end else
  begin
    Forms.Application.Initialize;
  end;
end;

procedure TServiceHelperApplication.Run;
begin
  if FRunAsService then
  begin
    SvcMgr.Application.Title := Title;
    SvcMgr.Application.Run;
  end else
  begin
    Forms.Application.ShowMainForm := ShowMainForm;
    Forms.Application.Title := Title;
    Forms.Application.Run;
  end;
end;

class procedure TServiceHelperApplication.WriteLog(const Message: string);
begin
  LogFile.WriteLog(Message,lcSrvApp);
end;

initialization

finalization
  DoneApplication;

end.
