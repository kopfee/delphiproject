program Qrep16;

uses
  Forms,
  qr2const in 'QR2CONST.PAS',
  qrabout in 'QRABOUT.PAS' {QRAboutBox},
  qralias in 'QRALIAS.PAS' {QRTableSelect},
  Qrcomped in 'QRCOMPED.PAS' {QRCompEd},
  Qrctrls in 'QRCTRLS.PAS',
  qrdatasu in 'QRDATASU.PAS' {QRDataSetup},
  qreport in 'QREPORT.PAS',
  qrexpbld in 'QREXPBLD.PAS' {QRExprBuilder},
  qrextra in 'QREXTRA.PAS',
  qrHtml in 'QRHTML.PAS',
  Qrprev in 'QRPREV.PAS' {QRStandardPreview},
  Qrprgres in 'QRPRGRES.PAS' {QRProgressForm},
  qrprntr in 'QRPRNTR.PAS',
  quickrpt in 'QUICKRPT.PAS';

{$R *.RES}

begin
  Application.Run;
end.
