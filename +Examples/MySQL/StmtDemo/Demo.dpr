program Demo;

uses
  Forms,
  UDemo in 'UDemo.pas' {Form1},
  mysql in '..\mysql.pas';

{$R *.res}

begin
  Application.Initialize;
{$IFDEF CONDITIONALEXPRESSIONS}
  {Delphi 6 and above}
  {$IF (CompilerVersion>=19)}
  Application.MainFormOnTaskbar := True;
  {$IFEND}
{$ENDIF}
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
