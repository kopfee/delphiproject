unit RPCtrls;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>RPCtrls
   <What>用于设计打印报表的格式的对象
   <Note>不包含实际的打印
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}
{ TODO : 对Report属性的安全性处理. }

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, RPDefines;

const
  DefaultMargin = 100;

type
  EContainmentError = class(Exception);

  TRDReport = class;
  TRDSimpleBand = class;
  TRDCustomGroupBand = class;

  TRDPrintSize = class(TPersistent)
  private
    FControl: TControl;
    // 在Load的时候读取的数据
    FX,FY,FW,FH,FX1,FY1 : TFloat;
    // 标志在Load的时候读取了哪些数据
    FXFlag, FYFlag, FWFlag, FHFlag, FX1Flag, FY1Flag : Boolean;
    // 保存最近设置的物理大小，用于保持精度
    FPrintLeft, FPrintTop, FPrintWidth, FPrintHeight, FPrintRightDistance, FPrintBottomDistance : TFloat;
    function    GetPrintHeight: TFloat;
    function    GetPrintLeft: TFloat;
    function    GetPrintTop: TFloat;
    function    GetPrintWidth: TFloat;
    procedure   SetPrintHeight(const Value: TFloat);
    procedure   SetPrintLeft(const Value: TFloat);
    procedure   SetPrintTop(const Value: TFloat);
    procedure   SetPrintWidth(const Value: TFloat);
    function    GetPrintBottomDistance: TFloat;
    function    GetPrintRightDistance: TFloat;
    procedure   SetPrintBottomDistance(const Value: TFloat);
    procedure   SetPrintRightDistance(const Value: TFloat);
    function    IsStoreBottomDistance: Boolean;
    function    IsStoreRightDistance: Boolean;
  protected
    procedure   ClearFlags;
    procedure   AfterControlLoad;
  public
    constructor Create(AControl : TControl);
    procedure   Assign(Source: TPersistent); override;
    property    Control : TControl read FControl;
  published
    property    PrintHeight : TFloat read GetPrintHeight write SetPrintHeight;
    property    PrintWidth : TFloat read GetPrintWidth write SetPrintWidth;
    property    PrintLeft : TFloat read GetPrintLeft write SetPrintLeft;
    property    PrintTop : TFloat read GetPrintTop write SetPrintTop;
    property    PrintRightDistance : TFloat read GetPrintRightDistance write SetPrintRightDistance stored IsStoreRightDistance;
    property    PrintBottomDistance : TFloat read GetPrintBottomDistance write SetPrintBottomDistance stored IsStoreBottomDistance;
  end;

  TRDCustomBand = class(TCustomControl)
  private
    FReport: TRDReport;
    FParentBand: TRDCustomGroupBand;
    FOptions: string;
    FBandName: string;
    FIsPrint: Boolean;
    FDum: Byte;
    FPrintSize: TRDPrintSize;
    FLoadBandIndex : Integer;
    function    GetBandIndex: Integer;
    procedure   SetBandIndex(const Value: Integer);
    procedure   SetPrintSize(const Value: TRDPrintSize);
  protected
    procedure   Paint; override;
    procedure   SetParent(AParent: TWinControl); override;
    //procedure   ValidateContainer(AComponent: TComponent); override;
    procedure   Loaded; override;
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    procedure   SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property    Report : TRDReport read FReport;
    property    ParentBand : TRDCustomGroupBand read FParentBand;
    property    BandIndex : Integer read GetBandIndex write SetBandIndex;
  published
    property    IsPrint : Boolean read FIsPrint write FIsPrint default True;
    property    BandName : string read FBandName write FBandName;
    property    Options : string read FOptions write FOptions;
    property    Hint : Byte read FDum stored false;
    property    HelpContext : Byte read FDum stored false;
    property    Cursor : Byte read FDum stored false;
    property    PrintSize : TRDPrintSize read FPrintSize write SetPrintSize; 
  end;

  TSimplyBandKind = (sbkNormal,sbkHeader,sbkFooter,sbkLefter,sbkRighter);

  TRDSimpleBand = class(TRDCustomBand)
  private
    FFrame: TRPFrame;
    FTransparent: Boolean;
    FIsAlignBottom: Boolean;
    FIsSpace: Boolean;
    FIsForceNewPage: Boolean;
    FIsForceEndPage: Boolean;
    FNoNewPageAtFirst: Boolean;
    procedure   SetFrame(const Value: TRPFrame);
    procedure   FrameChanged(Sender : TObject);
    function    GetBandKind: TSimplyBandKind;
    procedure   SetBandKind(const Value: TSimplyBandKind);
    procedure   SetIsAlignBottom(const Value: Boolean);
    //function    GetTransparent: Boolean;
    //procedure   SetTransparent(const Value: Boolean);
    procedure   CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure   SetTransparent(const Value: Boolean);
    procedure   SetIsSpace(const Value: Boolean);
  protected
    procedure   Paint; override;
  public
    constructor Create(AOwner : TComponent); override;
  published
    property    Frame : TRPFrame read FFrame write SetFrame;
    property    BandKind : TSimplyBandKind read GetBandKind write SetBandKind default sbkNormal;
    property    Transparent: Boolean read FTransparent write SetTransparent default True;
    property    IsAlignBottom : Boolean read FIsAlignBottom write SetIsAlignBottom;
    property    IsSpace : Boolean read FIsSpace write SetIsSpace default False;
    property    IsForceNewPage : Boolean read FIsForceNewPage write FIsForceNewPage default False;
    property    IsForceEndPage : Boolean read FIsForceEndPage write FIsForceEndPage default False;
    property    NoNewPageAtFirst : Boolean read FNoNewPageAtFirst write FNoNewPageAtFirst default False;
    property    BandIndex;

    property    Color default clWhite;
    property    Font;
    property    ParentColor default False;
    property    ParentFont;
    {
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    }
  end;

  TRDCustomGroupBand = class(TRDCustomBand)
  private
    FChildren : TList;
    FHeader: TRDSimpleBand;
    FFooter: TRDSimpleBand;
    FLefter: TRDSimpleBand;
    FRighter: TRDSimpleBand;
    FArranged: Boolean;
    FArranging : Boolean;
    procedure   SetArranged(const Value: Boolean);
    procedure   SortBands;
  protected
    procedure   AddChildren(Children : TRDCustomBand);
    procedure   RemoveChildren(Children : TRDCustomBand);
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure   Loaded; override;
    // trigger ArrangeChildren
    property    Arranged : Boolean read FArranged write SetArranged;
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    procedure   SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure   ArrangeChildren;
    property    Children : TList read FChildren;
    property    Header: TRDSimpleBand read FHeader;
    property    Footer: TRDSimpleBand read FFooter;
    property    Lefter: TRDSimpleBand read FLefter;
    property    Righter: TRDSimpleBand read FRighter;
  published

  end;

  TRDGroupBand = class(TRDCustomGroupBand)
  published
    property    BandIndex;
    property    Arranged;
    property Color;
    property Font;
    property ParentColor;
    property ParentFont;
    {
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    }
  end;

  TRDCustomRepeatBand = class(TRDCustomGroupBand)
  private
    FColumns: Integer;
    FControllerName: string;
    FGroupIndex: Integer;
    procedure   SetColumns(const Value: Integer);

  protected

  public
    constructor Create(AOwner : TComponent); override;
    property    Columns : Integer read FColumns write SetColumns default 1;
    property    ControllerName : string read FControllerName write FControllerName;
    property    GroupIndex : Integer read FGroupIndex write FGroupIndex default -1;
  end;

  TRDRepeatBand = class(TRDCustomRepeatBand)
  published
    property    Columns;
    property    ControllerName;
    property    GroupIndex;
    property    BandIndex;
    property    Arranged;
    property Color;
    property Font;
    property ParentColor;
    property ParentFont;
    {
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    }
  end;
  {
  TRPPageMargin = class(TRPMargin)
  public
    constructor Create;
  published
    property    Left stored True;
    property    Right stored True;
    property    Top stored True;
    property    Bottom stored True;
  end;
  }
  TRDReport = class(TRDCustomGroupBand)
  private
    FLineStyles: TLineStyles;
    FPaperHeight: TFloat;
    FPaperWidth: TFloat;
    FReportName: string;
    FMargin: TRPMargin{TRPPageMargin};
    FPaperSize: TRPPaperSize;
    FColumns: Integer;
    FRows: Integer;
    FColumnSpace: TFloat;
    FRowSpace: TFloat;
    FOrientation: TRPOrientation;
    FFixedSize: Boolean;
    procedure   SetLineStyles(const Value: TLineStyles);
    procedure   SetMargin(const Value: TRPMargin{TRPPageMargin});
    procedure   SetPaperHeight(const Value: TFloat);
    procedure   SetPaperSize(const Value: TRPPaperSize);
    procedure   SetPaperWidth(const Value: TFloat);
    procedure   MarginChanged(Sender : TObject);
    procedure   SetColumns(const Value: Integer);
    procedure   SetRows(const Value: Integer);
    procedure   SetOrientation(const Value: TRPOrientation);
  protected
    procedure   Loaded; override;
    procedure   CreateParams(var Params: TCreateParams); override;
    procedure   SetParent(AParent: TWinControl); override;
    procedure   ReadState(Reader: TReader); override;
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    procedure   PaperSizeChanged;
  published
    property    LineStyles : TLineStyles read FLineStyles write SetLineStyles;
    property    PaperWidth : TFloat read FPaperWidth write SetPaperWidth;
    property    PaperHeight : TFloat read FPaperHeight write SetPaperHeight;
    property    ReportName : string read FReportName write FReportName;
    property    Margin : TRPMargin{TRPPageMargin} read FMargin write SetMargin;
    property    PaperSize : TRPPaperSize read FPaperSize write SetPaperSize;
    property    Rows : Integer read FRows write SetRows default 1;
    property    Columns : Integer read FColumns write SetColumns default 1;
    property    ColumnSpace : TFloat read FColumnSpace write FColumnSpace;
    property    RowSpace : TFloat read FRowSpace write FRowSpace;
    property    Orientation: TRPOrientation read FOrientation Write SetOrientation;
    property    FixedSize : Boolean read FFixedSize write FFixedSize default False;

    property    Arranged;

    property    Color;
    property    Font;
    property    ParentColor;
    property    ParentFont;
    {
    property    PopupMenu;
    property    ShowHint;
    property    Visible;
    property    OnClick;
    property    OnContextPopup;
    property    OnDblClick;
    property    OnDragDrop;
    property    OnDragOver;
    property    OnEndDock;
    property    OnEndDrag;
    property    OnEnter;
    property    OnExit;
    property    OnKeyDown;
    property    OnKeyPress;
    property    OnKeyUp;
    property    OnMouseDown;
    property    OnMouseMove;
    property    OnMouseUp;
    property    OnStartDock;
    property    OnStartDrag;
    }
  end;

  TRDCustomControl = class;
  {
  原子操作方式	                  左对齐	左右对齐	上对齐	上下对齐	上下相连	上下相连2	左右相连	左右相连2
Left = LinkTo.Left	                  Y	      Y	        N	      N	          Y	        Y	        N	        N
Left = LinkTo.Left + LinkTo.Width	    N	      N	        N	      N	          N	        N	        Y	        Y
Top  = LinkTo.Top	                    N	      N	        Y	      Y	          N	        N	        Y	        Y
Top  = LinkTo.Top  + LinkTo.Height	  N	      N	        N	      N	          Y	        Y	        N	        N
Width = LinkTo.Width	                N	      Y	        N	      N	          N	        Y	        N	        N
Height= LinkTo.Height	                N	      N	        N	      Y	          N	        N	        N	        Y
  }

  TRDPosLinkStyle = (
    // 兼容旧的方式
    lsLeftToRight,    // 左右相连
    //lsLeftToLeft,     // 左右对齐,现在更名为lsLeftRightAlign，这里保持向后兼容
    lsLeftRightAlign, // 左右对齐
    // 新的方式
    lsNone,
    lsLeftAlign,      // 左对齐
    lsTopAlign,       // 上对齐
    lsTopBottomAlign, // 上下对齐
    lsTopToBottom,    // 上下相连
    lsTopToBottom2,   // 上下相连2
    lsLeftToRight2    //左右相连2
    );

  TRDCtrlPosLink = class(TPersistent)
  private
    FLinkTo: TRDCustomControl;
    FOwner: TRDCustomControl;
    FStyle: TRDPosLinkStyle;
    FUpdating : Boolean;
    procedure   SetLinkTo(const Value: TRDCustomControl);
    procedure   SetStyle(const Value: TRDPosLinkStyle);
  protected
    procedure   Update;
  public
    constructor Create(AOwner : TRDCustomControl);
    destructor  Destroy;override;
    procedure   Assign(Source: TPersistent); override;
    procedure   SetValue(AStyle : TRDPosLinkStyle; ALinkTo : TRDCustomControl);
    property    Owner : TRDCustomControl read FOwner;
  published
    property    Style : TRDPosLinkStyle read FStyle write SetStyle default lsNone;
    property    LinkTo : TRDCustomControl read FLinkTo write SetLinkTo;
  end;


  TRDCustomControl = class(TGraphicControl)
  private
    FReport:    TRDReport;
    FOptions: string;
    FFrame:     TRPFrame;
    FLinks:     TList;
    FLink: TRDCtrlPosLink;
    FID: string;
    FDum: Byte;
    FIsPrint: Boolean;
    FMargin: TRPMargin;
    FPrintSize: TRDPrintSize;
    function    GetBottomDistance: Integer;
    function    GetRightDistance: Integer;
    procedure   SetBottomDistance(const Value: Integer);
    procedure   SetRightDistance(const Value: Integer);
    //function    IsStoreBottomDistance: Boolean;
    //function    IsStoreRightDistance: Boolean;
    function    GetTransparent: Boolean;
    procedure   SetTransparent(const Value: Boolean);
    procedure   SetFrame(const Value: TRPFrame);
    procedure   FrameChanged(Sender : TObject);
    procedure   SetLink(const Value: TRDCtrlPosLink);
    procedure   FreeLinks;
    procedure   CMColorChanged(var Message: TMessage); message CM_ColorCHANGED;
    procedure   SetMargin(const Value: TRPMargin);
    procedure   MarginChanged(Sender : TObject);
    procedure   SetPrintSize(const Value: TRDPrintSize);
  protected
    procedure   Paint; override;
    procedure   SetParent(AParent: TWinControl); override;
    procedure   AddLink(Link : TRDCtrlPosLink);
    procedure   RemoveLink(Link : TRDCtrlPosLink);
    procedure   NotifyLinks;
    function    GetPaintRect : TRect;
    procedure   Loaded; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
    procedure   SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property    Report : TRDReport read FReport;
  published
    property    ID : string read FID write FID;
    property    RightDistance : Integer read GetRightDistance write SetRightDistance stored False; //IsStoreRightDistance;
    property    BottomDistance : Integer read GetBottomDistance write SetBottomDistance  stored False; //IsStoreBottomDistance;
    property    Transparent: Boolean read GetTransparent write SetTransparent default True;
    property    Options : string read FOptions write FOptions;
    property    Frame : TRPFrame read FFrame write SetFrame;
    property    Link : TRDCtrlPosLink read FLink write SetLink;
    property    IsPrint : Boolean read FIsPrint write FIsPrint default True;
    property    Margin : TRPMargin read FMargin write SetMargin;
    property    PrintSize : TRDPrintSize read FPrintSize write SetPrintSize;
    property    Anchors;
    property    Hint : Byte read FDum stored false;
    property    Cursor : Byte read FDum stored false;
  end;

  TRDLabel = class(TRDCustomControl)
  private
    FFieldName: string;
    FHAlign:    TRPHAlign;
    FVAlign:    TRPVAlign;
    FTextFormat: string;
    FTextFormatType: TRPTextFormatType;
    procedure   SetHAlign(const Value: TRPHAlign);
    procedure   SetVAlign(const Value: TRPVAlign);
    procedure   CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;

    procedure   SetFieldName(const Value: string);
  protected
    procedure   Paint; override; // only draw background if not transparent

  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
  published
    property    FieldName : string read FFieldName write SetFieldName;

    property    HAlign : TRPHAlign read FHAlign write SetHAlign;
    property    VAlign : TRPVAlign read FVAlign write SetVAlign;
    property    TextFormatType : TRPTextFormatType read FTextFormatType write FTextFormatType default tfNone;
    property    TextFormat : string read FTextFormat write FTextFormat;

    //property Align;
    property    Caption;
    property    Color default clWhite;
    property    Font;
    property    ParentColor default False;
    property    ParentFont;
    {
    property    DragCursor;
    property    DragKind;
    property    DragMode;
    property    Enabled;
    property    ParentBiDiMode;
    property    ParentShowHint;
    property    PopupMenu;
    property    ShowHint;
    property    Visible;
    property    OnClick;
    property    OnContextPopup;
    property    OnDblClick;
    property    OnDragDrop;
    property    OnDragOver;
    property    OnEndDock;
    property    OnEndDrag;
    property    OnMouseDown;
    property    OnMouseMove;
    property    OnMouseUp;
    property    OnStartDock;
    property    OnStartDrag;
    }
  end;

  TRDShapeType = (rdstRectangle, rdstEllipse, rdstHLine, rdstVLine, rdstLine1, rdstLine2);

  TRDShape = class(TRDCustomControl)
  private
    FShape:     TRDShapeType;
    FBrush:     TBrush;
    FLineIndex: Integer;
    procedure   SetShape(const Value: TRDShapeType);
    procedure   SetBrush(const Value: TBrush);
    procedure   BrushChanged(Sender : TObject);
    procedure   SetLineIndex(const Value: Integer);
  protected
    procedure   Paint; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
  published
    property    Shape : TRDShapeType read FShape write SetShape;
    property    Brush : TBrush read FBrush write SetBrush;
    property    LineIndex : Integer read FLineIndex write SetLineIndex;
    property    Color;
    {
    property    DragCursor;
    property    DragKind;
    property    DragMode;
    property    Enabled;
    property    ParentBiDiMode;
    property    ParentShowHint;
    property    PopupMenu;
    property    ShowHint;
    property    Visible;
    property    OnClick;
    property    OnContextPopup;
    property    OnDblClick;
    property    OnDragDrop;
    property    OnDragOver;
    property    OnEndDock;
    property    OnEndDrag;
    property    OnMouseDown;
    property    OnMouseMove;
    property    OnMouseUp;
    property    OnStartDock;
    property    OnStartDrag;
    }
  end;

  TRDPicture = class(TRDCustomControl)
  private
    FStretch: boolean;
    FFieldName: string;
    FPicture: TPicture;
    procedure   SetPicture(const Value: TPicture);
    procedure   SetStretch(const Value: boolean);
    procedure   PictureChanged(Sender : TObject);
  protected
    procedure   Paint; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
  published
    property    Picture: TPicture read FPicture write SetPicture;
    property    FieldName : string read FFieldName write FFieldName;
    property    Stretch : boolean read FStretch write SetStretch;
    {
    property    DragCursor;
    property    DragKind;
    property    DragMode;
    property    Enabled;
    property    ParentBiDiMode;
    property    ParentShowHint;
    property    PopupMenu;
    property    ShowHint;
    property    Visible;
    property    OnClick;
    property    OnContextPopup;
    property    OnDblClick;
    property    OnDragDrop;
    property    OnDragOver;
    property    OnEndDock;
    property    OnEndDrag;
    property    OnMouseDown;
    property    OnMouseMove;
    property    OnMouseUp;
    property    OnStartDock;
    property    OnStartDrag;
    }
  end;


