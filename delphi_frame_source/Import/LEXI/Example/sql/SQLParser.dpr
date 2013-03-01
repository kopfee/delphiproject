program SQLParser;

uses
  Forms,
  SQLMainform in 'SQLMainform.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TExampleForm, ExampleForm);
  Application.Run;
end.
