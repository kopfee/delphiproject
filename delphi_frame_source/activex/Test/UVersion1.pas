unit UVersion1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, AMovie_TLB, StdCtrls;

type
  TForm1 = class(TForm)
    ActiveMovie1: TActiveMovie;
    Button1: TButton;
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
  ActiveMovie1.Run;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ActiveMovie1.stop;
end;

end.
