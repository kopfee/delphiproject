unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls,BasicDataAccess_TLB,MSSQLAcs,DBAIntf,BDAImp;

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
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  //LoadLibrary('BasicDataAccess.dll');
  DataAccess := TMSSQLAcsEx.create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Render := nil;
  Dataset := nil;
  DBAccess := nil;
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
  btnConnect.Enabled := false;
  btnExec.Enabled := true;
  DBAccess := DataAccess;
  DBAccess.isSupportCompute := true;
  DatasetObj := THDataset.create(DBAccess);
  DatasetObj.AutoSum := true;
  Dataset := IHDataset(DatasetObj);
  //Render := Dataset.getRender(rtPrint);
end;

procedure TForm1.btnExecClick(Sender: TObject);
begin
  mmMessage.Lines.Clear;
  mmResult.Lines.Clear;
  DBAccess.execSQL(mmSQL.lines.text);
  DatasetObj.clearFields;
  DatasetObj.addAllExistFields;
  DatasetObj.Open(10);
  if rbBrowse.Checked then
    Render := Dataset.getRender(rtBrowse) else
    Render := Dataset.getRender(rtPrint);
  Render.prepare('mydata',edFields.text);
  mmResult.Lines.add(Render.getData(10));
  mmMessage.Lines.Assign(DataAccess.Messages);
end;

end.
