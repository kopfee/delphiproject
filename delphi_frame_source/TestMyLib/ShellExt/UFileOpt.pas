unit UFileOpt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ToolWin, ComCtrls, ShellUtils, ImgList, Buttons;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    ShellFolder1: TShellFolder;
    ShellFolder2: TShellFolder;
    FileOpt: TFileOperation;
    ListView1: TListView;
    ListView2: TListView;
    ToolBar2: TToolBar;
    ToolbarImages: TImageList;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolBar3: TToolBar;
    ToolButton2: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    pnPath1: TPanel;
    pnPath2: TPanel;
    ToolButton13: TToolButton;
    btnCopy1: TSpeedButton;
    btnDelete1: TSpeedButton;
    btnCopy2: TSpeedButton;
    btnDelete2: TSpeedButton;
    btnMove1: TSpeedButton;
    btnMove2: TSpeedButton;
    ToolButton14: TToolButton;
    procedure ViewStyleChange1(Sender: TObject);
    procedure ViewStyleChange2(Sender: TObject);
    procedure SelectDir1(Sender: TObject);
    procedure SelectDir2(Sender: TObject);
    procedure btnCopy1Click(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ListView2SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure btnCopy2Click(Sender: TObject);
    procedure btnDelete1Click(Sender: TObject);
    procedure btnDelete2Click(Sender: TObject);
    procedure btnMove1Click(Sender: TObject);
    procedure btnMove2Click(Sender: TObject);
  private
    { Private declarations }
    procedure Copy(Source,Dest : TShellFolder);
    procedure Delete(Source : TShellFolder);
    procedure Move(Source,Dest : TShellFolder);
    procedure PrepareSourceFiles(Source : TShellFolder);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses FileCtrl;

{$R *.DFM}

procedure TForm1.ViewStyleChange1(Sender: TObject);
begin
  ListView1.ViewStyle := TViewStyle((Sender as TComponent).Tag);
end;

procedure TForm1.ViewStyleChange2(Sender: TObject);
begin
  ListView2.ViewStyle := TViewStyle((Sender as TComponent).Tag);
end;

procedure TForm1.SelectDir1(Sender: TObject);
var
  dir : string;
begin
  dir := ShellFolder1.path;
  if SelectDirectory(dir,[],0) then
  begin
    ShellFolder1.path := dir;
    pnPath1.caption := dir;
  end;
end;

procedure TForm1.SelectDir2(Sender: TObject);
var
  dir : string;
begin
  dir := ShellFolder2.path;
  if SelectDirectory(dir,[],0) then
  begin
    ShellFolder2.path := dir;
    pnPath2.caption := dir;
  end;
end;

procedure TForm1.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected then
  begin
    btnCopy1.enabled := true;
    btnDelete1.enabled := true;
  end;
end;

procedure TForm1.ListView2SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected then
  begin
    btnCopy2.enabled := true;
    btnDelete2.enabled := true;
  end;
end;

procedure TForm1.Copy(Source, Dest: TShellFolder);
begin
  if Source.ListView.Selected <> nil then
  begin
    PrepareSourceFiles(Source);
    FileOpt.Dests.Clear;
    FileOpt.Dests.Add(Dest.path);
    FileOpt.Operation := fotCopy;
    if not FileOpt.DoFileOperate then
      messageDlg('Unsuccessful copy.',mtError,[mbOK],0);
    Dest.Refresh;
    Dest.ListView.Selected := nil;
  end;
end;

procedure TForm1.Delete(Source: TShellFolder);
begin
  if Source.ListView.Selected <> nil then
  begin
    PrepareSourceFiles(Source);
    FileOpt.Dests.Clear;
    FileOpt.Operation := fotDelete;
    if not FileOpt.DoFileOperate then
      messageDlg('Unsuccessful delete.',mtError,[mbOK],0);
    Source.Refresh;
    Source.ListView.Selected := nil;
  end;
end;

procedure TForm1.PrepareSourceFiles(Source: TShellFolder);
var
  i : integer;
  ListItem : TListItem;
  FileName : string;
begin
    FileOpt.Sources.Clear;
    ListItem := Source.ListView.Selected;
    for i:=0 to Source.ListView.SelCount-1 do
    begin
      FileName := Source.ItemFullName(ListItem.Index);
      FileOpt.Sources.Add(FileName);
      ListItem := Source.ListView.GetNextItem(ListItem,sdAll,[isSelected]);
    end;
end;

procedure TForm1.btnCopy1Click(Sender: TObject);
begin
  (*if listview1.Selected <> nil then
  begin
    FileOpt.Source := ShellFolder1.ItemFullName(listview1.Selected.Index);
    FileOpt.Dest := ShellFolder2.path;
    if not FileOpt.DoFileOperate then
      messageDlg('Unsuccessful copy.',mtError,[mbOK],0)
    else ShellFolder2.Refresh;
  end;*)
  Copy(ShellFolder1,ShellFolder2);
end;

procedure TForm1.btnCopy2Click(Sender: TObject);
begin
  Copy(ShellFolder2,ShellFolder1);
end;

procedure TForm1.btnDelete1Click(Sender: TObject);
begin
  Delete(ShellFolder1);
end;

procedure TForm1.btnDelete2Click(Sender: TObject);
begin
  Delete(ShellFolder2);
end;


procedure TForm1.Move(Source, Dest: TShellFolder);
begin
  if Source.ListView.Selected <> nil then
  begin
    PrepareSourceFiles(Source);
    FileOpt.Dests.Clear;
    FileOpt.Dests.Add(Dest.path);
    FileOpt.Operation := fotMove;
    if not FileOpt.DoFileOperate then
      messageDlg('Unsuccessful move.',mtError,[mbOK],0);
    Source.Refresh;
    Source.ListView.Selected := nil;
    Dest.Refresh;
    Dest.ListView.Selected := nil;
  end;
end;

procedure TForm1.btnMove1Click(Sender: TObject);
begin
  Move(ShellFolder1,ShellFolder2);
end;

procedure TForm1.btnMove2Click(Sender: TObject);
begin
  Move(ShellFolder2,ShellFolder1);
end;

end.
