unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TEnum = (e1,e2,e3,e4);
  TEnums = set of TEnum;

  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Label1: TLabel;
    lbFlags: TLabel;
    Label3: TLabel;
    CheckBox4: TCheckBox;
    procedure OptSelect(Sender: TObject);
  private
    { Private declarations }
    E : TEnums;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses ExtUtils;

const
  conv : array[TEnum] of LongWord
   = (1,2,4,16);

procedure TForm1.OptSelect(Sender: TObject);
begin
  with sender as TCheckbox do
    if checked then include(e,TEnum(tag))
    else exclude(e,TEnum(tag));
  //lbFlags.caption := IntToStr(EnumsToFlags(LongWord(e),conv));
  lbFlags.caption := IntToStr(EnumsToFlags(e,conv));
end;

end.
