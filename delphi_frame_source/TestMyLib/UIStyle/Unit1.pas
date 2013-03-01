unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, UIStyles, CompGroup, ExtCtrls, UICtrls;

type
  TForm1 = class(TForm)
    Label1: TUILabel;
    Label2: TUILabel;
    Label3: TUILabel;
    Label4: TUILabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    CtrlStyleGroup2: TCtrlStyleGroup;
    stNormal: TUIStyle;
    stOther: TUIStyle;
    UIPanel1: TUIPanel;
    rbNormal: TRadioButton;
    rbOther: TRadioButton;
    procedure rbNormalClick(Sender: TObject);
    procedure rbOtherClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses LogFile;

{$R *.DFM}

procedure TForm1.rbNormalClick(Sender: TObject);
begin
  stNormal.Active:=true;
end;

procedure TForm1.rbOtherClick(Sender: TObject);
begin
  stOther.Active:=true;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  rbNormal.Checked:=stNormal.Active;
  rbOther.Checked:=stOther.Active;
end;

initialization
  OpenLogFile();
end.
