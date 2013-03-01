program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {AppBuilder},
  IDEDlgs in '..\..\MyLib\IDEDlgs.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TAppBuilder, AppBuilder);
  Application.Run;
end.
