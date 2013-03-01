unit UFoldView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ToolWin, ShlObj, ImgList,ShellUtils, KeyCap,
  ExtCtrls, TreeItems;

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
    cbPath: TComboBox;
    ToolButton3: TToolButton;
    ToolButton1: TToolButton;
    btnGoUp: TToolButton;
    ToolButton2: TToolButton;
    btnHiddens: TCheckBox;
    btnSort: TCheckBox;
    btnNonFoldres: TCheckBox;
    btnFolders: TCheckBox;
    StatusBar1: TStatusBar;
    edFilter: TEdit;
    cbFiltered: TCheckBox;
    EnterKeyCapture1: TEnterKeyCapture;
    cbEnterSub: TCheckBox;
    FolderView1: TFolderView;
    Splitter1: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure cbPathKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbPathClick(Sender: TObject);
    procedure btnLargeIconsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGoUpClick(Sender: TObject);
    procedure OptionsClick(Sender: TObject);
    procedure btnSortClick(Sender: TObject);
    procedure cbFilteredClick(Sender: TObject);
    procedure EnterKeyCapture1EnterPressed(Sender: TObject);
    procedure cbEnterSubClick(Sender: TObject);
  private
    ShellFolder : TShellFolder;
    procedure 	SetPath(const Value: string);
    procedure 	OnPathChanged(Sender: TObject);
    procedure 	OnItemsChanged(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses ShellAPI, ActiveX, ComObj, CommCtrl, FileCtrl;

{TForm1}

//GENERAL FORM METHODS

procedure TForm1.FormCreate(Sender: TObject);
begin
  ShellFolder := TShellFolder.Create(self);
  ShellFolder.sorted := true;
  ShellFolder.ListView := ListView;
  ShellFolder.OnPathChanged := OnPathChanged;
  ShellFolder.OnItemsChanged:=OnItemsChanged;
  ShellFolder.CanEnterSub := true;
  OnPathChanged(Sender);
  OnItemsChanged(Sender);
end;

procedure TForm1.btnBrowseClick(Sender: TObject);
var
  S: string;
begin
  S := '';
  if SelectDirectory('Select Directory', '', S) then
    SetPath(S);
end;

procedure TForm1.cbPathKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    SetPath(cbPath.Text);
    Key := 0;
  end;
end;

procedure TForm1.cbPathClick(Sender: TObject);
var
  I: Integer;
begin
  I := cbPath.Items.IndexOf(cbPath.Text);
  if I >= 0 then
    ShellFolder.PathID := (PItemIDList(cbPath.Items.Objects[I]))
  else
    SetPath(cbPath.Text);
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
  if (ShellFolder.Path<> '') and (cbPath.Items.IndexOf(ShellFolder.Path) < 0) then
    cbPath.Items.InsertObject(0,ShellFolder.Path,TObject(ShellFolder.PathID));
  cbPath.Text := ShellFolder.Path;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  i : integer;
begin
  for i:=0 to cbPath.items.count-1 do
  begin
    DisposePIDL(PItemIDList(cbPath.items.objects[i]));
  end;
end;

procedure TForm1.btnGoUpClick(Sender: TObject);
begin
  ShellFolder.Goup;
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

procedure TForm1.cbEnterSubClick(Sender: TObject);
begin
  ShellFolder.CanEnterSub := cbEnterSub.checked;
end;

end.
