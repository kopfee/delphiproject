unit DrawUtils;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> DrawUtils
   <What> 画图工具
   <Written By> Huang YanLai
   <History>
**********************************************}

interface

uses Windows, Sysutils,Classes, Graphics, Forms, Controls, Dialogs;

const
{ TBitmap.GetTransparentColor from GRAPHICS.PAS use this value }
  PaletteMask = $02000000;

procedure DrawBitmapTransparent(Dest: TCanvas; DstX, DstY: Integer;
  Bitmap: TBitmap; TransparentColor: TColor);
procedure DrawBitmapRectTransparent(Dest: TCanvas; DstX, DstY: Integer;
  SrcRect: TRect; Bitmap: TBitmap; TransparentColor: TColor);
procedure StretchBitmapRectTransparent(Dest: TCanvas; DstX, DstY, DstW,
  DstH: Integer; SrcRect: TRect; Bitmap: TBitmap; TransparentColor: TColor);

procedure StretchBltTransparent(DstDC: HDC; DstX, DstY, DstW, DstH: Integer;
  SrcDC: HDC; SrcX, SrcY, SrcW, SrcH: Integer; Palette: HPalette;
  TransparentColor: TColorRef);
procedure DrawTransparentBitmap(DC: HDC; Bitmap: HBitmap;
  DstX, DstY: Integer; TransparentColor: TColorRef);

function PaletteColor(Color: TColor): Longint;

{
 Tile Draw Utilities
  Example in HuangYL\Tile\Project1.dpr (unit1)
}
// Add by HYL
// width, height is the width and height of Canvas
procedure TileDraw(Canvas : Tcanvas;
	Graphic : TGraphic;
  Width,Height : integer);

{ (x, y) , (x+width,y+height)
is the rect of background
that is consisted of some Tiled Graphic(s).
  Xoff,YOff is the top-left point of Canvas
in background.
}
procedure TileDrawEx(Canvas : Tcanvas;
	Graphic : TGraphic;
  X,Y : integer;
  Width,Height : integer;
  Xoff,YOff : integer);

procedure TileDrawDC(DstDC,	SRCDC : HDC;
  Width,Height,SX,SY,SW,SH : integer;
  Rop : integer=SRCCOPY);


procedure DrawLine(Canvas : TCanvas;
	x0,y0, // from
  x1,y1, // to
  dx,dy, // delta of x0/x1, y0/y1
  width : integer);

{
	The procedure will change pen.color
}
procedure DrawFrame(Canvas : TCanvas;const R : TRect;
	DrawLeft,DrawTop,DrawRight,DrawBottom : boolean;
  LineWidth : integer;
  LineColor,BackColor : TColor);

type
  EMemoryDCError = class(Exception);

  TMemoryDC = class
  private
    FBitmap: HBitmap;
    FDC: HDC;
    FHeight: integer;
    FWidth: integer;
    FSaveBmp : HBitmap;
    FCanvas : TCanvas;
    procedure   RaiseError;
    function    GetCanvas: TCanvas;
  public
    property    DC : HDC read FDC;
    property    Bitmap : HBitmap read FBitmap;
    property    Width : integer read FWidth;
    property    Height : integer read FHeight;
    property    Canvas : TCanvas read GetCanvas;
    constructor Create(AWidth,AHeight : integer;CompatibleDC:HDC); overload;
    constructor Create(AWidth,AHeight : integer;Planes,BitsPerPel:integer); overload;
    Destructor  Destroy;override;
    procedure   ReleaseCanvas;
  end;


procedure EllipseFrame(Canvas:TCanvas; ARect : TRect;
                    TopLeftColor,BottomRightColor : TColor;
                    BorderWidth : integer);

procedure RoundRectFrame(Canvas:TCanvas; ARect : TRect;
                    R : integer;
                    TopLeftColor,BottomRightColor : TColor;
                    BorderWidth : integer);

var
  DefaultMaskBitmap : TBitmap;

function  CreateMaskDC(AWidth,AHeight : integer) : TMemoryDC;

// 注意: Mask是黑白, TransparentColor in [clBlack,clWhite]
procedure SetHalfTransMask(Mask : TMemoryDC; TransparentColor : TColor);

