unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RPDesignInfo, RPDBDesignInfo, ExtCtrls, Grids, DBGrids, Db, DBTables,
  StdCtrls, ActnList, DBCtrls, RPProcessors;

type
  TForm1 = class(TForm)
    Query: TQuery;
    DataSource: TDataSource;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    DBReportInfo: TDBReportInfo;
    Label1: TLabel;
    edCustNo: TEdit;
    btnExecSQL: TButton;
    Label2: TLabel;
    edFileName: TEdit;
    btnSelectFile: TButton;
    OpenDialog: TOpenDialog;
    btnPreview: TButton;
    ActionList1: TActionList;
    acPreview: TAction;
    DBNavigator1: TDBNavigator;
    btnOutputToFile: TButton;
    acOutputToFile: TAction;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    RPGlobe1: TRPGlobe;
    btnSetupPrinter: TButton;
    PrintDialog: TPrintDialog;
    btnPrint: TButton;
    lbPrinter: TLabel;
    procedure btnExecSQLClick(Sender: TObject);
    procedure btnSelectFileClick(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction;
      var Handled: Boolean);
    procedure acPreviewExecute(Sender: TObject);
    procedure acOutputToFileExecute(Sender: TObject);
    procedure btnSetupPrinterClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure lbPrinterClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses ExtUtils, Printers, PrintUtils;

{$R *.DFM}

procedure TForm1.btnExecSQLClick(Sender: TObject);
begin
  Query.Close;
  Query.ParamByName('CustNo').AsInteger := StrToInt(edCustNo.Text);
  Query.Open;
end;

procedure TForm1.btnSelectFileClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    DBReportInfo.FileName := OpenDialog.FileName;
    edFileName.Text := OpenDialog.FileName;
  end;
end;

procedure TForm1.ActionList1Update(Action: TBasicAction;
  var Handled: Boolean);
begin
  Handled := True;
  acPreview.Enabled := Query.Active and (DBReportInfo.FileName<>'');
  acOutputToFile.Enabled := Query.Active;
end;

procedure TForm1.acPreviewExecute(Sender: TObject);
begin
  try
    DBReportInfo.PrepareReport;
    if PrintDialog.PrintRange=prAllPages then
      DBReportInfo.Preview
    else if PrintDialog.PrintRange=prPageNums then
      DBReportInfo.Preview(PrintDialog.FromPage,PrintDialog.ToPage);
  except
    Query.Close;
  end;
end;

procedure TForm1.acOutputToFileExecute(Sender: TObject);
begin
  if OpenDialog1.Execute and SaveDialog1.Execute then
  begin
    DBReportInfo.TextFormatFileName := OpenDialog1.FileName;
    DBReportInfo.PrintToFile(SaveDialog1.FileName);
    ShellOpenFile(SaveDialog1.FileName);
  end;
end;

procedure TForm1.btnSetupPrinterClick(Sender: TObject);
begin
  PrintDialog.Execute;
end;

procedure TForm1.btnPrintClick(Sender: TObject);
begin
  try
    DBReportInfo.PrepareReport;
    if PrintDialog.PrintRange=prAllPages then
      DBReportInfo.Print
    else if PrintDialog.PrintRange=prPageNums then
      DBReportInfo.Print(PrintDialog.FromPage,PrintDialog.ToPage);
  except
    Query.Close;
  end;
end;

procedure TForm1.lbPrinterClick(Sender: TObject);
var
  PrinterInfo : TKSPrinterInfo;
  Orientation : string;
begin
  GetPrinterInfo(PrinterInfo);
  if PrinterInfo.Orientation=poPortrait then
    Orientation := '×ÝÏò' else
    Orientation := 'ºáÏò';
  lbPrinter.Caption := Format('%s %s %s',[PrinterInfo.Device, PrinterInfo.FormName, Orientation]);
end;

end.
