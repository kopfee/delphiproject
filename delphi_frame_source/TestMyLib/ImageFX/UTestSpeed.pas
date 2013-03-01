unit UTestSpeed;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, CompGroup;

type
  TForm1 = class(TForm)
    Image1: TImage;
    PaintBox1: TPaintBox;
    btnStrech: TButton;
    btnNormal: TButton;
    Timer1: TTimer;
    btnIncreament: TButton;
    btnExclusive: TButton;
    apColor: TAppearanceProxy;
    ColorDialog1: TColorDialog;
    procedure btnStrechClick(Sender: TObject);
    procedure btnNormalClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnIncreamentClick(Sender: TObject);
    procedure btnExclusiveClick(Sender: TObject);
  private
    { Private declarations }
    procedure TestDraw;
  public
    { Public declarations }
    StretchDraw : boolean;
    Increament  : boolean;
    Index:integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnStrechClick(Sender: TObject);
begin
  StretchDraw := true;
  Increament  := false;
  TestDraw;
end;

procedure TForm1.btnNormalClick(Sender: TObject);
begin
  StretchDraw := false;
  Increament  := false;
  TestDraw;
end;

procedure TForm1.TestDraw;
begin
  Timer1.Enabled := true;
  Index := 1;
  with PaintBox1.Canvas do
  begin
    Brush.Color := apColor.Color;
    Brush.Style := bsSolid;
    FillRect(rect(0,0,PaintBox1.width,PaintBox1.Height));
  end;
end;

const
  count = 8;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  w : integer;
  gw,gh : integer;
  r : TRect;
begin
  gw:= Image1.Picture.Graphic.width;
  gh:= Image1.Picture.Graphic.Height;
  if Increament then
  begin
    r := rect(Round((Index-1) * gw /Count),0,Round(Index * gw /Count),gh);
    PaintBox1.Canvas.CopyRect(r,Image1.Picture.Bitmap.Canvas,r);
  end
  else
  begin
    w := Round(Index * gw /Count);
    r := rect(0,0,w,gh);
    if StretchDraw then
      PaintBox1.Canvas.CopyRect(r,Image1.Picture.Bitmap.Canvas,r)
    else
    begin
      SetStretchBltMode(PaintBox1.Canvas.handle,STRETCH_DELETESCANS);
      BitBlt(PaintBox1.Canvas.handle,0,0,w,gh,
           Image1.Picture.Bitmap.Canvas.handle,0,0,SRCCOPY);
    end;
  end;

  inc(index);
  if Index>count then Timer1.Enabled:=false;
end;

procedure TForm1.btnIncreamentClick(Sender: TObject);
begin
  Increament  := true;
  TestDraw;
end;

procedure TForm1.btnExclusiveClick(Sender: TObject);
var
  w : integer;
  gw,gh : integer;
  r : TRect;
  i : integer;
begin
  with PaintBox1.Canvas do
  begin
    Brush.Color := apColor.Color;//clBtnFace;
    Brush.Style := bsSolid;
    FillRect(rect(0,0,PaintBox1.width,PaintBox1.Height));
  end;
  gw:= Image1.Picture.Graphic.width;
  gh:= Image1.Picture.Graphic.Height;
  for i:=1 to count do
  begin
    r := rect(Round((I-1) * gw /Count),0,Round(I * gw /Count),gh);
    PaintBox1.Canvas.CopyRect(r,Image1.Picture.Bitmap.Canvas,r);
    Sleep(100);
  end;
end;

end.
