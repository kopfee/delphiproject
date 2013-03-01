unit UBookmarkMan;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons,iniFiles, ComCtrls, ExtCtrls;

type
  TdlgBookmarkMan = class(TForm)
    lvBookmarks: TListView;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    btnDelete: TBitBtn;
    btnRename: TBitBtn;
    btnView: TBitBtn;
    BitBtn2: TBitBtn;
    procedure btnDeleteClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure lvBookmarksColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvBookmarksCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure btnRenameClick(Sender: TObject);
  private
    { Private declarations }
    FBookmarks : TStrings;
    FSortType : integer;
    procedure fillData;
    procedure refreshData;
  public
    { Public declarations }
    function  execute(Bookmarks : TStrings):boolean;
  end;

var
  dlgBookmarkMan: TdlgBookmarkMan;

implementation

uses UMain;

{$R *.DFM}

{ TdlgBookMan }

function  TdlgBookmarkMan.execute(Bookmarks : TStrings):boolean;
begin
  assert(Bookmarks<>nil);
  FBookmarks := Bookmarks;
  fillData;
  result := ShowModal=mrOK;
  if result then
    refreshData;
end;

procedure TdlgBookmarkMan.btnDeleteClick(Sender: TObject);
begin
  if lvBookmarks.Selected<>nil then
    lvBookmarks.Selected.Delete;
end;

procedure TdlgBookmarkMan.btnViewClick(Sender: TObject);
begin
  if lvBookmarks.Selected<>nil then
    fmViewer.gotoPage(Integer(lvBookmarks.Selected.data));
end;

procedure TdlgBookmarkMan.fillData;
var
  i : integer;
  item : TListItem;
begin
  lvBookmarks.Items.Clear;
  lvBookmarks.Items.BeginUpdate;
  for i:=0 to FBookmarks.count-1 do
  begin
    item:=lvBookmarks.Items.Add;
    item.Caption:=FBookmarks[i];
    item.Data := FBookmarks.objects[i];
    item.SubItems.add(IntToStr(Integer(FBookmarks.objects[i])));
  end;
  lvBookmarks.Items.EndUpdate;
end;

procedure TdlgBookmarkMan.lvBookmarksColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  FSortType := Column.Index;
  lvBookmarks.AlphaSort;
end;

procedure TdlgBookmarkMan.lvBookmarksCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  case FSortType of
    0 : Compare := CompareText(Item1.caption,Item2.caption);
    1 : Compare := Integer(Item1.Data)-Integer(Item2.Data);
  else Compare:=0;
  end;
end;

procedure TdlgBookmarkMan.refreshData;
var
  i : integer;
  item : TListItem;
begin
  FBookmarks.Clear;
  for i:=0 to lvBookmarks.Items.count-1 do
  begin
    item:=lvBookmarks.Items[i];
    FBookmarks.AddObject(item.Caption,item.Data);
  end;
end;

procedure TdlgBookmarkMan.btnRenameClick(Sender: TObject);
begin
  if lvBookmarks.Selected<>nil then
    lvBookmarks.Selected.EditCaption;
end;

end.
