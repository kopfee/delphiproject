program Project2;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  ImagesMan in '..\..\MyLib\ImagesMan.pas',
  ImageCtrls in '..\..\MyLib\ImageCtrls.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
