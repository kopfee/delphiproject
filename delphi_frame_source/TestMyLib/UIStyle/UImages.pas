unit UImages;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ImageCtrls, UIStyles, ImagesMan, StdCtrls;

type
  TForm1 = class(TForm)
    UIImages1: TUIImages;
    UIImage1: TUIImage;
    UIImages2: TUIImages;
    rgImages: TRadioGroup;
    procedure rgImagesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.rgImagesClick(Sender: TObject);
begin
  case rgImages.ItemIndex of
    0 : UIImages1.Active := True;
    1 : UIImages2.Active := True;
  end;
end;

end.
