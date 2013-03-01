unit MCI_TLB;

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
// File generated on 98-10-13 10:29:42 from Type Library described below.

// ************************************************************************ //
// Type Lib: C:\PWIN98.NEW\SYSTEM\MCI32.OCX
// IID\LCID: {C1A8AF28-1257-101B-8FB0-0020AF039CA3}\0
// Helpfile: C:\PWIN98.NEW\HELP\MMEDIA96.HLP
// HelpString: Microsoft Multimedia Control 5.0
// Version:    1.1
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
  LIBID_MCI: TGUID = '{C1A8AF28-1257-101B-8FB0-0020AF039CA3}';
  IID_IVBDataObject: TGUID = '{2334D2B1-713E-11CF-8AE5-00AA00C00905}';
  CLASS_DataObject: TGUID = '{2334D2B2-713E-11CF-8AE5-00AA00C00905}';
  IID_IVBDataObjectFiles: TGUID = '{2334D2B3-713E-11CF-8AE5-00AA00C00905}';
  CLASS_DataObjectFiles: TGUID = '{2334D2B4-713E-11CF-8AE5-00AA00C00905}';
  IID_Imci: TGUID = '{B7ABC220-DF71-11CF-8E74-00A0C90F26F8}';
  DIID_DmciEvents: TGUID = '{C1A8AF27-1257-101B-8FB0-0020AF039CA3}';
  CLASS_MMControl: TGUID = '{C1A8AF25-1257-101B-8FB0-0020AF039CA3}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                  //
// *********************************************************************//
// ErrorConstants constants
type
  ErrorConstants = TOleEnum;
const
  mciInvalidPropertyValue = $0000017C;
  mciGetNotSupported = $0000018A;
  mciSetNotSupported = $0000017F;
  mciInvalidProcedureCall = $00000005;
  mciInvalidObjectUse = $000001A9;
  mciWrongClipboardFormat = $000001CD;
  mciDataObjectLocked = $000002A0;
  mciExpectedAnArgument = $000002A1;
  mciRecursiveOleDrag = $000002A2;
  mciFormatNotByteArray = $000002A3;
  mciDataNotSetForFormat = $000002A4;
  mciCantCreateButton = $00007531;
  mciCantCreateTimer = $00007532;
  mciUnsupportedFunction = $00007534;

// BorderStyleConstants constants
type
  BorderStyleConstants = TOleEnum;
const
  mciNone = $00000000;
  mciFixedSingle = $00000001;

// RecordModeConstants constants
type
  RecordModeConstants = TOleEnum;
const
  mciRecordInsert = $00000000;
  mciRecordOverwrite = $00000001;

// MousePointerConstants constants
type
  MousePointerConstants = TOleEnum;
const
  mciDefault = $00000000;
  mciArrow = $00000001;
  mciCross = $00000002;
  mciIBeam = $00000003;
  mciIcon = $00000004;
  mciSize = $00000005;
  mciSizeNESW = $00000006;
  mciSizeNS = $00000007;
  mciSizeNWSE = $00000008;
  mciSizeEW = $00000009;
  mciUpArrow = $0000000A;
  mciHourglass = $0000000B;
  mciNoDrop = $0000000C;
  mciArrowHourglass = $0000000D;
  mciArrowQuestion = $0000000E;
  mciSizeAll = $0000000F;
  mciCustom = $00000063;

// ModeConstants constants
type
  ModeConstants = TOleEnum;
const
  mciModeNotOpen = $0000020C;
  mciModeStop = $0000020D;
  mciModePlay = $0000020E;
  mciModeRecord = $0000020F;
  mciModeSeek = $00000210;
  mciModePause = $00000211;
  mciModeReady = $00000212;

// NotifyConstants constants
type
  NotifyConstants = TOleEnum;
const
  mciNotifySuccessful = $00000001;
  mciNotifySuperseded = $00000002;
  mciAborted = $00000004;
  mciFailure = $00000008;

// OrientationConstants constants
type
  OrientationConstants = TOleEnum;
const
  mciOrientHorz = $00000000;
  mciOrientVert = $00000001;

// FormatConstants constants
type
  FormatConstants = TOleEnum;
const
  mciFormatMilliseconds = $00000000;
  mciFormatHms = $00000001;
  mciFormatMsf = $00000002;
  mciFormatFrames = $00000003;
  mciFormatSmpte24 = $00000004;
  mciFormatSmpte25 = $00000005;
  mciFormatSmpte30 = $00000006;
  mciFormatSmpte30Drop = $00000007;
  mciFormatBytes = $00000008;
  mciFormatSamples = $00000009;
  mciFormatTmsf = $0000000A;

// OLEDropConstants constants
type
  OLEDropConstants = TOleEnum;
const
  mciOLEDropNone = $00000000;
  mciOLEDropManual = $00000001;

// DragOverConstants constants
type
  DragOverConstants = TOleEnum;
const
  mciEnter = $00000000;
  mciLeave = $00000001;
  mciOver = $00000002;

// ClipBoardConstants constants
type
  ClipBoardConstants = TOleEnum;
const
  mciCFText = $00000001;
  mciCFBitmap = $00000002;
  mciCFMetafile = $00000003;
  mciCFDIB = $00000008;
  mciCFPalette = $00000009;
  mciCFEMetafile = $0000000E;
  mciCFFiles = $0000000F;
  mciCFRTF = $FFFFBF01;

// OLEDropEffectConstants constants
type
  OLEDropEffectConstants = TOleEnum;
const
  mciOLEDropEffectNone = $00000000;
  mciOLEDropEffectCopy = $00000001;
  mciOLEDropEffectMove = $00000002;
  mciOLEDropEffectScroll = $80000000;

type

// *********************************************************************//
// Forward declaration of interfaces defined in Type Library            //
// *********************************************************************//
  IVBDataObject = interface;
  IVBDataObjectDisp = dispinterface;
  IVBDataObjectFiles = interface;
  IVBDataObjectFilesDisp = dispinterface;
  Imci = interface;
  ImciDisp = dispinterface;
  DmciEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                     //
