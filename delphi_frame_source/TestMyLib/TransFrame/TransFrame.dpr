program TransFrame;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Controls in 'c:\program files\borland\delphi4\source\vcl\Controls.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
