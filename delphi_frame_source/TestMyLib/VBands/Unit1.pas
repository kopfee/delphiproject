unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VBands, StdCtrls, Spin;

type
  TForm1 = class(TForm)
    VMainBand1: TVMainBand;
    Memo1: TMemo;
    ckLeft: TCheckBox;
    ckRight: TCheckBox;
    ckTop: TCheckBox;
    ckBottom: TCheckBox;
    sedWidth: TSpinEdit;
    Label1: TLabel;
    cbMemoBorder: TCheckBox;
    procedure ckLeftClick(Sender: TObject);
    procedure ckRightClick(Sender: TObject);
    procedure ckTopClick(Sender: TObject);
    procedure ckBottomClick(Sender: TObject);
    procedure sedWidthChange(Sender: TObject);
    procedure cbMemoBorderClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.ckLeftClick(Sender: TObject);
begin
  VMainBand1.frame.DrawLeft := ckLeft.checked;
end;

procedure TForm1.ckRightClick(Sender: TObject);
begin
  VMainBand1.frame.DrawRight := ckRight.checked;
end;

procedure TForm1.ckTopClick(Sender: TObject);
begin
  VMainBand1.frame.DrawTop := ckTop.checked;
end;

procedure TForm1.ckBottomClick(Sender: TObject);
begin
  VMainBand1.frame.DrawBottom := ckBottom.checked;
end;

procedure TForm1.sedWidthChange(Sender: TObject);
begin
  VMainBand1.frame.LineWidth := sedWidth.value;
end;

procedure TForm1.cbMemoBorderClick(Sender: TObject);
begin
  if cbMemoBorder.checked then
    Memo1.BorderStyle := bsSingle
  else
		Memo1.BorderStyle := bsNone;
end;

end.
