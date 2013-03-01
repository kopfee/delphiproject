unit UMovie5;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OleCtrls, AMovie_TLB, ActiveMovieEx;

type
  TForm1 = class(TForm)
    ActiveMovieEx1: TActiveMovieEx;
    CheckBox1: TCheckBox;
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  with ActiveMovieEx1 do
  begin
    BeginSetproperty;
    AllowChangeDisplayMode := false;
    EndSetproperty;
  end;
end;

end.