implementation

{$R *.RES}

uses SafeCode;

procedure StretchBltTransparent(DstDC: HDC; DstX, DstY, DstW, DstH: Integer;
  SrcDC: HDC; SrcX, SrcY, SrcW, SrcH: Integer; Palette: HPalette;
  TransparentColor: TColorRef);
var
  Color: TColorRef;
  bmAndBack, bmAndObject, bmAndMem, bmSave: HBitmap;
  bmBackOld, bmObjectOld, bmMemOld, bmSaveOld: HBitmap;
  MemDC, BackDC, ObjectDC, SaveDC: HDC;
  palDst, palMem, palSave, palObj: HPalette;
begin
  { Create some DCs to hold temporary data }
  BackDC := CreateCompatibleDC(DstDC);
  ObjectDC := CreateCompatibleDC(DstDC);
  MemDC := CreateCompatibleDC(DstDC);
  SaveDC := CreateCompatibleDC(DstDC);
  { Create a bitmap for each DC }
  bmAndObject := CreateBitmap(SrcW, SrcH, 1, 1, nil);
  bmAndBack := CreateBitmap(SrcW, SrcH, 1, 1, nil);
  bmAndMem := CreateCompatibleBitmap(DstDC, DstW, DstH);
  bmSave := CreateCompatibleBitmap(DstDC, SrcW, SrcH);
  { Each DC must select a bitmap object to store pixel data }
  bmBackOld := SelectObject(BackDC, bmAndBack);
  bmObjectOld := SelectObject(ObjectDC, bmAndObject);
  bmMemOld := SelectObject(MemDC, bmAndMem);
  bmSaveOld := SelectObject(SaveDC, bmSave);
  { Select palette }
  palDst := 0; palMem := 0; palSave := 0; palObj := 0;
  if Palette <> 0 then begin
    palDst := SelectPalette(DstDC, Palette, True);
    RealizePalette(DstDC);
    palSave := SelectPalette(SaveDC, Palette, False);
    RealizePalette(SaveDC);
    palObj := SelectPalette(ObjectDC, Palette, False);
    RealizePalette(ObjectDC);
    palMem := SelectPalette(MemDC, Palette, True);
    RealizePalette(MemDC);
  end;
  { Set proper mapping mode }
  SetMapMode(SrcDC, GetMapMode(DstDC));
  SetMapMode(SaveDC, GetMapMode(DstDC));
  { Save the bitmap sent here }
  BitBlt(SaveDC, 0, 0, SrcW, SrcH, SrcDC, SrcX, SrcY, SRCCOPY);
  { Set the background color of the source DC to the color,         }
  { contained in the parts of the bitmap that should be transparent }
  Color := SetBkColor(SaveDC, PaletteColor(TransparentColor));
  { Create the object mask for the bitmap by performing a BitBlt()  }
  { from the source bitmap to a monochrome bitmap                   }
  BitBlt(ObjectDC, 0, 0, SrcW, SrcH, SaveDC, 0, 0, SRCCOPY);
  { Set the background color of the source DC back to the original  }
  SetBkColor(SaveDC, Color);
  { Create the inverse of the object mask }
  BitBlt(BackDC, 0, 0, SrcW, SrcH, ObjectDC, 0, 0, NOTSRCCOPY);
  { Copy the background of the main DC to the destination }
  BitBlt(MemDC, 0, 0, DstW, DstH, DstDC, DstX, DstY, SRCCOPY);
  { Mask out the places where the bitmap will be placed }
  StretchBlt(MemDC, 0, 0, DstW, DstH, ObjectDC, 0, 0, SrcW, SrcH, SRCAND);
  { Mask out the transparent colored pixels on the bitmap }
  BitBlt(SaveDC, 0, 0, SrcW, SrcH, BackDC, 0, 0, SRCAND);
  { XOR the bitmap with the background on the destination DC }
  StretchBlt(MemDC, 0, 0, DstW, DstH, SaveDC, 0, 0, SrcW, SrcH, SRCPAINT);
  { Copy the destination to the screen }
  BitBlt(DstDC, DstX, DstY, DstW, DstH, MemDC, 0, 0,
    SRCCOPY);
  { Restore palette }
  if Palette <> 0 then begin
    SelectPalette(MemDC, palMem, False);
    SelectPalette(ObjectDC, palObj, False);
    SelectPalette(SaveDC, palSave, False);
    SelectPalette(DstDC, palDst, True);
  end;
  { Delete the memory bitmaps }
  DeleteObject(SelectObject(BackDC, bmBackOld));
  DeleteObject(SelectObject(ObjectDC, bmObjectOld));
  DeleteObject(SelectObject(MemDC, bmMemOld));
  DeleteObject(SelectObject(SaveDC, bmSaveOld));
  { Delete the memory DCs }
  DeleteDC(MemDC);
  DeleteDC(BackDC);
  DeleteDC(ObjectDC);
  DeleteDC(SaveDC);