// (NOTE: Here we map each CoClass to its Default Interface)            //
// *********************************************************************//
  DataObject = IVBDataObject;
  DataObjectFiles = IVBDataObjectFiles;
  MMControl = Imci;


// *********************************************************************//
// Declaration of structures, unions and aliases.                       //
// *********************************************************************//
  PSmallint1 = ^Smallint; {*}
  PInteger1 = ^Integer; {*}


// *********************************************************************//
// Interface: IVBDataObject
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2334D2B1-713E-11CF-8AE5-00AA00C00905}
// *********************************************************************//
  IVBDataObject = interface(IDispatch)
    ['{2334D2B1-713E-11CF-8AE5-00AA00C00905}']
    procedure Clear; safecall;
    function GetData(sFormat: Smallint): OleVariant; safecall;
    function GetFormat(sFormat: Smallint): WordBool; safecall;
    procedure SetData(vValue: OleVariant; vFormat: OleVariant); safecall;
    function Get_Files: IVBDataObjectFiles; safecall;
    property Files: IVBDataObjectFiles read Get_Files;
  end;

// *********************************************************************//
// DispIntf:  IVBDataObjectDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2334D2B1-713E-11CF-8AE5-00AA00C00905}
// *********************************************************************//
  IVBDataObjectDisp = dispinterface
    ['{2334D2B1-713E-11CF-8AE5-00AA00C00905}']
    procedure Clear; dispid 1;
    function GetData(sFormat: Smallint): OleVariant; dispid 2;
    function GetFormat(sFormat: Smallint): WordBool; dispid 3;
    procedure SetData(vValue: OleVariant; vFormat: OleVariant); dispid 4;
    property Files: IVBDataObjectFiles readonly dispid 5;
  end;

// *********************************************************************//
// Interface: IVBDataObjectFiles
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2334D2B3-713E-11CF-8AE5-00AA00C00905}
// *********************************************************************//
  IVBDataObjectFiles = interface(IDispatch)
    ['{2334D2B3-713E-11CF-8AE5-00AA00C00905}']
    function Get_Item(lIndex: Integer): WideString; safecall;
    function Get_Count: Integer; safecall;
    procedure Add(const bstrFilename: WideString; vIndex: OleVariant); safecall;
    procedure Clear; safecall;
    procedure Remove(vIndex: OleVariant); safecall;
    function _NewEnum: IUnknown; safecall;
    property Item[lIndex: Integer]: WideString read Get_Item;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  IVBDataObjectFilesDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2334D2B3-713E-11CF-8AE5-00AA00C00905}
// *********************************************************************//
  IVBDataObjectFilesDisp = dispinterface
    ['{2334D2B3-713E-11CF-8AE5-00AA00C00905}']
    property Item[lIndex: Integer]: WideString readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    procedure Add(const bstrFilename: WideString; vIndex: OleVariant); dispid 2;
    procedure Clear; dispid 3;
    procedure Remove(vIndex: OleVariant); dispid 4;
    function _NewEnum: IUnknown; dispid -4;
  end;

