unit DragMoveUtils;

// %DragMoveUtils : 包含鼠标拖动改变控件大小/位置的工具

(*****   Code Written By Huang YanLai   *****)

{
   实现原理：
   1、对TWincontrol, 使用TMouseByPass将TWincontrol的鼠标消息传给TGrabBoard处理
   2、对其他TControl, 使用TGraphCtrlMouseByPass将WM_LButtonDown转换为TGrabBoard的WM_NCLButtonDown
   3、使用TGrabHandle改变大小

   控制能否改变位置的MoveEnabled没有充分实现.
}

interface

uses Windows, Messages, SysUtils, Classes,
	Graphics, Controls,ComWriUtils;

type
{用来拖动的小点,每一个对应不同的方向
}
	TGrabHandle = class(TCustomControl)
  private
  	procedure WMNCHITTEST(var msg : TWMNCHITTEST);message WM_NCHITTEST;
    procedure WMERASEBKGND(var message : TWMERASEBKGND);message WM_ERASEBKGND;
  protected
    procedure Paint; override;
    procedure WndProc(var Message: TMessage); override;
  public
    HitResult : integer;
    DestCtrl : TWinControl;
    SizeEnabled : Boolean;
    constructor Create(AOwner : TComponent); override;
    destructor 	destroy; override;
  end;

var
	GrabSize : integer = 4;
  HalfGrabSize : integer = 4 div 2;

type
{
	产生八个用来拖动的小点,每一个对应不同的方向
  窗口不可见
  窗口大小位置改变以后,影响DestCtrl
}

  TGrabBoard = class;
  TSpecialMouseDownEvent = procedure (sender : TGrabBoard;
    var msg : TWMNCLBUTTONDOWN;
    var handled:boolean) of object;

  TFrameHandleType = (fhLEFT,
  		fhRIGHT ,
		  fhTOP ,
		  fhTOPLEFT,
		  fhTOPRIGHT,
		  fhBOTTOM,
		  fhBOTTOMLEFT,
		  fhBOTTOMRIGHT
    );

  TGrabBoard = class(TCustomControl)
  private
    FDestCtrl: TControl;
    FInstalled : boolean;
    FOnSizePosChanged: TNotifyEvent;
    FOnSpecialMouseDown: TSpecialMouseDownEvent;
    FMoveEnabled: Boolean;
    FSizeEnabled: Boolean;
    procedure   SetDestCtrl(const Value: TControl);
    procedure   WMSize(var message : TWMSize);message WM_Size;
    procedure   WMMove(var message : TWMMove);message WM_Move;
    procedure   RemoveGrabHandles;
    procedure   WMNCHITTEST(var msg : TWMNCHITTEST);message WM_NCHITTEST;
    procedure   WMGETMINMAXINFO(var message : TWMGETMINMAXINFO);message WM_GETMINMAXINFO;
    procedure   WMNCLBUTTONDOWN(var msg : TWMNCLBUTTONDOWN);message WM_NCLBUTTONDOWN;
    procedure   WMNCRBUTTONUP(var Message:TWMNCRBUTTONUP); message WM_NCRBUTTONUP;
    function    GetTheGrabHandles(Index: TFrameHandleType): TGrabHandle;
    function    GetHandleEnabled(Index: TFrameHandleType): Boolean;
    procedure   SetHandleEnabled(Index: TFrameHandleType;
      const Value: Boolean);
    procedure   SetSizeEnabled(const Value: Boolean);
  protected
    GrabHandles : array[0..7] of TGrabHandle;
    procedure   SetParent(AParent: TWinControl); override;
		procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
  public
  	constructor Create(AOwner : TComponent); override;
    destructor 	destroy; override;
    procedure   UpdateSize;
    //destructor 	destroy; override;
    procedure   SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property 	  DestCtrl : TControl
    						  read FDestCtrl write SetDestCtrl;
    procedure   SizePosChanged;
    procedure   SetGrabHandleVisible(AVisible : boolean);
    property 	  OnSizePosChanged : TNotifyEvent
    						  read FOnSizePosChanged write FOnSizePosChanged;
    property    OnSpecialMouseDown : TSpecialMouseDownEvent
                  read FOnSpecialMouseDown write FOnSpecialMouseDown ;
    property    TheGrabHandles[Index : TFrameHandleType] : TGrabHandle read GetTheGrabHandles;
    property    HandleEnabled[Index : TFrameHandleType] : Boolean read GetHandleEnabled Write SetHandleEnabled;
    property    MoveEnabled : Boolean read FMoveEnabled Write FMoveEnabled default true;
    property    SizeEnabled : Boolean read FSizeEnabled write SetSizeEnabled default true;
  published

  end;

