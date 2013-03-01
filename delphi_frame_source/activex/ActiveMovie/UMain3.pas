unit UMain3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs,QuartzTypeLib_TLB, StdCtrls,
  ExtCtrls, ComCtrls,AMovieUtils;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    btnBrowse: TButton;
    OpenDialog1: TOpenDialog;
    btnOpen: TButton;
    btnPlay: TButton;
    btnPause: TButton;
    btnStop: TButton;
    Timer1: TTimer;
    Label2: TLabel;
    Label3: TLabel;
    TrackBar1: TTrackBar;
    btnShow: TButton;
    cbAutoPlay: TCheckBox;
    procedure btnBrowseClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure btnPauseClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure btnShowClick(Sender: TObject);
  private
    { Private declarations }
    
  public
    { Public declarations }

  end;

var
  Form1: TForm1;

implementation

uses UVideoForm3;

{$R *.DFM}

procedure TForm1.btnBrowseClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    Edit1.text := OpenDialog1.FileName;
    btnOpenClick(Sender);
  end;
end;

procedure TForm1.btnOpenClick(Sender: TObject);
begin
  fmVideo.Movie.LoadFromFile(Edit1.text);
  if fmVideo.Movie.Opened then
  begin
    fmVideo.ClientWidth := fmVideo.Movie.MovieWidth;
    fmVideo.ClientHeight := fmVideo.Movie.MovieHeight;
    TrackBar1.max := Round(fmVideo.Movie.Duration*10);
    TrackBar1.Position := 0;
    fmVideo.show;
    if cbAutoPlay.Checked then
      btnPlayClick(Sender);
  end;
  fmVideo.amMovie.Enabled := fmVideo.Movie.Opened;
end;

procedure TForm1.btnPlayClick(Sender: TObject);
begin
  fmVideo.miPlayClick(Sender);
end;

procedure TForm1.btnPauseClick(Sender: TObject);
begin
  fmVideo.miPauseClick(Sender);
end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
  fmVideo.miStopClick(Sender);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if fmVideo.movie.opened then
  begin
    label3.caption := FloatToStr(fmVideo.movie.CurrentPosition);
    TrackBar1.Position :=
      Round(fmVideo.movie.CurrentPosition*10);
  end;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  if fmVideo.movie.opened then
    fmVideo.movie.CurrentPosition := TrackBar1.Position/10;
end;

procedure TForm1.btnShowClick(Sender: TObject);
begin
  fmVideo.show;
end;

end.
