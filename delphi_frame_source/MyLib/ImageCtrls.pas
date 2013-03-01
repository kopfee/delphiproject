unit ImageCtrls;

interface

uses Windows, Messages, SysUtils, Classes, Controls, StdCtrls, Buttons,
  Forms, Graphics, ImgList, ActnList, UIStyles, ImagesMan, ExtCtrls;

type
  TCustomBitBtn = class(TButton)
  private
    FCanvas: TCanvas;
    FStyle: TButtonStyle;
    FLayout: TButtonLayout;
    FSpacing: Integer;
    FMargin: Integer;
    IsFocused: Boolean;
    FGoPrevChar: Char;
    procedure   SetStyle(Value: TButtonStyle);
    procedure   SetLayout(Value: TButtonLayout);
    procedure   SetSpacing(Value: Integer);
    procedure   SetMargin(Value: Integer);
    procedure   CNMeasureItem(var Message: TWMMeasureItem); message CN_MEASUREITEM;
    procedure   CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure   CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure   CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure   WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
  protected
    procedure   DrawItem(const DrawItemStruct: TDrawItemStruct); virtual;
    procedure   ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    procedure   CreateParams(var Params: TCreateParams); override;
    procedure   SetButtonStyle(ADefault: Boolean); override;
    procedure   CopyImage(ImageList: TCustomImageList; Index: Integer); virtual;
    { Draw the text and the image and return the text rectangle }
    function    DrawImage(Canvas: TCanvas; const Client: TRect; const Offset: TPoint;
      const Caption: string; Layout: TButtonLayout; Margin, Spacing: Integer;
      State: TButtonState; Transparent: Boolean; BiDiFlags: Longint): TRect;
    function    GetGlyphSize : TPoint; virtual;
    procedure   PaintImage(var ImageRect : TRect); virtual;
    procedure   PaintText(var TextBounds : TRect); virtual;
    function    GetFrameColor : TColor; virtual;
    function    GetBackgroundColor : TColor; virtual;
    function    GetBrightColor : TColor; virtual;
    function    GetShadowColor : TColor; virtual;
    function    GetDisabledColor : TColor; virtual;
    procedure   KeyPress(var Key: Char); override;
    procedure   GoPrev;
    property    GoPrevChar : Char read FGoPrevChar write FGoPrevChar default #0;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   Click; override;
    property    Canvas : TCanvas read FCanvas;
  published
    property    Action;
    property    Anchors;
    property    BiDiMode;
    property    Cancel;
    property    Caption;
    property    Constraints;
    property    Enabled;
    property    Layout: TButtonLayout read FLayout write SetLayout default blGlyphLeft;
    property    Margin: Integer read FMargin write SetMargin default -1;
    property    ModalResult;
    property    ParentShowHint;
    property    ParentBiDiMode;
    property    ShowHint;
    property    Style: TButtonStyle read FStyle write SetStyle default bsAutoDetect;
    property    Spacing: Integer read FSpacing write SetSpacing default 4;
    property    TabOrder;
    property    TabStop;
    property    Visible;
    property    OnEnter;
    property    OnExit;
  end;

  TImageButton = class(TCustomBitBtn)
  private
    FLink : TCommandImageLink;
    procedure   OnStyleChange(Sender : TObject);
    function    GetCommandName: TCommandName;
    procedure   SetCommandName(const Value: TCommandName);
  protected
    function    GetGlyphSize : TPoint; override;
    procedure   PaintImage(var ImageRect : TRect); override;
    function    GetFrameColor : TColor; override;
    function    GetBackgroundColor : TColor; override;
    function    GetShadowColor : TColor; override;
    function    GetDisabledColor : TColor; override;
    function    GetBrightColor : TColor; override;
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
  published
    property    CommandName : TCommandName read GetCommandName write SetCommandName;
    property    GoPrevChar default '*';
  end;

  TUIImage = class(TImage)
  private
    FLink : TUIImageLink;
    function    GetStyleItemName: TUIStyleItemName;
    procedure   SetStyleItemName(const Value: TUIStyleItemName);
    procedure   OnStyleChange(Sender : TObject);
  protected

  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
  published
    property    Picture stored False;
    property    StyleItemName : TUIStyleItemName read GetStyleItemName write SetStyleItemName;
  end;

implementation

uses CompUtils;

type
  TWinControlAccess = class(TWinControl);
  
{ TCustomBitBtn }

