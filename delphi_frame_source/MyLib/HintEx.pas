unit HintEx;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms;

type
  THalfTransHintWindow = class(THintWindow)
  private
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
  protected
    procedure Paint; override;
  public
    procedure ActivateHint(Rect: TRect; const AHint: string); override;
  published

  end;

var
  HalfTransHint : boolean =true;
  TransHint : boolean =true;

function getHintFont : TFont;

implementation

uses DrawUtils;

var
  HintFont : TFont;

function getHintFont : TFont;
begin
  result := HintFont;
end;

{ THalfTransHintWindow }

procedure THalfTransHintWindow.ActivateHint(Rect: TRect;
  const AHint: string);
begin
  // make background to paint
  ShowWindow(handle,SW_HIDE);
  Application.ProcessMessages;
  inherited ActivateHint(Rect,AHint);
end;


procedure THalfTransHintWindow.Paint;
var
  R: TRect;
begin
  R := ClientRect;
  Inc(R.Left, 2);
  Inc(R.Top, 2);
  Canvas.Font := HintFont;
  DrawText(Canvas.Handle, PChar(Caption), -1, R, DT_LEFT or DT_NOPREFIX or
    DT_WORDBREAK or DrawTextBiDiModeFlagsReadingOnly);
end;

procedure THalfTransHintWindow.WMEraseBkgnd(var Message: TWmEraseBkgnd);
var
  Mem,Mask : TMemoryDC;
  OriDC : integer;
begin
  if (Message.DC<>0) and TransHint then
  begin
    try
      OriDC := SaveDC(Message.DC);
      Mem  := TMemoryDC.Create(width,height,Message.DC);
      Mask := CreateMaskDC(width,height);
      if HalfTransHint then
        TileDrawDC(Mask.DC,DefaultMaskBitmap.Canvas.Handle,width,Height,
          0,0,DefaultMaskBitmap.Width,DefaultMaskBitmap.Height)
      else
        with Mask.Canvas do
        begin
          brush.Color := clWhite;
          FillRect(ClientRect);
        end;

      Mem.Canvas.Brush.Assign(Brush);
      Mem.Canvas.FillRect(ClientRect);
      TransparentStretchBlt(Message.DC,0,0,width,Height,
        Mem.DC,0,0,width,Height,
        Mask.DC,0,0);
    finally
      RestoreDC(Message.DC,OriDC);
      Message.Result := 1;
      Mask.free;
      Mem.free;
    end;
  end
  else inherited ;
end;

initialization
   HintWindowClass := THalfTransHintWindow;
   HintFont := TFont.Create;
   HintFont.Color := clInfoText;

finalization
   HintFont.free;

end.
