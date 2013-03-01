unit UShellView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ToolWin, ShlObj, ImgList,ShellUtils, KeyCap,
  ExtCtrls, TreeItems,UFolderItem;

type
  TForm1 = class(TForm)
    ListView: TListView;
    CoolBar1: TCoolBar;
    ToolBar2: TToolBar;
    ToolbarImages: TImageList;
    btnBrowse: TToolButton;
    btnLargeIcons: TToolButton;
    btnSmallIcons: TToolButton;
    btnList: TToolButton;
    btnReport: TToolButton;
    ToolButton3: TToolButton;
    ToolButton2: TToolButton;
    btnHiddens: TCheckBox;
    btnSort: TCheckBox;
    StatusBar1: TStatusBar;
    edFilter: TEdit;
    cbFiltered: TCheckBox;
    EnterKeyCapture1: TEnterKeyCapture;
    Tree: TFolderView;
    Splitter1: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnLargeIconsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OptionsClick(Sender: TObject);
    procedure btnSortClick(Sender: TObject);
    procedure cbFilteredClick(Sender: TObject);
    procedure EnterKeyCapture1EnterPressed(Sender: TObject);
    procedure TreeChange(Sender: TObject; Node: TTreeNode);
  private
    ShellFolder : TShellFolder;
    Root : TShellFolderItem;
    procedure 	SetPath(const Value: string);
    procedure 	OnPathChanged(Sender: TObject);
    procedure 	OnItemsChanged(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses ShellAPI, ActiveX, ComObj, CommCtrl, FileCtrl,CompUtils;

{TForm1}

//GENERAL FORM METHODS

procedure TForm1.FormCreate(Sender: TObject);
begin
  ShellFolder := TShellFolder.Create(self);
  ShellFolder.sorted := true;
  ShellFolder.ListView := ListView;
  ShellFolder.OnPathChanged := OnPathChanged;
  ShellFolder.OnItemsChanged:=OnItemsChanged;
  ShellFolder.Options := [soNonFolders,soHiddens];
  OnPathChanged(Sender);
  OnItemsChanged(Sender);

  Root := TShellFolderItem.Create(nil);
  SetTreeViewImages(Tree,istNormal,GetSmallSysImages);
  //SetTreeViewImages(Tree,isNormal,GetNormalSysImages);
  Tree.RootItem := Root;
end;

procedure TForm1.btnBrowseClick(Sender: TObject);
var
  S: string;
begin
  S := '';
  if SelectDirectory('Select Directory', '', S) then
    SetPath(S);
end;

procedure TForm1.btnLargeIconsClick(Sender: TObject);
begin
  ListView.ViewStyle := TViewStyle((Sender as TComponent).Tag);
end;

procedure TForm1.SetPath(const Value: string);
begin
  ShellFolder.Path := Value;
end;

procedure TForm1.OnPathChanged(Sender: TObject);
begin
  //
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Root.free;
end;

procedure TForm1.OptionsClick(Sender: TObject);
begin
  with Sender as TCheckBox do
    if checked then
    	ShellFolder.options := ShellFolder.options
      	+ [TShellFolderOption(tag)]
    else
      ShellFolder.options := ShellFolder.options
      	- [TShellFolderOption(tag)];
end;

procedure TForm1.btnSortClick(Sender: TObject);
begin
  ShellFolder.sorted := btnSort.checked;
end;

procedure TForm1.OnItemsChanged(Sender: TObject);
begin
  StatusBar1.simpleText := 'Items count : '+ IntToStr(ShellFolder.count);
end;

procedure TForm1.cbFilteredClick(Sender: TObject);
begin
  ShellFolder.mask := edFilter.text;
  ShellFolder.filtered := cbFiltered.checked;
end;

procedure TForm1.EnterKeyCapture1EnterPressed(Sender: TObject);
begin
  ShellFolder.mask := edFilter.text;
end;

procedure TForm1.TreeChange(Sender: TObject; Node: TTreeNode);
begin
  if Tree.SelectedTreeItem<>nil then
    ShellFolder.PathID := TShellFolderItem(
        Tree.SelectedTreeItem.GetObject).ID;
end;

end.
