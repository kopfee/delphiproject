program Tool;

uses
  Forms,
  mainUnit in '.\src\mainUnit.pas' {MainForm},
  Uencrypt in '.\src\Uencrypt.pas' {frmEncrypt},
  AES in '..\CommonUnit\AES.pas',
  ElAES in '..\CommonUnit\ElAES.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
