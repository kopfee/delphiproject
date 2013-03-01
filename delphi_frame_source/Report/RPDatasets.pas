unit RPDatasets;

interface

uses Classes, Contnrs, Db;

type
  TRPDataEnvironment = class;

  TRPField = class
  private
    FEnvironment : TRPDataEnvironment;
    FFieldName: string;
  public
    function GetPrintableText : string; virtual; abstract;
    property FieldName : string read FFieldName write FFieldName;
    property Environment : TRPDataEnvironment read FEnvironment;
  end;

  TRPFieldDataType = (gfdtInteger,gfdtFloat,gfdtString,gfdtDate,gfdtOther);

  TRPDataField = class (TRPField)
  protected
    FFieldType: TRPFieldDataType;
  public
    function GetPrintableText : string; override;
    function AsInteger : Integer; virtual; abstract;
    function AsFloat : Double; virtual; abstract;
    function AsDateTime : TDateTime; virtual; abstract;
    function AsString : String; virtual; abstract;
    property FieldType : TRPFieldDataType read FFieldType;
  end;

  TRPDatasetField = class (TRPDataField)
  private
    FField : TField;
    procedure SetField(const Value: TField);
  public
    function GetPrintableText : string; override;
    function AsInteger : Integer; override;
    function AsFloat : Double; override;
    function AsDateTime : TDateTime; override;
    function AsString : String; override;
    property Field : TField read FField write SetField;
  end;

  TRPDataEnvironment = class(TComponent)
  private
    FFields : TObjectList;
    function    GetCount: Integer;
    function    GetFields(Index: Integer): TRPField;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
    function    FindFiled (const FieldName : String) : TRPField;
    procedure   AddField (Field : TRPField);
    procedure   RemoveField (Field : TRPField);
    procedure   ClearFields;

    property    Count : Integer read GetCount;
    property    Fields [Index : Integer] : TRPField read GetFields;
  end;

implementation

uses SysUtils;

{ TRPDataEnvironment }

constructor TRPDataEnvironment.Create(AOwner : TComponent);
begin
  inherited;
  FFields := TObjectList.Create;
end;

destructor TRPDataEnvironment.Destroy;
begin
  FFields.Free;
  inherited;
end;

function TRPDataEnvironment.FindFiled (const FieldName : String) : TRPField;
var
  i : integer;
begin
  for i:=0 to FFields.Count-1 do
  begin
    Result := TRPField(FFields[i]);
    if CompareText(Result.FieldName,FieldName)=0 then
      Exit;
  end;
  Result := nil;
end;

procedure TRPDataEnvironment.AddField (Field : TRPField);
begin
  if Field<>nil then
    FFields.Add(Field);
end;

procedure TRPDataEnvironment.RemoveField (Field : TRPField);
begin
  if Field<>nil then
    FFields.Remove(Field);
end;

procedure TRPDataEnvironment.ClearFields;
begin
  FFields.Clear;
end;

function TRPDataEnvironment.GetCount: Integer;
begin
  Result := FFields.Count;
end;

function TRPDataEnvironment.GetFields(Index: Integer): TRPField;
begin
  Result := TRPField(FFields[Index]);
end;

{ TRPDatasetField }

function TRPDatasetField.AsDateTime: TDateTime;
begin
  Assert(FField<>nil);
  Result := FField.AsDateTime;
end;

function TRPDatasetField.AsFloat: Double;
begin
  Assert(FField<>nil);
  Result := FField.AsFloat;
end;

function TRPDatasetField.AsInteger: Integer;
begin
  Assert(FField<>nil);
  Result := FField.AsInteger;
end;

function TRPDatasetField.AsString: String;
begin
  Assert(FField<>nil);
  Result := FField.AsString;
end;

function TRPDatasetField.GetPrintableText: string;
begin
  if FField<>nil then
    Result := FField.DisplayText
  else
    Result := '';
end;

procedure TRPDatasetField.SetField(const Value: TField);
begin
  if FField <> Value then
  begin
    FField := Value;
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
  end;
end;

{ TRPDataField }

function TRPDataField.GetPrintableText: string;
begin
  Result := AsString;
end;

end.
