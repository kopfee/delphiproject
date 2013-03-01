program PMovie3;

uses
  Forms,
  UMovie3 in 'UMovie3.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
