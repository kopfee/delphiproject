unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TxtDB,TxtDBEx, StdCtrls, Db, ExtCtrls, DBCtrls, Grids, DBGrids;

type
  TForm1 = class(TForm)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    OpenDialog: TOpenDialog;
    Memo1: TMemo;
    Panel1: TPanel;
    DBNavigator1: TDBNavigator;
    btnOpen: TButton;
    procedure btnOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    Data : TTextDataset;
    Dataset : TStdTextDataset;
    procedure viewData;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnOpenClick(Sender: TObject);
var
  DS : TTextDataStore;
begin
  if OpenDialog.Execute then
  begin
    DS := TTextDataStore.Create(Data);
    try
      DS.LoadFromFile(OpenDialog.fileName);
      viewData;
      Dataset.open;
    finally
      DS.free;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Data := TTextDataset.create;
  Dataset := TStdTextDataset.create(self);
  Dataset.data := data;
  DataSource1.DataSet:=Dataset;
  OpenDialog.InitialDir:=ExtractFileDir(Application.ExeName);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Dataset.free;
  Data.Free;
end;

procedure TForm1.viewData;
  procedure addLine(const s:string);
  begin
    Memo1.lines.add(s);
  end;

var
  s:string;
  i : integer;
begin
  Memo1.lines.clear;

  Data.first;
  while not Data.eof do
  begin
    s:='';
    for i:=0 to Data.FieldCount-1 do
      s:=s+' | '+Data.Fields[i].Value;
    addLine(s);
    Data.next;
  end;
end;

end.
