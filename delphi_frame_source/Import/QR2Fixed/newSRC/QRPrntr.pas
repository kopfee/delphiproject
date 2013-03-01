{ :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: QuickReport 2.0 for Delphi 1.0/2.0/3.0                  ::
  ::                                                         ::
  :: QRPRNTR - QRPrinter and other low level classes         ::
  ::                                                         ::
  :: Copyright (c) 1997 QuSoft AS                            ::
  :: All Rights Reserved                                     ::
  ::                                                         ::
  :: web: http://www.qusoft.no    mail: support@qusoft.no    ::
  ::                              fax: +47 22 41 74 91       ::
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: }

{$define proversion}
(*{$define eval}*)

unit qrprntr;

{$R-}
{$T-} { We don't need (nor want) this type checking! }
{$B-} { QuickReport source assumes boolean expression short-circuit  }

interface

uses
{$ifdef win32}
  Windows, winspool, Sysutils, Messages, Classes, Controls, StdCtrls, ExtCtrls,
  ComCtrls, Buttons, Printers, Graphics, Forms, db, qr2const, dialogs;
{$else}
  Wintypes, WinProcs, Sysutils, Messages, Classes, Controls, StdCtrls, ExtCtrls,
  Buttons, Printers, Graphics, Forms, db, qr2const, dialogs;
{$endif}

type
  { All the known paper sizes }
  TQRPaperSize = (Default,
                  Letter,
                  LetterSmall,
                  Tabloid,
                  Ledger,
                  Legal,
                  Statement,
                  Executive,
                  A3,
                  A4,
                  A4Small,
                  A5,
                  B4,
                  B5,
                  Folio,
                  Quarto,
                  qr10X14,
                  qr11X17,
                  Note,
                  Env9,
                  Env10,
                  Env11,
                  Env12,
                  Env14,
                  CSheet,
                  DSheet,
                  ESheet,
                  Custom);

  TQRBin = (First,
            Upper,
            Lower,
            Middle,
            Manual,
            Envelope,
            EnvManual,
            Auto,
            Tractor,
            SmallFormat,
            LargeFormat,
            LargeCapacity,
            Cassette,
            Last);

const
   cQRName = 'QuickReport 2.0g'; { This string should not be resourced }
   cQRVersion = 207;         
   cQRPDefaultExt = 'QRP';      { Default extesion for QRP files }
   cQRDefaultExt = 'QR';        { Default extesion for QR files }
   { Actual paper sizes for all the known paper types }
   cQRPaperSizeMetrics : array[Letter..ESheet, 0..1] of extended =
      ((215.9, 279.4), { Letter }
       (215.9, 279.4), { Letter small }
       (279.4, 431.8), { Tabloid }
       (431.8, 279.4), { Ledger }
       (215.9, 355.6), { Legal }
       (139.7, 215.9), { Statement }
       (190.5, 254.0), { Executive }
       (297.0, 420.0), { A3 }
       (210.0, 297.0), { A4 }
       (210.0, 297.0), { A4 small }
       (148.0, 210.0), { A5 }
       (250.0, 354.0), { B4 }
       (182.0, 257.0), { B5 }
       (215.9, 330.2), { Folio }
       (215.0, 275.0), { Quarto }
       (254.0, 355.6), { 10X14 }
       (279.4, 431.8), { 11X17 }
       (215.9, 279.0), { Note }
       (98.43, 225.4), { Envelope #9 }
       (104.8, 241.3), { Envelope #10 }
       (114.3, 263.5), { Envelope #11 }
       (101.6, 279.4), { Envelope #12 - might be wrong !! }
       (127.0, 292.1), { Envelope #14 }
       (100.0, 100.0),
       (100.0, 100.0),
       (100.0, 100.0));

   { Table for translating TQRPaperSize to values which can be used with the
     printer driver }
   cQRPaperTranslate : array[Default..Custom] of integer =
       (0,
       dmpaper_Letter,
       dmpaper_LetterSmall,
       dmpaper_Tabloid,
       dmpaper_Ledger,
       dmpaper_Legal,
       dmpaper_Statement,
       dmpaper_Executive,
       dmpaper_A3,
       dmpaper_A4,
       dmpaper_A4Small,
       dmpaper_A5,
       dmpaper_B4,
       dmpaper_B5,
       dmpaper_Folio,
       dmpaper_Quarto,
       dmpaper_10X14,
       dmpaper_11X17,
       dmpaper_Note,
       dmpaper_Env_9,
       dmpaper_Env_10,
       dmpaper_Env_11,
       dmpaper_Env_12,
       dmpaper_Env_14,
       dmpaper_CSheet,
       dmpaper_DSheet,
       dmpaper_ESheet,
       $100);

   cQRBinTranslate : array[First..Last] of integer =
     (1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 14, 14);

type
  TQRBandType = (rbTitle,
                 rbPageHeader,
                 rbDetail,
                 rbPageFooter,
                 rbSummary,
                 rbGroupHeader,
                 rbGroupFooter,
                 rbSubDetail,
                 rbColumnHeader,
                 rbOverlay,
                 rbChild);

const
   { TQREvaluator constants }

   { QRDesigner/QREditor constants }
   cHandleSize   = 2;
   hpFirst       = 1;
   hpLast        = 8;
   hpNone        = 0;
   hpTopLeft     = 1;
   hpTop         = 2;
   hpTopRight    = 3;
   hpLeft        = 4;
   hpRight       = 5;
   hpBottomLeft  = 6;
   hpBottom      = 7;
   hpBottomRight = 8;
   cQRCornerSize = 4;

   { Misc constants }
   cQRPageShadowWidth = 2;
   cQRPageFrameWidth = 1;
   cQRPageShadowColor = clBlack;

{$ifdef win32}
  cQRButtonSize = 24;
  cQRToolbarHeight = 30;
{$else}
  cQRButtonSize = 24;
  cQRToolbarHeight = 30;
{$endif}
  cQRToolbarMargin = 4;
  cQRToolbarCBWidth = 80;
  cQRToolbarCBMargin = 8;

  { TQRCompress related declarations }

const
  { TQRCompress constants }
  MaxChar = 256;
  EofChar = 256;
  PredMax = 255;
  TwiceMax = 512;
  Root = 0;
  BitMask : array[0..7] of Byte = (1, 2, 4, 8, 16, 32, 64, 128);

  CM_QRPROGRESSUPDATE = WM_USER + 0;
  CM_QRPAGEAVAILABLE = WM_USER + 1;
type
  TQRPrinter = class;
  TQREvElementFunction = class;
  TQREvElement = class;

  EQRError = class(Exception);

  CodeType = 0..MaxChar;
  UpIndex = 0..PredMax;
  DownIndex = 0..TwiceMax;
  TreeDownArray = array[UpIndex] of DownIndex;
  TreeUpArray = array[DownIndex] of UpIndex;

  TCM_QRPRogressUpdate = record
    Msg : Cardinal;
    Position : word;
    QRPrinter : TQRPrinter;
  end;

  TCM_QRPageAvailable = record
    Msg : Cardinal;
    PageCount : word;
    QRPrinter : TQRPrinter;
  end;

  { TQRExportFilterLibrary }
  TQRExportFilterClass = class of TQRExportFilter;

  TQRExportFilterLibraryEntry = class
  private
    FExportFilterClass : TQRExportFilterClass;
    FName : string;
    FExtension : string;
  public
    property ExportFilterClass : TQRExportFilterClass read FExportFilterClass write FExportFilterClass;
    property FilterName : string read FName write FName;
    property Extension : string read FExtension write FExtension;
  end;

  TQRExportFilterLibrary = class
  private
    FFilterList : TList;
  protected
    function GetSaveDialogFilter : string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddFilter(AFilter : TQRExportFilterClass);
    property Filters : TList read FFilterList;
    property SaveDialogFilterString : string read GetSaveDialogFilter;
  end;

  { TQRLibraryEntry }
  TQRLibraryItemClass = class of TObject;

  TQRLibraryEntry = class
  private
    FDescription : string;
    FData : string;
    FItem : TQRLibraryItemClass;
    FName : string;
    FVendor : string;
  public
    property Data : string read FData write FData;
    property Description : string read FDescription write FDescription;
    property Name : string read FName write FName;
    property Vendor : string read FVendor write FVendor;
    property Item : TQRLibraryItemClass read FItem write FItem;
  end;

  { TQRLibrary }
  TQRLibrary = class
  private
    Entries : TStrings;
  protected
    function GetEntry(Index : integer) : TQRLibraryEntry; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(aItem : TQRLibraryItemClass; AName, ADescription, AVendor, AData : string);
    property EntryList : TStrings read Entries write Entries;
    property Entry[Index : integer] : TQRLibraryEntry read GetEntry;
  end;

  { TQRFunctionLibrary }
  TQRFunctionLibrary = class(TQRLibrary)
  private
  protected
  public
    function GetFunction(Name : string) : TQREvElement;
  end;

  { TQRStream }
  TQRStream = class(TStream)
  private
{$ifdef win32}
    FLock: TRTLCriticalSection;
{$endif}
    MemoryStream : TMemoryStream;
    FFilename : string;
    FileStream : TFileStream;
    FInMemory : boolean;
    FMemoryLimit : longint;
  public
    constructor Create(MemoryLimit : Longint);
    constructor CreateFromFile(Filename : string);
    destructor Destroy; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    procedure LockStream;
    procedure UnlockStream;
    procedure SaveToStream(AStream : TStream);
    property InMemory : boolean read FInMemory;
  end;

  { TQRCompress }
  TQRCompress = class
  private
    BitPos : Byte;
    CompressFlag : Boolean;
    InByte : CodeType;
    Left, Right : TreeDownArray;
    OutByte : CodeType;
    Stream : TStream;
    Up : TreeUpArray;
    function GetByte : Byte;
    procedure InitializeSplay;
    procedure Splay(Plain : CodeType);
  public
    constructor Create(aStream : TStream; CompressData : boolean);
    destructor Destroy; override;
    procedure Expand(var Expanded : byte);
    procedure Compress(Plain : CodeType);
  end;

  { TQRPageList }
  TQRPageList = class
  private
{$ifdef win32}
    FLock: TRTLCriticalSection;
{$endif}
    aCompressor : TQRCompress;
    FCompression : boolean;
    FPageCount : integer;
    FStream : TQRStream;
    procedure SeekToFirst;
    procedure SeekToLast;
    procedure SeekToPage(PageNumber : integer);
    procedure ReadFileHeader;
    procedure WriteFileHeader;
  public
    constructor Create;
    destructor Destroy; override;
    function GetPage(PageNumber : integer) : TMetafile;
    procedure AddPage(aMetafile : TMetafile);
    procedure Clear;
    procedure Finish;
    procedure LoadFromFile(Filename : string);
    procedure LockList;
    procedure SaveToFile(Filename : string);
    procedure UnlockList;
    property Compression : boolean read FCompression write FCompression;
    property PageCount : integer read FPageCount;
    property Stream : TQRStream read FStream write FStream;
  end;

  { TQRToolbar  }
  TQRToolbar = class(TCustomPanel)
  private
    FComponent : TComponent;
    FCurrentX : integer;
    FCBClickOK : boolean;
  protected
    function AddButton(aCaption, GlyphName, aHint : string; aGroup : integer; ClickEvent : TNotifyEvent) : TSpeedButton;
    function AddCheckBox(aCaption, aHint : string; ClickEvent : TNotifyEvent) : TCheckBox;
    procedure AddSpace;
    procedure SetComponent(Value : TComponent); virtual;
    procedure EndSetComponent;
    property CBClickOK : boolean read FCBClickOK write FCBClickOK;
    property CurrentX : integer read FCurrentX write FCurrentX;
  public
    constructor Create(AOwner : TComponent); override;
    property Component : TComponent read FComponent write SetComponent;
  published
  end;

  { TQRGauge - Wraps to standard control in 32 bit, complete code
    for 16 bit }

{$ifdef win32}
  TQRGauge = class(TProgressBar)
  public
    constructor Create(AOwner : TComponent); override;
  end;
{$else}
  TQRGauge = class(TGraphicControl)
  private
    FCurValue: Longint;
    FBorderStyle: TBorderStyle;
    FForeColor: TColor;
    FBackColor: TColor;
    procedure PaintBackground(AnImage: TBitmap);
    procedure PaintAsBar(AnImage: TBitmap; PaintRect: TRect);
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetProgress(Value: Longint);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Color;
    property Enabled;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property ParentColor;
    property Position: Longint read FCurValue write SetProgress;
    property Visible;
  end;
{$endif}

  { TQREvaluator related declarations }
  TQREvOperator = (opLess, opLessOrEqual, opGreater, opGreaterOrEqual, opEqual,
                   opUnequal, opPlus, opMinus, opOr, opMul, opDiv, opAnd);

  TQREvResultType = (resInt, resDouble, resString, resBool, resError);

  TQREvResult = record
    case Kind : TQREvResultType of
      resInt    : (intResult : longint);
      resDouble : (dblResult : double);
      resString : (strResult : string[255]);
      resBool   : (booResult : boolean);
  end;

  TQREvResultClass = class
  public
    EvResult : TQREvResult;
  end;

  TQRFiFo = class
  private
    FAggreg : boolean;
    FiFo : TList;
    FNextItem : integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Put(Value : TObject);
    procedure Start;
    function Get : TObject;
    function GetAndFree : TObject;
    property Aggreg : boolean read FAggreg write FAggreg;
  end;

  TQREvElement = class
  private
    FIsAggreg : boolean;
  public
    constructor Create; virtual;
    function Value(FiFo : TQRFiFo) : TQREvResult; virtual;
    procedure Reset; virtual;
    property IsAggreg : boolean read FIsAggreg write FIsAggreg;
  end;

  TQREvElementFunction = class(TQREvElement)
  private
  protected
    ArgList : TList;
    function ArgumentOK(Value : TQREvElement) : boolean;
    function Argument(Index : integer) : TQREvResult;
    procedure FreeArguments;
    procedure GetArguments(FiFo : TQRFiFo);
    procedure Aggregate; virtual;
    function Calculate : TQREvResult; virtual;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Value(FiFo : TQRFiFo) : TQREvResult; override;
  end;

  TQREvElementFunctionClass = class of TQREvElementFunction;

  TQREvElementArgumentEnd = class(TQREvElement);

  TQREvElementDataField = class(TQREvElement)
  private
    FDataSet : TDataSet;
    FFieldNo : integer;
    FField : TField;
  public
    constructor CreateField(aField : TField); virtual;
    function Value(FiFo : TQRFiFo) : TQREvResult; override;
  end;

  TQREvElementError = class(TQREvElement)
  public
    function Value(FiFo : TQRFiFo) : TQREvResult; override;
  end;

{$ifndef win32}
  { TQRStringStack }

  TQRStringStack = class
  private
    aList : TStrings;
  public
    constructor Create;
    Destructor Destroy; override;
    procedure Push(Value : string);
    procedure Pop;
    function Peek(FromTop : integer) : string;
  end;
{$endif}

  { TQREvaluator class }

  TQREvaluator = class (TObject)
  private
    FDataSets : TList;
    FiFo : TQRFiFo;
    FPrepared : boolean;
{$ifndef win32}
    StringStack : TQRStringStack;
    function  EvalFunctionExpr : TQREvResult;
    function  EvalSimpleExpr : TQREvResult;
    function  EvalTerm : TQREvResult;
    function  EvalFactor : TQREvResult;
    function  EvalString : TQREvResult;
    function  EvalConstant : TQREvResult;
    function  GetAggregate : boolean;
    function  NegateResult(const Res : TQREvResult) : TQREvResult;
    function  Evaluate : TQREvResult;
    procedure FindDelimiter(var Pos : integer);
    procedure FindOp1(var Op : TQREvOperator; var Pos, Len : integer);
    procedure FindOp2(var Op : TQREvOperator; var Pos, Len : integer);
    procedure FindOp3(var Op : TQREvOperator; var Pos, Len : integer);
{$else}
    function  EvalFunctionExpr(const strFunc : string) : TQREvResult;
    function  EvalSimpleExpr(const strSimplExpr : string) : TQREvResult;
    function  EvalTerm(const strTermExpr : string) : TQREvResult;
    function  EvalFactor(strFactorExpr : string) : TQREvResult;
    function  EvalString(const strString : string) : TQREvResult;
    function  EvalConstant(const strConstant : string) : TQREvResult;
    function  GetAggregate : boolean;
    function  NegateResult(const Res : TQREvResult) : TQREvResult;
    function  Evaluate(const strExpr : string) : TQREvResult;
    procedure FindDelimiter(strArg : string; var Pos : integer);
    procedure FindOp1(const strExpr : string; var Op : TQREvOperator; var Pos, Len : integer);
    procedure FindOp2(const strExpr : string; var Op : TQREvOperator; var Pos, Len : integer);
    procedure FindOp3(const strExpr : string; var Op : TQREvOperator; var Pos, Len : integer);
{$endif}
    procedure SetAggregate(Value : boolean);
    procedure TrimString(var strString : string);
  protected
{$ifdef win32}
    function EvalFunction(strFunc : string; const strArg : string) : TQREvResult; virtual;
    function EvalVariable(strVariable : string) : TQREvResult; virtual;
{$else}
    function EvalFunction : TQREvResult; virtual;
    function EvalVariable : TQREvResult; virtual;
{$endif}
    function GetIsAggreg : boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function Calculate(const StrExpr : string) : TQREvResult;
    function Value : TQREvResult;
    procedure Prepare(const StrExpr : string);
    procedure Reset;
    procedure UnPrepare;
    property IsAggreg : boolean read GetIsAggreg;
    property Aggregate : boolean read GetAggregate write SetAggregate;
    property DataSets : TList read FDataSets write FDataSets;
    property Prepared : boolean read FPrepared write FPrepared;
  end;

  { TQRPreviewImage }
  TQRZoomState = (qrZoomToFit,qrZoomToWidth,qrZoomOther);

  TQRPreviewImage = class(TGraphicControl)
  private
    FQRPrinter : TQRPrinter;
    FPageNumber : integer;
    aMetaFile : TMetafile;
    FImageOK : boolean;
    procedure PaintPage;
    procedure SetPageNumber(Value : integer);
  public
    Zoom : Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    property ImageOK : boolean read FImageOK write FImageOK;
    property PageNumber : integer read FPageNumber write SetPageNumber;
    property QRPrinter : TQRPrinter read FQRPrinter write FQRPrinter;
  end;

  { TQRPreview }
  TQRProgressUpdateEvent = procedure (Sender : TObject; Progress : integer) of object;

  TQRPageAvailableEvent = procedure (Sender : TObject; PageNum : integer) of object;

  TQRPreview = Class(TScrollBox)
  private
    FOnPageAvailableEvent : TQRPageAvailableEvent;
    FOnProgressUpdateEvent : TQRProgressUpdateEvent;
    FPreviewImage : TQRPreviewImage;
    FPageNumber : integer;
    FQRPrinter : TQRPrinter;
    FZoom : integer;
    FZoomState : TQRZoomState;
    procedure SetPageNumber(Value : integer);
    procedure SetZoom(value : integer);
    procedure Fixvalues(Sender : TObject);
    procedure SetQRPrinter(Value : TQRPrinter);
  protected
    procedure CMPageAvailable(var Message : TCM_QRPageAvailable); Message CM_QRPAGEAVAILABLE;
    procedure CMProgressUpdate(var Message : TCM_QRProgressUpdate); Message CM_QRPROGRESSUPDATE;
  public
    constructor Create(aOwner : TComponent); override;
    destructor Destroy; override;
    procedure UpdateImage;
    procedure UpdateZoom;
    procedure ZoomToWidth;
    procedure ZoomToFit;
    property PreviewImage : TQRPreviewImage read FPreviewImage;
    property QRPrinter : TQRPrinter read FQRPrinter write SetQRPrinter;
    property ZoomState : TQRZoomState read FZoomState write FZoomState;
  published
    property OnPageAvailable : TQRPageAvailableEvent read FOnPageAvailableEvent
                                                     write FOnPageAvailableEvent;
    property OnProgressUpdate : TQRProgressUpdateEvent read FOnProgressUpdateEvent write FOnProgressUpdateEvent;
    property PageNumber : integer read FPageNumber write setPageNumber;
    property Zoom : integer read FZoom write SetZoom;
  end;

  { TQRExportFilter }
  TQRExportFilter = class
  private
    FFilename : string;
    FOwner : TComponent;
  protected
    function GetDescription : string; virtual;
    function GetExtension : string; virtual;
    function GetFilterName : string; virtual;
    function GetVendorName : string; virtual;
  public
    constructor Create(Filename : string);
    procedure Start(PaperWidth, PaperHeight : integer; Font : TFont); virtual;
    procedure EndPage; virtual;
    procedure Finish; virtual;
    procedure NewPage; virtual;
    procedure TextOut(X,Y : extended; Font : TFont; BGColor : TColor; Alignment : TAlignment; Text : string); virtual;
    property Description : string read GetDescription;
    property FileExtension : string read GetExtension;
    property Filename : string read FFilename;
    property Name : string read GetFilterName;
    property Owner : TComponent read FOwner write FOwner;
    property Vendor : string read GetVendorName;
  end;

  { TPrinterSettings }
  TPaperSizesSupported = array[Letter..Custom] of boolean;

  TPrinterSettings = class
  private
    { Device stuff }
    FDevice : PChar;
    FDriver : PChar;
    FPort : PChar;
    DeviceMode : THandle;
{$ifdef win32}
    DevMode : PDeviceMode;
{$else}
    DevMode : PDevMode;
    ExtDeviceMode: TExtDeviceMode;
{$endif}
    { Storage variables }
    FCopies : integer;
    FDuplex : boolean;
    FMaxExtentX : integer;
    FMaxExtentY : integer;
    FMinExtentX : integer;
    FMinExtentY : integer;
    FOrientation : TPrinterOrientation;
    FOutputBin : TQRBin;
    FPaperSize : TQRPaperSize;
    FPaperSizes : TPaperSizesSupported;
    FPaperWidth : integer;
    FPaperLength : integer;
    FPixelsPerX : integer;
    FPixelsPerY : integer;
    FTopOffset : integer;
    FLeftOffset : integer;
    FPrinter : TPrinter;
    FTitle : string;
    function GetCopies : integer;
    function GetDriver : string;
    function GetDuplex : boolean;
    function GetMaxExtentX : integer;
    function GetMaxExtentY : integer;
    function GetMinExtentX : integer;
    function GetMinExtentY : integer;
    function GetOrientation : TPrinterOrientation;
    function GetOutputBin : TQRBin;
    function GetPaperSize : TQRPaperSize;
    function GetPaperSizeSupported(PaperSize : TQRPaperSize) : boolean;
    function GetPaperWidth : integer;
    function GetPaperLength : integer;
    function GetPixelsPerX : integer;
    function GetPixelsPerY : integer;
    function GetPort : string;
    function GetPrinter : TPrinter;
    function GetTitle : string;
    function GetTopOffset : integer;
    function GetLeftOffset : integer;
    function Supported(Setting : integer) : boolean;
    procedure SetField(aField : integer);
    procedure GetPrinterSettings;
    procedure SetCopies(Value : integer);
    procedure SetDuplex(Value : boolean);
    procedure SetOrientation(Value : TPrinterOrientation);
    procedure SetOutputBin(Value : TQRBin);
    procedure SetPaperSize(Value : TQRPaperSize);
    procedure SetPaperLength(Value : integer);
    procedure SetPaperWidth(Value : integer);
    procedure SetPrinter(Value : TPrinter);
    procedure SetTitle(Value : string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure ApplySettings;
    { read only properties }
    property Device : string read GetDriver;
    property Driver : string read GetDriver;
    property LeftOffset : integer read GetLeftOffset;
    property MaxExtentX : integer read GetMaxExtentX;
    property MaxExtentY : integer read GetMaxExtentY;
    property MinExtentX : integer read GetMinExtentX;
    property MinExtentY : integer read GetMinExtentY;
    property PaperSizeSupported[PaperSize : TQRPaperSize] : boolean read GetPaperSizeSupported;
    property PixelsPerX : integer read GetPixelsPerX;
    property PixelsPerY : integer read GetPixelsPerY;
    property Port : string read GetPort;
    property TopOffset : integer read GetTopOffset;
    { Read/write properties }
    property Copies : integer read GetCopies write SetCopies;
    property Duplex : boolean read GetDuplex write SetDuplex;
    property Orientation : TPrinterOrientation read GetOrientation write SetOrientation;
    property OutputBin : TQRBin read GetOutputBin write SetOutputBin;
    property PaperLength : integer read GetPaperLength write SetPaperLength;
    property PaperSize : TQRPaperSize read GetPaperSize write SetPaperSize;
    property PaperWidth : integer read GetPaperWidth write SetPaperWidth;
    property Printer : TPrinter read GetPrinter write SetPrinter;
    property Title : string read GetTitle write SetTitle;
  end;

  { TQRPrinterSettings }
  TQRPrinterSettings = class(TPersistent)
  private
    FCopies : integer;
    FDuplex : boolean;
    FOrientation : TPrinterOrientation;
    FOutputBin : TQRBin;
    FPaperSize : TQRPaperSize;
    FPrinterIndex : integer;
    FTitle : string;
    FFirstPage : integer;
    FLastPage : integer;
  public
    constructor Create;
    procedure ApplySettings(APrinter : TQRPrinter);
    property Copies : integer read FCopies write FCopies;
    property Duplex : boolean read FDuplex write FDuplex;
    property FirstPage : integer read FFirstPage write FFirstPage;
    property LastPage : integer read FLastPage write FLastPage;
    property Orientation : TPrinterOrientation read FOrientation write FOrientation;
    property OutputBin : TQRBin read FOutputBin write FOutputBin;
    property PaperSize : TQRPaperSize read FPaperSize write FPaperSize;
    property PrinterIndex : integer read FPrinterIndex write FPrinterIndex;
    property Title : string read FTitle write FTitle;
  end;

  { TQRPrinter related declarations }

  TQRPrinterDestination = (qrdMetafile, qrdPrinter);

  TQRPrinterStatus = (mpReady, mpBusy, mpFinished);

  TQRGenerateToPrinterEvent = procedure of object;
  TQRPrintSetupEvent = procedure of object;
  TQRExportToFilterEvent = procedure (aFilter : TQRExportFilter) of object;
  TQRPreviewEvent = procedure of object;
  TQRAfterPrintEvent = procedure (Sender : TObject) of object;
  TQRAfterPreviewEvent = procedure (Sender : TObject) of object;

  { TQRPrinter }
  TQRPrinter = class(TPersistent)
  private
    aPrinter : TPrinter;
    aPrinterSettings : TPrinterSettings;
    aStream : TQRStream;
    FAfterPrintEvent : TQRAfterPrintEvent;
    FAfterPreviewEvent : TQRAfterPreviewEvent;
    FAvailablePages : integer;
    FCancelled : boolean;
    FCanvas : TCanvas;
    FDestination : TQRPrinterDestination;
    FFirstPage : integer;
    FLastpage : integer;
    FLeftWaste : integer;
    FMessageReceiver : TWinControl;
    FMetafile : TMetafile;
    FOnGenerateToPrinterEvent : TQRGenerateToPrinterEvent;
    FOnExportToFilterEvent : TQRExportToFilterEvent;
    FOnPreviewEvent : TNotifyEvent;
    FOnPrintSetupEvent : TQRPrintSetupEvent;
    FPage : TMetafile;
    FPageCount : integer;
    FPageNumber : integer;
    FPrinterOK : boolean;
    FProgress : integer;
    FTitle : string;
    FTopWaste : integer;
    FShowingPreview : boolean;
    FStatus : TQRPrinterStatus;
    FXFactor : extended;
    FYFactor : extended;
    PageList : TQRPageList;
    function CurrentPageOK : boolean;
    function GetLeftWaste : integer;
    function GetBin : TQRBin;
    function GetCanvas : TCanvas;
    function GetCompression : boolean;
    function GetCopies : integer;
    function GetDuplex : boolean;
    function GetOrientation : TPrinterOrientation;
    function GetPaperLength : integer;
    function GetPaperSize : TQRPaperSize;
    function GetPaperWidth : integer;
    function GetPrinterIndex : integer;
    function GetPrinters : TStrings;
    function GetTopWaste : integer;
    procedure CreateMetafileCanvas;
    procedure CreatePrinterCanvas;
    procedure EndMetafileCanvas;
    procedure EndPrinterCanvas;
    procedure SetAvailablePages(Value : integer);
    procedure SetBin(Value : TQRBin);
    procedure SetCompression(Value : boolean);
    procedure SetCopies(Value : integer);
    procedure SetDestination(Value : TQRPrinterDestination);
    procedure SetDuplex(Value : boolean);
    procedure SetOrientation(Value : TPrinterOrientation);
    procedure SetPaperLength(Value : integer);
    procedure SetPageNumber(Value : integer);
    procedure SetPaperSize(Value : TQRPaperSize);
    procedure SetPaperWidth(Value : integer);
    procedure SetPrinterIndex(Value : integer);
    procedure SetProgress(Value : integer);
    procedure SetShowingPreview(Value : boolean);
  public
    constructor Create;
    destructor Destroy; override;
    function GetPage(Value : integer) : TMetafile;
    function XPos(Value : extended) : integer;
    function XSize(Value : extended) : integer;
    function YPos(Value : extended) : integer;
    function YSize(Value : extended) : integer;
    function PaperLengthValue : integer;
    function PaperWidthValue : integer;
    procedure AbortDoc;
    procedure BeginDoc;
    procedure Cancel;
    procedure Cleanup;
    procedure EndDoc;
    procedure ExportToFilter(aFilter : TQRExportFilter);
    procedure Load(Filename : string);
    procedure NewPage;
    procedure Preview;
    procedure Print;
    procedure PrintSetup;
    procedure Save(Filename : string);
    property AfterPreview : TQRAfterPreviewEvent read FAfterPreviewEvent write FAfterPreviewEvent;
    property AfterPrint : TQRAfterPrintEvent read FAfterPrintEvent write FAfterPrintEvent;
    property AvailablePages : integer read FAvailablePages write SetAvailablePages;
    property OutputBin : TQRBin read GetBin write SetBin;
    property Cancelled : boolean read FCancelled write FCancelled;
    property Canvas : TCanvas read GetCanvas;
    property Compression : boolean read GetCompression write SetCompression;
    property Copies : integer read GetCopies write SetCopies;
    property Destination : TQRPrinterDestination read FDestination write SetDestination;
    property Duplex : boolean read GetDuplex write SetDuplex;
    property FirstPage : integer read FFirstPage write FFirstPage;
    property LastPage : integer read FLastPage write FLastPage;
    property LeftWaste : integer read GetLeftWaste;
    property MessageReceiver : TWinControl read FMessageReceiver write FMessageReceiver;
    property Orientation : TPrinterOrientation read GetOrientation write SetOrientation;
    property OnExportToFilter : TQRExportToFilterEvent read FOnExportToFilterEvent
                                                       write FOnExportToFilterEvent;
    property OnGenerateToPrinter : TQRGenerateToPrinterEvent read FOnGenerateToPrinterEvent
                                                             write FOnGenerateToPrinterEvent;
    property OnPreview : TNotifyEvent read FOnPreviewEvent write FOnPreviewEvent;
    property OnPrintSetup : TQRPrintSetupEvent read FOnPrintSetupEvent write FOnPrintSetupEvent;
    property PaperLength : Integer read GetPaperLength write SetPaperLength;
    property Page : TMetafile read FPage;
    property PageCount : integer read FPageCount write FPageCount;
    property PageNumber : Integer read FPageNumber write SetPageNumber;
    property PaperWidth : Integer read GetPaperWidth write SetPaperWidth;
    property PaperSize : TQRPaperSize read GetPaperSize write SetPaperSize;
    property PrinterIndex : integer read GetPrinterIndex write SetPrinterIndex;
    property PrinterOK : boolean read FPrinterOK;
    property Printers : TStrings read GetPrinters;
    property Progress : integer read FProgress write SetProgress;
    property ShowingPreview : boolean read FShowingPreview write SetShowingPreview;
    property Status : TQRPrinterStatus read FStatus;
    property Title : string read FTitle write FTitle;
    property TopWaste : integer read GetTopWaste;
    property XFactor : extended read FXFactor write FXFactor;
    property YFactor : extended read FYFactor write FYFactor;
  end;

{$ifndef ver100}
  function AnsiPos(Substr: string; S: string): integer;
{$endif}
  function GetFonts : TStrings;

  function TempFilename : string;
  function QRPaperName(Size : TQRPaperSize) : string;
  function QRBandTypeName(BandType : TQRBandType) : string;
  function QRBandComponentName(BandType : TQRBandType) : string;

  procedure RegisterQRFunction(FunctionClass : TQRLibraryItemClass; Name, Description, Vendor, Arguments : string);

{$ifdef ver90}
  function DeviceCapabilities(pDevice, pPort: PChar; fwCapability: Word;
    pOutput: PChar; DevMode: PDeviceMode): Integer; stdcall;
{$endif}

function QRPrinter : TQRPrinter;

var
  QRExportFilterLibrary : TQRExportFilterLibrary;
  QRFunctionLibrary : TQRFunctionLibrary;

implementation

uses
  QRPrev;

var
  ArgSeparator : Char;
  FQRPrinter : TQRPrinter;

const
  cQRPFormatVersion = 3;

type
  TQRFileHeader = record
    FormatVersion : word;                   { File format version }
    QRVersion : word;                       { QR version }
    PageSize : TQRPaperSize;
    PageCount : integer;
    CreateDateTime : TDateTime;
    Portrait : boolean;                     { field added in header version 2 }
    Compression : byte;                     { 0 - no compression, 1 - splay }
    EmptySpace : array[0..100] of byte;
  end;

{$ifdef eval}
function DelphiRunning : boolean;
var
  H1, H2, H3, H4 : Hwnd;
const
  A1 : array[0..12] of char = 'TApplication'#0;
  A2 : array[0..15] of char = 'TAlignPalette'#0;
  A3 : array[0..18] of char = 'TPropertyInspector'#0;
  A4 : array[0..11] of char = 'TAppBuilder'#0;
  T1 : array[0..6] of char = 'Delphi'#0;
begin
  H2 := FindWindow(A2, nil);
  H3 := FindWindow(A3, nil);
  H4 := FindWindow(A4, nil);
  Result := (H2 <> 0) and
            (H3 <> 0) and (H4 <> 0);
end;
{$endif}

{$ifndef ver100}

function AnsiPos(Substr: string; S: string): integer;
begin
  result := Pos(Substr,S);
end;

{$endif}

{ Work around a Delphi 2.0 *only* bug }
{$ifdef ver90}
const
  winspool = 'winspool.drv';

function DeviceCapabilities; external winspool name 'DeviceCapabilitiesA';
{$endif}

function QRPaperName(Size : TQRPaperSize) : string;
begin
  Result := LoadStr(SqrPaperSize1 + ord(Size) - 1);
end;

function QRBandTypeName(BandType : TQRBandType) : string;
begin
  Result := LoadStr(SqrTitle + ord(BandType));
end;

function QRBandComponentName(BandType : TQRBandType) : string;
begin
  Result := LoadStr(SqrTitleBandName + ord(BandType));
end;

function TempFilename : string;
var
  AName,
  ADir : array[0..80] of char;
{$ifndef win32}
  ADrive : char;
{$endif}
begin
{$ifdef win32}
  GetTempPath(30, adir);
  GetTempFilename(aDir, PChar('QRP'), 0, aName);
{$else}
  ADrive := GetTempDrive(ADrive);
  GetTempFilename(ADrive, PChar('QRP'), 0, aName);
{$endif}
  result := StrPas(aName);
end;

{ TQRLibrary }

constructor TQRLibrary.Create;
begin
  inherited Create;
  Entries := TStringList.Create;
end;

destructor TQRLibrary.Destroy;
begin
  Entries.Free;
  inherited Destroy;
end;

procedure TQRLibrary.Add(aItem : TQRLibraryItemClass; AName, ADescription, AVendor, AData : string);
var
  aLibraryEntry : TQRLibraryEntry;
begin
  aLibraryEntry := TQRLibraryEntry.Create;
  with aLibraryEntry do
  begin
    Name := AName;
    Description := ADescription;
    Vendor := AVendor;
    Data := AData;
    Item := aItem;
  end;
  Entries.AddObject(aName,aLibraryEntry);
end;

function TQRLibrary.GetEntry(Index : integer) : TQRLibraryEntry;
begin
  if Index <= Entries.Count then
    result := TQRLibraryEntry(Entries.Objects[Index])
  else
    result := nil;
end;

{ TQRFunctionLibrary }

function TQRFunctionLibrary.GetFunction(Name : string) : TQREvElement;
var
  I : integer;
  AObject : TQREvElementFunctionClass;
  aLibraryEntry : TQRLibraryEntry;
begin
  I := Entries.IndexOf(Name);
  if I>=0 then
  begin
    aLibraryEntry := TQRLibraryEntry(Entry[I]);
    aObject := TQREvElementFunctionClass(aLibraryEntry.Item);
    result := aObject.Create;
  end else
    result := TQREvElementError.Create;
end;

{ TQRStream }

constructor TQRStream.Create(MemoryLimit : longint);
begin
  inherited Create;
  FInMemory := true;
  MemoryStream := TMemoryStream.Create;
  FMemoryLimit := MemoryLimit;
{$ifdef win32}
  InitializeCriticalSection(FLock);
{$endif}
end;

constructor TQRStream.CreateFromFile(Filename : string);
begin
  inherited Create;
  FInMemory := false;
  FileStream := TFileStream.Create(Filename, fmOpenRead);
  FMemoryLimit := 0;
{$ifdef win32}
  InitializeCriticalSection(FLock);
{$endif}
end;

destructor TQRStream.Destroy;
begin
  LockStream;
  try
    if InMemory then
      MemoryStream.Free
    else
    begin
      FileStream.Free;
      DeleteFile(FFilename);
    end;
  finally
    UnlockStream;
{$ifdef win32}
    DeleteCriticalSection(FLock);
{$endif}
  end;
  inherited Destroy;
end;

procedure TQRStream.LockStream;
begin
{$ifdef win32}
  EnterCriticalSection(FLock);
{$endif}
end;

procedure TQRStream.UnlockStream;
begin
{$ifdef win32}
  LeaveCriticalSection(FLock);
{$endif}
end;

function TQRStream.Write(const Buffer; Count: Longint): Longint;
begin
  LockStream;
  if InMemory then
  begin
    result := MemoryStream.Write(Buffer,Count);
    if MemoryStream.Size > FMemoryLimit then {...this could be optimized somewhat }
    begin
      FFilename := TempFilename;
      FileStream := TFileStream.Create(FFilename, fmCreate or fmOpenReadWrite);
      MemoryStream.SaveToStream(FileStream);
      MemoryStream.Free;
      FInMemory := false;
    end
  end else
    result := FileStream.Write(Buffer,Count);
  UnlockStream;
end;

function TQRStream.Read(var Buffer; Count: Longint): Longint;
begin
  LockStream;
  if InMemory then
    result := MemoryStream.Read(Buffer,Count)
  else
    result := FileStream.Read(Buffer,Count);
  UnlockStream;
end;

function TQRStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  LockStream;
  if InMemory then
    result := MemoryStream.Seek(Offset,Origin)
  else
    result := FileStream.Seek(Offset,Origin);
  UnlockStream;
end;

procedure TQRStream.SaveToStream(AStream : TStream);
var
  Buffer : array[0..10240] of byte;
  BytesRead : longint;
begin
  LockStream;
  Position := 0;
  repeat
    BytesRead := Read(Buffer,10240);
    AStream.Write(Buffer,BytesRead);
  until BytesRead=0;
  UnlockStream;
end;

{ TQRCompress - Based on article by Douglas W. Jonsen and SPLAY.PAS by Kim Kokkonen }

constructor TQRCompress.Create(aStream : TStream; CompressData : boolean);
begin
  Stream := aStream;
  InitializeSplay;
  if CompressData then
    BitPos := 0
  else
    BitPos := 7;
  OutByte := 0;
  CompressFlag := CompressData;
end;

destructor TQRCompress.Destroy;
begin
  if CompressFlag and (BitPos<>0) then
    Stream.Write(OutByte,1);
  inherited Destroy;
end;

procedure TQRCompress.InitializeSplay;
var
  I : DownIndex;
  J : UpIndex;
  K : DownIndex;
begin
  for I := 1 to TwiceMax do
    Up[I] := (I-1) shr 1;
  for J := 0 to PredMax do
  begin
    K := (J+1) shl 1;
    Left[J] := K-1;
    Right[J] := K;
  end;
end;

procedure TQRCompress.Splay(Plain : CodeType);
var
  A, B : DownIndex;
  C, D : UpIndex;
begin
  A := Plain+MaxChar;
  repeat
    C := Up[A];
    if C <> Root then
    begin
      D := Up[C];
      B := Left[D];
      if C = B then
      begin
        B := Right[D];
        Right[D] := A;
      end else
        Left[D] := A;
      if A = Left[C] then
        Left[C] := B
      else
        Right[C] := B;
      Up[A] := D;
      Up[B] := C;
      A := D;
    end else
      A := C;
  until A = Root;
end;

procedure TQRCompress.Compress(Plain : CodeType);
{ Compress a single byte }
var
  A : DownIndex;
  U : UpIndex;
  Sp : 0..MaxChar;
  Stack : array[UpIndex] of Boolean;
begin
  A := Plain+MaxChar;
  Sp := 0;
  repeat
    U := Up[A];
    Stack[Sp] := (Right[U] = A);
    inc(Sp);
    A := U;
  until A = Root;
  repeat
    dec(Sp);
    if Stack[Sp] then
      OutByte := OutByte or BitMask[BitPos];
    if BitPos = 7 then
    begin
      Stream.Write(OutByte, 1); { writebyte }
      BitPos := 0;
      OutByte := 0;
    end else
      inc(BitPos);
  until Sp = 0;
  Splay(Plain);
end;

function TQRCompress.GetByte : Byte;
begin
  Stream.Read(Result, 1);
end;

procedure TQRCompress.Expand(var Expanded : byte);
{ Expand a single byte }
var
  A : DownIndex;
begin
  A := Root;
  repeat
    if BitPos = 7 then
    begin
      InByte := GetByte;
      BitPos := 0;
    end else
      inc(BitPos);
    if InByte and BitMask[BitPos] = 0 then
      A := Left[A]
    else
      A := Right[A];
  until A > PredMax;
  dec(A, MaxChar);
  Splay(A);
  Expanded := A;
end;

{ TQRPageList }

constructor TQRPageList.Create;
begin
  inherited Create;
  FPageCount := 0;
  FCompression := false;
{$ifdef win32}
  InitializeCriticalSection(FLock);
{$endif}
end;

destructor TQRPageList.Destroy;
begin
{$ifdef win32}
  DeleteCriticalSection(FLock);
{$endif}
  inherited Destroy;
end;

procedure TQRPageList.Clear;
begin
  FPageCount := 0;
end;

procedure TQRPageList.LockList;
begin
{$ifdef win32}
  EnterCriticalSection(FLock);
{$endif}
end;

procedure TQRPageList.UnlockList;
begin
{$ifdef win32}
  LeaveCriticalSection(FLock);
{$endif}
end;

procedure TQRPageList.Finish;
begin
  WriteFileHeader;
end;

procedure TQRPageList.LoadFromFile;
begin
  if assigned(FStream) then
    Stream.Free;
  Stream := TQRStream.CreateFromFile(Filename);
  ReadFileHeader;
end;

procedure TQRPageList.SaveToFile(Filename : string);
var
  AStream : TFileStream;
begin
  AStream := TFileStream.Create(Filename,fmCreate or fmOpenReadWrite);
  Stream.SaveToStream(AStream);
  AStream.Free;
end;

procedure TQRPageList.SeekToFirst;
begin
  Stream.Position := SizeOf(TQRFileHeader);
end;

procedure TQRPageList.SeekToLast;
var
  PrevPosition : longint;
begin
  Stream.Seek(-SizeOf(PrevPosition), soFromEnd);
  Stream.Read(PrevPosition,SizeOf(PrevPosition));
  Stream.Position := PrevPosition;
end;

procedure TQRPageList.SeekToPage(PageNumber : integer);
var
  ThisPageNum : longint;
  NextPosition : longint;
  PrevPosition : longint;
begin
  if PageNumber = 1 then
    SeekToFirst
  else
    if PageNumber=PageCount then
      SeekToLast
    else
    begin
      if Stream.Position=Stream.Size then
        SeekToLast;
      Stream.Read(ThisPageNum,SizeOf(ThisPageNum));
      Stream.Seek(-SizeOf(ThisPageNum),soFromCurrent);
      if ThisPageNum<PageNumber then
      begin
        repeat
          Stream.Read(ThisPageNum,SizeOf(ThisPageNum));
          if ThisPageNum<>PageNumber then
          begin
            Stream.Read(NextPosition,SizeOf(NextPosition));
            Stream.Position := NextPosition;
          end;
        until ThisPageNum=PageNumber;
        Stream.Seek(-SizeOf(ThisPageNum),soFromCurrent);
      end else
        if ThisPageNum>PageNumber then
        begin
          repeat
            Stream.Read(ThisPageNum,SizeOf(ThisPageNum));
            if ThisPageNum<>PageNumber then
            begin
              Stream.Position := Stream.Position-SizeOf(PrevPosition)-SizeOf(ThisPageNum);
              Stream.Read(PrevPosition,SizeOf(PrevPosition));
              Stream.Position := PrevPosition;
            end;
          until ThisPageNum=PageNumber;
          Stream.Seek(-SizeOf(ThisPageNum),soFromCurrent);
        end;
    end;
end;

function TQRPageList.GetPage(PageNumber : integer) : TMetafile;
var
  Dummy : longint;
  TempStream : TMemoryStream;
  aByte : byte;
  BytesToGet : longint;
  I : longint;
begin
  if PageNumber>PageCount then
    result := nil
  else
  try
    LockList;
    SeekToPage(PageNumber);
    Stream.Read(Dummy,SizeOf(Dummy));
    Stream.Read(Dummy,SizeOf(Dummy));
    BytesToGet := BytesToGet-Stream.Position;
    result := TMetafile.Create;
    if Compression then
    begin
      Stream.Read(BytesToGet,SizeOf(BytesToGet));
      TempStream := TMemoryStream.Create;
      aCompressor := TQRCompress.Create(Stream,false);
      for I := 1 to BytesToGet do
      begin
        aCompressor.Expand(aByte);
        TempStream.Write(aByte,1);
      end;
      aCompressor.Free;
      TempStream.Position := 0;
      result.LoadFromStream(TempStream);
      TempStream.Free;
    end else
      result.LoadFromStream(Stream);
    Stream.Read(Dummy,SizeOf(Dummy));
  finally
    UnlockList;
  end;
end;

procedure TQRPageList.ReadFileHeader;
var
  aFileHeader : TQRFileHeader;
begin
  Stream.Position := 0;
  Stream.Read(aFileHeader, SizeOf(aFileHeader));
  FPageCount := aFileHeader.PageCount;
end;

procedure TQRPageList.WriteFileHeader;
var
  aFileHeader : TQRFileHeader;
begin
  Stream.Position := 0;
  aFileHeader.FormatVersion := cQRPFormatVersion;
  aFileHeader.QRVersion := cQRVersion;
  aFileHeader.PageCount := PageCount;
  aFileHeader.CreateDateTime := Now;
  if Compression then
    aFileHeader.Compression := 1
  else
    aFileHeader.Compression := 0;
  Stream.Write(aFileHeader, SizeOf(aFileHeader));
end;

procedure TQRPageList.AddPage(aMetafile : TMetafile);
var
  I,
  SavePos1,
  SavePos2,
  SavePos3 : longint;
  TempStream : TMemoryStream;
  aByte : byte;

  procedure SavePreInfo;
  var
    aPageCount : longint;
  begin
    aPageCount := FPageCount;
    Stream.Position := Stream.Size;
    SavePos1 := Stream.Position;                    { Store start position }
    Stream.Write(aPageCount,SizeOf(aPageCount));  { Write page number }
    SavePos2 := Stream.Position;                    { Store metafile size pos }
    Stream.Write(SavePos2,SizeOf(SavePos2));      { Reserve space for size }
  end;

  procedure SavePostInfo;
  begin
    Stream.Write(SavePos1,Sizeof(SavePos1));      { Store previous start }
    SavePos3 := Stream.Position;                    { Store post of next }
    Stream.Position := SavePos2;                    { Go back to reserved pos }
    Stream.Write(SavePos3,Sizeof(SavePos3));      { Save pos of next};
    Stream.Position := SavePos3;                    { Go to end of stream }
  end;

begin
  try
    LockList;
    inc(FPageCount);
    if PageCount = 1 then
      WriteFileHeader;
    if Compression then
    begin
      TempStream := TMemoryStream.Create;
      AMetafile.SaveToStream(TempStream);
      SavePreInfo;
      aCompressor := TQRCompress.Create(Stream,true);
      TempStream.Position := 0;
      I := TempStream.Size;
      Stream.Write(I,SizeOf(I));
      for I := 0 to TempStream.Size - 1 do
      begin
        TempStream.Read(aByte,1);
        aCompressor.Compress(aByte);
      end;
      aCompressor.Free;
      TempStream.Free;
      SavePostInfo;
    end else
    begin
      SavePreInfo;
      AMetaFile.SaveToStream(Stream);               { Save the metafile }
      SavePostInfo;
    end;
  finally
    UnlockList;
  end;
end;

{ TQRToolbar }

constructor TQRToolbar.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  Height := cQRToolbarHeight;
  ShowHint := true;
  Visible := false;
  CurrentX := cQRToolbarMargin;
  Component := nil;
  Align := alTop;
  FCBClickOK := true;
end;

procedure TQRToolbar.SetComponent(Value : TComponent);
begin
  FComponent := Value;
  FCBClickOK := false;
end;

procedure TQRToolbar.EndSetComponent;
begin
  FCBClickOK := true;
end;

function TQRToolbar.AddButton(aCaption, GlyphName,aHint : string; aGroup : integer;
  ClickEvent : TNotifyEvent) : TSpeedButton;
var
  aButton : TSpeedButton;
  ResName : array[0..79] of char;
begin
  aButton := TSpeedButton.Create(self);
  aButton.Parent := self;
  with aButton do
  begin
    Caption := aCaption;
    SetBounds(CurrentX,cQRToolbarMargin,cQRButtonSize,cQRButtonSize);
    StrPCopy(ResName,GlyphName);
    Glyph.Handle := LoadBitmap(hinstance,ResName);
    Hint := aHint;
    GroupIndex := aGroup;
    result := aButton;
    AllowAllUp := true;
    OnClick := ClickEvent;
  end;
  inc(FCurrentX, aButton.Width);
end;

function TQRToolbar.AddCheckBox(aCaption, aHint : string; ClickEvent : TNotifyEvent) : TCheckBox;
var
  aCheckBox : TCheckBox;
begin
  aCheckBox := TCheckBox.Create(Self);
  aCheckBox.Parent := Self;
  with aCheckBox do
  begin
    Caption := aCaption;
    Left := CurrentX;
    Top := cQRToolbarCBMargin;
    Width := cQRToolbarCBWidth;
    Hint := aHint;
    OnClick := ClickEvent;
    Result := aCheckBox;
  end;
  inc(FCurrentX, cQRToolbarCBWidth);
end;

procedure TQRToolbar.AddSpace;
begin
  inc(FCurrentX, cQRToolbarMargin*2);
end;

{$ifdef win32}
function QREnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
                       FontType: Integer; Data: Pointer): Integer; stdcall;
{$else}
function QREnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
                       FontType: Integer; Data: Pointer): Integer;
{$endif}
begin
  TStrings(Data).Add(LogFont.lfFaceName);
  Result := 1;
end;

function GetFonts : TStrings;
begin
  if Printer.Printers.Count = 0 then
    Result := Screen.Fonts
  else
    Result := Printer.Fonts;
end;

{ TQRGauge }

{$ifdef win32}

constructor TQRGauge.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  Width := 100;
  Height := 40;
  Max := 100;
  Min := 0;
end;

{$else}

type
  TBltBitmap = class(TBitmap)
    procedure MakeLike(ATemplate: TBitmap);
  end;

procedure TBltBitmap.MakeLike(ATemplate: TBitmap);
begin
  Width := ATemplate.Width;
  Height := ATemplate.Height;
  Canvas.Brush.Color := clWindowFrame;
  Canvas.Brush.Style := bsSolid;
  Canvas.FillRect(Rect(0, 0, Width, Height));
end;

constructor TQRGauge.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csFramed, csOpaque];
  { default values }
  FCurValue := 0;
  FBorderStyle := bsSingle;
  FForeColor := clCaptionText;
  FBackColor := clBtnFace;
  Width := 100;
  Height := 40;
end;

procedure TQRGauge.Paint;
var
  TheImage: TBitmap;
  OverlayImage: TBltBitmap;
  PaintRect: TRect;
begin
  with Canvas do
  begin
    TheImage := TBitmap.Create;
    try
      TheImage.Height := Height;
      TheImage.Width := Width;
      PaintBackground(TheImage);
      PaintRect := ClientRect;
      if FBorderStyle = bsSingle then InflateRect(PaintRect, -1, -1);
      OverlayImage := TBltBitmap.Create;
      try
        OverlayImage.MakeLike(TheImage);
        PaintBackground(OverlayImage);
        PaintAsBar(OverlayImage, PaintRect);
        TheImage.Canvas.CopyMode := cmSrcInvert;
        TheImage.Canvas.Draw(0, 0, OverlayImage);
        TheImage.Canvas.CopyMode := cmSrcCopy;
      finally
        OverlayImage.Free;
      end;
      Canvas.CopyMode := cmSrcCopy;
      Canvas.Draw(0, 0, TheImage);
    finally
      TheImage.Destroy;
    end;
  end;
end;

procedure TQRGauge.PaintBackground(AnImage: TBitmap);
var
  ARect: TRect;
begin
  with AnImage.Canvas do
  begin
    CopyMode := cmBlackness;
    ARect := Rect(0, 0, Width, Height);
    CopyRect(ARect, Animage.Canvas, ARect);
    CopyMode := cmSrcCopy;
  end;
end;

procedure TQRGauge.PaintAsBar(AnImage: TBitmap; PaintRect: TRect);
var
  FillSize: Longint;
  W, H: Integer;
begin
  W := PaintRect.Right - PaintRect.Left + 1;
  H := PaintRect.Bottom - PaintRect.Top + 1;
  with AnImage.Canvas do
  begin
    Brush.Color := FBackColor;
    FillRect(PaintRect);
    Pen.Color := FForeColor;
    Pen.Width := 1;
    Brush.Color := FForeColor;
    FillSize := round(FCurValue / 100 * W);
    if FillSize > W then FillSize := W;
    if FillSize > 0 then FillRect(Rect(PaintRect.Left, PaintRect.Top, FillSize, H));
  end;
end;

procedure TQRGauge.SetBorderStyle(Value: TBorderStyle);
begin
  if Value <> FBorderStyle then
  begin
    FBorderStyle := Value;
    Refresh;
  end;
end;

procedure TQRGauge.SetProgress(Value: Longint);
begin
  if (FCurValue <> Value) and (Value >= 0) and (Value <= 100) then
  begin
    FCurValue := Value;
    Refresh;
    if not Visible then Visible := true;
  end;
  if (Value=0) or (Value=100) then Visible := false;
end;
{$endif}

{ TQREvaluator }

constructor TQRFiFo.Create;
begin
  FiFo := TList.Create;
  FAggreg := false;
  FNextItem := 0;
end;

destructor TQRFiFo.Destroy;
var
  I : integer;
begin
  for I := 0 to FiFo.Count-1 do
    TObject(FiFo[I]).Free;
  FiFo.Free;
  inherited Destroy;
end;

procedure TQRFiFo.Start;
begin
  FNextItem := 0;
end;

procedure TQRFiFo.Put(Value : TObject);
begin
  FiFo.Add(Value);
end;

function TQRFiFo.GetAndFree : TObject;
begin
  if FiFo.Count>0 then
  begin
    result := FiFo[0];
    FiFo.Delete(0);
  end else
    result := nil;
end;

function TQRFiFo.Get : TObject;
begin
  if FNextItem<FiFo.Count then
  begin
    result := FiFo[FNextItem];
    inc(FNextItem);
  end else
    result := nil;
end;

{ TQREvElement }

constructor TQREvElement.Create;
begin
  inherited Create;
  FIsAggreg := false;
end;

function TQREvElement.Value(FiFo : TQRFiFo) : TQREvResult;
begin
end;

procedure TQREvElement.Reset;
begin
end;

{ TQREvElementOperator }

type
  TQREvElementOperator = class(TQREvElement)
  private
    FOpCode :  TQREvOperator;
    procedure ConverTQREvResults(var Res1 : TQREvResult; var Res2 : TQREvResult);
  public
    constructor CreateOperator(OpCode : TQREvOperator);
    function Value(FiFo : TQRFiFo) : TQREvResult; override;
  end;

constructor TQREvElementOperator.CreateOperator(OpCode : TQREvOperator);
begin
  inherited Create;
  FOpCode := OpCode;
end;

procedure TQREvElementOperator.ConverTQREvResults(var Res1 : TQREvResult; var Res2 : TQREvResult);
begin
  if Res1.Kind <> Res2.Kind then
  begin
    if ((Res1.Kind = resInt) and (Res2.Kind = resDouble)) then
    begin
      Res1.Kind := resDouble;
      Res1.dblResult := Res1.intResult;
    end else
      if ((Res1.Kind = resDouble) and (Res2.Kind = resInt)) then
      begin
        Res2.Kind := resDouble;
        Res2.dblResult := Res2.intResult;
      end else
      begin
        Res1.Kind := resError;
        Res2.Kind := resError;
      end;
  end;
end;

function TQREvElementOperator.Value(FiFo : TQRFiFo) : TQREvResult;
var
  Res1,
  Res2 : TQREvResult;
begin
  Res1 := TQREvElement(FiFo.Get).Value(FiFo);
  Res2 := TQREvElement(FiFo.Get).Value(FiFo);
  ConverTQREvResults(Res1, Res2);
  result.Kind := Res1.Kind;
  if result.Kind <> resError then
    case FOpCode of
      opPlus: case result.Kind of
                resInt:    result.intResult := Res1.intResult + Res2.intResult;
                resDouble: result.dblResult := Res1.dblResult + Res2.dblResult;
                resString: result.strResult := Res1.strResult + Res2.strResult;
                resBool:   result.Kind := resError;
              end;
      opMinus:  case result.Kind of
                  resInt:    result.intResult := Res1.intResult - Res2.intResult;
                  resDouble: result.dblResult := Res1.dblResult - Res2.dblResult;
                  resString: result.Kind := resError;
                  resBool:   result.Kind := resError;
                end;
      opMul: case result.Kind of
               resInt:    result.intResult := Res1.intResult * Res2.intResult;
               resDouble: result.dblResult := Res1.dblResult * Res2.dblResult;
               resString: result.Kind := resError;
               resBool:   result.Kind := resError;
             end;
      opDiv: case result.Kind of
               resInt:    if Res2.intResult <> 0 then
                            result.intResult := Res1.intResult div Res2.intResult
                          else
                            result.Kind := resError;
               resDouble: if Res2.dblResult <> 0 then
                            result.dblResult := Res1.dblResult / Res2.dblResult
                          else
                            result.Kind := resError;
               resString: result.Kind := resError;
               resBool:   result.Kind := resError;
             end;
      opGreater: begin
                   result.Kind := resBool;
                   case Res1.Kind of
                     resInt:    result.booResult := Res1.intResult > Res2.intResult;
                     resDouble: result.booResult := Res1.dblResult > Res2.dblResult;
                     resString: result.booResult := Res1.strResult > Res2.strResult;
                     resBool:   result.Kind := resError;
                   end;
                 end;
      opGreaterOrEqual: begin
                result.Kind := resBool;
                case Res1.Kind of
                  resInt:    result.booResult := Res1.intResult >= Res2.intResult;
                  resDouble: result.booResult := Res1.dblResult >= Res2.dblResult;
                  resString: result.booResult := Res1.strResult >= Res2.strResult;
                  resBool:   result.Kind := resError;
                end;
             end;
      opLess: begin
                result.Kind := resBool;
                case Res1.Kind of
                  resInt:    result.booResult := Res1.intResult < Res2.intResult;
                  resDouble: result.booResult := Res1.dblResult < Res2.dblResult;
                  resString: result.booResult := Res1.strResult < Res2.strResult;
                  resBool:   result.Kind := resError;
                end;
              end;
      opLessOrEqual: begin
                 result.Kind := resBool;
                 case Res1.Kind of
                   resInt:    result.booResult := Res1.intResult <= Res2.intResult;
                   resDouble: result.booResult := Res1.dblResult <= Res2.dblResult;
                   resString: result.booResult := Res1.strResult <= Res2.strResult;
                   resBool:   result.Kind := resError;
                 end;
               end;
      opEqual: begin
                 result.Kind := resBool;
                 case Res1.Kind of
                   resInt:    result.booResult := Res1.intResult = Res2.intResult;
                   resDouble: result.booResult := Res1.dblResult = Res2.dblResult;
                   resString: result.booResult := Res1.strResult = Res2.strResult;
                   resBool:   result.booResult := Res1.booResult = Res2.booResult;
                 end;
               end;
      opUnequal: begin
                   result.Kind := resBool;
                   case Res1.Kind of
                     resInt:    result.booResult := Res1.intResult <> Res2.intResult;
                     resDouble: result.booResult := Res1.dblResult <> Res2.dblResult;
                     resString: result.booResult := Res1.strResult <> Res2.strResult;
                     resBool:   result.booResult := Res1.booResult <> Res2.booResult;
                   end;
                 end;
      opOr: begin
              result.Kind := Res1.Kind;
              case Res1.Kind of
                resInt:    result.intResult := Res1.intResult or Res2.intResult;
                resDouble: result.Kind := resError;
                resString: Result.Kind := resError;
                resBool:   result.booResult := Res1.booResult or Res2.booResult;
              end;
            end;
      opAnd: begin
               result.Kind := Res1.Kind;
               case Res1.Kind of
                 resInt:    result.intResult := Res1.intResult and Res2.intResult;
                 resDouble: result.Kind := resError;
                 resString: result.Kind := resError;
                 resBool:   result.booResult := Res1.booResult and Res2.booResult;
               end;
             end;
    end;
end;

{ TQREvElementConstant }

type
  TQREvElementConstant = class(TQREvElement)
  private
    FValue : TQREvResult;
  public
    constructor CreateConstant(Value : TQREvResult);
    function Value(FiFo : TQRFiFo) : TQREvResult; override;
  end;

constructor TQREvElementConstant.CreateConstant(Value : TQREvresult);
begin
  inherited Create;
  FValue := Value;
end;

function TQREvElementConstant.Value(FiFo : TQRFiFo): TQREvResult;
begin
  Result := FValue;
end;

{ TQREvElementString }

type
  TQREvElementString = class(TQREvElement)
  private
    FValue : string;
  public
    constructor CreateString(Value : string);
    function Value(FiFo : TQRFiFo) : TQREvResult; override;
  end;

constructor TQREvElementString.CreateString(Value : string);
begin
  inherited Create;
  FValue := Value;
end;

function TQREvElementString.Value(FiFo : TQRFiFo) : TQREvResult;
begin
  result.Kind := resString;
  result.StrResult := FValue;
end;

{ TQREvElementFunction }

constructor TQREvElementFunction.Create;
begin
  inherited Create;
  ArgList := TList.Create;
end;

destructor TQREvElementFunction.Destroy;
begin
  ArgList.Free;
  inherited Destroy;
end;

procedure TQREvElementFunction.GetArguments(FiFo : TQRFiFo);
var
  aArgument : TQREvElement;
  AResult : TQREvResultClass;
begin
  repeat
    aArgument := TQREvElement(FiFo.Get);
    if not (aArgument is TQREvElementArgumentEnd) then
    begin
      aResult := TQREvResultClass.Create;
      aResult.EvResult := aArgument.Value(FiFo);
      ArgList.Add(aResult);
    end;
  until aArgument is TQREvElementArgumentEnd;
end;

procedure TQREvElementFunction.FreeArguments;
var
  I : integer;
begin
  for I := 0 to ArgList.Count - 1 do
    TQREvElement(ArgList.Items[I]).Free;
  ArgList.Clear;
end;

function TQREvElementFunction.Argument(Index : integer): TQREvResult;
begin
  if Index <= ArgList.Count then
    Result := TQREvResultClass(ArgList[Index]).EvResult;
end;

function TQREvElementFunction.Value(FiFo : TQRFiFo) : TQREvResult;
begin
  GetArguments(FiFo);
  if FiFo.Aggreg then
    Aggregate;
  Result := Calculate;
  FreeArguments;
end;

function TQREvElementFunction.ArgumentOK(Value : TQREvElement) : boolean;
begin
  result := not (Value is TQREvElementArgumentEnd) and not (Value is TQREvElementError);
end;

procedure TQREvElementFunction.Aggregate;
begin
end;

function TQREvElementFunction.Calculate : TQREvResult;
begin
  Result.Kind := resError;
end;

{ TQREvTrue }

type
  TQREvTrue = class(TQREvElementFunction)
  public
    function Calculate : TQREvResult; override;
  end;

  TQREvFalse = class(TQREvElementFunction)
  public
    function Calculate : TQREvResult; override;
  end;

function TQREvTrue.Calculate : TQREvResult;
begin
  if ArgList.Count = 0 then
  begin
    Result.Kind := resBool;
    Result.booResult := true;
  end else
    Result.Kind := resError;
end;

function TQREvFalse.Calculate : TQREvResult;
begin
  if ArgList.Count = 0 then
  begin
    Result.Kind := resBool;
    Result.booResult := false;
  end else
    Result.Kind := resError;
end;

{ TQREvIfFunction }

type
  TQREvIfFunction = class(TQREvElementFunction)
  public
    function Calculate : TQREvResult; override;
  end;

function TQREvIfFunction.Calculate : TQREvResult;
begin
  if (ArgList.Count = 3) and (Argument(0).Kind = resBool) then
  begin
    if Argument(0).BooResult then
      result := Argument(1)
    else
      result := Argument(2);
  end else
    result.Kind := resError;
end;

{ TQREvTypeOfFunction }

type
  TQREvTypeOfFunction = class(TQREvElementFunction)
  public
    function Calculate : TQREvResult; override;
  end;

function TQREvTypeOfFunction.Calculate : TQREvResult;
begin
  Result.Kind := resString;
  if ArgList.Count = 1 then
  begin
    case Argument(0).Kind of
      resInt : Result.StrResult := 'INTEGER';    {<-- do not resource }
      resDouble : Result.StrResult := 'FLOAT';   {<-- do not resource }
      resString : Result.StrResult := 'STRING';  {<-- do not resource }
      resBool : Result.StrResult := 'BOOLEAN';   {<-- do not resource }
      resError : Result.StrResult := 'ERROR';    {<-- do not resource }
    else
      Result.Kind := resError;
    end
  end else
    Result.Kind := resError;
end;

{ TQREvIntFunction }

type
  TQREvIntFunction = class(TQREvElementFunction)
  public
    function Calculate : TQREvResult; override;
  end;

function TQREvIntFunction.Calculate : TQREvResult;
begin
  Result.Kind := resInt;
  if ArgList.Count = 1 then
  begin
    case Argument(0).Kind of
      resInt : Result.IntResult := Argument(0).IntResult;
      resDouble : Result.IntResult := Round(Int(Argument(0).DblResult));
    else
      Result.Kind := resError;
    end
  end else
    Result.Kind := resError;
end;

{ TQREvFracFunction }

type
  TQREvFracFunction = class(TQREvElementFunction)
  public
    function Calculate : TQREvResult; override;
  end;

function TQREvFracFunction.Calculate : TQREvResult;
begin
  Result.Kind := resDouble;
  if ArgList.Count = 1 then
  begin
    case Argument(0).Kind of
      resInt : Result.DblResult := 0;
      resDouble : Result.DblResult := Frac(Argument(0).DblResult);
    else
      Result.Kind := resError;
    end
  end else
    Result.Kind := resError;
end;

{ TQREvSQRTFunction }

type
  TQREvSQRTFunction = class(TQREvElementFunction)
  public
    function Calculate : TQREvResult; override;
  end;

function TQREvSQRTFunction.Calculate : TQREvResult;
begin
  Result.Kind := resDouble;
  if ArgList.Count = 1 then
  begin
    case Argument(0).Kind of
      resInt : Result.DblResult := SQRT(Argument(0).IntResult);
      resDouble : Result.DblResult := SQRT(Argument(0).DblResult);
    else
      Result.Kind := resError;
    end
  end else
    Result.Kind := resError;
end;

{ TQREvStrFunction }

type
  TQREvStrFunction = class(TQREvElementFunction)
  public
    function Calculate : TQREvResult; override;
  end;

function TQREvStrFunction.Calculate : TQREvResult;
var
  ArgRes : TQREvResult;
begin
  if ArgList.Count = 1 then
  begin
    ArgRes := Argument(0);
    Result.Kind := resString;
    case ArgRes.Kind of
      resInt : Result.strResult := IntToStr(ArgRes.IntResult);
      resDouble : Result.strResult := FloatToStr(ArgRes.DblResult);
      resBool : if ArgRes.booResult then
                result.StrResult := 'True'          {<-- do not resource }
              else
                result.StrResult := 'False';        {<-- do not resource }
    else
      result.Kind := resError;
    end
  end else
    Result.Kind := resError;
end;

{ TQREvUpperFunction }

type
  TQREvUpperFunction = class(TQREvElementFunction)
  public
    function Calculate : TQREvResult; override;
  end;

function TQREvUpperFunction.Calculate : TQREvResult;
begin
  if (ArgList.Count = 1) and (Argument(0).Kind = resString) then
  begin
    Result.Kind := resString;
{$ifdef ver100}
    Result.StrResult := AnsiUpperCase(Argument(0).StrResult);
{$else}
    Result.StrResult := UpperCase(Argument(0).StrResult);
{$endif}
  end else
    Result.Kind := resError;
end;

{ TQREvLowerFunction }

type
  TQREvLowerFunction = class(TQREvElementFunction)
  public
    function Calculate : TQREvResult; override;
  end;

function TQREvLowerFunction.Calculate : TQREvResult;
begin
  if (ArgList.Count = 1) and (Argument(0).Kind = resString) then
  begin
    Result.Kind := resString;
{$ifdef ver100}
    Result.StrResult := AnsiLowerCase(Argument(0).StrResult);
{$else}
    Result.StrResult := LowerCase(Argument(0).StrResult);
{$endif}
  end else
    Result.Kind := resError;
end;

{ TQREvUpperFunction }

type
  TQREvPrettyFunction = class(TQREvElementFunction)
  public
    function Calculate : TQREvResult; override;
  end;

function TQREvPrettyFunction.Calculate : TQREvResult;
begin
  if (ArgList.Count = 1) and (Argument(0).Kind = resString) then
  begin
    Result.Kind := resString;
{$ifdef ver100}
    Result.StrResult := AnsiUpperCase(Copy(Argument(0).StrResult, 1, 1)) +
                        AnsiLowerCase(Copy(Argument(0).StrResult, 2, length(Argument(0).StrResult)));
{$else}
    Result.StrResult := UpperCase(Copy(Argument(0).StrResult, 1, 1)) +
                        LowerCase(Copy(Argument(0).StrResult, 2, length(Argument(0).StrResult)));
{$endif}
  end else
    Result.Kind := resError;
end;

{ TQREvTimeFunction }

type
  TQREvTimeFunction = class(TQREvElementFunction)
  public
    function Calculate : TQREvResult; override;
  end;

function TQREvTimeFunction.Calculate : TQREvResult;
begin
  if ArgList.Count = 0 then
  begin
    Result.Kind := resString;
    Result.StrResult := TimeToStr(Now);
  end else
    Result.Kind := resError;
end;

{ TQREvTimeFunction }

type
  TQREvDateFunction = class(TQREvElementFunction)
  public
    function Calculate : TQREvResult; override;
  end;

function TQREvDateFunction.Calculate : TQREvResult;
begin
  if ArgList.Count=0 then
  begin
    Result.Kind := resString;
    Result.StrResult := DateToStr(Date);
  end else
    Result.Kind := resError;
end;

{ TQREvCopyFunction }

type
  TQREvCopyFunction = class(TQREvElementFunction)
  public
    function Calculate : TQREvResult; override;
  end;

function TQREvCopyFunction.Calculate : TQREvResult;
begin
  if (ArgList.Count = 3) and
    (Argument(0).Kind = resString) and
    (Argument(1).Kind = resInt) and
    (Argument(2).Kind = resInt) then
  begin
    Result.StrResult := copy(Argument(0).strResult, Argument(1).IntResult, Argument(2).IntResult);
    Result.Kind := resString;
  end else
    Result.Kind := resError;
end;

{ TQREvFormatNumericFunction }

type
  TQREvFormatNumericFunction = class(TQREvElementFunction)
  public
    function Calculate : TQREvResult; override;
  end;

function TQREvFormatNumericFunction.Calculate : TQREvResult;
begin
  if (ArgList.Count = 2) and
     ((Argument(1).Kind = resInt) or (Argument(1).Kind = resDouble)) and
     (Argument(0).Kind = resString) then
  begin
    Result.Kind := resString;
    if Argument(1).Kind = resInt then
      Result.StrResult := FormatFloat(Argument(0).StrResult, Argument(1).IntResult * 1.0)
    else
      Result.StrResult := FormatFloat(Argument(0).StrResult, Argument(1).DblResult);
  end else
    Result.Kind := resError;
end;

{ TQREvSumFunction }

type
  TQREvSumFunction = class(TQREvElementFunction)
  private
    SumResult : TQREvResult;
    ResAssigned : boolean;
  public
    constructor Create; override;
    procedure Aggregate; override;
    function Calculate : TQREvResult; override;
    procedure Reset; override;
  end;

constructor TQREvSumFunction.Create;
begin
  inherited Create;
  ResAssigned := false;
  IsAggreg := true;
end;

procedure TQREvSumFunction.Reset;
begin
  ResAssigned := false;
end;

procedure TQREvSumFunction.Aggregate;
var
  aValue : TQREvResult;
begin
  if ArgList.Count = 1 then
  begin
    aValue := Argument(0);
    if ResAssigned then
    begin
      case aValue.Kind of
        resInt : SumResult.IntResult := SumResult.IntResult + aValue.IntResult;
        resDouble : SumResult.dblResult := SumResult.dblResult + aValue.dblResult;
        resString : SumResult.Kind := resError;
      end;
    end else
    begin
      SumResult.Kind := aValue.Kind;
      case aValue.Kind of
        resInt : SumResult.IntResult := aValue.IntResult;
        resDouble : SumResult.dblResult := aValue.dblResult;
      else
        SumResult.Kind := resError;
      end;
    end;
    ResAssigned := true;
  end else
    SumResult.Kind := resError;
end;

function TQREvSumFunction.Calculate : TQREvResult;
begin
  if ResAssigned then
    Result := SumResult
  else
    Result.Kind := resError;
end;

{ TQREvAverageFunction }

type
  TQREvAverageFunction = class(TQREvSumFunction)
  private
    Count : longint;
    aResult : TQREvResult;
  public
    function Calculate : TQREvResult; override;
    procedure Aggregate; override;
    procedure Reset; override;
  end;

procedure TQREvAverageFunction.Reset;
begin
  inherited Reset;
  aResult.Kind := resError;
  Count := 0;
  IsAggreg := true;
end;

procedure TQREvAverageFunction.Aggregate;
var
  aValue : TQREvResult;
begin
  inherited Aggregate;
  inc(Count);
  aValue := inherited Calculate;
  aResult.Kind := resDouble;
  case aValue.Kind of
    ResInt : aResult.DblResult := aValue.IntResult / Count;
    ResDouble : aResult.DblResult := aValue.DblResult / Count;
  else
    aResult.Kind := resError;
  end;
end;

function TQREvAverageFunction.Calculate : TQREvResult;
begin
  Result := aResult
end;

{ TQREvMaxFunction }

type
  TQREvMaxFunction = class(TQREvElementFunction)
  private
    MaxResult : TQREvResult;
    ResAssigned : boolean;
  public
    constructor Create; override;
    function Calculate : TQREvResult; override;
    procedure Aggregate; override;
    procedure Reset; override;
  end;

constructor TQREvMaxFunction.Create;
begin
  inherited Create;
  ResAssigned := false;
  IsAggreg := true;
end;

procedure TQREvMaxFunction.Reset;
begin
  ResAssigned := false;
end;

procedure TQREvMaxFunction.Aggregate;
var
  aValue : TQREvResult;
begin
  if ArgList.Count = 1 then
  begin
    aValue := Argument(0);
    if ResAssigned then
    begin
      case MaxResult.Kind of
        resInt : if aValue.IntResult > MaxResult.IntResult then
                   MaxResult.IntResult := aValue.IntResult;
        resDouble : if aValue.DblResult > MaxResult.DblResult then
                      MaxResult.DblResult := aValue.DblResult;
        resString : if aValue.StrResult > MaxResult.StrResult then
                      MaxResult.StrResult := aValue.StrResult;
        resBool : if aValue.booResult > MaxResult.BooResult then
                    MaxResult.BooResult := aValue.BooResult;
      else
        MaxResult.Kind := resError;
      end
    end else
    begin
      MaxResult := aValue;
      ResAssigned := true;
    end
  end else
    MaxResult.Kind := resError;
end;

function TQREvMaxFunction.Calculate : TQREvResult;
begin
  if ResAssigned then
    Result := MaxResult
  else
    Result.Kind := resError;
end;

{ TQREvMinFunction }

type
  TQREvMinFunction = class(TQREvElementFunction)
  private
    MinResult : TQREvResult;
    ResAssigned : boolean;
  public
    constructor Create; override;
    function Calculate : TQREvResult; override;
    procedure Aggregate; override;
    procedure Reset; override;
  end;

constructor TQREvMinFunction.Create;
begin
  inherited Create;
  ResAssigned := false;
  IsAggreg := true;
end;

procedure TQREvMinFunction.Reset;
begin
  ResAssigned := false;
end;

procedure TQREvMinFunction.Aggregate;
var
  aValue : TQREvResult;
begin
  if ArgList.Count = 1 then
  begin
    aValue := Argument(0);
    if ResAssigned then
    begin
      case MinResult.Kind of
        resInt : if aValue.IntResult < MinResult.IntResult then
                   MinResult.IntResult := aValue.IntResult;
        resDouble : if aValue.DblResult < MinResult.DblResult then
                      MinResult.DblResult := aValue.DblResult;
        resString : if aValue.StrResult < MinResult.StrResult then
                      MinResult.StrResult := aValue.StrResult;
        resBool : if aValue.booResult > MinResult.BooResult then
                    MinResult.BooResult := aValue.BooResult;
      else
        MinResult.Kind := resError;
      end
    end else
    begin
      MinResult := aValue;
      ResAssigned := true;
    end
  end else
    MinResult.Kind := resError;
end;

function TQREvMinFunction.Calculate : TQREvResult;
begin
  if ResAssigned then
    Result := MinResult
  else
    Result.Kind := resError;
end;

{ TQREvCountFunction }

type
  TQREvCountFunction = class(TQREvElementFunction)
  private
    FCount : integer;
  public
    constructor Create; override;
    function Value(FiFo : TQRFiFo) : TQREvResult; override;
    procedure Reset; override;
  end;

constructor TQREvCountFunction.Create;
begin
  inherited Create;
  FCount := 0;
  IsAggreg := true;
end;

function TQREvCountFunction.Value(FiFo : TQRFiFo) : TQREvResult;
begin
  GetArguments(FiFo);
  if (ArgList.Count = 0) then
  begin
    if FiFo.Aggreg then
      inc(FCount);
    Result.Kind := resInt;
    Result.intResult := FCount;
  end else
    Result.Kind := resError;
  FreeArguments;
end;

procedure TQREvCountFunction.Reset;
begin
  FCount := 0;
end;

{ TQREvElementDataField }

constructor TQREvElementDataField.CreateField(aField : TField);
begin
  inherited Create;
  FDataSet := aField.DataSet;
  FFieldNo := aField.Index;
  FField := aField;
end;

function TQREvElementDataField.Value(FiFo : TQRFiFo) : TQREvResult;
begin
  if FDataSet.DefaultFields then
    FField := FDataSet.Fields[FFieldNo];
  if FField is TStringField then
  begin
    result.Kind := resString;
    result.strResult := TStringField(FField).Value;
  end else
    if (FField is TIntegerField) or
       (FField is TSmallIntField) or
       (FField is TWordField) then
    begin
      result.Kind := resInt;
      result.intResult := FField.AsInteger;
    end else
      if (FField is TFloatField)  or
         (FField is TCurrencyField) or
         (FField is TBCDField) then
      begin
        result.Kind := resDouble;
        result.dblResult := TFloatField(FField).AsFloat;
      end else
        if FField is TBooleanField then
        begin
          result.Kind := resBool;
          result.BooResult := TBooleanField(FField).Value;
        end else
          if FField is TDateField then
          begin
            result.Kind := resString;
            result.strResult := TDateField(FField).AsString;
          end else
            if FField is TDateTimeField then
            begin
              result.Kind := resString;
              result.strResult := TDateField(FField).AsString;
            end else
              result.Kind := resError
end;

function TQREvElementError.Value(FiFo : TQRFiFo) : TQREvResult;
begin
  result.Kind := resError;
end;


{$ifndef win32}
{ TQRStringStack }

function TrimString(strString : string) : string;
var
  intStart,
  intEnd : integer;
begin
  intStart := 1;
  intEnd := Length(strString);
  while (copy(strString,intStart,1) = ' ') and (intStart < intEnd) do
    inc(intStart);
  while (copy(strString,intEnd,1) = ' ') and (intEnd > intStart) do
    dec(intEnd);
  strString := Copy(strString, intStart, intEnd - intStart + 1);
  Result := strString;
end;

constructor TQRStringStack.Create;
begin
  aList := TStringList.Create;
end;

destructor TQRStringStack.Destroy;
begin
  aList.Free;
  inherited Destroy;
end;

procedure TQRStringStack.Push(Value : string);
begin
  aList.Add(TrimString(Value));
end;

procedure TQRStringStack.Pop;
begin
  aList.Delete(aList.Count - 1);
end;

function TQRStringStack.Peek(FromTop : integer) : string;
begin
  result := aList[aList.Count - FromTop - 1];
end;
{$endif}

{ TQREvaluator }
constructor TQREvaluator.Create;
begin
  Prepared := false;
{$ifndef win32}
  StringStack := TQRStringStack.Create;
{$endif}
end;

destructor TQREvaluator.Destroy;
begin
  if Prepared then Unprepare;
{$ifndef win32}
  StringStack.Free;
{$endif}
  inherited Destroy;
end;

procedure TQREvaluator.TrimString(var strString : string);
var
  intStart,
  intEnd : integer;
begin
  intStart := 1;
  intEnd := Length(strString);
  while (copy(strString,intStart,1) = ' ') and (intStart < intEnd) do
    inc(intStart);
  while (copy(strString,intEnd,1) = ' ') and (intEnd > intStart) do
    dec(intEnd);
  strString := Copy(strString, intStart, intEnd - intStart + 1);
end;

{$ifdef win32}
procedure TQREvaluator.FindDelimiter(strArg : string; var Pos : integer);
var
  n : integer;
  FoundDelim : boolean;
  booString : boolean;
  intParenteses : integer;
begin
  if strArg='' then
    Pos := 0
  else
  begin
    FoundDelim := false;
    BooString := false;
    intParenteses := 0;
    N := 1;
    while (N<length(strArg)) and not FoundDelim do
    begin
      case StrArg[N] of
        '(' : if not booString then inc(intParenteses);
        ')' : if not booString then dec(intParenteses);
        '''' : booString := not booString;
      end;
      if (intParenteses=0) and not booString then
        if strArg[N]=ArgSeparator then
        begin
          FoundDelim := true;
          break;
        end;
      inc(N);
    end;
    if FoundDelim then
      Pos := N
    else
      Pos := 0;
  end;
end;
{$else}
procedure TQREvaluator.FindDelimiter(var Pos : integer);
var
  n : integer;
  FoundDelim : boolean;
  booString : boolean;
  intParenteses : integer;
begin
  if StringStack.Peek(0) = '' then
    Pos := 0
  else
  begin
    FoundDelim := false;
    BooString := false;
    intParenteses := 0;
    N := 1;
    while (N < length(StringStack.Peek(0))) and not FoundDelim do
    begin
      case StringStack.Peek(0)[N] of
        '(' : if not booString then inc(intParenteses);
        ')' : if not booString then dec(intParenteses);
        '''' : booString := not booString;
      end;
      if (intParenteses = 0) and not booString then
        if StringStack.Peek(0)[N] = ArgSeparator then
        begin
          FoundDelim := true;
          break;
        end;
      inc(N);
    end;
    if FoundDelim then
      Pos := N
    else
      Pos := 0;
  end;
end;
{$endif}

{$ifdef win32}
procedure TQREvaluator.FindOp1(const strExpr : string; var Op : TQREvOperator; var Pos, Len : integer);
var
  n : integer;
  booFound : boolean;
  intParenteses : integer;
  aString : string[255];
  booString : boolean;
begin
  n := 1;
  intParenteses := 0;
  booFound := false;
  Len := 1;
  aString := strExpr;
  booString := false;
  while (n < Length(strExpr)) and (not booFound) do
  begin
    booFound := true;
    case aString[N] of
      '(' : if not booString then inc(intParenteses);
      ')' : if not booString then dec(intParenteses);
      '''' : booString := not booString;
    end;
    if (intParenteses = 0) and (n > 1) and not booString then
      case aString[N] of
        '<' : begin
                if aString[N + 1] = '>' then
                begin
                  Op := opUnequal;
                  Len := 2;
                end else
                  if aString[N + 1] = '=' then
                  begin
                    Op := opLessOrEqual;
                    Len := 2;
                  end else
                    Op := opLess;
                end;
        '>' : if aString[N + 1] = '=' then
              begin
                Op := opGreaterOrEqual;
                Len := 2;
              end else
                Op := opGreater;
        '=' : Op := opEqual;
      else
        booFound := false;
      end
    else
      booFound := false;
    inc(N);
  end;
  if booFound then
    Pos := n - 1
  else
    Pos := -1;
end;
{$else}
procedure TQREvaluator.FindOp1(var Op : TQREvOperator; var Pos, Len : integer);
var
  n : integer;
  booFound : boolean;
  intParenteses : integer;
  booString : boolean;
begin
  n := 1;
  intParenteses := 0;
  booFound := false;
  Len := 1;
  booString := false;
  while (n < Length(StringStack.Peek(0))) and (not booFound) do
  begin
    booFound := true;
    case StringStack.Peek(0)[N] of
      '(' : if not booString then inc(intParenteses);
      ')' : if not booString then dec(intParenteses);
      '''' : booString := not booString;
    end;
    if (intParenteses = 0) and (n > 1) and not booString then
      case StringStack.Peek(0)[N] of
        '<' : begin
                if StringStack.Peek(0)[N + 1] = '>' then
                begin
                  Op := opUnequal;
                  Len := 2;
                end else
                  if StringStack.Peek(0)[N + 1] = '=' then
                  begin
                    Op := opLessOrEqual;
                    Len := 2;
                  end else
                    Op := opLess;
                end;
        '>' : if StringStack.Peek(0)[N + 1] = '=' then
              begin
                Op := opGreaterOrEqual;
                Len := 2;
              end else
                Op := opGreater;
        '=' : Op := opEqual;
      else
        booFound := false;
      end
    else
      booFound := false;
    inc(N);
  end;
  if booFound then
    Pos := n - 1
  else
    Pos := -1;
end;
{$endif}

{$ifdef win32}
procedure TQREvaluator.FindOp2(const strExpr : string; var Op : TQREvOperator; var Pos, Len : integer);
var
  n : integer;
  booFound : boolean;
  intParenteses : integer;
  booString : boolean;
  aString : string[255];
begin
  n := 1;
  intParenteses := 0;
  booFound := false;
  booString := false;
  aString := strExpr;
  Len := 1;
  while (n < Length(strExpr)) and (not booFound) do
  begin
    booFound := true;
    case aString[N] of
      '(' : if not boostring then inc(intParenteses);
      ')' : if not boostring then dec(intParenteses);
      '''': booString := not booString;
    end;
    if (intParenteses = 0) and (not booString) and (N > 1) then
      case aString[N] of
        '+' : Op := opPlus;
        '-' : Op := opMinus;
        ' ' : if (AnsiLowercase(copy(strExpr, N + 1, 3)) = 'or ') then
              begin
                Op := opOr;
                Len := 2;
                inc(N);
              end else
                booFound := false;
      else
        booFound := false;
    end else
      booFound := false;
    inc(N);
  end;
  if booFound then
    Pos := N - 1
  else
    Pos := -1;
end;
{$else}
procedure TQREvaluator.FindOp2(var Op : TQREvOperator; var Pos, Len : integer);
var
  n : integer;
  booFound : boolean;
  intParenteses : integer;
  booString : boolean;
begin
  n := 1;
  intParenteses := 0;
  booFound := false;
  booString := false;
  Len := 1;
  while (n < Length(StringStack.Peek(0))) and (not booFound) do
  begin
    booFound := true;
    case StringStack.Peek(0)[N] of
      '(' : if not boostring then inc(intParenteses);
      ')' : if not boostring then dec(intParenteses);
      '''': booString := not booString;
    end;
    if (intParenteses = 0) and (not booString) and (N > 1) then
      case StringStack.Peek(0)[N] of
        '+' : Op := opPlus;
        '-' : Op := opMinus;
        ' ' : if (AnsiLowercase(copy(StringStack.Peek(0), N + 1, 3)) = 'or ') then
              begin
                Op := opOr;
                Len := 2;
                inc(N);
              end else
                booFound := false;
      else
        booFound := false;
    end else
      booFound := false;
    inc(N);
  end;
  if booFound then
    Pos := N - 1
  else
    Pos := -1;
end;
{$endif}

{$ifdef win32}
procedure TQREvaluator.FindOp3(const strExpr : string; var Op : TQREvOperator; var Pos, Len : integer);
var
  n : integer;
  booFound : boolean;
  intParenteses : integer;
  booString : boolean;
  aString : string[255];
begin
  n := 1;
  intParenteses := 0;
  booFound := false;
  booString := false;
  Len := 1;
  aString := strExpr;
  while (N < Length(strExpr)) and (not booFound) do
  begin
    booFound := true;
    case aString[N] of
      '(' : if not booString then inc(intParenteses);
      ')' : if not booString then dec(intParenteses);
      '''': booString := not booString;
    end;
    if (intParenteses = 0) and (not booString) and (N > 1) then
    begin
      case aString[N] of
        '*' : Op := opMul;
        '/' : Op := opDiv;
        ' ' : if (AnsiLowercase(copy(strExpr, n + 1, 4)) = 'and ') then
              begin
                Op := opAnd;
                Len := 3;
                inc(N);
              end else
                booFound := false;
      else
        booFound := false;
    end;
  end else
    booFound := false;
    inc(N);
  end;
  if booFound then
    Pos := N - 1
  else
    Pos := -1;
end;
{$else}
procedure TQREvaluator.FindOp3(var Op : TQREvOperator; var Pos, Len : integer);
var
  n : integer;
  booFound : boolean;
  intParenteses : integer;
  booString : boolean;
begin
  n := 1;
  intParenteses := 0;
  booFound := false;
  booString := false;
  Len := 1;
  while (N < Length(StringStack.Peek(0))) and (not booFound) do
  begin
    booFound := true;
    case StringStack.Peek(0)[N] of
      '(' : if not booString then inc(intParenteses);
      ')' : if not booString then dec(intParenteses);
      '''': booString := not booString;
    end;
    if (intParenteses = 0) and (not booString) and (N > 1) then
    begin
      case StringStack.Peek(0)[N] of
        '*' : Op := opMul;
        '/' : Op := opDiv;
        ' ' : if (AnsiLowercase(copy(StringStack.Peek(0), n + 1, 4)) = 'and ') then
              begin
                Op := opAnd;
                Len := 3;
                inc(N);
              end else
                booFound := false;
      else
        booFound := false;
    end;
  end else
    booFound := false;
    inc(N);
  end;
  if booFound then
    Pos := N - 1
  else
    Pos := -1;
end;
{$endif}

function TQREvaluator.NegateResult(const Res : TQREvResult) : TQREvResult;
begin
  result.Kind := Res.Kind;
  case Res.Kind of
    resInt: result.intResult := - Res.intResult;
    resDouble: result.dblResult := -Res.dblResult;
    resBool: result.booResult := not Res.booResult;
  else
    result.Kind := resError;
  end;
end;

{$ifdef win32}
function TQREvaluator.EvalVariable(strVariable : string) : TQREvResult;
var
  SeparatorPos : integer;
  DSName : string;
  FieldName : string;
  aDataSet : TDataSet;
  aField : TField;
  I : integer;
begin
  if assigned(FDataSets) then
  begin
    SeparatorPos := AnsiPos('.', strVariable);
    DSName := AnsiUpperCase(copy(StrVariable, 1, SeparatorPos - 1));
    FieldName := AnsiUpperCase(copy(strVariable, SeparatorPos + 1, length(StrVariable) - SeparatorPos));
    aField := nil;
    aDataSet := nil;
    if length(DSName)>0 then
    begin
      for I := 0 to FDataSets.Count - 1 do
        if AnsiUpperCase(TDataSet(FDataSets[I]).Name) = DSName then
        begin
          aDataSet := TDataSet(FDataSets[I]);
          break;
        end;
      if aDataSet<>nil then
        aField := aDataSet.FindField(FieldName);
    end else
    begin
      for I := 0 to FDataSets.Count - 1 do
        with TDataSet(FDataSets[I]) do
        begin
          aField := FindField(FieldName);
          if aField <> nil then break;
        end;
    end;
    if aField <> nil then
      FiFo.Put(TQREvElementDataField.CreateField(aField))
    else
      FiFo.Put(TQREvElementError.Create);
  end else
    FiFo.Put(TQREvElementError.Create);
end;
{$else}
function TQREvaluator.EvalVariable : TQREvResult;
var
  SeparatorPos : integer;
  DSName : string;
  FieldName : string;
  aDataSet : TDataSet;
  aField : TField;
  I : integer;
begin
  if assigned(FDataSets) then
  begin
    SeparatorPos := AnsiPos('.', StringStack.Peek(0));
    DSName := AnsiUpperCase(copy(StringStack.Peek(0), 1, SeparatorPos - 1));
    FieldName := AnsiUpperCase(copy(StringStack.Peek(0), SeparatorPos + 1, length(StringStack.Peek(0)) - SeparatorPos));
    aField := nil;
    aDataSet := nil;
    if length(DSName)>0 then
    begin
      for I := 0 to FDataSets.Count - 1 do
        if AnsiUpperCase(TDataSet(FDataSets[I]).Name) = DSName then
        begin
          aDataSet := TDataSet(FDataSets[I]);
          break;
        end;
      if aDataSet<>nil then
        aField := aDataSet.FindField(FieldName);
    end else
    begin
      for I := 0 to FDataSets.Count - 1 do
        with TDataSet(FDataSets[I]) do
        begin
          aField := FindField(FieldName);
          if aField <> nil then break;
        end;
    end;
    if aField <> nil then
      FiFo.Put(TQREvElementDataField.CreateField(aField))
    else
      FiFo.Put(TQREvElementError.Create);
  end else
    FiFo.Put(TQREvElementError.Create);
end;
{$endif}

{$ifdef win32}
function TQREvaluator.EvalString(const strString : string) : TQREvResult;
begin
  result.Kind := resString;
  result.strResult := strString;
  FiFo.Put(TQREvElementString.CreateString(Result.StrResult));
end;
{$else}
function TQREvaluator.EvalString : TQREvResult;
begin
  result.Kind := resString;
  result.strResult := StringStack.Peek(0);
  FiFo.Put(TQREvElementString.CreateString(Result.StrResult));
end;
{$endif}

{$ifdef win32}
function TQREvaluator.EvalFunction(strFunc : string; const strArg : string) : TQREvResult;
var
  DelimPos : integer;
  aString : string;
  Res : TQREvResult;
  aFunc : TQREvElement;
begin
  StrFunc := AnsiUpperCase(StrFunc);
  aFunc := QRFunctionLibrary.GetFunction(strFunc);
  if AFunc is TQREvElementError then
  begin
    if StrArg = '' then
    begin
      AFunc.Free;
      EvalVariable(StrFunc)
    end else
      FiFo.Put(AFunc);
  end else
  begin
    FiFo.Put(AFunc);
    if not (aFunc is TQREvElementError) then
    begin
      aString := strArg;
      repeat
        FindDelimiter(aString, DelimPos);
        if DelimPos > 0 then
          Res := Evaluate(copy(aString, 1, DelimPos - 1))
        else
          if length(aString) > 0 then Res := Evaluate(aString);
        Delete(aString, 1, DelimPos);
      until DelimPos = 0;
    end;
    FiFo.Put(TQREvElementArgumentEnd.Create);
  end;
end;
{$else}
function TQREvaluator.EvalFunction : TQREvResult;
var
  DelimPos : integer;
  aString : string;
  Res : TQREvResult;
  aFunc : TQREvElement;
begin
  aFunc := QRFunctionLibrary.GetFunction(AnsiUpperCase(StringStack.Peek(0)));
  if AFunc is TQREvElementError then
  begin
    if StringStack.Peek(1) = '' then
    begin
      AFunc.Free;
      StringStack.Push(StringStack.Peek(0));
      EvalVariable;
      StringStack.Pop;
    end else
      FiFo.Put(AFunc);
  end else
  begin
    FiFo.Put(AFunc);
    if not (aFunc is TQREvElementError) then
    begin
      aString := StringStack.Peek(1);
      repeat
        StringStack.Push(aString);
        FindDelimiter(DelimPos);
        StringStack.Pop;
        if DelimPos > 0 then
        begin
          StringStack.Push(copy(aString, 1, DelimPos - 1));
          Res := Evaluate;
          StringStack.Pop;
        end else
          if length(aString) > 0 then
          begin
            StringStack.Push(aString);
            Res := Evaluate;
            StringStack.Pop;
          end;
        Delete(aString, 1, DelimPos);
        TrimString(aString);
      until DelimPos = 0;
    end;
    FiFo.Put(TQREvElementArgumentEnd.Create);
  end;
end;
{$endif}

{$ifdef win32}
function TQREvaluator.EvalConstant(const strConstant : string) : TQREvResult;
var
  N : integer;
  aString : string[255];
begin
  N := 1;
  aString := strConstant;
  while (N <= Length(aString)) and  (aString[N] in ['0'..'9']) do
    inc(N);
  result.Kind := resInt;
  while ((N <= Length(aString)) and (aString[N] in ['0'..'9', '.', 'e', 'E', '+', '-'])) do
  begin
    inc(N);
    result.Kind := resDouble;
  end;
  if N - 1 <> Length(aString) then
    result.Kind := resError
  else
  begin
    if result.Kind = resInt then
      result.intResult := StrToInt(aString)
    else
      if result.Kind = resDouble then
      begin
        if DecimalSeparator <> '.' then
        begin
          while pos('.', aString) > 0 do
            aString[pos('.', aString)] := DecimalSeparator;
        end;
        result.dblResult := StrToFloat(aString);
      end;
  end;
  if result.Kind=resError then
    FiFo.Put(TQREvElementError.Create)
  else
    FiFo.Put(TQREvElementConstant.CreateConstant(Result));
end;
{$else}
function TQREvaluator.EvalConstant : TQREvResult;
var
  N : integer;
  aString : string;
begin
  N := 1;
  while (N <= Length(StringStack.Peek(0))) and  (StringStack.Peek(0)[N] in ['0'..'9']) do
    inc(N);
  result.Kind := resInt;
  while ((N <= Length(StringStack.Peek(0))) and (StringStack.Peek(0)[N] in ['0'..'9', '.', 'e', 'E', '+', '-'])) do
  begin
    inc(N);
    result.Kind := resDouble;
  end;
  if N - 1 <> Length(StringStack.Peek(0)) then
    result.Kind := resError
  else
  begin
    if result.Kind = resInt then
      result.intResult := StrToInt(StringStack.Peek(0))
    else
      if result.Kind = resDouble then
      begin
        if DecimalSeparator <> '.' then
        begin
          aString := StringStack.Peek(0);
          while pos('.', aString) > 0 do
            aString[pos('.', aString)] := DecimalSeparator;
        end;
        result.dblResult := StrToFloat(aString);
      end;
  end;
  if result.Kind = resError then
    FiFo.Put(TQREvElementError.Create)
  else
    FiFo.Put(TQREvElementConstant.CreateConstant(Result));
end;
{$endif}

{$ifdef win32}
function TQREvaluator.EvalFunctionExpr(const strFunc : string) : TQREvResult;
var
  argRes : TQREvResult;
  po : integer;
begin
  po := AnsiPos('(', StrFunc);
  if po > 0 then
  begin
    if copy(StrFunc, length(StrFunc), 1) = ')' then
    begin
      result := EvalFunction(copy(StrFunc, 1, po - 1), copy(StrFunc, po + 1, length(strFunc) - po - 1));
    end else
    begin
      argRes.Kind := resError;
      result := EvalFunction('', '');
    end;
  end else
  begin
    argRes.Kind := resError;
    result := EvalFunction(StrFunc, '');
  end;
end;
{$else}
function TQREvaluator.EvalFunctionExpr : TQREvResult;
var
  argRes : TQREvResult;
  po : integer;
  astr : string;
begin
  po := AnsiPos('(', StringStack.Peek(0));
  if po > 0 then
  begin
    if copy(StringStack.Peek(0), length(StringStack.Peek(0)), 1) = ')' then
    begin
      StringStack.Push(copy(StringStack.Peek(0), po + 1, length(StringStack.Peek(0)) - po - 1));
      StringStack.Push(copy(StringStack.Peek(1), 1, po - 1));
      result := EvalFunction;
      StringStack.Pop;
      StringStack.Pop;
    end else
    begin
      argRes.Kind := resError;
      StringStack.Push('');
      StringStack.Push('');
      result := EvalFunction;
      StringStack.Pop;
      StringStack.Pop;
    end;
  end else
  begin
    argRes.Kind := resError;
    StringStack.Push('');
    StringStack.Push(StringStack.Peek(1));
    result := EvalFunction;
    StringStack.Pop;
    StringStack.Pop;
  end;
end;
{$endif}

{$ifdef win32}
function TQREvaluator.EvalFactor(strFactorExpr : string) : TQREvResult;
var
  aString : string[255];
begin
  TrimString(strFactorExpr);
  aString := strFactorExpr;
  if (AnsiLowerCase(Copy(strFactorExpr, 1, 3)) = 'not') then
    result := NegateResult(EvalFactor(Copy(strFactorExpr, 4, Length(strFactorExpr))))
  else
    case aString[1] of
      '(' : if strFactorExpr[Length(strFactorExpr)] = ')' then
              result := Evaluate(Copy(strFactorExpr, 2, Length(strFactorExpr) - 2))
            else
              result.Kind := resError;
      '-' : result := NegateResult(EvalFactor(Copy(strFactorExpr, 2, Length(strFactorExpr))));
      '+' : result := EvalFactor(Copy(strFactorExpr, 2, Length(strFactorExpr)));
      '0'..'9' : result := EvalConstant(strFactorExpr);
      '''' : if aString[Length(strFactorExpr)] = '''' then
               result := EvalString(Copy(strFactorExpr, 2, Length(strFactorExpr) - 2))
             else
             begin
               result.Kind := resError;
               FiFo.Put(TQREvElementError.Create);
             end;
      '[' : if aString[Length(strFactorExpr)] = ']' then
              result := EvalVariable(Copy(strFactorExpr, 2, Length(strFactorExpr) - 2))
            else
              result.Kind := resError;
      'A'..'Z', 'a'..'z' : result := EvalFunctionExpr(strFactorExpr);
    else
    begin
      FiFo.Put(TQREvElementError.Create);
      result.Kind := resError;
    end;
  end;
end;
{$else}
function TQREvaluator.EvalFactor : TQREvResult;
begin
  if (AnsiLowerCase(Copy(StringStack.Peek(0), 1, 3)) = 'not') then
  begin
    StringStack.Push(Copy(StringStack.Peek(0), 4, Length(StringStack.Peek(0))));
    result := NegateResult(EvalFactor);
    StringStack.Pop;
  end else
    case StringStack.Peek(0)[1] of
      '(' : if StringStack.Peek(0)[Length(StringStack.Peek(0))] = ')' then
            begin
              StringStack.Push(Copy(StringStack.Peek(0), 2, Length(StringStack.Peek(0)) - 2));
              result := Evaluate;
              StringStack.Pop;
            end else
              result.Kind := resError;
      '-' : begin
              StringStack.Push(Copy(StringStack.Peek(0), 2, Length(StringStack.Peek(0))));
              result := NegateResult(EvalFactor);
              StringStack.Pop;
            end;
      '+' : begin
              StringStack.Push(Copy(StringStack.Peek(0), 2, Length(StringStack.Peek(0))));
              result := EvalFactor;
              StringStack.Pop;
            end;
      '0'..'9' :  result := EvalConstant;
      '''' : if StringStack.Peek(0)[Length(StringStack.Peek(0))] = '''' then
             begin
               StringStack.Push(Copy(StringStack.Peek(0), 2, Length(StringStack.Peek(0)) - 2));
               result := EvalString;
               StringStack.Pop;
             end else
             begin
               result.Kind := resError;
               FiFo.Put(TQREvElementError.Create);
             end;
      '[' : if StringStack.Peek(0)[Length(StringStack.Peek(0))] = ']' then
            begin
              StringStack.Push(Copy(StringStack.Peek(0), 2, Length(StringStack.Peek(0)) - 2));
              result := EvalVariable;
              StringStack.Pop;
            end else
              result.Kind := resError;
      'A'..'Z', 'a'..'z' : result := EvalFunctionExpr
    else
    begin
      FiFo.Put(TQREvElementError.Create);
      result.Kind := resError;
    end;
  end;
end;
{$endif}


{$ifdef win32}
function TQREvaluator.EvalSimpleExpr(const strSimplExpr : string) : TQREvResult;
var
  op : TQREvOperator;
  intStart,
  intLen : integer;
  Res1,
  Res2 : TQREvResult;
begin
  FindOp2(strSimplExpr, op, intStart, intLen);
  if intStart > 0 then
  begin
    FiFo.Put(TQREvElementOperator.CreateOperator(Op));
    Res1 := EvalTerm(Copy(strSimplExpr, 1, intStart - 1));
    Res2 := EvalSimpleExpr(Copy(strSimplExpr, intStart + intLen, Length(strSimplExpr)));
  end else
    result := EvalTerm(strSimplExpr);
end;
{$else}
function TQREvaluator.EvalSimpleExpr : TQREvResult;
var
  op : TQREvOperator;
  intStart,
  intLen : integer;
  Res1,
  Res2 : TQREvResult;
begin
  FindOp2(op, intStart, intLen);
  if intStart > 0 then
  begin
    FiFo.Put(TQREvElementOperator.CreateOperator(Op));
    StringStack.Push(Copy(StringStack.Peek(0), 1, intStart - 1));
    Res1 := EvalTerm;
    StringStack.Pop;
    StringStack.Push(Copy(StringStack.Peek(0), intStart + intLen, Length(StringStack.Peek(0))));
    Res2 := EvalSimpleExpr;
    StringStack.Pop;
  end else
    result := EvalTerm;
end;
{$endif}

{$ifdef win32}
function TQREvaluator.EvalTerm(const strTermExpr : string) : TQREvResult;
var
  op : TQREvOperator;
  intStart,
  intLen : integer;
  Res1,
  Res2 : TQREvResult;
begin
  FindOp3(strTermExpr, op, intStart, intLen);
  if intStart > 0 then
  begin
    FiFo.Put(TQREvElementOperator.CreateOperator(Op));
    Res1 := EvalFactor(Copy(strTermExpr, 1, intStart - 1));
    Res2 := EvalTerm(Copy(strTermExpr, intStart + intLen, Length(strTermExpr)));
  end else
    result := EvalFactor(strTermExpr);
end;
{$else}
function TQREvaluator.EvalTerm : TQREvResult;
var
  op : TQREvOperator;
  intStart,
  intLen : integer;
  Res1,
  Res2 : TQREvResult;
begin
  FindOp3(op, intStart, intLen);
  if intStart > 0 then
  begin
    FiFo.Put(TQREvElementOperator.CreateOperator(Op));
    StringStack.Push(Copy(StringStack.Peek(0), 1, intStart - 1));
    Res1 := EvalFactor;
    StringStack.Pop;
    StringStack.Push(Copy(StringStack.Peek(0), intStart + intLen, Length(StringStack.Peek(0))));
    Res2 := EvalTerm;
    StringStack.Pop;
  end else
    result := EvalFactor;
end;
{$endif}

{$ifdef win32}
function TQREvaluator.Evaluate(const strExpr : string) : TQREvResult;
var
  op : TQREvOperator;
  intStart,
  intLen : integer;
  Res1,
  Res2 : TQREvResult;
begin
  FindOp1(strExpr, op, intStart, intLen);
  if intStart > 0 then
  begin
    FiFo.Put(TQREvElementOperator.CreateOperator(Op));
    Res1 := EvalSimpleExpr(Copy(strExpr, 1, intStart - 1));
    Res2 := EvalSimpleExpr(Copy(strExpr, intStart + intLen, Length(strExpr)));
  end else
    result := EvalSimpleExpr(strExpr);
end;
{$else}
function TQREvaluator.Evaluate : TQREvResult;
var
  op : TQREvOperator;
  intStart,
  intLen : integer;
  Res1,
  Res2 : TQREvResult;
begin
  FindOp1(op, intStart, intLen);
  if intStart > 0 then
  begin
    FiFo.Put(TQREvElementOperator.CreateOperator(Op));
    StringStack.Push(Copy(StringStack.Peek(0), 1, intStart - 1));
    Res1 := EvalSimpleExpr;
    StringStack.Pop;
    StringStack.Push(Copy(StringStack.Peek(0), intStart + intLen, Length(StringStack.Peek(0))));
    Res2 := EvalSimpleExpr;
    StringStack.Pop;
  end else
    result := EvalSimpleExpr;
end;
{$endif}

procedure TQREvaluator.Prepare(const strExpr : string);
var
  Value : TQREvResult;
begin
  if Prepared then Unprepare;
  FiFo := TQRFiFo.Create;
{$ifndef win32}
  if strExpr = '' then
  begin
    StringStack.Push(''' ''');
    Value := Evaluate;
    StringStack.Pop;
  end else
  begin
    StringStack.Push(strExpr);
    Value := Evaluate;
    StringStack.Pop;
  end;
{$else}
  if strExpr = '' then
    Value := Evaluate(''' ''')
  else
    Value := Evaluate(strExpr);
{$endif}
  Prepared := true;
end;

procedure TQREvaluator.UnPrepare;
begin
  FiFo.Free;
  Prepared := false;
end;

procedure TQREvaluator.Reset;
var
  I : integer;
begin
  for I := 0 to FiFo.FiFo.Count - 1 do
    TQREvElement(FiFo.FiFo[I]).Reset;
end;

function TQREvaluator.Value : TQREvResult;
begin
  FiFo.Start;
  Result := TQREvElement(FiFo.Get).Value(FiFo);
end;

function TQREvaluator.GetIsAggreg : boolean;
var
  I : integer;
begin
  Result := false;
  for I := 0 to FiFo.FiFo.Count - 1 do
    Result := Result or TQREvElement(FiFo.FiFo[I]).IsAggreg;
end;

function TQREvaluator.GetAggregate : boolean;
begin
  Result := FiFo.Aggreg;
end;

procedure TQREvaluator.SetAggregate(Value : boolean);
begin
  FiFo.Aggreg := Value;
end;

function TQREvaluator.Calculate(const strExpr : string) : TQREvResult;
begin
  Prepare(strExpr);
  result := Value;
  UnPrepare;
end;

{ TQRPreviewImage }

constructor TQRPreviewImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Height := 50;
  Width := 100;
  Zoom := 100;
  QRPrinter := nil;
  ImageOK := false;
  FPageNumber := 1;
end;

destructor TQRPreviewImage.Destroy;
begin
  if ImageOK then
    aMetafile.Free;
  inherited Destroy;
end;

procedure TQRPReviewImage.PaintPage;
{$ifndef win32}
var
  DC,
  SavedDC : THandle;
  Inch : integer;
{$endif}
begin
  { Paint page background }
  if ImageOK or (csDesigning in ComponentState) then
    with Canvas do
    begin
      Brush.Color := clWhite;
      Pen.Color := clWhite;
      Rectangle(1, 1, Width - cQRPageFrameWidth - cQRPageShadowWidth, Height - cQRPageFrameWidth - cQRPageShadowWidth);
    end;
  if ImageOK then
  begin
    { Paint the metafile }
{$ifdef win32}
    Canvas.StretchDraw(rect(0, 0, Width, Height),aMetafile);
{$else}
    DC := Canvas.Handle;
    SavedDC := SaveDC(DC);
    SetMapMode(DC, MM_ANISOTROPIC);
    Inch := Screen.PixelsPerInch;
    SetWindowExtEx(DC, Inch, Inch, nil);
    Inch := round(Inch * Zoom / 100);
    SetViewportExtEx(DC, Inch, Inch, nil);
    SetViewPortOrg(DC,Left + cQRPageFrameWidth, Top + cQRPageFrameWidth);
    PlayMetafile(DC, aMetafile.Handle);
    RestoreDC(DC, SavedDC);
{$endif} {win32}
  end;
  { Paint frame around page }
  if ImageOK or (csDesigning in ComponentState) then
    with Canvas do
    begin
      Pen.Color := cQRPageShadowColor;
      Pen.Width := cQRPageFrameWidth;
      MoveTo(0,0);
      LineTo(0,Height - cQRPageFrameWidth - cQRPageShadowWidth);
      LineTo(Width - cQRPageFrameWidth - cQRPageShadowWidth, Height - cQRPageFrameWidth - cQRPageShadowWidth);
      LineTo(Width - cQRPageFrameWidth - cQRPageShadowWidth, 0);
      LineTo(0, 0);
      Brush.Color := cQRPageShadowColor;
      Rectangle(Width - cQRPageShadowWidth, cQRPageShadowWidth, Width, Height);
      Rectangle(cQRPageShadowWidth, Height - cqrPageShadowWidth, Width, Height);
    end;
end;

procedure TQRPreviewImage.Paint;
begin
  PaintPage;
end;

procedure TQRPreviewImage.SetPageNumber(Value : integer);
begin
  FPageNumber := Value;
  if assigned(aMetafile) then
    aMetafile.Free;
  aMetaFile := nil;
  if assigned(FQRPrinter) then
    aMetaFile := QRPrinter.GetPage(Value);
  ImageOK := aMetafile <> nil;
  PaintPage;
end;

{ TQRPreview }

constructor TQRPreview.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FPreviewImage := TQRPreviewImage.Create(self);
  FPreviewImage.Parent := self;
  with FPreviewImage do
  begin
    Top := 0;
    Left := 0;
  end;
{$ifdef win32}
  HorzScrollbar.Tracking := true;
  VertScrollBar.Tracking := true;
{$endif} {win32}
  FZoom := 100;
  FQRPrinter := nil;
  ZoomState := qrZoomOther{qrDefaultZoom};
  OnResize := FixValues;
  Height := 250;
  Width := 250;
  FPageNumber := 1;
  FOnPageAvailableEvent := nil;
  FOnProgressUpdateEvent := nil;
end;

destructor TQRPreview.Destroy;
begin
  if QRPrinter <> nil then QRPrinter := nil;
  inherited Destroy;
end;

procedure TQRPreview.SetQRPrinter(Value : TQRPrinter);
begin
  if assigned(FQRPrinter) and (FQRPrinter.MessageReceiver = self) then
  begin
    FQRPrinter.ShowingPreview := false;
    FQRPrinter.MessageReceiver := nil;
  end;
  FQRPrinter := Value;
  FPreviewImage.QRPrinter := Value;
  if FQRPrinter <> nil then
  begin
    FQRPrinter.MessageReceiver := self;
    FQRPrinter.ShowingPreview := true;
  end;
  PageNumber := 1;
  PreviewImage.PageNumber := 1;
  Invalidate;
  FPreviewImage.OnClick := OnClick;
  FPreviewImage.OnDblClick := OnDblClick;
  FPreviewImage.OnDragDrop := OnDragDrop;
  FPreviewImage.OnDragOver := OnDragOver;
  FPreviewImage.OnEndDrag := OnEndDrag;
  FPreviewImage.OnMouseDown := OnMouseDown;
  FPreviewImage.OnMouseMove := OnMouseMove;
  FPreviewImage.OnMouseUp := OnMouseUp;
end;

procedure TQRPreview.CMPageAvailable(var Message : TCM_QRPageAvailable);
begin
  if Message.PageCount = PageNumber then
    UpdateImage;
  if assigned(FOnPageAvailableEvent) then
  try
    FOnPageAvailableEvent(Self, Message.PageCount);
  finally
  end;
end;

procedure TQRPreview.CMProgressUpdate(var Message : TCM_QRProgressUpdate);
begin
  if assigned(FOnProgressUpdateEvent) then
  try
    FOnProgressUpdateEvent(Self, Message.Position);
  finally
  end;
end;

procedure TQRPreview.SetPageNumber(value : integer);
begin
  if ((Value <> FPageNumber) or (not PreviewImage.ImageOK)) and (Value > 0)
    and assigned(FQRPrinter) and (Value <= QRPrinter.PageCount) then
  begin
    FPreviewImage.PageNumber := Value;
    FPageNumber := Value;
    VertScrollBar.Position := 0;
    HorzScrollBar.Position := 0;
  end;
end;

procedure TQRPreview.UpdateImage;
begin
  if assigned(FPreviewImage) and not FPreviewImage.ImageOK and
    (FPreviewImage.PageNumber <= QRPrinter.AvailablePages) then
  begin
    ZoomToWidth;
    FPreviewImage.PageNumber := FPreviewImage.PageNumber;
  end;
end;

procedure TQRPreview.UpdateZoom;
begin
  if assigned(FQRPrinter) then
  begin
    with FPreviewImage do
    begin
      Width := round(QRPrinter.XSize(QRPrinter.PaperWidthValue / 100 * FZoom)) +
               cQRPageShadowWidth + cQRPageFrameWidth * 2;
      Height := round(QRPrinter.YSize(QRPrinter.PaperLengthValue / 100 * FZoom)) +
                cQRPageShadowWidth + cQRPageFrameWidth * 2;
    end
  end else
  begin
    with FPreviewImage do
    begin
      Width := round(cQRPaperSizeMetrics[Letter, 0] / 100 * FZoom) +
               cQRPageShadowWidth + cQRPageFrameWidth * 2;
      Height := round(cQRPaperSizeMetrics[Letter, 1] / 100 * FZoom) +
                cQRPageShadowWidth + cQRPageFrameWidth * 2;
    end;
  end;
  if FPreviewImage.Width < self.Width then
    FPreviewImage.Left := (width - FPreviewImage.width) div 2
  else
    FPreviewImage.Left := 0;
  if FPreviewImage.Height < Height then
    FPreviewImage.Top := ((Height - FPreviewImage.Height) div 2)
  else
    FPreviewImage.Top := 0;
  HorzScrollBar.Position := 0;
  VertScrollBar.Position := 0;
  FPreviewImage.Zoom := FZoom;
end;

procedure TQRPreview.FixValues(Sender : TObject);
begin
  if ZoomState = qrZoomToFit then
    ZoomToFit
  else
    if ZoomState = qrZoomToWidth then
      ZoomToWidth;
  UpdateZoom;
end;

procedure TQRPreview.SetZoom(Value:integer);
begin
  if (Value >= 2) and (Value <= 2000) then
  begin
    ZoomState := qrZoomOther;
    FZoom := Value;
    UpdateZoom;
  end;
end;

procedure TQRPreview.ZoomToFit;
var
  Zoom1,
  Zoom2 : Integer;
begin
  if assigned(FQRPrinter) then
  begin
    Zoom1 := round(Width / QRPrinter.XSize(QRPrinter.PaperWidthValue) * 95);
    Zoom2 := round(Height / QRPrinter.YSize(QRPrinter.PaperLengthValue) * 95);
  end else
  begin
    Zoom1 := round((Width / cQRPaperSizeMetrics[Letter, 0]) * 95);
    Zoom2 := round((Height / cQRPaperSizeMetrics[Letter, 1]) * 95);
  end;
  if Zoom1 < Zoom2 then
    Zoom := Zoom1
  else
    Zoom := Zoom2;
  ZoomState := qrZoomToFit;
end;

procedure TQRPreview.ZoomToWidth;
begin
  if assigned(FQRPrinter) then
    Zoom := round((Width / QRPrinter.XSize(QRPrinter.PaperWidthValue)) * 90)
  else
    Zoom := round((Width / cQRPaperSizeMetrics[Letter, 0]) * 95);
  UpdateZoom;
  ZoomState := qrZoomToWidth;
end;

{ TQRExportFilter }

constructor TQRExportFilter.Create(Filename : string);
begin
  inherited Create;
  FFilename := Filename;
  FOwner := nil;
end;

function TQRExportFilter.GetDescription : string;
begin
  result := LoadStr(SqrAbstractFilterDescription);
end;

function TQRExportFilter.GetExtension : string;
begin
  result := '';
end;

function TQRExportFilter.GetFilterName : string;
begin
  result := LoadStr(SqrAbstractFilterName);
end;

function TQRExportFilter.GetVendorName : string;
begin
  result := LoadStr(SqrQSD);
end;

procedure TQRExportFilter.Start(PaperWidth, PaperHeight : integer; Font : TFont);
begin
end;

procedure TQRExportFilter.EndPage;
begin
end;

procedure TQRExportFilter.Finish;
begin
end;

procedure TQRExportFilter.NewPage;
begin
end;

procedure TQRExportFilter.TextOut(X,Y : extended; Font : TFont; BGColor : TColor; Alignment : TAlignment; Text : string);
begin
end;

{ TQRExportFilterLibrary }

constructor TQRExportFilterLibrary.Create;
begin
  inherited Create;
  FFilterList := TList.Create;
end;

destructor TQRExportFilterLibrary.destroy;
begin
  FFilterList.Free;
  inherited Destroy;
end;

procedure TQRExportFilterLibrary.AddFilter(AFilter : TQRExportFilterClass);
var
  aTmpFilter : TQRExportFilter;
  aLibraryEntry : TQRExportFilterLibraryEntry;
begin
  aTmpFilter := AFilter.Create('');
  aLibraryEntry := TQRExportFilterLibraryEntry.Create;
  aLibraryEntry.ExportFilterClass := AFilter;
  aLibraryEntry.FilterName := aTmpFilter.Name;
  aLibraryEntry.Extension := aTmpFilter.FileExtension;
  aTmpFilter.Free;
  FFilterList.Add(aLibraryEntry);
end;

function TQRExportFilterLibrary.GetSaveDialogFilter : string;
var
  I : integer;
begin
  result := LoadStr(SqrQRFile)+ '(*.' +cQRPDefaultExt + ')|*.' + cqrDefaultExt;
  for I := 0 to Filters.Count - 1 do
    with TQRExportFilterLibraryEntry(Filters[I]) do
        result := result + '|' + FilterName + ' (*.' + Extension + ')|*.' + Extension;
end;

{ TPrinterSettings }

constructor TPrinterSettings.Create;
begin
  inherited Create;
  GetMem(FDevice,128);
  GetMem(FDriver,128);
  GetMem(FPort,128);
  FPaperSize := A4;
  FPrinter := nil;
end;

destructor TPrinterSettings.Destroy;
begin
  FreeMem(FDevice,128);
  FreeMem(FDriver,128);
  FreeMem(FPort,128);
  inherited Destroy;
end;

function TPrinterSettings.GetCopies : integer;
begin
  Result := FCopies;
end;

function TPrinterSettings.GetDriver : string;
begin
  Result := StrPas(FDriver);
end;

function TPrinterSettings.GetDuplex : boolean;
begin
  Result := FDuplex;
end;

function TPrinterSettings.GetMaxExtentX : integer;
begin
  Result := FMaxExtentX;
end;

function TPrinterSettings.GetMaxExtentY : integer;
begin
  Result := FMaxExtentY;
end;

function TPrinterSettings.GetMinExtentX : integer;
begin
  Result := FMinExtentX;
end;

function TPrinterSettings.GetMinExtentY : integer;
begin
  Result := FMinExtentY;
end;

function TPrinterSettings.GetOrientation : TPrinterOrientation;
begin
  Result := FOrientation;
end;

function TPrinterSettings.GetOutputBin : TQRBin;
begin
  Result := FOutputBin;
end;

function TPrinterSettings.GetPaperSize : TQRPaperSize;
begin
  Result := FPaperSize;
end;

function TPrinterSettings.GetPaperSizeSupported(PaperSize : TQRPaperSize) : boolean;
begin
  result := FPaperSizes[PaperSize];
end;

function TPrinterSettings.GetPaperWidth : integer;
begin
  if (PaperSize <> Custom) and (PaperSize <> Default) then
    Result := round(cQRPaperSizeMetrics[PaperSize, 0] * 10)
  else
    Result := FPaperWidth;
end;

function TPrinterSettings.GetPaperLength : integer;
begin
  if (PaperSize <> Custom) and (PaperSize <> Default) then
    Result := round(cQRPaperSizeMetrics[PaperSize, 1] * 10)
  else
    Result := FPaperLength;
end;

function TPrinterSettings.GetPixelsPerX : integer;
begin
  Result := FPixelsPerX;
end;

function TPrinterSettings.GetPixelsPerY : integer;
begin
  Result := FPixelsPerY;
end;

function TPrinterSettings.GetPort : string;
begin
  Result := StrPas(FPort);
end;

function TPrinterSettings.GetTopOffset : integer;
begin
  Result := FTopOffset;
end;

function TPrinterSettings.GetLeftOffset : integer;
begin
  Result := FLeftOffset;
end;

function TPrinterSettings.GetPrinter : TPrinter;
begin
  Result := FPrinter;
end;

function TPrinterSettings.GetTitle : string;
begin
  Result := FTitle;
end;

function TPrinterSettings.Supported(Setting : integer) : boolean;
begin
  if assigned(FPrinter) then
    Supported := (DevMode^.dmFields and Setting) = Setting
  else
    Supported := false;
end;

procedure TPrinterSettings.SetField(aField : integer);
begin
  DevMode^.dmFields := DevMode^.dmFields or aField;
end;

procedure TPrinterSettings.GetPrinterSettings;

  procedure GPrinter;
{$ifdef win32}
  var
    Driver_info_2 : pDriverinfo2;
    Retrieved : dword;
    hPrinter : THandle;
{$endif}

  begin
    FPrinter.GetPrinter(FDevice, FDriver, FPort, DeviceMode);
    if DeviceMode = 0 then
      FPrinter.GetPrinter(FDevice, FDriver, FPort, DeviceMode);
{$ifdef win32}
    OpenPrinter(FDevice, hPrinter, nil);
    GetMem(Driver_info_2, 255);
    GetPrinterDriver(hPrinter, nil, 2, Driver_info_2, 255, Retrieved);
    StrLCopy(FDriver, PChar(ExtractFileName(StrPas(Driver_info_2^.PDriverPath)) + #0), 63);
    FreeMem(Driver_info_2, 255);
{$endif}
    DevMode := GlobalLock(DeviceMode);
  end;

  procedure GCopies; { Number of copies }
  begin
    if Supported(dm_copies) then
      FCopies := DevMode^.dmCopies
    else
      FCopies := 1;
  end;

  procedure GBin; { Paper bin }
  var
    aBin : integer;
    I : TQRBin;
  begin
    FOutputBin := First;
    if Supported(dm_defaultsource) then
    begin
      aBin := DevMode^.dmDefaultSource;
      for I := First to Last do
      begin
        if cQRBinTranslate[I] = aBin then
        begin
          FOutputBin := I;
          exit;
        end
      end
    end
  end;

  procedure GDuplex; { Duplex }
  begin
    if Supported(dm_duplex) and (DevMode^.dmDuplex <> dmdup_simplex) then
      FDuplex := true
    else
      FDuplex := false;
  end;

  procedure GPixelsPer; { Horizontal and Vertical pixels per inch }
  begin
    FPixelsPerX := GetDeviceCaps(FPrinter.Handle, LOGPIXELSX);
    FPixelsPerY := GetDeviceCaps(FPrinter.Handle, LOGPIXELSY);
  end;

  procedure GOffset; { Top left printing offset (waste) }
  var
    PrintOffset: TPoint;
    EscapeFunc: word;
  begin
    EscapeFunc := GetPrintingOffset;
    if Escape(FPrinter.Handle,QueryEscSupport,SizeOf(EscapeFunc), @EscapeFunc,nil) <> 0 then
    begin
      Escape(FPrinter.Handle,GetPrintingOffset,0,nil,@PrintOffset);
      FLeftOffset := round(PrintOffset.X/PixelsPerX*254);
      FTopOffset := round(PrintOffset.Y/PixelsPerY*254);
    end else
    begin
      FLeftOffset := 0;
      FTopOffset := 0;
    end;
  end;

  procedure GPaperSize;
  var
    aSize : integer;
    I : TQRPaperSize;
  begin
    FPaperSize := Default;
    if Supported(dm_papersize) then
    begin
      aSize := DevMode^.dmPaperSize;
      for I := Default to Custom do
      begin
        if aSize=cQRPaperTranslate[I] then
        begin
          FPaperSize := I;
          exit;
        end
      end
    end
  end;

  procedure GPaperDim;
  var
    PSize : TPoint;
    EscapeFunc : word;
  begin
    EscapeFunc := GetPhysPageSize;
    if Escape(FPrinter.Handle, QueryEscSupport, SizeOf(EscapeFunc), @EscapeFunc, nil) <> 0 then
    begin
      Escape(FPrinter.Handle, GetPhysPageSize, 0, nil, @PSize);
      FPaperWidth := round(PSize.X / PixelsPerX * 254);
      FPaperLength := round(PSize.Y / PixelsPerY * 254);
    end else
    begin
      FPaperWidth := 0;
      FPaperLength := 0;
    end
  end;

  procedure GPaperSizes;
  var
{ Bug - Get PaperSize error - Begin}
    DCResult : array[0..255] of word;
{    DCResult : array[0..64] of word; }
{ Bug - Get PaperSize error - End}
    I : integer;
    J : TQRPaperSize;
    Count : integer;
{$ifndef win32}
   DeviceCapabilities : TDeviceCapabilities;
   FDeviceHandle : THandle;
   DriverName: array[0..255] of Char;
{$endif}
  begin
    Fillchar(DCResult,SizeOf(DCResult),#0);
    Fillchar(FPaperSizes,Sizeof(FPaperSizes),#0);
{$ifdef win32}
    Count := DeviceCapabilities(FDevice, FPort, DC_PAPERS, @DCResult, DevMode);
{$else}
    StrCat(StrCopy(DriverName, FDriver), '.DRV');
    FDeviceHandle := LoadLibrary(DriverName);
    if FDeviceHandle <= 16 then FDeviceHandle := 0;
    if FDeviceHandle <> 0 then
    begin
      @DeviceCapabilities := GetProcAddress(FDeviceHandle, 'DeviceCapabilities');
      if assigned(DeviceCapabilities) then
        Count := DeviceCapabilities(FDevice, FPort, DC_PAPERS, @DCResult, DevMode^)
      else
        Count := 0;
   end;
   if FDeviceHandle <> 0 then FreeLibrary(FDeviceHandle);
{$endif}
    for I := 0 to Count - 1 do
    begin
      for J := Default to Custom do
      begin
        if cQRPaperTranslate[J] = DCResult[I] then
        begin
          FPaperSizes[J] := true;
          break;
        end
      end
    end
  end;

begin
  if FPrinter<>nil then
  begin
    GPrinter;
    GPixelsPer;
    GCopies;
    GBin;
    GDuplex;
    GOffset;
    GPaperSize;
    GPaperDim;
    GPaperSizes;
    GlobalUnlock(DeviceMode);
  end
end;

procedure TPrinterSettings.ApplySettings;
begin
  FPrinter.GetPrinter(FDevice, FDriver, FPort, DeviceMode);
  DevMode := GlobalLock(DeviceMode);
  if PaperSize = Custom then
  begin
    if Supported(dm_paperlength) then
    begin
      SetField(dm_paperlength);
      DevMode^.dmPaperLength := PaperLength;
    end;
    if Supported(dm_PaperWidth) then
    begin
      SetField(dm_paperwidth);
      DevMode^.dmPaperWidth := PaperWidth;
    end
  end;

  if Supported(dm_PaperSize) and
     (PaperSize <> Default) then
  begin
    SetField(dm_papersize);
    DevMode^.dmPaperSize := cQRPaperTranslate[PaperSize];
  end;

  if Supported(dm_copies) then
  begin
    SetField(dm_copies);
    DevMode^.dmCopies := FCopies;
  end;

  if Supported(dm_defaultsource) then
  begin
    SetField(dm_defaultsource);
    DevMode^.dmDefaultSource := cQRBinTranslate[OutputBin];
  end;

  if Supported(dm_orientation) then
  begin
    SetField(dm_orientation);
    if Orientation=poPortrait then
      DevMode^.dmOrientation := dmorient_portrait
    else
      DevMode^.dmOrientation := dmorient_landscape;
  end;
  FPrinter.SetPrinter(FDevice, FDriver, FPort, DeviceMode);
  GlobalUnlock(DeviceMode);
end;

procedure TPrinterSettings.SetCopies(Value : integer);
begin
  if Supported(dm_copies) then
    FCopies := Value;
end;

procedure TPrinterSettings.SetDuplex(Value : boolean);
begin
  if Supported(dm_duplex) then
    FDuplex := Value;
end;

procedure TPrinterSettings.SetOrientation(Value : TPrinterOrientation);
begin
  if Supported(dm_orientation) then
    FOrientation := Value;
end;

procedure TPrinterSettings.SetOutputBin(Value : TQRBin);
begin
  if Supported(dm_defaultsource) then
    FOutputBin := Value;
end;

procedure TPrinterSettings.SetPaperSize(Value : TQRPaperSize);
begin
  if PaperSizeSupported[Value] then
    FPaperSize := Value
  else
    if (Value = Default) then
      FPaperSize := Default;
end;

procedure TPrinterSettings.SetPaperLength(Value : integer);
begin
  if PaperSize = Custom then
    FPaperLength := Value;
end;

procedure TPrinterSettings.SetPaperWidth(Value : integer);
begin
  if PaperSize = Custom then
    FPaperWidth := Value;
end;

procedure TPrinterSettings.SetPrinter(Value : TPrinter);
begin
  FPrinter := Value;
  if (Value <> nil) and (FPrinter.Printers.Count > 0) then
    GetPrinterSettings;
end;

procedure TPrinterSettings.SetTitle(Value : string);
begin
  FTitle := Value;
end;

{ TQRPrinterSettings }

constructor TQRPrinterSettings.Create;
begin
  PaperSize := Letter;
  Copies := 1;
  Duplex := false;
  Title := '';
  FFirstPage := 0;
  FLastPage := 0;
  FPrinterIndex := -1;
end;

procedure TQRPrinterSettings.ApplySettings(APrinter : TQRPrinter);
begin
  aPrinter.PrinterIndex := PrinterIndex;
  aPrinter.PaperSize := PaperSize;
  aPrinter.Copies := Copies;
  aPrinter.Duplex := Duplex;
  aPrinter.Orientation := Orientation;
  aPrinter.OutputBin := OutputBin;
  aPrinter.Title := Title;
end;

{ TQRPrinter }

constructor TQRPrinter.Create;
begin
{$ifdef eval}
  if not DelphiRunning then
  begin
    ShowMessage('This evaluation copy of QuickReport only works while Delphi is running. '+
                'Please contact QuSoft to order a full version');
    Application.Terminate;
  end;
{$endif}
  FPrinterOK := Printer.Printers.Count > 0;
  aPrinter := TPrinter.Create;
  aPrinterSettings := TPrinterSettings.Create;
  if PrinterOK then
  begin
    aPrinterSettings.Printer := aPrinter;
    aPrinter.PrinterIndex := Printer.PrinterIndex;
  end;
  FTopWaste := aPrinterSettings.TopOffset;
  FLeftWaste := aPrinterSettings.LeftOffset;
  FDestination := qrdMetafile;
  FStatus := mpReady;
  FPageNumber := 0;
  PageList := TQRPageList.Create;
{  FOnProgressChangeEvent := nil;}
  FAvailablePages := 0;
  FXFactor := 1;
  FYFactor := 1;
  FMessageReceiver := nil;
  FAfterPreviewEvent := nil;
  FAfterPrintEvent := nil;
  FShowingPreview := false;
end;

destructor TQRPrinter.Destroy;
begin
  if Status <> mpReady then
    Cleanup;
  aPrinter.Free;
  aPrinterSettings.Free;
  PageList.Free;
  inherited Destroy;
end;

procedure TQRPrinter.Cleanup;
begin
  if Status = mpBusy then
    Cancel;
  if assigned(aStream) then
  begin
    aStream.Free;
    aStream := nil;
  end;
  PageList.Clear;
  FStatus := mpReady;
end;

function TQRPrinter.XPos(Value : extended) : integer;
begin
  result := round((Value - FLeftWaste) * XFactor);
end;

function TQRPrinter.XSize(Value : extended) : integer;
begin
  result := round(Value * XFactor);
end;

function TQRPrinter.YPos(Value : extended) : integer;
begin
  result := round((Value - FTopWaste) * YFactor);
end;

function TQRPrinter.YSize(Value : extended) : integer;
begin
  result := round(Value * YFactor);
end;

function TQRPrinter.GetCompression : boolean;
begin
  Result := PageList.Compression;
end;

procedure TQRPrinter.SetCompression(Value : boolean);
begin
  PageList.Compression := Value;
end;

{ TQRPrinter methods related to printer driver settings }

function TQRPrinter.GetBin : TQRBin;
begin
  Result := aPrinterSettings.OutputBin;
end;

function TQRPrinter.GetCopies;
begin
  Result := aPrinterSettings.Copies;
end;

function TQRPrinter.GetDuplex : boolean;
begin
  Result := aPrinterSettings.Duplex;
end;

function TQRPrinter.GetLeftWaste : integer;
{ Return left unprintable area in 0.1 mm }
begin
  if Destination=qrdPrinter then
    Result := aPrinterSettings.LeftOffset
  else
    Result := 0;
end;

function TQRPrinter.GetOrientation : TPrinterOrientation;
begin
  Result := aPrinterSettings.Orientation;
end;

function TQRPrinter.GetPaperLength : integer;
{ Return physical paper length in 0.1 mm }
begin
  Result := aPrinterSettings.PaperLength;
end;

function TQRPrinter.PaperLengthValue : integer;
begin
  if Orientation = poPortrait then
  begin
    if (PaperSize <> Custom) and (PaperSize <> Default) then
      result := round(cqrPaperSizeMetrics[PaperSize, 1] * 10)
    else
      result := PaperLength;
  end else
  begin
    if aPrinterSettings.PaperSize<>Custom then
      result := round(cqrPaperSizeMetrics[PaperSize, 0] * 10)
    else
      result := PaperWidth;
  end;
end;

function TQRPrinter.PaperWidthValue : integer;
begin
  if Orientation = poPortrait then
  begin
    if (PaperSize <> Custom) and (PaperSize <> Default) then
      result := round(cqrPaperSizeMetrics[PaperSize, 0] * 10)
    else
      result := PaperWidth;
  end else
  begin
    if PaperSize<>Custom then
      result := round(cqrPaperSizeMetrics[PaperSize, 1] * 10)
    else
      result := PaperLength;
  end;
end;

function TQRPrinter.GetPaperWidth : integer;
{ Return physical paper width in 0.1 mm }
begin
  Result := aPrinterSettings.PaperWidth;
end;

function TQRPrinter.GetPaperSize : TQRPaperSize;
{ Return currently selected paper size }
begin
  Result := aPrinterSettings.PaperSize;
end;

function TQRPrinter.GetPrinterIndex : integer;
{ Return currently selected printer }
begin
  result := aPrinter.PrinterIndex;
end;

function TQRPrinter.GetPrinters : TStrings;
{ Return list of printers }
begin
  result := aPrinter.Printers;
end;

function TQRPrinter.GetTopWaste : integer;
{ Return unprintable area on top in 0.1 mm }
begin
  if Destination=qrdPrinter then
    Result := aPrinterSettings.TopOffset
  else
    Result := 0;
end;

procedure TQRPrinter.SetBin(Value : TQRBin);
begin
  aPrinterSettings.Outputbin := Value;
end;

procedure TQRPrinter.SetCopies(Value : integer);
begin
  aPrinterSettings.Copies := Value;
end;

procedure TQRPrinter.SetDestination(Value : TQRPrinterDestination);
begin
  FDestination := Value;
end;

procedure TQRPrinter.SetDuplex(Value : Boolean);
begin
  aPrinterSettings.Duplex := Value;
end;

procedure TQRPrinter.SetOrientation(Value : TPrinterOrientation);
begin
  aPrinterSettings.Orientation := Value;
end;

procedure TQRPrinter.SetPaperWidth(Value : integer);
{ Sets the paper width in 0.01 mm }
begin
  aPrinterSettings.PaperWidth := Value;
end;

function TQRPrinter.GetPage(Value : integer) : TMetafile;
begin
  if (Status in [mpBusy, mpFinished]) and
     (Value > 0) and (Value <= FPageCount) then
    Result := PageList.GetPage(Value)
  else
    Result := nil;
end;

procedure TQRPrinter.SetPageNumber(Value : integer);
begin
  if (PageNumber > 0) and (PageNumber <= FPageCount) then
  begin
    FPage := GetPage(Value);
    FPageNumber := Value;
  end;
end;

procedure TQRPrinter.SetPaperLength(Value : integer);
{ Sets the paper length in 0.1 mm }
begin
  aPrinterSettings.PaperLength := Value;
end;

procedure TQRPrinter.SetPaperSize(Value : TQRPaperSize);
begin
  aPrinterSettings.PaperSize := Value;
end;

procedure TQRPrinter.SetPrinterIndex(Value : integer);
begin
  if PrinterOK then
  begin
    aPrinter.PrinterIndex := Value;
    aPrinterSettings.GetPrinterSettings;
  end;
end;

{ TQRPrinter methods related to printing }

function TQRPrinter.GetCanvas;
begin
  result := FCanvas;
end;

procedure TQRPrinter.CreateMetafileCanvas;
begin
{$ifdef win32}
  FMetafile := TMetafile.Create;
  FMetafile.Width := XSize(PaperWidthValue);
  FMetafile.Height := YSize(PaperLengthValue);
  FCanvas := TMetafileCanvas.Create(FMetafile, 0);
{$else}
  FCanvas := TCanvas.Create;
  FCanvas.Handle := CreateMetafile(nil);
{$endif}
end;

function TQRPrinter.CurrentPageOK : boolean;
begin
  Result := true;
  if (FirstPage > 0) and (PageCount < FirstPage) then
    Result := false;
  if (LastPage > 0) and (PageCount > LastPage) then
    Result := false;
end;

procedure TQRPrinter.CreatePrinterCanvas;
begin
  if not aPrinter.Printing then
  begin
{    aPrinter.PrinterIndex := -1;}
    aPrinter.Title := Title;
    aPrinter.BeginDoc;
    FCanvas := aPrinter.Canvas;
  end else
  begin
    StartPage(aPrinter.Handle);
    FCanvas := aPrinter.Canvas;
    Canvas.Refresh;
  end;
end;

procedure TQRPrinter.EndMetafileCanvas;
begin
{$ifndef win32}
  FMetafile := TMetafile.Create;
  FMetafile.Handle := CloseMetafile(Canvas.Handle);
{$endif}
  Canvas.Free;
end;

procedure TQRPrinter.EndPrinterCanvas;
begin
  if aPrinter.Printing then
    aPrinter.NewPage;
{   EndPage(aPrinter.Handle);}
end;

procedure TQRPrinter.NewPage;
begin
  if Status <> mpBusy then
    raise EQRError.Create(LoadStr(SqrIllegalNewPage));
  if PageNumber > 0 then
  begin
    case Destination of
      qrdMetafile: begin
                    EndMetafileCanvas;
                    PageList.AddPage(FMetafile);
                    FMetafile.Free;
                  end;
      qrdPrinter: begin
                    if CurrentPageOK then
                      EndPrinterCanvas
                    else
                    begin
                      EndMetafileCanvas;
                      FMetaFile.Free;
                    end;
                  end;
    end;
    AvailablePages := AvailablePages + 1;
  end;
  inc(FPageCount);
  inc(FPageNumber);
  case Destination of
    qrdMetafile : CreateMetafileCanvas;
    qrdPrinter : if CurrentPageOK then
                   CreatePrinterCanvas
                 else
                   CreateMetafileCanvas;
  end;
end;

procedure TQRPrinter.Cancel;
begin
  Cancelled := true;
end;

procedure TQRPrinter.BeginDoc;
begin
  FAvailablePages := 0;
  FCancelled := false;
  FTopWaste := TopWaste;
  FLeftWaste := LeftWaste;
  if Destination = qrdPrinter then
    aPrinterSettings.ApplySettings;
  if Status <> mpReady then
    raise EQRError.Create(LoadStr(SqrQRPrinterNotReady))
  else
  begin
    FPageNumber := 0;
    FPageCount := 0;
    FStatus := mpBusy;
    case Destination of
      qrdMetafile : begin
                      aStream := TQRStream.Create(100000);
                      PageList.Stream := aStream;
                      YFactor := {1 / 2.54} Screen.PixelsPerInch / 254;
                      XFactor := YFactor;
                    end;
      qrdPrinter : begin
                     XFactor := GetDeviceCaps(aPrinter.Handle, LogPixelsX) / 254;
                     YFactor := GetDeviceCaps(aPrinter.Handle, LogPixelsY) / 254;
                   end;
    end;
  end;
end;

procedure TQRPrinter.SetAvailablePages(Value : integer);
begin
  FAvailablePages := Value;
  if MessageReceiver <> nil then
    PostMessage(MessageReceiver.Handle, CM_QRPAGEAVAILABLE, Value, 0);
end;

procedure TQRPrinter.SetProgress(Value : integer);
begin
  FProgress := Value;
  if MessageReceiver <> nil then
    PostMessage(MessageReceiver.Handle, CM_QRPROGRESSUPDATE, Value, 0)
end;

procedure TQRPrinter.SetShowingPreview(Value : boolean);
begin
  if ShowingPreview and not Value then
  try
    if Status = mpBusy then Cancel;
    if assigned(FAfterPreviewEvent) then
      FAfterPreviewEvent(Self);
  finally
    FShowingPreview := Value;
  end else
    FShowingPreview := Value;
end;

procedure TQRPrinter.EndDoc;
begin
  case Destination of
    qrdPrinter : aPrinter.EndDoc;
    qrdMetafile : begin
                    if FPageCount > 0 then
                    begin
                      EndMetafileCanvas;
                      PageList.AddPage(FMetafile);
                      FMetafile.Free;
                    end;
                  end;
  end;
  AvailablePages := AvailablePages + 1;
  FStatus := mpFinished;
  if Destination = qrdMetafile then
    PageList.Finish
  else
    if assigned(FAfterPrintEvent) then
    try
      FAfterPrintEvent(Self);
    finally
    end;
end;

procedure TQRPrinter.AbortDoc;
begin
  case Destination of
    qrdPrinter : aPrinter.Abort;
    qrdMetafile : begin
                    if FPageCount>0 then
                    begin
                      EndMetafileCanvas;
                      FMetafile.Free;
                    end;
                  end;
  end;
  FStatus := mpFinished;
end;

procedure TQRPrinter.Load(Filename : string);
begin
  if Status <> mpReady then
    CleanUp;
  PageList := TQRPageList.Create;
  PageList.LoadFromFile(Filename);
  FPageCount := PageList.PageCount;
  aStream := PageList.Stream;
  FStatus := mpFinished;
  FOnGenerateToPrinterEvent := nil;
  FOnPrintSetupEvent := nil;
  FOnExportToFilterEvent := nil;
end;

procedure TQRPrinter.Save(Filename : string);
begin
  if Status=mpFinished then
    PageList.SaveToFile(Filename);
end;

procedure TQRPrinter.ExportToFilter(AFilter : TQRExportFilter);
begin
  if assigned(FOnExportToFilterEvent) then
    FOnExportToFilterEvent(AFilter);
end;

procedure TQRPrinter.Preview;
begin
  if assigned(FOnPreviewEvent) then
  try
    FOnPreviewEvent(Self)
  finally
  end else
    TQRStandardPreview.CreatePreview(Application, Self).Show;
end;

procedure TQRPrinter.Print;
type
  TSmallPoint = record
    X,
    Y : integer;
  end;
var
  I : integer;
{$ifndef win32}
  DC : THandle;
  SavedDC : THandle;
  aPoint : TSmallPoint;
  Count : integer;
{$endif}
begin
{$ifdef EVAL}
  if not DelphiRunning then
    MessageDlg('Unregistered evaluation copy - Printing is only allowed while Delphi is running',mtWarning,[mbOK],0)
  else
{$endif}
    if assigned(FOnGenerateToPrinterEvent) then
      FOnGenerateToPrinterEvent
    else
      if (Status = mpFinished) and PrinterOK then
      try
        APrinter.Title := Title;
        if APrinter.Printing then
          APrinter.Abort;
        APrinter.BeginDoc;
        for I := 1 to PageCount do
        begin
          Application.ProcessMessages;
          PageNumber := I;
{$ifdef win32}
          APrinter.Canvas.StretchDraw(Rect(0, 0, APrinter.PageWidth, APrinter.PageHeight), GetPage(I));
{$else}
          DC := APrinter.Canvas.Handle;
          SavedDC := SaveDC(DC);
          SetMapMode(DC, MM_ANISOTROPIC);
          SetViewportExtEx(DC, aPrinterSettings.PixelsPerX, aPrinterSettings.PixelsPerY, nil);
          SetWindowExtEx(DC, Screen.PixelsPerinch, Screen.PixelsPerInch, nil);
          Escape(DC, GETPRINTINGOFFSET, Count, @aPoint, @aPoint);
          SetViewportOrgEx(DC, -aPoint.X, -aPoint.Y, nil);
{          SetWindowOrgEx(DC, 0, 0, nil);}
          PlayMetaFile(DC, Page.Handle);
          RestoreDC(DC, SavedDC);
{$endif}
          APrinter.NewPage;
          if Cancelled then
            APrinter.Abort;
        end
      finally
        if APrinter.Printing then
          APrinter.EndDoc;
      end;
end;

procedure TQRPrinter.PrintSetup;
begin
  if assigned(FOnPrintSetupEvent) then
    FOnPrintSetupEvent;
end;

procedure RegisterQRFunction(FunctionClass : TQRLibraryItemClass; Name, Description, Vendor, Arguments : string);
begin
  QRFunctionLibrary.Add(FunctionClass, Name, Description, Vendor, Arguments);
end;

function QRPrinter : TQRPRinter;
begin
  if FQRPrinter = nil then
    FQRPrinter := TQRPrinter.Create;
  Result := FQRPrinter;
end;

initialization
  ArgSeparator := ',';
  FQRPrinter := nil;

  QRExportFilterLibrary := TQRExportFilterLibrary.Create;
  QRFunctionLibrary := TQRFunctionLibrary.Create;

  { Register QREvaluator functions }
  RegisterQRFunction(TQREvIfFunction,'IF',
    'IF(<Exp>, <X>, <Y>)|' + LoadStr(SqrIfDesc), LoadStr(SqrQSD), '5BVV');
  RegisterQRFunction(TQREvStrFunction, 'STR', 'STR(<X>)|' + LoadStr(SqrStrDesc), LoadStr(SqrQSD), '7N');
  RegisterQRFunction(TQREvUpperFunction, 'UPPER', 'UPPER(<X>)|' + LoadStr(SqrUpperDesc), LoadStr(SqrQSD), '7S');
  RegisterQRFunction(TQREvLowerFunction, 'LOWER', 'LOWER(<X>)|' + LoadStr(SqrLowerDesc), LoadStr(SqrQSD), '7S');
  RegisterQRFunction(TQREvPrettyFunction, 'PRETTY', 'PRETTY(<X>)|' + LoadStr(SqrPrettyDesc), LoadStr(SqrQSD), '7S');
  RegisterQRFunction(TQREvTimeFunction, 'TIME', 'TIME|' + LoadStr(SqrTimeDesc), LoadStr(SqrQSD), '1');
  RegisterQRFunction(TQREvDateFunction, 'DATE', 'DATE|' + LoadStr(SqrDateDesc), LoadStr(SqrQSD), '1');
  RegisterQRFunction(TQREvCopyFunction, 'COPY', 'COPY(<X>, <St>,<Len>)|' + LoadStr(SqrCopyDesc), LoadStr(SqrQSD), '7SNN');
  RegisterQRFunction(TQREvSumFunction, 'SUM', 'SUM(<X>)|' + LoadStr(SqrSumDesc), LoadStr(SqrQSD), '3N');
  RegisterQRFunction(TQREvCountFunction, 'COUNT', 'COUNT|'+ LoadStr(SqrCountDesc), LoadStr(SqrQSD), '3');
  RegisterQRFunction(TQREvMaxFunction, 'MAX', 'MAX(<X>)|' + LoadStr(SqrMaxDesc), LoadStr(SqrQSD), '3V');
  RegisterQRFunction(TQREvMinFunction, 'MIN', 'MIN(<X>)|' + LoadStr(SqrMinDesc), LoadStr(SqrQSD), '3V');
  RegisterQRFunction(TQREvAverageFunction, 'AVERAGE', 'AVERAGE(<X>)|' + LoadStr(SqrAverageDesc), LoadStr(SqrQSD), '3N');
  RegisterQRFunction(TQREvTrue, 'TRUE', 'TRUE|' + LoadStr(SqrBoolDesc), LoadStr(SqrQSD), '5');
  RegisterQRFunction(TQREvFalse, 'FALSE', 'FALSE|' + LoadStr(SqrBoolDesc), LoadStr(SqrQSD), '5');
  RegisterQRFunction(TQREvIntFunction, 'INT', 'INT(<X>)|' + LoadStr(SqrIntDesc), LoadStr(SqrQSD), '2N');
  RegisterQRFunction(TQREvFracFunction, 'FRAC', 'FRAC(<X>)|' + LoadStr(SqrFracDesc), LoadStr(SqrQSD), '2N');
  RegisterQRFunction(TQREvSQRTFunction, 'SQRT', 'SQRT(<X>)|' + LoadStr(SqrSqrtDesc), LoadStr(SqrQSD), '2N');
  RegisterQRFunction(TQREvTypeOfFunction, 'TYPEOF', 'TYPEOF(<Exp>)|' + LoadStr(SqrTypeofDesc), LoadStr(SqrQSD), '6N');
  RegisterQRFunction(TQREvFormatNumericFunction,'FORMATNUMERIC', 'FORMATNUMERIC(<F>,<N>|' + LoadStr(SqrFormatNumericDesc),
                     LoadStr(SqrQSD), '7SN');
Finalization
{ Fee Resource allocate by FQRPrinter }
  if FQRPrinter <> nil then
    FQRPrinter.Free;
end.
