unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AppearUtils, StdCtrls, CoolCtrls, AbilityManager, ImgList, Spin,
  ComWriUtils;

type
  TForm1 = class(TForm)
    amLabels: TGroupAbilityManager;
    ImageList1: TImageList;
    CoolLabelX1: TCoolLabelX;
    CoolLabelX2: TCoolLabelX;
    CoolLabelX3: TCoolLabelX;
    CoolLabelX4: TCoolLabelX;
    LabelOutlook1: TLabelOutlook;
    btnConfig: TButton;
    cbLink: TCheckBox;
    cbEnabled: TCheckBox;
    procedure cbEnabledClick(Sender: TObject);
    procedure cbLinkClick(Sender: TObject);
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
  look : TLabelOutlook;
  i : integer;
begin
  if cbLink.Checked then
    look:= LabelOutlook1
  else
    look:= nil;
  for i:=0 to amLabels.Controls.Count-1 do
    TCoolLabelX(amLabels.Controls[i]).outlook
     := look;
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
