unit DataExtReg;

(*****   Code Written By Huang YanLai   *****)

interface

procedure Register;

const
  DEPage = 'Data Ext';
  
implementation

uses Classes,ProviderEx;

procedure Register;
begin
  RegisterComponents(DEPage,[TProviderEx])
end;

end.
 