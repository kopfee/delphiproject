program Qrep3;
{ This version have been fixed, the bug information is from
  "QuickReport bugs & fixes Page - http://www.bitsoft.com/delphi/quickrpt"
  The following bug number have been fixed :-
    1,2,3(Partical),4,7
}

uses
  Forms,
  qr2const in '..\SrcFixed\Qr2const.pas',
  qrabout in '..\SrcFixed\Qrabout.pas' {QRAboutBox},
  qralias in '..\SrcFixed\Qralias.pas' {QRTableSelect},
  Qrcomped in '..\SrcFixed\Qrcomped.pas' {QRCompEd},
  Qrctrls in '..\SrcFixed\Qrctrls.pas',
  qrdatasu in '..\SrcFixed\Qrdatasu.pas' {QRDataSetup},
  qreport in '..\SrcFixed\Qreport.pas',
  qrexpbld in '..\SrcFixed\Qrexpbld.pas' {QRExprBuilder},
  qrexpdlg in '..\SrcFixed\Qrexpdlg.pas' {QRExpert},
  qrextra in '..\SrcFixed\Qrextra.pas',
  qrHtml in '..\SrcFixed\Qrhtml.pas',
  Qrprgres in '..\SrcFixed\QRprgres.pas' {QRProgressForm},
  qrprntr in '..\SrcFixed\QRPrntr.pas',
  quickrpt in '..\SrcFixed\QuickRpt.pas',
  QRPrev in '..\SrcFixed\QRPrev.pas' {QRStandardPreview};

{$R *.RES}

begin
  Application.Initialize;
  Application.Run;
end.
