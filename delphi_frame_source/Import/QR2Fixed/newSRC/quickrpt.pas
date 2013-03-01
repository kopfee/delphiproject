{ :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: QuickReport 2.0 for Delphi 1.0/2.0/3.0                  ::
  ::                                                         ::
  :: QUICKRPT.PAS - MAIN UNIT                                ::
  ::                                                         ::
  :: Copyright (c) 1997 QuSoft AS                            ::
  :: All Rights Reserved                                     ::
  ::                                                         ::
  :: web: http://www.qusoft.no   mail: support@qusoft.no     ::
  ::                             fax: +47 22 41 74 91        ::
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: }

unit quickrpt;

interface

{$R-}
{$T-} { We don't need (nor want) this type checking! }
{$B-} { QuickReport source assumes boolean expression short-circuit }

{$ifdef win32}
uses Windows, Classes, Controls, StdCtrls, Sysutils, Graphics, Buttons ,
     Forms, ExtCtrls, Dialogs, Printers, DB, QRPrntr, QR2Const, QRPrgres ;
{$else}
uses Wintypes, Winprocs, Classes, Controls, StdCtrls, Sysutils, Graphics, Buttons,
     Forms, Extctrls, Dialogs, Printers, DB, QRPrntr, QR2Const, QRPrgres;
{$endif}

type
  { Forward declarations }
  TQuickRep = class;
  TQRBasePanel = class;
  TQRCustomBand = class;
  TQRChildBand = class;
  TQRPrintable = class;
  TQRDesigner = class;
  TQRSubDetail = class;
  TQRNewComponentClass = class of TQRPrintable;

  { TQRController class }
  TQROnNeedDataEvent = procedure (Sender : TObject; var MoreData : Boolean) of object;

  TQRNotifyOperation = (qrMasterDataAdvance, qrBandPrinted, qrBandSizeChange);

  TQRNotifyOperationEvent = procedure (Sender : TObject; Operation : TQRNotifyOperation) of object;

  TQRController = class(TComponent)
  private
    FMaster : TComponent;
    FDataSet : TDataSet;
    FDetail : TQRCustomBand;
    FFooter : TQRCustomBand;
    FHeader : TQRCustomBand;
    FOnNeedDataEvent : TQROnNeedDataEvent;
    FDetailNumber : integer;
    FParentReport : TQuickRep;
    FPrintBefore : boolean;
    FPrintIfEmpty : boolean;
    FSelfCheck : TComponent;
    GroupList : TList;
    NotifyList : TList;
    PrintAfterList : TList;
    PrintBeforeList : TList;
    procedure SetMaster(Value : TComponent);
    function CheckGroups : boolean;
    procedure CheckLastGroupFooters;
    procedure PrintGroupHeaders;
    procedure PrintGroupFooters;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure NotifyClients(Operation : TQRNotifyOperation);
    procedure SetDataSet(Value : TDataSet);
  protected
    procedure SetPrintBefore(Value : boolean); virtual;
    procedure AddAfter(aController : TQRController);
    procedure RegisterBands;
    procedure AddBefore(aController : TQRController);
    procedure BuildTree;
    procedure Execute;
    procedure Prepare;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure AddNotifyClient(Value : TQRPrintable);
    property DataSet : TDataSet read FDataSet write SetDataSet;
    property DetailNumber : integer read FDetailNumber;
    property Detail : TQRCustomBand read FDetail write FDetail;
    property Footer : TQRCustomband read FFooter write FFooter;
    property Header : TQRCustomBand read FHeader write FHeader;
    property Master : TComponent read FMaster write SetMaster;
    property OnNeedData : TQROnNeedDataEvent read FOnNeedDataEvent write FOnNeedDataEvent;
    property ParentReport : TQuickRep read FParentReport write FParentReport;
    property PrintBefore : boolean read FPrintBefore write SetPrintBefore;
    property PrintIfEmpty : boolean read FPrintIfEmpty write FPrintIfEmpty;
    property SelfCheck : TComponent read FSelfCheck write FSelfCheck;
  end;

  { TQRFrame }
  TQRFrame = class(TPersistent)
  private
    FColor : TColor;
    FBottom : boolean;
    FLeft : boolean;
    FParent : TControl;
    FPenStyle : TPenStyle;
    FRight : boolean;
    FTop : boolean;
    FWidth : integer;
    procedure SetColor(Value : TColor);
    procedure SetParent(Value : TControl);
    procedure SetStyle(Value : TPenStyle);
    procedure SetValue(index : integer; Value : boolean);
    procedure SetWidth(Value : integer);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure PaintIt(ACanvas : TCanvas; Rect : TRect; XFact, YFact : extended);
    procedure SetPen(aPen : TPen);
    procedure ReadMode(Reader : TReader); virtual;
    procedure WriteDummy(Writer : TWriter); virtual;
  public
    constructor Create;
    function AnyFrame : boolean;
    property Parent : TControl read FParent write SetParent;
  published
    property Color: TColor read FColor write SetColor;
    property DrawTop : boolean index 0 read FTop write SetValue;
    property DrawBottom : boolean index 1 read FBottom write SetValue;
    property DrawLeft : boolean index 2 read FLeft write SetValue;
    property DrawRight : boolean index 3 read FRight write SetValue;
    property Style: TPenStyle read FPenStyle write SetStyle default psSolid;
    property Width: Integer read FWidth write SetWidth default 1;
  end;

  { TQRUnitBase - Base class for positioning objects with multiple units support }
  TQRUnit =(MM, Inches, Pixels, Characters, Native);

  TQRUnitBase = class(TPersistent)
  private
    FResolution : integer;
    FUnits : TQRUnit;
    SavedUnits : TQRUnit;
    FParentReport : TQuickRep;
    FParentUpdating : boolean;
    FZoom : integer;
    function LoadUnit(Value : extended; aUnit : TQRUnit; Horizontal : boolean) : extended; virtual;
    function SaveUnit(Value : extended; aUnit : TQRUnit; Horizontal : boolean) : extended; virtual;
  protected
    function GetUnits : TQRUnit; virtual;
    procedure DefineProperties(Filer: TFiler); override;
    procedure Loaded; virtual;
    procedure ReadValues(Reader : TReader); virtual;
    procedure SetParentSizes; virtual;
    procedure SetUnits(Value : TQRUnit); virtual;
    procedure WriteValues(Writer : TWriter); virtual;
    procedure SetPixels;
    procedure RestoreUnit;
  public
    constructor Create;
    property ParentReport : TQuickRep read FParentReport write FParentReport;
    property ParentUpdating : boolean read FParentUpdating write FParentUpdating;
    property Resolution : integer read FResolution;
    property Units : TQRUnit read GetUnits write SetUnits;
    property Zoom : integer read FZoom write FZoom;
  end;

  { TQRBandSize - Object for storing band size information }
  TQRBandSize = class(TQRUnitBase)
  private
    FWidth : extended;
    FLength : extended;
    Parent : TQRCustomBand;
    function GetValue(Index : integer): extended;
    procedure SetValue(Index : integer; Value : extended);
  protected
    procedure ReadValues(Reader : TReader); override;
    procedure SetParentSizes; override;
    procedure WriteValues(Writer : TWriter); override;
    procedure FixZoom;
  public
    constructor Create(AParent : TQRCustomBand); 
    property Length : extended index 0 read GetValue write SetValue stored false;
  published
    { All properties are stored by the WriteValues method }
    property Height : extended index 0 read GetValue write SetValue stored false;
    property Width : extended index 1 read GetValue write SetValue stored false;
  end;

  { TQRPage - Object for storing page layout information }
  TQRPage = class(TQRUnitBase)
  private
    FBottomMargin : extended;
    FColumnSpace : extended;
    FColumns : integer;
    FLeftMargin : extended;
    FLength : extended;
    FOrientation : TPrinterOrientation;
    FPaperSize : TQRPaperSize;
    FRightMargin : extended;
    FRuler : boolean;
    FTopMargin : extended;
    FWidth : extended;
    Parent : TQuickRep;
    function GetPaperSize : TQRPaperSize;
    function GetRuler : boolean;
    function GetValue(Index : integer): extended;
    procedure SetColumns(Value : integer);
    procedure SetOrientation(Value : TPrinterOrientation);
    procedure SetPaperSize(Value : TQRPaperSize);
    procedure SetRuler(Value : boolean);
    procedure SetValue(Index : integer; Value : extended);
  protected
    procedure ReadValues(Reader : TReader); override;
    procedure SetParentSizes; override;
    procedure SetUnits(Value : TQRUnit); override;
    procedure WriteValues(Writer : TWriter); override;
    procedure FixZoom;
  public
    constructor create(AParent : TQuickRep);
  published
    { All the extended properties are stored by the WriteValues method }
    property BottomMargin : extended index 0 read GetValue write SetValue stored false;
    property ColumnSpace : extended index 6 read GetValue write SetValue stored false;
    property Columns : integer read FColumns write SetColumns;
    property LeftMargin : extended index 4 read GetValue write SetValue stored false;
    property Length : extended index 1 read GetValue write SetValue stored false;
    property Orientation : TPrinterOrientation read FOrientation write SetOrientation;
    property PaperSize : TQRPaperSize read GetPaperSize write SetPaperSize;
    property RightMargin : extended index 5 read GetValue write SetValue stored false;
    property Ruler : boolean read GetRuler write SetRuler default true;
    property TopMargin : extended index 2 read GetValue write SetValue stored false;
    property Width : extended index 3 read GetValue write SetValue stored false;
  end;

  { TQRBasePanel }
  TQRBasePanel = class(TCustomPanel)
  private
    FFontSize : integer;
    FZoom : integer;
    FFrame : TQRFrame;
    function GetFrame : TQRFrame;
    procedure SetFrame(Value : TQRFrame);
  protected
    procedure SetZoom(Value : integer); virtual;
    procedure Paint; override;
    procedure PaintRuler(Units : TQRUnit); virtual;
    procedure PrepareComponents;
    procedure UnprepareComponents;
{$ifdef ver100}
    procedure CreateParams(var Params: TCreateParams); override;
{$endif}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Zoom : integer read FZoom write SetZoom;
    property FontSize : integer read FFontSize write FFontSize;
  published
    property Frame : TQRFrame read GetFrame write SetFrame;
  end;

  { TQRCustomBand }
  TQRBandBeforePrintEvent = procedure (Sender : TQRCustomBand; var PrintBand : Boolean) of object;

  TQRBandAfterPrintEvent = procedure (Sender : TQRCustomBand; BandPrinted : Boolean) of object;

  TQRCustomBand = class(TQRBasePanel)
  private
    BandFrameRect : TRect;
    ButtonDown : boolean;
    FExpanded : integer;
    LastX : integer;
    LastY : integer;
    MoveRect : TRect;
    FAfterPrintEvent : TQRBandAfterPrintEvent;
    FAlignToBottom : boolean;
    FBeforePrintEvent : TQRBandBeforePrintEvent;
    FEnabled : boolean;
    FForceNewColumn : boolean;
    FForceNewPage : boolean;
    FLinkBand : TQRCustomBand;
    FParentReport : TQuickRep;
    FParentUpdating : boolean;
    FQRBandType : TQRBandType;
    LoadedHeight : integer;
    FSize : TQRBandSize;
    procedure SetLinkBand(Value : TQRCustomBand);
    function GetBandSize : TQRBandSize;
    function GetHasChild : boolean;
    function GetChild : TQRChildBand;
    procedure SetBandType(Value : TQRBandType);
    procedure SetHasChild(Value : boolean);
  protected
    function GetUnits : TQRUnit;
    function StretchHeight(IncludeNext : boolean) : integer;
    procedure AdvancePaper;
    procedure DefineProperties(Filer: TFiler); override;
    procedure Loaded; override;
    procedure MakeSpace;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure PaintRuler(Units : TQRUnit); override;
    procedure Print;
    procedure ReadAlign(Reader : TReader); virtual;
    procedure ReadRuler(Reader : TReader); virtual;
    procedure ReadLinkband(Reader : TReader); virtual;
    procedure ReleaseFocusFrame;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetBandSize(Value : TQRBandSize);
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: integer); override;
    procedure SetUnits(Value : TQRUnit);
    procedure SetZoom(Value : integer); override;
    procedure WriteDummy(Writer : TWriter); virtual;
    property Expanded : integer read FExpanded write FExpanded;
    property ParentUpdating : boolean read FParentUpdating write FParentUpdating;
    property Units : TQRUnit read GetUnits write SetUnits;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function AddPrintable(PrintableClass : TQRNewComponentClass) : TQRPrintable;
    function CanExpand(Value : extended) : boolean;
    function ExpandBand(Value : extended; var NewTop, OfsX: extended): boolean;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    property BandType : TQRBandType read FQRBandType write SetBandType;
    property ChildBand : TQRChildBand read GetChild;
    property ParentReport : TQuickRep read FParentReport write FParentReport;
    property LinkBand : TQRCustomBand read FLinkBand write SetLinkBand;
  published
    property AfterPrint : TQRBandAfterPrintEvent read FAfterPrintEvent write FAfterPrintEvent;
    property AlignToBottom : boolean read FAlignToBottom write FAlignToBottom;
    property BeforePrint : TQRBandBeforePrintEvent read FBeforePrintEvent write FBeforePrintEvent;
    property Color;
    property Enabled : boolean read FEnabled write FEnabled default true;
    property Font;
    property ForceNewColumn : boolean read FForcenewColumn write FForceNewColumn;
    property ForceNewPage : boolean read FForceNewPage write FForceNewPage;
    property HasChild : boolean read GetHasChild write SetHasChild stored false;
    property ParentFont;
    property Size : TQRBandSize read GetBandSize write SetBandSize;
  end;

  { TQRBand }
  TQRBand = class(TQRCustomBand)
  published
    property BandType;
  end;

  { TQRChildBand }
  TQRChildBand = class(TQRCustomBand)
  private
    FParentBand : TQRCustomBand;
    procedure SetParentBand(Value : TQRCustomBand);
  public
    constructor Create(AOwner : TComponent); override;
  published
    property ParentBand : TQRCustomBand read FParentBand write SetParentBand;
  end;

  { TQRControllerBand }
  TQRControllerBand = class(TQRCustomBand)
  private
    FController : TQRController;
    FMaster : TComponent;
  protected
    function GetPrintIfEmpty : boolean;
    procedure RegisterBands; virtual;
    procedure SetMaster(Value : TComponent); virtual;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetPrintIfEmpty(Value : boolean);
    property Controller : TQRController read FController write FController;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    property PrintIfEmpty : boolean read GetPrintIfEmpty write SetPrintIfEmpty;
  published
    property Master : TComponent read FMaster write SetMaster;
  end;

  { TQRSubDetailGroupBands }
  TQRSubDetailGroupBands = class(TPersistent)
  private
    Owner : TQRSubDetail;
    function GetFooterBand : TQRCustomBand;
    function GetHasFooter : boolean;
    function GetHasHeader : boolean;
    function GetHeaderBand : TQRCustomBand;
    procedure SetHasFooter(Value : boolean);
    procedure SetHasHeader(Value : boolean);
  public
    constructor Create(AOwner : TQRSubDetail);
    property FooterBand : TQRCustomBand read GetFooterBand;
    property HeaderBand : TQRCustomBand read GetHeaderBand;
  published
    property HasFooter : boolean read GetHasFooter write SetHasFooter stored false;
    property HasHeader : boolean read GetHasHeader write SetHasHeader stored false;
  end;

  { TQRSubDetail }
  TQRSubDetail = class(TQRControllerBand)
  private
    FBands : TQRSubDetailGroupBands;
    function GetDataSet : TDataSet;
    function GetFooterBand : TQRCustomBand;
    function GetHeaderBand : TQRCustomBand;
    function GetOnNeedData : TQROnNeedDataEvent;
    function GetPrintBefore : boolean;
    procedure SetDataSet(Value :TDataSet);
    procedure SetFooterBand(Value : TQRCustomBand);
    procedure SetHeaderBand(Value : TQRCustomBand);
    procedure SetOnNeedData(Value : TQROnNeedDataEvent);
    procedure SetPrintBefore(Value : boolean);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure RegisterBands; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure AddNotifyClient(Value : TQRPrintable);
  published
    property Bands : TQRSubDetailGroupBands read FBands write FBands;
    property DataSet : TDataSet read GetDataSet write SetDataSet;
    property FooterBand : TQRCustomBand read GetFooterBand write SetFooterBand;
    property HeaderBand : TQRCustomBand read GetHeaderBand write SetHeaderBand;
    property OnNeedData : TQROnNeedDataEvent read GetOnNeedData write SetOnNeedData;
    property PrintBefore : boolean read GetPrintBefore write SetPrintBefore;
    property PrintIfEmpty;
  end;

  { TQuickRepBands }
  TQuickRepBands = class(TPersistent)
  private
    FOwner : TQuickRep;
    function BandInList(BandType : TQRBandType) : TQRCustomBand;
    procedure SetBand(BandType : TQRBandType; Value : boolean);
    function GetBand(Index : Integer) : TQRCustomBand;
    function GetHasBand(Index : integer) : boolean;
    procedure SetHasBand(Index : integer; Value : boolean);
  public
    constructor Create(AOwner : TQuickRep);
    property TitleBand : TQRCustomBand index 1 read GetBand;
    property PageHeaderBand : TQRCustomBand index 2 read GetBand;
    property ColumnHeaderBand : TQRCustomBand index 3 read GetBand;
    property DetailBand : TQRCustomBand index 4 read GetBand;
    property ColumnFooterBand : TQRCustomBand index 5 read GetBand;
    property PageFooterBand : TQRCustomBand index 6 read GetBand;
    property SummaryBand : TQRCustomBand index 7 read GetBand;
  published
    property HasTitle : boolean index 1 read GetHasBand write SetHasBand stored false;
    property HasPageHeader : boolean index 2 read GetHasBand write SetHasBand stored false;
    property HasColumnHeader : boolean index 3 read GetHasBand write SetHasBand stored false;
    property HasDetail : boolean index 4 read GetHasBand write SetHasBand stored false;
    property HasPageFooter : boolean index 6 read GetHasBand write SetHasBand stored false;
    property HasSummary : boolean index 7 read GetHasBand write SetHasBand stored false;
  end;

  TQRState = (qrAvailable, qrPrepare, qrPreview, qrPrint, qrEdit);

  { TQuickRepPrinterSettings }
  TQuickRepPrinterSettings = class(TQRPrinterSettings)
  published
    property Copies;
    property Duplex;
    property FirstPage;
    property LastPage;
    property OutputBin;
  end;

