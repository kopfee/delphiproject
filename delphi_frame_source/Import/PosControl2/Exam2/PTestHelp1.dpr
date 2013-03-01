program PTestHelp1;

uses
  Forms,
  UHelpFrom3 in 'UHelpFrom3.pas' {dlgHelpForm3},
  UTestHelp1 in 'UTestHelp1.pas' {Form1},
  UHelpFrom2 in 'UHelpFrom2.pas' {dlgHelpForm2},
  UHelpFrom1 in 'UHelpFrom1.pas' {dlgHelpForm},
  URegHelps in 'URegHelps.pas' {DataModule1: TDataModule};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TdlgHelpForm, dlgHelpForm);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
