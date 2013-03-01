unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, Db, BDAImpEx, DBAIntf, MSSQLAcs;

type
  TForm1 = class(TForm)
    MSSQLDatabase1: TMSSQLDatabase;
    HQuery1: THQuery;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
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
