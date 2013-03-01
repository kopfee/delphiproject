unit winobjs;

interface

uses Windows{,winNT};

const
  InvalidHandle = 0;
  CharBufferLength = 127;
type

TCharBuffer = array[0..CharBufferLength] of char;

{ if you want to use A WObject in diffirent handles
  you should do :
    1 :  AObject := WObject.Create
      or AObject := WObject.CreateBy(h)
    2 :  if want to change handle , do
         AObject.CreateBy(h)
         ( or other !object referenced! constructor )
         or AObject.handle := h

}
WObject = class
protected
  Fhandle : THandle;
  // note : Sethandle set Owned = false
  procedure SetHandle(value : THandle); virtual;
public
  // Windows Object's Handle
  // If true , will closehandle in destroy
  Owned : boolean;
  // write Handle set Owned = false
  property Handle : THandle read FHandle write Sethandle;
  // This constructor set Owned = false
  constructor CreateBy(h : THandle);
  constructor OwnHandle(h : THandle);
  function    isValid:boolean;virtual;
  // Call CloseHandle
  procedure   release; virtual; abstract;
  destructor  destroy; override;
end;

WHandleObject = class(WObject)
public
  procedure   release; override;
  function    Duplicate(inherite : boolean):THandle;
  function    DuplicateObject(inherite : boolean):WHandleObject;
end;

WHandleObjectClass = class of WHandleObject;

WDC = class;

WClientRect = record
  width, height : longint;
end;

WWindowstate = (wsHide,wsNormal,wsIcon,wsZoom);

WWindow = class(WObject)
private
  function  GetCaption:string;
  procedure SetCaption(value : string);
  function  GetRect : TRect;
  procedure SetRect(const value : TRect);
  function  GetClientWidth : longint;
  procedure SetClientWidth(value : longint);
  function  GetClientHeight :longint;
  procedure SetClientHeight(value : longint);
  function  GetTop: longint;
  procedure SetTop(value : longint);
  function  GetLeft: longint;
  procedure SetLeft(value : longint);
  function  GetWidth : longint;
  procedure SetWidth(value : longint);
  function  GetHeight :longint;
  procedure SetHeight(value : longint);
  function  GetClientRect : WClientRect;
  procedure setClientRect(value : WClientRect);
  function  GethParent:THandle;
  procedure SethParent(value:THandle);
  function  GetEnabled:boolean;
  procedure SetEnabled(value:boolean);
  function  GetCaptured : boolean;
  procedure SetCaptured(value : boolean);
