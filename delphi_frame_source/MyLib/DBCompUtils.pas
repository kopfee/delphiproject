unit DBCompUtils;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>DBCompUtils
   <What>Database Component Utilities
   <Written By> Huang YanLai (ª∆—‡¿¥)
   <History>Moved From Unit CompUtils
**********************************************}

interface

uses Windows,Messages,Sysutils,Classes,Controls, Db, DBGrids,Menus;

{ 3. navigate in a mutil-selected Grid
Note : after create
}

type
  TNavgateSelectedRecords = class
  private
    FBof: boolean;
    FEof: boolean;
    FIndex: integer;
    FDataSet: TDataset;
    FBookmarks: TBookMarklist;
    function    GetCount: integer;
    procedure   SetIndex(const Value: integer);
    procedure   GotoCurrent;
  public
    constructor CreateByGrid(AGrid : TDBGrid;SelectCurrent : boolean = false);
    constructor CreateByDB(ADataset : TDataset;
                  ABookmarks : TBookMarklist);
    property    DataSet : TDataset read FDataSet;
    property    Bookmarks : TBookMarklist read FBookmarks;
    property    Count : integer read GetCount;
    procedure   First;
    procedure   Last;
    procedure   Next;
    procedure   Prior;
    property    Bof : boolean read FBof;
    property    Eof : boolean read FEof;
    property    Index  : integer read FIndex write SetIndex;
  end;

implementation

{ TNavgateSelectedRecords }

constructor TNavgateSelectedRecords.CreateByDB(ADataset: TDataset;
  ABookmarks: TBookMarklist);
begin
  inherited Create;
  assert(ADataset<>nil);
  assert(ABookmarks<>nil);
  FDataset := ADataset;
  FBookmarks := ABookmarks;
end;

constructor TNavgateSelectedRecords.CreateByGrid(AGrid: TDBGrid;SelectCurrent : boolean = false);
begin
  assert(AGrid<>nil);
  assert(AGrid.DataSource<>nil);
  if SelectCurrent then
    AGrid.SelectedRows.CurrentRowSelected := true;
  CreateByDB(AGrid.DataSource.dataset,AGrid.SelectedRows);
  First;
end;

function TNavgateSelectedRecords.GetCount: integer;
begin
  result := FBookmarks.Count;
end;

procedure TNavgateSelectedRecords.First;
begin
  FIndex := 0;
  FBof := true;
  FEof := FIndex>=count;
  GotoCurrent;
end;

procedure TNavgateSelectedRecords.Last;
begin
  FIndex := count - 1;
  FEof := true;
  FBof := FIndex<0;
  GotoCurrent;
end;

procedure TNavgateSelectedRecords.Next;
begin
  FBof := false;
  inc(FIndex);
  FEof := FIndex>=count;
  if FEof then FIndex := count-1;
  GotoCurrent;
end;

procedure TNavgateSelectedRecords.Prior;
begin
  FEof := false;
  dec(FIndex);
  FBof := FIndex<0;
  if FBof then FIndex := 0;
  GotoCurrent;
end;

procedure TNavgateSelectedRecords.SetIndex(const Value: integer);
begin
  CheckRange(value,0,count-1);
  FIndex := value;
  GotoCurrent;
end;

procedure TNavgateSelectedRecords.GotoCurrent;
begin
  if (FIndex>=0) and (FIndex<Count) then
    Dataset.BookMark := FBookmarks[index];
end;

end.
