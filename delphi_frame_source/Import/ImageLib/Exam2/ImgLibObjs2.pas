unit ImgLibObjs2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,ImageLibX,Controls;

{ Wrap the ImageLib functions
}

const
  ESGetInfo = 'Get Image Info';
  ESLoad = 'Load Image';
  ESSave = 'Save Image';
  ESOther = 'Other Operation';

procedure CheckImgLibCallError(ReturnCode : SmallInt);

procedure CheckImgLibCallErrorEx(Const ErrorStr:string;ReturnCode : SmallInt);

type
	TFileTypeStr = array[0..5] of char;
  TCompressTypeStr = array[0..10] of char;
  TImageType = (imUnknown,imJPEG, imGIF, imBMP, imPCX, imPNG,imTIFF);
  TImgLibError = class(Exception);

  TImgLibObj = class(TGraphic)
  private
    FDither:	  boolean;
    FSaveResolution: integer;
    FBitmap: 		TBitmap;
    FHeight:    SmallInt;
    FWidth:     SmallInt;
    FCompressType: TCompressTypeStr;
    FFileTypeStr: TFileTypeStr;
    FAutoResolution: boolean;
    FSize: LongInt;
    FImageType: TImageType;
    FBitsPixel: SmallInt;
    FPlanes: SmallInt;
    FNumColors: SmallInt;
    FQuality: smallInt;
    Fstripsize: word;
    Fcompression: word;
    Finterlaced: smallInt;
    FAutoImageType: boolean;
    FShowErrorInt : smallInt;
    FLoadResolution: integer;
    FProgressed: boolean;
    //get ImageType based on FileTypeStr, and SaveResolution
    procedure   UpdateInfo;
    //create a memory stream to copy stream, then call ReadBuffer
    procedure   ReadStream(Stream : TStream);
    //call internalRead
    procedure   ReadBuffer(Buffer : pointer);
    //call internalWrite
    procedure   WriteBuffer(Buffer : pointer;MaxSize:integer);
    function    GetTransparentColor: TColor;
    function    GetTransparentMode: TTransparentMode;
    procedure   SetTransparentColor(const Value: TColor);
    procedure   SetTransparentMode(const Value: TTransparentMode);
    procedure   SetShowError(const Value: boolean);
    function    GetShowError: boolean;

    function    StartLoading:boolean;
    function    EndLoading(hBmp : HBitmap; hPal :HPalette): boolean;
  protected
    LastPercent : integer;
    Callback :  TImgLibCallBackFunction;
    FIsCancel :  boolean;
    // override inherited methods
    procedure   Draw(ACanvas: TCanvas; const Rect: TRect); override;
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
    //Read/Write in Delphi Resource Stream
    //get Size, then call ReadStream
    procedure   ReadData(Stream: TStream); override;
    //write size, then call SaveToStream, then write size again
    procedure   WriteData(Stream: TStream); override;

    procedure 	InternalLoadDIB(const FileName:string;var hBmp : HBitmap);virtual;
    procedure 	InternalLoadDDB(const FileName:string;var hBmp : HBitmap; var hPal:HPalette);virtual;
    procedure 	InternalSaveDIB(const FileName:string;hBitmap,hPal : THandle);virtual;
    procedure 	InternalSaveDDB(const FileName:string;hBitmap,hPal : THandle);virtual;
    procedure 	InternalLoadBufferDIB(Buffer:pointer;var hBmp : HBitmap);virtual;
    procedure 	InternalLoadBufferDDB(Buffer:pointer;var hBmp : HBitmap;var hPal : HPalette);virtual;
    procedure 	InternalSaveBufferDIB(Buffer:pointer;MaxSize:integer;hBitmap,hPal : THandle);virtual;
    procedure 	InternalSaveBufferDDB(Buffer:pointer;MaxSize:integer;hBitmap,hPal : THandle);virtual;
    function    GetMaxSaveSize: integer; dynamic;

    procedure   DoProgress(Percent : integer; var isContinue:boolean);
  public
    constructor Create; override;
    Destructor 	Destroy;override;
  	procedure 	Assign(Source: TPersistent); override;
    procedure   Clear;

    property  	Bitmap : TBitmap read FBitmap;
    // these properties are used only in Read/Write
    property    Size : LongInt read FSize;
    //return the FHeight and FWidth, that may differ from the values of Bitmap
    function    GetInternalHeight: Integer;
    function    GetInternalWidth: Integer;

    property		FileTypeStr : TFileTypeStr read FFileTypeStr write FFileTypeStr;
    property  	CompressType: TCompressTypeStr read FCompressType write FCompressType;
    { compression :      1 - No compression
                   2 - CCITT compression (1 bit; not supported at this time)
                   5 - LZW compression
                   32773 - PackBits compression
    }
    property    compression : word read Fcompression write Fcompression;
    {  An integer value indicating the number of different strips
      to separate the image into. }
    property    stripsize : word read Fstripsize write Fstripsize;
    property    interlaced : smallInt read Finterlaced write Finterlaced;
    property    BitsPixel : SmallInt read FBitsPixel;
    property    Planes    : SmallInt read FPlanes ;
    property    NumColors : SmallInt read FNumColors;

    //Call set FileName then GetInfo;
    procedure 	GetFileInfo(const AFileName:string);

    //these methods may change the size .

    //LoadFromFile call InternalLoad
    procedure 	LoadFromFile(const AFileName:string); override;
    //SaveToFile call InternalSave
    procedure 	SaveToFile(const AFileName:string); override;
    //size = Stream.Size-Stream.Position, call ReadStream
    procedure   LoadFromStream(Stream: TStream); override;
    //call WriteBuffer to write into a Sharedmem,then copy to Stream
    procedure   SaveToStream(Stream: TStream); override;

    procedure   LoadFromClipboardFormat(AFormat: Word; AData: THandle;
                  APalette: HPALETTE); override;
    procedure   SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
                  var APalette: HPALETTE); override;

    procedure   Rotate90;
    procedure   Rotate180;
    procedure   Flip;
    property    IsCancel :  boolean read FIsCancel write FIsCancel;
  published
    // auto SaveResolution when load from file or stream
    property    AutoResolution : boolean read FAutoResolution write FAutoResolution default true;
    // auto imageType when save to file
    property    AutoImageType : boolean read FAutoImageType write FAutoImageType default true;
    // resolution for load/save
    property    LoadResolution : integer read FLoadResolution write FLoadResolution default 8;
    property  	SaveResolution : integer read FSaveResolution write FSaveResolution default 8;
    property		Dither : boolean read FDither write FDither;
    property    ImageType   : TImageType read FImageType write FImageType;
    property    Quality : smallInt read FQuality write FQuality default 75;
    property    ShowError : boolean read GetShowError write SetShowError default false;

    property    TransparentColor: TColor read GetTransparentColor Write SetTransparentColor;
    property    TransparentMode: TTransparentMode read GetTransparentMode Write SetTransparentMode default tmAuto;
    property    Progressed : boolean read FProgressed write FProgressed;
  end;

