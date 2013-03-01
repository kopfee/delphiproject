unit WVCmdReq;
{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>WVCmdReq
   <What>根据WorkView里面的数据自动产生Command的组件。
  用于自动完成对请求的数据绑定
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

{$I KSConditions.INC }

interface

uses SysUtils, Classes, DataTypes, WVCommands, WorkViews;

type
  TWVRequest = class;

  TWVBindingDirection = (bdField2Param, bdParam2Field, bdBiDirection);
  TWVBindingEvent = procedure (FieldData, ParamData : TKSDataObject) of object;
  {
    <Class>TWVFieldParamBinding
    <What>描述工作字段和命令参数的绑定关系
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TWVFieldParamBinding = class(TCollectionItem)
  private
    FFieldName: string;
    FParamName: string;
    FDirection: TWVBindingDirection;
    FRequest: TWVRequest;
    FOnBindInput: TWVBindingEvent;
    FOnBindOutput: TWVBindingEvent;
    FDefaultValue: Variant;
    procedure   BindInput(Command : TWVCommand);
    procedure   BindOutput(Command : TWVCommand);
    procedure   ClearOutput;
  protected
    function    GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    procedure   Assign(Source: TPersistent); override;
    property    Request : TWVRequest read FRequest;
  published
    property    ParamName : string read FParamName write FParamName;
    property    FieldName : string read FFieldName write FFieldName;
    property    Direction : TWVBindingDirection read FDirection write FDirection default bdField2Param;
    property    DefaultValue : Variant read FDefaultValue write FDefaultValue;
    property    OnBindInput : TWVBindingEvent read FOnBindInput write FOnBindInput;
    property    OnBindOutput : TWVBindingEvent read FOnBindOutput write FOnBindOutput;
  end;

  TRequestEvent = procedure (Request : TWVRequest; Command : TWVCommand) of object;
  {
    <Class>TWVRequest
    <What>完成workview和command之间的数据绑定
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TWVRequest = class(TComponent)
  private
    FWorkView: TWorkView;
    FID: TWVCommandID;
    FVersion: TWVCommandVersion;
    FContext: TWVContext;
    FBindings: TCollection;
    FBeforeExec: TRequestEvent;
    FAfterExec: TRequestEvent;
    FClearOutputsBeforeExec: Boolean;
    procedure   SetWorkView(const Value: TWorkView);
    procedure   SetBindings(const Value: TCollection);
    procedure   BindInputs(Command : TWVCommand);
    procedure   BindOutputs(Command : TWVCommand);
    procedure   ClearOutputs;
    procedure   DoBeforeExec(Command : TWVCommand);
    procedure   DoAfterExec(Command : TWVCommand);
  protected
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
    property    Context : TWVContext read FContext write FContext;
    procedure   SendCommand;
  published
    property    WorkView : TWorkView read FWorkView write SetWorkView;
    property    ID : TWVCommandID read FID write FID;
    property    Version : TWVCommandVersion read FVersion write FVersion default 1;
    property    Bindings : TCollection read FBindings write SetBindings;
    property    BeforeExec : TRequestEvent read FBeforeExec write FBeforeExec;
    property    AfterExec : TRequestEvent read FAfterExec write FAfterExec;
    property    ClearOutputsBeforeExec : Boolean read FClearOutputsBeforeExec write FClearOutputsBeforeExec default True;
  end;


implementation

uses SafeCode
{$ifdef VCL60_UP }
,Variants
{$else}

{$endif}
;

type
  TOwnedCollectionAccess = class(TOwnedCollection);

{ TWVFieldParamBinding }

constructor TWVFieldParamBinding.Create(Collection: TCollection);
begin
  inherited;
  FRequest := TWVRequest(TOwnedCollectionAccess(Collection).GetOwner);
  FDirection := bdField2Param;
  FDefaultValue := Unassigned;
end;

procedure TWVFieldParamBinding.Assign(Source: TPersistent);
begin
  if Source is TWVFieldParamBinding then
    with TWVFieldParamBinding(Source) do
    begin
      Self.ParamName := ParamName;
      Self.FieldName := FieldName;
      Self.Direction := Direction;
    end
  else
    inherited;
end;

function TWVFieldParamBinding.GetDisplayName: string;
var
  S : string;
begin
  case Direction of
    bdField2Param : S := '->';
    bdParam2Field : S := '<-';
  else
    S := '<->';
  end;
  Result := FieldName + S + ParamName;
end;

procedure TWVFieldParamBinding.BindInput(Command: TWVCommand);
var
  Field : TWVField;
  FieldData, ParamData : TKSDataObject;
begin
  CheckObject(Request.WorkView,'Error : Invalid WorkView For TWVRequest');
  if Direction in [bdField2Param, bdBiDirection] then
  begin
    if FieldName<>'' then
    begin
      Field := Request.WorkView.FieldByName(FieldName);
      FieldData := Field.Data;
    end else
    begin
      Field := nil;
      FieldData := nil;
    end;
    ParamData := Command.ParamData(ParamName);
    if Assigned(FOnBindInput) then
      FOnBindInput(FieldData,ParamData)
    else if Field<>nil then
    begin
      // 如果指定了字段，使用字段的值
      if not FieldData.IsEmpty then // 如果数据为空，使用命令参数的缺省值
        ParamData.Assign(FieldData);
    end
    else // 如果没有指定字段，使用绑定里面的缺省值(常数)
      if not VarIsEmpty(DefaultValue) then // 如果数据为空，使用命令参数的缺省值
        ParamData.Value := DefaultValue;
  end;
end;

procedure TWVFieldParamBinding.BindOutput(Command: TWVCommand);
var
  Field : TWVField;
  FieldData, ParamData : TKSDataObject;
begin
  CheckObject(Request.WorkView,'Error : Invalid WorkView For TWVRequest');
  if Direction in [bdParam2Field, bdBiDirection] then
  begin
    Field := Request.WorkView.FieldByName(FieldName);
    FieldData := Field.Data;
    if ParamName<>'' then
      ParamData := Command.ParamData(ParamName) else
      ParamData := nil;
    if Assigned(FOnBindOutput) then
      FOnBindOutput(FieldData,ParamData)
    else if ParamData<>nil then
      // 如果指定参数，使用参数的值
      FieldData.Assign(ParamData)
    else
      // 如果没有指定参数，使用缺省值
      FieldData.Value := DefaultValue;
  end;
end;

procedure TWVFieldParamBinding.ClearOutput;
var
  Field : TWVField;
  FieldData : TKSDataObject;
begin
  CheckObject(Request.WorkView,'Error : Invalid WorkView For TWVRequest');
  if Direction in [bdParam2Field] then
  begin
    Field := Request.WorkView.FieldByName(FieldName);
    FieldData := Field.Data;
    FieldData.Clear;
  end;
end;

{ TWVRequest }

constructor TWVRequest.Create(AOwner: TComponent);
begin
  inherited;
  FID := '';
  FVersion := 1;
  FBindings := TOwnedCollection.Create(Self, TWVFieldParamBinding);
  FClearOutputsBeforeExec := True;
end;

destructor TWVRequest.Destroy;
begin
  FreeAndNil(FBindings);
  inherited;
end;

procedure TWVRequest.DoAfterExec(Command : TWVCommand);
begin
  if Assigned(AfterExec) then
    AfterExec(Self,Command);
end;

procedure TWVRequest.DoBeforeExec(Command : TWVCommand);
begin
  if Assigned(BeforeExec) then
    BeforeExec(Self,Command);
end;

procedure TWVRequest.BindInputs(Command : TWVCommand);
var
  I : Integer;
begin
  for I:=0 to Bindings.Count-1 do
  begin
    TWVFieldParamBinding(Bindings.Items[I]).BindInput(Command);
  end;
end;

procedure TWVRequest.BindOutputs(Command : TWVCommand);
var
  I : Integer;
begin
  for I:=0 to Bindings.Count-1 do
  begin
    TWVFieldParamBinding(Bindings.Items[I]).BindOutput(Command);
  end;
end;

procedure TWVRequest.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation=opRemove) and (AComponent=WorkView) then
  begin
    WorkView := nil;
  end;
end;

procedure TWVRequest.SendCommand;
var
  Command : TWVCommand;
begin
  CheckObject(Context,'Invalid Context');
  Command := Context.CommandFactory.NewCommand(ID,Version);
  try
    BindInputs(Command);
    if FClearOutputsBeforeExec then
      ClearOutputs;
    DoBeforeExec(Command);
    Context.CommandBus.Process(Command);
    DoAfterExec(Command);
    BindOutputs(Command);
    Command.CheckError;
  finally
    Command.Free;
  end;
end;

procedure TWVRequest.SetBindings(const Value: TCollection);
begin
  FBindings.Assign(Value);
end;

procedure TWVRequest.SetWorkView(const Value: TWorkView);
begin
  if FWorkView<>Value then
  begin
    FWorkView := Value;
    if FWorkView<>nil then
      FWorkView.FreeNotification(Self);
  end;
end;

procedure TWVRequest.ClearOutputs;
var
  I : Integer;
begin
  for I:=0 to Bindings.Count-1 do
    TWVFieldParamBinding(Bindings.Items[I]).ClearOutput;
end;

end.
