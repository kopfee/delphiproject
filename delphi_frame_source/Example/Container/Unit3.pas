unit Unit3;

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms,container;

type
  TContainer3 = class(TContainer)
    Label1: TLabel;
    Memo1: TMemo;
    Button1: TButton;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Label2: TLabel;
    ListBox1: TListBox;
  private

  public

  end;

var
  Container3: TContainer3;

implementation

{$R *.DFM}

initialization

registerClass(TContainer3);

end.
