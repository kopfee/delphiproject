unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AppearUtils, StdCtrls, CoolCtrls, AbilityManager, ImgList, Spin,
  ComWriUtils;

type
  TForm1 = class(TForm)
    CoolLabel1: TCoolLabel;
    Appearances1: TAppearances;
    cbEnabled: TCheckBox;
    CoolLabel2: TCoolLabel;
    CoolLabel3: TCoolLabel;
    CoolLabel4: TCoolLabel;
    amLabels: TGroupAbilityManager;
    cbLink: TCheckBox;
    ImageList1: TImageList;
    cbShadowed: TCheckBox;
    spShadowX: TSpinEdit;
    spShadowY: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    CoolLabelX1: TCoolLabelX;
    CoolLabelX2: TCoolLabelX;
    CoolLabelX3: TCoolLabelX;
    CoolLabelX4: TCoolLabelX;
    LabelOutlook1: TLabelOutlook;
    btnConfig: TButton;
    procedure cbEnabledClick(Sender: TObject);
    procedure cbLinkClick(Sender: TObject);
    procedure spShadowXChange(Sender: TObject);
    procedure cbShadowedClick(Sender: TObject);
    procedure spShadowYChange(Sender: TObject);
    procedure btnConfigClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses LabelLookCfgDLG;

procedure TForm1.cbEnabledClick(Sender: TObject);
begin
  amLabels.Enabled := cbEnabled.Checked;
end;

procedure TForm1.cbLinkClick(Sender: TObject);
var
  Appearances: TAppearances;
  i : integer;
begin
  if cbLink.Checked then
    Appearances := Appearances1
  else
    Appearances := nil;
  for i:=0 to amLabels.Controls.Count-1 do
    if amLabels.Controls[i] is TCoolLabel then
    TCoolLabel(amLabels.Controls[i]).Appearances
     := Appearances;
end;

procedure TForm1.cbShadowedClick(Sender: TObject);
var
  i : integer;
begin
  for i:=0 to amLabels.Controls.Count-1 do
    TCoolLabel(amLabels.Controls[i]).Shadowed
      := cbShadowed.Checked;
end;

procedure TForm1.spShadowXChange(Sender: TObject);
var
  i : integer;
  del : integer;
begin
  del := spShadowX.value;
  for i:=0 to amLabels.Controls.Count-1 do
    TCoolLabel(amLabels.Controls[i]).ShadowXIns
     := del;
end;

procedure TForm1.spShadowYChange(Sender: TObject);
var
  i : integer;
  del : integer;
begin
  del := spShadowY.value;
  for i:=0 to amLabels.Controls.Count-1 do
    TCoolLabel(amLabels.Controls[i]).ShadowYIns
     := del;
end;

procedure TForm1.btnConfigClick(Sender: TObject);
var
  dlg : TdlgCfgLabelLook;
begin
    dlg := TdlgCfgLabelLook.Create(Application);
    try
      dlg.Execute(LabelOutlook1);
    finally
      dlg.free;
    end;
end;

end.
