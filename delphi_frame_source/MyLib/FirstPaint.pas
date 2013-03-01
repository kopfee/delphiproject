unit FirstPaint;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls,ComWriUtils;

type
  TShowFilter = class(TMsgFilter)
  private
    First : boolean;
    FOnFirstShow: TNotifyEvent;
    procedure WMPaint(var message : TWMPaint); message WM_Paint;
  public
    constructor Create(AControl : TControl); override;
    property    OnFirstShow : TNotifyEvent read FOnFirstShow write FOnFirstShow ;
  end;

  procedure HookShowFilter(Control : TControl; OnFirstShow: TNotifyEvent);
  procedure UnHookShowFilter(Control : TControl);
implementation

{ TShowFilter }

constructor TShowFilter.Create(AControl: TControl);
begin
  inherited Create(AControl);
  First := true;
end;

procedure TShowFilter.WMPaint(var message: TWMPaint);
begin
  if first then
  begin
    first := false;
    if Assigned(FOnFirstShow) then FOnFirstShow(self);
  end;
  inherited;
end;

procedure HookShowFilter(Control : TControl; OnFirstShow : TNotifyEvent);
var
  ShowFilter : TShowFilter;
begin
  ShowFilter := TShowFilter(HookMsgFilter(Control,TShowFilter));
  ShowFilter.OnFirstShow := OnFirstShow;
end;

procedure UnHookShowFilter(Control : TControl);
begin
  UnHookMsgFilter(Control,TShowFilter);
end;
end.