const
  {TIFF compression :      1 - No compression
                   2 - CCITT compression (1 bit; not supported at this time)
                   5 - LZW compression
                   32773 - PackBits compression}
  cmpNo = 1;
  cmpCCITT = 2;
  cmpLZW = 5;
  cmpPackBits = 32773;

function  GetImageTypeFromFileExt(const FileName:string): TImageType;

type
  TILImage = class(TGraphicControl)
  private
    FImageObj: TImgLibObj;
    FStretch: Boolean;
    FScale: boolean;
    FCenter: boolean;
    procedure   SetImageObj(const Value: TImgLibObj);
    procedure   Changed(sender : TObject);
    procedure   SetStretch(const Value: Boolean);
    procedure   SetScale(const Value: boolean);
    procedure   SetTransparent(const Value: Boolean);
    function    GetTransparent: Boolean;
    procedure   SetCenter(const Value: boolean);
    function    GetOnProgress: TProgressEvent;
    procedure   SetOnProgress(const Value: TProgressEvent);
  protected
    procedure   Paint; override;
    function    CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
  published
    property    ImageObj  : TImgLibObj read FImageObj write SetImageObj;
    property    Transparent: Boolean read GetTransparent write SetTransparent default False;
    { Stretch  Scale
         F       F        显示原始大小
         F       T        如果图象大于显示区域，缩小显示大小，保持长宽比
         T       F        放缩图象，不保持长宽比
         T       T        放缩图象，保持长宽比
    }
    property    Stretch: Boolean read FStretch write SetStretch default False;
    property    Scale : boolean read FScale write SetScale default true;
    property    Center : boolean read FCenter write SetCenter default true;

    property Align;
    property Anchors;
    property AutoSize;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    //property IncrementalDisplay: Boolean read FIncrementalDisplay write FIncrementalDisplay default False;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    //property Stretch: Boolean read FStretch write SetStretch default False;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnProgress: TProgressEvent read GetOnProgress write SetOnProgress;
    property OnStartDock;
    property OnStartDrag;
  end;


implementation

uses ExtUtils,IPCUtils;

procedure CheckImgLibCallError(ReturnCode : SmallInt);
begin
  if ReturnCode<=0 then
    raise TImgLibError.Create('ImageLibCall Error('+IntToStr(ReturnCode)+')!');
end;

procedure CheckImgLibCallErrorEx(Const ErrorStr:string;ReturnCode : SmallInt);
begin
  if ReturnCode<=0 then
    raise TImgLibError.Create('ImageLibCall Error in '+'('+ErrorStr+':'+IntToStr(ReturnCode)+')');
end;

procedure InvalidOperation;
begin
  raise EInvalidGraphicOperation.Create('Invalid Operation');
end;

procedure RegisterFileExt;
begin
  TPicture.RegisterFileFormat('GIF','GIF File',TImgLibObj);
  TPicture.RegisterFileFormat('PCX','PCX File',TImgLibObj);
  TPicture.RegisterFileFormat('TIF','TIF File',TImgLibObj);
  TPicture.RegisterFileFormat('PNG','PNG File',TImgLibObj);
  {TPicture.RegisterFileFormat('JPG','ImageLib JPEG File',TImgLibObj);
  TPicture.RegisterFileFormat('JPEG','ImageLib JPEG File',TImgLibObj);
  TPicture.RegisterFileFormat('BMP','ImageLib BMP File',TImgLibObj);  }
end;

procedure UnRegisterFileExt;
begin
  TPicture.UnregisterGraphicClass(TImgLibObj);
end;


function  GetImageTypeFromFileExt(const FileName:string): TImageType;
var
  Ext : string;
begin
  Ext := Uppercase(ExtractFileExt(FileName));
  if ext='.BMP' then result := imBMP
  else if ext='.PCX' then result := imPCX
  else if ext='.PNG' then result := imPNG
  else if ext='.GIF' then result := imGIF
  else if (ext='.JPG') or (ext='.JPEG') then result := imJPEG
  else if (ext='.TIF') or (ext='.TIFF') then result := imTIFF
  else result := imUnknown;
