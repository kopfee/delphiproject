unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  EditExts, StdCtrls, Spin;

type
  TForm1 = class(TForm)
    DigitalEdit1: TKSDigitalEdit;
    ckAllowNegative: TCheckBox;
    ckAllowPoint: TCheckBox;
    ckUseSeperator: TCheckBox;
    ckUserDelete: TCheckBox;
    ckRedNegative: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    seInt: TSpinEdit;
    sePrecision: TSpinEdit;
    Button1: TButton;
    lbText: TLabel;
    Label4: TLabel;
    Button2: TButton;
    ckLeading: TCheckBox;
    ckautoselect: TCheckBox;
    procedure ckAllowNegativeClick(Sender: TObject);
    procedure ckAllowPointClick(Sender: TObject);
    procedure ckUseSeperatorClick(Sender: TObject);
    procedure ckUserDeleteClick(Sender: TObject);
    procedure ckRedNegativeClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure DigitalEdit1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ckLeadingClick(Sender: TObject);
    procedure ckautoselectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.ckAllowNegativeClick(Sender: TObject);
begin
  DigitalEdit1.AllowNegative := ckAllowNegative.Checked;
  DigitalEdit1.Clear;
end;

procedure TForm1.ckAllowPointClick(Sender: TObject);
begin
  DigitalEdit1.AllowPoint:= ckAllowPoint.Checked;
  DigitalEdit1.Clear;
end;

procedure TForm1.ckUseSeperatorClick(Sender: TObject);
begin
  DigitalEdit1.UserSeprator:= ckUseSeperator.Checked;
end;

procedure TForm1.ckUserDeleteClick(Sender: TObject);
begin
  if ckUserDelete.Checked then
  begin
    DigitalEdit1.DeleteChar:='*';
    DigitalEdit1.ClearChar :='/';
  end
  else
  begin
    DigitalEdit1.DeleteChar:=#0;
    DigitalEdit1.ClearChar :=#0;
  end;
end;

procedure TForm1.ckRedNegativeClick(Sender: TObject);
begin
  DigitalEdit1.RedNegative := ckRedNegative.Checked;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  DigitalEdit1.MaxIntLen:=seInt.value;
  DigitalEdit1.Precision := sePrecision.value;
end;

procedure TForm1.DigitalEdit1Change(Sender: TObject);
begin
  lbText.Caption := DigitalEdit1.Text;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  DigitalEdit1.Clear;
end;

procedure TForm1.ckLeadingClick(Sender: TObject);
begin
  if ckLeading.Checked then
    DigitalEdit1.Leading:='$'
  else DigitalEdit1.Leading:='';
end;

procedure TForm1.ckautoselectClick(Sender: TObject);
begin
  DigitalEdit1.AutoSelect:= ckautoselect.Checked;
end;

end.
