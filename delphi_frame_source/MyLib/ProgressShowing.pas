unit ProgressShowing;
{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>ProgressShowing
   <What>显示长时间操作进度的接口
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

{ 使用方法：
1、可以调用InstallDefaultProgressShower安装一个缺省的实现
2、在进行长时间操作的代码中如下调用：

ShowProgress();
try
  while do
    UpdateProgress;
    if IsProgressCanceled then
      Break;
    // do something
  end;
finally
  CloseProgress;
end;

}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls;

type
  {
    <Interface>IProgressShower
    <What>显示长时间操作进度窗口的接口
    <Properties>
      ProgressFont - 字体
      ProgressColor - 背景颜色
      WaitCursor - 光标形状
    <Methods>
      ShowProgress - 显示进度窗口，可以设置标题、是否可以取消、取消提示文字、时间显示格式、延时显示窗口
      UpdateProgress - 更新进度窗口的显示
      CloseProgress -  改变进度窗口
      IsProgressCanceled - 是否用户取消了操作（按ESC或者双击）
      ForceClose - 强制关闭进度窗口
      GetNestCount - 嵌套的层次
      SetAnotherWaitingWindow - 设置另外一个等待窗口的句柄，允许消息发送到该窗口
      HandleMessages - 处理消息
      TempHide - 临时隐藏。再次调用UpdateProgress的时候显示
  }
  IProgressShower = interface
    procedure ShowProgress(const Title : string; ACanCanceled : Boolean=False;
      const CancelPrompt:string=''; const ATimeFormat : string=''; ADelaySeconds : Integer=0);
    procedure UpdateProgress(const Title : string='');
    procedure CloseProgress;
    function  IsProgressCanceled : Boolean;
    function  GetProgressColor: TColor;
    function  GetProgressFont: TFont;
    procedure SetProgressColor(const Value: TColor);
    procedure SetProgressFont(const Value: TFont);
    function  GetNestCount : Integer;
    procedure ForceClose;
    function  GetWaitCursor : TCursor;
    procedure SetWaitCursor(const Value : TCursor);
    procedure SetAnotherWaitingWindow(Handle : THandle);
    procedure HandleMessages;
    procedure TempHide;
    property  ProgressFont : TFont read GetProgressFont write SetProgressFont;
    property  ProgressColor : TColor read GetProgressColor write SetProgressColor;
    property  NestCount : Integer read GetNestCount;
    property  WaitCursor : TCursor read GetWaitCursor write SetWaitCursor;
  end;

  {
    <Interface>IWaitingForm
    <What>等待窗口实现的接口，内部(TCustomProgressShower)使用
    主要方法和IProgressShower相同
    <Properties>
      -
    <Methods>
      -
  }
  IWaitingForm = interface
    ['{C65C7DF5-85CC-4429-8F01-894C43D4CB35}']
    procedure ShowProgress(const Title : string; ACanCanceled : Boolean=False;
      const CancelPrompt:string=''; const ATimeFormat : string=''; ADelaySeconds : Integer=0);
    procedure UpdateProgress(const Title : string='');
    procedure CloseProgress;
    function  IsProgressCanceled : Boolean;
  end;

  {
    <Class>TfmProgressShowing
    <What>缺省的进度显示窗口，实现了IWaitingForm
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TfmProgressShowing = class(TForm, IWaitingForm)
    pnTitle: TPanel;
    StatusBar: TStatusBar;
    lbTitle: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StatusBarDblClick(Sender: TObject);
  private
    { Private declarations }
    FIsCanceled: Boolean;
    FCanCanceled: Boolean;
    FStartTime : LongWord;
    FLastTime : LongWord;
    FTimeFormat: string;
    FDelaySeconds: LongWord;
    FAnotherWaitingWindow: THandle;
    function  GetTitle: string;
    procedure SetTitle(const Value: string);
    procedure ShowMe;
    function  IsProgressCanceled : Boolean;
    procedure DoCancel;
  public
    { Public declarations }
    procedure ShowProgress(const ATitle : string; ACanCanceled : Boolean=False;
      const CancelPrompt:string=''; const ATimeFormat : string=''; ADelaySeconds : Integer=0);
    procedure UpdateProgress(const ATitle : string='');
    procedure CloseProgress;
    property  CanCanceled : Boolean read FCanCanceled write FCanCanceled;
    property  IsCanceled : Boolean read FIsCanceled write FIsCanceled;
    property  Title : string read GetTitle write SetTitle;
    property  TimeFormat : string read FTimeFormat write FTimeFormat;
    property  DelaySeconds : LongWord read FDelaySeconds write FDelaySeconds;
    property  AnotherWaitingWindow : THandle read FAnotherWaitingWindow write FAnotherWaitingWindow;
  end;

  TWaitingForm = TWinControl;
  TWaitingFormClass = class of TWaitingForm;

  {
    <Class>TCustomProgressShower
    <What>对IProgressShower接口的基本实现。
    需要根据TWaitingFormClass类创建出具体的实例，该实例实现IWaitingForm接口。
    该对象实现了：嵌套处理、消息处理
    <Properties>
      -
    <Methods>
      CreateWaitingForm - 根据TWaitingFormClass创建一个对象实例，获得IWaitingForm接口
    <Event>
      -
  }
  TCustomProgressShower = class(TInterfacedObject,IProgressShower)
  private
    FWaitingFormClass: TWaitingFormClass;
    FAnotherWaitingWindow: THandle;
  protected
    FForm : TWaitingForm;
    FWaitFormIntf : IWaitingForm;
    FNestCount : Integer;
    FNestMessages : TStringList;
    FWaitCursor: TCursor;
    FTempHidden : Boolean;
    procedure   CreateWaitingForm; dynamic;
    function    GetProgressColor: TColor;
    function    GetProgressFont: TFont;
    procedure   SetProgressColor(const Value: TColor);
    procedure   SetProgressFont(const Value: TFont);
    function    HandleMessage(var Msg: TMsg): Boolean; dynamic;
    function    IsKeyMsg(var Msg: TMsg): Boolean;
    procedure   CheckForm;
  public
    constructor Create(AWaitingFormClass : TWaitingFormClass);
    destructor  Destroy; override;
    procedure   ShowProgress(const Title : string; ACanCanceled : Boolean=False;
      const CancelPrompt:string=''; const ATimeFormat : string=''; ADelaySeconds : Integer=0);
    procedure   UpdateProgress(const Title : string='');
    procedure   CloseProgress;
    function    IsProgressCanceled : Boolean;
    function    GetNestCount : Integer;
    function    GetWaitCursor : TCursor;
    procedure   SetWaitCursor(const Value : TCursor);
    procedure   ForceClose;
    procedure   SetAnotherWaitingWindow(Handle : THandle);
    procedure   HandleMessages; virtual;
    procedure   TempHide;
    property    ProgressFont : TFont read GetProgressFont write SetProgressFont;
    property    ProgressColor : TColor read GetProgressColor write SetProgressColor;
    property    NestCount : Integer read GetNestCount;
    property    WaitCursor : TCursor read GetWaitCursor write SetWaitCursor;
    property    WaitingFormClass : TWaitingFormClass read FWaitingFormClass;
    property    AnotherWaitingWindow : THandle read FAnotherWaitingWindow write FAnotherWaitingWindow;
  end;

{
  <Procedure>ShowProgress
  <What>显示进度窗口。增加嵌套层数，如果嵌套层数大于1，使用已经出现的进度窗口。
  <Params>
    Title-标题
    ACanCanceled-是否允许用户取消
    CancelPrompt-取消的提示
    ATimeFormat-时间显示格式
    ADelaySeconds-延时显示进度窗口的秒数
  <Exception>
}

procedure ShowProgress(const Title : string; ACanCanceled : Boolean=False;
  const CancelPrompt:string=''; const ATimeFormat : string=''; ADelaySeconds : Integer=0);

{
  <Procedure>UpdateProgress
  <What>更新进度窗口的显示
  <Params>
    -
  <Exception>
}
procedure UpdateProgress(const Title : string='');

{
  <Procedure>CloseProgress
  <What>关闭进度窗口。如果嵌套层数<=0，实际的关闭进度窗口
  <Params>
    -
  <Exception>
}
procedure CloseProgress;

{
  <Function>IsProgressCanceled
  <What>是否被用户取消
  <Params>
    -
  <Return>
  <Exception>
}
function  IsProgressCanceled : Boolean;

{
  <Procedure>InstallDefaultProgressShower
  <What>安装缺省的进度显示窗口的实现。
  <Params>
    -
  <Exception>
}
procedure InstallDefaultProgressShower;

{
  <Procedure>ForceCloseProgress
  <What>强制关闭进度显示窗口，不管嵌套层数。
  <Params>
    -
  <Exception>
}
procedure ForceCloseProgress;

function  GetNestProgressCount : Integer;

function  GetWaitCursor : TCursor;

procedure SetWaitCursor(const Value : TCursor);

{
  <Procedure>如果没有安装进度显示的实现接口，那么安装一个缺省的。
  <What>
  <Params>
    -
  <Exception>
}
procedure CheckInstallProgressShower;

procedure TempHideProgress;

var
  ProgressShower : IProgressShower = nil; // 进度显示接口的实例

resourcestring
  DefaultCancelPrompt = 'Press ESC Key or Double Click Here to Cancel.';
  DefaultTimeFormat = 'Wait For %d Seconds.';
  SNotImpl = 'Not Implement IWaitingForm';

implementation

{$R *.DFM}

uses SafeCode;

type
  TWinControlAccess = class(TWinControl);

procedure InstallDefaultProgressShower;
begin
  ProgressShower := TCustomProgressShower.Create(TfmProgressShowing);
end;

procedure ShowProgress(const Title : string; ACanCanceled : Boolean;
  const CancelPrompt:string; const ATimeFormat : string; ADelaySeconds : Integer);
begin
  if ProgressShower<>nil then
    ProgressShower.ShowProgress(Title,ACanCanceled,CancelPrompt,ATimeFormat,ADelaySeconds);
end;

procedure UpdateProgress(const Title : string);
begin
  if ProgressShower<>nil then
    ProgressShower.UpdateProgress(Title);
end;

procedure CloseProgress;
begin
  if ProgressShower<>nil then
    ProgressShower.CloseProgress;
end;

function  IsProgressCanceled : Boolean;
begin
  if ProgressShower<>nil then
    Result := ProgressShower.IsProgressCanceled else
    Result := False;
end;

procedure ForceCloseProgress;
begin
  if ProgressShower<>nil then
    ProgressShower.ForceClose;
end;

function  GetNestProgressCount : Integer;
begin
  if ProgressShower<>nil then
    Result := ProgressShower.NestCount else
    Result := 0;
end;

function  GetWaitCursor : TCursor;
begin
  if ProgressShower<>nil then
    Result := ProgressShower.GetWaitCursor else
    Result := crDefault;
end;

procedure SetWaitCursor(const Value : TCursor);
begin
  if ProgressShower<>nil then
    ProgressShower.SetWaitCursor(Value);
end;

procedure CheckInstallProgressShower;
begin
  if ProgressShower=nil then
    InstallDefaultProgressShower;
end;

procedure TempHideProgress;
begin
  if ProgressShower<>nil then
    ProgressShower.TempHide;
end;

{ TfmProgressShowing }

procedure TfmProgressShowing.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_ESCAPE) then
  begin
    Key := 0;
    DoCancel;
  end;
end;

procedure TfmProgressShowing.ShowProgress(const ATitle: string;
  ACanCanceled: Boolean; const CancelPrompt: string; const ATimeFormat : string;
  ADelaySeconds : Integer);
begin
  Title := ATitle;
  CanCanceled := ACanCanceled;
  FDelaySeconds := ADelaySeconds;
  if CanCanceled then
  begin
    if CancelPrompt<>'' then
      StatusBar.Panels[1].Text := CancelPrompt else
      StatusBar.Panels[1].Text := DefaultCancelPrompt;
  end else
    StatusBar.Panels[1].Text := '';
  if ATimeFormat<>'' then
    TimeFormat := ATimeFormat else
    TimeFormat := DefaultTimeFormat;
  StatusBar.Panels[0].Text := Format(TimeFormat,[0]);
  IsCanceled := False;
  FStartTime := GetTickCount;
  FLastTime := FStartTime;
  if ADelaySeconds=0 then
    ShowMe;;
end;

function TfmProgressShowing.GetTitle: string;
begin
  Result := lbTitle.Caption;
end;

procedure TfmProgressShowing.SetTitle(const Value: string);
begin
  lbTitle.Caption := Value;
end;

procedure TfmProgressShowing.CloseProgress;
begin
  Hide;
end;

procedure TfmProgressShowing.UpdateProgress(const ATitle: string);
var
  ThisTime : LongWord;
begin
  if ATitle<>'' then
    Title := ATitle;
  ThisTime := GetTickCount;
  if (((ThisTime-FStartTime) div 1000)>=DelaySeconds) and not Visible then
  begin
    ShowMe;
    Update;
  end;
  if ThisTime-FLastTime>1000 then
  begin
    FLastTime := ThisTime;
    StatusBar.Panels[0].Text := Format(TimeFormat,[(FLastTime-FStartTime) div 1000]);
  end;
  {
  if Visible then
    HandleMessages;
  }
end;

procedure TfmProgressShowing.ShowMe;
begin
  Show;
  SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE	or SWP_NOSIZE);