const
	HitResults : array[0..7] of integer
  	=(HTLEFT ,
  		HTRIGHT ,
		  HTTOP ,
		  HTTOPLEFT,
		  HTTOPRIGHT,
		  HTBOTTOM,
		  HTBOTTOMLEFT,
		  HTBOTTOMRIGHT
    );
  TheMaxWindowSize = 10000;

type
{
 在一个Control上面产生一个拖动的框
如果拖动的起点在一个子Control上,按下ctrl
}
  TDragFrame = class(TMsgFilter)
  private
    Canvas : TControlCanvas;
    left,top,right,bottom : integer;
    LastRight,lastBottom : integer;
    FDraging: boolean;
    FCanceled: boolean;
    FOnEndDrag : TNotifyEvent;
    procedure WMLButtonDown(var message : TWMLButtonDown);message WM_LButtonDown;
    procedure WMLButtonUp(var message : TWMLButtonUp);message WM_LButtonUp;
    procedure WMMouseMove(var message : TWMMouseMove);message WM_MouseMove;
    procedure WMChar(var message : TWMChar);message WM_Char;
    procedure WMRButtonDown(var message : TWMRButtonDown);message WM_RButtonDown;
    procedure SetDraging(const Value: boolean);
    procedure DragTo(X,Y:integer);
  protected

  public
  	property 		Canceled : boolean read FCanceled;
    property 		Draging : boolean read FDraging write SetDraging;
    constructor Create(AControl : TControl);override;
    destructor 	destroy; override;
    procedure 	DrawDragFrame;
    procedure 	StartDrag(X,Y:integer);
    procedure 	EndDrag;
    procedure 	CancelDrag;
    function 		GetDragRect : TRect;
    property 		OnEndDrag : TNotifyEvent
    							read FOnEndDrag write FOnEndDrag;
  published

  end;

  procedure InstallDragFrame(AControl : TControl;
		installed : boolean; EndDragEvent : TNotifyEvent);

  {
  TDragFrame = class(TComponent)
  private
    Canvas : TControlCanvas;
    left,top,right,bottom : integer;
    LastRight,lastBottom : integer;
    FDraging: boolean;
    FCanceled: boolean;
    procedure WMLButtonDown(var message : TWMLButtonDown);message WM_LButtonDown;
    procedure WMLButtonUp(var message : TWMLButtonUp);message WM_LButtonUp;
    procedure WMMouseMove(var message : TWMMouseMove);message WM_MouseMove;
    procedure WMChar(var message : TWMChar);message WM_Char;
    procedure WMRButtonDown(var message : TWMRButtonDown);message WM_RButtonDown;
    //procedure SetDraging(const Value: boolean);
    procedure DragTo(X,Y:integer);
  protected

  public
  	property 		Canceled : boolean read FCanceled;
    property 		Draging : boolean read FDraging ;
    constructor Create(AOwner : TComponent); override;
    destructor 	destroy; override;
    procedure 	DrawDragFrame;
    procedure 	StartDrag(X,Y:integer);
    procedure 	EndDrag;
    procedure 	CancelDrag;
    function 		GetDragRect : TRect;
  published
		property 		Control : TControl
    							read FControl write SetControl;
  end;
  }

implementation

uses MsgFilters, LogFile;

type
	//TGraphCtrlMouseByPass = class(TMouseByPass)
  TGraphCtrlMouseByPass = class(TMsgFilter)
  private
    DestWin : TWincontrol;
    procedure WMLButtonDown(var message : TWMMouse);message WM_LButtonDown;
  end;

{ TGrabHandle }

constructor TGrabHandle.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  width := GrabSize;
  Height := GrabSize;
  HitResult := HTCLIENT;
  SizeEnabled := True;
end;

destructor TGrabHandle.destroy;
begin
  if Owner<>nil then
  	TGrabBoard(Owner).RemoveGrabHandles;
  inherited destroy;
end;

procedure TGrabHandle.Paint;
{var
	i : integer;}
