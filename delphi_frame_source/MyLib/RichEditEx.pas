unit RichEditEx;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TRichEditEx = class(TRichEdit)
  private
    FTransparent: boolean;
    { Private declarations }
    //painting : boolean;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure SetTransparent(const Value: boolean);
   // procedure WMERASEBKGND(var msg:TWMERASEBKGND);message WM_ERASEBKGND;
  protected
    { Protected declarations }
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    {// for test
    TestCanvas : TCanvas;
    x1,y1,x2,y2 : integer;}
    // end test
    //ABrush : HBrush;
    constructor Create(AOwner:TComponent);override;
    destructor  Destroy; override;
  published
    { Published declarations }
    property Transparent : boolean read FTransparent write SetTransparent;
  end;

procedure Register;

implementation

uses BKGround,Drawutils;

procedure Register;
begin
  RegisterComponents('users', [TRichEditEx]);
end;

{ TRichEditEx }

constructor TRichEditEx.Create(AOwner: TComponent);
{var
  LogBrush : TLogBrush;}
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csOpaque];
  autoselect := false;
  {LogBrush.lbStyle := BS_NULL;
  ABrush := CreateBrushIndirect(LogBrush);}
end;

procedure TRichEditEx.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_TRANSPARENT;
  Params.Style := Params.Style and not WS_CLIPSIBLINGS ;
  Params.WindowClass.Style := Params.WindowClass.Style and not CS_SAVEBITS;
//  Params.WindowClass.hbrBackground:=ABrush;
end;

destructor TRichEditEx.Destroy;
begin
  //deleteObject(ABrush);
  inherited destroy;
end;

(*
procedure TRichEditEx.WMERASEBKGND(var msg: TWMERASEBKGND);
var
  OldBrush : HBrush;
begin
  msg.result := 1;
  if msg.DC<>0 then
  begin
    setBKMode(msg.DC,transparent);
    oldBrush := SelectObject(msg.DC,ABrush);
    if parent is TBackGround then
      (parent as TBackGround).PaintCtrlBkGround(self,msg.dc);
  end;
end;
*)

(* unsuccessful resolution 1 , used with WMERASEBKGND
  but setBKMode(msg.DC,transparent);
    oldBrush := SelectObject(msg.DC,ABrush);
  not work!
procedure TRichEditEx.WMPaint(var Message: TWMPaint);
var
  DC, MemDC,saveDC: HDC;
  MemBitmap, OldBitmap: HBITMAP;
  NoDC : boolean;
begin
  invalidateRect(handle,nil,true);
  //DC := GetDC(handle);
  {try
    if parent is TBackGround then
      (parent as TBackGround).PaintCtrlBkGround(self,dc);
  finally
    releaseDC(handle,DC);
  end;}
  defaultHandler(Message);
end;
*)

(* unsuccessful resolution 2
  cannot redirect painting to memDC
procedure TRichEditEx.WMPaint(var Message: TWMPaint);
var
  DC, MemDC,saveDC: HDC;
  MemBitmap, OldBitmap: HBITMAP;
  NoDC : boolean;
begin
  if painting then inherited
  else begin
  painting := true;
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
      //defaultHandler(Message);
      inherited;
      Message.DC := 0;

      if parent is TBackGround then
        (parent as TBackGround).PaintCtrlBkGround(self,dc)
      else BitBlt(DC,0,0,ClientRect.Right, ClientRect.Bottom,0,0,0,Whiteness);
      // for test
      //BitBlt(TestCanvas.handle,x1,y2,width,height,BGBitmap.Canvas.handle,0,0,SRCCOPY);
      BitBlt(TestCanvas.handle,x1,y1,width,height,DC,0,0,SRCCOPY);
      BitBlt(TestCanvas.handle,x2,y2,width,height,MemDC,0,0,SRCCOPY);
      // end test

      StretchBltTransparent(DC,0,0,width,height,MemDC,0,0,width,height,0,color);
      ValidateRect(handle,nil);
      if NoDC then //EndPaint(Handle, PS);
      releaseDC(handle,DC);
    finally
      SelectObject(MemDC, OldBitmap);
      DeleteDC(MemDC);
      DeleteObject(MemBitmap);
    end;
    painting := false;
  end;
end;
*)

{ The successful resolution
  1. call invalidaterect(handle,nil,false) to make it  update all client region
  2. call defaultHandler(Message) to paint itself to self DC
  3. create MemBitmap and MemDC
}

procedure TRichEditEx.SetTransparent(const Value: boolean);
begin
  if value<> FTransparent then
  begin
    FTransparent := Value;
    repaint;
  end;
end;

procedure TRichEditEx.WMPaint(var Message: TWMPaint);
var
  DC, MemDC: HDC;
  MemBitmap, OldBitmap: HBITMAP;
begin
  if Transparent then
  begin
	  MemBitmap :=0;
  	MemDC := 0;
	  OldBitmap :=0;
	  invalidaterect(handle,nil,false);
  	defaultHandler(Message);
	  DC := GetDC(handle);
	  try
		  MemBitmap := CreateCompatibleBitmap(DC, ClientRect.Right, ClientRect.Bottom);
    	MemDC := CreateCompatibleDC(0);
	    OldBitmap := SelectObject(MemDC, MemBitmap);
      // copy DC to MemDC
      BitBlt(MemDC,0,0,ClientRect.Right, ClientRect.Bottom,DC,0,0,SRCCOPY);
      // paint background to DC
      if parent is TBackGround then
        (parent as TBackGround).PaintCtrlBkGround(self,dc)
      else BitBlt(DC,0,0,ClientRect.Right, ClientRect.Bottom,0,0,0,Whiteness);
     { // for test
      //BitBlt(TestCanvas.handle,x1,y2,width,height,BGBitmap.Canvas.handle,0,0,SRCCOPY);
      BitBlt(TestCanvas.handle,x1,y1,width,height,DC,0,0,SRCCOPY);
      BitBlt(TestCanvas.handle,x2,y2,width,height,MemDC,0,0,SRCCOPY);
      // end test}

      StretchBltTransparent(DC,0,0,width,height,MemDC,0,0,width,height,0,color);
      ValidateRect(handle,nil);
	  finally
      releaseDC(handle,DC);
      SelectObject(MemDC, OldBitmap);
      DeleteDC(MemDC);
      DeleteObject(MemBitmap);
  	end;
  end
  else inherited;
end;


end.
