unit PDG2Lib_TLB;

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

// PASTLWTR : $Revision:   1.88.1.0.1.0  $
// File generated on 2001-11-22 16:55:31 from Type Library described below.

// ************************************************************************ //
// Type Lib: D:\Program Files\SSREADER\PDG2.DLL (1)
// IID\LCID: {7F5E27C1-4A5C-11D3-9232-0000B48A05B2}\0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\STDVCL40.DLL)
// Errors:
//   Hint: Parameter 'type' of IT_Pdg01.MovePage changed to 'type_'
//   Hint: Parameter 'type' of IT_Pdg01.Print2 changed to 'type_'
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
  PDG2LibMajorVersion = 1;
  PDG2LibMinorVersion = 0;

  LIBID_PDG2Lib: TGUID = '{7F5E27C1-4A5C-11D3-9232-0000B48A05B2}';

  DIID__IT_Pdg01Events: TGUID = '{7F5E27CF-4A5C-11D3-9232-0000B48A05B2}';
  IID_IT_Pdg01: TGUID = '{7F5E27CD-4A5C-11D3-9232-0000B48A05B2}';
  CLASS_T_Pdg01: TGUID = '{7F5E27CE-4A5C-11D3-9232-0000B48A05B2}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _IT_Pdg01Events = dispinterface;
  IT_Pdg01 = interface;
  IT_Pdg01Disp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  T_Pdg01 = IT_Pdg01;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PInteger1 = ^Integer; {*}


// *********************************************************************//
// DispIntf:  _IT_Pdg01Events
// Flags:     (4096) Dispatchable
// GUID:      {7F5E27CF-4A5C-11D3-9232-0000B48A05B2}
// *********************************************************************//
  _IT_Pdg01Events = dispinterface
    ['{7F5E27CF-4A5C-11D3-9232-0000B48A05B2}']
    procedure OnInitDrawing(URL: Integer); dispid 1;
    procedure OnURL(flag: Integer); dispid 2;
    procedure OnKeyAction(flag: Integer; KeyCode: Smallint; Shift: Smallint); dispid 3;
    procedure OnMouseAction(flag: Integer; Button: Smallint; Shift: Smallint; x: Integer; y: Integer); dispid 4;
    procedure OnException(nException: Integer); dispid 5;
    procedure OnScroll(x: Integer; y: Integer); dispid 6;
    procedure OnProgress(filelength: Integer; curpos: Integer); dispid 7;
    procedure OnDownLoadProgress(ratio: Integer); dispid 8;
    procedure OnImageProgress(imageNum: Integer; curImage: Integer); dispid 9;
    procedure OnGetRemoteFileTime(const timeString: WideString); dispid 10;
    procedure OnLocateRect(left: SYSINT; top: SYSINT; right: SYSINT; bottom: SYSINT); dispid 11;
    procedure RequestUserAuth; dispid 12;
    procedure IsPrintEnabled(flag: Integer); dispid 13;
  end;