// *********************************************************************//
// Interface: Imci
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {B7ABC220-DF71-11CF-8E74-00A0C90F26F8}
// *********************************************************************//
  Imci = interface(IDispatch)
    ['{B7ABC220-DF71-11CF-8E74-00A0C90F26F8}']
    function Get_DeviceType: WideString; safecall;
    procedure Set_DeviceType(const pbstrType: WideString); safecall;
    function Get_AutoEnable: WordBool; safecall;
    procedure Set_AutoEnable(pfEnable: WordBool); safecall;
    function Get_PrevVisible: WordBool; safecall;
    procedure Set_PrevVisible(pfVisible: WordBool); safecall;
    function Get_NextVisible: WordBool; safecall;
    procedure Set_NextVisible(pfVisible: WordBool); safecall;
    function Get_PlayVisible: WordBool; safecall;
    procedure Set_PlayVisible(pfVisible: WordBool); safecall;
    function Get_PauseVisible: WordBool; safecall;
    procedure Set_PauseVisible(pfVisible: WordBool); safecall;
    function Get_BackVisible: WordBool; safecall;
    procedure Set_BackVisible(pfVisible: WordBool); safecall;
    function Get_StepVisible: WordBool; safecall;
    procedure Set_StepVisible(pfVisible: WordBool); safecall;
    function Get_StopVisible: WordBool; safecall;
    procedure Set_StopVisible(pfVisible: WordBool); safecall;
    function Get_RecordVisible: WordBool; safecall;
    procedure Set_RecordVisible(pfVisible: WordBool); safecall;
    function Get_EjectVisible: WordBool; safecall;
    procedure Set_EjectVisible(pfVisible: WordBool); safecall;
    function Get_PrevEnabled: WordBool; safecall;
    procedure Set_PrevEnabled(pfEnabled: WordBool); safecall;
    function Get_NextEnabled: WordBool; safecall;
    procedure Set_NextEnabled(pfEnabled: WordBool); safecall;
    function Get_PlayEnabled: WordBool; safecall;
    procedure Set_PlayEnabled(pfEnabled: WordBool); safecall;
    function Get_PauseEnabled: WordBool; safecall;
    procedure Set_PauseEnabled(pfEnabled: WordBool); safecall;
    function Get_BackEnabled: WordBool; safecall;
    procedure Set_BackEnabled(pfEnabled: WordBool); safecall;
    function Get_StepEnabled: WordBool; safecall;
    procedure Set_StepEnabled(pfEnabled: WordBool); safecall;
    function Get_StopEnabled: WordBool; safecall;
    procedure Set_StopEnabled(pfEnabled: WordBool); safecall;
    function Get_RecordEnabled: WordBool; safecall;
    procedure Set_RecordEnabled(pfEnabled: WordBool); safecall;
    function Get_EjectEnabled: WordBool; safecall;
    procedure Set_EjectEnabled(pfEnabled: WordBool); safecall;
    function Get_FileName: WideString; safecall;
    procedure Set_FileName(const pbstrName: WideString); safecall;
    function Get_Command: WideString; safecall;
    procedure Set_Command(const pbstrCmd: WideString); safecall;
    function Get_Notify: WordBool; safecall;
    procedure Set_Notify(pfNotify: WordBool); safecall;
    function Get_Wait: WordBool; safecall;
    procedure Set_Wait(pfWait: WordBool); safecall;
    function Get_Shareable: WordBool; safecall;
    procedure Set_Shareable(pfShare: WordBool); safecall;
    function Get_Orientation: OrientationConstants; safecall;
    procedure Set_Orientation(peOrientation: OrientationConstants); safecall;
    function Get_ErrorMessage: WideString; safecall;
    procedure Set_ErrorMessage(const pbstrMsg: WideString); safecall;
    function Get_From: Integer; safecall;
    procedure Set_From(plFrom: Integer); safecall;
    function Get_To_: Integer; safecall;
    procedure Set_To_(plTo: Integer); safecall;
    function Get_CanEject: WordBool; safecall;
    procedure Set_CanEject(pfCanEject: WordBool); safecall;
    function Get_CanPlay: WordBool; safecall;
    procedure Set_CanPlay(pfCanPlay: WordBool); safecall;
    function Get_CanRecord: WordBool; safecall;
    procedure Set_CanRecord(pfCanRecord: WordBool); safecall;
    function Get_CanStep: WordBool; safecall;
    procedure Set_CanStep(pfCanStep: WordBool); safecall;
    function Get_Mode: Integer; safecall;
    procedure Set_Mode(plMode: Integer); safecall;
    function Get_Length: Integer; safecall;
    procedure Set_Length(plLength: Integer); safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(plPosition: Integer); safecall;
    function Get_Start: Integer; safecall;
    procedure Set_Start(plStart: Integer); safecall;
    function Get_TimeFormat: Integer; safecall;
    procedure Set_TimeFormat(plTimeFormat: Integer); safecall;
    function Get_Silent: WordBool; safecall;
    procedure Set_Silent(pfSilent: WordBool); safecall;
    function Get_Track: Integer; safecall;
    procedure Set_Track(plTrack: Integer); safecall;
    function Get_Tracks: Integer; safecall;
    procedure Set_Tracks(plTracks: Integer); safecall;
    function Get_TrackLength: Integer; safecall;
    procedure Set_TrackLength(plTrackLength: Integer); safecall;
    function Get_TrackPosition: Integer; safecall;
    procedure Set_TrackPosition(plTrackPosition: Integer); safecall;
    function Get_UpdateInterval: Smallint; safecall;
    procedure Set_UpdateInterval(psUpdateInterval: Smallint); safecall;
    function Get_UsesWindows: WordBool; safecall;
    procedure Set_UsesWindows(pfUsesWindows: WordBool); safecall;
    function Get_Frames: Integer; safecall;
    procedure Set_Frames(plFrames: Integer); safecall;
    function Get_RecordMode: RecordModeConstants; safecall;
    procedure Set_RecordMode(peRecordMode: RecordModeConstants); safecall;
    function Get_hWndDisplay: Integer; safecall;
    procedure Set_hWndDisplay(plhWndDisplay: Integer); safecall;
    function Get_NotifyValue: Smallint; safecall;
    procedure Set_NotifyValue(psNotifyValue: Smallint); safecall;
    function Get_NotifyMessage: WideString; safecall;
    procedure Set_NotifyMessage(const pbstrMsg: WideString); safecall;
    function Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(pfEnabled: WordBool); safecall;
    function Get_BorderStyle: BorderStyleConstants; safecall;
    procedure Set_BorderStyle(peBorderStyle: BorderStyleConstants); safecall;
    function Get_Error: Smallint; safecall;
    procedure Set_Error(psError: Smallint); safecall;
    function Get_DeviceID: Smallint; safecall;
    procedure Set_DeviceID(psDeviceID: Smallint); safecall;
    function Get_MousePointer: MousePointerConstants; safecall;
    procedure Set_MousePointer(peMousePointer: MousePointerConstants); safecall;
    function Get_MouseIcon: IPictureDisp; safecall;
    procedure Set_MouseIcon(const ppMouseIcon: IPictureDisp); safecall;
    function Get_hWnd: OLE_HANDLE; safecall;
    procedure Set_hWnd(phWnd: OLE_HANDLE); safecall;
    function Get__Command: WideString; safecall;
    procedure Set__Command(const pbstrCommand: WideString); safecall;
    function Get_OLEDropMode: OLEDropConstants; safecall;
    procedure Set_OLEDropMode(psOLEDropMode: OLEDropConstants); safecall;
    procedure AboutBox; safecall;
    procedure Refresh; safecall;
    procedure OLEDrag; safecall;
    property DeviceType: WideString read Get_DeviceType write Set_DeviceType;
    property AutoEnable: WordBool read Get_AutoEnable write Set_AutoEnable;
    property PrevVisible: WordBool read Get_PrevVisible write Set_PrevVisible;
    property NextVisible: WordBool read Get_NextVisible write Set_NextVisible;
    property PlayVisible: WordBool read Get_PlayVisible write Set_PlayVisible;
    property PauseVisible: WordBool read Get_PauseVisible write Set_PauseVisible;
    property BackVisible: WordBool read Get_BackVisible write Set_BackVisible;
    property StepVisible: WordBool read Get_StepVisible write Set_StepVisible;
    property StopVisible: WordBool read Get_StopVisible write Set_StopVisible;
    property RecordVisible: WordBool read Get_RecordVisible write Set_RecordVisible;
    property EjectVisible: WordBool read Get_EjectVisible write Set_EjectVisible;
    property PrevEnabled: WordBool read Get_PrevEnabled write Set_PrevEnabled;
    property NextEnabled: WordBool read Get_NextEnabled write Set_NextEnabled;
    property PlayEnabled: WordBool read Get_PlayEnabled write Set_PlayEnabled;
    property PauseEnabled: WordBool read Get_PauseEnabled write Set_PauseEnabled;
    property BackEnabled: WordBool read Get_BackEnabled write Set_BackEnabled;
    property StepEnabled: WordBool read Get_StepEnabled write Set_StepEnabled;
    property StopEnabled: WordBool read Get_StopEnabled write Set_StopEnabled;
    property RecordEnabled: WordBool read Get_RecordEnabled write Set_RecordEnabled;
    property EjectEnabled: WordBool read Get_EjectEnabled write Set_EjectEnabled;
    property FileName: WideString read Get_FileName write Set_FileName;
    property Command: WideString read Get_Command write Set_Command;
    property Notify: WordBool read Get_Notify write Set_Notify;
    property Wait: WordBool read Get_Wait write Set_Wait;
    property Shareable: WordBool read Get_Shareable write Set_Shareable;
    property Orientation: OrientationConstants read Get_Orientation write Set_Orientation;
    property ErrorMessage: WideString read Get_ErrorMessage write Set_ErrorMessage;
    property From: Integer read Get_From write Set_From;
    property To_: Integer read Get_To_ write Set_To_;
    property CanEject: WordBool read Get_CanEject write Set_CanEject;
    property CanPlay: WordBool read Get_CanPlay write Set_CanPlay;
    property CanRecord: WordBool read Get_CanRecord write Set_CanRecord;
    property CanStep: WordBool read Get_CanStep write Set_CanStep;
    property Mode: Integer read Get_Mode write Set_Mode;
    property Length: Integer read Get_Length write Set_Length;
    property Position: Integer read Get_Position write Set_Position;
    property Start: Integer read Get_Start write Set_Start;
    property TimeFormat: Integer read Get_TimeFormat write Set_TimeFormat;
    property Silent: WordBool read Get_Silent write Set_Silent;
    property Track: Integer read Get_Track write Set_Track;
    property Tracks: Integer read Get_Tracks write Set_Tracks;
    property TrackLength: Integer read Get_TrackLength write Set_TrackLength;
    property TrackPosition: Integer read Get_TrackPosition write Set_TrackPosition;
    property UpdateInterval: Smallint read Get_UpdateInterval write Set_UpdateInterval;
    property UsesWindows: WordBool read Get_UsesWindows write Set_UsesWindows;
    property Frames: Integer read Get_Frames write Set_Frames;
    property RecordMode: RecordModeConstants read Get_RecordMode write Set_RecordMode;
    property hWndDisplay: Integer read Get_hWndDisplay write Set_hWndDisplay;
    property NotifyValue: Smallint read Get_NotifyValue write Set_NotifyValue;
    property NotifyMessage: WideString read Get_NotifyMessage write Set_NotifyMessage;
    property Enabled: WordBool read Get_Enabled write Set_Enabled;
    property BorderStyle: BorderStyleConstants read Get_BorderStyle write Set_BorderStyle;
    property Error: Smallint read Get_Error write Set_Error;
    property DeviceID: Smallint read Get_DeviceID write Set_DeviceID;
    property MousePointer: MousePointerConstants read Get_MousePointer write Set_MousePointer;
    property MouseIcon: IPictureDisp read Get_MouseIcon write Set_MouseIcon;
    property hWnd: OLE_HANDLE read Get_hWnd write Set_hWnd;
    property _Command: WideString read Get__Command write Set__Command;
    property OLEDropMode: OLEDropConstants read Get_OLEDropMode write Set_OLEDropMode;
  end;

