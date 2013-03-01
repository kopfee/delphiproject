unit UValid;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WorkViews, StdCtrls, WVCtrls, Mask, KSHints;

type
  TForm1 = class(TForm)
    WorkView1: TWorkView;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    WVEdit1: TWVEdit;
    WVEdit2: TWVEdit;
    WVEdit3: TWVEdit;
    WVComboBox1: TWVComboBox;
    Label4: TLabel;
    WVLabel1: TWVLabel;
    WVFieldDomain1: TWVFieldDomain;
    WVFieldDomain2: TWVFieldDomain;
    WVFieldDomain3: TWVFieldDomain;
    Label5: TLabel;
    WVEdit4: TWVEdit;
    lbCount: TLabel;
    btnOK: TButton;
    procedure WorkView1WorkFields4CheckValid(WorkField: TWVField);
    procedure WorkView1WorkFields4ValidChanged(WorkField: TWVField);
    procedure WorkView1FieldsMonitors0ValidChanged(Sender: TWVFieldMonitor;
      Valid: Boolean);
    procedure WorkView1InvalidInput(WorkField: TWVField; Target: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FCount : Integer;
    FHintMan : THintMan;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.WorkView1WorkFields4CheckValid(WorkField: TWVField);
begin
  if Length(WorkField.Data.AsString)=0 then
    WorkField.Valid := True;
end;

procedure TForm1.WorkView1WorkFields4ValidChanged(WorkField: TWVField);
begin
  Inc(FCount);
  lbCount.Caption := IntToStr(FCount);
end;

procedure TForm1.WorkView1FieldsMonitors0ValidChanged(
  Sender: TWVFieldMonitor; Valid: Boolean);
begin
  btnOk.Enabled := Valid;
end;

procedure TForm1.WorkView1InvalidInput(WorkField: TWVField;
  Target: TObject);
begin
  if Target is TControl then
  begin
    FHintMan.ShowHintFor(TControl(Target), WorkField.Caption+' ‰»Î¥ÌŒÛ');
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FHintMan := THintMan.Create(Self);
  Application.OnMessage := FHintMan.DoApplicationMessage;
end;

{
try
    Control.ShowHint := True;
    Application.HintMouseMessage(Control,Msg);
    Application.ActivateHint(P);
  finally
    Control.Hint := SavedHint;
    Control.ShowHint := False;
  end;
}

end.
