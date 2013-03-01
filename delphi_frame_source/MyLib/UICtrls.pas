unit UICtrls;

interface

uses Windows, SysUtils, Classes, Controls, StdCtrls, Graphics, ExtCtrls, Forms, UIStyles;

type
  TUIStyleLink = Class(TComponent)
  private
    FLink :     TUIStyleItemLink;
    FControl: TControl;
    procedure   OnStyleChange(Sender : TObject);
    function    GetStyleItemName: TUIStyleItemName;
    procedure   SetStyleItemName(const Value: TUIStyleItemName);
    procedure   SetControl(const Value: TControl);
    procedure   Changed;
  protected
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
  published
    property    Control : TControl read FControl write SetControl;
    property    StyleItemName : TUIStyleItemName read GetStyleItemName write SetStyleItemName;
  end;

  TUIPanel = Class(TPanel)
  private
    FLink :     TUIStyleItemLink;
    procedure   OnStyleChange(Sender : TObject);
    function    GetStyleItemName: TUIStyleItemName;
    procedure   SetStyleItemName(const Value: TUIStyleItemName);
  protected

  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
  published
    property    StyleItemName : TUIStyleItemName read GetStyleItemName write SetStyleItemName;
  end;

  TUILabel = Class(TLabel)
  private
    FLink :     TUIStyleItemLink;
    procedure   OnStyleChange(Sender : TObject);
    function    GetStyleItemName: TUIStyleItemName;
    procedure   SetStyleItemName(const Value: TUIStyleItemName);
  protected

  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
  published
    property    StyleItemName : TUIStyleItemName read GetStyleItemName write SetStyleItemName;
  end;

  TUIFrame = Class(TFrame)
  private
    FLink :     TUIStyleItemLink;
    FAutoCenter: Boolean;
    FCanvas: TCanvas;
    FDrawBackground: Boolean;
    procedure   OnStyleChange(Sender : TObject);
    function    GetStyleItemName: TUIStyleItemName;
    procedure   SetStyleItemName(const Value: TUIStyleItemName);
    procedure   SetDrawBackground(const Value: Boolean);
  protected
    procedure   Resize; override;
    procedure   Paint; virtual;
    procedure   PaintWindow(DC: HDC); override;
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    procedure   CenterControls;
    property    Canvas: TCanvas read FCanvas;
  published
    property    AutoCenter : Boolean read FAutoCenter write FAutoCenter default True;
    property    DrawBackground : Boolean read FDrawBackground write SetDrawBackground default True;
    property    StyleItemName : TUIStyleItemName read GetStyleItemName write SetStyleItemName;
    property    BevelEdges;
    property    BevelInner;
    property    BevelOuter;
    property    BevelKind;
    property    BevelWidth;
    property    BorderWidth;
  end;

implementation

uses DrawUtils, CompUtils;

var
  BackgroundBitmap : TBitmap;

procedure InitBackGround;
var
  FileName : string;
begin
  BackgroundBitmap := nil;
  FileName := ChangeFileExt(Application.ExeName,'.bmp');
  if FileExists(FileName) then
  begin
    BackgroundBitmap := TBitmap.Create;
    BackgroundBitmap.LoadFromFile(FileName);
  end;
end;

{ TUIStyleLink }

constructor TUIStyleLink.Create(AOwner: TComponent);
begin
  inherited;
  FLink:=TUIStyleItemLink.create;
  FLink.OnChange:=OnStyleChange;
  FControl := nil;
end;

destructor TUIStyleLink.Destroy;
begin
  inherited;
  FreeAndNil(FLink);
end;

function TUIStyleLink.GetStyleItemName: TUIStyleItemName;
begin
  result := FLink.StyleItemName;
end;

procedure TUIStyleLink.SetStyleItemName(const Value: TUIStyleItemName);
begin
  FLink.StyleItemName := Value;
end;

type
  TControlAccess = class(TControl);

procedure TUIStyleLink.OnStyleChange(Sender: TObject);
begin
  Changed;
end;

procedure TUIStyleLink.SetControl(const Value: TControl);
begin
  if FControl <> Value then
  begin
    FControl := Value;
    if FControl<>nil then
    begin
      FControl.FreeNotification(self);
      Changed;
    end;
  end;
