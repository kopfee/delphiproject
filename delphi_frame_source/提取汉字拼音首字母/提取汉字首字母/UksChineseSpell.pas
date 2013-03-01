unit UksChineseSpell;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,kschinesespell;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  var mytest:TKsChineseSpell;
implementation

{$R *.DFM}
procedure TForm1.FormCreate(Sender: TObject);
begin
  mytest:=TKsChineseSpell.create(self);
  mytest.name:='mytest1';
  mytest.parent:=form1;
  mytest.visible:=true;
  mytest.IsSkip :=false;
  mytest.show;
end;

end.
