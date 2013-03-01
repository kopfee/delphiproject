unit WVCmdTypeInfo;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>WVCmdDes
   <What>命令描述对象的组件包装
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

{$I KSConditions.INC }

interface

uses SysUtils, Classes, DataTypes, WVCommands;

type
  TWVCommandTypeInfo = class;

  {
    <Class>TWVStdCommandDescriptor
    <What>一个命令描述对象类的实现。
    1)对象的描述信息来自组件TWVCommandTypeInfo。
    2)一个TWVCommandTypeInfo对应一个TWVStdCommandDescriptor。
    3)释放TWVStdCommandDescriptor的时候，修改TWVCommandTypeInfo对它的引用
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TWVStdCommandDescriptor = class(TWVCommandDescriptor)
  private
    FCmdTypeInfo: TWVCommandTypeInfo;
  protected

  public
    destructor  Destroy;override;
    function    GetParamCount : Integer; override;
    function    GetParamName(Index : Integer) : string; override;
    function    GetParamDataType(Index : Integer) : TKSDataType; override;
    function    GetParamType(Index : Integer) : TWVParamType; override;
    function    GetDescription(Command : TWVCommand) : string; override;
    function    GetParamDefaultValue(Index : Integer) : Variant; override;
    property    CmdTypeInfo : TWVCommandTypeInfo read FCmdTypeInfo;
  end;

  {
    <Class>TWVParam
    <What>描述命令参数的信息
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TWVParam = class(TCollectionItem)
  private
    FParamName: string;
    FParamDataType: TKSDataType;
    FParamType: TWVParamType;
    FDefaultValue: Variant;
  protected
    function    GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor  Destroy; override;
    procedure   Assign(Source: TPersistent); override;
  published
    property    ParamName : string read FParamName write FParamName;
    property    ParamType : TWVParamType read FParamType write FParamType default ptInput;
    property    ParamDataType : TKSDataType read FParamDataType write FParamDataType default kdtString;
    property    DefaultValue : Variant read FDefaultValue write FDefaultValue;
  end;

  TGetDescriptionEvent = procedure (Command : TWVCommand; var Description : string) of object;
  {
    <Class>TWVCommandTypeInfo
    <What>保存对命令对象的描述信息
    1)一个TWVCommandTypeInfo对应0..1个TWVStdCommandDescriptor。
    2)释放TWVCommandTypeInfo的时候，释放对应的TWVStdCommandDescriptor。
    <Properties>
      -
    <Methods>
      RegisterCommandDescriptor - 根据设置的命令对象的描述信息创建并且注册TWVStdCommandDescriptor对象。
    <Event>
      -
  }
  TWVCommandTypeInfo = class(TComponent)
  private
    FID: TWVCommandID;
    FVersion: TWVCommandVersion;
    FParams: TCollection;
    FCommandDescriptor: TWVStdCommandDescriptor;
    FOnGetDescription: TGetDescriptionEvent;
    procedure   SetParams(const Value: TCollection);
  protected

  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
    function    RegisterCommandDescriptor(Context : TWVContext) : TWVStdCommandDescriptor;
    procedure   FreeCommandDescriptor;
    property    CommandDescriptor : TWVStdCommandDescriptor read FCommandDescriptor;
  published
    property    ID : TWVCommandID read FID write FID;
    property    Version : TWVCommandVersion read FVersion write FVersion default 1;
    property    Params : TCollection read FParams write SetParams;
    property    OnGetDescription : TGetDescriptionEvent read FOnGetDescription write FOnGetDescription;
  end;

function  FindCommandTypeInfo(ID : TWVCommandID; Version : TWVCommandVersion) : TWVCommandTypeInfo;

function  GetCommandTypeInfo(Index : Integer) : TWVCommandTypeInfo;

function  GetCommandTypeInfoCount : Integer;

procedure FillCommandParamNames(ID : TWVCommandID; Version : TWVCommandVersion; Proc: TGetStrProc);

procedure RegisterCommandDescriptors(AOwner : TComponent; Context : TWVContext);

implementation

uses SafeCode
  {$ifdef VCL60_UP }
  ,Variants
  {$else}

  {$endif}
;

var
  CommandTypeInfos : TList = nil;

procedure AddCommandTypeInfo(CommandTypeInfo : TWVCommandTypeInfo);
begin
  if CommandTypeInfos<>nil then
    CommandTypeInfos.Add(CommandTypeInfo);
end;

procedure RemoveCommandTypeInfo(CommandTypeInfo : TWVCommandTypeInfo);
begin
  if CommandTypeInfos<>nil then
    CommandTypeInfos.Remove(CommandTypeInfo);
end;

function  FindCommandTypeInfo(ID : TWVCommandID; Version : TWVCommandVersion) : TWVCommandTypeInfo;
var
  I : Integer;
begin
  for I:=0 to CommandTypeInfos.Count-1 do
  begin
    Result := TWVCommandTypeInfo(CommandTypeInfos[I]);
    if SameText(Result.ID,ID) and (Result.Version=Version) then
      Exit;
  end;
  Result := nil;
end;

function  GetCommandTypeInfo(Index : Integer) : TWVCommandTypeInfo;
begin
  Result := TWVCommandTypeInfo(CommandTypeInfos[Index]);
