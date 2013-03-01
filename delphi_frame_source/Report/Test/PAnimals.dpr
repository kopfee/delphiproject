program PAnimals;

uses
  Forms,
  UAnimalsRep in 'UAnimalsRep.pas' {fmReport},
  UAnimalMain in 'UAnimalMain.pas' {fmMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmReport, fmReport);
  Application.Run;
end.
