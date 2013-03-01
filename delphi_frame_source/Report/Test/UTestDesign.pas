unit UTestDesign;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, DBTables, Grids, DBGrids, ComCtrls, ExtCtrls, ExtDlgs;

type
  TForm1 = class(TForm)
    OpenDialog: TOpenDialog;
    Table1: TTable;
    DataSource1: TDataSource;
    Query1: TQuery;
    DataSource2: TDataSource;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    btnAnimals: TButton;
    DBGrid1: TDBGrid;
    btnOrders: TButton;
    DBGrid2: TDBGrid;
    Panel1: TPanel;
    Label1: TLabel;
    edCompany: TEdit;
    imgIcon: TImage;
    OpenPictureDialog: TOpenPictureDialog;
    TabSheet3: TTabSheet;
    btnAnimalsAndOrders: TButton;
    btnSetupPrinter: TButton;
    PrinterSetupDialog: TPrinterSetupDialog;
    procedure btnAnimalsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOrdersClick(Sender: TObject);
    procedure imgIconClick(Sender: TObject);
    procedure btnAnimalsAndOrdersClick(Sender: TObject);
    procedure btnSetupPrinterClick(Sender: TObject);
  private
    { Private declarations }
    procedure PreviewReport(const DatasetName : string; DataSource : TDataSource);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses RPDBVCL, RPDesignInfo, RPPrintObjects,JPEG;

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Query1.Open;
end;

procedure TForm1.btnOrdersClick(Sender: TObject);
begin
  PreviewReport('Orders',DataSource2);
end;

procedure TForm1.btnAnimalsClick(Sender: TObject);
begin
  PreviewReport('animals',DataSource1);
end;

procedure TForm1.PreviewReport(const DatasetName: string;
  DataSource: TDataSource);
var
  ReportInfo : TReportInfo;
  Ctrl : TRPPrintItemCtrl;
begin
  if OpenDialog.Execute then
  begin
    ReportInfo := TReportInfo.Create(Self);
    try
      ReportInfo.NewDataEntriesClass(TRPDBDataEntries);
      ReportInfo.LoadFromFile(OpenDialog.FileName);
      ReportInfo.CreateReport;
      TRPDBDataEntries(ReportInfo.DataEntries).AddDatasource(DatasetName,DataSource);
      ReportInfo.Environment.VariantValues.Values['#Company']:=edCompany.Text;
      Ctrl := ReportInfo.Processor.FindPrintCtrl('CompanyIcon');
      if Ctrl is TRPPrintPicture then
        TRPPrintPicture(Ctrl).Picture := imgIcon.Picture;
      ReportInfo.Preview;
    finally
      ReportInfo.Free;
    end;
  end;
end;

procedure TForm1.imgIconClick(Sender: TObject);
begin
  if OpenPictureDialog.Execute then
    imgIcon.Picture.LoadFromFile(OpenPictureDialog.FileName);
end;

procedure TForm1.btnAnimalsAndOrdersClick(Sender: TObject);
var
  ReportInfo : TReportInfo;
  Ctrl : TRPPrintItemCtrl;
begin
  if OpenDialog.Execute then
  begin
    ReportInfo := TReportInfo.Create(Self);
    try
      ReportInfo.NewDataEntriesClass(TRPDBDataEntries);
      ReportInfo.LoadFromFile(OpenDialog.FileName);
      ReportInfo.CreateReport;
      if ReportInfo.DataEntries.IndexOfDataset('Animals')>=0 then
        TRPDBDataEntries(ReportInfo.DataEntries).AddDatasource('Animals',DataSource1);
      if ReportInfo.DataEntries.IndexOfDataset('Orders')>=0 then
        TRPDBDataEntries(ReportInfo.DataEntries).AddDatasource('Orders',DataSource2);
      ReportInfo.Environment.VariantValues.Values['#Company']:=edCompany.Text;
      Ctrl := ReportInfo.Processor.FindPrintCtrl('CompanyIcon');
      if Ctrl is TRPPrintPicture then
        TRPPrintPicture(Ctrl).Picture := imgIcon.Picture;
      ReportInfo.Preview;
    finally
      ReportInfo.Free;
    end;
  end;
end;


procedure TForm1.btnSetupPrinterClick(Sender: TObject);
begin
  PrinterSetupDialog.Execute;
end;

end.
