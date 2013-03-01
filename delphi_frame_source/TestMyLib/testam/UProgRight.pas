unit UProgRight;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AbilityManager, StdCtrls, Buttons, DBCtrls, Db, DBTables, Grids, DBGrids;

type
  TForm1 = class(TForm)
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DataSource1: TDataSource;
    Table1: TTable;
    DataSource2: TDataSource;
    edRight: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    DBText1: TDBText;
    BitBtn1: TBitBtn;
    amTest: TSimpleAbilityManager;
    apTest: TAbilityProvider;
    aupTest: TDBAuthorityProvider;
    DBGrid3: TDBGrid;
    Label3: TLabel;
    procedure DataSource2DataChange(Sender: TObject; Field: TField);
    procedure edRightChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses UDMProgRight;

{$R *.DFM}

procedure TForm1.DataSource2DataChange(Sender: TObject; Field: TField);
begin
  aupTest.UserID :=  Table1.FieldByName('MC').AsString;
end;

procedure TForm1.edRightChange(Sender: TObject);
begin
  apTest.AsString := edRight.text;
end;

end.
