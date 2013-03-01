unit QuartzTypeLib_TLB;

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
// File generated on 98-10-19 15:32:57 from Type Library described below.

// ************************************************************************ //
// Type Lib: D:\HuangYL\activex\Quartz.tlb
// IID\LCID: {56A868B0-0AD4-11CE-B03A-0020AF0BA770}\0
// Helpfile: 
// HelpString: ActiveMovie control type library
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
  LIBID_QuartzTypeLib: TGUID = '{56A868B0-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IAMCollection: TGUID = '{56A868B9-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IMediaControl: TGUID = '{56A868B1-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IMediaEvent: TGUID = '{56A868B6-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IMediaEventEx: TGUID = '{56A868C0-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IMediaPosition: TGUID = '{56A868B2-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IBasicAudio: TGUID = '{56A868B3-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IVideoWindow: TGUID = '{56A868B4-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IBasicVideo: TGUID = '{56A868B5-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IDeferredCommand: TGUID = '{56A868B8-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IQueueCommand: TGUID = '{56A868B7-0AD4-11CE-B03A-0020AF0BA770}';
  CLASS_FilgraphManager: TGUID = '{E436EBB3-524F-11CE-9F53-0020AF0BA770}';
  IID_IFilterInfo: TGUID = '{56A868BA-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IRegFilterInfo: TGUID = '{56A868BB-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IMediaTypeInfo: TGUID = '{56A868BC-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IPinInfo: TGUID = '{56A868BD-0AD4-11CE-B03A-0020AF0BA770}';
type

// *********************************************************************//
// Forward declaration of interfaces defined in Type Library            //
// *********************************************************************//
  IAMCollection = interface;
  IAMCollectionDisp = dispinterface;
  IMediaControl = interface;
  IMediaControlDisp = dispinterface;
  IMediaEvent = interface;
  IMediaEventDisp = dispinterface;
  IMediaEventEx = interface;
  IMediaPosition = interface;
  IMediaPositionDisp = dispinterface;
  IBasicAudio = interface;
  IBasicAudioDisp = dispinterface;
  IVideoWindow = interface;
  IVideoWindowDisp = dispinterface;
  IBasicVideo = interface;
  IBasicVideoDisp = dispinterface;
  IDeferredCommand = interface;
  IQueueCommand = interface;
  IFilterInfo = interface;
  IFilterInfoDisp = dispinterface;
  IRegFilterInfo = interface;
  IRegFilterInfoDisp = dispinterface;
  IMediaTypeInfo = interface;
  IMediaTypeInfoDisp = dispinterface;
  IPinInfo = interface;
  IPinInfoDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                     //
// (NOTE: Here we map each CoClass to its Default Interface)            //
// *********************************************************************//
  FilgraphManager = IMediaControl;


// *********************************************************************//
// Declaration of structures, unions and aliases.                       //
// *********************************************************************//
  PUserType1 = ^TGUID; {*}
  POleVariant1 = ^OleVariant; {*}


// *********************************************************************//
// Interface: IAMCollection
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {56A868B9-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IAMCollection = interface(IDispatch)
    ['{56A868B9-0AD4-11CE-B03A-0020AF0BA770}']
    function Get_Count: Integer; safecall;
    procedure Item(lItem: Integer; out ppUnk: IUnknown); safecall;
    function Get__NewEnum: IUnknown; safecall;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  IAMCollectionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {56A868B9-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IAMCollectionDisp = dispinterface
    ['{56A868B9-0AD4-11CE-B03A-0020AF0BA770}']
    property Count: Integer readonly dispid 1610743808;
    procedure Item(lItem: Integer; out ppUnk: IUnknown); dispid 1610743809;
    property _NewEnum: IUnknown readonly dispid 1610743810;
  end;

// *********************************************************************//
// Interface: IMediaControl
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {56A868B1-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IMediaControl = interface(IDispatch)
    ['{56A868B1-0AD4-11CE-B03A-0020AF0BA770}']
    procedure Run; safecall;
    procedure Pause; safecall;
    procedure Stop; safecall;
    procedure GetState(msTimeout: Integer; out pfs: Integer); safecall;
    procedure RenderFile(const strFilename: WideString); safecall;
    procedure AddSourceFilter(const strFilename: WideString; out ppUnk: IDispatch); safecall;
    function Get_FilterCollection: IDispatch; safecall;
    function Get_RegFilterCollection: IDispatch; safecall;
    procedure StopWhenReady; safecall;
    property FilterCollection: IDispatch read Get_FilterCollection;
    property RegFilterCollection: IDispatch read Get_RegFilterCollection;
  end;

// *********************************************************************//
// DispIntf:  IMediaControlDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {56A868B1-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IMediaControlDisp = dispinterface
    ['{56A868B1-0AD4-11CE-B03A-0020AF0BA770}']
    procedure Run; dispid 1610743808;
    procedure Pause; dispid 1610743809;
    procedure Stop; dispid 1610743810;
    procedure GetState(msTimeout: Integer; out pfs: Integer); dispid 1610743811;
    procedure RenderFile(const strFilename: WideString); dispid 1610743812;
    procedure AddSourceFilter(const strFilename: WideString; out ppUnk: IDispatch); dispid 1610743813;
    property FilterCollection: IDispatch readonly dispid 1610743814;
    property RegFilterCollection: IDispatch readonly dispid 1610743815;
    procedure StopWhenReady; dispid 1610743816;
  end;

// *********************************************************************//
// Interface: IMediaEvent
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {56A868B6-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IMediaEvent = interface(IDispatch)
    ['{56A868B6-0AD4-11CE-B03A-0020AF0BA770}']
    procedure GetEventHandle(out hEvent: Integer); safecall;
    procedure GetEvent(out lEventCode: Integer; out lParam1: Integer; out lParam2: Integer; 
                       msTimeout: Integer); safecall;
    procedure WaitForCompletion(msTimeout: Integer; out pEvCode: Integer); safecall;
    procedure CancelDefaultHandling(lEvCode: Integer); safecall;
    procedure RestoreDefaultHandling(lEvCode: Integer); safecall;
    procedure FreeEventParams(lEvCode: Integer; lParam1: Integer; lParam2: Integer); safecall;
  end;

// *********************************************************************//
// DispIntf:  IMediaEventDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {56A868B6-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IMediaEventDisp = dispinterface
    ['{56A868B6-0AD4-11CE-B03A-0020AF0BA770}']
    procedure GetEventHandle(out hEvent: Integer); dispid 1610743808;
    procedure GetEvent(out lEventCode: Integer; out lParam1: Integer; out lParam2: Integer; 
                       msTimeout: Integer); dispid 1610743809;
    procedure WaitForCompletion(msTimeout: Integer; out pEvCode: Integer); dispid 1610743810;
    procedure CancelDefaultHandling(lEvCode: Integer); dispid 1610743811;
    procedure RestoreDefaultHandling(lEvCode: Integer); dispid 1610743812;
    procedure FreeEventParams(lEvCode: Integer; lParam1: Integer; lParam2: Integer); dispid 1610743813;
  end;

// *********************************************************************//
// Interface: IMediaEventEx
// Flags:     (4096) Dispatchable
// GUID:      {56A868C0-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IMediaEventEx = interface(IMediaEvent)
    ['{56A868C0-0AD4-11CE-B03A-0020AF0BA770}']
    function SetNotifyWindow(hwnd: Integer; lMsg: Integer; lInstanceData: Integer): HResult; stdcall;
    function SetNotifyFlags(lNoNotifyFlags: Integer): HResult; stdcall;
    function GetNotifyFlags(out lplNoNotifyFlags: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IMediaPosition
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {56A868B2-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IMediaPosition = interface(IDispatch)
    ['{56A868B2-0AD4-11CE-B03A-0020AF0BA770}']
    function Get_Duration: Double; safecall;
    procedure Set_CurrentPosition(pllTime: Double); safecall;
    function Get_CurrentPosition: Double; safecall;
    function Get_StopTime: Double; safecall;
    procedure Set_StopTime(pllTime: Double); safecall;
    function Get_PrerollTime: Double; safecall;
    procedure Set_PrerollTime(pllTime: Double); safecall;
    procedure Set_Rate(pdRate: Double); safecall;
    function Get_Rate: Double; safecall;
    function CanSeekForward: Integer; safecall;
    function CanSeekBackward: Integer; safecall;
    property Duration: Double read Get_Duration;
    property CurrentPosition: Double read Get_CurrentPosition write Set_CurrentPosition;
    property StopTime: Double read Get_StopTime write Set_StopTime;
    property PrerollTime: Double read Get_PrerollTime write Set_PrerollTime;
    property Rate: Double read Get_Rate write Set_Rate;
  end;

// *********************************************************************//
// DispIntf:  IMediaPositionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {56A868B2-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IMediaPositionDisp = dispinterface
    ['{56A868B2-0AD4-11CE-B03A-0020AF0BA770}']
    property Duration: Double readonly dispid 1610743808;
    property CurrentPosition: Double dispid 1610743809;
    property StopTime: Double dispid 1610743811;
    property PrerollTime: Double dispid 1610743813;
    property Rate: Double dispid 1610743815;
    function CanSeekForward: Integer; dispid 1610743817;
    function CanSeekBackward: Integer; dispid 1610743818;
  end;

// *********************************************************************//
// Interface: IBasicAudio
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {56A868B3-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IBasicAudio = interface(IDispatch)
    ['{56A868B3-0AD4-11CE-B03A-0020AF0BA770}']
    procedure Set_Volume(plVolume: Integer); safecall;
    function Get_Volume: Integer; safecall;
    procedure Set_Balance(plBalance: Integer); safecall;
    function Get_Balance: Integer; safecall;
    property Volume: Integer read Get_Volume write Set_Volume;
    property Balance: Integer read Get_Balance write Set_Balance;
  end;

// *********************************************************************//
// DispIntf:  IBasicAudioDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {56A868B3-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IBasicAudioDisp = dispinterface
    ['{56A868B3-0AD4-11CE-B03A-0020AF0BA770}']
    property Volume: Integer dispid 1610743808;
    property Balance: Integer dispid 1610743810;
  end;

// *********************************************************************//
// Interface: IVideoWindow
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {56A868B4-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IVideoWindow = interface(IDispatch)
    ['{56A868B4-0AD4-11CE-B03A-0020AF0BA770}']
    procedure Set_Caption(const strCaption: WideString); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_WindowStyle(WindowStyle: Integer); safecall;
    function Get_WindowStyle: Integer; safecall;
    procedure Set_WindowStyleEx(WindowStyleEx: Integer); safecall;
    function Get_WindowStyleEx: Integer; safecall;
    procedure Set_AutoShow(AutoShow: Integer); safecall;
    function Get_AutoShow: Integer; safecall;
    procedure Set_WindowState(WindowState: Integer); safecall;
    function Get_WindowState: Integer; safecall;
    procedure Set_BackgroundPalette(pBackgroundPalette: Integer); safecall;
    function Get_BackgroundPalette: Integer; safecall;
    procedure Set_Visible(pVisible: Integer); safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Left(pLeft: Integer); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Width(pWidth: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Top(pTop: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Height(pHeight: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Owner(Owner: Integer); safecall;
    function Get_Owner: Integer; safecall;
    procedure Set_MessageDrain(Drain: Integer); safecall;
    function Get_MessageDrain: Integer; safecall;
    function Get_BorderColor: Integer; safecall;
    procedure Set_BorderColor(Color: Integer); safecall;
    function Get_FullScreenMode: Integer; safecall;
    procedure Set_FullScreenMode(FullScreenMode: Integer); safecall;
    procedure SetWindowForeground(Focus: Integer); safecall;
    procedure NotifyOwnerMessage(hwnd: Integer; uMsg: Integer; wParam: Integer; lParam: Integer); safecall;
    procedure SetWindowPosition(Left: Integer; Top: Integer; Width: Integer; Height: Integer); safecall;
    procedure GetWindowPosition(out pLeft: Integer; out pTop: Integer; out pWidth: Integer; 
                                out pHeight: Integer); safecall;
    procedure GetMinIdealImageSize(out pWidth: Integer; out pHeight: Integer); safecall;
    procedure GetMaxIdealImageSize(out pWidth: Integer; out pHeight: Integer); safecall;
    procedure GetRestorePosition(out pLeft: Integer; out pTop: Integer; out pWidth: Integer; 
                                 out pHeight: Integer); safecall;
    procedure HideCursor(HideCursor: Integer); safecall;
    procedure IsCursorHidden(out CursorHidden: Integer); safecall;
    property Caption: WideString read Get_Caption write Set_Caption;
    property WindowStyle: Integer read Get_WindowStyle write Set_WindowStyle;
    property WindowStyleEx: Integer read Get_WindowStyleEx write Set_WindowStyleEx;
    property AutoShow: Integer read Get_AutoShow write Set_AutoShow;
    property WindowState: Integer read Get_WindowState write Set_WindowState;
    property BackgroundPalette: Integer read Get_BackgroundPalette write Set_BackgroundPalette;
    property Visible: Integer read Get_Visible write Set_Visible;
    property Left: Integer read Get_Left write Set_Left;
    property Width: Integer read Get_Width write Set_Width;
    property Top: Integer read Get_Top write Set_Top;
    property Height: Integer read Get_Height write Set_Height;
    property Owner: Integer read Get_Owner write Set_Owner;
    property MessageDrain: Integer read Get_MessageDrain write Set_MessageDrain;
    property BorderColor: Integer read Get_BorderColor write Set_BorderColor;
    property FullScreenMode: Integer read Get_FullScreenMode write Set_FullScreenMode;
  end;

// *********************************************************************//
// DispIntf:  IVideoWindowDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {56A868B4-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IVideoWindowDisp = dispinterface
    ['{56A868B4-0AD4-11CE-B03A-0020AF0BA770}']
    property Caption: WideString dispid 1610743808;
    property WindowStyle: Integer dispid 1610743810;
    property WindowStyleEx: Integer dispid 1610743812;
    property AutoShow: Integer dispid 1610743814;
    property WindowState: Integer dispid 1610743816;
    property BackgroundPalette: Integer dispid 1610743818;
    property Visible: Integer dispid 1610743820;
    property Left: Integer dispid 1610743822;
    property Width: Integer dispid 1610743824;
    property Top: Integer dispid 1610743826;
    property Height: Integer dispid 1610743828;
    property Owner: Integer dispid 1610743830;
    property MessageDrain: Integer dispid 1610743832;
    property BorderColor: Integer dispid 1610743834;
    property FullScreenMode: Integer dispid 1610743836;
    procedure SetWindowForeground(Focus: Integer); dispid 1610743838;
    procedure NotifyOwnerMessage(hwnd: Integer; uMsg: Integer; wParam: Integer; lParam: Integer); dispid 1610743839;
    procedure SetWindowPosition(Left: Integer; Top: Integer; Width: Integer; Height: Integer); dispid 1610743840;
    procedure GetWindowPosition(out pLeft: Integer; out pTop: Integer; out pWidth: Integer; 
                                out pHeight: Integer); dispid 1610743841;
    procedure GetMinIdealImageSize(out pWidth: Integer; out pHeight: Integer); dispid 1610743842;
    procedure GetMaxIdealImageSize(out pWidth: Integer; out pHeight: Integer); dispid 1610743843;
    procedure GetRestorePosition(out pLeft: Integer; out pTop: Integer; out pWidth: Integer; 
                                 out pHeight: Integer); dispid 1610743844;
    procedure HideCursor(HideCursor: Integer); dispid 1610743845;
    procedure IsCursorHidden(out CursorHidden: Integer); dispid 1610743846;
  end;

// *********************************************************************//
// Interface: IBasicVideo
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {56A868B5-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IBasicVideo = interface(IDispatch)
    ['{56A868B5-0AD4-11CE-B03A-0020AF0BA770}']
    function Get_AvgTimePerFrame: Double; safecall;
    function Get_BitRate: Integer; safecall;
    function Get_BitErrorRate: Integer; safecall;
    function Get_VideoWidth: Integer; safecall;
    function Get_VideoHeight: Integer; safecall;
    procedure Set_SourceLeft(pSourceLeft: Integer); safecall;
    function Get_SourceLeft: Integer; safecall;
    procedure Set_SourceWidth(pSourceWidth: Integer); safecall;
    function Get_SourceWidth: Integer; safecall;
    procedure Set_SourceTop(pSourceTop: Integer); safecall;
    function Get_SourceTop: Integer; safecall;
    procedure Set_SourceHeight(pSourceHeight: Integer); safecall;
    function Get_SourceHeight: Integer; safecall;
    procedure Set_DestinationLeft(pDestinationLeft: Integer); safecall;
    function Get_DestinationLeft: Integer; safecall;
    procedure Set_DestinationWidth(pDestinationWidth: Integer); safecall;
    function Get_DestinationWidth: Integer; safecall;
    procedure Set_DestinationTop(pDestinationTop: Integer); safecall;
    function Get_DestinationTop: Integer; safecall;
    procedure Set_DestinationHeight(pDestinationHeight: Integer); safecall;
    function Get_DestinationHeight: Integer; safecall;
    procedure SetSourcePosition(Left: Integer; Top: Integer; Width: Integer; Height: Integer); safecall;
    procedure GetSourcePosition(out pLeft: Integer; out pTop: Integer; out pWidth: Integer; 
                                out pHeight: Integer); safecall;
    procedure SetDefaultSourcePosition; safecall;
    procedure SetDestinationPosition(Left: Integer; Top: Integer; Width: Integer; Height: Integer); safecall;
    procedure GetDestinationPosition(out pLeft: Integer; out pTop: Integer; out pWidth: Integer; 
                                     out pHeight: Integer); safecall;
    procedure SetDefaultDestinationPosition; safecall;
    procedure GetVideoSize(out pWidth: Integer; out pHeight: Integer); safecall;
    procedure GetVideoPaletteEntries(StartIndex: Integer; Entries: Integer; 
                                     out pRetrieved: Integer; out pPalette: Integer); safecall;
    procedure GetCurrentImage(var pBufferSize: Integer; out pDIBImage: Integer); safecall;
    procedure IsUsingDefaultSource; safecall;
    procedure IsUsingDefaultDestination; safecall;
    property AvgTimePerFrame: Double read Get_AvgTimePerFrame;
    property BitRate: Integer read Get_BitRate;
    property BitErrorRate: Integer read Get_BitErrorRate;
    property VideoWidth: Integer read Get_VideoWidth;
    property VideoHeight: Integer read Get_VideoHeight;
    property SourceLeft: Integer read Get_SourceLeft write Set_SourceLeft;
    property SourceWidth: Integer read Get_SourceWidth write Set_SourceWidth;
    property SourceTop: Integer read Get_SourceTop write Set_SourceTop;
    property SourceHeight: Integer read Get_SourceHeight write Set_SourceHeight;
    property DestinationLeft: Integer read Get_DestinationLeft write Set_DestinationLeft;
    property DestinationWidth: Integer read Get_DestinationWidth write Set_DestinationWidth;
    property DestinationTop: Integer read Get_DestinationTop write Set_DestinationTop;
    property DestinationHeight: Integer read Get_DestinationHeight write Set_DestinationHeight;
  end;

// *********************************************************************//
// DispIntf:  IBasicVideoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {56A868B5-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IBasicVideoDisp = dispinterface
    ['{56A868B5-0AD4-11CE-B03A-0020AF0BA770}']
    property AvgTimePerFrame: Double readonly dispid 1610743808;
    property BitRate: Integer readonly dispid 1610743809;
    property BitErrorRate: Integer readonly dispid 1610743810;
    property VideoWidth: Integer readonly dispid 1610743811;
    property VideoHeight: Integer readonly dispid 1610743812;
    property SourceLeft: Integer dispid 1610743813;
    property SourceWidth: Integer dispid 1610743815;
    property SourceTop: Integer dispid 1610743817;
    property SourceHeight: Integer dispid 1610743819;
    property DestinationLeft: Integer dispid 1610743821;
    property DestinationWidth: Integer dispid 1610743823;
    property DestinationTop: Integer dispid 1610743825;
    property DestinationHeight: Integer dispid 1610743827;
    procedure SetSourcePosition(Left: Integer; Top: Integer; Width: Integer; Height: Integer); dispid 1610743829;
    procedure GetSourcePosition(out pLeft: Integer; out pTop: Integer; out pWidth: Integer; 
                                out pHeight: Integer); dispid 1610743830;
    procedure SetDefaultSourcePosition; dispid 1610743831;
    procedure SetDestinationPosition(Left: Integer; Top: Integer; Width: Integer; Height: Integer); dispid 1610743832;
    procedure GetDestinationPosition(out pLeft: Integer; out pTop: Integer; out pWidth: Integer; 
                                     out pHeight: Integer); dispid 1610743833;
    procedure SetDefaultDestinationPosition; dispid 1610743834;
    procedure GetVideoSize(out pWidth: Integer; out pHeight: Integer); dispid 1610743835;
    procedure GetVideoPaletteEntries(StartIndex: Integer; Entries: Integer; 
                                     out pRetrieved: Integer; out pPalette: Integer); dispid 1610743836;
    procedure GetCurrentImage(var pBufferSize: Integer; out pDIBImage: Integer); dispid 1610743837;
    procedure IsUsingDefaultSource; dispid 1610743838;
    procedure IsUsingDefaultDestination; dispid 1610743839;
  end;

// *********************************************************************//
// Interface: IDeferredCommand
// Flags:     (0)
// GUID:      {56A868B8-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IDeferredCommand = interface(IUnknown)
    ['{56A868B8-0AD4-11CE-B03A-0020AF0BA770}']
    function Cancel: HResult; stdcall;
    function Confidence(out pConfidence: Integer): HResult; stdcall;
    function Postpone(newtime: Double): HResult; stdcall;
    function GetHResult(out phrResult: HResult): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IQueueCommand
// Flags:     (0)
// GUID:      {56A868B7-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IQueueCommand = interface(IUnknown)
    ['{56A868B7-0AD4-11CE-B03A-0020AF0BA770}']
    function InvokeAtStreamTime(out pCmd: IDeferredCommand; time: Double; var iid: TGUID; 
                                dispidMethod: Integer; wFlags: Smallint; cArgs: Integer; 
                                var pDispParams: OleVariant; var pvarResult: OleVariant; 
                                out puArgErr: Smallint): HResult; stdcall;
    function InvokeAtPresentationTime(out pCmd: IDeferredCommand; time: Double; var iid: TGUID; 
                                      dispidMethod: Integer; wFlags: Smallint; cArgs: Integer; 
                                      var pDispParams: OleVariant; var pvarResult: OleVariant; 
                                      out puArgErr: Smallint): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IFilterInfo
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {56A868BA-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IFilterInfo = interface(IDispatch)
    ['{56A868BA-0AD4-11CE-B03A-0020AF0BA770}']
    procedure FindPin(const strPinID: WideString; out ppUnk: IDispatch); safecall;
    function Get_Name: WideString; safecall;
    function Get_VendorInfo: WideString; safecall;
    function Get_Filter: IUnknown; safecall;
    function Get_Pins: IDispatch; safecall;
    function Get_IsFileSource: Integer; safecall;
    function Get_Filename: WideString; safecall;
    procedure Set_Filename(const pstrFilename: WideString); safecall;
    property Name: WideString read Get_Name;
    property VendorInfo: WideString read Get_VendorInfo;
    property Filter: IUnknown read Get_Filter;
    property Pins: IDispatch read Get_Pins;
    property IsFileSource: Integer read Get_IsFileSource;
    property Filename: WideString read Get_Filename write Set_Filename;
  end;

// *********************************************************************//
// DispIntf:  IFilterInfoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {56A868BA-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IFilterInfoDisp = dispinterface
    ['{56A868BA-0AD4-11CE-B03A-0020AF0BA770}']
    procedure FindPin(const strPinID: WideString; out ppUnk: IDispatch); dispid 1610743808;
    property Name: WideString readonly dispid 1610743809;
    property VendorInfo: WideString readonly dispid 1610743810;
    property Filter: IUnknown readonly dispid 1610743811;
    property Pins: IDispatch readonly dispid 1610743812;
    property IsFileSource: Integer readonly dispid 1610743813;
    property Filename: WideString dispid 1610743814;
  end;

// *********************************************************************//
// Interface: IRegFilterInfo
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {56A868BB-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IRegFilterInfo = interface(IDispatch)
    ['{56A868BB-0AD4-11CE-B03A-0020AF0BA770}']
    function Get_Name: WideString; safecall;
    procedure Filter(out ppUnk: IDispatch); safecall;
    property Name: WideString read Get_Name;
  end;

// *********************************************************************//
// DispIntf:  IRegFilterInfoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {56A868BB-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IRegFilterInfoDisp = dispinterface
    ['{56A868BB-0AD4-11CE-B03A-0020AF0BA770}']
    property Name: WideString readonly dispid 1610743808;
    procedure Filter(out ppUnk: IDispatch); dispid 1610743809;
  end;

// *********************************************************************//
// Interface: IMediaTypeInfo
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {56A868BC-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IMediaTypeInfo = interface(IDispatch)
    ['{56A868BC-0AD4-11CE-B03A-0020AF0BA770}']
    function Get_Type_: WideString; safecall;
    function Get_Subtype: WideString; safecall;
    property Type_: WideString read Get_Type_;
    property Subtype: WideString read Get_Subtype;
  end;

// *********************************************************************//
// DispIntf:  IMediaTypeInfoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {56A868BC-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IMediaTypeInfoDisp = dispinterface
    ['{56A868BC-0AD4-11CE-B03A-0020AF0BA770}']
    property Type_: WideString readonly dispid 1610743808;
    property Subtype: WideString readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: IPinInfo
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {56A868BD-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IPinInfo = interface(IDispatch)
    ['{56A868BD-0AD4-11CE-B03A-0020AF0BA770}']
    function Get_Pin: IUnknown; safecall;
    function Get_ConnectedTo: IDispatch; safecall;
    function Get_ConnectionMediaType: IDispatch; safecall;
    function Get_FilterInfo: IDispatch; safecall;
    function Get_Name: WideString; safecall;
    function Get_Direction: Integer; safecall;
    function Get_PinID: WideString; safecall;
    function Get_MediaTypes: IDispatch; safecall;
    procedure Connect(const pPin: IUnknown); safecall;
    procedure ConnectDirect(const pPin: IUnknown); safecall;
    procedure ConnectWithType(const pPin: IUnknown; const pMediaType: IDispatch); safecall;
    procedure Disconnect; safecall;
    procedure Render; safecall;
    property Pin: IUnknown read Get_Pin;
    property ConnectedTo: IDispatch read Get_ConnectedTo;
    property ConnectionMediaType: IDispatch read Get_ConnectionMediaType;
    property FilterInfo: IDispatch read Get_FilterInfo;
    property Name: WideString read Get_Name;
    property Direction: Integer read Get_Direction;
    property PinID: WideString read Get_PinID;
    property MediaTypes: IDispatch read Get_MediaTypes;
  end;

// *********************************************************************//
// DispIntf:  IPinInfoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {56A868BD-0AD4-11CE-B03A-0020AF0BA770}
// *********************************************************************//
  IPinInfoDisp = dispinterface
    ['{56A868BD-0AD4-11CE-B03A-0020AF0BA770}']
    property Pin: IUnknown readonly dispid 1610743808;
    property ConnectedTo: IDispatch readonly dispid 1610743809;
    property ConnectionMediaType: IDispatch readonly dispid 1610743810;
    property FilterInfo: IDispatch readonly dispid 1610743811;
    property Name: WideString readonly dispid 1610743812;
    property Direction: Integer readonly dispid 1610743813;
    property PinID: WideString readonly dispid 1610743814;
    property MediaTypes: IDispatch readonly dispid 1610743815;
    procedure Connect(const pPin: IUnknown); dispid 1610743816;
    procedure ConnectDirect(const pPin: IUnknown); dispid 1610743817;
    procedure ConnectWithType(const pPin: IUnknown; const pMediaType: IDispatch); dispid 1610743818;
    procedure Disconnect; dispid 1610743819;
    procedure Render; dispid 1610743820;
  end;

  CoFilgraphManager = class
    class function Create: IMediaControl;
    class function CreateRemote(const MachineName: string): IMediaControl;
  end;

implementation

uses ComObj;

class function CoFilgraphManager.Create: IMediaControl;
begin
  Result := CreateComObject(CLASS_FilgraphManager) as IMediaControl;
end;

class function CoFilgraphManager.CreateRemote(const MachineName: string): IMediaControl;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FilgraphManager) as IMediaControl;
end;

end.
