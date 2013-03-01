program PNew4;

uses
  Forms,
  UCtrl5 in 'UCtrl5.pas' {Form1},
  Controls in '..\..\..\program files\borland\delphi4\source\vcl\Controls.pas',
  StdCtrls in '..\..\..\program files\borland\delphi4\source\vcl\StdCtrls.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
