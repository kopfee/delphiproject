unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,DragMoveUtils, StdCtrls, jpeg;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Image1: TImage;
    Shape1: TShape;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Drager : TGrabBoard;
    Drager2 : TGrabBoard;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Drager := TGrabBoard.Create(self);
  Drager.parent := self;
  Drager.DestCtrl := panel1;
  Drager2 := TGrabBoard.Create(self);
  Drager2.parent := self;
  Drager2.DestCtrl := shape1;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
	Drager2.free;
  Drager.free;
end;

end.
