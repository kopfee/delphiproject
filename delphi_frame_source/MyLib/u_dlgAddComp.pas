unit u_dlgAddComp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TdlgAddComponentsToGroup = class(TForm)
    Label1: TLabel;
    cbCompClass: TComboBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgAddComponentsToGroup: TdlgAddComponentsToGroup;

// if user click OK return true.
function QueryAddComponents(var ComponentClassName : string):boolean;

implementation

{$R *.DFM}

function QueryAddComponents(var ComponentClassName : string):boolean;
begin
  dlgAddComponentsToGroup:= TdlgAddComponentsToGroup.Create(Application);
  try
    result := dlgAddComponentsToGroup.showModal=mrOK;
    if result then
      ComponentClassName :=
        dlgAddComponentsToGroup.cbCompClass.Text;
  finally
    dlgAddComponentsToGroup.free;
  end;
end;

end.