// *********************************************************************//
// Interface: IT_Pdg01
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7F5E27CD-4A5C-11D3-9232-0000B48A05B2}
// *********************************************************************//
  IT_Pdg01 = interface(IDispatch)
    ['{7F5E27CD-4A5C-11D3-9232-0000B48A05B2}']
    function  Get_URL: WideString; safecall;
    procedure Set_URL(const pVal: WideString); safecall;
    function  Get_Zoom: Single; safecall;
    procedure Set_Zoom(pVal: Single); safecall;
    function  GetBusy: Integer; safecall;
    function  Get_IsPageValid: Integer; safecall;
    procedure Set_IsPageValid(pVal: Integer); safecall;
    function  Get_PageNum: LongWord; safecall;
    procedure Set_PageNum(pVal: LongWord); safecall;
    function  Get_PageWidth: Integer; safecall;
    procedure Set_PageWidth(pVal: Integer); safecall;
    function  Get_PageHeight: Integer; safecall;
    procedure Set_PageHeight(pVal: Integer); safecall;
    procedure Stop; safecall;
    procedure Refresh; safecall;
    procedure LoadPage(const URL: WideString; x: Integer; y: Integer; Zoom: Single); safecall;
    procedure MovePage(type_: Integer); safecall;
    procedure GotoNextPage; safecall;
    procedure GotoPreviousPage; safecall;
    procedure GotoPageNum(PageNum: LongWord); safecall;
    procedure GetFileLength(const URL: WideString; var pLen: Integer); safecall;
    procedure MoveStep(HStep: Integer; VStep: Integer); safecall;
    procedure AboutBox; safecall;
    procedure Set_ProxyName(const ProxyName: WideString); safecall;
    function  Get_ProxyName: WideString; safecall;
    procedure Set_ProxyUserName(const proxyUser: WideString); safecall;
    function  Get_ProxyUserName: WideString; safecall;
    procedure Set_ProxyPassword(const ProxyPassword: WideString); safecall;
    function  Get_ProxyPassword: WideString; safecall;
    procedure Set_ProxyPort(ProxyPort: Integer); safecall;
    function  Get_ProxyPort: Integer; safecall;
    function  Get_CurStatus: Integer; safecall;
    procedure Set_CurStatus(pVal: Integer); safecall;
    procedure GotoDirNum(dirNum: LongWord); safecall;
    procedure MoveTo(x: LongWord; y: LongWord); safecall;
    procedure GetPageRect(out left: Integer; out top: Integer; out right: Integer; 
                          out bottom: Integer); safecall;
    function  Get_isDir: Integer; safecall;
    function  Get_ImageType: Integer; safecall;
    function  Get_SerialNum: Integer; safecall;
    function  Get_dpi: Integer; safecall;
    procedure Set_dpi(pVal: Integer); safecall;
    function  Get_TotalSifPageNum: Integer; safecall;
    procedure GotoContentNum(PageNum: LongWord); safecall;
    function  Get_ZoomMode: Integer; safecall;
    procedure Set_ZoomMode(pVal: Integer); safecall;
    procedure SetZoom2(Zoom: Single); safecall;
    function  Get_OrgPageWidth: Integer; safecall;
    procedure Set_OrgPageWidth(pVal: Integer); safecall;
    function  Get_OrgPageHeight: Integer; safecall;
    procedure Set_OrgPageHeight(pVal: Integer); safecall;
    procedure GetViewPoint(out x: LongWord; out y: LongWord); safecall;
    function  Get_BackColor: OLE_COLOR; safecall;
    procedure Set_BackColor(pVal: OLE_COLOR); safecall;
    procedure GotoBookPage(const URL: WideString; PageNum: LongWord; isDir: Integer); safecall;
    procedure CopyToClipBoard(left: LongWord; top: LongWord; right: LongWord; bottom: LongWord); safecall;
    procedure Print(const URL: WideString; PageNum: LongWord; b2in1: Integer; 
                    isdoubleside: Integer; Zoom: LongWord); safecall;
    procedure StopPrint; safecall;
    procedure SetLocalZoom(zoomratio: Single); safecall;
    function  Get_ViewPoint_y: Integer; safecall;
    procedure Set_ViewPoint_y(pVal: Integer); safecall;
    function  Get_ViewPoint_x: Integer; safecall;
    procedure Set_ViewPoint_x(pVal: Integer); safecall;
    function  Get_LocalZoomHeight: Single; safecall;
    procedure Set_LocalZoomHeight(pVal: Single); safecall;
    function  Get_Zoom2Height: Integer; safecall;
    procedure Set_Zoom2Height(pVal: Integer); safecall;
    function  Get_Zoom2Width: Integer; safecall;
    procedure Set_Zoom2Width(pVal: Integer); safecall;
    procedure SetLocalZoom2(zoomratio: Single); safecall;
    procedure Rotate(rotation: LongWord); safecall;
    procedure Print2(beginpage: LongWord; PageNum: LongWord; type_: LongWord; b2in1: Integer; 
                     isdoubleside: Integer; Zoom: LongWord); safecall;
    procedure DownLoad(const URL: WideString; const filename: WideString); safecall;
    procedure StopDownLoad; safecall;
    function  SetBkBmp(hNewBmp: LongWord): LongWord; safecall;
    function  Get_BkMode: Integer; safecall;
    procedure Set_BkMode(pVal: Integer); safecall;
    function  Get_hBkPic: Integer; safecall;
    procedure Set_hBkPic(pVal: Integer); safecall;
    function  Get_isDrawImage: Integer; safecall;
    procedure Set_isDrawImage(pVal: Integer); safecall;
    function  Get_FontBkColor: Integer; safecall;
    procedure Set_FontBkColor(pVal: Integer); safecall;
    function  Get_FontFrColor: Integer; safecall;
    procedure Set_FontFrColor(pVal: Integer); safecall;
    procedure GetRemoteFileTime(const filename: WideString); safecall;
    procedure CleanUp; safecall;
    procedure LocateRect; safecall;
    function  Get_HDDKey: Integer; safecall;
    procedure Set_HDDKey(pVal: Integer); safecall;
    function  Get_UserAcount: Integer; safecall;
    procedure Set_UserAcount(pVal: Integer); safecall;
    procedure EndLocateRect; safecall;
    function  Get_PublicKey: WideString; safecall;
    procedure Set_PublicKey(const pVal: WideString); safecall;
    function  Register(const RegCode: WideString): Integer; safecall;
    procedure SetUserAuth(const UserName: WideString; const Password: WideString); safecall;
    function  OcrText(const path: WideString; left: LongWord; top: LongWord; right: LongWord; 
                      bottom: LongWord): Integer; safecall;
    procedure AddOcrMaskRect(x: LongWord; y: LongWord; xdis: LongWord; ydis: LongWord; 
                             color: OLE_COLOR); safecall;
    procedure LoadSifPage(const URL: WideString; x: Integer; y: Integer; Zoom: Single; 
                          PageNum: Integer); safecall;
    property URL: WideString read Get_URL write Set_URL;
    property Zoom: Single read Get_Zoom write Set_Zoom;
    property IsPageValid: Integer read Get_IsPageValid write Set_IsPageValid;
    property PageNum: LongWord read Get_PageNum write Set_PageNum;
    property PageWidth: Integer read Get_PageWidth write Set_PageWidth;
    property PageHeight: Integer read Get_PageHeight write Set_PageHeight;
    property ProxyName: WideString read Get_ProxyName write Set_ProxyName;
    property ProxyUserName: WideString read Get_ProxyUserName write Set_ProxyUserName;
    property ProxyPassword: WideString read Get_ProxyPassword write Set_ProxyPassword;
    property ProxyPort: Integer read Get_ProxyPort write Set_ProxyPort;
    property CurStatus: Integer read Get_CurStatus write Set_CurStatus;
    property isDir: Integer read Get_isDir;
    property ImageType: Integer read Get_ImageType;
    property SerialNum: Integer read Get_SerialNum;
    property dpi: Integer read Get_dpi write Set_dpi;
    property TotalSifPageNum: Integer read Get_TotalSifPageNum;
    property ZoomMode: Integer read Get_ZoomMode write Set_ZoomMode;
    property OrgPageWidth: Integer read Get_OrgPageWidth write Set_OrgPageWidth;
    property OrgPageHeight: Integer read Get_OrgPageHeight write Set_OrgPageHeight;
    property BackColor: OLE_COLOR read Get_BackColor write Set_BackColor;
    property ViewPoint_y: Integer read Get_ViewPoint_y write Set_ViewPoint_y;
    property ViewPoint_x: Integer read Get_ViewPoint_x write Set_ViewPoint_x;
    property LocalZoomHeight: Single read Get_LocalZoomHeight write Set_LocalZoomHeight;
    property Zoom2Height: Integer read Get_Zoom2Height write Set_Zoom2Height;
    property Zoom2Width: Integer read Get_Zoom2Width write Set_Zoom2Width;
    property BkMode: Integer read Get_BkMode write Set_BkMode;
    property hBkPic: Integer read Get_hBkPic write Set_hBkPic;
    property isDrawImage: Integer read Get_isDrawImage write Set_isDrawImage;
    property FontBkColor: Integer read Get_FontBkColor write Set_FontBkColor;
    property FontFrColor: Integer read Get_FontFrColor write Set_FontFrColor;
    property HDDKey: Integer read Get_HDDKey write Set_HDDKey;
    property UserAcount: Integer read Get_UserAcount write Set_UserAcount;
    property PublicKey: WideString read Get_PublicKey write Set_PublicKey;
  end;

