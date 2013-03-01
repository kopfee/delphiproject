unit AMovieUtils;

{
  %AMovieUtils : 包装ActiveMovie接口
}

(*****   Code Written By Huang YanLai   *****)

interface

uses
  Windows, Messages, SysUtils, Classes,
  Controls, Forms, StdCtrls, ExtCtrls,
  QuartzTypeLib_TLB, SafeCode;

type
  TMediaCtrlState = (mcsNotReady,mcsStopped,mcsPaused,mcsRunning);
  TActiveMovieObject = class;

  TStateChangeEvent = procedure (Sender : TActiveMovieObject;
    OldState,NewState : TMediaCtrlState) of object;

  TActiveMovieObject = class
  private
    FOpened: boolean;
    FMediaControl: IMediaControl;
    FMediaEvent: IMediaEvent;
    FMediaPosition: IMediaPosition;
    FFileName: string;
    FState: TMediaCtrlState;
    FOnClose: TNotifyEvent;
    FEnableTimer: boolean;
    FTimer : TTimer;
    FOnStateChanged: TStateChangeEvent;
    FInterval: integer;
    FOnTimer: TNotifyEvent;
    FAfterOpen: TNotifyEvent;
    FOnPlayComplete: TNotifyEvent;
    FBasicAudio: IBasicAudio;
    function    GetCurrentPosition: double;
    function    GetDuration: double;
    function    GetRate: Double;
    procedure   SetCurrentPosition(const Value: double);
    procedure   SetFileName(const Value: string);
    procedure   SetRate(const Value: Double);
    procedure   SetOpened(const Value: boolean);
    procedure   SetEnableTimer(const Value: boolean);
    procedure   CreateTimer;
    procedure   DestroyTimer;
    procedure   DoTimer(sender : TObject);
    procedure   SetInterval(const Value: integer);
  protected
    procedure   GetInterfaces; virtual;
    procedure   ReleaseInterfaces; virtual;
    procedure   RaiseOptError;
    procedure   SetState(NewState : TMediaCtrlState);
  public
    Rewind :    boolean;
    // the interfaces
    property    MediaControl  : IMediaControl read FMediaControl;
    property    MediaEvent    : IMediaEvent read FMediaEvent;
    property    MediaPosition : IMediaPosition read FMediaPosition;
    property 		BasicAudio 		: IBasicAudio read FBasicAudio;
    //constructor Create(AOwner : TComponent); override;
    constructor Create;
    destructor  destroy; override;
    // normal operation
    property    FileName : string read FFileName write SetFileName;
    property    Opened : boolean read FOpened write SetOpened;
    procedure   Open;
    procedure   Play;
    // notes: this stop is not MediaControl.stop
    // first pause, then move to first
    procedure   Stop;
    procedure   Pause;
    procedure 	SafePlay;
		procedure   SafeStop;
    procedure   SafePause;
    procedure   Close;
    function    RunToEnd: boolean;
    procedure   LoadFromFile(const AFileName:string);
    // media infomation
    property    Duration : double read GetDuration;
    property    CurrentPosition : double
                  read GetCurrentPosition write SetCurrentPosition;
    property    Rate: Double read GetRate write SetRate;
    property    State : TMediaCtrlState read FState;
    property    OnClose : TNotifyEvent read FOnClose write FOnClose;
    property    EnableTimer : boolean read FEnableTimer write SetEnableTimer;
    property    OnStateChanged : TStateChangeEvent
                  read FOnStateChanged write FOnStateChanged;
    property    OnTimer : TNotifyEvent read FOnTimer write FOnTimer;
    property    Interval : integer
                  read FInterval write SetInterval default 1000;
    property    AfterOpen : TNotifyEvent
                  read FAfterOpen write FAfterOpen;
    property    OnPlayComplete : TNotifyEvent
                  read FOnPlayComplete write FOnPlayComplete;
  published

  end;

  TMovie = class(TActiveMovieObject)
  private
    FFullScreen: boolean;
    FMovieWidth: integer;
    FMovieHeight: integer;
    FVideoWindow: IVideoWindow;
    FActiveMovie: TActiveMovieObject;
    FVideoCtrl: TWincontrol;
    FMsgCtrl: TWincontrol;
    function    GetBoundsRect: TRect;
    function    GetMessageWindow: THandle;
    function    GetOwnerWindow: THandle;
    procedure   SetBoundsRect(const Value: TRect);
    procedure   SetFullScreen(const Value: boolean);
    procedure   SetMessageWindow(const Value: THandle);
    procedure   SetOwnerWindow(const Value: THandle);
    procedure   SetVideoCtrl(const Value: TWincontrol);
    function    GetFullScreen: boolean;
    procedure   SetMsgCtrl(const Value: TWincontrol);
  protected
    procedure   GetInterfaces; override;
    procedure   ReleaseInterfaces; override;
  public
    constructor Create;
    property    ActiveMovie : TActiveMovieObject
                  read FActiveMovie;
    property    FullScreen : boolean
                  read GetFullScreen write SetFullScreen;
    property    VideoWindow : IVideoWindow read FVideoWindow;
    property    MovieWidth : integer read FMovieWidth;
    property    MovieHeight : integer read FMovieHeight;
    property    OwnerWindow : THandle
                  read GetOwnerWindow write SetOwnerWindow;
    property    MessageWindow : THandle
                  read GetMessageWindow write SetMessageWindow;
    property    BoundsRect : TRect read GetBoundsRect write SetBoundsRect;
    property    VideoCtrl : TWincontrol read FVideoCtrl write SetVideoCtrl;
    property    MsgCtrl   : TWincontrol read FMsgCtrl write SetMsgCtrl;
    procedure   VideoFitCtrlSize;
    procedure   UpdateVideoWindow; // when VideoCtrl or MsgCtrl handle changed, call this method
    function 		HasVideo : boolean;
  published

  end;

  TMovieWnd = class(TCustomPanel)
  private
    FOpened:    boolean;
    FMovie:     TMovie;
    function    GetFileName: string;
    function    GetOpened: boolean;
    procedure   SetFileName(const Value: string);
    procedure   SetOpened(const Value: boolean);
    procedure   WMSize(var message : TWMSize);message WM_Size;
    function    GetInterval: integer;
    function    GetOnStateChanged: TStateChangeEvent;
    function    GetOnTimer: TNotifyEvent;
    procedure   SetInterval(const Value: integer);
    procedure   SetOnStateChanged(const Value: TStateChangeEvent);
    procedure   SetOnTimer(const Value: TNotifyEvent);
    function    getEnableTimer: boolean;
    procedure   SetEnableTimer(const Value: boolean);
    function    GetAfterOpen: TNotifyEvent;
    procedure   SetAfterOpen(const Value: TNotifyEvent);
    function    GetAutoRewind: boolean;
    procedure   SetAutoRewind(const Value: boolean);
    function 		GetOnPlayComplete: TNotifyEvent;
    procedure 	SetOnPlayComplete(const Value: TNotifyEvent);
    procedure 	WMPaint(var message : TWMPaint);message WM_Paint;
  protected
    procedure   Loaded; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  destroy; override;
    property    Movie : TMovie read FMovie;

    property    DockManager;
  published
    property    AutoRewind : boolean
                  read GetAutoRewind write SetAutoRewind default false;
    property    Opened: boolean
                  read GetOpened write SetOpened default false;
    property    FileName: string read GetFileName write SetFileName;
    property    OnStateChanged : TStateChangeEvent
                  read GetOnStateChanged write SetOnStateChanged;
    property    OnTimer : TNotifyEvent read GetOnTimer write SetOnTimer;
    property    AfterOpen : TNotifyEvent
                  read GetAfterOpen write SetAfterOpen;
    property    OnPlayComplete : TNotifyEvent
                  read GetOnPlayComplete write SetOnPlayComplete;
    property    Interval : integer
                  read GetInterval write SetInterval default 1000;
    property    EnableTimer : boolean
                  read getEnableTimer write SetEnableTimer default false;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BiDiMode;
    property BorderWidth;
    property BorderStyle;
    property Caption;
    property Color;
    property Constraints;
    property Ctl3D;
    property UseDockManager default True;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FullRepaint;
    property Font;
    property Locked;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  TAudio = class(TActiveMovieObject)
  private

  protected

  public

  published

  end;


