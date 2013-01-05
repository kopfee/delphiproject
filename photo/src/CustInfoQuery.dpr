program CustInfoQuery;

uses
  Forms,
  UCustInfoQuery in 'UCustInfoQuery.pas' {frmCustInfoQuery},
  Udm in 'Udm.pas' {frmdm: TDataModule},
  uCommon in 'uCommon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmCustInfoQuery, frmCustInfoQuery);
  Application.CreateForm(Tfrmdm, frmdm);
  Application.Run;
end.
