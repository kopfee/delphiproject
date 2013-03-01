unit RPDB;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>RPDB
   <What>
    在打印报表时，控制数据集的浏览（游标移动）
    抽象数据集
    数据环境
   <Written By> Huang YanLai (黄燕来)
   <History>
    0.2 改名，合并了RPDatasets
    0.1 修改自UDataBrowsers.pas(用于算法测试),类名使用前缀RP
**********************************************}

interface

uses Classes, Contnrs, RPDefines;

type
  TRPDataEnvironment = class;
  TRPDataset = class;
  TRPDatasetController = class;
  TRPDatasetGroup = class;

  TRPField = class
  private
    FFieldName: string;
  public
    function    GetPrintableText(TextFormatType : TRPTextFormatType=tfNone;
                  const TextFormat : string='') : string; virtual; abstract;
    property    FieldName : string read FFieldName write FFieldName;
  end;

  TRPFieldDataType = (gfdtInteger,gfdtFloat,gfdtString,gfdtDate,gfdtOther,gfdtBinary);

  TRPDataField = class (TRPField)
  private
    //FFormat: string;
    FDataset: TRPDataset;
  protected
    FFieldType: TRPFieldDataType;
  public
    constructor Create(ADataset : TRPDataset);
    function    GetPrintableText(TextFormatType : TRPTextFormatType=tfNone;
                  const TextFormat : string='') : string; override;
    function    AsInteger : Integer; virtual; abstract;
    function    AsFloat : Double; virtual; abstract;
    function    AsDateTime : TDateTime; virtual; abstract;
    function    AsString : string; virtual; abstract;
    procedure   SaveBlobToStream(Stream : TStream); virtual; abstract;
    procedure   AssignTo(Dest: TPersistent); virtual; abstract;
    property    FieldType : TRPFieldDataType read FFieldType;
    //property    Format : string read FFormat write FFormat;
    property    Dataset : TRPDataset read FDataset;
  end;

  TRPDataset = class(TComponent)
  private
    FEnvironment: TRPDataEnvironment;
    FDatasetName: string;
    procedure   SetEnvironment(const Value: TRPDataEnvironment);
  protected
    function    GetFields (Index : Integer) : TRPDataField; virtual; abstract;
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    procedure   First; virtual; abstract;
    procedure   Next; virtual; abstract;
    function    Eof : Boolean; virtual; abstract;
    procedure   Last; virtual; abstract;
    procedure   Prior; virtual; abstract;
    function    Bof : Boolean; virtual; abstract;
    function    FieldCount : Integer; virtual; abstract;
    property    Fields [Index : Integer] : TRPDataField read GetFields;
    function    FindField(const FieldName:string) : TRPDataField;
  published
    property    DatasetName : string read FDatasetName write FDatasetName;
    property    Environment : TRPDataEnvironment read FEnvironment write SetEnvironment;
  end;

  TRPDataEnvironment = class (TComponent)
  private
    FDatasets : TList;
    FControllers : TList;
    FFieldMapping: TStrings;
    FVariantValues: TStrings;
    procedure   AddDataset(Dataset : TRPDataset);
    procedure   RemoveDataset(Dataset : TRPDataset);
    procedure   AddController(Controller : TRPDatasetController);
    procedure   RemoveController(Controller : TRPDatasetController);
    procedure   SetFieldMapping(const Value: TStrings);
    procedure   SetVariantValues(const Value: TStrings);
  protected
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
    function    FindField(const FieldName : string) : TRPField;
    function    FindController(const ControllerName : string): TRPDatasetController;
    function    FindDataset(const DatasetName : string): TRPDataset;
    function    GetFieldText(const FieldName : string): string;
    procedure   UseDataset(Dataset : TRPDataset);
  published
    property    FieldMapping : TStrings read FFieldMapping write SetFieldMapping;
    property    VariantValues : TStrings read FVariantValues write SetVariantValues;
  end;

  {
    <Class>TRPDataBrowser
    <What>抽象的数据集浏览对象
    <Properties>
      -
    <Methods>
      Init  - 初始化
      GotoNextData - 获得下一个数据行。如果没有数据返回false
      Eof   - 是否结束
    <Event>
      -
  }
  TRPDataBrowser = class (TObject)
  private
    FEof: Boolean;
    FEnvironment: TRPDataEnvironment;
  protected
    FIsFirst : Boolean;
    function  InternalGotoNextData: Boolean; virtual; abstract;
  public
    procedure Init; virtual;
    function  GotoNextData: Boolean;
    property  Eof : Boolean read FEof;
    property  Environment : TRPDataEnvironment read FEnvironment write FEnvironment;
  end;

  {
    <Class>TRPDatasetBrowser
    <What>数据集浏览对象
    使用TRPDatasetController对象，浏览数据。
    <Properties>
      Controller    - 关联到控制对象（根据ControllerName确定）
      GroupingIndex - 分组的编号
      ControllerName - Controller的名字
      Available     - 是否有效
    <Methods>
      -
    <Event>
      -
  }
  TRPDatasetBrowser = class (TRPDataBrowser)
  private
    FInternalCount : Integer;
    FGrouping : TRPDatasetGroup;
    FGroupingIndex: Integer;
    FController: TRPDatasetController;
    FControllerName : String;
    procedure   SetControllerName(const Value: String);
    procedure   SetController(const Value: TRPDatasetController);
  protected
    function    GetCurrentCount: Integer;
    function    InternalGotoNextData: Boolean; override;
  public
    constructor Create;
    procedure   Init; override;
    procedure   CheckController;
    property    Controller : TRPDatasetController read FController write SetController;
    property    GroupingIndex : Integer read FGroupingIndex write FGroupingIndex;
    property    InternalCount : Integer read FInternalCount;
    property    ControllerName : string read FControllerName write SetControllerName;
    function    Available: Boolean;
  end;

  {
    <Class>TRPDatasetController
    <What>控制数据集的移动。支持分组。
    <Properties>
      Dataset - 关联的数据集对象
      ControllerName - 名字
      Groups  - 分组（每一行是该分组的字段名称，字段之间用“;”分割）
      FromFirst - 在初始化的时候是否调用Dataset.first
    <Methods>
      Init  - 初始化
      GetData - 获得数据。如果IsGetNewData=true，先移动Dataset的游标(Dataest.next)
      InternalCount - 内部计数。
      Available - 是否有效
      GoBack - 回退游标。当数据移动到下一个分组的时候被调用。
      CheckGrouping - 检查是否发生分组变化
    <Event>
      -
  }
  TRPDatasetController = class (TComponent)
  private
    FInternalCount: Integer;
    FGroupings : TObjectList;
    //FIsFirst : Boolean;
    FDataset: TRPDataset;
    FControllerName: string;
    FGroups: TStrings;
    FFromFirst: Boolean;
    FEnvironment: TRPDataEnvironment;
    //FDataSource : TDataSource;
    procedure   SetDataset(const Value: TRPDataset);
    function    AddGroup: TRPDatasetGroup;
    procedure   SetGroups(const Value: TStrings);
    procedure   SetEnvironment(const Value: TRPDataEnvironment);
  protected
    procedure   CheckGrouping;
    procedure   GoBack;
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy; override;
    procedure   Init;
    function    GetData(IsGetNewData : Boolean): Boolean;
    property    InternalCount : Integer read FInternalCount;
    //function    AddGroup : TRPDatasetGroup;
    function    Available: Boolean;
  published
    property    Dataset : TRPDataset read FDataset write SetDataset;
    property    ControllerName : string read FControllerName write FControllerName;
    property    Groups : TStrings read FGroups write SetGroups;
    property    FromFirst: Boolean read FFromFirst write FFromFirst default true;
    property    Environment : TRPDataEnvironment read FEnvironment write SetEnvironment;
  end;

  // 保存字段的数据
  TGroupFieldData = Record
    SValue : string; // for gfdtString because it cannot in a variant record
    case DataType : TRPFieldDataType of
      gfdtInteger : (IValue : Integer);
      gfdtFloat : (FValue : Double);
      gfdtDate : (DValue : TDateTime);
  end;

  {
    <Class>TRPGroupField
    <What>保存字段的数据，并且检查数据是否发生改变
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TRPGroupField = class (TObject)
  private
    FSavedData : TGroupFieldData;
    FField: TRPDataField;
  protected

  public
    constructor Create(AField : TRPDataField);
    procedure   SaveValue;
    function    IsChanged : Boolean;
    property    Field : TRPDataField read FField;
  end;

  {
    <Class>TRPDatasetGroup
    <What>代表一个分组
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TRPDatasetGroup = class (TObject)
  private
    FInternalCount: Integer;
    FController: TRPDatasetController;
    //FFields : TList;
    FGroupFields : TObjectList;
    FFieldNames: String;
  protected
    procedure   PrepareGroupFields;
    procedure   SaveGroupFieldsData;
    function    IsGroupChanged : Boolean;
    procedure   SetNewGroup;
  public
    constructor Create(AController : TRPDatasetController);
    Destructor  Destroy; override;
    procedure   Init;
    procedure   Prepare;
    {procedure   AddField(Field : TField); overload;
    procedure   AddField(const FieldName : string); overload;}
    property    InternalCount : Integer read FInternalCount;
    property    Controller : TRPDatasetController read FController;
    //property    Fields : TList read FFields;
    property    FieldNames : String read FFieldNames write FFieldNames; // use ';'
  end;

  TRPDataEntry = class(TCollectionItem)
  private
    FFromFirst: Boolean;
    FControllerName: string;
    FDatasetName: string;
    FGroups: TStrings;
    procedure   SetGroups(const Value: TStrings);
    procedure   SetControllerName(const Value: string);
    procedure   SetDatasetName(const Value: string);
  protected
    function    GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor  Destroy;override;
  published
    property    DatasetName : string read FDatasetName write SetDatasetName;
    property    ControllerName : string read FControllerName write SetControllerName;
    property    Groups : TStrings read FGroups write SetGroups;
    property    FromFirst: Boolean read FFromFirst write FFromFirst  default true;
  end;

  TRPDataEntries = class(TOwnedCollection)
  private
    FControllers: TObjectList;
    function    GetItems(Index: Integer): TRPDataEntry;
  public
    constructor Create(AOwner: TPersistent); virtual;
    destructor  Destroy;override;
    procedure   Clear;
    procedure   ClearControllers; virtual;
    procedure   CreateControllers(Environment : TRPDataEnvironment);
    function    IndexOfDataset(const DatasetName:string): Integer;
    function    IndexOfController(const ControllerName:string): Integer;
    procedure   AddDataset(Dataset: TRPDataset);
    procedure   BindDatasets(Environment : TRPDataEnvironment);
    property    Controllers: TObjectList read FControllers;
    property    Items[Index : Integer] : TRPDataEntry read GetItems; default;
  end;

  TRPDataEntriesClass = class of TRPDataEntries;

implementation

uses SysUtils,LogFile,SafeCode;

{ TRPDataEnvironment }

constructor TRPDataEnvironment.Create(AOwner : TComponent);
begin
  inherited;
  FDatasets := TList.Create;
  FFieldMapping := TStringList.Create;
  FControllers := TList.Create;
  FVariantValues  := TStringList.Create;
end;

destructor TRPDataEnvironment.Destroy;
begin
  FVariantValues.Free;
  FFieldMapping.Free;
  inherited;
  FreeAndNil(FDatasets);
  FreeAndNil(FControllers);
end;

function TRPDataEnvironment.FindField(const FieldName : string) : TRPField;
var
  i : integer;
  FullName : string;
  DatasetNamePart,FieldNamePart : string;
  CheckDatasetName : Boolean;
  Dataset : TRPDataset;
begin
  if FieldName='' then
  begin
    Result := nil;
    Exit;
  end;
  // first check mapping
  if FFieldMapping.IndexOfName(FieldName)>=0 then
    FullName := FFieldMapping.Values[FieldName] else
    FullName := FieldName;
  i := pos('.',FullName);
  if i>0 then
  begin
    DatasetNamePart := Copy(FullName,1,i-1);
    FieldNamePart := Copy(FullName,i+1,Length(FullName));
    CheckDatasetName := true;
  end
  else
  begin
    DatasetNamePart := '';
    FieldNamePart := FullName;
    CheckDatasetName := false;
  end;
  for i:=0 to FDatasets.Count-1 do
  begin
    Dataset := TRPDataset(FDatasets[i]);
    if not CheckDatasetName or (CompareText(Dataset.DatasetName,DatasetNamePart)=0) then
    begin
      Result := Dataset.FindField(FieldNamePart);
      if Result<>nil then
        Exit;
    end;
  end;
  Result := nil;
end;

procedure TRPDataEnvironment.AddDataset(Dataset: TRPDataset);
begin
  FDatasets.Add(Dataset);
end;

procedure TRPDataEnvironment.RemoveDataset(Dataset: TRPDataset);
begin
  FDatasets.Remove(Dataset);
end;

procedure TRPDataEnvironment.SetFieldMapping(const Value: TStrings);
begin
  FFieldMapping.Assign(Value);
end;

procedure TRPDataEnvironment.AddController(
  Controller: TRPDatasetController);
begin
  FControllers.Add(Controller);
end;

function TRPDataEnvironment.FindController(
  const ControllerName: string): TRPDatasetController;
var
  i : integer;
begin
  for i:=0 to FControllers.Count-1 do
    begin
      Result := TRPDatasetController(FControllers[i]);
      if (CompareText(Result.ControllerName,ControllerName)=0) then
        Exit;
    end;
  Result := nil;
end;

procedure TRPDataEnvironment.RemoveController(
  Controller: TRPDatasetController);
begin
  FControllers.Remove(Controller);
end;

procedure TRPDataEnvironment.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if Operation=opRemove then
  begin
    FDatasets.Remove(AComponent);
    FControllers.Remove(AComponent);
  end;
end;

procedure TRPDataEnvironment.UseDataset(Dataset: TRPDataset);
var
  i : integer;
begin
  i := FDatasets.IndexOf(Dataset);
  if i>=0 then
    FDatasets.Move(I,0);
end;

procedure TRPDataEnvironment.SetVariantValues(const Value: TStrings);
begin
  FVariantValues.Assign(Value);
end;

function TRPDataEnvironment.GetFieldText(const FieldName: string): string;
var
  Field : TRPField;
begin
  Field := FindField(FieldName);
  if Field<>nil then
    Result := Field.GetPrintableText
  else
  begin
    Result := VariantValues.Values[FieldName];
  end;
end;

function TRPDataEnvironment.FindDataset(
  const DatasetName: string): TRPDataset;
var
  i : integer;
begin
  for i:=0 to FDatasets.Count-1 do
  begin
    Result := TRPDataset(FDatasets[i]);
    if SameText(Result.DatasetName,DatasetName) then
      Exit;
  end;
  Result := nil;
end;

{ TRPDataField }

constructor TRPDataField.Create(ADataset: TRPDataset);
begin
  FDataset := ADataset;
end;

function TRPDataField.GetPrintableText(TextFormatType : TRPTextFormatType=tfNone;
  const TextFormat : string=''): string;
begin
  case TextFormatType of
    tfNormal    : case FieldType of
                    gfdtInteger : Result := Format(TextFormat,[AsInteger]);
                    gfdtFloat   : Result := Format(TextFormat,[AsFloat]);
                    gfdtString  : Result := Format(TextFormat,[AsString]);
                    gfdtDate    : Result := Format(TextFormat,[AsDateTime]);
                  else
                    Result := AsString;
                  end;
    tfFloat     : Result := FormatFloat(TextFormat,AsFloat);
    tfDateTime  : Result := FormatDateTime(TextFormat,AsDateTime);
  else
    Result := AsString; // tfNone
  end;
end;


{ TRPDataset }

function TRPDataset.FindField(const FieldName: string): TRPDataField;
var
  i, count : Integer;
begin
  count := FieldCount-1;
  for i:=0 to count do
  begin
    Result := Fields[i];
    if CompareText(Result.FieldName,FieldName)=0 then
      Exit;
  end;
  Result := nil;
end;

procedure TRPDataset.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent=FEnvironment) and (Operation=opRemove) then
    Environment:=nil;
end;

procedure TRPDataset.SetEnvironment(const Value: TRPDataEnvironment);
begin
  if FEnvironment <> Value then
  begin
    if FEnvironment<>nil then
      FEnvironment.RemoveDataset(Self);
    FEnvironment := Value;
    if FEnvironment<>nil then
    begin
      FEnvironment.AddDataset(Self);
      FEnvironment.FreeNotification(Self);
    end;
  end;
end;

{ TRPDataBrowser }

function TRPDataBrowser.GotoNextData: Boolean;
begin
  Result := InternalGotoNextData;
  FEof := not Result;
  FIsFirst := false;
end;

procedure TRPDataBrowser.Init;
begin
  FEof := False;
  FIsFirst := True;
end;

{ TRPDatasetBrowser }

constructor TRPDatasetBrowser.Create;
begin
  FController := nil;
  FGroupingIndex := -1;
  FGrouping := nil;
end;

function TRPDatasetBrowser.Available: Boolean;
begin
  Result := (FController<>nil) and FController.Available;
end;

procedure TRPDatasetBrowser.CheckController;
begin
  if Controller=nil then
  begin
    Assert(FEnvironment<>nil);
    Controller := FEnvironment.FindController(FControllerName);
    if Controller=nil then
      WriteLog('Not Find Controller:'+FControllerName,lcReport);
  end;
end;
{
function TRPDatasetBrowser.GetControllerName: String;
begin
  if FController<>nil then
    Result := FController.ControllerName
  else
    Result := FControllerName;
end;
}
function TRPDatasetBrowser.GetCurrentCount: Integer;
begin
  if FGrouping<>nil then
    Result:= FGrouping.FInternalCount
  else
    Result:= FController.FInternalCount;
end;

procedure TRPDatasetBrowser.Init;
begin
  inherited;
  CheckController;
  if (FGroupingIndex>=0) and (FGroupingIndex<FController.FGroupings.Count) then
    FGrouping := TRPDatasetGroup(FController.FGroupings[FGroupingIndex])
  else
    FGrouping := nil;
  if FGrouping<>nil then
    FGrouping.Prepare;
  FInternalCount := GetCurrentCount;
  if (Controller<>nil) and (Environment<>nil) then
    Environment.UseDataset(TRPDataset(Controller.Dataset));
end;

function TRPDatasetBrowser.InternalGotoNextData: Boolean;
{var
  CurrentGroupIndex : Integer;}
begin
  Assert(FController<>nil);
  if FInternalCount<>GetCurrentCount then
    Result:=false // reach a new dataset or a new group
  else
  begin
    // return true when there are data and not reach a new dataset or a new group
    Result := FController.GetData(not FIsFirst);
    if Result then
      Result := (FInternalCount=GetCurrentCount);
  end;
end;

procedure TRPDatasetBrowser.SetController(
  const Value: TRPDatasetController);
begin
  if FController <> Value then
  begin
    FController := Value;
    if FController<>nil then
    begin
      FControllerName := FController.ControllerName;
    end;
  end;
end;

procedure TRPDatasetBrowser.SetControllerName(const Value: String);
begin
  if FControllerName <> Value then
  begin
    FControllerName := Value;
    if Environment<>nil then
      FController := Environment.FindController(FControllerName);
  end;
end;

{ TRPDatasetController }

constructor TRPDatasetController.Create(AOwner : TComponent);
begin
  inherited;
  FGroupings := TObjectList.Create;
  FGroups:= TStringList.Create;
  FFromFirst := true;
  FEnvironment := nil;
  FDataset := nil;
  //FDataSource := TDataSource.Create;
end;

destructor TRPDatasetController.Destroy;
var
  Obj : TObject;
begin
  //Environment := nil;
  //FDataSource.Free;
  FGroups.Free;
  Obj := FGroupings;
  FGroupings := nil;
  Obj.Free;
  inherited;
end;

function TRPDatasetController.AddGroup: TRPDatasetGroup;
begin
  Result := TRPDatasetGroup.Create(self);
end;

function TRPDatasetController.GetData(IsGetNewData : Boolean): Boolean;
begin
  if IsGetNewData then
  begin
    Dataset.Next;
    Result := not Dataset.Eof;
    if Result then
      CheckGrouping;
  end
  else
  begin
    //Result := not Dataset.Empty;
    Result := not Dataset.Eof;
  end;

  //IsFirst := False;
end;

procedure TRPDatasetController.Init;
var
  i : integer;
  s : string;
begin
  //Assert(Dataset<>nil);
  if not Available then Exit;

  if FromFirst then
    Dataset.First;
  //IsFirst := True;
  FInternalCount := 0;

  FGroupings.Clear;
  for i:=0 to FGroups.Count-1 do
  begin
    s := trim(FGroups[i]);
    if s<>'' then
      AddGroup.FieldNames := s;
  end;

  for i:=0 to FGroupings.Count-1 do
    TRPDatasetGroup(FGroupings[i]).Init;
end;

procedure TRPDatasetController.SetDataset(const Value: TRPDataset);
begin
  if FDataset <> Value then
  begin
    FDataset := Value;
    if Dataset<>nil then
      Dataset.FreeNotification(Self);
  end;
  //FDataSource.Dataset := Value;
end;

procedure TRPDatasetController.CheckGrouping;
var
  i : integer;
  Changed : Boolean;
  Group : TRPDatasetGroup;
begin
  Changed := false;
  for i:=0 to FGroupings.Count-1 do
  begin
    Assert(TObject(FGroupings[i]) is TRPDatasetGroup);
    Group := TRPDatasetGroup(FGroupings[i]);
    if Changed then
      Group.SetNewGroup
    else
      Changed := Group.IsGroupChanged;
  end;
  { !!!!
    If group changed, it will call GoBack to stop cursor at the end of current group.
    The outter none-changed group will call GetData(true) to move cursor at the start of the new group
  }
  if Changed then
    GoBack;
end;

procedure TRPDatasetController.GoBack;
begin
  Assert(Dataset<>nil);
  Dataset.Prior;
end;

function TRPDatasetController.Available: Boolean;
begin
  Result := Dataset<>nil;
end;

procedure TRPDatasetController.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation=opRemove) then
  begin
    if (AComponent=Dataset) then
      FDataset := nil;
    if (AComponent=Environment) then
      Environment := nil;
  end;