// *********************************************************************//
// DispIntf:  IT_Pdg01Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7F5E27CD-4A5C-11D3-9232-0000B48A05B2}
// *********************************************************************//
  IT_Pdg01Disp = dispinterface
    ['{7F5E27CD-4A5C-11D3-9232-0000B48A05B2}']
    property URL: WideString dispid 1;
    property Zoom: Single dispid 2;
    function  GetBusy: Integer; dispid 3;
    property IsPageValid: Integer dispid 4;
    property PageNum: LongWord dispid 5;
    property PageWidth: Integer dispid 6;
    property PageHeight: Integer dispid 7;
    procedure Stop; dispid 8;
    procedure Refresh; dispid 9;
    procedure LoadPage(const URL: WideString; x: Integer; y: Integer; Zoom: Single); dispid 10;
    procedure MovePage(type_: Integer); dispid 11;
    procedure GotoNextPage; dispid 12;
    procedure GotoPreviousPage; dispid 13;
    procedure GotoPageNum(PageNum: LongWord); dispid 14;
    procedure GetFileLength(const URL: WideString; var pLen: Integer); dispid 15;
    procedure MoveStep(HStep: Integer; VStep: Integer); dispid 17;
    procedure AboutBox; dispid 18;
    property ProxyName: WideString dispid 19;
    property ProxyUserName: WideString dispid 20;
    property ProxyPassword: WideString dispid 21;
    property ProxyPort: Integer dispid 22;
    property CurStatus: Integer dispid 23;
    procedure GotoDirNum(dirNum: LongWord); dispid 24;
    procedure MoveTo(x: LongWord; y: LongWord); dispid 25;
    procedure GetPageRect(out left: Integer; out top: Integer; out right: Integer; 
                          out bottom: Integer); dispid 26;
    property isDir: Integer readonly dispid 27;
    property ImageType: Integer readonly dispid 28;
    property SerialNum: Integer readonly dispid 29;
    property dpi: Integer dispid 30;
    property TotalSifPageNum: Integer readonly dispid 31;
    procedure GotoContentNum(PageNum: LongWord); dispid 32;
    property ZoomMode: Integer dispid 33;
    procedure SetZoom2(Zoom: Single); dispid 34;
    property OrgPageWidth: Integer dispid 35;
    property OrgPageHeight: Integer dispid 36;
    procedure GetViewPoint(out x: LongWord; out y: LongWord); dispid 37;
    property BackColor: OLE_COLOR dispid 38;
    procedure GotoBookPage(const URL: WideString; PageNum: LongWord; isDir: Integer); dispid 40;
    procedure CopyToClipBoard(left: LongWord; top: LongWord; right: LongWord; bottom: LongWord); dispid 41;
    procedure Print(const URL: WideString; PageNum: LongWord; b2in1: Integer; 
                    isdoubleside: Integer; Zoom: LongWord); dispid 42;
    procedure StopPrint; dispid 43;
    procedure SetLocalZoom(zoomratio: Single); dispid 44;
    property ViewPoint_y: Integer dispid 45;
    property ViewPoint_x: Integer dispid 46;
    property LocalZoomHeight: Single dispid 47;
    property Zoom2Height: Integer dispid 48;
    property Zoom2Width: Integer dispid 49;
    procedure SetLocalZoom2(zoomratio: Single); dispid 50;
    procedure Rotate(rotation: LongWord); dispid 51;
    procedure Print2(beginpage: LongWord; PageNum: LongWord; type_: LongWord; b2in1: Integer; 
                     isdoubleside: Integer; Zoom: LongWord); dispid 52;
    procedure DownLoad(const URL: WideString; const filename: WideString); dispid 53;
    procedure StopDownLoad; dispid 54;
    function  SetBkBmp(hNewBmp: LongWord): LongWord; dispid 55;
    property BkMode: Integer dispid 56;
    property hBkPic: Integer dispid 57;
    property isDrawImage: Integer dispid 58;
    property FontBkColor: Integer dispid 59;
    property FontFrColor: Integer dispid 60;
    procedure GetRemoteFileTime(const filename: WideString); dispid 61;
    procedure CleanUp; dispid 62;
    procedure LocateRect; dispid 63;
    property HDDKey: Integer dispid 64;
    property UserAcount: Integer dispid 65;
    procedure EndLocateRect; dispid 66;
    property PublicKey: WideString dispid 67;
    function  Register(const RegCode: WideString): Integer; dispid 68;
    procedure SetUserAuth(const UserName: WideString; const Password: WideString); dispid 69;
    function  OcrText(const path: WideString; left: LongWord; top: LongWord; right: LongWord; 
                      bottom: LongWord): Integer; dispid 70;
    procedure AddOcrMaskRect(x: LongWord; y: LongWord; xdis: LongWord; ydis: LongWord; 
                             color: OLE_COLOR); dispid 71;
    procedure LoadSifPage(const URL: WideString; x: Integer; y: Integer; Zoom: Single; 
                          PageNum: Integer); dispid 76;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TT_Pdg01
