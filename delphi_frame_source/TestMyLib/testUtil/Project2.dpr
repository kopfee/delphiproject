program Project2;

uses
  Forms,
  Unit2 in 'Unit2.pas' {fmMain},
  Unit3 in 'Unit3.pas' {fmChild};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmChild, fmChild);
  Application.Run;
end.
