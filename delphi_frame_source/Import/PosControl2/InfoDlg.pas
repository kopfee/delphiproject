unit InfoDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, Buttons, ExtCtrls, DBCtrls, Db;

type
  TfrmInfoDlg = class(TForm)
    Panel1: TPanel;
    btnClose: TBitBtn;
    Panel2: TPanel;
    grdInfo: TStringGrid;
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
  private
    { Private declarations }
    FDataSet: TDataSet;
    procedure FillGrid;
  public
    { Public declarations }
  published
    property DataSet:TDataSet read FDataSet write FDataSet;
  end;

implementation

{$R *.DFM}

procedure TfrmInfoDlg.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmInfoDlg.FormCreate(Sender: TObject);
begin
  grdInfo.ColWidths[0] := 150;
  grdInfo.ColWidths[1] := 200;
end;

procedure TfrmInfoDlg.FormShow(Sender: TObject);
begin
  DataSource1.DataSet := DataSet;
  grdInfo.RowCount := DataSet.FieldCount;
  FillGrid;
end;

procedure TfrmInfoDlg.FillGrid;
var
  i: integer;
begin
  for i := 0 to DataSet.FieldCount-1 do
    begin
      grdInfo.Cells[0,i] := DataSet.Fields[i].DisplayLabel;
      grdInfo.Cells[1,i] := DataSet.Fields[i].Text;
    end;
end;


procedure TfrmInfoDlg.DBNavigator1Click(Sender: TObject;
  Button: TNavigateBtn);
begin
  FillGrid;
end;

end.
