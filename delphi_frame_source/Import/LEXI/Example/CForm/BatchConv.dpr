program BatchConv;

uses
  Forms,
  UBatchMain in 'UBatchMain.pas' {fmBatchMain},
  CommParser in '..\..\..\..\mylib\CommParser.pas' {CommonParser: TDataModule},
  ProgDlg2 in '..\..\..\..\MyLib\ProgDlg2.pas' {dlgProgress},
  UFormParser in 'UFormParser.pas' {dmFormParser: TDataModule};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TdmFormParser, dmFormParser);
  Application.CreateForm(TfmBatchMain, fmBatchMain);
  Application.CreateForm(TdlgProgress, dlgProgress);
  Application.Run;
end.