end;

procedure TRPDatasetController.SetGroups(const Value: TStrings);
begin
  FGroups.Assign(Value);
end;

procedure TRPDatasetController.SetEnvironment(
  const Value: TRPDataEnvironment);
begin
  if FEnvironment <> Value then
  begin
    if FEnvironment<>nil then
      FEnvironment.RemoveController(Self);
    FEnvironment := Value;
    if FEnvironment<>nil then
    begin
      FEnvironment.AddController(Self);
      FEnvironment.FreeNotification(Self);
    end;
  end;
end;

{ TRPDatasetGroup }

constructor TRPDatasetGroup.Create(AController: TRPDatasetController);
begin
  Assert(AController<>nil);
  FController := AController;
  FController.FGroupings.Add(self);
  //FFields := TList.Create;
  FFieldNames := '';
  FGroupFields := TObjectList.Create;
end;

destructor TRPDatasetGroup.Destroy;
begin
  if FController.FGroupings<>nil then
    FController.FGroupings.Extract(self);
  //FFields.Free;
  FGroupFields.Free;
  inherited;
end;

procedure TRPDatasetGroup.Init;
begin
  FInternalCount := 0;
end;
{
procedure TRPDatasetGroup.AddField(Field: TField);
begin
  if Field<>nil then
  begin
    Assert(Field.Dataset=FController.Dataset);
    FFields.Add(Field);
  end;
end;

procedure TRPDatasetGroup.AddField(const FieldName: string);
begin
  AddField(FController.Dataset.FindField(FieldName));
end;
}
function TRPDatasetGroup.IsGroupChanged: Boolean;
var
  i : integer;
