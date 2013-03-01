unit UCmdProcs2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WVCmdProc, WVCommands, Db, BDAImpEx, KCDataAccess, DBAIntf, KCWVProcBinds;

type
  TdmCmProcs = class(TDataModule)
    KCDatabase1: TKCDatabase;
    KCDataset1: TKCDataset;
    KCWVProcessor1: TKCWVProcessor;
    KCWVProcessor2: TKCWVProcessor;
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  dmCmProcs: TdmCmProcs;

implementation

{$R *.DFM}

end.
