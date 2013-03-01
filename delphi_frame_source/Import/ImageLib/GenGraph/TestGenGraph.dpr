program TestGenGraph;

uses
  Forms,
  UInputParam in 'UInputParam.pas' {fmInputParam},
  UViewGraph in 'UViewGraph.pas' {fmViewer},
  UGenGraph in 'UGenGraph.pas',
  ImgLibObjs in '..\ImgLibObjs.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmInputParam, fmInputParam);
  Application.CreateForm(TfmViewer, fmViewer);
  Application.Run;
end.
