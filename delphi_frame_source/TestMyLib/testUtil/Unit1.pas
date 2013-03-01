unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,Component1;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    btnDelete: TButton;
    btnCreate: TButton;
    Label2: TLabel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure ComponentChanged(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    AButton : TButton;
    AComponent1 : TComponent1;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.ComponentChanged(Sender: TObject);
begin
  if AComponent1.Mycomponent<>nil then
    label1.caption := AComponent1.Mycomponent.classname
  else label1.caption := 'nil';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  AComponent1 := TComponent1.create(self);
  AComponent1.OnComponentChanged := ComponentChanged;
end;

procedure TForm1.btnCreateClick(Sender: TObject);
begin
  AButton := TButton.create(self);
  InsertControl(AButton);
  AComponent1.MyComponent := AButton;
  btnCreate.enabled := false;
  btnDelete.enabled := true;
end;

procedure TForm1.btnDeleteClick(Sender: TObject);
begin
  AButton.free;
  btnCreate.enabled := true;
  btnDelete.enabled := false;
end;

end.