public
  constructor GetFrom(const p : TPoint);
  // Get Popup or Overlapped Window
  constructor GetPopOverFrom(const p : TPoint);
  constructor GetDesktop;
  // if there is not a child window, return nil
  function  GetChildFrom(const p : TPoint):WWindow;
  function  GetParentObj : WWindow;
  procedure SetParentObj(P : WWindow);
  function  isValid:boolean; override;
  function  GetDC(entire : boolean) : HDC;
  function  GetDCObj(entire : boolean) : WDC;
  procedure release; override;
  property  Caption:string read GetCaption write SetCaption;
  property  Rect : TRect read GetRect write SetRect;
  property  left : longint read GetLeft write SetLeft;
  property  Top  : longint read GetTop write SetTop;
  property  width : longint read Getwidth write SetWidth;
  property  Height : longint read getHeight write SetHeight;
  property  ClientWidth : longint read GetClientWidth write SetClientWidth;
  property  ClientHeight : longint read GetClientHeight write SetClientHeight;
  property  ClientRect : WClientRect read GetClientRect write SetClientRect;
  procedure Hide;
  // You show call BringToForeground to bring it in the
  // front of all window(as well as others created)
  // not bringToTop(which only bring it to fornt of all
  // you created
  procedure BringToTop;
  procedure BringToForeground;

  // showNomal
  procedure Show;
  procedure Maximize;
  procedure Minimize;
  // If succeed to convert, return true
  function  ClientToScreen(p:TPoint):TPoint;
  function  ScreenToClient(p:TPoint):TPoint;
  property  hParent : THandle read GethParent write Sethparent;
  function  ChildOf(p : THandle) : boolean;
  function  IsChildObj(p : WWindow) : boolean;
  function  IsVisible : boolean;
  function  IsZoom: boolean;
  function  IsIcon: boolean;
  property  Enabled : boolean read GetEnabled write SetEnabled;
  function  ProcessID : longint;
  function  ThreadID : longint;
  // call GetWindowLong or SetWindowLong
  function  GetInfo(Index : integer):longint;
  procedure SetInfo(Index : integer; value : longint);
  property  Infos[index:integer] : longint read GetInfo write SetInfo;
  // see WS_XXX in CreateWindow about Style
  property  Style : longint index GWL_Style read GetInfo write SetInfo;
  property  ExStyle : longint index GWL_ExStyle read GetInfo write SetInfo;
  property  hInstance : longint index GWL_HInstance read GetInfo write SetInfo;
  property  WndProc :  longint index GWL_WNDProc read GetInfo write SetInfo;
  property  ID : longint index GWL_ID read GetInfo write SetInfo;
  property  userData : longint index GWL_UserData read GetInfo write SetInfo;
  property  DlgProc : longint index DWL_DlgProc read GetInfo write SetInfo;
  property  MsgResult : longint index DWL_MsgResult read GetInfo write SetInfo;
  function  IsChild:boolean;
  function  IsPopup:boolean;
  function  IsOverlapped:boolean;
  function  isPopupOrOvered:boolean;
  function  State : WWindowState;
  // class information
  function  ClassName : string;
  function  GetClassInfo(index : integer):longint;
  procedure SetClassInfo(index : integer; value:longint);
  property  ClassInfos[index : integer] : longint
            read GetClassInfo write SetClassInfo;
  property  ClassExtra : longint index GCL_CBCLSEXTRA
            read GetClassInfo write SetClassInfo;
  property  WndExtra : longint index GCL_CBWNDEXTRA
            read GetClassInfo write SetClassInfo;
  property  HBRBACKGROUND : longint index GCL_HBRBACKGROUND
            read GetClassInfo write SetClassInfo;
  property  HIcon : longint index GCL_HICON
            read GetClassInfo write SetClassInfo;
  property  HSmallIcon : longint index GCL_HICONSM
            read GetClassInfo write SetClassInfo;
  property  HCursor : longint index GCL_HCURSOR
            read GetClassInfo write SetClassInfo;
  property  HModule : longint index GCL_HMODULE
            read GetClassInfo write SetClassInfo;
  property  Menuname : longint index GCL_MENUNAME
            read GetClassInfo write SetClassInfo;
  property  ClassTyle : longint index GCL_STYLE
            read GetClassInfo write SetClassInfo;
  property  ClassWndProc : longint index GCL_WNDPROC
            read GetClassInfo write SetClassInfo;
  procedure SetCapture;
  procedure ReleaseCapture;
  property  Captured : boolean read GetCaptured write SetCaptured;
end;

WGUIObject = class;

WDC = class(WObject)
public
  // if owned , DeleteDC , otherwise ReleaseDC
  constructor CreateDisplay;
  constructor CreateCompatible(h : HDC);
  constructor CreateDisplayCompatible;
  constructor CreateByWnd(w : HWND; entire : boolean);
  function    GetCompatibleObj:WDC;
  procedure   release; override;
  // Two way to select GUI Object
  function    SelectObj(WGO : WGUIObject):THandle;
  function    SelectHandle(h : THandle):THandle;
  procedure   BitCopy(dx,dy,width,height : longint;
                      Src : HDC; sx,sy,mode : longint);
  procedure   BitStretch(dx,dy,dw,dh : longint;
                      Src : HDC; sx,sy,sw,sh,mode : longint);
  function    Width : longint;
  function    Height : longint;
end;

WGUIObject = class(WObject)
public
  // if owned , DeleteDC , otherwise ReleaseDC
  procedure   release; override;
end;

WBitmap = class(WGUIObject)
private
  FWidth,FHeight : longint;
  FAttachedDC : WDC;
  function GetAttachedDC:WDC;
  procedure SetAttachedDC(value : WDC);
