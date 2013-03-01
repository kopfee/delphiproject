unit RichTextLib_TLB;

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
// File generated on 98-12-25 11:38:00 from Type Library described below.

// ************************************************************************ //
// Type Lib: C:\PWIN98.NEW\SYSTEM\RICHTX32.OCX
// IID\LCID: {3B7C8863-D78F-101B-B9B5-04021C009402}\0
// Helpfile: C:\PWIN98.NEW\HELP\RTFBox96.HLP
// HelpString: Microsoft Rich Textbox Control 5.0
// Version:    1.1
// ************************************************************************ //

interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, StdVCL, DbOleCtl;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:      //
//   Type Libraries     : LIBID_xxxx                                    //
//   CoClasses          : CLASS_xxxx                                    //
//   DISPInterfaces     : DIID_xxxx                                     //
//   Non-DISP interfaces: IID_xxxx                                      //
// *********************************************************************//
const
  LIBID_RichTextLib: TGUID = '{3B7C8863-D78F-101B-B9B5-04021C009402}';
  IID_IVBDataObject: TGUID = '{2334D2B1-713E-11CF-8AE5-00AA00C00905}';
  CLASS_DataObject: TGUID = '{2334D2B2-713E-11CF-8AE5-00AA00C00905}';
  IID_IVBDataObjectFiles: TGUID = '{2334D2B3-713E-11CF-8AE5-00AA00C00905}';
  CLASS_DataObjectFiles: TGUID = '{2334D2B4-713E-11CF-8AE5-00AA00C00905}';
  IID_IOLEObject: TGUID = '{ED117630-4090-11CF-8981-00AA00688B10}';
  IID_IOLEObjects: TGUID = '{859321D0-3FD1-11CF-8981-00AA00688B10}';
  IID_IRichText: TGUID = '{D92641A0-DF79-11CF-8E74-00A0C90F26F8}';
  DIID_DRichTextEvents: TGUID = '{3B7C8862-D78F-101B-B9B5-04021C009402}';
  CLASS_RichTextBox: TGUID = '{3B7C8860-D78F-101B-B9B5-04021C009402}';
  CLASS_OLEObjects: TGUID = '{4A8F35A0-D900-11CF-89B4-00AA00688B10}';
  CLASS_OLEObject: TGUID = '{4A8F35A1-D900-11CF-89B4-00AA00688B10}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                  //
// *********************************************************************//
// OLEDragConstants constants
type
  OLEDragConstants = TOleEnum;
const
  rtfOLEDragManual = $00000000;
  rtfOLEDragAutomatic = $00000001;

// OLEDropConstants constants
type
  OLEDropConstants = TOleEnum;
const
  rtfOLEDropNone = $00000000;
  rtfOLEDropManual = $00000001;
  rtfOLEDropAutomatic = $00000002;

// DragOverConstants constants
type
  DragOverConstants = TOleEnum;
const
  rtfEnter = $00000000;
  rtfLeave = $00000001;
  rtfOver = $00000002;

// ClipBoardConstants constants
type
  ClipBoardConstants = TOleEnum;
const
  rtfCFText = $00000001;
  rtfCFBitmap = $00000002;
  rtfCFMetafile = $00000003;
  rtfCFDIB = $00000008;
  rtfCFPalette = $00000009;
  rtfCFEMetafile = $0000000E;
  rtfCFFiles = $0000000F;
  rtfCFRTF = $FFFFBF01;

// OLEDropEffectConstants constants
type
  OLEDropEffectConstants = TOleEnum;
const
  rtfOLEDropEffectNone = $00000000;
  rtfOLEDropEffectCopy = $00000001;
  rtfOLEDropEffectMove = $00000002;
  rtfOLEDropEffectScroll = $80000000;

// AppearanceConstants constants
type
  AppearanceConstants = TOleEnum;
const
  rtfFlat = $00000000;
  rtfThreeD = $00000001;

// BorderStyleConstants constants
type
  BorderStyleConstants = TOleEnum;
const
  rtfNoBorder = $00000000;
  rtfFixedSingle = $00000001;

// FindConstants constants
type
  FindConstants = TOleEnum;
const
  rtfWholeWord = $00000002;
  rtfMatchCase = $00000004;
  rtfNoHighlight = $00000008;

// LoadSaveConstants constants
type
  LoadSaveConstants = TOleEnum;
const
  rtfRTF = $00000000;
  rtfText = $00000001;

// MousePointerConstants constants
type
  MousePointerConstants = TOleEnum;
const
  rtfDefault = $00000000;
  rtfArrow = $00000001;
  rtfCross = $00000002;
  rtfIBeam = $00000003;
  rtfIcon = $00000004;
  rtfSize = $00000005;
  rtfSizeNESW = $00000006;
  rtfSizeNS = $00000007;
  rtfSizeNWSE = $00000008;
  rtfSizeEW = $00000009;
  rtfUpArrow = $0000000A;
  rtfHourglass = $0000000B;
  rtfNoDrop = $0000000C;
  rtfArrowHourglass = $0000000D;
  rtfArrowQuestion = $0000000E;
  rtfSizeAll = $0000000F;
  rtfCustom = $00000063;

