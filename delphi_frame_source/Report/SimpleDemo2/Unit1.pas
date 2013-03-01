unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RPDesignInfo, RPDBDesignInfo, ExtCtrls, Grids, DBGrids, Db, DBTables,
  StdCtrls, ActnList, DBCtrls;

type
  TForm1 = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    DBReportInfo: TDBReportInfo;
    Label2: TLabel;
    edFileName: TEdit;
    btnSelectFile: TButton;
    OpenDialog: TOpenDialog;
    btnPreview: TButton;
    ActionList1: TActionList;
    acPreview: TAction;
    btnOutputToFile: TButton;
    acOutputToFile: TAction;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Table1: TTable;
    Table2: TTable;
    DataSource2: TDataSource;
    DBGrid2: TDBGrid;
    procedure btnSelectFileClick(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction;
      var Handled: Boolean);
    procedure acPreviewExecute(Sender: TObject);
    procedure acOutputToFileExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses ExtUtils;

{$R *.DFM}

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
  acPreview.Enabled := (DBReportInfo.FileName<>'');
end;

procedure TForm1.acPreviewExecute(Sender: TObject);
begin
  DBReportInfo.PrepareReport;
  DBReportInfo.Preview;
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

end.
