unit UForMovie;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OleCtrls, AMovie_TLB, ExtCtrls, Design;

type
  TForm1 = class(TForm)
    Designer1: TDesigner;
    ActiveMovie1: TActiveMovie;
    ComboBox1: TComboBox;
    Button1: TButton;
    Label1: TLabel;
    procedure Designer1DesignCtrlChanged(DesignCtrl: TControl);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Designer1DesignCtrlChanged(DesignCtrl: TControl);
begin
  if DesignCtrl=nil then
  	label1.caption := 'nil'
  else
    label1.caption := DesignCtrl.Classname;
end;

end.
