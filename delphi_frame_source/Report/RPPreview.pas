unit RPPreview;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>RPPreview
   <What>¥Ú”°‘§¿¿¥∞ø⁄
   <Written By> Huang YanLai (ª∆—‡¿¥)
   <History>
**********************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, PrintDevices, Spin, RPDefines, ComCtrls, Buttons;

type
  TdlgPreview = class(TForm)
    ScrollBox: TScrollBox;
    Image: TImage;
    Panel1: TPanel;
    btnFirst: TSpeedButton;
    btnPrev: TSpeedButton;
    btnNext: TSpeedButton;
    btnLast: TSpeedButton;
    StatusBar: TStatusBar;
    btnPrint: TBitBtn;
    btnClose: TBitBtn;
    cbZoom: TComboBox;
    spPaper: TShape;
    spContent: TShape;
    procedure FormCreate(Sender: TObject);
    procedure btnFirstClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure cbZoomClick(Sender: TObject);
    procedure cbZoomKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FMetaFilePrinter : TMetaFilePrinter;
    FZoom: TFloat;
    FPageNumber: Integer;
    FTotal: Integer;
    FImageWidth, FImageHeight : Integer;
    FPaperWidth, FPaperHeight, FPaperTopMargin, FPaperLeftMargin : Integer;
    procedure SetZoom(const Value: TFloat);
    procedure AdjustImageSize;
    procedure UpdateDisplay;
    procedure SetPageNumber(const Value: Integer);
    procedure SetZoomValue(const ZoomValue : string);
  public
    { Public declarations }
    property  Zoom : TFloat read FZoom write SetZoom;
    property  PageNumber : Integer read FPageNumber write SetPageNumber;
    property  Total : Integer read FTotal;
    function  Execute(AMetaFilePrinter : TMetaFilePrinter):Boolean;
  end;
{
var
  dlgPreview: TdlgPreview;
}
function  Preview(AMetaFilePrinter : TMetaFilePrinter):Boolean;

const
  PreviewMargin = 16;

implementation

uses ProgressShowing;

{$R *.DFM}

function  Preview(AMetaFilePrinter : TMetaFilePrinter):Boolean;
var
  Dialog : TdlgPreview;
begin
  Assert(AMetaFilePrinter<>nil);
  Dialog := TdlgPreview.Create(Application);
  try
    TempHideProgress;
    Result := Dialog.Execute(AMetaFilePrinter);
  finally
    Dialog.Free;
  end;
end;

{ TdlgPreview }

function  TdlgPreview.Execute(AMetaFilePrinter : TMetaFilePrinter):Boolean;
begin
  //Assert(AMetaFilePrinter.PageNumber>0);
  FMetaFilePrinter := AMetaFilePrinter;
  FTotal := FMetaFilePrinter.PageNumber;
  btnPrint.Enabled := FTotal>0;
  ScrollBox.Visible := FTotal>0;
  FPageNumber := 0;
  FImageWidth:=ScreenTransform.Physics2DeviceX(FMetaFilePrinter.PageWidth);
  FImageHeight:=ScreenTransform.Physics2DeviceY(FMetaFilePrinter.PageHeight);
  FPaperWidth := ScreenTransform.Physics2DeviceX(FMetaFilePrinter.PaperWidth);
  FPaperHeight := ScreenTransform.Physics2DeviceY(FMetaFilePrinter.PaperHeight);
  FPaperLeftMargin := ScreenTransform.Physics2DeviceX(FMetaFilePrinter.PaperLeftMargin);
  FPaperTopMargin := ScreenTransform.Physics2DeviceY(FMetaFilePrinter.PaperTopMargin);
  StatusBar.Panels[1].Text := Format('%0.1fmm * %0.1fmm',[FMetaFilePrinter.PaperWidth/10,FMetaFilePrinter.PaperHeight/10]);
  StatusBar.Panels[2].Text := Format('%0.1fmm * %0.1fmm',[FMetaFilePrinter.PageWidth/10,FMetaFilePrinter.PageHeight/10]);
  UpdateDisplay;
  FZoom := 1;
  cbZoom.ItemIndex := 2;
  cbZoomClick(Self);
  //cbZoom.Text := '100%';
  AdjustImageSize;
  {
  with FMetaFilePrinter.MetaFiles[FPageNumber] do
  begin
    WriteLog(Format('Width=%f,Height=%f',[MMWidth/10, MMHeight/10]),lcReport);
    WriteLog(Format('ImageWidth=%d,ImageHeight=%d',[Width, Height]),lcReport);
  end;
  WriteLog(Format('FImageWidth=%d,FImageHeight=%d',[FImageWidth, FImageHeight]),lcReport);
  }
  Result := ShowModal=mrOK;
