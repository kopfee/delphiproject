unit UDMProgRight;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, AbilityManager;

type
  TDataModule2 = class(TDataModule)
    dbNormal: TDatabase;
    qrTest: TQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule2: TDataModule2;

implementation

uses UProgRight;

{$R *.DFM}

end.
