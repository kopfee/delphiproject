unit KCReg;

{$I KSConditions.INC }

interface

procedure Register;

implementation

uses Classes, DesignUtils, KCDataAccess, KCWVProcBinds, KCEditors, WVDBBinders, WorkViews
  {$ifdef VCL60_UP }
    ,DesignIntf, DesignEditors
  {$else}
    ,dsgnintf
  {$endif}
;

const
  Page = 'KC';

procedure Register;
begin
  RegisterComponents(Page,[TKCDatabase,TKCDataset]);
  RegisterComponents(Page,[TKCWVProcessor, TKCWVQuery]);
  RegisterComponentEditor(TKCDataset,TCollectionEditor);
  RegisterComponentEditor(TKCWVCustomProcessor,TKCWVProcessorEditor);
  RegisterPropertyEditor(TypeInfo(string),TKCParamBinding,'FieldName',TWVFieldNameProperty3);
  RegisterPropertyEditor(TypeInfo(string),TKCParamBinding,'ParamName',TWVParamNameProperty2);
  RegisterPropertyEditor(TypeInfo(string),TWVDBBinding,'FieldName',TWVFieldNameProperty3);
  RegisterPropertyEditor(TypeInfo(string),TWVField,'DataField',TWVFieldNameProperty3);
end;

end.