implementation


{ TActiveMovieObject }

//constructor TActiveMovieObject.Create(AOwner: TComponent);
constructor TActiveMovieObject.Create;
begin
  //inherited Create(AOwner);
  inherited Create;
  FState := mcsNotReady;
  FEnableTimer := false;
  FTimer := nil;
  FInterval := 1000;
  Rewind := false; 
end;

destructor TActiveMovieObject.destroy;
begin
  OnTimer := nil;
  OnClose := nil;
  OnStateChanged := nil;
  close;
  DestroyTimer;
  inherited destroy;
end;

function TActiveMovieObject.GetCurrentPosition: double;
begin
  if FMediaPosition<>nil then
    result := FMediaPosition.CurrentPosition
  else
    result := 0;
end;

function TActiveMovieObject.GetDuration: double;
begin
  if FMediaPosition<>nil then
    result := FMediaPosition.Duration
  else
    result := 0;
end;

function TActiveMovieObject.GetRate: Double;
begin
  if FMediaPosition<>nil then
    result := FMediaPosition.Rate
  else
    result := 0;
end;

procedure TActiveMovieObject.LoadFromFile(const AFileName: string);
begin
  FFileName := AFileName;
  Open;
end;

procedure TActiveMovieObject.Open;
begin
  Close;
  try
    GetInterfaces;
    FMediaControl.pause;
    FOpened := true;
    SetState(mcsStopped);
    if assigned(AfterOpen) then
      AfterOpen(self);
  except
    Close;
  end;
