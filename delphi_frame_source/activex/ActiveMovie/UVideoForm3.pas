unit UVideoForm3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs,QuartzTypeLib_TLB, Menus,AMovieUtils, AbilityManager;

type
  TfmVideo = class(TForm)
    PopupMenu1: TPopupMenu;
    miPlay: TMenuItem;
    miPause: TMenuItem;
    miStop: TMenuItem;
    N1: TMenuItem;
    miFullScreen: TMenuItem;
    amMovie: TGroupAbilityManager;
    procedure FormResize(Sender: TObject);
    procedure miPlayClick(Sender: TObject);
    procedure miPauseClick(Sender: TObject);
    procedure miStopClick(Sender: TObject);
    procedure miFullScreenClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FVideoWindow: IVideoWindow;
    InitSize : boolean;
  public
    { Public declarations }
    Movie : TMovie;
  end;

var
  fmVideo: TfmVideo;

implementation

uses UMain3;

{$R *.DFM}

procedure TfmVideo.FormResize(Sender: TObject);
begin
  if not InitSize and Movie.Opened then
    Movie.VideoFitCtrlSize;
end;
(*
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
*)

procedure TfmVideo.miPlayClick(Sender: TObject);
begin
  if Movie.Opened then
    Movie.Play;
end;

procedure TfmVideo.miPauseClick(Sender: TObject);
begin
  if Movie.Opened then
    Movie.Pause;
end;

procedure TfmVideo.miStopClick(Sender: TObject);
begin
  if Movie.Opened then
    Movie.Stop;
end;

procedure TfmVideo.miFullScreenClick(Sender: TObject);
begin
  miFullScreen.Checked := not miFullScreen.Checked;
  Movie.FullScreen := miFullScreen.Checked;
end;

procedure TfmVideo.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p : TPoint;
begin
  if Button=mbRight then
  begin
    miFullScreen.Checked := Movie.FullScreen;
    if Movie.FullScreen then
      PopupMenu1.popup(x,y)
    else
    begin
      p := ClientToScreen(point(x,y));
      PopupMenu1.popup(p.x,p.y);
    end;
  end;
end;

procedure TfmVideo.FormCreate(Sender: TObject);
begin
  Movie := TMovie.Create;
  Movie.VideoCtrl := self;
  amMovie.Enabled := Movie.Opened;
end;

procedure TfmVideo.FormDestroy(Sender: TObject);
begin
  Movie.free;
end;

end.
