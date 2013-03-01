unit UDataCenter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RPEasyReports, Db, DBTables, RPDB, RPDBVCL;

type
  TdmReportCenter = class(TDataModule)
    Query1: TQuery;
    EasyReport: TRPEasyReport;
    Controller1: TRPDatasetController;
    Controller2: TRPDatasetController;
    Controller3_Master: TRPDatasetController;
    Query2: TQuery;
    DataSource2: TDataSource;
    Query3: TQuery;
    Controller3_Detail: TRPDatasetController;
    Controller4: TRPDatasetController;
    Query4: TQuery;
    RPDataEnvironment1: TRPDataEnvironment;
    RPDBDataset1: TRPDBDataset;
    RPDBDataset2: TRPDBDataset;
    RPDBDataset3: TRPDBDataset;
    RPDBDataset4: TRPDBDataset;
    DataSource1: TDataSource;
    DataSource3: TDataSource;
    DataSource4: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmReportCenter: TdmReportCenter;

implementation

{$R *.DFM}

end.