procedure RaiseContainmentError;

procedure PaintFrame(Canvas : TCanvas; Width,Height : Integer; Frame : TRPFrame; LineStyles : TLineStyles);

function  GetCtrlName(Ctrl : TControl; const Default:string=''): string;

implementation

uses Forms, LogFile;

var
  DesignFramePen : TPen;

procedure RaiseContainmentError;
begin
  Raise EContainmentError.Create('Cannot in this control!');
end;

procedure PaintFrame(Canvas : TCanvas; Width,Height : Integer; Frame : TRPFrame; LineStyles : TLineStyles);

  function  SetBorderPen(Index : Integer):Integer;
  var
    Pen : TPen;
    Item : TCollectionItem;
  begin
    Assert((Index>=0) and (Index<=3));
    Pen := nil;
    if (Frame.FBorders[Index]>=0)
      and (Frame.FBorders[Index]<LineStyles.Count) then
    begin
      Item := LineStyles.Items[Frame.FBorders[Index]];
      Assert(Item is TLineStyle);
      Pen := TLineStyle(Item).Pen;
    end;
    if Pen<>nil then
      Canvas.Pen := Pen
    else
      Canvas.Pen.Style := psClear;
    if Canvas.Pen.Style <> psClear then
      Result := Canvas.Pen.Width
    else
      Result := 0;
  end;