// ScrollBarsConstants constants
type
  ScrollBarsConstants = TOleEnum;
const
  rtfNone = $00000000;
  rtfHorizontal = $00000001;
  rtfVertical = $00000002;
  rtfBoth = $00000003;

// SelAlignmentConstants constants
type
  SelAlignmentConstants = TOleEnum;
const
  rtfLeft = $00000000;
  rtfRight = $00000001;
  rtfCenter = $00000002;

// DisplayTypeConstants constants
type
  DisplayTypeConstants = TOleEnum;
const
  rtfDisplayContent = $00000000;
  rtfDisplayIcon = $00000001;

// ErrorConstants constants
type
  ErrorConstants = TOleEnum;
const
  rtfOutOfMemory = $00000007;
  rtfInvalidPropertyValue = $0000017C;
  rtfInvalidPropertyArrayIndex = $0000017D;
  rtfSetNotSupported = $0000017F;
  rtfSetNotPermitted = $00000183;
  rtfGetNotSupported = $0000018A;
  rtfInvalidProcedureCall = $00000005;
  rtfInvalidObjectUse = $000001A9;
  rtfWrongClipboardFormat = $000001CD;
  rtfDataObjectLocked = $000002A0;
  rtfExpectedAnArgument = $000002A1;
  rtfRecursiveOleDrag = $000002A2;
  rtfFormatNotByteArray = $000002A3;
  rtfDataNotSetInFormat = $000002A4;
  rtfPathFileAccessError = $0000004B;
  rtfInvalidFileFormat = $00000141;
  rtfInvalidCharPosition = $00007D00;
  rtfInvalidHdc = $00007D01;
  rtfCannotLoadFile = $00007D02;
  rtfProtected = $00007D0B;
  rtfInvalidKeyName = $00007D05;
  rtfInvalidClassName = $00007D06;
  rtfKeyNotFound = $00007D07;
  rtfOLESourceRequired = $00007D08;
  rtfNonUniqueKey = $00007D09;
  rtfInvalidObject = $00007D0A;
  rtfOleCreate = $00007D0C;
  rtfOleServer = $00007D0D;

type

// *********************************************************************//
// Forward declaration of interfaces defined in Type Library            //
// *********************************************************************//
  IVBDataObject = interface;
  IVBDataObjectDisp = dispinterface;
  IVBDataObjectFiles = interface;
  IVBDataObjectFilesDisp = dispinterface;
  IOLEObject = interface;
  IOLEObjectDisp = dispinterface;
  IOLEObjects = interface;
  IOLEObjectsDisp = dispinterface;
  IRichText = interface;
  IRichTextDisp = dispinterface;
  DRichTextEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                     //
// (NOTE: Here we map each CoClass to its Default Interface)            //
// *********************************************************************//
  DataObject = IVBDataObject;
  DataObjectFiles = IVBDataObjectFiles;
  RichTextBox = IRichText;
  OLEObjects = IOLEObjects;
  OLEObject = IOLEObject;


// *********************************************************************//
// Declaration of structures, unions and aliases.                       //
// *********************************************************************//
  PSmallint1 = ^Smallint; {*}


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
// Interface: IOLEObject
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {ED117630-4090-11CF-8981-00AA00688B10}
// *********************************************************************//
  IOLEObject = interface(IDispatch)
    ['{ED117630-4090-11CF-8981-00AA00688B10}']
    function Get_Index: SYSINT; safecall;
    function Get_Key: WideString; safecall;
    procedure Set_Key(const pbstrKey: WideString); safecall;
    function Get_Class_: WideString; safecall;
    function Get_DisplayType: DisplayTypeConstants; safecall;
    procedure Set_DisplayType(pnType: DisplayTypeConstants); safecall;
    function Get_ObjectVerbs: OleVariant; safecall;
    function Get_ObjectVerbFlags: OleVariant; safecall;
    function Get_ObjectVerbsCount: SYSINT; safecall;
    procedure DoVerb(verb: OleVariant); safecall;
    function FetchVerbs: SYSINT; safecall;
    property Index: SYSINT read Get_Index;
    property Key: WideString read Get_Key write Set_Key;
    property Class_: WideString read Get_Class_;
    property DisplayType: DisplayTypeConstants read Get_DisplayType write Set_DisplayType;
    property ObjectVerbs: OleVariant read Get_ObjectVerbs;
    property ObjectVerbFlags: OleVariant read Get_ObjectVerbFlags;
    property ObjectVerbsCount: SYSINT read Get_ObjectVerbsCount;
  end;

// *********************************************************************//
// DispIntf:  IOLEObjectDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {ED117630-4090-11CF-8981-00AA00688B10}
// *********************************************************************//
  IOLEObjectDisp = dispinterface
    ['{ED117630-4090-11CF-8981-00AA00688B10}']
    property Index: SYSINT readonly dispid 1;
    property Key: WideString dispid 2;
    property Class_: WideString readonly dispid 3;
    property DisplayType: DisplayTypeConstants dispid 5;
    property ObjectVerbs: OleVariant readonly dispid 6;
    property ObjectVerbFlags: OleVariant readonly dispid 7;
    property ObjectVerbsCount: SYSINT readonly dispid 8;
    procedure DoVerb(verb: OleVariant); dispid 9;
    function FetchVerbs: SYSINT; dispid 10;
  end;

