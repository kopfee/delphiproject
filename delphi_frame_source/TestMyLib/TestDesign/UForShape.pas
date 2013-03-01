unit UForShape;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Design, jpeg, BkGround;

type
  TForm1 = class(TForm)
    BackGround1: TBackGround;
    Designer1: TDesigner;
    Shape1: TShape;
    Button1: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

end.
