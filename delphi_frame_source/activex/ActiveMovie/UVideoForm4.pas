unit UVideoForm4;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs,QuartzTypeLib_TLB, Menus,AMovieUtils, AbilityManager,
  ExtCtrls;

type
  TfmVideo = class(TForm)
    PopupMenu1: TPopupMenu;
    miPlay: TMenuItem;
    miPause: TMenuItem;
    miStop: TMenuItem;
    N1: TMenuItem;
    miFullScreen: TMenuItem;
    amMovie: TGroupAbilityManager;
    MovieWnd1: TMovieWnd;
    procedure FormResize(Sender: TObject);
    procedure miPlayClick(Sender: TObject);
    procedure miPauseClick(Sender: TObject);
    procedure miStopClick(Sender: TObject);
    procedure miFullScreenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MovieWnd1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MovieWnd1Timer(Sender: TObject);
    procedure MovieWnd1StateChanged(Sender: TActiveMovie; OldState,
      NewState: TMediaCtrlState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Open(const FileName:string);
  end;

var
  fmVideo: TfmVideo;

implementation

uses UMain4;

{$R *.DFM}

procedure TfmVideo.FormResize(Sender: TObject);
begin

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
  if MovieWnd1.Opened then
    MovieWnd1.Movie.Play;
end;

procedure TfmVideo.miPauseClick(Sender: TObject);
begin
  if MovieWnd1.Opened then
    MovieWnd1.Movie.Pause;
end;

procedure TfmVideo.miStopClick(Sender: TObject);
begin
  if MovieWnd1.Opened then
    MovieWnd1.Movie.Stop;
end;

procedure TfmVideo.miFullScreenClick(Sender: TObject);
begin
  miFullScreen.Checked := not miFullScreen.Checked;
  MovieWnd1.Movie.FullScreen := miFullScreen.Checked;
end;

procedure TfmVideo.FormCreate(Sender: TObject);
begin
  amMovie.Enabled := MovieWnd1.Movie.Opened;
end;

procedure TfmVideo.Open(const FileName: string);
begin
  MovieWnd1.Movie.LoadFromFile(FileName);
  if MovieWnd1.Opened then
  begin
    ClientWidth := MovieWnd1.Movie.MovieWidth;
    ClientHeight := MovieWnd1.Movie.MovieHeight;
  end;
  amMovie.Enabled := MovieWnd1.Opened;
end;

procedure TfmVideo.MovieWnd1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p : TPoint;
begin
  if Button=mbRight then
  begin
    miFullScreen.Checked := MovieWnd1.Movie.FullScreen;
    if MovieWnd1.Movie.FullScreen then
      PopupMenu1.popup(x,y)
    else
    begin
      p := MovieWnd1.ClientToScreen(point(x,y));
      PopupMenu1.popup(p.x,p.y);
    end;
  end;
end;

procedure TfmVideo.MovieWnd1Timer(Sender: TObject);
begin
  if MovieWnd1.opened then
  begin
    Form1.label3.caption := FloatToStr(MovieWnd1.movie.CurrentPosition);
    Form1.TrackBar1.Position :=
      Round(MovieWnd1.movie.CurrentPosition*10);
  end;
end;

procedure TfmVideo.MovieWnd1StateChanged(Sender: TActiveMovie; OldState,
  NewState: TMediaCtrlState);
begin
  case NewState of
    mcsNotReady : Form1.label2.caption := 'Not ready';
    mcsRunning  : Form1.label2.caption := 'Running';
    mcsStopped  : Form1.label2.caption := 'Stopped';
    mcsPaused   : Form1.label2.caption := 'Paused';
  end;
  MovieWnd1Timer(Sender);
end;

end.
