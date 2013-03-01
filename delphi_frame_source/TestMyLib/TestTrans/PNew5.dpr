program PNew5;

uses
  Forms,
  UCtrl6 in 'UCtrl6.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
