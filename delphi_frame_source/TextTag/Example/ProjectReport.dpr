program ProjectReport;



uses
  Forms,
  UProjectReport in 'UProjectReport.pas' {fmProjectReport},
  AbsParsers in '..\AbsParsers.pas',
  PrjRepScripts in '..\PrjRepScripts.pas',
  UTemp in 'UTemp.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmProjectReport, fmProjectReport);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
