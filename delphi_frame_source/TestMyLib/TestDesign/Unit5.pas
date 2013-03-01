unit Unit5;
// this is a bad program!
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Image1: TImage;
    Button1: TButton;
    Label1: TLabel;
    RichEdit1: TRichEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
uses Frames;

procedure TForm1.FormCreate(Sender: TObject);
var
  f : TFrame;
begin
  f := TFrame.Create(self);
  f.borderSize := 2;
  f.LinkedCtrl := StaticText1;
  f := TFrame.Create(self);
  f.borderSize := 2;
  f.LinkedCtrl := Image1;
  f := TFrame.Create(self);
  f.borderSize := 2;
  f.LinkedCtrl := Button1;
  f := TFrame.Create(self);
  f.borderSize := 2;
  f.LinkedCtrl := Label1;
  f := TFrame.Create(self);
  f.borderSize := 2;
  f.LinkedCtrl := RichEdit1;
end;

end.
