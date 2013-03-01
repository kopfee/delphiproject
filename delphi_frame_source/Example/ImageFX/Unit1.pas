unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImageFXs, ExtCtrls, jpeg, BkGround, StdCtrls;

type
  TForm1 = class(TForm)
    BackGround1: TBackGround;
    ImageFX1: TImageFX;
    FXScalePainter1: TFXScalePainter;
    FXStripPainter1: TFXStripPainter;
    CheckBox1: TCheckBox;
    FXDualPainter1: TFXDualPainter;
    procedure FXScalePainter1EndFX(Sender: TObject);
    procedure FXStripPainter1EndFX(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FXDualPainter1EndFX(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FXScalePainter1EndFX(Sender: TObject);
begin
  Sleep(3000);
  ImageFX1.Painter := FXStripPainter1;
  ImageFX1.StartFX;
end;

procedure TForm1.FXStripPainter1EndFX(Sender: TObject);
begin
  Sleep(3000);
  ImageFX1.Painter := FXDualPainter1;
  ImageFX1.StartFX;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  ImageFX1.Transparent := CheckBox1.Checked;
end;

procedure TForm1.FXDualPainter1EndFX(Sender: TObject);
begin
  Sleep(3000);
  ImageFX1.Painter := FXScalePainter1;
  ImageFX1.StartFX;
end;

end.
