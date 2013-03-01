unit UVersionX;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, AMovie_TLB, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Bevel1: TBevel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    ActiveMovie1: TActiveMovie;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  ActiveMovie1.Run;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ActiveMovie1.stop;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  ActiveMovie1:= TActiveMovie.Create(self);
  ActiveMovie1.parent := self;
  {ActiveMovie1.ShowDisplay := false;
  ActiveMovie1.ShowControls := false;}
  ActiveMovie1.FileName:='150.avi';
  //ActiveMovie1.BoundsRect := Bevel1.BoundsRect;
  ActiveMovie1.left := Bevel1.left;
  ActiveMovie1.Top := Bevel1.top;
end;

end.
