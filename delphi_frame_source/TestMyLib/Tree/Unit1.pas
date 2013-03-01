unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, Grids, DBGrids, ExtCtrls,
  Db, DBTables,TreeItems,DBTreeItems;

type
  TForm1 = class(TForm)
    tabAll: TTable;
    tabChildren: TTable;
    dsAll: TDataSource;
    dsChildren: TDataSource;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Splitter2: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Tree : TFolderView;
    Root : TDBTreeItem;
    Envir : TDBTreeEnvir;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


procedure TForm1.FormCreate(Sender: TObject);
begin
  Envir := TDBTreeEnvir.Create;
  with Envir do
  begin
    ItemDataSet := tabAll;
    CaptionFieldName := 'Text';
    ChildrenDataSet := tabChildren;
    KeyFieldName:= 'ID';
    RootKey := '1';
    RootCaption := 'RootCaption';
    RootExists := true;
  end;

  Tree := TFolderView.Create(self);
  Tree.Align := alClient;
  Tree.parent := Panel1;

  Root := TDBTreeItem.CreateAsRoot(Envir);
  //Root.GetFromDB;

  Tree.RootItem := Root;// as ITreeItem;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Envir.free;
  Tree.RootItem := nil;
  Root.free;
end;

end.
