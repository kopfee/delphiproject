unit Unit3;

{ this debug program is for BKGround.
  this unit is adapted from unit1
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, BkGround,JPEG, Buttons, ExtDlgs;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    BackGround1: TBackGround;
    OpenPictureDialog1: TOpenPictureDialog;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Edit1DblClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Unit2;

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  background1.picture.loadFromFile(edit1.text);
  Form2.Image1.picture := background1.picture;
  if background1.picture.Graphic is TBitmap then
    label2.caption := intToStr(integer(TBitmap(
      background1.picture.Graphic).PixelFormat))
  else if background1.picture.Graphic is TJPEGImage then
    label2.caption := intToStr(integer(TJPEGImage(
      background1.picture.Graphic).PixelFormat));
end;

procedure TForm1.Edit1DblClick(Sender: TObject);
begin
  OpenPictureDialog1.Filename := edit1.text;
  if OpenPictureDialog1.execute then
  begin
    edit1.text := OpenPictureDialog1.Filename;
    Button1Click(Sender);
  end;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  background1.tiled := CheckBox1.checked;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  if Form2<>nil then
  begin
    Form2.ClientWidth := background1.width;
    Form2.ClientHeight := background1.height;
  end;
end;

end.