end;

procedure TActiveMovieObject.Close;
begin
  try
    if assigned(FOnClose) then FOnClose(self);
  finally
    try
      SetState(mcsNotReady);
      FOpened := false;
      if EnableTimer then
        FTimer.Enabled := false;
    finally
      //FState := mcsNotReady;
      ReleaseInterfaces;
    end;
  end;
end;

procedure TActiveMovieObject.Pause;
begin
  if FMediaControl<>nil then
  begin
    FMediaControl.pause;
    //FState := mcsPaused;
    SetState(mcsPaused);
  end
  else
    RaiseOptError;
end;

procedure TActiveMovieObject.Play;
begin
  if FMediaControl<>nil then
  begin
    if Rewind and RunToEnd then
      FMediaPosition.CurrentPosition := 0;
    FMediaControl.Run;
    //FState := mcsRunning;
    SetState(mcsRunning);
    if EnableTimer then
      FTimer.Enabled := true;
  end
  else
    RaiseOptError;
end;

procedure TActiveMovieObject.SetCurrentPosition(const Value: double);
begin
  if FMediaPosition<>nil then
    FMediaPosition.CurrentPosition := value
  else
    RaiseOptError;
end;

procedure TActiveMovieObject.SetFileName(const Value: string);
begin
  if not FOpened then
    FFileName := Value
  else
    RaiseOptError;
end;

procedure TActiveMovieObject.SetRate(const Value: Double);
begin
  if FMediaPosition<>nil then
    FMediaPosition.rate:= value
  else
    RaiseOptError;
end;

procedure TActiveMovieObject.Stop;
begin
  if FMediaControl<>nil then
  begin
    FMediaControl.pause;
    FMediaPosition.CurrentPosition := 0;
    //FState := mcsStopped;
    SetState(mcsStopped);
  end
  else
    RaiseOptError;