{$ifdef win32}
  { TQRCreateReportThread - class used to spawn background thread }
  TQRCreateReportThread = class(TThread)
  private
    FQRPrinter : TQRPrinter;
    FQuickRep : TQuickRep;
  public
    constructor Create(AReport : TQuickRep);
    procedure Execute; override;
    property QuickRep : TQuickRep read FQuickRep write FQuickRep;
  end;
{$endif}

  TQuickReportOption = (FirstPageHeader,
                        LastPageFooter,
                        Compression);

  TQuickReportOptions = set of TQuickReportOption;

  { TQuickRep - QuickReport main class }
  TQRNotifyEvent = procedure (Sender : TQuickrep) of object;

  TQRReportBeforePrintEvent = procedure (Sender : TQuickRep; var PrintReport : Boolean) of object;

  TQuickRep = class(TQRBasePanel)
  private
{$ifdef win32}
    BGThread : TQRCreateReportThread;
{$endif}
    aController : TQRController;
    BandRegList : TList;
    FAfterPrintEvent : TQRAfterPrintEvent;
    FAfterPreviewEvent : TQRAfterPreviewEvent;
    FAllDataSets : TList;
    FAvailable : boolean;
    FBandList : TList;
    FBands : TQuickRepBands;
    FBeforePrintEvent : TQRReportBeforePrintEvent;
    FColumnTopPosition : integer;
    FCurrentColumn : integer;
    FCurrentX : integer;
    FCurrentY : integer;
    FDescription : TStrings;
    FDesigner : TQRDesigner;
    FExportFilter : TQRExportFilter;
    FExporting : boolean;
    FFinalPass : boolean;
    FHideBands : boolean;
    FLastPage : boolean;
    FOnEndPageEvent : TQRNotifyEvent;
    FOnNeedDataEvent : TQROnNeedDataEvent;
    FOnPreviewEvent : TNotifyEvent;
    FOnStartPageEvent : TQRNotifyEvent;
    FOptions : TQuickReportOptions;
    FPage : TQRPage;
    FPageCount : integer;
    FPageFooterSize : extended;
    FPrinterSettings : TQuickRepPrinterSettings;
    FReportTitle : string;
    FRotateBands : integer;
    FShowProgress : boolean;
    FSnapToGrid : boolean;
    FState : TQRState;
    FQRPrinter : TQRPrinter;
    NewColumnForced : boolean;
    NewPageForced : boolean;
    ReferenceDC : THandle;
    function GetUnits : TQRUnit;
    function GetDataSet : TDataSet;
    function GetPrintIfEmpty : boolean;
    function GetRecordCount : integer;
    function GetRecordNumber : integer;
    procedure PrintBand(ABand : TQRCustomBand);
    procedure PrintPageBackground;
    procedure SetExportFilter(Value : TQRExportFilter);
    procedure SetUnits(Value : TQRUnit);
    procedure SetDataSet(Value : TDataSet);
    procedure SetDescription(Value : TStrings);
    procedure SetPrintIfEmpty(Value : boolean);
    procedure SetPrinterValues;
  protected
    function AvailableSpace : integer;
    function PrepareQRPrinter : boolean;
    procedure CreateReport(CompositeReport : boolean);
    procedure ForceNewColumn;
    procedure ForceNewPage;
{$ifdef ver100}
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
{$endif}
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure PaintColumns; virtual;
    procedure PaintMargins; virtual;
    procedure PaintFrame; virtual;
    procedure PaintRuler(Units : TQRUnit); override;
    procedure PreviewFinished(Sender : TObject);
    procedure PrintFinished(Sender : TObject);
    procedure RebuildBandList;
    procedure RegisterBand(aBand : TQRCustomBand);
    procedure SetHideBands(Value : boolean);
    procedure SetRotateBands(Value : integer);
    procedure SetZoom(Value : integer); override;
  public
    constructor Create(AOwner : TComponent); override;
{$ifdef ver100}
    constructor CreateNew(AOwner : TComponent);
{$endif}
    destructor Destroy; override;
    function CreateBand(BandType : TQRBandType) : TQRBand;
    function TextHeight(aFont : TFont; aText : string) : integer;
    function TextWidth(aFont : TFont; aText : string) : integer;
    procedure AddBand(aBand : TQRCustomBand);
    procedure AddNotifyClient(Value : TQRPrintable);
    procedure Edit(ADesigner : TQRDesigner);
    procedure ExportToFilter(AFilter : TQRExportFilter);
    procedure EndPage;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure NewColumn;
    procedure NewPage;
    procedure Paint; override;
    procedure Print;
    procedure PrintBackground;
    procedure PrinterSetup;
    procedure Prepare;
    procedure Preview;
    procedure ResetPageFooterSize;
    procedure RemoveBand(aBand : TQRCustomBand);
    procedure SetBandValues;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property AllDataSets : TList read FAllDataSets write FAllDataSets;
    property Available : boolean read FAvailable;
    property BandList : TList read FBandList;
    property ColumnTopPosition : integer read FColumnTopPosition write FColumnTopPosition;
    property CurrentColumn : integer read FCurrentColumn;
    property CurrentX : integer read FCurrentX write FCurrentX;
    property CurrentY : integer read FCurrentY write FCurrentY;
    property Designer : TQRDesigner read FDesigner;
    property ExportFilter : TQRExportFilter read FExportFilter write SetExportFilter;
    property Exporting : boolean read FExporting;
    property FinalPass : boolean read FFinalPass;
    property HideBands : boolean read FHideBands write SetHideBands;
    property PageNumber : integer read FPageCount;
    property Printer : TQRPrinter read FQRPrinter;
    property QRPrinter : TQRPrinter read FQRPrinter write FQRPrinter;
    property RecordCount : integer read GetRecordCount;
    property RecordNumber : integer read GetRecordNumber;
    property RotateBands : integer read FRotateBands write SetRotateBands;
    property State : TQRState read FState write FState;
  published
    property AfterPrint : TQRAfterPrintEvent read FAfterPrintEvent write FAfterPrintEvent;
    property AfterPreview : TQRAfterPreviewEvent read FAfterPreviewEvent write FAfterPreviewEvent;
    property Bands : TQuickRepBands read FBands write FBands;
    property BeforePrint : TQRReportBeforePrintEvent read FBeforePrintEvent write FBeforePrintEvent;
    property DataSet : TDataSet read GetDataSet write SetDataSet;
    property Description : TStrings read FDescription write SetDescription;
    property Font;
    property OnEndPage : TQRNotifyEvent read FOnEndPageEvent write FOnEndPageEvent;
    property OnNeedData : TQROnNeedDataEvent read FOnNeedDataEvent write FOnNeedDataEvent;
    property OnPreview : TNotifyEvent read FOnPreviewEvent write FOnPreviewEvent;
    property OnStartPage : TQRNotifyEvent read FOnStartPageEvent write FOnStartPageEvent;
    property Options : TQuickReportOptions read FOptions write FOptions;
    property Page : TQRPage read FPage write FPage;
    property PrintIfEmpty : boolean read GetPrintIfEmpty write SetPrintIfEmpty;
    property PrinterSettings : TQuickRepPrinterSettings read FPrinterSettings write FPrinterSettings;
    property ReportTitle : string read FReportTitle write FReportTitle;
    property ShowProgress : boolean read FShowProgress write FShowProgress default true;
    property SnapToGrid : boolean read FSnapToGrid write FSnapToGrid;
    property Units : TQRUnit read GetUnits write SetUnits stored true;
    property Zoom;
  end;

  { TQRGroup }
  TQRGroup = class(TQRCustomBand)
  private
    Evaluator : TQREvaluator;
    FExpression : string;
    FFooterBand : TQRBand;
    FMaster : TComponent;
    FReprint : boolean;
    GroupValue : TQREvResult;
    HasResult : boolean;
    procedure SetFooterBand(Value : TQRBand);
    procedure SetMaster(Value : TComponent);
  protected
    property Reprint : boolean read FReprint write FReprint;
    procedure Check;
    procedure DefineProperties(Filer: TFiler); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Prepare;
    procedure ReadValues(Reader : TReader); virtual;
    procedure ReadDataSource(Reader : TReader); virtual;
    procedure ReadDataField(Reader : TReader); virtual;
    procedure ReadHeaderBand(Reader : TReader); virtual;
    procedure ReadOnNeedData(Reader : TReader); virtual;
    procedure SetExpression(Value : string);
    procedure SetParent(AParent: TWinControl); override;
    procedure Unprepare;
    procedure WriteValues(Writer : TWriter); virtual;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
  published
    property Expression : string read FExpression write SetExpression;
    property FooterBand : TQRBand read FFooterBand write SetFooterBand;
    property Master : TComponent read FMaster write SetMaster;
  end;

  { TQRPrintableSize - Class storing size and positioning information for
    all printable objects }
  TQRPrintableSize = class(TQRUnitBase)
  private
    FHeight : extended;
    FLeft : extended;
    FTop : extended;
    FWidth : extended;
    Parent : TQRPrintable;
    function GetValue(Index : integer): extended;
    procedure SetValue(Index : integer; Value : extended);
  protected
    procedure SetParentSizes; override;
    procedure ReadValues(Reader : TReader); override;
    procedure WriteValues(Writer : TWriter); override;
    procedure FixZoom;
  public
    constructor Create(AParent : TQRPrintable);
  published
    property Height : extended index 0 read GetValue write SetValue stored false;
    property Left : extended index 1 read GetValue write SetValue stored false;
    property Top : extended index 2 read GetValue write SetValue stored false;
    property Width : extended index 3 read GetValue write SetValue stored false;
  end;

  { TQRPrintable - Base QuickReport printable object }
  TQRPrintable = class(TCustomControl)
  private
    { Private variables and methods }
    AlignUpdating : boolean;
    FAlignment : TAlignment;
    FAlignToBand : boolean;
    ButtonDown : boolean;
    FFrame : TQRFrame;
    FIsPrinting : boolean;
    FParentReport : TQuickRep;
    FQRPrinter : TQRPrinter;
    FSize : TQRPrintableSize;
    LastX : integer;
    LastY : integer;
    LoadedTop : integer;
    LoadedWidth : integer;
    LoadedHeight : integer;
    LoadedLeft : integer;
    function GetTransparent : boolean;
    procedure SetTransparent(Value : boolean);
    function GetZoom : integer;
    procedure SetAlignToBand(Value : boolean);
    procedure SetFrame(Value : TQRFrame);
  protected
    procedure AlignIt; virtual;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure PaintCorners;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetZoom(Value : integer);
    procedure Paint; override;
    procedure Prepare; virtual;
    procedure Print(OfsX, OfsY : integer); virtual;
    procedure QRNotification(Sender : TObject; Operation : TQRNotifyOperation); virtual;
    procedure ReleaseFocusFrame;
    procedure SetAlignment(Value : TAlignment); virtual;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure UnPrepare; virtual;
    property Alignment : TAlignment read FAlignment write SetAlignment;
    property AlignToBand : boolean read FAlignToBand write SetAlignToBand;
    property IsPrinting : boolean read FIsPrinting write FIsPrinting;
    property QRPrinter : TQRPrinter read FQRPrinter write FQRPrinter;
    property Transparent : boolean read GetTransparent write SetTransparent;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ParentReport : TQuickRep read FParentReport write FParentReport;
    property Zoom : integer read GetZoom write SetZoom;
  published
    property Enabled;
    property Frame : TQRFrame read FFrame write SetFrame;
    property Size : TQRPrintableSize read FSize write FSize;
  end;

  { TQRCompositeReport - Component which combines several reports into one }
  TQRCompositeReport = class(TComponent)
  private
    FOnAddReports : TNotifyEvent;
    FOnFinished : TNotifyEvent;
    FOptions : TQuickReportOptions;
    FPrinterSettings : TQuickRepPrinterSettings;
    FQRPrinter : TQRPrinter;
    FReports : TList;
    FReportTitle : string;
    procedure CreateComposite;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Prepare;
    procedure Preview;
    procedure Print;
    property Reports : TList read FReports write FReports;
  published
    property OnAddReports : TNotifyEvent read FOnAddReports write FOnAddReports;
    property OnFinished : TNotifyEvent read FOnFinished write FOnFinished;
    property Options : TQuickReportOptions read FOptions write FOptions;
    property PrinterSettings : TQuickRepPrinterSettings read FPrinterSettings write FPrinterSettings;
    property ReportTitle : string read FReportTitle write FReportTitle;
  end;

  { QREditor type declarations }
  THandlePosition  = hpNone..hpLast;
  THandleOperation = (hoCreate, hoParent, hoDestroy, hoMove, hoShow, hoHide);

  { TControlHandle }
  TControlHandle = Class(TCustomControl)
  Private
    FPosition  : THandlePosition;
    QRDesigner : TQRDesigner;
    procedure SetPosition(Value : THandlePosition );
    procedure SetPos(x,y : integer);
    function GetCenter : TPoint;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure SetParent(aParent : TWinControl ); override;
  public
    constructor CreateGrab(aQRDesigner : TQRDesigner; aPosition : THandlePosition); virtual;
    procedure Hide;
    procedure Show;
    procedure Paint; override;
    property Position : THandlePosition read FPosition write SetPosition;
    property Center : TPoint read GetCenter;
  end;

  { TQRDesigner - object taking care of all low level report designing }
  TQRDesigner = class(TControl)
  private
    FEditControl : TControl;
    FEditing : boolean;
    FIsAdding : boolean;
    FOnSelectComponent : TNotifyEvent;
    FReport : TQuickRep;
    FSizing : boolean;
    Handles : array[hpFirst..hpLast] of TControlHandle;
    MoveRect : TRect;
    NewComponentClass : TQRNewComponentClass;
    SizePosition : THandlePosition;
    SizeStartX : integer;
    SizeStartY : integer;
    procedure DrawControlHandles(Control : TControl; Visible : Boolean);
    procedure HandleOperation(Operation : THandleOperation);
    procedure SetOnSelectComponent(Value : TNotifyEvent);
    procedure UpdateHandlePositions(Control : TControl);
  protected
    function ReleaseFocusFrame : TRect;
    procedure MoveFocusFrame(Rect : TRect);
    procedure SetEditControl(AControl : TControl); virtual;
    procedure SizeBegin(X, Y : integer; aPosition : THandlePosition);
    procedure SizeTo(X, Y : integer);
    procedure SizeEnd(X, Y: integer);
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure AddComponent(aNewComponentType : TQRNewComponentClass);
    procedure AddIt(aParent : TWinControl; X, Y : integer);
    procedure Edit(AReport : TQuickRep);
    procedure GetHandles;
    procedure SetFocusFrame;
    procedure StopEdit;
    property EditControl : TControl read FEditControl write SetEditControl;
    property Editing : boolean read FEditing write FEditing;
    property IsAdding : boolean read FIsAdding;
    property OnSelectComponent : TNotifyEvent read FOnSelectComponent write SetOnSelectComponent;
    property Sizing : boolean read FSizing write FSizing;
  end;

  { TQuickReport - conversion component from QR 1 to QR 2 (New component is TQuickRep) }

  TQRPrintOrder = (qrColByCol, qrRowByRow);
  TQRFilterEvent = procedure (var PrintRecord : boolean) of object;

  TQR1PaperSize = (qrpDefault,
                   qrpLetter,
                   qrpLegal,
                   qrpA3,
                   qrpA4,
                   qrpA5,
                   qrpCustom);

  TQuickReport = class(TQuickRep)
  private
    FAfterDetail : TNotifyEvent;
    FAfterPrint : TNotifyEvent;
    FBeforeDetail : TNotifyEvent;
    FBeforePrint : TQRReportBeforePrintEvent;
    FColumnMarginInches : longint;
    FColumnMarginMM : longint;
    FColumns : integer;
    FDataSource : TDataSource;
    FDisplayPrintDialog : boolean;
    FLeftMarginInches : longint;
    FLeftMarginMM : longint;
    FOnEndPage : TNotifyEvent;
    FOnStartPage : TNotifyEvent;
    FOnFilterEvent : TQRFilterEvent;
    FOrientation : TPrinterOrientation;
    FPageFrame : TQRFrame;
    FPaperLength : integer;
    FPaperSize : TQR1PaperSize;
    FPaperWidth : integer;
    FPrintOrder : TQRPrintOrder;
    FReportTitle : string;
    FRestartData : boolean;
    FShowProgress : boolean;
    FSQLCompatible : boolean;
    FTitleBeforeHD : boolean;
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
  published
    property AfterDetail : TNotifyEvent read FAfterDetail write FAfterDetail;
    property AfterPrint : TNotifyEvent read FAfterPrint write FAfterPrint;
    property BeforeDetail : TNotifyEvent read FBeforeDetail write FBeforeDetail;
    property BeforePrint : TQRReportBeforePrintEvent read FBeforePrint write FBeforePrint;
    property ColumnMarginInches : longint read FColumnMarginInches write FColumnMarginInches;
    property ColumnMarginMM : longint read FColumnMarginMM write FColumnMarginMM;
    property Columns : integer read FColumns write FColumns;
    property DataSource : TDataSource read FDataSource write FDataSource;
    property DisplayPrintDialog : boolean read FDisplayPrintDialog write FDisplayPrintDialog;
    property LeftMarginInches : longint read FLeftMarginInches write FLeftMarginInches;
    property LeftMarginMM : longint read FLeftMarginMM write FLeftMarginMM;
    property OnEndPage : TNotifyEvent read FOnEndPage write FOnEndPage;
    property OnStartPage : TNotifyEvent read FOnStartPage write FOnStartPage;
    property Orientation : TPrinterOrientation read FOrientation write FOrientation;
    property PageFrame : TQRFrame read FPageFrame write FPageFrame;
    property PaperLength : integer read FPaperLength write FPaperLength;
    property PaperSize : TQR1PaperSize read FPaperSize write FPaperSize;
    property PaperWidth : integer read FPaperWidth write FPaperWidth;
    property PrintOrder : TQRPrintOrder read FPrintOrder write FPrintOrder;
    property ReportTitle : string read FReportTitle write FReportTitle;
    property RestartData : boolean read FRestartData write FRestartData;
    property ShowProgress : boolean read FShowProgress write FShowProgress default true;
    property SQLCompatible : boolean read FSQLCompatible write FSQLCompatible;
    property TitleBeforeHeader : boolean read FTitleBeforeHD write FTitleBeforeHD;
    property OnFilter : TQRFilterEvent read FOnFilterEvent write FOnFilterEvent;
  end;

  TQRDetailLink = class(TQRSubDetail)
  private
    DataSourceName : string;
    DetailBandName : string;
  protected
    procedure Loaded; override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure ReadDataSource(Reader : TReader); virtual;
    procedure ReadDetailBand(Reader : TReader); virtual;
    procedure ReadOnFilter(Reader : TReader); virtual;
    procedure WriteValues(Writer : TWriter);
  end;

  procedure SetQRHiColor;
  procedure SetQRLoColor;
  function UniqueName(AComponent : TComponent; Start : string) : string;

implementation

uses qrctrls;

{$R QUICKRPT.RES}

{ Misc. internal routines }

const
{ Bug - Number of pages not correct in printer setup dialog - Begin }
{ Add Following Lines }
  LastPageCount : Word = 0;
{ Bug - Number of pages not correct in printer setup dialog - End }

  Cursors : array[hpFirst..hpLast] of tCursor = ( crSizeNWSE, crSizeNS, crSizeNESW,
                                                  crSizeWE,             crSizeWE,
                                                  crSizeNESW, crSizeNS, crSizeNWSE );

var
  cqrRulerMinorStyle : TPenStyle;
  cqrRulerMajorStyle : TPenStyle;
  cqrRulerMinorColor : TColor;
  cqrRulerMajorColor : TColor;
  cqrRulerFontName : string[30];
  cqrRulerFontColor : TColor;
  cqrRulerFontSize : integer;

  cqrMarginStyle : TPenStyle;
  cqrMarginColor : TColor;

  cqrBandFrameStyle : TPenStyle;
  cqrBandFrameColor : TColor;
  LocalMeasureInches : boolean;

function UniqueName(AComponent : TComponent; Start : string) : string;
var
  i : integer;
begin
  i:=1;
  while AComponent.FindComponent(Start+IntToStr(I))<>nil do
    inc(i);
  result:=Start+IntToStr(I);
end;

function DataSetOK(ADataSet : TDataSet) : boolean;
begin
  Result := (ADataSet <> nil) and
    ADataSet.Active;
end;

function CharWidth(Size : integer):extended;
begin
  result := 80 / Size / 2.54;
end;

function CharHeight(Size : integer):extended;
begin
  result := 145.3 / Size / 2.54;
end;

function SnapToUnit(Value : extended; aUnit : TQRUnit) : extended;
begin
  case aUnit of
    Characters : Result := round(Value);
    MM : Result := round(Value)
  else
    Result := round(Value * 40) / 40;
  end
end;

{ TQRController }

constructor TQRController.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  PrintAfterList := TList.Create;
  PrintBeforeList := TList.Create;
  GroupList := TList.Create;
  NotifyList  := TList.Create;
  Master := nil;
  FSelfCheck := self;
  PrintBefore := false;
  PrintIfEmpty := false;