// *********************************************************************//
// DispIntf:  ImciDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {B7ABC220-DF71-11CF-8E74-00A0C90F26F8}
// *********************************************************************//
  ImciDisp = dispinterface
    ['{B7ABC220-DF71-11CF-8E74-00A0C90F26F8}']
    property DeviceType: WideString dispid 21;
    property AutoEnable: WordBool dispid 2;
    property PrevVisible: WordBool dispid 3;
    property NextVisible: WordBool dispid 4;
    property PlayVisible: WordBool dispid 5;
    property PauseVisible: WordBool dispid 6;
    property BackVisible: WordBool dispid 7;
    property StepVisible: WordBool dispid 8;
    property StopVisible: WordBool dispid 9;
    property RecordVisible: WordBool dispid 10;
    property EjectVisible: WordBool dispid 11;
    property PrevEnabled: WordBool dispid 12;
    property NextEnabled: WordBool dispid 13;
    property PlayEnabled: WordBool dispid 14;
    property PauseEnabled: WordBool dispid 15;
    property BackEnabled: WordBool dispid 16;
    property StepEnabled: WordBool dispid 17;
    property StopEnabled: WordBool dispid 18;
    property RecordEnabled: WordBool dispid 19;
    property EjectEnabled: WordBool dispid 20;
    property FileName: WideString dispid 22;
    property Command: WideString dispid 23;
    property Notify: WordBool dispid 24;
    property Wait: WordBool dispid 25;
    property Shareable: WordBool dispid 26;
    property Orientation: OrientationConstants dispid 27;
    property ErrorMessage: WideString dispid 28;
    property From: Integer dispid 29;
    property To_: Integer dispid 30;
    property CanEject: WordBool dispid 31;
    property CanPlay: WordBool dispid 32;
    property CanRecord: WordBool dispid 33;
    property CanStep: WordBool dispid 34;
    property Mode: Integer dispid 35;
    property Length: Integer dispid 36;
    property Position: Integer dispid 37;
    property Start: Integer dispid 38;
    property TimeFormat: Integer dispid 39;
    property Silent: WordBool dispid 40;
    property Track: Integer dispid 41;
    property Tracks: Integer dispid 42;
    property TrackLength: Integer dispid 43;
    property TrackPosition: Integer dispid 44;
    property UpdateInterval: Smallint dispid 45;
    property UsesWindows: WordBool dispid 46;
    property Frames: Integer dispid 47;
    property RecordMode: RecordModeConstants dispid 48;
    property hWndDisplay: Integer dispid 49;
    property NotifyValue: Smallint dispid 50;
    property NotifyMessage: WideString dispid 51;
    property Enabled: WordBool dispid 52;
    property BorderStyle: BorderStyleConstants dispid -504;
    property Error: Smallint dispid 53;
    property DeviceID: Smallint dispid 54;
    property MousePointer: MousePointerConstants dispid 1;
    property MouseIcon: IPictureDisp dispid 55;
    property hWnd: OLE_HANDLE dispid -515;
    property _Command: WideString dispid 0;
    property OLEDropMode: OLEDropConstants dispid 1551;
    procedure AboutBox; dispid -552;
    procedure Refresh; dispid -550;
    procedure OLEDrag; dispid 1552;
  end;

