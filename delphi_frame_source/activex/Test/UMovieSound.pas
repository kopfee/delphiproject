unit UMovieSound;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OleCtrls, AMovie_TLB;

type
  TForm1 = class(TForm)
    ActiveMovie1: TActiveMovie;
    Edit1: TEdit;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Button2: TButton;
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
    Edit1.text := OpenDialog1.Filename;
    Button2Click(Sender);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ActiveMovie1.FileName :=Edit1.text;
end;

end.
