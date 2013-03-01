unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,Design;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Designer : TDesigner;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var
  AButton : TButton;
begin
  Designer := TDesigner.Create(self);
  Designer.Align:=alClient;
  Designer.Parent := self;
  AButton := TButton.Create(self);
  AButton.caption := 'Test';
  AButton.left := 10;
  AButton.top	:= 10;
  AButton.parent := Designer;
end;

end.
