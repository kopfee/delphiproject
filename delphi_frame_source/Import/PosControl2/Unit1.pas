unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, Db, DBTables, LookupControls, PDBCounterEdit,
  PDBStaffEdit;

type
  TForm1 = class(TForm)
    Table1: TTable;
    DBGrid1: TDBGrid;
    Table2: TTable;
    DataSource2: TDataSource;
    DBGrid2: TDBGrid;
    DataSource1: TDataSource;
    PDBStaffEdit1: TPDBStaffEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

end.
