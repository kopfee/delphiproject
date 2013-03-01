unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Design, Design2;

type
  TForm1 = class(TForm)
    Designer21: TDesigner2;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel3: TPanel;
    ckNotMovePanel: TCheckBox;
    Panel4: TPanel;
    Memo1: TMemo;
    lbControlName: TLabel;
    ckNotSizePanel: TCheckBox;
    procedure Designer21CanMoveCtrl(Designer: TCustomDesigner;
      Ctrl: TControl; var CanMoved: Boolean);
    procedure Designer21DesignCtrlChanged(DesignCtrl: TControl);
    procedure Designer21CanSizeCtrl(Designer: TCustomDesigner;
      Ctrl: TControl; var CanSized: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Designer21CanMoveCtrl(Designer: TCustomDesigner;
  Ctrl: TControl; var CanMoved: Boolean);
begin
  CanMoved := not ckNotMovePanel.Checked or not (Ctrl is TPanel);
end;

type
  TControlAccess = class(TControl);

procedure TForm1.Designer21DesignCtrlChanged(DesignCtrl: TControl);
begin
  if DesignCtrl<>nil then
    lbControlName.Caption := TControlAccess(DesignCtrl).Text;
end;

procedure TForm1.Designer21CanSizeCtrl(Designer: TCustomDesigner;
  Ctrl: TControl; var CanSized: Boolean);
begin
  CanSized := not ckNotSizePanel.Checked or not (Ctrl is TPanel);
end;

end.
