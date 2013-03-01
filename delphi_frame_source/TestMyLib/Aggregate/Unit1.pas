unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, Db, BDAImpEx, DBAIntf, MSSQLAcs, StdCtrls, ExtCtrls,
  ComCtrls;

type
  TForm1 = class(TForm)
    MSSQLDatabase: TMSSQLDatabase;
    HQuery: THQuery;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    StatusBar: TStatusBar;
    Panel1: TPanel;
    btnDoIt: TButton;
    mmSQL: TMemo;
    Label1: TLabel;
    edAggregateFields: TEdit;
    procedure btnDoItClick(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses BDAImp;

{$R *.DFM}

procedure TForm1.btnDoItClick(Sender: TObject);
begin
  HQuery.SQL.Assign(mmSQL.Lines);
  HQuery.AggregateFieldsSettings := edAggregateFields.Text;
  edAggregateFields.Text := HQuery.AggregateFieldsSettings;
  HQuery.Open;
end;

procedure TForm1.DataSource1DataChange(Sender: TObject; Field: TField);
var
  I : Integer;
  S : string;
  AggField : THDBAggregateField;
begin
  if Field=nil then
  begin
    S := Format('Count : %d', [HQuery.CurrentRecordCount]);
    for I:=0 to HQuery.AggregateFields.Count-1 do
    begin
      AggField := HQuery.AggregateField(I);
      S := Format('%s,%s(%s)=%g',[S,AggregateNames[AggField.AggregateType],AggField.FieldName,AggField.AsFloat]);
    end;
    StatusBar.SimpleText := S;
  end;
end;

end.
