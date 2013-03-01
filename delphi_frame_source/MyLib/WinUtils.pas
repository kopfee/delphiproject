unit WinUtils;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> WinUtils
   <What> Window¹¤¾ß
   <Written By> Huang YanLai
   <History>
**********************************************}

interface

uses Windows,winObjs,classes,Messages,
			controls,forms, DebugMemory,Graphics;

type
{ TMessageComponent is a unvisible Component,
  that creates a FUtilWindow to handle messages
  such as timer messages, DDE messeges and all
  you want. The style of the FUtilWindow is WS_Popup,
  Size is 0. TMessageComponent.Wndroc only call
  DefWindowProc.
}

  TMessageComponent = class(TComponent)
  private
    function    GetHandle: THandle;
  protected
    FUtilWindow : WWindow;
    procedure 	WndProc(var MyMsg : TMessage); virtual;
  public
    constructor create(Aowner : TComponent); override;
    destructor  destroy; override;
    procedure 	DefaultHandler(var Message); override;
    property    Handle : THandle read GetHandle;
  end;


  { TFindWindow is module , that help you use mouse
    to find window in the screen.
    How to use;
      1. set OnFinish = yourform.method
        in yourform.method, FoundWindow indicate the found
        window.
      2. call start to begin find window
        if you set ownerform ( if its owner is Tform, will
        automaticly set ownerform = owner), the form will
        hide. After you clicked a mouse button, ( call BeforeRestire
        then ) the form will show again, then call yourform.method.
    Note:
      1. The property GetChild indicate you want find child window
    or toplevel window(Popup or Overlapped)
      2. The Event BeforeRestore likes OnFinish, but it will be
    called before ownerform restore.
  }

  TFindWindowMethod = (fwmMouseDown,fwmMouseUp);

  TFindWindow = class(TMessageComponent)
  private
    FPrevHandle : THandle;
    FOwnerForm : TForm;
    FOwnerWindow : WWindow;
    FFoundWindow : WWindow;
    FOnFinish : TNotifyEvent;
    FBeforeRestore : TNotifyEvent;
    FGetChild : boolean;
    FFindMode : boolean;
    FFindMethod: TFindWindowMethod;
    FCursor: TCursor;
    FOldCursor : TCursor;
    FHideBeforeFind: boolean;
    procedure SetOwnerForm(value : TForm);
    procedure SetOwnerWindow(value : WWindow);
    procedure Finish;
    procedure Failure;
  protected
    // if result differ from previous, return true
    function 	GetFoundWindow(x,y:integer):boolean; // Client X,Y
    procedure WndProc(var MyMsg : TMessage); override;
    procedure DrawWinFrame(Win:WWindow);
  public
    constructor create(Aowner : TComponent); override;
    destructor  destroy; override;
    property    OwnerWindow : WWindow read FOwnerWindow write SetOwnerWindow;
    property    FoundWindow : WWindow read FFoundWindow;
    procedure   Start;
  published
    property GetChild : boolean read FGetChild write FGetChild;
    property OwnerForm : TForm read FOwnerForm write SetOwnerForm;
    property OnFinish : TNotifyEvent read FOnFinish write FOnFinish;
    property BeforeRestore : TNotifyEvent
      read FBeforeRestore write FBeforeRestore;
    property FindMethod : TFindWindowMethod
    					read FFindMethod write FFindMethod default fwmMouseUp;
    property Cursor : TCursor
    					read FCursor write FCursor default crHandPoint;
    property HideBeforeFind : boolean
    					read FHideBeforeFind write FHideBeforeFind default true;
  end;

  { TSubClassWindow is a class that subClass from a window.
    Create method needs a window handle.
    Override the WndProc method, you can do something useful.
    TSubClassWindow.WndProc only call previous Wndproc.
  }
  TSubClassWindow = class
  private
  	procedure ReleaseWndProc;
  protected
    hWnd : THandle;
    PreWndproc : Pointer;
    FWindow : WWindow;
    ObjInst : Pointer;
    procedure WndProc(var MyMsg : TMessage); virtual;
  public
    Enabled : boolean;
    constructor create(hw : THandle); virtual;
    destructor  Destroy; override;
    procedure 	DefaultHandler(var Message); override;
  end;

  TSubClassWindowClass = class of TSubClassWindow;

  TSubClasssNotifyMsg = record
    Msg				: Cardinal;
    NotifyID	: Longint;
    TheClass	: TSubClassWindowClass;
    Result		: Longint;
  end;

var
  SubClasssNotify : UINT;
const
  SubClasssNotifyName = 'SubClasssNotify';
// subclass notify id (WParam)
  scn_enabled 	= 1;
  scn_disabled 	= 2;
  scn_release		= 3;

