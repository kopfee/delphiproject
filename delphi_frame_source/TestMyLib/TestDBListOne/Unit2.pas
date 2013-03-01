unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, StdCtrls, DBListOne, Grids, DBGrids, DBCtrls;

type
  TForm1 = class(TForm)
    DBComboList1: TDBComboList;
    Table1: TTable;
    DataSource1: TDataSource;
    Label1: TLabel;
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
