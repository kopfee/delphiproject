program PShellView;

uses
  Forms,
  UShellView in 'UShellView.pas' {Form1},
  UFolderItem in 'UFolderItem.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
