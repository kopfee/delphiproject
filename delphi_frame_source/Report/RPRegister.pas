unit RPRegister;

interface

procedure Register;

implementation

uses Classes, RPCtrls, RPProcessors, RPEasyReports, RPDB, RPDBVCL, RPDBDesignInfo;

const
  Page = 'KSReport';

procedure Register;
begin
  RegisterComponents(Page,
    [
    TRDReport,
    TRDGroupBand,
    TRDRepeatBand,
    TRDSimpleBand,
    TRDLabel,
    TRDShape,
    TRDPicture,
    TRPDataEnvironment,
    TRPEasyReport,
    TReportProcessor,
    TRPDatasetController,
    TRPDBDataset,
    TDBReportInfo,
    TRPGlobe
    ]);
end;


end.