public
  property AttachedDC : WDC read GetAttachedDC write SetAttachedDC;
  property Width : longint read FWidth;
  property Height : longint read FHeight;
  constructor CreateCompatible(hd : HDC; W,H : longint);
  constructor create(W,H : longint);
  // the two Copy methods use a DC which user provide
  procedure   CopyFromDC(usedDC : HDC; SrcDC : HDC);
  // Copy form (sx,sy) in SrcDC (w,h)=(sw,sh)
  //      to   (dx,dy) (w,h)=(sw,sh)
  // use mode , may stretch bitmap
  procedure   CopyFromDCEx(usedDC : HDC; SrcDC : HDC;
      dx,dy,dw,dh,sx,sy,sw,sh,mode:longint);

  // the two Get methods use attached DC
  procedure GetFromDC(SrcDC : HDC);
  procedure GetFromDCEx(SrcDC : HDC;
      dx,dy,dw,dh,sx,sy,sw,sh,mode:longint);

  procedure DrawDC(usedDC,desDC : HDC; x,y,w,h,mode : longint);

  // The three Draw methods use attached DC
  procedure Draw(desDC : HDC; x,y : longint);
  procedure DrawEx(desDC : HDC; x,y,w,h,mode : longint);
  procedure DrawSuper(desDC : HDC; dx,dy,dw,dh,
                      sx,sy,sw,sh,mode : longint);
  // Release Attached DC
  procedure ReleaseADC;
  procedure Release; override;
end;

function ScreenDC:HDC;

type
  WModule = class(WObject)
  public
    constructor LoadLibrary(const filename:string);
    procedure   release; override;
    // only you loaded library can use ProcAddr
    function    ProcAddr(const Procname:string):Pointer;
    function    FileName:string;
  end;
  {
  WXForm = class
  public
    XForm : TXForm;
    constructor create;
    // init XForm;
    procedure   Restore;
    procedure   GetFromDC(dc : HDC);
    procedure   SetToDC(dc : HDC);
    procedure   Move(dx,dy : single);
    // A is rad
    procedure   rotate(A : single);
    procedure   scale(dx,dy : single);
    procedure   shear(dx,dy : single);
    procedure   ReflectX;
    procedure   ReflectY;
    procedure   MulXForm(const X : TXform);
  end;
 }
{function MakeXForm(e11,e12,e21,e22,dx,dy):TXForm;

type
  WFile = class(WObject)
    //constructor CreateFile(const name:string);
    //constructor OpenFile(const name:string);
    function ReadFile(buffer:Pointer;length:longint):longint;
    function WriteFile(buffer:Pointer;length:longint):longint;
  end;

  WPipe = class
  protected

  public

    constructor create(inherite : boolean);
  end;
}
implementation

//   WObject

function ScreenDC:HDC;
begin
  result := CreateDC('DISPLAY',nil,nil,nil);
end;

constructor WObject.CreateBy(h : THandle);
begin
  handle := h;
end;

constructor WObject.OwnHandle(h : THandle);
begin
  FHandle := h;
  owned := true;
end;

procedure WObject.SetHandle(value : THandle);
begin
  FHandle := value;
  owned := false;
end;

function    WObject.isValid:boolean;
begin
  result := handle<>Invalidhandle;
end;

destructor WObject.destroy;
begin
  if Owned then release;
  inherited destroy;
end;

//   WHandleObject

procedure WHandleObject.release;
begin
  CloseHandle(Handle);
  Owned := false;
  Handle := InvalidHandle;
end;


function WHandleObject.Duplicate(inherite : boolean):THandle;
var
  CurProc : THandle;
begin
  CurProc := GetCurrentProcess;
  if not DuplicateHandle(CurProc,handle,CurProc,@result,
              0,inherite,DUPLICATE_SAME_ACCESS)
  then result := InvalidHandle;
end;

function WHandleObject.DuplicateObject(inherite : boolean):WHandleObject;
var
  h : THandle;
begin
  h:=Duplicate(inherite);
  result := WHandleObjectClass(self.ClassType).CreateBy(h);
  result.owned := true;
end;


//   WWindow

constructor WWindow.GetFrom(const p : TPoint);
begin
  CreateBy(WindowFromPoint(p));
end;

constructor WWindow.GetPopOverFrom(const p : TPoint);
var
  wnd,par : WWindow;
