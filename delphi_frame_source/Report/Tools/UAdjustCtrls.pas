unit UAdjustCtrls;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, CheckLst, Spin, RPDefines, RPCtrls,
  UAdjustCtrlFrame, UTools;

type
  TdlgAdjustCtrls = class(TForm, ISimpleSelection)
    lsCtrls: TCheckListBox;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    btnApply: TBitBtn;
    btnReadCtrlParams: TBitBtn;
    btnSelectAll: TBitBtn;
    btnSelectNone: TBitBtn;
    btnClear: TBitBtn;
    AdjustCtrlsFrame: TfaAdjustCtrls;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure lsCtrlsDblClick(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure btnSelectNoneClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  private
    { Private declarations }
    FModified : Boolean;
    FSimpleSelection: TSimpleSelectionForCheckListBox;
    procedure SelectAll(Selected : Boolean);
  public
    { Public declarations }
    function  Execute(SimpleBand : TRDSimpleBand) : Boolean;
    property  SimpleSelection : TSimpleSelectionForCheckListBox read FSimpleSelection implements ISimpleSelection;
  end;

var
  dlgAdjustCtrls: TdlgAdjustCtrls;

implementation

{$R *.DFM}

{ TdlgAdjustCtrls }

procedure TdlgAdjustCtrls.FormCreate(Sender: TObject);
begin
  FSimpleSelection := TSimpleSelectionForCheckListBox.Create(Self,lsCtrls);
end;

procedure TdlgAdjustCtrls.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FSimpleSelection);
end;

function TdlgAdjustCtrls.Execute(SimpleBand: TRDSimpleBand): Boolean;
var
  i : integer;
  Ctrl : TControl;
begin
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
  if lsCtrls.Items.Count>0 then
    AdjustCtrlsFrame.ReadCtrlParams(TRDCustomControl(lsCtrls.Items.Objects[0]));
  FModified := False;
  if ShowModal =  mrOk then
  begin
    FModified := True;
    AdjustCtrlsFrame.UpdateSelectedCtrls(Self);
  end;

  Result := FModified;
end;

procedure TdlgAdjustCtrls.btnApplyClick(Sender: TObject);
begin
  FModified := True;
  AdjustCtrlsFrame.UpdateSelectedCtrls(Self);
end;

procedure TdlgAdjustCtrls.lsCtrlsDblClick(Sender: TObject);
begin
  if lsCtrls.ItemIndex>=0 then
    AdjustCtrlsFrame.ReadCtrlParams(TRDCustomControl(lsCtrls.Items.Objects[lsCtrls.ItemIndex]));
end;

procedure TdlgAdjustCtrls.SelectAll(Selected: Boolean);
var
  I : Integer;
begin
  for I:=0 to lsCtrls.Items.Count-1 do
  begin
    lsCtrls.Checked[I] := Selected;
  end;
end;

procedure TdlgAdjustCtrls.btnSelectAllClick(Sender: TObject);
begin
  SelectAll(True);
end;

procedure TdlgAdjustCtrls.btnSelectNoneClick(Sender: TObject);
begin
  SelectAll(False);
end;

procedure TdlgAdjustCtrls.btnClearClick(Sender: TObject);
begin
  AdjustCtrlsFrame.ClearCheckBox;
end;

end.