end;

destructor TQRController.Destroy;
begin
  NotifyList.Free;
  PrintAfterList.Free;
  PrintBeforeList.Free;
  GroupList.Free;
  inherited Destroy;
end;

procedure TQRController.AddAfter(aController : TQRController);
begin
  PrintAfterList.Add(aController);
end;

procedure TQRController.RegisterBands;
var
  I : integer;
begin
  if assigned(FHeader) then ParentReport.RegisterBand(Header);
  for I := 0 to GroupList.Count - 1 do
    ParentReport.RegisterBand(TQRGroup(GroupList[I]));
  for I := 0 to PrintBeforeList.Count - 1 do
    TQRController(PrintBeforeList[I]).RegisterBands;
  if assigned(FDetail) then ParentReport.RegisterBand(Detail);
  for I := 0 to PrintAfterList.Count - 1 do
    TQRController(PrintAfterList[I]).RegisterBands;
  for I := GroupList.Count - 1 downto 0 do
    if TQRGroup(GroupList[I]).FooterBand <> nil then
      ParentReport.RegisterBand(TQRGroup(GroupList[I]).FooterBand);
  if assigned(FFooter) then ParentReport.RegisterBand(Footer);
end;

procedure TQRController.AddBefore(aController : TQRController);
begin
  PrintBeforeList.Add(aController);
end;

procedure TQRController.AddNotifyClient(Value : TQRPrintable);
begin
  NotifyList.Add(Value);
end;

function TQRController.CheckGroups : boolean;
var
  I, J : integer;
begin
  result := false;
  for I := 0 to GroupList.Count - 1 do
  begin
    TQRGroup(GroupList[I]).Check;
    if TQRGroup(GroupList[I]).Reprint then
    begin
      result := true;
      for J := I + 1 to GroupList.Count - 1 do
        with TQRGroup(GroupList[J]) do
        begin
          GroupValue := Evaluator.Value;
          Reprint := true;
          HasResult := true;
        end;
      exit;
    end
  end
end;

procedure TQRController.PrintGroupHeaders;
var
  I : integer;
begin
  for I := 0 to GroupList.Count - 1 do
    if TQRGroup(GroupList[I]).Reprint then
    begin
      TQRGroup(GroupList[I]).MakeSpace;
      ParentReport.PrintBand(TQRGroup(GroupList[I]));
    end
end;

procedure TQRController.PrintGroupFooters;
var
  I : integer;
begin
  for I := GroupList.Count - 1 downto 0 do
    if TQRGroup(GroupList[I]).Reprint and
       (TQRGroup(GroupList[I]).FooterBand <> nil) then
      begin
        TQRGroup(GroupList[I]).FooterBand.MakeSpace;
        ParentReport.PrintBand(TQRGroup(GroupList[I]).FooterBand);
      end
end;

procedure TQRController.CheckLastGroupFooters;
var
  I : integer;
begin
  for I := 0 to GroupList.Count - 1 do
    TQRGroup(GroupList[I]).Reprint := not TQRGroup(GroupList[I]).Reprint;
end;

procedure TQRController.BuildTree;
var
  Controller : TQRController;
  Group : TQRGroup;

  procedure BuildTreeFrom(Component: TComponent);
  var
    I : integer;
  begin
    if Component = nil then Exit;
    for I := 0 to Component.ComponentCount - 1 do
    begin
      if Component.Components[I] is TQRController then
      begin
        Controller := TQRController(Component.Components[I]);
        if TQRController(Controller.Master) = SelfCheck then
        begin
          if Controller.PrintBefore then
            AddBefore(Controller)
          else
            AddAfter(Controller);
          Controller.ParentReport := ParentReport;
        end
      end;
      if (Component.Components[I] is TQRControllerBand) then
      begin
        Controller := TQRControllerBand(Component.Components[I]).Controller;
        if not (csDestroying in Controller.ComponentState) then
          if Controller.Master = SelfCheck then
          begin
            Controller.ParentReport := ParentReport;
            if Controller.PrintBefore then
              AddBefore(Controller)
            else
              AddAfter(Controller);
            Controller.BuildTree;
          end;
      end;
      if (Component.Components[I] is TQRGroup) then
      begin
        Group := TQRGroup(Component.Components[I]);
        if (Group.Master=SelfCheck) and not (csDestroying in Group.ComponentState) then
        begin
          GroupList.Add(Group);
          Group.ParentReport := ParentReport;
        end
      end
    end
  end;

begin
  PrintBeforeList.Clear;
  PrintAfterList.Clear;
  GroupList.Clear;
  BuildTreeFrom(SelfCheck.Owner);
{$ifdef ver100}
  BuildTreeFrom(SelfCheck);
{$endif}
end;

procedure TQRController.Prepare;
var
  I : integer;
begin
  BuildTree;
  NotifyList.Clear;
  if DataSetOK(FDataSet) then
    ParentReport.AllDataSets.Add(DataSet);
{  else
    FDataSet := nil;}
  for I := 0 to PrintBeforeList.Count - 1 do
    TQRController(PrintBeforeList[I]).Prepare;
  for I := 0 to PrintAfterList.Count - 1 do
    TQRController(PrintAfterList[I]).Prepare;
  for I := 0 to GroupList.Count - 1 do
    TQRGroup(GroupList[I]).Prepare;
end;

