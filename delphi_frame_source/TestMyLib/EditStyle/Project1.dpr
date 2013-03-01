program Project1;

uses
  Forms,
  UMain1 in 'UMain1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
