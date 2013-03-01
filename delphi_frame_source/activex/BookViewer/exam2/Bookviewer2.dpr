program Bookviewer2;

uses
  Forms,
  UMain in 'UMain.pas' {fmViewer},
  UBookmarkMan in 'UBookmarkMan.pas' {dlgBookmarkMan},
  UBookMan in 'UBookMan.pas' {dlgBookMan},
  HYLAbout in '..\..\..\MyLib\HYLAbout.pas' {dlgAbout};

{$R *.RES}

begin
  StartAbout(1000);
  Application.Initialize;
  Application.Title := 'Book Viewer';
  Application.CreateForm(TfmViewer, fmViewer);
  Application.CreateForm(TdlgBookMan, dlgBookMan);
  Application.CreateForm(TdlgBookmarkMan, dlgBookmarkMan);
  Application.Run;
end.
