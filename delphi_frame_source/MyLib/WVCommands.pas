unit WVCommands;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>WVCommands
   <What>命令模型
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

interface

uses SysUtils, Classes, DataTypes, Contnrs;

const
  // log category
  lcCommand = 6;

type
  TWVCommandID = string;
  TWVCommandVersion = Integer;
  TWVParamType = (ptInput,ptOutput,ptInputOutput);

  TWVContext = class;
  TWVCommand = class;
  TWVCommandDescriptor = class;
  TWVCommandFactory = class;
  TWVCommandBus = class;
  TWVCommandProcessor = class;
  TWVCommandFilter = class;

  {
    <Class>TWVContextedObject
    <What>处于运行环境中的基对象。运行环境结束的时候自动被运行环境释放
    <Properties>
      Context - 运行环境
    <Methods>
      -
    <Event>
      -
  }
  TWVContextedObject = class(TObject)
  private
    FContext: TWVContext;
  protected
    procedure   Initialize; virtual;
  public
    constructor Create(AContext : TWVContext);
    destructor  Destroy;override;
    property    Context : TWVContext read FContext;
  end;

  {
    <Class>TWVMetaCommand
    <What>元命令。是命令类和命令描述类的公共父类
    <Properties>
      ID - 命令标志
      Version - 版本号
    <Methods>
      -
    <Event>
      -
  }
  TWVMetaCommand = class(TWVContextedObject)
  private
    FID: TWVCommandID;
    FVersion: TWVCommandVersion;
  public
    constructor Create(AContext : TWVContext; AID : TWVCommandID; AVersion : TWVCommandVersion); virtual;
    property    ID : TWVCommandID read FID;
    property    Version : TWVCommandVersion read FVersion;
  end;

  {
    <Class>TWVCommand
    <What>命令对象类
    <Properties>
      -
    <Methods>
      FindParamData - 根据参数名查找参数值对象
      ParamData - 根据参数名或者索引查找参数值对象，如果找不到，抛出意外错误。
    <Event>
      -
  }
  TWVCommand = class(TWVMetaCommand)
  private
    FParamData : TObjectList;
    procedure   SetDescriptor(const Value: TWVCommandDescriptor);
    procedure   CreateParamData;
    procedure   SetError(const Value: Exception);
  protected
    FDescriptor : TWVCommandDescriptor;
    FError: Exception;
    property    Descriptor : TWVCommandDescriptor read FDescriptor write SetDescriptor;
    procedure   Initialize; override;
  public
    destructor  Destroy;override;
    property    Error : Exception read FError write SetError;
    {procedure   PutValue(const Name : string; Value : Variant); virtual;
    function    GetValue(const Name : string): Variant; virtual;}
    function    GetDescription : string; virtual;
    function    GetDetail : string;
    function    GetDescriptor : TWVCommandDescriptor; virtual;
    function    FindParamData(const ParamName : string) : TKSDataObject; virtual;
    function    ParamData(const ParamName : string) : TKSDataObject; overload;
    function    ParamData(ParamIndex : Integer) : TKSDataObject; overload; virtual;
    procedure   CheckError;
  end;

  {
    <Class>TWVCommandDescriptor
    <What>命令描述对象类。
    1、用于描述命令对象的特征。
    2、创建命令对象
    对唯一的ID和Version存在唯一的描述对象对象。
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TWVCommandDescriptor = class(TWVMetaCommand)
  private

  protected
    procedure   Initialize; override;
  public
    destructor  Destroy;override;
    function    NewCommand : TWVCommand; virtual;
    function    GetParamCount : Integer; virtual; abstract;
    function    GetParamName(Index : Integer) : string; virtual; abstract;
    function    GetParamDataType(Index : Integer) : TKSDataType; virtual; abstract;
    function    GetParamType(Index : Integer) : TWVParamType; virtual; abstract;
    function    GetParamDefaultValue(Index : Integer) : Variant; virtual; abstract;
    function    IndexOfParam(const ParamName : string): Integer; virtual;
    function    GetDescription(Command : TWVCommand) : string; virtual;
    procedure   FreeParamObject(const ParamName : string; AObject : TObject); virtual;
  end;

  {
    <Class>TWVCommandFactory
    <What>命令类工厂
    管理命令描述对象类
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TWVCommandFactory = class(TWVContextedObject)
  private
    FDescriptors : TList;
  protected
    procedure   Initialize; override;
  public
    destructor  Destroy;override;
    function    NewCommand(ID : TWVCommandID; Version : TWVCommandVersion) : TWVCommand; virtual;
    procedure   AddDescriptor(Descriptor : TWVCommandDescriptor);
    procedure   RemoveDescriptor(Descriptor : TWVCommandDescriptor);
    function    GetDescriptorCount : Integer;
    function    GetDescriptor(Index : Integer): TWVCommandDescriptor;
    function    FindDescriptor(ID : TWVCommandID; Version : TWVCommandVersion): TWVCommandDescriptor;
    procedure   FreeParamObject(ID : TWVCommandID; Version : TWVCommandVersion; const ParamName : string; AObject : TObject);
  end;

  {
    <Class>TWVCommandProcessor
    <What>命令对象的处理者
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TWVCommandProcessor = class(TWVContextedObject)
  private

  protected

  public
    procedure   Process(Command : TWVCommand); virtual; abstract;
    destructor  Destroy;override;
  published

  end;

  {
    <Class>TWVCommandFilter
    <What>命令对象处理过滤器
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TWVCommandFilter = class(TWVContextedObject)
  private

  protected
    procedure   Process(Command : TWVCommand); virtual; abstract;
  public
    destructor  Destroy;override;
  end;

  {
    <Class>TWVCommandBus
    <What>命令总线
    负责将命令发送到命令处理者
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TWVCommandBus = class(TWVContextedObject)
  private
    FBeforeFilters : TList;
    FAfterFilters : TList;
    FProcessors : TList;
    FDescriptors : TList;
  protected
    procedure   Initialize; override;
  public
    destructor  Destroy;override;
    procedure   Process(Command : TWVCommand); virtual;
    procedure   AddProcessor(Descriptor : TWVCommandDescriptor; Processor : TWVCommandProcessor);
    procedure   RemoveProcessor(Processor : TWVCommandProcessor);
    procedure   RemoveDescriptor(Descriptor : TWVCommandDescriptor);
    procedure   AddBeforeFilter(Filter : TWVCommandFilter);
    procedure   RemoveBeforeFilter(Filter : TWVCommandFilter);
    procedure   AddAfterFilter(Filter : TWVCommandFilter);
    procedure   RemoveAfterFilter(Filter : TWVCommandFilter);
    function    FindProcessor(Descriptor : TWVCommandDescriptor) : TWVCommandProcessor;
  end;

  {
    <Class>TWVContext
    <What>运行环境
    <Properties>
      CommandBus - 命令总线实例
      CommandFactory - 命令类工厂实例
    <Methods>
      AddClient - 增加一个在运行环境中执行的对象。在运行环境结束的时候，这个对象自动被运行环境释放。
      RemoveClient - 去掉一个在运行环境中执行的对象。
    <Event>
      -
  }
  TWVContext = class(TObject)
  private
    FCommandBus: TWVCommandBus;
    FCommandFactory: TWVCommandFactory;
    FClients : TObjectList;
    FParamNames : TStringList;
    FParamData : TObjectList;
    function    GetParamCount: Integer;
    function    GetParamNames(Index: Integer): string;
    //FFreeNotifications : TList;
  protected
    procedure   NewBusAndFactory; virtual;
  public
    constructor Create;
    destructor  Destroy;override;
    procedure   AddClient(AObject : TObject);
    procedure   RemoveClient(AObject : TObject);
    //procedure   FreeNotification(AObject : TObject);
    property    CommandBus : TWVCommandBus read FCommandBus;
    property    CommandFactory : TWVCommandFactory read FCommandFactory;
    // param
    procedure   ClearParam;
    procedure   AddParam(const ParamName : string; DataType : TKSDataType; const ProtectStr : string='');
    function    FindParamData(const ParamName : string) : TKSDataObject;
    property    ParamCount : Integer read GetParamCount;
    property    ParamNames[Index : Integer] : string read GetParamNames;
    function    ParamData(Index: Integer): TKSDataObject; overload;
    function    ParamData(const ParamName : string): TKSDataObject; overload;
  end;

  TWVLogFilter = class(TWVCommandFilter)
  private
    FFilterName: string;
  protected
    procedure   Process(Command : TWVCommand); override;
  public
    property    FilterName : string read FFilterName write FFilterName;
  end;

// 注册上下文对象的参数名称，用于设计时使用
procedure RegisterContextParamName(const ParamName : string);

// 填充上下文对象的参数名称
procedure GetContextParamNames(Proc: TGetStrProc);

implementation

uses SafeCode, LogFile;

var
  ContextParamNames : TStringList;

procedure RegisterContextParamName(const ParamName : string);
begin
  if ContextParamNames=nil then
    ContextParamNames := TStringList.Create;
  if ContextParamNames.IndexOf(ParamName)<0 then
    ContextParamNames.Add(ParamName);
end;

procedure GetContextParamNames(Proc: TGetStrProc);
var
  I : Integer;
begin
  if ContextParamNames<>nil then
  begin
    for I:=0 to ContextParamNames.Count-1 do
      Proc(ContextParamNames[I]);
  end;
end;

{ TWVContextedObject }

constructor TWVContextedObject.Create(AContext: TWVContext);
begin
  Assert(AContext<>nil);
  FContext := AContext;
  FContext.AddClient(Self);
  Initialize;
end;

destructor TWVContextedObject.Destroy;
begin
  FContext.RemoveClient(Self);
  inherited;
end;

procedure TWVContextedObject.Initialize;
begin

end;

{ TWVMetaCommand }

constructor TWVMetaCommand.Create(AContext: TWVContext; AID: TWVCommandID;
  AVersion: TWVCommandVersion);
begin
  FID := AID;
  FVersion := AVersion;
  inherited Create(AContext);
end;

{ TWVCommand }

procedure TWVCommand.Initialize;
begin
  inherited;
  FParamData := TObjectList.Create;
end;

destructor TWVCommand.Destroy;
begin
  FreeAndNil(FParamData);
  inherited;
end;

procedure TWVCommand.CreateParamData;
var
  I : Integer;
  Count : Integer;
  DataObject : TKSDataObject;
begin
  FParamData.Clear;
  if Descriptor=nil then
    Exit;
  Count := Descriptor.GetParamCount;
  for I:=0 to Count-1 do
  begin
    DataObject := TKSDataObject.Create;
    DataObject.DataType := Descriptor.GetParamDataType(I);
    FParamData.Add(DataObject);
    DataObject.Value := Descriptor.GetParamDefaultValue(I);
  end;
end;

function TWVCommand.FindParamData(const ParamName: string): TKSDataObject;
var
  I : Integer;
begin
  I := Descriptor.IndexOfParam(ParamName);
  if I>=0 then
    Result := TKSDataObject(FParamData[I]) else
    Result := nil;
  if Result=nil then
    Result := Context.FindParamData(ParamName);  
end;

function TWVCommand.GetDescription: string;
begin
  Result := Descriptor.GetDescription(Self);
end;

function TWVCommand.GetDescriptor: TWVCommandDescriptor;
begin
  {Result := FContext.FCommandFactory.FindDescriptor(ID,Version);}
  Result := FDescriptor;
  Assert(Result<>nil);
end;

function TWVCommand.ParamData(const ParamName : string): TKSDataObject;
begin
  Result := FindParamData(ParamName);
  CheckObject(Result,'Error : No Command Param '+ParamName);
end;

function TWVCommand.ParamData(ParamIndex: Integer): TKSDataObject;
begin
  Result := TKSDataObject(FParamData[ParamIndex]);
end;

procedure TWVCommand.SetDescriptor(const Value: TWVCommandDescriptor);
begin
  FDescriptor := Value;
  if FDescriptor<>nil then
  begin
    Assert((FDescriptor.ID=ID) and (FDescriptor.Version=Version));
  end;
  CreateParamData;
end;

function TWVCommand.GetDetail: string;
var
  I,Count : Integer;
begin
  Result := Format('[%s.%d]',[ID,Version]);
  Count := Descriptor.GetParamCount;
  for I:=0 to Count-1 do
  begin
    Result := Format('%s%s=%s;',[Result,Descriptor.GetParamName(I),ParamData(I).AsString]);
  end;
end;

procedure TWVCommand.CheckError;
var
  TempError : Exception;
begin
  if Error<>nil then
  begin
    TempError := Error;
    Error := nil;
    raise TempError;
  end;
end;

type
  ExceptionClass = class of Exception;

procedure TWVCommand.SetError(const Value: Exception);
var
  AExceptionClass : ExceptionClass;
begin
  if Value<>nil then
  begin
    AExceptionClass := ExceptionClass(Value.ClassType);
    FError := AExceptionClass.Create(Value.Message);
  end else
    FError := nil;
end;

{ TWVCommandDescriptor }

procedure TWVCommandDescriptor.Initialize;
begin
  inherited;
  FContext.CommandFactory.AddDescriptor(Self);
end;

destructor TWVCommandDescriptor.Destroy;
begin
  if FContext.CommandFactory<>nil then
    FContext.CommandFactory.RemoveDescriptor(Self);
  if FContext.CommandBus<>nil then
    FContext.CommandBus.RemoveDescriptor(Self);
  inherited;
end;

function TWVCommandDescriptor.NewCommand: TWVCommand;
begin
  Result := TWVCommand.Create(Context,ID,Version);
  Result.Descriptor := Self;
end;

function TWVCommandDescriptor.IndexOfParam(const ParamName: string): Integer;
var
  I : Integer;
  Count : Integer;
begin
  Count := GetParamCount;
  for I:=0 to Count-1 do
    if SameText(ParamName,GetParamName(I)) then
    begin
      Result := I;
      Exit;
    end;
  Result := -1;
end;

function TWVCommandDescriptor.GetDescription(Command: TWVCommand): string;
begin
  Result := '';
end;

procedure TWVCommandDescriptor.FreeParamObject(const ParamName: string;
  AObject: TObject);
begin
  AObject.Free;
end;

{ TWVCommandFactory }

procedure TWVCommandFactory.Initialize;
begin
  inherited;
  FDescriptors := TList.Create;
end;

destructor TWVCommandFactory.Destroy;
begin
  inherited;
  FreeAndNil(FDescriptors);
end;

procedure TWVCommandFactory.AddDescriptor(
  Descriptor: TWVCommandDescriptor);
begin
  if FindDescriptor(Descriptor.ID,Descriptor.Version)<>nil then
  begin
    WriteLog(Format('Error Will Be Raised : Duplicated Command Descriptor[%s.%d]',[Descriptor.ID,Descriptor.Version]),lcCommand);
    CheckTrue(False,Format('Error : Duplicated Command Descriptor[%s.%d]',[Descriptor.ID,Descriptor.Version]));
  end;
  FDescriptors.Add(Descriptor);
  WriteLog(Format('Register Command Descriptor[%s.%d]',[Descriptor.ID,Descriptor.Version]),lcCommand);
end;

procedure TWVCommandFactory.RemoveDescriptor(
  Descriptor: TWVCommandDescriptor);
begin
  FDescriptors.Remove(Descriptor);
  WriteLog(Format('UnRegister Command Descriptor[%s.%d]',[Descriptor.ID,Descriptor.Version]),lcCommand);
end;

function TWVCommandFactory.FindDescriptor(ID: TWVCommandID;
  Version: TWVCommandVersion): TWVCommandDescriptor;
var
  I : Integer;
begin
  for I:=0 to FDescriptors.Count-1 do
  begin
    Result := TWVCommandDescriptor(FDescriptors[I]);
    if (Result.ID=ID) and (Result.Version=Version) then
      Exit;
  end;
  Result := nil;
end;

function TWVCommandFactory.GetDescriptor(
  Index: Integer): TWVCommandDescriptor;
begin
  Result := TWVCommandDescriptor(FDescriptors[Index]);
end;

function TWVCommandFactory.GetDescriptorCount: Integer;
begin
  Result := FDescriptors.Count;
end;

function TWVCommandFactory.NewCommand(ID: TWVCommandID;
  Version: TWVCommandVersion): TWVCommand;
var
  Descriptor : TWVCommandDescriptor;
begin
  Descriptor := FindDescriptor(ID,Version);
  if Descriptor<>nil then
    Result := Descriptor.NewCommand else
    Result := nil;
  CheckObject(Result,Format('Error : Command[%s.%d] have not registered',[ID,Version]));
end;

procedure TWVCommandFactory.FreeParamObject(ID: TWVCommandID;
  Version: TWVCommandVersion; const ParamName: string; AObject: TObject);
var
  Descriptor : TWVCommandDescriptor;
begin
  Descriptor := FindDescriptor(ID,Version);
  if Descriptor<>nil then
    Descriptor.FreeParamObject(ParamName,AObject) else
    AObject.Free;
end;

{ TWVCommandProcessor }

destructor TWVCommandProcessor.Destroy;
begin
  if FContext.CommandBus<>nil then
    FContext.CommandBus.RemoveProcessor(Self);
  inherited;
end;

{ TWVCommandFilter }

destructor TWVCommandFilter.Destroy;
begin
  if FContext.CommandBus<>nil then
  begin
    FContext.CommandBus.RemoveBeforeFilter(Self);
    FContext.CommandBus.RemoveAfterFilter(Self);
  end;
  inherited;
end;

{ TWVCommandBus }

procedure TWVCommandBus.Initialize;
begin
  inherited;
  FBeforeFilters := TList.Create;
  FAfterFilters := TList.Create;
  FProcessors := TList.Create;
  FDescriptors := TList.Create;
end;

destructor TWVCommandBus.Destroy;
begin
  inherited;
  FreeAndNil(FBeforeFilters);
  FreeAndNil(FAfterFilters);
  FreeAndNil(FProcessors);
  FreeAndNil(FDescriptors);
end;

procedure TWVCommandBus.AddAfterFilter(Filter: TWVCommandFilter);
begin
  if FAfterFilters.IndexOf(Filter)<0 then
    FAfterFilters.Add(Filter);
end;

procedure TWVCommandBus.AddBeforeFilter(Filter: TWVCommandFilter);
begin
  if FBeforeFilters.IndexOf(Filter)<0 then
    FBeforeFilters.Add(Filter);
end;

procedure TWVCommandBus.AddProcessor(Descriptor: TWVCommandDescriptor;
  Processor: TWVCommandProcessor);
begin
  FDescriptors.Insert(0,Descriptor);
  FProcessors.Insert(0,Processor);
  WriteLog(Format('Add Command Processor[%s.%d]',[Descriptor.ID,Descriptor.Version]),lcCommand);
  Assert(FDescriptors.Count=FProcessors.Count);
end;

procedure TWVCommandBus.Process(Command: TWVCommand);
var
  I : Integer;
  Filter : TWVCommandFilter;
  Processor : TWVCommandProcessor;
begin
  // 使用前置过滤器过滤
  for I:=0 to FBeforeFilters.Count-1 do
  begin
    try
      Filter := FBeforeFilters[I];
      Filter.Process(Command);
    except
      on E : Exception do
        if Command.Error=nil then
          Command.Error := E;
    end;
  end;

  // 如果没有意外，处理
  if Command.Error=nil then
  begin
    try
      Processor := FindProcessor(Command.GetDescriptor);
      CheckObject(Processor,Format('Error : Command Processor[%s.%d] have not registered',[Command.ID,Command.Version]));
      Processor.Process(Command);
    except
      on E : Exception do
        if Command.Error=nil then
          Command.Error := E;
    end;
  end;
  // 使用后置过滤器过滤
  for I:=0 to FAfterFilters.Count-1 do
  begin
    try
      Filter := FAfterFilters[I];
      Filter.Process(Command);
    except
      on E : Exception do
        if Command.Error=nil then
          Command.Error := E;
    end;
  end;
end;

procedure TWVCommandBus.RemoveAfterFilter(Filter: TWVCommandFilter);
begin
  FAfterFilters.Remove(Filter);
end;

procedure TWVCommandBus.RemoveBeforeFilter(Filter: TWVCommandFilter);
begin
  FBeforeFilters.Remove(Filter);
end;

procedure TWVCommandBus.RemoveProcessor(Processor: TWVCommandProcessor);
var
  I : Integer;
begin
  I := FProcessors.IndexOf(Processor);
  while I>=0 do
  begin
    with TWVCommandDescriptor(FDescriptors[I]) do
      WriteLog(Format('Remove Command Processor[%s.%d]',[ID,Version]),lcCommand);
    FProcessors.Delete(I);
    FDescriptors.Delete(I);
    I := FProcessors.IndexOf(Processor);
  end;
  Assert(FDescriptors.Count=FProcessors.Count);
end;

function TWVCommandBus.FindProcessor(
  Descriptor: TWVCommandDescriptor): TWVCommandProcessor;
var
  I : Integer;
begin
  I := FDescriptors.IndexOf(Descriptor);
  if I>=0 then
    Result := TWVCommandProcessor(FProcessors[I]) else
    Result := nil;
end;

procedure TWVCommandBus.RemoveDescriptor(Descriptor: TWVCommandDescriptor);
var
  I : Integer;
begin
  I := FDescriptors.IndexOf(Descriptor);
  while I>=0 do
  begin
    WriteLog(Format('Remove Command Processor For [%s.%d]',[Descriptor.ID,Descriptor.Version]),lcCommand);
    FProcessors.Delete(I);
    FDescriptors.Delete(I);
    I := FDescriptors.IndexOf(Descriptor);
  end;
  Assert(FDescriptors.Count=FProcessors.Count);
end;

{ TWVContext }

constructor TWVContext.Create;
begin
  FClients := TObjectList.Create;
  FParamNames := TStringList.Create;
  FParamData := TObjectList.Create;
  NewBusAndFactory;
end;

destructor TWVContext.Destroy;
var
  Temp : TObject;
begin
  FreeAndNil(FParamNames);
  FreeAndNil(FParamData);
  FreeAndNil(FCommandBus);
  FreeAndNil(FCommandFactory);
  Temp := FClients;
  FClients := nil;
  Temp.Free;
  inherited;
end;

procedure TWVContext.NewBusAndFactory;
begin
  FCommandBus := TWVCommandBus.Create(Self);
  FCommandFactory := TWVCommandFactory.Create(Self);
end;

procedure TWVContext.AddClient(AObject: TObject);
begin
  if FClients.IndexOf(AObject)<0 then
    FClients.Add(AObject);
end;

procedure TWVContext.RemoveClient(AObject: TObject);
begin
  if FClients<>nil then
    FClients.Extract(AObject);
end;

procedure TWVContext.AddParam(const ParamName: string;
  DataType: TKSDataType; const ProtectStr : string='');
var
  Data : TKSDataObject;
begin
  FParamNames.Add(ParamName);
  Data := TKSDataObject.Create(ProtectStr);
  Data.BeginUpdate(ProtectStr);
  Data.DataType := DataType;
  Data.EndUpdate(ProtectStr);
  FParamData.Add(Data);
end;

procedure TWVContext.ClearParam;
begin
  FParamNames.Clear;
  FParamData.Clear;
end;

function TWVContext.GetParamCount: Integer;
begin
  Result := FParamNames.Count;
  Assert(Result=FParamData.Count);
end;

function TWVContext.ParamData(Index: Integer): TKSDataObject;
begin
  Result := TKSDataObject(FParamData[Index]);
  Assert(Result<>nil);
end;

function TWVContext.GetParamNames(Index: Integer): string;
begin
  Result := FParamNames[Index];
end;

function TWVContext.FindParamData(const ParamName: string): TKSDataObject;
var
  I : Integer;
begin
  for I:=0 to FParamNames.Count-1 do
  begin
    if SameText(FParamNames[I],ParamName) then
    begin
      Result := ParamData(I);
      Exit;
    end;
  end;
  Result := nil;
end;

function TWVContext.ParamData(const ParamName: string): TKSDataObject;
begin
  Result := FindParamData(ParamName);
  CheckObject(Result,'Error : No Context Param '+ParamName);
end;

{ TWVLogFilter }

procedure TWVLogFilter.Process(Command: TWVCommand);
begin
  WriteLog(Format('Filter[%s]-Command:%s',[FilterName,Command.GetDetail]),lcCommand);
end;

initialization

finalization
  FreeAndNil(ContextParamNames);
end.
