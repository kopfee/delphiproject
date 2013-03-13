program CheckNet;

uses
  Forms,
  Unit1 in 'src\Unit1.pas' {Form1},
  Unit2 in 'src\Unit2.pas' {Form2},
  uIO in '..\CommonUnit\uIO.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'ÍøÂç¼ì²é¹¤¾ß';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
