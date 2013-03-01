program PImage2;

uses
  Forms,
  UImage2 in 'UImage2.pas' {Form1},
  ImageLibX in '..\ImageLibX.pas',
  UProgress in 'UProgress.pas' {dlgProgress},
  ImgLibObjs in '..\ImgLibObjs.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TdlgProgress, dlgProgress);
  Application.Run;
end.
