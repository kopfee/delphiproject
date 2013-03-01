unit DIRECTORSHOCKWAVELib_TLB;

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
// File generated on 98-10-13 10:34:53 from Type Library described below.

// ************************************************************************ //
// Type Lib: C:\PWIN98.NEW\SYSTEM\MACROMED\DIRECTOR\SWDIR.DLL
// IID\LCID: {166B1BC7-3F9C-11CF-8075-444553540000}\0
// Helpfile: 
// HelpString: Macromedia Shockwave Director Control
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
  LIBID_DIRECTORSHOCKWAVELib: TGUID = '{166B1BC7-3F9C-11CF-8075-444553540000}';
  DIID__ShockwaveEvents: TGUID = '{166B1BC9-3F9C-11CF-8075-444553540000}';
  IID_IShockwaveCtl: TGUID = '{166B1BC8-3F9C-11CF-8075-444553540000}';
  CLASS_ShockwaveCtl: TGUID = '{166B1BCA-3F9C-11CF-8075-444553540000}';
type

// *********************************************************************//
// Forward declaration of interfaces defined in Type Library            //
// *********************************************************************//
  _ShockwaveEvents = dispinterface;
  IShockwaveCtl = interface;
  IShockwaveCtlDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                     //
// (NOTE: Here we map each CoClass to its Default Interface)            //
// *********************************************************************//
  ShockwaveCtl = IShockwaveCtl;


// *********************************************************************//
// DispIntf:  _ShockwaveEvents
// Flags:     (4096) Dispatchable
// GUID:      {166B1BC9-3F9C-11CF-8075-444553540000}
// *********************************************************************//
  _ShockwaveEvents = dispinterface
    ['{166B1BC9-3F9C-11CF-8075-444553540000}']
    procedure ExternalEvent(const bstrEvent: WideString); dispid 1;
    procedure Progress(percentComplete: Integer); dispid 2;
    procedure ReadyStateChange(newState: Integer); dispid -609;
  end;

// *********************************************************************//
// Interface: IShockwaveCtl
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {166B1BC8-3F9C-11CF-8075-444553540000}
// *********************************************************************//
  IShockwaveCtl = interface(IDispatch)
    ['{166B1BC8-3F9C-11CF-8075-444553540000}']
    function Get_BGCOLOR: WideString; safecall;
    procedure Set_BGCOLOR(const pVal: WideString); safecall;
    function Get_swURL: WideString; safecall;
    procedure Set_swURL(const pVal: WideString); safecall;
    function Get_swText: WideString; safecall;
    procedure Set_swText(const pVal: WideString); safecall;
    function Get_swForeColor: WideString; safecall;
    procedure Set_swForeColor(const pVal: WideString); safecall;
    function Get_swBackColor: WideString; safecall;
    procedure Set_swBackColor(const pVal: WideString); safecall;
    function Get_swFrame: WideString; safecall;
    procedure Set_swFrame(const pVal: WideString); safecall;
    function Get_swColor: WideString; safecall;
    procedure Set_swColor(const pVal: WideString); safecall;
    function Get_swName: WideString; safecall;
    procedure Set_swName(const pVal: WideString); safecall;
    function Get_swPassword: WideString; safecall;
    procedure Set_swPassword(const pVal: WideString); safecall;
    function Get_swBanner: WideString; safecall;
    procedure Set_swBanner(const pVal: WideString); safecall;
    function Get_swSound: WideString; safecall;
    procedure Set_swSound(const pVal: WideString); safecall;
    function Get_swVolume: WideString; safecall;
    procedure Set_swVolume(const pVal: WideString); safecall;
    function Get_swPreloadTime: WideString; safecall;
    procedure Set_swPreloadTime(const pVal: WideString); safecall;
    function Get_swAudio: WideString; safecall;
    procedure Set_swAudio(const pVal: WideString); safecall;
    function Get_swList: WideString; safecall;
    procedure Set_swList(const pVal: WideString); safecall;
    function Get_sw1: WideString; safecall;
    procedure Set_sw1(const pVal: WideString); safecall;
    function Get_sw2: WideString; safecall;
    procedure Set_sw2(const pVal: WideString); safecall;
    function Get_sw3: WideString; safecall;
    procedure Set_sw3(const pVal: WideString); safecall;
    function Get_sw4: WideString; safecall;
    procedure Set_sw4(const pVal: WideString); safecall;
    function Get_sw5: WideString; safecall;
    procedure Set_sw5(const pVal: WideString); safecall;
    function Get_sw6: WideString; safecall;
    procedure Set_sw6(const pVal: WideString); safecall;
    function Get_sw7: WideString; safecall;
    procedure Set_sw7(const pVal: WideString); safecall;
    function Get_sw8: WideString; safecall;
    procedure Set_sw8(const pVal: WideString); safecall;
    function Get_sw9: WideString; safecall;
    procedure Set_sw9(const pVal: WideString); safecall;
    function Get_SRC: WideString; safecall;
    procedure Set_SRC(const pVal: WideString); safecall;
    function Get_AutoStart: Integer; safecall;
    procedure Set_AutoStart(pVal: Integer); safecall;
    function Get_Sound: Integer; safecall;
    procedure Set_Sound(pVal: Integer); safecall;
    procedure Play; safecall;
    procedure Stop; safecall;
    procedure Rewind; safecall;
    function GetCurrentFrame: Integer; safecall;
    procedure GotoFrame(FrameNumber: Integer); safecall;
    procedure GotoMovie(const MovieUrl: WideString); safecall;
    function EvalScript(const LingoScript: WideString): WideString; safecall;
    property BGCOLOR: WideString read Get_BGCOLOR write Set_BGCOLOR;
    property swURL: WideString read Get_swURL write Set_swURL;
    property swText: WideString read Get_swText write Set_swText;
    property swForeColor: WideString read Get_swForeColor write Set_swForeColor;
    property swBackColor: WideString read Get_swBackColor write Set_swBackColor;
    property swFrame: WideString read Get_swFrame write Set_swFrame;
    property swColor: WideString read Get_swColor write Set_swColor;
    property swName: WideString read Get_swName write Set_swName;
    property swPassword: WideString read Get_swPassword write Set_swPassword;
    property swBanner: WideString read Get_swBanner write Set_swBanner;
    property swSound: WideString read Get_swSound write Set_swSound;
    property swVolume: WideString read Get_swVolume write Set_swVolume;
    property swPreloadTime: WideString read Get_swPreloadTime write Set_swPreloadTime;
    property swAudio: WideString read Get_swAudio write Set_swAudio;
    property swList: WideString read Get_swList write Set_swList;
    property sw1: WideString read Get_sw1 write Set_sw1;
    property sw2: WideString read Get_sw2 write Set_sw2;
    property sw3: WideString read Get_sw3 write Set_sw3;
    property sw4: WideString read Get_sw4 write Set_sw4;
    property sw5: WideString read Get_sw5 write Set_sw5;
    property sw6: WideString read Get_sw6 write Set_sw6;
    property sw7: WideString read Get_sw7 write Set_sw7;
    property sw8: WideString read Get_sw8 write Set_sw8;
    property sw9: WideString read Get_sw9 write Set_sw9;
    property SRC: WideString read Get_SRC write Set_SRC;
    property AutoStart: Integer read Get_AutoStart write Set_AutoStart;
    property Sound: Integer read Get_Sound write Set_Sound;
  end;