end;

procedure DrawTransparentBitmapRect(DC: HDC; Bitmap: HBitmap; DstX, DstY,
  DstW, DstH: Integer; SrcRect: TRect; TransparentColor: TColorRef);
var
  hdcTemp: HDC;
begin
  hdcTemp := CreateCompatibleDC(DC);
  try
    SelectObject(hdcTemp, Bitmap);
    with SrcRect do
      StretchBltTransparent(DC, DstX, DstY, DstW, DstH, hdcTemp,
        Left, Top, Right - Left, Bottom - Top, 0, TransparentColor);
  finally
    DeleteDC(hdcTemp);
  end;
end;

procedure DrawTransparentBitmap(DC: HDC; Bitmap: HBitmap;
  DstX, DstY: Integer; TransparentColor: TColorRef);
var
{$IFDEF WIN32}
  BM: Windows.TBitmap;
{$ELSE}
  BM: Wintypes.TBitmap;
{$ENDIF}
begin
  GetObject(Bitmap, SizeOf(TBitmap), @BM);
  DrawTransparentBitmapRect(DC, Bitmap, DstX, DstY, BM.bmWidth, BM.bmHeight,
    Rect(0, 0, BM.bmWidth, BM.bmHeight), TransparentColor);
end;

procedure StretchBitmapTransparent(Dest: TCanvas; Bitmap: TBitmap;
  TransparentColor: TColor; DstX, DstY, DstW, DstH, SrcX, SrcY,
  SrcW, SrcH: Integer);
var
  CanvasChanging: TNotifyEvent;
  Temp: TBitmap;
begin
  if DstW <= 0 then DstW := Bitmap.Width;
  if DstH <= 0 then DstH := Bitmap.Height;
  if (SrcW <= 0) or (SrcH <= 0) then begin
    SrcX := 0; SrcY := 0;
    SrcW := Bitmap.Width;
    SrcH := Bitmap.Height;
  end;
  if not Bitmap.Monochrome then
    SetStretchBltMode(Dest.Handle, STRETCH_DELETESCANS);
  CanvasChanging := Bitmap.Canvas.OnChanging;
  try
    Bitmap.Canvas.OnChanging := nil;
{$IFDEF RX_D3}
    {if Bitmap.HandleType = bmDIB then begin
      Temp := TBitmap.Create;
      Temp.Assign(Bitmap);
      Temp.HandleType := bmDDB;
    end
    else} Temp := Bitmap;
{$ELSE}
    Temp := Bitmap;
{$ENDIF}
    try
      if TransparentColor = clNone then begin
        StretchBlt(Dest.Handle, DstX, DstY, DstW, DstH, Temp.Canvas.Handle,
          SrcX, SrcY, SrcW, SrcH, Dest.CopyMode);
      end
      else begin
{$IFDEF RX_D3}
        if TransparentColor = clDefault then
          TransparentColor := Temp.Canvas.Pixels[0, Temp.Height - 1];
{$ENDIF}
        if Temp.Monochrome then TransparentColor := clWhite
        else TransparentColor := ColorToRGB(TransparentColor);
        StretchBltTransparent(Dest.Handle, DstX, DstY, DstW, DstH,
          Temp.Canvas.Handle, SrcX, SrcY, SrcW, SrcH, Temp.Palette,
          TransparentColor);
      end;
    finally
{$IFDEF RX_D3}
      {if Bitmap.HandleType = bmDIB then Temp.Free;}
{$ENDIF}
    end;
  finally
    Bitmap.Canvas.OnChanging := CanvasChanging;
  end;
