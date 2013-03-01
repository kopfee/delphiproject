unit UTestDesign;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, DBTables, Grids, DBGrids, ComCtrls, ExtCtrls, ExtDlgs,
  Buttons,registry,inifiles;

type
  TForm1 = class(TForm)
    OpenDialog: TOpenDialog;
    DataSource1: TDataSource;
    Query1: TQuery;
    Panel1: TPanel;
    Label1: TLabel;
    edCompany: TEdit;
    imgIcon: TImage;
    OpenPictureDialog: TOpenPictureDialog;
    btnSetupPrinter: TButton;
    PrinterSetupDialog: TPrinterSetupDialog;
    Panel2: TPanel;
    Panel3: TPanel;
    cboDATABASE: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DBGrid1: TDBGrid;
    Database1: TDatabase;
    Label4: TLabel;
    edUsername: TEdit;
    Label5: TLabel;
    edPassword: TEdit;
    btnSaveConfig: TBitBtn;
    btnLoadConfig: TBitBtn;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Panel4: TPanel;
    BtnOpen: TBitBtn;
    Label7: TLabel;
    edDataSet: TEdit;
    procedure imgIconClick(Sender: TObject);
   // procedure btnAnimalsAndOrdersClick(Sender: TObject);
    procedure btnSetupPrinterClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure cboDATABASEChange(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnSaveConfigClick(Sender: TObject);
    procedure btnLoadConfigClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure edPUBLICKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure PreviewReport(const DatasetName : string; DataSource : TDataSource);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses RPDLLComp;

{$R *.DFM}


procedure TForm1.PreviewReport(const DatasetName: string;
  DataSource: TDataSource);
var
  DLLReport : TDLLReport;
begin
  if OpenDialog.Execute then
  begin
    DLLReport := TDLLReport.Create(Self);
    try
      DLLReport.LoadFromFile(OpenDialog.FileName);
      DLLReport.BingDataset(DatasetName,DataSource.DataSet);
      DLLReport.SetVariant('#Company',edCompany.Text);
      DLLReport.Preview;
    finally
      DLLReport.Free;
    end;
  end;
end;

procedure TForm1.imgIconClick(Sender: TObject);
begin
  if OpenPictureDialog.Execute then
    imgIcon.Picture.LoadFromFile(OpenPictureDialog.FileName);
end;



procedure TForm1.btnSetupPrinterClick(Sender: TObject);
begin
  PrinterSetupDialog.Execute;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
 session.GetAliasNames(cboDATABASE.items);
 edCompany.setfocus;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var Fstr:string;
begin
  if trim(cboDatabase.Text)='' then
  begin
    application.MessageBox(pchar('请选择数据库名(database)！'),pchar('提示'),mb_ok);
    cboDatabase.SetFocus;
    exit;
  end;

  Fstr:=memo1.Lines.Text;
  if Fstr='' then
    begin
        application.MessageBox(pchar('SQL语句不能为空！'),pchar('提示'),mb_ok);
        memo1.SetFocus;
        exit;
    end;
  if database1.Connected then
  database1.Connected :=false;
  if trim(cboDATABASE.text)<>'' then
    database1.AliasName :=cboDATABASE.Text;
  database1.params.Clear ;
  database1.Params.add('user name='+edUsername.text);
  database1.Params.add(' password='+edPassword.text);
  database1.LoginPrompt :=false;
  database1.Connected :=true;

  query1.Close;
  query1.SQL.clear;
  query1.SQL.Add(memo1.Lines.GetText);
  query1.open;

end;

procedure TForm1.cboDATABASEChange(Sender: TObject);
begin
  if database1.Connected then
    database1.Connected :=false;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  database1.Connected :=false;
  memo1.Lines.Clear ;
end;

procedure TForm1.btnOpenClick(Sender: TObject);
begin
  PreviewReport(edDataset.text,DataSource1)
end;

procedure TForm1.btnSaveConfigClick(Sender: TObject);
var FFile:textfile;
begin
  if saveDialog1.Execute  and (trim(savedialog1.FileName) <>'')   then
     begin
      AssignFile(FFile,saveDialog1.FileName);
      Rewrite(FFile);
      writeln(FFile,cboDatabase.text);
      writeln(FFile,edUsername.text);
      writeln(FFile,{edPassword.text}'');
      writeln(FFile,memo1.lines.text);
      CloseFile(FFile);
    end;

end;

procedure TForm1.btnLoadConfigClick(Sender: TObject);
var FFile:textFile;
    Fstr:string;
begin
  if openDialog1.Execute  and (trim(opendialog1.FileName) <>'')   then
     begin
       AssignFile(FFile,openDialog1.FileName);
       Reset(FFile);
       Readln(FFile,FStr);
       cboDatabase.text:=Fstr;
       Readln(FFile,FStr);
       edUsername.text:=Fstr;
       Readln(FFile,FStr);
       edPassword.text:=Fstr;
       memo1.lines.Clear ;
       while not eof(FFile) do
        begin
          Readln(FFile,Fstr);
          memo1.lines.Add(Fstr);
        end;
       CloseFile(FFile);
     end;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
  if trim(edDataSet.text)<>'' then
    PreviewReport(edDataset.text,DataSource1)
  else
    begin
      application.MessageBox(pchar('请先输入数据集名（Dataset）！'),pchar('提示'),mb_ok);
      edDataSet.setfocus;
    end;
end;
procedure TForm1.edPUBLICKeyPress(Sender: TObject; var Key: Char);
begin
  if (key=#13)  then
     postMessage((Sender as TWinControl).handle,WM_KEYDOWN,VK_TAB,0);
end;

end.
