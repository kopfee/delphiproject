unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons,Container;

type
  TContainer1 = class(TContainer)
    Label1: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Container1 : TContainer1;

implementation

{$R *.DFM}

procedure TContainer1.Button1Click(Sender: TObject);
begin
  label1.caption := 'clicked';
end;

initialization

registerClass(TContainer1);

end.
