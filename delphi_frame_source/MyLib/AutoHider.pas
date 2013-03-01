unit AutoHider;
{ TODO : 
Design-Time Support
Form AutoHide Position Support }
interface

uses Windows, Messages, Classes, WinUtils, Controls, Forms;

type
  TAutoHider = class(TMessageComponent)
  private
    FEnabled: Boolean;
    FInterval: Cardinal;
    FTestingHide: Boolean;
    FForm: TCustomForm;
    FMargin: Integer;
    procedure   UpdateTimer;
    procedure   SetEnabled(Value: Boolean);
    procedure   SetInterval(Value: Cardinal);
    procedure   Timer;
    procedure   SetTestingHide(const Value: Boolean);
    procedure   SetForm(const Value: TCustomForm);
    procedure   AutoHide;
    procedure   AutoShow;
  protected
    procedure 	WndProc(var Msg : TMessage); override;
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
    property    TestingHide : Boolean read FTestingHide write SetTestingHide;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  published
    property    Enabled: Boolean read FEnabled write SetEnabled default false;
    property    Interval: Cardinal read FInterval write SetInterval default 1000;
    property    Margin : Integer read FMargin write FMargin default 10;
    property    Form : TCustomForm read FForm write SetForm;
  end;

implementation

uses SysUtils, Consts;

{ TAutoHider }

constructor TAutoHider.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnabled := false;
  FInterval := 1000;
  FTestingHide := false;
  FMargin := 10;
end;

destructor TAutoHider.Destroy;
begin
  FEnabled := False;
  UpdateTimer;
  inherited Destroy;
end;

procedure TAutoHider.WndProc(var Msg: TMessage);
begin
  try
    if not (csDesigning in ComponentState) and Enabled then
      case Msg.Msg of
        WM_TIMER : Timer;
        WM_MouseFirst..WM_MouseLast : AutoShow;
      else
        inherited;
      end
    else
      inherited;
  except
    Application.HandleException(Self);
  end;
end;

procedure TAutoHider.UpdateTimer;
begin
  if not (csDesigning in ComponentState) then
  begin
    KillTimer(FUtilWindow.Handle, 1);
    if (FInterval <> 0) and FEnabled and FTestingHide then
      if SetTimer(FUtilWindow.Handle, 1, FInterval, nil) = 0 then
        raise EOutOfResources.Create(SNoTimers);
  end;
end;

procedure TAutoHider.SetEnabled(Value: Boolean);
begin
  if Value <> FEnabled then
  begin
    FEnabled := Value;
    UpdateTimer;
  end;
end;

procedure TAutoHider.SetInterval(Value: Cardinal);
begin
  if Value <> FInterval then
  begin
    FInterval := Value;
    UpdateTimer;
  end;
end;

procedure TAutoHider.Timer;
var
  MouseInRange : Boolean;
begin
  //Assert((FForm<>nil));
  if TestingHide and (FForm<>nil) then
  begin
    MouseInRange := PtInRect(
      Rect(FForm.Left-Margin,
        FForm.Top-Margin,
        FForm.Left+FForm.Width+Margin+Margin,
        FForm.Top+FForm.Height+Margin+Margin)
      ,Mouse.CursorPos);
    if not MouseInRange then
    begin
      AutoHide;
    end;
  end;
end;

procedure TAutoHider.SetTestingHide(const Value: Boolean);
begin
  if FTestingHide <> Value then
  begin
    FTestingHide := Value;
    UpdateTimer;
  end;
end;

procedure TAutoHider.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent=FForm) and (Operation=opRemove) then
    Form := nil;
end;

procedure TAutoHider.SetForm(const Value: TCustomForm);
begin
  if FForm <> Value then
  begin
    FForm := Value;
    if FForm<>nil then
    begin
      FForm.FreeNotification(Self);
      TestingHide := True;
    end
    else
      TestingHide := False;
    UpdateTimer;  
  end;
end;

procedure TAutoHider.AutoHide;
begin
  Assert(FForm<>nil);
  FForm.Hide;
  TestingHide := false;
  SetWindowPos(FUtilWindow.Handle,HWND_TOPMOST,FForm.Left,0,FForm.Width,5,SWP_SHOWWINDOW);
end;

procedure TAutoHider.AutoShow;
begin
  if not TestingHide and Enabled then
  begin
    FForm.Visible := true;
    TestingHide := true;
    SetWindowPos(FUtilWindow.Handle,HWND_BOTTOM,0,0,0,0,SWP_HIDEWINDOW);
  end
  else
    TestingHide := false;
end;

end.
