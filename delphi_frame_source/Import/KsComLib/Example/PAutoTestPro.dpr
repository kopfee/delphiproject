program PAutoTestPro;

uses
  Forms,
  UAutoTestPro in 'UAutoTestPro.pas' {fmAutoTestPro},
  KCDataAccess in '..\KCDataAccess.pas',
  DBAIntf in '..\..\..\StdIntf\DBAIntf.pas',
  DRTPAPI in '..\DRTPAPI.pas',
  KCDataPack in '..\KCDataPack.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmAutoTestPro, fmAutoTestPro);
  Application.Run;
end.