end;

threadvar
  ProgressImgObj : TImgLibObj;

function ImgLibProgress(I : Integer) : Integer cdecl;
var
  isContinue : boolean;
begin
  if ProgressImgObj<>nil then
    try
      isContinue := true;
      ProgressImgObj.DoProgress(i,isContinue);
      if isContinue then
        result := 1
      else
        result := 0;
    except
      result := 0;
    end
  else result := 0;
end;

{ TImgLibObj }

procedure TImgLibObj.Assign(Source: TPersistent);
begin
  if Source is TImgLibObj then
  with Source as TImgLibObj do
  begin
    self.Fsize := size;
    self.Fwidth := width;
    self.Fheight := height;
    self.FAutoResolution := AutoResolution;
    self.FAutoImageType := AutoImageType;
    self.FSaveResolution := SaveResolution;
    self.FLoadResolution := LoadResolution;
    self.FDither := Dither;
    self.FImageType := ImageType;
    self.FBitsPixel := BitsPixel;
    self.FPlanes := Planes;
    self.FNumColors := FNumColors;
    self.FQuality := Quality;
    self.Fstripsize := stripsize;
    self.Fcompression := compression;
    self.Finterlaced := interlaced;
    self.Bitmap.Assign(Bitmap);
  end
  else if Source is TBitmap then
    Bitmap.Assign(Source)
  else if source=nil then
  begin
    Clear;
  end
  else inherited Assign(Source);
end;

constructor TImgLibObj.Create;
begin
  inherited Create;
  FBitmap := TBitmap.Create;
  FBitmap.HandleType:=bmDDB;
  FBitmap.OnChange := Changed;
  FSize := 0;
  FAutoResolution := true;
  FAutoImageType := true;
  FDither := true;
  FImageType := imGIF;
  FQuality := 75;
  Fcompression := cmpLZW;
  Fstripsize := 10;
  Finterlaced := 1;
  FShowErrorInt := 0;
  FLoadResolution := 8;
  FSaveResolution := 8;
  TransparentMode := tmAuto;
end;

destructor TImgLibObj.Destroy;
begin
  FBitmap.free;
  inherited Destroy;
end;

procedure TImgLibObj.GetFileInfo(const AFileName: string);
begin
  FillMemory(@FFileTypeStr,sizeof(TFileTypeStr),0);
  CheckImgLibCallErrorEx(ESGetInfo,
    ImageLibX.fileinfo(
      pchar(AFileName),
      pchar(@FFileTypeStr),
      FWidth,FHeight,
      Fbitspixel,
      Fplanes,
      Fnumcolors,
      pchar(@FCompressType),
      0)
   );
  FSize := GetFileSize(AFileName);
  UpdateInfo;
end;

procedure TImgLibObj.LoadFromFile(const AFileName: string);
var
	hBmp : HBitmap;
  hPal : HPalette;
  {$ifdef speed}
  _LastTick,_CurTick : integer;
  {$endif}
begin
  hBmp := 0;
  hPal := 0;
  //FFileName := AFileName;
  GetFileInfo(AFileName);
  if StartLoading then
  begin
    if Bitmap.HandleType=bmDIB then
    begin
      {$ifdef speed}
      _LastTick := GetTickCount;
      outputDebugString(pchar('before load'+IntToStr(_LastTick)));
      {$endif}
      InternalLoadDIB(AFileName,hBmp);
      {$ifdef speed}
      _curTick:=GetTickCount;
      outputDebugString(pchar(format('after load:%d,%d',[_curTick,_curTick-_lastTick])));
      _lastTick:=_curTick;
      {$endif}
      if EndLoading(hBmp,hPal) then
        Bitmap.Handle:=hBmp;
      {$ifdef speed}
      _curTick:=GetTickCount;
      outputDebugString(pchar(format('after set to bitmap:%d,%d',[_curTick,_curTick-_lastTick])));
      _lastTick:=_curTick;
      {$endif}
    end
    else
    begin
      {$ifdef speed}
      _LastTick := GetTickCount;
      outputDebugString(pchar('before load'+IntToStr(_LastTick)));
      {$endif}
      InternalLoadDDB(AFileName,hBmp,hPal);
      {$ifdef speed}
      _curTick:=GetTickCount;
      outputDebugString(pchar(format('after load:%d,%d',[_curTick,_curTick-_lastTick])));
      _lastTick:=_curTick;
      {$endif}
      if EndLoading(hBmp,hPal) then
      begin
        Bitmap.Handle:=hBmp;
        Bitmap.Palette :=hPal;
      end;
      {$ifdef speed}
      _curTick:=GetTickCount;
      outputDebugString(pchar(format('after set to bitmap:%d,%d',[_curTick,_curTick-_lastTick])));
      _lastTick:=_curTick;
      {$endif}
    end;
    Changed(self);
  end;
end;

procedure TImgLibObj.SaveToFile(const AFileName: string);
var
  im : TImageType;
begin
  //FFileName := AFileName;
  if AutoImageType then
  begin
    im := GetImageTypeFromFileExt(AFileName);
    if im<>imUnknown then
      ImageType := im;
  end;
  if Bitmap.HandleType=bmDIB then
  	InternalSaveDIB(AFileName,Bitmap.Handle,Bitmap.Palette)
  else
		InternalSaveDDB(AFileName,Bitmap.Handle,Bitmap.Palette);
  Modified := false;
end;


type
  TBitmapAccess = class(TBitmap);

