unit Unit7;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AppearUtils, StdCtrls, CoolCtrls, AbilityManager, ImgList, Spin,
  ComWriUtils, jpeg, ExtCtrls, Buttons;

type
  TForm1 = class(TForm)
    amCtrls: TGroupAbilityManager;
    ImageList1: TImageList;
    cbEnabled: TCheckBox;
    CoolButton1: TCoolButton;
    CtrlOutlook1: TButtonOutlook;
    CoolButton2: TCoolButton;
    CoolButton4: TCoolButton;
    CoolButton5: TCoolButton;
    CtrlOutlook2: TButtonOutlook;
    CtrlOutlook3: TButtonOutlook;
    CoolButton7: TCoolButton;
    CoolButton8: TCoolButton;
    cbConfig: TCheckBox;
    Image1: TImage;
    CoolButton3: TCoolButton;
    ImageList2: TImageList;
    LabelOutlook1: TLabelOutlook;
    CoolLabelX1: TCoolLabelX;
    LabelOutlook2: TLabelOutlook;
    CoolLabelX2: TCoolLabelX;
    CoolButton6: TCoolButton;
    ButtonOutlook1: TButtonOutlook;
    ButtonOutlook2: TButtonOutlook;
    CoolButton9: TCoolButton;
    CoolButton10: TCoolButton;
    CoolButton11: TCoolButton;
    SpeedButton1: TSpeedButton;
    procedure cbEnabledClick(Sender: TObject);
    procedure TestBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses BtnLookCfgDLG;

procedure TForm1.cbEnabledClick(Sender: TObject);
begin
  amCtrls.Enabled := cbEnabled.Checked;
end;

procedure TForm1.TestBtnClick(Sender: TObject);
var
  dlg : TdlgCfgBtnLook;
begin
  if cbConfig.Checked then
  begin
    dlg := TdlgCfgBtnLook.Create(Application);
    try
      dlg.Execute(TCoolButton(Sender).Outlook);
    finally
      dlg.free;
    end;
  end;
end;

end.
