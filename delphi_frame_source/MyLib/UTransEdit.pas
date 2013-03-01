unit UTransEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TTransparentMemo = class(TMemo)
  private
    { Private declarations }
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  protected
    { Protected declarations }
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    BGBitmap : TBitmap;
    BGX,BGY,BGW,BGH : integer;
    // for test
    TestCanvas : TCanvas;
    x1,y1,x2,y2 : integer;
    // end test
    ABrush : HBrush;
    constructor Create(AOwner:TComponent);override;
    destructor  Destroy; override;
    procedure   PaintBackGround(DC : HDC);
  published
    { Published declarations }
  end;

procedure Register;

implementation

uses myUtils;

procedure Register;
begin
  RegisterComponents('users', [TTransparentMemo]);
end;

{ TTransparentEdit }

constructor TTransparentMemo.Create(AOwner: TComponent);
var
  LogBrush : TLogBrush;
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csOpaque];
  autoselect := false;
  LogBrush.lbStyle := BS_NULL;
  ABrush := CreateBrushIndirect(LogBrush);
end;

procedure TTransparentMemo.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_TRANSPARENT;
  Params.Style := Params.Style and not WS_CLIPSIBLINGS;
  Params.WindowClass.hbrBackground:=ABrush;
end;


destructor TTransparentMemo.Destroy;
begin
  deleteObject(ABrush);
  inherited destroy;
end;

procedure TTransparentMemo.PaintBackGround(DC: HDC);
var
  oldPalette : HPalette;
begin
  try
    oldPalette:=SelectPalette(DC,BGBitmap.Palette,true);
    RealizePalette(DC);
    //copy Background bitmap to DC
    StretchBlt(DC,0,0,ClientRect.Right, ClientRect.Bottom,
    BGBitmap.Canvas.handle,BGX,BGY,BGW,BGH,SRCCOPY);
  finally
    SelectPalette(DC,OldPalette,false);
  end;
end;


(*
procedure TTransparentMemo.WMPaint(var Message: TWMPaint);
var
  DC, MemDC,saveDC: HDC;
  MemBitmap, OldBitmap: HBITMAP;
  NoDC : boolean;
begin
    NoDC := Message.DC=0;
    SaveDC := Message.DC;
    DC := GetDC(0);
    MemBitmap := CreateCompatibleBitmap(DC, ClientRect.Right, ClientRect.Bottom);
    ReleaseDC(0, DC);
    if NoDC then //DC := BeginPaint(Handle, PS)
      DC := GetDC(handle)
      else DC:=SaveDC;
    MemDC := CreateCompatibleDC(0);
    OldBitmap := SelectObject(MemDC, MemBitmap);
    try
      // paint to MemDC
      BitBlt(MemDC,0,0,ClientRect.Right, ClientRect.Bottom,0,0,0,Whiteness);
      Message.DC := MemDC;
      defaultHandler(Message);
      Message.DC := 0;

      PaintBackGround(DC);
     { // for test
      BitBlt(TestCanvas.handle,x1,y2,width,height,BGBitmap.Canvas.handle,0,0,SRCCOPY);
      BitBlt(TestCanvas.handle,x1,y1,width,height,DC,0,0,SRCCOPY);
      BitBlt(TestCanvas.handle,x2,y2,width,height,MemDC,0,0,SRCCOPY);
      // end test
     }
      StretchBltTransparent(DC,0,0,width,height,MemDC,0,0,width,height,0,color);
      ValidateRect(handle,nil);
      if NoDC then //EndPaint(Handle, PS);
      releaseDC(handle,DC);
    finally
      SelectObject(MemDC, OldBitmap);
      DeleteDC(MemDC);
      DeleteObject(MemBitmap);
    end;
end;
*)

(*
procedure TTransparentMemo.WMPaint(var Message: TWMPaint);
var
  DC, MemDC,saveDC: HDC;
  MemBitmap, OldBitmap: HBITMAP;
  NoDC : boolean;
  OldBrush : HBrush;
begin
  inherited;
{    NoDC := Message.DC=0;
    SaveDC := Message.DC;
    if NoDC then //DC := BeginPaint(Handle, PS)
      DC := GetDC(handle)
      else DC:=SaveDC;
    try
      PaintBackGround(DC);
      setBKMode(DC,transparent);
      oldBrush := SelectObject(DC,ABrush);
      Message.DC := DC;
      defaultHandler(Message);
      Message.DC := 0;

      ValidateRect(handle,nil);
      if NoDC then //EndPaint(Handle, PS);
    finally
      SelectObject(DC,OldBrush);
      releaseDC(handle,DC);
    end;}
end;
*)


end.
