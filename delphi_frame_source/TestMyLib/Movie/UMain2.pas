unit UMain2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Container, MovieViewer, Menus;

type
  TForm1 = class(TForm)
    MovieView1: TMovieView;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Exit1: TMenuItem;
    OpenDialog1: TOpenDialog;
    N1: TMenuItem;
    N2: TMenuItem;
    miShowCtrl: TMenuItem;
    miRepeat: TMenuItem;
    procedure MovieView1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure miShowCtrlClick(Sender: TObject);
    procedure MovieView1PlayComplete(Sender: TObject);
    procedure miRepeatClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses  AMovieUtils;

procedure TForm1.MovieView1Click(Sender: TObject);
begin
  if MovieView1.State in [mcsStopped,mcsPaused] then
    MovieView1.Play
  else
    if MovieView1.State=mcsRunning then
      MovieView1.Pause;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Open1Click(Sender: TObject);
begin
  if OpenDialog1.execute then
  begin
    //MovieView1.close;
    MovieView1.OpenFile(OpenDialog1.FileName);
  end;
end;

procedure TForm1.miShowCtrlClick(Sender: TObject);
begin
  miShowCtrl.checked := not miShowCtrl.checked;
  MovieView1.CtrlVisible := miShowCtrl.checked;
end;

procedure TForm1.MovieView1PlayComplete(Sender: TObject);
begin
  if miRepeat.checked then
    MovieView1.play;
end;

procedure TForm1.miRepeatClick(Sender: TObject);
begin
  miRepeat.checked := not miRepeat.checked;
end;

end.