end;

function TfmProgressShowing.IsProgressCanceled: Boolean;
begin
  Result := FIsCanceled;
end;

procedure TfmProgressShowing.DoCancel;
begin
  if (CanCanceled) then
  begin
    IsCanceled := True;
    Hide;
  end;
end;

procedure TfmProgressShowing.StatusBarDblClick(Sender: TObject);
begin
  DoCancel;
end;

{ TCustomProgressShower }

constructor TCustomProgressShower.Create(AWaitingFormClass : TWaitingFormClass);
begin
  Assert(AWaitingFormClass<>nil);
  inherited Create;
  FNestCount := 0;
  FNestMessages := TStringList.Create;
  FWaitCursor := crHourGlass;
  FWaitingFormClass := AWaitingFormClass;
  FForm := nil;
end;

destructor TCustomProgressShower.Destroy;
begin
  {
  if FWaitFormIntf<>nil then
    FWaitFormIntf.CloseProgress;
  }  
  Screen.Cursor := crDefault;
  FWaitFormIntf := nil;
  FreeAndNil(FForm);
  FreeAndNil(FNestMessages);
  inherited;
end;

procedure TCustomProgressShower.CheckForm;
begin
  if FForm=nil then
    CreateWaitingForm;
end;

procedure TCustomProgressShower.CloseProgress;
begin
  Dec(FNestCount);
  if FNestCount<0 then
    FNestCount:=0;
  while FNestMessages.Count>FNestCount do
    FNestMessages.Delete(FNestMessages.Count-1);
  if (FForm<>nil) then
    if (FNestCount=0) then
    begin
      FWaitFormIntf.CloseProgress;
      Screen.Cursor := crDefault;
    end
    else
    begin
      if FNestMessages.Count>0 then
        FWaitFormIntf.UpdateProgress(FNestMessages[FNestMessages.Count-1]);
    end;