var
  LineWidth : Integer;
begin
  Assert(LineStyles<>nil);
  LineWidth := SetBorderPen(0);
  if LineWidth>0 then
  begin
    Canvas.MoveTo(0,0 + LineWidth div 2);
    Canvas.LineTo(Width,0 + LineWidth div 2);
  end;
  LineWidth := SetBorderPen(1);
  if LineWidth>0 then
  begin
    Canvas.MoveTo(Width - (1 + LineWidth) div 2,0);
    Canvas.LineTo(Width - (1 + LineWidth) div 2,Height);
  end;
  LineWidth := SetBorderPen(2);
  if LineWidth>0 then
  begin
    Canvas.MoveTo(Width, Height -(1 + LineWidth) div 2);
    Canvas.LineTo(0, Height -(1 + LineWidth) div 2);
  end;
  LineWidth := SetBorderPen(3);
  if LineWidth>0 then
  begin
    Canvas.MoveTo(0 + LineWidth div 2, Height);
    Canvas.LineTo(0 + LineWidth div 2, 0);
  end;
end;

function  GetCtrlName(Ctrl : TControl; const Default:string=''): string;
begin
  Result := '';
  if Ctrl is TRDLabel then
    with TRDLabel(Ctrl) do
    begin
      if Caption<>'' then
        Result := Caption
      else if FieldName<>'' then
        Result := '@'+FieldName
    end;
  if (Ctrl is TRDCustomBand) and (TRDCustomBand(Ctrl).BandName<>'') then
    Result := TRDCustomBand(Ctrl).BandName;
  if Result='' then
    Result := Ctrl.Name;  
  if Result='' then
    Result := Default;
  if Result='' then
    Result:=Ctrl.ClassName;
end;


{ TRDCustomBand }

