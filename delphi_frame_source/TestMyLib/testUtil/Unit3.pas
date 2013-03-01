unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,Component1;

type
  TfmChild = class(TForm)
    btnDelete: TButton;
    btnCreate: TButton;
    procedure btnCreateClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    AButton : TButton;
  end;

var
  fmChild: TfmChild;

implementation

uses Unit2;

{$R *.DFM}

procedure TfmChild.btnCreateClick(Sender: TObject);
begin
  AButton := TButton.create(self);
  InsertControl(AButton);
  fmMain.AComponent1.MyComponent := AButton;
  btnCreate.enabled := false;
  btnDelete.enabled := true;
end;

procedure TfmChild.btnDeleteClick(Sender: TObject);
begin
  AButton.free;
  btnCreate.enabled := true;
  btnDelete.enabled := false;
end;

end.
