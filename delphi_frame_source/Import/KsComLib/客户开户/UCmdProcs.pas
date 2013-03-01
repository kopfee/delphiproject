unit UCmdProcs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WVCmdProc, WVCommands, Db, BDAImpEx, KCDataAccess, DBAIntf, KCWVProcBinds;

type
  TdmCmProcs = class(TDataModule)
    KCDatabase1: TKCDatabase;
    KCDataset1: TKCDataset;
    KCWVProcessor1: TKCWVProcessor;
    procedure SetUserID(
      Dataset: TKCDataset; Command: TWVCommand; Param: THRPCParam);
    procedure SetDepartID(
      Dataset: TKCDataset; Command: TWVCommand; Param: THRPCParam);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FUserID : string;
    FDepartmentID : Integer;
  public
    { Public declarations }
  end;

var
  dmCmProcs: TdmCmProcs;

implementation

{$R *.DFM}

procedure TdmCmProcs.SetUserID(
  Dataset: TKCDataset; Command: TWVCommand; Param: THRPCParam);
begin
  Param.AsString := FUserID;
end;

procedure TdmCmProcs.SetDepartID(
  Dataset: TKCDataset; Command: TWVCommand; Param: THRPCParam);
begin
  Param.AsInteger := FDepartmentID;
end;

procedure TdmCmProcs.DataModuleCreate(Sender: TObject);
begin
  FUserID := '001';
  FDepartmentID := 101;
end;

end.
