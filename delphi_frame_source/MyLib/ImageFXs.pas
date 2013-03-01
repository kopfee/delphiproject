unit ImageFXs;

// %ImageFXs : 特殊效果图像
(*****   Code Written By Huang YanLai   *****)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TCustomFXPainter = class;

  // %TImageFX : 特殊效果图像，特殊效果来自TCustomFXPainter
  TImageFX = class(TImage)
  private
    { Private declarations }
    FTimer: TTimer;
    FirstShow : boolean;
    FAutoRunning: boolean;
    FOnPaintFX: TNotifyEvent;
    FPainter: TCustomFXPainter;
    FClearBeforeFX: boolean;
    FOnStartFX: TNotifyEvent;
    FOnEndFX: TNotifyEvent;
    FTempBitmap: TBitmap;
    FNeedTempBitmap: boolean;
    procedure SetRuning(const Value: boolean);
    function  GetRuning: boolean;
    function  getDestCanvas: TCanvas;
    function  GetInterval: integer;
    procedure SetInterval(const Value: integer);
    procedure SetPainter(const Value: TCustomFXPainter);
    function  GetGraphicHeight: integer;
    function  GetGraphicWidth: integer;
    procedure SetGraphicHeight(const Value: integer);
    procedure SetGraphicWidth(const Value: integer);
  protected
    { Protected declarations }
    procedure   OnTimer(sender : TObject); virtual;
    procedure   Paint; override;
    procedure   PaintFX; virtual;
    property    DestCanvas : TCanvas read getDestCanvas;
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure   ReleaseTempBitmap;
    procedure   CreateTempBitmap;
    property    TempBitmap : TBitmap read FTempBitmap;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    property    Timer : TTimer read FTimer;
    procedure   StartFX; virtual;
    procedure   EndFX;   virtual;
    property    Runing : boolean read GetRuning write SetRuning;

    property    NeedTempBitmap : boolean read FNeedTempBitmap write FNeedTempBitmap;
    function    SourceBitmap: TBitmap;
    function    FXValid: boolean;
  published
    { Published declarations }
    property    AutoRunning : boolean read FAutoRunning write FAutoRunning;
    property    Interval : integer read GetInterval Write SetInterval;
    property    Painter : TCustomFXPainter read FPainter write SetPainter;
    property    Color;
    property    Stretch default true;
    property    OnPaintFX : TNotifyEvent read FOnPaintFX write FOnPaintFX;
    // %GraphicWidth,%GraphicHeight : readonly properties, the set Methods are used to make delphi show them in Inspector
    property    GraphicWidth : integer read GetGraphicWidth Write SetGraphicWidth stored false;
    property    GraphicHeight : integer read GetGraphicHeight write SetGraphicHeight stored false;
    property    ClearBeforeFX : boolean read FClearBeforeFX write FClearBeforeFX default false;
    property    OnStartFX : TNotifyEvent read FOnStartFX write FOnStartFX;
    property    OnEndFX : TNotifyEvent read FOnEndFX write FOnEndFX;
  end;

  TCustomFXPainter = class(TComponent)
  private
    FEndIndex: integer;
    FStartIndex: integer;
    FIndex : integer;
    FOnStartFX: TNotifyEvent;
    FOnEndFX: TNotifyEvent;
    function    GetCount: integer;
    procedure   SetCount(const Value: integer);
  protected

    function    GetNeedTempBitmap(ImageFX : TImageFX): boolean; dynamic;

    procedure   Paint(ImageFX : TImageFX); virtual;
    procedure   InternalPaint(ImageFX : TImageFX); virtual; abstract;
    property    StartIndex : integer read FStartIndex write FStartIndex;
    property    EndIndex : integer read FEndIndex write FEndIndex;
    property    Index : integer read FIndex write FIndex;
    procedure   StartFX(Sender : TImageFX); virtual;
    procedure   EndFX(Sender : TImageFX); virtual;
    // Draw utils
    // %DrawRect : Draw the whole Grphic to ARect of ImageFX
    procedure   DrawRect(ImageFX : TImageFX;const ARect:TRect);
    // %DrawRect : Draw the SourceRect of  Grphic to DestRect of ImageFX
    procedure   DrawRectEx(ImageFX : TImageFX;const SourceRect,DestRect:TRect);

    function    GraphicRect(ImageFX : TImageFX;const ImageRect:TRect):TRect;
    function    GraphicBounds(ImageFX : TImageFX;x,y,w,h:Single):TRect;
    property    OnStartFX : TNotifyEvent read FOnStartFX write FOnStartFX;
    property    OnEndFX : TNotifyEvent read FOnEndFX write FOnEndFX;
  public
    //function    SourceBitmap(ImageFX : TImageFX): TBitmap;
    constructor Create(AOwner : TComponent); override;
    property    Count : integer read GetCount  write SetCount;
  end;

  { W = ImageWidth
    H = ImageHeight
    w = paintWidth  = index * W / count
    h = paintHeight = index * H / Count
    x = left = P0 * W + P1 * w
    y = Top  = p2 * H + P3 * h    }
  TFXScaleStyle = (ssLeftTop,ssRightTop,ssLeftBottom,ssRightBottom,ssCenter,ssCustom);
  // %TFXScalePainter : 放缩的特殊效果
  TFXScalePainter = class(TCustomFXPainter)
  private
    FParams :   array[0..3] of Single;
    //FSetting : boolean;
    FStyle: TFXScaleStyle;
    FStretch: boolean;
    function    GetParam(Index: Integer): Single;
    procedure   SetParam(Index: Integer; const Value: Single);
    procedure   SetStyle(const Value: TFXScaleStyle);
  protected
    procedure   InternalPaint(ImageFX : TImageFX); override;
  public
    constructor Create(AOwner : TComponent); override;
    property    Params[index:integer] : single read GetParam Write SetParam;
  published
    property    Count;
    property    P0 : Single index 0 read GetParam Write SetParam;
    property    P1 : Single index 1 read GetParam Write SetParam;
    property    P2 : Single index 2 read GetParam Write SetParam;
    property    P3 : Single index 3 read GetParam Write SetParam;
    property    Style : TFXScaleStyle read FStyle write SetStyle;
    property    Stretch : boolean read FStretch write FStretch default true;
    property    OnStartFX;
    property    OnEndFX;
  end;

  TFXStyle = (fxssVertical,fxssHorizontal);

  // %TFXStripPainter : 条带的特殊效果
  TFXStripPainter = class(TCustomFXPainter)
  private
    FStripCount: integer;
    FStyle:     TFXStyle;
    FReverse:   boolean;
    sw,sh,stripw,striph : Single;
    FStretch: boolean;
    procedure   SetStripCount(const Value: integer);
  protected
    procedure   InternalPaint(ImageFX : TImageFX); override;
    procedure   StartFX(Sender : TImageFX); override;
  public
    constructor Create(AOwner : TComponent); override;
  published
    property    StripCount : integer read FStripCount write SetStripCount;
    property    Count;
    property    Style : TFXStyle read FStyle write FStyle;
    property    Reverse : boolean read FReverse write FReverse;
    property    Stretch : boolean read FStretch write FStretch;
    property    OnStartFX;
    property    OnEndFX;
  end;

  // %TFXDualPainter  : 双边的特殊效果
  TFXDualPainter = class(TCustomFXPainter)
  private
    FStyle:     TFXStyle;
    FStretch:   boolean;
    FReverse:   boolean;
  protected
    procedure   InternalPaint(ImageFX : TImageFX); override;
  public
    constructor Create(AOwner : TComponent); override;
  published
    property    Count;
    property    OnStartFX;
    property    OnEndFX;
    property    Style : TFXStyle read FStyle write FStyle;
    property    Stretch : boolean read FStretch write FStretch;
    property    Reverse : boolean read FReverse write FReverse;
  end;

