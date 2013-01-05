program yczn_c10;

uses
    Forms,
    Unit1 in 'Unit1.pas' {Form1},
    uDoorController in 'uDoorController.pas',
    AES in '..\..\CommonUnit\AES.pas',
    ElAES in '..\..\CommonUnit\ElAES.pas',
    uRunOnce in '..\..\CommonUnit\uRunOnce.pas',
    FormWait in '..\..\CommonUnit\FormWait.pas' {frmWait};

{$R *.res}

begin
    Application.Initialize;
    Application.Title := 'Óî´¨ÖÇÄÜC10';
    if not AppHasRun(Application.Handle) then
        Application.CreateForm(TForm1, Form1);
    Application.Run;
end.

