unit SimpBmp;

// %SimpBmp : 包装Windows的Bitmap,功能比TBitmap简单，速度快
(*****   Code Written By Huang YanLai   *****)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms;

type
  TSimpleBitmapImage = class(TSharedImage)
  private
    FHandle:    HBITMAP;     // DDB or DIB handle, used for drawing
    FPalette:   HPALETTE;
    FOwn    :   boolean;
    FBitmap  :   tagBITMAP;
  protected
    procedure   FreeHandle; override;
  public
    destructor  Destroy; override;
  end;

  // %TSimpleBitmap : 包装Windows的Bitmap,功能比TBitmap简单，速度快
  TSimpleBitmap = class(TGraphic)
  private
    FImage :    TSimpleBitmapImage;
    FOldBitmap : HBitmap;
    FOldPalette : HPalette;
    FMemDC : HDC;
    function    GetHandle: THandle;
    function    GetOwnHandle: boolean;
    procedure   SetHandle(const Value: THandle);
    procedure   SetOwnHandle(const Value: boolean);
    procedure   CreateNew;
  protected
    function    GetEmpty: Boolean; override;
    // return the width/height of bitmap
    function    GetHeight: Integer; override;
    function    GetWidth: Integer; override;
    procedure   SetHeight(Value: Integer); override;
    function    GetTransparent: boolean; override;
    procedure   SetTransparent(Value: Boolean); override;
    procedure   SetWidth(Value: Integer); override;
    function    GetPalette: HPALETTE; override;
    procedure   SetPalette(Value: HPALETTE); override;
  public
    constructor Create; override;
    Destructor 	Destroy;override;
  	procedure 	Assign(Source: TPersistent); override;
    procedure   Clear;
    procedure   Draw(ACanvas: TCanvas; const Rect: TRect); override;
    property    Handle : THandle read GetHandle Write SetHandle;
    procedure   LoadFromStream(Stream: TStream); override;
    procedure   SaveToStream(Stream: TStream); override;
    procedure   LoadFromClipboardFormat(AFormat: Word; AData: THandle;
                  APalette: HPALETTE); override;
    procedure   SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
                  var APalette: HPALETTE); override;
    property    OwnHandle : boolean read GetOwnHandle Write SetOwnHandle;

    property    MemDC : HDC read FMemDC;
    // before draw the bitmap, call GetmemDC to return the memDC that contain the bitmap
    function    GetMemDC: HDC;
    // after draw the bitmap call ReleaseMemDC to release the memDC
    procedure   ReleaseMemDC;
  published

  end;

implementation

procedure InvalidOperation(const Str: string); near;
begin
  raise EInvalidGraphicOperation.Create(Str);
end;

{ TSimpleBitmapImage }

destructor TSimpleBitmapImage.Destroy;
begin
  FreeHandle;
  inherited Destroy;
end;

procedure TSimpleBitmapImage.FreeHandle;
begin
  if FOwn then
  begin
    DeleteObject(FHandle);
    if FPalette<>SystemPalette16 then
      DeleteObject(FPalette);
    FHandle:=0;
    FPalette:=0;
  end;
end;

{ TSimpleBitmap }

constructor TSimpleBitmap.Create;
begin
  Inherited Create;
  FImage := TSimpleBitmapImage.Create;
  FImage.Reference;
end;

destructor TSimpleBitmap.Destroy;
begin
  FImage.Release;
  inherited Destroy;
end;

procedure TSimpleBitmap.Assign(Source: TPersistent);
begin
  if (Source = nil) or (Source is TSimpleBitmap) then
  begin
    //EnterCriticalSection(BitmapImageLock);
    try
      if Source <> nil then
      begin
        TSimpleBitmap(Source).FImage.Reference;
        FImage.Release;
        FImage := TSimpleBitmap(Source).FImage;
      end
      else
      begin
        CreateNew;
      end;
    finally
      //LeaveCriticalSection(BitmapImageLock);
    end;
    Changed(Self);
  end
  else inherited Assign(Source);
end;

procedure TSimpleBitmap.Clear;
begin
  CreateNew;
end;

procedure TSimpleBitmap.Draw(ACanvas: TCanvas; const Rect: TRect);
var
  OldPalette: HPalette;
  RestorePalette: Boolean;
begin
  with Rect, FImage do
  begin
    //ACanvas.RequiredState(csAllValid);
    //PaletteNeeded;
    OldPalette := 0;
    RestorePalette := False;

    if FPalette <> 0 then
    begin
      OldPalette := SelectPalette(ACanvas.Handle, FPalette, True);
      RealizePalette(ACanvas.Handle);
      RestorePalette := True;
    end;

    try
      //Canvas.RequiredState(csAllValid);
      //MemDC := GetMemDC;
      GetMemDC;
      //SelectObject(MemDC,FHandle);
      if FBitmap.bmBitsPixel=1 then
        SetStretchBltMode(ACanvas.Handle,STRETCH_ORSCANS)
      else
        SetStretchBltMode(ACanvas.Handle,STRETCH_DELETESCANS);
      StretchBlt(ACanvas.Handle, Left, Top, Right - Left, Bottom - Top,
          MemDC, 0, 0, Width,Height, ACanvas.CopyMode);
    finally
      //DeleteDC(MemDC);
      ReleaseMemDC;
      if RestorePalette then
        SelectPalette(ACanvas.Handle, OldPalette, True);
    end;
  end;
