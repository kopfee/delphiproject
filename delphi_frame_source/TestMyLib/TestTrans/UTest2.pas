unit UTest2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, UTransEdit;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Button1: TButton;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    ABrush : HBrush;
    procedure WMCtlColorEdit(var Msg : TWMCtlColor);message WM_CtlColorEdit;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{ TForm1 }

procedure TForm1.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.style := Params.style and not WS_CLIPCHILDREN;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  LogBrush : TLogBrush;
begin
  LogBrush.lbStyle := BS_NULL;
  ABrush := CreateBrushIndirect(LogBrush);
end;

procedure TForm1.WMCtlColorEdit(var Msg: TWMCtlColor);
begin
  // paint background
  //windows.InvalidateRect(msg.ChildWnd,nil,false);
  with memo1 do
   BitBlt(msg.ChildDc,0,0,width,height,
   image1.picture.bitmap.canvas.handle,left,top,SRCCOPY);
  setBKMode(msg.ChildDC,transparent);
  msg.Result:=ABrush; 
  //windows.validateRect(msg.ChildWnd,nil);
end;

end.
