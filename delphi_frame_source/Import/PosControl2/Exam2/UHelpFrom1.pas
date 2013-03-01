unit UHelpFrom1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, PDataHelper;

type
  TdlgHelpForm = class(TForm)
    SimpleDataHelper1: TSimpleDataHelper;
    Label1: TLabel;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure SimpleDataHelper1BeforeHelp(Helper: TCustomDataHelper);
    procedure SimpleDataHelper1AfterHelp(Helper: TCustomDataHelper);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgHelpForm: TdlgHelpForm;

implementation

{$R *.DFM}


procedure TdlgHelpForm.SimpleDataHelper1BeforeHelp(Helper: TCustomDataHelper);
begin
  if Helper.HelpSender is TEdit then
      Helper.TextValue:=TEdit(Helper.HelpSender).Text;
  edit1.text:=Helper.TextValue;
  ActiveControl := edit1;
end;

procedure TdlgHelpForm.SimpleDataHelper1AfterHelp(Helper: TCustomDataHelper);
begin
  if Helper.ExecResult=mrOK then
  begin
    Helper.TextValue:=edit1.text;
    if Helper.HelpSender is TEdit then
      TEdit(Helper.HelpSender).Text:=Helper.TextValue;
  end;
end;


initialization
  

end.
