unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AbilityManager, Buttons, Menus;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Menu1: TMenuItem;
    BitBtn1: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure SimpleAbilityManager1EnableChanged(Sender: TObject);
    procedure SimpleAbilityManager1VisibleChanged(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    SimpleAbilityManager1: TSimpleAbilityManager;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses extutils;

{$R *.DFM}

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  SimpleAbilityManager1.Enabled := CheckBox1.checked;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  SimpleAbilityManager1.visible := CheckBox2.checked;
end;

procedure TForm1.CheckBox3Click(Sender: TObject);
begin
  SimpleAbilityManager1.VisibleOnEnabled:= CheckBox3.checked;
end;

procedure TForm1.SimpleAbilityManager1EnableChanged(Sender: TObject);
begin
  label3.caption := BoolToStr(SimpleAbilityManager1.Enabled);
end;

procedure TForm1.SimpleAbilityManager1VisibleChanged(Sender: TObject);
begin
  label4.caption := BoolToStr(SimpleAbilityManager1.visible);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SimpleAbilityManager1:= TSimpleAbilityManager.create(self);
  SimpleAbilityManager1.control := Bitbtn1;
  SimpleAbilityManager1.MenuItem := Menu1;
  SimpleAbilityManager1.OnEnableChanged:= SimpleAbilityManager1EnableChanged;
  SimpleAbilityManager1.OnvisibleChanged:= SimpleAbilityManager1visibleChanged;
end;

end.