implementation

uses JPEG;

type
  TJpegImageAccess = class(TJpegImage);

{ TImageFX }

constructor TImageFX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTimer := TTimer.Create(self);
  FTimer.Enabled := false;
  FTimer.OnTimer := OnTimer;
  FClearBeforeFX := false;
  FirstShow := true;
  Stretch := true;
end;

procedure TImageFX.OnTimer(sender: TObject);
begin
  PaintFX;
end;

procedure TImageFX.Paint;
begin
  if FirstShow then
  begin
    FirstShow:=false;
    if AutoRunning and not (csDesigning in ComponentState) then
    begin
      StartFX;
      //exit;
    end;
  end;
  if not Runing then inherited Paint
  else PaintFX;
end;

procedure TImageFX.SetRuning(const Value: boolean);
begin
  //FRuning := Value;
  if value<>Runing then
    StartFX
  else
    EndFX;
end;

procedure TImageFX.StartFX;
begin
  if (Picture.Graphic=nil) or not FXValid then  exit;
  //start timer
  Timer.enabled:=true;
  //clear BK
  if ClearBeforeFX then
  begin
    DestCanvas.Brush.Style := bsSolid;
    DestCanvas.Brush.Color := Color;
    DestCanvas.FillRect(Rect(0,0,width,height));
  end;
  //call start event handler
  if FPainter<>nil then
    begin
      FPainter.StartFX(self);
      NeedTempBitmap := FPainter.GetNeedTempBitmap(self);
    end;
  if Assigned(FOnStartFX) then
    FOnStartFX(self);
  //create TempBitmap when need
  if NeedTempBitmap then CreateTempBitmap;
