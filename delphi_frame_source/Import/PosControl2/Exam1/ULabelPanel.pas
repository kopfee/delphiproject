unit ULabelPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, PLabelPanel;

type
  TForm1 = class(TForm)
    PLabelPanel1: TPLabelPanel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

type
  TControlAccess = class(TControl);

procedure TForm1.Button1Click(Sender: TObject);
begin
  edit1.text := TControlAccess(PLabelPanel1).Text;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  TControlAccess(PLabelPanel1).Text := edit1.text;
end;

end.
