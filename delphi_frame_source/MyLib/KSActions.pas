unit KSActions;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, ActnList, StdCtrls;

type
  TKSListAction = class(TAction)
  private
    FListBox: TCustomListBox;
    function    GetControl(Target: TObject): TCustomListBox; virtual;
    procedure   SetListBox(const Value: TCustomListBox);
  protected
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    function    HandlesTarget(Target: TObject): Boolean; override;
    procedure   UpdateTarget(Target: TObject); override;
  published
    property    ListBox : TCustomListBox read FListBox write SetListBox;
  end;

  TKSListMoveUp = class(TKSListAction)
  public
    procedure   ExecuteTarget(Target: TObject); override;
    procedure   UpdateTarget(Target: TObject); override;
  end;

  TKSListMoveDown = class(TKSListAction)
  public
    procedure   ExecuteTarget(Target: TObject); override;
    procedure   UpdateTarget(Target: TObject); override;
  end;

  TKSListDelete = class(TKSListAction)
  public
    procedure   ExecuteTarget(Target: TObject); override;
  end;

implementation

{ TKSListAction }

function TKSListAction.GetControl(Target: TObject): TCustomListBox;
begin
  Assert(Target is TCustomListBox);
  Result := TCustomListBox(Target);
end;

function TKSListAction.HandlesTarget(Target: TObject): Boolean;
begin
  // 如果指定了FListBox，那么只对指定的处理，否则处理有可能的控件。
  Result := ((FListBox<>nil) and (Target=FListBox)) or
    ((FListBox=nil) and (Target is TCustomListBox)){ and TCustomListBox(Target).Focused};
end;

procedure TKSListAction.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent=FListBox) and (Operation=opRemove) then
    FListBox:=nil;
end;

procedure TKSListAction.SetListBox(const Value: TCustomListBox);
begin
  if FListBox <> Value then
  begin
    FListBox := Value;
    if FListBox<>nil then
      FListBox.FreeNotification(Self);
  end;
end;

procedure TKSListAction.UpdateTarget(Target: TObject);
begin
  Enabled := GetControl(Target).ItemIndex>=0;
end;

{ TKSListMoveUp }

procedure TKSListMoveUp.ExecuteTarget(Target: TObject);
var
  SavedIndex, NewIndex : Integer;
begin
  with GetControl(Target) do
  begin
    SavedIndex := ItemIndex;
    NewIndex := SavedIndex-1;
    Items.Move(SavedIndex,NewIndex);
    ItemIndex := NewIndex;
  end;
end;

procedure TKSListMoveUp.UpdateTarget(Target: TObject);
begin
  with GetControl(Target) do
    Self.Enabled := (ItemIndex>=0) and (ItemIndex>0);
end;

{ TKSListMoveDown }

procedure TKSListMoveDown.ExecuteTarget(Target: TObject);
var
  SavedIndex, NewIndex : Integer;
begin
  with GetControl(Target) do
  begin
    SavedIndex := ItemIndex;
    NewIndex := SavedIndex+1;
    Items.Move(SavedIndex,NewIndex);
    ItemIndex := NewIndex;
  end;
end;

procedure TKSListMoveDown.UpdateTarget(Target: TObject);
begin
  with GetControl(Target) do
    Self.Enabled := (ItemIndex>=0) and (ItemIndex<Items.Count-1);
end;

{ TKSListDelete }

procedure TKSListDelete.ExecuteTarget(Target: TObject);
var
  SavedIndex : Integer;
begin
  with GetControl(Target) do
  begin
    SavedIndex := ItemIndex;
    Items.Delete(ItemIndex);
    if SavedIndex>=Items.Count then
      SavedIndex:=Items.Count-1;
    ItemIndex := SavedIndex;
  end;
end;

end.