end;

procedure TImageFX.EndFX;
begin
  Timer.enabled:=false;
  if FPainter<>nil then FPainter.EndFX(self);
  if Assigned(FOnEndFX) then
    FOnEndFX(self);
  if NeedTempBitmap then ReleaseTempBitmap;
  // 将Invalidate=>inherited Paint,避免透明状态时完成以后的闪烁(因为Parent要画背景)
  //Invalidate;
  inherited Paint;
end;


function TImageFX.GetRuning: boolean;
begin
  result := Timer.enabled;
end;

type
  TGraphicControlAccess = class(TGraphicControl);

procedure TImageFX.PaintFX;
{ // this is a test
var
  ARect : TRect;
begin
  case FIndex of
    1 : ARect:=Rect(0,0,width div 8,height div 8);
    2 : ARect:=Rect(0,0,width div 4,height div 4);
    3 : ARect:=Rect(0,0,width div 2,height div 2);
  end;
  DestCanvas.StretchDraw(ARect,Picture.Graphic);
  if FIndex=3 then EndFX;
end; }
begin
  if FPainter<>nil then FPainter.Paint(self)
  else if Assigned(FOnPaintFX) then
    FOnPaintFX(self);
  {Inc(FIndex);
  if (FIndex>EndIndex) then EndFX;}
end;

function TImageFX.getDestCanvas: TCanvas;
begin
  result := TGraphicControlAccess(self).Canvas;
end;

function TImageFX.GetInterval: integer;
begin
  result := FTimer.Interval;
end;

procedure TImageFX.SetInterval(const Value: integer);
begin
  FTimer.Interval:=value;
end;

procedure TImageFX.SetPainter(const Value: TCustomFXPainter);
begin
  if FPainter <> Value then
  begin
    FPainter := Value;
    if FPainter<>nil then FPainter.FreeNotification(self);
  end;
end;

procedure TImageFX.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (AComponent=FPainter) and (Operation=opRemove) then
    FPainter:=nil;
end;

function TImageFX.GetGraphicHeight: integer;
begin
  result := Picture.Graphic.Height;
end;

function TImageFX.GetGraphicWidth: integer;
begin
  result := Picture.Graphic.Width;
end;

