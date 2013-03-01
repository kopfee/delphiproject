unit FrmFileGen;

interface

uses classes;

{
  Notes : not written event handlers! 
}

procedure ModuleFileGen(const pasFileName:string; module : TComponent; const className:string=''; const parentClass:string='');

implementation

uses  sysUtils,ExtUtils,TextUtils,safeCode,Proxies;


procedure ModuleFileGen(const pasFileName:string; module : TComponent; const className:string=''; const parentClass:string='');
var
  unitName : string;
  formFileName : string;
  Stream : TFileStream;
  textWriter : TtextWriter;
  i : integer;
  comp : TComponent;
  aclassName,aparentClass : string;
  useProxy : boolean;
  oriClassName : string;
begin
  unitName := ExtractOnlyFileName(pasFileName);
  oriClassName := module.className;
  formFileName := ChangeFileExt(pasFileName,'.dfm');
  if className='' then
    aclassName:=oriClassName else
    aclassName:=className;
  if parentClass='' then
    aparentClass:=module.ClassParent.className else
    aparentClass:=parentClass;

  useProxy:= false;
  if aclassName<>oriClassName then
  begin
    Proxies.CreateSubClass(module,aClassName,UnitName,module.classType);
    checkTrue(module.className=aClassName,'Cannot change className');
    useProxy:= true;
  end;
  // write .dfm file
  Stream := TFileStream.create(formFileName,fmCreate);
  try
    Stream.WriteComponentRes(aClassName, module);
  finally
    if useProxy then
    begin
      Proxies.DestroySubClass(module);
      checkTrue(module.className=oriClassName,'cannot restore className');
    end;

    Stream.free;
  end;
  //  WriteComponentResFile(formFileName,module);

  // write .pas file
  Stream := TFileStream.create(pasFileName,fmCreate);
  textWriter := TtextWriter.create(Stream);
  try
    textWriter.println('unit '+unitName+';');
    textWriter.println('');
    textWriter.println('interface');
    textWriter.println('');
    textWriter.println('uses');
    textWriter.println('  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;');
    textWriter.println('');
    textWriter.println('type');
    textWriter.println('  '+aclassName+' = class('+aparentClass+')');
    // write components
    for i:=0 to module.ComponentCount-1 do
    begin
      comp := module.Components[i];
      if comp.Name<>'' then
        textWriter.println('    '+comp.name+': '+comp.ClassName+';');
    end;
    textWriter.println('  private');
    textWriter.println('');
    textWriter.println('  public');
    textWriter.println('');
    textWriter.println('  end;');
    textWriter.println('');
    textWriter.println('var');
    textWriter.println('  '+module.Name+': '+aclassName+';');
    textWriter.println('');
    textWriter.println('implementation');
    textWriter.println('');
    textWriter.println('{$R *.DFM}');
    textWriter.println('');
    textWriter.println('end.');
  finally
    textWriter.free;
    Stream.free;
  end;
end;

end.