end;

procedure TActiveMovieObject.SetOpened(const Value: boolean);
begin
  if FOpened <> Value then
    if Value then
      open
    else
      close;
end;

procedure TActiveMovieObject.RaiseOptError;
begin
  RaiseCannotDo('Cannot do this, because not opened.');
end;

procedure TActiveMovieObject.GetInterfaces;
begin
  FMediaControl := CoFilgraphManager.Create;
  FMediaControl.RenderFile(FFilename);
  FMediaPosition := MediaControl as IMediaPosition;
  FMediaEvent := MediaControl  as IMediaEvent;
  FBasicAudio := MediaControl  as IBasicAudio;
end;

procedure TActiveMovieObject.ReleaseInterfaces;
begin
	FBasicAudio := nil;
  FMediaEvent := nil;
  FMediaPosition := nil;
  FMediaControl := nil;
end;

procedure TActiveMovieObject.SetEnableTimer(const Value: boolean);
begin
  if FEnableTimer <> Value then
  begin
    if Value then
      CreateTimer
    else
      DestroyTimer;
  end;
end;

procedure TActiveMovieObject.CreateTimer;
begin
  DestroyTimer;
  FTimer := TTimer.Create(nil);
  FTimer.Interval := FInterval;
  FTimer.enabled := false;
  FTimer.OnTimer := DoTimer;
  FEnableTimer := true;
end;

procedure TActiveMovieObject.DestroyTimer;
begin
  if FTimer<>nil then
  begin
    FTimer.free;
    FTimer := nil;
    FEnableTimer := false;
  end;
end;

procedure TActiveMovieObject.SetState(NewState: TMediaCtrlState);
begin
  if (FState<>NewState) then
  begin
    try
      if assigned(FOnStateChanged) then
        FOnStateChanged(self,FState,NewState);
    finally
      FState := NewState;
    end;
  end;
end;

procedure TActiveMovieObject.DoTimer(sender: TObject);
begin
  if Assigned(OnTimer) then
      OnTimer(self);
  if FState=mcsRunning then
  begin
    if RunToEnd then
    begin
      FTimer.Enabled := false;
      Pause;
      if Assigned(OnPlayComplete) then
        OnPlayComplete(self);
    end;
  end
  else
    FTimer.Enabled := false;
end;

procedure TActiveMovieObject.SetInterval(const Value: integer);
begin
  if FInterval <> Value then
  begin
    FInterval := Value;
    if EnableTimer then
      FTimer.Interval := FInterval;
  end;
end;

function TActiveMovieObject.RunToEnd: boolean;
begin
  if FOpened then
    result := MediaPosition.CurrentPosition>=
        MediaPosition.Duration
  else
    result := false;
end;

{ TMovie }

procedure TMovie.GetInterfaces;
var
  BasicVideo : IBasicVideo;
begin
  inherited GetInterfaces;
  FMovieWidth := 0;
  FMovieHeight := 0;
  try
	  //FVideoWindow := FMediaControl as IVideoWindow;
    FMediaControl.QueryInterface(IVideoWindow,FVideoWindow);
    if FVideoWindow<>nil then
    begin
	  	//BasicVideo := FVideoWindow as IBasicVideo;
      //FVideoWindow.QueryInterface(IBasicVideo,BasicVideo);
      FMediaControl.QueryInterface(IBasicVideo,BasicVideo);
      if BasicVideo<>nil then
      begin
			  FMovieWidth := BasicVideo.VideoWidth;
  			FMovieHeight := BasicVideo.VideoHeight;
      end;
    end;
	  UpdateVideoWindow;
  except
    FVideoWindow := nil;
  end;
end;