procedure TImageFX.SetGraphicHeight(const Value: integer);
begin

end;

procedure TImageFX.SetGraphicWidth(const Value: integer);
begin

end;

procedure TImageFX.CreateTempBitmap;
begin
  ReleaseTempBitmap;
  if Picture.Graphic<>nil then
  begin
    FTempBitmap := TBitmap.Create;
    FTempBitmap.width := GraphicWidth;
    FTempBitmap.Height := GraphicHeight;
    FTempBitmap.HandleType := bmDDB;
    //FTempBitmap.PixelFormat := pfDevice;
    //FTempBitmap.PixelFormat := pf16bit;
    OutputDebugString(pchar('Colors:'+IntToStr(integer(FTempBitmap.PixelFormat))));
    FTempBitmap.Canvas.Draw(0,0,Picture.Graphic);
  end;
end;

procedure TImageFX.ReleaseTempBitmap;
begin
  if TempBitmap<>nil then
  begin
    TempBitmap.free;
    FTempBitmap:=nil;
  end;
end;

function TImageFX.FXValid: boolean;
begin
  result := (Painter<>nil) or  Assigned(FOnPaintFX);
end;

function TImageFX.SourceBitmap: TBitmap;
begin
  if NeedTempBitmap and (TempBitmap<>nil) then
    result:=TempBitmap
  else
    if Picture.Graphic is TBitmap then
      result:=Picture.Bitmap
    else if Picture.Graphic is TJpegImage then
      result:= TJpegImageAccess(Picture.Graphic).bitmap
    else
      result:=nil;
end;

{ TCustomFXPainter }

constructor TCustomFXPainter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStartIndex := 1;
  FEndIndex := 1;
end;

function TCustomFXPainter.GetCount: integer;
begin
  result := FEndIndex;
end;

procedure TCustomFXPainter.SetCount(const Value: integer);
begin
  if value>0 then EndIndex:=value;
end;

procedure TCustomFXPainter.Paint(ImageFX: TImageFX);
begin
  InternalPaint(ImageFX);
  Inc(FIndex);
  if (FIndex>EndIndex) then ImageFX.EndFX;
end;

procedure TCustomFXPainter.StartFX(Sender: TImageFX);
begin
  FIndex:=FStartIndex;
  if Assigned(FOnStartFX) then
    FOnStartFX(Sender);
end;

procedure TCustomFXPainter.EndFX(Sender: TImageFX);
begin
  if Assigned(FOnEndFX) then
    FOnEndFX(Sender);
end;

procedure TCustomFXPainter.DrawRect(ImageFX: TImageFX; const ARect: TRect);
begin
  with ImageFX do
    DestCanvas.StretchDraw(ARect,Picture.Graphic);
end;

procedure TCustomFXPainter.DrawRectEx(ImageFX: TImageFX; const SourceRect,
  DestRect: TRect);
var
  ABitmap : TBitmap;
begin
// Notes : ImageFX has property "DestRect" !!!!
  abitmap := ImageFX.SourceBitmap;
  if abitmap<>nil then
  begin
    SetStretchBltMode(ImageFX.DestCanvas.Handle, STRETCH_DELETESCANS);
    ImageFX.DestCanvas.CopyRect(DestRect,abitmap.Canvas,SourceRect)
  end
  else
    assert(false);  
  {if ImageFX.Picture.Graphic is TBitmap then
    ImageFX.DestCanvas.CopyRect(DestRect,ImageFX.Canvas,SourceRect);}
end;

function TCustomFXPainter.GraphicRect(ImageFX: TImageFX;
  const ImageRect: TRect): TRect;
var
  xs,ys : Single;
begin
  with ImageFX do
  begin
    if (width=0) or (height=0) then
      result:=rect(0,0,0,0)
    else
    begin
      xs:=GraphicWidth/width;
      ys:=GraphicHeight/Height;
      result := Rect(Round(ImageRect.left*xs),Round(ImageRect.Top*ys),
        Round(ImageRect.Right*xs),Round(ImageRect.Bottom*ys));
    end;
  end;
