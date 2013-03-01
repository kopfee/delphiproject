unit UMovie6;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, AMovie_TLB, ComCtrls, StdCtrls, ExtCtrls, ActiveMovieEx;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    Panel1: TPanel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    OpenDialog1: TOpenDialog;
    ActiveMovie1: TActiveMovie;
    ActiveMovie2: TActiveMovie;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.execute then
  begin
    Edit1.text := OpenDialog1.FileName;
    Button2Click(Sender);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  {ActiveMovie1.ShowTracker := false;
  ActiveMovie1.ShowControls := false;
  ActiveMovie2.ShowTracker := false;
  ActiveMovie2.ShowControls := false;
  }
  ActiveMovie1.FileName := Edit1.text;
  ActiveMovie2.FileName := Edit1.text;
  {
  ActiveMovie1.ShowControls := true;
  ActiveMovie1.ShowTracker := true;
  ActiveMovie2.ShowControls := true;
  ActiveMovie2.ShowTracker := true;
  }
end;

end.
