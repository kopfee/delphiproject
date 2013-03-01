unit ProviderEx;

(*****   Code Written By Huang YanLai   *****)

interface

uses SysUtils,Classes,DB,Provider;

type
  // TDataSetProviderEx
  // 1. convert null Params to unassigned to resovle query re-opening problem
  //  see DoBeforeGetRecords
  // notes :
  //   1) PackageParams (in DBClient) produce null as param
  //  when TClientDataset.Params.count=0
  //   2) TDataSetProvider.SetParams call PSSetParams when Params is not unassigned
  //   3) TQuery.PSSetParams  and TStoredProc.PSSetParams will close itself
  TProviderEx = class(TDataSetProvider)
  private

  protected
    procedure DoBeforeGetRecords(Count: Integer; Options: Integer;
      const CommandText: WideString; var Params, OwnerData: OleVariant); override;
  public

  published

  end;

implementation

{ TProviderEx }

procedure TProviderEx.DoBeforeGetRecords(Count, Options: Integer;
  const CommandText: WideString; var Params, OwnerData: OleVariant);
begin
  if VarIsNull(Params) then Params:=unassigned;
  inherited;
end;

end.
 