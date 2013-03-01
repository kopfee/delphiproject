unit ImgeditLibCtl_TLB;

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
// File generated on 98-12-9 13:37:49 from Type Library described below.

// ************************************************************************ //
// Type Lib: C:\WIN98.SYSTEMFOR97\IMGEDIT.OCX
// IID\LCID: {6D940288-9F11-11CE-83FD-02608C3EC08A}\0
// Helpfile: C:\WIN98.SYSTEMFOR97\imgocxd.hlp
// HelpString: Kodak Image Edit Controls
// Version:    2.1
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
  LIBID_ImgeditLibCtl: TGUID = '{6D940288-9F11-11CE-83FD-02608C3EC08A}';
  DIID__DImgEdit: TGUID = '{6D940281-9F11-11CE-83FD-02608C3EC08A}';
  DIID__DImgEditEvents: TGUID = '{6D940282-9F11-11CE-83FD-02608C3EC08A}';
  CLASS_ImgEdit: TGUID = '{6D940280-9F11-11CE-83FD-02608C3EC08A}';
  DIID__DImgAnnTool: TGUID = '{6D940286-9F11-11CE-83FD-02608C3EC08A}';
  DIID__DImgAnnToolEvents: TGUID = '{6D940287-9F11-11CE-83FD-02608C3EC08A}';
  CLASS_ImgAnnTool: TGUID = '{6D940285-9F11-11CE-83FD-02608C3EC08A}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                  //
// *********************************************************************//
// AnnotationStyleConstants constants
type
  AnnotationStyleConstants = TOleEnum;
const
  wiTransparent = $00000000;
  wiOpaque = $00000001;

// PageTypeConstants constants
type
  PageTypeConstants = TOleEnum;
const
  wiPageTypeBW = $00000001;
  wiPageTypeGray4 = $00000002;
  wiPageTypeGray8 = $00000003;
  wiPageTypePal4 = $00000004;
  wiPageTypePal8 = $00000005;
  wiPageTypeRGB24 = $00000006;
  wiPageTypeBGR24 = $00000007;

// AnnotationTypeConstants constants
type
  AnnotationTypeConstants = TOleEnum;
const
  wiNone = $00000000;
  wiStraightLine = $00000001;
  wiFreehandLine = $00000002;
  wiHollowRect = $00000003;
  wiFilledRect = $00000004;
  wiImageEmbedded = $00000005;
  wiImageReference = $00000006;
  wiText = $00000007;
  wiTextStamp = $00000008;
  wiTextFromFile = $00000009;
  wiTextAttachment = $0000000A;
  wiAnnotationSelection = $0000000B;

// DisplayScaleConstants constants
type
  DisplayScaleConstants = TOleEnum;
const
  wiScaleNormal = $00000000;
  wiScaleGray4 = $00000001;
  wiScaleGray8 = $00000002;
  wiScaleStamp = $00000003;
  wiScaleOptimize = $00000004;

// ImagePaletteConstants constants
type
  ImagePaletteConstants = TOleEnum;
const
  wiPaletteCustom = $00000000;
  wiPaletteCommon = $00000001;
  wiPaletteGray8 = $00000002;
  wiPaletteRGB24 = $00000003;
  wiPaletteBlackWhite = $00000004;

// FileTypeConstants constants
type
  FileTypeConstants = TOleEnum;
const
  wiFileTypeTIFF = $00000001;
  wiFileTypeAWD = $00000002;
  wiFileTypeBMP = $00000003;
  wiFileTypePCX = $00000004;
  wiFileTypeDCX = $00000005;
  wiFileTypeJPG = $00000006;
  wiFileTypeXIF = $00000007;
  wiFileTypeGIF = $00000008;
  wiFileTypeWIFF = $00000009;

// MousePointerConstants constants
type
  MousePointerConstants = TOleEnum;
const
  wiMPDefault = $00000000;
  wiMPArrow = $00000001;
  wiMPCross = $00000002;
  wiMPIBeam = $00000003;
  wiMPIcon = $00000004;
  wiMPSize = $00000005;
  wiMPSizeNESW = $00000006;
  wiMPSizeNS = $00000007;
  wiMPSizeNWSE = $00000008;
  wiMPSizeWE = $00000009;
  wiMPUpArrow = $0000000A;
  wiMPHourGlass = $0000000B;
  wiMPNoDrop = $0000000C;
  wiMPArrowHourglass = $0000000D;
  wiMPArrowQuestion = $0000000E;
  wiMPSizeAll = $0000000F;
  wiMPFreehandLine = $00000010;
  wiMPHollowRect = $00000011;
  wiMPFilledRect = $00000012;
  wiMPRubberStamp = $00000013;
  wiMPText = $00000014;
  wiMPTextFromFile = $00000015;
  wiMPTextAttachment = $00000016;
  wiMPHand = $00000017;
  wiMPSelect = $00000018;
  wiMPCustom = $00000063;

// EditCommandConstants constants
type
  EditCommandConstants = TOleEnum;
const
  wiCutEditText = $00000000;
  wiCopyEditText = $00000001;
  wiPasteEditText = $00000002;
  wiUndoEditText = $00000003;
  wiSelectAllEditText = $00000004;
  wiDeleteEditText = $00000005;
  wiCanUndoEditText = $00000006;
  wiIsEditTextSelected = $00000007;
  wiFinishEditText = $00000008;
  wiCancelEditText = $00000009;
  wiIsModifiedEditText = $0000000A;

type

// *********************************************************************//
// Forward declaration of interfaces defined in Type Library            //
// *********************************************************************//
  _DImgEdit = dispinterface;
  _DImgEditEvents = dispinterface;
  _DImgAnnTool = dispinterface;
  _DImgAnnToolEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                     //
// (NOTE: Here we map each CoClass to its Default Interface)            //
// *********************************************************************//
  ImgEdit = _DImgEdit;
  ImgAnnTool = _DImgAnnTool;


// *********************************************************************//
// Declaration of structures, unions and aliases.                       //
// *********************************************************************//
  PSmallint1 = ^Smallint; {*}
  PWideString1 = ^WideString; {*}
  PWordBool1 = ^WordBool; {*}


