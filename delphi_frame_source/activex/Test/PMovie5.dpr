program PMovie5;

uses
  Forms,
  UMovie5 in 'UMovie5.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