procedure TImgLibObj.Draw(ACanvas: TCanvas; const Rect: TRect);
begin
  TBitmapAccess(FBitmap).Draw(ACanvas,Rect);
end;

function TImgLibObj.GetEmpty: Boolean;
begin
  result := FSize=0;
end;

function TImgLibObj.GetHeight: Integer;
begin
  result := Bitmap.Height;
end;

function TImgLibObj.GetWidth: Integer;
begin
  result := Bitmap.Width;
end;

function TImgLibObj.GetInternalHeight: Integer;
begin
  result := FHeight;
end;

function TImgLibObj.GetInternalWidth: Integer;
begin
  result := FWidth;
end;

procedure TImgLibObj.SetHeight(Value: Integer);
begin
  InvalidOperation;
end;

function TImgLibObj.GetTransparent: boolean;
begin
  result := FBitmap.Transparent;
end;

procedure TImgLibObj.SetTransparent(Value: Boolean);
begin
  FBitmap.Transparent := value;
end;

procedure TImgLibObj.SetWidth(Value: Integer);
begin
  InvalidOperation;
end;


procedure TImgLibObj.UpdateInfo;
begin
  if StrIComp(FFileTypeStr,'BMP')=0 then
    FImageType := imBMP
  else if StrIComp(FFileTypeStr,'JPEG')=0 then
    FImageType := imJPEG
  else if StrIComp(FFileTypeStr,'TIFF')=0 then
    FImageType := imTIFF
  else if StrIComp(FFileTypeStr,'PCX')=0 then
    FImageType := imPCX
  else if StrIComp(FFileTypeStr,'PNG')=0 then
    FImageType := imPNG
  else if StrIComp(FFileTypeStr,'GIF')=0 then
    FImageType := imGIF
  else
    FImageType := imTIFF;
  //else InvalidOperation;
  if AutoResolution then
    LoadResolution:=Fbitspixel;
end;

procedure TImgLibObj.InternalLoadDDB(const FileName:string;var hBmp : HBitmap; var hPal:HPalette);
var
  theDither : smallInt;
begin
  if Dither then
    theDither := 1
  else
    theDither := 0;
  case FImageType of
    imJPEG:  CheckImgLibCallErrorEx(EsLoad,readJPGfile(pchar(FileName),LoadResolution,1,theDither,hBmp,hPal,Callback,FShowErrorInt));
    imGIF:   CheckImgLibCallErrorEx(EsLoad,readGIFfile(pchar(FileName),LoadResolution,theDither,hBmp,hPal,Callback,FShowErrorInt,unilzw));
    imBMP:   CheckImgLibCallErrorEx(EsLoad,readBMPfile(pchar(FileName),LoadResolution,theDither,hBmp,hPal,Callback,FShowErrorInt));
    imPCX:   CheckImgLibCallErrorEx(EsLoad,readPCXfile(pchar(FileName),LoadResolution,theDither,hBmp,hPal,Callback,FShowErrorInt));
    imPNG:   CheckImgLibCallErrorEx(EsLoad,readpngfile(pchar(FileName),LoadResolution,theDither,hBmp,hPal,Callback,FShowErrorInt));
    imTIFF:  CheckImgLibCallErrorEx(EsLoad,readTIFfile(pchar(FileName),LoadResolution,theDither,hBmp,hPal,Callback,FShowErrorInt,unilzw));
  end;
end;

procedure TImgLibObj.InternalLoadDIB(const FileName:string;var hBmp: HBitmap);
var
  theDither : smallInt;
begin
  if Dither then
    theDither := 1
  else
    theDither := 0;
  case FImageType of
    imJPEG:  CheckImgLibCallErrorEx(EsLoad,RDJPGfileDIB(pchar(FileName),LoadResolution,1,TheDither,hBmp,0,Callback,FShowErrorInt));
    imGIF:   CheckImgLibCallErrorEx(EsLoad,RDGIFfileDIB(pchar(FileName),LoadResolution,TheDither,hBmp,0,Callback,FShowErrorInt,unilzw));
    imBMP:   CheckImgLibCallErrorEx(EsLoad,RDBMPfileDIB(pchar(FileName),LoadResolution,TheDither,hBmp,0,Callback,FShowErrorInt));
    imPCX:   CheckImgLibCallErrorEx(EsLoad,RDPCXfileDIB(pchar(FileName),LoadResolution,TheDither,hBmp,0,Callback,FShowErrorInt));
    imPNG:   CheckImgLibCallErrorEx(EsLoad,RDpngfileDIB(pchar(FileName),LoadResolution,TheDither,hBmp,0,Callback,FShowErrorInt));
    imTIFF:  CheckImgLibCallErrorEx(EsLoad,RDTIFfileDIB(pchar(FileName),LoadResolution,TheDither,hBmp,0,Callback,FShowErrorInt,unilzw));
  end;
end;

procedure TImgLibObj.InternalSaveDDB(const FileName:string;hBitmap, hPal: THandle);
begin
  case FImageType of
    imJPEG:  CheckImgLibCallErrorEx(ESSave,WriteJPGfile(pchar(FileName),Quality,1,SaveResolution,hBitmap,hPal,nil,FShowErrorInt));
    imGIF:   CheckImgLibCallErrorEx(ESSave,WriteGIFfile(pchar(FileName),SaveResolution,hBitmap,hPal,nil,FShowErrorInt,unilzw));
    imBMP:   CheckImgLibCallErrorEx(ESSave,WriteBMPfile(pchar(FileName),SaveResolution,hBitmap,hPal,nil,FShowErrorInt));
    imPCX:   CheckImgLibCallErrorEx(ESSave,WritePCXfile(pchar(FileName),SaveResolution,hBitmap,hPal,nil,FShowErrorInt));
    imPNG:   CheckImgLibCallErrorEx(ESSave,Writepngfile(pchar(FileName),SaveResolution,interlaced,hBitmap,hPal,nil,FShowErrorInt));
    imTIFF:  CheckImgLibCallErrorEx(ESSave,WriteTIFfile(pchar(FileName),compression,stripsize,SaveResolution,hBitmap,hPal,nil,FShowErrorInt,unilzw));
  end;
