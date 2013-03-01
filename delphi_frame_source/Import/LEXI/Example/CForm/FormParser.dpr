program FormParser;

uses
  Forms,
  UMain in 'UMain.pas' {fmMain},
  CommParser in '..\..\..\..\MyLib\CommParser.pas' {CommonParser: TDataModule},
  RepInfoIntf in '..\..\..\..\MyLib\RepInfoIntf.pas',
  ProgDlg2 in '..\..\..\..\MyLib\ProgDlg2.pas' {dlgProgress},
  UFormParser in 'UFormParser.pas' {dmFormParser: TDataModule};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TdmFormParser, dmFormParser);
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TdlgProgress, dlgProgress);
  Application.Run;
end.
