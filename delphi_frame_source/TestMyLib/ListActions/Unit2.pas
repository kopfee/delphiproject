unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, KSActions, ActnList, CheckLst, WVCtrls;

type
  TForm1 = class(TForm)
    ActionList1: TActionList;
    KSListDelete1: TKSListDelete;
    KSListMoveDown1: TKSListMoveDown;
    KSListMoveUp1: TKSListMoveUp;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    edNewItem: TEdit;
    btnAdd: TButton;
    CheckListBox1: TCheckListBox;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Label2: TLabel;
    edNewItem2: TEdit;
    btnAdd2: TButton;
    CheckListBox2: TCheckListBox;
    procedure btnAddClick(Sender: TObject);
    procedure btnAdd2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnAddClick(Sender: TObject);
begin
  CheckListBox1.Items.Add(edNewItem.Text);
end;

procedure TForm1.btnAdd2Click(Sender: TObject);
begin
  CheckListBox2.Items.Add(edNewItem2.Text);
end;

end.
