unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RPCtrls, RPProcessors;

type
  TfmReport2 = class(TForm)
    ReportProcessor: TReportProcessor;
    RDReport: TRDReport;
    RDSimpleBand1: TRDSimpleBand;
    RDLabel1: TRDLabel;
    RDRepeatBand1: TRDRepeatBand;
    RDRepeatBand2: TRDRepeatBand;
    RDRepeatBand3: TRDRepeatBand;
    RDSimpleBand4: TRDSimpleBand;
    RDSimpleBand2: TRDSimpleBand;
    RDLabel2: TRDLabel;
    RDLabel3: TRDLabel;
    RDLabel4: TRDLabel;
    RDLabel5: TRDLabel;
    RDSimpleBand3: TRDSimpleBand;
    RDLabel6: TRDLabel;
    RDLabel7: TRDLabel;
    RDLabel8: TRDLabel;
    RDLabel9: TRDLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmReport2: TfmReport2;

implementation

{$R *.DFM}

end.
