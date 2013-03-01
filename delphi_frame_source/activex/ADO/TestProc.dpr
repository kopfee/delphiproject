program TestProc;

uses
  Forms,
  UTestProc in 'UTestProc.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
