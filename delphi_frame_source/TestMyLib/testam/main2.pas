unit main2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, AbilityManager, Menus, Db, DBTables, DBCtrls, Grids,
  DBGrids;

type
  TForm1 = class(TForm)
    AbilityProvider1: TAbilityProvider;
    AbilityProvider2: TAbilityProvider;
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
    AbilityProvider3: TAbilityProvider;
    SimpleAbilityManager1: TSimpleAbilityManager;
    Button1: TButton;
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure amReadEnableChanged(Sender: TObject);
    procedure dapUserAuthorityChanged(Sender: TObject);
    procedure cbActiveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses outmod;

{$R *.DFM}

procedure TForm1.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  if dapUser<>nil
    then dapUser.UserID := table1.fields[0].asString;
end;

procedure TForm1.amReadEnableChanged(Sender: TObject);
begin
  if form2=nil then exit;
  if form2.edit1=nil then exit;
  if amRead.enabled
    then form2.Edit1.passwordchar:=#0
    else form2.Edit1.passwordchar:='*';
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

procedure TForm1.Button1Click(Sender: TObject);
begin
  form2.show;
end;

end.
