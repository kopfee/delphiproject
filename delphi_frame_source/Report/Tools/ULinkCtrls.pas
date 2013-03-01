unit ULinkCtrls;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, CheckLst, RPCtrls, ActnList, UTools;

type
  TdlgLinkCtrls = class(TForm, ISimpleSelection)
    lsCtrls: TCheckListBox;
    Panel1: TPanel;
    btnApply: TBitBtn;
    BitBtn2: TBitBtn;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    ActionList1: TActionList;
    acMoveUp: TAction;
    acMoveDown: TAction;
    rgLinkStyles: TRadioGroup;
    btnSelectAll: TBitBtn;
    btnSelectNone: TBitBtn;
    procedure ActionList1Update(Action: TBasicAction;
      var Handled: Boolean);
    procedure acMoveUpExecute(Sender: TObject);
    procedure acMoveDownExecute(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure btnSelectNoneClick(Sender: TObject);
  private
    { Private declarations }
    FChanged : Boolean;
    FSimpleSelection: TSimpleSelectionForCheckListBox;
    procedure DoApplyLink;
    procedure SelectAll(Selected : Boolean);
  public
    { Public declarations }
    function  Execute(SimpleBand : TRDSimpleBand) : Boolean;
    property  SimpleSelection : TSimpleSelectionForCheckListBox read FSimpleSelection implements ISimpleSelection;
  end;

var
  dlgLinkCtrls: TdlgLinkCtrls;

implementation

{$R *.DFM}

{ TdlgLinkCtrls }

procedure TdlgLinkCtrls.FormCreate(Sender: TObject);
begin
  FSimpleSelection := TSimpleSelectionForCheckListBox.Create(Self,lsCtrls);
end;

procedure TdlgLinkCtrls.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FSimpleSelection);
end;

function TdlgLinkCtrls.Execute(SimpleBand: TRDSimpleBand): Boolean;
var
  i : integer;
  Ctrl : TControl;
begin
  FChanged := False;
  lsCtrls.ItemIndex := 0;
  lsCtrls.Items.Clear;
  for i:=0 to SimpleBand.ControlCount-1 do
  begin
    Ctrl := SimpleBand.Controls[i];
    if Ctrl is TRDCustomControl then
    begin
      lsCtrls.Items.AddObject(GetDesignObjectName(Ctrl),Ctrl);
      lsCtrls.Checked[lsCtrls.Items.Count-1]:=True;
    end;
  end;
  ShowModal;
  Result := FChanged;
end;

procedure TdlgLinkCtrls.ActionList1Update(Action: TBasicAction;
  var Handled: Boolean);
begin
  acMoveUp.Enabled := lsCtrls.ItemIndex>0;
  acMoveDown.Enabled := (lsCtrls.ItemIndex>=0) and (lsCtrls.ItemIndex<lsCtrls.Items.Count-1);
end;

procedure TdlgLinkCtrls.acMoveUpExecute(Sender: TObject);
begin
  if lsCtrls.ItemIndex>0 then
    lsCtrls.Items.Exchange(lsCtrls.ItemIndex,lsCtrls.ItemIndex-1);
end;

procedure TdlgLinkCtrls.acMoveDownExecute(Sender: TObject);
begin
  if (lsCtrls.ItemIndex>=0) and (lsCtrls.ItemIndex<lsCtrls.Items.Count-1) then
    lsCtrls.Items.Exchange(lsCtrls.ItemIndex,lsCtrls.ItemIndex+1);
end;

procedure TdlgLinkCtrls.btnApplyClick(Sender: TObject);
begin
  DoApplyLink;
end;

procedure TdlgLinkCtrls.DoApplyLink;
var
  AStyle: TRDPosLinkStyle;
begin
  case rgLinkStyles.ItemIndex of
    0 : AStyle := lsNone;
    1 : AStyle := lsLeftAlign;
    2 : AStyle := lsLeftRightAlign;
    3 : AStyle := lsTopAlign;
    4 : AStyle := lsTopBottomAlign;
    5 : AStyle := lsLeftToRight;
    6 : AStyle := lsLeftToRight2;
    7 : AStyle := lsTopToBottom;
    8 : AStyle := lsTopToBottom2;
  else
    AStyle := lsNone;
  end;
  LinkControls(Self,AStyle);
  FChanged := True;
end;

procedure TdlgLinkCtrls.btnSelectAllClick(Sender: TObject);
begin
  SelectAll(True);
end;

procedure TdlgLinkCtrls.SelectAll(Selected: Boolean);
var
  I : Integer;
begin
  for I:=0 to lsCtrls.Items.Count-1 do
  begin
    lsCtrls.Checked[I] := Selected;
  end;
end;

procedure TdlgLinkCtrls.btnSelectNoneClick(Sender: TObject);
begin
  SelectAll(False);
end;

end.
