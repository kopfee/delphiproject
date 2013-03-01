unit PRadioButton;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,PGroup;

type
  TPRadioButton = class(TRadioButton)
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure Click;override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure TPRadioButton.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
     if AHeight < 17 then
        AHeight := 17;
     if AHeight >50 then
        AHeight := 50;
     inherited;
end;

procedure TPRadioButton.Click;
var i: integer;
begin
     if not (csLoading in ComponentState) then
     begin
          for i := 0 to Parent.ControlCount-1 do
          begin
               if (Parent.Controls[i] is TPRadioGroup) then
                  if (Parent.Controls[i] as TPRadioGroup).Checked then
                     (Parent.Controls[i] as TPRadioGroup).Checked := False;
          end;
     end;
     inherited Click;
end;

procedure Register;
begin
     RegisterComponents('PosControl2', [TPRadioButton]);
end;

end.

