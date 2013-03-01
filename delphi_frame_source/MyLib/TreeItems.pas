unit TreeItems;

(*****   Code Written By Huang YanLai   *****)

interface

uses windows,Sysutils,classes,IntfUtils,
  SafeCode,ComWriUtils,ComCtrls,Commctrl;

type
  TTreeItemType = integer;

  ITreeItem   = interface;
  ITreeFolder = interface;

  ITreeItem   = interface
    ['{F732EE60-57AB-11D2-B3AB-0080C85570FA}']
    function    GetCaption: string;
    procedure 	SetCaption(const Value: string);
    function    GetItemType:TTreeItemType;
    function    GetParent:ITreeFolder;

    property 		Caption	  : string Read GetCaption Write SetCaption;
    property 		ItemType  : TTreeItemType Read GetItemType;
    property		Parent 	  : ITreeFolder read GetParent;

    procedure 	Delete;
    function    CanEdit   : boolean;
    function    CanDelete : boolean;
    function 		IsFolder  : boolean;
    // return the object that implements the interface.
    function    GetObject : TObject;
    // when attached to A TreeNode,
    // tree will call AfterAttach(TreeNode)
    procedure   AfterAttach(AttachTo : TObject);
  end;

  ITreeFolder = interface(ITreeItem)
    ['{F732EE61-57AB-11D2-B3AB-0080C85570FA}']
    function    GetOpened: boolean;
    function 		GetCount: integer;
    function 		GetChildren(index: integer): ITreeItem;

    property 		Opened: boolean	Read GetOpened ;
    procedure 	Open;
    procedure 	Close;
    // manage all items
    property		Count : integer read GetCount;
    property 		Children[index : integer] : ITreeItem Read GetChildren;
  end;

  TTreeItem = class(TVCLDelegateObject{,ITreeItem})
  private
    FParent   : ITreeFolder;
    FItemType : TTreeItemType;
    // implement ITreeItem
  public
    // FCaption is only for its owner to use
    FCaption  : string;

    constructor Create(AOwner:TObject; AParent : ITreeFolder;AItemType : TTreeItemType);
    // implement ITreeItem
    function    GetCaption: string;
    procedure 	SetCaption(const Value: string);
    function    GetItemType:TTreeItemType;
    function    GetParent:ITreeFolder;
    property 		Caption	  : string Read GetCaption Write SetCaption;
    property 		ItemType  : TTreeItemType Read GetItemType Write FItemType;
    property		Parent 	  : ITreeFolder read GetParent;
    procedure 	Delete; virtual;
    function    CanEdit   : boolean; //virtual;
    function    CanDelete : boolean; //virtual;
    function 		IsFolder  : boolean; //virtual;
    function    GetObject : TObject;
    procedure   AfterAttach(AttachTo : TObject);
  end;

  TMyTreeItem = class(TComponent,ITreeItem)
  private
    FTreeItem: TTreeItem;
  public
    constructor Create(AOwner : TComponent); override;
    property    TreeItem: TTreeItem read FTreeItem implements ITreeItem;
  end;

  TTreeFolder = class(TTreeItem{,IUnknown,ITreeItem,ITreeFolder})
  private
    FOpened   : boolean;
    FItems    : TObjectList;
  public
    FreeNodeWhenClose : boolean;
    constructor Create(AOwner:TObject; AParent : ITreeFolder;AItemType : TTreeItemType);
    destructor  destroy; override;
    // TreeItem implements ITreeItem
    function 		IsFolder  : boolean;
    function    GetOpened: boolean;
    function 		GetCount: integer;
    function 		GetChildren(index: integer): ITreeItem;
    procedure 	Open; //virtual;
    procedure 	Close; //virtual;
    // manage all items
    property 		Opened: boolean	Read FOpened write FOpened;
    property		Count : integer read GetCount;
    property 		Children[index : integer] : ITreeItem Read GetChildren;
    property    Items : TObjectList read FItems;
    procedure   Clear;
    procedure   Add(TreeItem:TObject);
  end;

  TFolderView = class(TTreeView)
  private
   { FFolderMan: TFolderMan;
    FOnInitItemImage: TInitImageIndexEvent;
    procedure SetFolderMan(const Value: TFolderMan);}
    function 	GetSelectedTreeItem: ITreeItem;
    function  GetRootItem: ITreeItem;
    procedure SetRootItem(const Value: ITreeItem);
  protected
    function 	CanEdit(Node: TTreeNode): Boolean; override;
    procedure Edit(const Item: TTVItem); override;
    function 	CanExpand(Node: TTreeNode): Boolean; override;
    function 	GetNodeFromItem(const Item: TTVItem): TTreeNode;
    function  InternalOpen(Node : TTreeNode; Reload : boolean):boolean;
    procedure Collapse(Node: TTreeNode); override;
  public
    //property  FolderMan : TFolderMan read FFolderMan write SetFolderMan;
    property 	SelectedTreeItem : ITreeItem Read GetSelectedTreeItem;
    function	OpenNode(Node : TTreeNode):boolean;
    function  UpdateNode(Node : TTreeNode):boolean;
    function	AddTreeItem(ParentNode : TTreeNode;
    						TreeItem : ITreeItem): TTreeNode;
    property  RootItem : ITreeItem Read GetRootItem write SetRootItem;
    function  ItemFromNode(Node: TTreeNode): ITreeItem;
    function  ItemObjectFromNode(Node: TTreeNode): TObject;
  published
   { property OnInitItemImage: TInitImageIndexEvent
    						Read FOnInitItemImage Write FOnInitItemImage;}
  end;

