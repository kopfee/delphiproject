unit MsgFilters;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> MsgFilters
   <What> 某些消息过滤器
   <Written By> Huang YanLai
   <History>
**********************************************}

interface

uses windows,messages,sysutils,classes,controls,ComWriUtils;

type
  TMouseTransparent = class(TMsgFilter)
  private
    procedure WMNCHITTEST(var msg : TWMNCHITTEST);message WM_NCHITTEST;
  end;

procedure HookMouseTransparent(AControl : TControl);

procedure UnHookMouseTransparent(AControl : TControl);

procedure EnableMouseTransparent(AControl : TControl; Enabled : boolean);

// if Installed is true, install TMouseTransparent
// otherwise uninstall TMouseTransparent
// InstallMouseTrans will install or uninstall
// TMouseTransparent to AControl's all children
procedure InstallMouseTrans(AControl : TControl; Installed : boolean);

type
  TMouseDrag = class(TMsgFilter)
  private
    procedure WMNCHITTEST(var msg : TWMNCHITTEST);message WM_NCHITTEST;
  public
  	HitResult : integer;
  end;

procedure InstallMouseDrag(AControl : TControl;
	Installed : boolean; Hit : integer);

type
	TMousePass = class(TMouseDrag)
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    DestWin : TWincontrol;
  end;

type
  TMouseByPass = class(TMsgFilter)
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    DestWin : TWincontrol;
  end;
{
type
	TMessageByPass= class(TMsgFilter)
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    MessageDrain : TObject;
  end;
}
implementation

{ TMouseTransparent }

procedure TMouseTransparent.WMNCHITTEST(var msg: TWMNCHITTEST);
begin
  msg.Result := HTTRANSPARENT;
  //IgnoreMsg(msg);
end;

procedure HookMouseTransparent(AControl : TControl);
begin
  HookMsgFilter(AControl,TMouseTransparent);
end;

procedure UnHookMouseTransparent(AControl : TControl);
begin
  UnHookMsgFilter(AControl,TMouseTransparent);
end;

procedure EnableMouseTransparent(AControl : TControl; Enabled : boolean);
begin
  EnableMsgFilter(AControl,enabled,TMouseTransparent);
end;

// if Installed is true, install TMouseTransparent
// otherwise uninstall TMouseTransparent
procedure InstallMouseTrans(AControl : TControl; Installed : boolean);
var
  i : integer;
begin
  if AControl is TWinControl then
  with AControl as TWinControl do
  for i:=0 to controlCount-1 do
  begin
    if Installed then
      HookMouseTransparent(controls[i])
    else
      UnHookMouseTransparent(controls[i]);
    InstallMouseTrans(controls[i],Installed);
  end;
end;

{ TMouseDrag }

procedure TMouseDrag.WMNCHITTEST(var msg: TWMNCHITTEST);
begin
  msg.Result := HitResult;
  SetCursor(LoadCursor(0,MAKEINTRESOURCE(IDC_SIZENS)));
end;

procedure InstallMouseDrag(AControl : TControl;
	Installed : boolean; Hit : integer);
begin
  if installed then
  	with TMouseDrag(HookMsgFilter(AControl,TMouseDrag)) do
			HitResult := Hit
  else
		UnHookMsgFilter(AControl,TMouseDrag);
end;

{ TMousePass }

procedure TMousePass.WndProc(var Message: TMessage);
begin
  if DestWin<>nil then
  	if (message.Msg>=WM_NCMOUSEMOVE)
      and (message.Msg<=WM_NCMBUTTONDBLCLK)
    or (message.Msg>=WM_MOUSEFIRST)
      and (message.Msg<=WM_MOUSELast) then
    begin
    	DestWin.HandleNeeded;
	    DestWin.WindowProc(message);
      exit;
    end;
  inherited WndProc(Message);
end;

{ TMouseByPass }

procedure TMouseByPass.WndProc(var Message: TMessage);
begin
  if DestWin<>nil then
  	if (message.Msg>=WM_NCMOUSEMOVE)
      and (message.Msg<=WM_NCMBUTTONDBLCLK)
    or (message.Msg>=WM_MOUSEFIRST)
      and (message.Msg<=WM_MOUSELast)
    or (message.Msg=WM_NCHITTEST) then
    begin
    	DestWin.HandleNeeded;
	    DestWin.WindowProc(message);
      exit;
    end;
  inherited WndProc(Message);
end;

end.