// Help String      : Pdg2 Control
// Default Interface: IT_Pdg01
// Def. Intf. DISP? : No
// Event   Interface: _IT_Pdg01Events
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TT_Pdg01OnInitDrawing = procedure(Sender: TObject; URL: Integer) of object;
  TT_Pdg01OnURL = procedure(Sender: TObject; flag: Integer) of object;
  TT_Pdg01OnKeyAction = procedure(Sender: TObject; flag: Integer; KeyCode: Smallint; Shift: Smallint) of object;
  TT_Pdg01OnMouseAction = procedure(Sender: TObject; flag: Integer; Button: Smallint; 
                                                     Shift: Smallint; x: Integer; y: Integer) of object;
  TT_Pdg01OnException = procedure(Sender: TObject; nException: Integer) of object;
  TT_Pdg01OnScroll = procedure(Sender: TObject; x: Integer; y: Integer) of object;
  TT_Pdg01OnProgress = procedure(Sender: TObject; filelength: Integer; curpos: Integer) of object;
  TT_Pdg01OnDownLoadProgress = procedure(Sender: TObject; ratio: Integer) of object;
  TT_Pdg01OnImageProgress = procedure(Sender: TObject; imageNum: Integer; curImage: Integer) of object;
  TT_Pdg01OnGetRemoteFileTime = procedure(Sender: TObject; const timeString: WideString) of object;
  TT_Pdg01OnLocateRect = procedure(Sender: TObject; left: SYSINT; top: SYSINT; right: SYSINT; 
                                                    bottom: SYSINT) of object;
  TT_Pdg01IsPrintEnabled = procedure(Sender: TObject; flag: Integer) of object;

  TT_Pdg01 = class(TOleControl)
  private
    FOnInitDrawing: TT_Pdg01OnInitDrawing;
    FOnURL: TT_Pdg01OnURL;
    FOnKeyAction: TT_Pdg01OnKeyAction;
    FOnMouseAction: TT_Pdg01OnMouseAction;
    FOnException: TT_Pdg01OnException;
    FOnScroll: TT_Pdg01OnScroll;
    FOnProgress: TT_Pdg01OnProgress;
    FOnDownLoadProgress: TT_Pdg01OnDownLoadProgress;
    FOnImageProgress: TT_Pdg01OnImageProgress;
    FOnGetRemoteFileTime: TT_Pdg01OnGetRemoteFileTime;
    FOnLocateRect: TT_Pdg01OnLocateRect;
    FOnRequestUserAuth: TNotifyEvent;
    FOnIsPrintEnabled: TT_Pdg01IsPrintEnabled;
    FIntf: IT_Pdg01;
    function  GetControlInterface: IT_Pdg01;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function  GetBusy: Integer;
    procedure Stop;
    procedure Refresh;
    procedure LoadPage(const URL: WideString; x: Integer; y: Integer; Zoom: Single);
    procedure MovePage(type_: Integer);
    procedure GotoNextPage;
    procedure GotoPreviousPage;
    procedure GotoPageNum(PageNum: LongWord);
    procedure GetFileLength(const URL: WideString; var pLen: Integer);
    procedure MoveStep(HStep: Integer; VStep: Integer);
    procedure AboutBox;
    procedure GotoDirNum(dirNum: LongWord);
    procedure MoveTo(x: LongWord; y: LongWord);
    procedure GetPageRect(out left: Integer; out top: Integer; out right: Integer; 
                          out bottom: Integer);
    procedure GotoContentNum(PageNum: LongWord);
    procedure SetZoom2(Zoom: Single);
    procedure GetViewPoint(out x: LongWord; out y: LongWord);
    procedure GotoBookPage(const URL: WideString; PageNum: LongWord; isDir: Integer);
    procedure CopyToClipBoard(left: LongWord; top: LongWord; right: LongWord; bottom: LongWord);
    procedure Print(const URL: WideString; PageNum: LongWord; b2in1: Integer; 
                    isdoubleside: Integer; Zoom: LongWord);
    procedure StopPrint;
    procedure SetLocalZoom(zoomratio: Single);
    procedure SetLocalZoom2(zoomratio: Single);
    procedure Rotate(rotation: LongWord);
    procedure Print2(beginpage: LongWord; PageNum: LongWord; type_: LongWord; b2in1: Integer; 
                     isdoubleside: Integer; Zoom: LongWord);
    procedure DownLoad(const URL: WideString; const filename: WideString);
    procedure StopDownLoad;
    function  SetBkBmp(hNewBmp: LongWord): LongWord;
    procedure GetRemoteFileTime(const filename: WideString);
    procedure CleanUp;
    procedure LocateRect;
    procedure EndLocateRect;
    function  Register(const RegCode: WideString): Integer;
    procedure SetUserAuth(const UserName: WideString; const Password: WideString);
    function  OcrText(const path: WideString; left: LongWord; top: LongWord; right: LongWord; 
                      bottom: LongWord): Integer;
    procedure AddOcrMaskRect(x: LongWord; y: LongWord; xdis: LongWord; ydis: LongWord; 
                             color: OLE_COLOR);
    procedure LoadSifPage(const URL: WideString; x: Integer; y: Integer; Zoom: Single; 
                          PageNum: Integer);
    property  ControlInterface: IT_Pdg01 read GetControlInterface;
    property  DefaultInterface: IT_Pdg01 read GetControlInterface;
    property isDir: Integer index 27 read GetIntegerProp;
    property ImageType: Integer index 28 read GetIntegerProp;
    property SerialNum: Integer index 29 read GetIntegerProp;
    property TotalSifPageNum: Integer index 31 read GetIntegerProp;
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
    property URL: WideString index 1 read GetWideStringProp write SetWideStringProp stored False;
    property Zoom: Single index 2 read GetSingleProp write SetSingleProp stored False;
    property IsPageValid: Integer index 4 read GetIntegerProp write SetIntegerProp stored False;
    property PageNum: Integer index 5 read GetIntegerProp write SetIntegerProp stored False;
    property PageWidth: Integer index 6 read GetIntegerProp write SetIntegerProp stored False;
    property PageHeight: Integer index 7 read GetIntegerProp write SetIntegerProp stored False;
    property ProxyName: WideString index 19 read GetWideStringProp write SetWideStringProp stored False;
    property ProxyUserName: WideString index 20 read GetWideStringProp write SetWideStringProp stored False;
    property ProxyPassword: WideString index 21 read GetWideStringProp write SetWideStringProp stored False;
    property ProxyPort: Integer index 22 read GetIntegerProp write SetIntegerProp stored False;
    property CurStatus: Integer index 23 read GetIntegerProp write SetIntegerProp stored False;
    property dpi: Integer index 30 read GetIntegerProp write SetIntegerProp stored False;
    property ZoomMode: Integer index 33 read GetIntegerProp write SetIntegerProp stored False;
    property OrgPageWidth: Integer index 35 read GetIntegerProp write SetIntegerProp stored False;
    property OrgPageHeight: Integer index 36 read GetIntegerProp write SetIntegerProp stored False;
    property BackColor: TColor index 38 read GetTColorProp write SetTColorProp stored False;
    property ViewPoint_y: Integer index 45 read GetIntegerProp write SetIntegerProp stored False;
    property ViewPoint_x: Integer index 46 read GetIntegerProp write SetIntegerProp stored False;
    property LocalZoomHeight: Single index 47 read GetSingleProp write SetSingleProp stored False;
    property Zoom2Height: Integer index 48 read GetIntegerProp write SetIntegerProp stored False;
    property Zoom2Width: Integer index 49 read GetIntegerProp write SetIntegerProp stored False;
    property BkMode: Integer index 56 read GetIntegerProp write SetIntegerProp stored False;
    property hBkPic: Integer index 57 read GetIntegerProp write SetIntegerProp stored False;
    property isDrawImage: Integer index 58 read GetIntegerProp write SetIntegerProp stored False;
    property FontBkColor: Integer index 59 read GetIntegerProp write SetIntegerProp stored False;
    property FontFrColor: Integer index 60 read GetIntegerProp write SetIntegerProp stored False;
    property HDDKey: Integer index 64 read GetIntegerProp write SetIntegerProp stored False;
    property UserAcount: Integer index 65 read GetIntegerProp write SetIntegerProp stored False;
    property PublicKey: WideString index 67 read GetWideStringProp write SetWideStringProp stored False;
    property OnInitDrawing: TT_Pdg01OnInitDrawing read FOnInitDrawing write FOnInitDrawing;
    property OnURL: TT_Pdg01OnURL read FOnURL write FOnURL;
    property OnKeyAction: TT_Pdg01OnKeyAction read FOnKeyAction write FOnKeyAction;
    property OnMouseAction: TT_Pdg01OnMouseAction read FOnMouseAction write FOnMouseAction;
    property OnException: TT_Pdg01OnException read FOnException write FOnException;
    property OnScroll: TT_Pdg01OnScroll read FOnScroll write FOnScroll;
    property OnProgress: TT_Pdg01OnProgress read FOnProgress write FOnProgress;
    property OnDownLoadProgress: TT_Pdg01OnDownLoadProgress read FOnDownLoadProgress write FOnDownLoadProgress;
    property OnImageProgress: TT_Pdg01OnImageProgress read FOnImageProgress write FOnImageProgress;
    property OnGetRemoteFileTime: TT_Pdg01OnGetRemoteFileTime read FOnGetRemoteFileTime write FOnGetRemoteFileTime;
    property OnLocateRect: TT_Pdg01OnLocateRect read FOnLocateRect write FOnLocateRect;
    property OnRequestUserAuth: TNotifyEvent read FOnRequestUserAuth write FOnRequestUserAuth;
    property OnIsPrintEnabled: TT_Pdg01IsPrintEnabled read FOnIsPrintEnabled write FOnIsPrintEnabled;
  end;

