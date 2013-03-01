unit DataServer_TLB;

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
// File generated on 1999-12-27 15:41:41 from Type Library described below.

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
// Type Lib: D:\HuangYL\lib\Import\DBLib\exam2\DataServer.tlb (1)
// IID\LCID: {73DB7720-BC73-11D3-AAFA-00C0268E6AE8}\0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\SYSTEM\STDOLE2.TLB)
//   (2) v4.0 StdVCL, (C:\WINDOWS\SYSTEM\STDVCL40.DLL)
//   (3) v1.0 BasicDataAccess, (C:\Program Files\Borland\Delphi5\Bin\basicdataaccess.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, OleCtrls, StdVCL, 
  BasicDataAccess_TLB;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  DataServerMajorVersion = 1;
  DataServerMinorVersion = 0;

  LIBID_DataServer: TGUID = '{73DB7720-BC73-11D3-AAFA-00C0268E6AE8}';

  IID_ITestData: TGUID = '{73DB7721-BC73-11D3-AAFA-00C0268E6AE8}';
  CLASS_TestData: TGUID = '{73DB7723-BC73-11D3-AAFA-00C0268E6AE8}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ITestData = interface;
  ITestDataDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  TestData = ITestData;


// *********************************************************************//
// Interface: ITestData
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {73DB7721-BC73-11D3-AAFA-00C0268E6AE8}
// *********************************************************************//
  ITestData = interface(IDispatch)
    ['{73DB7721-BC73-11D3-AAFA-00C0268E6AE8}']
    procedure connect(const hostName: WideString; const serverName: WideString; 
                      const user: WideString; const password: WideString); safecall;
    function  Get_connected: WordBool; safecall;
    function  exec(const sql: WideString): IHDataset; safecall;
    property connected: WordBool read Get_connected;
  end;

// *********************************************************************//
// DispIntf:  ITestDataDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {73DB7721-BC73-11D3-AAFA-00C0268E6AE8}
// *********************************************************************//
  ITestDataDisp = dispinterface
    ['{73DB7721-BC73-11D3-AAFA-00C0268E6AE8}']
    procedure connect(const hostName: WideString; const serverName: WideString; 
                      const user: WideString; const password: WideString); dispid 1;
    property connected: WordBool readonly dispid 2;
    function  exec(const sql: WideString): IHDataset; dispid 3;
  end;

// *********************************************************************//
// The Class CoTestData provides a Create and CreateRemote method to          
// create instances of the default interface ITestData exposed by              
// the CoClass TestData. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTestData = class
    class function Create: ITestData;
    class function CreateRemote(const MachineName: string): ITestData;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TTestData
// Help String      : TestData Object
// Default Interface: ITestData
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TTestDataProperties= class;
{$ENDIF}
  TTestData = class(TOleServer)
  private
    FIntf:        ITestData;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TTestDataProperties;
    function      GetServerProperties: TTestDataProperties;
{$ENDIF}
    function      GetDefaultInterface: ITestData;
  protected
    procedure InitServerData; override;
    function  Get_connected: WordBool;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ITestData);
    procedure Disconnect; override;
    procedure connect1(const hostName: WideString; const serverName: WideString; 
                       const user: WideString; const password: WideString);
    function  exec(const sql: WideString): IHDataset;
    property  DefaultInterface: ITestData read GetDefaultInterface;
    property connected: WordBool read Get_connected;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TTestDataProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TTestData
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TTestDataProperties = class(TPersistent)
  private
    FServer:    TTestData;
    function    GetDefaultInterface: ITestData;
    constructor Create(AServer: TTestData);
  protected
    function  Get_connected: WordBool;
  public
    property DefaultInterface: ITestData read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

implementation

uses ComObj;

class function CoTestData.Create: ITestData;
begin
  Result := CreateComObject(CLASS_TestData) as ITestData;
end;

class function CoTestData.CreateRemote(const MachineName: string): ITestData;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TestData) as ITestData;
end;

procedure TTestData.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{73DB7723-BC73-11D3-AAFA-00C0268E6AE8}';
    IntfIID:   '{73DB7721-BC73-11D3-AAFA-00C0268E6AE8}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TTestData.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ITestData;
  end;
end;

procedure TTestData.ConnectTo(svrIntf: ITestData);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TTestData.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TTestData.GetDefaultInterface: ITestData;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TTestData.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TTestDataProperties.Create(Self);
{$ENDIF}
end;

destructor TTestData.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TTestData.GetServerProperties: TTestDataProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TTestData.Get_connected: WordBool;
begin
  Result := DefaultInterface.Get_connected;
end;

procedure TTestData.connect1(const hostName: WideString; const serverName: WideString; 
                             const user: WideString; const password: WideString);
begin
  DefaultInterface.connect(hostName, serverName, user, password);
end;

function  TTestData.exec(const sql: WideString): IHDataset;
begin
  Result := DefaultInterface.exec(sql);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TTestDataProperties.Create(AServer: TTestData);
begin
  inherited Create;
  FServer := AServer;
end;

function TTestDataProperties.GetDefaultInterface: ITestData;
begin
  Result := FServer.DefaultInterface;
end;

function  TTestDataProperties.Get_connected: WordBool;
begin
  Result := DefaultInterface.Get_connected;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents('Servers',[TTestData]);
end;

end.
