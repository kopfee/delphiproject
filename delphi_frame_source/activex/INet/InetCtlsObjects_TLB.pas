unit InetCtlsObjects_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : $Revision:   1.88  $
// File generated on 2000-04-13 13:23:53 from Type Library described below.

// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
// ************************************************************************ //
// Type Lib: C:\WINDOWS\SYSTEM\MSINET.OCX (1)
// IID\LCID: {48E59290-9880-11CF-9754-00AA00C00908}\0
// Helpfile: C:\WINDOWS\SYSTEM\INET.HLP
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\SYSTEM\StdOle2.Tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\SYSTEM\STDVCL40.DLL)
// Errors:
//   Hint: Parameter 'Type' of IInet.AccessType changed to 'Type_'
//   Hint: Parameter 'Type' of IInet.AccessType changed to 'Type_'
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, OleCtrls, StdVCL;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  InetCtlsObjectsMajorVersion = 1;
  InetCtlsObjectsMinorVersion = 0;

  LIBID_InetCtlsObjects: TGUID = '{48E59290-9880-11CF-9754-00AA00C00908}';

  IID_IInet: TGUID = '{48E59291-9880-11CF-9754-00AA00C00908}';
  DIID_DInetEvents: TGUID = '{48E59292-9880-11CF-9754-00AA00C00908}';
  CLASS_Inet: TGUID = '{48E59293-9880-11CF-9754-00AA00C00908}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum StateConstants
type
  StateConstants = TOleEnum;
const
  icNone = $00000000;
  icResolvingHost = $00000001;
  icHostResolved = $00000002;
  icConnecting = $00000003;
  icConnected = $00000004;
  icRequesting = $00000005;
  icRequestSent = $00000006;
  icReceivingResponse = $00000007;
  icResponseReceived = $00000008;
  icDisconnecting = $00000009;
  icDisconnected = $0000000A;
  icError = $0000000B;
  icResponseCompleted = $0000000C;

// Constants for enum AccessConstants
type
  AccessConstants = TOleEnum;
const
  icUseDefault = $00000000;
  icDirect = $00000001;
  icNamedProxy = $00000002;

// Constants for enum ProtocolConstants
type
  ProtocolConstants = TOleEnum;
const
  icUnknown = $00000000;
  icDefault = $00000001;
  icFTP = $00000002;
  icGopher = $00000003;
  icHTTP = $00000004;
  icHTTPS = $00000005;

// Constants for enum DataTypeConstants
type
  DataTypeConstants = TOleEnum;
const
  icString = $00000000;
  icByteArray = $00000001;

// Constants for enum ErrorConstants
type
  ErrorConstants = TOleEnum;
