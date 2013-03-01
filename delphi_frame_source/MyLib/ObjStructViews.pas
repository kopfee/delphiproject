unit ObjStructViews;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Imglist, TypUtils, menus, ActnList;

type
  TTreeViewAccess = class(TCustomTreeView);
  TObjStructViews = class;

  TAddObjectEvent = procedure (View : TObjStructViews; Obj : TObject; var ACaption : string; AParent : TTreeNode; var AddIt : Boolean) of object;
  TUpdateObjectEvent = procedure (View : TObjStructViews; Obj : TObject; Node : TTreeNode) of object;
  TGetCaptionEvent = procedure (View : TObjStructViews; Obj : TObject; var ACaption : string) of object;
  TFilterChildrenEvent = procedure (View : TObjStructViews; Obj : TObject; var ViewControl,ViewComponents,ViewCollection : Boolean) of object;
  TOnDeleteObjectEvent = procedure (View : TObjStructViews; Obj : TObject; var DeleteIt : Boolean) of object;

  TObjStructViews = class(TWinControl)
  private
    FRoot: TObject;
    FOnSelectedChanged: TNotifyEvent;
    FReadOnly: Boolean;
    FOnUpdateMenu: TNotifyEvent;
    FViewControls: Boolean;
    FViewComponents: Boolean;
    FViewCollection: Boolean;
    FOnUpdateObject: TUpdateObjectEvent;
    FOnAddObject: TAddObjectEvent;
    FOnFilterChildren: TFilterChildrenEvent;
    FOnGetCaption: TGetCaptionEvent;
    FOnDeleteObject: TOnDeleteObjectEvent;
    FDeleteAction: TAction;
    FAddItemAction: TAction;
    FActionList: TActionList;
    FOnCanDeleteObject: TOnDeleteObjectEvent;
    FOnModified: TNotifyEvent;
    procedure   SetRoot(const Value: TObject);
    procedure   SetImages(const Value: TCustomImageList);
    function    GetSelected: TObject;
    function    GetTreeView: TTreeView;
    function    GetImages: TCustomImageList;
    procedure   SetSelected(const Value: TObject);
  protected
    FTree :     TTreeViewAccess;
    FPopupMenu: TPopupMenu;
    FMIAddCollectionItem : TMenuItem;
    FMIDelete : TMenuItem;
    function    CreateTreeView : TCustomTreeView; virtual;
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure   TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure   DoDeleteObject(Sender : TObject);
    procedure   DoAddCollectionItem(Sender : TObject);
    procedure   DoUpdateMenu(Sender : TObject);
    procedure   DoUpdateAction(Action: TBasicAction; var Handled: Boolean);
    procedure   Loaded; override;
    procedure   Modified;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
    procedure   RecreateStructTree;
    function    AddItem(Obj : TObject; const ACaption : string; AParent : TTreeNode): TTreeNode;
    function    GetObjectCaption(Obj : TObject; const Default:string=''): string; virtual;
    function    CanAddCollectionItem : Boolean;
    function    CanDeleteObject: Boolean;
    procedure   DeleteSelected;
    procedure   AddCollectionItem;
    procedure   UpdateNode(Node : TTreeNode);
    procedure   UpdateSelected;
    function    FindObject(Obj : TObject): TTreeNode;
    procedure   AddObject(Obj : TObject);
    procedure   DeleteObject(Obj : TObject);

    property    Root : TObject read FRoot write SetRoot;
    property    Selected : TObject read GetSelected write SetSelected;
    property    TreeView : TTreeView read GetTreeView;
    property    PopupMenu : TPopupMenu read FPopupMenu;
    property    MIAddCollectionItem : TMenuItem read FMIAddCollectionItem;
    property    MIDelete : TMenuItem read FMIDelete;
    property    ActionList : TActionList read FActionList;
    property    DeleteAction : TAction read FDeleteAction;
    property    AddItemAction : TAction read FAddItemAction;
  published
    property    ReadOnly : Boolean read FReadOnly write FReadOnly;
    property    Images: TCustomImageList read GetImages write SetImages;
    property    ViewControls : Boolean read FViewControls write FViewControls default True;
    property    ViewComponents : Boolean read FViewComponents write FViewComponents default True;
    property    ViewCollection : Boolean read FViewCollection write FViewCollection default True;
    property    OnSelectedChanged : TNotifyEvent read FOnSelectedChanged write FOnSelectedChanged;
    property    OnUpdateMenu : TNotifyEvent read FOnUpdateMenu write FOnUpdateMenu;
    property    OnAddObject : TAddObjectEvent read FOnAddObject write FOnAddObject;
    property    OnUpdateObject : TUpdateObjectEvent read FOnUpdateObject write FOnUpdateObject;
    property    OnGetCaption : TGetCaptionEvent read FOnGetCaption write FOnGetCaption;
    property    OnFilterChildren : TFilterChildrenEvent read FOnFilterChildren write FOnFilterChildren;
    property    OnDeleteObject : TOnDeleteObjectEvent read FOnDeleteObject write FOnDeleteObject;
    property    OnCanDeleteObject : TOnDeleteObjectEvent read FOnCanDeleteObject write FOnCanDeleteObject;
    property    OnModified : TNotifyEvent read FOnModified write FOnModified;
    property Align;
    property Anchors;
    property BiDiMode;
    property Color default clWindow;
    property Constraints;
    property Ctl3D;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBiDiMode;
    property ParentColor default False;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDockDrop;
    property OnDockOver;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

