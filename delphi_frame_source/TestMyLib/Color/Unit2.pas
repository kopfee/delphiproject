unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, CompGroup;

type
  TForm1 = class(TForm)
    PaintBox1: TPaintBox;
    AppearanceProxy1: TAppearanceProxy;
    ColorDialog1: TColorDialog;
    Timer1: TTimer;
    procedure PaintBox1Paint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    H,S,B : integer;
    count : integer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses ColorUtils;

{$R *.DFM}

const
  steps = 5;

procedure TForm1.PaintBox1Paint(Sender: TObject);
var
  r1,g1,b1 : integer;
  acolor : TColor;
  s1 : integer;
begin
  with PaintBox1.Canvas do
  begin
    s1 := round(s*(steps-count/3*2)/steps);
    HSB2RGB(h,s1,b,r1,g1,b1);
    //outputDebugString(pchar(format('r:%d,g:%d,b:%d',[r1,g1,b1])));
    acolor := (b1 shl 16) or ( g1 shl 8) or r1;
    font.color := acolor;
    font.height := 20;
    TextOut(2,2,'test');
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  inc(count);
  if count>=steps then count:=0;
  PaintBox1Paint(Sender);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  H:=0;
  S:=100;
  B:=100;
end;

end.
