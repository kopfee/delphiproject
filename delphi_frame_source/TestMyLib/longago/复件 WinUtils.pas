unit WinUtils;

interface

uses Windows,winObjs,classes,Messages,forms;

type
{ TMessageComponent is a unvisible Component,
  that creates a FUtilWindow to handle messages
  such as timer messages, DDE messeges and all
  you want. The style of the FUtilWindow is WS_Popup,
  Size is 0. TMessageComponent.Wndroc only call
  DefWindowProc.
}

  TMessageComponent = class(TComponent)
  protected
    FUtilWindow : WWindow;
    procedure WndProc(var MyMsg : TMessage); virtual;
  public
    constructor create(Aowner : TComponent); override;
    destructor  destroy; override;
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

  TFindWindow = class(TMessageComponent)
  protected
    procedure WndProc(var MyMsg : TMessage); override;
  private
    FOwnerForm : TForm;
    FOwnerWindow : WWindow;
    FFoundWindow : WWindow;
    FOnFinish : TNotifyEvent;
    FBeforeRestore : TNotifyEvent;
    FGetChild : boolean;
    FFindMode : boolean;
    procedure SetOwnerForm(value : TForm);
    procedure SetOwnerWindow(value : WWindow);
    procedure Finish;
    procedure Failure;
  public
    property OwnerWindow : WWindow read FOwnerWindow write SetOwnerWindow;
    property FoundWindow : WWindow read FFoundWindow;
    constructor create(Aowner : TComponent); override;
    procedure   Start;
    destructor  destroy; override;
  published
    property GetChild : boolean read FGetChild write FGetChild;
    property OwnerForm : TForm read FOwnerForm write SetOwnerForm;
    property OnFinish : TNotifyEvent read FOnFinish write FOnFinish;
    property BeforeRestore : TNotifyEvent
      read FBeforeRestore write FBeforeRestore;
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
  FUtilWindow  := WWindow.CreateBy(AllocateHWnd(WndProc));
  FUtilWindow.style := longint(WS_Popup);
  FUtilWindow.rect := Rect(0,0,0,0);
end;

destructor  TMessageComponent.destroy;
begin
  DeallocateHWnd(FUtilWindow.handle);
  FUtilWindow.free;
  inherited destroy;
end;

procedure   TMessageComponent.WndProc(var MyMsg : TMessage);
begin
  with MyMsg do
    Result := DefWindowProc(FUtilWindow.Handle,Msg,wParam,lParam);
end;


// TFindWindow
constructor TFindWindow.create(Aowner : TComponent);
begin
  inherited Create(AOwner);
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
  if FOwnerWindow.Isvalid
    then FOwnerWindow.hide;
  FUtilWindow.BringToForeGround;
  FUtilWindow.SetCapture;
  FFindmode:=FUtilWindow.captured;
  if not FFindmode then Failure;
end;

procedure   TFindWindow.finish;
begin
  if Assigned(BeforeRestore)
    then BeforeRestore(self);
  if FOwnerWindow.Isvalid
    then FOwnerWindow.BringToForeGround;
  if Assigned(OnFinish)
    then OnFinish(self);
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
  p : TPoint;
begin
  with TWMMouse(MyMsg) do
   if FFindmode  and
   ((msg=WM_LButtonDown) or (msg=WM_MButtonDown)
     or (msg=WM_RButtonDown))
   then begin
     p := FUtilWindow.ClientToScreen(Point(xpos,ypos));
     if GetChild
       then FFoundWindow.GetFrom(p)
       else FFoundWindow.GetPopOverFrom(p);
     FFindmode := false;
     FUtilWindow.releaseCapture;
     finish;
   end
   else inherited WndProc(MyMsg);
end;

//  TSubClassWindow

constructor TSubClassWindow.create(hw : THandle);
begin
  FWindow := WWindow.Createby(hw);
  PreWndproc := Pointer(Fwindow.Wndproc);
  ObjInst := MakeObjectInstance(Wndproc);
  Fwindow.Wndproc := longint(ObjInst);
  Enabled := true;
end;

destructor  TSubClassWindow.Destroy;
begin
  ReleaseWndProc;
  FreeObjectInstance(ObjInst);
  FWindow.free;
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
  FReceiveWindow := WWindow.createby(reciever);
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
end.