constructor TCustomBitBtn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCanvas := TCanvas.Create;
  FStyle := bsAutoDetect;
  FLayout := blGlyphLeft;
  FSpacing := 4;
  FMargin := -1;
  FGoPrevChar := #0;
  ControlStyle := ControlStyle + [csReflector];
end;

destructor TCustomBitBtn.Destroy;
begin
  inherited Destroy;
  FCanvas.Free;
end;

procedure TCustomBitBtn.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do Style := Style or BS_OWNERDRAW;
end;

procedure TCustomBitBtn.SetButtonStyle(ADefault: Boolean);
begin
  if ADefault <> IsFocused then
  begin
    IsFocused := ADefault;
    Refresh;
  end;
end;

procedure TCustomBitBtn.Click;
(*var
  Form: TCustomForm;
  Control: TWinControl;*)
begin
  {
  case FKind of
    bkClose:
      begin
        Form := GetParentForm(Self);
        if Form <> nil then Form.Close
        else inherited Click;
      end;
    bkHelp:
      begin
        Control := Self;
        while (Control <> nil) and (Control.HelpContext = 0) do
          Control := Control.Parent;
        if Control <> nil then Application.HelpContext(Control.HelpContext)
        else inherited Click;
      end;
    else
   }
  inherited Click;
end;

procedure TCustomBitBtn.CNMeasureItem(var Message: TWMMeasureItem);
begin
  with Message.MeasureItemStruct^ do
  begin
    itemWidth := Width;
    itemHeight := Height;
  end;
end;

procedure TCustomBitBtn.CNDrawItem(var Message: TWMDrawItem);
begin
  DrawItem(Message.DrawItemStruct^);
end;

procedure TCustomBitBtn.DrawItem(const DrawItemStruct: TDrawItemStruct);
var
  IsDown, IsDefault: Boolean;
  State: TButtonState;
  R: TRect;
  //Flags: Longint;
begin
  FCanvas.Handle := DrawItemStruct.hDC;
  R := ClientRect;

  with DrawItemStruct do
  begin
    IsDown := itemState and ODS_SELECTED <> 0;
    IsDefault := (itemState and ODS_FOCUS <> 0){ or Default};

    if not Enabled then State := bsDisabled
    else if IsDown then State := bsDown
    else State := bsUp;
  end;
  {
  Flags := DFCS_BUTTONPUSH or DFCS_ADJUSTRECT;
  if IsDown then Flags := Flags or DFCS_PUSHED;
  if DrawItemStruct.itemState and ODS_DISABLED <> 0 then
    Flags := Flags or DFCS_INACTIVE;
  }
  FCanvas.Brush.Color := GetBackgroundColor;
  FCanvas.FillRect(R);

  { DrawFrameControl doesn't allow for drawing a button as the
      default button, so it must be done here. }
  if IsFocused or IsDefault then
  begin
    FCanvas.Pen.Color := GetFrameColor;
    FCanvas.Pen.Width := 1;
    FCanvas.Brush.Style := bsClear;
    FCanvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);

    { DrawFrameControl must draw within this border }
    InflateRect(R, -1, -1);
  end;

  { DrawFrameControl does not draw a pressed button correctly }
  if IsDown then
  begin
    FCanvas.Pen.Color := GetShadowColor;
    FCanvas.Pen.Width := 1;
    FCanvas.Brush.Color := GetBackgroundColor;
    FCanvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
    InflateRect(R, -1, -1);
  end
  else
  begin
    //DrawFrameControl(DrawItemStruct.hDC, R, DFC_BUTTON, Flags);
    Frame3D(Canvas,R,clWhite,GetShadowColor,1);
  end;

  if IsFocused then
  begin
    R := ClientRect;
    InflateRect(R, -1, -1);
  end;

  FCanvas.Font := Self.Font;
  if IsDown then
    OffsetRect(R, 1, 1);

  DrawImage(FCanvas, R, Point(0,0), Caption, FLayout, FMargin,
    FSpacing, State, False, DrawTextBiDiModeFlags(0));

  if IsFocused and IsDefault then
  begin
    R := ClientRect;
    InflateRect(R, -4, -4);
    FCanvas.Pen.Color := GetFrameColor;
    FCanvas.Brush.Color := GetBackgroundColor;
    DrawFocusRect(FCanvas.Handle, R);
  end;

  FCanvas.Handle := 0;
end;

