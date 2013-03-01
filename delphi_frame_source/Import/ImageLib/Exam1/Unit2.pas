unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,ImgLibObjs;

type
  TForm1 = class(TForm)
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    Label1: TLabel;
    edFile: TEdit;
    btnBrowse: TButton;
    btnOpen: TButton;
    OpenDialog1: TOpenDialog;
    Image1: TImage;
    btnSave: TButton;
    btnSaveStream: TButton;
    btnLoadStream: TButton;
    procedure btnOpenClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSaveStreamClick(Sender: TObject);
    procedure btnLoadStreamClick(Sender: TObject);
  private
    { Private declarations }
    ImageObj : TImgLibObj;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses ImageLibX;

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  //InitDll(application.handle,'yk127e');
  ImageObj := TImgLibObj.Create;
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
  ImageObj.free;
end;

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
    // add code here.
    ImageObj.LoadFromFile(edFile.text);
    Image1.Picture.Graphic := ImageObj;
  end;
end;

procedure TForm1.btnSaveClick(Sender: TObject);
begin
  if edFile.text<>'' then
  begin
    // add code here.
    ImageObj.SaveToFile(edFile.text);
  end;
end;

procedure TForm1.btnSaveStreamClick(Sender: TObject);
var
  f : TFileStream;
begin
  if edFile.text<>'' then
  begin
    // add code here.
    f := TFileStream.Create(edFile.text,fmCreate);
    try
      ImageObj.WriteData(f);
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
      ImageObj.ReadData(f);
      Image1.Picture.Graphic := ImageObj;
    finally
      f.free;
    end;
  end;
end;

end.