end;

function TCustomFXPainter.GraphicBounds(ImageFX: TImageFX; x, y, w,
  h: Single): TRect;
var
  xs,ys : Single;
begin
  with ImageFX do
  begin
    if (width=0) or (height=0) then
      result:=rect(0,0,0,0)
    else
    begin
      xs:=GraphicWidth/width;
      ys:=GraphicHeight/Height;
      result := Bounds(Round(x*xs),Round(y*ys),Round(w*xs),Round(h*ys));
    end;
  end;
end;


function TCustomFXPainter.GetNeedTempBitmap(ImageFX: TImageFX): boolean;
begin
  result := not (ImageFX.Picture.Graphic is TBitmap)
      and (ImageFX.Picture.Graphic is TJPEGImage);
end;

{ TFXScalePainter }

constructor TFXScalePainter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStartIndex := 1;
  FEndIndex := 1;
  FStretch := true;
end;

procedure TFXScalePainter.InternalPaint(ImageFX: TImageFX);
var
  ARect : TRect;
  x,y,w,h : Single;
begin
  with ImageFX do
  begin
    w:=FIndex * Width / Count;
    h:=FIndex * Height / Count;
    x:=FParams[0]*Width + FParams[1]*W;
    y:=FParams[2]*Height + FParams[3]*H;
    ARect:=Bounds(Round(x),Round(y),Round(w),Round(h));
    if self.Stretch then
      DestCanvas.StretchDraw(ARect,Picture.Graphic)
    else
    begin
      DrawRectEx(ImageFX,GraphicBounds(ImageFX,x,y,w,h),ARect);
    end;
    //if Index=3 then EndFX;
  end;
end;


function TFXScalePainter.GetParam(Index: Integer): Single;
begin
  result := FParams[index];
end;

procedure TFXScalePainter.SetParam(Index: Integer;
  const Value: Single);
begin
  if (FStyle=ssCustom) {or FSetting} then
    FParams[index]:=value;
end;