resourcestring
  SADD = 'Add Item';
  SDelete = 'Delete';

implementation

{ TObjStructViews }

constructor TObjStructViews.Create(AOwner: TComponent);
begin
  inherited;
  ParentColor := False;
  Color := clWindow;
  Width := 100;
  Height := 50;
  FViewControls := True;
  FViewComponents := True;
  FViewCollection := True;
  // Actions
  FActionList:= TActionList.Create(Self);
  FActionList.OnUpdate := DoUpdateAction;
  FAddItemAction:= TAction.Create(Self);
  FAddItemAction.ActionList := FActionList;
  FAddItemAction.Caption := SADD;
  FAddItemAction.OnExecute := DoAddCollectionItem;
  FDeleteAction:= TAction.Create(Self);
  FDeleteAction.ActionList := FActionList;
  FDeleteAction.Caption := SDELETE;
  FDeleteAction.OnExecute := DoDeleteObject;
  // Menu Items
  FPopupMenu := TPopupMenu.Create(Self);
  FPopupMenu.OnPopup := DoUpdateMenu;
  FMIAddCollectionItem := TMenuItem.Create(Self);
  FMIAddCollectionItem.Action := AddItemAction;
  FPopupMenu.Items.Add(FMIAddCollectionItem);
  FMIDelete := TMenuItem.Create(Self);
  FMIDelete.Action := DeleteAction;
  FPopupMenu.Items.Add(FMIDelete);

  FTree := TTreeViewAccess(CreateTreeView);
  FTree.Align := alClient;
  FTree.Parent := Self;
  FTree.ParentFont := True;
  FTree.ParentColor := True;
  FTree.ReadOnly := True;
  FTree.HideSelection := False;
  FTree.PopupMenu := FPopupMenu;
  FTree.OnChange := TreeViewChange;
end;

function TObjStructViews.CreateTreeView: TCustomTreeView;
begin
  Result := TTreeView.Create(Self);
end;

destructor TObjStructViews.Destroy;
begin
  inherited;
end;

procedure TObjStructViews.SetRoot(const Value: TObject);
begin
  if FRoot <> Value then
  begin
    FRoot := Value;
    RecreateStructTree;
  end;
end;

procedure TObjStructViews.RecreateStructTree;
begin
  try
    FTree.Items.BeginUpdate;
    FTree.Items.Clear;
    if Root<>nil then
      AddItem(Root,GetObjectCaption(Root),nil);
  finally
    FTree.Items.EndUpdate;
  end;
end;

function TObjStructViews.AddItem(Obj: TObject; const ACaption : string;
  AParent: TTreeNode): TTreeNode;
