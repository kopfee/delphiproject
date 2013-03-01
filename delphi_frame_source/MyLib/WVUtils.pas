unit WVUtils;

interface

uses Classes, WVCommands, WVCmdTypeInfo, WVCmdReq, WVCmdProc;

procedure RegisterDecsriptorsAndProcessors(Context : TWVContext);

implementation

uses Forms;

procedure RegisterDecsriptorsAndProcessors(Context : TWVContext);
var
  I : Integer;
  Comp : TComponent;
begin
  if Application<>nil then
  begin
    // 注册所有的命令描述对象
    for I:=0 to Application.ComponentCount-1 do
    begin
      Comp := Application.Components[I];
      RegisterCommandDescriptors(Comp,Context);
    end;
    // 注册所有的命令处理对象（依赖命令描述对象，所以后注册）
    for I:=0 to Application.ComponentCount-1 do
    begin
      Comp := Application.Components[I];
      RegisterCommandProcessors(Comp,Context);
    end;
  end;
end;

end.
