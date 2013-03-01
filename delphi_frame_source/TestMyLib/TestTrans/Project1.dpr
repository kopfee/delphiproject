program Project1;

uses
  Forms,
  UTest in 'UTest.pas' {Form1},
  myutils in '..\..\Trans\myutils.pas',
  safecode in '..\safecode.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