end;

procedure TUIStyleLink.Changed;
begin
  if FLink.IsAvailable and (FControl<>nil) then
  with TControlAccess(FControl) do
    begin
      Font:=FLink.StyleItem.Font;
      Color:= FLink.StyleItem.Color;
    end;
end;

procedure TUIStyleLink.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent=FControl) and (Operation=opRemove) then
    FControl:=nil;
end;

{ TUIPanel }

constructor TUIPanel.Create(AOwner: TComponent);
begin
  inherited;
  FLink:=TUIStyleItemLink.create;
  FLink.OnChange:=OnStyleChange;
end;

destructor TUIPanel.Destroy;
begin
  inherited;
  FreeAndNil(FLink);
end;

function TUIPanel.GetStyleItemName: TUIStyleItemName;
begin
  result := FLink.StyleItemName;
end;

procedure TUIPanel.SetStyleItemName(const Value: TUIStyleItemName);
begin
  FLink.StyleItemName := Value;
end;

procedure TUIPanel.OnStyleChange(Sender: TObject);
begin
  if FLink.IsAvailable then
  begin
    Font:=FLink.StyleItem.Font;
    Color:= FLink.StyleItem.Color;
  end;
end;

{ TUILabel }

constructor TUILabel.Create(AOwner: TComponent);
begin
  inherited;
  FLink:=TUIStyleItemLink.create;
  FLink.OnChange:=OnStyleChange;
end;

destructor TUILabel.Destroy;
begin
  inherited;
  FreeAndNil(FLink);
end;

function TUILabel.GetStyleItemName: TUIStyleItemName;
begin
  result := FLink.StyleItemName;
end;

procedure TUILabel.SetStyleItemName(const Value: TUIStyleItemName);
begin
  FLink.StyleItemName := Value;
end;

procedure TUILabel.OnStyleChange(Sender: TObject);
begin
  if FLink.IsAvailable then
  begin
    Font:=FLink.StyleItem.Font;
    Color:= FLink.StyleItem.Color;
  end;
end;

{ TUIFrame }

constructor TUIFrame.Create(AOwner: TComponent);
begin
  // must create FLink before inherited Create
  // otherwise it will bring about a exception
  // when reading StyleItemName (SetStyleItemName)
  FLink:=TUIStyleItemLink.create;
  FLink.OnChange:=OnStyleChange;
  FAutoCenter := True;
  FDrawBackground := True;
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;
  inherited;
end;

destructor TUIFrame.Destroy;
begin
  inherited;
  FreeAndNil(FLink);
  FreeAndNil(FCanvas);
end;

function TUIFrame.GetStyleItemName: TUIStyleItemName;
begin
  result := FLink.StyleItemName;
end;

procedure TUIFrame.SetStyleItemName(const Value: TUIStyleItemName);
begin
  FLink.StyleItemName := Value;
end;

procedure TUIFrame.OnStyleChange(Sender: TObject);
begin
  if FLink.IsAvailable then
  begin
    Font:=FLink.StyleItem.Font;
    Color:= FLink.StyleItem.Color;
  end;
end;

procedure TUIFrame.Resize;
begin
  inherited;
  if AutoCenter and not (csDesigning in ComponentState) then
    CenterControls;
end;

procedure TUIFrame.CenterControls;
begin
  CenterChildren(Self);
end;

procedure TUIFrame.Paint;
begin
  if DrawBackground and (BackgroundBitmap<>nil) then
  begin
    TileDraw(Canvas,BackgroundBitmap,Width,Height);
  end;
end;

procedure TUIFrame.PaintWindow(DC: HDC);
begin
  FCanvas.Lock;
  try
    FCanvas.Handle := DC;
    try
      TControlCanvas(FCanvas).UpdateTextFlags;
      Paint;
    finally
      FCanvas.Handle := 0;
    end;
  finally
    FCanvas.Unlock;
  end;
end;

procedure TUIFrame.SetDrawBackground(const Value: Boolean);
begin
  if FDrawBackground <> Value then
  begin
    FDrawBackground := Value;
    Invalidate;
  end;
end;

initialization
  InitBackGround;

end.