end;

procedure TImgLibObj.InternalSaveDIB(const FileName:string;hBitmap, hPal: THandle);
begin
  case FImageType of
    imJPEG:  CheckImgLibCallErrorEx(ESSave,WrJPGfileDIB(pchar(FileName),Quality,1,SaveResolution,hBitmap,nil,FShowErrorInt));
    imGIF:   CheckImgLibCallErrorEx(ESSave,WrGIFfileDIB(pchar(FileName),SaveResolution,hBitmap,nil,FShowErrorInt,unilzw));
    imBMP:   CheckImgLibCallErrorEx(ESSave,WrBMPfileDIB(pchar(FileName),SaveResolution,hBitmap,nil,FShowErrorInt));
    imPCX:   CheckImgLibCallErrorEx(ESSave,WrPCXfileDIB(pchar(FileName),SaveResolution,hBitmap,nil,FShowErrorInt));
    imPNG:   CheckImgLibCallErrorEx(ESSave,WrpngfileDIB(pchar(FileName),SaveResolution,interlaced,hBitmap,nil,FShowErrorInt));
    imTIFF:  CheckImgLibCallErrorEx(ESSave,WrTIFfileDIB(pchar(FileName),compression,stripsize,SaveResolution,hBitmap,nil,FShowErrorInt,unilzw));
  end;
end;

function TImgLibObj.GetPalette: HPALETTE;
begin
  result := Bitmap.Palette;
end;

procedure TImgLibObj.SetPalette(Value: HPALETTE);
begin
  Bitmap.Palette := value;
end;

procedure TImgLibObj.LoadFromStream(Stream: TStream);
begin
  Fsize := Stream.Size-Stream.Position;
  ReadStream(Stream);
end;

procedure TImgLibObj.SaveToStream(Stream: TStream);
{var
  Memory : TMemoryStream;
begin
  Memory := TMemoryStream.Create;
  try
    Memory.Position := 0;
    Memory.size := Size;
    WriteBuffer(Memory.Memory);
    Memory.size := size;
    Memory.Position := 0;
    Stream.CopyFrom(Memory,size);
  finally
    Memory.free;
  end;
end;
}
var
  Memory : TSharedMem;
  MaxSize : integer;
begin
  MaxSize := GetMaxSaveSize;
  Memory := TSharedMem.Create('',MaxSize);
  try
    WriteBuffer(Memory.Buffer,MaxSize);
    Stream.WriteBuffer(Memory.Buffer^,size);
  finally
    Memory.free;
  end;
  Modified := false;
end;

procedure TImgLibObj.ReadData(Stream: TStream);
begin
  Stream.Read(FSize, SizeOf(FSize));
  ReadStream(Stream);
end;

procedure TImgLibObj.WriteData(Stream: TStream);
var
  p1,p2 : integer;
begin
  //Stream.Write(FImageType,sizeof(FImageType));
  p1 := Stream.Position;
  Stream.WriteBuffer(FSize, SizeOf(FSize));
  SaveToStream(Stream);
  p2 := Stream.Position;
  Stream.Position := p1;
  Stream.WriteBuffer(FSize, SizeOf(FSize));
  Stream.Position := p2;
  //assert(FSize+sizeof(FSize)=p2-p1);
  if (FSize+sizeof(FSize))<>(p2-p1) then
    raise exception.create(
      format('size=%d,p1=%d,p2=%d',[size,p1,p2])
    );
end;

procedure TImgLibObj.ReadStream(Stream: TStream);
var
  Memory : TMemoryStream;
begin
  Memory := TMemoryStream.Create;
  try
    Memory.position := 0;
    Memory.CopyFrom(Stream,size);
    FillMemory(@FFileTypeStr,sizeof(TFileTypeStr),0);
    CheckImgLibCallErrorEx(ESGetInfo,
      ImageLibX.streaminfo(
        Memory.Memory,
        size,
        pchar(@FFileTypeStr),
        FWidth,FHeight,
        Fbitspixel,
        Fplanes,
        Fnumcolors,
        pchar(@CompressType),
        0)
     );
    UpdateInfo;
    ReadBuffer(Memory.Memory);
  finally
    Memory.free;
  end;
end;

procedure TImgLibObj.ReadBuffer(Buffer: pointer);
var
	hBmp: HBitmap;
  hPal : hPalette;
begin
  hBmp := 0;
  hPal := 0;
  if Bitmap.HandleType=bmDIB then
  begin
    InternalLoadBufferDIB(Buffer,hBmp);
    Bitmap.Handle:=hBmp;
  end
  else
  begin
    InternalLoadBufferDDB(Buffer,hBmp,hPal);
    Bitmap.Handle:=hBmp;
    Bitmap.Palette :=hPal;
  end;
  Changed(self);
end;

procedure TImgLibObj.InternalLoadBufferDDB(Buffer: pointer; var hBmp : HBitmap;var hPal : HPalette);
var
  theDither : smallInt;