end;

procedure TCustomProgressShower.ForceClose;
begin
  if FNestCount>0 then
  begin
    FNestCount:=1;
    CloseProgress;
  end;
end;

function TCustomProgressShower.GetNestCount: Integer;
begin
  Result := FNestCount;
end;

function TCustomProgressShower.GetProgressColor: TColor;
begin
  CheckForm;
  Result := TWinControlAccess(FForm).Color;
end;

function TCustomProgressShower.GetProgressFont: TFont;
begin
  CheckForm;
  Result := TWinControlAccess(FForm).Font;
end;

function TCustomProgressShower.IsProgressCanceled: Boolean;
begin
  if FNestCount>0 then
    Result := FWaitFormIntf.IsProgressCanceled else
    Result := False;
end;

procedure TCustomProgressShower.SetProgressColor(const Value: TColor);
begin
  CheckForm;
  TWinControlAccess(FForm).Color:= Value;
end;

procedure TCustomProgressShower.SetProgressFont(const Value: TFont);
begin
  CheckForm;
  TWinControlAccess(FForm).Font := Value;
end;

procedure TCustomProgressShower.ShowProgress(const Title: string;
  ACanCanceled: Boolean; const CancelPrompt: string;
  const ATimeFormat : string; ADelaySeconds : Integer);
