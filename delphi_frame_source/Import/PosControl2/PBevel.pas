unit PBevel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls;

type
  TPBevel = class(TGraphicControl)
  private
    FShape: TBevelShape;
    FStyle: TBevelStyle;
  protected
    procedure Paint; override;
    procedure SetShape(Value: TBevelShape);
    procedure SetStyle(Value: TBevelStyle);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ParentShowHint;
    property Shape: TBevelShape read FShape write SetShape default bsBox;
    property ShowHint;
    property Style: TBevelStyle read FStyle write SetStyle default bsLowered;
    property Visible;
  end;

procedure Register;

implementation

constructor TPBevel.Create(AOwner: TComponent);
var i: integer;
begin
     inherited Create(AOwner);
     ControlStyle := ControlStyle + [csReplicatable];
     FStyle := bsLowered;
     FShape := bsBox;
     Width := 50;
     Height := 50;
end;

procedure TPBevel.SetShape(Value: TBevelShape);
begin
     if Value <> FShape then
     begin
          FShape := Value;
          Invalidate;
     end;
end;

procedure TPBevel.SetStyle(Value: TBevelStyle);
begin
     if Value <> FStyle then
     begin
          FStyle := Value;
          Invalidate;
     end;
end;

procedure TPBevel.Paint;
var Color1, Color2: TColor;
    Temp: TColor;

    procedure BevelRect(const R: TRect);
    begin
         with Canvas do
         begin
              Pen.Color := Color1;
              PolyLine([Point(R.Left, R.Bottom), Point(R.Left, R.Top),
              Point(R.Right, R.Top)]);
              Pen.Color := Color2;
              PolyLine([Point(R.Right, R.Top), Point(R.Right, R.Bottom),
              Point(R.Left, R.Bottom)]);
         end;
    end;

    procedure BevelLine(C: TColor; X1, Y1, X2, Y2: Integer);
    begin
         with Canvas do
         begin
              Pen.Color := C;
              MoveTo(X1, Y1);
              LineTo(X2, Y2);
         end;
    end;
begin
     with Canvas do
     begin
          Pen.Width := 1;
          if FStyle = bsLowered then
          begin
               Color1 := clBtnShadow;
               Color2 := clBtnHighlight;
          end
          else
          begin
               Color1 := clBtnHighlight;
               Color2 := clBtnShadow;
          end;

          case FShape of
               bsBox:
                    BevelRect(Rect(0, 0, Width - 1, Height - 1));
               bsFrame:
                    begin
                         Temp := Color1;
                         Color1 := Color2;
                         BevelRect(Rect(1, 1, Width - 1, Height - 1));
                         Color2 := Temp;
                         Color1 := Temp;
                         BevelRect(Rect(0, 0, Width - 2, Height - 2));
                    end;
               bsTopLine:
                    begin
                         BevelLine(Color1, 0, 0, Width, 0);
                         BevelLine(Color2, 0, 1, Width, 1);
                    end;
               bsBottomLine:
                    begin
                         BevelLine(Color1, 0, Height - 2, Width, Height - 2);
                         BevelLine(Color2, 0, Height - 1, Width, Height - 1);
                    end;
               bsLeftLine:
                    begin
                         BevelLine(Color1, 0, 0, 0, Height);
                         BevelLine(Color2, 1, 0, 1, Height);
                    end;
               bsRightLine:
                    begin
                         BevelLine(Color1, Width - 2, 0, Width - 2, Height);
                         BevelLine(Color2, Width - 1, 0, Width - 1, Height);
                    end;
          end;
     end;
end;


procedure Register;
begin
     RegisterComponents('PosControl', [TPBevel]);
end;

end.

