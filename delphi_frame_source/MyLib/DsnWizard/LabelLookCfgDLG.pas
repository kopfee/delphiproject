unit LabelLookCfgDLG;

// %LabelLookCfgDLG : 设置Label的外观的界面

(*****   Code Written By Huang YanLai   *****)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Spin, ExtCtrls, CompGroup, ImgList, CoolCtrls,
  ComWriUtils;

type
  TdlgCfgLabelLook = class(TForm)
    LabelOutlook1: TLabelOutlook;
    CoolLabelX1: TCoolLabelX;
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
  private
    { Private declarations }
    DesignLabelLook : TLabelOutlook;
    Updating : boolean;
    procedure Reset;
  public
    { Public declarations }
    function Execute(LabelLook : TLabelOutlook): boolean;
  end;

var
  dlgCfgLabelLook: TdlgCfgLabelLook;

implementation

{$R *.DFM}

{ TdlgCfgLabelLook }

function TdlgCfgLabelLook.Execute(LabelLook: TLabelOutlook): boolean;
begin
  DesignLabelLook := LabelLook;
  Reset;
  result := Showmodal=mrOk;
  if result and (LabelLook<>nil) then
    LabelLook.Assign(LabelOutlook1);
end;

procedure TdlgCfgLabelLook.cbEnableClick(Sender: TObject);
begin
  CoolLabelX1.Enabled := cbEnable.Checked;
end;

procedure TdlgCfgLabelLook.apMouseOverFontChanged(Sender: TObject);
begin
  if not updating then LabelOutlook1.MouseOverFont := apMouseOver.Font;
end;

procedure TdlgCfgLabelLook.apMouseDownFontChanged(Sender: TObject);
begin
  if not updating then LabelOutlook1.MouseDownFont := apMouseDown.Font;
end;

procedure TdlgCfgLabelLook.apDisableFontChanged(Sender: TObject);
begin
  if not updating then LabelOutlook1.DisabledFont:= apDisable.Font;
end;

procedure TdlgCfgLabelLook.apShadowColorChanged(Sender: TObject);
begin
  if not updating then LabelOutlook1.ShadowColor := apShadow.Color;
end;

procedure TdlgCfgLabelLook.cbShadowedClick(Sender: TObject);
begin
  LabelOutlook1.Shadowed := cbShadowed.Checked;
end;

procedure TdlgCfgLabelLook.cbShadowImageClick(Sender: TObject);
begin
  LabelOutlook1.ShadowImage := cbShadowImage.Checked;
end;

procedure TdlgCfgLabelLook.cbShadowItalicClick(Sender: TObject);
begin
  LabelOutlook1.ShadowItalic:= cbShadowItalic.Checked;
end;

procedure TdlgCfgLabelLook.cbxLayoutChange(Sender: TObject);
begin
  LabelOutlook1.Layout := TButtonLayout(cbxLayout.ItemIndex);
end;

procedure TdlgCfgLabelLook.seXChange(Sender: TObject);
begin
  LabelOutlook1.ShadowXIns := seX.Value;
end;

procedure TdlgCfgLabelLook.seYChange(Sender: TObject);
begin
  LabelOutlook1.ShadowYIns := seY.Value;
end;

procedure TdlgCfgLabelLook.seMarginChange(Sender: TObject);
begin
  LabelOutlook1.Margin := seMargin.Value;
end;

procedure TdlgCfgLabelLook.seSpaceChange(Sender: TObject);
begin
  LabelOutlook1.Spacing := seSpace.Value;
end;

procedure TdlgCfgLabelLook.btnResetClick(Sender: TObject);
begin
  Reset;
end;

procedure TdlgCfgLabelLook.Reset;
begin
  if DesignLabelLook<>nil then
  begin
    LabelOutlook1.Assign(DesignLabelLook);
  end;
  Updating := true;
    with LabelOutlook1 do
    begin
      apNormal.Font := Font;
      apNormal.Color := color;
      apMouseOver.Font := MouseOverFont;
      apMouseDown.Font := MouseDownFont;
      apDisable.Font := DisabledFont;
      apShadow.Color := ShadowColor;
      cbShadowed.Checked := Shadowed;
      cbShadowImage.Checked := ShadowImage;
      cbShadowItalic.Checked := ShadowItalic;
      cbxLayout.ItemIndex := integer(Layout);
      seSpace.value := Spacing;
      seMargin.Value := Margin;
      seX.Value := ShadowXIns;
      seY.Value := ShadowYIns;
    end;
  Updating := false;
end;

procedure TdlgCfgLabelLook.apNormalFontChanged(Sender: TObject);
begin
  if not updating then
    LabelOutlook1.Font := apNormal.Font;
end;

procedure TdlgCfgLabelLook.apNormalColorChanged(Sender: TObject);
begin
  if not updating then
    LabelOutlook1.color := apNormal.color;
end;

procedure TdlgCfgLabelLook.apMouseOverColorChanged(Sender: TObject);
begin
  if not updating then
    LabelOutlook1.MouseOverColor := apMouseOver.color;
end;

procedure TdlgCfgLabelLook.apMouseDownColorChanged(Sender: TObject);
begin
  if not updating then
    LabelOutlook1.MouseDownColor := apMouseDown.color;
end;

procedure TdlgCfgLabelLook.apDisableColorChanged(Sender: TObject);
begin
  if not updating then
    LabelOutlook1.DisabledColor := apDisable.color;
end;

end.
