unit UMovie;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, AMovie_TLB, StdCtrls;

type
  TForm1 = class(TForm)
    ActiveMovie1: TActiveMovie;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    First : boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  // do this will show a popup movie window.
  //ActiveMovie1.FileName := 'e:\ebook2\fileversion\test.avi';
  // do this will show an embeded movie window.
  First := true;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if first then
  begin
    first := false;
    ActiveMovie1.FileName := 'e:\ebook2\fileversion\test.avi';
  end;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  // these codes raise an error
  // because ActiveMovie cannot set property at runtime. 
  if CheckBox1.Checked then
    ActiveMovie1.borderStyle := 1
  else
    ActiveMovie1.borderStyle := 0;
end;

end.
