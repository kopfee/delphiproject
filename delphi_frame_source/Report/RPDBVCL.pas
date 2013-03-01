unit RPDBVCL;

interface

uses Classes, Contnrs, Db, RPDB, RPDefines;

type
  TRPDBDataset = class;

  TRPDBField = class (TRPDataField)
  private
    FField : TField;
    procedure   SetField(const Value: TField);
  public
    function    GetPrintableText(TextFormatType : TRPTextFormatType=tfNone;
                  const TextFormat : string='') : string; override;
    function    AsInteger : Integer; override;
    function    AsFloat : Double; override;
    function    AsDateTime : TDateTime; override;
    function    AsString : String; override;
    procedure   SaveBlobToStream(Stream : TStream); override;
    procedure   AssignTo(Dest: TPersistent); override;
    property    Field : TField read FField write SetField;
  end;

  {
  TRPDBLink = class(TDataLink)
  private
    FRPDataset : TRPDBDataset;
  protected
    //procedure   ActiveChanged; override;
    procedure   DataEvent(Event: TDataEvent; Info: Longint); override;
  public
    constructor Create(ARPDataset : TRPDBDataset);
  end;
  }

  TRPDBDataset = class(TRPDataset)
  private
    function    GetDataSource: TDataSource;
    procedure   SetDataSource(const Value: TDataSource);
  protected
    FFields :   TObjectList;
    FDBFields : TList;
    FLink :     TDataLink; //TRPDBLink;
    function    GetFields(Index : Integer) : TRPDataField; override;
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure   RecreateFields;
    procedure   NeedRecreateFields;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
    procedure   First; override;
    procedure   Next; override;
    function    Eof : Boolean; override;
    procedure   Last; override;
    procedure   Prior; override;
    function    Bof : Boolean; override;
    function    FieldCount : Integer; override;
  published
    property    DataSource : TDataSource read GetDataSource write SetDataSource;
  end;

  TRPDBDataEntries = class(TRPDataEntries)
  private
    FOwnedDatasets : TObjectList;
    function GetDatasetCount: Integer;
    function GetDatasets(Index: Integer): TRPDBDataset;
  public
    procedure   ClearControllers; override;
    procedure   AddDatasource(const DatasetName : string; Datasource : TDatasource);
    procedure   SetBlockReadSize(BlockReadSize : Integer);
    procedure   DisableControls;
    procedure   EnableControls;
    property    DatasetCount : Integer read GetDatasetCount;
    property    Datasets[Index : Integer] : TRPDBDataset read GetDatasets;
  end;

implementation

uses SysUtils, SafeCode;

{TRPDatasetField}

function TRPDBField.AsDateTime: TDateTime;
begin
  Assert(FField<>nil);
  Result := FField.AsDateTime;
end;

function TRPDBField.AsFloat: Double;
begin
  Assert(FField<>nil);
  Result := FField.AsFloat;
end;

function TRPDBField.AsInteger: Integer;
begin
  Assert(FField<>nil);
  Result := FField.AsInteger;
end;

procedure TRPDBField.AssignTo(Dest: TPersistent);
begin
  Assert(FField<>nil);
  Dest.Assign(FField);
end;

function TRPDBField.AsString: String;
begin
  Assert(FField<>nil);
  Result := FField.AsString;
end;

function TRPDBField.GetPrintableText(TextFormatType : TRPTextFormatType=tfNone;
  const TextFormat : string=''): string;
begin
  if FField<>nil then
  begin
    if TextFormatType=tfNone then
    begin
      if FieldType<>gfdtBinary then
        Result := FField.DisplayText else
      begin
        try
          Result := FField.AsString;
        except
          Result := '';
        end;
      end;
    end else
      Result := inherited GetPrintableText(TextFormatType, TextFormat);
  end else
    Result := '';
end;

procedure TRPDBField.SaveBlobToStream(Stream: TStream);
begin
  Assert((FFieldType = gfdtBinary) and (FField is TBlobField));
  TBlobField(FField).SaveToStream(Stream);
end;

procedure TRPDBField.SetField(const Value: TField);
begin
  if FField <> Value then
  begin
    FField := Value;
    if FField<>nil then
    begin
      if FieldName='' then
        FieldName := FField.FieldName;
      case FField.DataType  of
        ftString,ftFixedChar, ftWideString :
          FFieldType:=gfdtString;
        ftSmallint, ftInteger, ftWord, ftAutoInc, ftLargeint :
          FFieldType:=gfdtInteger;
        ftFloat, ftCurrency, ftBCD :
          FFieldType:=gfdtFloat;
        ftDate, ftTime, ftDateTime :
          FFieldType:=gfdtDate;
      else
        FFieldType := gfdtOther;
      end;
      if (FFieldType = gfdtOther) and FField.IsBlob then
        FFieldType := gfdtBinary;
    end;
  end;
end;

(*

{ TRPDBLink }

constructor TRPDBLink.Create(ARPDataset: TRPDBDataset);
begin
  FRPDataset := ARPDataset;
end;

*)

(*
procedure TRPDBLink.ActiveChanged;
begin
  inherited;
  FRPDataset.RecreateFields;
end;
*)

(*
procedure TRPDBLink.DataEvent(Event: TDataEvent; Info: Integer);
begin
  inherited;
  if Event in [deFieldListChange, deLayoutChange, dePropertyChange] then
    FRPDataset.NeedRecreateFields;
end;
*)

{ TRPDBDataset }

constructor TRPDBDataset.Create(AOwner: TComponent);
begin
  inherited;
  FFields := nil;
  FDBFields := TList.Create;
  //FLink := TRPDBLink.Create(Self);
  FLink := TDataLink.Create;
end;

