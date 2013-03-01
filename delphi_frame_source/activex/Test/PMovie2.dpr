program PMovie2;

uses
  Forms,
  UMovie2 in 'UMovie2.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
