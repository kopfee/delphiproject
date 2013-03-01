unit KCWVProcBinds;

{$I KSConditions.INC }

interface

uses SysUtils, Classes, KCDataAccess, WVCommands, WVCmdProc, WVCmdReq, BDAImpEx, LogFile;

const
  SReturn = '@Return';
  SDataset = '@Dataset';
  SMessageFieldName1 = 'vsmess';
  SMessageFieldName2 = 'vsvarstr0';

  lcKCProcessor = 18;

type
  TKCWVCustomProcessor = class;
  TKCParamBinding = class;

  TKCWVProcBindingEvent = procedure (Dataset : TKCDataset; Command : TWVCommand; Binding : TKCParamBinding) of object;

  TKCParamBinding = class(TCollectionItem)
  private
    FFieldName: string;
    FParamName: string;
    FProcessor: TKCWVCustomProcessor;
    FOnBindInput: TKCWVProcBindingEvent;
    FDefaultValue: Variant;
    FOnBindOutput: TKCWVProcBindingEvent;
    procedure   BindInput(Dataset : TKCDataset; Command : TWVCommand);
    procedure   BindOutput(Dataset : TKCDataset; Command : TWVCommand);
  protected
    function    GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    procedure   Assign(Source: TPersistent); override;
    property    Processor : TKCWVCustomProcessor read FProcessor;
  published
    property    ParamName : string read FParamName write FParamName;
    property    FieldName : string read FFieldName write FFieldName;
    property    DefaultValue : Variant read FDefaultValue write FDefaultValue;
    property    OnBindInput : TKCWVProcBindingEvent read FOnBindInput write FOnBindInput;
    property    OnBindOutput : TKCWVProcBindingEvent read FOnBindOutput write FOnBindOutput;
  end;

  TBindDataEvent = procedure (Dataset : TKCDataset; Command : TWVCommand) of object;

  TKCWVCustomProcessor = class(TWVCustomProcessor)
  private
    FInputBindings: TCollection;
    FRequestType: Integer;
    FTimeout: Integer;
    FOnBindInput: TBindDataEvent;
    FOnBindOutput: TBindDataEvent;
    FOpenCursor: Boolean;
    FSleepBetweenReceive: Integer;
    FOutputBindings: TCollection;
    FFuncNo: Word;
    FAggregateFieldsSettings: string;
    FLogMessage: Boolean;
    procedure   SetInputBindings(const Value: TCollection);
    procedure   SetOutputBindings(const Value: TCollection);
  protected
    procedure   Process(Command: TWVCommand); override;
    procedure   BindInputs(Dataset : TKCDataset; Command : TWVCommand); virtual;
    procedure   BindOutputs(Dataset : TKCDataset; Command : TWVCommand); virtual;
    function    GetDataset : TKCDataset; virtual; abstract;
    procedure   FreeDataset(Dataset : TKCDataset); virtual;
    procedure   InitDataset(Dataset : TKCDataset); virtual;
    property    OpenCursor : Boolean read FOpenCursor write FOpenCursor default True;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
  published
    property    InputBindings : TCollection read FInputBindings write SetInputBindings;
    property    OutputBindings : TCollection read FOutputBindings write SetOutputBindings;
    property    FuncNo : Word read FFuncNo write FFuncNo default 0;
    property    RequestType : Integer read FRequestType write FRequestType;
    property    AggregateFieldsSettings : string read FAggregateFieldsSettings write FAggregateFieldsSettings;
    property    LogMessage : Boolean read FLogMessage write FLogMessage default True;
    property    Timeout : Integer read FTimeout write FTimeout default -1;
    property    SleepBetweenReceive : Integer read FSleepBetweenReceive write FSleepBetweenReceive default -1;
    property    OnBindInput : TBindDataEvent read FOnBindInput write FOnBindInput;
    property    OnBindOutput : TBindDataEvent read FOnBindOutput write FOnBindOutput;
  end;

  TKCWVProcessor = class(TKCWVCustomProcessor)
  private
    FKCDataset: TKCDataset;
    procedure   SetKCDataset(const Value: TKCDataset);
  protected
    function    GetDataset : TKCDataset; override;
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
  public

  published
    property    KCDataset : TKCDataset read FKCDataset write SetKCDataset;
    property    OpenCursor;
  end;

  TKCWVQuery = class(TKCWVCustomProcessor)
  private
    FKCDatabase: TKCDatabase;
    procedure   SetKCDatabase(const Value: TKCDatabase);
  protected
    function    GetDataset : TKCDataset; override;
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
  public

  published
    property    KCDatabase : TKCDatabase read FKCDatabase write SetKCDatabase;
  end;

