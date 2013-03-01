program PValid;

uses
  Forms,
  UValid in 'UValid.pas' {Form1},
  KSHints in '..\..\MyLib\KSHints.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
