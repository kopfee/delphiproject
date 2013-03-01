unit UTestHelp1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, HelpBtns,PDataHelper;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    edit1: TEdit;
    HelpButton1: THelpButton;
    Button1: TButton;
    HelpButton2: THelpButton;
    HelpButton3: THelpButton;
    HelpButton4: THelpButton;
    procedure Button1Click(Sender: TObject);
    procedure HelpButton1AfterHelp(Sender: THelpButton;
      Helper: TCustomDataHelper);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;


implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  s:string;
  DataHelper : TCustomDataHelper;
begin
  s:=edit1.text;
  if TDataHelpManager.ExecuteHelp(edit1,'TestHelp1',s,nil,DataHelper)=mrOK then
  begin
    edit1.text:=s;
  end;
end;

procedure TForm1.HelpButton1AfterHelp(Sender: THelpButton;
  Helper: TCustomDataHelper);
begin
  if Helper.ExecResult=mrOk then
    edit1.text:= Helper.TextValue;
end;


end.