// *********************************************************************//
// Interface: IOLEObjects
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {859321D0-3FD1-11CF-8981-00AA00688B10}
// *********************************************************************//
  IOLEObjects = interface(IDispatch)
    ['{859321D0-3FD1-11CF-8981-00AA00688B10}']
    function Get_Item(Item: OleVariant): IOLEObject; safecall;
    function Get_Count: Integer; safecall;
    procedure Clear; safecall;
    function Add(Index: OleVariant; Key: OleVariant; source: OleVariant; objclass: OleVariant): IOLEObject; safecall;
    procedure Remove(Item: OleVariant); safecall;
    function _NewEnum: IUnknown; safecall;
    property Item[Item: OleVariant]: IOLEObject read Get_Item;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  IOLEObjectsDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {859321D0-3FD1-11CF-8981-00AA00688B10}
// *********************************************************************//
  IOLEObjectsDisp = dispinterface
    ['{859321D0-3FD1-11CF-8981-00AA00688B10}']
    property Item[Item: OleVariant]: IOLEObject readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    procedure Clear; dispid 4;
    function Add(Index: OleVariant; Key: OleVariant; source: OleVariant; objclass: OleVariant): IOLEObject; dispid 2;
    procedure Remove(Item: OleVariant); dispid 3;
    function _NewEnum: IUnknown; dispid -4;
  end;

