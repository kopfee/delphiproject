unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs,PECtrls, StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CompEditor : TCompEditor;
    PELink : TPELink;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  CompEditor := TCompEditor.Create(self);
  CompEditor.EditingComponent := Edit1;
  CompEditor.Immediate := true;
  PELink := TPELink.Create(self);
  PELink.Source := CompEditor;
  PELink.EditCtrl := Edit2;
	PELink.PropName := 'Text';
  PELink.CtrlPropName := 'Text';
	PELink.EventName := 'OnChange';
end;

end.
