program PCustOpenAcc;

uses
  Forms,
  UCustOpenAcc in 'UCustOpenAcc.pas' {fmCustOpenAcc},
  UCmdDefinitions in 'UCmdDefinitions.pas' {dmCmdDefinitions: TDataModule},
  UCmdProcs in 'UCmdProcs.pas' {dmCmProcs: TDataModule},
  UContext in 'UContext.pas' {dmContext: TDataModule};

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