// *********************************************************************//
// Interface: IRichText
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {D92641A0-DF79-11CF-8E74-00A0C90F26F8}
// *********************************************************************//
  IRichText = interface(IDispatch)
    ['{D92641A0-DF79-11CF-8E74-00A0C90F26F8}']
    function Get_defTextRTF: WideString; safecall;
    procedure Set_defTextRTF(const pbstrTextRTF: WideString); safecall;
    function Get_Appearance: AppearanceConstants; safecall;
    procedure Set_Appearance(pAppearance: AppearanceConstants); safecall;
    function Get_BackColor: OLE_COLOR; safecall;
    procedure Set_BackColor(pocBackColor: OLE_COLOR); safecall;
    function Get_BorderStyle: BorderStyleConstants; safecall;
    procedure Set_BorderStyle(pBorderStyle: BorderStyleConstants); safecall;
    function Get_BulletIndent: Single; safecall;
    procedure Set_BulletIndent(pflBulletIndent: Single); safecall;
    function Get_DisableNoScroll: WordBool; safecall;
    procedure Set_DisableNoScroll(pfDisableNoScroll: WordBool); safecall;
    function Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(pfEnabled: WordBool); safecall;
    function Get_FileName: WideString; safecall;
    procedure Set_FileName(const pbstrFileName: WideString); safecall;
    function Get_Font: IFontDisp; safecall;
    procedure Set_Font(const ppFont: IFontDisp); safecall;
    function Get_HideSelection: WordBool; safecall;
    procedure Set_HideSelection(pfHideSelection: WordBool); safecall;
    function Get_Hwnd: OLE_HANDLE; safecall;
    procedure Set_Hwnd(pohHwnd: OLE_HANDLE); safecall;
    function Get_Locked: WordBool; safecall;
    procedure Set_Locked(pfLocked: WordBool); safecall;
    function Get_MaxLength: Integer; safecall;
    procedure Set_MaxLength(plMaxLength: Integer); safecall;
    function Get_MouseIcon: IPictureDisp; safecall;
    procedure _Set_MouseIcon(const ppMouseIcon: IPictureDisp); safecall;
    procedure Set_MouseIcon(const ppMouseIcon: IPictureDisp); safecall;
    function Get_MousePointer: MousePointerConstants; safecall;
    procedure Set_MousePointer(pMousePointer: MousePointerConstants); safecall;
    function Get_MultiLine: WordBool; safecall;
    procedure Set_MultiLine(pfMultiLine: WordBool); safecall;
    function Get_RightMargin: Single; safecall;
    procedure Set_RightMargin(pflRightMargin: Single); safecall;
    function Get_ScrollBars: ScrollBarsConstants; safecall;
    procedure Set_ScrollBars(psbcScrollBars: ScrollBarsConstants); safecall;
    function Get_SelAlignment: OleVariant; safecall;
    procedure Set_SelAlignment(pvarSelAlignment: OleVariant); safecall;
    function Get_SelBold: OleVariant; safecall;
    procedure Set_SelBold(pvarSelBold: OleVariant); safecall;
    function Get_SelBullet: OleVariant; safecall;
    procedure Set_SelBullet(pvarSelBullet: OleVariant); safecall;
    function Get_SelCharOffset: OleVariant; safecall;
    procedure Set_SelCharOffset(pvarSelCharOffset: OleVariant); safecall;
    function Get_SelColor: OleVariant; safecall;
    procedure Set_SelColor(pvarSelColor: OleVariant); safecall;
    function Get_SelFontName: OleVariant; safecall;
    procedure Set_SelFontName(pvarSelFontName: OleVariant); safecall;
    function Get_SelFontSize: OleVariant; safecall;
    procedure Set_SelFontSize(pvarSelFontSize: OleVariant); safecall;
    function Get_SelHangingIndent: OleVariant; safecall;
    procedure Set_SelHangingIndent(pvarSelHangingIndent: OleVariant); safecall;
    function Get_SelIndent: OleVariant; safecall;
    procedure Set_SelIndent(pvarSelIndent: OleVariant); safecall;
    function Get_SelItalic: OleVariant; safecall;
    procedure Set_SelItalic(pvarSelItalic: OleVariant); safecall;
    function Get_SelLength: Integer; safecall;
    procedure Set_SelLength(plSelLength: Integer); safecall;
    function Get_SelProtected: OleVariant; safecall;
    procedure Set_SelProtected(pvarSelProtected: OleVariant); safecall;
    function Get_SelRightIndent: OleVariant; safecall;
    procedure Set_SelRightIndent(pvarSelRightIndent: OleVariant); safecall;
    function Get_SelRTF: WideString; safecall;
    procedure Set_SelRTF(const pbstrSelRTF: WideString); safecall;
    function Get_SelStart: Integer; safecall;
    procedure Set_SelStart(plSelStart: Integer); safecall;
    function Get_SelStrikeThru: OleVariant; safecall;
    procedure Set_SelStrikeThru(pvarSelStrikeThru: OleVariant); safecall;
    function Get_SelTabCount: OleVariant; safecall;
    procedure Set_SelTabCount(pvarSelTabCount: OleVariant); safecall;
    function Get_SelText: WideString; safecall;
    procedure Set_SelText(const pbstrSelText: WideString); safecall;
    function Get_SelUnderline: OleVariant; safecall;
    procedure Set_SelUnderline(pvarSelUnderline: OleVariant); safecall;
    function Get_Text: WideString; safecall;
    procedure Set_Text(const pbstrText: WideString); safecall;
    function Get_TextRTF: WideString; safecall;
    procedure Set_TextRTF(const pbstrTextRTF: WideString); safecall;
    function Get_OLEObjects: IOLEObjects; safecall;
    function Get_AutoVerbMenu: WordBool; safecall;
    procedure Set_AutoVerbMenu(pfOn: WordBool); safecall;
    function Get_OLEDragMode: OLEDragConstants; safecall;
    procedure Set_OLEDragMode(psOLEDragMode: OLEDragConstants); safecall;
    function Get_OLEDropMode: OLEDropConstants; safecall;
    procedure Set_OLEDropMode(psOLEDropMode: OLEDropConstants); safecall;
    procedure AboutBox; stdcall;
    function Find(const bstrString: WideString; vStart: OleVariant; vEnd: OleVariant; 
                  vOptions: OleVariant): Integer; safecall;
    function GetLineFromChar(lChar: Integer): Integer; safecall;
    procedure LoadFile(const bstrFilename: WideString; vFileType: OleVariant); safecall;
    procedure Refresh; stdcall;
    procedure SaveFile(const bstrFilename: WideString; vFlags: OleVariant); safecall;
    procedure SelPrint(lHDC: Integer); safecall;
    function Get_SelTabs(sElement: Smallint): OleVariant; safecall;
    procedure Set_SelTabs(sElement: Smallint; pvarSelTab: OleVariant); safecall;
    procedure Span(const bstrCharacterSet: WideString; vForward: OleVariant; vNegate: OleVariant); safecall;
    procedure UpTo(const bstrCharacterSet: WideString; vForward: OleVariant; vNegate: OleVariant); safecall;
    procedure OLEDrag; safecall;
    property defTextRTF: WideString read Get_defTextRTF write Set_defTextRTF;
    property Appearance: AppearanceConstants read Get_Appearance write Set_Appearance;
    property BackColor: OLE_COLOR read Get_BackColor write Set_BackColor;
    property BorderStyle: BorderStyleConstants read Get_BorderStyle write Set_BorderStyle;
    property BulletIndent: Single read Get_BulletIndent write Set_BulletIndent;
    property DisableNoScroll: WordBool read Get_DisableNoScroll write Set_DisableNoScroll;
    property Enabled: WordBool read Get_Enabled write Set_Enabled;
    property FileName: WideString read Get_FileName write Set_FileName;
    property Font: IFontDisp read Get_Font write Set_Font;
    property HideSelection: WordBool read Get_HideSelection write Set_HideSelection;
    property Hwnd: OLE_HANDLE read Get_Hwnd write Set_Hwnd;
    property Locked: WordBool read Get_Locked write Set_Locked;
    property MaxLength: Integer read Get_MaxLength write Set_MaxLength;
    property MouseIcon: IPictureDisp read Get_MouseIcon write _Set_MouseIcon;
    property MousePointer: MousePointerConstants read Get_MousePointer write Set_MousePointer;
    property MultiLine: WordBool read Get_MultiLine write Set_MultiLine;
    property RightMargin: Single read Get_RightMargin write Set_RightMargin;
    property ScrollBars: ScrollBarsConstants read Get_ScrollBars write Set_ScrollBars;
    property SelAlignment: OleVariant read Get_SelAlignment write Set_SelAlignment;
    property SelBold: OleVariant read Get_SelBold write Set_SelBold;
    property SelBullet: OleVariant read Get_SelBullet write Set_SelBullet;
    property SelCharOffset: OleVariant read Get_SelCharOffset write Set_SelCharOffset;
    property SelColor: OleVariant read Get_SelColor write Set_SelColor;
    property SelFontName: OleVariant read Get_SelFontName write Set_SelFontName;
    property SelFontSize: OleVariant read Get_SelFontSize write Set_SelFontSize;
    property SelHangingIndent: OleVariant read Get_SelHangingIndent write Set_SelHangingIndent;
    property SelIndent: OleVariant read Get_SelIndent write Set_SelIndent;
    property SelItalic: OleVariant read Get_SelItalic write Set_SelItalic;
    property SelLength: Integer read Get_SelLength write Set_SelLength;
    property SelProtected: OleVariant read Get_SelProtected write Set_SelProtected;
    property SelRightIndent: OleVariant read Get_SelRightIndent write Set_SelRightIndent;
    property SelRTF: WideString read Get_SelRTF write Set_SelRTF;
    property SelStart: Integer read Get_SelStart write Set_SelStart;
    property SelStrikeThru: OleVariant read Get_SelStrikeThru write Set_SelStrikeThru;
    property SelTabCount: OleVariant read Get_SelTabCount write Set_SelTabCount;
    property SelText: WideString read Get_SelText write Set_SelText;
    property SelUnderline: OleVariant read Get_SelUnderline write Set_SelUnderline;
    property Text: WideString read Get_Text write Set_Text;
    property TextRTF: WideString read Get_TextRTF write Set_TextRTF;
    property OLEObjects: IOLEObjects read Get_OLEObjects;
    property AutoVerbMenu: WordBool read Get_AutoVerbMenu write Set_AutoVerbMenu;
    property OLEDragMode: OLEDragConstants read Get_OLEDragMode write Set_OLEDragMode;
    property OLEDropMode: OLEDropConstants read Get_OLEDropMode write Set_OLEDropMode;
    property SelTabs[sElement: Smallint]: OleVariant read Get_SelTabs write Set_SelTabs;
  end;

