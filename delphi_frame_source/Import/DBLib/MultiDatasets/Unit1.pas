unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, BDAImpEx, DBAIntf, MSSQLAcs, ComCtrls,
  StdCtrls;

type
  TForm1 = class(TForm)
    MSSQLDatabase: TMSSQLDatabase;
    MSQuery: THQuery;
    HResponseHandler: THResponseHandler;
    HSimpleDataset1: THSimpleDataset;
    DataSource1: TDataSource;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    DBGrid1: TDBGrid;
    HSimpleDataset2: THSimpleDataset;
    HSimpleDataset3: THSimpleDataset;
    DataSource2: TDataSource;
    DataSource3: TDataSource;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    pcPages: TPageControl;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    Label1: TLabel;
    mmSQL: TMemo;
    btnRun: TButton;
    Label2: TLabel;
    edHost: TEdit;
    Label3: TLabel;
    edUser: TEdit;
    Label4: TLabel;
    edServer: TEdit;
    Label5: TLabel;
    edPassword: TEdit;
    btnConnect: TButton;
    procedure btnRunClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
  private
    { Private declarations }
    procedure OpenDatasets;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses LogFile;

{$R *.dfm}

procedure TForm1.btnRunClick(Sender: TObject);
begin
  HResponseHandler.Close;
  MSQuery.SQL := mmSQL.Lines;
  HResponseHandler.Open;
  OpenDatasets;
end;

procedure TForm1.OpenDatasets;
begin
  if HResponseHandler.Datasets.Count>=1 then
    HSimpleDataset1.Active := True;
  if HResponseHandler.Datasets.Count>=2 then
    HSimpleDataset2.Active := True;
  if HResponseHandler.Datasets.Count>=3 then
    HSimpleDataset3.Active := True;
end;

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  MSSQLDatabase.ServerName := edServer.Text;
  MSSQLDatabase.HostName := edHost.Text;
  MSSQLDatabase.UserName := edUser.Text;
  MSSQLDatabase.Password := edPassword.Text;
  MSSQLDatabase.open;
  btnRun.Enabled := True;
  btnConnect.Enabled := False;
  pcPages.ActivePageIndex := 1;
end;

initialization
  OpenLogFile('',False,True);
end.
