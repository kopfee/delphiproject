unit BtnLookCfgDLG;

// %BtnLookCfgDLG : 设置按键的外观的界面
(*****   Code Written By Huang YanLai   *****)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Spin, ExtCtrls, CompGroup, ImgList, CoolCtrls,
  ComWriUtils;

type
  TdlgCfgBtnLook = class(TForm)
    Bevel1: TBevel;
    cbShadowed: TCheckBox;
    FontDialog1: TFontDialog;
    ColorDialog1: TColorDialog;
    GroupBox1: TGroupBox;
    apNormal: TAppearanceProxy;
    apMouseOver: TAppearanceProxy;
    apMouseDown: TAppearanceProxy;
    apDisable: TAppearanceProxy;
    seX: TSpinEdit;
    seY: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    cbEnable: TCheckBox;
    cbShadowImage: TCheckBox;
    cbShadowItalic: TCheckBox;
    apShadow: TAppearanceProxy;
    Label3: TLabel;
    cbxLayout: TComboBox;
    seMargin: TSpinEdit;
    seSpace: TSpinEdit;
    Label4: TLabel;
    labelx: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    btnReset: TBitBtn;
    CoolCtrlTest: TCoolButton;
    CtrlOutlook: TButtonOutlook;
    cbFlat: TCheckBox;
    apBright: TAppearanceProxy;
    apDull: TAppearanceProxy;
    Label5: TLabel;
    seWidth: TSpinEdit;
    procedure cbEnableClick(Sender: TObject);
    procedure apMouseOverFontChanged(Sender: TObject);
    procedure apMouseDownFontChanged(Sender: TObject);
    procedure apDisableFontChanged(Sender: TObject);
    procedure apShadowColorChanged(Sender: TObject);
    procedure cbShadowedClick(Sender: TObject);
    procedure cbShadowImageClick(Sender: TObject);
    procedure cbShadowItalicClick(Sender: TObject);
    procedure cbxLayoutChange(Sender: TObject);
    procedure seXChange(Sender: TObject);
    procedure seYChange(Sender: TObject);
    procedure seMarginChange(Sender: TObject);
    procedure seSpaceChange(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure apNormalFontChanged(Sender: TObject);
    procedure apNormalColorChanged(Sender: TObject);
    procedure apMouseOverColorChanged(Sender: TObject);
    procedure apMouseDownColorChanged(Sender: TObject);
    procedure apDisableColorChanged(Sender: TObject);
    procedure cbFlatClick(Sender: TObject);
    procedure apBrightColorChanged(Sender: TObject);
    procedure apDullColorChanged(Sender: TObject);
    procedure seWidthChange(Sender: TObject);
  private
    { Private declarations }
    DesignCtrlLook : TButtonOutlook;
    Updating : boolean;
    procedure Reset;
  public
    { Public declarations }
    function Execute(CtrlLook : TButtonOutlook): boolean;
  end;

var
  dlgCfgBtnLook: TdlgCfgBtnLook;

implementation

{$R *.DFM}

{ TdlgCfgLabelLook }

function TdlgCfgBtnLook.Execute(CtrlLook: TButtonOutlook): boolean;
begin
  DesignCtrlLook := CtrlLook;
  Reset;
  result := Showmodal=mrOk;
  if result and (CtrlLook<>nil) then
    CtrlLook.Assign(CtrlOutlook);
end;

procedure TdlgCfgBtnLook.cbEnableClick(Sender: TObject);
begin
  CoolCtrlTest.Enabled := cbEnable.Checked;
end;

procedure TdlgCfgBtnLook.apMouseOverFontChanged(Sender: TObject);
begin
  if not updating then CtrlOutlook.MouseOverFont := apMouseOver.Font;
end;

procedure TdlgCfgBtnLook.apMouseDownFontChanged(Sender: TObject);
begin
  if not updating then CtrlOutlook.MouseDownFont := apMouseDown.Font;
end;

procedure TdlgCfgBtnLook.apDisableFontChanged(Sender: TObject);
begin
  if not updating then CtrlOutlook.DisabledFont:= apDisable.Font;
end;

procedure TdlgCfgBtnLook.apShadowColorChanged(Sender: TObject);
begin
  if not updating then CtrlOutlook.ShadowColor := apShadow.Color;
end;

procedure TdlgCfgBtnLook.cbShadowedClick(Sender: TObject);
begin
  CtrlOutlook.Shadowed := cbShadowed.Checked;
end;

procedure TdlgCfgBtnLook.cbShadowImageClick(Sender: TObject);
begin
  CtrlOutlook.ShadowImage := cbShadowImage.Checked;
end;

procedure TdlgCfgBtnLook.cbShadowItalicClick(Sender: TObject);
begin
  CtrlOutlook.ShadowItalic:= cbShadowItalic.Checked;
end;

procedure TdlgCfgBtnLook.cbxLayoutChange(Sender: TObject);
begin
  CtrlOutlook.Layout := TButtonLayout(cbxLayout.ItemIndex);
end;

procedure TdlgCfgBtnLook.seXChange(Sender: TObject);
begin
  CtrlOutlook.ShadowXIns := seX.Value;
end;

procedure TdlgCfgBtnLook.seYChange(Sender: TObject);
begin
  CtrlOutlook.ShadowYIns := seY.Value;
end;

procedure TdlgCfgBtnLook.seMarginChange(Sender: TObject);
begin
  CtrlOutlook.Margin := seMargin.Value;
end;

procedure TdlgCfgBtnLook.seSpaceChange(Sender: TObject);
begin
  CtrlOutlook.Spacing := seSpace.Value;
end;

procedure TdlgCfgBtnLook.btnResetClick(Sender: TObject);
begin
  Reset;
end;

procedure TdlgCfgBtnLook.Reset;
begin
  if DesignCtrlLook<>nil then
  begin
    CtrlOutlook.Assign(DesignCtrlLook);
  end;
  Updating := true;
    with CtrlOutlook do
    begin
      apNormal.Font := Font;
      apNormal.Color := color;
      apMouseOver.Font := MouseOverFont;
      apMouseOver.Color := MouseOverColor;
      apMouseDown.Font := MouseDownFont;
      apMouseDown.Color := MouseDownColor;
      apDisable.Font := DisabledFont;
      apDisable.Color := DisabledColor;
      apShadow.Color := ShadowColor;
      cbShadowed.Checked := Shadowed;
      cbShadowImage.Checked := ShadowImage;
      cbShadowItalic.Checked := ShadowItalic;
      cbxLayout.ItemIndex := integer(Layout);
      seSpace.value := Spacing;
      seMargin.Value := Margin;
      seX.Value := ShadowXIns;
      seY.Value := ShadowYIns;
      cbFlat.Checked := Flat;
      seWidth.Value := BorderWidth;
      apBright.Color := BrightColor;
      apDull.Color := DullColor;
    end;
  Updating := false;
end;

procedure TdlgCfgBtnLook.apNormalFontChanged(Sender: TObject);
begin
  if not updating then
    CtrlOutlook.Font := apNormal.Font;
end;

procedure TdlgCfgBtnLook.apNormalColorChanged(Sender: TObject);
begin
  if not updating then
    CtrlOutlook.color := apNormal.color;
end;

procedure TdlgCfgBtnLook.apMouseOverColorChanged(Sender: TObject);
begin
  if not updating then
    CtrlOutlook.MouseOverColor := apMouseOver.color;
end;

procedure TdlgCfgBtnLook.apMouseDownColorChanged(Sender: TObject);
begin
  if not updating then
    CtrlOutlook.MouseDownColor := apMouseDown.color;
end;

procedure TdlgCfgBtnLook.apDisableColorChanged(Sender: TObject);
begin
  if not updating then
    CtrlOutlook.DisabledColor := apDisable.color;
end;

procedure TdlgCfgBtnLook.cbFlatClick(Sender: TObject);
begin
  CtrlOutlook.Flat := cbFlat.Checked;
end;

procedure TdlgCfgBtnLook.apBrightColorChanged(Sender: TObject);
begin
  if not updating then
    CtrlOutlook.BrightColor := apBright.Color;
end;

procedure TdlgCfgBtnLook.apDullColorChanged(Sender: TObject);
begin
  if not updating then
    CtrlOutlook.DullColor := apDull.Color;
end;

procedure TdlgCfgBtnLook.seWidthChange(Sender: TObject);
begin
  CtrlOutlook.BorderWidth := seWidth.Value;
end;

end.
