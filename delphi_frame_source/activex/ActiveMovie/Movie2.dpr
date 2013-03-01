program Movie2;

uses
  Forms,
  UMain4 in 'UMain4.pas' {Form1},
  QuartzTypeLib_TLB in '..\QuartzTypeLib_TLB.pas',
  UVideoForm4 in 'UVideoForm4.pas' {fmVideo},
  AMovieUtils in '..\..\MyLib\AMovieUtils.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfmVideo, fmVideo);
  Application.Run;
end.
