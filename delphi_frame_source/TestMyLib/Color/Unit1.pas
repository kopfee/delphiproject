unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    seHue: TSpinEdit;
    seR: TSpinEdit;
    seSat: TSpinEdit;
    seBri: TSpinEdit;
    seG: TSpinEdit;
    seB: TSpinEdit;
    btnHSB2RGB: TButton;
    btnRGB2HSB: TButton;
    procedure btnHSB2RGBClick(Sender: TObject);
    procedure btnRGB2HSBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses ColorUtils;

{$R *.DFM}

procedure TForm1.btnHSB2RGBClick(Sender: TObject);
var
  r,g,b : integer;
begin
  HSB2RGB(seHue.value,seSat.value,seBri.value,
    r,g,b);
  seR.value := r;
  seG.value := g;
  seB.value := b;
end;

procedure TForm1.btnRGB2HSBClick(Sender: TObject);
var
  h,s,b : integer;
begin
  RGB2HSB(seR.value,seG.value,seB.value,
    h,s,b);
  seHue.value:=h;
  seSat.value:=s;
  seBri.value:=b;
end;

end.
