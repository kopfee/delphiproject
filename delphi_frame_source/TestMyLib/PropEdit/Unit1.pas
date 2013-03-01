unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,PECtrls, ComWriUtils, Buttons, CheckLst;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    CompEditor1: TCompEditor;
    PELink1: TPELink;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    CheckBox1: TCheckBox;
    Label4: TLabel;
    CheckBox2: TCheckBox;
    CompEditor2: TCompEditor;
    PELink2: TPELink;
    ckImmediate: TCheckBox;
    btnRefresh: TButton;
    btnUpdate: TButton;
    BitBtn1: TBitBtn;
    ComboBox1: TComboBox;
    CompEditor3: TCompEditor;
    PEComboLink1: TPEComboLink;
    Label5: TLabel;
    ComboBox2: TComboBox;
    PEComboLink2: TPEComboLink;
    CheckListBox1: TCheckListBox;
    CompEditor4: TCompEditor;
    CheckListLink1: TCheckListLink;
    CheckListBox2: TCheckListBox;
    CheckListLink2: TCheckListLink;
    ComboBox3: TComboBox;
    PEComboLink3: TPEComboLink;
    procedure ckImmediateClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.ckImmediateClick(Sender: TObject);
begin
  CompEditor1.Immediate:=ckImmediate.checked;
  CompEditor2.Immediate:=ckImmediate.checked;
  CompEditor3.Immediate:=ckImmediate.checked;
  CompEditor4.Immediate:=ckImmediate.checked;
end;

procedure TForm1.btnRefreshClick(Sender: TObject);
begin
  CompEditor1.RefreshProps;
  CompEditor2.RefreshProps;
  CompEditor3.RefreshProps;
  CompEditor4.RefreshProps;
end;

procedure TForm1.btnUpdateClick(Sender: TObject);
begin
	CompEditor1.UpdateProps;
  CompEditor2.UpdateProps;
  CompEditor3.UpdateProps;
  CompEditor4.UpdateProps;
end;

end.