constructor TRDCustomBand.Create(AOwner: TComponent);
begin
  inherited;
  FParentBand := nil;
  FIsPrint := True;
  SetBounds(0,0,80,20);
  Color := clWhite;
  ControlStyle := ControlStyle + [csAcceptsControls, csCaptureMouse, csClickEvents,
    csDoubleClicks, csReplicatable];
  FPrintSize := TRDPrintSize.Create(Self);
  FLoadBandIndex := 0;
end;

function TRDCustomBand.GetBandIndex: Integer;
begin
  if FParentBand=nil then
    Result:=-1
  else
  begin
    Result := FParentBand.FChildren.IndexOf(Self);
    Assert(Result>=0);
  end;
end;

procedure TRDCustomBand.SetBandIndex(const Value: Integer);
var
  NewIndex : Integer;
  OldIndex : Integer;
begin
  if not (csLoading in ComponentState) then
  begin
    OldIndex := BandIndex;
    if (ParentBand<>nil) and (OldIndex <> Value) then
    begin
      if Value<0 then
        NewIndex:=0
      else if Value>=ParentBand.FChildren.Count then
        NewIndex:=ParentBand.FChildren.Count-1
      else NewIndex := Value;
      if NewIndex>=0 then
      begin
        ParentBand.FChildren.Move(OldIndex,NewIndex);
        ParentBand.ArrangeChildren;
      end;
    end;
  end else
  begin
    FLoadBandIndex := Value;
  end;
end;

procedure TRDCustomBand.SetParent(AParent: TWinControl);
begin
  if FParentBand<>nil then
    FParentBand.RemoveChildren(Self);
  FParentBand := nil;

  if not (Self is TRDReport) and (AParent<>nil) then
    if not (AParent is TRDCustomGroupBand) then
      RaiseContainmentError;

  inherited;

  if (Parent is TRDCustomBand) then
    FReport := TRDCustomBand(Parent).Report;
  {if (Parent<>nil) and not (Self is TRDReport) then
    SetBounds(0,Top,Parent.Width,Height);}
  if (Parent is TRDCustomGroupBand) then
  begin
    FParentBand := TRDCustomGroupBand(Parent);
    FParentBand.AddChildren(Self);
    FParentBand.ArrangeChildren;
  end;
end;

destructor TRDCustomBand.Destroy;
begin
  if FParentBand<>nil then
    FParentBand.RemoveChildren(Self);
  FParentBand := nil;
  FreeAndNil(FPrintSize);
  inherited;
end;

{
procedure TRDCustomBand.ValidateContainer(AComponent: TComponent);
begin
  if not (Self is TRDReport) then
    if not (AComponent is TRDCustomGroupBand) then
      RaiseContainmentError;
end;
}
procedure TRDCustomBand.Paint;
begin
  inherited;
  Canvas.Pen := DesignFramePen;
  Canvas.MoveTo(0,0);
  Canvas.LineTo(Width-1,0);
  Canvas.LineTo(Width-1,Height-1);
  Canvas.LineTo(0,Height-1);
  Canvas.LineTo(0,0);
end;

procedure TRDCustomBand.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  if ParentBand<>nil then
    ParentBand.ArrangeChildren;
end;

procedure TRDCustomBand.SetPrintSize(const Value: TRDPrintSize);
begin
  FPrintSize.Assign(Value);
end;

procedure TRDCustomBand.Loaded;
begin
  inherited;
  FPrintSize.AfterControlLoad;
end;

{ TRDSimpleBand }

constructor TRDSimpleBand.Create(AOwner: TComponent);
begin
  inherited;
  FFrame := TRPFrame.Create;
  FFrame.OnChanged := FrameChanged;
  ParentColor := False;
  Color := clWhite;
  Transparent := true;
  FIsSpace := False;
  FIsAlignBottom := False;
  FIsForceNewPage := False;
  FIsForceEndPage := False;
  FNoNewPageAtFirst := False;
end;

procedure TRDSimpleBand.FrameChanged(Sender : TObject);
begin
  Invalidate;
end;

procedure TRDSimpleBand.Paint;
begin
  inherited;
  if Report<>nil then
    PaintFrame(Canvas,Width,Height,Frame,FReport.LineStyles);
end;

function TRDSimpleBand.GetBandKind: TSimplyBandKind;
begin
  Result := sbkNormal;
  if ParentBand<>nil then
    if ParentBand.Header=Self then
      Result := sbkHeader
    else if ParentBand.Footer=Self then
      Result := sbkFooter
    else if ParentBand.Lefter=Self then
      Result := sbkLefter
    else if ParentBand.Righter=Self then
      Result := sbkRighter;
end;

procedure TRDSimpleBand.SetBandKind(const Value: TSimplyBandKind);
var
  OldKind : TSimplyBandKind;
begin
  OldKind := GetBandKind;
  if (ParentBand<>nil) and (OldKind<>Value) then
  begin
    case OldKind of
      sbkHeader: ParentBand.FHeader := nil;
      sbkFooter: ParentBand.FFooter:= nil;
      sbkLefter: ParentBand.FLefter:= nil;
      sbkRighter: ParentBand.FRighter := nil;
    end;
    case Value of
      sbkHeader: ParentBand.FHeader := self;
      sbkFooter: ParentBand.FFooter:= self;
      sbkLefter: ParentBand.FLefter:= self;
      sbkRighter: ParentBand.FRighter := self;
    end;
    {if Value<>sbkFooter then
      FIsAlignBottom := false;}
    ParentBand.ArrangeChildren;
  end;
end;

procedure TRDSimpleBand.SetFrame(const Value: TRPFrame);
begin
  FFrame.Assign(Value);
end;
{
function TRDSimpleBand.GetTransparent: Boolean;
begin
  Result := not (csOpaque in ControlStyle);
end;

procedure TRDSimpleBand.SetTransparent(const Value: Boolean);
begin
  if Transparent <> Value then
  begin
    if Value then
    begin
      ControlStyle := ControlStyle - [csOpaque];
      ParentColor := true;
    end
    else
      ControlStyle := ControlStyle + [csOpaque];
    Invalidate;
  end;
end;
}
{
procedure TRDSimpleBand.CMColorChanged(var Message: TMessage);
begin
  inherited;
  if
  Brush.Color :=
end;
}
procedure TRDSimpleBand.SetIsAlignBottom(const Value: Boolean);
begin
  {if FIsAlignBottom <> Value then
    FIsAlignBottom := Value and (BandKind=sbkFooter);}
  FIsAlignBottom := Value;
end;

procedure TRDSimpleBand.CMColorChanged(var Message: TMessage);
begin
  inherited;
  if Color<>clWhite then
    Transparent := False;
end;

procedure TRDSimpleBand.SetTransparent(const Value: Boolean);
begin
  if FTransparent <> Value then
  begin
    FTransparent := Value;
    if FTransparent then
      Color := clWhite;
  end;
end;

procedure TRDSimpleBand.SetIsSpace(const Value: Boolean);
begin
  if FIsSpace <> Value then
  begin
    if Value and (BandKind=sbkHeader) then Exit;
    FIsSpace := Value;
  end;
end;

{ TRDCustomGroupBand }

constructor TRDCustomGroupBand.Create(AOwner: TComponent);
begin
  FChildren := TList.Create;
  FLefter := nil;
  FRighter := nil;
  FHeader := nil;
  FFooter := nil;
  inherited;
  FArranging := false;
end;

destructor TRDCustomGroupBand.Destroy;
begin
  inherited;
  FreeAndNil(FChildren);
end;

