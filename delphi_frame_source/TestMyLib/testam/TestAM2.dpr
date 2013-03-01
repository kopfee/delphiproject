program TestAM2;

uses
  Forms,
  outmod in 'outmod.pas' {Form2},
  main2 in 'main2.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
