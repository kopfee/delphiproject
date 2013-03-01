unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, AbilityManager, Menus, Db, DBTables, DBCtrls, Grids,
  DBGrids, ComWriUtils;

type
  TForm1 = class(TForm)
    AbilityProvider1: TAbilityProvider;
    AbilityProvider2: TAbilityProvider;
    MainMenu1: TMainMenu;
    Read1: TMenuItem;
    Write1: TMenuItem;
    btnRead: TBitBtn;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    btnWrite: TBitBtn;
    dapUser: TDBAuthorityProvider;
    Query1: TQuery;
    Table1: TTable;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBText1: TDBText;
    Label1: TLabel;
    Label2: TLabel;
    amRead: TSimpleAbilityManager;
    amWrite: TGroupAbilityManager;
    DBText2: TDBText;
    cbActive: TCheckBox;
    Edit2: TEdit;
    Label3: TLabel;
    BitBtn1: TBitBtn;
    AbilityProvider3: TAbilityProvider;
    SimpleAbilityManager1: TSimpleAbilityManager;
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure amReadEnableChanged(Sender: TObject);
    procedure dapUserAuthorityChanged(Sender: TObject);
    procedure cbActiveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  if dapUser<>nil
    then dapUser.UserID := table1.fields[0].asString;
end;

procedure TForm1.amReadEnableChanged(Sender: TObject);
begin
  if edit1=nil then exit;
  if amRead.enabled
    then Edit1.passwordchar:=#0
    else Edit1.passwordchar:='*';
end;

procedure TForm1.dapUserAuthorityChanged(Sender: TObject);
begin
  cbActive.checked := dapUser.active;
end;

procedure TForm1.cbActiveClick(Sender: TObject);
begin
  dapUser.active := cbActive.checked;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  cbActive.checked := dapUser.active;
end;

procedure TForm1.Edit2Change(Sender: TObject);
begin
  dapUser.DefaultAuthorityString := Edit2.text;
end;

end.