implementation

{ TTreeItem }

constructor TTreeItem.Create(AOwner: TObject; AParent : ITreeFolder;
  AItemType: TTreeItemType);
begin
  inherited Create(AOwner);
  FItemType := AItemType;
  FParent := AParent;
end;

function TTreeItem.CanDelete: boolean;
begin
  result := false;
end;

function TTreeItem.CanEdit: boolean;
begin
  result := false;
end;

procedure TTreeItem.Delete;
begin
  // do nothing.
end;

function TTreeItem.GetCaption: string;
begin
  result := FCaption;
end;

procedure TTreeItem.SetCaption(const Value: string);
begin
  FCaption := value;
end;

function TTreeItem.GetItemType: TTreeItemType;
begin
  result := FItemType;
end;

function TTreeItem.GetObject: TObject;
begin
  result := Owner;
end;

function TTreeItem.GetParent: ITreeFolder;
begin
  result := FParent;
end;

function TTreeItem.IsFolder: boolean;
begin
  result := false;
end;

procedure TTreeItem.AfterAttach(AttachTo: TObject);
begin
  // do nothing
end;

{ TMyTreeItem }

constructor TMyTreeItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTreeItem := TTreeItem.Create(self,nil,0);
end;

{ TTreeFolder }


constructor TTreeFolder.Create(AOwner: TObject; AParent: ITreeFolder;
  AItemType: TTreeItemType);
begin
  inherited Create(AOwner,AParent,AItemType);
  FItems := TObjectList.Create(true);
  FreeNodeWhenClose := false;
end;

destructor TTreeFolder.destroy;
begin
  FItems.free;
  inherited destroy;
end;

function TTreeFolder.GetChildren(index: integer): ITreeItem;
begin
  if FItems[index]<>nil then
    FItems[index].GetInterface(ITreeItem, result)
  else result:=nil;
end;

function TTreeFolder.GetCount: integer;
begin
  result := FItems.count;
end;

function TTreeFolder.GetOpened: boolean;
begin
  result := FOpened;
end;

procedure TTreeFolder.Open;
begin
  Fopened := true;
end;

procedure TTreeFolder.Close;
begin
  //Fopened := false;
  if FreeNodeWhenClose then
    Clear;
end;

procedure TTreeFolder.Add(TreeItem:TObject);
var
  intf : ITreeItem;
begin
  if (TreeItem<>nil) and
    (TreeItem.GetInterface(ITreeItem,intf)) then
    items.add(TreeItem)
  else RaiseInvalidParam;
end;

procedure TTreeFolder.Clear;
begin
  items.Clear;
  Fopened := false;
end;

function TTreeFolder.IsFolder: boolean;
begin
  result := true;
end;

{ TFolderView }

function TFolderView.CanEdit(Node: TTreeNode): Boolean;
begin
  result := inherited CanEdit(Node) and
    ITreeItem(node.data).CanEdit;
end;

function TFolderView.CanExpand(Node: TTreeNode): Boolean;
begin
  result := inherited CanExpand(Node)
  	and ITreeItem(Node.data).IsFolder;
  if result then result := OpenNode(Node);
end;

procedure TFolderView.Edit(const Item: TTVItem);
var
  Node: TTreeNode;
begin
  inherited Edit(Item);
  Node := GetNodeFromItem(Item);
  if Node<>nil then
    try
    	ITreeItem(Node.data).caption := Node.text;
    except
      Node.text := ITreeItem(Node.data).caption;
      raise ;
    end;
end;

function TFolderView.GetSelectedTreeItem: ITreeItem;
begin
  if selected=nil then
  	result := nil
  else
    result :=  ITreeItem(selected.data);
