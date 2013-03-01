program PDebug1;

uses
  Forms,
  UDebug1 in 'UDebug1.pas' {Form1},
  DragMoveUtils in '..\DragMoveUtils.pas',
  MsgFilters in '..\MsgFilters.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
