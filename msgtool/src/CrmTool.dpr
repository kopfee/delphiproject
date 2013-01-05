program CrmTool;

uses
  Forms,
  UDemo in 'UDemo.pas' {frmMain},
  FormWait in '..\..\CommonUnit\FormWait.pas',
  uLkJSON in '..\..\CommonUnit\uLkJSON.pas',
  md5 in '..\..\CommonUnit\md5.pas',
  AES in '..\..\CommonUnit\AES.pas',
  ElAES in '..\..\CommonUnit\ElAES.pas',
  uRunOnce in '..\..\CommonUnit\uRunOnce.pas',
  mysql in '..\..\CommonUnit\mysql.pas',
  uConst in 'uConst.pas',
  Ulogin in 'Ulogin.pas' {loginForm};

{$R *.res}

begin
    Application.Initialize;
{$IFDEF CONDITIONALEXPRESSIONS}
    {Delphi 6 and above}
{$IF (CompilerVersion>=18)}
    Application.MainFormOnTaskbar := True;
{$IFEND}
{$ENDIF}
    Application.Title := 'CRM消息通知';
    if not AppHasRun(Application.Handle) then
        Application.CreateForm(TloginForm, loginForm);
  Application.Run;
end.

