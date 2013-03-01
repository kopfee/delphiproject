unit UTest;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, UTransEdit;

type
  TForm1 = class(TForm)
    Image1: TImage;
    TransparentMemo1: TTransparentMemo;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure WMCtlColorEdit(var Msg : TWMCtlColor);message WM_CtlColorEdit;
    procedure WMCommand(var msg : TWMCommand); message WM_Command;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    switch : boolean;
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
begin
  with TransparentMemo1 do
  begin
    BGBitmap := Image1.picture.bitmap;
    BGX:=left;
    BGY:=top;
    BGW:=width;
    BGH:=height;
    // for test
    TestCanvas := self.canvas;
    x1:=50+width;
    y1:=0;
    x2:=0;
    y2:=50+height;
    // end test
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  repaint;
end;

procedure TForm1.WMCtlColorEdit(var Msg: TWMCtlColor);
var
  Rect : TRect;
  DC : HDC;
begin
  setBKMode(msg.ChildDC,transparent);
  msg.Result:=TransparentMemo1.ABrush;
  switch := not switch;
  if switch then
  begin
  //excludeUpdateRgn(msg.ChildDC,Msg.ChildWnd);
  DC := GetDC(Msg.ChildWnd);
  try
    TransparentMemo1.PaintBackGround(DC);
    TransparentMemo1.perform(WM_Paint,DC,0);
    //ValidateRect(Msg.ChildWnd,nil);
  finally
    releaseDC(Msg.ChildWnd,DC);
  end;
  cancelDC(msg.ChildDC);
  end;

end;


procedure TForm1.WMCommand(var msg: TWMCommand);
begin
  if (msg.NotifyCode=EN_update) and (msg.Ctl=TransparentMemo1.handle)
    then invalidateRect(TransparentMemo1.handle,nil,false);
end;

end.
