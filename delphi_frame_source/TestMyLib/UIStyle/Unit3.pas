unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, UIStyles, ImagesMan, StdCtrls, ImageCtrls, ComCtrls, ToolWin,
  UICtrls, ActnList, ExtCtrls, Buttons;

type
  TForm1 = class(TForm)
    CommandImages1: TCommandImages;
    ImageList1: TImageList;
    ImageButton1: TImageButton;
    ImageButton2: TImageButton;
    CommandImages2: TCommandImages;
    rgStyle: TRadioGroup;
    procedure ImageButton1Click(Sender: TObject);
    procedure rgStyleClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.ImageButton1Click(Sender: TObject);
begin
  ShowMessage(IntToStr(ImageList1.Count));
end;

procedure TForm1.rgStyleClick(Sender: TObject);
begin
  if rgStyle.ItemIndex=0 then
    CommandImages1.Active := True else
    CommandImages2.Active := True;
end;

end.
