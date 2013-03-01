unit PConfirmBtn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,Buttons;

type
  TPConfirmBtn = class(TBitBtn)
  private
    { Private declarations }
    FBeforeClick: TNotifyEvent;
    FConfirmLevel: Integer;
  protected
    { Protected declarations }
    procedure Click;override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent);override;
  published
    { Published declarations }
    property ConfirmLevel: Integer read FConfirmLevel write FConfirmLevel default 0;
    property OnBeforeClick: TNotifyEvent read FBeforeClick write FBeforeClick;
  end;

procedure Register;

implementation

constructor TPConfirmBtn.Create(AOwner: TComponent);
begin
     inherited create(AOwner);
     FConfirmLevel:=0;
     Font.Name := 'ËÎÌו';
     Font.Size := 11;
end;

procedure TPConfirmBtn.Click;
begin
     if Assigned(FBeforeClick) then FBeforeClick(Self);
     inherited Click;
end;

procedure Register;
begin
     RegisterComponents('PosControl2', [TPConfirmBtn]);
end;

end.
