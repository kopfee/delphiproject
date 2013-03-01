unit Unit6;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Design, ExtCtrls, BkGround, Grids;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    CheckBox1: TCheckBox;
    Label2: TLabel;
    BackGround1: TBackGround;
    Designer1: TDesigner;
    Label1: TLabel;
    Button1: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    CheckBox2: TCheckBox;
    RadioButton1: TRadioButton;
    ListBox1: TListBox;
    StaticText1: TStaticText;
    GroupBox1: TGroupBox;
    Panel2: TPanel;
    StringGrid1: TStringGrid;
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  Designer1.Designed:=CheckBox1.checked;
end;

end.
