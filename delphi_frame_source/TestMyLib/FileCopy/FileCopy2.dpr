program FileCopy2;

uses
  Forms,
  Unit2 in 'Unit2.pas' {Form1},
  FileCopyOptCnt in '..\ComForms\FileCopyOptCnt.pas' {ctFileCopyOptions: TContainer};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
