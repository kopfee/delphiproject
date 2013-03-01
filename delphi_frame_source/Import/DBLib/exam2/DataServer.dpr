library DataServer;

uses
  ComServ,
  ServerImp in 'ServerImp.pas' {TestData: CoClass};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