// *********************************************************************//
// DispIntf:  DmciEvents
// Flags:     (4224) NonExtensible Dispatchable
// GUID:      {C1A8AF27-1257-101B-8FB0-0020AF039CA3}
// *********************************************************************//
  DmciEvents = dispinterface
    ['{C1A8AF27-1257-101B-8FB0-0020AF039CA3}']
    procedure Done(var NotifyCode: Smallint); dispid 38;
    procedure BackClick(var Cancel: Smallint); dispid 1;
    procedure PrevClick(var Cancel: Smallint); dispid 2;
    procedure NextClick(var Cancel: Smallint); dispid 3;
    procedure PlayClick(var Cancel: Smallint); dispid 4;
    procedure PauseClick(var Cancel: Smallint); dispid 5;
    procedure StepClick(var Cancel: Smallint); dispid 6;
    procedure StopClick(var Cancel: Smallint); dispid 7;
    procedure RecordClick(var Cancel: Smallint); dispid 8;
    procedure EjectClick(var Cancel: Smallint); dispid 9;
    procedure PrevGotFocus; dispid 10;
    procedure PrevLostFocus; dispid 11;
    procedure NextGotFocus; dispid 12;
    procedure NextLostFocus; dispid 13;
    procedure PlayGotFocus; dispid 14;
    procedure PlayLostFocus; dispid 15;
    procedure PauseGotFocus; dispid 16;
    procedure PauseLostFocus; dispid 17;
    procedure BackGotFocus; dispid 18;
    procedure BackLostFocus; dispid 19;
    procedure StepGotFocus; dispid 20;
    procedure StepLostFocus; dispid 21;
    procedure StopLostFocus; dispid 22;
    procedure StopGotFocus; dispid 23;
    procedure RecordGotFocus; dispid 24;
    procedure RecordLostFocus; dispid 25;
    procedure EjectGotFocus; dispid 26;
    procedure EjectLostFocus; dispid 27;
    procedure StatusUpdate; dispid 28;
    procedure NextCompleted(var Errorcode: Integer); dispid 29;
    procedure PlayCompleted(var Errorcode: Integer); dispid 30;
    procedure PauseCompleted(var Errorcode: Integer); dispid 31;
    procedure BackCompleted(var Errorcode: Integer); dispid 32;
    procedure StepCompleted(var Errorcode: Integer); dispid 33;
    procedure StopCompleted(var Errorcode: Integer); dispid 34;
    procedure RecordCompleted(var Errorcode: Integer); dispid 35;
    procedure EjectCompleted(var Errorcode: Integer); dispid 36;
    procedure PrevCompleted(var Errorcode: Integer); dispid 37;
    procedure OLEStartDrag(var Data: DataObject; var AllowedEffects: Integer); dispid 1550;
    procedure OLEGiveFeedback(var Effect: Integer; var DefaultCursors: WordBool); dispid 1551;
    procedure OLESetData(var Data: DataObject; var DataFormat: Smallint); dispid 1552;
    procedure OLECompleteDrag(var Effect: Integer); dispid 1553;
    procedure OLEDragOver(var Data: DataObject; var Effect: Integer; var Button: Smallint; 
                          var Shift: Smallint; var X: Single; var Y: Single; var State: Smallint); dispid 1554;
    procedure OLEDragDrop(var Data: DataObject; var Effect: Integer; var Button: Smallint; 
                          var Shift: Smallint; var X: Single; var Y: Single); dispid 1555;
  end;

  CoDataObject = class
    class function Create: IVBDataObject;
    class function CreateRemote(const MachineName: string): IVBDataObject;
  end;

  CoDataObjectFiles = class
    class function Create: IVBDataObjectFiles;
    class function CreateRemote(const MachineName: string): IVBDataObjectFiles;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TMMControl
