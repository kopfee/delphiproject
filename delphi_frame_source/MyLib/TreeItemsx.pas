unit TreeItemsx;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  ExtCtrls, ComCtrls,ComWriUtils,Commctrl;

type
	TTreeItemType = longword;
  TTreeItem = class;
  TTreeFolder = class;
  TTreeItemclass = class of TTreeItem;

  TTreeItem = class
  private
    FParent		: TTreeFolder;
    procedure 	SetCaption(const Value: string); virtual;
    procedure 	SetModified(const Value: boolean); virtual;
  protected
    FModified	: boolean;
    FCaption	: string;
    FItemType	: TTreeItemType;
  public
    constructor Create(AParent : TTreeFolder); virtual;
    property 		Caption	: string Read FCaption Write SetCaption;
    property 		ItemType: TTreeItemType Read FItemType;
    property		Parent 	: TTreeFolder read FParent;
    function 		IsFolder: boolean; virtual;
    property 		Modified : boolean Read FModified Write SetModified;
    procedure 	Delete;
  published

  end;

  TTreeFolder = class(TTreeItem)
  private
    FOpened		: boolean;
    FChilrenModified: boolean;
    procedure 	SetOpened(const Value: boolean);
    function 		GetCount: integer;
    function 		GetItems(index: integer): TTreeItem;
  protected
    FItems 		: TObjectList;
    procedure 	ItemChanged(Item : TTreeItem); virtual;
  public
    constructor Create(AFolder : TTreeFolder); override;
    destructor 	destroy; override;

    function 		IsFolder: boolean; override;
    // set ChilrenModified when a child item changed, or
    // add / delete a item.
    property 		ChilrenModified : boolean
    							Read FChilrenModified Write FChilrenModified;

    property 		Opened: boolean	Read FOpened Write SetOpened;
    procedure 	Open; virtual; abstract;
    procedure 	Save; virtual; abstract;
    procedure 	Close; virtual;
    // manage all items
    property		Count : integer read GetCount;
    property 		Items[index : integer] : TTreeItem Read GetItems;
    function 		NewItem(AItemType : TTreeItemType): TTreeItem; virtual;
    function 		DeleteItem(Item : TTreeItem):boolean ;
    class function  ItemClass(AItemType : TTreeItemType)
    						: TTreeItemClass; virtual; abstract;
  published

  end;

  TFolderMan = class;
  TFolderView = class;

  TFolderMan = class
  private
    FFolderView: TFolderView;
    FRoot: TTreeFolder;
    procedure SetFolderView(const Value: TFolderView);
  public
    constructor Create(ARoot : TTreeFolder;
    							AFolderView : TFolderView);
    destructor 	Destroy; override;
    property		Root : TTreeFolder read FRoot;
    property 		FolderView : TFolderView read FFolderView write SetFolderView;
    function 		CanEdit(Item : TTreeItem): Boolean; virtual;
  end;

  TInitImageIndexEvent = procedure (Sender: TFolderView;
  		Node: TTreeNode;
      TreeItem : TTreeItem) of object;

  TFolderView = class(TTreeView)
  private
    FFolderMan: TFolderMan;
    FOnInitItemImage: TInitImageIndexEvent;
    procedure SetFolderMan(const Value: TFolderMan);
    function 	GetSelectedTreeItem: TTreeItem;
  protected
    function 	CanEdit(Node: TTreeNode): Boolean; override;
    procedure Edit(const Item: TTVItem); override;
    function 	CanExpand(Node: TTreeNode): Boolean; override;
    function 	GetNodeFromItem(const Item: TTVItem): TTreeNode;
  public
    property  FolderMan : TFolderMan read FFolderMan write SetFolderMan;
    property 	SelectedTreeItem : TTreeItem Read GetSelectedTreeItem;
    function	OpenNode(Node : TTreeNode):boolean;
    function	AddTreeItem(ParentNode : TTreeNode;
    						TreeItem : TTreeItem): TTreeNode;
  published
    property OnInitItemImage: TInitImageIndexEvent
    						Read FOnInitItemImage Write FOnInitItemImage;
  end;

implementation

{ TTreeItem }

constructor TTreeItem.Create(AParent: TTreeFolder);
begin
  inherited Create;
  FParent 		:= AParent;
end;

procedure TTreeItem.Delete;
begin
  if parent<>nil then parent.deleteItem(self);
end;

function TTreeItem.IsFolder: boolean;
begin
  result := false;
end;


procedure TTreeItem.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Modified := true;
  end;
