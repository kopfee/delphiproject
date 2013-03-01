unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,container;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FContainer : Tcontainer;
    procedure LayContainer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Unit2, Unit3;

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  FreeAndNil(FContainer);
  FContainer := TContainer2.CreateWithParent(self,Panel2);
  LayContainer;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  FreeAndNil(FContainer);
  FContainer := TContainer3.CreateWithParent(self,Panel2);
  LayContainer;
end;

procedure TForm1.LayContainer;
begin
  with FContainer do
  begin
    Visible:=true;
    SetBounds(0,0,10,10);
    Align := alClient;
    //Parent := self.Panel2;
  end;
end;


end.
