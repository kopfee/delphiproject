program Bookviewer;

uses
  Forms,
  UMain in 'UMain.pas' {fmViewer};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmViewer, fmViewer);
  Application.Run;
end.
