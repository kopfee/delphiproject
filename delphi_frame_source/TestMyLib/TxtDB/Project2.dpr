program Project2;

uses
  Forms,
  Unit2 in 'Unit2.pas' {Form1},
  TxtDBEx in '..\..\MyLib\TxtDBEx.pas',
  TxtDB in '..\..\MyLib\TxtDB.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
