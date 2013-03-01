unit Unit2;

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms,container;

type
  TContainer2 = class(TContainer)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Label2: TLabel;
    Edit2: TEdit;
    Button2: TButton;
    ListBox1: TListBox;
    CheckBox1: TCheckBox;
    RadioButton1: TRadioButton;
  private

  public

  end;

var
  Container2: TContainer2;

implementation

{$R *.DFM}

initialization

registerClass(TContainer2);

end.
