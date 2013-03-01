unit PrintDevices;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>PrintDevices
   <What>提供打印驱动接口的实现。实现不仅限于打印机设备，也可以包含屏幕显示等等。
   <Written By> Huang YanLai
   <See>打印.mdl
   <History>
    0.l 将接口定义移到RPDefines.pas
**********************************************}


interface

uses Windows, SysUtils, Classes, Graphics, Printers, Contnrs, RPDefines;


type
  {
    <Class>TBasicPrinter
    <What>基本的打印设备接口实现。
    主要在Canvas上面实现了画图的方法。
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TBasicPrinter = class(TComponent,IBasicPrinter)
  private
    FTitle: string;
  protected
    FPrinting : Boolean;
    FPageNumber: Integer;
    FHeight: TFloat;
    FWidth: TFloat;
    FTransform : TTransform;
    FCanvas : TCanvas;

    FPaperWidth : TFloat;
    FPaperHeight : TFloat;
    FPaperLeftMargin : TFloat;
    FPaperTopMargin : TFloat;

    FSavedDC : HDC;
    FAborted : Boolean;

    function    GetPageNumber: Integer;
    function    GetWidth : TFloat;
    function    GetHeight: TFloat;
    function    GetFont: TFont;
    procedure   SetFont(Value : TFont);
    function    GetPen: TPen;
    procedure   SetPen(Value : TPen);
    function    GetBrush: TBrush;
    procedure   SetBrush(Value : TBrush);
    function    GetPageCanvas: TCanvas; virtual; abstract;
    procedure   ReleasePageCanvas;
    procedure   InternalReleasePageCanvas; virtual;
    procedure   GetDeviceProperties; virtual;
    procedure   UpdatePageSize; virtual;
    procedure   InitPage; virtual;
    procedure   CheckDeviceAvailable;
    procedure   GetPageSizeFromDC(DC : THandle); // call GetDeviceCaps
    procedure   GetPageInfo(DC : THandle); // use cached data or call GetPageSizeFromDC

    function    GetPaperWidth : TFloat;
    function    GetPaperHeight : TFloat;
    function    GetPaperLeftMargin : TFloat;
    function    GetPaperTopMargin : TFloat;
    function    GetTitle : string;

    function    CanSetPaperSize : Boolean; virtual;
    procedure   SetPaperSize(APaperWidth, APaperHeight : TFloat; AOrientation : TRPOrientation); virtual; abstract;
    procedure   RestorePaperSize; virtual; abstract;
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    // Output Functions
    procedure   DrawLine(X1,Y1,X2,Y2 : TFloat);
    procedure   DrawEllipse(X1,Y1,X2,Y2 : TFloat);
    procedure   DrawRect(X1,Y1,X2,Y2 : TFloat);
    procedure   DrawRoundRect(X1,Y1,X2,Y2,X3,Y3 : TFloat);
    procedure   DrawArc(X1,Y1,X2,Y2,X3,Y3,X4,Y4 : TFloat);
    procedure   FillRect(X1,Y1,X2,Y2 : TFloat);
    procedure   DrawGraphic(X1,Y1,X2,Y2 : TFloat; Graphic : TGraphic);
    procedure   DrawGraphic2(X,Y : TFloat; Graphic : TGraphic);
    procedure   DrawText(X,Y : TFloat; const Text:String);
    procedure   DrawTextRect(X1,Y1,X2,Y2 : TFloat; const Text:String; Flags : Integer);
    function    CalcTextSize(const Text:String; IsMultiLine : Boolean; Width : TFloat):TRPSize;
    property    Width : TFloat read GetWidth;
    property    Height: TFloat read GetHeight;
    property    Font : TFont read GetFont Write SetFont;
    property    Pen : TPen read GetPen Write SetPen;
    property    Brush : TBrush read GetBrush Write SetBrush;
    property    Canvas : TCanvas read FCanvas;

    property    PaperWidth : TFloat read GetPaperWidth;
    property    PaperHeight : TFloat read GetPaperHeight;
    property    PaperLeftMargin : TFloat read GetPaperLeftMargin;
    property    PaperTopMargin : TFloat read GetPaperTopMargin;
    // Page Controls
    procedure   BeginDoc(const Title:string=''); virtual;
    procedure   EndDoc; virtual;
    procedure   AbortDoc; virtual;
    procedure   NewPage; virtual;
    function    Printing: Boolean;
    function    Aborted : Boolean;
    procedure   GetPageSize(var AWidth,AHeight : TFloat);
    property    PageNumber: Integer read FPageNumber;
    property    Title : string read FTitle;
  published

  end;

  {
    <Class>TMetaFilePrinter
    <What>一个在MetaFile上面输出的打印驱动对象。可以用于模拟打印以及打印预览。
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
    <Note>
      注意：MataFile的纸张大小从DC获得的不正确。
  }
  TMetaFilePrinter = class(TBasicPrinter)
  private
    FMetaFiles : TObjectList;
    {
    FSavedPageHeight: TFloat;
    FSavedPageWidth : TFloat;
    FSavedPaperWidth : TFloat;
    FSavedPaperHeight: TFloat;
    FSavedPaperLeftMargin : TFloat;
    FSavedPaperTopMargin  : TFloat;
    }
    FPageHeight: TFloat;
    FPageWidth: TFloat;
    function    GetMetaFiles(PageIndex: Integer): TMetaFile;
  protected
    function    GetPageCanvas: TCanvas; override;
    procedure   InternalReleasePageCanvas; override;
    procedure   InitPage; override;
    procedure   UpdatePageSize; override;
    procedure   SetPaperSize(APaperWidth, APaperHeight : TFloat; AOrientation : TRPOrientation); override;
    procedure   RestorePaperSize; override;
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    procedure   BeginDoc(const Title:string=''); override;
    procedure   AbortDoc; override;
    procedure   NewPage; override;
    procedure   PageLikeThis(DC : THandle);
    property    MetaFiles[PageIndex : Integer] : TMetaFile read GetMetaFiles;
  published
    property    PageWidth : TFloat read FPageWidth write FPageWidth;
    property    PageHeight : TFloat read FPageHeight write FPageHeight;
  end;

  {
    <Class>TStanderdPrinter
    <What>标准打印机。对应物理打印机。
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TStandardPrinter = class(TBasicPrinter)
  private
    FPrinter: TPrinter;
    //FSavedDeviceMode : PDeviceMode;
  protected
    function    GetPageCanvas: TCanvas; override;
    procedure   UpdatePageSize; override;
    procedure   SetPaperSize(APaperWidth, APaperHeight : TFloat; AOrientation : TRPOrientation); override;
    procedure   RestorePaperSize; override;
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    procedure   BeginDoc(const Title:string=''); override;
    procedure   EndDoc; override;
    procedure   AbortDoc; override;
    procedure   NewPage; override;
    property    Printer : TPrinter read FPrinter write FPrinter;
  published

  end;


implementation

{ TBasicPrinter }

constructor TBasicPrinter.Create(AOwner: TComponent);
begin
  inherited;
  FPageNumber := 0;
  FCanvas := nil;
  FTransform := TTransform.Create;
  FPrinting := false;
  FSavedDC := 0;
end;

destructor TBasicPrinter.Destroy;
begin
  inherited;
  FTransform.Free;
end;

// Page Controls
procedure TBasicPrinter.CheckDeviceAvailable;
begin
  Assert((FCanvas<>nil) and (FCanvas.Handle<>0));
end;

procedure TBasicPrinter.AbortDoc;
begin
  FPageNumber := 0;
  FPrinting := false;
  FAborted := True;
end;

procedure TBasicPrinter.BeginDoc(const Title:string='');
begin
  FPageNumber := 0;
  FPrinting := true;
  FTitle := Title;
  FAborted := False;
end;

procedure TBasicPrinter.EndDoc;
begin
  ReleasePageCanvas;
  FPrinting := false;
end;

procedure TBasicPrinter.NewPage;
begin
  Assert(FPrinting);
  ReleasePageCanvas;
  FCanvas := GetPageCanvas;
  Inc(FPageNumber);

  if FPageNumber=1 then
    GetDeviceProperties;

  InitPage;
  CheckDeviceAvailable;
end;

function TBasicPrinter.GetPageNumber: Integer;
begin
  Result := FPageNumber;
end;

procedure TBasicPrinter.GetDeviceProperties;
begin
  CheckDeviceAvailable;
  FTransform.InitFromCanvas(FCanvas);
  //UpdatePageSize;
end;

// Output Functions
function TBasicPrinter.CalcTextSize(const Text:String; IsMultiLine : Boolean; Width : TFloat): TRPSize;
var
  ARect : TRect;
  Flags : Integer;
begin
  CheckDeviceAvailable;
  ARect := Rect(
    0,
    0,
    FTransform.Physics2DeviceX(Width),
    0
    );
  if IsMultiLine then
    Flags := DT_CALCRECT or DT_WORDBREAK	or DT_EDITCONTROL
  else
    Flags := DT_CALCRECT or DT_SINGLELINE	;
  Windows.DrawText(FCanvas.Handle,Pchar(Text),Length(Text),ARect,Flags);
  Result.Width := FTransform.Device2PhysicsX(ARect.Right);
  Result.Height := FTransform.Device2PhysicsY(ARect.Bottom);
end;

procedure TBasicPrinter.DrawArc(X1, Y1, X2, Y2, X3, Y3, X4, Y4: TFloat);
begin
  CheckDeviceAvailable;
  FCanvas.Arc(
    FTransform.Physics2DeviceX(X1),
    FTransform.Physics2DeviceY(Y1),
    FTransform.Physics2DeviceX(X2),
    FTransform.Physics2DeviceY(Y2),
    FTransform.Physics2DeviceX(X3),
    FTransform.Physics2DeviceY(Y3),
    FTransform.Physics2DeviceX(X4),
    FTransform.Physics2DeviceY(Y4)
    );
end;

procedure TBasicPrinter.DrawEllipse(X1, Y1, X2, Y2: TFloat);
begin
  CheckDeviceAvailable;
  FCanvas.Ellipse(
    FTransform.Physics2DeviceX(X1),
    FTransform.Physics2DeviceY(Y1),
    FTransform.Physics2DeviceX(X2),
    FTransform.Physics2DeviceY(Y2)
    );
end;

procedure TBasicPrinter.DrawGraphic(X1, Y1, X2, Y2: TFloat;
  Graphic: TGraphic);
begin
  CheckDeviceAvailable;
  FCanvas.CopyMode := cmSrcCopy;
  FCanvas.StretchDraw(
    Rect(
      FTransform.Physics2DeviceX(X1),
      FTransform.Physics2DeviceY(Y1),
      FTransform.Physics2DeviceX(X2),
      FTransform.Physics2DeviceY(Y2)
      ),
    Graphic
    );
end;

procedure TBasicPrinter.DrawLine(X1, Y1, X2, Y2: TFloat);
begin
  CheckDeviceAvailable;
  FCanvas.MoveTo(
    FTransform.Physics2DeviceX(X1),
    FTransform.Physics2DeviceY(Y1)
    );
  FCanvas.LineTo(
    FTransform.Physics2DeviceX(X2),
    FTransform.Physics2DeviceY(Y2)
    );
end;

procedure TBasicPrinter.DrawRect(X1, Y1, X2, Y2: TFloat);
begin
  CheckDeviceAvailable;
  FCanvas.Rectangle(
    FTransform.Physics2DeviceX(X1),
    FTransform.Physics2DeviceY(Y1),
    FTransform.Physics2DeviceX(X2),
    FTransform.Physics2DeviceY(Y2)
    );
end;

procedure TBasicPrinter.DrawRoundRect(X1, Y1, X2, Y2, X3, Y3: TFloat);
begin
  CheckDeviceAvailable;
  FCanvas.RoundRect(
    FTransform.Physics2DeviceX(X1),
    FTransform.Physics2DeviceY(Y1),
    FTransform.Physics2DeviceX(X2),
    FTransform.Physics2DeviceY(Y2),
    FTransform.Physics2DeviceX(X3),
    FTransform.Physics2DeviceY(Y3)
    );
end;

procedure TBasicPrinter.DrawText(X, Y: TFloat; const Text: String);
begin
  CheckDeviceAvailable;
  FCanvas.TextOut(
    FTransform.Physics2DeviceX(X),
    FTransform.Physics2DeviceY(Y),
    Text
    );
end;


procedure TBasicPrinter.DrawTextRect(X1, Y1, X2, Y2: TFloat;
  const Text: String; Flags: Integer);
var
  ARect : TRect;
begin
  CheckDeviceAvailable;
  ARect := Rect(
    FTransform.Physics2DeviceX(X1),
    FTransform.Physics2DeviceY(Y1),
    FTransform.Physics2DeviceX(X2),
    FTransform.Physics2DeviceY(Y2)
    );
  Windows.DrawText(FCanvas.Handle,Pchar(Text),Length(Text),ARect,Flags);
end;

procedure TBasicPrinter.FillRect(X1, Y1, X2, Y2: TFloat);
begin
  CheckDeviceAvailable;
  Canvas.FillRect(Rect(
    FTransform.Physics2DeviceX(X1),
    FTransform.Physics2DeviceY(Y1),
    FTransform.Physics2DeviceX(X2),
    FTransform.Physics2DeviceY(Y2)
    ));
end;

function TBasicPrinter.GetBrush: TBrush;
begin
  CheckDeviceAvailable;
  Result := FCanvas.Brush;
end;

function TBasicPrinter.GetFont: TFont;
begin
  CheckDeviceAvailable;
  Result := FCanvas.Font;
end;

function TBasicPrinter.GetHeight: TFloat;
begin
  UpdatePageSize;
  Result := FHeight;
end;

function TBasicPrinter.GetWidth: TFloat;
begin
  UpdatePageSize;
  Result := FWidth;
end;

function TBasicPrinter.GetPen: TPen;
begin
  CheckDeviceAvailable;
  Result := FCanvas.Pen;
end;

procedure TBasicPrinter.SetBrush(Value: TBrush);
begin
  CheckDeviceAvailable;
  FCanvas.Brush := Value;
end;

procedure TBasicPrinter.SetFont(Value: TFont);
begin
  CheckDeviceAvailable;
  FCanvas.Font := Value;
end;

procedure TBasicPrinter.SetPen(Value: TPen);
begin
  CheckDeviceAvailable;
  FCanvas.Pen := Value;
end;

procedure TBasicPrinter.InternalReleasePageCanvas;
begin
  FCanvas := nil;
end;

procedure TBasicPrinter.ReleasePageCanvas;
begin
  if (FCanvas<>nil) and (FPageNumber>0) then
    InternalReleasePageCanvas;
end;

procedure TBasicPrinter.InitPage;
begin

end;

procedure TBasicPrinter.DrawGraphic2(X, Y: TFloat; Graphic: TGraphic);
begin
  CheckDeviceAvailable;
  FCanvas.CopyMode := cmSrcCopy;
  FCanvas.Draw(
      FTransform.Physics2DeviceX(X),
      FTransform.Physics2DeviceY(Y),
      Graphic
    );
end;

procedure TBasicPrinter.UpdatePageSize;
begin
  Assert(FCanvas<>nil);
  if (FCanvas<>nil) then
  begin
    GetPageInfo(FCanvas.Handle);
  end;
end;

procedure TBasicPrinter.GetPageSize(var AWidth, AHeight: TFloat);
begin
  UpdatePageSize;
  AWidth := FWidth;
  AHeight := FHeight;
end;

function TBasicPrinter.Printing: Boolean;
begin
  Result := FPrinting;
end;

procedure TBasicPrinter.GetPageSizeFromDC(DC: THandle);
var
  FX,FY : Double;
begin
  FWidth := GetDeviceCaps(DC, HORZSIZE)*10;
  FHeight:= GetDeviceCaps(DC, VERTSIZE)*10;
  FX := GetDeviceCaps(DC,LOGPIXELSX) / TenthMMPerInch;
  FY := GetDeviceCaps(DC,LOGPIXELSY) / TenthMMPerInch;
  FPaperWidth := GetDeviceCaps(DC, PHYSICALWIDTH) / FX;
  FPaperHeight := GetDeviceCaps(DC, PHYSICALHEIGHT) / FY;
  FPaperLeftMargin := GetDeviceCaps(DC, PHYSICALOFFSETX) / FX;
  FPaperTopMargin := GetDeviceCaps(DC, PHYSICALOFFSETY) / FY;
end;

function TBasicPrinter.GetPaperHeight: TFloat;
begin
  UpdatePageSize;
  Result := FPaperHeight;
end;

function TBasicPrinter.GetPaperLeftMargin: TFloat;
begin
  UpdatePageSize;
  Result := FPaperLeftMargin;
end;

function TBasicPrinter.GetPaperTopMargin: TFloat;
begin
  UpdatePageSize;
  Result := FPaperTopMargin;
end;

function TBasicPrinter.GetPaperWidth: TFloat;
begin
  UpdatePageSize;
  Result := FPaperWidth;
end;

procedure TBasicPrinter.GetPageInfo(DC: THandle);
begin
  if (FSavedDC<>DC) then
  begin
    GetPageSizeFromDC(DC);
    FSavedDC:=DC;
  end
end;

function TBasicPrinter.GetTitle: string;
begin
  Result := FTitle;
end;

function TBasicPrinter.CanSetPaperSize: Boolean;
begin
  Result := True;
end;

function TBasicPrinter.Aborted: Boolean;
begin
  Result := FAborted;
end;

{ TMetaFilePrinter }

constructor TMetaFilePrinter.Create(AOwner: TComponent);
begin
  inherited;
  FMetaFiles := TObjectList.Create;
end;

destructor TMetaFilePrinter.Destroy;
begin
  FMetaFiles.Free;
  inherited;
end;

procedure TMetaFilePrinter.AbortDoc;
begin
  inherited;
  FMetaFiles.Clear;
end;

function TMetaFilePrinter.GetPageCanvas: TCanvas;
var
  MetaFile : TMetaFile;
  MetaFileCanvas : TMetaFileCanvas;
begin
  MetaFile := TMetaFile.Create;
  FMetaFiles.Add(MetaFile);
  MetaFile.Enhanced := true;
  // 应该用这种方式根据物理大小0.1mm指定MetaFile的大小
  MetaFile.Width := ScreenTransform.Physics2DeviceX(FPageWidth);
  MetaFile.Height := ScreenTransform.Physics2DeviceX(FPageHeight);
  {
  // 这样指定的大小小于实际值
  MetaFile.MMWidth := Round(FPageWidth*10);
  MetaFile.MMHeight := Round(FPageHeight*10);
  }
  MetaFileCanvas := TMetaFileCanvas.Create(MetaFile,0);
  Result := MetaFileCanvas;
end;

procedure TMetaFilePrinter.NewPage;
begin
  inherited;
  FWidth := FPageWidth;
  FHeight := FPageHeight;
  //Assert((abs(FPageWidth-FWidth)<15) and (abs(FPageHeight-FHeight)<15));
end;

procedure TMetaFilePrinter.PageLikeThis(DC: THandle);
begin
  {
  FPageWidth := GetDeviceCaps(DC, HORZSIZE)*10;
  FPageHeight:= GetDeviceCaps(DC, VERTSIZE)*10;
  }
  GetPageSizeFromDC(DC);
  FPageHeight := FHeight;
  FPageWidth := FWidth;
  {
  FSavedPageWidth := FPageWidth;
  FSavedPageHeight:= FPageHeight;
  FSavedPaperWidth := FPaperWidth;
  FSavedPaperHeight:= FPaperHeight;
  FSavedPaperLeftMargin := FPaperLeftMargin;
  FSavedPaperTopMargin  := FPaperTopMargin;
  }
end;

function TMetaFilePrinter.GetMetaFiles(PageIndex: Integer): TMetaFile;
begin
  Result := TMetaFile(FMetaFiles[PageIndex]);
end;

procedure TMetaFilePrinter.InternalReleasePageCanvas;
begin
  FCanvas.Free;
  inherited;
end;

procedure TMetaFilePrinter.InitPage;
{var
  w, h : TFloat;}
begin
  inherited;
  Brush.Color := clWhite;
  Brush.Style := bsSolid;
  Pen.Color := clBlack;
  Pen.Style := psSolid;
  Pen.Width := 1;
  {
  W := FPageWidth;
  H := FPageHeight;
  DrawRect(
      0,
      0,
      W,
      H
    );
  }
end;

procedure TMetaFilePrinter.BeginDoc(const Title:string='');
begin
  inherited;
  FMetaFiles.Clear;
end;

procedure TMetaFilePrinter.UpdatePageSize;
begin
  FWidth := FPageWidth;
  FHeight := FPageHeight;
end;

procedure TMetaFilePrinter.SetPaperSize(APaperWidth,
  APaperHeight: TFloat; AOrientation : TRPOrientation);
begin
  FPaperWidth := APaperWidth;
  FPaperHeight:= APaperHeight;
  FPageWidth  := APaperWidth;
  FPageHeight := APaperHeight;
  FHeight := FPageHeight;
  FWidth  := FPageWidth;
  FPaperLeftMargin := 0;
  FPaperTopMargin  := 0;
end;

procedure TMetaFilePrinter.RestorePaperSize;
begin
  {
  FPaperWidth := FSavedPaperWidth;
  FPaperHeight:= FSavedPaperHeight;
  FPageWidth  := FSavedPageWidth;
  FPageHeight := FSavedPageHeight;
  FWidth  := FPageWidth;
  FHeight := FPageHeight;
  FPaperLeftMargin := FSavedPaperLeftMargin;
  FPaperTopMargin  := FSavedPaperTopMargin;
  }
end;

{ TStandardPrinter }

constructor TStandardPrinter.Create(AOwner: TComponent);
begin
  inherited;
  //FSavedDeviceMode := nil;
end;

destructor TStandardPrinter.Destroy;
begin
  {
  if FSavedDeviceMode<>nil then
  begin
    FreeMem(FSavedDeviceMode);
    FSavedDeviceMode := nil;
  end;
  }
  inherited;
end;

procedure TStandardPrinter.BeginDoc(const Title:string='');
begin
  if FPrinter=nil then FPrinter:=Printers.Printer;
  Assert(FPrinter<>nil);
  FPrinter.Title := Title;
  FPrinter.BeginDoc;
  inherited;
end;

procedure TStandardPrinter.EndDoc;
begin
  Assert(FPrinter<>nil);
  FPrinter.EndDoc;
  inherited;
end;

procedure TStandardPrinter.AbortDoc;
begin
  Assert(FPrinter<>nil);
  FPrinter.Abort;
  inherited;
end;

function TStandardPrinter.GetPageCanvas: TCanvas;
begin
  Assert(FPrinter<>nil);
  Result := FPrinter.Canvas;
end;

procedure TStandardPrinter.NewPage;
begin
  Assert(FPrinter<>nil);
  if FPageNumber>0 then FPrinter.NewPage;
  inherited;
end;

procedure TStandardPrinter.UpdatePageSize;
begin
  if FCanvas<>nil then
    inherited
  else
  begin
    {try
      FCanvas := Printers.Printer.Canvas;
      inherited;
    finally
      FCanvas := nil;
    end;}
    //GetPageSizeFromDC(Printers.Printer.Handle);
    GetPageInfo(Printers.Printer.Handle);
  end;
end;

procedure TStandardPrinter.SetPaperSize(APaperWidth,
  APaperHeight: TFloat; AOrientation : TRPOrientation);
var
  Device, Driver, Port : array[0..255] of Char;
  DeviceMode : THandle;
  DevMode : PDeviceMode;

  procedure SetField(aField : Longword);
  begin
    DevMode^.dmFields := DevMode^.dmFields or aField;
  end;

begin
  Printers.Printer.GetPrinter(Device, Driver, Port, DeviceMode);
  DevMode := GlobalLock(DeviceMode);
  try
    {
    if FSavedDeviceMode=nil then
    begin
      GetMem(FSavedDeviceMode,SizeOf(DevMode^));
      Move(DevMode^,FSavedDeviceMode^,SizeOf(DevMode^));
    end;
    }
    SetField(dm_paperlength);
    DevMode^.dmPaperLength := Round(APaperHeight);
    SetField(dm_paperwidth);
    DevMode^.dmPaperWidth := Round(APaperWidth);

    SetField(dm_orientation);
    if AOrientation=poPortrait then
      DevMode^.dmOrientation := dmorient_portrait
    else
      DevMode^.dmOrientation := dmorient_landscape;
    Printers.Printer.SetPrinter(Device, Driver, Port, DeviceMode);
  finally
    GlobalUnlock(DeviceMode);
  end;
end;

procedure TStandardPrinter.RestorePaperSize;
var
  Device, Driver, Port : array[0..255] of Char;
  DeviceMode : THandle;
  //DevMode : PDeviceMode;
begin
  {
  if FSavedDeviceMode<>nil then
  begin
    Printers.Printer.GetPrinter(Device, Driver, Port, DeviceMode);
    DevMode := GlobalLock(DeviceMode);
    Move(FSavedDeviceMode^,DevMode^,SizeOf(DevMode^));
    Printers.Printer.SetPrinter(Device, Driver, Port, DeviceMode);
    GlobalUnlock(DeviceMode);
    FreeMem(FSavedDeviceMode);
    FSavedDeviceMode := nil;
  end;
  }
  Printers.Printer.GetPrinter(Device, Driver, Port, DeviceMode);
  Printers.Printer.SetPrinter(Device, Driver, Port, 0);
end;

end.