procedure TMovie.ReleaseInterfaces;
begin
  try
    if FVideoWindow<>nil then
    begin
    // for ActiveMovie 1.0
      FVideoWindow.Visible := 0;
      FVideoWindow.Owner := 0;
    end;
  finally
    try
      FVideoWindow := nil;
    finally
      inherited ReleaseInterfaces;
    end;
  end;
end;

function TMovie.GetBoundsRect: TRect;
begin
  if FVideoWindow <> nil then
    result := rect(FVideoWindow.left,
      FVideoWindow.Top,
      FVideoWindow.left + FVideoWindow.Width,
      FVideoWindow.Top + FVideoWindow.Height)
  else
    result := rect(0,0,0,0);
end;

function TMovie.GetMessageWindow: THandle;
begin
  if FVideoWindow <> nil then
    result := FVideoWindow.MessageDrain
  else
    result := 0;
end;

function TMovie.GetOwnerWindow: THandle;
begin
  if FVideoWindow <> nil then
    result := FVideoWindow.Owner
  else
    result := 0;
end;


procedure TMovie.SetBoundsRect(const Value: TRect);
begin
  if FVideoWindow <> nil then
    FVideoWindow.SetWindowPosition
      (value.left,
      value.top,
      value.Right-value.left,
      value.Bottom-value.top);
end;

procedure TMovie.SetFullScreen(const Value: boolean);
begin
  FFullScreen := Value;
  if FVideoWindow <> nil then
    FVideoWindow.FullScreenMode :=
      Integer(Longbool(FFullScreen));
end;

procedure TMovie.SetMessageWindow(const Value: THandle);
begin
  if FVideoWindow <> nil then
    FVideoWindow.MessageDrain := Value
  else
    RaiseOptError;
end;

procedure TMovie.SetOwnerWindow(const Value: THandle);
begin
  if FVideoWindow <> nil then
  begin
    if Value<>0 then
      FVideoWindow.WindowStyle := $6000000;
    FVideoWindow.Owner := Value;  
  end
  else
    RaiseOptError;
end;


procedure TMovie.SetVideoCtrl(const Value: TWincontrol);
begin
  if FVideoCtrl <> Value then
  begin
    FVideoCtrl := Value;
    UpdateVideoWindow;
  end;
end;

constructor TMovie.Create;
begin
  inherited Create;
end;

procedure TMovie.UpdateVideoWindow;
begin
  if FVideoWindow<>nil then
  with FVideoWindow do
  begin
    if FVideoCtrl=nil then
    begin
      Owner := 0;
      //MessageDrain := 0;
    end
    else
    begin
      WindowStyle := $6000000;
      Owner := FVideoCtrl.handle;
      //MessageDrain := FVideoCtrl.handle;
      SetWindowPosition(0,0,
        FVideoCtrl.ClientWidth,
        FVideoCtrl.ClientHeight);
      FullScreenMode :=
        Integer(Longbool(FFullScreen));
    end;
    if MsgCtrl=nil then
      MessageDrain := 0
    else
      MessageDrain := MsgCtrl.handle;
  end;
end;

procedure TMovie.VideoFitCtrlSize;
begin
  if (FVideoCtrl<>nil) and (FVideoWindow<>nil) then
  begin
    FullScreen := false;
    FVideoWindow.SetWindowPosition(0,0,
        FVideoCtrl.ClientWidth,
        FVideoCtrl.ClientHeight);
  end
  //else RaiseOptError;
end;

function TMovie.GetFullScreen: boolean;
begin
  if FVideoWindow<>nil then
  begin
    FFullScreen := longbool(FVideoWindow.FullScreenMode);
    result := FFullScreen;
  end
  else result := FFullScreen;
end;

procedure TMovie.SetMsgCtrl(const Value: TWincontrol);
begin
  if FMsgCtrl <> Value then
  begin
    FMsgCtrl := Value;
    if FVideoWindow<>nil then
    if (FMsgCtrl=nil) then
      MessageWindow := 0
    else
      if FMsgCtrl.HandleAllocated then
        MessageWindow := FMsgCtrl.handle
      else
        MessageWindow := 0;
  end;