begin
  wnd := WWindow.GetFrom(p);
  while (wnd.isvalid) and not wnd.isPopupOrOvered do
  begin
    par := wnd.GetParentObj;
    if not par.IsValid
      then begin
        par.free;
        break;
      end;
    wnd.free;
    wnd := par;
  end;
  createBy(wnd.handle);
  wnd.free;
end;

function  WWindow.GetChildFrom(const p : TPoint):WWindow;
var
  hChild : THandle;
begin
  hChild := ChildWindowFromPoint(handle,p);
  if (hChild<>handle) and (hChild<>Invalidhandle)
    then result := WWindow.CreateBy(hChild)
    else result := nil;
end;

constructor WWindow.GetDesktop;
begin
  createBy(GetDeskTopWindow);
end;

function  WWindow.GetParentObj : WWindow;
begin
  result := WWindow.CreateBy(GetParent(handle));
end;

procedure WWindow.SetParentObj(P : WWindow);
begin
  if P.isValid then hParent := p.handle;
end;

function  WWindow.isValid:boolean;
begin
  result := isWindow(handle);
end;

procedure WWindow.release;
begin
  DestroyWindow(handle);
end;

function  WWindow.GetDC(entire : boolean) : HDC;
begin
  if entire
    then result := Windows.GetWindowDC(Handle)
    else result := Windows.GetDC(Handle);
end;

function  WWindow.GetDCObj(entire : boolean) : WDC;
begin
  result := WDC.createBy(self.GetDC(entire));
end;

function WWindow.GetCaption:string;
var
  cb : TCharBuffer;
begin
  GetWindowText(handle,cb,CharBufferLength);
  result := string(cb);
end;

procedure WWindow.SetCaption(value : string);
begin
  SetWindowText(handle,PChar(value));
end;

function  WWindow.GetRect : TRect;
begin
  getWindowRect(handle,result);
end;

procedure WWindow.SetRect(const value : TRect);
begin
  with value do
    setWindowPos(handle,0,left,top,right-left,bottom-top,swp_noZOrder);
end;

function  WWindow.GetTop: longint;
begin
  with rect do
    result := top;
end;

procedure WWindow.SetTop(value : longint);
var
  r : Trect;
begin
  r := rect;
  r.bottom := r.bottom - r.top + value;
  r.TOP := VALUE;
  rect := r;
end;

function  WWindow.GetLeft: longint;
begin
  with rect do
    result := left;
end;

procedure WWindow.SetLeft(value : longint);
var
  r : Trect;
begin
  r := rect;
  r.right := r.right - r.left + value ;
  r.left := value;
  rect := r;
end;


function  WWindow.GetWidth : longint;
begin
  with rect do
    result := right-left;
end;

procedure WWindow.SetWidth(value : longint);
var
  r : Trect;
begin
  r := rect;
  r.right := r.left + value;
  rect := r;
end;

function  WWindow.GetHeight :longint;
begin
  with rect do
    result := bottom-top;
end;

procedure WWindow.SetHeight(value : longint);
var
  r : Trect;
begin
  r := rect;
  r.bottom := r.top + value;
  rect := r;
end;

function  WWindow.GetClientWidth : longint;
var
  r : Trect;
begin
  windows.GetClientRect(handle,r);
  result := r.right;
end;

procedure WWindow.SetClientWidth(value : longint);
var
  cr : WClientRect;
begin
  cr := ClientRect;
  cr.width := value;
  ClientRect := cr;
end;

function  WWindow.GetClientHeight :longint;
var
  r : Trect;
begin
  windows.GetClientRect(handle,r);
  result := r.bottom;
end;

procedure WWindow.SetClientHeight(value : longint);
var
  cr : WClientRect;
begin
  cr := ClientRect;
  cr.height := value;
  ClientRect := cr;
end;

function  WWindow.GetClientRect : WClientRect;
var
  r : Trect;
begin
  windows.GetClientRect(handle,r);
  result.width := r.right - r.left;
  result.height := r.bottom - r.top;
end;

procedure WWindow.setClientRect(value : WClientRect);
var
  dx,dy : longint;
  cr : WClientRect;
  r : TRect;
