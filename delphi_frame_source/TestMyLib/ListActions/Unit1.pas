unit Unit1;

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
    procedure btnAddClick(Sender: TObject);
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

end.