begin
  with canvas do
  begin
    {brush.color := clBlack;
		brush.style := bsSolid;
    CopyMode := cmDstInvert;
    Rectangle(0,0,width,height);}
    BitBlt(canvas.handle,
    	0,0,width,height,
      0,0,0,DSTINVERT);
    {pen.color := clBlack;
    pen.Mode := pmNotXor;
    pen.Style := psSolid;
    pen.width := 1;
    for i:=0 to height-1 do
    begin
      moveto(0,i);
      lineto(width,i);
    end;
    }
  end;
end;

procedure TGrabHandle.WMERASEBKGND(var message: TWMERASEBKGND);
begin
  message.result := 1;
end;

procedure TGrabHandle.WMNCHITTEST(var msg: TWMNCHITTEST);
begin
  if (DestCtrl<>nil) and SizeEnabled then
	  Msg.result := HitResult
  else
		Msg.result := HTCLIENT;
end;

procedure TGrabHandle.WndProc(var Message: TMessage);
begin
  if (Owner<>nil) and (DestCtrl<>nil) then
  	if (message.Msg>=WM_NCMOUSEMOVE)
      and (message.Msg<=WM_NCMBUTTONDBLCLK)
    or (message.Msg>=WM_MOUSEFIRST)
      and (message.Msg<=WM_MOUSELast) then
    begin
      DestCtrl.HandleNeeded;
	    DestCtrl.WindowProc(message);
      exit;
    end;
  inherited WndProc(Message);
end;

{ TGrabBoard }

constructor TGrabBoard.Create(AOwner: TComponent);
var
	i : integer;
begin
  inherited Create(AOwner);
  visible := false;
  for i:=0 to 7 do
  begin
    GrabHandles[i] := TGrabHandle.create(self);
    GrabHandles[i].DestCtrl := self;
    GrabHandles[i].HitResult := HitResults[i];
    GrabHandles[i].visible := false;
  end;
  FInstalled := true;
  FMoveEnabled := true;
  FSizeEnabled := true;
end;

destructor TGrabBoard.destroy;
begin
	DestCtrl:=nil;
  inherited destroy;
end;

function TGrabBoard.GetHandleEnabled(Index: TFrameHandleType): Boolean;
begin
  Result := GrabHandles[Ord(Index)].HitResult = HitResults[Ord(Index)];
end;

function TGrabBoard.GetTheGrabHandles(
  Index: TFrameHandleType): TGrabHandle;
begin
  Result := GrabHandles[ord(Index)];
end;

procedure TGrabBoard.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (AComponent=DestCtrl) and (Operation=opRemove) then
    DestCtrl:=nil;
end;

procedure TGrabBoard.RemoveGrabHandles;
var
	i : integer;
begin
  if FInstalled then
  begin
    FInstalled := false;
    for i:=0 to 7 do
      GrabHandles[i].DestCtrl:=nil;
  end;
end;

procedure TGrabBoard.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
	SizePosChanged;
end;

procedure TGrabBoard.SetDestCtrl(const Value: TControl);
begin
  if FDestCtrl <> Value then
  begin
    if (FDestCtrl <> nil) then
    	if (FDestCtrl is TWinControl) then
	      UnHookMsgFilter(FDestCtrl,TMouseByPass)
      else
      	UnHookMsgFilter(FDestCtrl,TGraphCtrlMouseByPass);
    FDestCtrl := Value;
    if FDestCtrl <> nil then
    begin
      {
    	SetBounds(FDestCtrl.left,FDestCtrl.top,
      	FDestCtrl.width,FDestCtrl.Height);
      }
      UpdateSize;
      parent := FDestCtrl.parent;
      FDestCtrl.FreeNotification(self);
      if (FDestCtrl is TWinControl) then
	      TMouseByPass(HookMsgFilter(FDestCtrl,TMouseByPass))
  	    	.DestWin := self
      else
        TGraphCtrlMouseByPass(HookMsgFilter(FDestCtrl,TGraphCtrlMouseByPass))
  	    	.DestWin := self;
    end
    else
			parent := nil;
    SetGrabHandleVisible(FDestCtrl<>nil);
  end;
end;

procedure TGrabBoard.SetGrabHandleVisible(AVisible: boolean);
var
	i : integer;
begin
  for i:=0 to 7 do
  	GrabHandles[i].visible := AVisible;
end;

procedure TGrabBoard.SetHandleEnabled(Index: TFrameHandleType;
  const Value: Boolean);
