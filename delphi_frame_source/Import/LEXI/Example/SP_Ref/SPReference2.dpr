program SPReference2;

uses
  Forms,
  SPRefMain2 in 'SPRefMain2.pas' {fmMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Stored Procedure Reference';
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
