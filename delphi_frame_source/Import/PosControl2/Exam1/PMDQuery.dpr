program PMDQuery;

uses
  Forms,
  UMDQuery in 'UMDQuery.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