begin
  if Enabled then
    GrabHandles[Ord(Index)].HitResult := HitResults[Ord(Index)]
  else
    GrabHandles[Ord(Index)].HitResult := HTCLIENT;
end;

procedure TGrabBoard.SetParent(AParent: TWinControl);
var
	i : integer;
begin
  inherited SetParent(AParent);
  for i:=0 to 7 do
    GrabHandles[i].Parent := AParent;
end;

procedure TGrabBoard.SetSizeEnabled(const Value: Boolean);
var
  I : Integer;
begin
  if FSizeEnabled <> Value then
  begin
    FSizeEnabled := Value;
    for i:=0 to 7 do
    begin
      GrabHandles[i].SizeEnabled := Value;
    end;
  end;
end;

procedure TGrabBoard.SizePosChanged;
var
	TheLeft,TheRight,TheTop,TheBottom,
  HorMid,VertMid : integer;
  i : integer;
  NeedChange : Boolean;
begin
  NeedChange := (DestCtrl.Left<>Left) or (DestCtrl.Top<>Top) or (DestCtrl.Width<>Width) or (DestCtrl.Height<>Height);
  TheLeft:=left - HalfGrabSize;
  TheRight:=left + width - HalfGrabSize;
  TheTop:= top - HalfGrabSize;
  TheBottom:= top + height - HalfGrabSize;
  HorMid:= left + width div 2 - HalfGrabSize;
  VertMid:=top + height div 2 - HalfGrabSize;
  for i:=0 to 7 do
  case GrabHandles[i].HitResult of
      HTLEFT      	:
        begin
          GrabHandles[i].left := TheLeft;
          GrabHandles[i].top := VertMid;
        end;
      HTRIGHT				:
        begin
          GrabHandles[i].left := TheRight;
          GrabHandles[i].top := VertMid;
        end;
      HTTOP :
        begin
          GrabHandles[i].left := HorMid;
          GrabHandles[i].top := TheTop;
        end;
      HTTOPLEFT :
        begin
          GrabHandles[i].left := theLeft;
          GrabHandles[i].top := TheTop;
        end;
      HTTOPRIGHT :
        begin
          GrabHandles[i].left := theRight;
          GrabHandles[i].top := TheTop;
        end;
      HTBOTTOM   :
        begin
          GrabHandles[i].left := HorMid;
          GrabHandles[i].top := TheBottom;
        end;
      HTBOTTOMLEFT :
        begin
          GrabHandles[i].left := theLeft;
          GrabHandles[i].top := TheBottom;
        end;
      HTBOTTOMRIGHT :
        begin
          GrabHandles[i].left := theRight;
          GrabHandles[i].top := TheBottom;
        end;
  end;
  if NeedChange then
  begin

    if DestCtrl<>nil then
      DestCtrl.setBounds(Left, Top, Width, Height);
    if assigned(OnSizePosChanged) then
      OnSizePosChanged(self);
  end;
end;

procedure TGrabBoard.UpdateSize;
begin
  SetBounds(FDestCtrl.left,FDestCtrl.top,
    FDestCtrl.width,FDestCtrl.Height);
end;

procedure TGrabBoard.WMGETMINMAXINFO(var message: TWMGETMINMAXINFO);
begin
  inherited ;
  with message.MinMaxInfo^.ptMaxTrackSize do
  begin
    x:=TheMaxWindowSize;
    y:=TheMaxWindowSize;
  end;
end;

procedure TGrabBoard.WMMove(var message: TWMMove);
begin
  inherited;
  SizePosChanged;
end;

procedure TGrabBoard.WMNCHITTEST(var msg: TWMNCHITTEST);
begin
  { // old version with bug
  if MoveEnabled then
    msg.result := HTCaption
  else
  begin
    msg.result := HTNOWHERE;
  end;}
  //outputDebugString('TGrabBoard.WMNCHITTEST');
  // 始终返回HTCaption，在WMNCLBUTTONDOWN的时候集中判断MoveEnabled
  // 这样在MoveEnabled=false的时候可以选中wincontrol的子控制。
  msg.result := HTCaption;
end;

procedure TGrabBoard.WMNCLBUTTONDOWN(var msg: TWMNCLBUTTONDOWN);
var
  handled : boolean;
