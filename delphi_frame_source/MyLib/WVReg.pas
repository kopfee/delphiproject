unit WVReg;

{$I KSConditions.INC }

interface

procedure Register;

implementation

uses Classes, WorkViews, WVCtrls, WVEditors, DesignUtils,
  WVCommands, WVCmdTypeInfo, WVCmdProc, WVCmdReq, WVDBBinders, DBGrids
  {$ifdef VCL60_UP }
    ,DesignIntf, DesignEditors
  {$else}
    ,dsgnintf
  {$endif}
;

const
  Page = 'WorkView';

procedure Register;
begin
  RegisterComponents(Page,[TWorkView,TWVFieldDomain,TWVStringsMan,TWVFieldPresent, TWVDataSource, TWorkViewCenter]);
  RegisterComponents(Page,[TWVEdit, TWVComboBox, TWVLabel, TWVCheckBox, TWVCheckListBox, TWVDigitalEdit]);
  RegisterComponents(Page,[TWVCommandTypeInfo, TWVProcessor]);
  RegisterComponents(Page,[TWVRequest]);
  RegisterComponents(Page,[TWVDBBinder]);

  RegisterPropertyEditor(TypeInfo(string),TWVEdit,'FieldName',TWVFieldNameProperty);
  RegisterPropertyEditor(TypeInfo(string),TWVComboBox,'FieldName',TWVFieldNameProperty);
  RegisterPropertyEditor(TypeInfo(string),TWVLabel,'FieldName',TWVFieldNameProperty);
  RegisterPropertyEditor(TypeInfo(string),TWVCheckBox,'FieldName',TWVFieldNameProperty);
  RegisterPropertyEditor(TypeInfo(string),TWVDBBinder,'FieldName',TWVFieldNameProperty);
  RegisterPropertyEditor(TypeInfo(string),TWVCheckListBox,'FieldName',TWVFieldNameProperty);
  RegisterPropertyEditor(TypeInfo(string),TWVDigitalEdit,'FieldName',TWVFieldNameProperty);

  RegisterPropertyEditor(TypeInfo(string),TWVField,'DomainName',TWVDomainNameProperty);
  RegisterPropertyEditor(TypeInfo(string),TWVFieldParamBinding,'FieldName',TWVFieldNameProperty2);
  RegisterPropertyEditor(TypeInfo(string),TWVFieldParamBinding,'ParamName',TWVParamNameProperty);
  RegisterPropertyEditor(TypeInfo(string),TWVDBBinding,'WVFieldName',TWVFieldNameProperty2);
  RegisterPropertyEditor(TypeInfo(string),TWVField,'MonitorValueChangedFields',TWVFieldNamesProperty1);
  RegisterPropertyEditor(TypeInfo(string),TWVField,'MonitorValidChangedFields',TWVFieldNamesProperty1);
  RegisterPropertyEditor(TypeInfo(string),TWVFieldMonitor,'MonitorValueChangedFields',TWVFieldNamesProperty2);
  RegisterPropertyEditor(TypeInfo(string),TWVFieldMonitor,'MonitorValidChangedFields',TWVFieldNamesProperty2);

  RegisterComponentEditor(TWorkView,TWVWorkViewEditor);
  RegisterComponentEditor(TWVCommandTypeInfo,TWVCommandTypeInfoEditor);
  RegisterComponentEditor(TWVRequest,TWVRequestEditor);
  RegisterComponentEditor(TWVDBBinder,TCollectionEditor);
  RegisterComponentEditor(TDBGrid,TWVDBGridEditor);

  RegisterPropertyEditor(TypeInfo(TWVCommandID),TWVRequest,'ID',TWVIDProperty);
  RegisterPropertyEditor(TypeInfo(TWVCommandID),TWVCustomProcessor,'ID',TWVIDProperty);
end;

end.
