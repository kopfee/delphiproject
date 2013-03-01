unit DBTreeItems;

// %DBTreeItems : 继承TreeItems的类，处理来自数据库的层次信息
(*****   Code Written By Huang YanLai   *****)

interface

uses windows,sysutils,classes,IntfUtils,TreeItems,DB;

type
  TCustomDBTreeEnvir = class
  public
    ItemDataSet,                //  Contains all items
    ChildrenDataSet : TDataset;  // containa all its children
    CaptionFieldName : string;  // if CaptionFieldName='' caption is empty
    CanEdit : boolean;
  end;

  TDBTreeEnvir = class(TCustomDBTreeEnvir)
  public
    KeyFieldName : string;
    RootKey : string;
    RootExists : boolean;
    RootCaption : string;
    OnGotoVirtualTop : TNotifyEvent;
  end;

  TCustomDBTreeItem = class({TVCLInterfacedObject}TObject,IUnknown,ITreeItem,ITreeFolder)
  private
    FDBEnvir:   TCustomDBTreeEnvir;
    function    GetCaptionFieldName: string;
    function    GetChildrenDataSet: TDataSet;
    function    GetItemDataSet: TDataSet;
  protected
    FTreeData:  TTreeFolder;
    FParent :   TCustomDBTreeItem;
    //FOpened :   boolean;
    //function    GetIsFolder: boolean; virtual;
  public
    property    DBEnvir : TCustomDBTreeEnvir read FDBEnvir write FDBEnvir;
    property    ItemDataSet : TDataSet read GetItemDataSet;
    property    ChildrenDataSet : TDataSet read GetChildrenDataSet;
    property    CaptionFieldName : string read GetCaptionFieldName;
    function    BeforeOpen:boolean; virtual; // return if successful
    procedure   AfterOpen;  virtual;
    procedure   GetKeyFromDB(DataSet : TDataSet); virtual;
    function    GotoKey(DataSet : TDataSet):boolean; virtual;

    constructor Create(AParent : TCustomDBTreeItem); virtual;
    constructor CreateAsRoot(ADBEnvir : TCustomDBTreeEnvir); virtual;
    destructor  destroy; override;
    procedure   GetFromDB;
    procedure   GetDataFromDB;
    procedure   GetDataFromCurRow(DataSet : TDataset);virtual;

    //function    MyIsFolder : boolean;
    procedure 	MyOpen;
    //function    MyGetOpened: boolean;
    function    MyCanEdit   : boolean;
    procedure 	MySetCaption(const Value: string);

    property    TreeData : TTreeFolder read FTreeData
                  implements IUnknown,ITreeItem,ITreeFolder;
    procedure   ITreeFolder.open = MyOpen;
    //function    ITreeFolder.GetOpened = MyGetOpened;
    //function    ITreeFolder.IsFolder = MyIsFolder;
    //function    ITreeItem.IsFolder = MyIsFolder;
    function    ITreeItem.CanEdit = MyCanEdit;
    function    ITreeFolder.CanEdit = MyCanEdit;
    procedure 	ITreeItem.SetCaption = MySetCaption;
    procedure 	ITreeFolder.SetCaption = MySetCaption;
    //procedure 	Close;
  published

  end;

  TCustomDBTreeItemClass = class of TCustomDBTreeItem;

  TDBTreeItem = class(TCustomDBTreeItem)
  private
    function    GetKeyFieldName: string;
  protected
    FKey: string;
  public
    constructor CreateAsRoot(ADBEnvir : TCustomDBTreeEnvir); override;
    property    KeyFieldName : string read GetKeyFieldName;
    property    Key : string read FKey;
    procedure   GetKeyFromDB(DataSet : TDataSet); override;
    function    GotoKey(DataSet : TDataSet):boolean; override;
    procedure   GetDataFromCurRow(DataSet : TDataset); override;
    function    GotoVirtualTop:boolean; virtual;
  published

  end;

implementation


{ TCustomDBTreeItem }

constructor TCustomDBTreeItem.Create(AParent : TCustomDBTreeItem);
begin
  inherited Create;
  FParent := AParent;
  FDBEnvir := nil;
  // Notes : set ItemType after create
  if AParent<>nil then
  begin
    FTreeData := TTreeFolder.Create(self,AParent as ITreeFolder,0);
    {ItemDataSet := AParent.ItemDataSet;
    ChildrenDataSet := AParent.ChildrenDataSet;
    CaptionFieldName := AParent.CaptionFieldName;}
    FDBEnvir := AParent.DBEnvir;
  end
  else
    FTreeData := TTreeFolder.Create(self,nil,0);
end;

constructor TCustomDBTreeItem.CreateAsRoot(ADBEnvir: TCustomDBTreeEnvir);
begin
  Create(nil);
  FDBEnvir := ADBEnvir;
end;

destructor TCustomDBTreeItem.destroy;
begin
  FTreeData.free;
  inherited destroy;
end;
{
function TCustomDBTreeItem.MyGetOpened: boolean;
begin
  result := FOpened;
end;
}
procedure TCustomDBTreeItem.MyOpen;
var
  Child : TCustomDBTreeItem;
