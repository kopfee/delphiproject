program PNew3;

uses
  Forms,
  UCtrl4 in 'UCtrl4.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
