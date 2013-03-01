program Project3;

uses
  Forms,
  Unit3 in 'Unit3.pas' {Form1},
  Unit4 in 'Unit4.pas' {Container1: TContainer};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TContainer1, Container1);
  Application.Run;
end.
