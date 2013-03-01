unit ProgressDlgs;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  StdCtrls,ProgReptDlg;

type
  // return whether continue
  TExecuteMethod = function : boolean of object;
  TSimpleMethod = procedure of object;

  TProgrssWithReport = class(TComponent)
  private
    dlgProgress : TdlgProgressReport;
    FRunning: boolean;
    FTitle: string;
    FOnRun: TNotifyEvent;
    FOnExecute: TExecuteMethod;
    FOnInit: TSimpleMethod;
    FOnDone: TSimpleMethod;
    FCancelConfirm: boolean;
    FConfirmCaption: string;
    procedure   DoExecute(sender:TObject);
    procedure   DoRun(sender:TObject);
    procedure   SetTitle(const Value: string);
    function    GetCanceled: boolean;
    procedure   SetCanceled(const Value: boolean);
    procedure   CreateDialog;
  protected

  public
    constructor Create(AOwner : TComponent); override;
    property    CancelConfirm : boolean
                  read FCancelConfirm write FCancelConfirm;
    property    ConfirmCaption  : string
                  read FConfirmCaption write FConfirmCaption;
    procedure   Start;
    property    Canceled : boolean
                  read GetCanceled write SetCanceled;
    function    ShowInfo(const Info:string):boolean;
    function    AddInfo(const Info:string):boolean;
    function    ClearInfo:boolean;
    procedure   Done;
    property    Running : boolean read FRunning;
    procedure   Execute;
    // return false when user click cancel button
    function    ProcessMessages: boolean;
    function    ConfirmUserToCancel:boolean;
  published
    property    Title : string read FTitle write SetTitle;
    property    OnInit : TSimpleMethod
                  read FOnInit write FOnInit;
    property    OnDone : TSimpleMethod
                  read FOnDone write FOnDone ;
    property    OnExecute : TExecuteMethod
                  read FOnExecute write FOnExecute;
    property    OnRun : TNotifyEvent
                  read FOnRun write FOnRun;
  end;
  { Readme:
How to use TProgrssWithReport.
  Way 1 :
    1) Set OnRun = MyRun
    2) some initialization
    3) call TProgrssWithReport.Start,
    it will show a modal dialog
    4) In MyRun, do someting like this :
      a)do init, normally call TProgrssWithReport.AddInfo
      b)loop for process
      while TProgrssWithReport.ProcessMessages
        and Not ProcessDone do
          something;
      c)do cleanup, normally call TProgrssWithReport.AddInfo
  Notes :
      a) In MyRun, must call TProgrssWithReport.ProcessMessages
  for user to cancel this process.
      

  Way 2 :
    1) Set OnInit,OnDone,OnExecute to MyInit,MyDone,MyExecute
    2) call TProgrssWithReport.Execute,
    it will show a modal dialog.
    3) In MyInit, normally call TProgrssWithReport.AddInfo
    4) In MyExecute, do one step of your process.
       if process done, return false, otherwise return true.
       if MyExecute return true, TProgrssWithReport will repeate call
    MyExecute until it return false or user canceled.
    5) after process done or user canceled, MyDone will be called.
    normally call TProgrssWithReport.AddInfo.
  Notes : Way 2 is easy to use, you need not to call
    TProgrssWithReport.ProcessMessages and
    TProgrssWithReport.Done, but note that
    MyExecute do only one step of your process,
    not the total.

  Example :
    d:\HuangYL\MyLib\process1\project1.dpr
  }
implementation

{ TProgrssWithReport }


constructor TProgrssWithReport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  dlgProgress := nil;
  FCancelConfirm := false;
end;

function TProgrssWithReport.ClearInfo: boolean;
begin
  if dlgProgress<>nil then
  begin
    dlgProgress.ClearInfo;
    result := true;
  end
  else
    result := false;
end;

function TProgrssWithReport.AddInfo(const Info: string): boolean;
begin
  if dlgProgress<>nil then
  begin
    dlgProgress.AddInfo(Info);
    result := true;
  end
  else
    result := false;
end;

function  TProgrssWithReport.ShowInfo(const Info: string):boolean;
begin
  if dlgProgress<>nil then
  begin
    dlgProgress.ShowInfo(Info);
    result := true;
  end
  else
    result := false;
end;

procedure TProgrssWithReport.SetTitle(const Value: string);
begin
  FTitle := Value;
  if dlgProgress<>nil then
    dlgProgress.caption := FTitle;
end;

function TProgrssWithReport.GetCanceled: boolean;
begin
  result := (dlgProgress<>nil)
    and dlgProgress.Canceled;
end;

procedure TProgrssWithReport.SetCanceled(const Value: boolean);
begin
  if dlgProgress<>nil then
    dlgProgress.Canceled := value;
end;

procedure TProgrssWithReport.Done;
begin
  if dlgProgress<>nil then
    dlgProgress.Done;
end;

procedure TProgrssWithReport.Execute;
begin
  if Assigned(FOnExecute) then
  begin
    CreateDialog;
    dlgProgress.OnExecute := DoExecute;
    try
      dlgProgress.Start;
    finally
      dlgProgress.free;
      dlgProgress := nil;
    end;
  end;
end;

procedure TProgrssWithReport.Start;
begin
  if Assigned(FOnRun) then
  begin
    CreateDialog;
    dlgProgress.OnExecute := DoRun;
    try
      dlgProgress.Start;
    finally
      dlgProgress.free;
      dlgProgress := nil;
    end;
  end;
end;

procedure TProgrssWithReport.DoExecute(sender: TObject);
begin
  try
    if Assigned(FOnInit) then FOnInit;
    while ProcessMessages and FOnExecute do
      ;
    if Assigned(FOnDone) then FOnDone;
  finally
    Done;
  end;
end;


procedure TProgrssWithReport.DoRun(sender: TObject);
begin
  if assigned(FOnRun) then
    try
      FOnRun(self);
    finally
      Done;
    end;
end;

function TProgrssWithReport.ProcessMessages: boolean;
begin
  Application.ProcessMessages;
  result := not Canceled;
end;

procedure TProgrssWithReport.CreateDialog;
begin
  dlgProgress := TdlgProgressReport.Create(self);
  dlgProgress.caption := FTitle;
  dlgProgress.ConfirmCaption := ConfirmCaption;
  dlgProgress.CancelConfirm := CancelConfirm;
end;

function TProgrssWithReport.ConfirmUserToCancel: boolean;
begin
  assert(dlgProgress<>nil);
  result := dlgProgress.ConfirmUserToCancel;
  if result then dlgProgress.Canceled:=true;
end;

end.
