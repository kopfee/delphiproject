unit IntfUtils;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> IntfUtils
   <What> 实现接口的基础类
   <Written By> Huang YanLai
   <History>
**********************************************}

interface

uses windows,ActiveX,Sysutils,ComObj;

type
  TVCLInterfacedObject0 = class(TObject,IUnknown)
  private
    FCounting : Boolean;
    FRefCount: Integer;
    FIsDestroying: Boolean;
  protected
    property    IsDestroying : Boolean read FIsDestroying;
  public
    { IUnknown }
    function    QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function    _AddRef: Integer; stdcall;
    function    _Release: Integer; stdcall;

    constructor Create(Counting : Boolean=False);
    procedure   BeforeDestruction; override;
    Destructor  Destroy;override;
    property    RefCount: Integer read FRefCount;
  end;

  TVCLInterfacedObject = class(TVCLInterfacedObject0)
  private

  public
    constructor Create(Counting : Boolean=False);
    destructor  Destroy;override;
  end;

  TVCLDelegateObject = class(TVCLInterfacedObject0,IUnknown)
  private
    FOwner : TObject;
  protected

  public
    constructor Create(AOwner : TObject);
    property    Owner : TObject read FOwner ;
    function    QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
  end;

  TAutoIntfObjectEx = class(TObject,IUnknown, IDispatch, ISupportErrorInfo)
  private
    FController: Pointer;
    FRefCount: Integer;
    FDispTypeInfo: ITypeInfo;
    FDispIntfEntry: PInterfaceEntry;
    FDispIID: TGUID;
    FServerExceptionHandler: IServerExceptionHandler;
    function GetController: IUnknown;
  protected
    { IUnknown }
    //function IUnknown.QueryInterface = ObjQueryInterface;
    //function IUnknown._AddRef = ObjAddRef;
    //function IUnknown._Release = ObjRelease;
    { IUnknown methods for other interfaces }
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    { ISupportErrorInfo }
    function InterfaceSupportsErrorInfo(const iid: TIID): HResult; stdcall;
    { IDispatch }
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
  public
    constructor Create(const TypeLib: ITypeLib; const DispIntf: TGUID);
    constructor CreateAggregated(const TypeLib: ITypeLib; const DispIntf: TGUID;const Controller: IUnknown);
    destructor  Destroy; override;
    procedure   Initialize; virtual;
    function    ObjAddRef: Integer; virtual; stdcall;
    function    ObjQueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;
    function    ObjRelease: Integer; virtual; stdcall;
    property    Controller: IUnknown read GetController;
    property    RefCount: Integer read FRefCount;
    function    SafeCallException(ExceptObject: TObject;
                  ExceptAddr: Pointer): HResult; override;
    property    DispIntfEntry: PInterfaceEntry read FDispIntfEntry;
    property    DispTypeInfo: ITypeInfo read FDispTypeInfo;
    property    DispIID: TGUID read FDispIID;
    property    ServerExceptionHandler: IServerExceptionHandler
                    read FServerExceptionHandler write FServerExceptionHandler;
  end;

implementation

uses DebugMemory,logFile;

{ TVCLInterfacedObject0 }

constructor TVCLInterfacedObject0.Create(Counting: Boolean=False);
begin
  FCounting := Counting;
  FRefCount := 0;
  FIsDestroying:=False;
end;

function TVCLInterfacedObject0._AddRef: Integer;
begin
  //writeLog(className+'.addRef',lcConstruct_Destroy);
  if FCounting then
  begin
    Result := InterlockedIncrement(FRefCount);
  end else
    result := -1;
end;

function TVCLInterfacedObject0._Release: Integer;
begin
  //writeLog(className+'.release',lcConstruct_Destroy);
  if FCounting then
  begin
    Result := InterlockedDecrement(FRefCount);
    if (Result = 0) and not FIsDestroying then Destroy;
  end else
    result := -1;
end;

function TVCLInterfacedObject0.QueryInterface(const IID: TGUID;
  out Obj): HResult;
begin
  if GetInterface(IID, Obj) then Result := S_OK
    else Result := E_NOINTERFACE;
end;

destructor TVCLInterfacedObject0.Destroy;
begin
  WriteLog('count='+IntToStr(FRefCount),lcConstruct_Destroy);
  //if (FRefCount > 0) and FCounting then CoDisconnectObject(Self, 0);
  inherited;
end;

procedure TVCLInterfacedObject0.BeforeDestruction;
begin
  inherited;
  FIsDestroying:=true;
end;

{ TVCLDelegateObject }

constructor TVCLDelegateObject.Create(AOwner: TObject);
begin
  inherited Create(False);
  FOwner := AOwner;
end;

function TVCLDelegateObject.QueryInterface(const IID: TGUID;
  out Obj): HResult;
begin
  if FOwner.GetInterface(IID, Obj) then Result := S_OK
    else Result := E_NOINTERFACE;
end;

{ TAutoIntfObjectEx }

