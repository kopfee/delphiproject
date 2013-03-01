unit USelection;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UToolForm, ActnList, ImgList, StdCtrls, ToolWin, ComCtrls, UTools,
  CheckLst;

type
  TfmSelection = class(TToolForm, ISimpleSelection, ISelection)
    ToolBar1: TToolBar;
    lsSelection: TCheckListBox;
    ActionList1: TActionList;
    acClear: TAction;
    acDelete: TAction;
    acMoveUp: TAction;
    acMoveDown: TAction;
    acAdd: TAction;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    acCopy: TAction;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    acAllChecked: TAction;
    acNoneChecked: TAction;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    procedure ActionList1Update(Action: TBasicAction;
      var Handled: Boolean);
    procedure acAddExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acClearExecute(Sender: TObject);
    procedure acMoveUpExecute(Sender: TObject);
    procedure acMoveDownExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lsSelectionDblClick(Sender: TObject);
    procedure acCopyExecute(Sender: TObject);
    procedure acAllCheckedExecute(Sender: TObject);
    procedure acNoneCheckedExecute(Sender: TObject);
  private
    { Private declarations }
    FAutoShow : Boolean;
    procedure SelectAll(Selected: Boolean);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public declarations }
    procedure ClearSelection;
    procedure AddSelected;
    procedure RemoveSelected;
    procedure AddSelectedComponent(Comp : TComponent);
    procedure RemoveSelectedComponent(Comp : TComponent);
    function  GetCount : Integer;
    function  GetSelectedComponent(Index : Integer) : TComponent;
    function  Checked(Index : Integer) : Boolean;
  end;

var
  fmSelection: TfmSelection;

implementation

uses UImages, UReportInspector, RPCtrls;

{$R *.DFM}

procedure TfmSelection.FormCreate(Sender: TObject);
begin
  inherited;
  DesignSelection := Self;
  FAutoShow := True;
end;

procedure TfmSelection.FormDestroy(Sender: TObject);
begin
  lsSelection.Items.Clear;
  DesignSelection := nil;
  inherited;
end;

procedure TfmSelection.AddSelectedComponent(Comp: TComponent);
begin
  if lsSelection.Items.IndexOfObject(Comp)<0 then
  begin
    Comp.FreeNotification(Self);
    lsSelection.Items.AddObject(GetDesignObjectName(Comp),Comp);
    lsSelection.Checked[lsSelection.Items.Count-1] := True;
    if FAutoShow then
      Visible := True;
  end;
end;

procedure TfmSelection.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if Operation=opRemove then
  begin
    RemoveSelectedComponent(AComponent);
  end;
end;

procedure TfmSelection.ActionList1Update(Action: TBasicAction;
  var Handled: Boolean);
var
  Selected : Boolean;
begin
  inherited;
  Handled := True;
  Selected := (lsSelection.ItemIndex>=0) and (lsSelection.Items.Count>0);
  acMoveUp.Enabled := Selected and (lsSelection.ItemIndex>0);
  acMoveDown.Enabled := Selected and (lsSelection.ItemIndex<lsSelection.Items.Count-1);
  acDelete.Enabled := Selected;
  acAdd.Enabled := ReportInspector.Selected is TRDCustomControl;
end;

procedure TfmSelection.acAddExecute(Sender: TObject);
begin
  inherited;
  AddSelected;
end;

procedure TfmSelection.acDeleteExecute(Sender: TObject);
begin
  inherited;
  lsSelection.Items.Delete(lsSelection.ItemIndex);
end;

procedure TfmSelection.acClearExecute(Sender: TObject);
begin
  inherited;
  lsSelection.Items.Clear;
end;

procedure TfmSelection.acMoveUpExecute(Sender: TObject);
var
  Index : Integer;
begin
  inherited;
  Index := lsSelection.ItemIndex;
  lsSelection.Items.Move(Index,Index-1);
  lsSelection.ItemIndex := Index-1;
end;

procedure TfmSelection.acMoveDownExecute(Sender: TObject);
var
  Index : Integer;
begin
  inherited;
  Index := lsSelection.ItemIndex;
  lsSelection.Items.Move(Index,Index+1);
  lsSelection.ItemIndex := Index+1;
end;

procedure TfmSelection.RemoveSelectedComponent(Comp : TComponent);
var
  I : Integer;
begin
  if not (csDestroying in ComponentState) then
  begin
    I := lsSelection.Items.IndexOfObject(Comp);
    if I>=0 then
      lsSelection.Items.Delete(I);
  end;
end;

function TfmSelection.GetCount: Integer;
begin
  Result := lsSelection.Items.Count;
end;

function TfmSelection.GetSelectedComponent(Index: Integer): TComponent;
begin
  Result := TComponent(lsSelection.Items.Objects[Index]);
end;

procedure TfmSelection.AddSelected;
begin
  if ReportInspector.Selected is TRDCustomControl then
    AddSelectedComponent(TComponent(ReportInspector.Selected));
end;

procedure TfmSelection.RemoveSelected;
begin
  if ReportInspector.Selected is TRDCustomControl then
    RemoveSelectedComponent(TComponent(ReportInspector.Selected));
end;

function TfmSelection.Checked(Index: Integer): Boolean;
begin
  Result := lsSelection.Checked[Index];
end;

procedure TfmSelection.lsSelectionDblClick(Sender: TObject);
begin
  inherited;
  if (lsSelection.ItemIndex>=0) and (GetCount>0) then
    ReportInspector.Selected := GetSelectedComponent(lsSelection.ItemIndex);
end;

procedure TfmSelection.acCopyExecute(Sender: TObject);
begin
  inherited;
  CopySelectionToClipboard(Self);
end;

procedure TfmSelection.ClearSelection;
begin
  lsSelection.Items.Clear;
end;

procedure TfmSelection.acAllCheckedExecute(Sender: TObject);
begin
  inherited;
  SelectAll(True);
end;

procedure TfmSelection.acNoneCheckedExecute(Sender: TObject);
begin
  inherited;
  SelectAll(False);
end;

procedure TfmSelection.SelectAll(Selected: Boolean);
var
  I : Integer;
begin
  for I:=0 to lsSelection.Items.Count-1 do
  begin
    lsSelection.Checked[I] := Selected;
  end;
end;

end.
