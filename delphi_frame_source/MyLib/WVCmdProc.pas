unit WVCmdProc;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>WVCmdProc
   <What>命令处理器的组件包装
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

interface

uses SysUtils, Classes, WVCommands;

type
  TWVCustomProcessor = class;

  TWVStdCommandProcessor = class(TWVCommandProcessor)
  private
    FProcessor: TWVCustomProcessor;
  protected

  public
    destructor  Destroy; override;
    procedure   Process(Command : TWVCommand); override;
    property    Processor : TWVCustomProcessor read FProcessor;
  end;

  TProcessCommandEvent = procedure (Command : TWVCommand) of object;


  TWVCustomProcessor = class(TComponent)
  private
    FID: TWVCommandID;
    FVersion: TWVCommandVersion;
    FCommandProcessor: TWVStdCommandProcessor;
  protected
    procedure   Process(Command : TWVCommand); virtual; abstract;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
    function    RegisterCommandProcessor(Context : TWVContext) : TWVStdCommandProcessor;
    procedure   FreeCommandProcessor;
    property    CommandProcessor : TWVStdCommandProcessor read FCommandProcessor;
  published
    property    ID : TWVCommandID read FID write FID;
    property    Version : TWVCommandVersion read FVersion write FVersion default 1;
  end;

  TWVProcessor = class(TWVCustomProcessor)
  private
    FOnProcess: TProcessCommandEvent;
  protected
    procedure   Process(Command: TWVCommand); override;
  public

  published
    property    OnProcess : TProcessCommandEvent read FOnProcess write FOnProcess;
  end;


procedure RegisterCommandProcessors(AOwner : TComponent; Context : TWVContext);

implementation

uses SafeCode;

procedure RegisterCommandProcessors(AOwner : TComponent; Context : TWVContext);
var
  I : Integer;
begin
  for I:=0 to AOwner.ComponentCount-1 do
    if (AOwner.Components[I] is TWVCustomProcessor) and (TWVCustomProcessor(AOwner.Components[I]).ID<>'') then
      TWVCustomProcessor(AOwner.Components[I]).RegisterCommandProcessor(Context);
end;

{ TWVStdCommandProcessor }

destructor TWVStdCommandProcessor.Destroy;
begin
  Assert(Processor<>nil);
  Processor.FCommandProcessor := nil;
  inherited;
end;

procedure TWVStdCommandProcessor.Process(Command: TWVCommand);
begin
  Assert(Processor<>nil);
  Processor.Process(Command);
end;

{ TWVCustomProcessor }

constructor TWVCustomProcessor.Create(AOwner: TComponent);
begin
  inherited;
  FID := '';
  FVersion := 1;
end;

destructor TWVCustomProcessor.Destroy;
begin
  inherited;
  FreeCommandProcessor;
end;

procedure TWVCustomProcessor.FreeCommandProcessor;
var
  Temp : TObject;
begin
  Temp := FCommandProcessor;
  FCommandProcessor := nil;
  Temp.Free;
end;

function TWVCustomProcessor.RegisterCommandProcessor(
  Context: TWVContext): TWVStdCommandProcessor;
var
  Descriptor : TWVCommandDescriptor;
begin
  Assert(Context<>nil);
  FreeCommandProcessor;
  CheckTrue(ID<>'','Invalid ID!');
  Descriptor := Context.CommandFactory.FindDescriptor(ID,Version);
  CheckObject(Descriptor,Format('Error : Command[%s.%d] have not registered.',[ID,Version]));
  FCommandProcessor := TWVStdCommandProcessor.Create(Context);
  FCommandProcessor.FProcessor := Self;
  Context.CommandBus.AddProcessor(Descriptor,FCommandProcessor);
  Result := FCommandProcessor;
end;

procedure TWVProcessor.Process(Command: TWVCommand);
begin
  if Assigned(FOnProcess) then
    FOnProcess(Command);
end;


end.
