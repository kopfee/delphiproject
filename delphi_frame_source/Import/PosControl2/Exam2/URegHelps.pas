unit URegHelps;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  PDataHelper,StdCtrls;

type
  TDataModule1 = class(TDataModule)
    DynamicDataHelper1: TDynamicDataHelper;
    procedure DynamicDataHelper1AfterHelp(Helper: TCustomDataHelper);
    procedure DynamicDataHelper1BeforeHelp(Helper: TCustomDataHelper);
    procedure DataModule1Create(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

uses UHelpFrom3;

{$R *.DFM}

procedure TDataModule1.DynamicDataHelper1AfterHelp(
  Helper: TCustomDataHelper);
begin
  if Helper.ExecResult=mrOK then
  begin
    Helper.TextValue:=TdlgHelpForm3(Helper.HelpObject).edit1.text;
    if Helper.HelpSender is TEdit then
      TEdit(Helper.HelpSender).Text:=Helper.TextValue;
  end;
end;

procedure TDataModule1.DynamicDataHelper1BeforeHelp(
  Helper: TCustomDataHelper);
begin
  if Helper.HelpSender is TEdit then
      Helper.TextValue:=TEdit(Helper.HelpSender).Text;
  TdlgHelpForm3(Helper.HelpObject).edit1.text:=Helper.TextValue;
end;

procedure TDataModule1.DataModule1Create(Sender: TObject);
begin
  DynamicDataHelper1.FormClass := TdlgHelpForm3;
end;

end.