begin
  msg.result := 0;
  handled:=false;
  if MoveEnabled and (msg.HitTest=HTMenu) then
    msg.HitTest:=HTCaption;
  if assigned(FOnSpecialMouseDown) then
    FOnSpecialMouseDown(self,msg,handled);
  if not handled then
    if msg.HitTest=HTCaption then
    begin
      if MoveEnabled then inherited; // 集中在这里判断MoveEnabled
    end else
      inherited;
end;

procedure TGrabBoard.WMNCRBUTTONUP(var Message: TWMNCRBUTTONUP);
begin
  inherited;
  Perform(WM_CONTEXTMENU,Handle,MakeLong(Message.XCursor,Message.YCursor));
end;

procedure TGrabBoard.WMSize(var message: TWMSize);
begin
  inherited;
  SizePosChanged;
end;

{ TGraphCtrlMouseByPass }

procedure TGraphCtrlMouseByPass.WMLButtonDown(var message: TWMMouse);
var
	NewMsg : TWMNCLButtonDown;
  p : TPoint;
begin
  Assert((DestWin=nil) or (DestWin is TGrabBoard));
  if (DestWin<>nil) and TGrabBoard(DestWin).MoveEnabled then
  begin
    //outputDebugString('TGraphCtrlMouseByPass');
    NewMsg.msg := WM_NCLButtonDown;
    NewMsg.HitTest := HTCaption;
    p := Control.ClientToScreen(
      Point(message.XPos,message.YPos));
    NewMsg.XCursor := p.x;
    NewMsg.YCursor := p.y;
    NewMsg.result := 0;
    DestWin.HandleNeeded;
    DestWin.WindowProc(Tmessage(NewMsg));
  end
  else
  	inherited;
end;


{ TDragFrame }

constructor TDragFrame.Create(AControl: TControl);
begin
  inherited Create(AControl);
  Canvas := TControlCanvas.create;
  Canvas.Control := AControl;
  FDraging := false;
end;

destructor TDragFrame.destroy;
begin
  Canvas.free;
  inherited destroy;
end;

procedure TDragFrame.DrawDragFrame;
begin
  with canvas do
  begin
  	pen.color := clBlack;
    pen.style := psDot;
    pen.mode := pmNot;//pmMergePenNot;
    pen.width := 1;
    MoveTo(left,top);
    lineto(right,top);
    lineto(right,bottom);
    lineto(left,bottom);
  	lineto(left,top);
  end;
  LastRight:=Right;
  lastBottom:=Bottom;
end;

type
	TControlAccess=class(TControl);

procedure TDragFrame.StartDrag(X,Y:integer);
begin
  Draging := true;
  left:=x;
  right:=x;
  top:=y;
  bottom:=y;
  FCanceled:=false;
  TControlAccess(Control).MouseCapture := true;
  if control is TWincontrol then
  	if TWincontrol(control).CanFocus then
			TWincontrol(control).SetFocus;
  DrawDragFrame;
end;

procedure TDragFrame.EndDrag;
begin
  TControlAccess(Control).MouseCapture := false;
  Draging := false;
  if (LastRight=Right) and (LastBottom=Bottom) then
	  DrawDragFrame;
  if (not Canceled) and (left<>right) and (Top<>bottom)
  	and Assigned(FOnEndDrag) then
		FOnEndDrag(self);
end;

procedure TDragFrame.CancelDrag;
begin
  FCanceled := true;
  EndDrag;
end;

procedure TDragFrame.WMChar(var message: TWMChar);
begin
  if Draging and (message.CharCode=VK_Escape) then
    CancelDrag
  else
  	inherited;
end;

procedure TDragFrame.WMLButtonDown(var message: TWMLButtonDown);
begin
  if (Control is TWincontrol) and
  	(TWincontrol(Control).ControlAtPos(
    	point(message.XPos,message.YPos),
		  true)<>nil
    ) and
    ((message.Keys and MK_CONTROL)=0) then
    inherited
  else
	  StartDrag(message.XPos,message.YPos);
end;

procedure TDragFrame.WMLButtonUp(var message: TWMLButtonUp);
begin
  if Draging then
  begin
  	EndDrag;//(message.XPos,message.YPos)
  end
  else
  	inherited;
end;

procedure TDragFrame.WMMouseMove(var message: TWMMouseMove);
begin
  if Draging then
  	DragTo(message.XPos,message.YPos)
  else
  	inherited;
end;

procedure TDragFrame.DragTo(X, Y: integer);
begin
  DrawDragFrame;
  Right :=x;
  Bottom := y;
	DrawDragFrame;