procedure TCustomBitBtn.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TCustomBitBtn.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TCustomBitBtn.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  Perform(WM_LBUTTONDOWN, Message.Keys, Longint(Message.Pos));
end;

procedure TCustomBitBtn.SetStyle(Value: TButtonStyle);
begin
  if Value <> FStyle then
  begin
    FStyle := Value;
    Invalidate;
  end;
end;

procedure TCustomBitBtn.SetLayout(Value: TButtonLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    Invalidate;
  end;
end;

procedure TCustomBitBtn.SetSpacing(Value: Integer);
begin
  if FSpacing <> Value then
  begin
    FSpacing := Value;
    Invalidate;
  end;
end;

procedure TCustomBitBtn.SetMargin(Value: Integer);
begin
  if (Value <> FMargin) and (Value >= - 1) then
  begin
    FMargin := Value;
    Invalidate;
  end;
end;

procedure TCustomBitBtn.ActionChange(Sender: TObject; CheckDefaults: Boolean);
begin
  inherited ActionChange(Sender, CheckDefaults);
  if Sender is TCustomAction then
    with TCustomAction(Sender) do
    begin
      { Copy image from action's imagelist }
      if (ActionList <> nil) and (ActionList.Images <> nil) and
        (ImageIndex >= 0) and (ImageIndex < ActionList.Images.Count) then
        CopyImage(ActionList.Images, ImageIndex);
    end;
end;

procedure TCustomBitBtn.CopyImage(ImageList: TCustomImageList;
  Index: Integer);
begin

end;

function TCustomBitBtn.DrawImage(Canvas: TCanvas; const Client: TRect;
  const Offset: TPoint; const Caption: string; Layout: TButtonLayout;
  Margin, Spacing: Integer; State: TButtonState; Transparent: Boolean;
  BiDiFlags: Integer): TRect;
var
  ImageRect, TextBounds: TRect;
  GlyphSize : TPoint;
  OriDC : integer;
begin
  GlyphSize := GetGlyphSize;
  // Calculate
  CalcLayout(Canvas, ClientRect,
    Offset, Text, GlyphSize,Layout,
    Margin, Spacing,
    ImageRect.topLeft, TextBounds,BiDiFlags);
  with ImageRect do
  begin
    right := left + GlyphSize.x;
    Bottom :=Top  + GlyphSize.y;
  end;
  //
  if (GlyphSize.x>0) and ((GlyphSize.y>0)) then
  begin
    // avoid PaintImage change text font
    OriDC := SaveDC(Canvas.handle);
    PaintImage(ImageRect);
    RestoreDC(Canvas.handle,OriDC);
  end;
  PaintText(TextBounds);
end;

function TCustomBitBtn.GetGlyphSize: TPoint;
begin
  Result := Point(0,0);
end;

procedure TCustomBitBtn.PaintImage(var ImageRect: TRect);
begin

end;

procedure TCustomBitBtn.PaintText(var TextBounds: TRect);
var
  BiDiFlags : integer;
  OldBackMode : Integer;
begin
  BiDiFlags := DrawTextBiDiModeFlags(0);
  OldBackMode := GetBkMode(Canvas.Handle);
  if OldBackMode<>TRANSPARENT	then
    SetBkMode(Canvas.Handle, TRANSPARENT);
  if Enabled then
    windows.DrawText(Canvas.Handle, PChar(Caption), Length(Caption), TextBounds,
      DT_CENTER or DT_VCENTER or BiDiFlags) else
    with Canvas do
    begin
      OffsetRect(TextBounds, 1, 1);
      Font.Color := GetDisabledColor;
      DrawText(Handle, PChar(Caption), Length(Caption), TextBounds,
        DT_CENTER or DT_VCENTER or BiDiFlags);
      OffsetRect(TextBounds, -1, -1);
      Font.Color := GetShadowColor;
      DrawText(Handle, PChar(Caption), Length(Caption), TextBounds,
        DT_CENTER or DT_VCENTER or BiDiFlags);
    end;

  if OldBackMode<>TRANSPARENT	then
    SetBkMode(Canvas.Handle, OldBackMode);
end;

function TCustomBitBtn.GetBackgroundColor: TColor;
begin
  Result := clBtnFace;
end;

function TCustomBitBtn.GetFrameColor: TColor;
begin
  Result :=  clWindowFrame;
end;

function TCustomBitBtn.GetShadowColor: TColor;
begin
  Result := clBtnShadow;
end;

function TCustomBitBtn.GetDisabledColor: TColor;
begin
  Result := clBtnHighlight;
end;

function TCustomBitBtn.GetBrightColor: TColor;
begin
  Result := clBtnHighlight;
end;

procedure TCustomBitBtn.KeyPress(var Key: Char);
begin
  if (GoPrevChar<>#0) and (Key=GoPrevChar) then
  begin
    Key := #0;
    GoPrev;
  end;
  inherited;
end;

procedure TCustomBitBtn.GoPrev;
var
  Ctrl : TWinControl;
begin
  Ctrl := GetParentForm(Self);
  if Ctrl=nil then
    Ctrl:=Parent;
  if Ctrl<>nil then
    TWinControlAccess(Ctrl).SelectNext(Self,False,True);
end;

{ TImageButton }

constructor TImageButton.Create(AOwner: TComponent);
begin
  inherited;
  FLink := TCommandImageLink.Create;
  FLink.OnChange := OnStyleChange;
  FGoPrevChar := '*';
end;

function TImageButton.GetCommandName: TCommandName;
begin
  assert(FLink<>nil);
  Result := FLink.StyleItemName;
end;

procedure TImageButton.SetCommandName(const Value: TCommandName);
begin
  assert(FLink<>nil);
  FLink.StyleItemName := value;
end;

procedure TImageButton.OnStyleChange(Sender: TObject);
begin
  assert(FLink<>nil);
  if FLink.IsAvailable then
  begin
    Caption := FLink.CommandImage.Caption;
    SetBounds(Left,Top,FLink.CommandImage.Width,FLink.CommandImage.Height);
    Font := FLink.CommandImage.CommandImages.Font;
    Hint := FLink.CommandImage.Hint;
  end;
  Invalidate;
end;

function TImageButton.GetGlyphSize: TPoint;
begin
  assert(FLink<>nil);
  if FLink.ImageAvailable then
  with FLink.CommandImage.CommandImages.Images do
    Result := Point(Width,Height)
  else
    Result := Point(0,0);
end;

procedure TImageButton.PaintImage(var ImageRect: TRect);
begin
  assert(FLink<>nil);
  if FLink.ImageAvailable then
    FLink.CommandImage.CommandImages.Images.Draw(
      Canvas,
      ImageRect.Left,ImageRect.Top,
      FLink.CommandImage.ImageIndex,
      Enabled);
end;

destructor TImageButton.Destroy;
begin
  FLink.OnChange := nil;
  FLink.Free;
  inherited;
end;

function TImageButton.GetBackgroundColor: TColor;
begin
  if FLink.IsAvailable then
    Result := FLink.CommandImage.CommandImages.BackgroundColor else
    Result := inherited GetBackgroundColor;
end;

function TImageButton.GetFrameColor: TColor;
begin
  if FLink.IsAvailable then
    Result := FLink.CommandImage.CommandImages.FrameColor else
    Result := inherited GetFrameColor;
end;

function TImageButton.GetShadowColor: TColor;
begin
  if FLink.IsAvailable then
    Result := FLink.CommandImage.CommandImages.ShadowColor else
    Result := inherited GetShadowColor;
end;

function TImageButton.GetDisabledColor: TColor;
begin
  if FLink.IsAvailable then
    Result := FLink.CommandImage.CommandImages.DisabledColor else
    Result := inherited GetDisabledColor;
end;

function TImageButton.GetBrightColor: TColor;
begin
  if FLink.IsAvailable then
    Result := FLink.CommandImage.CommandImages.DisabledColor else
    Result := inherited GetBrightColor;
end;

{ TUIImage }

constructor TUIImage.Create(AOwner: TComponent);
begin
  inherited;
  FLink := TUIImageLink.Create;
  FLink.OnChange := OnStyleChange;
end;

destructor TUIImage.Destroy;
begin
  FreeAndNil(FLink);
  inherited;
end;

function TUIImage.GetStyleItemName: TUIStyleItemName;
begin
  Result := FLink.StyleItemName;
end;

procedure TUIImage.OnStyleChange(Sender: TObject);
begin
  if FLink.IsAvailable then
    Picture.Assign(FLink.Image.Picture) else
    Picture.Graphic := nil;
end;

procedure TUIImage.SetStyleItemName(const Value: TUIStyleItemName);
begin
  FLink.StyleItemName := Value;
end;

end.
