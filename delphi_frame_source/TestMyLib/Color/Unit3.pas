unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids;

type
  TForm1 = class(TForm)
    DrawGrid1: TDrawGrid;
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses ColorUtils;

{$R *.DFM}

procedure TForm1.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  index : integer;
begin
  index := acol + arow * 12;
  with DrawGrid1.Canvas do
  begin
    Brush.color := getColorFromReserved(index);
    FillRect(rect);
  end;
end;

end.
