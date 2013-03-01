program SPReference;

uses
  Forms,
  SPRefMain in 'SPRefMain.pas' {fmMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Stored Procedure Reference';
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