begin
  if (ItemDataSet=nil) or (ChildrenDataSet=nil) then
  begin
    //FOpened := false;
    TreeData.Opened := false;
    exit;
  end;
  if BeforeOpen then
  try
    ChildrenDataSet.First;
    while  not ChildrenDataSet.eof do
    begin
      Child := TCustomDBTreeItemClass(Self.ClassType).Create(self);
      Child.GetKeyFromDB(ChildrenDataSet);
      Child.GetDataFromCurRow(ChildrenDataSet);
      FTreeData.Add(Child);
      ChildrenDataSet.next;
    end;
    AfterOpen;
  except
    //FOpened := false;
    TreeData.Opened := false;
  end;
end;

{
function TCustomDBTreeItem.MyIsFolder: boolean;
begin
  result := GetIsFolder;
end;

function TCustomDBTreeItem.GetIsFolder: boolean;
begin
  result := true;
end;
}
procedure TCustomDBTreeItem.GetFromDB;
begin
  assert(ItemDataSet<>nil);
  GetKeyFromDB(ItemDataSet);
  GetDataFromDB;
end;

procedure TCustomDBTreeItem.GetDataFromDB;
begin
  assert(ItemDataSet<>nil);
  if GotoKey(ItemDataSet) then
    GetDataFromCurRow(ItemDataSet);
end;

procedure TCustomDBTreeItem.GetDataFromCurRow(DataSet: TDataset);
var
  Field : TField;
begin
  assert(DataSet<>nil);
  Field := DataSet.FindField(CaptionFieldName);
  if Field<>nil then
    TreeData.SetCaption(Field.AsString);
end;

procedure TCustomDBTreeItem.GetKeyFromDB(DataSet: TDataSet);
begin

end;


function TCustomDBTreeItem.GotoKey(DataSet: TDataSet): boolean;
begin
  result := false;
end;

function TCustomDBTreeItem.BeforeOpen: boolean;
begin
  FTreeData.Clear;
  //FOpened := false;
  TreeData.Opened := false;
  result := ItemDataSet.active and GotoKey(ItemDataSet);
end;

procedure TCustomDBTreeItem.AfterOpen;
begin
  //FOpened := true;
  TreeData.Opened := true;
end;


function TCustomDBTreeItem.GetCaptionFieldName: string;
begin
  if FDBEnvir<>nil then
    result:=FDBEnvir.CaptionFieldName
  else
    result:='';
end;

function TCustomDBTreeItem.GetChildrenDataSet: TDataSet;
begin
  if FDBEnvir<>nil then
    result := FDBEnvir.ChildrenDataSet
  else
    result := nil;
end;

function TCustomDBTreeItem.GetItemDataSet: TDataSet;
begin
  if FDBEnvir<>nil then
    result := FDBEnvir.ItemDataSet
  else
    result := nil;
end;

function TCustomDBTreeItem.MyCanEdit: boolean;
begin
  if DBEnvir<>nil then
    result := DBEnvir.CanEdit
               and (ItemDataSet<>nil)
               and ItemDataSet.active
               and GotoKey(ItemDataSet)
  else
    result := false;
end;

procedure TCustomDBTreeItem.MySetCaption(const Value: string);
begin
  if MyCanEdit then
  begin
    GotoKey(ItemDataSet);
    ItemDataSet.Edit;
    ItemDataSet.FieldByName(CaptionFieldName).AsString := Value;
    TreeData.Caption := value;
    ItemDataSet.Post;
  end;
end;

{ TDBTreeItem }


constructor TDBTreeItem.CreateAsRoot(ADBEnvir: TCustomDBTreeEnvir);
begin
  inherited CreateAsRoot(ADBEnvir);
  if DBEnvir<>nil then
  with DBEnvir as TDBTreeEnvir do
  begin
    Fkey := RootKey;
    if (ItemDataSet<>nil) and (ItemDataSet.active) then
      GetDataFromDB
    else
      TreeData.SetCaption(RootCaption);
  end;
end;

procedure TDBTreeItem.GetDataFromCurRow(DataSet: TDataset);
begin
  if (key=TDBTreeEnvir(DBEnvir).RootKey)
    and not TDBTreeEnvir(DBEnvir).RootExists then
    TreeData.SetCaption(TDBTreeEnvir(DBEnvir).RootCaption)
  else
    inherited GetDataFromCurRow(DataSet);
end;

function TDBTreeItem.GetKeyFieldName: string;
begin
  if DBEnvir<>nil then
    result := TDBTreeEnvir(DBEnvir).KeyFieldName
  else
    result := '';
end;

procedure TDBTreeItem.GetKeyFromDB(DataSet: TDataSet);
var
  Field : TField;
begin
  assert(DataSet<>nil);
  Field := DataSet.FindField(KeyFieldName);
  if Field<>nil then
    FKey := Field.AsString
  else
    Fkey := '';
end;

function  TDBTreeItem.GotoKey(DataSet : TDataSet):boolean;
begin
  assert(DataSet<>nil);
  if (key=TDBTreeEnvir(DBEnvir).RootKey)
    and not TDBTreeEnvir(DBEnvir).RootExists
  then result:=GotoVirtualTop
  else
    result := DataSet.Locate(KeyFieldName,key,[]);
end;


function TDBTreeItem.GotoVirtualTop: boolean;
begin
  if (DBEnvir<>nil) and
    Assigned(TDBTreeEnvir(DBEnvir).OnGotoVirtualTop) then
      TDBTreeEnvir(DBEnvir).OnGotoVirtualTop(self);
  result := true;
end;

end.
