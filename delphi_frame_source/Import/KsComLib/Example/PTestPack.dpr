program PTestPack;

uses
  Forms,
  UTestPack in 'UTestPack.pas' {Form1},
  KCDataPack in '..\KCDataPack.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