end;

function  GetCommandTypeInfoCount : Integer;
begin
  Result := CommandTypeInfos.Count; 
end;

procedure FillCommandParamNames(ID : TWVCommandID; Version : TWVCommandVersion; Proc: TGetStrProc);
var
  I : Integer;
  CommandTypeInfo : TWVCommandTypeInfo;
begin
  GetContextParamNames(Proc);
  CommandTypeInfo := FindCommandTypeInfo(ID,Version);
  if CommandTypeInfo=nil then Exit;
  try
    for i:=0 to CommandTypeInfo.Params.Count-1 do
    begin
      if TWVParam(CommandTypeInfo.Params.Items[I]).ParamName<>'' then
        Proc(TWVParam(CommandTypeInfo.Params.Items[I]).ParamName);
    end;
  except

  end;
end;

procedure RegisterCommandDescriptors(AOwner : TComponent; Context : TWVContext);
var
  I : Integer;
begin
  for I:=0 to AOwner.ComponentCount-1 do
    if AOwner.Components[I] is TWVCommandTypeInfo then
      TWVCommandTypeInfo(AOwner.Components[I]).RegisterCommandDescriptor(Context);
end;

{ TWVStdCommandDescriptor }

destructor TWVStdCommandDescriptor.Destroy;
begin
  //Assert(CmdTypeInfo<>nil);
  if CmdTypeInfo<>nil then
    CmdTypeInfo.FCommandDescriptor := nil;
  inherited;
end;

function TWVStdCommandDescriptor.GetDescription(
  Command: TWVCommand): string;
begin
  Assert(CmdTypeInfo<>nil);
  Result := '';
  if Assigned(CmdTypeInfo.FOnGetDescription) then
    CmdTypeInfo.FOnGetDescription(Command,Result);
end;

function TWVStdCommandDescriptor.GetParamCount: Integer;
begin
  Assert(CmdTypeInfo<>nil);
  Result := CmdTypeInfo.Params.Count;
end;

function TWVStdCommandDescriptor.GetParamDataType(
  Index: Integer): TKSDataType;
begin
  Assert(CmdTypeInfo<>nil);
  Result := TWVParam(CmdTypeInfo.Params.Items[Index]).ParamDataType;
end;

function TWVStdCommandDescriptor.GetParamDefaultValue(
  Index: Integer): Variant;
begin
  Assert(CmdTypeInfo<>nil);
  Result := TWVParam(CmdTypeInfo.Params.Items[Index]).DefaultValue;
end;

function TWVStdCommandDescriptor.GetParamName(Index: Integer): string;
begin
  Assert(CmdTypeInfo<>nil);
  Result := TWVParam(CmdTypeInfo.Params.Items[Index]).ParamName;
end;

function TWVStdCommandDescriptor.GetParamType(
  Index: Integer): TWVParamType;
begin
  Assert(CmdTypeInfo<>nil);
  Result := TWVParam(CmdTypeInfo.Params.Items[Index]).ParamType;
end;

{ TWVParam }

constructor TWVParam.Create(Collection: TCollection);
begin
  inherited;
  FDefaultValue := Unassigned;
  FParamName := '';
  FParamDataType := kdtString;
  FParamType := ptInput;
end;

destructor TWVParam.Destroy;
begin
  inherited;

end;

procedure TWVParam.Assign(Source: TPersistent);
begin
  if Source is TWVParam then
    with TWVParam(Source) do
    begin
      Self.ParamName := ParamName;
      Self.ParamType := ParamType;
      Self.ParamDataType := ParamDataType;
      Self.DefaultValue := DefaultValue;
    end
  else
    inherited;
end;

function TWVParam.GetDisplayName: string;
begin
  Result := ParamName;
end;

{ TWVCommandTypeInfo }

constructor TWVCommandTypeInfo.Create(AOwner: TComponent);
begin
  inherited;
  FID := '';
  FVersion := 1;
  FParams := TOwnedCollection.Create(Self,TWVParam);
  AddCommandTypeInfo(Self);
end;

destructor TWVCommandTypeInfo.Destroy;
begin
  RemoveCommandTypeInfo(Self);
  FreeCommandDescriptor;
  FParams.Free;
  inherited;
end;

procedure TWVCommandTypeInfo.FreeCommandDescriptor;
var
  Temp : TObject;
begin
  Temp := FCommandDescriptor;
  FCommandDescriptor := nil;
  Temp.Free;
end;

function  TWVCommandTypeInfo.RegisterCommandDescriptor(Context : TWVContext) : TWVStdCommandDescriptor;
begin
  Assert(Context<>nil);
  FreeCommandDescriptor;
  CheckTrue(ID<>'','Invalid ID!');
  FCommandDescriptor := TWVStdCommandDescriptor.Create(Context,ID,Version);
  FCommandDescriptor.FCmdTypeInfo := Self;
  Result := FCommandDescriptor;
end;

procedure TWVCommandTypeInfo.SetParams(const Value: TCollection);
begin
  FParams.Assign(Value);
end;

initialization
  CommandTypeInfos := TList.Create;

finalization
  FreeAndNil(CommandTypeInfos);

end.
