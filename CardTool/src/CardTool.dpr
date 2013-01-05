program CardTool;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  CardDll in 'CardDll.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