procedure TQRController.Notification(AComponent : TComponent; Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if AComponent = Header then
      Header := nil;
    if AComponent = Detail then
      Detail := nil;
    if AComponent = Footer then
      Footer := nil;
    if AComponent = DataSet then
      DataSet := nil;
    if AComponent = Master then
      Master := nil;
  end
end;

procedure TQRController.NotifyClients(Operation : TQRNotifyOperation);
var
  I : integer;
begin
  for I := 0 to NotifyList.Count - 1 do
    TQRPrintable(NotifyList[I]).QRNotification(Self, Operation);
end;

procedure TQRController.Execute;
var
  MoreData : boolean;
  RecCount : integer;
  DSOK : boolean;
  SQLBased : boolean;

  procedure PrintBeforeControllers;
  var
    I : integer;
  begin
    for I := 0 to PrintBeforeList.Count - 1 do
      TQRController(PrintBeforeList[I]).Execute;
  end;

  procedure PrintAfterControllers;
  var
    I : integer;
  begin
    for I := 0 to PrintAfterList.Count - 1 do
      TQRController(PrintAfterList[I]).Execute;
  end;

  procedure PrintEmptyController;
  begin
    if assigned(FHeader) then
    begin
      FHeader.MakeSpace;
      ParentReport.PrintBand(FHeader);
    end;
    PrintBeforeControllers;
    if assigned(FDetail) then
    begin
      FDetail.MakeSpace;
      ParentReport.PrintBand(FDetail);
    end;
    PrintAfterControllers;
    if assigned(FFooter) then
    begin
      FFooter.MakeSpace;
      ParentReport.PrintBand(FFooter);
    end;
  end;

begin
  RecCount := 1;
  if (DataSetOK(FDataSet) or assigned(FOnNeedDataEvent)) and
    assigned(FParentReport) then
  begin
    MoreData := true;
    DSOK := DataSetOK(FDataSet);
    //SQLBased := not (DSOK and (FDataSet is TTable) and not (TTable(FDataSet).DataBase.IsSQLBased));
    SQLBased := not DSOK;
    if DSOK then
    begin
      FDataSet.First;
      MoreData := not FDataSet.Eof;
      if ParentReport.DataSet = DataSet then
        RecCount := ParentReport.RecordCount;
      if (not Moredata) and PrintIfEmpty then
        PrintEmptyController;
    end else
    begin
      if assigned(FOnNeedDataEvent) and not (csDesigning in ComponentState) then
        OnNeedData(SelfCheck, MoreData);
    end;
    FDetailNumber := 0;
    CheckGroups;
    if MoreData then
    begin
      Application.ProcessMessages;
      if ParentReport.QRPrinter.Cancelled then Exit;
      if assigned(FHeader) then
      begin
        FHeader.MakeSpace;
        ParentReport.PrintBand(FHeader);
      end;
      if (ParentReport.PageNumber = 1) and  { Print first column header }
         (SelfCheck is TQuickRep) then
      begin
        ParentReport.PrintBand(ParentReport.Bands.ColumnHeaderBand);
      end;
      while MoreData do
      begin
        Application.ProcessMessages;
        if ParentReport.QRPrinter.Cancelled then Exit;
        inc(FDetailNumber);
        PrintGroupHeaders;
        PrintBeforeControllers;
        if assigned(FDetail) then FDetail.MakeSpace;
        NotifyClients(qrMasterDataAdvance);
        ParentReport.PrintBand(FDetail);
        PrintAfterControllers;
        if DSOK then
        begin
          DataSet.Next;
          MoreData := not FDataSet.Eof
        end else
        begin
          MoreData := false;
          if assigned(FOnNeedDataEvent) and not (csDesigning in ComponentState) then
            OnNeedData(SelfCheck, MoreData);
        end;
        if CheckGroups then
          begin
            if DSOK then
              DataSet.Prior;
            PrintGroupFooters;
            if DSOK then
              DataSet.Next;
        end;
        if DSOK and (ParentReport.DataSet = DataSet) and (RecCount <> 0) then
          ParentReport.QRPrinter.Progress := (Longint(DetailNumber) * 100) div RecCount;
      end;
      CheckLastGroupFooters;
      PrintGroupFooters;
      if assigned(FFooter) then
      begin
        FFooter.MakeSpace;
        ParentReport.PrintBand(FFooter);
      end
    end
  end
  else
    if PrintIfEmpty then
      PrintEmptyController;
end;

procedure TQRController.SetDataSet(Value : TDataSet);
begin
  FDataSet := Value;
{$ifdef win32}
  if Value <> nil then
    FDataSet.FreeNotification(self);
{$endif}
end;

procedure TQRController.SetMaster(Value : TComponent);
begin
  if (Value <> TControl(Self)) and
    ((Value is TQuickRep) or (Value is TQRController) or (Value is TQRControllerBand)) then
  begin
    FMaster := Value;
{$ifdef win32}
    if Assigned(Value) then Value.FreeNotification(Self);
{$endif}
  end
end;

procedure TQRController.SetPrintBefore(Value : boolean);
begin
   FPrintBefore := Value;
end;

{ TQRGroup }

constructor TQRGroup.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  Evaluator := TQREvaluator.Create;
  BandType := rbGroupHeader;
end;

destructor TQRGroup.Destroy;
begin
  Evaluator.Free;
  inherited Destroy;
end;

procedure TQRGroup.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if AComponent = FFooterBand then
      FFooterBand := nil;
    if AComponent = FMaster then
      FMaster := nil;
  end
end;

procedure TQRGroup.DefineProperties(Filer: TFiler);
begin
  Filer.DefineProperty('Level', ReadValues, WriteValues, false); { <-- do not resource }
  Filer.DefineProperty('DataSource', ReadDataSource, WriteValues, false);
  Filer.DefineProperty('DataField', ReadDataField, WriteValues, false);
  Filer.DefineProperty('HeaderBand', ReadHeaderBand, WriteValues, false);
  Filer.DefineProperty('OnNeedData', ReadOnNeedData, WriteValues, false);
  inherited DefineProperties(Filer);
end;

procedure TQRGroup.ReadValues(Reader : TReader);
begin
  Reader.ReadInteger;
end;

procedure TQRGroup.ReadDataSource(Reader : TReader);
begin
  Reader.ReadIdent;
end;

procedure TQRGroup.ReadDataField(Reader : TReader);
begin
  Expression := Reader.ReadString;
end;

procedure TQRGroup.ReadHeaderBand(Reader : TReader);
begin
  Reader.ReadIdent;
end;

procedure TQRGroup.ReadOnNeedData(Reader : TReader);
begin
  Reader.ReadIdent;
end;

procedure TQRGroup.WriteValues(Writer : TWriter);
begin
end;

procedure TQRGroup.SetExpression(Value : string);
begin
  FExpression := Value;
end;

procedure TQRGroup.Check;
var
  aValue : TQREvResult;
begin
  Reprint := false;
  if not HasResult then
  begin
    GroupValue := Evaluator.Value;
    Reprint := true;
    HasResult := true;
  end else
  begin
    aValue := Evaluator.Value;
    if aValue.Kind <> GroupValue.Kind then
      Reprint := true
    else
    begin
      case aValue.Kind of
        resString : Reprint := aValue.StrResult <> GroupValue.StrResult;
        resInt : Reprint := aValue.IntResult <> GroupValue.IntResult;
        resDouble : Reprint := aValue.dblResult <> GroupValue.dblResult;
        resBool : Reprint := aValue.booResult <> GroupValue.booResult;
      end
    end;
    if Reprint then GroupValue := aValue;
  end
end;

procedure TQRGroup.SetFooterBand(Value : TQRBand);
begin
  FFooterBand := Value;
  if FFooterBand <> nil then
  begin
    FFooterBand.BandType := rbGroupFooter;
{$ifdef win32}
    FFooterBand.FreeNotification(self);
{$endif}
  end;
end;

procedure TQRGroup.SetMaster(Value : TComponent);
begin
  if (Value is TQRControllerBand) or
     (Value is TQuickRep) then
  begin
    FMaster := Value;
    ParentReport.RebuildBandList;
    ParentReport.SetBandValues;
{$ifdef win32}
    FMaster.FreeNotification(self);
{$endif}
  end;
end;

procedure TQRGroup.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if (Master = nil) and (AParent is TQuickRep) then
    Master := AParent;
end;

procedure TQRGroup.Prepare;
begin
  Evaluator.DataSets := ParentReport.AllDataSets;
  Evaluator.Prepare(Expression);
  HasResult := false;
end;

procedure TQRGroup.Unprepare;
begin
  Evaluator.Unprepare;
end;

{ TQRFrame }

constructor TQRFrame.Create;
begin
  FWidth := 1;
  FTop := false;
  FBottom := false;
  FLeft := false;
  FRight := false;
  FPenStyle := psSolid;
end;

procedure TQRFrame.DefineProperties(Filer: TFiler);
begin
  Filer.DefineProperty('Mode', ReadMode, WriteDummy, false); { <-- do not resource }
  inherited DefineProperties(Filer);
end;

procedure TQRFrame.ReadMode(Reader : TReader);
begin
  Reader.ReadIdent;
end;

procedure TQRFrame.WriteDummy(Writer : TWriter);
begin
end;

procedure TQRFrame.PaintIt(ACanvas : TCanvas; Rect : TRect; XFact, YFact : extended);
var
  FWX, FWY : integer;
  I : integer;
begin
  FWX := round(XFact / 72 * 254 * FWidth);
  if ((FWX < 1) and (FWidth >= 1)) or (FWidth = -1) then
    FWX := 1;
  FWY := round(YFact / 72 * 254 * FWidth);
  if ((FWY < 1) and (FWidth >= 1)) or (FWidth = -1) then
    FWY := 1;
  SetPen(ACanvas.Pen);
  ACanvas.Brush.Style := bsSolid;
  ACanvas.Brush.Color := Color;
  with aCanvas do
  begin
    if DrawTop then
      for I := 0 to FWY - 1 do
      begin
        MoveTo(Rect.Left, Rect.Top + I);
        LineTo(Rect.Right, Rect.Top + I);
      end;
{      Rectangle(Rect.Left, Rect.Top, Rect.Right, Rect.Top + FWY);}
    if DrawBottom then
      for I := 0 to FWY - 1 do
      begin
        MoveTo(Rect.Left, Rect.Bottom - I);
        LineTo(Rect.Right, Rect.Bottom - I);
      end;
{      Rectangle(Rect.Left, Rect.Bottom, Rect.Right, Rect.Bottom - FWY);}
    if DrawLeft then
      for I := 0 to FWX - 1 do
      begin
        MoveTo(Rect.Left + I, Rect.Top);
        LineTo(Rect.Left + I, Rect.Bottom);
      end;
{      Rectangle(Rect.Left, Rect.Top, Rect.Left + FWX, Rect.Bottom);}
    if DrawRight then
      for I := 0 to FWX - 1 do
      begin
        MoveTo(Rect.Right - I, Rect.Top);
        LineTo(Rect.Right - I, Rect.Bottom);
      end;
{      Rectangle(Rect.Right - FWX, Rect.Top, Rect.Right, Rect.Bottom);}
  end;
  ACanvas.Brush.Style := bsClear;
end;

function TQRFrame.AnyFrame : boolean;
begin
  Result := FTop or FBottom or FLeft or FRight;
end;

procedure TQRFrame.SetColor(Value : TColor);
begin
  FColor := Value;
  Parent.Invalidate;
end;

procedure TQRFrame.SetParent(Value : TControl);
begin
  FParent := Value;
end;

procedure TQRFrame.SetStyle(Value : TPenStyle);
begin
  FPenStyle := Value;
  Parent.Invalidate;
end;

procedure TQRFrame.SetValue(Index : integer; Value : boolean);
begin
  case Index of
    0 : FTop := Value;
    1 : FBottom := Value;
    2 : FLeft := Value;
    3 : FRight := Value;
  end;
  Parent.Invalidate;
end;

procedure TQRFrame.SetWidth(Value : integer);
begin
  FWidth := Value;
  Parent.Invalidate;
end;

procedure TQRFrame.SetPen(APen : TPen);
begin
  aPen.Width := 1;
  aPen.Style := Style;
  aPen.Color := Color;
end;

{ TQRUnitBase }

constructor TQRUnitBase.Create;
begin
  if LocalMeasureInches then
    Units := Inches
  else
    Units := MM;
  SavedUnits := Units;
  FResolution := Screen.PixelsPerInch;
  FParentUpdating := false;
  FZoom := 100;
end;

function TQRUnitBase.GetUnits : TQRUnit;
begin
  result := FUnits;
end;

procedure TQRUnitBase.SetUnits(Value : TQRUnit);
begin
  FUnits := Value;
end;

function TQRUnitBase.LoadUnit(Value : extended; aUnit : TQRUnit; Horizontal : boolean): extended;
begin
  case aUnit of
    MM : result := Value / 10;
    Inches : result := Value / 254;
    Pixels : result := Value / (254 / Resolution) * Zoom / 100;
    Characters : if Horizontal then
                     result := Value/CharWidth(abs(ParentReport.Font.Size)) / 10
                   else
                     result := Value/CharHeight(abs(ParentReport.Font.Size)) / 10;
  else
    result := Value;
  end
end;

function TQRUnitBase.SaveUnit(Value : extended; aUnit : TQRUnit; Horizontal : boolean): extended;
begin
  case aUnit of
    MM : result := Value * 10;
    Inches : result := Value * 254;
    Pixels : result := Value * (254 / Resolution) / Zoom * 100;
    Characters : if Horizontal then
                     result := Value * CharWidth(abs(ParentReport.Font.Size)) * 10
                   else
                     result := Value * CharHeight(abs(ParentReport.Font.Size)) * 10;
  else
    result := Value;
  end;
end;

procedure TQRUnitBase.DefineProperties(Filer: TFiler);
begin
  Filer.DefineProperty('Values', ReadValues, WriteValues, true); {<-- do not resource }
  inherited DefineProperties(Filer);
end;

procedure TQRUnitBase.SetPixels;
begin
  SavedUnits := Units;
  FUnits := Pixels;
end;

procedure TQRUnitBase.Loaded;
begin
  SetParentSizes;
end;

procedure TQRUnitBase.SetParentSizes;
begin
end;

procedure TQRUnitBase.ReadValues(Reader : TReader);
begin
end;

procedure TQRUnitBase.WriteValues(Writer : TWriter);
begin
end;

procedure TQRUnitBase.RestoreUnit;
begin
  FUnits := SavedUnits;
end;

{ TQRBandSize }

constructor TQRBandSize.Create(AParent : TQRCustomBand);
begin
  inherited Create;
  Parent := AParent;
  FWidth := 40;
  FLength := 20;
end;

procedure TQRBandSize.FixZoom;
begin
  SetParentSizes;
end;

function TQRBandSize.GetValue(Index : integer): extended;
begin
  if Index = 0 then
    result := LoadUnit(FLength, Units, false)
  else
    result := LoadUnit(FWidth, Units, true);
end;

procedure TQRBandSize.ReadValues(Reader : TReader);
begin
  Reader.ReadListBegin;
  FLength := Reader.ReadFloat;
  FWidth := Reader.ReadFloat;
  Reader.ReadListEnd;
end;

procedure TQRBandSize.SetParentSizes;
begin
  if assigned(Parent) then
  begin
    ParentUpdating := true;
    Parent.SetBounds(Parent.Left, Parent.Top,
                     round(LoadUnit(FWidth, Pixels, true)),
                     round(LoadUnit(FLength, Pixels, false)));
    ParentUpdating := false;
  end;
end;

procedure TQRBandSize.SetValue(Index : integer; Value : extended);
begin
  case Index of
    0 : FLength := SaveUnit(Value, Units, false);
    1 : FWidth := SaveUnit(Value, Units, true);
  end;
  SetParentSizes;
end;

procedure TQRBandSize.WriteValues(Writer : TWriter);
begin
  Writer.WriteListBegin;
  Writer.WriteFloat(FLength);
  Writer.WriteFloat(FWidth);
  Writer.WriteListEnd;
end;

{ TQRPage }

constructor TQRPage.Create(AParent : TQuickRep);
begin
  inherited create;
  Parent := AParent;
  BottomMargin := 0;
  if LocalMeasureInches then
  begin
    Units := Inches;
    PaperSize := Letter;
    TopMargin := 0.5;
    BottomMargin := 0.5;
    RightMargin := 0.5;
    LeftMargin := 0.5;
  end else
  begin
    Units := MM;
    PaperSize := A4;
    TopMargin := 10;
    BottomMargin := 10;
    LeftMargin := 10;
    RightMargin := 10;
  end;
  FRuler := true;
  FColumns := 1;
end;

function TQRPage.GetValue(Index : integer): extended;
begin
  case index of
    0 : result := LoadUnit(FBottomMargin, Units, false);
    1 : result := LoadUnit(FLength, Units, false);
    2 : result := LoadUnit(FTopMargin, Units, false);
    3 : result := LoadUnit(FWidth, Units, true);
    4 : result := LoadUnit(FLeftMargin, Units, true);
    5 : result := LoadUnit(FRightMargin, Units, true);
  else
    result := LoadUnit(FColumnSpace, Units, true);
  end
end;

procedure TQRPage.FixZoom;
begin
  SetParentSizes;
end;

procedure TQRPage.ReadValues(Reader : TReader);
begin
  Reader.ReadListBegin;
  FBottomMargin := Reader.ReadFloat;
  FLength := Reader.ReadFloat;
  FTopMargin := Reader.ReadFloat;
  FWidth := Reader.ReadFloat;
  FLeftMargin := Reader.ReadFloat;
  FRightMargin := Reader.ReadFloat;
  FColumnSpace := Reader.ReadFloat;
  Reader.ReadListEnd;
  SetParentSizes;
end;

procedure TQRPage.SetColumns(Value : integer);
begin
  if (FColumns <> Value) and (Value > 0) then
  begin
    FColumns := Value;
    if assigned(Parent) then
    begin
      Parent.SetBandValues;
      Parent.Invalidate;
    end
  end
end;

procedure TQRPage.WriteValues(Writer : TWriter);
begin
  Writer.WriteListBegin;
  Writer.WriteFloat(FBottomMargin);
  Writer.WriteFloat(FLength);
  Writer.WriteFloat(FTopMargin);
  Writer.WriteFloat(FWidth);
  Writer.WriteFloat(FLeftMargin);
  Writer.WriteFloat(FRightMargin);
  Writer.WriteFloat(FColumnSpace);
  Writer.WriteListEnd;
end;

function TQRPage.GetPaperSize : TQRPaperSize;
begin
  Result := FPaperSize;
end;

function TQRPage.GetRuler : boolean;
begin
  Result := FRuler;
end;

procedure TQRPage.SetOrientation(Value : TPrinterOrientation);
begin
  FOrientation := Value;
  PaperSize := PaperSize;
end;

procedure TQRPage.SetParentSizes;
begin
  if not ParentUpdating and assigned(Parent) then
  begin
    ParentUpdating := true;
    Parent.Width := round(LoadUnit(FWidth, Pixels, true));
    Parent.Height := round(LoadUnit(FLength, Pixels, false));
    ParentUpdating := false;
  end;
end;

procedure TQRPage.SetValue(Index : integer; Value : extended);
begin
  case index of
    0 : begin
          FBottomMargin := SaveUnit(Value, Units, false);
          SetParentSizes;
          Parent.SetBandValues;
        end;
    1 : if PaperSize=Custom then
        begin
          FLength := SaveUnit(Value, Units, false);
          SetParentSizes;
          Parent.SetBandValues;
        end;
    2 : begin
          FTopMargin := SaveUnit(Value, Units, false);
          Parent.SetBandValues;
          Parent.Invalidate;
        end;
    3 : if PaperSize=Custom then
        begin
          FWidth := SaveUnit(Value, Units, true);
          SetParentSizes;
          Parent.SetBandValues;
        end;
    4 : begin
          FLeftMargin := SaveUnit(Value, Units, true);
          Parent.SetBandValues;
          Parent.Invalidate;
        end;
    5 : begin
          FRightMargin := SaveUnit(Value, Units, true);
          Parent.SetBandValues;
          Parent.Invalidate;
        end;
    6 : begin
          FColumnSpace := SaveUnit(Value, Units, true);
          Parent.SetBandValues;
          Parent.Invalidate;
        end;
  end;
end;

procedure TQRPage.SetRuler(Value : boolean);
begin
  if Value <> FRuler then
  begin
    FRuler := Value;
    if assigned(Parent) then
    begin
      Parent.Invalidate;
      Parent.Units := Parent.Units;
    end
  end
end;

procedure TQRPage.SetUnits(Value : TQRUnit);
begin
  inherited SetUnits(Value);
  if assigned(Parent) then
     Parent.Invalidate;
end;

procedure TQRPage.SetPaperSize(Value : TQRPaperSize);
begin
  if (Value <> Default) and (Value <> Custom) then
  begin
    SetPixels;
    Units := MM;
    PaperSize := Custom;
    if Orientation = poPortrait then
    begin
      Width := cQRPaperSizeMetrics[Value, 0];
      Length := cQRPaperSizeMetrics[Value, 1];
    end else
    begin
      Width := cQRPaperSizeMetrics[Value, 1];
      Length := cQRPaperSizeMetrics[Value, 0];
    end;
    RestoreUnit;
    Parent.SetBandValues;
  end;
  FPaperSize := Value;
end;

{ TQRBasePanel }

constructor TQRBasePanel.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFrame := TQRFrame.Create;
  FFrame.Parent := Self;
  FontSize := 12;
  FZoom := 100;
end;

destructor TQRBasePanel.Destroy;
begin
  FFrame.Free;
  inherited Destroy;
end;

function TQRBasePanel.GetFrame : TQRFrame;
begin
  result := FFrame;
end;

procedure TQRBasePanel.SetFrame(Value : TQRFrame);
begin
  FFrame := Value;
  Invalidate;
end;

procedure TQRBasePanel.SetZoom(Value : integer);
var
  I : integer;
begin
  if Value <> 0 then
  begin
    FZoom := Value;
    for I := 0 to ControlCount - 1 do
    begin
      if Controls[I] is TQRPrintable then
        TQRPrintable(Controls[I]).Zoom := Value
      else if Controls[I] is TQRBasePanel then
        TQRBasePanel(Controls[I]).Zoom := Value;
    end
  end
end;

procedure TQRBasePanel.PaintRuler(Units : TQRUnit);
var
  TotalLines : integer;
  Resolution : integer;
  Factor : extended;
  PaintMinor : boolean;
  PaintNumbers : boolean;

  procedure PaintInches;
  var
    I : integer;
    Major : boolean;
  begin
    PaintMinor := Zoom > 49;
    with Canvas do
    begin
      Factor := Resolution / 4 * Zoom / 100;
      TotalLines := round(Width / Resolution / Zoom * 400);
      for i := 1 to TotalLines do
      begin
        if (i mod 4) = 0 then
        begin
          Pen.Color := cqrRulerMajorColor;
          Pen.Style := cqrRulerMajorStyle;
          Major := true;
        end else
        begin
          Pen.Color := cqrRulerMinorColor;
          Pen.Style := cqrRulerMinorStyle;
          Major := false;
        end;
        if PaintMinor or Major then
        begin
          MoveTo(round(I * Factor), 0);
          LineTo(round(I * Factor), height);
          if PaintNumbers and ((I mod 4) = 0) then TextOut(2 + round(I * Factor), 2, IntToStr(i div 4));
        end;
      end;
      TotalLines := round(Height / Resolution / Zoom * 400);
      for I := 1 to TotalLines do
      begin
        if (i mod 4) = 0 then
        begin
          Pen.Style := cqrRulerMajorStyle;
          Pen.Color := cqrRulerMajorColor;
          Major := true;
        end else
        begin
          Pen.Style := cqrRulerMinorStyle;
          Pen.Color := cqrRulerMinorColor;
          Major := false;
        end;
        if PaintMinor or Major then
        begin
          MoveTo(0, round(I * Factor));
          LineTo(Width,round(I * Factor));
          if ((I mod 4) = 0) and PaintNumbers then TextOut(2, 2 + round(I * Factor), IntToStr(i div 4));
        end
      end
    end
  end;

  procedure PaintMM;
  var
    I : integer;
    Major : boolean;
  begin
    PaintMinor := Zoom > 59;
    with Canvas do
    begin
      Factor := 1 / Resolution * 5.08 / Zoom * 100;
      TotalLines := round(Width * Factor);
      for I := 1 to TotalLines do
      begin
        if (I mod 2) = 1 then
        begin
          Pen.Style := cqrRulerMinorStyle;
          Pen.Color := cqrRulerMinorColor;
          Major := false;
        end else
        begin
          Pen.Color := cqrRulerMajorColor;
          Pen.Style := cqrRulerMajorStyle;
          Major := true;
          if PaintNumbers and PaintMinor then
            TextOut(2 + round(I / Factor), 2, IntToStr(I div 2));
        end;
        if PaintMinor or Major then
        begin
          MoveTo(round(I / Factor), 0);
          LineTo(round(I / Factor), Height);
        end
      end;
      TotalLines := round(Height * Factor);
      for I := 1 to TotalLines do
      begin
        if (I mod 2) = 1 then
        begin
          Pen.Color := cqrRulerMinorColor;
          Pen.Style := cqrRulerMinorStyle;
          Major := false;
        end else
        begin
          Pen.Style := cqrRulerMajorStyle;
          Pen.Color := cqrRulerMajorColor;
          Major := true;
          if PaintNumbers and PaintMinor then
            TextOut(2, 2 + round(I / Factor), IntToStr(I div 2));
        end;
        if PaintMinor or Major then
        begin
          MoveTo(0, round(I / Factor));
          LineTo(width, round(I / Factor));
        end
      end
    end
  end;

  procedure PaintCharacters;
  var
     I : integer;
  begin
    with Canvas do
    begin
      Pen.Style := psDot;
      TotalLines := round(Width / Resolution * 25.4 / CharWidth(FontSize) / 10);
      for I := 1 to TotalLines do
      begin
        MoveTo(round(I * CharWidth(FontSize) * Resolution / 2.54), 0);
        LineTo(Round(I * CharWidth(FontSize) * Resolution / 2.54), Height);
        if PaintNumbers then TextOut(2 + round(I * CharWidth(FontSize) * Resolution / 2.54), 2, IntToStr(I * 10));
      end;
      TotalLines := round(Height / Resolution * 25.4 / CharHeight(FontSize));
      for I := 1 to TotalLines do
      begin
        MoveTo(0, round(I * CharHeight(FontSize) * Resolution / 25.4));
        LineTo(Width, round(I * CharHeight(FontSize) * Resolution / 25.4));
        if PaintNumbers then TextOut(2, 2 + round(I * CharHeight(FontSize) * Resolution / 25.4), IntToStr(I));
      end
    end
  end;

begin
  with Canvas do
  begin
    Resolution := Screen.PixelsPerInch;
    Font.Name := cqrRulerFontName;
    Font.Size := cqrRulerFontSize;
    Font.Color := cqrRulerFontColor;
    Canvas.Pen.Color := clSilver;
    Pen.Width := 1;
    PaintNumbers := self is TQuickRep;
    if Units=Inches then
      PaintInches
    else
      if Units=MM then
        PaintMM
      else
        if Units=Characters then
          PaintCharacters;
    Pen.Style := psSolid;
  end
end;

procedure TQRBasePanel.Paint;
begin
  with Canvas do
  begin
    Brush.Color := Color;
    Brush.Style := bsSolid;
    FillRect(ClientRect);
    Brush.Style := bsClear;
  end
end;

procedure TQRBasePanel.PrepareComponents;
var
  I : integer;
begin
  for I := 0 to ControlCount - 1 do
    if Controls[I] is TQRPrintable then
      TQRPrintable(Controls[I]).Prepare
    else
      if Controls[I] is TQRBasePanel then
        TQRBasePanel(Controls[I]).PrepareComponents;
end;

procedure TQRBasePanel.UnprepareComponents;
var
  I : integer;
begin
  for I := 0 to ControlCount - 1 do
    if Controls[I] is TQRPrintable then
      TQRPrintable(Controls[I]).Unprepare
    else
      if Controls[I] is TQRBasePanel then
        TQRBasePanel(Controls[I]).UnprepareComponents;
end;

{$ifdef ver100}
procedure TQRBasePanel.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  if Params.WndParent = 0 then Params.WndParent := Application.Handle;
end;
{$endif}

{ TQRCustomBand }

constructor TQRCustomBand.Create(AOwner : TComponent);
begin
  FSize := TQRBandSize.Create(Self);
  FParentUpdating := false;
  ParentReport := nil;
  inherited Create(AOwner);
  Align := alNone;
  Caption := '';
  Color := clWhite;
  BevelOuter := bvNone;
  BevelInner := bvNone;
  Enabled := true;
  ButtonDown := false;
  Height := 40;
  LoadedHeight := 40;
end;

destructor TQRCustomBand.Destroy;
begin
  if ParentReport <> nil then
    ParentReport.RemoveBand(Self);
  FSize.Free;
  inherited destroy;
end;

procedure TQRCustomband.DefineProperties(Filer : TFiler);
begin
  Filer.DefineProperty('Align', ReadAlign, WriteDummy, false); {<-- do not resource }
  Filer.DefineProperty('Ruler', ReadRuler, WriteDummy, false); {<-- do not resource }
  Filer.DefineProperty('LinkBand', ReadLinkBand, WriteDummy, false);
  inherited DefineProperties(Filer);
end;

procedure TQRCustomband.ReadAlign(Reader : TReader);
begin
  Reader.ReadIdent;
end;

procedure TQRCustomBand.ReadRuler(Reader : TReader);
begin
  Reader.ReadIdent;
end;

procedure TQRCustomBand.ReadLinkBand(Reader : TReader);
begin
  Reader.Readident;
end;

function TQRCustomBand.GetBandSize : TQRBandSize;
begin
  result := FSize;
end;

procedure TQRCustomBand.WriteDummy(Writer : TWriter);
begin
end;

procedure TQRCustomBand.Loaded;
begin
  inherited Loaded;
  Size.Loaded;
  if (LoadedHeight <> 40) and (Height = 40) then Height := LoadedHeight;
end;

function TQRCustomBand.GetChild : TQRChildBand;
var
  I : integer;
begin
  result := nil;
  if ParentReport <> nil then
  begin
    for I := 0 to ParentReport.BandList.Count - 1 do
    begin
      if (TQRCustomBand(ParentReport.BandList[I]).BandType = rbChild) and
         ((TQRChildBand(ParentReport.BandList[I]).ParentBand) = self) then
      begin
        result := TQRChildBand(ParentReport.BandList[I]);
        break;
      end
    end
  end
end;

function TQRCustomBand.GetHasChild : boolean;
begin
  result := (GetChild <> nil);
end;

procedure TQRCustomBand.SetZoom(Value: integer);
begin
  inherited SetZoom(Value);
  Size.Zoom := Zoom;
  Size.FixZoom;
end;

// modified by hyl
procedure TQRCustomBand.SetHasChild(Value : boolean);
var
  aBand : TQRChildBand;
  aName : string;
  AComponent : TComponent;
begin
  if GetHasChild <> Value then
  begin
    if Value then
    begin
      if csDesigning in ComponentState then
      begin
        AComponent := Owner;
        while not (AComponent is TCustomForm) and (AComponent <> nil) do
          AComponent := AComponent.Owner;
        if AComponent <> nil then
          TForm(AComponent).designer.UniqueName(QRBandComponentName(rbChild));
      end else
        AName := '';
      aBand := TQRChildBand.Create(Owner);
      aBand.Name := aName;
      aBand.Parent := Parent;
      aBand.ParentBand := self;
    end else
    begin
      aBand := GetChild;
      if aBand.HasChild then
        aBand.ChildBand.ParentBand := Self;
      aBand.Free;
    end
  end
end;

function TQRCustomBand.GetUnits : TQRUnit;
begin
  if assigned(FSize) then
    Result := FSize.Units
  else
    Result := Native;
end;

procedure TQRCustomBand.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (ParentReport <> nil) and (ParentReport.State = qrEdit) then
  begin
    if ParentReport.Designer.IsAdding then
    begin
      ParentReport.Designer.AddIt(Self, X, Y);
    end else
    begin
      ParentReport.Designer.EditControl := Self;
      ParentReport.Designer.SetFocusFrame;
      ButtonDown := true;
      LastX := X;
      LastY := Y;
    end
  end
end;

procedure TQRCustomBand.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
  if ButtonDown then
    ParentReport.Designer.MoveFocusFrame(Rect(Left + X - LastX, Top + Y - LastY,
                                              Width + Left + X - LastX, Height + Top + Y - LastY));
end;

procedure TQRCustomBand.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and ButtonDown then
  begin
    ButtonDown := false;
    ReleaseFocusFrame;
    ParentReport.Designer.GetHandles;
  end;
end;

procedure TQRCustomBand.ReleaseFocusFrame;
begin
  MoveRect := ParentReport.Designer.ReleaseFocusFrame;
  if (MoveRect.Bottom - MoveRect.Top) <> Height then
    Height := MoveRect.Bottom - MoveRect.Top;
end;

procedure TQRCustomBand.SetBandType(Value : TQRBandType);
begin
  FQRBandType := Value;
  if assigned(FParentReport) then
  begin
    ParentReport.RebuildBandList;
    ParentReport.SetBandValues;
  end
end;

procedure TQRCustomBand.SetBandSize(Value : TQRBandSize);
begin
  FSize := Value;
end;

procedure TQRCustomBand.SetParent(AParent: TWinControl);
begin
  if (Parent <> nil) and (Parent is TQuickRep) then
    TQuickRep(Parent).RemoveBand(Self);
  if AParent is TQRCustomBand then
    AParent := AParent.Parent;
  inherited SetParent(AParent);
  if (Parent <> nil) and (Parent is TQuickRep) then
  begin
    ParentReport := TQuickRep(AParent);
    ParentReport.AddBand(Self);
    Size.ParentReport := ParentReport;
    Zoom := ParentReport.Zoom;
  end;
end;

procedure TQRCustomBand.SetUnits(Value : TQRUnit);
var
  I : integer;
begin
  if assigned(FSize) then
     FSize.Units := Value;
  Invalidate;
  for I := 0 to ControlCount - 1 do
    if Controls[I] is TQRPrintable then TQRPrintable(Controls[I]).Size.Units := Value;
end;

procedure TQRCustomBand.Paint;
var
  aRect : TRect;
begin
  inherited Paint;
  if assigned(FParentReport) and ParentReport.Page.Ruler then
    PaintRuler(ParentReport.Units);
  with Canvas do
  begin
    Pen.Color := cqrBandFrameColor;
    Pen.Width := 1;
    Pen.Style := cqrBandFrameStyle;
    MoveTo(0, 0);
    LineTo(Width, 0);

    MoveTo(0, Height - 1);
    LineTo(Width - 1, Height - 1);

    MoveTo(0, 0);
    LineTo(0, Height - 1);

    MoveTo(Width - 1, 0);
    LineTo(Width - 1, Height - 1);
    aRect := GetClientRect;
    dec(aRect.Right);
    dec(aRect.Bottom);
    Frame.PaintIt(Canvas, aRect, Screen.PixelsPerInch / 254, Screen.PixelsPerInch / 254);
    Font.Name := cqrRulerFontName;
    Font.Size := cqrRulerFontSize;

    if BandType = rbChild then
      font.color := cqrRulerFontColor
    else
      font.color := cqrRulerFontColor;
    TextOut(2, Height - TextHeight('W') - 4, QRBandTypeName(BandType))
  end
end;

procedure TQRCustomBand.PaintRuler(Units : TQRUnit);
begin
  if ParentReport <> nil then
    FontSize := abs(ParentReport.Font.Size);
  inherited PaintRuler(Units);
end;

procedure TQRCustomBand.AdvancePaper;
begin
  ParentReport.CurrentY := ParentReport.CurrentY + round(size.Length);
end;

function TQRCustomBand.CanExpand(Value : extended) : boolean;
begin
  result := ParentReport.AvailableSpace >= round(Size.Length + Value);
end;

function TQRCustomBand.ExpandBand(Value : extended; var NewTop, OfsX : extended) : boolean;
var
  OldX : extended;
begin
  result := false;
  if not CanExpand(Value) then
  begin
    if ParentReport.FinalPass then
      Frame.PaintIt(ParentReport.QRPrinter.Canvas,
        rect(ParentReport.QRPrinter.XPos(ParentReport.CurrentX),
             ParentReport.QRPrinter.YPos(ParentReport.CurrentY),
             ParentReport.QRPrinter.XPos(ParentReport.CurrentX + Size.Width),
             ParentReport.QRPrinter.Ypos(ParentReport.CurrentY + Size.Length)),
        ParentReport.QRPrinter.XFactor, ParentReport.QRPrinter.YFactor);
  end;
  Size.Length := Size.Length + Value;
  BandFrameRect := rect(ParentReport.QRPrinter.XPos(ParentReport.CurrentX),
                        ParentReport.QRPrinter.YPos(ParentReport.CurrentY),
                        ParentReport.QRPrinter.XPos(ParentReport.CurrentX + Size.Width),
                        ParentReport.QRPrinter.YPos(ParentReport.CurrentY + Size.Length));
  if ParentReport.AvailableSpace < round(Size.Length) then
  begin
    {print band frame;}
    OldX := ParentReport.CurrentX;
    ParentReport.NewColumn;
    Size.Length := Value;
    result := true;
    NewTop := ParentReport.CurrentY;
    OfsX := ParentReport.CurrentX - OldX;
  end;
end;

function TQRCustomBand.AddPrintable(PrintableClass : TQRNewComponentClass) : TQRPrintable;
var
  aPrintable : TQRPrintable;
  I : integer;
  MaxX : integer;
begin
  aPrintable := PrintableClass.Create(Owner);
  aPrintable.Parent := Self;
  MaxX := 1;
  for I := 0 to ControlCount-1 do
    if (Controls[I] is TQRPrintable) and
      ((TQRPrintable(Controls[I]).Left + TQRPrintable(Controls[I]).Width) > MaxX) then
      MaxX := TQRPrintable(Controls[I]).Left + TQRPrintable(Controls[I]).Width + 10;
  aPrintable.Left := MaxX;
  result := aPrintable;
end;

procedure TQRCustomBand.MakeSpace;
begin
  if (BandType <> rbPageFooter) and (ParentReport.AvailableSpace <= round(Size.Length)) then
    ParentReport.NewColumn;
end;

procedure TQRCustomBand.Print;
var
  I : integer;
  OrgLength : extended;
  PrintBand : boolean;
  MyChild : TQRChildBand;
{ bug : Non-overlapped band frames not displayed in the preview - Begin}
{ Add Following Lines }
  FWX, FWY : Integer;
  InRect : TRect;
{ bug : Non-overlapped band frames not displayed in the preview - End}

begin
  PrintBand := Enabled;
  if Enabled and assigned(FBeforePrintEvent) and not (csDesigning in ComponentState) then
    FBeforePrintEvent(Self, PrintBand);
  if PrintBand then
  begin
    if ForceNewPage and not (BandType in [rbPageHeader, rbPageFooter, rbTitle, rbOverlay]) then
      ParentReport.ForceNewPage
    else
      if ForceNewColumn and not (BandType in [rbPageHeader, rbPageFooter, rbTitle, rbOverlay]) then
        ParentReport.ForceNewColumn;
    BandFrameRect := rect(ParentReport.QRPrinter.XPos(ParentReport.CurrentX),
                          ParentReport.QRPrinter.YPos(ParentReport.CurrentY),
                          ParentReport.QRPrinter.XPos(ParentReport.CurrentX + Size.Width),
                          ParentReport.QRPrinter.YPos(ParentReport.CurrentY + Size.Length));
    if ParentReport.FinalPass then
    begin
      with ParentReport.QRPrinter.Canvas do
      begin
{ bug : Non-overlapped band frames not displayed in the preview - Begin}
{ Add Following Lines }
        FWX := round(ParentReport.QRPrinter.XFactor / 72 * 254);
        if (FWX < 1) then
          FWX := 1;
        FWY := round(ParentReport.QRPrinter.YFactor / 72 * 254);
        if (FWY < 1) then
          FWY := 1;
        InRect := rect(ParentReport.QRPrinter.XPos(ParentReport.CurrentX) + FWX,
          ParentReport.QRPrinter.YPos(ParentReport.CurrentY) + FWY,
          ParentReport.QRPrinter.XPos(ParentReport.CurrentX + Size.Width),
          ParentReport.QRPrinter.YPos(ParentReport.CurrentY + Size.Length));
{ bug : Non-overlapped band frames not displayed in the preview - End}
        Brush.Color := Self.Color;
        Brush.Style := bsSolid;
{ bug : Non-overlapped band frames not displayed in the preview - Begin}
{ Replace Following Lines }
{        FillRect(BandFrameRect); }
         FillRect(InRect);  { <- line changed }
{ bug : Non-overlapped band frames not displayed in the preview - End}
      end;
    end;
    Expanded := 0;
    OrgLength := Size.Length;
    for I := 0 to ControlCount - 1 do
    begin
      if Controls[I] is TQRPrintable then
      begin
        if TQRPrintable(Controls[I]).Enabled then
          TQRPrintable(Controls[I]).Print(ParentReport.CurrentX, ParentReport.CurrentY + Expanded);
      end;
    end;
    if ParentReport.FinalPass then
      Frame.PaintIt(ParentReport.QRPrinter.Canvas, BandFrameRect, ParentReport.QRPrinter.XFactor,
                    ParentReport.QRPrinter.YFactor);
    AdvancePaper;
    Size.Length := OrgLength;
  end;
  if assigned(FAfterPrintEvent) and not (csDesigning in ComponentState) then
    FAfterPrintEvent(self, PrintBand);
  if HasChild then
  begin
    MyChild := ChildBand;
    if BandType = rbPageFooter then
      MyChild.BandType := rbPageFooter;
    MyChild.MakeSpace;
    ParentReport.PrintBand(MyChild);
    MyChild.BandType := rbChild;
  end;
end;

procedure TQRCustomBand.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = LinkBand) then
    LinkBand := nil;