var
  i : integer;
  Comp : TObject;
  Properties : TPropertyAnalyse;
  TheCaption : string;
  AddIt : Boolean;
  aViewControls,aViewComponents,aViewCollection : Boolean;
  IsChild : Boolean;
begin
  Assert(Obj<>nil);
  TheCaption := ACaption;
  AddIt := true;
  Result := nil;
  if Assigned(FOnAddObject) then
    FOnAddObject(Self,Obj,TheCaption,AParent,AddIt);
  if not AddIt then
    Exit;
  Result := FTree.Items.AddChild(AParent,ACaption);
  Result.Data := Obj;
  if Assigned(FOnUpdateObject) then
    FOnUpdateObject(Self,Obj,Result);
  aViewControls:=ViewControls;
  aViewComponents:=ViewComponents;
  aViewCollection:=ViewCollection;
  if Assigned(FOnFilterChildren) then
    FOnFilterChildren(Self,Obj,aViewControls,aViewComponents,aViewCollection);
  // Add all collection properties
  if aViewCollection then
  begin
    Properties := TPropertyAnalyse.Create;
    try
      Properties.AnalysedObject := Obj;
      for i:=0 to Properties.PropCount-1 do
        if Properties.PropTypes[i]=ptClass then
        begin
          Comp := Properties.Properties[i].AsObject;
          if Comp is TCollection then
            AddItem(Comp,GetObjectCaption(Comp,Properties.Properties[i].PropName),Result);
        end;
    finally
      Properties.Free;
    end;
  end;
  // Add Collection Item
  if Obj is TCollection then
  with TCollection(Obj) do
  begin
    for i:=0 to Count-1 do
    begin
      Comp := Items[i];
      AddItem(Comp,GetObjectCaption(Comp),Result);
    end;
  end;

  // Add all child controls
  if aViewControls then
  begin
    if Obj is TWinControl then
    with TWinControl(Obj) do
    begin
      for i:=0 to ControlCount-1 do
      begin
        Comp := Controls[i];
        AddItem(Comp,GetObjectCaption(Comp),Result);
      end;
    end;
  end;

  // Add all owned components
  if aViewComponents then
  begin
    if Obj is TComponent then
    with TComponent(Obj) do
    begin
      for i:=0 to ComponentCount-1 do
      begin
        Comp := Components[i];
        if not (Comp is TControl) then
          AddItem(Comp,GetObjectCaption(Comp),Result) else
        begin
          IsChild := False;
          Comp := TControl(Comp).Parent;
          while Comp<>nil do
          begin
            if Comp=Obj then
            begin
              IsChild := true;
              Break;
            end;
            Comp := TControl(Comp).Parent;
          end;
          Comp := Components[i];
          if not IsChild
            and ((TControl(Comp).Parent=nil) or (TControl(Comp).Parent.Owner<>Obj)) then
            AddItem(Comp,GetObjectCaption(Comp),Result);
        end;

      end;
    end;
  end;
end;

function TObjStructViews.GetObjectCaption(Obj: TObject; const Default:string=''): string;
begin
  if Obj is TComponent then
    Result := TComponent(Obj).Name
  else if Obj is TCollectionItem then
    Result := TCollectionItem(Obj).DisplayName;
  // default
  if Result='' then
    Result := Default;
  if Result='' then
    Result := Obj.ClassName;
  if Assigned(FOnGetCaption) then
    FOnGetCaption(Self,Obj,Result);
end;

procedure TObjStructViews.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

end;

function TObjStructViews.GetSelected: TObject;
begin
  if FTree.Selected<>nil then
    Result := TObject(FTree.Selected.Data) else
    Result := nil;
end;

procedure TObjStructViews.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  if Assigned(FOnSelectedChanged) then
  begin
    FOnSelectedChanged(Self);
  end;
end;

function TObjStructViews.GetTreeView: TTreeView;
begin
  Result := TTreeView(FTree);
end;

procedure TObjStructViews.SetImages(const Value: TCustomImageList);
begin
  FTree.Images := Value;
  FPopupMenu.Images := Value;
