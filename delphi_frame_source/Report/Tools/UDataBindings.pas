unit UDataBindings;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, RPDesignInfo, UToolForm, ExtCtrls, ImgList, ToolWin;

type
  TfmDataBindings = class(TToolForm)
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    lvBands: TListView;
    lvLabels: TListView;
    ToolBar1: TToolBar;
    btnRefresh: TToolButton;
    ImageList1: TImageList;
    procedure   SelectItem(Sender: TObject);
    procedure   btnRefreshClick(Sender: TObject);
  private
    { Private declarations }
    FLoading : Boolean;
    procedure   RemoveObject(Obj : TObject);
    function    FindObject(Obj : TObject): TListItem;
    procedure   FreshItem(Item : TListItem; Obj : TObject);
  protected
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public declarations }
    procedure   Clear;
    procedure   RefreshObjects; override;
    procedure   BeforeLoad; override;
    procedure   AfterLoad; override;
    procedure   Add(Obj : TObject); override;
    procedure   Changed(Obj : TObject); override;
  end;

var
  fmDataBindings: TfmDataBindings;

implementation

uses RPCtrls, UReportInspector, UTools;

{$R *.DFM}

{ TfmDataBindings }

procedure TfmDataBindings.Add(Obj: TObject);
var
  Node : TListItem;
begin
  if Obj is TRDRepeatBand then
    Node := lvBands.Items.Add
  else if Obj is TRDLabel then
    Node := lvLabels.Items.Add
  else Exit;
  Assert(Node<>nil);
  TComponent(Obj).FreeNotification(Self);
  Node.Data := Obj;
  FreshItem(Node,Obj);
end;

procedure TfmDataBindings.AfterLoad;
begin
  FLoading := False;
  RefreshObjects;
end;

procedure TfmDataBindings.BeforeLoad;
begin
  FLoading := True;
  Clear;
end;

procedure TfmDataBindings.Changed(Obj: TObject);
var
  Node : TListItem;
begin
  inherited;
  Node := FindObject(Obj);
  if Node<>nil then
    FreshItem(Node,Obj);
end;

procedure TfmDataBindings.Clear;
begin
  lvBands.Items.Clear;
  lvLabels.Items.Clear;
end;

function TfmDataBindings.FindObject(Obj: TObject): TListItem;
var
  Node : TListItem;
  i : integer;
  ListView: TListView;
begin
  Result := nil;
  if Obj is TRDRepeatBand then
    ListView := lvBands
  else if Obj is TRDLabel then
    ListView := lvLabels
  else
    Exit;
  for i:=0 to ListView.Items.Count-1 do
  begin
    Node := ListView.Items[i];
    if Node.Data=Obj then
    begin
      Result := Node;
      Break;
    end;
  end;
end;

procedure TfmDataBindings.FreshItem(Item: TListItem; Obj: TObject);
begin
  Assert(Item.Data=Obj);
  Assert(Obj is TControl);
  if Obj is TRDRepeatBand then
  begin
    Item.SubItems.Clear;
    Item.Caption := GetDesignObjectName(TControl(Obj));
    Item.SubItems.Add(TRDRepeatBand(Obj).ControllerName);
    Item.SubItems.Add(IntToStr(TRDRepeatBand(Obj).GroupIndex));
  end
  else if Obj is TRDLabel then
  begin
    Item.Caption := TRDLabel(Obj).Caption;
    Item.SubItems.Clear;
    Item.SubItems.Add(TRDLabel(Obj).FieldName);
  end
end;

procedure TfmDataBindings.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if not FLoading then
    if Operation=opRemove then
      RemoveObject(AComponent);
end;

procedure TfmDataBindings.RefreshObjects;
var
  i : integer;
  Comp : TComponent;
begin
  inherited;
  Clear;
  try
    lvBands.Items.BeginUpdate;
    lvLabels.Items.BeginUpdate;
    for i:=0 to ReportInfo.ComponentCount-1 do
    begin
      Comp := ReportInfo.Components[i];
      Add(Comp);
    end;
  finally
    lvBands.Items.EndUpdate;
    lvLabels.Items.EndUpdate;
  end;
end;

procedure TfmDataBindings.RemoveObject(Obj: TObject);
var
  Node : TListItem;
begin
  Node := FindObject(Obj);
  if Node<>nil then
    Node.Delete;
end;

procedure TfmDataBindings.SelectItem(Sender: TObject);
begin
  inherited;
  if TListView(Sender).Selected<>nil then
    ReportInspector.Selected := TObject(TListView(Sender).Selected.Data);
end;

procedure TfmDataBindings.btnRefreshClick(Sender: TObject);
begin
  inherited;
  RefreshObjects;
end;

end.