end;

procedure TQRCustomBand.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  aUnit : TQRUnit;
  I : integer;
begin
  if (not assigned(FSize)) or (csLoading in ComponentState) then
  begin
    if csLoading in ComponentState then
      if AHeight <> 40 then LoadedHeight := AHeight;
  end else
  begin
    if ParentReport = nil then
      inherited SetBounds(ALeft, ATop, AWidth, AHeight);
    if Size.ParentUpdating then
    begin
      inherited SetBounds(ALeft, ATop, AWidth, AHeight);
      if not ParentUpdating and assigned(FParentReport) then
        ParentReport.SetBandValues;
      for I := 0 to ControlCount - 1 do
        if Controls[I] is TQRPrintable then
          with TQRPrintable(Controls[I]) do
            if AlignToBand then
              QRNotification(self, qrBandSizeChange);
    end else
    begin
      aUnit := Size.Units;
      Size.Units := Pixels;
      if aHeight <> Size.Length then Size.Length := aHeight;
{      if aWidth <> Size.Width then Size.Width := aWidth;}
      if (aTop <> Top) or (aLeft <> Left) then
      begin
        inherited SetBounds(aLeft, ATop, Width, Height);
        ParentReport.SetBandValues;
      end;
      Size.Units := aUnit
    end;
  end;
end;

function TQRCustomBand.StretchHeight(IncludeNext : Boolean): Integer;
var
  i : integer;
begin
  Result := 0;
  for i := 0 to ControlCount - 1 do
  begin
  end;
  if Assigned(FLinkBand) and IncludeNext then
    Result := Result + LinkBand.StretchHeight(True) + LinkBand.Height;
end;

procedure TQRCustomBand.SetLinkBand(Value : TQRCustomBand);
var
  aBand : TQRCustomBand;
begin
  aBand := Value;
  while (aBand <> Self) and (aBand <> nil) do
    aBand := aBand.LinkBand;
  if aBand = nil then
    FLinkBand := Value
  else
  begin
    if csDesigning in ComponentState then
      ShowMessage(LoadStr(SqrNoCircular));
  end;
end;

{ TQRChildBand }

constructor TQRChildBand.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  BandType := rbChild;
end;

procedure TQRChildBand.SetParentBand(Value : TQRCustomBand);
var
  aBand : TQRCustomBand;
begin
  aBand := Value;
  while (aBand <> Self) and (aBand <> nil) do
  begin
    if aBand is TQRChildBand then
      aBand := TQRChildBand(aBand).ParentBand
    else
      aBand := nil;
  end;
  if aBand = nil then
  begin
    FParentBand := Value;
    ParentReport.RebuildBandList;
    ParentReport.SetBandValues;
  end else
  begin
    if csDesigning in ComponentState then
      ShowMessage(LoadStr(SqrNoCircular));
  end;
end;

{ TQRControllerBand }

constructor TQRControllerBand.Create(AOwner : TComponent);
begin
  FController := TQRController.Create(Self);
  FController.SelfCheck := Self;
  inherited Create(AOwner);
  FController.Detail := Self;
  FController.Header := nil;
  FController.Footer := nil;
end;

destructor TQRControllerBand.Destroy;
begin
  FController.Free;
  inherited Destroy;
end;

procedure TQRControllerBand.RegisterBands;
begin
  ParentReport.RegisterBand(Self);
end;

procedure TQRControllerBand.SetMaster(Value : TComponent);
var
  aComponent : TComponent;
begin
  if Value <> TControl(Self) then
  begin
    aComponent := Value;
    while (aComponent <> Self) and (aComponent <> nil) do
    begin
      if aComponent is TQRControllerBand then
        aComponent := TQRControllerBand(aComponent).Master
      else
        aComponent := nil;
    end;
    if aComponent = nil then
    begin
      FMaster := Value;
      Controller.Master := Value;
      if (ParentReport <> nil) and not (csDestroying in ParentReport.ComponentState) then
      begin
        ParentReport.RebuildBandList;
        ParentReport.SetBandValues;
      end;
  {$ifdef win32}
      if Assigned(Value) then Value.FreeNotification(Self);
  {$endif}
    end else
    begin
      if csDesigning in ComponentState then
        ShowMessage(LoadStr(SqrNoCircular));
    end;
  end;
end;

procedure TQRControllerBand.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if (Master = nil) and (AParent is TQuickRep) then
    Master := AParent;
end;

function TQRControllerBand.GetPrintIfEmpty : boolean;
begin
  Result := FController.PrintIfEmpty;
end;

procedure TQRControllerBand.SetPrintIfEmpty(Value : boolean);
begin
  FController.PrintIfEmpty := Value;
end;

{ TQRSubDetailGroupBands }

constructor TQRSubDetailGroupBands.Create(AOwner : TQRSubDetail);
begin
  inherited Create;
  Owner := AOwner;
end;

function TQRSubDetailGroupBands.GetHasFooter : boolean;
begin
  Result := Owner.FooterBand <> nil;
end;

function TQRSubDetailGroupBands.GetHasHeader : boolean;
begin
  Result := Owner.HeaderBand <> nil;
end;

function TQRSubDetailGroupBands.GetHeaderBand : TQRCustomBand;
begin
  Result := Owner.HeaderBand;
end;

function TQRSubDetailGroupBands.GetFooterBand : TQRCustomBand;
begin
  Result := Owner.FooterBand;
end;

procedure TQRsubDetailGroupBands.SetHasHeader(Value : boolean);
begin
  if Value then
  begin
    if not HasHeader then
      Owner.HeaderBand := Owner.ParentReport.CreateBand(rbGroupHeader)
  end else
  begin
    if HasHeader then
    begin
      HeaderBand.Free;
      Owner.HeaderBand := nil;
    end
  end
end;

procedure TQRSubDetailGroupBands.SetHasFooter(Value : boolean);
begin
  if Value then
  begin
    if not HasFooter then
      Owner.FooterBand := Owner.ParentReport.CreateBand(rbGroupFooter);
  end else
  begin
    if HasFooter then
    begin
      FooterBand.Free;
      Owner.FooterBand := nil;
    end
  end
end;

{ TQRSubDetail }

constructor TQRSubDetail.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  BandType := rbSubDetail;
  Bands := TQRSubDetailGroupBands.Create(Self);
end;

destructor TQRSubDetail.Destroy;
begin
  Bands.Free;
  inherited Destroy;
end;

procedure TQRSubDetail.AddNotifyClient(Value : TQRPrintable);
begin
  Controller.AddNotifyClient(Value);
end;

function TQRSubDetail.GetDataSet : TDataSet;
begin
  Result := Controller.DataSet;
end;

function TQRSubDetail.GetOnNeedData : TQROnNeedDataEvent;
begin
  Result := Controller.OnNeedData;
end;

function TQRSubDetail.GetPrintBefore : boolean;
begin
  Result := Controller.PrintBefore;
end;

procedure TQRSubDetail.SetDataSet(Value : TDataSet);
begin
  Controller.DataSet := Value;
end;

procedure TQRSubDetail.SetOnNeedData(Value : TQROnNeedDataEvent);
begin
  Controller.OnNeedData := Value;
end;

function TQRSubDetail.GetFooterBand : TQRCustomBand;
begin
  Result := Controller.Footer;
end;

function TQRSubDetail.GetHeaderBand : TQRCustomBand;
begin
  Result := Controller.Header;
end;

procedure TQRSubDetail.RegisterBands;
begin
  if not (csDestroying in ComponentState) then
  begin
    if HeaderBand <> nil then ParentReport.RegisterBand(HeaderBand);
    ParentReport.RegisterBand(Self);
    if FooterBand <> nil then ParentReport.RegisterBand(FooterBand);
  end;
end;

procedure TQRSubDetail.SetFooterBand(Value : TQRCustomBand);
begin
  Controller.Footer := Value;
  if Controller.Footer <> nil then
  begin
    Controller.Footer.BandType := rbGroupFooter;
{$ifdef win32}
    Controller.Footer.FreeNotification(self);
{$endif}
  end
end;

procedure TQRSubDetail.SetHeaderBand(Value : TQRCustomBand);
begin
  Controller.Header := Value;
  if Controller.Header <> nil then
  begin
    Controller.Header.BandType := rbGroupHeader;
{$ifdef win32}
    Controller.Header.FreeNotification(self);
{$endif}
  end
end;

procedure TQRSubDetail.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if AComponent = FooterBand then
      FooterBand := nil;
    if AComponent = HeaderBand then
      HeaderBand := nil;
    if AComponent = DataSet then
      DataSet := nil;
    if AComponent = Master then
      Master := nil;
  end
end;

procedure TQRSubDetail.SetPrintBefore(Value : boolean);
begin
  if Value <> PrintBefore then
  begin
    Controller.PrintBefore := Value;
    if ParentReport <> nil then
    begin
      ParentReport.RebuildBandList;
      ParentReport.SetBandValues;
    end;
  end
end;

{ TQuickRepBands }

constructor TQuickRepBands.Create(AOwner : TQuickRep);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TQuickRepBands.BandInList(BandType : TQRBandType) : TQRCustomBand;
var
  I : integer;
begin
  result := nil;
  if assigned(FOwner) and (FOwner.BandList <> nil) then
  begin
    for I := 0 to FOwner.BandList.Count - 1 do
    begin
      if TQRCustomBand(FOwner.BandList[I]).BandType = BandType then
      begin
        result := TQRCustomBand(FOwner.BandList[I]);
        break;
      end
    end
  end
end;

function TQuickRepBands.GetHasBand(Index : integer) : boolean;
begin
  case Index of
    1 : result := BandInList(rbTitle) <> nil;
    2 : result := BandInList(rbPageHeader) <> nil;
    3 : result := BandInList(rbColumnHeader) <> nil;
    4 : result := BandInList(rbDetail) <> nil;
    5 : result := false;
    6 : result := BandInList(rbPageFooter) <> nil;
  else
    result := BandInList(rbSummary) <> nil;
  end
end;

function TQuickRepBands.GetBand(Index : integer) : TQRCustomBand;
begin
  case Index of
    1 : result := BandInList(rbTitle);
    2 : result := BandInList(rbPageHeader);
    3 : result := BandInList(rbColumnHeader);
    4 : result := BandInList(rbDetail);
    5 : result := nil;
    6 : result := BandInList(rbPageFooter);
  else
    result := BandInList(rbSummary);
  end;
end;

procedure TQuickRepBands.SetBand(BandType : TQRBandType; Value : boolean);
var
  aBand : TQRCustomBand;
begin
  if (BandInList(BandType) <> nil) <> Value then
  begin
    if Value then
      TQuickRep(FOwner).CreateBand(BandType)
    else
    begin
      aBand := BandInList(BandType);
      aBand.Free;
    end
  end
end;

procedure TQuickRepBands.SetHasBand(Index : integer; Value : boolean);
begin
  case Index of
    1 : SetBand(rbTitle, Value);
    2 : SetBand(rbPageHeader, Value);
    3 : SetBand(rbColumnHeader, Value);
    4 : SetBand(rbDetail, Value);
    5 : ;
    6 : SetBand(rbPageFooter, Value);
    7 : SetBand(rbSummary, Value);
  end;
end;

{$ifdef win32}

{ TQRCreateReportTread - class for background preparing/printing. 32 bit only }

constructor TQRCreateReportThread.Create(AReport : TQuickRep);
begin
  FQuickRep := AReport;
  FreeOnTerminate := true;
  FQRPrinter := AReport.QRPrinter;
  inherited Create(false);
end;

procedure TQRCreateReportThread.Execute;
begin
  FQuickRep.CreateReport(false);
  FQRPrinter.Free;
end;

{$endif}

{ TQuickRep }

constructor TQuickRep.Create(AOwner : TComponent);
{$ifdef ver100}
begin
  CreateNew(AOwner);
  if (ClassType <> TQuickRep) and not (csDesigning in ComponentState) then
    InitInheritedComponent(Self, TQuickRep)
end;

