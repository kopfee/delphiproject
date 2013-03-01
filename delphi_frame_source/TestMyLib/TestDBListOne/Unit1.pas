unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, StdCtrls, DBListOne, Grids, DBGrids, DBCtrls;

type
  TForm1 = class(TForm)
    DBComboList1: TDBComboList;
    Table1: TTable;
    DataSource1: TDataSource;
    DBListOne1: TDBListOne;
    Label1: TLabel;
    DBImage1: TDBImage;
    DBComboList2: TDBComboList;
    Button1: TButton;
    Label2: TLabel;
    Lable10: TLabel;
    lbAREA: TLabel;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure DBComboList2Selected(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  DBComboList2.text:='';
  Button2Click(Sender);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  lbArea.caption := DBComboList2.Code;
end;

procedure TForm1.DBComboList2Selected(Sender: TObject);
begin
  Button2Click(Sender);
end;

end.