begin
  if Dither then
    theDither := 1
  else
    theDither := 0;
  case FImageType of
    imJPEG:  CheckImgLibCallErrorEx(EsLoad,readJPGStream(pchar(Buffer),size,LoadResolution,1,theDither,hBmp,hPal,nil,FShowErrorInt));
    imGIF:   CheckImgLibCallErrorEx(EsLoad,readGIFStream(pchar(Buffer),size,LoadResolution,theDither,hBmp,hPal,nil,FShowErrorInt,unilzw));
    imBMP:   CheckImgLibCallErrorEx(EsLoad,readBMPStream(pchar(Buffer),size,LoadResolution,theDither,hBmp,hPal,nil,FShowErrorInt));
    imPCX:   CheckImgLibCallErrorEx(EsLoad,readPCXStream(pchar(Buffer),size,LoadResolution,theDither,hBmp,hPal,nil,FShowErrorInt));
    imPNG:   CheckImgLibCallErrorEx(EsLoad,readpngStream(pchar(Buffer),size,LoadResolution,theDither,hBmp,hPal,nil,FShowErrorInt));
    imTIFF:  CheckImgLibCallErrorEx(EsLoad,readTIFStream(pchar(Buffer),size,LoadResolution,theDither,hBmp,hPal,nil,FShowErrorInt,unilzw));
  end;
end;

procedure TImgLibObj.InternalLoadBufferDIB(Buffer: pointer;
  var hBmp : HBitmap);
var
  theDither : smallInt;
begin
  if Dither then
    theDither := 1
  else
    theDither := 0;
  case FImageType of
    imJPEG:  CheckImgLibCallErrorEx(EsLoad,RDJPGStreamDIB(pchar(Buffer),size,LoadResolution,1,theDither,hBmp,nil,FShowErrorInt));
    imGIF:   CheckImgLibCallErrorEx(EsLoad,RDGIFStreamDIB(pchar(Buffer),size,LoadResolution,theDither,hBmp,nil,FShowErrorInt,unilzw));
    imBMP:   CheckImgLibCallErrorEx(EsLoad,RDBMPStreamDIB(pchar(Buffer),size,LoadResolution,theDither,hBmp,nil,FShowErrorInt));
    imPCX:   CheckImgLibCallErrorEx(EsLoad,RDPCXStreamDIB(pchar(Buffer),size,LoadResolution,theDither,hBmp,nil,FShowErrorInt));
    imPNG:   CheckImgLibCallErrorEx(EsLoad,RDpngStreamDIB(pchar(Buffer),size,LoadResolution,theDither,hBmp,nil,FShowErrorInt));
    imTIFF:  CheckImgLibCallErrorEx(EsLoad,RDTIFStreamDIB(pchar(Buffer),size,LoadResolution,theDither,hBmp,nil,FShowErrorInt,unilzw));
  end;
end;

procedure TImgLibObj.InternalSaveBufferDDB(Buffer: pointer; MaxSize:integer;hBitmap,
  hPal: THandle);
begin
  case FImageType of
    imJPEG:  CheckImgLibCallErrorEx(ESSave,WritejpgStream(pchar(Buffer),MaxSize,Quality,1,SaveResolution,hBitmap,hPal,nil,FShowErrorInt));
    imGIF:   CheckImgLibCallErrorEx(ESSave,WriteGIFStream(pchar(Buffer),MaxSize,SaveResolution,hBitmap,hPal,nil,FShowErrorInt,unilzw));
    imBMP:   CheckImgLibCallErrorEx(ESSave,WriteBMPStream(pchar(Buffer),MaxSize,SaveResolution,hBitmap,hPal,nil,FShowErrorInt));
    imPCX:   CheckImgLibCallErrorEx(ESSave,WritePCXStream(pchar(Buffer),MaxSize,SaveResolution,hBitmap,hPal,nil,FShowErrorInt));
    imPNG:   CheckImgLibCallErrorEx(ESSave,WritepngStream(pchar(Buffer),MaxSize,SaveResolution,interlaced,hBitmap,hPal,nil,FShowErrorInt));
    imTIFF:  CheckImgLibCallErrorEx(ESSave,WriteTIFStream(pchar(Buffer),MaxSize,compression,stripsize,SaveResolution,hBitmap,hPal,nil,FShowErrorInt,unilzw));
  else
    exit;
  end;
  FSize := MaxSize;
end;

procedure TImgLibObj.InternalSaveBufferDIB(Buffer: pointer; MaxSize:integer;hBitmap,
  hPal: THandle);
begin
  case FImageType of
    imJPEG:  CheckImgLibCallErrorEx(ESSave,WrjpgStreamDIB(pchar(Buffer),MaxSize,Quality,1,SaveResolution,hBitmap,nil,FShowErrorInt));
    imGIF:   CheckImgLibCallErrorEx(ESSave,WrGIFStreamDIB(pchar(Buffer),MaxSize,SaveResolution,hBitmap,nil,FShowErrorInt,unilzw));
    imBMP:   CheckImgLibCallErrorEx(ESSave,WrBMPStreamDIB(pchar(Buffer),MaxSize,SaveResolution,hBitmap,nil,FShowErrorInt));
    imPCX:   CheckImgLibCallErrorEx(ESSave,WrPCXStreamDIB(pchar(Buffer),MaxSize,SaveResolution,hBitmap,nil,FShowErrorInt));
    imPNG:   CheckImgLibCallErrorEx(ESSave,WrpngStreamDIB(pchar(Buffer),MaxSize,SaveResolution,interlaced,hBitmap,nil,FShowErrorInt));
    imTIFF:  CheckImgLibCallErrorEx(ESSave,WrTIFStreamDIB(pchar(Buffer),MaxSize,compression,stripsize,SaveResolution,hBitmap,nil,FShowErrorInt,unilzw));
  else
    exit;
  end;
  FSize := MaxSize;