// *********************************************************************//
// DispIntf:  IRichTextDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {D92641A0-DF79-11CF-8E74-00A0C90F26F8}
// *********************************************************************//
  IRichTextDisp = dispinterface
    ['{D92641A0-DF79-11CF-8E74-00A0C90F26F8}']
    property defTextRTF: WideString dispid 0;
    property Appearance: AppearanceConstants dispid 29;
    property BackColor: OLE_COLOR dispid -501;
    property BorderStyle: BorderStyleConstants dispid 23;
    property BulletIndent: Single dispid 30;
    property DisableNoScroll: WordBool dispid 7;
    property Enabled: WordBool dispid -514;
    property FileName: WideString dispid 19;
    property Font: IFontDisp dispid -512;
    property HideSelection: WordBool dispid 2;
    property Hwnd: OLE_HANDLE dispid -515;
    property Locked: WordBool dispid 22;
    property MaxLength: Integer dispid 12;
    property MouseIcon: IPictureDisp dispid 6;
    property MousePointer: MousePointerConstants dispid 1;
    property MultiLine: WordBool dispid 3;
    property RightMargin: Single dispid 32;
    property ScrollBars: ScrollBarsConstants dispid 4;
    property SelAlignment: OleVariant dispid 28;
    property SelBold: OleVariant dispid 24;
    property SelBullet: OleVariant dispid 31;
    property SelCharOffset: OleVariant dispid 16;
    property SelColor: OleVariant dispid 13;
    property SelFontName: OleVariant dispid 14;
    property SelFontSize: OleVariant dispid 15;
    property SelHangingIndent: OleVariant dispid 18;
    property SelIndent: OleVariant dispid 17;
    property SelItalic: OleVariant dispid 25;
    property SelLength: Integer dispid 5;
    property SelProtected: OleVariant dispid 48;
    property SelRightIndent: OleVariant dispid 21;
    property SelRTF: WideString dispid 11;
    property SelStart: Integer dispid 8;
    property SelStrikeThru: OleVariant dispid 26;
    property SelTabCount: OleVariant dispid 20;
    property SelText: WideString dispid 9;
    property SelUnderline: OleVariant dispid 27;
    property Text: WideString dispid -517;
    property TextRTF: WideString dispid 10;
    property OLEObjects: IOLEObjects readonly dispid 42;
    property AutoVerbMenu: WordBool dispid 43;
    property OLEDragMode: OLEDragConstants dispid 1550;
    property OLEDropMode: OLEDropConstants dispid 1551;
    procedure AboutBox; dispid -552;
    function Find(const bstrString: WideString; vStart: OleVariant; vEnd: OleVariant; 
                  vOptions: OleVariant): Integer; dispid 34;
    function GetLineFromChar(lChar: Integer): Integer; dispid 33;
    procedure LoadFile(const bstrFilename: WideString; vFileType: OleVariant); dispid 37;
    procedure Refresh; dispid -550;
    procedure SaveFile(const bstrFilename: WideString; vFlags: OleVariant); dispid 38;
    procedure SelPrint(lHDC: Integer); dispid 39;
    property SelTabs[sElement: Smallint]: OleVariant dispid 40;
    procedure Span(const bstrCharacterSet: WideString; vForward: OleVariant; vNegate: OleVariant); dispid 35;
    procedure UpTo(const bstrCharacterSet: WideString; vForward: OleVariant; vNegate: OleVariant); dispid 36;
    procedure OLEDrag; dispid 1552;
  end;

