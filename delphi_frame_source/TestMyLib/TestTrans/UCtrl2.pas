unit UCtrl2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, DBCtrls, Grids, CheckLst, Buttons, ExtCtrls, ComCtrls,
  BkGround;

type
  TForm2 = class(TForm)
    BackGround1: TBackGround;
    SpeedButton1: TSpeedButton;
    ComboBox1: TComboBox;
    TreeView1: TTreeView;
    ListView1: TListView;
    RadioGroup1: TRadioGroup;
    Panel1: TPanel;
    Label2: TLabel;
    CheckBox3: TCheckBox;
    GroupBox1: TGroupBox;
    CheckBox2: TCheckBox;
    ScrollBox1: TScrollBox;
    CheckListBox1: TCheckListBox;
    DrawGrid1: TDrawGrid;
    DBEdit1: TDBEdit;
    Label1: TLabel;
    Edit1: TEdit;
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
