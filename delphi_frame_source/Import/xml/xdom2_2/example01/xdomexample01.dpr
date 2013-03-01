program xdomexample01;

uses
  Forms,
  example01main in 'example01main.pas' {Mainpage};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainpage, Mainpage);
  Application.Run;
end.
