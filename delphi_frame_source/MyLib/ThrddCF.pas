unit ThrddCF;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> ThrddCF
   <What> Threaded Class Factory
   <Written By> Huang YanLai
   <History>
**********************************************}

// base on delphi's ThrddCF.pas

{*******************************************************}
{                                                       }
{          Threaded Class Factory Demo                  }
{                                                       }
{*******************************************************}

{
  This unit provides some custom class factories that implement threading for
  out of process servers.  The TThreadedAutoObjectFactory is for any TAutoObject
  and the TThreadedClassFactory is for and TComponentFactory.  To use them,
  replace the line in the initialization section of your automation object to
  use the appropriate threaded class factory instead of the non-threaded version.
}

interface

uses messages,sysUtils,ComObj, ActiveX, Classes, Windows, VCLCom, Forms;

type

  TCreateInstanceProc = function(const UnkOuter: IUnknown;
    const IID: TGUID; out Obj): HResult of object; stdcall;

{ TThreadedAutoObjectFactory }

  TThreadedAutoObjectFactory = class(TAutoObjectFactory, IClassFactory)
  protected
    function CreateInstance(const UnkOuter: IUnknown; const IID: TGUID;
      out Obj): HResult; stdcall;
    function DoCreateInstance(const UnkOuter: IUnknown; const IID: TGUID;
      out Obj): HResult; stdcall;
  end;

{ TThreadedClassFactory }

  TThreadedClassFactory = class(TComponentFactory, IClassFactory)
  protected
    function CreateInstance(const UnkOuter: IUnknown; const IID: TGUID;
      out Obj): HResult; stdcall;
    function DoCreateInstance(const UnkOuter: IUnknown; const IID: TGUID;
      out Obj): HResult; stdcall;
  end;

{ TApartmentThread }

  TApartmentThread = class(TThread)
  private
    FCreateInstanceProc: TCreateInstanceProc;
    FUnkOuter: IUnknown;
    FIID: TGuid;
    FSemaphore: THandle;
    FStream: Pointer;
    FCreateResult: HResult;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateInstanceProc: TCreateInstanceProc; UnkOuter: IUnknown; IID: TGuid);
    destructor Destroy; override;
    property Semaphore: THandle read FSemaphore;
    property CreateResult: HResult read FCreateResult;
    property ObjStream: Pointer read FStream;
  end;

  TCOMServerThread = class(TThread)
  private
    FCreateResult: boolean;
    FTimeOut : integer;
    FTimeOutDateTime : TDateTime;
    FKeepStay: boolean;
    procedure SetTimeOut(const Value: integer);
  protected
    FServerObject : TObject;
    // set FStream : Pointer to avoid delphi's counting
    FStream: Pointer;
    FSemaphore: THandle;
    FServerInterface : IUnknown;
    FLastAccessTime: TDateTime;
    FTimer : THandle;
    procedure   Execute; override;
    // return whether success
    function    CreateServer(out Unk: IUnknown):boolean; virtual;abstract;
    procedure   InitServer; virtual;
    function    CanTimeout : boolean; virtual;
    function    UnMarshalInterface(out Unk: IUnknown):HResult;
    function    MarshalInterface:HResult;
    function    MarshalInterfaceEx(const IID : TGUID):HResult;
    function    UnMarshalInterfaceEx(const IID : TGUID; out Unk):HResult;
  public
    constructor Create;
    destructor  Destroy; override;
    procedure   ReleaseSemaphore;
    // called out of this thread
    procedure   Wait;
    function    WaitForCreate:boolean;
    procedure   Release; virtual;
    function    GetServerInterface: IUnknown;
    property    CreateResult : boolean read FCreateResult;
    property    Semaphore: THandle read FSemaphore;
    property    ObjStream: Pointer read FStream;
    property    ServerObject : TObject read FServerObject;
    property    ServerInterface : IUnknown read GetServerInterface;
    property    LastAccessTime : TDateTime read FLastAccessTime;
    // TimeOut is in minutes
    // if TimeOut<=0 , no TimeOut
    property    TimeOut : integer read FTimeOut write SetTimeOut;
    function    GetServerInterfaceEx(const IID : TGUID; out obj): HResult;
    property    KeepStay : boolean read FKeepStay write FKeepStay default true;
  end;

const
  ServerThreadMsg_MarshalInterface = WM_User + $1000;
  ServerThreadMsg_MarshalInterfaceEx = WM_User + $1001;

implementation

uses SafeCode;

{ TThreadedAutoObjectFactory }

function TThreadedAutoObjectFactory.DoCreateInstance(const UnkOuter: IUnknown;
  const IID: TGUID; out Obj): HResult; stdcall;
begin
  Result := inherited CreateInstance(UnkOuter, IID, Obj);
end;

function TThreadedAutoObjectFactory.CreateInstance(const UnkOuter: IUnknown;
  const IID: TGUID; out Obj): HResult; stdcall;