begin
  CheckForm;
  Inc(FNestCount);
  FNestMessages.Add(Title);
  FTempHidden := False;
  if FNestCount=1 then
  begin
    FWaitFormIntf.ShowProgress(Title,ACanCanceled,CancelPrompt,ATimeFormat,ADelaySeconds);
    Screen.Cursor := FWaitCursor;
  end
  else
    FWaitFormIntf.UpdateProgress(Title)
end;

procedure TCustomProgressShower.UpdateProgress(const Title: string);
begin
  CheckForm;
  if FNestCount>0 then
  begin
    if FTempHidden then
    begin
      FTempHidden := False;
      //FForm.Visible := True;
      SetWindowPos(FForm.Handle,HWND_TOPMOST,0,0,0,0,SWP_SHOWWINDOW	or SWP_NOMOVE	or SWP_NOSIZE);
    end;
    FWaitFormIntf.UpdateProgress(Title);
    HandleMessages;
  end;
end;

function TCustomProgressShower.GetWaitCursor: TCursor;
begin
  Result := FWaitCursor;
end;

procedure TCustomProgressShower.SetWaitCursor(const Value: TCursor);
begin
  FWaitCursor := Value;
end;

procedure TCustomProgressShower.SetAnotherWaitingWindow(Handle: THandle);
begin
  CheckForm;
  FAnotherWaitingWindow := Handle;