end;

procedure TImgLibObj.WriteBuffer(Buffer: pointer;MaxSize:integer);
var
	hBmp: HBitmap;
  hPal : hPalette;
begin
  hBmp := Bitmap.Handle;
  hPal := Bitmap.Palette;
  if Bitmap.HandleType=bmDIB then
    InternalSaveBufferDIB(Buffer,MaxSize,hBmp,hPal)
  else
    InternalSaveBufferDDB(Buffer,MaxSize,hBmp,hPal);
end;


const
  MaxHeaderSize = 1024;
  PalSize = 256*4;

function TImgLibObj.GetMaxSaveSize: integer;
var
  W,H : integer;
  BitsPixels : integer;
  LineSize : integer;
begin
  W := Bitmap.width;
  H := Bitmap.Height;
  BitsPixels := SaveResolution;
  if BitsPixels=0 then
    BitsPixels:=4;
  LineSize := (BitsPixels * w + 8) div 8 + 4;
  result := MaxHeaderSize + PalSize + LineSize * H;
end;

procedure TImgLibObj.LoadFromClipboardFormat(AFormat: Word; AData: THandle;
  APalette: HPALETTE);
begin
  Bitmap.LoadFromClipboardFormat(AFormat,AData,APalette);
end;

procedure TImgLibObj.SaveToClipboardFormat(var AFormat: Word;
  var AData: THandle; var APalette: HPALETTE);
begin
  Bitmap.SaveToClipboardFormat(AFormat,AData,APalette);
end;

procedure TImgLibObj.Clear;
begin
  FSize := 0;
  Fwidth := 0;
  FHeight := 0;
  Bitmap.Handle := 0;
  Bitmap.Palette := 0;
  Changed(self);
end;

function TImgLibObj.GetTransparentColor: TColor;
begin
  result := Bitmap.TransparentColor;
end;

function TImgLibObj.GetTransparentMode: TTransparentMode;
begin
  result := Bitmap.TransparentMode;
end;

procedure TImgLibObj.SetTransparentColor(const Value: TColor);
begin
  Bitmap.TransparentColor := value;
end;

procedure TImgLibObj.SetTransparentMode(const Value: TTransparentMode);
begin
  Bitmap.TransparentMode := value;
end;

procedure TImgLibObj.SetShowError(const Value: boolean);
begin
  if value then
    FShowErrorInt := 1
  else
    FShowErrorInt := 0;
end;

function TImgLibObj.GetShowError: boolean;
begin
  result := FShowErrorInt = 1;
end;

procedure TImgLibObj.Flip;
var
  hBMP         : HBitmap;
  hPAL         : HPalette;
begin
  hBMP:=Bitmap.Handle;
  HPAL:=Bitmap.Palette;
  if Bitmap.HandleType=bmDIB then
  begin
    CheckImgLibCallErrorEx(ESOther,FlipDIB(LoadResolution,hBMP,0));
    Bitmap.Handle :=hBMP;
  end
  else
  begin
    CheckImgLibCallErrorEx(ESOther,FlipDDB(LoadResolution,hBMP,HPAL,0));
    Bitmap.Palette :=HPAL;
    Bitmap.Handle :=hBMP;
  end;
  Changed(self);
end;

procedure TImgLibObj.Rotate180;
var
  hBMP         : HBitmap;
  hPAL         : HPalette;
begin
  hBMP:=Bitmap.Handle;
  HPAL:=Bitmap.Palette;
  if Bitmap.HandleType=bmDIB then
  begin
    CheckImgLibCallErrorEx(ESOther,ROTATEDIB180(LoadResolution,hBMP,0));
    Bitmap.Handle :=hBMP;
  end
  else
  begin
    CheckImgLibCallErrorEx(ESOther,ROTATEDDB180(LoadResolution,hBMP,HPAL,0));
    Bitmap.Palette :=HPAL;
    Bitmap.Handle :=hBMP;
  end;
  Changed(self);
end;

procedure TImgLibObj.Rotate90;
var
  hBMP         : HBitmap;
  hPAL         : HPalette;
begin
  hBMP:=Bitmap.Handle;
  HPAL:=Bitmap.Palette;
  if Bitmap.HandleType=bmDIB then
  begin
    CheckImgLibCallErrorEx(ESOther,ROTATEDIB90(LoadResolution,hBMP,0));
    Bitmap.Handle :=hBMP;
  end
  else
  begin
    CheckImgLibCallErrorEx(ESOther,ROTATEDDB90(LoadResolution,hBMP,HPAL,0));
    Bitmap.Palette :=HPAL;
    Bitmap.Handle :=hBMP;
  end;
  Changed(self);
end;

procedure TImgLibObj.DoProgress(Percent: integer; var isContinue: boolean);
begin
  LastPercent  := Percent;
  Progress(self,psRunning,Percent,false,rect(0,0,0,0),'');
  isContinue := not IsCancel;
end;

function TImgLibObj.EndLoading(hBmp: HBitmap; hPal: HPalette): boolean;
begin
  if Progressed then
  begin
    Progress(self,psEnding,LastPercent,false,rect(0,0,0,0),'');
    ProgressImgObj := nil;
    result := not isCancel;
    if isCancel then
    begin
      DeleteObject(hPal);
      DeleteObject(hBmp);
    end;
    Callback := nil;
  end
  else result:=true;