// *********************************************************************//
// DispIntf:  _DImgEdit
// Flags:     (4112) Hidden Dispatchable
// GUID:      {6D940281-9F11-11CE-83FD-02608C3EC08A}
// *********************************************************************//
  _DImgEdit = dispinterface
    ['{6D940281-9F11-11CE-83FD-02608C3EC08A}']
    property Image: WideString dispid 1;
    property ImageControl: WideString dispid 2;
    property AnnotationType: AnnotationTypeConstants dispid 3;
    property AnnotationGroupCount: Smallint dispid 4;
    property Zoom: Single dispid 5;
    property Page: Integer dispid 6;
    property AnnotationBackColor: OLE_COLOR dispid 7;
    property AnnotationFillColor: OLE_COLOR dispid 8;
    property AnnotationFillStyle: AnnotationStyleConstants dispid 9;
    property AnnotationFont: IFontDisp dispid 10;
    property AnnotationImage: WideString dispid 11;
    property AnnotationLineColor: OLE_COLOR dispid 12;
    property AnnotationLineStyle: AnnotationStyleConstants dispid 13;
    property AnnotationLineWidth: Smallint dispid 14;
    property AnnotationStampText: WideString dispid 15;
    property AnnotationTextFile: WideString dispid 16;
    property DisplayScaleAlgorithm: DisplayScaleConstants dispid 17;
    property ImageDisplayed: WordBool dispid 18;
    property ImageHeight: OLE_YSIZE_PIXELS dispid 19;
    property ImageModified: WordBool dispid 20;
    property ImagePalette: ImagePaletteConstants dispid 21;
    property ImageResolutionX: Integer dispid 22;
    property ImageResolutionY: Integer dispid 23;
    property MousePointer: MousePointerConstants dispid 24;
    property PageCount: Integer dispid 25;
    property ScrollBars: WordBool dispid 26;
    property ScrollPositionX: OLE_XPOS_PIXELS dispid 27;
    property ScrollPositionY: OLE_YPOS_PIXELS dispid 28;
    property AnnotationFontColor: OLE_COLOR dispid 29;
    property CompressionType: Smallint dispid 30;
    property FileType: Smallint dispid 31;
    property ScrollShortcutsEnabled: WordBool dispid 32;
    property SelectionRectangle: WordBool dispid 33;
    property PageType: Smallint dispid 34;
    property CompressionInfo: Integer dispid 35;
    property StatusCode: Integer dispid 36;
    property MouseIcon: IPictureDisp dispid 37;
    property AutoRefresh: WordBool dispid 38;
    property ImageWidth: OLE_XSIZE_PIXELS dispid 39;
    property BorderStyle: Smallint dispid -504;
    property Enabled: WordBool dispid -514;
    property hWnd: OLE_HANDLE dispid -515;
    property ImageScaleHeight: OLE_YSIZE_PIXELS dispid 40;
    property ImageScaleWidth: OLE_XSIZE_PIXELS dispid 41;
    property UndoLevels: Integer dispid 2048;
    property UndoScope: Integer dispid 2049;
    property UndoBufferSize: Integer dispid 2050;
    property UseCheckContinuePrinting: WordBool dispid 2056;
    property ContinuePrinting: WordBool dispid 2057;
    property ContinueWithoutUndo: WordBool dispid 2058;
    property DisplayICMEnabled: WordBool dispid 2059;
    property ReadyState: Integer readonly dispid -525;
    procedure Display; dispid 301;
    function GetAnnotationGroup(Index: Smallint): WideString; dispid 302;
    procedure AddAnnotationGroup(const GroupName: WideString); dispid 303;
    function GetSelectedAnnotationLineColor: OLE_COLOR; dispid 304;
    procedure ClearDisplay; dispid 305;
    procedure DeleteAnnotationGroup(const GroupName: WideString); dispid 306;
    procedure DeleteImageData(Left: OleVariant; Top: OleVariant; Width: OleVariant; 
                              Height: OleVariant); dispid 307;
    procedure ClipboardCopy(Left: OleVariant; Top: OleVariant; Width: OleVariant; Height: OleVariant); dispid 308;
    procedure ClipboardCut(Left: OleVariant; Top: OleVariant; Width: OleVariant; Height: OleVariant); dispid 309;
    procedure DeleteSelectedAnnotations; dispid 310;
    procedure Flip; dispid 311;
    function GetSelectedAnnotationBackColor: OLE_COLOR; dispid 312;
    function GetSelectedAnnotationFont: IFontDisp; dispid 313;
    function GetSelectedAnnotationImage: WideString; dispid 314;
    function GetSelectedAnnotationLineStyle: Smallint; dispid 315;
    function GetSelectedAnnotationLineWidth: Smallint; dispid 316;
    procedure HideAnnotationToolPalette; dispid 317;
    function IsClipboardDataAvailable: WordBool; dispid 318;
    procedure Refresh; dispid 319;
    procedure RotateLeft(Degrees: OleVariant); dispid 320;
    procedure RotateRight(Degrees: OleVariant); dispid 321;
    procedure Save(SaveAtZoom: OleVariant); dispid 322;
    procedure ScrollImage(Direction: Smallint; ScrollAmount: Integer); dispid 323;
    procedure SelectAnnotationGroup(const GroupName: WideString); dispid 324;
    procedure SetImagePalette(Option: Smallint); dispid 325;
    procedure SetSelectedAnnotationFillStyle(Style: Smallint); dispid 326;
    procedure SetSelectedAnnotationFont(const Font: IFontDisp); dispid 327;
    procedure SetSelectedAnnotationLineStyle(Style: Smallint); dispid 328;
    procedure SetSelectedAnnotationLineWidth(Width: Smallint); dispid 329;
    procedure ZoomToSelection; dispid 330;
    function GetAnnotationMarkCount(GroupName: OleVariant; AnnotationType: OleVariant): Smallint; dispid 331;
    function GetSelectedAnnotationFillColor: OLE_COLOR; dispid 332;
    function GetSelectedAnnotationFontColor: OLE_COLOR; dispid 333;
    function GetCurrentAnnotationGroup: WideString; dispid 334;
    procedure ConvertPageType(PageType: Smallint; Repaint: OleVariant); dispid 335;
    procedure BurnInAnnotations(Option: Smallint; MarkOption: Smallint; GroupName: OleVariant); dispid 336;
    procedure Draw(Left: OLE_XPOS_PIXELS; Top: OLE_YSIZE_PIXELS; Width: OleVariant; 
                   Height: OleVariant); dispid 337;
    procedure SetSelectedAnnotationLineColor(Color: Integer); dispid 338;
    procedure SetSelectedAnnotationFillColor(Color: Integer); dispid 339;
    procedure HideAnnotationGroup(GroupName: OleVariant); dispid 340;
    procedure ShowAnnotationGroup(GroupName: OleVariant); dispid 341;
    function GetSelectedAnnotationFillStyle: Smallint; dispid 342;
    procedure SaveAs(const Image: WideString; FileType: OleVariant; PageType: OleVariant; 
                     CompressionType: OleVariant; CompressionInfo: OleVariant; 
                     SaveAtZoom: OleVariant); dispid 343;
    procedure SetSelectedAnnotationBackColor(Color: Integer); dispid 344;
    procedure SetSelectedAnnotationFontColor(Color: Integer); dispid 345;
    procedure DrawSelectionRect(Left: OLE_XPOS_PIXELS; Top: OLE_YPOS_PIXELS; 
                                Width: OLE_XSIZE_PIXELS; Height: OLE_YSIZE_PIXELS); dispid 346;
    procedure ShowAnnotationToolPalette(ShowAttrDialog: OleVariant; Left: OleVariant; 
                                        Top: OleVariant; ToolTipText: OleVariant); dispid 347;
    procedure SelectTool(ToolId: Smallint); dispid 348;
    procedure DisplayBlankImage(ImageWidth: Integer; ImageHeight: Integer; ResolutionX: OleVariant; 
                                ResolutionY: OleVariant; PageType: OleVariant); dispid 349;
    procedure ClipboardPaste(Left: OleVariant; Top: OleVariant); dispid 350;
    procedure PrintImage(StartPage: OleVariant; EndPage: OleVariant; OutputFormat: OleVariant; 
                         Annotations: OleVariant; Printer: OleVariant; Driver: OleVariant; 
                         PortNumber: OleVariant); dispid 351;
    procedure FitTo(Option: Smallint; Repaint: OleVariant); dispid 352;
    procedure ShowAttribsDialog(ShowMarkAttrDialog: OleVariant); dispid 353;
    procedure ShowRubberStampDialog; dispid 354;
    procedure RotateAll(Degrees: OleVariant); dispid 355;
    procedure CacheImage(const Image: WideString; Page: Integer); dispid 356;
    procedure EditSelectedAnnotationText(Left: Integer; Top: Integer); dispid 357;
    procedure CompletePaste; dispid 358;
    procedure RemoveImageCache(const Image: WideString; Page: Integer); dispid 359;
    procedure SetCurrentAnnotationGroup(const GroupName: WideString); dispid 360;
    function GetVersion: WideString; dispid 361;
    procedure PrintImageAs(StartPage: OleVariant; EndPage: OleVariant; OutputFormat: OleVariant; 
                           Annotations: OleVariant; JobName: OleVariant; Printer: OleVariant; 
                           Driver: OleVariant; PortNumber: OleVariant); dispid 362;
    function RenderAllPages(Option: Smallint; MarkOption: Smallint): Integer; dispid 363;
    function GetRubberStampMenuItems: WideString; dispid 364;
    procedure SetRubberStampItem(ItemNo: Smallint); dispid 365;
    function GetRubberStampItem: Smallint; dispid 366;
    procedure Undo(Options: OleVariant); dispid 367;
    procedure Redo(Options: OleVariant); dispid 368;
    function ShowPageProperties(bReadOnly: WordBool): Integer; dispid 395;
    procedure SetExternalName(const ExternalImageName: WideString); dispid 396;
    procedure SavePage(const Image: WideString; FileType: OleVariant; PageType: OleVariant; 
                       CompressionType: OleVariant; CompressionInfo: OleVariant; 
                       SaveAtZoom: OleVariant; PageNumber: OleVariant); dispid 399;
    procedure ManualDeSkew; dispid 401;
    procedure AboutBox; dispid -552;
    function ShowColorMatchingOptions(const SourceName: WideString; hWnd: OleVariant): Integer; dispid 402;
    function GetMonitorProfile: WideString; dispid 403;
    function GetPrinterProfile: WideString; dispid 404;
    function GetRenderingIntent: Integer; dispid 405;
    procedure SetMonitorProfile(const MonitorProfile: WideString); dispid 406;
    procedure SetPrinterProfile(const PrinterProfile: WideString); dispid 407;
    procedure SetRenderingIntent(RenderingIntent: Integer); dispid 408;
    function ExecuteTextEditCommand(EditCommand: EditCommandConstants): Integer; dispid 409;
    function GetICMOptions: Integer; dispid 412;
    procedure SetICMOptions(Option: Integer); dispid 413;
    procedure ResetICMDefaults; dispid 414;
  end;