begin
  Result := false;
  for i:=0 to FGroupFields.Count-1 do
    if TRPGroupField(FGroupFields[i]).IsChanged then
    begin
      Result := true;
      Break;
    end;
  if Result then
    SetNewGroup;
end;

procedure TRPDatasetGroup.Prepare;
begin
  // must re-create fields
  // because in master-detail link
  // the detail table field objects may be re-created
  //(example detail table is a TQuery)
  PrepareGroupFields;
  SaveGroupFieldsData;
end;

procedure TRPDatasetGroup.PrepareGroupFields;
var
  i,len : integer;
  S,FieldName : string;
  Field : TRPDataField;
begin
  S := FFieldNames;
  FGroupFields.Clear;
  S := Trim(S);
  len := Length(S);

  while len>0 do
  begin
    i := pos(';',S);
    if (i>0) then
    begin
      FieldName := Copy(S,1,i-1);
      S := Copy(S,i+1,len);
    end
    else
    begin
      FieldName := S;
      S := '';
    end;
    { TODO : Correct Field }

    Field := FController.Dataset.FindField(FieldName);
    if Field<>nil then
      FGroupFields.Add(TRPGroupField.Create(Field));

    len := Length(S);
  end;
end;

procedure TRPDatasetGroup.SaveGroupFieldsData;
var
  i : integer;