end;

procedure TdlgPreview.SetZoom(const Value: TFloat);
begin
  if (FZoom<>Value) and (FZoom>0) then
  begin
    FZoom := Value;
    AdjustImageSize;
  end;
end;

procedure TdlgPreview.FormCreate(Sender: TObject);
begin
  FZoom := 1;
end;

procedure TdlgPreview.AdjustImageSize;
var
  W, H : Integer;
  PW,PH : Integer;
  LM, TM : Integer;
begin
  {W := Round(Image.Picture.Width*FZoom);
  H := Round(Image.Picture.Height*FZoom);}
  W := Round(FImageWidth*FZoom);
  H := Round(FImageHeight*FZoom);
  PW := Round(FPaperWidth * FZoom);
  PH := Round(FPaperHeight * FZoom);
  LM := Round(FPaperLeftMargin * FZoom);
  TM := Round(FPaperTopMargin * FZoom);
  ScrollBox.HorzScrollBar.Position := 0;
  ScrollBox.VertScrollBar.Position := 0;
  Image.SetBounds(PreviewMargin + LM,PreviewMargin+ TM,W,H);
  spContent.SetBounds(PreviewMargin + LM,PreviewMargin+ TM,W,H);
  spPaper.SetBounds(PreviewMargin ,PreviewMargin,PW,PH);
  ScrollBox.HorzScrollBar.Range := PW + 2 * PreviewMargin;
  ScrollBox.VertScrollBar.Range := PH + 2 * PreviewMargin;
  //OutputDebugString(Pchar(Format('%d,%d',[Image.Width,Image.Height])));
end;

procedure TdlgPreview.SetPageNumber(const Value: Integer);
begin
  if (Value>=0) and (Value<Total) then
  begin
    FPageNumber := Value;
    UpdateDisplay;
  end;
end;

procedure TdlgPreview.UpdateDisplay;
begin
  if FMetaFilePrinter.PageNumber>0 then
  begin
    Image.Picture.Metafile := FMetaFilePrinter.MetaFiles[FPageNumber];
    StatusBar.Panels[0].Text := Format('%d / %d',[PageNumber+1, Total]);
  end else
  begin
    Image.Picture.Graphic := nil;
    StatusBar.Panels[0].Text := Format('%d / %d',[0, Total]);
  end;

  btnFirst.Enabled := (PageNumber>0) and (Total>0);
  btnPrev.Enabled := (PageNumber>0) and (Total>0);
  btnNext.Enabled := PageNumber<Total-1;
  btnLast.Enabled := PageNumber<Total-1;
end;

procedure TdlgPreview.btnFirstClick(Sender: TObject);
begin
  PageNumber := 0;
end;

procedure TdlgPreview.btnPrevClick(Sender: TObject);
begin
  PageNumber := PageNumber -1;
end;

procedure TdlgPreview.btnNextClick(Sender: TObject);
begin
  PageNumber := PageNumber +1;
end;

procedure TdlgPreview.btnLastClick(Sender: TObject);
begin
  PageNumber := Total-1;
end;

procedure TdlgPreview.cbZoomClick(Sender: TObject);
begin
  case cbZoom.ItemIndex of
    0 : Zoom := (ScrollBox.ClientWidth - 2 * PreviewMargin) / FPaperWidth;
    1 : Zoom := (ScrollBox.ClientHeight - 2 * PreviewMargin) / FPaperHeight;
  else
    SetZoomValue(cbZoom.Text);
  end;
end;

procedure TdlgPreview.SetZoomValue(const ZoomValue: string);
var
  i, Per : integer;
  ValueStr : string;
begin
  i := pos('%',ZoomValue);
  if i>0 then
    ValueStr := copy(ZoomValue,1,i-1)
  else
    ValueStr := ZoomValue;
  Per := StrToIntDef(ValueStr,100);
  cbZoom.Text := IntToStr(Per)+'%';
  Zoom := Per / 100;
end;

procedure TdlgPreview.cbZoomKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
  begin
    Key := #0;
    SetZoomValue(cbZoom.Text);
  end;
end;

end.