end;

procedure TCustomProgressShower.CreateWaitingForm;
begin
  FForm := FWaitingFormClass.Create(nil);
  CheckTrue(FForm.GetInterface(IWaitingForm,FWaitFormIntf),SNotImpl);
end;

function TCustomProgressShower.HandleMessage(var Msg: TMsg): Boolean;
var
  Handle : THandle;
  Handled: Boolean;
begin
  Result := False;
  Handle := FForm.Handle;
  if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
  begin
    Result := True;
    Handled := False;
    (*
    if (WM_KEYFIRST<=Msg.message) and (Msg.message<=WM_KEYLAST) then
      Msg.hwnd := Handle;
    if {(Msg.hwnd<>0) and} (Msg.hwnd<>Handle) and not IsChild(Handle,Msg.hwnd) then
    begin
      {Handled := ()
        or ((WM_MOUSEFIRST<=Msg.message) and (Msg.message<=WM_MOUSELAST));}
      Handled := True;
    end;
    *)
    if Msg.hwnd<>0 then
    begin
      // Window Messages
      if (Msg.hwnd<>Handle) and not IsChild(Handle,Msg.hwnd) then
      begin
        // Messages not for this wait window
        if (Msg.hwnd=FAnotherWaitingWindow) or IsChild(FAnotherWaitingWindow,Msg.hwnd) then
        begin
          // Messages for another wait window

        end else
        begin
          if (WM_KEYFIRST<=Msg.message) and (Msg.message<=WM_KEYLAST) then
            Msg.hwnd := Handle // 将键盘消息全部重定向到标准的等待窗口
          else
            Handled := True;  // 其他消息全部忽略
        end;
      end;
    end; // else Application Messages
    if not Handled and not IsKeyMsg(Msg) then
    begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end;
  end;
end;

procedure TCustomProgressShower.HandleMessages;
const
  MaxMessageCount = 10;
var
  Msg: TMsg;
  MessageCounter : Integer;
begin
  if FForm<>nil then
  begin
    MessageCounter := 0;
    while (MessageCounter<MaxMessageCount) and HandleMessage(Msg) do
      Inc(MessageCounter);
  end;
end;

// copy from TApplication
function TCustomProgressShower.IsKeyMsg(var Msg: TMsg): Boolean;
var
  Wnd: HWND;
begin
  Result := False;
  with Msg do
    if (Message >= WM_KEYFIRST) and (Message <= WM_KEYLAST) then
    begin
      Wnd := GetCapture;
      if Wnd = 0 then
      begin
        Wnd := HWnd;
        if (Application.MainForm <> nil) and (Wnd = Application.MainForm.ClientHandle) then
          Wnd := Application.MainForm.Handle
        else
        begin
          // Find the nearest VCL component.  Non-VCL windows won't know what
          // to do with CN_BASE offset messages anyway.
          // TOleControl.WndProc needs this for TranslateAccelerator
          while (FindControl(Wnd) = nil) and (Wnd <> 0) do
            Wnd := GetParent(Wnd);
          if Wnd = 0 then Wnd := HWnd;
        end;
        if SendMessage(Wnd, CN_BASE + Message, WParam, LParam) <> 0 then
          Result := True;
      end
      else if (LongWord(GetWindowLong(Wnd, GWL_HINSTANCE)) = HInstance) then
      begin
        if SendMessage(Wnd, CN_BASE + Message, WParam, LParam) <> 0 then
          Result := True;
      end;
    end;
end;

procedure TCustomProgressShower.TempHide;
begin
  // 利用FNestCount>0和SWP_NOACTIVATE参数避免将错误的将焦点设置到一个隐藏的进度窗口。
  if FNestCount>0 then
  begin
    FTempHidden := True;
    //FForm.Visible := False;
    if FForm<>nil then
      SetWindowPos(FForm.Handle,HWND_TOPMOST,0,0,0,0,SWP_HIDEWINDOW	or SWP_NOMOVE	or SWP_NOSIZE or SWP_NOACTIVATE);
  end;
end;

end.
