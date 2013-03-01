unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RPCtrls, RPProcessors;

type
  TfmReport3 = class(TForm)
    ReportProcessor: TReportProcessor;
    RDReport: TRDReport;
    RDSimpleBand1: TRDSimpleBand;
    RDLabel1: TRDLabel;
    RDRepeatBand1: TRDRepeatBand;
    RDRepeatBand2: TRDRepeatBand;
    RDRepeatBand3: TRDRepeatBand;
    RDSimpleBand4: TRDSimpleBand;
    RDSimpleBand2: TRDSimpleBand;
    RDLabel3: TRDLabel;
    RDLabel5: TRDLabel;
    RDSimpleBand3: TRDSimpleBand;
    RDLabel7: TRDLabel;
    RDLabel8: TRDLabel;
    RDLabel9: TRDLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmReport3: TfmReport3;

implementation

{$R *.DFM}

end.