procedure Register;

implementation

uses ComObj;

procedure TT_Pdg01.InitControlData;
const
  CEventDispIDs: array [0..12] of DWORD = (
    $00000001, $00000002, $00000003, $00000004, $00000005, $00000006,
    $00000007, $00000008, $00000009, $0000000A, $0000000B, $0000000C,
    $0000000D);
  CLicenseKey: array[0..30] of Word = ( $0043, $006F, $0070, $0079, $0072, $0069, $0067, $0068, $0074, $0020, $0028
    , $0063, $0029, $0020, $0031, $0039, $0039, $0038, $0020, $5317, $4EAC
    , $5E02, $8D85, $661F, $7535, $5B50, $6280, $672F, $516C, $53F8, $0000);
  CControlData: TControlData2 = (
    ClassID: '{7F5E27CE-4A5C-11D3-9232-0000B48A05B2}';
    EventIID: '{7F5E27CF-4A5C-11D3-9232-0000B48A05B2}';
    EventCount: 13;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: @CLicenseKey;
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnInitDrawing) - Cardinal(Self);
end;

procedure TT_Pdg01.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IT_Pdg01;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TT_Pdg01.GetControlInterface: IT_Pdg01;
begin
  CreateControl;
  Result := FIntf;
end;

function  TT_Pdg01.GetBusy: Integer;
begin
  Result := DefaultInterface.GetBusy;
