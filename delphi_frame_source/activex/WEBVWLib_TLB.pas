unit WEBVWLib_TLB;

// ************************************************************************ //
// WARNING                                                                  //
// -------                                                                  //
// The types declared in this file were generated from data read from a     //
// Type Library. If this type library is explicitly or indirectly (via      //
// another type library referring to this type library) re-imported, or the //
// 'Refresh' command of the Type Library Editor activated while editing the //
// Type Library, the contents of this file will be regenerated and all      //
// manual modifications will be lost.                                       //
// ************************************************************************ //

// PASTLWTR : $Revision:   1.11.1.62  $
// File generated on 98-9-24 11:59:57 from Type Library described below.

// ************************************************************************ //
// Type Lib: C:\PWIN98.NEW\SYSTEM\WEBVW.DLL
// IID\LCID: {CD603FC0-1F11-11D1-9E88-00C04FDCAB92}\0
// Helpfile: 
// HelpString: webvw 1.0 Type Library
// Version:    1.0
// ************************************************************************ //

interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, StdVCL;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:      //
//   Type Libraries     : LIBID_xxxx                                    //
//   CoClasses          : CLASS_xxxx                                    //
//   DISPInterfaces     : DIID_xxxx                                     //
//   Non-DISP interfaces: IID_xxxx                                      //
// *********************************************************************//
const
  LIBID_WEBVWLib: TGUID = '{CD603FC0-1F11-11D1-9E88-00C04FDCAB92}';
  DIID_DThumbCtlEvents: TGUID = '{58D6F4B0-181D-11D1-9E88-00C04FDCAB92}';
  IID_IThumbCtl: TGUID = '{E8ACCAE0-23E6-11D1-9E88-00C04FDCAB92}';
  CLASS_ThumbCtl: TGUID = '{1D2B4F40-1F10-11D1-9E88-00C04FDCAB92}';
  IID_IWebViewFolderIcon: TGUID = '{E52B4910-3EB2-11D1-83E8-00A0C90DC849}';
  CLASS_WebViewFolderIcon: TGUID = '{E5DF9D10-3B52-11D1-83E8-00A0C90DC849}';
type

// *********************************************************************//
// Forward declaration of interfaces defined in Type Library            //
// *********************************************************************//
  DThumbCtlEvents = dispinterface;
  IThumbCtl = interface;
  IThumbCtlDisp = dispinterface;
  IWebViewFolderIcon = interface;
  IWebViewFolderIconDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                     //
// (NOTE: Here we map each CoClass to its Default Interface)            //
// *********************************************************************//
  ThumbCtl = IThumbCtl;
  WebViewFolderIcon = IWebViewFolderIcon;


// *********************************************************************//
// DispIntf:  DThumbCtlEvents
// Flags:     (4096) Dispatchable
// GUID:      {58D6F4B0-181D-11D1-9E88-00C04FDCAB92}
// *********************************************************************//
  DThumbCtlEvents = dispinterface
    ['{58D6F4B0-181D-11D1-9E88-00C04FDCAB92}']
    procedure OnThumbnailReady; dispid 200;
  end;

// *********************************************************************//
// Interface: IThumbCtl
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E8ACCAE0-23E6-11D1-9E88-00C04FDCAB92}
// *********************************************************************//
  IThumbCtl = interface(IDispatch)
    ['{E8ACCAE0-23E6-11D1-9E88-00C04FDCAB92}']
    function displayFile(const bsFileName: WideString): WordBool; safecall;
    function haveThumbnail: WordBool; safecall;
    function Get_freeSpace: WideString; safecall;
    function Get_usedSpace: WideString; safecall;
    function Get_totalSpace: WideString; safecall;
    property freeSpace: WideString read Get_freeSpace;
    property usedSpace: WideString read Get_usedSpace;
    property totalSpace: WideString read Get_totalSpace;
  end;

// *********************************************************************//
// DispIntf:  IThumbCtlDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E8ACCAE0-23E6-11D1-9E88-00C04FDCAB92}
// *********************************************************************//
  IThumbCtlDisp = dispinterface
    ['{E8ACCAE0-23E6-11D1-9E88-00C04FDCAB92}']
    function displayFile(const bsFileName: WideString): WordBool; dispid 1;
    function haveThumbnail: WordBool; dispid 2;
    property freeSpace: WideString readonly dispid 3;
    property usedSpace: WideString readonly dispid 4;
    property totalSpace: WideString readonly dispid 5;
  end;

