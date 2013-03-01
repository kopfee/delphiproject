program Project1;

uses
  Forms,
  UMain in 'UMain.pas' {Form1},
  MPDBs in '..\MPDBs.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
