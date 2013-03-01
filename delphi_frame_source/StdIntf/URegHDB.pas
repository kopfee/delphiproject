unit URegHDB;

interface

procedure Register;

implementation

uses Classes,BDAImpEx;

const
  HDBPage = 'HDB';

procedure Register;
begin
  RegisterComponents(HDBPage,
    [THStdDataset,THQuery,THResponseHandler,THSimpleDataset]);
end;

end.