end;

procedure StretchBitmapRectTransparent(Dest: TCanvas; DstX, DstY,
  DstW, DstH: Integer; SrcRect: TRect; Bitmap: TBitmap;
  TransparentColor: TColor);
begin
  with SrcRect do
    StretchBitmapTransparent(Dest, Bitmap, TransparentColor,
    DstX, DstY, DstW, DstH, Left, Top, Right - Left, Bottom - Top);
end;

procedure DrawBitmapRectTransparent(Dest: TCanvas; DstX, DstY: Integer;
  SrcRect: TRect; Bitmap: TBitmap; TransparentColor: TColor);
begin
  with SrcRect do
    StretchBitmapTransparent(Dest, Bitmap, TransparentColor,
    DstX, DstY, Right - Left, Bottom - Top, Left, Top, Right - Left,
    Bottom - Top);
end;

procedure DrawBitmapTransparent(Dest: TCanvas; DstX, DstY: Integer;
  Bitmap: TBitmap; TransparentColor: TColor);
begin
  StretchBitmapTransparent(Dest, Bitmap, TransparentColor, DstX, DstY,
    Bitmap.Width, Bitmap.Height, 0, 0, Bitmap.Width, Bitmap.Height);
end;

function PaletteColor(Color: TColor): Longint;
begin
  Result := ColorToRGB(Color) or PaletteMask;
end;

procedure TileDraw(Canvas : Tcanvas;
	Graphic : TGraphic;
  Width,Height : integer);
var
	i,j : integer;
  CountX,CountY : integer;
begin
  CountX := (Width - 1 ) div Graphic.width;
  CountY := (Height - 1) div Graphic.Height;
  for i:=0 to CountX do
    for j:=0 to CountY do
    begin
      Canvas.Draw(i * Graphic.width,j * Graphic.Height,Graphic);
    end;
end;

procedure TileDrawEx(Canvas : Tcanvas;
	Graphic : TGraphic;
  X,Y : integer;
  Width,Height : integer;
  Xoff,YOff : integer);
var
	i,j : integer;
  StartX,StartY : integer;
  EndX,EndY : integer;
begin
	StartX := x div Graphic.width;
  StartY := y div Graphic.Height;
	EndX := (x + Width - 1 ) div Graphic.width;
  EndY := (y + Height  - 1) div Graphic.Height;
  for i:=StartX to EndX do
    for j:=StartY to EndY do
      Canvas.Draw(i * Graphic.width - Xoff,
        j * Graphic.Height-YOff,
        Graphic);
end;

procedure TileDrawDC(DstDC,	SRCDC : HDC;
  Width,Height,SX,SY,SW,SH : integer;
  Rop : integer=SRCCOPY);
var
	i,j : integer;
  CountX,CountY : integer;
begin
  CountX := (Width - 1 ) div SW;
  CountY := (Height - 1) div SH;
  for i:=0 to CountX do
    for j:=0 to CountY do
      BitBlt(DstDC,i * SW,j * SH,SW,SH,SRCDC,SX,SY,ROP);
end;

procedure DrawLine(Canvas : TCanvas;
	x0,y0, // from
  x1,y1, // to
  dx,dy, // delta of x0/x1, y0/y1
  width : integer);
var
	OldPenWidth : integer;
  i : integer;
begin
  with canvas do
  begin
    OldPenWidth := pen.Width;
    pen.Width := 1;
    for i:=1 to width do
    begin
      MoveTo(x0,y0);
      LineTo(x1,y1);
      inc(x0,dx);
      inc(x1,dx);
      inc(y0,dy);
      inc(y1,dy);
    end;
    pen.Width := OldPenWidth;
  end;
end;

procedure DrawFrame(Canvas : TCanvas;const R : TRect;
	DrawLeft,DrawTop,DrawRight,DrawBottom : boolean;
  LineWidth : integer;
  LineColor,BackColor : TColor);

  procedure SetPenColor(DrawTheLine : boolean);
  begin
    if DrawTheLine then
	    Canvas.pen.color := LineColor
    else
			Canvas.pen.color := BackColor;
  end;