begin
  for i:=0 to FGroupFields.Count-1 do
    TRPGroupField(FGroupFields[i]).SaveValue;
end;

procedure TRPDatasetGroup.SetNewGroup;
begin
  Inc(FInternalCount);
  // must have this below line!
  // 将字段的值设定为新组的值可以避免再次产生分组.
  SaveGroupFieldsData;
end;

{ TRPGroupField }

constructor TRPGroupField.Create(AField: TRPDataField);
begin
  FField := AField;
  FSavedData.DataType := FField.FieldType;
end;

function TRPGroupField.IsChanged: Boolean;
begin
  Result := true;
  case FSavedData.DataType of
    gfdtInteger: Result := FSavedData.IValue <> FField.AsInteger;
    gfdtFloat:   Result := FSavedData.FValue <> FField.AsFloat;
    gfdtString:  Result := FSavedData.SValue <> FField.AsString;
    gfdtDate:    Result := FSavedData.DValue <> FField.AsDateTime;
  else  Assert(false);  
  end;
end;

procedure TRPGroupField.SaveValue;
begin
  case FSavedData.DataType of
    gfdtInteger: FSavedData.IValue := FField.AsInteger;
    gfdtFloat:   FSavedData.FValue := FField.AsFloat;
    gfdtString:  FSavedData.SValue := FField.AsString;
    gfdtDate:    FSavedData.DValue := FField.AsDateTime;
  end;
