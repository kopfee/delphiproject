unit HotKeyMons;

// %HotKeyMons : 包含系统热键组件
(*****   Code Written By Huang YanLai   *****)

interface

uses Windows,Messages,Classes,Controls,menus,WinUtils;

type
  // %THotKeyMonitor : 可以定义一个系统热键，当用户按下热键以后，触发事件
  THotKeyMonitor = class(TMessageComponent)
  private
    FInstalled: boolean;
    FActive: boolean;
    FModifiers: TShiftState;
    FOnHotKey: TNotifyEvent;
    FID: Integer;
    //FShortCut: TShortCut;
    FVKCode: word;
    procedure SetActive(const Value: boolean);
    procedure SetModifiers(const Value: TShiftState);
    procedure Register;
    procedure UnRegister;
    procedure UpdateHotkey;
    procedure SetShortCut(const Value: TShortCut);
    procedure WMHotKey(var Message:TWMHotKey); message WM_HotKey;
    procedure SetVKCode(const Value: word);
    function  GetShortCut: TShortCut;
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    property  Installed: boolean read FInstalled;
    property  ID : Integer read FID;
    property  VKCode : word read FVKCode write SetVKCode;
  published
    property  Active : boolean read FActive write SetActive default false;
    //property  ID : integer read FID write SetID;
    property  ShortCut : TShortCut read GetShortCut Write SetShortCut ;
    property  Modifiers : TShiftState read FModifiers write SetModifiers;
    property  OnHotKey : TNotifyEvent read FOnHotKey write FOnHotKey;
  end;


implementation


{ THotKeyMonitor }

constructor THotKeyMonitor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FID:= 1;
  FInstalled := false;
  FActive := false;
end;

destructor THotKeyMonitor.Destroy;
begin
  UnRegister;
  inherited Destroy;
end;

procedure THotKeyMonitor.SetActive(const Value: boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    if not (csDesigning in ComponentState)
    and not (csLoading in ComponentState) then
      if FActive then
        Register
      else
        UnRegister;
  end;
end;

procedure THotKeyMonitor.SetModifiers(const Value: TShiftState);
begin
  if FModifiers <> Value then
  begin
    FModifiers := Value;
    menus.ShortCut(VKCode,Modifiers);
    UpdateHotkey;
  end;
end;

procedure THotKeyMonitor.SetShortCut(const Value: TShortCut);
begin
  //if FShortCut <> Value then
  begin
    {FShortCut := Value;
    ShortCutToKey(FShortCut,FVKCode,FModifiers);}
    ShortCutToKey(value,FVKCode,FModifiers);
    UpdateHotKey;
  end;
end;

procedure THotKeyMonitor.Register;
var
  M : integer;
begin
  if not FInstalled then
  begin
    M := 0;
    if ssShift in FModifiers then M := M or MOD_Shift;
    if ssCtrl in FModifiers then M := M or MOD_CONTROL;
    if ssAlt in FModifiers then M := M or MOD_ALT;
    FInstalled := RegisterHotKey(FUtilWindow.handle,FID,M,VKCode);
    FActive := FInstalled;
  end;
end;

procedure THotKeyMonitor.UnRegister;
begin
  if FInstalled then
  begin
    FInstalled:=not UnRegisterHotKey(FUtilWindow.handle,FID);
    //FInstalled:=false;
  end;
end;

procedure THotKeyMonitor.WMHotKey(var Message: TWMHotKey);
begin
  if assigned(FOnHotkey) then FOnHotkey(self);
end;

procedure THotKeyMonitor.UpdateHotkey;
begin
  if FInstalled then
  begin
    UnRegister;
    Register;
  end;
end;


procedure THotKeyMonitor.Loaded;
begin
  inherited Loaded;
  if not (csDesigning in ComponentState) then
      if FActive then
        Register
      else
        UnRegister;
end;

procedure THotKeyMonitor.SetVKCode(const Value: word);
begin
  if FVKCode <> Value then
  begin
    FVKCode := Value;
    UpdateHotkey;
  end;
end;


function THotKeyMonitor.GetShortCut: TShortCut;
begin
  result := menus.ShortCut(FVKCode,FModifiers);
end;

end.