end;

function TMovie.HasVideo: boolean;
begin
  result := FVideoWindow<>nil;
end;

{ TMovieWnd }

constructor TMovieWnd.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMovie:= TMovie.Create;
  FMovie.VideoCtrl := self;
  FMovie.MsgCtrl := self;
end;

destructor TMovieWnd.destroy;
begin
  Movie.free;
  inherited destroy;
end;

function TMovieWnd.GetAfterOpen: TNotifyEvent;
begin
  result := Movie.AfterOpen;
end;

function TMovieWnd.GetAutoRewind: boolean;
begin
  result := Movie.Rewind;
end;

function TMovieWnd.getEnableTimer: boolean;
begin
  result := Movie.EnableTimer;
end;

function TMovieWnd.GetFileName: string;
begin
  result := Movie.FileName;
end;

function TMovieWnd.GetInterval: integer;
begin
  result := Movie.Interval;
end;

function TMovieWnd.GetOnStateChanged: TStateChangeEvent;
begin
  result := Movie.OnStateChanged;
end;

function TMovieWnd.GetOnTimer: TNotifyEvent;
begin
  result := Movie.OnTimer;
end;

function TMovieWnd.GetOpened: boolean;
begin
  result := Movie.Opened;
end;

function TMovieWnd.GetOnPlayComplete: TNotifyEvent;
begin
  result := Movie.OnPlayComplete;
end;

procedure TMovieWnd.Loaded;
begin
  inherited Loaded;
  Movie.Opened := FOpened;
end;

procedure TMovieWnd.SetAfterOpen(const Value: TNotifyEvent);
begin
  Movie.AfterOpen := value;
end;

procedure TMovieWnd.SetAutoRewind(const Value: boolean);
begin
  Movie.Rewind := value;
end;

procedure TMovieWnd.SetEnableTimer(const Value: boolean);
begin
  Movie.EnableTimer := value;
end;

procedure TMovieWnd.SetFileName(const Value: string);
begin
  Movie.FileName := Value;
end;

procedure TMovieWnd.SetInterval(const Value: integer);
begin
  movie.Interval := value;
end;

procedure TMovieWnd.SetOnStateChanged(const Value: TStateChangeEvent);
begin
  movie.OnStateChanged := value;
end;

procedure TMovieWnd.SetOnTimer(const Value: TNotifyEvent);
begin
  movie.OnTimer := value;
end;

procedure TMovieWnd.SetOpened(const Value: boolean);
begin
  if csLoading in componentState then
    FOpened := Value
  else
    Movie.Opened := value;
end;

procedure TMovieWnd.SetOnPlayComplete(const Value: TNotifyEvent);
begin
  Movie.OnPlayComplete := value;
end;

procedure TMovieWnd.WMSize(var message: TWMSize);
begin
  inherited;
  if Movie.Opened then
    Movie.VideoFitCtrlSize;
end;


procedure TActiveMovieObject.SafePause;
begin
  if state in [mcsStopped,mcsRunning] then
    Pause;
end;

procedure TActiveMovieObject.SafePlay;
begin
  if state in [mcsStopped,mcsPaused] then
    play;
end;

procedure TActiveMovieObject.SafeStop;
begin
  if state in [mcsPaused,mcsRunning] then
    Stop;
end;

procedure TMovieWnd.WMPaint(var message: TWMPaint);
var
	hWnd : THandle;
begin
// override WM_Paint to enforce paint the movie
  if Opened then
  begin
    hWnd := GetWindow(handle,GW_CHILD);
    if hWnd<>0 then
	    SendMessage(hWnd,WM_paint,0,0);
    //Must call DefaultHandler to validate update region
    DefaultHandler(Message);
  end
  else
  	inherited ;
end;

end.