end;

{ TRPDataEntry }

constructor TRPDataEntry.Create(Collection: TCollection);
begin
  inherited;
  FGroups := TStringList.Create;
  FFromFirst := true;
end;

destructor TRPDataEntry.Destroy;
begin
  FGroups.Free;
  inherited;
end;

function TRPDataEntry.GetDisplayName: string;
begin
  Result := ControllerName;
end;

procedure TRPDataEntry.SetControllerName(const Value: string);
begin
  FControllerName := Value;
  if FDatasetName='' then
    FDatasetName := Value;
end;

procedure TRPDataEntry.SetDatasetName(const Value: string);
begin
  FDatasetName := Value;
  if FControllerName='' then
    FControllerName:= Value;
end;

procedure TRPDataEntry.SetGroups(const Value: TStrings);
begin
  FGroups.Assign(Value);
end;

{ TRPDataEntries }

constructor TRPDataEntries.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner,TRPDataEntry);
  FControllers := TObjectList.Create;
end;

destructor TRPDataEntries.Destroy;
begin
  FControllers.Free;
  inherited;
end;

procedure TRPDataEntries.CreateControllers(
  Environment: TRPDataEnvironment);
var
  Controller : TRPDatasetController;
  i : integer;
begin
  FControllers.Clear;
  for i:=0 to Count-1 do
  with Items[i] do
  begin
    Controller := TRPDatasetController.Create(nil);
    Controller.ControllerName := ControllerName;
    Controller.Groups := Groups;
    //Controller.Dataset := Dataset;
    Controller.FromFirst := FromFirst;
    Controller.Environment := Environment;
    if Environment<>nil then
      Controller.Dataset := Environment.FindDataset(DatasetName);
    FControllers.Add(Controller);
  end;
