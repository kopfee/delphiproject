unit PButton;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TPButton = class(TButton)
  private
    { Private declarations }
    FBeforeClick: TNotifyEvent;
  protected
    { Protected declarations }
    procedure Click;override;
  public
    { Public declarations }
  published
    { Published declarations }
    property BeforeClick: TNotifyEvent read FBeforeClick write FBeforeClick;
  end;

procedure Register;

implementation

procedure TPButton.Click;
begin
  if Assigned(FBeforeClick) then FBeforeClick(Self);
  inherited Click;
end;

procedure Register;
begin
  RegisterComponents('PosControl', [TPButton]);
end;

end.
