unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,Component1;

type
  TfmMain = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure ComponentChanged(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    AComponent1 : TComponent1;
  end;

var
  fmMain: TfmMain;

implementation

uses Unit3;

{$R *.DFM}

procedure TfmMain.ComponentChanged(Sender: TObject);
begin
  if AComponent1.Mycomponent<>nil then
    label1.caption := AComponent1.Mycomponent.classname
  else label1.caption := 'nil';
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  AComponent1 := TComponent1.create(self);
  AComponent1.OnComponentChanged := ComponentChanged;
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
  fmChild.Show;
end;

end.