// *********************************************************************//
// DispIntf:  _DImgEditEvents
// Flags:     (4096) Dispatchable
// GUID:      {6D940282-9F11-11CE-83FD-02608C3EC08A}
// *********************************************************************//
  _DImgEditEvents = dispinterface
    ['{6D940282-9F11-11CE-83FD-02608C3EC08A}']
    procedure KeyDown(var KeyCode: Smallint; Shift: Smallint); dispid -602;
    procedure KeyUp(var KeyCode: Smallint; Shift: Smallint); dispid -604;
    procedure KeyPress(var KeyAscii: Smallint); dispid -603;
    procedure MouseDown(Button: Smallint; Shift: Smallint; x: OLE_XPOS_PIXELS; y: OLE_YPOS_PIXELS); dispid -605;
    procedure MouseMove(Button: Smallint; Shift: Smallint; x: OLE_XPOS_PIXELS; y: OLE_YPOS_PIXELS); dispid -606;
    procedure MouseUp(Button: Smallint; Shift: Smallint; x: OLE_XPOS_PIXELS; y: OLE_YPOS_PIXELS); dispid -607;
    procedure Click; dispid -600;
    procedure DblClick; dispid -601;
    procedure Error(Number: Smallint; var Description: WideString; Scode: Integer; 
                    const Source: WideString; const HelpFile: WideString; HelpContext: Integer; 
                    var CancelDisplay: WordBool); dispid -608;
    procedure Close; dispid 1;
    procedure MarkEnd(Left: Integer; Top: Integer; Width: Integer; Height: Integer; 
                      MarkType: Smallint; const GroupName: WideString); dispid 2;
    procedure ToolSelected(ToolId: Smallint); dispid 3;
    procedure SelectionRectDrawn(Left: Integer; Top: Integer; Width: Integer; Height: Integer); dispid 4;
    procedure ToolTip(Index: Smallint); dispid 5;
    procedure ToolPaletteHidden(Left: Integer; Top: Integer); dispid 6;
    procedure Scroll; dispid 7;
    procedure MarkSelect(Button: Smallint; Shift: Smallint; Left: Integer; Top: Integer; 
                         Width: Integer; Height: Integer; MarkType: Smallint; 
                         const GroupName: WideString); dispid 8;
    procedure PasteCompleted; dispid 9;
    procedure Load(Zoom: Double); dispid 10;
    procedure MarkMove(MarkType: Smallint; const GroupName: WideString); dispid 11;
    procedure PagePropertiesClose; dispid 12;
    procedure CheckContinuePrinting(PagesPrinted: Integer; CurrentPage: Integer; Status: Smallint); dispid 13;
    procedure HyperlinkGoToPage(Page: Integer); dispid 14;
    procedure ErrorSavingUndoInformation(Error: Integer); dispid 15;
    procedure StraightenPage; dispid 16;
    procedure HyperlinkGoToDoc(const Link: WideString; Page: Integer; var Handled: WordBool); dispid 17;
    procedure EditingTextAnnotation(Editing: WordBool); dispid 18;
    procedure ReadyStateChange; dispid -609;
  end;

// *********************************************************************//
// DispIntf:  _DImgAnnTool
// Flags:     (4112) Hidden Dispatchable
// GUID:      {6D940286-9F11-11CE-83FD-02608C3EC08A}
// *********************************************************************//
  _DImgAnnTool = dispinterface
    ['{6D940286-9F11-11CE-83FD-02608C3EC08A}']
    property AnnotationBackColor: OLE_COLOR dispid 1;
    property AnnotationFillColor: OLE_COLOR dispid 2;
    property AnnotationFillStyle: AnnotationStyleConstants dispid 3;
    property AnnotationFont: IFontDisp dispid 4;
    property AnnotationFontColor: OLE_COLOR dispid 5;
    property AnnotationImage: WideString dispid 6;
    property AnnotationLineColor: OLE_COLOR dispid 7;
    property AnnotationLineStyle: AnnotationStyleConstants dispid 8;
    property AnnotationLineWidth: Smallint dispid 9;
    property AnnotationStampText: WideString dispid 10;
    property AnnotationTextFile: WideString dispid 11;
    property AnnotationType: AnnotationTypeConstants dispid 12;
    property DestImageControl: WideString dispid 13;
    property Enabled: WordBool dispid -514;
    property PictureDisabled: IPictureDisp dispid 14;
    property PictureDown: IPictureDisp dispid 15;
    property PictureUp: IPictureDisp dispid 16;
    property Value: WordBool dispid 17;
    property hWnd: OLE_HANDLE dispid -515;
    property StatusCode: Integer dispid 18;
    property ReadyState: Integer readonly dispid -525;
    procedure Draw(Left: OLE_XPOS_PIXELS; Top: OLE_YPOS_PIXELS; Width: OleVariant; 
                   Height: OleVariant); dispid 301;
    function GetVersion: WideString; dispid 302;
    procedure AboutBox; dispid -552;
  end;

// *********************************************************************//
// DispIntf:  _DImgAnnToolEvents
// Flags:     (4096) Dispatchable
// GUID:      {6D940287-9F11-11CE-83FD-02608C3EC08A}
// *********************************************************************//
  _DImgAnnToolEvents = dispinterface
    ['{6D940287-9F11-11CE-83FD-02608C3EC08A}']
    procedure Click; dispid -600;
    procedure MouseDown(Button: Smallint; Shift: Smallint; x: OLE_XPOS_PIXELS; y: OLE_YPOS_PIXELS); dispid -605;
    procedure MouseMove(Button: Smallint; Shift: Smallint; x: OLE_XPOS_PIXELS; y: OLE_YPOS_PIXELS); dispid -606;
    procedure MouseUp(Button: Smallint; Shift: Smallint; x: OLE_XPOS_PIXELS; y: OLE_YPOS_PIXELS); dispid -607;
    procedure KeyDown(var KeyCode: Smallint; Shift: Smallint); dispid -602;
    procedure KeyPress(var KeyAscii: Smallint); dispid -603;
    procedure KeyUp(var KeyCode: Smallint; Shift: Smallint); dispid -604;
    procedure Error(Number: Smallint; var Description: WideString; Scode: Integer; 
                    const Source: WideString; const HelpFile: WideString; HelpContext: Integer; 
                    var CancelDisplay: WordBool); dispid -608;
    procedure ReadyStateChange; dispid -609;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TImgEdit
