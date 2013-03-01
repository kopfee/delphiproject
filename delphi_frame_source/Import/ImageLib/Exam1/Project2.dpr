program Project2;

uses
  Forms,
  Unit2 in 'Unit2.pas' {Form1},
  ImageLibX in '..\ImageLibX.pas',
  ImgLibObjs in '..\ImgLibObjs.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
