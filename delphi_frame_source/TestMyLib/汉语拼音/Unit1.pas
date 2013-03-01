unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    edText: TEdit;
    lbResult: TLabel;
    btnTest: TButton;
    ckSkipOther: TCheckBox;
    procedure btnTestClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses KsChineseSpell;

{$R *.DFM}

procedure TForm1.btnTestClick(Sender: TObject);
begin
  lbResult.Caption := GetChineseFirstSpell(edText.Text,ckSkipOther.Checked);
end;

end.
