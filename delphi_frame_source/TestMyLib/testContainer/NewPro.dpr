program NewPro;

uses
  Forms,
  main2 in 'main2.pas' {Form1},
  test2 in 'test2.pas' {MyContainer: TContainer};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
