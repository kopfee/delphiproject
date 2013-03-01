unit RPDBCBImp;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>RPDBCBImp
   <What>Report Dataset Callback implementations
   针对RPDBCB描述的数据集回调函数，实现了TRPCBDataset(TRPCBDataset的子类)和TRPCBField(TRPDataField的子类)
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

interface

uses Classes,Contnrs, RPDBCB,RPDB, RPDefines;

type
  TRPCBDataset = class;

  TRPCBField = class (TRPDataField)
  private
    FFieldIndex: Integer;
    procedure   SetFieldIndex(const Value: Integer);
  public
    function    GetPrintableText(TextFormatType : TRPTextFormatType=tfNone;
                  const TextFormat : string='') : string; override;
    function    AsInteger : Integer; override;
    function    AsFloat : Double; override;
    function    AsDateTime : TDateTime; override;
    function    AsString : string; override;
    procedure   SaveBlobToStream(Stream : TStream); override;
    procedure   AssignTo(Dest: TPersistent); override;
    property    FieldIndex : Integer read FFieldIndex write SetFieldIndex;
  end;

  TRPCBDataset = class(TRPDataset)
  private

  protected
    FFields :   TObjectList;
    function    GetFields(Index : Integer) : TRPDataField; override;
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure   RecreateFields;
    procedure   NeedRecreateFields;
    function    Available:Boolean;
  public
    DatasetRecord : PDatasetRecord;
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

  end;

  TRPCBDataEntries = class(TRPDataEntries)
  private
    FOwnedDatasets : TObjectList;
  public
    procedure   ClearControllers; override;
    procedure   AddRecord(const DatasetName : string; DatasetRecord : PDatasetRecord);
  end;

implementation

uses SysUtils, SafeCode;

{ TRPCBField }

function TRPCBField.AsDateTime: TDateTime;
begin
  with TRPCBDataset(Dataset).DatasetRecord^ do
    Result := GetDateTime(Dataset,FieldIndex);
end;

function TRPCBField.AsFloat: Double;
begin
  with TRPCBDataset(Dataset).DatasetRecord^ do
    Result := GetFloat(Dataset,FieldIndex);
end;

function TRPCBField.AsInteger: Integer;
begin
  with TRPCBDataset(Dataset).DatasetRecord^ do
    Result := GetInteger(Dataset,FieldIndex);
end;

procedure TRPCBField.AssignTo(Dest: TPersistent);
begin
  // empty
end;

function TRPCBField.AsString: string;
var
  Len : Integer;
begin
  with TRPCBDataset(Dataset).DatasetRecord^ do
  begin
    Len := GetString(Dataset,FieldIndex,nil,0);
    SetLength(Result,Len);
    if Len>0 then
      GetString(Dataset,FieldIndex,PChar(Result),Len);
  end;
end;

function TRPCBField.GetPrintableText(TextFormatType : TRPTextFormatType=tfNone;
  const TextFormat : string=''): string;
begin
  if TextFormatType=tfNone then
  begin
    case FieldType of
      gfdtInteger : Result := IntToStr(AsInteger);
      gfdtFloat   : Result := FloatToStr(AsFloat);
      gfdtString  : Result := AsString;
      gfdtDate    : Result := FloatToStr(AsDateTime);
    else Result := '';
    end;
  end else
    Result := inherited GetPrintableText(TextFormatType, TextFormat);
end;

procedure TRPCBField.SaveBlobToStream(Stream: TStream);
begin
  // empty
end;

procedure TRPCBField.SetFieldIndex(const Value: Integer);
var
  DT : integer;
  Len : Integer;
  S : string;
begin
  FFieldIndex := Value;
  with TRPCBDataset(Dataset).DatasetRecord^ do
  begin
    Len := GetFieldName(Dataset,FFieldIndex,nil,0);
    SetLength(S,Len);
    if Len>0 then
      GetFieldName(Dataset,FFieldIndex,PChar(S),Len);
    FieldName := S;
    DT := GetFieldDataType(Dataset,FFieldIndex);
  end;
  if (DT<0) or (DT>cdtBinary) then
    FFieldType := gfdtOther else
    FFieldType := TRPFieldDataType(DT);
end;

{ TRPCBDataset }

constructor TRPCBDataset.Create(AOwner: TComponent);
begin
  inherited;
  FFields := nil;
end;

destructor TRPCBDataset.Destroy;
begin
  inherited;
  FreeAndNil(FFields);
end;

function TRPCBDataset.Eof: Boolean;
begin
  if Available then
    Result := DatasetRecord.Eof(DatasetRecord.Dataset) else
    Result := true;
end;

function TRPCBDataset.Bof: Boolean;
begin
  if Available then
    Result := DatasetRecord.Bof(DatasetRecord.Dataset) else
    Result := true;
end;

function TRPCBDataset.FieldCount: Integer;
begin
  if Available then
    Result := DatasetRecord.FieldCount(DatasetRecord.Dataset) else
    Result := 0;
end;

function TRPCBDataset.GetFields(Index: Integer): TRPDataField;
begin
  if FFields=nil then
    RecreateFields;
  if FFields=nil then
    Result := nil else
    Result := TRPDataField(FFields[Index]);
end;

procedure TRPCBDataset.First;
begin
  if Available then
    DatasetRecord.First(DatasetRecord.Dataset);
end;

procedure TRPCBDataset.Last;
begin
  if Available then
    DatasetRecord.Last(DatasetRecord.Dataset);
end;

procedure TRPCBDataset.Next;
begin
  if Available then
    DatasetRecord.Next(DatasetRecord.Dataset);
end;

procedure TRPCBDataset.Prior;
begin
  if Available then
    DatasetRecord.Prior(DatasetRecord.Dataset);
end;

procedure TRPCBDataset.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

end;


procedure TRPCBDataset.RecreateFields;
var
  i : integer;
  Field : TRPCBField;
  FieldCount : Integer;
begin
  if FFields<>nil then
    FFields.Clear;
  if Available then
  begin
    if FFields=nil then
      FFields := TObjectList.Create;
    FieldCount := Self.FieldCount;
    for i:=0 to FieldCount-1 do
    begin
      Field := TRPCBField.Create(Self);
      Field.FieldIndex := I;
      FFields.Add(Field);
    end;
  end
  else
    FreeAndNil(FFields);
end;

procedure TRPCBDataset.NeedRecreateFields;
begin
  FreeAndNil(FFields);
end;

function TRPCBDataset.Available: Boolean;
begin
  Result := DatasetRecord<>nil;
end;

{ TRPCBDataEntries }

procedure TRPCBDataEntries.AddRecord(const DatasetName: string;
  DatasetRecord: PDatasetRecord);
var
  i : integer;
  Dataset: TRPCBDataset;
begin
  CheckPtr(DatasetRecord,'Invalid DatasetRecord.');
  if FOwnedDatasets=nil then
    FOwnedDatasets := TObjectList.Create;
  i := IndexOfDataset(DatasetName);
  CheckTrue(i>=0,'No Entry For '+DatasetName);
  Dataset:= TRPCBDataset.Create(nil);
  Dataset.Environment := TRPDatasetController(Controllers[i]).Environment;
  Dataset.DatasetName := DatasetName;
  Dataset.DatasetRecord := DatasetRecord;
  FOwnedDatasets.Add(Dataset);
  TRPDatasetController(Controllers[i]).Dataset := Dataset;
end;

procedure TRPCBDataEntries.ClearControllers;
begin
  inherited;
  FreeAndNil(FOwnedDatasets);
end;

end.