begin
  with TApartmentThread.Create(DoCreateInstance, UnkOuter, IID) do
  begin
    if WaitForSingleObject(Semaphore, INFINITE) = WAIT_OBJECT_0 then
    begin
      Result := CreateResult;
      if Result <> S_OK then Exit;
      Result := CoGetInterfaceAndReleaseStream(IStream(ObjStream), IID, Obj);
    end else
      Result := E_FAIL
  end;
end;

{ TThreadedClassFactory }

function TThreadedClassFactory.DoCreateInstance(const UnkOuter: IUnknown;
  const IID: TGUID; out Obj): HResult; stdcall;
begin
  Result := inherited CreateInstance(UnkOuter, IID, Obj);
end;

function TThreadedClassFactory.CreateInstance(const UnkOuter: IUnknown;
  const IID: TGUID; out Obj): HResult; stdcall;
begin
  with TApartmentThread.Create(DoCreateInstance, UnkOuter, IID) do
  begin
    if WaitForSingleObject(Semaphore, INFINITE) = WAIT_OBJECT_0 then
    begin
      Result := CreateResult;
      if Result <> S_OK then Exit;
      Result := CoGetInterfaceAndReleaseStream(IStream(ObjStream), IID, Obj);
    end else
      Result := E_FAIL
  end;
end;

{ TApartmentThread }

constructor TApartmentThread.Create(CreateInstanceProc: TCreateInstanceProc;
  UnkOuter: IUnknown; IID: TGuid);
begin
  FCreateInstanceProc := CreateInstanceProc;
  FUnkOuter := UnkOuter;
  FIID := IID;
  FSemaphore := CreateSemaphore(nil, 0, 1, nil);
  FreeOnTerminate := True;
  inherited Create(False);
end;

destructor TApartmentThread.Destroy;
begin
  FUnkOuter := nil;
  CloseHandle(FSemaphore);
  inherited Destroy;
  Application.ProcessMessages;
end;

procedure TApartmentThread.Execute;
var
  msg: TMsg;
  Unk: IUnknown;
begin
  CoInitialize(nil);
  FCreateResult := FCreateInstanceProc(FUnkOuter, FIID, Unk);
  if FCreateResult = S_OK then
    CoMarshalInterThreadInterfaceInStream(FIID, Unk, IStream(FStream));
  ReleaseSemaphore(FSemaphore, 1, nil);
  if FCreateResult = S_OK then
    while GetMessage(msg, 0, 0, 0) do
    begin
      DispatchMessage(msg);
      Unk._AddRef;
      if Unk._Release = 1 then break;
    end;
  Unk := nil;
  CoUninitialize;
end;

{ TCOMServerThread }

constructor TCOMServerThread.Create;
begin
  FTimeOut := -1;
  FSemaphore := CreateSemaphore(nil, 0, 1, nil);
  FreeOnTerminate := True;
  FKeepStay := true;
  inherited Create(False);
end;

destructor TCOMServerThread.Destroy;
begin
  FServerInterface := nil;
  // FServerObject is freed by FServerInterface
  //FServerObject.free;
  CloseHandle(FSemaphore);
  inherited Destroy;
  Application.ProcessMessages;
end;

procedure TCOMServerThread.Release;
begin
  FServerInterface := nil;
end;

procedure TCOMServerThread.Execute;
var
  msg: TMsg;
  Unk: IUnknown;
  FCurTime : TDateTime;
  RefCount : integer;
begin
  CoInitialize(nil);

  FCreateResult := CreateServer(Unk);
  if FCreateResult then
  begin
    FServerInterface := Unk;
    //CoMarshalInterThreadInterfaceInStream(IUnknown, Unk, IStream(FStream));
  end;
  // force the system to create the message queue
  PeekMessage(msg, 0, WM_USER, WM_USER, PM_NOREMOVE);
  ReleaseSemaphore;

  // Init Server;
  InitServer;

  if FCreateResult then
  begin
    FTimer := SetTimer(0,0,1000*30,nil);
    while GetMessage(msg, 0, 0, 0) do
    begin
      DispatchMessage(msg);
      outPutDebugString('AddRef and Release For Count Testing');
      Unk._AddRef;
      RefCount := Unk._Release;
      outPutDebugString(pchar('Count Testing : '+IntToStr(RefCount)));
      if RefCount=1 then break
      else if (RefCount=2) and not KeepStay then
      begin
        Release;
        break;
      end;
      FCurTime := Now;
      //if (msg.message=WM_Timer) and (msg.hwnd=0) then
      // avoid OLEChanel Window's WM_Timer
      if (msg.message=WM_Timer) then
      begin
        // check time out
        if CanTimeout and (FLastAccessTime+FTimeOutDateTime<FCurTime) then
        begin
          OutputDebugString('Time out!');
          break;
        end
        else
        begin
          OutputDebugString(pchar(
            ' now : '+ formatDateTime('hh:nn:ss',FCurTime)+
            ' last : '+ formatDateTime('hh:nn:ss',FLastAccessTime)
            ));
        end;
      end
      else if (msg.hwnd=0) and
              (msg.message=ServerThreadMsg_MarshalInterface) and
              (msg.wParam=ServerThreadMsg_MarshalInterface) and
              (msg.lParam=ServerThreadMsg_MarshalInterface) then
      begin
        MarshalInterface;
        ReleaseSemaphore;
      end
      else if (msg.hwnd=0) and
              (msg.message=ServerThreadMsg_MarshalInterfaceEx) and
              (msg.wParam=ServerThreadMsg_MarshalInterfaceEx)then
      begin
        MarshalInterfaceEx(PGUID(msg.LParam)^);
        ReleaseSemaphore;
      end
      else
      begin
        FLastAccessTime := FCurTime;
        OutputDebugString(pchar(
            ' now : '+ formatDateTime('hh:nn:ss',FCurTime)+
            ' msg : '+ IntToHex(msg.message,8)+
            ' wnd : '+ IntToHex(msg.hwnd,8)
            ));
      end;
    end; // end while
    KillTimer(0,FTimer);
  end;

  Unk := nil;
  CoUninitialize;
