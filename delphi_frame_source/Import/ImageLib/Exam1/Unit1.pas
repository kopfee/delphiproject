unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
	TImageFormat = (ifJpeg,ifTiff);

  TForm1 = class(TForm)
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    Label1: TLabel;
    edFile: TEdit;
    btnBrowse: TButton;
    btnOpen: TButton;
    OpenDialog1: TOpenDialog;
    Image1: TImage;
    procedure btnOpenClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure OpenImage(const FileName:string;fmt : TImageFormat);
  public
    { Public declarations }
    FileHandle : THandle;
  end;

var
  Form1: TForm1;

implementation

uses ImageLibX;

{$R *.DFM}

procedure TForm1.btnOpenClick(Sender: TObject);
var
	Ext : string;
begin
  if edFile.text<>'' then
  begin
    // add code here.
    Ext := Uppercase(ExtractFileExt(edFile.text));
    if (Ext='.JPG') or (Ext='.JPEG') then
	    OpenImage(edFile.text,ifJpeg)
    else if (Ext='.TIF') or (Ext='.TIFF') then
	    OpenImage(edFile.text,ifTiff)
  end;
end;

procedure TForm1.btnBrowseClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    edFile.Text := OpenDialog1.FileName;
    btnOpenClick(sender);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //InitDll(application.handle,'yk127e');
end;

procedure TForm1.OpenImage(const FileName: string;fmt : TImageFormat);
var
	r : smallint;
  hBMP          : HBitmap;
  HPAL          : HPalette;
begin
  case fmt of
    ifJpeg : r := readjpgfile(pchar(FileName),
								  	24,
							  	  1,
							    	0,
								    hBMP,
							  	  HPAL,
							    	nil,
								    1);
		ifTiff : r := readTifFile(pchar(FileName),
								  	1,
							  	  0,
								    hBMP,
							  	  HPAL,
							    	nil,
								    1,
                    unilzw);
  end;
  if r>=0 then
  with Image1.picture.bitmap do
  begin
    Handle := hBMP;
    Palette := HPAL;
  end
  else
  	ShowMessage('Error Code : '+IntToStr(r));
end;

end.
