unit RPDefines;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>RPDefines
   <What>提供打印驱动接口、基本的数据类型等等的定义。
   被其他单元所引用。
   <Written By> Huang YanLai
   <See>打印.mdl
   <History>
    0.l 接口定义来自PrintDevices.pas
**********************************************}

interface

uses Windows, SysUtils, Classes, Graphics;

const
  TenthMMPerInch = 254; // 1 inch 英寸=25.4 millimetres 毫米 = 254 * 0.1mm
  lcReport = 5;

type
  TFloat = Single; // 定义浮点数类型,用于表示物理长度(0.1mm)
  TLineStyles = class;

  // 定义物理大小
  TRPSize = record
    Width, Height : TFloat;
  end;

  // 定义物理矩形区域
  TRPRect = record
    Left, Right, Top, Bottom : TFloat;
  end;

  TRPHAlign = (haLeft,haRight,haCenter); // 文本水平对齐方式
  TRPVAlign = (vaTop,vaBottom,vaCenter,vaMultiLine); // 文本垂直对齐方式

  TRPTextFormatType = (  // 文本格式化方法
    tfNone,       // 无
    tfNormal,     // 使用Format()
    tfFloat,      // 使用FormatFloat()
    tfDateTime    // 使用FormatDateTime()
    );

  {
    <Class>TTransform
    <What>提供坐标变换处理：输出设备像素坐标和物理坐标（0.1mm为单位）的变换
    <Properties>
      XPixesPerTenthMM - 输出设备水平方向每0.1mm的像素数目
      YPixesPerTenthMM - 输出设备垂直方向每0.1mm的像素数目
    <Methods>
      -
    <Event>
      -
  }
  TTransform = class(TObject)
  private
    FYPixesPerTenthMM: TFloat;
    FXPixesPerTenthMM: TFloat;
  protected

  public
    procedure InitFromDC(DC : THandle; OldMethod : Boolean=False);
    procedure InitFromCanvas(Canvas : TCanvas);
    procedure InitFromScreen(OldMethod : Boolean=False);
    property  XPixesPerTenthMM : TFloat read FXPixesPerTenthMM write FXPixesPerTenthMM;
    property  YPixesPerTenthMM : TFloat read FYPixesPerTenthMM write FYPixesPerTenthMM;
    function  Device2PhysicsX(DeviceValue : Integer):TFloat;
    function  Device2PhysicsY(DeviceValue : Integer):TFloat;
    function  Physics2DeviceX(PhysicsValue : TFloat): Integer;
    function  Physics2DeviceY(PhysicsValue : TFloat): Integer;
  end;

  TRPOrientation = (poPortrait, poLandscape);

  {
    <Interface>IBasicPrinter
    <What>打印驱动接口。坐标位置使用物理长度单位（0.1mm）。
    包括：
      1、打印设备的描述
      2、对打印的文档控制
      3、基本画图功能
    <Properties>
      -
    <Methods>
      -
  }
  { TODO :
对字体的物理大小描述
对线段粗细的物理大小描述 }
  IBasicPrinter = interface
    function  GetPageNumber: Integer;
    function  GetWidth : TFloat;
    function  GetHeight: TFloat;
    function  GetFont: TFont;
    procedure SetFont(Value : TFont);
    function  GetPen: TPen;
    procedure SetPen(Value : TPen);
    function  GetBrush: TBrush;
    procedure SetBrush(Value : TBrush);

    procedure DrawLine(X1,Y1,X2,Y2 : TFloat);
    procedure DrawEllipse(X1,Y1,X2,Y2 : TFloat);
    procedure DrawRect(X1,Y1,X2,Y2 : TFloat);
    procedure DrawRoundRect(X1,Y1,X2,Y2,X3,Y3 : TFloat);
    procedure DrawArc(X1,Y1,X2,Y2,X3,Y3,X4,Y4 : TFloat);
    procedure FillRect(X1,Y1,X2,Y2 : TFloat);
    procedure DrawGraphic(X1,Y1,X2,Y2 : TFloat; Graphic : TGraphic);
    procedure DrawGraphic2(X,Y : TFloat; Graphic : TGraphic);
    procedure DrawText(X,Y : TFloat; const Text:String);
    procedure DrawTextRect(X1,Y1,X2,Y2 : TFloat; const Text:String; Flags : Integer);
    function  CalcTextSize(const Text:String; IsMultiLine : Boolean; Width : TFloat):TRPSize;

    procedure BeginDoc(const Title:string='');
    procedure EndDoc;
    procedure AbortDoc;
    procedure NewPage;
    procedure GetPageSize(var AWidth,AHeight : TFloat);
    function  Printing: Boolean;
    function  Aborted : Boolean;

    function  GetPaperWidth : TFloat;
    function  GetPaperHeight : TFloat;
    function  GetPaperLeftMargin : TFloat;
    function  GetPaperTopMargin : TFloat;
    function  GetTitle : string;
    function  CanSetPaperSize : Boolean;
    procedure SetPaperSize(APaperWidth, APaperHeight : TFloat; AOrientation : TRPOrientation);
    procedure RestorePaperSize;

    property  PageNumber: Integer read GetPageNumber;
    property  Width : TFloat read GetWidth;
    property  Height: TFloat read GetHeight;
    property  Font : TFont read GetFont write SetFont;
    property  Pen : TPen read GetPen write SetPen;
    property  Brush : TBrush read GetBrush write SetBrush;

    property  PaperWidth : TFloat read GetPaperWidth;
    property  PaperHeight : TFloat read GetPaperHeight;
    property  PaperLeftMargin : TFloat read GetPaperLeftMargin;
    property  PaperTopMargin : TFloat read GetPaperTopMargin;
    property  Title : string read GetTitle;
  end;

  TReportStatus = (rsRunning, rsStopped, rsCancelled, rsErrorStop, rsDone);
  {
    <Interface>IReportProcessor
    <What>报表处理接口，具体处理在指定的位置输出（打印）一个报表对象。
    并且提供一个输出报表的环境。
    <Properties>
      -
    <Methods>
      -
  }
  IReportProcessor = interface
    procedure BeginDoc;
    procedure EndDoc;
    procedure AbortDoc;
    procedure NewPage;
    procedure ProcessReport(ReportInfo, ReportedObject : TObject; const ARect : TRPRect);
    function  IsPrint(ReportInfo, ReportedObject : TObject; var ARect : TRPRect): Boolean;
    function  GetLineStyles : TLineStyles;
    function  FindField(const FieldName:string): TObject;
    function  GetVariantText(const FieldName:string; TextFormatType : TRPTextFormatType=tfNone; const TextFormat : string=''): string;
    property  LineStyles : TLineStyles read GetLineStyles;
    procedure DoProgress(var ContinuePrint : Boolean);
    function  GetStatus : TReportStatus;
    procedure SetStatus(Value: TReportStatus);
  end;

  {
    <Class>TLineStyle
    <What>描述一种线型
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TLineStyle = class(TCollectionItem)
  private
    FPen: TPen;
    procedure   SetPen(const Value: TPen);
  protected

  public
    constructor Create(Collection: TCollection); override;
    destructor  Destroy;override;
    procedure   Assign(Source : TPersistent) ; override;
  published
    property    Pen : TPen read FPen write SetPen;
  end;

  {
    <Class>TLineStyles
    <What>描述需要的线型
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TLineStyles = class(TOwnedCollection)
  private
    function    GetLineStyles(Index: Integer): TLineStyle;
  public
    constructor Create(AOwner: TPersistent);
    property    LineStyles[Index : Integer] : TLineStyle read GetLineStyles; default;
  end;

  {
    <Class>TRPFrame
    <What>描述矩形边框。
    各边用线型的索引值标志
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TRPFrame = class(TPersistent)
  private
    FOnChanged: TNotifyEvent;
    function    GetBorder(Index : Integer): Integer;
    procedure   SetBorder(Index, Value: Integer);
    procedure   Changed;
  public
    FBorders : Array[0..3] of Integer;
    constructor Create;
    procedure   Assign(Source: TPersistent); override;
    property    OnChanged : TNotifyEvent read FOnChanged write FOnChanged;
  published
    // clockwise
    property    Top : Integer Index 0 read GetBorder write SetBorder default -1;
    property    Right : Integer Index 1 read GetBorder write SetBorder  default -1;
    property    Bottom : Integer Index 2 read GetBorder write SetBorder default -1;
    property    Left : Integer Index 3 read GetBorder write SetBorder default -1;
  end;

  {
    <Class>TRPMargin
    <What>描述打印页四周的空白
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TRPMargin = class(TPersistent)
  private
    FTop: TFloat;
    FLeft: TFloat;
    FRight: TFloat;
    FBottom: TFloat;
    FOnChanged: TNotifyEvent;
    procedure   Changed;
    procedure   SetBottom(const Value: TFloat);
    procedure   SetLeft(const Value: TFloat);
    procedure   SetRight(const Value: TFloat);
    procedure   SetTop(const Value: TFloat);
  public
    procedure   Assign(Source: TPersistent); override;
    property    OnChanged : TNotifyEvent read FOnChanged write FOnChanged;
  published
    property    Left: TFloat read FLeft write SetLeft;
    property    Right: TFloat read FRight write SetRight;
    property    Top: TFloat read FTop write SetTop;
    property    Bottom: TFloat read FBottom write SetBottom;
  end;

  // 类似 Controls.TAnchors 和 Controls.TAnchorKind
  TRPAnchorKind = (rakLeft,  rakTop, rakRight, rakBottom);
  TRPAnchors = set of TRPAnchorKind; // 描述一个报表控制与它的载体报表控制的位置关系

  // 预定义的纸张大小
  TRPPaperSize = (Letter,
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

  {
    <Class>EStopReport
    <What>终止打印的意外对象。继承自EAbort。用于停止打印。例如打印超出了指定的打印范围。
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  EStopReport = class(EAbort);
  {
    <Class>ECancelReport
    <What>取消打印的意外对象。继承自EAbort。用于取消当前打印。
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  ECancelReport = class(EAbort);
  //ECancelReport = class(Exception);

{
  <Function>GetTextFlags
  <What>返回文字对齐方式对应的数值。
  <Params>
    -
  <Return>
  <Exception>
}
function GetTextFlags(HAlign : TRPHAlign; VAlign : TRPVAlign): Integer;

{
  <Procedure>StopReport
  <What>产生出停止打印的意外（EStopReport），使得打印被停止。
  <Params>
    -
  <Exception>
}
procedure StopReport;

{
  <Procedure>CancelReport
  <What>产生出取消打印的意外（ECancelReport），使得打印被取消。
  <Params>
    -
  <Exception>
}
procedure CancelReport;

var
  ScreenTransform : TTransform; // 全局变量，描述屏幕到物理大小的坐标变换

const
  { Actual paper sizes for all the known paper types }
  RPPaperSizeMetrics : array[Letter..ESheet, 0..1] of TFloat =
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

resourcestring
  SStopReport = '中断报表输出';
  SCancelReport = '取消报表输出';

implementation

function GetTextFlags(HAlign : TRPHAlign; VAlign : TRPVAlign): Integer;
const
  HAligns: array[TRPHAlign] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  VAligns: array[TRPVAlign] of Word = (DT_TOP or DT_SINGLELINE,
    DT_BOTTOM or DT_SINGLELINE,
    DT_VCENTER or DT_SINGLELINE,
    DT_WORDBREAK or DT_EDITCONTROL);
begin
  Result := HAligns[HAlign] or VAligns[VAlign];
end;

{ TTransform }

function TTransform.Device2PhysicsX(DeviceValue: Integer): TFloat;
begin
  Result := DeviceValue / FXPixesPerTenthMM;
end;

function TTransform.Device2PhysicsY(DeviceValue: Integer): TFloat;
begin
  Result := DeviceValue / FYPixesPerTenthMM;
end;

procedure TTransform.InitFromCanvas(Canvas: TCanvas);
begin
  InitFromDC(Canvas.Handle);
end;

procedure TTransform.InitFromDC(DC: THandle; OldMethod : Boolean=False);
begin
  if not OldMethod then
  begin
    // 方法1
    // this only work for printers.
    // when metafile, it's a X Pixes Per "logic" 0.1mm
    // 对显示器，得到的是逻辑比例。该比例和屏幕显示的字体大小匹配，但是屏幕显示的图形尺寸比实际的大
    XPixesPerTenthMM := GetDeviceCaps(DC, LogPixelsX) / TenthMMPerInch;
    YPixesPerTenthMM := GetDeviceCaps(DC, LogPixelsY) / TenthMMPerInch;
  end
  else
  begin
    // 方法2
    // 得到的是物理比例。显示的图形尺寸和实际尺寸相同，但是字体大小不匹配。
    XPixesPerTenthMM := GetDeviceCaps(DC,HORZRES)/GetDeviceCaps(DC,HORZSIZE)/10;
    YPixesPerTenthMM := GetDeviceCaps(DC,VERTRES)/GetDeviceCaps(DC,VERTSIZE)/10;
  end;
end;

procedure TTransform.InitFromScreen(OldMethod : Boolean=False);
var
  Win : THandle;
  DC : THandle;
begin
  //Win := GetDesktopWindow;
  Win := 0;
  DC := GetDC(Win);
  try
    InitFromDC(DC,OldMethod);
  finally
    ReleaseDC(Win, DC);
  end;
end;

function TTransform.Physics2DeviceX(PhysicsValue: TFloat): Integer;
begin
  Result := Round(PhysicsValue * FXPixesPerTenthMM);
end;

function TTransform.Physics2DeviceY(PhysicsValue: TFloat): Integer;
begin
  Result := Round(PhysicsValue * FYPixesPerTenthMM);
end;


{ TLineStyle }

procedure TLineStyle.Assign(Source: TPersistent);
begin
  if Source is TLineStyle then
  begin
    Pen := TLineStyle(Source).Pen;
  end
  else
  inherited;

end;

constructor TLineStyle.Create(Collection: TCollection);
begin
  inherited;
  FPen := TPen.Create;
end;

destructor TLineStyle.Destroy;
begin
  FPen.Free;
  inherited;
end;

procedure TLineStyle.SetPen(const Value: TPen);
begin
  FPen.Assign(Value);
end;

{ TLineStyles }

constructor TLineStyles.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner,TLineStyle);
end;

function TLineStyles.GetLineStyles(Index: Integer): TLineStyle;
begin
  Result := TLineStyle(Items[Index]);
end;

{ TRPFrame }

procedure TRPFrame.Assign(Source: TPersistent);
begin
  if Source is TRPFrame then
    FBorders := TRPFrame(Source).FBorders
  else
    inherited;
end;

procedure TRPFrame.Changed;
begin
  if Assigned(FOnChanged) then
    FOnChanged(self);
end;

constructor TRPFrame.Create;
begin
  FBorders[0]:=-1;
  FBorders[1]:=-1;
  FBorders[2]:=-1;
  FBorders[3]:=-1;
end;

function TRPFrame.GetBorder(Index: Integer): Integer;
begin
  Assert((Index>=0) and (Index<=3));
  Result := FBorders[Index];
end;

procedure TRPFrame.SetBorder(Index, Value: Integer);
begin
  Assert((Index>=0) and (Index<=3));
  if FBorders[Index]<>Value then
  begin
    FBorders[Index]:=Value;
    Changed;
  end;
end;

{ TRPMargin }

procedure TRPMargin.Assign(Source: TPersistent);
begin
  if Source is TRPMargin then
  begin
    FLeft := TRPMargin(Source).Left;
    FRight:= TRPMargin(Source).Right;
    FTop := TRPMargin(Source).Top;
    FBottom:= TRPMargin(Source).Bottom;
    Changed;
  end
  else
    inherited;
end;

procedure TRPMargin.Changed;
begin
  if Assigned(OnChanged) then
    OnChanged(Self);
end;

procedure TRPMargin.SetBottom(const Value: TFloat);
begin
  if FBottom <> Value then
  begin
    FBottom := Value;
    Changed;
  end;
end;

procedure TRPMargin.SetLeft(const Value: TFloat);
begin
  if FLeft <> Value then
  begin
    FLeft := Value;
    Changed;
  end;
end;

procedure TRPMargin.SetRight(const Value: TFloat);
begin
  if FRight <> Value then
  begin
    FRight := Value;
    Changed;
  end;
end;

procedure TRPMargin.SetTop(const Value: TFloat);
begin
  if FTop <> Value then
  begin
    FTop := Value;
    Changed;
  end;
end;

procedure StopReport;
begin
  raise EStopReport.Create(SStopReport);
end;

procedure CancelReport;
begin
  raise ECancelReport.Create(SCancelReport);
end;

initialization
  ScreenTransform := TTransform.Create;
  ScreenTransform.InitFromScreen;
finalization
  ScreenTransform.Free;

end.
