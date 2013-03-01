unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  NewDlgs, ExtCtrls, StdCtrls,SimpBmp, ComCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    btnBrowse: TButton;
    btnOpen: TButton;
    OpenDialogEx1: TOpenDialogEx;
    CheckBox1: TCheckBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    PaintBox1: TPaintBox;
    Image1: TImage;
    procedure btnBrowseClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    bmp : TSimpleBitmap;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnBrowseClick(Sender: TObject);
begin
  OpenDialogEx1.Execute;
end;

procedure TForm1.btnOpenClick(Sender: TObject);
begin
  Image1.Picture.LoadFromFile(edit1.text);
  bmp.LoadFromFile(edit1.text);
  PaintBox1.Invalidate;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  bmp := TSimpleBitmap.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  bmp.free;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
begin
  if CheckBox1.Checked then
  begin
    {bmp.GetMemDC;
    try

      bmp.
    finally
      bmp.ReleaseMemDC;
    end;}
    PaintBox1.Canvas.StretchDraw(rect(0,0,PaintBox1.width,PaintBox1.Height),bmp)
  end
  else
    PaintBox1.Canvas.Draw(0,0,bmp);
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  PaintBox1.Invalidate;
  Image1.Stretch := CheckBox1.Checked;
end;

end.