const
  icOutOfMemory = $00000007;
  icTypeMismatch = $0000000D;
  icInvalidPropertyValue = $0000017C;
  icInetOpenFailed = $00008BA6;
  icUrlOpenFailed = $00008BA7;
  icBadUrl = $00008BA8;
  icProtMismatch = $00008BA9;
  icConnectFailed = $00008BAA;
  icNoRemoteHost = $00008BAB;
  icRequestFailed = $00008BAC;
  icNoExecute = $00008BAD;
  icBlewChunk = $00008BAE;
  icFtpCommandFailed = $00008BAF;
  icUnsupportedType = $00008BB0;
  icTimeout = $00008BB1;
  icUnsupportedCommand = $00008BB2;
  icInvalidOperation = $00008BB3;
  icExecuting = $00008BB4;
  icInvalidForFtp = $00008BB5;
  icOutOfHandles = $00008BB7;
  icInetTimeout = $00008BB8;
  icExtendedError = $00008BB9;
  icIntervalError = $00008BBA;
  icInvalidURL = $00008BBB;
  icUnrecognizedScheme = $00008BBC;
  icNameNotResolved = $00008BBD;
  icProtocolNotFound = $00008BBE;
  icInvalidOption = $00008BBF;
  icBadOptionLength = $00008BC0;
  icOptionNotSettable = $00008BC1;
  icShutDown = $00008BC2;
  icIncorrectUserName = $00008BC3;
  icIncorrectPassword = $00008BC4;
  icLoginFailure = $00008BC5;
  icInetInvalidOperation = $00008BC6;
  icOperationCancelled = $00008BC7;
  icIncorrectHandleType = $00008BC8;
  icIncorrectHandleState = $00008BC9;
  icNotProxyRequest = $00008BCA;
  icRegistryValueNotFound = $00008BCB;
  icBadRegistryParameter = $00008BCC;
  icNoDirectAccess = $00008BCD;
  icNoContext = $00008BCE;
  icNoCallback = $00008BCF;
  icRequestPending = $00008BD0;
  icIncorrectFormat = $00008BD1;
  icItemNotFound = $00008BD2;
  icCannotConnect = $00008BD3;
  icConnectionAborted = $00008BD4;
  icConnectionReset = $00008BD5;
  icForceRetry = $00008BD6;
  icInvalidProxyRequest = $00008BD7;
  icWouldBlock = $00008BD8;
  icHandleExists = $00008BDA;
  icSecCertDateInvalid = $00008BDB;
  icSecCertCnInvalid = $00008BDC;
  icHttpToHttpsOnRedir = $00008BDD;
  icHttpsToHttpOnRedir = $00008BDE;
  icMixedSecurity = $00008BDF;
  icChgPostIsNonSecure = $00008BE0;
  icPostIsNonSecure = $00008BE1;
  icClientAuthCertNeeded = $00008BE2;
  icInvalidCa = $00008BE3;
  icClientAuthNotSetup = $00008BE4;
  icAsyncThreadFailed = $00008BE5;
  icRedirectSchemeChange = $00008BE6;
  icFtpTransferInProgress = $00008C24;
  icFtpDropped = $00008C25;
  icGopherProtocolError = $00008C38;
  icGopherNotFile = $00008C39;
  icGopherDataError = $00008C3A;
  icGopherEndOfData = $00008C3B;
  icGopherInvalidLocator = $00008C3C;
  icGopherIncorrectLocatorType = $00008C3D;
  icGopherNotGopherPlus = $00008C3E;
  icGopherAttributeNotFound = $00008C3F;
  icGopherUnknownLocator = $00008C40;
  icHttpHeaderNotFound = $00008C4C;
  icHttpDownlevelServer = $00008C4D;
  icHttpInvalidServerResponse = $00008C4E;
  icHttpInvalidHeader = $00008C4F;
  icHttpInvalidQueryRequest = $00008C50;
  icHttpHeaderAlreadyExists = $00008C51;
  icHttpRedirectFailed = $00008C52;
  icSecurityChannelError = $00008C53;
  icUnableToCacheFile = $00008C54;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IInet = interface;
  IInetDisp = dispinterface;
  DInetEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Inet = IInet;


// *********************************************************************//
// Interface: IInet
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {48E59291-9880-11CF-9754-00AA00C00908}
// *********************************************************************//
  IInet = interface(IDispatch)
    ['{48E59291-9880-11CF-9754-00AA00C00908}']
    function  Get_Protocol: ProtocolConstants; safecall;
    procedure Set_Protocol(Protocol: ProtocolConstants); safecall;
    function  Get_RemoteHost: WideString; safecall;
    procedure Set_RemoteHost(const RemoteHost: WideString); safecall;
    function  Get_RemotePort: Smallint; safecall;
    procedure Set_RemotePort(RemotePort: Smallint); safecall;
    function  Get_ResponseInfo: WideString; safecall;
    function  Get_ResponseCode: Integer; safecall;
    function  Get_hInternet: Integer; safecall;
    function  Get_StillExecuting: WordBool; safecall;
    function  Get_URL: WideString; safecall;
    procedure Set_URL(const URL: WideString); safecall;
    function  Get_Proxy: WideString; safecall;
    procedure Set_Proxy(const Name: WideString); safecall;
    function  Get_Document: WideString; safecall;
    procedure Set_Document(const Document: WideString); safecall;
    function  Get_AccessType: AccessConstants; safecall;
    procedure Set_AccessType(Type_: AccessConstants); safecall;
    function  Get_UserName: WideString; safecall;
    procedure Set_UserName(const UserName: WideString); safecall;
    function  Get_Password: WideString; safecall;
    procedure Set_Password(const Password: WideString); safecall;
    function  Get_RequestTimeout: Integer; safecall;
    procedure Set_RequestTimeout(Timeout: Integer); safecall;
    function  OpenURL(URL: OleVariant; DataType: OleVariant): OleVariant; safecall;
    procedure Execute(URL: OleVariant; Operation: OleVariant; InputData: OleVariant; 
                      InputHdrs: OleVariant); safecall;
    procedure Cancel; safecall;
    function  GetChunk(var Size: Integer; DataType: OleVariant): OleVariant; safecall;
    function  GetHeader(HdrName: OleVariant): WideString; safecall;
    procedure AboutBox; stdcall;
    function  Get__URL: WideString; safecall;
    procedure Set__URL(const URL: WideString); safecall;
    property Protocol: ProtocolConstants read Get_Protocol write Set_Protocol;
    property RemoteHost: WideString read Get_RemoteHost write Set_RemoteHost;
    property RemotePort: Smallint read Get_RemotePort write Set_RemotePort;
    property ResponseInfo: WideString read Get_ResponseInfo;
    property ResponseCode: Integer read Get_ResponseCode;
    property hInternet: Integer read Get_hInternet;
    property StillExecuting: WordBool read Get_StillExecuting;
    property URL: WideString read Get_URL write Set_URL;
    property Proxy: WideString read Get_Proxy write Set_Proxy;
    property Document: WideString read Get_Document write Set_Document;
    property AccessType: AccessConstants read Get_AccessType write Set_AccessType;
    property UserName: WideString read Get_UserName write Set_UserName;
    property Password: WideString read Get_Password write Set_Password;
    property RequestTimeout: Integer read Get_RequestTimeout write Set_RequestTimeout;
    property _URL: WideString read Get__URL write Set__URL;
  end;

