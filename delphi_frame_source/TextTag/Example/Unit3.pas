unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TextOutScripts, RPDB, Db, DBTables, ComCtrls, Grids, DBGrids;

type
  TForm1 = class(TForm)
    OpenDialog: TOpenDialog;
    Environment: TRPDataEnvironment;
    SaveDialog: TSaveDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    mmResults: TMemo;
    mmSource: TMemo;
    btnOpen: TButton;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    mmOutput: TMemo;
    btnRun: TButton;
    Table1: TTable;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    Query1: TQuery;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    procedure btnOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
  private
    { Private declarations }
    FContext : TScriptContext;
    procedure ViewResults;
    procedure AddInfo(const s:string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FContext := TScriptContext.Create(Self);
  FContext.Environment := Environment;
  Query1.Open;
  Table1.Open;
end;

procedure TForm1.AddInfo(const s: string);
begin
  mmResults.Lines.Add(s);
end;

procedure TForm1.btnOpenClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    mmSource.Lines.LoadFromFile(OpenDialog.FileName);
    mmResults.Lines.Clear;
    FContext.LoadScripts(OpenDialog.FileName);
    ViewResults;
  end;
end;

procedure TForm1.ViewResults;
var
  i : integer;
  Node : TTOScriptNode;
begin
  //
  AddInfo('Default File Name '+FContext.DefaultFileName);
  // data entries
  AddInfo('Data Entries');
  for i:=0 to FContext.DataEntries.Count-1 do
  with FContext.DataEntries[i] do
    AddInfo(Format('%d: Dataset=%s,Controller=%s,GroupFields=%s',[i,DatasetName,ControllerName,Groups.Text]));
  // nodes
  AddInfo('');
  AddInfo('Nodes');
  for i:=0 to FContext.Nodes.Count-1 do
  begin
    Node := TTOScriptNode(FContext.Nodes[i]);
    if Node is TTOText then
      AddInfo(Format('%d - Text',[I]))
    else if Node is TTOFieldValue then
      with TTOFieldValue(Node) do
        AddInfo(Format('%d - Field : Name=%s,Width=%d,Align=%d',[I,FieldName,Width,Ord(Align)]))
    else if Node is TTOForLoop then
      with TTOForLoop(Node) do
        AddInfo(Format('%d - For : Controller=%s,GroupIndex=%d,Exit=%d',[I,ControllerName,GroupIndex,ExitNodeIndex]))
    else if Node is TTOEndLoop then
      with TTOEndLoop(Node) do
        AddInfo(Format('%d - End : For=%d',[I,ForNodeIndex]))
  end;
end;

procedure TForm1.btnRunClick(Sender: TObject);
begin
  if FContext.DefaultFileName<>'' then
    SaveDialog.FileName := FContext.DefaultFileName;
  if SaveDialog.Execute then
  begin
    if FContext.DataEntries.IndexOfDataset('Animals')>=0 then
      FContext.DataEntries.AddDatasource('Animals',DataSource1);
    if FContext.DataEntries.IndexOfDataset('Orders')>=0 then
      FContext.DataEntries.AddDatasource('Orders',DataSource2);
    FContext.Output(SaveDialog.FileName);
    mmOutput.Lines.LoadFromFile(SaveDialog.FileName);
  end;
end;

end.
