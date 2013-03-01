unit UFolderItem;

interface

uses Windows,Sysutils,Classes,ShellAPI,ShlObj,
      ShellUtils,TreeItems;

type
  TShellFolderEnvir = class
  private
    FShellFolder: TShellFolder;
  public
    property    ShellFolder : TShellFolder read FShellFolder;
    constructor Create;
    destructor  destroy; override;
  end;

  TShellFolderItem = class(TObject,IUnknown,ITreeItem,ITreeFolder)
  private
    FTreeData:  TTreeFolder;
    FParent:    TShellFolderItem;
    FEnvir:     TShellFolderEnvir;
    function    GetShellFolder: TShellFolder;
  protected
    FID :        PItemIDList;
    FImageIndex: integer;
  public
    constructor Create(AParent : TShellFolderItem); virtual;
    destructor  destroy; override;
    property    ShellFolder : TShellFolder read GetShellFolder;
    property    Parent : TShellFolderItem read FParent;
    property    Envir : TShellFolderEnvir read FEnvir;
    property    ID : PItemIDList read FID;
    property    ImageIndex : integer read FImageIndex;
    // implement interfaces
    procedure 	MyOpen;
    procedure   MyAfterAttach(AttachTo : TObject);

    property    TreeData : TTreeFolder read FTreeData
                  implements IUnknown,ITreeItem,ITreeFolder;
    procedure   ITreeFolder.open = MyOpen;
    procedure   ITreeFolder.AfterAttach = MyAfterAttach;
    procedure   ITreeItem.AfterAttach = MyAfterAttach;
  published

  end;

implementation

uses ComCtrls;

{ TShellFolderEnvir }

constructor TShellFolderEnvir.Create;
begin
  inherited Create;
  FShellFolder := TShellFolder.Create(nil);
  FShellFolder.sorted := true;
  FShellFolder.options := [soFolders,soHiddens];
end;

destructor TShellFolderEnvir.destroy;
begin
  FShellFolder.free;
  inherited destroy;
end;

{ TShellFolderItem }

constructor TShellFolderItem.Create(AParent: TShellFolderItem);
var
  hIcon : THandle;
begin
  inherited Create;
  FParent := AParent;
  if FParent<>nil then
  begin
    FEnvir := FParent.Envir;
    FTreeData := TTreeFolder.Create(self,AParent as ITreeFolder,0);
  end
  else
  begin
    FEnvir := TShellFolderEnvir.Create;
    FTreeData := TTreeFolder.Create(self,nil,0);
    FID := FEnvir.ShellFolder.PathID;
    FTreeData.Caption := FEnvir.ShellFolder.Path;
    GetIconByPID(GetDesktopID,[icsSmall],hIcon,FImageIndex);
  end;
end;

destructor TShellFolderItem.destroy;
begin
  FTreeData.free;
  if FParent=nil then
    FEnvir.free;
  DisposePIDL(ID);
  inherited destroy;
end;

function TShellFolderItem.GetShellFolder: TShellFolder;
begin
  if FEnvir<>nil then
    result := FEnvir.ShellFolder
  else
    result := nil;
end;

procedure TShellFolderItem.MyAfterAttach(AttachTo: TObject);
begin
  assert(AttachTo<>nil);
  TTreeNode(AttachTo).ImageIndex := ImageIndex;
  TTreeNode(AttachTo).SelectedIndex := ImageIndex;
end;

procedure TShellFolderItem.MyOpen;
var
  i : integer;
  child : TShellFolderItem;
  hIcon : THandle;
  iIcon : integer;
begin
  TreeData.Opened := false;
  TreeData.Clear;
  if ShellFolder<>nil then
  begin
    ShellFolder.PathID := ID;
    //ShellFolder.CheckShellItems(0,ShellFolder.count-1);
    for i:=0 to ShellFolder.count-1 do
    begin
      child := TShellFolderItem.Create(self);
      child.FID := ConcatPIDLs(ID, ShellFolder.ShellItems[i].ID);
      child.TreeData.Caption := ShellFolder.ShellItems[i].DisplayName;
      //Child.ImageIndex := ShellFolder.ShellItems[i].NormalImageIndex;
      //Child.ImageIndex := ShellFolder.ShellItems[i].SmallImageIndex;
      GetIconByPID(child.ID,[icsSmall],hIcon,iIcon);
      Child.FImageIndex := iIcon;
      TreeData.Add(child);
    end;
    TreeData.Opened := true;
  end;
end;

end.
