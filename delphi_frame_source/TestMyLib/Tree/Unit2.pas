unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, Grids, DBGrids, ExtCtrls,
  Db, DBTables,TreeItems,DBTreeItems;

type
  TForm1 = class(TForm)
    tabAll: TTable;
    dsAll: TDataSource;
    dsChildren: TDataSource;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Splitter2: TSplitter;
    qrChildren: TQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure dsAllDataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
    procedure GoTop(Sender: TObject);
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
    ChildrenDataSet := qrChildren;
    KeyFieldName:= 'ID';
    RootKey := '0';
    RootCaption := 'RootCaption';
    RootExists := false;
    OnGotoVirtualTop:= GoTop;
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

procedure TForm1.GoTop(Sender: TObject);
begin
  qrChildren.Params[0].AsInteger := 0;
  qrChildren.active:=false;
  qrChildren.active:=true;
end;

procedure TForm1.dsAllDataChange(Sender: TObject; Field: TField);
begin
  if qrChildren<>nil then
  begin
    qrChildren.Active := false;
    qrChildren.Params[0].AsInteger :=
      tabAll.FieldByName('ID').AsInteger;
    qrChildren.Active := true;  
  end;
end;

end.
