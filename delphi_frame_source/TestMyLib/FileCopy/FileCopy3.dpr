program FileCopy3;

uses
  Forms,
  Unit3 in 'Unit3.pas' {Form1},
  FileCopyOptCnt in '..\ComForms\FileCopyOptCnt.pas' {ctFileCopyOptions: TContainer};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