// *********************************************************************//
// DispIntf:  IShockwaveCtlDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {166B1BC8-3F9C-11CF-8075-444553540000}
// *********************************************************************//
  IShockwaveCtlDisp = dispinterface
    ['{166B1BC8-3F9C-11CF-8075-444553540000}']
    property BGCOLOR: WideString dispid 1;
    property swURL: WideString dispid 2;
    property swText: WideString dispid 3;
    property swForeColor: WideString dispid 4;
    property swBackColor: WideString dispid 5;
    property swFrame: WideString dispid 6;
    property swColor: WideString dispid 7;
    property swName: WideString dispid 8;
    property swPassword: WideString dispid 9;
    property swBanner: WideString dispid 10;
    property swSound: WideString dispid 11;
    property swVolume: WideString dispid 12;
    property swPreloadTime: WideString dispid 13;
    property swAudio: WideString dispid 14;
    property swList: WideString dispid 15;
    property sw1: WideString dispid 16;
    property sw2: WideString dispid 17;
    property sw3: WideString dispid 18;
    property sw4: WideString dispid 19;
    property sw5: WideString dispid 20;
    property sw6: WideString dispid 21;
    property sw7: WideString dispid 22;
    property sw8: WideString dispid 23;
    property sw9: WideString dispid 24;
    property SRC: WideString dispid 25;
    property AutoStart: Integer dispid 26;
    property Sound: Integer dispid 27;
    procedure Play; dispid 28;
    procedure Stop; dispid 29;
    procedure Rewind; dispid 30;
    function GetCurrentFrame: Integer; dispid 31;
    procedure GotoFrame(FrameNumber: Integer); dispid 32;
    procedure GotoMovie(const MovieUrl: WideString); dispid 33;
    function EvalScript(const LingoScript: WideString): WideString; dispid 34;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TShockwaveCtl
