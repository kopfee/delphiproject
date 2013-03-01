unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, BkGround, Mask, ComCtrls, Buttons, ExtCtrls, DBCtrls, Grids,
  CheckLst;

type
  TForm1 = class(TForm)
    BackGround1: TBackGround;
    Memo1: TMemo;
    Edit1: TEdit;
    ListBox1: TListBox;
    ComboBox1: TComboBox;
    MaskEdit1: TMaskEdit;
    Button1: TButton;
    TreeView1: TTreeView;
    ListView1: TListView;
    RichEdit1: TRichEdit;
    Label1: TLabel;
    RadioGroup1: TRadioGroup;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    SpeedButton1: TSpeedButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    RadioButton1: TRadioButton;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    StaticText1: TStaticText;
    ScrollBox1: TScrollBox;
    CheckListBox1: TCheckListBox;
    DrawGrid1: TDrawGrid;
    DBText1: TDBText;
    DBEdit1: TDBEdit;
    DBListBox1: TDBListBox;
    DBCheckBox1: TDBCheckBox;
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
  RichEdit1.lines.loadfromfile('c:\html3.rtf');
end;

end.
