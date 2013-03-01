program Project2;

uses
  Forms,
  UTest2 in 'UTest2.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