end;


function TSimpleBitmap.GetEmpty: Boolean;
begin
  result:=FImage.FHandle=0;
end;

function TSimpleBitmap.GetHandle: THandle;
begin
  result := FImage.FHandle;
end;

function TSimpleBitmap.GetPalette: HPALETTE;
begin
  result := FImage.FPalette;
end;

function TSimpleBitmap.GetHeight: Integer;
begin
  result := FImage.FBitmap.bmHeight;
end;

function TSimpleBitmap.GetWidth: Integer;
begin
  result := FImage.FBitmap.bmWidth;
end;


function TSimpleBitmap.GetTransparent: boolean;
begin
  result := false;
end;


procedure TSimpleBitmap.LoadFromClipboardFormat(AFormat: Word;
  AData: THandle; APalette: HPALETTE);
begin

end;

procedure TSimpleBitmap.SaveToClipboardFormat(var AFormat: Word;
  var AData: THandle; var APalette: HPALETTE);
begin

end;

procedure TSimpleBitmap.LoadFromStream(Stream: TStream);
var
  WorkBitmap : TBitmap;
begin
  WorkBitmap := TBitmap.Create;
  try
    WorkBitmap.LoadFromStream(Stream);
    {FImage.FHandle := WorkBitmap.Handle;
    FImage.FPalette := WorkBitmap.Palette;}
    Handle := WorkBitmap.Handle;
    Palette := WorkBitmap.Palette;
    WorkBitmap.ReleaseHandle;
    WorkBitmap.ReleasePalette;
    OwnHandle := true;
  finally
    WorkBitmap.free;
  end;
end;

procedure TSimpleBitmap.SaveToStream(Stream: TStream);
var
  WorkBitmap : TBitmap;
begin
  WorkBitmap := TBitmap.Create;
  try
    WorkBitmap.Handle := FImage.FHandle;
    WorkBitmap.Palette := FImage.FPalette;
    WorkBitmap.SaveToStream(Stream);
    WorkBitmap.ReleaseHandle;
    WorkBitmap.ReleasePalette;
  finally
    WorkBitmap.free;
  end;
end;


procedure TSimpleBitmap.SetHandle(const Value: THandle);
begin
  if FImage.FHandle <> Value then
    begin
      // set to FImage
      if FImage.RefCount > 1 then
        CreateNew;
      FImage.FHandle :=  Value;
      // get bitmap info
      FillChar(FImage.FBitmap, sizeof(FImage.FBitmap), 0);
      if Value <> 0 then
        GetObject(Value, SizeOf(FImage.FBitmap), @FImage.FBitmap);
      Changed(Self);
    end;
end;

procedure TSimpleBitmap.SetPalette(Value: HPALETTE);
begin
  if FImage.FPalette <> Value then
    begin
      FImage.FPalette :=  Value;
      Changed(Self);
    end;
end;

function TSimpleBitmap.GetOwnHandle: boolean;
begin
  result := FImage.FOwn;
end;

procedure TSimpleBitmap.SetOwnHandle(const Value: boolean);
begin
  FImage.FOwn := value;
end;

procedure TSimpleBitmap.SetTransparent(Value: Boolean);
begin

end;

procedure TSimpleBitmap.SetWidth(Value: Integer);
begin
  InvalidOperation('SetWidth');
end;

procedure TSimpleBitmap.SetHeight(Value: Integer);
begin
  InvalidOperation('SetHeight');
end;

procedure TSimpleBitmap.CreateNew;
begin
  if FImage.RefCount=1 then
  begin
    FImage.FreeHandle;
  end
  else
  begin
    // release
    FImage.Release;
    // create new
    FImage := TSimpleBitmapImage.Create;
    FImage.Reference;
  end;
end;

function TSimpleBitmap.GetMemDC: HDC;
begin
  ReleaseMemDC;
  FMemDC:=CreateCompatibleDC(0);
  result:=FMemDC;
  if FImage.FHandle <> 0 then
    FOldBitmap := SelectObject(FMemDC, FImage.FHandle) else
    FOldBitmap := 0;
  if FImage.FPalette <> 0 then
  begin
    FOldPalette := SelectPalette(FMemDC, FImage.FPalette, True);
    RealizePalette(FMemDC);
  end
  else
    FOldPalette := 0;
end;

procedure TSimpleBitmap.ReleaseMemDC;
begin
  if FMemDC <> 0 then
  begin
    if FOldBitmap <> 0 then SelectObject(FMemDC, FOldBitmap);
    if FOldPalette <> 0 then SelectPalette(FMemDC, FOldPalette, True);
    DeleteDC(FMemDC);
    FMemDC:=0;
    FOldBitmap := 0;
    FOldPalette := 0;
  end;
end;

end.
