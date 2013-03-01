program TestConn;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  MSSQLAcs in '..\MSSQLAcs.pas',
  MSSQL in '..\MSSQL.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
