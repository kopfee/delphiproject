program SimpleCallDLL;

uses
  Forms,
  USimple in 'USimple.pas' {fmSimpleTest},
  RPDBCB in '..\RPDBCB.pas',
  RPDLLIntf in '..\RPDLLIntf.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmSimpleTest, fmSimpleTest);
  Application.Run;
end.
