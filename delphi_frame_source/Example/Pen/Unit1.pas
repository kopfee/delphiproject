unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtDialogs, CoolCtrls;

type
  TForm1 = class(TForm)
    PenExample1: TPenExample;
    PenDialog1: TPenDialog;
    procedure PenExample1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.PenExample1Click(Sender: TObject);
begin
  PenDialog1.Pen := PenExample1.Pen;
  if PenDialog1.Execute then
    PenExample1.Pen := PenDialog1.Pen;
end;

end.