function SubClass(Wnd : HWnd;
	TheClass:TSubClassWindowClass ):TSubClassWindow ;

function NotifySubClass(Wnd : HWnd;	NotifyID : longint;
	 TheClass:TSubClassWindowClass):longint;

function ReleaseSubClass(Wnd : HWnd;
	 TheClass:TSubClassWindowClass):longint;

function EnableSubClass(Wnd : HWnd; TheClass:TSubClassWindowClass;
	Enabled : boolean):longint;

  (*
  { TDirectDrag makes a window movable-by-mouse
    by handling WM_NCHitTest, and replacing
    the result HTClient to HTCaption.
  }
  TDirectDrag = class(TSubClassWindow)
  protected
    procedure WndProc(var MyMsg : TMessage); override;
  end;

  { TPassMessage send messages from a window
    to another window, when method pass return true.
  }
  TPassMessage = class(TSubClassWindow)
  protected
    FReceiveWindow : WWindow;
    // if pass return true, messges will be passed to Receive Window
    function  Pass(var MyMsg:TMessage):boolean; virtual; abstract;
    procedure WndProc(var MyMsg : TMessage); override;
  public
    // source is the subclassed window handle
    // receiver is the handle of the window witch receive message
    // message from source to receiver
    constructor Create(source,reciever : THandle);
    destructor  destroy; override;
  end;

  { TPassMouseMsg inherites form TPassMessage.
    It passes Mouse messages(contains NoneClient)
    to another window.
  }
const
  WM_NCMouseFirst = WM_NCMouseMove;
  WM_NCMouseLast  = WM_NCMButtonDblClk;
type
  TPassMouseMsg = class(TPassMessage)
  protected
    function  Pass(var MyMsg:TMessage):boolean; override;
  public
    // if reverse is true , will reverse mouse (X,y)
    Reverse : boolean;
  end;

  { TDirectMoveSize makes a window sizable and movable-
  by-mouse , by handling WM_NCHitTest
  }
  TDirectMoveSize = class(TSubClassWindow)
  protected
    procedure WndProc(var MyMsg : TMessage); override;
  public
    canMove : boolean;
    canSize : boolean;
    BorderWidth : integer;
    constructor Create(hw : THandle);
  end;
 *)

implementation

// TMessageComponent

constructor TMessageComponent.create(Aowner : TComponent);
begin
  inherited Create(AOwner);
  // FUtilWindow does not own the handle
  FUtilWindow  := WWindow.Create(AllocateHWnd(WndProc));
  {FUtilWindow.style := longint(WS_Popup);
  FUtilWindow.rect := Rect(0,0,0,0);}
end;

destructor  TMessageComponent.destroy;
begin
  DeallocateHWnd(FUtilWindow.handle);
  FUtilWindow.free;
  inherited destroy;
end;

procedure   TMessageComponent.WndProc(var MyMsg : TMessage);
begin
  dispatch(MyMsg);
end;

procedure TMessageComponent.DefaultHandler(var Message);
begin
  with TMessage(Message) do
    Result := DefWindowProc(FUtilWindow.Handle,Msg,wParam,lParam);
end;


function TMessageComponent.GetHandle: THandle;
begin
  Result := FUtilWindow.Handle;
end;

// TFindWindow
constructor TFindWindow.create(Aowner : TComponent);
begin
  inherited Create(AOwner);
  FFindMethod := fwmMouseUp;
  FHideBeforeFind := true;
  FCursor := crHandPoint;
  FOwnerWindow := WWindow.Create;
  if AOwner is TForm
    then OwnerForm := TForm(AOwner)
    else OwnerForm := nil;
  FFoundWindow := WWindow.Create;
end;

destructor  TFindWindow.destroy;
begin
  FOwnerWindow.free;
  FFoundWindow.free;
  inherited destroy;
end;

procedure   TFindWindow.Start;
begin
  FOldCursor := Screen.Cursor;
	Screen.Cursor := Cursor;
  if FHideBeforeFind and FOwnerWindow.Isvalid then
    	FOwnerWindow.hide;
  FFoundWindow.Handle:=0;    
	FUtilWindow.BringToForeGround;
  FUtilWindow.SetCapture;
	FFindmode:=FUtilWindow.captured;
  if not FFindmode then Failure;
end;

function 	TFindWindow.GetFoundWindow(x,y:integer):boolean;
var
	p : TPoint;
begin
  FPrevHandle := FFoundWindow.Handle;
  p := FUtilWindow.ClientToScreen(Point(x,y));
	if GetChild then
    FFoundWindow.GetFrom(p)
  else
    FFoundWindow.GetPopOverFrom(p);
  result := FFoundWindow.Handle<>FPrevHandle;
