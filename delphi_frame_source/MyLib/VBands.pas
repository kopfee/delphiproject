unit VBands;

// %VBands : 表格形式的外观

(*****   Code Written By Huang YanLai   *****)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;
type
	TVCustomBand = class;

  TVFrame = class(TPersistent)
  private
    FDrawLeft: boolean;
    FDrawTop: boolean;
    FDrawBottom: boolean;
    FDrawRight: boolean;
    FLineWidth: integer;
    FColor: TColor;
    FBand: TVCustomBand;
    procedure SetColor(const Value: TColor);
    procedure SetDrawBottom(const Value: boolean);
    procedure SetDrawLeft(const Value: boolean);
    procedure SetDrawRight(const Value: boolean);
    procedure SetDrawTop(const Value: boolean);
    procedure SetLineWidth(const Value: integer);
  protected
    property 	Band: TVCustomBand read FBand;
    procedure PropChanged;
    procedure SetBoolProp(var Prop : Boolean; value : boolean);
    //procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(Band : TVCustomBand);
    procedure 	Assign(Source: TPersistent); override;
  published
    property DrawLeft : boolean read FDrawLeft write SetDrawLeft default false;
    property DrawTop : boolean read FDrawTop write SetDrawTop default false;
    property DrawRight : boolean read FDrawRight write SetDrawRight default false;
    property DrawBottom : boolean read FDrawBottom write SetDrawBottom default false;
    property Color : TColor read FColor write SetColor default clBlack;
    property LineWidth : integer read FLineWidth write SetLineWidth default 1;
  end;

  TVCustomBand = class(TCustomControl)
  private
    { Private declarations }
    FFrame: TVFrame;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
    procedure DrawFrame(R : TRect);
    procedure DrawNC;
    procedure SetFrame(const Value: TVFrame);
  protected
    { Protected declarations }
    property 	Frame : TVFrame read FFrame write SetFrame;
    procedure Paint; override;
    procedure BorderChanged;
    procedure SetParent(AParent: TWinControl); override;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor 	destroy; override;
  published
    { Published declarations }
  end;

  TVBand = class(TVCustomBand)
  private

  protected

  public

  published
    property Frame;
    property Align;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property Color;
    property Font;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ParentBiDiMode;
    property ParentCtl3D;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;


  TVMainBand = class(TVBand)
  public
    constructor Create(AOwner : TComponent); override;
  end;

  TVRowBand = class(TVBand)
  public
    constructor Create(AOwner : TComponent); override;
  end;

  TVColBand = class(TVBand)
  public
    constructor Create(AOwner : TComponent); override;
  end;


implementation

uses DrawUtils;


{ TVFrame }

procedure TVFrame.Assign(Source: TPersistent);
begin
  if Source is TVFrame then
  with Source as TVFrame do
  begin
    self.FDrawLeft:=FDrawLeft;
	  self.FDrawTop:=FDrawTop;
  	self.FDrawBottom:=FDrawBottom;
	  self.FDrawRight:=FDrawRight;
  	self.FLineWidth:=FLineWidth;
	  self.FColor:=FColor;
    if self.FBand<>nil then
      self.FBand.BorderChanged;
  end
  else inherited Assign(Source);
end;

{
procedure TVFrame.AssignTo(Dest: TPersistent);
begin
  if Dest is TVFrame then
  with Dest as TVFrame do
  begin
    FDrawLeft:=self.FDrawLeft;
	  FDrawTop:=self.FDrawTop;
  	FDrawBottom:=self.FDrawBottom;
	  FDrawRight:=self.FDrawRight;
  	FLineWidth:=self.FLineWidth;
	  FColor:=self.FColor;
    if self.FBand<>nil then
      self.FBand.BorderChanged;
  end
  else inherited AssignTo(Dest);
end;
}
constructor TVFrame.Create(Band: TVCustomBand);
begin
  inherited Create;
  FBand := Band;
  FDrawLeft:=false;
  FDrawTop:=false;
  FDrawBottom:=false;
  FDrawRight:=false;
  FLineWidth:=1;
  FColor:=clBlack;
end;

procedure TVFrame.PropChanged;
begin
  if FBand<>nil then
  	//FBand.Invalidate;
    FBand.DrawNC;
end;

procedure TVFrame.SetBoolProp(var Prop: Boolean; value: boolean);
begin
  if Prop<>value then
  begin
    Prop := value;
    PropChanged;
  end;
end;

