unit OpenGLUtils;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, OpenGL;

type
  EOpenGLError = class(Exception);

  TOGLDevice = class(TObject)
  private
    FOwnDC: Boolean;
    FDC: HDC;
    FRC: HGLRC;
    FIsCurrent: Boolean;
    procedure   SetIsCurrent(const Value: Boolean);

  protected

  public
    constructor Create(ADC : HDC; AOwnDC : Boolean); overload;
    constructor Create(AWnd : THandle); overload;
    destructor  Destroy;override;
    procedure   MakeCurrent;
    procedure   MakeNonCurrent;
    property    DC : HDC read FDC;
    property    RC : HGLRC read FRC;
    property    OwnDC : Boolean read FOwnDC;
    property    IsCurrent : Boolean read FIsCurrent write SetIsCurrent;
  end;

function  uCreateRC(DC: HDC): HGLRC;

procedure uCheckOpenGLCall(Ok : Boolean; const ErrorMsg : string='');

resourcestring
  SEChoosePixelFormat = 'Unable to select a suitable pixel format';
  SESetPixelFormat = 'Unable to set pixel format';

implementation

procedure uCheckOpenGLCall(Ok : Boolean; const ErrorMsg : string='');
begin
  if not Ok then
    raise EOpenGLError.Create(ErrorMsg);
end;

function  uCreateRC(DC: HDC): HGLRC;
var
  PixelFmt: Integer;
  pfd: TPixelFormatDescriptor;
begin
  FillChar(pfd, SizeOf(pfd), 0);

  with pfd do
  begin
    nSize     := sizeof(pfd);
    nVersion  := 1;
    dwFlags   := PFD_DRAW_TO_WINDOW or
                 PFD_SUPPORT_OPENGL or
                 PFD_DOUBLEBUFFER;
    iPixelType:= PFD_TYPE_RGBA;
    cColorBits:= 24;
    cDepthBits:= 32;
    iLayerType:= PFD_MAIN_PLANE;
  end;

  PixelFmt := ChoosePixelFormat(DC, @pfd);
  uCheckOpenGLCall(PixelFmt<>0,SEChoosePixelFormat);
  uCheckOpenGLCall(SetPixelFormat(DC, PixelFmt, @pfd),SESetPixelFormat);
  Result := wglCreateContext(DC);
end;

{ TOGLDevice }

constructor TOGLDevice.Create(ADC: HDC; AOwnDC: Boolean);
begin
  FDC := ADC;
  FOwnDC := AOwnDC;
  FRC := uCreateRC(FDC);
end;

constructor TOGLDevice.Create(AWnd: THandle);
begin
  Create(GetDC(AWnd),True);
end;

destructor TOGLDevice.Destroy;
begin
  IsCurrent := False;
  wglDeleteContext(FRC);
  if FOwnDC then
    ReleaseDC(WindowFromDC(FDC),FDC);
  inherited;
end;

procedure TOGLDevice.MakeCurrent;
begin
  FIsCurrent := True;
  wglMakeCurrent(FDC, FRC);
end;

procedure TOGLDevice.MakeNonCurrent;
begin
  FIsCurrent := False;
  wglMakeCurrent(0, 0);
end;

procedure TOGLDevice.SetIsCurrent(const Value: Boolean);
begin
  if FIsCurrent <> Value then
  begin
    if Value then
      MakeCurrent else
      MakeNonCurrent;
  end;
end;

end.
