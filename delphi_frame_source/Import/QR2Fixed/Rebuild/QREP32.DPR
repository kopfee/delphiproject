program QRep32;

uses
  Forms,
  qr2const in 'Qr2const.pas',
  qrabout in 'Qrabout.pas' {QRAboutBox},
  qralias in 'Qralias.pas' {QRTableSelect},
  Qrcomped in 'Qrcomped.pas' {QRCompEd},
  Qrctrls in 'Qrctrls.pas',
  qrdatasu in 'Qrdatasu.pas' {QRDataSetup},
  qreport in 'Qreport.pas',
  qrexpbld in 'Qrexpbld.pas' {QRExprBuilder},
  qrexpdlg in 'Qrexpdlg.pas' {QRExpert},
  qrextra in 'Qrextra.pas',
  qrHtml in 'Qrhtml.pas',
  Qrprgres in 'QRprgres.pas' {QRProgressForm},
  qrprntr in 'QRPrntr.pas',
  quickrpt in 'QuickRpt.pas',
  QRPrev in 'QRPrev.pas' {QRStandardPreview};

{$R *.RES}

begin
  Application.Initialize;
  Application.Run;
end.
