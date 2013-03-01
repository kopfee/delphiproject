program PNew2;

uses
  Forms,
  UCtrl3 in 'UCtrl3.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
