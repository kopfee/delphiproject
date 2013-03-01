unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    btnShowProgress: TButton;
    procedure btnShowProgressClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses ProgressShowing;

const
  Count = 10;

procedure TForm1.btnShowProgressClick(Sender: TObject);
var
  I : Integer;
  Cancelled : Boolean;
begin
  ShowProgress('长时间计算',True,'按ESC键或者鼠标双击这里取消');
  try
    for I:=1 to Count do
    begin
      Sleep(1000);
      UpdateProgress(Format('长时间计算%d%%',[I*100 div Count]));
      Cancelled := IsProgressCanceled;
      if Cancelled then
        Break;
    end;
  finally
    CloseProgress;
  end;
  if Cancelled then
    ShowMessage('取消');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  InstallDefaultProgressShower;
end;

end.
