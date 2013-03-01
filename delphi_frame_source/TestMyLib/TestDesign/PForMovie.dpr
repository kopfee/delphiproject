program PForMovie;

uses
  Forms,
  UForMovie in 'UForMovie.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
