program Project1;

uses
  Forms,
  main in 'main.pas' {Form1},
  test in 'test.pas' {MyContainer: TContainer};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
