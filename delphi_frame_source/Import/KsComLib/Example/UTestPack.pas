unit UTestPack;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Button1: TButton;
    Label5: TLabel;
    lbSize1: TLabel;
    lbSize2: TLabel;
    Label6: TLabel;
    edMsg1: TEdit;
    Label7: TLabel;
    edMsg2: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses KCDataPack;

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  ParamBits : TSTParamBits;
  Data : TSTPack;
  Buffer : Array[0..MAXPACKAGESIZE-1] of Char;
begin
  KCCheckDefine;
  
  KCClearParamBits(ParamBits);
  ParamBits[0] := ParamBits[0] or 1;
  ParamBits[0] := ParamBits[0] or 32;
  ParamBits[2] := ParamBits[2] or 4;
  ParamBits[4] := ParamBits[4] or 1;

  if Edit1.Text<>'' then
    KCPutStr(Data.gddm,16,Edit1.Text);
  if Edit2.Text<>'' then
    KCPutStr(Data.gdxm,21,Edit2.Text);
  if Edit3.Text<>'' then
    Data.yybid := StrToInt(Edit3.Text);
  if Edit4.Text<>'' then
    Data.dqje := StrToFloat(Edit4.Text);
  lbSize1.Caption := IntToStr(KCPackData(ParamBits,Data,@Buffer));

  FillChar(Data,SizeOf(Data),0);

  lbSize2.Caption := IntToStr(KCUnPackData(ParamBits,Data,@Buffer));
  Edit5.Text := KCGetStr(Data.gddm,16);
  Edit6.Text := KCGetStr(Data.gdxm,21);
  Edit7.Text := IntToStr(Data.yybid);
  Edit8.Text := FloatToStr(Data.dqje);
end;

end.
