unit RPDataBrowsers;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>RPDataBrowsers (Report Data Browser)
   <What>在打印报表时，控制数据集的浏览（游标移动）
   <Written By> Huang YanLai (黄燕来)
   <History>
    修改自UDataBrowsers.pas(用于算法测试),类名使用前缀RP
**********************************************}

interface

uses SysUtils, Classes, Contnrs, RPDB;

type
  TRPDatasetController = class;
  TRPDatasetGroup = class;

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
      Controller    - 关联到控制对象（根据ReportName和ControllerName确定）
      GroupingIndex - 分组的编号
      ReportName    - 报表名称
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
    //FReportName: string;
    //function    GetControllerName: String;
    procedure   SetControllerName(const Value: String);
    //procedure   SetReportName(const Value: string);
    procedure   CheckController;
    procedure   SetController(const Value: TRPDatasetController);
  protected
    function    GetCurrentCount: Integer;
    function    InternalGotoNextData: Boolean; override;
  public
    constructor Create;
    procedure   Init; override;
    property    Controller : TRPDatasetController read FController write SetController;
    property    GroupingIndex : Integer read FGroupingIndex write FGroupingIndex;
    property    InternalCount : Integer read FInternalCount;
    //property    ReportName : string read FReportName write SetReportName;
    property    ControllerName : string read FControllerName write SetControllerName;
    function    Available: Boolean;
  end;

  {
    <Class>TRPDatasetController
    <What>控制数据集的移动。支持分组。
    <Properties>
      Dataset - 关联的数据集对象
      ControllerName - 名字
      ReportName  - 报表名字
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
    FReportName: string;
    FGroups: TStrings;
    FFromFirst: Boolean;
    //FDataSource : TDataSource;
    procedure   SetDataset(const Value: TRPDataset);
    function    AddGroup: TRPDatasetGroup;
    procedure   SetGroups(const Value: TStrings);
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
    property    ReportName : string read FReportName write FReportName;
    property    Groups : TStrings read FGroups write SetGroups;
    property    FromFirst: Boolean read FFromFirst write FFromFirst default true;
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
    property    FieldNames : String read FFieldNames write FFieldNames;
  end;

(*
  {
    <Class>TRPControllerManager
    <What>管理所有的TRPDatasetController对象
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TRPControllerManager = class (TObject)
  private
    FControllers: TObjectList;
  protected

  public
    constructor Create;
    Destructor  Destroy; override;
    procedure   Init(const ReportName:string; DatasetList : TList=nil);
    function    FindController(const ReportName, Name:String): TRPDatasetController;
    property    Controllers : TObjectList read FControllers;
  end;

var
  ControllerManager : TRPControllerManager;
*)
implementation

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
      FReportName := FController.ReportName;
      FControllerName := FController.ControllerName;
    end;
  end;
end;

procedure TRPDatasetBrowser.SetControllerName(const Value: String);
begin
  if FControllerName <> Value then
  begin
    FControllerName := Value;
    //Controller := ControllerManager.FindController(FReportName,FControllerName);
  end;
end;
(*
procedure TRPDatasetBrowser.SetReportName(const Value: string);
begin
  if FReportName <> Value then
  begin
    FReportName := Value;
    Controller := ControllerManager.FindController(FReportName,FControllerName);
  end;
end;
*)
{ TRPDatasetController }

constructor TRPDatasetController.Create(AOwner : TComponent);
begin
  inherited;
  FGroupings := TObjectList.Create;
  FGroups:= TStringList.Create;
  Assert(ControllerManager<>nil);
  ControllerManager.FControllers.Add(self);
  FFromFirst := true;
  //FDataSource := TDataSource.Create;
end;

destructor TRPDatasetController.Destroy;
var
  Obj : TObject;
begin
  if (ControllerManager<>nil) and (ControllerManager.FControllers<>nil) then
    ControllerManager.FControllers.Extract(self);
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
  Assert(Dataset<>nil);
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
  if (AComponent=Dataset) and (Operation=opRemove) then
    FDataset := nil;
end;

procedure TRPDatasetController.SetGroups(const Value: TStrings);
begin
  FGroups.Assign(Value);
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

{ TRPControllerManager }

constructor TRPControllerManager.Create;
begin
  FControllers := TObjectList.Create;
end;

destructor TRPControllerManager.Destroy;
var
  Obj : TObject;
begin
  Obj := FControllers;
  FControllers := nil;
  Obj.Free;
  inherited;
end;

function TRPControllerManager.FindController(
  const ReportName, Name: String): TRPDatasetController;
var
  i : integer;
begin
  if Name<>'' then
    for i:=0 to FControllers.Count-1 do
    begin
      Result := TRPDatasetController(FControllers[i]);
      if (CompareText(Result.ControllerName,Name)=0)
        and (CompareText(Result.ReportName,ReportName)=0) then
        Exit;
    end;
  Result := nil;
end;

procedure TRPControllerManager.Init(const ReportName:string; DatasetList : TList);
var
  i : integer;
  Controller : TRPDatasetController;
begin
  for i:=0 to FControllers.Count-1 do
  begin
    Controller := TRPDatasetController(FControllers[i]);
    if CompareText(Controller.ReportName,ReportName)=0 then
    begin
      Controller.Init;
      if (DatasetList<>nil) and (Controller.Dataset<>nil) then
        DatasetList.Add(Controller.Dataset);
    end;
  end;
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

initialization
  ControllerManager := TRPControllerManager.Create;

finalization
  ControllerManager.Free;

end.
