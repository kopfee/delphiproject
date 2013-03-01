unit myReg;

interface

procedure Register;

implementation

uses Classes,AbilityManager,DsgnIntf,compGroup,DBListOne;

procedure Register;
begin
  RegisterComponents('users',
   [TSimpleAbilityManager,
   TGroupAbilityManager,
   TAbilityProvider,
   TSimpleAuthorityProvider,
   TDBAuthorityProvider]);
  registerComponents('users',[TComponentGroup]);
  registerComponents('users',[TAppearanceGroup,TAppearanceProxy]);
  RegisterComponents('users',[TDBListOne,TDBComboList]);
end;

end.