// Help String      : Kodak Image Edit Control
// Default Interface: _DImgEdit
// Def. Intf. DISP? : Yes
// Event   Interface: _DImgEditEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TImgEditError = procedure(Sender: TObject; Number: Smallint; var Description: WideString; 
                                             Scode: Integer; const Source: WideString; 
                                             const HelpFile: WideString; HelpContext: Integer; 
                                             var CancelDisplay: WordBool) of object;
  TImgEditMarkEnd = procedure(Sender: TObject; Left: Integer; Top: Integer; Width: Integer; 
                                               Height: Integer; MarkType: Smallint; 
                                               const GroupName: WideString) of object;
  TImgEditToolSelected = procedure(Sender: TObject; ToolId: Smallint) of object;
  TImgEditSelectionRectDrawn = procedure(Sender: TObject; Left: Integer; Top: Integer; 
                                                          Width: Integer; Height: Integer) of object;
  TImgEditToolTip = procedure(Sender: TObject; Index: Smallint) of object;
  TImgEditToolPaletteHidden = procedure(Sender: TObject; Left: Integer; Top: Integer) of object;
  TImgEditMarkSelect = procedure(Sender: TObject; Button: Smallint; Shift: Smallint; Left: Integer; 
                                                  Top: Integer; Width: Integer; Height: Integer; 
                                                  MarkType: Smallint; const GroupName: WideString) of object;
  TImgEditLoad = procedure(Sender: TObject; Zoom: Double) of object;
  TImgEditMarkMove = procedure(Sender: TObject; MarkType: Smallint; const GroupName: WideString) of object;
  TImgEditCheckContinuePrinting = procedure(Sender: TObject; PagesPrinted: Integer; 
                                                             CurrentPage: Integer; Status: Smallint) of object;
  TImgEditHyperlinkGoToPage = procedure(Sender: TObject; Page: Integer) of object;
  TImgEditErrorSavingUndoInformation = procedure(Sender: TObject; Error: Integer) of object;
  TImgEditHyperlinkGoToDoc = procedure(Sender: TObject; const Link: WideString; Page: Integer; 
                                                        var Handled: WordBool) of object;
  TImgEditEditingTextAnnotation = procedure(Sender: TObject; Editing: WordBool) of object;

  TImgEdit = class(TOleControl)
  private
    FOnError: TImgEditError;
    FOnClose: TNotifyEvent;
    FOnMarkEnd: TImgEditMarkEnd;
    FOnToolSelected: TImgEditToolSelected;
    FOnSelectionRectDrawn: TImgEditSelectionRectDrawn;
    FOnToolTip: TImgEditToolTip;
    FOnToolPaletteHidden: TImgEditToolPaletteHidden;
    FOnScroll: TNotifyEvent;
    FOnMarkSelect: TImgEditMarkSelect;
    FOnPasteCompleted: TNotifyEvent;
    FOnLoad: TImgEditLoad;
    FOnMarkMove: TImgEditMarkMove;
    FOnPagePropertiesClose: TNotifyEvent;
    FOnCheckContinuePrinting: TImgEditCheckContinuePrinting;
    FOnHyperlinkGoToPage: TImgEditHyperlinkGoToPage;
    FOnErrorSavingUndoInformation: TImgEditErrorSavingUndoInformation;
    FOnStraightenPage: TNotifyEvent;
    FOnHyperlinkGoToDoc: TImgEditHyperlinkGoToDoc;
    FOnEditingTextAnnotation: TImgEditEditingTextAnnotation;
    FOnReadyStateChange: TNotifyEvent;
    FIntf: _DImgEdit;
    function  GetControlInterface: _DImgEdit;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure Display;
    function GetAnnotationGroup(Index: Smallint): WideString;
    procedure AddAnnotationGroup(const GroupName: WideString);
    function GetSelectedAnnotationLineColor: OLE_COLOR;
    procedure ClearDisplay;
    procedure DeleteAnnotationGroup(const GroupName: WideString);
    procedure DeleteImageData(Left: OleVariant; Top: OleVariant; Width: OleVariant; 
                              Height: OleVariant);
    procedure ClipboardCopy(Left: OleVariant; Top: OleVariant; Width: OleVariant; Height: OleVariant);
    procedure ClipboardCut(Left: OleVariant; Top: OleVariant; Width: OleVariant; Height: OleVariant);
    procedure DeleteSelectedAnnotations;
    procedure Flip;
    function GetSelectedAnnotationBackColor: OLE_COLOR;
    function GetSelectedAnnotationFont: IFontDisp;
    function GetSelectedAnnotationImage: WideString;
    function GetSelectedAnnotationLineStyle: Smallint;
    function GetSelectedAnnotationLineWidth: Smallint;
    procedure HideAnnotationToolPalette;
    function IsClipboardDataAvailable: WordBool;
    procedure Refresh;
    procedure RotateLeft(Degrees: OleVariant);
    procedure RotateRight(Degrees: OleVariant);
    procedure Save(SaveAtZoom: OleVariant);
    procedure ScrollImage(Direction: Smallint; ScrollAmount: Integer);
    procedure SelectAnnotationGroup(const GroupName: WideString);
    procedure SetImagePalette(Option: Smallint);
    procedure SetSelectedAnnotationFillStyle(Style: Smallint);
    procedure SetSelectedAnnotationFont(const Font: IFontDisp);
    procedure SetSelectedAnnotationLineStyle(Style: Smallint);
    procedure SetSelectedAnnotationLineWidth(Width: Smallint);
    procedure ZoomToSelection;
    function GetAnnotationMarkCount(GroupName: OleVariant; AnnotationType: OleVariant): Smallint;
    function GetSelectedAnnotationFillColor: OLE_COLOR;
    function GetSelectedAnnotationFontColor: OLE_COLOR;
    function GetCurrentAnnotationGroup: WideString;
    procedure ConvertPageType(PageType: Smallint; Repaint: OleVariant);
    procedure BurnInAnnotations(Option: Smallint; MarkOption: Smallint; GroupName: OleVariant);
    procedure Draw(Left: OLE_XPOS_PIXELS; Top: OLE_YSIZE_PIXELS; Width: OleVariant; 
                   Height: OleVariant);
    procedure SetSelectedAnnotationLineColor(Color: Integer);
    procedure SetSelectedAnnotationFillColor(Color: Integer);
    procedure HideAnnotationGroup(GroupName: OleVariant);
    procedure ShowAnnotationGroup(GroupName: OleVariant);
    function GetSelectedAnnotationFillStyle: Smallint;
    procedure SaveAs(const Image: WideString; FileType: OleVariant; PageType: OleVariant; 
                     CompressionType: OleVariant; CompressionInfo: OleVariant; 
                     SaveAtZoom: OleVariant);
    procedure SetSelectedAnnotationBackColor(Color: Integer);
    procedure SetSelectedAnnotationFontColor(Color: Integer);
    procedure DrawSelectionRect(Left: OLE_XPOS_PIXELS; Top: OLE_YPOS_PIXELS; 
                                Width: OLE_XSIZE_PIXELS; Height: OLE_YSIZE_PIXELS);
    procedure ShowAnnotationToolPalette(ShowAttrDialog: OleVariant; Left: OleVariant; 
                                        Top: OleVariant; ToolTipText: OleVariant);
    procedure SelectTool(ToolId: Smallint);
    procedure DisplayBlankImage(ImageWidth: Integer; ImageHeight: Integer; ResolutionX: OleVariant; 
                                ResolutionY: OleVariant; PageType: OleVariant);
    procedure ClipboardPaste(Left: OleVariant; Top: OleVariant);
    procedure PrintImage(StartPage: OleVariant; EndPage: OleVariant; OutputFormat: OleVariant; 
                         Annotations: OleVariant; Printer: OleVariant; Driver: OleVariant; 
                         PortNumber: OleVariant);
    procedure FitTo(Option: Smallint; Repaint: OleVariant);
    procedure ShowAttribsDialog(ShowMarkAttrDialog: OleVariant);
    procedure ShowRubberStampDialog;
    procedure RotateAll(Degrees: OleVariant);
    procedure CacheImage(const Image: WideString; Page: Integer);
    procedure EditSelectedAnnotationText(Left: Integer; Top: Integer);
    procedure CompletePaste;
    procedure RemoveImageCache(const Image: WideString; Page: Integer);
    procedure SetCurrentAnnotationGroup(const GroupName: WideString);
    function GetVersion: WideString;
    procedure PrintImageAs(StartPage: OleVariant; EndPage: OleVariant; OutputFormat: OleVariant; 
                           Annotations: OleVariant; JobName: OleVariant; Printer: OleVariant; 
                           Driver: OleVariant; PortNumber: OleVariant);
    function RenderAllPages(Option: Smallint; MarkOption: Smallint): Integer;
    function GetRubberStampMenuItems: WideString;
    procedure SetRubberStampItem(ItemNo: Smallint);
    function GetRubberStampItem: Smallint;
    procedure Undo(Options: OleVariant);
    procedure Redo(Options: OleVariant);
    function ShowPageProperties(bReadOnly: WordBool): Integer;
    procedure SetExternalName(const ExternalImageName: WideString);
    procedure SavePage(const Image: WideString; FileType: OleVariant; PageType: OleVariant; 
                       CompressionType: OleVariant; CompressionInfo: OleVariant; 
                       SaveAtZoom: OleVariant; PageNumber: OleVariant);
    procedure ManualDeSkew;
    procedure AboutBox;
    function ShowColorMatchingOptions(const SourceName: WideString; hWnd: OleVariant): Integer;
    function GetMonitorProfile: WideString;
    function GetPrinterProfile: WideString;
    function GetRenderingIntent: Integer;
    procedure SetMonitorProfile(const MonitorProfile: WideString);
    procedure SetPrinterProfile(const PrinterProfile: WideString);
    procedure SetRenderingIntent(RenderingIntent: Integer);
    function ExecuteTextEditCommand(EditCommand: EditCommandConstants): Integer;
    function GetICMOptions: Integer;
    procedure SetICMOptions(Option: Integer);
    procedure ResetICMDefaults;
    property  ControlInterface: _DImgEdit read GetControlInterface;
    property UndoScope: Integer index 2049 read GetIntegerProp write SetIntegerProp;
    property UndoBufferSize: Integer index 2050 read GetIntegerProp write SetIntegerProp;
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
    property  OnMouseUp;
    property  OnMouseMove;
    property  OnMouseDown;
    property  OnKeyUp;
    property  OnKeyPress;
    property  OnKeyDown;
    property  OnDblClick;
    property  OnClick;
    property Image: WideString index 1 read GetWideStringProp write SetWideStringProp stored False;
    property ImageControl: WideString index 2 read GetWideStringProp write SetWideStringProp stored False;
    property AnnotationType: TOleEnum index 3 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property AnnotationGroupCount: Smallint index 4 read GetSmallintProp write SetSmallintProp stored False;
    property Zoom: Single index 5 read GetSingleProp write SetSingleProp stored False;
    property Page: Integer index 6 read GetIntegerProp write SetIntegerProp stored False;
    property AnnotationBackColor: TColor index 7 read GetTColorProp write SetTColorProp stored False;
    property AnnotationFillColor: TColor index 8 read GetTColorProp write SetTColorProp stored False;
    property AnnotationFillStyle: TOleEnum index 9 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property AnnotationFont: TFont index 10 read GetTFontProp write SetTFontProp stored False;
    property AnnotationImage: WideString index 11 read GetWideStringProp write SetWideStringProp stored False;
    property AnnotationLineColor: TColor index 12 read GetTColorProp write SetTColorProp stored False;
    property AnnotationLineStyle: TOleEnum index 13 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property AnnotationLineWidth: Smallint index 14 read GetSmallintProp write SetSmallintProp stored False;
    property AnnotationStampText: WideString index 15 read GetWideStringProp write SetWideStringProp stored False;
    property AnnotationTextFile: WideString index 16 read GetWideStringProp write SetWideStringProp stored False;
    property DisplayScaleAlgorithm: TOleEnum index 17 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property ImageDisplayed: WordBool index 18 read GetWordBoolProp write SetWordBoolProp stored False;
    property ImageHeight: Integer index 19 read GetIntegerProp write SetIntegerProp stored False;
    property ImageModified: WordBool index 20 read GetWordBoolProp write SetWordBoolProp stored False;
    property ImagePalette: TOleEnum index 21 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property ImageResolutionX: Integer index 22 read GetIntegerProp write SetIntegerProp stored False;
    property ImageResolutionY: Integer index 23 read GetIntegerProp write SetIntegerProp stored False;
    property MousePointer: TOleEnum index 24 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property PageCount: Integer index 25 read GetIntegerProp write SetIntegerProp stored False;
    property ScrollBars: WordBool index 26 read GetWordBoolProp write SetWordBoolProp stored False;
    property ScrollPositionX: Integer index 27 read GetIntegerProp write SetIntegerProp stored False;
    property ScrollPositionY: Integer index 28 read GetIntegerProp write SetIntegerProp stored False;
    property AnnotationFontColor: TColor index 29 read GetTColorProp write SetTColorProp stored False;
    property CompressionType: Smallint index 30 read GetSmallintProp write SetSmallintProp stored False;
    property FileType: Smallint index 31 read GetSmallintProp write SetSmallintProp stored False;
    property ScrollShortcutsEnabled: WordBool index 32 read GetWordBoolProp write SetWordBoolProp stored False;
    property SelectionRectangle: WordBool index 33 read GetWordBoolProp write SetWordBoolProp stored False;
    property PageType: Smallint index 34 read GetSmallintProp write SetSmallintProp stored False;
    property CompressionInfo: Integer index 35 read GetIntegerProp write SetIntegerProp stored False;
    property StatusCode: Integer index 36 read GetIntegerProp write SetIntegerProp stored False;
    property MouseIcon: TPicture index 37 read GetTPictureProp write SetTPictureProp stored False;
    property AutoRefresh: WordBool index 38 read GetWordBoolProp write SetWordBoolProp stored False;
    property ImageWidth: Integer index 39 read GetIntegerProp write SetIntegerProp stored False;
    property BorderStyle: Smallint index -504 read GetSmallintProp write SetSmallintProp stored False;
    property Enabled: WordBool index -514 read GetWordBoolProp write SetWordBoolProp stored False;
    property hWnd: Integer index -515 read GetIntegerProp write SetIntegerProp stored False;
    property ImageScaleHeight: Integer index 40 read GetIntegerProp write SetIntegerProp stored False;
    property ImageScaleWidth: Integer index 41 read GetIntegerProp write SetIntegerProp stored False;
    property UndoLevels: Integer index 2048 read GetIntegerProp write SetIntegerProp stored False;
    property UseCheckContinuePrinting: WordBool index 2056 read GetWordBoolProp write SetWordBoolProp stored False;
    property ContinuePrinting: WordBool index 2057 read GetWordBoolProp write SetWordBoolProp stored False;
    property ContinueWithoutUndo: WordBool index 2058 read GetWordBoolProp write SetWordBoolProp stored False;
    property DisplayICMEnabled: WordBool index 2059 read GetWordBoolProp write SetWordBoolProp stored False;
    property OnError: TImgEditError read FOnError write FOnError;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnMarkEnd: TImgEditMarkEnd read FOnMarkEnd write FOnMarkEnd;
    property OnToolSelected: TImgEditToolSelected read FOnToolSelected write FOnToolSelected;
    property OnSelectionRectDrawn: TImgEditSelectionRectDrawn read FOnSelectionRectDrawn write FOnSelectionRectDrawn;
    property OnToolTip: TImgEditToolTip read FOnToolTip write FOnToolTip;
    property OnToolPaletteHidden: TImgEditToolPaletteHidden read FOnToolPaletteHidden write FOnToolPaletteHidden;
    property OnScroll: TNotifyEvent read FOnScroll write FOnScroll;
    property OnMarkSelect: TImgEditMarkSelect read FOnMarkSelect write FOnMarkSelect;
    property OnPasteCompleted: TNotifyEvent read FOnPasteCompleted write FOnPasteCompleted;
    property OnLoad: TImgEditLoad read FOnLoad write FOnLoad;
    property OnMarkMove: TImgEditMarkMove read FOnMarkMove write FOnMarkMove;
    property OnPagePropertiesClose: TNotifyEvent read FOnPagePropertiesClose write FOnPagePropertiesClose;
    property OnCheckContinuePrinting: TImgEditCheckContinuePrinting read FOnCheckContinuePrinting write FOnCheckContinuePrinting;
    property OnHyperlinkGoToPage: TImgEditHyperlinkGoToPage read FOnHyperlinkGoToPage write FOnHyperlinkGoToPage;
    property OnErrorSavingUndoInformation: TImgEditErrorSavingUndoInformation read FOnErrorSavingUndoInformation write FOnErrorSavingUndoInformation;
    property OnStraightenPage: TNotifyEvent read FOnStraightenPage write FOnStraightenPage;
    property OnHyperlinkGoToDoc: TImgEditHyperlinkGoToDoc read FOnHyperlinkGoToDoc write FOnHyperlinkGoToDoc;
    property OnEditingTextAnnotation: TImgEditEditingTextAnnotation read FOnEditingTextAnnotation write FOnEditingTextAnnotation;
    property OnReadyStateChange: TNotifyEvent read FOnReadyStateChange write FOnReadyStateChange;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TImgAnnTool