end;

function TObjStructViews.GetImages: TCustomImageList;
begin
  Result := FTree.Images;
end;

function TObjStructViews.CanAddCollectionItem: Boolean;
begin
  Result := (Selected is TCollection);
end;

function TObjStructViews.CanDeleteObject: Boolean;
begin
  Result := not (Selected is TCollection);
  if Assigned(FOnCanDeleteObject) then
    FOnCanDeleteObject(Self,Selected,Result);
end;

procedure TObjStructViews.DoAddCollectionItem(Sender: TObject);
begin
  AddCollectionItem;
end;

procedure TObjStructViews.DoDeleteObject(Sender: TObject);
var
  CanDelete : Boolean;
begin
  if Selected=nil then Exit;

  CanDelete := True;
  if Assigned(FOnDeleteObject) then
    FOnDeleteObject(Self,Selected,CanDelete);
  if CanDelete then
    DeleteSelected;
end;

procedure TObjStructViews.AddCollectionItem;
var
  Obj : TObject;
begin
  if CanAddCollectionItem then
  begin
    Obj := TCollection(Selected).Add;
    AddItem(Obj,GetObjectCaption(Obj),FTree.Selected);
    Modified;
  end;
end;

procedure TObjStructViews.DeleteSelected;
begin
  if CanDeleteObject then
  begin
    Selected.Free;
    FTree.Selected.Delete;
    Modified;
  end;
end;

procedure TObjStructViews.DoUpdateMenu(Sender: TObject);
begin
  if Assigned(FOnUpdateMenu) then
    FOnUpdateMenu(Self);
end;

procedure TObjStructViews.UpdateNode(Node: TTreeNode);
var
  Obj : TObject;
  ACaption : string;
begin
  Obj := TObject(Node.Data);
  if Obj<>nil then
  begin
    ACaption := GetObjectCaption(Obj,Node.Text);
    if Assigned(FOnUpdateObject) then
      FOnUpdateObject(Self,Obj,Node);
    Node.Text := ACaption;  
  end;
end;


procedure TObjStructViews.UpdateSelected;
begin
  if FTree.Selected<>nil then
    UpdateNode(FTree.Selected);
end;

procedure TObjStructViews.SetSelected(const Value: TObject);
var
  Node : TTreeNode;
begin
  Node := FindObject(Value);
  if Node<>nil then
    Node.Selected := True;
end;

procedure TObjStructViews.Loaded;
begin
  inherited;
end;

procedure TObjStructViews.AddObject(Obj: TObject);
var
  Node : TTreeNode;
begin
  Node := nil;
  if (Obj is TControl) and (TControl(Obj).Parent<>nil) then
    Node := FindObject(TControl(Obj).Parent);
  if (Node=nil) and (Obj is TComponent) and (TComponent(Obj).Owner<>nil) then
    Node := FindObject(TComponent(Obj).Owner);
  if Node<>nil then
    AddItem(Obj,GetObjectCaption(Obj),Node);
end;

function TObjStructViews.FindObject(Obj: TObject): TTreeNode;
var
  Node : TTreeNode;
begin
  if Selected<>Obj then
  begin
    Node := FTree.Items.GetFirstNode;
    while Node<>nil do
    begin
      if Node.Data=Obj then
      begin
        Break;
      end;
      Node := Node.GetNext;
    end;
  end else
    Node := FTree.Selected;
  Result := Node;
end;

procedure TObjStructViews.DeleteObject(Obj: TObject);
var
  Node : TTreeNode;
begin
  Node := FindObject(Obj);
  if Node<>nil then
    Node.Delete;
end;

procedure TObjStructViews.DoUpdateAction(Action: TBasicAction;
  var Handled: Boolean);
begin
  Handled := True;
  AddItemAction.Enabled := not ReadOnly and CanAddCollectionItem;
  DeleteAction.Enabled := not ReadOnly and CanDeleteObject;
end;

procedure TObjStructViews.Modified;
begin
  if Assigned(FOnModified) then
    FOnModified(self);
end;

end.
