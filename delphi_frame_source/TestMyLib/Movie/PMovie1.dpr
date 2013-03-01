program PMovie1;

uses
  Forms,
  UMain in 'UMain.pas' {Form1},
  MovieViewer in '..\MovieViewer.pas' {MovieView: TContainer};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
