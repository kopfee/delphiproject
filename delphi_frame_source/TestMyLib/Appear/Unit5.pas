unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ImgList, ComWriUtils, CoolCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    AniCoolButton1: TAniCoolButton;
    AniCoolButton2: TAniCoolButton;
    AniButtonOutlook1: TAniButtonOutlook;
    ImageList1: TImageList;
    cbTransparent: TCheckBox;
    cbFlat: TCheckBox;
    btnConfig: TButton;
    procedure btnConfigClick(Sender: TObject);
    procedure cbTransparentClick(Sender: TObject);
    procedure cbFlatClick(Sender: TObject);
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

procedure TForm1.btnConfigClick(Sender: TObject);
var
  dlg : TdlgCfgBtnLook;
begin
    dlg := TdlgCfgBtnLook.Create(Application);
    try
      dlg.Execute(AniButtonOutlook1);
    finally
      dlg.free;
    end;
end;

procedure TForm1.cbTransparentClick(Sender: TObject);
begin
  AniCoolButton1.Transparent := cbTransparent.Checked;
  AniCoolButton2.Transparent := cbTransparent.Checked;
end;

procedure TForm1.cbFlatClick(Sender: TObject);
begin
  AniButtonOutlook1.Flat := cbFlat.Checked;
end;

end.
