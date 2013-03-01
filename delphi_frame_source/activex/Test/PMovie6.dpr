program PMovie6;

uses
  Forms,
  UMovie6 in 'UMovie6.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
