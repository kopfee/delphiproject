unit UMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfmMain = class(TForm)
    rgStyles: TRadioGroup;
    btnPreview: TButton;
    procedure btnPreviewClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

uses UDataCenter, Unit1, Unit2, Unit3, RPBands, Unit4, Unit5, Unit6;

{$R *.DFM}

procedure TfmMain.btnPreviewClick(Sender: TObject);
begin
  dmReportCenter.Query1.Active := true;
  dmReportCenter.EasyReport.Processor := nil;
  case rgStyles.ItemIndex of
    0 : dmReportCenter.EasyReport.Processor := fmReport1.ReportProcessor;
    1 : dmReportCenter.EasyReport.Processor := fmReport2.ReportProcessor;
    2 : dmReportCenter.EasyReport.Processor := fmReport3.ReportProcessor;
    3 : dmReportCenter.EasyReport.Processor := fmReport4.ReportProcessor;
    4 : dmReportCenter.EasyReport.Processor := fmReport5.ReportProcessor;
    5 : dmReportCenter.EasyReport.Processor := fmReport6.ReportProcessor;
  end;
  Assert(dmReportCenter.EasyReport.Processor <> nil);
  if dmReportCenter.EasyReport.Processor.Report=nil then
  begin
    dmReportCenter.EasyReport.Processor.CreateReportFromDesign;
    SaveReport(dmReportCenter.EasyReport.Processor.Report,'c:\RPReportFile.txt');
  end;

  dmReportCenter.EasyReport.Preview;
end;

end.
