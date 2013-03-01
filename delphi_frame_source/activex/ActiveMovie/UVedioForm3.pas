unit UVedioForm3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs,QuartzTypeLib_TLB, Menus;

type
  TfmVideo = class(TForm)
    PopupMenu1: TPopupMenu;
    miPlay: TMenuItem;
    miPause: TMenuItem;
    miStop: TMenuItem;
    N1: TMenuItem;
    miFullScreen: TMenuItem;
    procedure FormResize(Sender: TObject);
    procedure miPlayClick(Sender: TObject);
    procedure miPauseClick(Sender: TObject);
    procedure miStopClick(Sender: TObject);
    procedure miFullScreenClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FVideoWindow: IVideoWindow;
    InitSize : boolean;
    procedure SetVideoWindowPos;
    procedure SetVideoWindow(const Value: IVideoWindow);
  public
    { Public declarations }
    property VideoWindow : IVideoWindow
              read FVideoWindow write SetVideoWindow;
  end;

var
  fmVideo: TfmVideo;

implementation

uses UMain3;

{$R *.DFM}

procedure TfmVideo.FormResize(Sender: TObject);
begin
  if not InitSize then SetVideoWindowPos;
end;

procedure TfmVideo.SetVideoWindow(const Value: IVideoWindow);
var
  maxWidth,maxHeight : integer;
  BasicVideo : IBasicVideo;
begin
  if FVideoWindow<>nil then
  begin
    FVideoWindow.Owner := 0;
    FVideoWindow.MessageDrain := 0;
  end;
  FVideoWindow := Value;
  if FVideoWindow<>nil then
  begin
    InitSize := true;
    BasicVideo := FVideoWindow as IBasicVideo;
    //FVideoWindow.GetMaxIdealImageSize(maxWidth,maxHeight);
    {ClientWidth := maxWidth;
    ClientHeight := maxHeight;}
    ClientWidth := BasicVideo.VideoWidth;
    ClientHeight := BasicVideo.VideoHeight;
    InitSize := false;
    with FVideoWindow do
    begin
      WindowStyle := $6000000;
      Owner := Handle;
      MessageDrain := handle;
    end;
    SetVideoWindowPos;
  end;
end;

procedure TfmVideo.SetVideoWindowPos;
begin
  if FVideoWindow<>nil then
  with VideoWindow do
  begin
    SetWindowPosition(0,0,ClientWidth,ClientHeight);
  end;
end;

procedure TfmVideo.miPlayClick(Sender: TObject);
begin
  Form1.btnPlayClick(Sender);
end;

procedure TfmVideo.miPauseClick(Sender: TObject);
begin
  Form1.btnPauseClick(Sender);
end;

procedure TfmVideo.miStopClick(Sender: TObject);
begin
  Form1.btnStopClick(Sender);
end;

procedure TfmVideo.miFullScreenClick(Sender: TObject);
begin
  miFullScreen.Checked := not miFullScreen.Checked;
  FVideoWindow.FullScreenMode := integer(longBool(miFullScreen.Checked));
end;

procedure TfmVideo.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p : TPoint;
begin
  if Button=mbRight then
  begin
    if longbool(FVideoWindow.FullScreenMode) then
      PopupMenu1.popup(x,y)
    else
    begin
      p := ClientToScreen(point(x,y));
      PopupMenu1.popup(p.x,p.y);
    end;

  end;
end;

end.
