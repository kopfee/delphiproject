program Movie1;

uses
  Forms,
  UMain3 in 'UMain3.pas' {Form1},
  QuartzTypeLib_TLB in '..\QuartzTypeLib_TLB.pas',
  UVideoForm3 in 'UVideoForm3.pas' {fmVideo},
  AMovieUtils in '..\..\MyLib\AMovieUtils.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfmVideo, fmVideo);
  Application.Run;
end.
