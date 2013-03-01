unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls, Design, Design2, Menus;

type
  TForm1 = class(TForm)
    Designer1: TDesigner2;
    Label1: TLabel;
    Memo1: TMemo;
    Button1: TButton;
    CheckBox1: TCheckBox;
    RadioButton1: TRadioButton;
    ListBox1: TListBox;
    ComboBox1: TComboBox;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    BitBtn1: TBitBtn;
    Panel2: TPanel;
    CheckBox2: TCheckBox;
    SpeedButton2: TSpeedButton;
    Label2: TLabel;
    Label3: TLabel;
    PopupMenu1: TPopupMenu;
    Test1: TMenuItem;
    Popup1: TMenuItem;
    Menu1: TMenuItem;
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

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  Designer1.Designed := CheckBox2.Checked;
end;

end.
