program Project2;

uses
  Forms,
  Unit2 in 'Unit2.pas' {Form1},
  TreeItems in '..\TreeItems.pas',
  IntfUtils in '..\IntfUtils.pas',
  DBTreeItems in '..\DBTreeItems.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