// Help String      : Kodak Image Annotation Control
// Default Interface: _DImgAnnTool
// Def. Intf. DISP? : Yes
// Event   Interface: _DImgAnnToolEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TImgAnnToolError = procedure(Sender: TObject; Number: Smallint; var Description: WideString; 
                                                Scode: Integer; const Source: WideString; 
                                                const HelpFile: WideString; HelpContext: Integer; 
                                                var CancelDisplay: WordBool) of object;

  TImgAnnTool = class(TOleControl)
  private
    FOnError: TImgAnnToolError;
    FOnReadyStateChange: TNotifyEvent;
    FIntf: _DImgAnnTool;
    function  GetControlInterface: _DImgAnnTool;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure Draw(Left: OLE_XPOS_PIXELS; Top: OLE_YPOS_PIXELS; Width: OleVariant; 
                   Height: OleVariant);
    function GetVersion: WideString;
    procedure AboutBox;
    property  ControlInterface: _DImgAnnTool read GetControlInterface;
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
    property  OnMouseUp;
    property  OnMouseMove;
    property  OnMouseDown;
    property  OnKeyUp;
    property  OnKeyPress;
    property  OnKeyDown;
    property  OnClick;
    property AnnotationBackColor: TColor index 1 read GetTColorProp write SetTColorProp stored False;
    property AnnotationFillColor: TColor index 2 read GetTColorProp write SetTColorProp stored False;
    property AnnotationFillStyle: TOleEnum index 3 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property AnnotationFont: TFont index 4 read GetTFontProp write SetTFontProp stored False;
    property AnnotationFontColor: TColor index 5 read GetTColorProp write SetTColorProp stored False;
    property AnnotationImage: WideString index 6 read GetWideStringProp write SetWideStringProp stored False;
    property AnnotationLineColor: TColor index 7 read GetTColorProp write SetTColorProp stored False;
    property AnnotationLineStyle: TOleEnum index 8 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property AnnotationLineWidth: Smallint index 9 read GetSmallintProp write SetSmallintProp stored False;
    property AnnotationStampText: WideString index 10 read GetWideStringProp write SetWideStringProp stored False;
    property AnnotationTextFile: WideString index 11 read GetWideStringProp write SetWideStringProp stored False;
    property AnnotationType: TOleEnum index 12 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property DestImageControl: WideString index 13 read GetWideStringProp write SetWideStringProp stored False;
    property Enabled: WordBool index -514 read GetWordBoolProp write SetWordBoolProp stored False;
    property PictureDisabled: TPicture index 14 read GetTPictureProp write SetTPictureProp stored False;
    property PictureDown: TPicture index 15 read GetTPictureProp write SetTPictureProp stored False;
    property PictureUp: TPicture index 16 read GetTPictureProp write SetTPictureProp stored False;
    property Value: WordBool index 17 read GetWordBoolProp write SetWordBoolProp stored False;
    property hWnd: Integer index -515 read GetIntegerProp write SetIntegerProp stored False;
    property StatusCode: Integer index 18 read GetIntegerProp write SetIntegerProp stored False;
    property OnError: TImgAnnToolError read FOnError write FOnError;
    property OnReadyStateChange: TNotifyEvent read FOnReadyStateChange write FOnReadyStateChange;
  end;

