unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls,BasicDataAccess_TLB,MSSQLAcs,
  DBAIntf,BDAImp,BDAImpEx, Grids, DBGrids, DBCtrls, Db, Spin;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edHost: TEdit;
    Label2: TLabel;
    edServer: TEdit;
    Label3: TLabel;
    edUser: TEdit;
    Label4: TLabel;
    edPassword: TEdit;
    btnConnect: TButton;
    PageControl1: TPageControl;
    tsSQL: TTabSheet;
    mmSQL: TMemo;
    btnExec: TButton;
    Label5: TLabel;
    edDatabase: TEdit;
    tsMessage: TTabSheet;
    mmMessage: TMemo;
    TabSheet1: TTabSheet;
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    seMaxRows: TSpinEdit;
    Label7: TLabel;
    btnClose: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnExecClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
    Database : TMSSQLDatabase;
    Dataset : THQuery;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses LogFile;

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Database := TMSSQLDatabase.create(self);
  Dataset := THQuery.create(self);
  Dataset.database := Database;
  DataSource1.DataSet:= Dataset;
end;

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  Database.ServerName := edServer.text;
  Database.HostName := edHost.text;
  Database.DatabaseName := edDatabase.text;
  Database.UserName := edUser.text;
  Database.Password := edPassword.text;
  Database.Timeout := 30;
  Database.Connected := true;

  btnConnect.Enabled := false;
  btnExec.Enabled := true;
end;

procedure TForm1.btnExecClick(Sender: TObject);
begin
  mmMessage.Lines.Clear;
  Dataset.MaxRows:=seMaxRows.value;

  Dataset.close;
  Dataset.sql:=mmSQL.lines;
  try
    Dataset.Open;
    PageControl1.ActivePageIndex:=2;
  except on e:Exception do
    begin
      mmMessage.Lines.add('Exception : '+e.Message);
      mmMessage.Lines.add(Dataset.MessageText);
      PageControl1.ActivePageIndex:=1;
    end;
  end;
end;

procedure TForm1.btnCloseClick(Sender: TObject);
begin
  dataset.Close;
end;

initialization
  openLogFile('',false,true);
  LogCatalogs:=[lcDebug,lcConstruct_Destroy];
end.
