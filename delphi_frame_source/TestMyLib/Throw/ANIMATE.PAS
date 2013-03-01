unit Animate;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls, ExtCtrls;

type
  TAnimated = class(TGraphicControl)
  private
    FBitMap : TBitmap;
    FFrameCount : integer;
    FFrame : Integer;
    Timer : TTimer;
    FInterval : integer;
    FLoop : boolean;
    FReverse : boolean;
    FPlay : boolean;
    FTransparentColor : TColor;
    FOnChangeFrame : TNotifyEvent;
    procedure SetFrame(Value : Integer);
    procedure SetInterval(Value : integer);
    procedure SetBitMap(Value : TBitMap);
    procedure SetPlay(Onn : boolean);
    procedure SetTransparentColor(Value : TColor);
  protected
    procedure Paint; override;
    procedure TimeHit(Sender : TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Interval : integer read FInterval write SetInterval;
    {Note: FrameCount must precede Frame in order for initialization to be correct}
    property FrameCount : integer read FFrameCount write FFrameCount default 1;
    property Frame : Integer read FFrame write SetFrame;
    property BitMap : TBitMap read FBitMap write SetBitMap;
    property Play : boolean read FPlay write SetPlay;
    property Reverse: boolean read FReverse write FReverse;
    property Loop: boolean read FLoop write FLoop default True;
    property TransparentColor : TColor read FTransparentColor
             write SetTransparentColor default -1;
    property Height default 30;
    property Width default 30;
    property OnChangeFrame: TNotifyEvent read FOnChangeFrame
                            write FOnChangeFrame;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property Visible;
  end;

procedure Register;

implementation

constructor TAnimated.Create(AOwner: TComponent);
begin
inherited Create(AOwner);
Width := 30;
Height := 30;
FBitMap := TBitMap.Create;
FrameCount := 1;
ControlStyle := ControlStyle +[csOpaque];
FLoop := True;
FTransparentColor := -1;
end;

destructor TAnimated.Destroy;
begin
Timer.Free;
FBitMap.Free;
inherited Destroy;
end;

procedure TAnimated.SetBitMap(Value : TBitMap);
begin
FBitMap.Assign(Value);
Height := FBitMap.Height;
if Height = 0 then Height := 30;  {so something will display}
end;

procedure TAnimated.SetInterval(Value : Integer);
begin
if Value <> FInterval then
  begin
  Timer.Free;
  Timer := Nil;
  if FPlay and (Value > 0) then
    begin
    Timer := TTimer.Create(Self);
    Timer.Interval := Value;
    Timer.OnTimer := TimeHit;
    end;
  FInterval := Value;
  end;
end;

procedure TAnimated.SetPlay(Onn : boolean);
begin
if Onn <> FPlay then
  begin
  FPlay := Onn;
  if not Onn then
    begin
    Timer.Free;
    Timer := Nil;
    end
  else if FInterval > 0 then
    begin
    Timer := TTimer.Create(Self);
    Timer.Interval := FInterval;
    Timer.OnTimer := TimeHit;
    end;
  end;
end;

procedure TAnimated.SetFrame(Value : Integer);
var
  Temp : Integer;
begin
if Value < 0 then
  Temp := FFrameCount - 1
else
  Temp := Value Mod FFrameCount;
if Temp <> FFrame then
  begin
  FFrame := Temp;
  if Assigned(FOnChangeFrame) then FOnChangeFrame(Self);
  Invalidate;
  end;
end;

procedure TAnimated.SetTransparentColor(Value : TColor);
begin
if Value <> FTransparentColor then
  begin
  FTransparentColor := Value;
  Invalidate;
  end;
end;

procedure TAnimated.TimeHit(Sender : TObject);
  procedure ChkStop;
  begin
  if not FLoop then
    begin
    FPlay := False;
    Timer.Free;
    Timer := Nil;
    end;
  end;

begin
if FReverse then
  begin
  Frame := Frame-1;
  if FFrame = 0 then ChkStop;
  end
else
  begin
  Frame := Frame+1;
  if FFrame = FrameCount-1 then ChkStop;
  end;
end;

procedure TAnimated.Paint;
var
  ARect, BRect : TRect;
  X : Integer;
  Tmp : TBitMap;
begin
ARect := Rect(0,0,Width,Height);
if FBitMap.Height > 0 then
  begin
  X := Width*FFrame;
  BRect := Rect(X,0, X+Width, Height);
  if (FTransparentColor >= 0) and (FTransparentColor <= $7FFFFFFF) then
    begin    {draw on Tmp bitmap to eliminate flicker}
    Tmp := TBitmap.Create;
    Tmp.Height := FBitMap.Height;
    Tmp.Width := FBitMap.Width;
    Tmp.Canvas.Brush.Color := Color;
    Tmp.Canvas.BrushCopy(ARect, FBitmap, BRect, FTransparentColor);
    Canvas.CopyRect(ARect, Tmp.Canvas, ARect);
    Tmp.Free;
    end
  else  {can draw direct}
    Canvas.CopyRect(ARect, FBitmap.Canvas, BRect);
  end
else
  begin   {fill with something}
  Canvas.Brush.Color := clWhite;
  Canvas.FillRect(BoundsRect);
  end;
if csDesigning in ComponentState then
  begin    {to add visibility when designing}
  Canvas.Pen.Style := psDash;
  Canvas.Brush.Style := bsClear;
  Canvas.Rectangle(0, 0, Width, Height);
  end;
end;

procedure Register;
begin
  RegisterComponents('Samples', [TAnimated]);
end;

end.