// *********************************************************************//
// DispIntf:  IInetDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {48E59291-9880-11CF-9754-00AA00C00908}
// *********************************************************************//
  IInetDisp = dispinterface
    ['{48E59291-9880-11CF-9754-00AA00C00908}']
    property Protocol: ProtocolConstants dispid 19;
    property RemoteHost: WideString dispid 1;
    property RemotePort: Smallint dispid 2;
    property ResponseInfo: WideString readonly dispid 4;
    property ResponseCode: Integer readonly dispid 5;
    property hInternet: Integer readonly dispid 6;
    property StillExecuting: WordBool readonly dispid 8;
    property URL: WideString dispid 9;
    property Proxy: WideString dispid 24;
    property Document: WideString dispid 10;
    property AccessType: AccessConstants dispid 14;
    property UserName: WideString dispid 20;
    property Password: WideString dispid 21;
    property RequestTimeout: Integer dispid 26;
    function  OpenURL(URL: OleVariant; DataType: OleVariant): OleVariant; dispid 22;
    procedure Execute(URL: OleVariant; Operation: OleVariant; InputData: OleVariant; 
                      InputHdrs: OleVariant); dispid 17;
    procedure Cancel; dispid 18;
    function  GetChunk(var Size: Integer; DataType: OleVariant): OleVariant; dispid 23;
    function  GetHeader(HdrName: OleVariant): WideString; dispid 25;
    procedure AboutBox; dispid -552;
    property _URL: WideString dispid 0;
  end;

// *********************************************************************//
// DispIntf:  DInetEvents
// Flags:     (4112) Hidden Dispatchable
// GUID:      {48E59292-9880-11CF-9754-00AA00C00908}
// *********************************************************************//
  DInetEvents = dispinterface
    ['{48E59292-9880-11CF-9754-00AA00C00908}']
    procedure StateChanged(State: Smallint); dispid 32;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TInet
