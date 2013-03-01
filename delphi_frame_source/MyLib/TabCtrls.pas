unit TabCtrls;

interface

uses Windows,SysUtils,Classes,ComCtrls;

type
  TTabControlEx = class(TTabControl)
  private
    FTextVertical: Boolean;
    FActiveFont: TFont;
    procedure SetTextVertical(const Value: Boolean);
    procedure SetActiveFont(const Value: TFont);

  protected
    procedure   DrawTab(TabIndex: Integer; const Rect: TRect; Active: Boolean); override;
  public
    constructor Create(AOwner : TComponent); override;
  published
    property    TextVertical : Boolean read FTextVertical write SetTextVertical default True;
    property    ActiveFont : TFont read FActiveFont write SetActiveFont;
  end;

implementation

procedure TabControl1DrawTab(Control: TCustomTabControl;
  Caption: Integer; const Rect: TRect; Font: TFont);
var
  MyRect : TRect;
  S,S1 : String;
  i,len : integer;
  P : Pchar;
  MultiBytes : boolean;
begin
  MyRect := Rect;
  Inc(MyRect.left,Margin);
  Inc(MyRect.Top,Margin);
  S:=Caption;
  P:=Pchar(S);
  len := length(s);
  MultiBytes := false;
  S1 := '';
  for i:=1 to len do
  begin
    if P^>#127 then
    begin
      S1 := S1 + P^;
      if MultiBytes then
      begin
        MultiBytes:=false;
        if i<len then S1:=S1+LineBreak;
      end
      else
        MultiBytes := true;
    end
    else
    begin
      MultiBytes := false;
      S1 := S1+P^;
      if i<len then S1:=S1+LineBreak;
    end;
    Inc(P);
  end;
  Control.Canvas.Font := Font;
  Windows.DrawText(Control.Canvas.Handle,
    Pchar(S1),
    -1,
    MyRect,
    DT_EDITCONTROL or DT_WORDBREAK{ or DT_NOCLIP});
end;

{ TTabControlEx }

constructor TTabControlEx.Create(AOwner: TComponent);
begin
  inherited;
  FTextVertical := true;
  FActiveFont := TFont.Create;
end;

procedure TTabControlEx.DrawTab(TabIndex: Integer; const Rect: TRect;
  Active: Boolean);
begin
  if Assigned(FOnDrawTab) then
    inherited
  else
    ;

end;

procedure TTabControlEx.SetActiveFont(const Value: TFont);
begin
  FActiveFont.Assign(Value);
end;

procedure TTabControlEx.SetTextVertical(const Value: Boolean);
begin
  if FTextVertical <> Value then
  begin
    FTextVertical := Value;
    if TabPosition in [tpLeft, tpRight] then
      Invalidate();
  end;
end;

end.