begin
  with R do
  begin
		SetPenColor(DrawLeft);
	  DrawLine(canvas,
    	left,top,
      left,bottom,
      1,0,
      linewidth);
    SetPenColor(DrawRight);
		DrawLine(canvas,
    	right-1,top,
      right-1,bottom,
      -1,0,
      linewidth);
    SetPenColor(DrawTop);
	  DrawLine(canvas,
    	left,top,
      right,top,
      0,1,
      linewidth);
    SetPenColor(DrawBottom);
	  DrawLine(canvas,
    	left,bottom-1,
      right,bottom-1,
      0,-1,
      LineWidth);
  end;
end;

{ TMemoryDC }

constructor TMemoryDC.Create(AWidth, AHeight: integer;CompatibleDC:HDC);
begin
  FCanvas := nil;
  FDC:=0;
  FBitmap:=0;
  CheckTrue((AWidth>0) and (AHeight>0),'Error : Width or Height <0');
  FWidth := AWidth;
  FHeight := AHeight;
  FDC := CreateCompatibleDC(0);
  if FDC=0 then RaiseError;
  FBitmap := CreateCompatibleBitmap(CompatibleDC, width, Height);
  if FBitmap=0 then
  begin
    DeleteDC(DC);
    FDC:=0;
    RaiseError;
  end;
  FSaveBmp := SelectObject(DC, Bitmap);
end;

constructor TMemoryDC.Create(AWidth, AHeight, Planes, BitsPerPel: integer);
begin
  FCanvas := nil;
  FDC:=0;
  FBitmap:=0;
  CheckTrue((AWidth>0) and (AHeight>0),'Error : Width or Height <0');
  FWidth := AWidth;
  FHeight := AHeight;
  FDC := CreateCompatibleDC(0);
  if FDC=0 then RaiseError;
  FBitmap := CreateBitmap(width, Height,Planes, BitsPerPel,nil);
  if FBitmap=0 then
  begin
    DeleteDC(DC);
    FDC:=0;
    RaiseError;
  end;
  FSaveBmp := SelectObject(DC, Bitmap);
end;

destructor TMemoryDC.Destroy;
begin
  ReleaseCanvas;
  if (FBitmap<>0) and (FSaveBmp<>0) and (FDC<>0) then
    SelectObject(FDC, FSaveBmp);
  if (FBitmap<>0) then DeleteObject(FBitmap);
  if DC<>0 then DeleteDC(DC);
  inherited Destroy;
end;

function TMemoryDC.GetCanvas: TCanvas;
begin
  if FCanvas=nil then
    FCanvas := TCanvas.Create;

  FCanvas.Handle := DC;
  result := FCanvas;
end;

procedure TMemoryDC.ReleaseCanvas;
begin
  if FCanvas<>nil then
  begin
    FCanvas.Handle := 0;
    FCanvas.free;
    FCanvas:=nil;
  end;
end;

procedure TMemoryDC.RaiseError;
begin
  raise EMemoryDCError.Create('Memory DC Error!');
end;


procedure EllipseFrame(Canvas:TCanvas; ARect : TRect;
                    TopLeftColor,BottomRightColor : TColor;
                    BorderWidth : integer);
var
  i : integer;
  XMid{,YMid} : integer;
  X1,X2 : integer;
begin
  with Canvas,ARect do
  begin
    //inc(left);
    //inc(Top);
    dec(right);
    dec(bottom);

    XMid:=(left+right)div 2;
    //YMid:=(top+Bottom)div 2;
    Pen.Style := psSolid;
    Pen.width := 1;
    // draw frame
    for i:=0 to BorderWidth-1 do
    begin
      {// 1象限
      Pen.Color := MiddleColor;
      Canvas.Arc(left,top,right,bottom,Right,YMid,XMid,Top);
      // 2象限
      Pen.Color := TopLeftColor;
      Canvas.Arc(left,top,right,bottom,XMid,Top,left,YMid);
      // 3象限
      Pen.Color := MiddleColor;
      Canvas.Arc(left,top,right,bottom,left,YMid,XMid,Bottom);
      // 4象限
      Pen.Color := BottomRightColor;
      Canvas.Arc(left,top,right,bottom,XMid,Bottom,Right,YMid);}

      X1:=XMid+(i+1)*(Right-XMid) div BorderWidth div 2;
      X2:=left+i*(XMid-left) div BorderWidth div 2;
      Pen.Color := TopLeftColor;
      Canvas.Arc(left,top,right,bottom,
        x1,Top,x2,Bottom);
      Pen.Color := BottomRightColor;
      Canvas.Arc(left,top,right,bottom,
        x2,Bottom,x1,Top);
      inc(left);
      dec(right);
      inc(top);
      dec(bottom);
    end;
  end;
