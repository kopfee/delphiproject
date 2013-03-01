unit CMUtils;

{$I KSConditions.INC }

// custom module utilities
(*****   Code Written By Huang YanLai   *****)

interface

implementation

{$ifndef VCL60_UP}

uses classes,forms;

var
  OldFindGlobalComponent : TFindGlobalComponent;

{
  I write FindGlobalComponent and set Classes.FindGlobalComponent
  in order to resovle the name conflict witch is that components
  of same name are owned by application.
  See classes.TReader.ReadRootComponent and its FindUniqueName
}

function FindGlobalComponent(const Name: string): TComponent;
begin
  if assigned(OldFindGlobalComponent)
    then result:=OldFindGlobalComponent(name)
    else result:=nil;
  if result=nil
    then result := application.findComponent(name);
end;

initialization
  OldFindGlobalComponent := Classes.FindGlobalComponent;
  Classes.FindGlobalComponent := FindGlobalComponent;
finalization
  Classes.FindGlobalComponent := OldFindGlobalComponent;

{$endif}

end.