end;

procedure   TFindWindow.finish;
begin
  DrawWinFrame(FFoundWindow);
  Screen.Cursor := FOldCursor;
  if Assigned(BeforeRestore) then
  	BeforeRestore(self);
  if FHideBeforeFind and FOwnerWindow.Isvalid then
  	FOwnerWindow.BringToForeGround;
  if Assigned(OnFinish) then
  	OnFinish(self);
end;


procedure   TFindWindow.SetOwnerForm(value : TForm);
begin
  if value=nil
    then FOwnerWindow.handle := 0
    else FOwnerWindow.handle := value.handle;
  FOwnerForm := value;
end;

procedure   TFindWindow.SetOwnerWindow(value : WWindow);
begin
  FOwnerWindow.handle := value.handle;
end;

procedure   TFindWindow.Failure;
begin
  FFoundWindow.handle := Invalidhandle;
  finish;
end;

procedure TFindWindow.WndProc(var MyMsg : TMessage);
var
  //p : TPoint;
  NewHandle : THandle;
begin
  if FFindmode then
  with TWMMouse(MyMsg) do
  begin
    // check end
    if
     ( (FFindMethod=fwmMouseDown) and
   			( (msg=WM_LButtonDown) or (msg=WM_MButtonDown)
    		 or (msg=WM_RButtonDown)
        )
      )or
      ( (FFindMethod=fwmMouseUp) and
   			( (msg=WM_LButtonUp) or (msg=WM_MButtonUp)
    		 or (msg=WM_RButtonUp)
        )
      )
     then begin
       GetFoundWindow(Xpos,YPos);
	     FFindmode := false;
  	   FUtilWindow.releaseCapture;
    	 finish;
	   end
     else if (msg=WM_MouseMove)
     		and GetFoundWindow(Xpos,YPos) then
     begin
       NewHandle := FFoundWindow.Handle;
       FFoundWindow.Handle := FPrevHandle;
       DrawWinFrame(FFoundWindow);
       FFoundWindow.Handle := NewHandle;
			 DrawWinFrame(FFoundWindow);
     end;
  end
  else inherited WndProc(MyMsg);
end;

procedure TFindWindow.DrawWinFrame(Win: WWindow);
var
	SDC : WDC;
  R : TRect;
begin
  if not Win.isValid then exit;
  //SDC := WDC.CreateDisplay;
  SDC := WDC.Create;
  try
    SDC.CreateScreen;
    with SDC.Canvas do
    begin
      pen.mode := pmNotXor;
      r := win.Rect;
      moveto(r.left,r.top);
      lineto(r.right,r.top);
      lineto(r.right,r.bottom);
      lineto(r.left,r.bottom);
      lineto(r.left,r.top);
    end;
  finally
    SDC.free;
  end;
end;

//  TSubClassWindow

{$ifdef debug }
var
  SubClasses : TPointerRecord;
{$endif}

constructor TSubClassWindow.create(hw : THandle);
begin
  inherited create;
  FWindow := WWindow.Create(hw);
  PreWndproc := Pointer(Fwindow.Wndproc);
  ObjInst := MakeObjectInstance(Wndproc);
  Fwindow.Wndproc := longint(ObjInst);
  Enabled := true;
  {$ifdef debug }
  SubClasses.Add(self);
  {$endif}
end;

destructor  TSubClassWindow.Destroy;
begin
  ReleaseWndProc;
  FreeObjectInstance(ObjInst);
  FWindow.free;
  {$ifdef debug }
  SubClasses.remove(self);
  {$endif}
  inherited Destroy;
end;

procedure TSubClassWindow.WndProc(var MyMsg : TMessage);
begin
  if (MyMsg.msg=SubClasssNotify) then
    with TSubClasssNotifyMsg(MyMsg) do
    begin
      if NotifyID=scn_release then
      begin
        if self is TheClass then
        begin
          result := longint(PreWndProc);
          //PreWndProc := nil;
          free;
        end
        else
        begin
          DefaultHandler(MyMsg);
          if MyMsg.result<>longint(nil) then
          begin
            PreWndProc:=pointer(MyMsg.result);
            MyMsg.result := longint(nil);
          end;
        end;
        exit;
      end;
      if (self is TheClass) then
      case NotifyID of
        scn_disabled : enabled := false;
        scn_enabled	 : enabled := true;
      end;
    end;
  if MyMsg.msg=WM_Destroy then
    ReleaseWndProc;
  if enabled then
  	dispatch(MyMsg)
  else
   DefaultHandler(MyMsg);
  if MyMsg.msg=WM_Destroy then
    free;
end;

