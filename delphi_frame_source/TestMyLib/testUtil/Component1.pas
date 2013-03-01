unit Component1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TComponent1 = class(TComponent)
  private
    FMyComponent: TComponent;
    FOnComponentChanged: TNotifyEvent;
    procedure SetMyComponent(const Value: TComponent);
    procedure SetOnComponentChanged(const Value: TNotifyEvent);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
    procedure ComponentChanged;
  published
    { Published declarations }
    property MyComponent : TComponent read FMyComponent write SetMyComponent;
    property OnComponentChanged : TNotifyEvent read FOnComponentChanged write SetOnComponentChanged;
  end;

procedure Register;

implementation

uses ComWriUtils;

procedure Register;
begin
  RegisterComponents('Samples', [TComponent1]);
end;

{ TComponent1 }

procedure TComponent1.ComponentChanged;
begin
  if Assigned(FOnComponentChanged) then
    OnComponentChanged(self);
end;

constructor TComponent1.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  registerRefProp(self,'MyComponent');
end;

procedure TComponent1.SetMyComponent(const Value: TComponent);
begin
  FMyComponent := Value;
  ReferTo(value);
  ComponentChanged;
end;

procedure TComponent1.SetOnComponentChanged(const Value: TNotifyEvent);
begin
  FOnComponentChanged := Value;
end;

end.
