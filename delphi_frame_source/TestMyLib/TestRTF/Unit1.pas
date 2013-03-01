unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Spin;
{
const
  EM_POSFROMCHAR                      = WM_USER + 38;
  EM_CHARFROMPOS                      = WM_USER + 39;
}
type
  TForm1 = class(TForm)
    RichEdit1: TRichEdit;
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    edWL: TSpinEdit;
    edWH: TSpinEdit;
    edLL: TSpinEdit;
    edLH: TSpinEdit;
    label1: TLabel;
    label11: TLabel;
    Button1: TButton;
    Label5: TLabel;
    lbRL: TLabel;
    Label7: TLabel;
    lbRH: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation


{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  RichEdit1.Lines.LoadFromFile('c:\test.rtf');
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  WParam,LParam : longword;
  WinResult : integer;
begin
	WParam:=MakeWParam(edWL.value,edWH.value);
  LParam:=MakeLParam(edLL.value,edLH.value);
  WinResult :=sendMessage(RichEdit1.handle,EM_CharFromPos,
  	WParam,LParam );
  lbRL.caption := IntToStr(LoWord(WinResult));
  lbRH.caption := IntToStr(HiWord(WinResult));
end;

end.
