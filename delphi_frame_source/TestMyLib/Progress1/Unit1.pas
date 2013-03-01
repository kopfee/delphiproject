unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin,ProgressDlgs;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    seCount: TSpinEdit;
    btnStart: TButton;
    btnExecute: TButton;
    btnClose: TButton;
    Label2: TLabel;
    seMSeconds: TSpinEdit;
    cbConfirmCancel: TCheckBox;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure cbConfirmCancelClick(Sender: TObject);
  private
    { Private declarations }
    progress : TProgrssWithReport;
    Count : integer;
    Index : integer;
    procedure Init;
    procedure Done;
    procedure Run(sender : TObject);
    function  Execute:boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  progress := TProgrssWithReport.Create(self);
  progress.OnRun := Run;
  progress.OnExecute := Execute;
  progress.OnInit := Init;
  progress.OnDone := Done;
  progress.CancelConfirm := true;
  progress.ConfirmCaption := 'Do you want to stop this?';
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  progress.free;
end;

procedure TForm1.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TForm1.btnStartClick(Sender: TObject);
begin
  Progress.Title := 'Start';
  progress.Start;
end;

procedure TForm1.btnExecuteClick(Sender: TObject);
begin
  Progress.Title := 'Execute';
  progress.Execute;
end;

procedure TForm1.Init;
begin
  Progress.ShowInfo('Start...');
  count := seCount.value;
  Index := 0;
end;

procedure TForm1.Done;
begin
  if progress.Canceled then
    progress.AddInfo('Cancaled!')
  else
    progress.AddInfo('Complete!');
end;

function TForm1.Execute: boolean;
begin
  inc(index);
  progress.AddInfo(IntToStr(index));
  Sleep(seMSeconds.value);
  result := index<count;
end;

procedure TForm1.Run(sender: TObject);
begin
  Init;
  while progress.ProcessMessages and Execute do
    ;
  Done;
end;


procedure TForm1.cbConfirmCancelClick(Sender: TObject);
begin
  progress.CancelConfirm
    := cbConfirmCancel.Checked;
end;

end.