// Help String      : Microsoft Internet Transfer Control
// Default Interface: IInet
// Def. Intf. DISP? : No
// Event   Interface: DInetEvents
// TypeFlags        : (38) CanCreate Licensed Control
// *********************************************************************//
  TInetStateChanged = procedure(Sender: TObject; State: Smallint) of object;

  TInet = class(TOleControl)
  private
    FOnStateChanged: TInetStateChanged;
    FIntf: IInet;
    function  GetControlInterface: IInet;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function  OpenURL: OleVariant; overload;
    function  OpenURL(URL: OleVariant): OleVariant; overload;
    function  OpenURL(URL: OleVariant; DataType: OleVariant): OleVariant; overload;
    procedure Execute; overload;
    procedure Execute(URL: OleVariant); overload;
    procedure Execute(URL: OleVariant; Operation: OleVariant); overload;
    procedure Execute(URL: OleVariant; Operation: OleVariant; InputData: OleVariant); overload;
    procedure Execute(URL: OleVariant; Operation: OleVariant; InputData: OleVariant; 
                      InputHdrs: OleVariant); overload;
    procedure Cancel;
    function  GetChunk(var Size: Integer): OleVariant; overload;
    function  GetChunk(var Size: Integer; DataType: OleVariant): OleVariant; overload;
    function  GetHeader: WideString; overload;
    function  GetHeader(HdrName: OleVariant): WideString; overload;
    procedure AboutBox;
    property  ControlInterface: IInet read GetControlInterface;
    property  DefaultInterface: IInet read GetControlInterface;
    property ResponseInfo: WideString index 4 read GetWideStringProp;
    property ResponseCode: Integer index 5 read GetIntegerProp;
    property hInternet: Integer index 6 read GetIntegerProp;
    property StillExecuting: WordBool index 8 read GetWordBoolProp;
    property _URL: WideString index 0 read GetWideStringProp write SetWideStringProp;
  published
    property Protocol: TOleEnum index 19 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property RemoteHost: WideString index 1 read GetWideStringProp write SetWideStringProp stored False;
    property RemotePort: Smallint index 2 read GetSmallintProp write SetSmallintProp stored False;
    property URL: WideString index 9 read GetWideStringProp write SetWideStringProp stored False;
    property Proxy: WideString index 24 read GetWideStringProp write SetWideStringProp stored False;
    property Document: WideString index 10 read GetWideStringProp write SetWideStringProp stored False;
    property AccessType: TOleEnum index 14 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property UserName: WideString index 20 read GetWideStringProp write SetWideStringProp stored False;
    property Password: WideString index 21 read GetWideStringProp write SetWideStringProp stored False;
    property RequestTimeout: Integer index 26 read GetIntegerProp write SetIntegerProp stored False;
    property OnStateChanged: TInetStateChanged read FOnStateChanged write FOnStateChanged;
  end;

procedure Register;

implementation

uses ComObj;

procedure TInet.InitControlData;
const
  CEventDispIDs: array [0..0] of DWORD = (
    $00000020);
  CControlData: TControlData2 = (
    ClassID: '{48E59293-9880-11CF-9754-00AA00C00908}';
    EventIID: '{48E59292-9880-11CF-9754-00AA00C00908}';
    EventCount: 1;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$80040112*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnStateChanged) - Cardinal(Self);
end;

procedure TInet.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IInet;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TInet.GetControlInterface: IInet;
begin
  CreateControl;
  Result := FIntf;
end;

function  TInet.OpenURL: OleVariant;
begin
  Result := DefaultInterface.OpenURL(EmptyParam, EmptyParam);
end;

function  TInet.OpenURL(URL: OleVariant): OleVariant;
begin
  Result := DefaultInterface.OpenURL(URL, EmptyParam);
end;

function  TInet.OpenURL(URL: OleVariant; DataType: OleVariant): OleVariant;
begin
  Result := DefaultInterface.OpenURL(URL, DataType);
end;

procedure TInet.Execute;
begin
  DefaultInterface.Execute(EmptyParam, EmptyParam, EmptyParam, EmptyParam);
end;

procedure TInet.Execute(URL: OleVariant);
begin
  DefaultInterface.Execute(URL, EmptyParam, EmptyParam, EmptyParam);
end;

procedure TInet.Execute(URL: OleVariant; Operation: OleVariant);
begin
  DefaultInterface.Execute(URL, Operation, EmptyParam, EmptyParam);
end;

procedure TInet.Execute(URL: OleVariant; Operation: OleVariant; InputData: OleVariant);
begin
  DefaultInterface.Execute(URL, Operation, InputData, EmptyParam);
end;

procedure TInet.Execute(URL: OleVariant; Operation: OleVariant; InputData: OleVariant; 
                        InputHdrs: OleVariant);
begin
  DefaultInterface.Execute(URL, Operation, InputData, InputHdrs);
end;

procedure TInet.Cancel;
begin
  DefaultInterface.Cancel;
end;

function  TInet.GetChunk(var Size: Integer): OleVariant;
begin
  Result := DefaultInterface.GetChunk(Size, EmptyParam);
end;

function  TInet.GetChunk(var Size: Integer; DataType: OleVariant): OleVariant;
begin
  Result := DefaultInterface.GetChunk(Size, DataType);
end;

function  TInet.GetHeader: WideString;
begin
  Result := DefaultInterface.GetHeader(EmptyParam);
end;

function  TInet.GetHeader(HdrName: OleVariant): WideString;
begin
  Result := DefaultInterface.GetHeader(HdrName);
end;

procedure TInet.AboutBox;
begin
  DefaultInterface.AboutBox;
end;

procedure Register;
begin
  RegisterComponents('ActiveX',[TInet]);
end;

end.