procedure TVFrame.SetColor(const Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
		PropChanged;
  end;
end;

procedure TVFrame.SetDrawBottom(const Value: boolean);
begin
  SetBoolProp(FDrawBottom,Value);
end;

procedure TVFrame.SetDrawLeft(const Value: boolean);
begin
  SetBoolProp(FDrawLeft,Value);
end;

procedure TVFrame.SetDrawRight(const Value: boolean);
begin
  SetBoolProp(FDrawRight,Value);
end;

procedure TVFrame.SetDrawTop(const Value: boolean);
begin
  SetBoolProp(FDrawTop,Value);
end;

procedure TVFrame.SetLineWidth(const Value: integer);
begin
  if  FLineWidth <> Value then
  begin
		FLineWidth := Value;
    //PropChanged;
    Band.BorderChanged;
  end;
end;

{ TVCustomBand }

procedure TVCustomBand.BorderChanged;
begin
  if parent<>nil then
	  BorderWidth := Frame.LineWidth;
end;

constructor TVCustomBand.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFrame := TVFrame.Create(self);
  ControlStyle := ControlStyle + [csAcceptsControls];
  Width := 100;
  Height := 100;
  //BorderWidth := FFrame.lineWidth;
  //BorderWidth := 1;
end;

destructor TVCustomBand.destroy;
begin
	FFrame.free;
  inherited destroy;
end;

procedure TVCustomBand.DrawFrame(R : Trect);
begin
	//Canvas.pen.color := Frame.Color;
  Canvas.pen.Style := psSolid;
  {with R do begin
	  if Frame.DrawLeft then
  	  Canvas.pen.color := Frame.Color
	  else
  	  Canvas.pen.color := Color;
	  DrawLine(canvas,
    	left,top,
      left,bottom,
      1,0,
      Frame.linewidth);
	  if Frame.DrawRight then
			Canvas.pen.color := Frame.Color
	  else
  	  Canvas.pen.color := Color;
		DrawLine(canvas,
    	right-1,top,
      right-1,bottom,
      -1,0,
      Frame.linewidth);
	  if Frame.DrawTop then
    	Canvas.pen.color := Frame.Color
	  else
  	  Canvas.pen.color := Color;
	  DrawLine(canvas,
    	left,top,
      right,top,
      0,1,
      Frame.linewidth);
	  if Frame.DrawBottom then
	    Canvas.pen.color := Frame.Color
	  else
  	  Canvas.pen.color := Color;
	  DrawLine(canvas,
    	left,bottom-1,
      right,bottom-1,
      0,-1,
      Frame.LineWidth);
  end;}
  with Frame do
	  DrawUtils.DrawFrame(Canvas,R,
    	DrawLeft,DrawTop,DrawRight,DrawBottom,
		  LineWidth,
  		Color,Self.Color);
end;

procedure TVCustomBand.DrawNC;
var
	DC : HDC;
  RC, RW, SaveRW: TRect;
begin
  { Get window DC that is clipped to the non-client area }
  if (BorderWidth > 0) then
  begin
    DC := GetWindowDC(Handle);
    try
      Windows.GetClientRect(Handle, RC);
      GetWindowRect(Handle, RW);
      MapWindowPoints(0, Handle, RW, 2);
      OffsetRect(RC, -RW.Left, -RW.Top);
      ExcludeClipRect(DC, RC.Left, RC.Top, RC.Right, RC.Bottom);
      { Draw borders in non-client area }
      SaveRW := RW;
      InflateRect(RC, BorderWidth, BorderWidth);
      RW := RC;
      try
        Canvas.Handle := DC;
        // draw frame
        DrawFrame(RW);
      finally
				Canvas.Handle := 0;
      end;
      (*
      IntersectClipRect(DC, RW.Left, RW.Top, RW.Right, RW.Bottom);
      RW := SaveRW;
      { Erase parts not drawn }
      OffsetRect(RW, -RW.Left, -RW.Top);
      //Windows.FillRect(DC, RW, Brush.Handle);
      *)
    finally
      ReleaseDC(Handle, DC);
    end;
  end;
  //inherited;
end;

procedure TVCustomBand.Paint;
begin
  {with canvas do
  begin
  	// clear background
    brush.style := bsSolid;
		brush.Color := color;
    FillRect(ClientRect);
  end;}
  inherited Paint;
end;


procedure TVCustomBand.SetFrame(const Value: TVFrame);
begin
  if FFrame <> Value then
  	FFrame.Assign(Value);
end;

procedure TVCustomBand.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if (parent<>nil) and
  	(Frame.lineWidth<>BorderWidth) then
  	BorderWidth := Frame.lineWidth;
end;

procedure TVCustomBand.WMNCPaint(var Message: TMessage);
begin
  DrawNC;
end;

{ TVMainBand }

constructor TVMainBand.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  with frame do
  begin
    Drawleft := true;
    DrawRight := true;
    DrawTop := true;
    DrawBottom := true;
    LineWidth := 2;
  end;
end;

{ TVRowBand }

constructor TVRowBand.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  with frame do
  begin
    DrawTop := true;
  end;
end;

{ TVColBand }

constructor TVColBand.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  with frame do
  begin
    DrawLeft := true;
  end;
end;

end.