// Help String      : Microsoft Multimedia Control 5.0
// Default Interface: Imci
// Def. Intf. DISP? : No
// Event   Interface: DmciEvents
// TypeFlags        : (38) CanCreate Licensed Control
// *********************************************************************//
  TMMControlDone = procedure(Sender: TObject; var NotifyCode: Smallint) of object;
  TMMControlBackClick = procedure(Sender: TObject; var Cancel: Smallint) of object;
  TMMControlPrevClick = procedure(Sender: TObject; var Cancel: Smallint) of object;
  TMMControlNextClick = procedure(Sender: TObject; var Cancel: Smallint) of object;
  TMMControlPlayClick = procedure(Sender: TObject; var Cancel: Smallint) of object;
  TMMControlPauseClick = procedure(Sender: TObject; var Cancel: Smallint) of object;
  TMMControlStepClick = procedure(Sender: TObject; var Cancel: Smallint) of object;
  TMMControlStopClick = procedure(Sender: TObject; var Cancel: Smallint) of object;
  TMMControlRecordClick = procedure(Sender: TObject; var Cancel: Smallint) of object;
  TMMControlEjectClick = procedure(Sender: TObject; var Cancel: Smallint) of object;
  TMMControlNextCompleted = procedure(Sender: TObject; var Errorcode: Integer) of object;
  TMMControlPlayCompleted = procedure(Sender: TObject; var Errorcode: Integer) of object;
  TMMControlPauseCompleted = procedure(Sender: TObject; var Errorcode: Integer) of object;
  TMMControlBackCompleted = procedure(Sender: TObject; var Errorcode: Integer) of object;
  TMMControlStepCompleted = procedure(Sender: TObject; var Errorcode: Integer) of object;
  TMMControlStopCompleted = procedure(Sender: TObject; var Errorcode: Integer) of object;
  TMMControlRecordCompleted = procedure(Sender: TObject; var Errorcode: Integer) of object;
  TMMControlEjectCompleted = procedure(Sender: TObject; var Errorcode: Integer) of object;
  TMMControlPrevCompleted = procedure(Sender: TObject; var Errorcode: Integer) of object;
  TMMControlOLEStartDrag = procedure(Sender: TObject; var Data: DataObject; 
                                                      var AllowedEffects: Integer) of object;
  TMMControlOLEGiveFeedback = procedure(Sender: TObject; var Effect: Integer; 
                                                         var DefaultCursors: WordBool) of object;
  TMMControlOLESetData = procedure(Sender: TObject; var Data: DataObject; var DataFormat: Smallint) of object;
  TMMControlOLECompleteDrag = procedure(Sender: TObject; var Effect: Integer) of object;
  TMMControlOLEDragOver = procedure(Sender: TObject; var Data: DataObject; var Effect: Integer; 
                                                     var Button: Smallint; var Shift: Smallint; 
                                                     var X: Single; var Y: Single; 
                                                     var State: Smallint) of object;
  TMMControlOLEDragDrop = procedure(Sender: TObject; var Data: DataObject; var Effect: Integer; 
                                                     var Button: Smallint; var Shift: Smallint; 
                                                     var X: Single; var Y: Single) of object;

  TMMControl = class(TOleControl)
  private
    FOnDone: TMMControlDone;
    FOnBackClick: TMMControlBackClick;
    FOnPrevClick: TMMControlPrevClick;
    FOnNextClick: TMMControlNextClick;
    FOnPlayClick: TMMControlPlayClick;
    FOnPauseClick: TMMControlPauseClick;
    FOnStepClick: TMMControlStepClick;
    FOnStopClick: TMMControlStopClick;
    FOnRecordClick: TMMControlRecordClick;
    FOnEjectClick: TMMControlEjectClick;
    FOnPrevGotFocus: TNotifyEvent;
    FOnPrevLostFocus: TNotifyEvent;
    FOnNextGotFocus: TNotifyEvent;
    FOnNextLostFocus: TNotifyEvent;
    FOnPlayGotFocus: TNotifyEvent;
    FOnPlayLostFocus: TNotifyEvent;
    FOnPauseGotFocus: TNotifyEvent;
    FOnPauseLostFocus: TNotifyEvent;
    FOnBackGotFocus: TNotifyEvent;
    FOnBackLostFocus: TNotifyEvent;
    FOnStepGotFocus: TNotifyEvent;
    FOnStepLostFocus: TNotifyEvent;
    FOnStopLostFocus: TNotifyEvent;
    FOnStopGotFocus: TNotifyEvent;
    FOnRecordGotFocus: TNotifyEvent;
    FOnRecordLostFocus: TNotifyEvent;
    FOnEjectGotFocus: TNotifyEvent;
    FOnEjectLostFocus: TNotifyEvent;
    FOnStatusUpdate: TNotifyEvent;
    FOnNextCompleted: TMMControlNextCompleted;
    FOnPlayCompleted: TMMControlPlayCompleted;
    FOnPauseCompleted: TMMControlPauseCompleted;
    FOnBackCompleted: TMMControlBackCompleted;
    FOnStepCompleted: TMMControlStepCompleted;
    FOnStopCompleted: TMMControlStopCompleted;
    FOnRecordCompleted: TMMControlRecordCompleted;
    FOnEjectCompleted: TMMControlEjectCompleted;
    FOnPrevCompleted: TMMControlPrevCompleted;
    FOnOLEStartDrag: TMMControlOLEStartDrag;
    FOnOLEGiveFeedback: TMMControlOLEGiveFeedback;
    FOnOLESetData: TMMControlOLESetData;
    FOnOLECompleteDrag: TMMControlOLECompleteDrag;
    FOnOLEDragOver: TMMControlOLEDragOver;
    FOnOLEDragDrop: TMMControlOLEDragDrop;
    FIntf: Imci;
    function  GetControlInterface: Imci;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure AboutBox;
    procedure Refresh;
    procedure OLEDrag;
    property  ControlInterface: Imci read GetControlInterface;
    property MouseIcon: TPicture index 55 read GetTPictureProp write SetTPictureProp;
    property _Command: WideString index 0 read GetWideStringProp write SetWideStringProp;
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
    property DeviceType: WideString index 21 read GetWideStringProp write SetWideStringProp stored False;
    property AutoEnable: WordBool index 2 read GetWordBoolProp write SetWordBoolProp stored False;
    property PrevVisible: WordBool index 3 read GetWordBoolProp write SetWordBoolProp stored False;
    property NextVisible: WordBool index 4 read GetWordBoolProp write SetWordBoolProp stored False;
    property PlayVisible: WordBool index 5 read GetWordBoolProp write SetWordBoolProp stored False;
    property PauseVisible: WordBool index 6 read GetWordBoolProp write SetWordBoolProp stored False;
    property BackVisible: WordBool index 7 read GetWordBoolProp write SetWordBoolProp stored False;
    property StepVisible: WordBool index 8 read GetWordBoolProp write SetWordBoolProp stored False;
    property StopVisible: WordBool index 9 read GetWordBoolProp write SetWordBoolProp stored False;
    property RecordVisible: WordBool index 10 read GetWordBoolProp write SetWordBoolProp stored False;
    property EjectVisible: WordBool index 11 read GetWordBoolProp write SetWordBoolProp stored False;
    property PrevEnabled: WordBool index 12 read GetWordBoolProp write SetWordBoolProp stored False;
    property NextEnabled: WordBool index 13 read GetWordBoolProp write SetWordBoolProp stored False;
    property PlayEnabled: WordBool index 14 read GetWordBoolProp write SetWordBoolProp stored False;
    property PauseEnabled: WordBool index 15 read GetWordBoolProp write SetWordBoolProp stored False;
    property BackEnabled: WordBool index 16 read GetWordBoolProp write SetWordBoolProp stored False;
    property StepEnabled: WordBool index 17 read GetWordBoolProp write SetWordBoolProp stored False;
    property StopEnabled: WordBool index 18 read GetWordBoolProp write SetWordBoolProp stored False;
    property RecordEnabled: WordBool index 19 read GetWordBoolProp write SetWordBoolProp stored False;
    property EjectEnabled: WordBool index 20 read GetWordBoolProp write SetWordBoolProp stored False;
    property FileName: WideString index 22 read GetWideStringProp write SetWideStringProp stored False;
    property Command: WideString index 23 read GetWideStringProp write SetWideStringProp stored False;
    property Notify: WordBool index 24 read GetWordBoolProp write SetWordBoolProp stored False;
    property Wait: WordBool index 25 read GetWordBoolProp write SetWordBoolProp stored False;
    property Shareable: WordBool index 26 read GetWordBoolProp write SetWordBoolProp stored False;
    property Orientation: TOleEnum index 27 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property ErrorMessage: WideString index 28 read GetWideStringProp write SetWideStringProp stored False;
    property From: Integer index 29 read GetIntegerProp write SetIntegerProp stored False;
    property To_: Integer index 30 read GetIntegerProp write SetIntegerProp stored False;
    property CanEject: WordBool index 31 read GetWordBoolProp write SetWordBoolProp stored False;
    property CanPlay: WordBool index 32 read GetWordBoolProp write SetWordBoolProp stored False;
    property CanRecord: WordBool index 33 read GetWordBoolProp write SetWordBoolProp stored False;
    property CanStep: WordBool index 34 read GetWordBoolProp write SetWordBoolProp stored False;
    property Mode: Integer index 35 read GetIntegerProp write SetIntegerProp stored False;
    property Length: Integer index 36 read GetIntegerProp write SetIntegerProp stored False;
    property Position: Integer index 37 read GetIntegerProp write SetIntegerProp stored False;
    property Start: Integer index 38 read GetIntegerProp write SetIntegerProp stored False;
    property TimeFormat: Integer index 39 read GetIntegerProp write SetIntegerProp stored False;
    property Silent: WordBool index 40 read GetWordBoolProp write SetWordBoolProp stored False;
    property Track: Integer index 41 read GetIntegerProp write SetIntegerProp stored False;
    property Tracks: Integer index 42 read GetIntegerProp write SetIntegerProp stored False;
    property TrackLength: Integer index 43 read GetIntegerProp write SetIntegerProp stored False;
    property TrackPosition: Integer index 44 read GetIntegerProp write SetIntegerProp stored False;
    property UpdateInterval: Smallint index 45 read GetSmallintProp write SetSmallintProp stored False;
    property UsesWindows: WordBool index 46 read GetWordBoolProp write SetWordBoolProp stored False;
    property Frames: Integer index 47 read GetIntegerProp write SetIntegerProp stored False;
    property RecordMode: TOleEnum index 48 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property hWndDisplay: Integer index 49 read GetIntegerProp write SetIntegerProp stored False;
    property NotifyValue: Smallint index 50 read GetSmallintProp write SetSmallintProp stored False;
    property NotifyMessage: WideString index 51 read GetWideStringProp write SetWideStringProp stored False;
    property Enabled: WordBool index 52 read GetWordBoolProp write SetWordBoolProp stored False;
    property BorderStyle: TOleEnum index -504 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property Error: Smallint index 53 read GetSmallintProp write SetSmallintProp stored False;
    property DeviceID: Smallint index 54 read GetSmallintProp write SetSmallintProp stored False;
    property MousePointer: TOleEnum index 1 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property hWnd: Integer index -515 read GetIntegerProp write SetIntegerProp stored False;
    property OLEDropMode: TOleEnum index 1551 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property OnDone: TMMControlDone read FOnDone write FOnDone;
    property OnBackClick: TMMControlBackClick read FOnBackClick write FOnBackClick;
    property OnPrevClick: TMMControlPrevClick read FOnPrevClick write FOnPrevClick;
    property OnNextClick: TMMControlNextClick read FOnNextClick write FOnNextClick;
    property OnPlayClick: TMMControlPlayClick read FOnPlayClick write FOnPlayClick;
    property OnPauseClick: TMMControlPauseClick read FOnPauseClick write FOnPauseClick;
    property OnStepClick: TMMControlStepClick read FOnStepClick write FOnStepClick;
    property OnStopClick: TMMControlStopClick read FOnStopClick write FOnStopClick;
    property OnRecordClick: TMMControlRecordClick read FOnRecordClick write FOnRecordClick;
    property OnEjectClick: TMMControlEjectClick read FOnEjectClick write FOnEjectClick;
    property OnPrevGotFocus: TNotifyEvent read FOnPrevGotFocus write FOnPrevGotFocus;
    property OnPrevLostFocus: TNotifyEvent read FOnPrevLostFocus write FOnPrevLostFocus;
    property OnNextGotFocus: TNotifyEvent read FOnNextGotFocus write FOnNextGotFocus;
    property OnNextLostFocus: TNotifyEvent read FOnNextLostFocus write FOnNextLostFocus;
    property OnPlayGotFocus: TNotifyEvent read FOnPlayGotFocus write FOnPlayGotFocus;
    property OnPlayLostFocus: TNotifyEvent read FOnPlayLostFocus write FOnPlayLostFocus;
    property OnPauseGotFocus: TNotifyEvent read FOnPauseGotFocus write FOnPauseGotFocus;
    property OnPauseLostFocus: TNotifyEvent read FOnPauseLostFocus write FOnPauseLostFocus;
    property OnBackGotFocus: TNotifyEvent read FOnBackGotFocus write FOnBackGotFocus;
    property OnBackLostFocus: TNotifyEvent read FOnBackLostFocus write FOnBackLostFocus;
    property OnStepGotFocus: TNotifyEvent read FOnStepGotFocus write FOnStepGotFocus;
    property OnStepLostFocus: TNotifyEvent read FOnStepLostFocus write FOnStepLostFocus;
    property OnStopLostFocus: TNotifyEvent read FOnStopLostFocus write FOnStopLostFocus;
    property OnStopGotFocus: TNotifyEvent read FOnStopGotFocus write FOnStopGotFocus;
    property OnRecordGotFocus: TNotifyEvent read FOnRecordGotFocus write FOnRecordGotFocus;
    property OnRecordLostFocus: TNotifyEvent read FOnRecordLostFocus write FOnRecordLostFocus;
    property OnEjectGotFocus: TNotifyEvent read FOnEjectGotFocus write FOnEjectGotFocus;
    property OnEjectLostFocus: TNotifyEvent read FOnEjectLostFocus write FOnEjectLostFocus;
    property OnStatusUpdate: TNotifyEvent read FOnStatusUpdate write FOnStatusUpdate;
    property OnNextCompleted: TMMControlNextCompleted read FOnNextCompleted write FOnNextCompleted;
    property OnPlayCompleted: TMMControlPlayCompleted read FOnPlayCompleted write FOnPlayCompleted;
    property OnPauseCompleted: TMMControlPauseCompleted read FOnPauseCompleted write FOnPauseCompleted;
    property OnBackCompleted: TMMControlBackCompleted read FOnBackCompleted write FOnBackCompleted;
    property OnStepCompleted: TMMControlStepCompleted read FOnStepCompleted write FOnStepCompleted;
    property OnStopCompleted: TMMControlStopCompleted read FOnStopCompleted write FOnStopCompleted;
    property OnRecordCompleted: TMMControlRecordCompleted read FOnRecordCompleted write FOnRecordCompleted;
    property OnEjectCompleted: TMMControlEjectCompleted read FOnEjectCompleted write FOnEjectCompleted;
    property OnPrevCompleted: TMMControlPrevCompleted read FOnPrevCompleted write FOnPrevCompleted;
    property OnOLEStartDrag: TMMControlOLEStartDrag read FOnOLEStartDrag write FOnOLEStartDrag;
    property OnOLEGiveFeedback: TMMControlOLEGiveFeedback read FOnOLEGiveFeedback write FOnOLEGiveFeedback;
    property OnOLESetData: TMMControlOLESetData read FOnOLESetData write FOnOLESetData;
    property OnOLECompleteDrag: TMMControlOLECompleteDrag read FOnOLECompleteDrag write FOnOLECompleteDrag;
    property OnOLEDragOver: TMMControlOLEDragOver read FOnOLEDragOver write FOnOLEDragOver;
    property OnOLEDragDrop: TMMControlOLEDragDrop read FOnOLEDragDrop write FOnOLEDragDrop;
  end;