end;

procedure TT_Pdg01.Stop;
begin
  DefaultInterface.Stop;
end;

procedure TT_Pdg01.Refresh;
begin
  DefaultInterface.Refresh;
end;

procedure TT_Pdg01.LoadPage(const URL: WideString; x: Integer; y: Integer; Zoom: Single);
begin
  DefaultInterface.LoadPage(URL, x, y, Zoom);
end;

procedure TT_Pdg01.MovePage(type_: Integer);
begin
  DefaultInterface.MovePage(type_);
end;

procedure TT_Pdg01.GotoNextPage;
begin
  DefaultInterface.GotoNextPage;
end;

procedure TT_Pdg01.GotoPreviousPage;
begin
  DefaultInterface.GotoPreviousPage;
end;

procedure TT_Pdg01.GotoPageNum(PageNum: LongWord);
begin
  DefaultInterface.GotoPageNum(PageNum);
end;

procedure TT_Pdg01.GetFileLength(const URL: WideString; var pLen: Integer);
begin
  DefaultInterface.GetFileLength(URL, pLen);
end;

procedure TT_Pdg01.MoveStep(HStep: Integer; VStep: Integer);
begin
  DefaultInterface.MoveStep(HStep, VStep);
end;

procedure TT_Pdg01.AboutBox;
begin
  DefaultInterface.AboutBox;
