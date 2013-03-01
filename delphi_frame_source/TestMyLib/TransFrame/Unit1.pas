unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FrameCtrl, StdCtrls, Buttons, ExtCtrls, Spin,WinObjs;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    FrameControl1: TFrameControl;
    BitBtn1: TBitBtn;
    Panel2: TPanel;
    btnUp: TSpeedButton;
    btnLeft: TSpeedButton;
    btnRight: TSpeedButton;
    btnDown: TSpeedButton;
    btnRefresh: TBitBtn;
    edDelta: TSpinEdit;
    cbTransparent: TCheckBox;
    btnHDec: TSpeedButton;
    btnWDec: TSpeedButton;
    btnWInc: TSpeedButton;
    btnHInc: TSpeedButton;
    Label2: TLabel;
    Label3: TLabel;
    cbClipChildren: TCheckBox;
    cbClipSIBLINGS: TCheckBox;
    procedure btnRefreshClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnLeftClick(Sender: TObject);
    procedure btnRightClick(Sender: TObject);
    procedure cbTransparentClick(Sender: TObject);
    procedure btnHDecClick(Sender: TObject);
    procedure btnHIncClick(Sender: TObject);
    procedure btnWDecClick(Sender: TObject);
    procedure btnWIncClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbClipChildrenClick(Sender: TObject);
    procedure cbClipSIBLINGSClick(Sender: TObject);
  private
    { Private declarations }
    //WPanel,WBitBtn : WWindow;
    procedure MoveIt(delX,delY : integer);
    procedure SizeIt(delW,delH : integer);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnRefreshClick(Sender: TObject);
begin
  //Panel1.Repaint;
  //InvalidateRect(Panel1.handle,nil,false);
  Panel1.Refresh;
end;

procedure TForm1.MoveIt(delX, delY: integer);
var
  newRect : TRect;
begin
  with FrameControl1 do
  begin
    newRect :=  rect(left+delX,
        top+delY,
        left+delX+width,
        top+delY+height);
    BoundsRect := newRect;
  end;

  {InvalidateRect(Panel1.handle,nil,false);
  FrameControl1.Invalidate;}
  InvalidateRect(Panel1.handle,@NewRect,false);
end;

procedure TForm1.btnUpClick(Sender: TObject);
begin
  MoveIt(0,-edDelta.Value);
end;

procedure TForm1.btnDownClick(Sender: TObject);
begin
  MoveIt(0,edDelta.Value);
end;

procedure TForm1.btnLeftClick(Sender: TObject);
begin
  MoveIt(-edDelta.Value,0);
end;

procedure TForm1.btnRightClick(Sender: TObject);
begin
  MoveIt(edDelta.Value,0);
end;

procedure TForm1.cbTransparentClick(Sender: TObject);
begin
  FrameControl1.Transparent := cbTransparent.Checked;
end;

procedure TForm1.SizeIt(delW, delH: integer);
begin
  with FrameControl1 do
    BoundsRect := rect(left,
        top,
        left+delW+width,
        top+delH+height);
end;

procedure TForm1.btnHDecClick(Sender: TObject);
begin
  SizeIt(0,-edDelta.Value);
end;

procedure TForm1.btnHIncClick(Sender: TObject);
begin
  SizeIt(0,edDelta.Value);
end;

procedure TForm1.btnWDecClick(Sender: TObject);
begin
  SizeIt(-edDelta.Value,0);
end;

procedure TForm1.btnWIncClick(Sender: TObject);
begin
  SizeIt(edDelta.Value,0);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  {WPanel := WWindow.CreateBy(Panel1.handle);
  WBitBtn := WWindow.CreateBy(Bitbtn1.handle);}
end;

procedure TForm1.cbClipChildrenClick(Sender: TObject);
var
  theWnd : WWindow;
begin
  theWnd := WWindow.CreateBy(Panel1.handle);
  try
    if cbClipChildren.Checked then
      theWnd.Style := theWnd.Style or WS_CLIPCHILDREN
    else
      theWnd.Style := theWnd.Style and not WS_CLIPCHILDREN;
  finally
    theWnd.free;
  end;
end;

procedure TForm1.cbClipSIBLINGSClick(Sender: TObject);
var
  theWnd : WWindow;
begin
  theWnd := WWindow.CreateBy(Bitbtn1.handle);
  try
    if cbClipSIBLINGS.Checked then
      theWnd.Style := theWnd.Style or WS_CLIPSIBLINGS
    else
      theWnd.Style := theWnd.Style and not WS_CLIPSIBLINGS;
  finally
    theWnd.free;
  end;
end;

end.