end;

procedure TCOMServerThread.Wait;
begin
  CheckTrue(WaitForSingleObject(FSemaphore, INFINITE) = WAIT_OBJECT_0);
end;

procedure TCOMServerThread.ReleaseSemaphore;
begin
  windows.ReleaseSemaphore(FSemaphore, 1, nil);
end;

function  TCOMServerThread.MarshalInterface:HResult;
begin
  // must set FStream=nil to avoid delphi's counting
  FStream:=nil;
  result := CoMarshalInterThreadInterfaceInStream(IUnknown, FServerInterface, IStream(FStream));
end;

function  TCOMServerThread.UnMarshalInterface(out Unk: IUnknown):HResult;
begin
  Result := CoGetInterfaceAndReleaseStream(IStream(FStream), IUnknown, Unk);
  // must set FStream=nil to avoid delphi's counting
  FStream:=nil;
end;

function TCOMServerThread.WaitForCreate: boolean;
begin
  wait;
  Result := FCreateResult;
  if result then
  begin
    //result := CoGetInterfaceAndReleaseStream(IStream(ObjStream), IUnknown, FServerInterface)=S_OK;
    //Synchronize(MarshalInterface);
  end;
  //ReleaseSemaphore;
end;

procedure TCOMServerThread.SetTimeOut(const Value: integer);
begin
  FTimeOut := Value;
  FTimeOutDateTime := FTimeOut * ( 1 / 24 / 60);
  OutputDebugString(pchar(
    formatDateTime('hh:nn:ss',FTimeOutDateTime)
    ));
end;

function TCOMServerThread.CanTimeout: boolean;
begin
  result := FTimeOut>0;
end;

function TCOMServerThread.GetServerInterface: IUnknown;
begin
  if GetCurrentThreadId=ThreadId then
    result := FServerInterface else
    begin
      if PostThreadMessage(ThreadId,
        ServerThreadMsg_MarshalInterface,
        ServerThreadMsg_MarshalInterface,
        ServerThreadMsg_MarshalInterface) then
      begin
        wait;
        {if UnMarshalInterface(result)<>S_OK then
          result:=nil;}
        CheckTrue(UnMarshalInterface(result)=S_OK,'Error : UnMarshalInterface');
      end
      else  result:=nil;
    end;
end;

function TCOMServerThread.GetServerInterfaceEx(const IID: TGUID;
  out obj): HResult;
begin
  try
    if GetCurrentThreadId=ThreadId then
      result:=FServerInterface.QueryInterface(IID,Obj) else
      begin
        if PostThreadMessage(ThreadId,
          ServerThreadMsg_MarshalInterfaceEx,
          ServerThreadMsg_MarshalInterfaceEx,
          integer(@IID)) then
        begin
          wait;
          result := UnMarshalInterfaceEx(IID,Obj);
        end
        else
        begin
          Pointer(obj) := nil;
          result:=S_FALSE;
        end;
      end;
  except
    pointer(obj) := nil;
    result := S_FALSE;
  end;
end;

function TCOMServerThread.MarshalInterfaceEx(const IID: TGUID): HResult;
{var
  Intf : IUnknown;}
begin
  // must set FStream=nil to avoid delphi's counting
  FStream:=nil;
  {result := FServerInterface.QueryInterface(IID,Intf);
  if result=S_OK then
  result := CoMarshalInterThreadInterfaceInStream(IID, Intf, IStream(FStream));}
  result := CoMarshalInterThreadInterfaceInStream(IID, FServerInterface, IStream(FStream));
end;

function TCOMServerThread.UnMarshalInterfaceEx(const IID: TGUID;
  out Unk): HResult;
begin
  Result := CoGetInterfaceAndReleaseStream(IStream(FStream), IID, Unk);
  // must set FStream=nil to avoid delphi's counting
  FStream:=nil;
end;

procedure TCOMServerThread.InitServer;
begin
  // do nothing
end;

end.