begin
  r := Rect;
  cr := ClientRect;
  dx := value.width - cr.width;
  dy := value.height - cr.height;
  SetWindowPos(handle,0,
     0,0,r.right-r.left+dx,r.bottom-r.top+dy,
     swp_noZOrder or swp_NoMove);
end;

procedure WWindow.Hide;
begin
  showWindow(handle,SW_HIDE);
end;

procedure WWindow.BringToTop;
begin
  show;
  BringWindowToTop(handle);
end;

procedure WWindow.BringToForeground;
begin
  show;
  SetForegroundWindow(handle);
end;

procedure WWindow.Show;
begin
  ShowWindow(handle,SW_SHOWNORMAL);
end;

procedure WWindow.Maximize;
begin
  ShowWindow(handle,SW_SHOWMaximized);
end;

procedure WWindow.Minimize;
begin
  ShowWindow(handle,SW_SHOWMinimized);
end;

function  WWindow.ClientToScreen(p:TPoint):TPoint;
begin
  windows.ClientToScreen(handle,p);
  result := p;
end;

function  WWindow.ScreenToClient(p:TPoint):TPoint;
begin
  windows.ScreenToClient(handle,p);
  result := p;
end;

function  WWindow.GethParent:THandle;
begin
  result := windows.GetParent(handle);
end;

procedure WWindow.SethParent(value:THandle);
begin
  windows.SetParent(handle,value);
end;

function  WWindow.ChildOf(p : THandle) : boolean;
begin
  result := windows.IsChild(p,handle);
end;

function  WWindow.IsChildObj(p : WWindow) : boolean;
begin
  result := windows.IsChild(p.handle,handle);
end;

function  WWindow.IsVisible : boolean;
begin
  result := IsWindowVisible(handle);
end;

function  Wwindow.IsZoom: boolean;
begin
  result := IsZoomed(handle);
end;

function  Wwindow.IsIcon: boolean;
begin
  result := IsIconic(handle);
end;

function  Wwindow.GetEnabled:boolean;
begin
  result := IsWindowEnabled(handle);
end;

procedure Wwindow.SetEnabled(value:boolean);
begin
  EnableWindow(handle,value);
end;

function  WWindow.ProcessID : longint;
begin
  result := 0;
  GetWindowThreadProcessID(handle,@result);
end;

function  WWindow.ThreadID : longint;
begin
  result := GetWindowThreadProcessID(handle,nil);
end;

function  WWindow.GetInfo(Index : integer):longint;
begin
  result := GetWindowLong(handle,Index);
end;

procedure WWindow.SetInfo(Index : integer ;value : longint);
begin
  SetWindowLong(handle,index,value);
end;

function  WWindow.IsChild:boolean;
begin
  result := (WS_Child and Style)<>0;
end;

function  WWindow.IsPopup:boolean;
begin
  result := (WS_Popup and Style)<>0;
end;

function  WWindow.IsOverlapped:boolean;
begin
  result := (WS_Overlapped and Style)<>0;
end;

function  WWindow.isPopupOrOvered:boolean;
begin
  result := ((WS_Overlapped or WS_Popup) and Style)<>0;
end;

function  WWindow.State : WWindowState;
begin
  if not isVisible
    then result := wsHide
    else if isZoom
           then result := wsZoom
           else if isIcon
                   then result := wsIcon
                   else result := wsNormal;

end;

function  WWindow.ClassName : string;
var
  cb : TCharBuffer;
begin
  GetClassName(handle,cb,CharBufferLength);
  result := string(cb);
end;

function  WWindow.GetClassInfo(index : integer):longint;
begin
  result := GetClassLong(handle,index);
end;

procedure WWindow.SetClassInfo(index : integer; value:longint);
begin
  setClassLong(handle,index,value);
end;

function  WWindow.GetCaptured : boolean;
begin
  result := Windows.Getcapture=handle;
end;

procedure WWindow.SetCaptured(value : boolean);
begin
  if value
    then SetCapture
    else releaseCapture;
end;

procedure WWindow.SetCapture;
begin
  Windows.SetCapture(handle);
end;

procedure WWindow.ReleaseCapture;
begin
  if captured
     then Windows.releaseCapture;
end;

// WDC

constructor WDC.CreateDisplay;
begin
  handle := ScreenDC;
  owned := handle<>InvalidHandle;