procedure Register;

implementation

uses ComObj;

procedure TImgEdit.InitControlData;
const
  CEventDispIDs: array [0..19] of DWORD = (
    $FFFFFDA0, $00000001, $00000002, $00000003, $00000004, $00000005,
    $00000006, $00000007, $00000008, $00000009, $0000000A, $0000000B,
    $0000000C, $0000000D, $0000000E, $0000000F, $00000010, $00000011,
    $00000012, $FFFFFD9F);
  CTFontIDs: array [0..0] of DWORD = (
    $0000000A);
  CTPictureIDs: array [0..0] of DWORD = (
    $00000025);
  CControlData: TControlData = (
    ClassID: '{6D940280-9F11-11CE-83FD-02608C3EC08A}';
    EventIID: '{6D940282-9F11-11CE-83FD-02608C3EC08A}';
    EventCount: 20;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil;
    Flags: $00000008;
    Version: 300;
    FontCount: 1;
    FontIDs: @CTFontIDs;
    PictureCount: 1;
    PictureIDs: @CTPictureIDs);
begin
  ControlData := @CControlData;
end;

procedure TImgEdit.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as _DImgEdit;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TImgEdit.GetControlInterface: _DImgEdit;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TImgEdit.Display;
begin
  ControlInterface.Display;
end;

function TImgEdit.GetAnnotationGroup(Index: Smallint): WideString;
begin
  Result := ControlInterface.GetAnnotationGroup(Index);
end;

procedure TImgEdit.AddAnnotationGroup(const GroupName: WideString);
begin
  ControlInterface.AddAnnotationGroup(GroupName);
end;

function TImgEdit.GetSelectedAnnotationLineColor: OLE_COLOR;
begin
  Result := ControlInterface.GetSelectedAnnotationLineColor;
end;

procedure TImgEdit.ClearDisplay;
begin
  ControlInterface.ClearDisplay;
end;