// Help String      : Macromedia Shockwave Director Control
// Default Interface: IShockwaveCtl
// Def. Intf. DISP? : No
// Event   Interface: _ShockwaveEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TShockwaveCtlExternalEvent = procedure(Sender: TObject; const bstrEvent: WideString) of object;
  TShockwaveCtlProgress = procedure(Sender: TObject; percentComplete: Integer) of object;
  TShockwaveCtlReadyStateChange = procedure(Sender: TObject; newState: Integer) of object;

  TShockwaveCtl = class(TOleControl)
  private
    FOnExternalEvent: TShockwaveCtlExternalEvent;
    FOnProgress: TShockwaveCtlProgress;
    FOnReadyStateChange: TShockwaveCtlReadyStateChange;
    FIntf: IShockwaveCtl;
    function  GetControlInterface: IShockwaveCtl;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure Play;
    procedure Stop;
    procedure Rewind;
    function GetCurrentFrame(out pFrameNumber: Integer): Integer;
    procedure GotoFrame(FrameNumber: Integer);
    procedure GotoMovie(const MovieUrl: WideString);
    function EvalScript(const LingoScript: WideString; out Result_: WideString): WideString;
    property  ControlInterface: IShockwaveCtl read GetControlInterface;
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
    property BGCOLOR: WideString index 1 read GetWideStringProp write SetWideStringProp stored False;
    property swURL: WideString index 2 read GetWideStringProp write SetWideStringProp stored False;
    property swText: WideString index 3 read GetWideStringProp write SetWideStringProp stored False;
    property swForeColor: WideString index 4 read GetWideStringProp write SetWideStringProp stored False;
    property swBackColor: WideString index 5 read GetWideStringProp write SetWideStringProp stored False;
    property swFrame: WideString index 6 read GetWideStringProp write SetWideStringProp stored False;
    property swColor: WideString index 7 read GetWideStringProp write SetWideStringProp stored False;
    property swName: WideString index 8 read GetWideStringProp write SetWideStringProp stored False;
    property swPassword: WideString index 9 read GetWideStringProp write SetWideStringProp stored False;
    property swBanner: WideString index 10 read GetWideStringProp write SetWideStringProp stored False;
    property swSound: WideString index 11 read GetWideStringProp write SetWideStringProp stored False;
    property swVolume: WideString index 12 read GetWideStringProp write SetWideStringProp stored False;
    property swPreloadTime: WideString index 13 read GetWideStringProp write SetWideStringProp stored False;
    property swAudio: WideString index 14 read GetWideStringProp write SetWideStringProp stored False;
    property swList: WideString index 15 read GetWideStringProp write SetWideStringProp stored False;
    property sw1: WideString index 16 read GetWideStringProp write SetWideStringProp stored False;
    property sw2: WideString index 17 read GetWideStringProp write SetWideStringProp stored False;
    property sw3: WideString index 18 read GetWideStringProp write SetWideStringProp stored False;
    property sw4: WideString index 19 read GetWideStringProp write SetWideStringProp stored False;
    property sw5: WideString index 20 read GetWideStringProp write SetWideStringProp stored False;
    property sw6: WideString index 21 read GetWideStringProp write SetWideStringProp stored False;
    property sw7: WideString index 22 read GetWideStringProp write SetWideStringProp stored False;
    property sw8: WideString index 23 read GetWideStringProp write SetWideStringProp stored False;
    property sw9: WideString index 24 read GetWideStringProp write SetWideStringProp stored False;
    property SRC: WideString index 25 read GetWideStringProp write SetWideStringProp stored False;
    property AutoStart: Integer index 26 read GetIntegerProp write SetIntegerProp stored False;
    property Sound: Integer index 27 read GetIntegerProp write SetIntegerProp stored False;
    property OnExternalEvent: TShockwaveCtlExternalEvent read FOnExternalEvent write FOnExternalEvent;
    property OnProgress: TShockwaveCtlProgress read FOnProgress write FOnProgress;
    property OnReadyStateChange: TShockwaveCtlReadyStateChange read FOnReadyStateChange write FOnReadyStateChange;
  end;

procedure Register;

implementation

uses ComObj;

procedure TShockwaveCtl.InitControlData;
const
  CEventDispIDs: array [0..2] of DWORD = (
    $00000001, $00000002, $FFFFFD9F);
  CControlData: TControlData = (
    ClassID: '{166B1BCA-3F9C-11CF-8075-444553540000}';
    EventIID: '{166B1BC9-3F9C-11CF-8075-444553540000}';
    EventCount: 3;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil;
    Flags: $00000000;
    Version: 300);
begin
  ControlData := @CControlData;
end;

procedure TShockwaveCtl.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IShockwaveCtl;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TShockwaveCtl.GetControlInterface: IShockwaveCtl;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TShockwaveCtl.Play;
begin
  ControlInterface.Play;
end;

procedure TShockwaveCtl.Stop;
begin
  ControlInterface.Stop;
end;

procedure TShockwaveCtl.Rewind;
begin
  ControlInterface.Rewind;
end;

function TShockwaveCtl.GetCurrentFrame(out pFrameNumber: Integer): Integer;
begin
  Result := ControlInterface.GetCurrentFrame;
end;

procedure TShockwaveCtl.GotoFrame(FrameNumber: Integer);
begin
  ControlInterface.GotoFrame(FrameNumber);
end;

procedure TShockwaveCtl.GotoMovie(const MovieUrl: WideString);
begin
  ControlInterface.GotoMovie(MovieUrl);
end;

function TShockwaveCtl.EvalScript(const LingoScript: WideString; out Result_: WideString): WideString;
begin
  Result := ControlInterface.EvalScript(LingoScript);
end;

procedure Register;
begin
  RegisterComponents('ActiveX',[TShockwaveCtl]);
end;

end.
