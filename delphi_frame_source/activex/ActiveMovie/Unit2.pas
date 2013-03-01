unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs,QuartzTypeLib_TLB, StdCtrls, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Panel1: TPanel;
    Timer1: TTimer;
    Label2: TLabel;
    Label3: TLabel;
    TrackBar1: TTrackBar;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private
    { Private declarations }
    MediaControl  : IMediaControl;
    BasicAudio    : IBasicAudio;
    VideoWindow   : IVideoWindow;
    MediaEvent    : IMediaEvent;
    MediaPosition : IMediaPosition;
  public
    { Public declarations }

  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  //MediaControl := CoFilgraphManager.Create;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    Edit1.text := OpenDialog1.FileName;
    Button2Click(Sender);
  end;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  MediaControl := nil;
  MediaControl := CoFilgraphManager.Create;
  //MediaControl.stop;
  MediaPosition := nil;
  BasicAudio := nil;
  VideoWindow :=nil;
  MediaEvent :=nil;

  MediaControl.RenderFile(Edit1.text);
  //MediaControl.StopWhenReady;

  MediaPosition := MediaControl as IMediaPosition;
  BasicAudio := MediaControl as IBasicAudio;
  VideoWindow := MediaControl as IVideoWindow;
  MediaEvent := MediaControl  as IMediaEvent;

  VideoWindow.WindowStyle := $6000000;
  VideoWindow.Left := 0;//Panel1.Left;
  VideoWindow.Top := 0;//Panel1.Top)
  //Panel1.Width := VideoWindow.Width;
  VideoWindow.Width := Panel1.ClientWidth;
  //Panel1.Height := VideoWindow.Height;
  VideoWindow.Height := Panel1.ClientHeight;
  VideoWindow.Owner := Panel1.Handle;
  //VideoWindow.AutoShow:=integer(true);
  VideoWindow.AutoShow:=-1;

  MediaPosition.CurrentPosition := 0;
  TrackBar1.max := Round(MediaPosition.Duration);
  TrackBar1.Position := 0;
  MediaControl.pause;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  MediaControl.Run;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  MediaControl.Pause;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  //MediaControl.Stop;
  MediaControl.Pause;
  MediaPosition.CurrentPosition := 0;
  //MediaControl.Pause;
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
    TrackBar1.Position := Round(MediaPosition.CurrentPosition);
  end;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  if MediaPosition<>nil then
    MediaPosition.CurrentPosition := TrackBar1.Position;
end;

end.
