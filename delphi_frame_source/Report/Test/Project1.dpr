program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {fmReport1},
  UDataCenter in 'UDataCenter.pas' {dmReportCenter: TDataModule},
  UMain in 'UMain.pas' {fmMain},
  Unit6 in 'Unit6.pas' {fmReport6},
  Unit2 in 'Unit2.pas' {fmReport2},
  Unit5 in 'Unit5.pas' {fmReport5},
  Unit4 in 'Unit4.pas' {fmReport4},
  Unit3 in 'Unit3.pas' {fmReport3};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TdmReportCenter, dmReportCenter);
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmReport1, fmReport1);
  Application.CreateForm(TfmReport2, fmReport2);
  Application.CreateForm(TfmReport3, fmReport3);
  Application.CreateForm(TfmReport4, fmReport4);
  Application.CreateForm(TfmReport5, fmReport5);
  Application.CreateForm(TfmReport6, fmReport6);
  Application.Run;
end.