procedure TRDCustomGroupBand.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  NeedArrange : Boolean;
begin
  inherited;
  NeedArrange := false;
  if Operation=opRemove then
  begin
    {
    NeedArrange := true;
    if AComponent=Header then
      FHeader:=nil
    else if AComponent=Footer then
      FFooter:=nil
    else if AComponent=Lefter then
      FLefter:=nil
    else if AComponent=Righter then
      FRighter:=nil
    else
      NeedArrange := False;
    //FChildren.Remove(AComponent);
    }
    if AComponent is TRDCustomBand then
    begin
      RemoveChildren(TRDCustomBand(AComponent));
      NeedArrange := true;
    end;
  end;
  if not (csDestroying in ComponentState)
    and not (csFreeNotification in ComponentState)
    and NeedArrange then
    ArrangeChildren;
end;

procedure TRDCustomGroupBand.AddChildren(Children: TRDCustomBand);
begin
  Assert(FChildren<>nil);
  FChildren.Add(Children);
end;

procedure TRDCustomGroupBand.RemoveChildren(Children: TRDCustomBand);
begin
  Assert(FChildren<>nil);
  FChildren.Remove(Children);
  if Children=Header then
    FHeader:=nil
  else if Children=Footer then
    FFooter:=nil
  else if Children=Lefter then
    FLefter:=nil
  else if Children=Righter then
    FRighter:=nil;
end;

procedure TRDCustomGroupBand.ArrangeChildren;
var
  i : integer;
  W : Integer;
  X,Y : Integer;
  TempList : TList;
  Band : TRDCustomBand;
begin
  if not FArranging and not (csLoading in ComponentState) then
  begin
    FArranging := true;
    TempList := TList.Create;
    try
      for i:=0 to FChildren.Count-1 do
        TempList.Add(FChildren[i]);

      W := Width;
      X := 0;
      Y := 0;
      if Lefter<>nil then
      begin
        W := W - Lefter.Width;
        X := Lefter.Width;
        Lefter.SetBounds(0,0,Lefter.Width,Height);
        TempList.Remove(Lefter);
      end;
      if Righter<>nil then
      begin
        W := W - Righter.Width;
        Righter.SetBounds(Width-Righter.Width,0,Righter.Width,Height);
        TempList.Remove(Righter);
      end;
      if Header<>nil then
      begin
        Y := Header.Height;
        Header.SetBounds(X,0,W,Header.Height);
        TempList.Remove(Header);
      end;
      if Footer<>nil then
      begin
        Footer.SetBounds(X,Height-Footer.Height,W,Footer.Height);
        TempList.Remove(Footer);
      end;
      for i:=0 to TempList.Count-1 do
      begin
        Band := TRDCustomBand(TempList[i]);
        Assert(Band is TRDCustomBand);
        Band.SetBounds(X,Y,W,Band.Height);
        Y := Y + Band.Height;
      end;
    finally
      TempList.Free;
      FArranging := false;
    end;
  end;
end;

procedure TRDCustomGroupBand.SetArranged(const Value: Boolean);
begin
  ArrangeChildren;
end;

procedure TRDCustomGroupBand.SetBounds(ALeft, ATop, AWidth,
  AHeight: Integer);
begin
  inherited;
  if FChildren.Count>0 then
    ArrangeChildren;
end;

procedure TRDCustomGroupBand.Loaded;
begin
  inherited;
  SortBands;
end;

function CompareBand(Item1, Item2: Pointer): Integer;
begin
  Result := TRDCustomBand(Item1).FLoadBandIndex - TRDCustomBand(Item2).FLoadBandIndex;
end;

procedure TRDCustomGroupBand.SortBands;
begin
  FChildren.Sort(CompareBand);
  ArrangeChildren;
end;

{ TRDReport }

constructor TRDReport.Create(AOwner: TComponent);
begin
  inherited;
  FLineStyles := TLineStyles.Create(Self);
  with TLineStyle(FLineStyles.Add) do
  begin
    Pen.Style := psSolid;
    Pen.Width := 1;
    Pen.Color := clBlack;
  end;
  with TLineStyle(FLineStyles.Add) do
  begin
    Pen.Style := psSolid;
    Pen.Width := 2;
    Pen.Color := clBlack;
  end;
  with TLineStyle(FLineStyles.Add) do
  begin
    Pen.Style := psDot;
    Pen.Width := 1;
    Pen.Color := clBlack;
  end;
  FReport := self;

  FMargin:= TRPMargin{TRPPageMargin}.Create;
  with FMargin do
  begin
    Left := DefaultMargin;
    Right := DefaultMargin;
    Top := DefaultMargin;
    Bottom := DefaultMargin;
  end;

  FMargin.OnChanged := MarginChanged;
  PaperSize := A4;
  FColumns := 1;
  FRows := 1;
  FOrientation := poPortrait;

  FFixedSize := False;
end;

destructor TRDReport.Destroy;
begin
  FLineStyles.Free;
  FMargin.Free;
  inherited;
end;

procedure TRDReport.SetLineStyles(const Value: TLineStyles);
begin
  FLineStyles.Assign(Value);
end;

procedure TRDReport.SetMargin(const Value: TRPMargin{TRPPageMargin});
begin
  FMargin.Assign(Value);
end;

procedure TRDReport.SetPaperHeight(const Value: TFloat);
begin
  if (FPaperHeight <> Value) then
  begin
    FPaperSize:=Custom;
    FPaperHeight := Value;
    PaperSizeChanged;
  end;
end;

procedure TRDReport.SetPaperWidth(const Value: TFloat);
begin
  if (FPaperWidth <> Value) then
  begin
    FPaperSize:=Custom;
    FPaperWidth := Value;
    PaperSizeChanged;
  end;
end;

procedure TRDReport.SetPaperSize(const Value: TRPPaperSize);
begin
  if PaperSize<> Value then
  begin
    FPaperSize := Value;
    if FPaperSize<>Custom then
    begin
      FPaperWidth := RPPaperSizeMetrics[FPaperSize,0]*10;
      FPaperHeight := RPPaperSizeMetrics[FPaperSize,1]*10;
      PaperSizeChanged;
    end;
  end;
end;

procedure TRDReport.PaperSizeChanged;
var
  W, H : Integer;
begin
  if not (csLoading in ComponentState) then
  begin
    W := ScreenTransform.Physics2DeviceX(PaperWidth-Margin.Left-Margin.Right);
    H := ScreenTransform.Physics2DeviceY(PaperHeight-Margin.Top-Margin.Bottom);
    if Orientation = poPortrait then
      SetBounds(Left,Top,W,H) else
      SetBounds(Left,Top,H,W);
  end;
end;

procedure TRDReport.Loaded;
begin
  inherited;
  PaperSizeChanged;
end;

procedure TRDReport.MarginChanged(Sender: TObject);
begin
  PaperSizeChanged;
end;

procedure TRDReport.SetColumns(const Value: Integer);
begin
  if Value>0 then
  begin
    FColumns := Value;
  end;
end;

procedure TRDReport.SetRows(const Value: Integer);
begin
  if Value>0 then
  begin
    FRows := Value;
  end;
end;

procedure TRDReport.SetOrientation(
  const Value: TRPOrientation);
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;
    PaperSizeChanged;
  end;
end;


procedure TRDReport.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if Parent = nil then
  begin
    if Application.Handle<>0 then
      Params.WndParent := Application.Handle else
      Params.WndParent := GetDesktopWindow; // for DLL
  end;

end;

procedure TRDReport.SetParent(AParent: TWinControl);
begin
  if (Parent = nil) and HandleAllocated then
    DestroyHandle;
  inherited;
end;

procedure TRDReport.ReadState(Reader: TReader);
begin
  with FMargin do
  begin
    Left := 0;
    Right := 0;
    Top := 0;
    Bottom := 0;
  end;
  inherited;
end;

{ TRDCustomRepeatBand }