destructor TRPDBDataset.Destroy;
begin
  inherited;
  FreeAndNil(FLink);
  FreeAndNil(FFields);
  FreeAndNil(FDBFields);
end;

function TRPDBDataset.Eof: Boolean;
begin
  if FLink.Active then
    Result := FLink.DataSet.Eof
  else
    Result := true;
end;

function TRPDBDataset.Bof: Boolean;
begin
  if FLink.Active then
    Result := FLink.DataSet.Bof
  else
    Result := true;
end;

function TRPDBDataset.FieldCount: Integer;
begin
  if FLink.Active then
    Result := FLink.Dataset.FieldCount
  else
    Result := 0;
end;

function TRPDBDataset.GetFields(Index: Integer): TRPDataField;
begin
  if FFields=nil then
    RecreateFields;
  if FFields=nil then
    Result := nil else
    Result := TRPDataField(FFields[Index]);
  if Result<>nil then
    Assert(TRPDBField(Result).Field=DataSource.Dataset.Fields[Index]);
end;

procedure TRPDBDataset.First;
begin
  if FLink.Active then
    FLink.DataSet.First;
end;

procedure TRPDBDataset.Last;
begin
  if FLink.Active then
    FLink.DataSet.Last;
end;

procedure TRPDBDataset.Next;
begin
  if FLink.Active then
    FLink.DataSet.Next;
end;

procedure TRPDBDataset.Prior;
begin
  if FLink.Active then
    FLink.DataSet.Prior;
end;

procedure TRPDBDataset.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) then
  begin
    if (FLink<>nil) and (AComponent = DataSource) then
      DataSource := nil;
    if (AComponent is TField) and (FDBFields.IndexOf(AComponent)>=0) then
      NeedRecreateFields;
  end;
end;

procedure TRPDBDataset.RecreateFields;
var
  i : integer;
  Dataset : TDataset;
  Field : TRPDBField;
  DBField : TField;
begin
  if (csDestroying in ComponentState)  or (FLink=nil) then
    Exit;
  if FFields<>nil then
    FFields.Clear;
  FDBFields.Clear;
  if FLink.Active then
  begin
    if FFields=nil then
      FFields := TObjectList.Create;
    Dataset := FLink.Dataset;
    for i:=0 to Dataset.FieldCount-1 do
    begin
      Field := TRPDBField.Create(Self);
      DBField := Dataset.Fields[i];
      Field.Field := DBField;
      FFields.Add(Field);
      FDBFields.Add(DBField);
      DBField.FreeNotification(Self);
    end;
  end
  else
    FreeAndNil(FFields);
end;

function TRPDBDataset.GetDataSource: TDataSource;
begin
  Result := FLink.DataSource;
end;

procedure TRPDBDataset.SetDataSource(const Value: TDataSource);
begin
  if not (FLink.DataSourceFixed and (csLoading in ComponentState)) then
    FLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

procedure TRPDBDataset.NeedRecreateFields;
begin
  FreeAndNil(FFields);
  FDBFields.Clear;
end;

{ TRPDBDataEntries }

procedure TRPDBDataEntries.AddDatasource(const DatasetName: string;
  Datasource: TDatasource);
var
  i : integer;
  Dataset: TRPDBDataset;
begin
  if FOwnedDatasets=nil then
    FOwnedDatasets := TObjectList.Create;
  i := IndexOfDataset(DatasetName);
  CheckTrue(i>=0,'No Entry For '+DatasetName);
  Dataset:= TRPDBDataset.Create(nil);
  Dataset.Environment := TRPDatasetController(Controllers[i]).Environment;
  Dataset.DatasetName := DatasetName;
  Dataset.DataSource := Datasource;
  FOwnedDatasets.Add(Dataset);
  TRPDatasetController(Controllers[i]).Dataset := Dataset;
end;


procedure TRPDBDataEntries.ClearControllers;
begin
  inherited;
  FreeAndNil(FOwnedDatasets);
end;

procedure TRPDBDataEntries.DisableControls;
var
  I,Count : Integer;
  Dataset : TRPDBDataset;
begin
  if FOwnedDatasets<>nil then
  begin
    Count := DatasetCount;
    for I:=0 to Count-1 do
    begin
      Dataset := Datasets[I];
      if Dataset.DataSource.DataSet<>nil then
        Dataset.DataSource.DataSet.DisableControls;
    end;
  end;
end;

procedure TRPDBDataEntries.EnableControls;
var
  I,Count : Integer;
  Dataset : TRPDBDataset;
begin
  if FOwnedDatasets<>nil then
  begin
    Count := DatasetCount;
    for I:=0 to Count-1 do
    begin
      Dataset := Datasets[I];
      if Dataset.DataSource.DataSet<>nil then
        Dataset.DataSource.DataSet.EnableControls;
    end;
  end;
end;

function TRPDBDataEntries.GetDatasetCount: Integer;
begin
  if FOwnedDatasets<>nil then
    Result := FOwnedDatasets.Count else
    Result := 0;
end;

function TRPDBDataEntries.GetDatasets(Index: Integer): TRPDBDataset;
begin
  CheckObject(FOwnedDatasets,'Error : TRPDBDataEntries No Dataset');
  Result := TRPDBDataset(FOwnedDatasets[Index]);
end;

procedure TRPDBDataEntries.SetBlockReadSize(BlockReadSize: Integer);
var
  I,Count : Integer;
  Dataset : TRPDBDataset;
begin
  if FOwnedDatasets<>nil then
  begin
    Count := DatasetCount;
    for I:=0 to Count-1 do
    begin
      Dataset := Datasets[I];
      if Dataset.DataSource.DataSet<>nil then
        Dataset.DataSource.DataSet.BlockReadSize := BlockReadSize;
    end;
  end;
end;

end.
