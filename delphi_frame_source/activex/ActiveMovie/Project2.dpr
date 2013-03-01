program Project2;

uses
  Forms,
  UMain2 in 'UMain2.pas' {Form1},
  QuartzTypeLib_TLB in '..\QuartzTypeLib_TLB.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
