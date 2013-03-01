program Example;

uses
  Forms,
  ExampleMainform in 'ExampleMainform.pas' {Form1},
  AboutDialog in 'AboutDialog.pas' {AboutForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TExampleForm, ExampleForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
