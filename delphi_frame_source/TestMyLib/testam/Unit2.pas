unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, AbilityManager, Menus, Db, DBTables;

type
  TForm1 = class(TForm)
    AbilityProvider1: TAbilityProvider;
    AbilityProvider2: TAbilityProvider;
    MainMenu1: TMainMenu;
    Read1: TMenuItem;
    Write1: TMenuItem;
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    BitBtn2: TBitBtn;
    GroupAbilityManager1: TGroupAbilityManager;
    SimpleAbilityManager1: TSimpleAbilityManager;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    DBAuthorityProvider1: TDBAuthorityProvider;
    Query1: TQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


end.
