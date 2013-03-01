unit MovieViewer;

// %MovieViewer : 播放Movie
(*****   Code Written By Huang YanLai   *****)

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms,container, AMovieUtils, Buttons, ComCtrls;

type
  // %TMovieView : 播放Movie的控件
  TMovieView = class(TContainer)
    MovieWnd:   TMovieWnd;
    CtrlBar:    TPanel;
    TrackBar:   TTrackBar;
    Panel2:     TPanel;
    btnPlay:    TSpeedButton;
    btnPause:   TSpeedButton;
    btnStop:    TSpeedButton;
    procedure   btnPlayClick(Sender: TObject);
    procedure   btnPauseClick(Sender: TObject);
    procedure   btnStopClick(Sender: TObject);
    procedure   MovieWndAfterOpen(Sender: TObject);
    procedure   TrackBarChange(Sender: TObject);
    procedure   MovieWndTimer(Sender: TObject);
    procedure   MovieWndStateChanged(Sender: TActiveMovieObject; OldState,
                  NewState: TMediaCtrlState);
    procedure   MovieWndPlayComplete(Sender: TObject);
  private
    changing :  boolean;
    FActiveInLoad : boolean;
    FAfterOpen: TNotifyEvent;
    FOnPlayComplete: TNotifyEvent;
    FStateChanged: TStateChangeEvent;
    function    GetOpened: boolean;
    function    GetState: TMediaCtrlState;
    procedure   EnableButtons(PlayBtn,StopBtn,PauseBtn : boolean);
    function    GetAutoRewind: boolean;
    function    GetCtrlVisible: boolean;
    function    GetFileName: string;
    procedure   SetAutoRewind(const Value: boolean);
    procedure   SetCtrlVisible(const Value: boolean);
    procedure   SetFileName(const Value: string);
    function    GetActive: boolean;
    procedure   SetActive(const Value: boolean);
  protected
    procedure   Loaded; override;
    procedure 	CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner : TComponent); override;
    property    State : TMediaCtrlState read GetState;
    property    Opened : boolean read GetOpened;
    procedure   OpenFile(const FileName:string);
    procedure   Open;
    procedure   Play;
    procedure   Stop;
    procedure   Pause;
    procedure   Close;
  published
    property    Active : boolean
                  read GetActive write SetActive default false;
    property    CtrlVisible : boolean
                  read GetCtrlVisible write SetCtrlVisible;
    property    AutoRewind : boolean
                  read GetAutoRewind write SetAutoRewind default false;
    property    FileName : string
                  read GetFileName write SetFileName;
    property    StateChanged : TStateChangeEvent
                  read FStateChanged write FStateChanged;
    property    AfterOpen : TNotifyEvent
                  read FAfterOpen write FAfterOpen;
    property    OnPlayComplete : TNotifyEvent
                  read FOnPlayComplete write FOnPlayComplete;
    property    Align;
  end;

var
  MovieView: TMovieView;

implementation

{$R *.DFM}

{ TMovieView }

procedure TMovieView.Close;
begin
  MovieWnd.Movie.Close;
end;

function TMovieView.GetOpened: boolean;
begin
  result := MovieWnd.Opened;
end;

function TMovieView.GetState: TMediaCtrlState;
begin
  result := MovieWnd.Movie.State;
end;

procedure TMovieView.OpenFile(const FileName: string);
begin
  MovieWnd.Movie.Close;
  MovieWnd.Movie.FileName := FileName;
  MovieWnd.Movie.Open;
end;

procedure TMovieView.Pause;
begin
  MovieWnd.Movie.Pause;
end;

procedure TMovieView.Play;
begin
  MovieWnd.Movie.Play;
end;

procedure TMovieView.Stop;
begin
  MovieWnd.Movie.Stop;
end;

procedure TMovieView.btnPlayClick(Sender: TObject);
begin
  Play;
end;

procedure TMovieView.btnPauseClick(Sender: TObject);
begin
  Pause;
end;

procedure TMovieView.btnStopClick(Sender: TObject);
begin
  Stop;
end;

procedure TMovieView.MovieWndAfterOpen(Sender: TObject);
begin
  TrackBar.Max := round(MovieWnd.Movie.Duration*10);
  if Assigned(AfterOpen) then
    AfterOpen(self);
end;

procedure TMovieView.TrackBarChange(Sender: TObject);
begin
  if not changing then
    MovieWnd.Movie.CurrentPosition :=
      TrackBar.Position / 10;
end;

procedure TMovieView.MovieWndTimer(Sender: TObject);
begin
  changing := true;
  TrackBar.Position :=
    round(MovieWnd.Movie.CurrentPosition*10);
  changing := false;
end;

procedure TMovieView.MovieWndStateChanged(Sender: TActiveMovieObject; OldState,
  NewState: TMediaCtrlState);
begin
  TrackBar.enabled := true;
  case NewState of
    mcsNotReady :
      begin
        EnableButtons(false,false,false);
        TrackBar.enabled := false;
      end;
    mcsStopped : EnableButtons(true,false,false);
    mcsPaused : EnableButtons(true,true,false);
    mcsRunning : EnableButtons(false,true,true);
  end;
  MovieWndTimer(Sender);
  if Assigned(StateChanged) then
    StateChanged(Sender,OldState,NewState);
end;

procedure TMovieView.EnableButtons(PlayBtn, StopBtn, PauseBtn: boolean);
begin
  btnPlay.Enabled := PlayBtn;
  btnPause.Enabled := PauseBtn;
  btnStop.Enabled := StopBtn;
end;

function TMovieView.GetAutoRewind: boolean;
begin
  result :=  MovieWnd.AutoRewind;
end;

function TMovieView.GetCtrlVisible: boolean;
begin
  result := CtrlBar.visible;
end;

function TMovieView.GetFileName: string;
begin
  result := MovieWnd.FileName;
end;

procedure TMovieView.SetAutoRewind(const Value: boolean);
begin
  MovieWnd.AutoRewind := value;
end;

procedure TMovieView.SetCtrlVisible(const Value: boolean);
begin
  CtrlBar.visible := value;
end;

procedure TMovieView.SetFileName(const Value: string);
begin
  MovieWnd.FileName := value;
end;

constructor TMovieView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls];
  EnableButtons(false,false,false);
  MovieWnd.Movie.MsgCtrl := self;
  //Designed := csDesigning in ComponentState;
end;

function TMovieView.GetActive: boolean;
begin
  result := MovieWnd.Opened;
end;

procedure TMovieView.SetActive(const Value: boolean);
begin
  if Value<>Active then
    if csLoading in ComponentState then
      FActiveInLoad := Value
    else
      if value and FileExists(FileName) then
        Open
      else
        Close;
end;

procedure TMovieView.Open;
begin
  OpenFile(FileName);
end;

procedure TMovieView.Loaded;
begin
  inherited Loaded;
  active := FActiveInLoad;
end;

procedure TMovieView.MovieWndPlayComplete(Sender: TObject);
begin
  if Assigned(OnPlayComplete) then
    OnPlayComplete(self);
end;

procedure TMovieView.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or WS_CLIPCHILDREN;
end;

initialization

registerClass(TMovieView);

end.
 