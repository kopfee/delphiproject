unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RPCtrls, StdCtrls, RPProcessors, RPEasyReports;

type
  TfmReport1 = class(TForm)
    RDReport1: TRDReport;
    RDSimpleBand1: TRDSimpleBand;
    RDLabel1: TRDLabel;
    RDGroupBand1: TRDGroupBand;
    RDSimpleBand2: TRDSimpleBand;
    RDLabel2: TRDLabel;
    RDRepeatBand1: TRDRepeatBand;
    RDSimpleBand3: TRDSimpleBand;
    RDLabel3: TRDLabel;
    RDLabel4: TRDLabel;
    RDLabel5: TRDLabel;
    RDLabel6: TRDLabel;
    RDLabel7: TRDLabel;
    RDLabel8: TRDLabel;
    RDLabel9: TRDLabel;
    ReportProcessor: TReportProcessor;
    RDSimpleBand4: TRDSimpleBand;
    RDLabel10: TRDLabel;
    RDSimpleBand5: TRDSimpleBand;
    RDLabel11: TRDLabel;
    RDLabel12: TRDLabel;
    RDLabel13: TRDLabel;
    RDShape1: TRDShape;
    RDShape2: TRDShape;
    RDLabel14: TRDLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmReport1: TfmReport1;

implementation

{$R *.DFM}

end.
