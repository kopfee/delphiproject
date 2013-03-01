program PropTst;

uses
  Forms,
  PropFrm in 'PropFrm.pas' {Form1},
  DsgnIntf in '..\..\Program Files\Borland\Delphi5\Source\Toolsapi\DsgnIntf.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Object Inspector';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
