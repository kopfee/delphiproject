program Project1;

uses
  Forms,
  PenCfgDlg in '..\ComForms\PenCfgDlg.pas' {dlgPenCfg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TdlgPenCfg, dlgPenCfg);
  Application.Run;
end.
