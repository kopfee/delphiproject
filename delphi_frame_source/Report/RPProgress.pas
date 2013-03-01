unit RPProgress;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, RPProcessors, ProgressShowing;

type
  TProgressStatus = (psRun,psPause,psStop,psCancel,psStopped,psCanceled);

  TdlgPrintProgress = class(TForm, IWaitingForm)
    btnStop: TBitBtn;
    btnPause: TBitBtn;
    btnCancel: TBitBtn;
    btnContinue: TBitBtn;
    lbDocTitle: TLabel;
    lbPageNumber: TLabel;
    procedure btnContinueClick(Sender: TObject);
    procedure btnPauseClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FStatus : TProgressStatus;
    //FSavedForm : TCustomForm;
    FProcessor: TReportProcessor;
    procedure SetProcessor(const Value: TReportProcessor);
    procedure UpdatePrintInfo(Processor: TReportProcessor);
    // IWaitingForm
    procedure ShowProgress(const Title : string; ACanCanceled : Boolean=False;
      const CancelPrompt:string=''; const ATimeFormat : string=''; ADelaySeconds : Integer=0);
    procedure UpdateProgress(const Title : string='');
    procedure CloseProgress;
    function  IsProgressCanceled : Boolean;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public declarations }
    property  Processor : TReportProcessor read FProcessor write SetProcessor;
  end;

  TReportProgressShower = class(TCustomProgressShower)
  private

  protected

  public
    constructor Create;
    destructor  Destroy; override;
    procedure   ShowPrintProgress(Processor: TReportProcessor);
  end;

var
  dlgPrintProgress : TdlgPrintProgress;

procedure ShowPrintProgress(Processor: TReportProcessor);

procedure ClosePrintProgress;

procedure UpdatePrintProgress(var ContinuePrint: Boolean);

implementation

{$R *.DFM}

uses RPDefines;

var
  LastProgressShower : IProgressShower = nil;

procedure ShowPrintProgress(Processor: TReportProcessor);
var
  Shower : TReportProgressShower;
begin
  LastProgressShower := ProgressShower;
  // 如果没有缺省的进度显示接口或者当前接口没有正在工作(GetNestCount<=0)，使用报表专门的进度显示接口
  if (LastProgressShower=nil) or (LastProgressShower.GetNestCount<=0) then
  begin
    Shower := TReportProgressShower.Create;
    ProgressShower := Shower;
    Shower.ShowPrintProgress(Processor);
  end else
    ShowProgress(Processor.GetTitle);
end;

procedure ClosePrintProgress;
begin
  CloseProgress;
  ProgressShower := LastProgressShower;
end;

procedure UpdatePrintProgress(var ContinuePrint: Boolean);
begin
  UpdateProgress;
  // 和其他进度显示接口兼容。如果使用TReportProgressShower，那么以意外的形式停止或者取消报表输出
  ContinuePrint := not IsProgressCanceled;
end;

{ TdlgPrintProgress }

procedure TdlgPrintProgress.UpdatePrintInfo(Processor: TReportProcessor);
begin
  if Processor<>nil then
    lbPageNumber.Caption := IntToStr(Processor.Report.PageNumber);
end;

procedure TdlgPrintProgress.btnContinueClick(Sender: TObject);
begin
  FStatus := psRun;
  btnContinue.Enabled := False;
  btnPause.Enabled := True;
end;

procedure TdlgPrintProgress.btnPauseClick(Sender: TObject);
begin
  FStatus := psPause;
  btnContinue.Enabled := True;
  btnPause.Enabled := False;
end;

procedure TdlgPrintProgress.btnStopClick(Sender: TObject);
begin
  FStatus := psStop;
end;

procedure TdlgPrintProgress.btnCancelClick(Sender: TObject);
begin
  FStatus := psCancel;
  // CancelReport; // 不能在这里产生意外，因为会破坏消息处理
end;

procedure TdlgPrintProgress.CloseProgress;
begin
  {
  if FSavedForm<>nil then
    FSavedForm.Enabled := True;
  }
  Hide;
end;

function TdlgPrintProgress.IsProgressCanceled: Boolean;
begin
  Result := not (FStatus in [psRun,psPause]);
end;

procedure TdlgPrintProgress.SetProcessor(const Value: TReportProcessor);
begin
  FProcessor := Value;
  if FProcessor<>nil then
    FProcessor.FreeNotification(Self);
end;

procedure TdlgPrintProgress.ShowProgress(const Title: string;
  ACanCanceled: Boolean; const CancelPrompt, ATimeFormat: string;
  ADelaySeconds: Integer);
begin
  UpdatePrintInfo(Processor);
  if Processor<>nil then
    lbDocTitle.Caption := Processor.GetTitle; //Processor.Printer.Title;
  btnContinue.Enabled := False;
  btnPause.Enabled := True;
  FStatus := psRun;
  {
  FSavedForm := Screen.ActiveCustomForm;
  if FSavedForm=Self then
    FSavedForm:=nil;
  if FSavedForm<>nil then
    FSavedForm.Enabled := False;
  }
  Show;
end;

procedure TdlgPrintProgress.UpdateProgress(const Title: string);
begin
  UpdatePrintInfo(Processor);
  repeat
    // Sleep(400); //test
    ProgressShower.HandleMessages;
  until FStatus <> psPause;

  case FStatus of
    psStop    :
    begin
      FStatus := psStopped;
      StopReport;
    end;
    psCancel  :
    begin
      FStatus := psCanceled;
      CancelReport;
    end;
  end;
end;

procedure TdlgPrintProgress.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent=FProcessor) and (Operation=opRemove) then
    FProcessor := nil;
end;

{ TReportProgressShower }

constructor TReportProgressShower.Create;
begin
  inherited Create(TdlgPrintProgress);

end;

destructor TReportProgressShower.Destroy;
begin
  inherited;

end;

procedure TReportProgressShower.ShowPrintProgress(
  Processor: TReportProcessor);
begin
  CheckForm;
  TdlgPrintProgress(FForm).Processor := Processor;
  ShowProgress('', True);
end;

procedure TdlgPrintProgress.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#27 then // ESC
  begin
    Key := #0;
    FStatus := psCancel;
  end;
end;

end.
