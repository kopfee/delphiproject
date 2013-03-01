unit UDebug1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, BkGround3, Mask, ComCtrls, Buttons, ExtCtrls, DBCtrls, Grids,
  CheckLst;

type
  TForm1 = class(TForm)
    BackGround1: TBackGround;
    Memo1: TMemo;
    Edit1: TEdit;
    ListBox1: TListBox;
    MaskEdit1: TMaskEdit;
    Button1: TButton;
    RichEdit1: TRichEdit;
    Label1: TLabel;
    RadioGroup1: TRadioGroup;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    RadioButton1: TRadioButton;
    StaticText1: TStaticText;
    DBText1: TDBText;
    DBListBox1: TDBListBox;
    DBCheckBox1: TDBCheckBox;
    CheckBox2: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  RichEdit1.lines.loadfromfile('c:\html3.rtf');
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  BackGround1.transparent := CheckBox2.checked;
end;

end.
