unit UAnimals;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, RPCtrls, RPDB, RPDBVCL, RPProcessors, RPEasyReports;

type
  TForm1 = class(TForm)
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

end.