procedure TImgEdit.DeleteAnnotationGroup(const GroupName: WideString);
begin
  ControlInterface.DeleteAnnotationGroup(GroupName);
end;

procedure TImgEdit.DeleteImageData(Left: OleVariant; Top: OleVariant; Width: OleVariant; 
                                   Height: OleVariant);
begin
  ControlInterface.DeleteImageData(Left, Top, Width, Height);
end;

procedure TImgEdit.ClipboardCopy(Left: OleVariant; Top: OleVariant; Width: OleVariant; 
                                 Height: OleVariant);
begin
  ControlInterface.ClipboardCopy(Left, Top, Width, Height);
end;

procedure TImgEdit.ClipboardCut(Left: OleVariant; Top: OleVariant; Width: OleVariant; 
                                Height: OleVariant);
begin
  ControlInterface.ClipboardCut(Left, Top, Width, Height);
end;

procedure TImgEdit.DeleteSelectedAnnotations;
begin
  ControlInterface.DeleteSelectedAnnotations;
end;

procedure TImgEdit.Flip;
begin
  ControlInterface.Flip;
end;

function TImgEdit.GetSelectedAnnotationBackColor: OLE_COLOR;
begin
  Result := ControlInterface.GetSelectedAnnotationBackColor;
end;

function TImgEdit.GetSelectedAnnotationFont: IFontDisp;
begin
  Result := ControlInterface.GetSelectedAnnotationFont;
end;

function TImgEdit.GetSelectedAnnotationImage: WideString;
begin
  Result := ControlInterface.GetSelectedAnnotationImage;
end;

function TImgEdit.GetSelectedAnnotationLineStyle: Smallint;
begin
  Result := ControlInterface.GetSelectedAnnotationLineStyle;
end;

function TImgEdit.GetSelectedAnnotationLineWidth: Smallint;
begin
  Result := ControlInterface.GetSelectedAnnotationLineWidth;
end;

procedure TImgEdit.HideAnnotationToolPalette;
begin
  ControlInterface.HideAnnotationToolPalette;
end;

function TImgEdit.IsClipboardDataAvailable: WordBool;
begin
  Result := ControlInterface.IsClipboardDataAvailable;
end;

procedure TImgEdit.Refresh;
begin
  ControlInterface.Refresh;
end;

procedure TImgEdit.RotateLeft(Degrees: OleVariant);
begin
  ControlInterface.RotateLeft(Degrees);
end;

procedure TImgEdit.RotateRight(Degrees: OleVariant);
begin
  ControlInterface.RotateRight(Degrees);
end;

procedure TImgEdit.Save(SaveAtZoom: OleVariant);
begin
  ControlInterface.Save(SaveAtZoom);
end;

procedure TImgEdit.ScrollImage(Direction: Smallint; ScrollAmount: Integer);
begin
  ControlInterface.ScrollImage(Direction, ScrollAmount);
end;

procedure TImgEdit.SelectAnnotationGroup(const GroupName: WideString);
begin
  ControlInterface.SelectAnnotationGroup(GroupName);
end;

procedure TImgEdit.SetImagePalette(Option: Smallint);
begin
  ControlInterface.SetImagePalette(Option);
end;

procedure TImgEdit.SetSelectedAnnotationFillStyle(Style: Smallint);
begin
  ControlInterface.SetSelectedAnnotationFillStyle(Style);
end;

procedure TImgEdit.SetSelectedAnnotationFont(const Font: IFontDisp);
begin
  ControlInterface.SetSelectedAnnotationFont(Font);
end;

procedure TImgEdit.SetSelectedAnnotationLineStyle(Style: Smallint);
begin
  ControlInterface.SetSelectedAnnotationLineStyle(Style);
end;

procedure TImgEdit.SetSelectedAnnotationLineWidth(Width: Smallint);
begin
  ControlInterface.SetSelectedAnnotationLineWidth(Width);
end;

procedure TImgEdit.ZoomToSelection;
begin
  ControlInterface.ZoomToSelection;
end;

function TImgEdit.GetAnnotationMarkCount(GroupName: OleVariant; AnnotationType: OleVariant): Smallint;
begin
  Result := ControlInterface.GetAnnotationMarkCount(GroupName, AnnotationType);
end;

function TImgEdit.GetSelectedAnnotationFillColor: OLE_COLOR;
begin
  Result := ControlInterface.GetSelectedAnnotationFillColor;
end;

function TImgEdit.GetSelectedAnnotationFontColor: OLE_COLOR;
begin
  Result := ControlInterface.GetSelectedAnnotationFontColor;
end;

function TImgEdit.GetCurrentAnnotationGroup: WideString;
begin
  Result := ControlInterface.GetCurrentAnnotationGroup;
end;

procedure TImgEdit.ConvertPageType(PageType: Smallint; Repaint: OleVariant);
begin
  ControlInterface.ConvertPageType(PageType, Repaint);
end;

procedure TImgEdit.BurnInAnnotations(Option: Smallint; MarkOption: Smallint; GroupName: OleVariant);
begin
  ControlInterface.BurnInAnnotations(Option, MarkOption, GroupName);
end;

procedure TImgEdit.Draw(Left: OLE_XPOS_PIXELS; Top: OLE_YSIZE_PIXELS; Width: OleVariant; 
                        Height: OleVariant);
begin
  ControlInterface.Draw(Left, Top, Width, Height);
end;

procedure TImgEdit.SetSelectedAnnotationLineColor(Color: Integer);
begin
  ControlInterface.SetSelectedAnnotationLineColor(Color);
end;

procedure TImgEdit.SetSelectedAnnotationFillColor(Color: Integer);
begin
  ControlInterface.SetSelectedAnnotationFillColor(Color);
end;

procedure TImgEdit.HideAnnotationGroup(GroupName: OleVariant);
begin
  ControlInterface.HideAnnotationGroup(GroupName);
end;

procedure TImgEdit.ShowAnnotationGroup(GroupName: OleVariant);
begin
  ControlInterface.ShowAnnotationGroup(GroupName);
end;

function TImgEdit.GetSelectedAnnotationFillStyle: Smallint;
begin
  Result := ControlInterface.GetSelectedAnnotationFillStyle;
end;

procedure TImgEdit.SaveAs(const Image: WideString; FileType: OleVariant; PageType: OleVariant; 
                          CompressionType: OleVariant; CompressionInfo: OleVariant; 
                          SaveAtZoom: OleVariant);
begin
  ControlInterface.SaveAs(Image, FileType, PageType, CompressionType, CompressionInfo, SaveAtZoom);
end;

procedure TImgEdit.SetSelectedAnnotationBackColor(Color: Integer);
begin
  ControlInterface.SetSelectedAnnotationBackColor(Color);
end;

procedure TImgEdit.SetSelectedAnnotationFontColor(Color: Integer);
begin
  ControlInterface.SetSelectedAnnotationFontColor(Color);
end;

procedure TImgEdit.DrawSelectionRect(Left: OLE_XPOS_PIXELS; Top: OLE_YPOS_PIXELS; 
                                     Width: OLE_XSIZE_PIXELS; Height: OLE_YSIZE_PIXELS);
begin
  ControlInterface.DrawSelectionRect(Left, Top, Width, Height);
end;

procedure TImgEdit.ShowAnnotationToolPalette(ShowAttrDialog: OleVariant; Left: OleVariant; 
                                             Top: OleVariant; ToolTipText: OleVariant);
begin
  ControlInterface.ShowAnnotationToolPalette(ShowAttrDialog, Left, Top, ToolTipText);
end;

procedure TImgEdit.SelectTool(ToolId: Smallint);
begin
  ControlInterface.SelectTool(ToolId);
end;

procedure TImgEdit.DisplayBlankImage(ImageWidth: Integer; ImageHeight: Integer; 
                                     ResolutionX: OleVariant; ResolutionY: OleVariant; 
                                     PageType: OleVariant);
