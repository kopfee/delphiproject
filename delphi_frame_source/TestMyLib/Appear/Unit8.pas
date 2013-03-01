unit Unit8;

// Change The Implement of Transparent Property of CoolButton to Resolve Bug!

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BkGround, ComWriUtils, CoolCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    CoolButton1: TCoolButton;
    CoolButton2: TCoolButton;
    CoolButton3: TCoolButton;
    ButtonOutlook1: TButtonOutlook;
    BackGround1: TBackGround;
    CoolButton4: TCoolButton;
    CoolButton5: TCoolButton;
    CoolButton6: TCoolButton;
    ButtonOutlook2: TButtonOutlook;
    Edit1: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

initialization
  RegisterNotTransparentControlClass(TCoolButton);
end.
   