unit UMain2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs,QuartzTypeLib_TLB, StdCtrls, ExtCtrls, ComCtrls;

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
    MediaControl  : IMediaControl;
    BasicAudio    : IBasicAudio;
    //VideoWindow   : IVideoWindow;
    MediaEvent    : IMediaEvent;
    MediaPosition : IMediaPosition;
  public
    { Public declarations }

  end;

var
  Form1: TForm1;

implementation

uses UVedioForm;

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
  MediaControl := nil;
  MediaControl := CoFilgraphManager.Create;
  MediaPosition := nil;
  BasicAudio := nil;
  fmVideo.VideoWindow :=nil;
  MediaEvent :=nil;

  MediaControl.RenderFile(Edit1.text);

  MediaPosition := MediaControl as IMediaPosition;
  BasicAudio := MediaControl as IBasicAudio;
  fmVideo.VideoWindow := MediaControl as IVideoWindow;
  MediaEvent := MediaControl  as IMediaEvent;

  {
  with VideoWindow do
  begin
    WindowStyle := $6000000;
    Left := 0;
    Top := 0;
    Width := fmVedio.ClientWidth;
    Height := fmVedio.ClientHeight;
    Owner := fmVedio.Handle;
  end;
  }
  MediaPosition.CurrentPosition := 0;
  TrackBar1.max := Round(MediaPosition.Duration*10);
  TrackBar1.Position := 0;
  MediaControl.pause;
  fmVideo.show;
end;

procedure TForm1.btnPlayClick(Sender: TObject);
begin
  MediaControl.Run;
end;

procedure TForm1.btnPauseClick(Sender: TObject);
begin
  MediaControl.Pause;
end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
  MediaControl.Pause;
  MediaPosition.CurrentPosition := 0;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  state : integer;
begin
  {MediaControl.GetState(0,state);
  label2.caption := IntToStr(state);}
  if MediaPosition<>nil then
  begin
    label3.caption := FloatToStr(MediaPosition.CurrentPosition);
    TrackBar1.Position :=
      Round(MediaPosition.CurrentPosition*10);
  end;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  if MediaPosition<>nil then
    MediaPosition.CurrentPosition := TrackBar1.Position/10;
end;

procedure TForm1.btnShowClick(Sender: TObject);
begin
  fmVideo.show;
end;

end.