begin
  ControlInterface.DisplayBlankImage(ImageWidth, ImageHeight, ResolutionX, ResolutionY, PageType);
end;

procedure TImgEdit.ClipboardPaste(Left: OleVariant; Top: OleVariant);
begin
  ControlInterface.ClipboardPaste(Left, Top);
end;

procedure TImgEdit.PrintImage(StartPage: OleVariant; EndPage: OleVariant; OutputFormat: OleVariant; 
                              Annotations: OleVariant; Printer: OleVariant; Driver: OleVariant; 
                              PortNumber: OleVariant);
begin
  ControlInterface.PrintImage(StartPage, EndPage, OutputFormat, Annotations, Printer, Driver, 
                              PortNumber);
end;

procedure TImgEdit.FitTo(Option: Smallint; Repaint: OleVariant);
begin
  ControlInterface.FitTo(Option, Repaint);
end;

procedure TImgEdit.ShowAttribsDialog(ShowMarkAttrDialog: OleVariant);
begin
  ControlInterface.ShowAttribsDialog(ShowMarkAttrDialog);
end;

procedure TImgEdit.ShowRubberStampDialog;
begin
  ControlInterface.ShowRubberStampDialog;
end;

procedure TImgEdit.RotateAll(Degrees: OleVariant);
begin
  ControlInterface.RotateAll(Degrees);
end;

procedure TImgEdit.CacheImage(const Image: WideString; Page: Integer);
begin
  ControlInterface.CacheImage(Image, Page);
end;

procedure TImgEdit.EditSelectedAnnotationText(Left: Integer; Top: Integer);
begin
  ControlInterface.EditSelectedAnnotationText(Left, Top);
end;

procedure TImgEdit.CompletePaste;
begin
  ControlInterface.CompletePaste;
end;

procedure TImgEdit.RemoveImageCache(const Image: WideString; Page: Integer);
begin
  ControlInterface.RemoveImageCache(Image, Page);
end;

procedure TImgEdit.SetCurrentAnnotationGroup(const GroupName: WideString);
begin
  ControlInterface.SetCurrentAnnotationGroup(GroupName);
end;

function TImgEdit.GetVersion: WideString;
begin
  Result := ControlInterface.GetVersion;
end;

procedure TImgEdit.PrintImageAs(StartPage: OleVariant; EndPage: OleVariant; 
                                OutputFormat: OleVariant; Annotations: OleVariant; 
                                JobName: OleVariant; Printer: OleVariant; Driver: OleVariant; 
                                PortNumber: OleVariant);
begin
  ControlInterface.PrintImageAs(StartPage, EndPage, OutputFormat, Annotations, JobName, Printer, 
                                Driver, PortNumber);
end;

function TImgEdit.RenderAllPages(Option: Smallint; MarkOption: Smallint): Integer;
begin
  Result := ControlInterface.RenderAllPages(Option, MarkOption);
end;

function TImgEdit.GetRubberStampMenuItems: WideString;
begin
  Result := ControlInterface.GetRubberStampMenuItems;
end;

procedure TImgEdit.SetRubberStampItem(ItemNo: Smallint);
begin
  ControlInterface.SetRubberStampItem(ItemNo);
end;

function TImgEdit.GetRubberStampItem: Smallint;
begin
  Result := ControlInterface.GetRubberStampItem;
end;

procedure TImgEdit.Undo(Options: OleVariant);
begin
  ControlInterface.Undo(Options);
end;

procedure TImgEdit.Redo(Options: OleVariant);
begin
  ControlInterface.Redo(Options);
end;

function TImgEdit.ShowPageProperties(bReadOnly: WordBool): Integer;
begin
  Result := ControlInterface.ShowPageProperties(bReadOnly);
end;

procedure TImgEdit.SetExternalName(const ExternalImageName: WideString);
begin
  ControlInterface.SetExternalName(ExternalImageName);
end;

procedure TImgEdit.SavePage(const Image: WideString; FileType: OleVariant; PageType: OleVariant; 
                            CompressionType: OleVariant; CompressionInfo: OleVariant; 
                            SaveAtZoom: OleVariant; PageNumber: OleVariant);
begin
  ControlInterface.SavePage(Image, FileType, PageType, CompressionType, CompressionInfo, 
                            SaveAtZoom, PageNumber);
end;

procedure TImgEdit.ManualDeSkew;
begin
  ControlInterface.ManualDeSkew;
end;

procedure TImgEdit.AboutBox;
begin
  ControlInterface.AboutBox;
end;

function TImgEdit.ShowColorMatchingOptions(const SourceName: WideString; hWnd: OleVariant): Integer;
begin
  Result := ControlInterface.ShowColorMatchingOptions(SourceName, hWnd);
end;

function TImgEdit.GetMonitorProfile: WideString;
begin
  Result := ControlInterface.GetMonitorProfile;
end;

function TImgEdit.GetPrinterProfile: WideString;
begin
  Result := ControlInterface.GetPrinterProfile;
end;

function TImgEdit.GetRenderingIntent: Integer;
begin
  Result := ControlInterface.GetRenderingIntent;
end;

procedure TImgEdit.SetMonitorProfile(const MonitorProfile: WideString);
begin
  ControlInterface.SetMonitorProfile(MonitorProfile);
end;

procedure TImgEdit.SetPrinterProfile(const PrinterProfile: WideString);
begin
  ControlInterface.SetPrinterProfile(PrinterProfile);
end;

procedure TImgEdit.SetRenderingIntent(RenderingIntent: Integer);
begin
  ControlInterface.SetRenderingIntent(RenderingIntent);
end;

function TImgEdit.ExecuteTextEditCommand(EditCommand: EditCommandConstants): Integer;
begin
  Result := ControlInterface.ExecuteTextEditCommand(EditCommand);
end;

function TImgEdit.GetICMOptions: Integer;
begin
  Result := ControlInterface.GetICMOptions;
end;

procedure TImgEdit.SetICMOptions(Option: Integer);
begin
  ControlInterface.SetICMOptions(Option);
end;

procedure TImgEdit.ResetICMDefaults;
begin
  ControlInterface.ResetICMDefaults;
end;

procedure TImgAnnTool.InitControlData;
const
  CEventDispIDs: array [0..1] of DWORD = (
    $FFFFFDA0, $FFFFFD9F);
  CTFontIDs: array [0..0] of DWORD = (
    $00000004);
  CTPictureIDs: array [0..2] of DWORD = (
    $0000000E, $0000000F, $00000010);
  CControlData: TControlData = (
    ClassID: '{6D940285-9F11-11CE-83FD-02608C3EC08A}';
    EventIID: '{6D940287-9F11-11CE-83FD-02608C3EC08A}';
    EventCount: 2;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil;
    Flags: $00000008;
    Version: 300;
    FontCount: 1;
    FontIDs: @CTFontIDs;
    PictureCount: 3;
    PictureIDs: @CTPictureIDs);
begin
  ControlData := @CControlData;
end;

procedure TImgAnnTool.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as _DImgAnnTool;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TImgAnnTool.GetControlInterface: _DImgAnnTool;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TImgAnnTool.Draw(Left: OLE_XPOS_PIXELS; Top: OLE_YPOS_PIXELS; Width: OleVariant; 
                           Height: OleVariant);
begin
  ControlInterface.Draw(Left, Top, Width, Height);
end;

function TImgAnnTool.GetVersion: WideString;
begin
  Result := ControlInterface.GetVersion;
end;

procedure TImgAnnTool.AboutBox;
begin
  ControlInterface.AboutBox;
end;

procedure Register;
begin
  RegisterComponents('ActiveX',[TImgEdit, TImgAnnTool]);
end;

end.
