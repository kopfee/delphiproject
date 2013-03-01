program Project3;

uses
  Forms,
  Unit3 in 'Unit3.pas' {Form1},
  BtnLookCfgDLG in '..\DsnWizard\BtnLookCfgDLG.pas' {dlgCfgBtnLook};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TdlgCfgBtnLook, dlgCfgBtnLook);
  Application.Run;
end.
