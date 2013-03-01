unit Unit1;

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
    tsResult: TTabSheet;
    mmSQL: TMemo;
    mmResult: TMemo;
    btnExec: TButton;
    Label5: TLabel;
    edDatabase: TEdit;
    edFields: TEdit;
    Label6: TLabel;
    rbBrowse: TRadioButton;
    rbPrint: TRadioButton;
    tsMessage: TTabSheet;
    mmMessage: TMemo;
    TabSheet1: TTabSheet;
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    seReadCount: TSpinEdit;
    seMaxRows: TSpinEdit;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnExecClick(Sender: TObject);
  private
    { Private declarations }
    DataAccess : TMSSQLAcsEx;
    DBAccess : IDBAccess;
    Dataset : IHDataset;
    DatasetObj : THDataset;
    Render : IHResultRender;
    StdDataset : THStdDataset;
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
  //LoadLibrary('BasicDataAccess.dll');
  DataAccess := TMSSQLAcsEx.create;
  //DataAccess := TMSSQLAcsEx.create(true);
  DBAccess := DataAccess;
  DBAccess.isSupportCompute := true;
  StdDataset := THStdDataset.create(self);
  DataSource1.DataSet:=StdDataset;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  writeLog('StdDataset.free',lcConstruct_Destroy);
  StdDataset.free;
  {writeLog('DatasetObj.DBAccess:= nil',lcConstruct_Destroy);
  DatasetObj.DBAccess:=nil;}
  writeLog('Render := nil',lcConstruct_Destroy);
  Render := nil;
  writeLog('Dataset := nil',lcConstruct_Destroy);
  Dataset := nil;
  {writeLog('DBAccess:=nil',lcConstruct_Destroy);
  DBAccess := nil;}
  pointer(DBAccess):=nil;
  writeLog('DataAccess.free',lcConstruct_Destroy);
  DataAccess.free;
end;

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  DataAccess.ServerName := edServer.text;
  DataAccess.HostName := edHost.text;
  DataAccess.DatabaseName := edDatabase.text;
  DataAccess.UserName := edUser.text;
  DataAccess.Password := edPassword.text;
  DataAccess.Timeout := 30;
  DataAccess.Connected := true;
  DataAccess.readAllRows:=true;
  btnConnect.Enabled := false;
  btnExec.Enabled := true;
  DatasetObj := THDataset.create(DBAccess{,true});
  DatasetObj.AutoSum := true;
  DatasetObj.TextDB.MinRowsPerBuffer:=50;
  Dataset := IHDataset(DatasetObj);
  //Render := Dataset.getRender(rtPrint);
end;

procedure TForm1.btnExecClick(Sender: TObject);
begin
  StdDataset.close;
  StdDataset.Data := DatasetObj;

  mmMessage.Lines.Clear;
  mmResult.Lines.Clear;
  DBAccess.execSQL(mmSQL.lines.text);

  DBAccess.nextResponse;

  DatasetObj.clearFields;
  DatasetObj.addAllExistFields;
  DatasetObj.MaxRows := seMaxRows.Value;
  DatasetObj.Open(seReadCount.value);
  if rbBrowse.Checked then
    Render := Dataset.getRender(rtBrowse) else
    Render := Dataset.getRender(rtPrint);
  Render.prepare('mydata',edFields.text);
  mmResult.Lines.add(Render.getData(10));
  mmMessage.Lines.Assign(DataAccess.Messages);

  StdDataset.open;
  PageControl1.ActivePageIndex:=3;
end;

initialization
  openLogFile('',false,true);
  LogCatalogs:=[lcDebug,lcConstruct_Destroy];
end.
