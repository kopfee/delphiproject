program PProgRight;

uses
  Forms,
  UProgRight in 'UProgRight.pas' {Form1},
  UDMProgRight in 'UDMProgRight.pas' {DataModule2: TDataModule};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TDataModule2, DataModule2);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