constructor TRDCustomRepeatBand.Create(AOwner: TComponent);
begin
  inherited;
  FColumns := 1;
  FGroupIndex := -1;
end;

procedure TRDCustomRepeatBand.SetColumns(const Value: Integer);
begin
  if (Value>=1) and (Value<>FColumns) then
  begin
    FColumns := Value;
  end;
end;

{ TRDCustomControl }


constructor TRDCustomControl.Create(AOwner: TComponent);
begin
  inherited;
  Transparent := true;
  SetBounds(Left,Top,64,16);
  FFrame := TRPFrame.Create;
  FFrame.OnChanged := FrameChanged;
  FLink:= TRDCtrlPosLink.Create(Self);
  FMargin := TRPMargin.Create;
  FMargin.Left := 0;
  FMargin.Right := 0;
  FMargin.Top := 0;
  FMargin.Bottom := 0;
  FMargin.OnChanged := MarginChanged;
  FIsPrint := True;
  FPrintSize := TRDPrintSize.Create(Self);
end;

function TRDCustomControl.GetBottomDistance: Integer;
begin
  if Parent<>nil then
    Result := Parent.ClientHeight - (Top + Height)
  else
    Result := 0;
end;

function TRDCustomControl.GetRightDistance: Integer;
begin
  if Parent<>nil then
    Result := Parent.ClientWidth - (Left+ Width)
  else
    Result := 0;
end;

function TRDCustomControl.GetTransparent: Boolean;
begin
  Result := not (csOpaque in ControlStyle);
end;

procedure TRDCustomControl.SetBottomDistance(const Value: Integer);
begin
  if (Parent<>nil) and not (csLoading in ComponentState) then
    SetBounds(Left,Top,Width,Parent.ClientHeight-Top-Value);
end;

procedure TRDCustomControl.SetRightDistance(const Value: Integer);
begin
  if (Parent<>nil) and not (csLoading in ComponentState) then
    SetBounds(Left,Top,Parent.ClientWidth-Left-Value,Height);
end;

procedure TRDCustomControl.SetTransparent(const Value: Boolean);
begin
  if Transparent <> Value then
  begin
    if Value then
      ControlStyle := ControlStyle - [csOpaque] else
      ControlStyle := ControlStyle + [csOpaque];
    if Value then
      Color := clWhite;
    Invalidate;
  end;
end;
{
function TRDCustomControl.IsStoreBottomDistance: Boolean;
begin
  Result := akBottom in Anchors;
end;

function TRDCustomControl.IsStoreRightDistance: Boolean;
begin
  Result := akRight in Anchors;
end;
}
procedure TRDCustomControl.SetParent(AParent: TWinControl);
begin
  if AParent is TRDSimpleBand then
    FReport := TRDSimpleBand(AParent).Report
  else if AParent=nil then
    FReport := nil
  else RaiseContainmentError;
  inherited;
end;

procedure TRDCustomControl.Paint;
begin
  with Canvas do
  begin
    if not Transparent then
    begin
      Brush.Color := Self.Color;
      Brush.Style := bsSolid;
      FillRect(ClientRect);
    end;
  end;
end;

destructor TRDCustomControl.Destroy;
begin
  FreeAndNil(FLink);
  FreeAndNil(FPrintSize);
  FreeLinks;
  FFrame.Free;
  inherited;
end;

procedure TRDCustomControl.SetFrame(const Value: TRPFrame);
begin
  FFrame.Assign(Value);
end;

procedure TRDCustomControl.FrameChanged(Sender: TObject);
begin
  Invalidate;
end;


procedure TRDCustomControl.AddLink(Link: TRDCtrlPosLink);
begin
  if FLinks=nil then
  begin
    FLinks := TList.Create;
  end;
  FLinks.Add(Link);
end;

procedure TRDCustomControl.RemoveLink(Link: TRDCtrlPosLink);
begin
  if FLinks<>nil then
  begin
    FLinks.Remove(Link);
  end;
end;

procedure TRDCustomControl.SetLink(const Value: TRDCtrlPosLink);
begin
  FLink.Assign(Value);
end;

procedure TRDCustomControl.NotifyLinks;
var
  i : integer;
begin
  if FLinks<>nil then
  begin
    for i:=0 to FLinks.Count-1 do
      TRDCtrlPosLink(FLinks[i]).Update;
  end;
end;

procedure TRDCustomControl.SetBounds(ALeft, ATop, AWidth,
  AHeight: Integer);
var
  DoIt : Boolean;
begin
  DoIt := (ALeft<>Left) or (ATop<>Top) or (Width<>AWidth) or (AHeight<>Height);
  inherited;
  if DoIt then NotifyLinks;
end;

procedure TRDCustomControl.FreeLinks;
var
  Link : TRDCtrlPosLink;
  Old : Integer;
begin
  if FLinks<>nil then
    while FLinks.Count>0 do
    begin
      Old := FLinks.Count;
      Link := TRDCtrlPosLink(FLinks[0]);
      Link.LinkTo := nil;
      Assert(Old=FLinks.Count+1);
    end;
  FreeAndNil(FLinks);
end;

procedure TRDCustomControl.CMColorChanged(var Message: TMessage);
begin
  inherited;
  if Color<>clWhite then
    Transparent := False;
end;


procedure TRDCustomControl.SetMargin(const Value: TRPMargin);
begin
  FMargin.Assign(Value);
end;

function TRDCustomControl.GetPaintRect: TRect;
begin
  Result := GetClientRect;
  Result.Left := Result.Left + ScreenTransform.Physics2DeviceX(Margin.Left);
  Result.Right:= Result.Right- ScreenTransform.Physics2DeviceX(Margin.Right);
  Result.Top := Result.Top + ScreenTransform.Physics2DeviceY(Margin.Top);
  Result.Bottom := Result.Bottom- ScreenTransform.Physics2DeviceY(Margin.Bottom);
end;

procedure TRDCustomControl.MarginChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TRDCustomControl.SetPrintSize(const Value: TRDPrintSize);
begin
  FPrintSize.Assign(Value);
end;

procedure TRDCustomControl.Loaded;
begin
  inherited;
  FPrintSize.AfterControlLoad;
end;

{ TRDLabel }

constructor TRDLabel.Create(AOwner: TComponent);
begin
  inherited;
  ParentColor := False;
  Color := clWhite;
end;

destructor TRDLabel.Destroy;
begin

  inherited;
end;

procedure TRDLabel.CMTextChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TRDLabel.Paint;
var
  Flags : Integer;
  ARect : TRect;
begin
  inherited;
  if FReport<>nil then
    PaintFrame(Canvas,Width,Height,Frame,FReport.LineStyles);
  with Canvas do
  begin
    Font := Self.Font;
    Brush.Style := bsClear;
    ARect := GetPaintRect;
    Flags := GetTextFlags(HAlign,VAlign);
    DrawText(Handle, PChar(Caption), Length(Caption), ARect, Flags);
  end;
end;

procedure TRDLabel.SetHAlign(const Value: TRPHAlign);
begin
  if FHAlign <> Value then
  begin
    FHAlign := Value;
    Invalidate;
  end;
end;

procedure TRDLabel.SetVAlign(const Value: TRPVAlign);
begin
  if FVAlign <> Value then
  begin
    FVAlign := Value;
    Invalidate;
  end;
end;

procedure TRDLabel.SetFieldName(const Value: string);
begin
  if FFieldName <> Value then
  begin
    if (Value<>'') and ((Caption='') or (Caption='@'+FFieldName)) then
      Caption := '@'+Value;
    FFieldName := Value;
  end;
end;


{ TRDShape }

procedure TRDShape.BrushChanged(Sender: TObject);
begin
  Invalidate;
