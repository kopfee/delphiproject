unit UImage2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,ImgLibObjs, ExtDialogs;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edFile: TEdit;
    btnBrowse: TButton;
    btnOpen: TButton;
    btnSave: TButton;
    btnSaveStream: TButton;
    btnLoadStream: TButton;
    btnLoadData: TButton;
    btnSaveData: TButton;
    btnRotate90: TButton;
    btnRotate180: TButton;
    btnFlip: TButton;
    OpenDialog1: TOpenDialogEx;
    Label2: TLabel;
    lbResolution: TLabel;
    ILImage1: TILImageView;
    procedure btnOpenClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSaveStreamClick(Sender: TObject);
    procedure btnLoadStreamClick(Sender: TObject);
    procedure btnLoadDataClick(Sender: TObject);
    procedure btnSaveDataClick(Sender: TObject);
    procedure btnRotate90Click(Sender: TObject);
    procedure btnRotate180Click(Sender: TObject);
    procedure btnFlipClick(Sender: TObject);
    procedure ILImage1Progress(Sender: TObject; Stage: TProgressStage;
      PercentDone: Byte; RedrawNow: Boolean; const R: TRect;
      const Msg: String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses ImageLibX, UProgress;

{$R *.DFM}

procedure TForm1.btnBrowseClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    edFile.Text := OpenDialog1.FileName;
    //btnOpenClick(sender);
  end;
end;


procedure TForm1.btnOpenClick(Sender: TObject);
begin
  if edFile.text<>'' then
  begin
    dlgProgress.Start;
    try
      ILImage1.ImageObj.LoadFromFile(edFile.text);
    finally
      dlgProgress.Done;
    end;
    lbResolution.caption :=
      IntToStr(ILImage1.ImageObj.LoadResolution);
  end;
end;

procedure TForm1.btnSaveClick(Sender: TObject);
begin
  if edFile.text<>'' then
  begin
    // add code here.
    ILImage1.ImageObj.SaveToFile(edFile.text);
  end;
end;

type
  TImgLibObjAccess = class(TImgLibObj);

procedure TForm1.btnSaveStreamClick(Sender: TObject);
var
  f : TFileStream;
begin
  if edFile.text<>'' then
  begin
    // add code here.
    f := TFileStream.Create(edFile.text,fmCreate);
    ILImage1.ImageObj.ImageType := GetImageTypeFromFileExt(edFile.text);
    try
      ILImage1.ImageObj.SaveToStream(f);
    finally
      f.free;
    end;
  end;
end;

procedure TForm1.btnLoadStreamClick(Sender: TObject);
var
  f : TFileStream;
begin
  if edFile.text<>'' then
  begin
    // add code here.
    f := TFileStream.Create(edFile.text,fmOpenRead);
    try
      ILImage1.ImageObj.LoadFromStream(f);
    finally
      f.free;
    end;
    lbResolution.caption :=
      IntToStr(ILImage1.ImageObj.LoadResolution);
  end;
end;

procedure TForm1.btnLoadDataClick(Sender: TObject);
var
  f : TFileStream;
begin
  if edFile.text<>'' then
  begin
    // add code here.
    f := TFileStream.Create(edFile.text,fmOpenRead);
    try
      TImgLibObjAccess(ILImage1.ImageObj).ReadData(f);
    finally
      f.free;
    end;
    lbResolution.caption :=
      IntToStr(ILImage1.ImageObj.LoadResolution);
  end;
end;

procedure TForm1.btnSaveDataClick(Sender: TObject);
var
  f : TFileStream;
begin
  if edFile.text<>'' then
  begin
    // add code here.
    f := TFileStream.Create(edFile.text,fmCreate);
    ILImage1.ImageObj.ImageType := GetImageTypeFromFileExt(edFile.text);
    try
      TImgLibObjAccess(ILImage1.ImageObj).WriteData(f);
    finally
      f.free;
    end;
  end;
end;

(*
//Vesrion 1 : OK!
// Notes :
//ROTATEDDB90 will change the handle
procedure TForm1.btnRotate90Click(Sender: TObject);
var
  hBMP1,hBMP2         : HBitmap;
  hPAL1,hPAL2         : HPalette;
begin
  ILImage1.ImageObj.Bitmap.FreeImage;
  hBMP1:=ILImage1.ImageObj.Bitmap.Handle;
  HPAL1:=ILImage1.ImageObj.Bitmap.Palette;
  hBmp2 := hBmp1;
  HPAL2 := HPAL1;
  //HPAL2 := 0;
  ILImage1.ImageObj.Bitmap.ReleaseHandle;
  ILImage1.ImageObj.Bitmap.ReleasePalette;
  CheckImgLibCallError(ROTATEDDB90(ILImage1.ImageObj.LoadResolution,hBMP2,HPAL2,0));
  ILImage1.ImageObj.Bitmap.Palette :=HPAL2;
  ILImage1.ImageObj.Bitmap.Handle :=hBMP2;
  if hBmp1<>hBmp2 then
  begin
    deleteObject(hBmp1);
    OutputDebugString(pchar(format('Bmp:New=%d,Old=%d',[hBmp2,hBmp1])));
  end;
  if hPal1<>hPal2 then
  begin
    deleteObject(hPal1);
    OutputDebugString(pchar(format('Pal:New=%d,Old=%d',[hPal2,hPal1])));
  end;
  ILImage1.Invalidate;
end;
*)

(*
//version2 OK
procedure TForm1.btnRotate90Click(Sender: TObject);
var
  hBMP         : HBitmap;
  hPAL         : HPalette;
begin
  hBMP:=ILImage1.ImageObj.Bitmap.Handle;
  HPAL:=ILImage1.ImageObj.Bitmap.Palette;
  CheckImgLibCallError(ROTATEDDB90(ILImage1.ImageObj.LoadResolution,hBMP,HPAL,0));
  ILImage1.ImageObj.Bitmap.Palette :=HPAL;
  ILImage1.ImageObj.Bitmap.Handle :=hBMP;
  ILImage1.Invalidate;
end;
*)
procedure TForm1.btnRotate90Click(Sender: TObject);
begin
  ILImage1.ImageObj.Rotate90;
end;

procedure TForm1.btnRotate180Click(Sender: TObject);
begin
  ILImage1.ImageObj.Rotate180;
end;

procedure TForm1.btnFlipClick(Sender: TObject);
begin
  ILImage1.ImageObj.Flip;
end;

procedure TForm1.ILImage1Progress(Sender: TObject; Stage: TProgressStage;
  PercentDone: Byte; RedrawNow: Boolean; const R: TRect;
  const Msg: String);
begin
  dlgProgress.Progress(PercentDone);
  if dlgProgress.isCancel then ILImage1.ImageObj.IsCancel := true;
end;

end.