end;

procedure TT_Pdg01.GotoDirNum(dirNum: LongWord);
begin
  DefaultInterface.GotoDirNum(dirNum);
end;

procedure TT_Pdg01.MoveTo(x: LongWord; y: LongWord);
begin
  DefaultInterface.MoveTo(x, y);
end;

procedure TT_Pdg01.GetPageRect(out left: Integer; out top: Integer; out right: Integer; 
                               out bottom: Integer);
begin
  DefaultInterface.GetPageRect(left, top, right, bottom);
end;

procedure TT_Pdg01.GotoContentNum(PageNum: LongWord);
begin
  DefaultInterface.GotoContentNum(PageNum);
end;

procedure TT_Pdg01.SetZoom2(Zoom: Single);
begin
  DefaultInterface.SetZoom2(Zoom);
end;

procedure TT_Pdg01.GetViewPoint(out x: LongWord; out y: LongWord);
begin
  DefaultInterface.GetViewPoint(x, y);
end;

procedure TT_Pdg01.GotoBookPage(const URL: WideString; PageNum: LongWord; isDir: Integer);
begin
  DefaultInterface.GotoBookPage(URL, PageNum, isDir);
end;

procedure TT_Pdg01.CopyToClipBoard(left: LongWord; top: LongWord; right: LongWord; bottom: LongWord);
begin
  DefaultInterface.CopyToClipBoard(left, top, right, bottom);