procedure TFXScalePainter.SetStyle(const Value: TFXScaleStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    case FStyle of
      ssLeftTop:    begin
                      FParams[0]:=0;
                      FParams[1]:=0;
                      FParams[2]:=0;
                      FParams[3]:=0;
                    end;
      ssRightTop:   begin
                      FParams[0]:=1;
                      FParams[1]:=-1;
                      FParams[2]:=0;
                      FParams[3]:=0;
                    end;
      ssLeftBottom: begin
                      FParams[0]:=0;
                      FParams[1]:=0;
                      FParams[2]:=1;
                      FParams[3]:=-1;
                    end;
      ssRightBottom:begin
                      FParams[0]:=1;
                      FParams[1]:=-1;
                      FParams[2]:=1;
                      FParams[3]:=-1;
                    end;
      ssCenter:     begin
                      FParams[0]:=0.5;
                      FParams[1]:=-0.5;
                      FParams[2]:=0.5;
                      FParams[3]:=-0.5;
                    end;
    end;
  end;
end;

{ TFXStripPainter }

constructor TFXStripPainter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStripCount := 4;
end;

procedure TFXStripPainter.SetStripCount(const Value: integer);
begin
  if value>0 then
    FStripCount := Value;
end;

procedure TFXStripPainter.InternalPaint(ImageFX: TImageFX);
var
  i : integer;
  x,y,w,h : Single;
  Src,Dest : TRect;
begin
  with ImageFX do
  begin
    for i:=0 to StripCount-1 do
    begin
      if Style=fxssVertical then
      begin
        y:=0;
        h:=Height;
        w:=FIndex*sw;
        if not Reverse then
          // left to right
          x:=i*stripw
        else
          x:=(i+1)*stripw-w;
      end
      else
      begin
        x:=0;
        w:=width;
        h:=FIndex*sh;
        if not Reverse then
          // top to bottom
          y:=i*striph
        else
          y:=(i+1)*striph-h;
      end;
      Dest := Bounds(Round(x),Round(y),Round(w),Round(h));
      //Src := GraphicRect(ImageFX,Dest);
      if self.Stretch then
        if Style=fxssVertical then
          Src := GraphicBounds(ImageFX,i*stripw,y,stripw,h)
        else
          Src := GraphicBounds(ImageFX,x,i*striph,w,striph)
      else
        Src := GraphicBounds(ImageFX,x,y,w,h);
      if i=StripCount-1 then
      begin
      OutputDebugString(pchar(format('SRCLeft[%d]:%d',[i,Src.Left])));
      OutputDebugString(pchar(format('SRCRight[%d]:%d',[i,Src.Right])));
      OutputDebugString(pchar(format('DestLeft[%d]:%d',[i,Dest.Left])));
      OutputDebugString(pchar(format('DestRight[%d]:%d',[i,Dest.Right])));
      end;
      DrawRectEx(ImageFX,Src,Dest);
    end;
  end;
end;

procedure TFXStripPainter.StartFX(Sender: TImageFX);
begin
  with Sender do
  begin
    stripw:=Width/StripCount;
    striph:=Height/StripCount;
    sw:=stripw/count;
    sh:=striph/count;
    {NeedTempBitmap:= not (Sender.Picture.Graphic is TBitmap)
      and (Sender.Picture.Graphic is TJPEGImage) ;}
    {OutputDebugString(pchar('stripw:'+FloatToStr(stripw)));
    OutputDebugString(pchar('striph:'+FloatToStr(striph)));
    OutputDebugString(pchar('sw:'+FloatToStr(sw)));
    OutputDebugString(pchar('sh:'+FloatToStr(sh)));}
  end;
  inherited StartFX(Sender);
end;

{ TFXDualPainter }

constructor TFXDualPainter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStretch := false;
end;

procedure TFXDualPainter.InternalPaint(ImageFX: TImageFX);
var
  x1,y1,x2,y2,w,h : single;
  src,dest : TRect;
begin
  if style=fxssVertical then
  begin
    w := index * ImageFX.width / count / 2;
    h := ImageFX.Height;
    y1 := 0;
    y2 := 0;
    if Reverse then
    begin
      x1 := ImageFX.width/2 - w;
      x2 := ImageFX.width/2 ;
    end
    else
    begin
      x1 := 0;
      x2 := ImageFX.width - w;
    end;
  end
  else
  begin
    w := ImageFX.width;
    h := index * ImageFX.height / count / 2;
    x1 := 0;
    x2 := 0;
    if Reverse then
    begin
      y1 := ImageFX.Height/2 - h;
      y2 := ImageFX.Height/2 ;
    end
    else
    begin
      y1 := 0;
      y2 := ImageFX.Height - h;
    end;
  end;

  Dest := Bounds(Round(x1),Round(y1),Round(w),Round(h));
  if not Stretch then
    SRC := GraphicBounds(ImageFX,x1,y1,w,h)
  else if style=fxssVertical then
    SRC := Rect(0,0,ImageFX.GraphicWidth div 2,ImageFX.GraphicHeight)
  else SRC := Rect(0,0,ImageFX.GraphicWidth,ImageFX.GraphicHeight div 2);
  DrawRectEx(ImageFX,SRC,Dest);

  Dest := Bounds(Round(x2),Round(y2),Round(w),Round(h));
  if not Stretch then
    SRC := GraphicBounds(ImageFX,x2,y2,w,h)
  else if style=fxssVertical then
    SRC := Rect(ImageFX.GraphicWidth div 2,0,ImageFX.GraphicWidth,ImageFX.GraphicHeight)
  else SRC := Rect(0,ImageFX.GraphicHeight div 2,ImageFX.GraphicWidth,ImageFX.GraphicHeight);
  DrawRectEx(ImageFX,SRC,Dest);
end;

end.
