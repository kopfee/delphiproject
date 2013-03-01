unit outmod;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, Buttons;

type
  TForm2 = class(TForm)
    btnRead: TBitBtn;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    btnWrite: TBitBtn;
    BitBtn1: TBitBtn;
    MainMenu1: TMainMenu;
    Read1: TMenuItem;
    Write1: TMenuItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

end.
