library BasicDataAccess;

uses
  ComServ,
  BasicDataAccess_TLB in 'BasicDataAccess_TLB.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