// *********************************************************************//
// DispIntf:  DRichTextEvents
// Flags:     (4224) NonExtensible Dispatchable
// GUID:      {3B7C8862-D78F-101B-B9B5-04021C009402}
// *********************************************************************//
  DRichTextEvents = dispinterface
    ['{3B7C8862-D78F-101B-B9B5-04021C009402}']
    procedure Change; dispid 1;
    procedure Click; dispid -600;
    procedure DblClick; dispid -601;
    procedure KeyDown(var KeyCode: Smallint; Shift: Smallint); dispid -602;
    procedure KeyUp(var KeyCode: Smallint; Shift: Smallint); dispid -604;
    procedure KeyPress(var KeyAscii: Smallint); dispid -603;
    procedure MouseDown(Button: Smallint; Shift: Smallint; x: OLE_XPOS_PIXELS; y: OLE_YPOS_PIXELS); dispid -605;
    procedure MouseMove(Button: Smallint; Shift: Smallint; x: OLE_XPOS_PIXELS; y: OLE_YPOS_PIXELS); dispid -606;
    procedure MouseUp(Button: Smallint; Shift: Smallint; x: OLE_XPOS_PIXELS; y: OLE_YPOS_PIXELS); dispid -607;
    procedure SelChange; dispid 2;
    procedure OLEStartDrag(var Data: DataObject; var AllowedEffects: Integer); dispid 1550;
    procedure OLEGiveFeedback(var Effect: Integer; var DefaultCursors: WordBool); dispid 1551;
    procedure OLESetData(var Data: DataObject; var DataFormat: Smallint); dispid 1552;
    procedure OLECompleteDrag(var Effect: Integer); dispid 1553;
    procedure OLEDragOver(var Data: DataObject; var Effect: Integer; var Button: Smallint; 
                          var Shift: Smallint; var x: Single; var y: Single; var State: Smallint); dispid 1554;
    procedure OLEDragDrop(var Data: DataObject; var Effect: Integer; var Button: Smallint; 
                          var Shift: Smallint; var x: Single; var y: Single); dispid 1555;
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
// Control Name     : TRichTextBox
// Help String      : Microsoft Rich Textbox Control 5.0
// Default Interface: IRichText
// Def. Intf. DISP? : No
// Event   Interface: DRichTextEvents
// TypeFlags        : (38) CanCreate Licensed Control
// *********************************************************************//
  TRichTextBoxOLEStartDrag = procedure(Sender: TObject; var Data: DataObject; 
                                                        var AllowedEffects: Integer) of object;
  TRichTextBoxOLEGiveFeedback = procedure(Sender: TObject; var Effect: Integer; 
                                                           var DefaultCursors: WordBool) of object;
  TRichTextBoxOLESetData = procedure(Sender: TObject; var Data: DataObject; var DataFormat: Smallint) of object;
  TRichTextBoxOLECompleteDrag = procedure(Sender: TObject; var Effect: Integer) of object;
  TRichTextBoxOLEDragOver = procedure(Sender: TObject; var Data: DataObject; var Effect: Integer; 
                                                       var Button: Smallint; var Shift: Smallint; 
                                                       var x: Single; var y: Single; 
                                                       var State: Smallint) of object;
  TRichTextBoxOLEDragDrop = procedure(Sender: TObject; var Data: DataObject; var Effect: Integer; 
                                                       var Button: Smallint; var Shift: Smallint; 
                                                       var x: Single; var y: Single) of object;

  TRichTextBox = class(TDBOleControl)
  private
    FOnChange: TNotifyEvent;
    FOnSelChange: TNotifyEvent;
    FOnOLEStartDrag: TRichTextBoxOLEStartDrag;
    FOnOLEGiveFeedback: TRichTextBoxOLEGiveFeedback;
    FOnOLESetData: TRichTextBoxOLESetData;
    FOnOLECompleteDrag: TRichTextBoxOLECompleteDrag;
    FOnOLEDragOver: TRichTextBoxOLEDragOver;
    FOnOLEDragDrop: TRichTextBoxOLEDragDrop;
    FIntf: IRichText;
    function  GetControlInterface: IRichText;
    function Get_OLEObjects: IOLEObjects;
    function Get_SelTabs(sElement: Smallint): OleVariant;
    procedure Set_SelTabs(sElement: Smallint; pvarSelTab: OleVariant);
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure AboutBox;
    function Find(const bstrString: WideString; vStart: OleVariant; vEnd: OleVariant; 
                  vOptions: OleVariant; out plFind: Integer): Integer;
    function GetLineFromChar(lChar: Integer; out plLine: Integer): Integer;
    procedure LoadFile(const bstrFilename: WideString; vFileType: OleVariant);
    procedure Refresh;
    procedure SaveFile(const bstrFilename: WideString; vFlags: OleVariant);
    procedure SelPrint(lHDC: Integer);
    procedure Span(const bstrCharacterSet: WideString; vForward: OleVariant; vNegate: OleVariant);
    procedure UpTo(const bstrCharacterSet: WideString; vForward: OleVariant; vNegate: OleVariant);
    procedure OLEDrag;
    property  ControlInterface: IRichText read GetControlInterface;
    property defTextRTF: WideString index 0 read GetWideStringProp write SetWideStringProp;
    property Font: TFont index -512 read GetTFontProp write SetTFontProp;
    property OLEObjects: IOLEObjects read Get_OLEObjects;
    property SelTabs[sElement: Smallint]: OleVariant read Get_SelTabs write Set_SelTabs;
  published
    property  ParentColor;
    property  ParentFont;
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
    property Appearance: TOleEnum index 29 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property BackColor: TColor index -501 read GetTColorProp write SetTColorProp stored False;
    property BorderStyle: TOleEnum index 23 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property BulletIndent: Single index 30 read GetSingleProp write SetSingleProp stored False;
    property DisableNoScroll: WordBool index 7 read GetWordBoolProp write SetWordBoolProp stored False;
    property Enabled: WordBool index -514 read GetWordBoolProp write SetWordBoolProp stored False;
    property FileName: WideString index 19 read GetWideStringProp write SetWideStringProp stored False;
    property HideSelection: WordBool index 2 read GetWordBoolProp write SetWordBoolProp stored False;
    property Hwnd: Integer index -515 read GetIntegerProp write SetIntegerProp stored False;
    property Locked: WordBool index 22 read GetWordBoolProp write SetWordBoolProp stored False;
    property MaxLength: Integer index 12 read GetIntegerProp write SetIntegerProp stored False;
    property MouseIcon: TPicture index 6 read GetTPictureProp write SetTPictureProp stored False;
    property MousePointer: TOleEnum index 1 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property MultiLine: WordBool index 3 read GetWordBoolProp write SetWordBoolProp stored False;
    property RightMargin: Single index 32 read GetSingleProp write SetSingleProp stored False;
    property ScrollBars: TOleEnum index 4 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property SelAlignment: OleVariant index 28 read GetOleVariantProp write SetOleVariantProp stored False;
    property SelBold: OleVariant index 24 read GetOleVariantProp write SetOleVariantProp stored False;
    property SelBullet: OleVariant index 31 read GetOleVariantProp write SetOleVariantProp stored False;
    property SelCharOffset: OleVariant index 16 read GetOleVariantProp write SetOleVariantProp stored False;
    property SelColor: OleVariant index 13 read GetOleVariantProp write SetOleVariantProp stored False;
    property SelFontName: OleVariant index 14 read GetOleVariantProp write SetOleVariantProp stored False;
    property SelFontSize: OleVariant index 15 read GetOleVariantProp write SetOleVariantProp stored False;
    property SelHangingIndent: OleVariant index 18 read GetOleVariantProp write SetOleVariantProp stored False;
    property SelIndent: OleVariant index 17 read GetOleVariantProp write SetOleVariantProp stored False;
    property SelItalic: OleVariant index 25 read GetOleVariantProp write SetOleVariantProp stored False;
    property SelLength: Integer index 5 read GetIntegerProp write SetIntegerProp stored False;
    property SelProtected: OleVariant index 48 read GetOleVariantProp write SetOleVariantProp stored False;
    property SelRightIndent: OleVariant index 21 read GetOleVariantProp write SetOleVariantProp stored False;
    property SelRTF: WideString index 11 read GetWideStringProp write SetWideStringProp stored False;
    property SelStart: Integer index 8 read GetIntegerProp write SetIntegerProp stored False;
    property SelStrikeThru: OleVariant index 26 read GetOleVariantProp write SetOleVariantProp stored False;
    property SelTabCount: OleVariant index 20 read GetOleVariantProp write SetOleVariantProp stored False;
    property SelText: WideString index 9 read GetWideStringProp write SetWideStringProp stored False;
    property SelUnderline: OleVariant index 27 read GetOleVariantProp write SetOleVariantProp stored False;
    property Text: WideString index -517 read GetWideStringProp write SetWideStringProp stored False;
    property TextRTF: WideString index 10 read GetWideStringProp write SetWideStringProp stored False;
    property AutoVerbMenu: WordBool index 43 read GetWordBoolProp write SetWordBoolProp stored False;
    property OLEDragMode: TOleEnum index 1550 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property OLEDropMode: TOleEnum index 1551 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnSelChange: TNotifyEvent read FOnSelChange write FOnSelChange;
    property OnOLEStartDrag: TRichTextBoxOLEStartDrag read FOnOLEStartDrag write FOnOLEStartDrag;
    property OnOLEGiveFeedback: TRichTextBoxOLEGiveFeedback read FOnOLEGiveFeedback write FOnOLEGiveFeedback;
    property OnOLESetData: TRichTextBoxOLESetData read FOnOLESetData write FOnOLESetData;
    property OnOLECompleteDrag: TRichTextBoxOLECompleteDrag read FOnOLECompleteDrag write FOnOLECompleteDrag;
    property OnOLEDragOver: TRichTextBoxOLEDragOver read FOnOLEDragOver write FOnOLEDragOver;
    property OnOLEDragDrop: TRichTextBoxOLEDragDrop read FOnOLEDragDrop write FOnOLEDragDrop;
  end;

  CoOLEObjects = class
    class function Create: IOLEObjects;
    class function CreateRemote(const MachineName: string): IOLEObjects;
  end;

  CoOLEObject = class
    class function Create: IOLEObject;
    class function CreateRemote(const MachineName: string): IOLEObject;
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