end;

procedure TT_Pdg01.Print(const URL: WideString; PageNum: LongWord; b2in1: Integer; 
                         isdoubleside: Integer; Zoom: LongWord);
begin
  DefaultInterface.Print(URL, PageNum, b2in1, isdoubleside, Zoom);
end;

procedure TT_Pdg01.StopPrint;
begin
  DefaultInterface.StopPrint;
end;

procedure TT_Pdg01.SetLocalZoom(zoomratio: Single);
begin
  DefaultInterface.SetLocalZoom(zoomratio);
end;

procedure TT_Pdg01.SetLocalZoom2(zoomratio: Single);
begin
  DefaultInterface.SetLocalZoom2(zoomratio);
end;

procedure TT_Pdg01.Rotate(rotation: LongWord);
begin
  DefaultInterface.Rotate(rotation);
end;

procedure TT_Pdg01.Print2(beginpage: LongWord; PageNum: LongWord; type_: LongWord; b2in1: Integer; 
                          isdoubleside: Integer; Zoom: LongWord);
begin
  DefaultInterface.Print2(beginpage, PageNum, type_, b2in1, isdoubleside, Zoom);
end;

procedure TT_Pdg01.DownLoad(const URL: WideString; const filename: WideString);
begin
  DefaultInterface.DownLoad(URL, filename);
end;

procedure TT_Pdg01.StopDownLoad;
begin
  DefaultInterface.StopDownLoad;
end;

function  TT_Pdg01.SetBkBmp(hNewBmp: LongWord): LongWord;
begin
  Result := DefaultInterface.SetBkBmp(hNewBmp);
end;

procedure TT_Pdg01.GetRemoteFileTime(const filename: WideString);
begin
  DefaultInterface.GetRemoteFileTime(filename);
end;

procedure TT_Pdg01.CleanUp;
begin
  DefaultInterface.CleanUp;
end;

procedure TT_Pdg01.LocateRect;
begin
  DefaultInterface.LocateRect;
end;

procedure TT_Pdg01.EndLocateRect;
begin
  DefaultInterface.EndLocateRect;
end;

function  TT_Pdg01.Register(const RegCode: WideString): Integer;
begin
  Result := DefaultInterface.Register(RegCode);
end;

procedure TT_Pdg01.SetUserAuth(const UserName: WideString; const Password: WideString);
begin
  DefaultInterface.SetUserAuth(UserName, Password);
end;

function  TT_Pdg01.OcrText(const path: WideString; left: LongWord; top: LongWord; right: LongWord; 
                           bottom: LongWord): Integer;
begin
  Result := DefaultInterface.OcrText(path, left, top, right, bottom);
end;

procedure TT_Pdg01.AddOcrMaskRect(x: LongWord; y: LongWord; xdis: LongWord; ydis: LongWord; 
                                  color: OLE_COLOR);
begin
  DefaultInterface.AddOcrMaskRect(x, y, xdis, ydis, color);
end;

procedure TT_Pdg01.LoadSifPage(const URL: WideString; x: Integer; y: Integer; Zoom: Single; 
                               PageNum: Integer);
begin
  DefaultInterface.LoadSifPage(URL, x, y, Zoom, PageNum);
end;

procedure Register;
begin
  RegisterComponents('ActiveX',[TT_Pdg01]);
end;

end.