implementation

uses SafeCode, DBAIntf, KCDataPack, DataTypes, DB
{$ifdef VCL60_UP }
,Variants
{$else}

{$endif}
;

type
  TOwnedCollectionAccess = class(TOwnedCollection);

{ TKCParamBinding }

constructor TKCParamBinding.Create(Collection: TCollection);
begin
  inherited;
  FProcessor := TKCWVCustomProcessor(TOwnedCollectionAccess(Collection).GetOwner);
  FDefaultValue := Unassigned;
end;

procedure TKCParamBinding.Assign(Source: TPersistent);
begin
  if Source is TKCParamBinding then
    with TKCParamBinding(Source) do
    begin
      Self.ParamName := ParamName;
      Self.FieldName := FieldName;
    end
  else
    inherited;
end;

procedure TKCParamBinding.BindInput(Dataset : TKCDataset; Command: TWVCommand);
var
  I : Integer;
  DatasetParam : THRPCParam;
  CommandParamData : TKSDataObject;
begin
  I := KCFindParam(FieldName);
  CheckTrue(I>=0,'Invalid Param '+FieldName);
  DatasetParam := Dataset.Params.Add;
  DatasetParam.Name := FieldName;
  // set datatype
  case KCPackDataTypes[I] of
    kcChar,kcBit :  DatasetParam.DataType := DBAIntf.ftChar;
    kcInteger:DatasetParam.DataType := DBAIntf.ftInteger;
    kcFloat:  DatasetParam.DataType := DBAIntf.ftFloat;
  else Assert(False);
  end;
  if ParamName<>'' then
    CommandParamData := Command.ParamData(ParamName) else
    CommandParamData := nil;
  if Assigned(OnBindInput) then
    OnBindInput(Dataset,Command,Self) else
  begin
    if CommandParamData<>nil then
      // get value from  command param
      case KCPackDataTypes[I] of
        kcChar,kcBit :  DatasetParam.AsString := CommandParamData.AsString;
        kcInteger:DatasetParam.AsInteger := CommandParamData.AsInteger;
        kcFloat:  DatasetParam.AsFloat := CommandParamData.AsFloat;
      else Assert(False);
      end
    else
      // get value from  default
      case KCPackDataTypes[I] of
        kcChar,kcBit :  DatasetParam.AsString := DefaultValue;
        kcInteger:DatasetParam.AsInteger := DefaultValue;
        kcFloat:  DatasetParam.AsFloat := DefaultValue;
      else Assert(False);
      end
  end;
end;

procedure TKCParamBinding.BindOutput(Dataset : TKCDataset; Command: TWVCommand);
begin
  if Assigned(OnBindOutput) then
    OnBindOutput(Dataset,Command,Self)
  else if SameText(FieldName,SReturn) then
    Command.ParamData(ParamName).Value := Dataset.ReturnCode
  else if SameText(FieldName,SDataset) then
    Command.ParamData(ParamName).SetObject(Dataset)
  else if Dataset.IsEmpty then
    Command.ParamData(ParamName).Clear
  else
    if Dataset.FindField(FieldName)<>nil then
      Command.ParamData(ParamName).Value := Dataset.FieldByName(FieldName).Value
  else
      Command.ParamData(ParamName).Value := DefaultValue; // 允许对应的数据不存在
end;

function TKCParamBinding.GetDisplayName: string;
begin
  Result := FieldName + '-' + ParamName;
end;

{ TKCWVCustomProcessor }

constructor TKCWVCustomProcessor.Create(AOwner: TComponent);
begin
  inherited;
  FInputBindings := TOwnedCollection.Create(Self,TKCParamBinding);
  FOutputBindings := TOwnedCollection.Create(Self,TKCParamBinding);
  FTimeout := -1;
  FSleepBetweenReceive := -1;
  FFuncNo := 0;
  FOpenCursor := True;
  FLogMessage := True;
end;

destructor TKCWVCustomProcessor.Destroy;
begin
  FInputBindings.Free;
  FOutputBindings.Free;
  inherited;
end;

procedure TKCWVCustomProcessor.BindInputs(Dataset: TKCDataset;
  Command: TWVCommand);
var
  I : Integer;
  Binding : TKCParamBinding;
