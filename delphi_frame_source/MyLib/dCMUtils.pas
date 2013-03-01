unit dCMUtils;

// custom module utilities
(*****   Code Written By Huang YanLai   *****)

{$I KSConditions.INC }

interface

uses classes,forms
{$ifdef VCL60_UP }
  ,DesignIntf
{$else}
  ,DsgnIntf
{$endif}
  ;

procedure  RegisterSimpleModule(AComponentClass : TComponentClass);

implementation

{$ifndef VCL60_UP }
var
  OldFindGlobalComponent : TFindGlobalComponent;
{$endif}

procedure  RegisterSimpleModule(AComponentClass : TComponentClass);
begin
{$ifdef VCL60_UP }
  RegisterCustomModule(AComponentClass,TBaseCustomModule);
{$else}
  RegisterCustomModule(AComponentClass,TCustomModule);
{$endif}
end;

{
  I write FindGlobalComponent and set Classes.FindGlobalComponent
  in order to resovle the name conflict witch is that components
  of same name are owned by application.
  See classes.TReader.ReadRootComponent and its FindUniqueName
}

{$ifndef VCL60_UP }
function FindGlobalComponent(const Name: string): TComponent;
begin
  if assigned(OldFindGlobalComponent)
    then result:=OldFindGlobalComponent(name)
    else result:=nil;
  if result=nil
    then result := application.findComponent(name);
end;
{$endif}

initialization
  {$ifndef VCL60_UP }
  OldFindGlobalComponent := Classes.FindGlobalComponent;
  Classes.FindGlobalComponent := FindGlobalComponent;
  {$endif}
finalization
  {$ifndef VCL60_UP }
  Classes.FindGlobalComponent := OldFindGlobalComponent;
  {$endif}
end.