procedure TRichTextBox.InitControlData;
const
  CEventDispIDs: array [0..7] of DWORD = (
    $00000001, $00000002, $0000060E, $0000060F, $00000610, $00000611,
    $00000612, $00000613);
  CLicenseKey: array[0..23] of Word = ( $0020, $0071, $0068, $006A, $0020, $005A, $0074, $0075, $0051, $0068, $0061
    , $003B, $006A, $0064, $0066, $006E, $005B, $0069, $0061, $0065, $0074
    , $0072, $0020, $0000);
  CTFontIDs: array [0..0] of DWORD = (
    $FFFFFE00);
  CTPictureIDs: array [0..0] of DWORD = (
    $00000006);
  CControlData: TControlData = (
    ClassID: '{3B7C8860-D78F-101B-B9B5-04021C009402}';
    EventIID: '{3B7C8862-D78F-101B-B9B5-04021C009402}';
    EventCount: 8;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: @CLicenseKey;
    Flags: $0000002D;
    Version: 300;
    FontCount: 1;
    FontIDs: @CTFontIDs;
    PictureCount: 1;
    PictureIDs: @CTPictureIDs);
begin
  ControlData := @CControlData;
end;

procedure TRichTextBox.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IRichText;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TRichTextBox.GetControlInterface: IRichText;
begin
  CreateControl;
  Result := FIntf;
