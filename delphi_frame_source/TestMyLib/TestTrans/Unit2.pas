unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, BkGround, Mask, ComCtrls, RichEditEx;

type
  TForm1 = class(TForm)
    BackGround1: TBackGround;
    RichEditEx1: TRichEditEx;
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

const
	path='c:\html3.rtf';

procedure TForm1.FormCreate(Sender: TObject);
begin
  with RichEditEx1 do
  begin
    lines.loadfromfile(path);
  {  // for test
    TestCanvas := self.canvas;
    x1:=50+width;
    y1:=0;
    x2:=0;
    y2:=50+height;
    // end test}
  end;
end;

end.
