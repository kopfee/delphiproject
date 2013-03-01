unit RegKSPack;

interface

procedure Register;

implementation

uses classes,DsgnIntf,KSCtrls;

procedure Register;
begin
  RegisterComponents('Kingstar',
    [TKSLabel,TKSDBLabel,TKSButton,TKSPanel,TKSEdit,TKSSwitchEdit,TKSDateEdit,TKSListEdit,
      TKSCheckBox,TKSComboBox,TKSDBGrid,TKSMemo,TKSDBMemo,TKSNotebook]);
  RegisterCustomModule(TKSForm,TCustomModule);
end;

end.
