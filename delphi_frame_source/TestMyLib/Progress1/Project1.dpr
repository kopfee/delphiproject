program Project1;

uses
  Forms,
  ProgReptDlg in '..\ComForms\ProgReptDlg.pas' {dlgProgressReport},
  ProgressDlgs in '..\ProgressDlgs.pas',
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