end;

procedure TDragFrame.SetDraging(const Value: boolean);
begin
  FDraging := value;
end;

procedure InstallDragFrame(AControl : TControl;
	installed : boolean; EndDragEvent : TNotifyEvent);
begin
  if installed then
    TDragFrame(HookMsgFilter(AControl,TDragFrame)).
    	OnEndDrag := EndDragEvent
  else
  	UnHookMsgFilter(AControl,TDragFrame);
end;

procedure TDragFrame.WMRButtonDown(var message: TWMRButtonDown);
begin
  Inherited ;
  if Draging then
    CancelDrag;
end;

function TDragFrame.GetDragRect: TRect;
begin
  if left>right then
  begin
  	result.Left := right;
    result.Right := left;
  end
  else
  begin
    result.Left := left;
    result.Right := right;
  end;
  if top>bottom then
  begin
  	result.top:= bottom;
    result.bottom:= top;
  end
  else
  begin
    result.top:= top;
    result.bottom:= bottom;
  end;
end;

(*
// old version
{ TDragFrame }
{
constructor TDragFrame.Create(AControl: TControl);
begin
  inherited Create(AControl);
  Canvas := TControlCanvas.create;
  Canvas.Control := AControl;
  FDraging := false;
end;
}
destructor TDragFrame.destroy;
begin
  Canvas.free;
  inherited destroy;
end;

procedure TDragFrame.DrawDragFrame;
begin
  with canvas do
  begin
  	pen.color := clBlack;
    pen.style := psDot;
    pen.mode := pmNot;//pmMergePenNot;
    pen.width := 1;
    MoveTo(left,top);
    lineto(right,top);
    lineto(right,bottom);
    lineto(left,bottom);
  	lineto(left,top);
  end;
  LastRight:=Right;
  lastBottom:=Bottom;
end;

type
	TControlAccess=class(TControl);

procedure TDragFrame.StartDrag(X,Y:integer);
begin
  FDraging := true;
  left:=x;
  right:=x;
  top:=y;
  bottom:=y;
  FCanceled:=false;
  TControlAccess(Control).MouseCapture := true;
  if control is TWincontrol then
  	if TWincontrol(control).CanFocus then
			TWincontrol(control).SetFocus;
  DrawDragFrame;
end;

procedure TDragFrame.EndDrag;
begin
  TControlAccess(Control).MouseCapture := false;
  FDraging := false;
  if (LastRight=Right) and (LastBottom=Bottom) then
	  DrawDragFrame;
end;

procedure TDragFrame.CancelDrag;
begin
  EndDrag;
  FCanceled := true;
end;

procedure TDragFrame.WMChar(var message: TWMChar);
begin
  if Draging and (message.CharCode=VK_Escape) then
    CancelDrag
  else
  	inherited;
end;

procedure TDragFrame.WMLButtonDown(var message: TWMLButtonDown);
begin
  StartDrag(message.XPos,message.YPos);
end;

procedure TDragFrame.WMLButtonUp(var message: TWMLButtonUp);
begin
  if Draging then
  begin
  	EndDrag;//(message.XPos,message.YPos)
  end
  else
  	inherited;
end;

procedure TDragFrame.WMMouseMove(var message: TWMMouseMove);
begin
  if Draging then
  	DragTo(message.XPos,message.YPos)
  else
  	inherited;
end;

procedure TDragFrame.DragTo(X, Y: integer);
begin
  DrawDragFrame;
  Right :=x;
  Bottom := y;
	DrawDragFrame;
end;


procedure InstallDragFrame(AControl : TControl;
	installed : boolean);
begin
  if installed then
    HookMsgFilter(AControl,TDragFrame)
  else
  	UnHookMsgFilter(AControl,TDragFrame);
end;
procedure TDragFrame.WMRButtonDown(var message: TWMRButtonDown);
begin
  Inherited ;
  if Draging then
    CancelDrag;
end;

function TDragFrame.GetDragRect: TRect;
begin
  if left>right then
  begin
  	result.Left := right;
    result.Right := left;
  end
  else
  begin
    result.Left := left;
    result.Right := right;
  end;
  if top>bottom then
  begin
  	result.top:= bottom;
    result.bottom:= top;
  end
  else
  begin
    result.top:= top;
    result.bottom:= bottom;
  end;
end;
*)

end.
