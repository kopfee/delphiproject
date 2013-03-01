program FileCopy;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  FileCopyOptCnt in '..\ComForms\FileCopyOptCnt.pas' {ctFileCopyOptions: TContainer};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
