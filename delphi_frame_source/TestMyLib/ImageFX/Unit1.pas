unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, CustomImageFX, ImageFXs, StdCtrls, jpeg;

type
  TForm1 = class(TForm)
    ImageFX1: TImageFX;
    FXScalePainter1: TFXScalePainter;
    FXStripPainter1: TFXStripPainter;
    btnStart: TButton;
    btnEnd: TButton;
    FXDualPainter1: TFXDualPainter;
    procedure btnStartClick(Sender: TObject);
    procedure btnEndClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation


{$R *.DFM}

procedure TForm1.btnStartClick(Sender: TObject);
begin
  ImageFX1.StartFX;
end;

procedure TForm1.btnEndClick(Sender: TObject);
begin
  ImageFX1.EndFX;
end;

end.
