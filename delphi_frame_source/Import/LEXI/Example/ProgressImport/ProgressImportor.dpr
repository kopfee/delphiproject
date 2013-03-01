program ProgressImportor;

uses
  Forms,
  ImportMain in 'ImportMain.pas' {fmMain},
  ProgDlg in 'ProgDlg.pas' {dlgProgress};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Progress Importor';
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TdlgProgress, dlgProgress);
  Application.Run;
end.