end;

function  TImgLibObj.StartLoading:boolean;
begin
  IsCancel := false;
  if Progressed then
  begin
    LastPercent := 0;
    Callback := ImgLibProgress;
    ProgressImgObj := self;
    Progress(self,psStarting,0,false,rect(0,0,0,0),'');
  end
  else Callback := nil;
  result := not IsCancel;
end;

{ TILImage }

function TILImage.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
begin
  Result := True;
  if not (csDesigning in ComponentState) or (ImageObj.Width > 0) and
    (ImageObj.Height > 0) then
  begin
    if Align in [alNone, alLeft, alRight] then
      NewWidth := ImageObj.Width;
    if Align in [alNone, alTop, alBottom] then
      NewHeight := ImageObj.Height;
  end;
end;

procedure TILImage.Changed(sender: TObject);
begin
  if autoSize and not FImageObj.empty then
    SetBounds(Left, Top, FImageObj.Width, FImageObj.Height);
  Invalidate;
end;

constructor TILImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable,csOpaque];
  width := 100;
  height := 100;
  FImageObj := TImgLibObj.Create;
  FImageObj.OnChange := Changed;
  FImageObj.Transparent := false;
  FStretch := false;
  FScale := true;
  FCenter := true;
end;

destructor TILImage.Destroy;
begin
  FImageObj.OnChange := nil;
  FImageObj.free;
  inherited destroy;
end;

procedure TILImage.Paint;
var
  x,y,DestW,DestH : integer;
begin
  if not transparent then
  begin
    Canvas.brush.style := bsSolid;
    Canvas.brush.Color := color;
    Canvas.FillRect(Rect(0,0,width,height));
  end;

  if ImageObj.Empty or (ImageObj.Width<=0)
    or (ImageObj.Height<=0) then exit;
  (*
  { Stretch  Scale
         F       F        显示原始大小
         F       T        如果图象大于显示区域，缩小显示大小，保持长宽比
         T       F        放缩图象，不保持长宽比
         T       T        放缩图象，保持长宽比
  }
  if not FStretch then
    if not scale then
      //显示原始大小
      Canvas.Draw(0,0,FImageObj)
    else
    begin
      //如果图象大于显示区域，缩小显示大小，保持长宽比
      {if (FImageObj.width>width) or (FImageObj.Height>.Height) then
      begin
        //缩小显示大小，保持长宽比
        AdjustWH(DestW,DestH,FImageObj.width,FImageObj.Height,width,height,true);
        FImageObj.Draw(Canvas,Rect(0,0,DestW,DestH));
      end
      else
        //显示原始大小
        Canvas.Draw(0,0,FImageObj);}
      AdjustWH(DestW,DestH,FImageObj.width,FImageObj.Height,width,height,false);
      FImageObj.Draw(Canvas,Rect(0,0,DestW,DestH));
    end
  else
    if not scale then
    //放缩图象，不保持长宽比
      FImageObj.Draw(Canvas,Rect(0,0,width,height))
    else
    begin
    //放缩图象，保持长宽比
      AdjustWH(DestW,DestH,FImageObj.width,FImageObj.Height,width,height,true);
      FImageObj.Draw(Canvas,Rect(0,0,DestW,DestH));
    end;
  *)
  x:=0;
  y:=0;
  DestW:=ImageObj.Width;
  DestH:=ImageObj.Height;
  if not FStretch then
  begin
    if scale then
      //如果图象大于显示区域，缩小显示大小，保持长宽比
      AdjustWH(DestW,DestH,FImageObj.width,FImageObj.Height,width,height,false);
  end
  else
    if not scale then
    begin
      //放缩图象，不保持长宽比
      DestW:=width;
      DestH:=height;
    end
    else
      //放缩图象，保持长宽比
      AdjustWH(DestW,DestH,FImageObj.width,FImageObj.Height,width,height,true);
  if Center then
  begin
    if DestW<width then x := (width-DestW) div 2;
    if DestH<Height then y := (Height-DestH) div 2;
  end;
  FImageObj.Draw(Canvas,Rect(x,y,x+DestW,y+DestH));
end;

procedure TILImage.SetImageObj(const Value: TImgLibObj);
begin
  if  FImageObj <> Value then
  begin
    FImageObj.Assign(Value);
  end;
end;

procedure TILImage.SetScale(const Value: boolean);
begin
  if FScale <> Value then
  begin
    FScale := Value;
    invalidate;
  end;
end;

procedure TILImage.SetStretch(const Value: Boolean);
begin
  if FStretch <> Value then
  begin
    FStretch := Value;
    invalidate;
  end;
end;

function TILImage.GetTransparent: Boolean;
begin
  result := ImageObj.Transparent;
end;

procedure TILImage.SetTransparent(const Value: Boolean);
begin
  ImageObj.Transparent := Value;
  if ImageObj.Transparent then
    ControlStyle := ControlStyle - [csOpaque]
  else
    ControlStyle := ControlStyle + [csOpaque];

end;

procedure TILImage.SetCenter(const Value: boolean);
begin
  if FCenter <> Value then
  begin
    FCenter := Value;
    invalidate;
  end;
end;

function TILImage.GetOnProgress: TProgressEvent;
begin
  result := ImageObj.OnProgress;
end;

procedure TILImage.SetOnProgress(const Value: TProgressEvent);
begin
  ImageObj.OnProgress := value;
end;

initialization
  RegisterFileExt;

finalization
  UnRegisterFileExt;
end.
