unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls, BkGround, Menus, Design;

type
  TForm1 = class(TForm)
    Designer1: TDesigner;
    BackGround1: TBackGround;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    Panel1: TPanel;
    Label1: TLabel;
    CheckBox2: TCheckBox;
    RadioButton3: TRadioButton;
    Edit2: TEdit;
    RadioGroup1: TRadioGroup;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    CheckBox3: TCheckBox;
    Edit1: TEdit;
    Memo1: TMemo;
    ListBox1: TListBox;
    ComboBox1: TComboBox;
    BitBtn1: TBitBtn;
    Button1: TButton;
    MainMenu1: TMainMenu;
    Transparent1: TMenuItem;
    Transparent2: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    procedure Exit1Click(Sender: TObject);
    procedure Transparent2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Exit1Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.Transparent2Click(Sender: TObject);
begin
  Transparent2.checked := not Transparent2.checked;
  Background1.Transparent := Transparent2.checked;
end;

end.