procedure TSubClassWindow.DefaultHandler(var Message);
begin
  with TMessage(Message) do
    result := callWindowProc(PreWndProc,FWindow.handle,
      msg,WParam,LParam);
end;

function SubClass(Wnd : HWnd;
	TheClass:TSubClassWindowClass ):TSubClassWindow ;
begin
  assert(assigned(TheClass));
  result := TheClass.Create(Wnd);
end;

function NotifySubClass(Wnd : HWnd;	NotifyID : longint;
	 TheClass:TSubClassWindowClass):longint;
begin
  result := SendMessage(Wnd,SubClasssNotify,
  	NotifyID,longint(TheClass));
end;

function ReleaseSubClass(Wnd : HWnd;
	 TheClass:TSubClassWindowClass):longint;
begin
  result:=NotifySubClass(Wnd,scn_release,theClass);
end;

function EnableSubClass(Wnd : HWnd; TheClass:TSubClassWindowClass;
	Enabled : boolean):longint;
var
  Notify : longint;
begin
  if enabled then
  	Notify:=scn_enabled
  else
    Notify:=scn_disabled;
  result:=NotifySubClass(Wnd,Notify,theClass);
end;

(*
// TDirectDrag

procedure TDirectDrag.WndProc(var MyMsg : TMessage);
begin
  inherited Wndproc(MyMsg);
  with MyMsg do
    if (msg=WM_NCHITTEST) and (result=HTClient)
      then result := HTCaption;
end;

// TPassMessage
constructor TPassMessage.Create(source,reciever : THandle);
begin
  inherited Create(source);
  FReceiveWindow := WWindow.Create(reciever);
end;

destructor  TPassMessage.destroy;
begin
  FReceiveWindow.free;
  inherited destroy;
end;

procedure TPassMessage.WndProc(var MyMsg : TMessage);
begin
  with MyMsg do
  if pass(MyMsg)
    then result := sendMessage(FReceiveWindow.handle,
      msg,WParam,LParam)
    else inherited WndProc(MyMsg);
end;

// TPassMouseMsg
function  TPassMouseMsg.Pass(var MyMsg:TMessage):boolean;
var
  p : TPoint;
begin
  with MyMsg do
  pass := ((Msg>=WM_MouseFirst) and (Msg<=WM_MouseLast))
     or (Msg=WM_NCHitTest)
     or ((Msg>=WM_NCMouseFirst) and (Msg<=WM_NCMouseLast));
  if result and Reverse and (MyMsg.msg<>WM_NCHitTest)
    then with TWMMouse(MyMsg) do
    begin
      p := Point(xpos,ypos);
      p := FWindow.ClientToScreen(p);
      p := FReceiveWindow.ScreenToClient(p);
      xpos := p.x;
      ypos := p.y;
    end;
end;

// TDirectMoveSize

constructor TDirectMoveSize.Create(hw : THandle);
begin
  inherited Create(hw);
  BorderWidth := 2;
  CanMove := true;
  CanSize := true;
end;

procedure TDirectMoveSize.WndProc(var MyMsg : TMessage);
var
  left,right,top,bottom : boolean;
  rect : TRect;
begin
  if MyMsg.msg=wm_NCHitTest
    then with TWMMouse(MyMsg) do
    begin
      if CanMove
        then result := HTCaption
        else result := HTClient;
      if canSize
        then begin
          rect := FWindow.Rect;
          left  := (xpos>=rect.left) and (xpos<=rect.left+borderWidth);
          right := (xpos<=rect.right) and (xpos>=rect.right-borderWidth);
          top   := (ypos>=rect.top) and (ypos<=rect.top+borderWidth);
          bottom:= (ypos<=rect.bottom) and (ypos>=rect.bottom-borderWidth);
          if left
            then result := HTLeft
            else if right
                   then result := HTRight;
          if bottom
        then
              if left
                then result := HTBottomLeft
                else if right
                       then result := HTBottomRight
                       else result := HTBottom
        else
          if top
        then  if left
                then result := HTTopLeft
                else if right
                       then result := HTTopRight
                       else result := HTTop;
        end; // border > 0
    end  // WM_NCHitTest
    else inherited WndProc(MyMsg);
end;
*)

procedure TSubClassWindow.ReleaseWndProc;
begin
  if (FWindow.WndProc=longint(ObjInst)) then
	  FWindow.WndProc := longint(PreWndproc);
end;



initialization
  SubClasssNotify:=RegisterWindowMessage
  		(SubClasssNotifyName);
  {$ifdef debug }
  SubClasses := TPointerRecord.Create;
  {$endif}
finalization
  {$ifdef debug }
  SubClasses.free;
  {$endif}
end.
