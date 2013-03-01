unit CustomImageFX;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TCustomImageFX = class(TImage)
  private
    { Private declarations }
    FTimer: TTimer;
    FirstShow : boolean;
    FAutoRunning: boolean;
    FCount : integer;
    procedure SetRuning(const Value: boolean);
    procedure OnTimer(sender : TObject); virtual;
    function  GetRuning: boolean;
    function  getDestCanvas: TCanvas;
    function  GetInterval: integer;
    procedure SetInterval(const Value: integer);
  protected
    { Protected declarations }
    procedure Paint; override;
    procedure PaintFX; virtual;
    property  DestCanvas : TCanvas read getDestCanvas;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    property    Timer : TTimer read FTimer;
    procedure   StartFX; virtual;
    procedure   EndFX;   virtual;
    property    Runing : boolean read GetRuning write SetRuning;
  published
    { Published declarations }
    property    AutoRunning : boolean read FAutoRunning write FAutoRunning;
    property    Interval : integer read GetInterval Write SetInterval;
    property    Color;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TCustomImageFX]);
end;

{ TCustomImageFX }

constructor TCustomImageFX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTimer := TTimer.Create(self);
  FTimer.Enabled := false;
  FTimer.OnTimer := OnTimer;
  FirstShow := true;
end;

procedure TCustomImageFX.OnTimer(sender: TObject);
begin
  Inc(FCount);
  PaintFX;
end;

procedure TCustomImageFX.Paint;
begin
  if FirstShow then
  begin
    FirstShow:=false;
    if AutoRunning and not (csLoading in ComponentState) then
    begin
      StartFX;
      exit;
    end;
  end;
  if not Runing then inherited Paint
  else PaintFX;
end;

procedure TCustomImageFX.SetRuning(const Value: boolean);
begin
  //FRuning := Value;
  if value<>Runing then
    StartFX
  else
    EndFX;
end;

procedure TCustomImageFX.StartFX;
begin
  Timer.enabled:=true;
  FCount:=0;
end;

procedure TCustomImageFX.EndFX;
begin
  Timer.enabled:=false;
end;


function TCustomImageFX.GetRuning: boolean;
begin
  result := Timer.enabled;
end;

type
  TGraphicControlAccess = class(TGraphicControl);

procedure TCustomImageFX.PaintFX;
var
  ARect : TRect;
begin
  case FCount of
    1 : ARect:=Rect(0,0,width div 8,height div 8);
    2 : ARect:=Rect(0,0,width div 4,height div 4);
    3 : ARect:=Rect(0,0,width div 2,height div 2);
  end;
  DestCanvas.StretchDraw(ARect,Picture.Graphic);
  if FCount=3 then EndFX;
end;

function TCustomImageFX.getDestCanvas: TCanvas;
begin
  result := TGraphicControlAccess(self).Canvas;
end;

function TCustomImageFX.GetInterval: integer;
begin
  result := FTimer.Interval;
end;

procedure TCustomImageFX.SetInterval(const Value: integer);
begin
  FTimer.Interval:=value;
end;

end.
