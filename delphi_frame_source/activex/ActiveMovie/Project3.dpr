program Project3;

uses
  Forms,
  UMain2 in 'UMain2.pas' {Form1},
  QuartzTypeLib_TLB in '..\QuartzTypeLib_TLB.pas',
  UVedioForm in 'UVedioForm.pas' {fmVideo};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfmVideo, fmVideo);
  Application.Run;
end.
