unit UGenGraph;

interface

uses windows,classes,Graphics,ImgLibObjs;

procedure GenGif(W,H : integer;
  Color:TColor;
  Style : integer;
  const GifFileName:string);

implementation

procedure GenGif(W,H : integer;
  Color:TColor;
  Style : integer;
  const GifFileName:string);
var
  Gif : TImgLibObj;
begin
  Gif := TImgLibObj.Create;
  try
    with Gif.Bitmap do
    begin
      width := w;
      Height := h;
      PixelFormat := pf8bit;
      HandleType := bmDDB;
    end;
    with Gif.Bitmap.Canvas do
    begin
      Brush.color := clWhite;
      FillRect(rect(0,0,w,h));
      pen.color := clBlack;
      Brush.color := color;
      case Style of
        0 : Rectangle(1,1,w-1,h-1);
        1 : Ellipse(1,1,w-1,h-1);
        2 : RoundRect(1,1,w-1,h-1,w div 4,H div 4);
      end;
    end;
    Gif.SaveResolution := 8;
    Gif.ImageType := imGIF;
    Gif.SaveToFile(GifFileName);
  finally
    Gif.free;
  end;
end;

end.
