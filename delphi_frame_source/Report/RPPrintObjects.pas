unit RPPrintObjects;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>RPPrintObjects
   <What>包含实际的打印控制
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}


interface

uses SysUtils, Classes, Graphics, Contnrs,
  RPDefines;

type                                    
  {
    <Class>TRPPrintCtrl
    <What>抽象的打印对象
    <Properties>
      -
    <Methods>
      Print - 完成实际的打印
    <Event>
      -
  }
  TRPPrintCtrl = class(TObject)
  private
    FFrame: TRPFrame;
    FBrush: TBrush;
    FFont: TFont;
    FBottomDistance: TFloat;
    FRightDistance: TFloat;
    FAnchors: TRPAnchors;
    FOptions: string;
    FIsPrint: Boolean;
    procedure   SetFrame(const Value: TRPFrame);
    procedure   SetBrush(const Value: TBrush);
    procedure   SetFont(const Value: TFont);
    procedure   PrintFrame(Processor : IReportProcessor; Printer : IBasicPrinter;
      const ARect : TRPRect);
  protected
    property    RightDistance : TFloat read FRightDistance write FRightDistance;
    property    BottomDistance : TFloat read FBottomDistance write FBottomDistance;
    property    Anchors : TRPAnchors read FAnchors write FAnchors;
  public
    PageRect : TRPRect;
    constructor Create; virtual;
    Destructor  Destroy;override;
    procedure   Prepare; virtual;
    procedure   Print(Processor : IReportProcessor; Printer : IBasicPrinter;
      const ARect : TRPRect); virtual;

    property    Brush : TBrush read FBrush write SetBrush;
    property    Font : TFont read FFont write SetFont;
    property    Frame : TRPFrame read FFrame write SetFrame;
    property    Options : string read FOptions write FOptions;
    property    IsPrint : Boolean read FIsPrint write FIsPrint default True;
  end;

  {
    <Class>TRPPrintBand
    <What>可以包含其他的打印对象
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TRPPrintBand = class(TRPPrintCtrl)
  private
    FItems: TObjectList;
    FBandName: string;
    procedure   PrintItems(Processor : IReportProcessor; Printer : IBasicPrinter;
      const ARect : TRPRect);
  protected

  public
    constructor Create; override;
    Destructor  Destroy;override;
    procedure   Print(Processor : IReportProcessor; Printer : IBasicPrinter;
      const ARect : TRPRect); override;
    property    Items : TObjectList read FItems;
    property    BandName : string read FBandName write FBandName;
  end;

  {
    <Class>TRPPrintItemCtrl
    <What>简单的打印对象
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TRPPrintItemCtrl = class(TRPPrintCtrl)
  private
    FID: string;
    FMargin: TRPMargin;
    procedure   SetMargin(const Value: TRPMargin);
  protected

  public
    constructor Create; override;
    property    ID : string read FID write FID;
    property    Margin : TRPMargin read FMargin write SetMargin;
    property    RightDistance;
    property    BottomDistance;
    property    Anchors;
  end;

  {
    <Class>TRPPrintLabel
    <What>打印文字
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TRPPrintLabel = class(TRPPrintItemCtrl)
  private
    FText: string;
    FFieldName: string;
    FHAlign: TRPHAlign;
    FVAlign: TRPVAlign;
    FTextFormat: string;
    FTextFormatType: TRPTextFormatType;
    //FParent: TRPPrintBand;
  protected
    function    GetPrintText(Processor : IReportProcessor): string;
  public
    procedure   Print(Processor : IReportProcessor; Printer : IBasicPrinter;
      const ARect : TRPRect); override;
    property    Text : string read FText write FText;
    property    FieldName : string read FFieldName write FFieldName;
    //property    Parent : TRPPrintBand read FParent write FParent;
    property    HAlign : TRPHAlign read FHAlign write FHAlign;
    property    VAlign : TRPVAlign read FVAlign write FVAlign;
    property    TextFormatType : TRPTextFormatType read FTextFormatType write FTextFormatType default tfNone;
    property    TextFormat : string read FTextFormat write FTextFormat;
  end;

  TRPShapeType = (rpstRectangle, rpstEllipse, rpstHLine, rpstVLine, rpstLine1, rpstLine2);

  {
    <Class>TRPPrintShape
    <What>打印图形
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TRPPrintShape = class(TRPPrintItemCtrl)
  private
    FLineIndex: Integer;
    FShape: TRPShapeType;
    FFillBrush: TBrush;
    procedure   SetFillBrush(const Value: TBrush);
  protected

  public
    constructor Create; override;
    Destructor  Destroy;override;
    procedure   Print(Processor : IReportProcessor; Printer : IBasicPrinter;
      const ARect : TRPRect); override;
    property    Shape : TRPShapeType read FShape write FShape;
    property    LineIndex : Integer read FLineIndex write FLineIndex;
    property    FillBrush : TBrush read FFillBrush write SetFillBrush;
 end;

  TRPPrintPicture = class(TRPPrintItemCtrl)
  private
    FPicture: TPicture;
    FFieldName: string;
    FStretch: boolean;
    procedure   SetPicture(const Value: TPicture);
  protected

  public
    constructor Create; override;
    Destructor  Destroy;override;
    procedure   Print(Processor : IReportProcessor; Printer : IBasicPrinter;
      const ARect : TRPRect); override;
    property    Picture: TPicture read FPicture write SetPicture;
    property    FieldName : string read FFieldName write FFieldName;
    property    Stretch : boolean read FStretch write FStretch;
  published

  end;

implementation

uses LogFile, RPDB;

{ TRPPrintCtrl }

constructor TRPPrintCtrl.Create;
begin
  FFrame := TRPFrame.Create;
  FBrush := TBrush.Create;
  FBrush.Style := bsClear;
  FFont := TFont.Create;
  FOptions := '';
  FIsPrint := True;
end;

destructor TRPPrintCtrl.Destroy;
begin
  FFont.Free;
  FBrush.Free;
  FFrame.Free;
  inherited;
end;

procedure TRPPrintCtrl.SetFrame(const Value: TRPFrame);
begin
  FFrame.Assign(Value);
end;

procedure TRPPrintCtrl.Print(Processor : IReportProcessor; Printer: IBasicPrinter;
  const ARect: TRPRect);
begin
  Assert((Printer<>nil) and (Processor<>nil));
  // fill color
  if Brush.Style<>bsClear then
  begin
    Printer.Brush := Brush;
    Printer.FillRect(ARect.Left,ARect.Top,ARect.Right,ARect.Bottom);
  end;
  // draw frame
  PrintFrame(Processor,Printer,ARect);
end;

procedure TRPPrintCtrl.Prepare;
begin

end;

procedure TRPPrintCtrl.SetBrush(const Value: TBrush);
begin
  FBrush.Assign(Value);
end;

procedure TRPPrintCtrl.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TRPPrintCtrl.PrintFrame(Processor: IReportProcessor;
  Printer: IBasicPrinter; const ARect: TRPRect);

var
  LineWidth : Integer;
  LineStyles : TLineStyles;

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
      Printer.Pen := Pen
    else
      Printer.Pen.Style := psClear;
    if Printer.Pen.Style <> psClear then
      Result := Printer.Pen.Width
    else
      Result := 0;
  end;

begin
  LineStyles := Processor.GetLineStyles;
  if LineStyles<>nil then
  begin
    LineWidth := SetBorderPen(0);
    if LineWidth>0 then
    begin
      Printer.DrawLine(ARect.Left,ARect.Top + LineWidth / 2,
        ARect.Right,ARect.Top + LineWidth / 2);
    end;
    LineWidth := SetBorderPen(1);
    if LineWidth>0 then
    begin
      Printer.DrawLine(ARect.Right - (1 + LineWidth) / 2,ARect.Top,
        ARect.Right - (1 + LineWidth) / 2,ARect.Bottom);
    end;
    LineWidth := SetBorderPen(2);
    if LineWidth>0 then
    begin
      Printer.DrawLine(ARect.Right, ARect.Bottom -(1 + LineWidth) / 2,
        ARect.Left, ARect.Bottom -(1 + LineWidth) / 2);
    end;
    LineWidth := SetBorderPen(3);
    if LineWidth>0 then
    begin
      Printer.DrawLine(ARect.Left + LineWidth / 2, ARect.Bottom,
        ARect.Left + LineWidth / 2, ARect.Top);
    end;
  end;
end;

{ TRPPrintBand }

constructor TRPPrintBand.Create;
begin
  inherited;
  FItems := TObjectList.Create;
end;

destructor TRPPrintBand.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TRPPrintBand.Print(Processor: IReportProcessor;
  Printer: IBasicPrinter; const ARect: TRPRect);
begin
  inherited;
  //WriteLog(Format('Band[%s] (%g,%g)~(%g,%g)',[BandName, ARect.Left,ARect.Top,ARect.Right,ARect.Bottom]),lcReport);
  if FItems.Count>0 then
    PrintItems(Processor,Printer,ARect);
end;

procedure TRPPrintBand.PrintItems(Processor: IReportProcessor;
  Printer: IBasicPrinter; const ARect: TRPRect);
var
  i : integer;
  ItemRect : TRPRect;
  Item : TRPPrintCtrl;
begin
  for i:=0 to FItems.Count-1 do
  begin
    Item := TRPPrintCtrl(FItems[i]);
    {if ([rakLeft,rakRight] <= Item.Anchors) then
    begin
      WriteLog(Format('%s Left=%g, RightDistance=%g',[Item.ClassName,Item.PageRect.Left,Item.RightDistance]),lcReport);
    end;}
    // calculate this rectangle for its items
    if (rakLeft in Item.Anchors) or not (rakRight in Item.Anchors) then
      ItemRect.Left := Item.PageRect.Left + ARect.Left
    else
      // not (rakLeft in Item.Anchors) and (rakRight in Item.Anchors)
      ItemRect.Left := ARect.Right - Item.RightDistance -
        (Item.PageRect.Right - Item.PageRect.Left);
    if rakRight in Item.Anchors then
      ItemRect.Right := ARect.Right - Item.RightDistance
    else
      ItemRect.Right := Item.PageRect.Right+ ARect.Left;
    if (rakTop in Item.Anchors) or not (rakBottom in Item.Anchors) then
      ItemRect.Top := Item.PageRect.Top + ARect.Top
    else
      ItemRect.Top := ARect.Bottom - Item.BottomDistance -
        (Item.PageRect.Bottom - Item.PageRect.Top);
    if rakBottom in Item.Anchors then
      ItemRect.Bottom := ARect.Bottom - Item.BottomDistance
    else
      ItemRect.Bottom := Item.PageRect.Bottom + ARect.Top;
    if Processor.isPrint(nil,Item,ItemRect) then
      Item.Print(Processor,Printer,ItemRect);
  end;
end;

{ TRPPrintLabel }

function TRPPrintLabel.GetPrintText(Processor : IReportProcessor): string;
var
  FieldObj : TObject;
begin
  if FieldName='' then
    Result:=Text
  else
  begin
    FieldObj := Processor.FindField(FieldName);
    if FieldObj is TRPField then
      Result := TRPField(FieldObj).GetPrintableText(TextFormatType, TextFormat)
    else
      Result := Processor.GetVariantText(FieldName, TextFormatType, TextFormat);
  end;
end;

procedure TRPPrintLabel.Print(Processor: IReportProcessor;
  Printer: IBasicPrinter; const ARect: TRPRect);
var
  s : string;
begin
  inherited;
  Printer.Font := Font;
  Printer.Brush.Style := bsClear;
  s := GetPrintText(Processor);
  Printer.DrawTextRect(ARect.Left+Margin.Left,ARect.Top+Margin.Top,ARect.Right-Margin.Right,ARect.Bottom-Margin.Bottom,s,
    GetTextFlags(HAlign,VAlign));
end;

{ TRPPrintShape }

constructor TRPPrintShape.Create;
begin
  inherited;
  FFillBrush := TBrush.Create;
end;

destructor TRPPrintShape.Destroy;
begin
  FFillBrush.Free;
  inherited;
end;

procedure TRPPrintShape.Print(Processor: IReportProcessor;
  Printer: IBasicPrinter; const ARect: TRPRect);
var
  LineStyles : TLineStyles;
  HalfWidth : Integer;
begin
  { TODO : 增加对margin的支持 }
  inherited;
  LineStyles := Processor.GetLineStyles;
  Printer.Brush := Self.FillBrush;
  if (LineStyles<>nil) and (LineIndex>=0) and (LineIndex<LineStyles.Count) then
  begin
    Printer.Pen := LineStyles[LineIndex].Pen;
    HalfWidth := Printer.Pen.Width div 2;
  end
  else
  begin
    Printer.Pen.Style := psClear;
    HalfWidth := 0;
  end;
  case Shape of
    rpstRectangle: Printer.DrawRect(ARect.Left+HalfWidth,ARect.Top+HalfWidth,ARect.Right,ARect.Bottom);
    rpstEllipse: Printer.DrawEllipse(ARect.Left+HalfWidth,ARect.Top+HalfWidth,ARect.Right,ARect.Bottom);
    rpstHLine: Printer.DrawLine(ARect.Left,(ARect.Top+ARect.Bottom)/2,ARect.Right,(ARect.Top+ARect.Bottom)/2);
    rpstVLine: Printer.DrawLine((ARect.Left+ARect.Right)/2,ARect.Top,(ARect.Left+ARect.Right)/2,ARect.Bottom);
    rpstLine1: Printer.DrawLine(ARect.Left,ARect.Top,ARect.Right,ARect.Bottom);
    rpstLine2: Printer.DrawLine(ARect.Left,ARect.Bottom,ARect.Right,ARect.Top);
  end;
  //WriteLog(Format('Shape (%g,%g)~(%g,%g)',[ARect.Left,ARect.Top,ARect.Right,ARect.Bottom]),lcReport);
end;

procedure TRPPrintShape.SetFillBrush(const Value: TBrush);
begin
  FFillBrush.Assign(Value);
end;

{ TRPPrintPicture }

constructor TRPPrintPicture.Create;
begin
  inherited;
  FPicture := TPicture.Create;
end;

destructor TRPPrintPicture.Destroy;
begin
  FPicture.Free;
  inherited;
end;

procedure TRPPrintPicture.Print(Processor: IReportProcessor;
  Printer: IBasicPrinter; const ARect: TRPRect);
var
  Field : TObject;
begin
  try
    Field := Processor.FindField(FieldName);
    if (Field is TRPDataField) and (TRPDataField(Field).FieldType=gfdtBinary) then
      TRPDataField(Field).AssignTo(Picture);
    with ARect do
      if Stretch then
        Printer.DrawGraphic(Left+Margin.Left,Top+Margin.Top,Right-Margin.Right,Bottom-Margin.Bottom,Picture.Graphic) else
        Printer.DrawGraphic2(Left+Margin.Left,Top+Margin.Top,Picture.Graphic);
  except

  end;
end;

procedure TRPPrintPicture.SetPicture(const Value: TPicture);
begin
  FPicture.Assign(Value);
end;

{ TRPPrintItemCtrl }

constructor TRPPrintItemCtrl.Create;
begin
  inherited;
  FMargin := TRPMargin.Create;
end;

procedure TRPPrintItemCtrl.SetMargin(const Value: TRPMargin);
begin
  FMargin.Assign(Value);
end;

end.
