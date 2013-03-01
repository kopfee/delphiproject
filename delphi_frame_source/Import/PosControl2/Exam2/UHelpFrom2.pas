unit UHelpFrom2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, PDataHelper;

type
  TdlgHelpForm2 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgHelpForm2: TdlgHelpForm2;

implementation

{$R *.DFM}



type
  TMyHelp = class(TFormDataHelper)
  protected
    procedure   DoBeforeHelp;override;
    procedure   DoAfterHelp; override;
  end;

procedure   TMyHelp.DoBeforeHelp;
begin
  if HelpSender is TEdit then
      TextValue:=TEdit(HelpSender).Text;
  TdlgHelpForm2(HelpForm).edit1.text:=TextValue;
end;

procedure   TMyHelp.DoAfterHelp;
begin
  if ExecResult=mrOK then
  begin
    TextValue:=TdlgHelpForm2(HelpForm).edit1.text;
    if HelpSender is TEdit then
      TEdit(HelpSender).Text:=TextValue;
  end;
end;

initialization
  TMyHelp.CreateByClass(nil,'TestHelp2',TdlgHelpForm2);

end.
