program PCustOpenAcc2;

uses
  Forms,
  UCustOpenAcc2 in 'UCustOpenAcc2.pas' {fmCustOpenAcc},
  UCmdDefinitions in 'UCmdDefinitions.pas' {dmCmdDefinitions: TDataModule},
  UCmdProcs2 in 'UCmdProcs2.pas' {dmCmProcs: TDataModule},
  UContext2 in 'UContext2.pas' {dmContext: TDataModule};

{$R *.RES}

begin
  // 注意创建的顺序
  Application.Initialize;
  Application.CreateForm(TdmCmdDefinitions, dmCmdDefinitions);
  Application.CreateForm(TdmCmProcs, dmCmProcs);
  Application.CreateForm(TdmContext, dmContext);
  Application.CreateForm(TfmCustOpenAcc, fmCustOpenAcc);
  Application.Run;
end.
