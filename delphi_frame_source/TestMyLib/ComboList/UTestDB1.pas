unit UTestDB1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComWriUtils, ComboLists, DBTables, Db, Grids, DBGrids, ExtCtrls, DBCtrls,
  StdCtrls, Mask;

type
  TForm1 = class(TForm)
    Query1: TQuery;
    Database1: TDatabase;
    DBCodeValues1: TDBCodeValues;
    DBCodeValues2: TDBCodeValues;
    DBCodeValues3: TDBCodeValues;
    DBComboBoxList1: TDBComboBoxList;
    DBComboBoxList2: TDBComboBoxList;
    DBComboBoxList3: TDBComboBoxList;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    Table1: TTable;
    DataSource1: TDataSource;
    DBEdit1: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
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
begin
  DBCodeValues1.Active := true;
  DBCodeValues2.Active := true;
  DBCodeValues3.Active := true;
  Table1.Active := true;
end;

end.