end;

procedure RoundRectFrame(Canvas:TCanvas; ARect : TRect;
                    R : integer;
                    TopLeftColor,BottomRightColor : TColor;
                    BorderWidth : integer);
var
  i : integer;
begin
  with Canvas,ARect do
  begin
    //inc(left);
    //inc(Top);
    dec(right);
    dec(bottom);

    Pen.Style := psSolid;
    Pen.width := 1;
    // draw frame
    for i:=1 to BorderWidth do
    begin
      // Top
      Pen.Color := TopLeftColor;
      Canvas.MoveTo(left+R,Top);
      Canvas.LineTo(Right-R+1,Top);
      // left
      Canvas.MoveTo(left,Top+R);
      Canvas.LineTo(left,Bottom-R+1);
      // Bottom
      Pen.Color := BottomRightColor;
      Canvas.MoveTo(left+R,Bottom);
      Canvas.LineTo(Right-R+1,Bottom);
      // Right
      Canvas.MoveTo(Right,Top+R);
      Canvas.LineTo(Right,Bottom-R+1);

      //if (i mod 2)<>0 then
      begin
      // Left-top Corner
      Pen.Color := TopLeftColor;
      Canvas.Arc(left,top,left+2*R,Top+2*R,left+R,Top,left,Top+R);
      // right-top
      Canvas.Arc(Right-2*R,top,Right,Top+2*R,Right,Top,Right-R,Top);
      // left-bottom
      Canvas.Arc(left,bottom-2*R,left+2*R,Bottom,left,Bottom-R,left,Bottom);

      // other Corner
      Pen.Color := BottomRightColor;
      // right-top
      Canvas.Arc(Right-2*R,top,Right,Top+2*R,Right,Top+R,Right,Top);
      // left-bottom
      Canvas.Arc(left,bottom-2*R,left+2*R,Bottom,left,Bottom,left+R,Bottom);
      // right-Bottom
      Canvas.Arc(right-2*R,bottom-2*R,Right,Bottom,Right-R,Bottom,Right,Bottom-R);
      end;
      inc(left);
      dec(right);
      inc(top);
      dec(bottom);
      dec(R);
    end;
  end;
end;

function  CreateMaskDC(AWidth,AHeight : integer) : TMemoryDC;
begin
  result := TMemoryDC.Create(AWidth,AHeight,1,1);
end;

// 注意: Mask是黑白, TransparentColor in [clBlack,clWhite]
procedure SetHalfTransMask(Mask : TMemoryDC; TransparentColor : TColor);
begin
  checkTrue((TransparentColor=clWhite)or(TransparentColor=clBlack),'Error : TransparentColor');
  if TransparentColor=clWhite then
    TileDrawDC(Mask.DC,DefaultMaskBitmap.Canvas.handle,
        Mask.width,Mask.height,
        0,0,DefaultMaskBitmap.width,DefaultMaskbitmap.Height,
        SRCPAINT)
  else
  begin
    TileDrawDC(Mask.DC,DefaultMaskBitmap.Canvas.handle,
        Mask.width,Mask.height,
        0,0,DefaultMaskBitmap.width,DefaultMaskbitmap.Height,
        SRCAND);
    BitBlt(Mask.DC,0,0,Mask.width,Mask.height,0,0,0,DSTINVERT);
  end;

end;

initialization
  DefaultMaskBitmap := TBitmap.Create;
  DefaultMaskBitmap.LoadFromResourceName(hInstance,'DEFAULTMASK');

finalization
  DefaultMaskBitmap.free;
end.
