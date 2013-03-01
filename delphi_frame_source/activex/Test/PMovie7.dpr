program PMovie7;

uses
  Forms,
  UMovie7 in 'UMovie7.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
