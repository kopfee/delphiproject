unit KSHints;

interface

uses Windows, SysUtils, Classes, Controls, Graphics;

const
  TenSeconds = 10 * 1000;

type
  {
    <Class>TKSHintWindow
    <What>保证字体和背景颜色正确
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TKSHintWindow = class(THintWindow)
  private

  protected
    procedure   Paint; override;
  public

  end;

  THintPosition = (hpAbove, hpBellow, hpAuto);
  {
    <Class>THintMan
    <What>为控件显示hint，机制和Application的不相同。
    <Properties>
      -
    <Methods>
      ShowHintFor-在控件的上方显示hint
    <Event>
      -
  }
  THintMan = class(TComponent)
  private
    FHintWindow : TKSHintWindow;
    FShowHintTime : LongWord;
    FHintActive : Boolean;
    FDisplayTime: LongWord;
    function    GetColor: TColor;
    function    GetFont: TFont;
    procedure   SetColor(const Value: TColor);
    procedure   SetFont(const Value: TFont);
  protected

  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
    procedure   DoApplicationMessage(var Msg: TMsg; var Handled: Boolean);
    procedure   ShowHintFor(Control : TControl; const AHint : string=''; Position : THintPosition=hpAuto);
    procedure   CloseHint;
  published
    property    DisplayTime : LongWord read FDisplayTime write FDisplayTime default TenSeconds;
    property    Font : TFont read GetFont write SetFont;
    property    Color : TColor read GetColor write SetColor default clInfoBk;
  end;

  TKSHintWindowEx = class(THintWindow)
  private

  protected

  public
    procedure   ActivateHint(Rect: TRect; const AHint: string); override;
  end;

implementation

uses Messages, Forms;

{ THintMan }

constructor THintMan.Create(AOwner: TComponent);
begin
  inherited;
  FHintWindow := TKSHintWindow.Create(Self);
  FHintWindow.Color := clInfoBk;
  FDisplayTime := TenSeconds;
end;

destructor THintMan.Destroy;
var
  MessageEvent : TMessageEvent;
begin
  MessageEvent := Application.OnMessage;
  if TMethod(MessageEvent).Data=Self then
    Application.OnMessage:=nil;
  FreeAndNil(FHintWindow);
  inherited;
end;

procedure THintMan.DoApplicationMessage(var Msg: TMsg;
  var Handled: Boolean);
begin
  if FHintActive then
  begin
    with Msg do
      if ((Message >= WM_KEYFIRST) and (Message <= WM_KEYLAST)) or
      ((Message = CM_ACTIVATE) or (Message = CM_DEACTIVATE)) or
      (Message = CM_APPKEYDOWN) or (Message = CM_APPSYSCOMMAND) or
      (Message = WM_COMMAND) or ((Message > WM_MOUSEMOVE) and
      (Message <= WM_MOUSELAST)) or (Message = WM_NCMOUSEMOVE)
          then
      begin
        if Message<>WM_KeyUp then
          CloseHint;
      end else
      begin
        if GetTickCount>FShowHintTime+FDisplayTime then
          CloseHint;
      end;
  end;
end;

procedure THintMan.ShowHintFor(Control: TControl; const AHint: string; Position : THintPosition);
const
  ScreenSpaceMargin = 50;
var
  Rect : TRect;
  P : TPoint;
  HintStr : string;
begin
  KillTimer(FHintWindow.Handle,1);

  FHintWindow.Canvas.Font := FHintWindow.Font; // call this, assure CalcHintRect is right.
  if AHint<>'' then
    HintStr := AHint else
    HintStr := Control.Hint;
  if HintStr='' then
    Exit;
  Rect := FHintWindow.CalcHintRect(400,HintStr,nil);
  P := Control.ClientOrigin;
  OffsetRect(Rect,P.X,P.Y);
  if Position=hpAuto then
  begin
    if Screen.Height - Rect.Bottom < ScreenSpaceMargin then
      Position := hpAbove else
      Position := hpBellow;
  end;
  case Position of
    hpAbove : OffsetRect(Rect,0,-(Rect.Bottom-Rect.Top+4));
    hpBellow : OffsetRect(Rect,0,Control.Height);
  end;

  FHintActive := True;
  FHintWindow.ActivateHint(Rect,HintStr);
  FShowHintTime := GetTickCount;

  SetTimer(FHintWindow.Handle,1,DisplayTime,nil);
end;

procedure THintMan.CloseHint;
begin
  FHintActive := False;
  if (FHintWindow<> nil) and FHintWindow.HandleAllocated and
    IsWindowVisible(FHintWindow.Handle) then
    ShowWindow(FHintWindow.Handle, SW_HIDE);
end;

function THintMan.GetColor: TColor;
begin
  Result := FHintWindow.Color;
end;

function THintMan.GetFont: TFont;
begin
  Result := FHintWindow.Font;
end;

procedure THintMan.SetColor(const Value: TColor);
begin
  FHintWindow.Color := Value;
end;

procedure THintMan.SetFont(const Value: TFont);
begin
  FHintWindow.Font := Value;
end;

{ TKSHintWindow }

procedure TKSHintWindow.Paint;
var
  R: TRect;
begin
  Canvas.Font := Font;
  Canvas.Brush.Color := Color;
  R := ClientRect;
  Inc(R.Left, 2);
  Inc(R.Top, 2);
  DrawText(Canvas.Handle, PChar(Caption), -1, R, DT_LEFT or DT_NOPREFIX or
    DT_WORDBREAK or DrawTextBiDiModeFlagsReadingOnly);
end;

{ TKSHintWindowEx }

procedure TKSHintWindowEx.ActivateHint(Rect: TRect; const AHint: string);
var
  CursorHeight : Integer;
begin
  CursorHeight := GetSystemMetrics(SM_CXCURSOR);
  if Rect.Bottom > Screen.DesktopHeight then
  begin
    OffsetRect(Rect,0,-(Rect.Bottom-Rect.Top)-CursorHeight);
  end;
  if Rect.Right > Screen.DesktopWidth then
  begin
    OffsetRect(Rect,-(Rect.Right-Rect.Left)-CursorHeight,0);
  end;

  inherited ActivateHint(Rect,AHInt);
end;

end.
