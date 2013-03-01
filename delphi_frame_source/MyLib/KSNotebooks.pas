unit KSNotebooks;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TKSNotebook = class(TNotebook)
  private
    FAutoCenter: Boolean;
    { Private declarations }
    procedure   CenterControls;
  protected
    { Protected declarations }
    procedure   Resize; override;
  public
    { Public declarations }
    constructor Create(AOwner:TComponent);override;
  published
    { Published declarations }
    property    AutoCenter : Boolean read FAutoCenter write FAutoCenter default False;
  end;

implementation

uses CompUtils, DrawUtils;

{ TKSNotebook }

constructor TKSNotebook.Create(AOwner: TComponent);
begin
  inherited;
  Include(FComponentStyle,csInheritable);
  FAutoCenter := False;
end;

procedure TKSNotebook.Resize;
begin
  inherited;
  if AutoCenter and not (csDesigning in ComponentState) then
    CenterControls;
end;

procedure TKSNotebook.CenterControls;
var
  I : Integer;
  Ctrl : TControl;
begin
  for I:=0 to ControlCount-1 do
  begin
    Ctrl := Controls[I];
    if Ctrl is TPage then
      CenterChildren(TWinControl(Ctrl));
  end;
end;

end.