constructor TQuickRep.CreateNew(AOwner : TComponent);
{$endif}
begin
  inherited Create(AOwner);
  FBandList := TList.Create;
  BandRegList := TList.Create;
  FDescription := TStringList.Create;
  FBands := TQuickRepBands.Create(self);
  FPage := TQRPage.Create(self);
  FPrinterSettings := TQuickRepPrinterSettings.Create;
  Color := clWhite;
  Top := 0;
  Left := 0;
  Page.ParentReport := Self;
  SnapToGrid := True;
  State := qrAvailable;
  FReportTitle := '';
  FAvailable := true;
  FExporting := false;
  FFinalPass := true;
  FExportFilter := nil;
  AfterPreview := nil;
  AfterPrint := nil;
  ShowProgress := true;
  FHideBands := false;
  FRotateBands := 0;
  Options := [FirstPageHeader, LastPageFooter];
  Font.Name := 'Arial'; { do not resource }
  Font.Size := 10;
{$ifdef ver100}
  aController := TQRController.Create(nil);
{$else}
  aController := TQRController.Create(Self);
{$endif}
  aController.ParentReport := Self;
  aController.SelfCheck := Self;
  ReferenceDC := CreateCompatibleDC(0);
  QRPrinter := TQRPrinter.Create;
  Page.PaperSize := QRPrinter.PaperSize;
  QRPrinter.Free;
  FQRPrinter := nil;
  if Owner is {$ifdef VER100}TCustomForm{$else}TForm{$endif} then
    TForm(Owner).Scaled := false;
end;

destructor TQuickRep.Destroy;
begin
  if State = qrEdit then FDesigner.StopEdit;
  DeleteDC(ReferenceDC);
  if FExportFilter <> nil then FExportFilter.Free;
  FDescription.Free;
  aController.Free;
  FPrinterSettings.Free;
  FPage.Free;
  BandRegList.Free;
  FBandList.Free;
  FBands.Free;
  inherited Destroy;
end;

// modified by hyl
function TQuickRep.CreateBand(BandType : TQRBandType) : TQRBand;
var
  Designer: IDesigner;
  BandOwner: TComponent;
  aName : string;
  aBand : TQRBand;

  function FindDesigner: IDesigner;
  var
    Component: TComponent;
  begin
    Result := nil;
    if csDesigning in ComponentState then
    begin
      Component := Owner;
      while not (Component is TCustomForm) and
        (Component <> nil) do
        Component := Component.Owner;
      Result := TCustomForm(Component).Designer;
    end
  end;

begin
  Designer := FindDesigner;
{$ifdef ver100}
  BandOwner := nil;
  if Designer <> nil then BandOwner := Designer.GetRoot;
  if BandOwner = nil  then BandOwner := Owner;
  if BandOwner = nil then BandOwner := Self;
{$else}
  BandOwner := Owner;
{$endif}
  aBand := TQRBand.Create(BandOwner);
  Result := aBand;
  result.Parent := Self;
  result.BandType := BandType;
  {$ifdef win32}
  if Designer <> nil then
  begin
    aName := QRBandComponentName(BandType);
    if Copy(aName, 1, 1) = 'T' then
      aName := 'T'+ aName;
    Result.Name := Designer.UniqueName(aName);
    Designer.Modified;
  end else
{$endif}
    Result.Name := UniqueName(BandOwner, QRBandComponentName(BandType));
end;

function TQuickRep.GetUnits : TQRUnit;
begin
  Result := Page.Units;
end;

function TQuickRep.GetDataSet : TDataSet;
begin
  Result := aController.DataSet;
end;

function TQuickRep.TextHeight(aFont : TFont; aText : string) : integer;
var
  SavedFont : THandle;
  Extent : TSize;
begin
  SavedFont := SelectObject(ReferenceDC, aFont.Handle);
  if GetTextExtentPoint(ReferenceDC, 'A', Length(aText), Extent) then
    result := Extent.cY
  else
    result := 0;
  SelectObject(ReferenceDC,SavedFont);
end;

function TQuickRep.TextWidth(aFont : TFont; aText : string) : integer;
var
  SavedFont : THandle;
  Extent : TSize;
{$ifndef win32}
  aPChar : array[0..255] of char;
{$endif}
begin
  SavedFont := SelectObject(ReferenceDC, aFont.Handle);
{$ifdef win32}
  if GetTextExtentPoint(ReferenceDC, PChar(aText), Length(aText), Extent) then
{$else}
  StrPCopy(aPChar, aText);
  if GetTextExtentPoint(ReferenceDC, aPChar, Length(aText), Extent) then
{$endif}
    result := Extent.cX + 1
  else
    result := 0;
  SelectObject(ReferenceDC,SavedFont);
end;

procedure TQuickRep.SetDataSet(Value : TDataSet);
begin
  aController.DataSet := Value;
end;

procedure TQuickRep.SetDescription(Value : TStrings);
begin
  FDescription.Assign(Value);
end;

function TQuickRep.GetPrintIfEmpty : boolean;
begin
  if assigned(aController) then
    Result := aController.PrintIfEmpty
  else
    Result := false;
end;

procedure TQuickRep.SetPrintIfEmpty(Value : boolean);
begin
  if assigned(aController) then
    aController.PrintIfEmpty := Value;
end;

function TQuickRep.GetRecordNumber : integer;
begin
  if assigned(aController) then
    Result := aController.DetailNumber
  else
    Result := 0;
end;

function TQuickRep.GetRecordCount : integer;
begin
  result := 1;
  if DataSetOK(DataSet) then
    begin
      try
        result := DataSet.RecordCount;
      except
        result := 0;
      end;
    end
end;

procedure TQuickRep.AddNotifyClient(Value : TQRPrintable);
begin
  aController.AddNotifyClient(Value);
end;

procedure TQuickRep.SetHideBands(Value : boolean);
begin
  if Value <> FHideBands then
  begin
    FHideBands := Value;
    SetBandValues;
  end;
end;

procedure TQuickRep.SetRotateBands(Value : integer);
begin
  if Value <> FRotateBands then
  begin
    FRotateBands := Value;
    RebuildBandList;
    SetBandValues;
  end;
end;

procedure TQuickRep.SetZoom(Value : integer);
begin
  if (Value > 0) and (Value <= 300) then
  begin
    inherited SetZoom(Value);
    Page.Zoom := Zoom;
    Page.FixZoom;
    SetBandValues;
  end
end;

procedure TQuickRep.AddBand(ABand : TQRCustomBand);
begin
  if FBandList.IndexOf(ABand) < 0 then
  begin
    FBandList.Add(ABand);
    RebuildBandList;
    SetBandValues;
  end
end;

procedure TQuickRep.ResetPageFooterSize;
var
  I : integer;
  aBand : TQRCustomBand;
begin
  FPageFooterSize := 0;
  for I := 0 to ControlCount - 1 do
  begin
    if Controls[I] is TQRCustomBand then
      with TQRCustomBand(Controls[I]) do
      begin
        if (BandType = rbPageFooter) and Enabled then
        begin
          FPageFooterSize := FPageFooterSize + Size.Length;
          aBand := TQRCustomBand(Self.Controls[I]);
          while aBand.HasChild do
          begin
            aBand := aBand.ChildBand;
            FPageFooterSize := FPageFooterSize + aBand.Size.Length;
          end;
        end;
      end
  end
end;

procedure TQuickRep.PrintBand(ABand : TQRCustomBand);
begin
  if ABand <> nil then
  begin
    if ABand.AlignToBottom then
    begin
      if Page.Orientation = poPortrait then
        CurrentY := round(QRPrinter.PaperLength - Page.BottomMargin - ABand.Size.Length - FPageFooterSize)
      else
        CurrentY := round(QRPrinter.PaperWidth - Page.BottomMargin - ABand.Size.Length - FPageFooterSize);
    end;
    ABand.Print;
  end
end;

procedure TQuickRep.ForceNewColumn;
begin
  if (not Available) then
  begin
    if NewColumnForced or (CurrentColumn > 1) then
      NewColumn
    else
      NewColumnForced := true;
  end;
end;

procedure TQuickRep.ForceNewPage;
begin
  if not Available then
  begin
    if NewPageForced or (PageNumber > 1) then
    begin
      repeat
        NewColumn
      until CurrentColumn = 1
    end else
      NewPageForced := true;
  end;
end;

procedure TQuickRep.CreateReport(CompositeReport : boolean);
var
  I : integer;
  PrintReport : boolean;
  SavedUnits : TQRUnit;
begin
  if Available then
  begin
    FAvailable := false;
    FLastPage := false;
    NewColumnForced := false;
    NewPageForced := false;
    PrintReport := true;
    try
      FAllDataSets := TList.Create;
      {$ifndef ver100}
      if Parent is TForm then
        for I := 0 to TForm(Parent).ComponentCount - 1 do
        if TForm(Parent).Components[I] is TDataset then
          FAllDatasets.Add(TDataset(TForm(Parent).Components[I]));
      {$else}
        if Parent is TCustomForm then
        for I := 0 to TCustomForm(Parent).ComponentCount - 1 do
        if TCustomForm(Parent).Components[I] is TDataset then
          FAllDatasets.Add(TDataset(TCustomForm(Parent).Components[I]));
      {$endif}
      if assigned(FBeforePrintEvent) and not (csDesigning in ComponentState) then
        FBeforePrintEvent(Self, PrintReport);
      if PrintReport then
      try
        SavedUnits := Units;
        Units := Native;
        if not CompositeReport then
        begin
          SetPrinterValues;
          QRPrinter.Title := ReportTitle;
          QRPrinter.Compression := Compression in Options;
          QRPrinter.BeginDoc;
          FCurrentY := round(Page.Length);
          FPageCount := 0;
          FCurrentColumn := 1;
          if Exporting then ExportFilter.Start(round(Page.Width), round(Page.Length), Font);
        end else
        begin
          FCurrentColumn := 1;
        end;
        ResetPageFooterSize;
        for I := 0 to ControlCount - 1 do
        begin
          if Controls[I] is TQRCustomBand then
            TQRCustomBand(Controls[I]).ParentReport := self
          else
            if Controls[I] is TQRPrintable then
              TQRPrintable(Controls[I]).ParentReport := self;
        end;
        FCurrentX := round(Page.LeftMargin);
        with aController do
        begin
          Detail := Bands.DetailBand;
          Header := Bands.TitleBand;
          Footer := Bands.SummaryBand;
          Prepare;
          OnNeedData := Self.OnNeedData;
          PrepareComponents;
          if not CompositeReport then NewPage;
          Execute;
        end;
        if not CompositeReport then
        begin
          FCurrentX := round(Page.LeftMargin);
          FLastPage := true;
          if not QRPrinter.Cancelled then EndPage;
          if Exporting then ExportFilter.Finish;
        end;
        Units := SavedUnits;
        UnprepareComponents;
      finally
        if not QRPrinter.Cancelled and not CompositeReport then
        begin
          if FinalPass then
            QRPrinter.EndDoc
          else
            QRPrinter.AbortDoc;
        end;
      end;
    finally
      FAllDataSets.Free;
    end;
    FAvailable := true;
  end;{// else
//    raise EQRError.Create(LoadStr(SqrQuickRepBusy));}
end;

procedure TQuickRep.SetPrinterValues;
begin
{ Bug : Printer settings are always replaced with the system printer default settings - Begin}
{ The following line move from ending or procedure }
  QRPrinter.PrinterIndex := PrinterSettings.PrinterIndex;
{ Bug : Printer settings are always replaced with the system printer default settings - End}

  QRPrinter.PaperSize := Page.PaperSize;
  if QRPrinter.PaperSize = Custom then
  begin
    QRPrinter.PaperWidth := round(Page.Width);
    QRPrinter.PaperLength := round(Page.Length);
  end;
  QRPrinter.Orientation := Page.Orientation;
  QRPrinter.Copies := PrinterSettings.Copies;
  QRPrinter.OutputBin := PrinterSettings.OutputBin;
  QRPrinter.FirstPage := PrinterSettings.FirstPage;
  QRPrinter.LastPage := PrinterSettings.LastPage;

{ Bug : Printer settings are always replaced with the system printer default settings }
{ Move the following line to beginning }
{  QRPrinter.PrinterIndex := PrinterSettings.PrinterIndex; }
end;

procedure TQuickRep.Print;
var
  AProgress : TQRProgressForm;
begin
  AProgress := nil;
  if PrepareQRPrinter and QRPrinter.PrinterOK then
  try
    QRPrinter.Destination := qrdPrinter;
    AProgress := TQRProgressForm.Create(Application);
    AProgress.QRPrinter := QRPrinter;
    if ShowProgress then AProgress.Show;
    QRPrinter.MessageReceiver := AProgress;
    CreateReport(false);
  finally
    QRPrinter.Free;
    QRPrinter := nil;
    AProgress.Free;
  end;
end;

procedure TQuickRep.PreviewFinished(Sender : TObject);
begin
  if assigned(FAfterPreviewEvent) then
    FAfterPreviewEvent(Self);
end;

procedure TQuickRep.PrintFinished(Sender : TObject);
begin
  if assigned(FAfterPrintEvent) then
    FAfterPrintEvent(Self);
end;

function TQuickRep.PrepareQRPrinter : boolean;
var
  aReceiver : TWinControl;
begin
  Result := Available;
  if Result then
  begin
    if assigned(FQRPrinter) then
      AReceiver := QRPrinter.MessageReceiver
    else
      AReceiver := nil;
    QRPrinter := TQRPrinter.Create;
    QRPrinter.MessageReceiver := AReceiver;
    QRPrinter.AfterPreview := PreviewFinished;
    QRPrinter.AfterPrint := PrintFinished;
  end;
end;

procedure TQuickRep.PrintBackground;
begin
  if PrepareQRPrinter and QRPrinter.PrinterOK then
  begin
    QRPrinter.Destination := qrdPrinter;
{$ifdef win32}
    BGThread := TQRCreateReportThread.Create(Self);
{$else}
    CreateReport(false);
    QRPrinter.Free;
{$endif}
  end;
end;

procedure TQuickRep.Prepare;
begin
  if PrepareQRPrinter and not QRPrinter.ShowingPreview then
  begin
    QRPrinter.Destination := qrdMetafile;
    QRPrinter.OnExportToFilter := ExportToFilter;
    if assigned(FOnPreviewEvent) then
      QRPrinter.OnPreview := FOnPreviewEvent;
    Application.ProcessMessages;
    CreateReport(false);
  end;
end;

procedure TQuickRep.Preview;
var
  aQRPrinter : TQRPrinter;
begin
  AQRPrinter := nil;
  if PrepareQRPrinter and not QRPrinter.ShowingPreview then
  try
    QRPrinter.Destination := qrdMetafile;
    QRprinter.OnGenerateToPrinter := Print;
    QRPrinter.OnPrintSetup := PrinterSetup;
    QRPrinter.OnExportToFilter := ExportToFilter;
    QRPrinter.Title := ReportTitle;
    if assigned(FOnPreviewEvent) then
      QRPrinter.OnPreview := FOnPreviewEvent;
    QRPrinter.Preview;
    Application.ProcessMessages;
    CreateReport(false);
    AQRPrinter := QRPrinter;
    repeat
      Application.ProcessMessages
    until (not AQRPrinter.ShowingPreview) or Application.Terminated;
  finally
    AQRPrinter.Free;
    QRPrinter := nil;
  end;
end;

procedure TQuickRep.PrinterSetup;
begin
  with TPrintDialog.Create(Self)do
{ Bug - Number of pages not correct in printer setup dialog - Begin }
{ Replace Follow Lines }
{  try
    if PrepareQRPrinter and QRPrinter.PrinterOK then }
   try
     if assigned(FQRPrinter) then
       if LastPageCount < QRPrinter.PageCount then
         LastPageCount := QRPrinter.PageCount;
     if PrepareQRPrinter then
       QRPrinter.PageCount := LastPageCount
     else
       Exit;
     if QRPrinter.PrinterOK then
{ Bug - Number of pages not correct in printer setup dialog - End }
       begin
{ Bug - Number of pages not correct in printer setup dialog - Begin }
{ Replace Follow Lines }
{         if (QRPrinter.Status = mpFinished) then }
         if (QRPrinter.Status = mpReady) then
{ Bug - Number of pages not correct in printer setup dialog - End }

         begin
           MinPage := 1;
           MaxPage := QRPrinter.PageCount;
           FromPage := 1;
           ToPage := MaxPage;
         end;
         Copies := PrinterSettings.Copies;
         Options := [poPageNums, poSelection, poWarning];
         if Execute then
         begin
           PrinterSettings.PrinterIndex := Printers.Printer.PrinterIndex;
           PrinterSettings.Copies := Copies;
           Page.Orientation := Printer.Orientation;
           case PrintRange of
             prAllPages,
             prSelection : begin
                            PrinterSettings.FirstPage := 0;
                            PrinterSettings.LastPage := 0;
                          end;
             prPageNums : begin
                            PrinterSettings.FirstPage := FromPage;
                            PrinterSettings.LastPage := ToPage;
                          end;
           end;
         end;
       end;
  finally
    free;
  end
end;

procedure TQuickRep.ExportToFilter(AFilter : TQRExportFilter);
var
  OldQRPrinter : TQRPrinter;
  AProgress : TQRProgressForm;
begin
  aProgress := nil;
  ExportFilter := AFilter;
  FFinalPass := false;
  OldQRPrinter := QRPrinter;
  try
    QRPrinter := TQRPrinter.Create;
    AProgress := TQRProgressForm.Create(Application);
    AProgress.QRPrinter := QRPrinter;
    if ShowProgress then AProgress.Show;
    QRPrinter.MessageReceiver := AProgress;
    CreateReport(false);
  finally
    QRPrinter.Free;
    AProgress.Free;
  end;
  ExportFilter := nil;
  QRPrinter := OldQRPrinter;
end;

function TQuickRep.AvailableSpace : integer;
begin
  if not Available then
  begin
    if Page.Orientation = poPortrait then
      Result := round(QRPrinter.PaperLength - Page.BottomMargin - FPageFooterSize - CurrentY)
    else
      Result := round(QRPrinter.PaperWidth - Page.BottomMargin - FPageFooterSize - CurrentY)
  end else
    Result := 0;
end;

procedure TQuickRep.NewColumn;
begin
  if Bands.ColumnFooterBand <> nil then
    Bands.ColumnFooterBand.Print;
  if FCurrentColumn=Page.Columns then
  begin
    FCurrentColumn := 1;
    FCurrentX := round(Page.LeftMargin);
    NewPage;
  end else
  begin
    FCurrentX := FCurrentX + round(Bands.DetailBand.Size.Width + Page.ColumnSpace);
    FCurrentY := FColumnTopPosition;
    inc(FCurrentColumn);
{ Bug : Second column prints above the first one when using a title band - Begin}
{ Add Following lines }
    if (FPageCount = 1) and Assigned(Bands.TitleBand) then
      FCurrentY := FCurrentY + round(Bands.TitleBand.Size.Height);
{ Bug : Second column prints above the first one when using a title band - End}
  end;
  if Bands.ColumnHeaderBand <> nil then
    Bands.ColumnHeaderBand.Print;
end;

procedure TQuickRep.NewPage;
begin
  EndPage;
  if Exporting then
    ExportFilter.NewPage;
  inc(FPageCount);
  if FinalPass or (FPageCount = 1) then
    QRPrinter.NewPage;
  FCurrentY := round(Page.TopMargin);
  if assigned(FOnStartPageEvent) and not (csDesigning in ComponentState) then
    FOnStartPageEvent(Self);
  if (FPageCount > 1) or ((FPageCount = 1) and (FirstPageHeader in Options)) then
    if Bands.PageHeaderBand <> nil then
      Bands.PageHeaderBand.Print;
  FColumnTopPosition := FCurrentY;
end;

procedure TQuickRep.PrintPageBackground;
var
  I : integer;
begin
  for I := 0 to ControlCount - 1 do
    if Controls[I] is TQRPrintable then
      TQRPrintable(Controls[I]).Print(0, 0);
  if FinalPass then
    Frame.PaintIt(QRPrinter.Canvas,
      rect(QRPrinter.XPos(Page.LeftMargin),
           QRPrinter.YPos(Page.TopMargin),
           QRPrinter.XPos(Page.Width - Page.RightMargin),
           QRPrinter.XPos(Page.Length - Page.BottomMargin)),
    QRPrinter.XFactor,QRPrinter.YFactor);
end;

procedure TQuickRep.EndPage;
begin
  if FPageCount > 0 then
  begin
    if assigned(FOnEndPageEvent) and not (csDesigning in ComponentState) then
      FOnEndPageEvent(Self);
    CurrentY := round(Page.Length - Page.BottomMargin - FPageFooterSize);
    if (Bands.PageFooterBand <> nil) and (FPageCount > 0) and
       ((not FLastPage) or (LastPageFooter in Options)) then
      Bands.PageFooterBand.Print;
    PrintPageBackground;
  end;
  if Exporting then ExportFilter.EndPage;
end;

procedure TQuickRep.RegisterBand(ABand : TQRCustomBand);
begin
  if not (csDestroying in ABand.ComponentState) and
    (BandRegList.IndexOf(ABand) < 0) then
  begin
    BandRegList.Add(ABand);
    while (aBand <> nil) and aBand.HasChild do
    begin
      aBand := aBand.ChildBand;
      BandRegList.Add(aBand);
    end
  end;
end;

procedure TQuickRep.RebuildBandList;
var
  aBand : TQRCustomBand;
  I : integer;

  procedure AddBandsToList(BandType : TQRBandType);
  var
    I : integer;
  begin
    for I := 0 to FBandList.Count - 1 do
    begin
      if TQRCustomBand(FBandList[I]).BandType = BandType then
      begin
        aBand := TQRCustomBand(FBandList[I]);
        RegisterBand(aBand);
      end
    end
  end;

begin
  if not (csLoading in ComponentState) then
  begin
    with AController do
    begin
      Detail := Bands.DetailBand;
      Header := Bands.TitleBand;
      Footer := Bands.SummaryBand;
      BuildTree;
    end;
    BandRegList.Clear;
    AddBandsToList(rbPageHeader);
    if Bands.HasTitle then
      AddBandsToList(rbTitle);
    AddBandsToList(rbColumnHeader);
    AController.RegisterBands;
    AddBandsToList(rbPageFooter);
    for I := 0 to FBandList.Count - 1 do
    begin
      if BandRegList.IndexOf(FBandList[I]) = -1 then
        RegisterBand(TQRCustomBand(FBandList[I]));
    end;
    FBandList.Free;
    FBandList := BandRegList;
    BandRegList := TList.Create;
  end;
  if FBandList.Count > 0 then
    for I := 1 to RotateBands do
      FBandList.Move(0, FBandList.Count - 1);
end;

procedure TQuickRep.SetBandValues;
var
  I : integer;
  VertPos : integer;
  BandWidth : integer;
  ColumnWidth : integer;
  aUnit : TQRUnit;
  aBand : TQRCustomBand;
  aChildBand : TQRChildBand;
  aBandType : TQRBandType;
begin
  if assigned(FPage) and assigned(FBandList) and
    not (csDestroying in ComponentState) and not (csLoading in ComponentState) then
  begin
    aUnit := Units;
    Units := Pixels;
    VertPos := round(Page.TopMargin);
    BandWidth := Width - round(Page.LeftMargin + Page.RightMargin);
    ColumnWidth := ((BandWidth - round(Page.ColumnSpace) * (Page.Columns - 1)) div Page.Columns);
    for I := 0 to FBandList.Count - 1 do
    begin
      aBand := TQRCustomBand(FBandList[I]);
      if assigned(aBand) and not (csDestroying in aBand.ComponentState) then
      begin
        aBand.ParentUpdating := true;
        aBand.Left := round(Page.LeftMargin);
        if HideBands then
          aBand.Top := round(Page.Length)
        else
          aBand.Top := VertPos;
        inc(VertPos, aBand.Height);
        aBandType := aBand.BandType;
        if aBand is TQRChildBand then
        begin
          aChildBand := TQRChildBand(aBand);
          while (aChildBand.ParentBand <> nil) and
                (aChildBand.ParentBand is TQRChildBand) do
            aChildBand := TQRChildBand(aChildBand.ParentBand);
          if aChildBand.ParentBand <> nil then
            aBandType := aChildBand.ParentBand.BandType;
        end;
        if aBandType in [rbTitle, rbPageHeader, rbPageFooter, rbSummary, rbOverlay] then
          aBand.Size.Width := BandWidth
        else
          aBand.Size.Width := ColumnWidth;
        aBand.ParentUpdating := false;
      end
    end;
    Units := aUnit;
  end
end;

procedure TQuickRep.Edit(ADesigner : TQRDesigner);
begin
  FDesigner := aDesigner;
  State := qrEdit;
end;

procedure TQuickRep.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if (Key = VK_DELETE) and (State = qrEdit) and (Designer.EditControl <> nil) and (Designer.EditControl is TQRPrintable) then
  begin
    Designer.EditControl.Free;
    Designer.EditControl := Self;
  end;
end;

procedure TQuickRep.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button=mbLeft) and (State=qrEdit) then
  begin
    Designer.HandleOperation(hoHide);
    Application.ProcessMessages;
    Designer.EditControl := self;
  end