begin
  Dataset.Params.Clear;
  for I:=0 to FInputBindings.Count-1 do
  begin
    Binding := TKCParamBinding(FInputBindings.Items[I]);
    Binding.BindInput(Dataset,Command);
  end;
  if Assigned(FOnBindInput) then
    FOnBindInput(Dataset,Command);
end;

procedure TKCWVCustomProcessor.BindOutputs(Dataset: TKCDataset;
  Command: TWVCommand);
var
  I : Integer;
  Binding : TKCParamBinding;
  Field : TField;
  Msg, Msg1, Msg2 : string;
begin
  if LogMessage then
  begin
    Field := Dataset.FindField(SMessageFieldName1);
    if Field<>nil then
      Msg1 := Field.AsString else
      Msg1 := '';
    Field := Dataset.FindField(SMessageFieldName2);
    if Field<>nil then
      Msg2 := Format('%s[%s]',[Msg,Field.AsString]) else
      Msg2 := '';
    Msg := Format('After Command Process,ID=%s,Version=%d,Request=%d,Return=%d,Msg1=%s,Msg2=%s',
      [ID,Version,RequestType,Dataset.ReturnCode,Msg1,Msg2]);
    WriteLog(Msg,lcKCProcessor);
  end;
  for I:=0 to FOutputBindings.Count-1 do
  begin
    Binding := TKCParamBinding(FOutputBindings.Items[I]);
    Binding.BindOutput(Dataset,Command);
  end;
  if Assigned(FOnBindOutput) then
    FOnBindOutput(Dataset,Command);
end;

procedure TKCWVCustomProcessor.Process(Command: TWVCommand);
var
  Dataset : TKCDataset;
begin
  try
    Dataset := GetDataset;
    CheckObject(Dataset,'Invalid Dataset For TKCWVCustomProcessor.');
    try
      Dataset.Active := False;
      InitDataset(Dataset);
      BindInputs(Dataset,Command);
      if OpenCursor then
      begin
        try
          Dataset.Open;
        except
          on EDBNoDataset do ;
        end;
      end else
        Dataset.Exec;
      BindOutputs(Dataset,Command);
    finally
      FreeDataset(Dataset);
    end;
  except
    on E : Exception do
      Command.Error := E;
  end;
end;

procedure TKCWVCustomProcessor.SetInputBindings(const Value: TCollection);
begin
  FInputBindings.Assign(Value);
end;

procedure TKCWVCustomProcessor.FreeDataset(Dataset: TKCDataset);
begin

end;

procedure TKCWVCustomProcessor.InitDataset(Dataset: TKCDataset);
begin
  if Timeout>=0 then
    Dataset.Timeout := Timeout;
  if SleepBetweenReceive>=0 then
    Dataset.SleepBetweenReceive := SleepBetweenReceive;
  Dataset.FuncNo := FuncNo;
  Dataset.RequestType := RequestType;
  Dataset.AggregateFieldsSettings := AggregateFieldsSettings;
end;

procedure TKCWVCustomProcessor.SetOutputBindings(const Value: TCollection);
begin
  FOutputBindings.Assign(Value);
end;

{ TKCWVProcessor }

function TKCWVProcessor.GetDataset: TKCDataset;
begin
  Result := FKCDataset;
end;

procedure TKCWVProcessor.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent=FKCDataset) and (Operation=opRemove) then
    FKCDataset := nil;
end;

procedure TKCWVProcessor.SetKCDataset(const Value: TKCDataset);
begin
  if FKCDataset <> Value then
  begin
    FKCDataset := Value;
    if FKCDataset<>nil then
      FKCDataset.FreeNotification(Self);
  end;
end;

{ TKCWVQuery }

function TKCWVQuery.GetDataset: TKCDataset;
begin
  CheckObject(FKCDatabase,'Invalid Database');
  // 必须设置Dataset的Owner是nil，交给WorkView管理Dataset的生命期。
  Result := TKCDataset.Create(nil);
  Result.Database := FKCDatabase;
end;

procedure TKCWVQuery.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent=FKCDatabase) and (Operation=opRemove) then
    FKCDatabase := nil;
end;

procedure TKCWVQuery.SetKCDatabase(const Value: TKCDatabase);
begin
  if FKCDatabase <> Value then
  begin
    FKCDatabase := Value;
    if KCDatabase<>nil then
      FKCDatabase.FreeNotification(Self);
  end;
end;

end.