end;

constructor TRDShape.Create(AOwner: TComponent);
begin
  inherited;
  FBrush := TBrush.Create;
  FBrush.OnChange := BrushChanged;
  FLineIndex := 0;
end;

destructor TRDShape.Destroy;
begin
  FBrush.Free;
  inherited;
end;

procedure TRDShape.Paint;
var
  LineStyles : TLineStyles;
  HalfWidth : Integer;
begin
  inherited;
  if FReport<>nil then
    LineStyles := FReport.LineStyles
  else
    LineStyles := nil;
  { TODO : 增加对margin的支持 }
  with Canvas do
  begin
    Brush := Self.Brush;
    if (LineStyles<>nil) and (LineIndex>=0) and (LineIndex<LineStyles.Count) then
    begin
      Pen := LineStyles[LineIndex].Pen;
      HalfWidth := Pen.Width div 2;
    end
    else
    begin
      Pen.Style := psClear;
      HalfWidth := 0;
    end;
    case Shape of
      rdstRectangle: Rectangle(HalfWidth,HalfWidth,Width,Height);
      rdstEllipse: Ellipse(HalfWidth,HalfWidth,Width,Height);
      rdstHLine: begin
                   MoveTo(0,Height div 2);
                   LineTo(Width,Height div 2);
                 end;
      rdstVLine: begin
                   MoveTo(Width div 2,0);
                   LineTo(Width div 2,Height);
                 end;
      rdstLine1: begin
                   MoveTo(0,0);
                   LineTo(Width,Height);
                 end;
      rdstLine2: begin
                   MoveTo(Width,0);
                   LineTo(0,Height);
                 end;
    end;
  end;
end;

procedure TRDShape.SetBrush(const Value: TBrush);
begin
  FBrush := Value;
end;

procedure TRDShape.SetLineIndex(const Value: Integer);
begin
  if FLineIndex <> Value then
  begin
    FLineIndex := Value;
    Invalidate;
  end;
end;

procedure TRDShape.SetShape(const Value: TRDShapeType);
begin
  if FShape <> Value then
  begin
    FShape := Value;
    Invalidate;
  end;
end;

{ TRDPicture }

constructor TRDPicture.Create(AOwner: TComponent);
begin
  inherited;
  FPicture := TPicture.Create;
  FPicture.OnChange := PictureChanged;
end;

destructor TRDPicture.Destroy;
begin
  FPicture.Free;
  inherited;
end;

procedure TRDPicture.Paint;
begin
  inherited;
  if Stretch then
    Canvas.StretchDraw(GetPaintRect,Picture.Graphic) else
    Canvas.Draw(0,0,Picture.Graphic);
end;

procedure TRDPicture.PictureChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TRDPicture.SetPicture(const Value: TPicture);
begin
  FPicture.Assign(Value);
end;

procedure TRDPicture.SetStretch(const Value: boolean);
begin
  if FStretch <> Value then
  begin
    FStretch := Value;
    Invalidate;
  end;
end;

{ TRDCtrlPosLink }

constructor TRDCtrlPosLink.Create(AOwner: TRDCustomControl);
begin
  FOwner := AOwner;
  FStyle := lsNone;
  Assert(FOwner<>nil);
end;

procedure TRDCtrlPosLink.SetLinkTo(const Value: TRDCustomControl);
begin
  if FLinkTo <> Value then
  begin
    if FLinkTo<>nil then
      FLinkTo.RemoveLink(Self);
    if Value<>Owner then
      FLinkTo := Value else
      FLinkTo := nil;
    if FLinkTo<>nil then
    begin
      FLinkTo.AddLink(Self);
      Update;
    end;
  end;
end;

procedure TRDCtrlPosLink.Assign(Source: TPersistent);
begin
  if Source is TRDCtrlPosLink then
  begin
    FUpdating := True;
    Style := TRDCtrlPosLink(Source).Style;
    LinkTo := TRDCtrlPosLink(Source).LinkTo;
    FUpdating := False;
    Update; // triger update
  end else
    inherited;
end;

procedure TRDCtrlPosLink.Update;
begin
  if not FUpdating and (LinkTo<>nil) and not (csLoading in Owner.ComponentState) then
  begin
    case Style of
      lsLeftToRight   : Owner.SetBounds(LinkTo.Left+LinkTo.Width,LinkTo.Top,Owner.Width,Owner.Height);
      lsLeftRightAlign: Owner.SetBounds(LinkTo.Left,Owner.Top,LinkTo.Width,Owner.Height);
      lsLeftAlign     : Owner.SetBounds(LinkTo.Left,Owner.Top,Owner.Width,Owner.Height);
      lsTopAlign      : Owner.SetBounds(Owner.Left,LinkTo.Top,Owner.Width,Owner.Height);
      lsTopBottomAlign: Owner.SetBounds(Owner.Left,LinkTo.Top,Owner.Width,LinkTo.Height);
      lsTopToBottom   : Owner.SetBounds(LinkTo.Left,LinkTo.Top+LinkTo.Height,Owner.Width,Owner.Height);
      lsTopToBottom2  : Owner.SetBounds(LinkTo.Left,LinkTo.Top+LinkTo.Height,LinkTo.Width,Owner.Height);
      lsLeftToRight2  : Owner.SetBounds(LinkTo.Left+LinkTo.Width,LinkTo.Top,Owner.Width,LinkTo.Height);
    end;
  end;
end;

