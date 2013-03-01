unit UMDQuery;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, Db, DBTables, RxQuery;

type
  TForm1 = class(TForm)
    RxQuery1: TRxQuery;
    RxQuery2: TRxQuery;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Query1: TQuery;
    Query2: TQuery;
    DataSource3: TDataSource;
    DataSource4: TDataSource;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var
   i : integer;
begin
  RxQuery1.open;
  RxQuery2.Prepare;
  RxQuery2.open;
  //RxQuery2.FieldByName('CustNo').DisplayLabel := '±àºÅ';
  //DBGrid2.Columns.Items[0].Title.Caption := '±àºÅ';
  DBGrid2.Columns.Clear;
  with RxQuery2,DBGrid2.Columns do
  for i:=0 to FieldCount-1 do
  with Add do
  begin
    FieldName := Fields[i].FieldName;
    Title.Caption := 'D_'+FieldName;
  end;
  Query1.open;
  Query2.Prepare;
  Query2.open;
  //DBGrid4.Columns.Items[0].Title.Caption := '±àºÅ';
  //Query2.FieldByName('CustNo').DisplayLabel := '±àºÅ';
end;

end.
