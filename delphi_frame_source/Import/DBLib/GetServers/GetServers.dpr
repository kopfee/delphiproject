program GetServers;

uses
  Forms,
  UMain in 'UMain.pas' {Form1},
  MSSQL in '..\MSSQL.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