procedure TRDCtrlPosLink.SetStyle(const Value: TRDPosLinkStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Update;
  end;
end;

procedure TRDCtrlPosLink.SetValue(AStyle: TRDPosLinkStyle;
  ALinkTo: TRDCustomControl);
begin
  FUpdating := True;
  Style := AStyle;
  LinkTo := ALinkTo;
  FUpdating := False;
  Update;
end;

destructor TRDCtrlPosLink.Destroy;
begin
  LinkTo := nil;
  inherited;
end;

{ TRDPrintSize }

constructor TRDPrintSize.Create(AControl: TControl);
begin
  Assert(AControl<>nil);
  inherited Create;
  FControl := AControl;
  ClearFlags;
  with Control do
  begin
    FPrintLeft := ScreenTransform.Device2PhysicsX(Left);
    FPrintTop  := ScreenTransform.Device2PhysicsY(Top);
    FPrintWidth := ScreenTransform.Device2PhysicsX(Width);
    FPrintHeight:= ScreenTransform.Device2PhysicsY(Height);
    if Parent<>nil then
    begin
      FPrintRightDistance := ScreenTransform.Device2PhysicsX(Parent.ClientWidth - (Left+ Width));
      FPrintBottomDistance := ScreenTransform.Device2PhysicsY(Parent.ClientHeight - (Top + Height));
    end else
    begin
      FPrintRightDistance := 0;
      FPrintBottomDistance := 0;
    end;
  end;
  // 设置缺省值
  FX := 0;
  FY := 0;
  FH := 0;
  FW := 0;
  FX1 := 0;
  FY1 := 0;
end;

procedure TRDPrintSize.AfterControlLoad;
var
  X, Y, H, W : Integer;
  AddAnchors : TAnchors;
begin
  if FXFlag or FYFlag or FWFlag or FHFlag or FX1Flag or FY1Flag then
  begin
    if FXFlag then
      X := ScreenTransform.Physics2DeviceX(FX) else
      X := Control.Left;
    if FYFlag then
      Y := ScreenTransform.Physics2DeviceY(FY) else
      Y := Control.Top;
    if FWFlag then
      W := ScreenTransform.Physics2DeviceX(FW) else
      W := Control.Width;
    if FHFlag then
      H := ScreenTransform.Physics2DeviceY(FH) else
      H := Control.Height;
    // 追加判断 (akRight in Control.Anchors)，因为PrintRightDistance=0的时候，不保存到流，不会装载，FX1Flag=False
    if FX1Flag or (akRight in Control.Anchors) then
      if [akLeft,akRight]<=Control.Anchors then
        W := Control.Parent.ClientWidth-X-ScreenTransform.Physics2DeviceX(FX1)
      else if (akRight in Control.Anchors) then
        X := Control.Parent.ClientWidth-W-ScreenTransform.Physics2DeviceX(FX1);
    // 追加判断 (akBottom in Control.Anchors)，因为PrintBottomDistance=0的时候，不保存到流，不会装载，FY1Flag=False    
    if FY1Flag or (akBottom in Control.Anchors) then
      if [akTop,akBottom]<=Control.Anchors then
        H := Control.Parent.ClientHeight-Y-ScreenTransform.Physics2DeviceY(FY1)
      else if (akBottom in Control.Anchors) then
        Y := Control.Parent.ClientHeight-H-ScreenTransform.Physics2DeviceY(FY1);
    Control.SetBounds(X,Y,W,H);
    AddAnchors := [];
    if not (akLeft in Control.Anchors) and not (akRight in Control.Anchors) then
      AddAnchors := AddAnchors+[akLeft];
    if not (akTop in Control.Anchors) and not (akBottom in Control.Anchors) then
      AddAnchors := AddAnchors+[akTop];
    Control.Anchors := Control.Anchors + AddAnchors;
    ClearFlags;
  end;
end;

procedure TRDPrintSize.ClearFlags;
begin
  FXFlag := False;
  FYFlag := False;
  FWFlag := False;
  FHFlag := False;
  FX1Flag := False;
  FY1Flag := False;
end;

function TRDPrintSize.GetPrintHeight: TFloat;
begin
  // 保持物理浮点数精度
  if FControl.Height<>ScreenTransform.Physics2DeviceY(FPrintHeight) then
  begin
    FPrintHeight := ScreenTransform.Device2PhysicsY(FControl.Height);
  end;
  Result := FPrintHeight;
end;

function TRDPrintSize.GetPrintLeft: TFloat;
begin
  // 保持物理浮点数精度
  if FControl.Left<>ScreenTransform.Physics2DeviceX(FPrintLeft) then
  begin
    FPrintLeft := ScreenTransform.Device2PhysicsX(FControl.Left);
  end;
  Result := FPrintLeft;
end;

function TRDPrintSize.GetPrintTop: TFloat;
begin
  // 保持物理浮点数精度
  if FControl.Top<>ScreenTransform.Physics2DeviceY(FPrintTop) then
  begin
    FPrintTop := ScreenTransform.Device2PhysicsY(FControl.Top);;
  end;
  Result := FPrintTop;
end;

function TRDPrintSize.GetPrintWidth: TFloat;
begin
  // 保持物理浮点数精度
  if FControl.Width<>ScreenTransform.Physics2DeviceX(FPrintWidth) then
  begin
    FPrintWidth := ScreenTransform.Device2PhysicsX(FControl.Width);
  end;
  Result := FPrintWidth;
end;

procedure TRDPrintSize.SetPrintHeight(const Value: TFloat);
begin
  if not (csLoading in Control.ComponentState) then
    Control.Height := ScreenTransform.Physics2DeviceY(Value) else
  begin
    FH := Value;
    FHFlag := True;
  end;
  FPrintHeight := Value;
end;

procedure TRDPrintSize.SetPrintLeft(const Value: TFloat);
begin
  if not (csLoading in Control.ComponentState) then
    Control.Left := ScreenTransform.Physics2DeviceX(Value) else
  begin
    FX := Value;
    FXFlag := True;
  end;
  FPrintLeft := Value;
end;

procedure TRDPrintSize.SetPrintTop(const Value: TFloat);
begin
  if not (csLoading in Control.ComponentState) then
    Control.Top := ScreenTransform.Physics2DeviceY(Value) else
  begin
    FY := Value;
    FYFlag := True;
  end;
  FPrintTop := Value;
end;

procedure TRDPrintSize.SetPrintWidth(const Value: TFloat);
begin
  if not (csLoading in Control.ComponentState) then
    Control.Width := ScreenTransform.Physics2DeviceX(Value) else
  begin
    FW := Value;
    FWFlag := True;
  end;
  FPrintWidth := Value;
end;

procedure TRDPrintSize.Assign(Source: TPersistent);
begin
  if Source is TRDPrintSize then
  begin
    FX := TRDPrintSize(Source).PrintLeft;
    FY := TRDPrintSize(Source).PrintTop;
    FW := TRDPrintSize(Source).PrintWidth;
    FH := TRDPrintSize(Source).PrintHeight;
    FXFlag := True;
    FYFlag := True;
    FWFlag := True;
    FHFlag := True;
    FX1Flag := False;
    FY1Flag := False;

    FPrintLeft := TRDPrintSize(Source).PrintLeft;
    FPrintTop := TRDPrintSize(Source).PrintTop;
    FPrintWidth := TRDPrintSize(Source).PrintWidth;
    FPrintHeight := TRDPrintSize(Source).PrintHeight;

    AfterControlLoad;
  end else
    inherited;
end;

function TRDPrintSize.GetPrintBottomDistance: TFloat;
begin
  with Control do
  if Parent<>nil then
  begin
    // 保持物理浮点数精度
    if Parent.ClientHeight - (Top + Height)<>ScreenTransform.Physics2DeviceY(FPrintBottomDistance) then
      FPrintBottomDistance := ScreenTransform.Device2PhysicsY(Parent.ClientHeight - (Top + Height));
  end;
  Result := FPrintBottomDistance;
end;

function TRDPrintSize.GetPrintRightDistance: TFloat;
begin
  with Control do
  if Parent<>nil then
  begin
    // 保持物理浮点数精度
    if Parent.ClientWidth - (Left+ Width)<>ScreenTransform.Physics2DeviceX(FPrintRightDistance) then
      FPrintRightDistance := ScreenTransform.Device2PhysicsY(Parent.ClientWidth - (Left+ Width));
  end;
  Result := FPrintRightDistance;
end;

procedure TRDPrintSize.SetPrintBottomDistance(const Value: TFloat);
begin
  with Control do
  if Parent<>nil then
    if not (csLoading in ComponentState) then
      Height := Parent.ClientHeight-Top-ScreenTransform.Physics2DeviceY(Value)
    else
    begin
      FY1 := Value;
      FY1Flag := True;
    end;
  FPrintBottomDistance := Value;
end;

procedure TRDPrintSize.SetPrintRightDistance(const Value: TFloat);
begin
  with Control do
  if Parent<>nil then
    if not (csLoading in ComponentState) then
      Width := Parent.ClientWidth-Left-ScreenTransform.Physics2DeviceX(Value)
    else
    begin
      FX1 := Value;
      FX1Flag := True;
    end;
  FPrintRightDistance := Value;  
end;

function TRDPrintSize.IsStoreBottomDistance: Boolean;
begin
  Result :=  akBottom in Control.Anchors;
end;

function TRDPrintSize.IsStoreRightDistance: Boolean;
begin
  Result :=  akRight in Control.Anchors;
end;

(*
{ TRPPageMargin }

constructor TRPPageMargin.Create;
begin
  inherited ;
  Left := DefaultMargin;
  Right := DefaultMargin;
  Top := DefaultMargin;
  Bottom := DefaultMargin;
end;
*)

initialization
  DesignFramePen := TPen.Create;
  DesignFramePen.Color := clBlue;
  DesignFramePen.Style := psDot;

finalization
  DesignFramePen.Free;
end.