end;

function TRPDataEntries.GetItems(Index: Integer): TRPDataEntry;
begin
  Result := TRPDataEntry(inherited Items[Index]);
end;

function TRPDataEntries.IndexOfController(
  const ControllerName: string): Integer;
var
  i : integer;
begin
  for i:=0 to Count-1 do
    if SameText(Items[i].ControllerName,ControllerName) then
    begin
      Result := i;
      Exit;
    end;
  Result := -1;
end;

function TRPDataEntries.IndexOfDataset(const DatasetName: string): Integer;
var
  i : integer;
begin
  for i:=0 to Count-1 do
    if SameText(Items[i].DatasetName,DatasetName) then
    begin
      Result := i;
      Exit;
    end;
  Result := -1;
end;

procedure TRPDataEntries.AddDataset(Dataset: TRPDataset);
var
  i : integer;
begin
  i := IndexOfDataset(Dataset.DatasetName);
  CheckTrue(i>=0,'No Entry For '+Dataset.DatasetName);
  Dataset.Environment := TRPDatasetController(Controllers[i]).Environment;
  TRPDatasetController(Controllers[i]).Dataset := Dataset;
end;


procedure TRPDataEntries.Clear;
begin
  inherited;
  ClearControllers;
end;

procedure TRPDataEntries.ClearControllers;
begin
  Controllers.Clear;
end;

procedure TRPDataEntries.BindDatasets(Environment: TRPDataEnvironment);
var
  I : Integer;
  Dataset : TRPDataset;
begin
  if (Environment<>nil) and (Controllers.Count=Count) then
    for I:=0 to Count-1 do
    begin
      Dataset := Environment.FindDataset(Items[i].DatasetName);
      if Dataset<>nil then
        TRPDatasetController(Controllers[I]).Dataset := Dataset;
    end;
end;

end.
