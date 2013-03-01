unit AniSymbl;

// Encapsulation of the Animation Control
// from COMCTL32.DLL (Common Controls)

// by Thomas Schimming (c) 1996
// e-mail: schimmin@iee1.et.tu-dresden.de

// provided free of charge (not public domain)
// use at Your own risk

// NOT TO BE SOLD OR DISTRIBUTED FOR A CHARGE without my permission.

interface

uses
  Windows, Messages, SysUtils, CommCtrl, Classes, Graphics, Controls, Forms, Dialogs;

type

  TAnimatedState = (acmOpen,acmClosed,acmPlaying);
  TAnimatedSymbol = class(TWinControl)
  private
    FPlayFrom: Smallint;
    FPlayTo: Smallint;
    FCycles: Smallint;
    FState: TAnimatedState;
    FAVIName: String;
    FAutoPlay: Boolean;
    FCenter: Boolean;
    FTransparent: Boolean;
    procedure SetPlayRange;
    procedure SetPlayFrom(FromFrame: Smallint);
    procedure SetPlayTo(ToFrame: Smallint);
    procedure SetCycles(nCycles: Smallint);
    procedure SetAVIName(aName: String);
    procedure SetState(aState: TAnimatedState);
    procedure SetCenter(NewValue: Boolean);
    procedure SetTransparent(NewValue: Boolean);
    procedure SetAutoPlay(NewValue: Boolean);
    procedure SetAllData;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure OpenResource(ResID: Longint);
    procedure OpenAVIFile(FileName: String);
  published
    property Enabled;
    property Visible;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property AVIName: String read FAVIName write SetAVIName;
    property Center: Boolean read FCenter write SetCenter default true;
    property Transparent: Boolean read FTransparent write SetTransparent default true;
    property PlayFrom: Smallint read FPlayFrom write SetPlayFrom default 0;
    property PlayTo: Smallint read FPlayTo write SetPlayTo default -1;
    property Cycles: Smallint read FCycles write SetCycles default -1;
    property State: TAnimatedState read FState write SetState default acmClosed;
    property AutoPlay: Boolean read FAutoPlay write SetAutoPlay default true;
  end;

procedure Register;

implementation

{ TAnimatedSymbol }
constructor TAnimatedSymbol.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 32;
  Height := 32;

  FPlayFrom := 0;
  FPlayTo := -1;
  FCycles := -1;
  FState := acmClosed;
  FAutoPlay := true;
  FCenter := True;
  FTransparent := True;
end;

procedure TAnimatedSymbol.CreateParams(var Params: TCreateParams);
begin
  InitCommonControls;
  inherited CreateParams(Params);

  if FAutoPlay then Params.Style := Params.Style or ACS_AUTOPLAY;
  if FCenter then Params.Style := Params.Style or ACS_CENTER;
  if FTransparent then Params.Style := Params.Style or ACS_TRANSPARENT;

  CreateSubClass(Params, ANIMATE_CLASS);
end;

procedure TAnimatedSymbol.CreateWnd;
begin
  inherited CreateWnd;

  SetAllData;
end;

procedure TAnimatedSymbol.SetAllData;
begin
  if (FAutoPlay or (State<>acmClosed)) and (FAVIName<>'') then
    if SendMessage(Handle, ACM_OPEN, 0, Longint(PChar(FAVIName)))=0 then
      raise Exception.Create('Could not open AVI "'+FAVIName+'"'+
                 #13+#13+'It must be a silent AVI file/resource.')
    else
      SetPlayRange
  else
  begin
    SendMessage(Handle, ACM_OPEN, 0, 0);
    Invalidate;
  end;
end;

procedure TAnimatedSymbol.SetState(aState: TAnimatedState);
begin
  FState := aState;
  SetAllData;
end;

procedure TAnimatedSymbol.SetAVIName(aName: String);
begin
  FAVIName := aName;
  SetAllData;
end;

procedure TAnimatedSymbol.OpenResource(ResID: Longint);
begin
  if SendMessage(Handle, ACM_OPEN, 0, ResID)=0 then
    raise Exception.Create('Could not open AVI #'+IntToStr(ResID)+
               #13+#13+'It must be a silent AVI file/resource.');
  SetPlayRange;
end;

procedure TAnimatedSymbol.OpenAVIFile(FileName: String);
begin
  FAVIName := FileName;
  SetAllData;
end;

procedure TAnimatedSymbol.SetPlayRange;
begin
  if FState=acmPlaying then
    SendMessage(Handle, ACM_PLAY, FCycles, MakeLong(FPlayFrom,FPlayTo));
end;

procedure TAnimatedSymbol.SetPlayFrom(FromFrame: Smallint);
begin
  FPlayFrom := FromFrame;
  SetPlayRange;
end;

procedure TAnimatedSymbol.SetPlayTo(ToFrame: Smallint);
begin
  FPlayTo := ToFrame;
  SetPlayRange;
end;

procedure TAnimatedSymbol.SetCycles(nCycles: Smallint);
begin
  FCycles := nCycles;
  SetPlayRange;
end;

procedure TAnimatedSymbol.SetCenter(NewValue: Boolean);
begin
  if FCenter <> NewValue then
  begin
    FCenter := NewValue;
    RecreateWnd;
  end;
end;

procedure TAnimatedSymbol.SetTransparent(NewValue: Boolean);
begin
  if FTransparent <> NewValue then
  begin
    FTransparent := NewValue;
    RecreateWnd;
  end;
end;

procedure TAnimatedSymbol.SetAutoPlay(NewValue: Boolean);
begin
  if FAutoPlay <> NewValue then
  begin
    FAutoPlay := NewValue;
    RecreateWnd;
  end;
end;

procedure Register;
begin
  RegisterComponents('Win95', [TAnimatedSymbol]);
end;

end.