constructor TAutoIntfObjectEx.Create(const TypeLib: ITypeLib; const DispIntf: TGUID);
begin
  CreateAggregated(TypeLib,DispIntf,nil);
end;

constructor TAutoIntfObjectEx.CreateAggregated(const TypeLib: ITypeLib; const DispIntf: TGUID;const Controller: IUnknown);
begin
  LogCreate(self);
  OleCheck(TypeLib.GetTypeInfoOfGuid(DispIntf, FDispTypeInfo));
  FDispIntfEntry := GetInterfaceEntry(DispIntf);
  FRefCount := 1;
  FController := Pointer(Controller);
  Initialize;
  Dec(FRefCount);
end;

destructor TAutoIntfObjectEx.Destroy;
begin
  if FRefCount > 0 then CoDisconnectObject(Self, 0);
  inherited;
  LogDestroy(self);
end;

function TAutoIntfObjectEx.GetController: IUnknown;
begin
  Result := IUnknown(FController);
end;

procedure TAutoIntfObjectEx.Initialize;
begin
end;

{ TAutoIntfObjectEx.IUnknown }

function TAutoIntfObjectEx.ObjQueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then Result := S_OK else Result := E_NOINTERFACE;
end;

function TAutoIntfObjectEx.ObjAddRef: Integer;
begin
  Result := InterlockedIncrement(FRefCount);
end;

function TAutoIntfObjectEx.ObjRelease: Integer;
begin
  // InterlockedDecrement returns only 0 or 1 on Win95 and NT 3.51
  // returns actual result on NT 4.0
  Result := InterlockedDecrement(FRefCount);
  if Result = 0 then Destroy;
end;

{ TAutoIntfObjectEx.IUnknown for other interfaces }

function TAutoIntfObjectEx.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  {if FController <> nil then
    Result := IUnknown(FController).QueryInterface(IID, Obj) else
    Result := ObjQueryInterface(IID, Obj);}
    Result := ObjQueryInterface(IID, Obj);
end;

function TAutoIntfObjectEx._AddRef: Integer;
begin
  if FController <> nil then
    Result := IUnknown(FController)._AddRef else
    Result := ObjAddRef;
end;

function TAutoIntfObjectEx._Release: Integer;
begin
  if FController <> nil then
    Result := IUnknown(FController)._Release else
    Result := ObjRelease;
end;

{ TAutoIntfObjectEx.ISupportErrorInfo }

function TAutoIntfObjectEx.InterfaceSupportsErrorInfo(const iid: TIID): HResult;
begin
  if GetInterfaceEntry(iid) <> nil then
    Result := S_OK else
    Result := S_FALSE;
end;

function TAutoIntfObjectEx.GetIDsOfNames(const IID: TGUID; Names: Pointer;
  NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin
  Result := DispGetIDsOfNames(FDispTypeInfo, Names, NameCount, DispIDs);
end;

function TAutoIntfObjectEx.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HResult;
begin
  Pointer(TypeInfo) := nil;
  if Index <> 0 then
  begin
    Result := DISP_E_BADINDEX;
    Exit;
  end;
  ITypeInfo(TypeInfo) := FDispTypeInfo;
  Result := S_OK;
end;

function TAutoIntfObjectEx.GetTypeInfoCount(out Count: Integer): HResult;
begin
  Count := 1;
  Result := S_OK;
end;

function TAutoIntfObjectEx.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HResult;
const
  INVOKE_PROPERTYSET = INVOKE_PROPERTYPUT or INVOKE_PROPERTYPUTREF;
begin
  if Flags and INVOKE_PROPERTYSET <> 0 then Flags := INVOKE_PROPERTYSET;
  Result := FDispTypeInfo.Invoke(Pointer(Integer(Self) +
    FDispIntfEntry.IOffset), DispID, Flags, TDispParams(Params), VarResult,
    ExcepInfo, ArgErr);
end;

function TAutoIntfObjectEx.SafeCallException(ExceptObject: TObject;
  ExceptAddr: Pointer): HResult;
{
begin
  Result := HandleSafeCallException(ExceptObject, ExceptAddr, DispIID, '', '');
end;
}
var
  Msg: string;
  Handled: Integer;
begin
  //WriteException;
  Handled := 0;
  if ServerExceptionHandler <> nil then
  begin
    if ExceptObject is Exception then
      Msg := Exception(ExceptObject).Message;
    Result := 0;
    ServerExceptionHandler.OnException(ClassName,
      ExceptObject.ClassName, Msg, Integer(ExceptAddr),
      '',
      '', Handled, Result);
  end;
  if Handled = 0 then
    Result := HandleSafeCallException(ExceptObject, ExceptAddr, DispIID, '', '');
  //WriteException;
end;

{ TVCLInterfacedObject }

constructor TVCLInterfacedObject.Create(Counting: Boolean);
begin
  LogCreate(self);
  inherited;
end;

destructor TVCLInterfacedObject.Destroy;
begin
  inherited;
  LogDestroy(self);
end;

end.
