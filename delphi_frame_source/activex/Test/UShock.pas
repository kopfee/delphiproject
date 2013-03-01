unit UShock;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OleCtrls, DIRECTORSHOCKWAVELib_TLB;

type
  TForm1 = class(TForm)
    ShockwaveCtl1: TShockwaveCtl;
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
  ShockwaveCtl1.play;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ShockwaveCtl1.GotoMovie('file://E:\EBook2\FileVersion\test.avi');
end;

end.
