program Project2;

uses
  Forms,
  Unit2 in 'Unit2.pas' {Form1},
  BDAImp in '..\..\StdIntf\BDAImp.pas',
  BDAImpEx in '..\..\StdIntf\BDAImpEx.pas',
  Listeners in '..\..\MyLib\Listeners.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
