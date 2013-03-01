program PAutoTest2;

uses
  Forms,
  UAutoTest in 'UAutoTest.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