end;

constructor WDC.CreateCompatible(h : HDC);
begin
  handle := CreateCompatibleDC(h);
  owned := handle<>InvalidHandle;
end;


constructor WDC.CreateDisplayCompatible;
begin
  handle := CreateCompatibleDC(ScreenDC);
  owned := handle<>InvalidHandle;
end;

constructor WDC.CreateByWnd(w : HWND; entire : boolean);
begin
  if entire
    then handle := Windows.GetWindowDC(w)
    else handle := Windows.GetDC(w);
  owned := false;
end;

function    WDC.GetCompatibleObj:WDC;
begin
  result := WDC.CreateCompatible(handle);
end;

procedure WDC.release;
begin
  if owned
    then deleteDC(handle)
    else releaseDC(WindowfromDC(handle),handle);
  Handle := Invalidhandle;
end;

function  WDC.SelectObj(WGO : WGUIObject):THandle;
begin
  result := windows.SelectObject(handle,WGO.handle);
end;

function  WDC.SelectHandle(h : THandle):THandle;
begin
  result := windows.SelectObject(handle,h);
end;

procedure WDC.BitCopy(dx,dy,width,height : longint;
                      Src : HDC; sx,sy,mode : longint);
begin
  bitBlt(handle,dx,dy,width,height,Src,sx,sy,mode);
end;

procedure WDC.BitStretch(dx,dy,dw,dh : longint;
                      Src : HDC; sx,sy,sw,sh,mode : longint);
begin
  StretchBlt(handle,dx,dy,dw,dh,Src,sx,sy,sw,sh,mode);
end;

function WDC.Width : longint;
begin
  result := GetDeviceCaps(handle,HORZRES);
end;

function WDC.Height : longint;
begin
  result := GetDeviceCaps(handle,VERTRES);
end;

// WGUIObject

procedure   WGUIObject.release;
begin
  deleteObject(Handle);
  handle:=InvalidHandle;
  Owned := false;
end;

// WBitmap

constructor WBitmap.CreateCompatible(hd : HDC; W,H : longint);
begin
  handle := CreateCompatibleBitmap(hd,w,h);
  owned := handle<>InvalidHandle;
  FWidth := W;
  FHeight := h;
  AttachedDC := nil;
end;

constructor WBitmap.create(W,H : longint);
begin
  CreateCompatible(ScreenDC,W,H);
end;

procedure   WBitmap.CopyFromDC(usedDC : HDC; SrcDC : HDC);
var
  old : THandle;
begin
  old := SelectObject(usedDC,handle);
  bitBlt(usedDC,0,0,width,height,SrcDC,0,0,SRCCOPY);
  SelectObject(usedDC,old);
end;

  // Copy form (sx,sy) in SrcDC (w,h)=(sw,sh)
  //      to   (dx,dy) (w,h)=(sw,sh)
  // use mode , may stretch bitmap
procedure   WBitmap.CopyFromDCEx(usedDC : HDC; SrcDC : HDC;
      dx,dy,dw,dh,sx,sy,sw,sh,mode:longint);
var
  old : THandle;
begin
  old := SelectObject(usedDC,handle);
  StretchBlt(usedDC,dx,dy,dw,dh,SrcDC,sx,sy,sw,sh,mode);
  SelectObject(usedDC,old);
end;


procedure WBitmap.GetFromDC(SrcDC : HDC);
begin
  bitBlt(AttachedDC.handle,0,0,width,height,SrcDC,0,0,SRCCOPY);
end;

procedure WBitmap.GetFromDCEx(SrcDC : HDC;
      dx,dy,dw,dh,sx,sy,sw,sh,mode:longint);
begin
  StretchBlt(AttachedDC.handle,dx,dy,dw,dh,SrcDC,sx,sy,sw,sh,mode);
end;

procedure   WBitmap.DrawDC(usedDC,desDC : HDC; x,y,w,h,mode : longint);
var
  old : THandle;
begin
  old := SelectObject(usedDC,handle);
  StretchBlt(desDC,x,y,w,h,UsedDC,0,0,width,height,mode);
  SelectObject(usedDC,old);
end;

