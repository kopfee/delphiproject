unit UAnimalsRep;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, RPCtrls, RPDB, RPDBVCL, RPProcessors, RPEasyReports;

type
  TfmReport = class(TForm)
    RDReport1: TRDReport;
    RDSimpleBand1: TRDSimpleBand;
    RDLabel1: TRDLabel;
    RDGroupBand1: TRDGroupBand;
    RDSimpleBand2: TRDSimpleBand;
    RDRepeatBand1: TRDRepeatBand;
    RDSimpleBand3: TRDSimpleBand;
    RDGroupBand2: TRDGroupBand;
    RDSimpleBand4: TRDSimpleBand;
    RDRepeatBand2: TRDRepeatBand;
    RDSimpleBand5: TRDSimpleBand;
    RDSimpleBand6: TRDSimpleBand;
    RDSimpleBand7: TRDSimpleBand;
    RDLabel2: TRDLabel;
    RDLabel3: TRDLabel;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    Table1: TTable;
    Table2: TTable;
    Table1NAME: TStringField;
    Table1SIZE: TSmallintField;
    Table1WEIGHT: TSmallintField;
    Table1AREA: TStringField;
    Table1BMP: TBlobField;
    Table2SpeciesNo: TFloatField;
    Table2Category: TStringField;
    Table2Common_Name: TStringField;
    Table2SpeciesName: TStringField;
    Table2Lengthcm: TFloatField;
    Table2Length_In: TFloatField;
    Table2Notes: TMemoField;
    Table2Graphic: TGraphicField;
    RDLabel4: TRDLabel;
    RDLabel5: TRDLabel;
    RDLabel6: TRDLabel;
    RDLabel7: TRDLabel;
    RDLabel8: TRDLabel;
    RDLabel9: TRDLabel;
    RDLabel10: TRDLabel;
    RPDatasetController1: TRPDatasetController;
    RPDatasetController2: TRPDatasetController;
    RPDBDataset1: TRPDBDataset;
    RPDBDataset2: TRPDBDataset;
    RPDataEnvironment1: TRPDataEnvironment;
    RPEasyReport1: TRPEasyReport;
    ReportProcessor1: TReportProcessor;
    RDLabel11: TRDLabel;
    RDLabel12: TRDLabel;
    RDLabel13: TRDLabel;
    RDLabel14: TRDLabel;
    RDLabel15: TRDLabel;
    RDLabel16: TRDLabel;
    RDLabel18: TRDLabel;
    RDLabel19: TRDLabel;
    RDLabel20: TRDLabel;
    RDLabel21: TRDLabel;
    RDLabel22: TRDLabel;
    RDLabel23: TRDLabel;
    RDLabel17: TRDLabel;
    RDLabel24: TRDLabel;
    RDLabel25: TRDLabel;
    RDPicture1: TRDPicture;
    RDPicture2: TRDPicture;
    RDPicture3: TRDPicture;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmReport: TfmReport;

implementation

{$R *.DFM}

end.