end;

function TRichTextBox.Get_OLEObjects: IOLEObjects;
begin
  Result := ControlInterface.Get_OLEObjects;
end;

function TRichTextBox.Get_SelTabs(sElement: Smallint): OleVariant;
begin
  Result := ControlInterface.Get_SelTabs(sElement);
end;

procedure TRichTextBox.Set_SelTabs(sElement: Smallint; pvarSelTab: OleVariant);
begin
  ControlInterface.Set_SelTabs(sElement, pvarSelTab);
end;

procedure TRichTextBox.AboutBox;
begin
  ControlInterface.AboutBox;
end;

function TRichTextBox.Find(const bstrString: WideString; vStart: OleVariant; vEnd: OleVariant; 
                           vOptions: OleVariant; out plFind: Integer): Integer;
begin
  Result := ControlInterface.Find(bstrString, vStart, vEnd, vOptions);
end;

function TRichTextBox.GetLineFromChar(lChar: Integer; out plLine: Integer): Integer;
begin
  Result := ControlInterface.GetLineFromChar(lChar);
end;

procedure TRichTextBox.LoadFile(const bstrFilename: WideString; vFileType: OleVariant);
begin
  ControlInterface.LoadFile(bstrFilename, vFileType);
end;

procedure TRichTextBox.Refresh;
begin
  ControlInterface.Refresh;
end;

procedure TRichTextBox.SaveFile(const bstrFilename: WideString; vFlags: OleVariant);
begin
  ControlInterface.SaveFile(bstrFilename, vFlags);
end;

procedure TRichTextBox.SelPrint(lHDC: Integer);
begin
  ControlInterface.SelPrint(lHDC);
end;

procedure TRichTextBox.Span(const bstrCharacterSet: WideString; vForward: OleVariant; 
                            vNegate: OleVariant);
begin
  ControlInterface.Span(bstrCharacterSet, vForward, vNegate);
end;

procedure TRichTextBox.UpTo(const bstrCharacterSet: WideString; vForward: OleVariant; 
                            vNegate: OleVariant);
begin
  ControlInterface.UpTo(bstrCharacterSet, vForward, vNegate);
end;

procedure TRichTextBox.OLEDrag;
begin
  ControlInterface.OLEDrag;
end;

class function CoOLEObjects.Create: IOLEObjects;
begin
  Result := CreateComObject(CLASS_OLEObjects) as IOLEObjects;
end;

class function CoOLEObjects.CreateRemote(const MachineName: string): IOLEObjects;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_OLEObjects) as IOLEObjects;
end;

class function CoOLEObject.Create: IOLEObject;
begin
  Result := CreateComObject(CLASS_OLEObject) as IOLEObject;
end;

class function CoOLEObject.CreateRemote(const MachineName: string): IOLEObject;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_OLEObject) as IOLEObject;
end;

procedure Register;
begin
  RegisterComponents('ActiveX',[TRichTextBox]);
end;

end.
