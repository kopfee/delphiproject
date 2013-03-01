program PAutoTest;

uses
  Forms,
  UAutoTest in 'UAutoTest.pas' {Form1},
  KCDataAccess in '..\KCDataAccess.pas',
  DBAIntf in '..\..\..\StdIntf\DBAIntf.pas',
  DRTPAPI in '..\DRTPAPI.pas',
  KCDataPack in '..\KCDataPack.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