end;

procedure TTreeItem.SetModified(const Value: boolean);
begin
  FModified := Value;
  if FModified and (Parent<>nil) then
    Parent.ItemChanged(self);
end;

{ TTreeFolder }

constructor TTreeFolder.Create(AFolder: TTreeFolder);
begin
  inherited Create(AFolder);
  FItems := TObjectList.Create(true);
  FOpened := false;
  FModified := false;
  FChilrenModified := false;
end;


destructor TTreeFolder.destroy;
begin
  Close;
  FItems.free;
  inherited destroy;
end;

function TTreeFolder.GetCount: integer;
begin
  result := FItems.count;
end;


procedure TTreeFolder.Close;
begin
  //if opened and modified then Save;
  FItems.clear;
  FOpened := false;
  FModified := false;
  FChilrenModified := false;
end;

function TTreeFolder.NewItem(AItemType : TTreeItemType): TTreeItem;
var
  AClass : TTreeItemClass;
begin
  AClass := ItemClass(AItemType);
  if AClass<>nil then
  begin
    result := AClass.Create(self);
	  FItems.Add(result);
    FChilrenModified := true;
  end
  else result:=nil;
end;

procedure TTreeFolder.SetOpened(const Value: boolean);
begin
  if FOpened <> Value then
  begin
    if value then open else close;
  end;
end;

function TTreeFolder.GetItems(index: integer): TTreeItem;
begin
  result := TTreeItem(FItems[index]);
end;

function TTreeFolder.DeleteItem(Item: TTreeItem): boolean;
begin
  result := FItems.Remove(Item)>=0;
  FChilrenModified := true;
end;

function TTreeFolder.IsFolder: boolean;
begin
  result := true;
end;

procedure TTreeFolder.ItemChanged(Item: TTreeItem);
begin
  FChilrenModified := true;
end;

{ TFolderMan }

function TFolderMan.CanEdit(Item: TTreeItem): Boolean;
begin
  result := true;
end;

constructor TFolderMan.Create(ARoot: TTreeFolder;
  AFolderView: TFolderView);
begin
  inherited Create;
  FRoot :=ARoot;
  FFolderView:=AFolderView;
  AFolderView.FFolderMan := self;
end;

destructor TFolderMan.Destroy;
begin
  FFolderView.FolderMan := nil;
  FRoot.free;
  inherited Destroy;
end;

procedure TFolderMan.SetFolderView(const Value: TFolderView);
begin
  if FFolderView <> Value then
  begin
    if FFolderView<>nil then
    	FFolderView.FFolderMan := nil;
    FFolderView := Value;
    if FFolderView<>nil then
	    FFolderView.FolderMan := self;
  end;
end;

{ TFolderView }

function TFolderView.CanEdit(Node: TTreeNode): Boolean;
begin
  result := inherited CanEdit(Node);
  if result and (FolderMan<>nil) then
  	result := FolderMan.CanEdit(TTreeItem(Node.data));
end;

function TFolderView.CanExpand(Node: TTreeNode): Boolean;
begin
  result := inherited CanExpand(Node)
  	and TTreeItem(Node.data).IsFolder;
  if result then result := OpenNode(Node);
end;

procedure TFolderView.Edit(const Item: TTVItem);
var
  Node: TTreeNode;
begin
  inherited Edit(Item);
  Node := GetNodeFromItem(Item);
  if Node<>nil then
  	TTreeItem(Node.data).caption := Node.text;
end;

function TFolderView.GetSelectedTreeItem: TTreeItem;
begin
  if selected=nil then
  	result := nil
  else
    result := TTreeItem(selected.data);
end;

function TFolderView.AddTreeItem(ParentNode: TTreeNode;
  TreeItem: TTreeItem): TTreeNode;
begin
  result := Items.AddChildObject(ParentNode,
	  			TreeItem.caption,
        	TreeItem);
  result.HasChildren := TreeItem.IsFolder;
  if Assigned(FOnInitItemImage) then
    FOnInitItemImage(self,result,TreeItem);
end;

function TFolderView.OpenNode(Node: TTreeNode): boolean;
var
  i : integer;
begin
  assert(Node<>nil);
  with TTreeFolder(Node.data) do
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
  end;
end;

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

function TFolderView.GetNodeFromItem(const Item: TTVItem): TTreeNode;
begin
  with Item do
    if (state and TVIF_PARAM) <> 0 then Result := Pointer(lParam)
    else Result := Items.GetNode(hItem);
end;

end.
