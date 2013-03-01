program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  BDAImp in '..\..\StdIntf\BDAImp.pas',
  BDAImpEx in '..\..\StdIntf\BDAImpEx.pas',
  Listeners in '..\..\MyLib\Listeners.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
