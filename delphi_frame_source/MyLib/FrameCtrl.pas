unit FrameCtrl;
{ 1. In CreateParams, add WS_EX_TRANSPARENT style.
Bug : when moving, the inner contents will not update automitically.
  2. In Create , remove csOpaque;
Bug :
  1) when moving, the inner contents will not update automitically.
  2) set color will fill inner contents
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

const
  defaultLineWidth = 1;
type
  TFrameControl = class(TCustomControl)
  private
    { Private declarations }
    FLineWidth: integer;
    FLineColor: TColor;
    FTransparent: boolean;
    procedure SetLineWidth(const Value: integer);
    procedure SetLineColor(const Value: TColor);
    procedure SetTransparent(const Value: boolean);
    procedure WMERASEBKGND(var message : TWMERASEBKGND);message WM_ERASEBKGND;
    //procedure WMMove(var message : TWMMove);message WM_Move;
  protected
    { Protected declarations }
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
  published
    { Published declarations }
    property  LineWidth : integer
      read FLineWidth write SetLineWidth default defaultLineWidth;
    property  LineColor : TColor
      read FLineColor write SetLineColor default clBlack;
    property  Transparent: boolean
      read FTransparent write SetTransparent default true;
    property  Color;
  end;

procedure Register;

implementation

uses ExtUtils;

procedure Register;
begin
  RegisterComponents('users', [TFrameControl]);
end;

{ TFrameControl }

constructor TFrameControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLineWidth := defaultLineWidth;
  FLineColor := clBlack;
  FTransparent := true;
  height := 50;
  width := 50;

  //2
  controlStyle := controlStyle - [csOpaque];
end;

procedure TFrameControl.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WindowClass.style :=
   (Params.WindowClass.style
   or CS_HREDRAW or CS_VREDRAW or CS_PARENTDC)
   and not CS_SAVEBITS;
  Params.ExStyle := (Params.ExStyle
    or WS_EX_TRANSPARENT) ;
  Params.Style := Params.Style
    and not WS_CLIPSIBLINGS
    and not WS_OVERLAPPED;
end;

procedure TFrameControl.Paint;
begin
  {$ifdef debug}
  OutputDebugString(pchar('Paint,transparent:'+BoolToStr(FTransparent)));
  {$endif}
  with Canvas do
  begin
    pen.Width := FLineWidth;
    pen.Color := FLineColor;
    pen.mode := pmNot	;//pmXor;
    Brush.Color := Color;
    if FTransparent then
      Brush.Style := bsClear
    else
      Brush.Style := bsSolid;
    //Brush.Style := bsClear; // for debug
    Rectangle(0,0,width,height);
  end;
end;

procedure TFrameControl.SetLineColor(const Value: TColor);
begin
  if FLineColor <> Value then
  begin
    FLineColor := Value;
    Repaint;
  end;
end;

procedure TFrameControl.SetLineWidth(const Value: integer);
begin
  if (FLineWidth<>Value) and (value>0) then
  begin
    FLineWidth := Value;
    Repaint;
  end;
end;

procedure TFrameControl.SetTransparent(const Value: boolean);
begin
  if FTransparent <> Value then
  begin
    FTransparent := Value;
    if FTransparent then
      controlStyle := controlStyle - [csOpaque]
    else
      controlStyle := controlStyle + [csOpaque];
    Repaint;
  end;
end;

procedure TFrameControl.WMERASEBKGND(var message: TWMERASEBKGND);
begin
  message.result := 1;
end;
{
procedure TFrameControl.WMMove(var message: TWMMove);
begin
  inherited;
  Invalidate;
end;
}
end.
