program Project1;

uses
  Forms,
  IDESpyMain in '..\..\MyLib\IDESpyMain.pas' {dlgIDESpyMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TdlgIDESpyMain, dlgIDESpyMain);
  Application.Run;
end.