end;

function TFolderView.AddTreeItem(ParentNode: TTreeNode;
  TreeItem: ITreeItem): TTreeNode;
begin
  assert(TreeItem<>nil);
  result := Items.AddChildObject(ParentNode,
	  			TreeItem.caption,
        	pointer(TreeItem));
  result.HasChildren := TreeItem.IsFolder;
  TreeItem.AfterAttach(result);
  //TreeItem.TreeNode :=
  {if Assigned(FOnInitItemImage) then
    FOnInitItemImage(self,result,TreeItem);}
end;

function TFolderView.OpenNode(Node: TTreeNode): boolean;
{var
  i : integer;}
begin
  {assert(Node<>nil);
  if ITreeItem(Node.data).IsFolder then
  with ITreeItem(Node.data) as ITreeFolder do
  begin
    if not opened then
    begin // not yet open
      Node.DeleteChildren;

      Open;
      result := Opened;
      if result then
        for i:=0 to count-1 do
          AddTreeItem(node,Children[i]);
    end
    else result:=true // already opened
  end
  else result:=false; // not is folder}
  result := InternalOpen(Node,false);
end;
{
procedure TFolderView.SetFolderMan(const Value: TFolderMan);
begin
  if FFolderMan <> Value then
  begin
    if FFolderMan<>nil then
    	FFolderMan.FFolderView := nil;
    FFolderMan := Value;
    if FFolderMan<>nil then
	    FFolderMan.FFolderView := self;
    items.Clear;
    if (FFolderMan<>nil) and (FFolderMan.root<>nil) then
      AddTreeItem(nil,FFolderMan.root);
  end;
end;
}
function TFolderView.GetNodeFromItem(const Item: TTVItem): TTreeNode;
begin
  with Item do
    if (state and TVIF_PARAM) <> 0 then Result := Pointer(lParam)
    else Result := Items.GetNode(hItem);
end;


function TFolderView.GetRootItem: ITreeItem;
begin
  if Items.count=0 then
    result:=nil
  else
    result := ITreeItem(Items.GetFirstNode.Data);
end;

procedure TFolderView.SetRootItem(const Value: ITreeItem);
begin
  if GetRootItem<>value then
  begin
    items.Clear;
    if value<>nil then
    begin
      //items.AddChildObjectFirst(nil,
      AddTreeItem(nil,value);
    end;
  end;
end;

function TFolderView.ItemFromNode(Node: TTreeNode): ITreeItem;
begin
  if Node=nil then
    result  :=  nil
  else
    result  :=  ITreeItem(Node.data);
end;

function TFolderView.UpdateNode(Node: TTreeNode): boolean;
var
  Expanded : boolean;
begin
  Expanded := Node.Expanded;
  result := InternalOpen(Node,true);
  if Expanded then Node.Expand(false);
end;

function TFolderView.InternalOpen(Node: TTreeNode;
  Reload: boolean): boolean;
var
  i : integer;
begin
  assert(Node<>nil);
  {with ITreeFolder(Node.data) do
  begin
    if not opened then
    begin
      Node.DeleteChildren;
      Opened := true;
    end;
    if opened and (Node.Count=0) then
      for i:=0 to count-1 do
      begin
        AddTreeItem(node,items[i]);
      end;
    result := opened;
  end;}
  if ITreeItem(Node.data).IsFolder then
  with ITreeItem(Node.data) as ITreeFolder do
  begin
    if reload or not opened
      or (opened and (Node.count<>count)) then
    begin // not yet open
      try
        self.items.BeginUpdate;

        Node.DeleteChildren;

        Open;
        result := Opened;
        if result then
          for i:=0 to count-1 do
            AddTreeItem(node,Children[i]);
      finally
        self.items.EndUpdate;
      end;
    end
    else result:=true // already opened
  end
  else result:=false; // not is folder
end;

function TFolderView.ItemObjectFromNode(Node: TTreeNode): TObject;
var
  TreeItem : ITreeItem;
begin
  TreeItem := ItemFromNode(Node);
  if TreeItem=nil then
    result:=nil
  else
    result:=TreeItem.GetObject;
end;

procedure TFolderView.Collapse(Node: TTreeNode);
var
  TreeItem : ITreeItem;
begin
  inherited Collapse(Node);
  TreeItem := ItemFromNode(Node);
  if (TreeItem<>nil) and
    TreeItem.IsFolder then
  with (TreeItem as ITreeFolder) do
  begin
    Close;
    if Count<>Node.Count then
      Node.DeleteChildren;
  end;
end;

end.