procedure Register;

implementation

uses ComObj;

class function CoDataObject.Create: IVBDataObject;
begin
  Result := CreateComObject(CLASS_DataObject) as IVBDataObject;
end;

class function CoDataObject.CreateRemote(const MachineName: string): IVBDataObject;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DataObject) as IVBDataObject;
end;

class function CoDataObjectFiles.Create: IVBDataObjectFiles;
begin
  Result := CreateComObject(CLASS_DataObjectFiles) as IVBDataObjectFiles;
end;

class function CoDataObjectFiles.CreateRemote(const MachineName: string): IVBDataObjectFiles;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DataObjectFiles) as IVBDataObjectFiles;
end;

procedure TMMControl.InitControlData;
const
  CEventDispIDs: array [0..43] of DWORD = (
    $00000026, $00000001, $00000002, $00000003, $00000004, $00000005,
    $00000006, $00000007, $00000008, $00000009, $0000000A, $0000000B,
    $0000000C, $0000000D, $0000000E, $0000000F, $00000010, $00000011,
    $00000012, $00000013, $00000014, $00000015, $00000016, $00000017,
    $00000018, $00000019, $0000001A, $0000001B, $0000001C, $0000001D,
    $0000001E, $0000001F, $00000020, $00000021, $00000022, $00000023,
    $00000024, $00000025, $0000060E, $0000060F, $00000610, $00000611,
    $00000612, $00000613);
  CLicenseKey: array[0..36] of Word = ( $006D, $0067, $006B, $0067, $0074, $0067, $006E, $006E, $006D, $006E, $006D
    , $006E, $0069, $006E, $0069, $0067, $0074, $0068, $006B, $0067, $006F
    , $0067, $0067, $0067, $0076, $006D, $006B, $0068, $0069, $006E, $006A
    , $0067, $0067, $006E, $0076, $006D, $0000);
  CTPictureIDs: array [0..0] of DWORD = (
    $00000037);
  CControlData: TControlData = (
    ClassID: '{C1A8AF25-1257-101B-8FB0-0020AF039CA3}';
    EventIID: '{C1A8AF27-1257-101B-8FB0-0020AF039CA3}';
    EventCount: 44;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: @CLicenseKey;
    Flags: $00000000;
    Version: 300;
    FontCount: 0;
    FontIDs: nil;
    PictureCount: 1;
    PictureIDs: @CTPictureIDs);
begin
  ControlData := @CControlData;
end;

procedure TMMControl.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as Imci;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TMMControl.GetControlInterface: Imci;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TMMControl.AboutBox;
begin
  ControlInterface.AboutBox;
end;

procedure TMMControl.Refresh;
begin
  ControlInterface.Refresh;
end;

procedure TMMControl.OLEDrag;
begin
  ControlInterface.OLEDrag;
end;

procedure Register;
begin
  RegisterComponents('ActiveX',[TMMControl]);
end;

end.
