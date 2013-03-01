program Project3;

uses
  Forms,
  UCtrl1 in 'UCtrl1.pas' {Form1},
  UCtrl2 in 'UCtrl2.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
