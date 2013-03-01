unit ColorUtils;
{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> ColorUtils
   <What> 有关颜色的处理和转换
   <Written By> Huang YanLai
   <History>
**********************************************}

interface

// hue : 0~360, saturation : 0~1, brightness : 0~1
procedure RGB2HSB(r,g,b : integer;var hue, saturation, brightness : single); overload;

// hue : 0~360, saturation : 0~100, brightness : 0~100
procedure RGB2HSB(r,g,b : integer;var hue, saturation, brightness : integer); overload;

// hue : 0~360, saturation : 0~1, brightness : 0~1
procedure HSB2RGB(hue, saturation, brightness : single; var r,g,b : integer); overload;

// hue : 0~360, saturation : 0~100, brightness : 0~100
procedure HSB2RGB(hue, saturation, brightness : integer; var r,g,b : integer); overload;

// get a color from a color table that contain 72 colors
// index : 0 .. 71
function getColorFromReserved(index : integer): integer;

implementation

uses Math;

// hue : 0~360, saturation : 0~1, brightness : 0~1
procedure RGB2HSB(r,g,b : integer;var hue, saturation, brightness : single);
var
  cmax,cmin : integer;
  redc,greenc,bluec : single;
begin
  if (r > g) then cmax := r else cmax := g;
	if (b > cmax) then cmax := b;
  if (r < g) then cmin := r else cmin := g;
  if (b < cmin) then cmin := b;
 	brightness := (cmax) / 255;
  if (cmax <> 0) then 
    saturation := (cmax - cmin)/ cmax else
    saturation := 0;
  if (saturation = 0) then
    hue := 0 else
    begin
      redc := (cmax - r) / (cmax - cmin);
	    greenc := (cmax - g) / (cmax - cmin);
	    bluec :=  (cmax - b) / (cmax - cmin);
	    if (r = cmax) then
        hue := bluec - greenc else
        if (g = cmax) then
	        hue := 2.0 + redc - bluec else
		      hue := 4.0 + greenc - redc;
	    hue := hue / 6.0;
	    if (hue < 0) then
		    hue := hue + 1.0;
      hue := hue * 360;
    end;
end;

// hue : 0~360, saturation : 0~100, brightness : 0~100
procedure RGB2HSB(r,g,b : integer;var hue, saturation, brightness : integer);
var
  h1,s1,b1 : single;
begin
  RGB2HSB(r,g,b,h1, s1, b1);
  hue:=trunc(h1);
  saturation:=trunc(s1*100);
  brightness:=trunc(b1*100);
end;

// hue : 0~360, saturation : 0~1, brightness : 0~1
procedure HSB2RGB(hue, saturation, brightness : single; var r,g,b : integer);
var
  h,f,p,q,t : double;
  h1 : integer;
begin
  hue := hue / 360;
  r:=0;  g:=r; b := r;
  if (saturation=0) then
  begin
    r:=round(255*brightness);  g:=r; b := r;
  end else
  begin
    h := (hue - floor(hue)) * 6.0;
    h1 := trunc(h);
    f := h - floor(h);
    p := brightness * (1.0 - saturation);
    q := brightness * (1.0 - saturation * f);
    t := brightness * (1.0 - (saturation * (1.0 - f)));
    case (h1) of
      0 : begin
            r := trunc(brightness * 255);
		        g := trunc(t * 255);
		        b := trunc(p * 255);
          end;
      1 : begin
            r := trunc (q * 255);
		        g := trunc (brightness * 255);
		        b := trunc (p * 255);
          end;
      2 : begin
            r := trunc (p * 255);
		        g := trunc (brightness * 255);
		        b := trunc (t * 255);
          end;
      3 : begin
            r := trunc (p * 255);
		        g := trunc (q * 255);
		        b := trunc (brightness * 255);
          end;
      4 : begin
            r := trunc (t * 255);
		        g := trunc (p * 255);
		        b := trunc (brightness * 255);
          end;
      5 : begin
            r := trunc (brightness * 255);
		        g := trunc (p * 255);
		        b := trunc (q * 255);
          end;
    end;
  end;
end;

// hue : 0~360, saturation : 0~100, brightness : 0~100
procedure HSB2RGB(hue, saturation, brightness : integer; var r,g,b : integer);
var
  h1,s1,b1 : single;
begin
  h1:=hue;
  s1:=saturation/100;
  b1:=brightness/100;
  HSB2RGB(h1, s1, b1,r,g,b);
end;

function getColorFromReserved(index : integer): integer;
var
  sat,bri,hue : integer;
  h : integer;
  r,g,b : integer;
begin
  index := index mod 72;
  h := (index mod 12);
  hue := (h div 3);
  case hue of
    0 : hue := 0;
    1 : hue := 60;
    2 : hue := 30;
    3 : hue := 90;
  end;
  hue := hue + (h mod 3)*120;
  if index< 36 then
    sat:=100 else
    sat:=20;

  h := index mod 36;
  if h>=24 then
    bri:=40 else
    if h>=12 then
      bri:=70 else
      bri:=100;
  if hue=120 then bri:=100-bri+40;    
  HSB2RGB(hue,sat,bri,r,g,b);
  result := (b shl 16) or ( g shl 8) or r;
end;

end.