procedure WBitmap.Draw(desDC : HDC; x,y : longint);
begin
  BitBlt(desDC,x,y,width,height,attachedDC.handle,0,0,SRCCopy);
end;

procedure WBitmap.DrawEx(desDC : HDC; x,y,w,h,mode : longint);
begin
  StretchBlt(desDC,x,y,w,h,AttachedDC.handle,0,0,width,height,mode);
end;

procedure WBitmap.DrawSuper(desDC : HDC; dx,dy,dw,dh,
                      sx,sy,sw,sh,mode : longint);
begin
  StretchBlt(desDC,dx,dy,dw,dh,AttachedDC.handle,sx,sy,sw,sh,mode);
end;

function WBitmap.GetAttachedDC:WDC;
begin
  if FAttachedDC=nil
    then FAttachedDC := WDC.CreateDisplayCompatible;
  result := FAttachedDC;
  result.selectObj(self);
end;

procedure WBitmap.SetAttachedDC(value : WDC);
begin
  FAttachedDC := value;
  if FAttachedDC<>nil then FAttachedDC.selectObj(self);
end;

procedure WBitmap.ReleaseADC;
begin
  if FAttachedDC<>nil then FAttachedDC.free;
  FAttachedDC := nil;
end;

procedure WBitmap.Release;
begin
  ReleaseADC;
  inherited Release;
end;

constructor WModule.LoadLibrary(const filename:string);
begin
  handle := windows.LoadLibrary(pchar(filename));
  owned  := true;
end;

procedure   WModule.release;
begin
  freeLibrary(handle);
end;

function    WModule.ProcAddr(const Procname:string):Pointer;
begin
  result := GetProcAddress(handle,PChar(Procname));
end;

function    WModule.FileName:string;
var
  cb : TCharBuffer;
begin
  GetModuleFileName(handle,cb,CharBufferLength);
  result := String(cb);
end;
{
function MakeXForm(e11,e12,e21,e22,dx,dy):TXForm;
begin
  with result do begin
    em11 := e11;
    em12 := e12;
    em21 := e21;
    em22 := e22;
    edx := dx;
    edy := dy;
  end;
end;
}
//  WXForm
{
constructor WXForm.create;
begin
  restore;
end;

procedure   WXForm.Restore;
begin
  with XForm do begin
    em11 := 1;
    em21 := 0;
    em12 := 0;
    em22 := 1;
    edx := 0;
    edy := 0;
  end;
end;

procedure   WXForm.GetFromDC(dc : HDC);
begin
  GetWorldTransform(dc,@XForm);
end;

procedure   WXForm.SetToDC(dc : HDC);
begin
  SetWorldTransform(dc,@XForm);
end;

procedure   WXForm.Move(dx,dy : single);
begin
  MulXForm(MakeXForm(1,0,0,1,dx,dy));
end;

procedure   WXForm.rotate(A : single);
begin
  MulXForm(MakeXForm(cos(a),sin(a),-sin(a),cos(a),0,0));
end;

procedure   WXForm.scale(dx,dy : single);
begin
  MulXForm(MakeXForm(dx,0,0,dy,0,0));
end;

procedure   WXForm.shear(dx,dy : single);
begin
  MulXForm(MakeXForm(1,dx,dy,1,0,0));
end;

procedure   WXForm.ReflectX;
begin
  MulXForm(MakeXForm(-1,0,0,1,0,0));
end;

procedure   WXForm.ReflectY;
begin
  MulXForm(MakeXForm(1,0,0,-1,0,0));
end;

procedure   WXForm.MulXForm(const X : TXform);
var
  t : TXForm;
begin
  t := XForm;
  with XForm do begin
    em11 := t.em11 * x.em11 + t.em12 * x.em21;
    em12 := t.em11 * x.em12 + t.em12 * x.em22;
    em21 := t.em21 * x.em11 + t.em22 * x.em21;
    em22 := t.em21 * x.em12 + t.em22 * x.em22;
    edx  := t.edx  * x.em11 + t.edy  * x.em21 + x.edx;
    edx  := t.edx  * x.em12 + t.edy  * x.em22 + x.edy;
  end;
end;
}
{
function ReadFile(buffer:Pointer,length:longint):longint;
function WriteFile(buffer:Pointer,length:longint):longint;
}
end.
