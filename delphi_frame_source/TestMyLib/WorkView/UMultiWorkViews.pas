unit UMultiWorkViews;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Mask, WVCtrls, WorkViews, KSHints, ExtCtrls;

type
  TForm1 = class(TForm)
    WorkView1: TWorkView;
    WorkView2: TWorkView;
    WorkViewCenter: TWorkViewCenter;
    Label1: TLabel;
    Label2: TLabel;
    WVEdit1: TWVEdit;
    WVEdit2: TWVEdit;
    StatusBar: TStatusBar;
    HintMan: THintMan;
    RadioGroup1: TRadioGroup;
    procedure RadioGroup1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
  if RadioGroup1.ItemIndex=1 then
    WorkViewCenter.InvalidColor := clYellow else
    WorkViewCenter.InvalidColor := clInfoBK;
end;

end.