// *********************************************************************//
// Interface: IWebViewFolderIcon
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E52B4910-3EB2-11D1-83E8-00A0C90DC849}
// *********************************************************************//
  IWebViewFolderIcon = interface(IDispatch)
    ['{E52B4910-3EB2-11D1-83E8-00A0C90DC849}']
    function Get_scale: SYSINT; safecall;
    procedure Set_scale(__MIDL_0020: SYSINT); safecall;
    property scale: SYSINT read Get_scale write Set_scale;
  end;

// *********************************************************************//
// DispIntf:  IWebViewFolderIconDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E52B4910-3EB2-11D1-83E8-00A0C90DC849}
// *********************************************************************//
  IWebViewFolderIconDisp = dispinterface
    ['{E52B4910-3EB2-11D1-83E8-00A0C90DC849}']
    property scale: SYSINT dispid 1;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TThumbCtl
// Help String      : ThumbCtl Class
// Default Interface: IThumbCtl
// Def. Intf. DISP? : No
// Event   Interface: DThumbCtlEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TThumbCtl = class(TOleControl)
  private
    FOnThumbnailReady: TNotifyEvent;
    FIntf: IThumbCtl;
    function  GetControlInterface: IThumbCtl;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function displayFile(const bsFileName: WideString; out __MIDL_0015: WordBool): WordBool;
    function haveThumbnail(out __MIDL_0016: WordBool): WordBool;
    property  ControlInterface: IThumbCtl read GetControlInterface;
    property freeSpace: WideString index 3 read GetWideStringProp;
    property usedSpace: WideString index 4 read GetWideStringProp;
    property totalSpace: WideString index 5 read GetWideStringProp;
  published
    property  TabStop;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
    property OnThumbnailReady: TNotifyEvent read FOnThumbnailReady write FOnThumbnailReady;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TWebViewFolderIcon
// Help String      : WebViewFolderIcon Class
// Default Interface: IWebViewFolderIcon
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TWebViewFolderIcon = class(TOleControl)
  private
    FIntf: IWebViewFolderIcon;
    function  GetControlInterface: IWebViewFolderIcon;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    property  ControlInterface: IWebViewFolderIcon read GetControlInterface;
  published
    property  TabStop;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
    property scale: Integer index 1 read GetIntegerProp write SetIntegerProp stored False;
  end;

procedure Register;

implementation

uses ComObj;

procedure TThumbCtl.InitControlData;
const
  CEventDispIDs: array [0..0] of DWORD = (
    $000000C8);
  CControlData: TControlData = (
    ClassID: '{1D2B4F40-1F10-11D1-9E88-00C04FDCAB92}';
    EventIID: '{58D6F4B0-181D-11D1-9E88-00C04FDCAB92}';
    EventCount: 1;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil;
    Flags: $00000000;
    Version: 300);
begin
  ControlData := @CControlData;
end;

procedure TThumbCtl.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IThumbCtl;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TThumbCtl.GetControlInterface: IThumbCtl;
begin
  CreateControl;
  Result := FIntf;
end;

function TThumbCtl.displayFile(const bsFileName: WideString; out __MIDL_0015: WordBool): WordBool;
begin
  Result := ControlInterface.displayFile(bsFileName);
end;

function TThumbCtl.haveThumbnail(out __MIDL_0016: WordBool): WordBool;
begin
  Result := ControlInterface.haveThumbnail;
end;

procedure TWebViewFolderIcon.InitControlData;
const
  CControlData: TControlData = (
    ClassID: '{E5DF9D10-3B52-11D1-83E8-00A0C90DC849}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: nil;
    Flags: $00000000;
    Version: 300);
begin
  ControlData := @CControlData;
end;

procedure TWebViewFolderIcon.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IWebViewFolderIcon;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TWebViewFolderIcon.GetControlInterface: IWebViewFolderIcon;
begin
  CreateControl;
  Result := FIntf;
end;

procedure Register;
begin
  RegisterComponents('ActiveX',[TThumbCtl, TWebViewFolderIcon]);
end;

end.