end;

{$ifdef ver100}
procedure TQuickRep.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  I: Integer;
  OwnedComponent: TComponent;
begin
  inherited GetChildren(Proc, Root);
  if Root = Self then
    for I := 0 to ComponentCount - 1 do
    begin
      OwnedComponent := Components[I];
      if not OwnedComponent.HasParent then Proc(OwnedComponent);
    end
end;
{$endif}

procedure TQuickRep.Loaded;
begin
  inherited Loaded;
  RebuildBandList;
  SetBandValues;
end;

procedure TQuickRep.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if not (csDestroying in ComponentState) then
  begin
    if Operation=opRemove then
    begin
      if (AComponent is TQRCustomBand) then
        if (FBandList.IndexOf(AComponent) >= 0) then
          RemoveBand(TQRCustomBand(AComponent));
      if (AComponent is TDataSet) and (AComponent = DataSet) then
         DataSet := nil;
    end
  end
end;

procedure TQuickRep.RemoveBand(ABand : TQRCustomBand);
var
  BandIndex : integer;
begin
  if not (csDestroying in ComponentState) then
  begin
    BandIndex := FBandList.IndexOf(ABand);
    if BandIndex >= 0 then
    begin
      FBandList.Delete(BandIndex);
      RebuildBandList;
      SetBandValues;
    end
  end
end;

procedure TQuickRep.Paint;
begin
  inherited Paint;
  if Page.Ruler then
    PaintRuler(Units);
  PaintMargins;
  PaintFrame;
  PaintColumns;
end;

procedure TQuickRep.PaintColumns;
var
  I : integer;
  ColumnWidth : integer;
begin
  if Page.Columns > 1 then with Canvas do
  begin
    Pen.Width := 1;
    Pen.Style := cqrMarginStyle;
    Pen.Color := cqrMarginColor;
    Page.SetPixels;
    ColumnWidth := round(((Page.Width - Page.LeftMargin - Page.RightMargin - Page.ColumnSpace *
                   (Page.Columns - 1)) / Page.Columns));
    for i := 1 to Page.Columns-1 do
    begin
      MoveTo(round(Page.LeftMargin + I * ColumnWidth + (I - 1) * Page.ColumnSpace), 0);
      LineTo(round(Page.LeftMargin + I * ColumnWidth + (I - 1) * Page.ColumnSpace), round(Page.TopMargin));

      MoveTo(round(Page.LeftMargin + I * (ColumnWidth + Page.ColumnSpace)), 0);
      LineTo(round(Page.LeftMargin + I * (ColumnWidth + Page.ColumnSpace)), round((Page.TopMargin)));
    end;
    Page.RestoreUnit;
    Pen.Style := psSolid;
  end
end;

procedure TQuickRep.PaintMargins;
begin
  with canvas do
  begin
    Pen.Style := cqrMarginStyle;
    Pen.Color := cqrMarginColor;
    Page.SetPixels;
    rectangle(round(Page.LeftMargin),round(Page.TopMargin),Width-round(Page.RightMargin),Height-Round(Page.BottomMargin));
    Pen.Style := psSolid;
    Page.RestoreUnit;
  end
end;

procedure TQuickRep.PaintFrame;
begin
  with canvas do
  begin
    Frame.SetPen(Pen);
    Page.SetPixels;
    if Frame.DrawTop then
    begin
      MoveTo(round(Page.LeftMargin), Round(Page.TopMargin));
      LineTo(round(Page.Width - Page.RightMargin) - 1, Round(Page.TopMargin));
    end;
    if Frame.DrawBottom then
    begin
      MoveTo(round(Page.LeftMargin), Round(Page.Length - Page.BottomMargin) - 1);
      LineTo(round(Page.Width - Page.RightMargin) - 1, Round(Page.Length - Page.BottomMargin) - 1);
    end;
    if Frame.DrawLeft then
    begin
      MoveTo(round(Page.LeftMargin), Round(Page.TopMargin));
      LineTo(round(Page.LeftMargin), Round(Page.Length - Page.BottomMargin) - 1);
    end;
    if Frame.DrawRight then
    begin
      MoveTo(round(Page.Width - Page.RightMargin) - 1, Round(Page.TopMargin));
      LineTo(round(Page.Width - Page.RightMargin) - 1, Round(Page.Length - Page.BottomMargin) - 1);
    end;
    Page.RestoreUnit;
  end
end;

procedure TQuickRep.PaintRuler(Units : TQRUnit);
begin
  FontSize := abs(Font.Size);
  inherited PaintRuler(Units);
end;

procedure TQuickRep.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  UpdatePage : boolean;
begin
  UpdatePage := (AWidth <> Width) or (AHeight <> Height);
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  if assigned(FPage) and (not Page.ParentUpdating) and UpdatePage and (Page.PaperSize = Custom) then
  begin
    Page.ParentUpdating := true;
    Page.SetPixels;
    Page.Width := aWidth;
    Page.Length := aHeight;
    Page.RestoreUnit;
    Page.ParentUpdating := false;
    SetBandValues;
  end
end;

procedure TQuickRep.SetExportFilter(Value : TQRExportFilter);
begin
  FExportFilter := Value;
  if Value <> nil then
    FExporting := true
  else
    FExporting := false;
end;

procedure TQuickRep.SetUnits(Value : TQRUnit);
var
  I : integer;
begin
  Page.Units := Value;
  for I := 0 to FBandList.Count - 1 do
    TQRCustomBand(FBandList[I]).Units := Units;
  for I := 0 to ControlCount - 1 do
  begin
    if Controls[I] is TQRPrintable then
      TQRPrintable(Controls[I]).Size.Units := Units;
  end;
end;

{ TQRPrintableSize }

constructor TQRPrintableSize.Create(AParent : TQRPrintable);
begin
  inherited create;
  Parent := AParent;
  FHeight := 20;
  FWidth := 20;
  FTop := 20;
  FLeft := 20;
end;

function TQRPrintableSize.GetValue(Index : integer): extended;
begin
  case Index of
    0 : Result := LoadUnit(FHeight, Units, false);
    1 : Result := LoadUnit(FLeft, Units, true);
    2 : Result := LoadUnit(FTop, Units, false);
  else
    Result := LoadUnit(FWidth, Units, true);
  end;
  if Units = Pixels then
    if Parent.Parent is TQRBasePanel then
      Result := (result * TQRBasePanel(Parent.Parent).Zoom) / 100;
end;

procedure TQRPrintableSize.ReadValues(Reader : TReader);
begin
  Reader.ReadListBegin;
  FHeight := Reader.ReadFloat;
  FLeft := Reader.ReadFloat;
  FTop := Reader.ReadFloat;
  FWidth := Reader.ReadFloat;
  Reader.ReadListEnd;
end;

procedure TQRPrintableSize.FixZoom;
begin
  SetParentSizes;
end;

procedure TQRPrintableSize.SetParentSizes;
begin
  if assigned(Parent) then
  begin
    ParentUpdating := true;
    Parent.SetBounds(round(LoadUnit(FLeft, Pixels, true)),
                     round(LoadUnit(FTop, Pixels, false)),
                     round(LoadUnit(FWidth, Pixels, true)),
                     round(LoadUnit(FHeight, Pixels, false)));
    ParentUpdating := false;
  end
end;

procedure TQRPrintableSize.SetValue(Index : integer; Value : extended);
begin
  case Index of
    0 : FHeight := SaveUnit(Value, Units, false);
    1 : FLeft := SaveUnit(Value, Units, true);
    2 : FTop := SaveUnit(Value, Units, false);
    3 : FWidth := SaveUnit(Value, Units, true);
  end;
  SetParentSizes;
end;

procedure TQRPrintableSize.WriteValues(Writer : TWriter);
begin
  Writer.WriteListBegin;
  Writer.WriteFloat(FHeight);
  Writer.WriteFloat(FLeft);
  Writer.WriteFloat(FTop);
  Writer.WriteFloat(FWidth);
  Writer.WriteListEnd;
end;

{ TQRPrintable }

constructor TQRPrintable.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSize := TQRPrintableSize.Create(Self);
  FFrame := TQRFrame.Create;
  FFrame.Parent := Self;
  Color := clWhite;
  ButtonDown := false;
  Height := 10;
  Width := 10;
  FAlignment := taLeftJustify;
  FAlignToBand := false;
  AlignUpdating := false;
  IsPrinting := false;
  LoadedTop := 0;
  LoadedLeft := 0;
  LoadedWidth := 0;
  LoadedHeight := 0;
end;

destructor TQRPrintable.Destroy;
begin
  FSize.Free;
  FFrame.Free;
  inherited Destroy;
end;

procedure TQRPrintable.Loaded;
begin
  inherited Loaded;
  Size.Loaded;
  if (Left = 0) and (LoadedLeft <> 0 ) then Left := LoadedLeft;
  if (Top = 0) and (LoadedTop <> 0) then Top := LoadedTop;
  if (Width = 0) and (LoadedWidth <> 0) then Width := LoadedWidth;
  if (Height = 0) and (LoadedHeight <> 0) then Height := LoadedHeight;
end;

function TQRPrintable.GetZoom : integer;
begin
  result := Size.Zoom;
end;

procedure TQRPrintable.SetZoom(Value : integer);
begin
  Size.Zoom := Value;
  Size.FixZoom;
end;

procedure TQRPrintable.AlignIt;
begin
  if AlignToBand then
  begin
    AlignUpdating := true;
    case Alignment of
      taLeftJustify : Left := 0;
      taRightJustify : if Parent is TQRCustomBand then
                  Left := TQRCustomBand(Parent).Width - Width;
      taCenter : if Parent is TQRCustomBand then
                  Left := (TQRCustomBand(Parent).Width - Width) div 2;
    end;
    AlignUpdating := false;
  end
end;

procedure TQRPrintable.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (ParentReport <> nil) and (ParentReport.State = qrEdit) then
  begin
    ParentReport.Designer.EditControl := Self;
    ParentReport.Designer.SetFocusFrame;
    ButtonDown := true;
    LastX := X;
    LastY := Y;
  end
end;

procedure TQRPrintable.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
  if ButtonDown then
    ParentReport.Designer.MoveFocusFrame(Rect(Left + X - LastX, Top + Y - LastY,
                                              Width + Left + X - LastX, Height + Top + Y - LastY));
end;

procedure TQRPrintable.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button=mbLeft) and ButtonDown then
  begin
    ButtonDown := false;
    ReleaseFocusFrame;
    if ParentReport.SnapToGrid then
    begin
      Size.Top := SnapToUnit(Size.Top, Size.Units);
      Size.Left := SnapToUnit(Size.Left, Size.Units);
    end;
    ParentReport.Designer.GetHandles;
  end
end;

procedure TQRPrintable.Prepare;
begin
   IsPrinting := true;
   QRPrinter := ParentReport.QRPrinter;
end;

procedure TQRPrintable.SetAlignment(Value : TAlignment);
begin
  FAlignment := Value;
  if AlignToBand then AlignIt;
  Invalidate;
end;

procedure TQRPrintable.SetAlignToBand(Value : boolean);
begin
  FAlignToBand := Value;
  AlignIt;
end;

procedure TQRPrintable.SetFrame(Value : TQRFrame);
begin
  FFrame := Value;
  Invalidate;
end;

procedure TQRPrintable.QRNotification(Sender : TObject; Operation : TQRNotifyOperation);
begin
  case Operation of
    qrBandSizeChange : AlignIt;
  end
end;

procedure TQRPrintable.ReleaseFocusFrame;
var
  MoveRect : TRect;
begin
  MoveRect := ParentReport.Designer.ReleaseFocusFrame;
  with MoveRect do
    SetBounds(Left, Top, Right - Left, Bottom - Top)
end;

procedure TQRPrintable.Paint;
var
  aRect : TRect;
begin
  if not Transparent then
  begin
    Canvas.Brush.Color := clWhite;
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(ClientRect);
  end;
  PaintCorners;
  aRect := GetClientRect;
  dec(aRect.Bottom);
  dec(aRect.Right);
  FFrame.PaintIt(Canvas, aRect, Screen.PixelsPerInch / 254 * Zoom/100, Screen.PixelsPerInch / 254 * Zoom/100);
end;

procedure TQRPrintable.Print(OfsX, OfsY : integer);
begin
  if ParentReport.FinalPass and FFrame.AnyFrame then
    FFrame.PaintIt(ParentReport.QRPrinter.Canvas,
      Rect(ParentReport.QRPrinter.XPos(OfsX + Size.Left),
      ParentReport.QRPrinter.YPos(OfsY + Size.Top),
      ParentReport.QRPrinter.XPos(OfsX + Size.Left + Size.Width),
      ParentReport.QRPrinter.YPos(OfsY + Size.Top + Size.Height)),
      ParentReport.QRPrinter.XFactor,
      ParentReport.QRPrinter.YFactor);
end;

procedure TQRPrintable.PaintCorners;
begin
  with Canvas do
  begin
    Pen.Color := clBlack;
    Pen.Width := 1;
    { Top left corner }
    MoveTo(0, cQRCornerSize);
    LineTo(0, 0);
    LineTo(cQRCornerSize, 0);
    { Bottom left corner }
    MoveTo(0, Height - cQRCornerSize - 1);
    LineTo(0, Height - 1);
    LineTo(cQRCornerSize,Height - 1);
    { Top Right corner }
    MoveTo(Width - cQRCornerSize - 1, 0);
    LineTo(Width - 1, 0);
    LineTo(Width - 1, cQRCornerSize);
    { Bottom Right corner }
    MoveTo(Width - cQRCornerSize - 1, Height - 1);
    LineTo(Width - 1, Height - 1);
    LineTo(Width - 1, Height - cQRCornerSize - 1);
  end
end;

procedure TQRPrintable.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
var
  aUnit : TQRUnit;
begin
  if Size.ParentUpdating then
  begin
    inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  end else
    if not (csLoading in ComponentState) then
    begin
      aUnit := Size.Units;
      Size.Units := Pixels;
      if AHeight <> Size.Height then Size.Height := aHeight;
      if aWidth <> Size.Width then Size.Width := aWidth;
      if aTop <> Size.Top then Size.Top := aTop;
      if aLeft <> Size.Left then Size.Left := aLeft;
      Size.Units := aUnit;
    end else
    begin
      if ALeft <> 0 then LoadedLeft := ALeft;
      if ATop <> 0 then LoadedTop := ATop;
      if AWidth <> 0 then LoadedWidth := AWidth;
      if AHeight <> 0 then LoadedHeight := AHeight;
    end;
  if AlignToBand and not AlignUpdating then AlignIt;
end;

procedure TQRPrintable.SetParent(AParent: TWinControl);
var
  aTop, ALeft : integer;
