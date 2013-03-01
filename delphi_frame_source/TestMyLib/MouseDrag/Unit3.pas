unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Shape1: TShape;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure OnEndDrag(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses DragMoveUtils;

procedure TForm1.FormCreate(Sender: TObject);
begin
  InstallDragFrame(Panel1,true,OnEndDrag);
end;

procedure TForm1.OnEndDrag(Sender: TObject);
var
	r : TRect;
begin
  r := TDragFrame(sender).GetDragRect;
  Shape1.SetBounds(r.left,r.top,
  	r.right-r.left,
    r.bottom-r.top);
end;

end.
