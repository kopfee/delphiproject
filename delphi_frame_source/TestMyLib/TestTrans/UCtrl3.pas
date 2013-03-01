unit UCtrl3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, DBCtrls, Grids, CheckLst, Buttons, ExtCtrls, ComCtrls,
  BkGround, DBGrids, Db, DBTables;

type
  TForm2 = class(TForm)
    BackGround1: TBackGround;
    SpeedButton1: TSpeedButton;
    TreeView1: TTreeView;
    ListView1: TListView;
    RadioGroup1: TRadioGroup;
    ScrollBox1: TScrollBox;
    CheckListBox1: TCheckListBox;
    DBEdit1: TDBEdit;
    ComboBox1: TComboBox;
    DataSource1: TDataSource;
    Table1: TTable;
    DBGrid1: TDBGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

end.