begin
  inherited SetParent(AParent);
  if AParent is TQuickRep then
  begin
    FSize.Units := TQuickRep(AParent).Units;
    ParentReport := TQuickRep(AParent);
    Size.ParentReport := ParentReport;
    aTop := top;
    aLeft := Left;
    Zoom := ParentReport.Zoom;
    Top := aTop;
    Left := aLeft;
  end else
  begin
    if AParent is TQRCustomBand then
    begin
      FSize.Units := TQRCustomBand(AParent).Units;
      if TQRCustomBand(AParent).ParentReport <> nil then
      begin
        ParentReport := TQRCustomBand(AParent).ParentReport;
        Size.ParentReport := ParentReport;
        Zoom := ParentReport.Zoom;
      end;
      aTop := top;aLeft := Left;
      Top := aTop;Left := aLeft;
    end
  end
end;

function TQRPrintable.GetTransparent : boolean;
begin
  Result := not (csOpaque in ControlStyle);
end;

procedure TQRPrintable.SetTransparent(Value : boolean);
begin
  if Transparent <> Value then
  begin
    if Value then
      ControlStyle := ControlStyle - [csOpaque]
    else
      ControlStyle := ControlStyle + [csOpaque];
    Invalidate;
  end
end;

procedure TQRPrintable.Unprepare;
begin
   FIsPrinting := false;
end;

{ TQRCompositeReport }

constructor TQRCompositeReport.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FReports := TList.Create;
  FPrinterSettings := TQuickRepPrinterSettings.Create;
end;

destructor TQRCompositeReport.Destroy;
begin
  FReports.Free;
  inherited Destroy;
end;

procedure TQRCompositeReport.CreateComposite;
var
  I : integer;
  LastCurrentY : integer;
  LastPageCount : integer;
  LastColumn : integer;
  aReport : TQuickRep;
begin
  Reports.Clear;
  if assigned(FOnAddReports) then
    FOnAddReports(self);
  if Reports.Count > 0 then
  begin
    FQRPrinter.BeginDoc;
    FQRPrinter.NewPage;
    aReport := TQuickRep(Reports[0]);
    aReport.Units := Native;
    LastCurrentY := round(aReport.Page.TopMargin);
    LastPageCount := 0;
    LastColumn := 1;
    for I := 0 to Reports.Count - 1 do
    begin
      aReport := TQuickRep(Reports[I]);
      aReport.QRPrinter := FQRPrinter;
      aReport.CurrentY := LastCurrentY;
      aReport.FPageCount := LastPageCount;
      aReport.FCurrentColumn := LastColumn;
      aReport.CreateReport(true);
      if assigned(FOnFinished) then FOnFinished(Reports[I]);
      LastCurrentY := aReport.CurrentY;
      LastPageCount := aReport.FPageCount;
      LastColumn := aReport.CurrentColumn;
    end;
    FQRPrinter.EndDoc;
  end;
  if assigned(FOnFinished) then FOnFinished(Self);
end;

procedure TQRCompositeReport.Print;
begin
  FQRPrinter := TQRPrinter.Create;
  FQRPrinter.Destination := qrdPrinter;
  CreateComposite;
end;

procedure TQRCompositeReport.Preview;
begin
  FQRPrinter := TQRPrinter.Create;
  FQRPrinter.Preview;
  CreateComposite;
end;

procedure TQRCompositeReport.Prepare;
begin
  FQRPrinter := TQRPrinter.Create;
  CreateComposite;
end;

{ QRDesigner & related components}

{ TQRControlHandle }

constructor TControlHandle.CreateGrab(aQRDesigner : TQRDesigner; aPosition : THandlePosition );
begin
  inherited Create(aQRDesigner);
  Visible := False;
  QRDesigner := aQRDesigner;
  SetBounds(0, 0, cHandleSize * 2, cHandleSize * 2);
  SetPosition(aPosition);
end;

procedure TControlHandle.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and not QRDesigner.Sizing then
    QRDesigner.SizeBegin(X,Y, FPosition);
end;

procedure TControlHandle.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
  if QRDesigner.Sizing then
    QRDesigner.SizeTo(X, Y);
end;

procedure TControlHandle.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and QRDesigner.Sizing then
    QRDesigner.SizeEnd(X, Y);
end;

procedure TControlHandle.Paint;
begin
  PatBlt(Canvas.Handle, 0, 0, Width, Height, BLACKNESS);
end;

procedure TControlHandle.SetPos(x, y : integer);
begin
  Left := X;
  Top := Y;
end;

procedure TControlHandle.SetParent(aParent : TWinControl);
begin
  inherited SetParent(aParent);
end;

procedure TControlHandle.SetPosition(value : THandlePosition);
begin
  if Value <> fPosition then
  begin
    FPosition := Value;
    Cursor := Cursors[fPosition];
  end
end;

procedure TControlHandle.Hide;
begin
  if Visible and ( Parent <> nil ) and not (csDestroying in ComponentState) then
    Visible := False;
end;

procedure TControlHandle.Show;
begin
  if Parent <> nil then begin
    BringToFront;
    Visible := True;
  end
end;

function TControlHandle.GetCenter : TPoint;
begin
  with Result do begin
    X := Left + Width div 2;
    Y := Top  + Height div 2;
  end
end;

{ TQRDesigner }

constructor TQRDesigner.Create;
begin
  inherited Create(AOwner);
  Sizing := false;
  Editing := false;
end;

destructor TQRDesigner.Destroy;
begin
  inherited Destroy;
end;

procedure TQRDesigner.AddComponent(aNewComponentType : TQRNewComponentClass);
begin
  NewComponentClass := aNewComponentType;
  FIsAdding := true;
end;

procedure TQRDesigner.AddIt(aParent : TWinControl; X,Y : integer);
var
  aPrintable : TQRPrintable;
begin
  if IsAdding then
  begin
    aPrintable := NewComponentClass.Create(FReport.Owner);
    aPrintable.Parent := aParent;
    aPrintable.Top := Y;
    aPrintable.Left := X;
    FIsAdding := false;
    aPrintable.Invalidate;
    Application.ProcessMessages;
    SetEditControl(aPrintable);
  end
end;

procedure TQRDesigner.DrawControlHandles(Control : TControl; Visible : Boolean);
begin
  UpdateHandlePositions(Control);
end;

procedure TQRDesigner.Edit(AReport : TQuickRep);
begin
  if AReport <> nil then
    StopEdit;
  HandleOperation(hoCreate);
  HandleOperation(hoParent);
  HandleOperation(hoShow);
  FReport := AReport;
  AReport.Edit(self);
  SetEditControl(AReport);
  Editing := true;
end;

procedure TQRDesigner.GetHandles;
begin
  UpdateHandlePositions(EditControl);
  HandleOperation(hoShow);
end;

procedure TQRDesigner.HandleOperation(Operation : THandleOperation);
var
  Index : THandlePosition;
begin
  if (EditControl <> nil) and (Operation in [hoShow, hoHide]) then
    LockWindowUpdate(FReport.Handle);
  if (EditControl <> nil) and (Operation = hoShow) then
    DrawControlHandles(EditControl, true);
  for Index := hpFirst to hpLast do
  begin
    case Operation of
      hoCreate  : Handles[Index] := TControlHandle.CreateGrab(Self, Index);
      hoParent  : if EditControl=nil then
                    Handles[Index].Parent := FReport
                  else
                    Handles[Index].Parent := FReport{EditControl.Parent};
      hoDestroy : begin
                    Handles[Index].Parent := nil;
                    Handles[Index].Free;
                    Handles[Index] := nil;
                  end;
      hoShow    : if EditControl <> nil then
                    Handles[Index].Show;
      hoHide    : Handles[Index].Hide;
    end
  end;
  if (EditControl<>nil) and (Operation in [hoShow, hoHide]) then
  begin
    LockWindowUpdate(0);
    Update;
  end
end;

procedure TQRDesigner.SetEditControl(AControl : TControl);
begin
  HandleOperation(hoHide);
  if assigned(FOnSelectComponent) then
    FOnSelectComponent(AControl);
  FEditControl := AControl;
  HandleOperation(hoParent);
  if FReport.Visible then
    FReport.SetFocus;
end;

procedure TQRDesigner.SetOnSelectComponent(Value : TNotifyEvent);
begin
  FOnSelectComponent := Value;
end;

procedure TQRDesigner.SizeBegin(X,Y : integer; aPosition : THandlePosition);
begin
  FSizing := true;
  SizeStartX := X;
  SizeStartY := Y;
  SizePosition := aPosition;
  HandleOperation(hoHide);
  SetFocusFrame;
  Application.ProcessMessages;
  if EditControl is TQRPrintable then
{    TQRPrintable(EditControl).SetFocusFrame(EditControl.BoundsRect)}
  else
    if EditControl is TQRCustomBand then
{      TQRCustomBand(EditControl).SetFocusFrame};
end;

procedure TQRDesigner.SizeEnd(X,Y : integer);
begin
  SizeTo(X,Y);
  if EditControl is TQRPrintable then
    TQRPrintable(EditControl).ReleaseFocusFrame
  else
    if EditControl is TQRCustomBand then
      TQRCustomBand(EditControl).ReleaseFocusFrame;
  FSizing := false;
  UpdateHandlePositions(EditControl);
  HandleOperation(hoShow);
end;

procedure TQRDesigner.SizeTo(X,Y : integer);
begin
  if EditControl is TQRPrintable then
  begin
    with TQRPrintable(EditControl) do
    begin
      case SizePosition of
        hpTopLeft :    MoveFocusFrame(Rect(Left + X - SizeStartX, Top + Y - SizeStartY, Left + Width, Top + Height));
        hpTop :        MoveFocusFrame(Rect(Left, Top + Y - SizeStartY, Left + Width, Top + Height));
        hpTopRight:    MoveFocusFrame(Rect(Left, Top + Y - SizeStartY, Left + Width + X - SizeStartX, Top + Height));
        hpLeft :       MoveFocusFrame(Rect(Left + X - SizeStartX, Top, Left + Width, Top + Height));
        hpRight :      MoveFocusFrame(Rect(Left, Top, Left + Width + X - SizeStartX, Top + Height));
        hpBottomLeft:  MoveFocusFrame(Rect(Left + X - SizeStartX, Top, Left + Width, Top + Height + Y - SizeStartY));
        hpBottom :     MoveFocusFrame(Rect(Left, Top, Left + Width, Top + Height + Y - SizeStartY));
        hpBottomRight: MoveFocusFrame(Rect(Left, Top, Left + Width + X - SizeStartX, Top + Height + Y - SizeStartY));
      end
    end
  end else
    if EditControl is TQRCustomBand then
    begin
      with TQRCustomBand(EditControl) do
      begin
        case SizePosition of
          hpTopLeft :    MoveFocusFrame(Rect(Left + X - SizeStartX, Top + Y - SizeStartY, Left + Width, Top + Height));
          hpTop :        MoveFocusFrame(Rect(Left, Top + Y - SizeStartY, Left + Width, Top + Height));
          hpTopRight:    MoveFocusFrame(Rect(Left, Top + Y - SizeStartY, Left + Width + X - SizeStartX, Top + Height));
          hpLeft :       MoveFocusFrame(Rect(Left + X - SizeStartX, Top, Left + Width, Top + Height));
          hpRight :      MoveFocusFrame(Rect(Left, Top, Left + Width + X - SizeStartX, Top + Height));
          hpBottomLeft:  MoveFocusFrame(Rect(Left + X - SizeStartX, Top, Left + Width, Top + Height + Y - SizeStartY));
          hpBottom :     MoveFocusFrame(Rect(Left, Top, Left + Width, Top + Height + Y - SizeStartY));
          hpBottomRight: MoveFocusFrame(Rect(Left, Top, Left + Width + X - SizeStartX, Top + Height + Y - SizeStartY));
        end
      end
    end
end;

procedure TQRDesigner.StopEdit;
begin
  if Editing then
  begin
    if assigned(FReport) then
    begin
      FReport.State := qrAvailable;
      FReport := nil;
    end;
    FEditControl := nil;
    HandleOperation(hoDestroy);
    Editing := false;
  end;
end;

procedure TQRDesigner.SetFocusFrame;
var
  AHandle : THandle;
begin
  MoveRect := EditControl.BoundsRect;
  if not (EditControl is TQRCustomBand) then
    OffsetRect(MoveRect, EditControl.Parent.Left, EditControl.Parent.Top);
  FReport.Canvas.Pen.Color := clBlack;
  AHandle := GetDCEx(FReport.Handle, 0, DCX_WINDOW or DCX_PARENTCLIP);
  DrawFocusRect(AHandle, MoveRect);
  ReleaseDC(FReport.Handle, AHandle);
end;

function TQRDesigner.ReleaseFocusFrame : TRect;
var
  AHandle : THandle;
begin
  FReport.Canvas.Pen.Color := clBlack;
  AHandle := GetDCEx(FReport.Handle, 0, DCX_WINDOW or DCX_PARENTCLIP);
  DrawFocusRect(AHandle, MoveRect);
  ReleaseDC(FReport.Handle, AHandle);
  if not (EditControl is TQRCustomBand) then
    OffsetRect(MoveRect, -EditControl.Parent.Left, -EditControl.Parent.Top);
  Result := MoveRect;
end;

procedure TQRDesigner.MoveFocusFrame(Rect : TRect);
var
  AHandle : THandle;
begin
  FReport.Canvas.Pen.Color := clBlack;
  AHandle := GetDCEx(FReport.Handle, 0, DCX_WINDOW or DCX_PARENTCLIP);
  DrawFocusRect(AHandle, MoveRect);
  MoveRect := Rect;
  if not (EditControl is TQRCustomBand) then
    OffsetRect(MoveRect, EditControl.Parent.Left, EditControl.Parent.Top);
  DrawFocusRect(AHandle, MoveRect);
  ReleaseDC(FReport.Handle, AHandle);
end;

procedure TQRDesigner.UpdateHandlePositions(Control : TControl);
var
  OfsX : integer;
  OfsY : integer;
begin
  if not (EditControl is TQRCustomBand) then
  begin
    OfsX := EditControl.Parent.Left;
    OfsY := EditControl.Parent.Top;
  end else
  begin
    OfsX := 0;
    OfsY := 0;
  end;
  with Control do
  begin
    Handles[hpTopLeft].SetPos(OfsX + Left - cHandleSize, OfsY + Top - cHandleSize);
    Handles[hpTop].SetPos(OfsX + Left + (Width div 2) - cHandleSize, OfsY + Top - cHandleSize);
    Handles[hpTopRight].SetPos(OfsX + Left + Width - cHandleSize, OfsY + Top - cHandleSize);
    Handles[hpLeft].SetPos(OfsX + Left - cHandleSize, OfsY + Top + (Height div 2) - cHandleSize);
    Handles[hpRight].SetPos(OfsX + Left + width - cHandleSize, OfsY + Top + (Height div 2) - cHandleSize);
    Handles[hpBottomLeft].SetPos(OfsX + Left - cHandleSize, OfsY + Top + Height - cHandleSize);
    Handles[hpBottom].SetPos(OfsX+Left + (Width div 2) - cHandleSize, OfsY + Top + Height - cHandleSize);
    Handles[hpBottomRight].SetPos(OfsX + Left + Width - cHandleSize, OfsY + Top + Height - cHandleSize);
  end
end;

constructor TQuickReport.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FPageFrame := TQRFrame.Create;
  FPageFrame.Parent := Self;
end;

destructor TQuickReport.Destroy;
begin
  FPageFrame.Free;
  inherited Destroy;
end;

procedure TQuickReport.Loaded;
var
  aQuickRep : TQuickRep;
  i, j : integer;
  aName : string;
  aBand : TQRCustomBand;
  aControl : TControl;
  Component : TComponent;
begin
  inherited Loaded;
  if csDesigning in ComponentState then
  begin
    aQuickRep := TQuickRep.Create(Owner);
    aQuickRep.Parent := Parent;
    for i := 0 to Owner.ComponentCount - 1 do
    begin
      if Owner.Components[i] is TQRCustomband then
      begin
        aBand := TQRCustomband(Owner.Components[i]);
        aBand.Parent := aQuickRep;
        for j := 0 to aBand.ControlCount - 1 do
        begin
          aControl := aBand.Controls[0];
          aControl.Parent := nil;
          aControl.Parent := aBand;
        end
      end
    end;
    aName := Name;
    Name := '';
    aQuickRep.Name := aName;
    Free;
    ShowMessage(LoadStr(SqrConverted));
{    Component := Self;
    while Component <> nil do
      if Component is TForm then
      begin
        if TForm(Component).Designer <> nil then
          TForm(Component).Designer.Modified;
        Break;
      end
      else Component := Component.Owner;}
  end;
end;

{ Set the QuickReport color scheme }

procedure SetQRHiColor;
begin
  cqrRulerMinorStyle := psSolid;
  cqrRulerMajorStyle := psSolid;
  cqrRulerMinorColor := $f9f9f9;
  cqrRulerMajorColor := $f0f0f0;
  cqrRulerFontName := 'Small Fonts'; {<-- do not resource }
  cqrRulerFontColor := $707070;
  cqrRulerFontSize := 6;

  cqrMarginStyle := psDot;
  cqrMarginColor := $ff8080;

  cqrBandFrameStyle := psDot;
  cqrBandFrameColor := $606060;
end;

procedure SetQRLoColor;
begin
  cqrRulerMinorStyle := psDot;
  cqrRulerMajorStyle := psSolid;
  cqrRulerMinorColor := clSilver;
  cqrRulerMajorColor := clSilver;
  cqrRulerFontName := 'Small Fonts'; {<-- do not resource }
  cqrRulerFontColor := clSilver;
  cqrRulerFontSize := 6;

  cqrMarginStyle := psDash;
  cqrMarginColor := clGray;

  cqrBandFrameStyle := psSolid;
  cqrBandFrameColor := clGray;
end;

{ Initialization and finalization code }

procedure SetQRColorScheme;
var
  NumCol : integer;
  DC : THandle;
begin
  DC := GetDC(0);
  NumCol := GetDeviceCaps(DC,numcolors);
  if (NumCol > 256) or (NumCol < 0) then
    SetQRHiColor
  else
    SetQRLoColor;
  ReleaseDC(0, DC);
end;

procedure TQRDetailLink.DefineProperties(Filer: TFiler);
begin
  Filer.DefineProperty('DataSource', ReadDataSource, WriteValues, false); {<-- do not resource }
  Filer.DefineProperty('DetailBand', ReadDetailBand, WriteValues, false);
  Filer.DefineProperty('OnFilter', ReadOnFilter, WriteValues, false);
  inherited DefineProperties(Filer);
end;

procedure TQRDetailLink.ReadDataSource(Reader : TReader);
begin
  DataSourceName := Reader.ReadIdent;
end;

procedure TQRDetailLink.ReadDetailBand(Reader : TReader);
begin
  DetailBandName := Reader.ReadIdent;
end;

procedure TQRDetailLink.ReadOnFilter(Reader : TReader);
begin
  Reader.ReadIdent;
end;

procedure TQRDetailLink.Loaded;
var
  aComponent : TComponent;
begin
  inherited Loaded;
  if DataSourceName <> '' then
  begin
    aComponent := Owner.FindComponent(DataSourceName);
    if (aComponent <> nil) and (aComponent is TDataSource) then
      DataSet := TDataSource(aComponent).DataSet;
  end
end;

procedure TQRDetailLink.WriteValues(Writer : TWriter);
begin
end;

{$ifdef win32}
var
  DefaultLCID: LCID;
begin
  SetQRColorScheme;
  DefaultLCID := GetSystemDefaultLCID;
  LocalMeasureInches := GetLocaleChar(DefaultLCID, LOCALE_IMEASURE, ' ') = '1';
{$else}
begin
  SetQRColorScheme;
  LocalMeasureInches := false;
{$endif}
end.

