unit DBBKMarker;

interface

uses sysUtils,Classes,DB,ComWriUtils;

type
  TDBBookMarker = class(TObject)
  private
    FDataset: TDataset;
    FBookmark: TBookmarkStr;
    FisBOF,FisEOF : boolean;
    FID: integer;
  protected

  public
    constructor Create(ADataset : TDataset; AID:integer);
    procedure   Init;
    property    Dataset : TDataset read FDataset;
    procedure   SavePosition;
    procedure   RestorePosition;
    property    Bookmark : TBookmarkStr read FBookmark;
    function    MoveBy(distance : integer): integer;
    procedure   First;
    procedure   Last;
    property    ID : integer read FID;
  end;

  TDBBookMarkers = class(TObject)
  private
    FList : TObjectList;
    FDataset: TDataset;
  protected

  public
    constructor Create(ADataset : TDataset);
    Destructor  Destroy;override;
    property    Dataset : TDataset read FDataset;
    function    GetBookMarker(var ID:integer):TDBBookMarker;
  end;

implementation

uses SafeCode;

{ TDBBookMarker }

constructor TDBBookMarker.Create(ADataset: TDataset; AID:integer);
begin
  CheckObject(ADataset,'Error : Dataset is nil for BookMarker.');
  inherited Create;
  FDataset := ADataset;
  FID := AID;
  FisEof := false;
  FisBof := false;
end;

procedure TDBBookMarker.Init;
begin
  FDataset.First;
  SavePosition;
end;

procedure TDBBookMarker.First;
begin
  FDataset.First;
  SavePosition;
end;

procedure TDBBookMarker.Last;
begin
  FDataset.Last;
  SavePosition;
end;

function TDBBookMarker.MoveBy(distance: integer): integer;
begin
  RestorePosition;
  result := FDataset.MoveBy(distance);
  SavePosition;
end;

procedure TDBBookMarker.RestorePosition;
begin
  if FisBOF then
  begin
    FDataSet.First;
    FDataSet.Prior;
  end
  else if FisEOF then
  begin
    FDataSet.last;
    FDataSet.next;
  end
  else if (length(FBookmark)>0) and  FDataSet.BookmarkValid(@FBookmark[1]) then
    FDataSet.Bookmark:=FBookmark else
    Init;
end;

procedure TDBBookMarker.SavePosition;
begin
  FBookmark := FDataSet.Bookmark;
  FisBOF:= FDataSet.BOF;
  FisEOF:= FDataSet.EOF;
end;

{ TDBBookMarkers }

constructor TDBBookMarkers.Create(ADataset : TDataset);
begin
  inherited Create;
  FList := TObjectList.Create;
  FDataset := ADataset;
end;

destructor TDBBookMarkers.Destroy;
begin
  FList.free;
  Inherited Destroy;
end;

function TDBBookMarkers.GetBookMarker(var ID: integer): TDBBookMarker;
begin
  if (ID>=0) and (ID<FList.count) then
    result := TDBBookMarker(FList[ID]) else
    begin
      ID := FList.count;
      result := TDBBookMarker.Create(FDataset,ID);
      result.Init;
      FList.Add(result);
    end;
end;

end.
