unit Design;

// %Design : 包含设计控件
(*****   Code Written By Huang YanLai   *****)

{
  	in old vesion, when a control has children , and mouse on them,
  MsgFilter that hooked with the control can not receive design mouse messages.
    in this version , try to resolve the problem by using SubClass.
  See procedure SAllChildren for detail.
  	The WinUtils Unit has Classes and procedures for WindowSunClass.
}
interface

uses
  Windows, Messages, SysUtils, Classes, Controls,
  extctrls,Graphics,ComWriUtils, Menus, SafeCode;

const
  HTNone = HTMenu;
  MoveSizeStep = 1;

type
{ How do it work:
	1.		user
     *TWincontrol*   <-hooked by TDesignMsgFilter , <- focused
     TDesignFrame
      TCustomDesigner

  2.    user
     TDesignFrame  paint TGraphicControl in its own DC <- focused
    *TGraphicControl* <-hooked by TDesignMsgFilter
      TCustomDesigner

  TDesignFrame get the keyboard focus, then pass these messages to TCustomDesigner 

  Notes:  if A control(must be a WinControl) can accept child control,
				  it will be hooked by TGroupMsgFilter.

  The function of
   TGroupMsgFilter : pass CM_CONTROLCHANGE to other control.
   TDesignMsgFilter :
    1. TWinControl (pass message to TDesignFrame
      WM_NCHITTEST : if it is being designed ,pass WM_NCHITTEST to TDesignFrame,
      								otherwise result HTCaption

      WM_NCLBUTTONDOWN:
      	if mouse not on child set DesignedCtrl = self, and pass msg to TDesignFrame
        otherwise set DesignedCtrl = child

      WM_NCLBUTTONUP,WM_NCMOUSEMOVE	: if it is being designed, pass msg to TDesignFrame

      PreHandle : pass keyboard message to Designer

   	2. TGraphicControl
      WM_LBUTTONDOWN : set DesignedCtrl = self, and pass a WM_NCLBUTTONDOWN to TDesignFrame

   TDesignFrame :
      WM_NCHITTEST : return HTCaption, HTTop and so on
      WM_Size, WM_Move : resize or move LinkedCtrl
      WM_ERASEBKGND : do nothing
      Paint	: paint frame and GraphicControl's image

      WM_NCLBUTTONDOWN : if PlaceNewCtrl , DoPlaceNewCtrl

      WndProc (for GraphicControl) : pass keyboard message to Designer

   TCustomDesigner:
      CM_CONTROLCHANGE : hook control
      MouseDown : if PlaceNewCtrl , DoPlaceNewCtrl
      WM_KEYUP	: if delete key up, Call OnDelete
}
  TCustomDesigner = class;
  TDesignCtrlChangedEvent = procedure(DesignCtrl : TControl) of object;
  TDesignFrame = class(TCustomControl)
  private
    FLinkedCtrl: TControl;
    FPen: TPen;
    FBorderSize: integer;
    FDesigner: TCustomDesigner;
    FOnDesignCtrlChanged: TDesignCtrlChangedEvent;
    FSizeEnabled: Boolean;
    { Private declarations }
    procedure WMSize(var msg : TWMSize);message WM_Size;
    procedure WMMove(var msg : TWMMove);message WM_Move;
    procedure WMERASEBKGND(var Message:TWMERASEBKGND); message WM_ERASEBKGND;
    procedure WMNCHITTEST(var msg:TWMNCHITTEST);message WM_NCHITTEST;
    procedure AdjustLinkedCtrl;
    procedure SetLinkedCtrl(const Value: TControl);
    procedure SetPen(const Value: TPen);
    procedure SetBorderSize(const Value: integer);

    procedure WMNCLBUTTONDOWN(var msg : TWMNCLBUTTONDOWN);message WM_NCLBUTTONDOWN;
    procedure WMNCRBUTTONUP(var Message:TWMNCRBUTTONUP); message WM_NCRBUTTONUP;
    procedure	InternalSizeMove(ACtrl:TControl);
    procedure	SetTheBounds;
    procedure SetSizeEnabled(const Value: Boolean);
  protected
    { Protected declarations }
    //procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint;override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure WndProc(var Message: TMessage); override;
  public
    { Public declarations }
    Constructor Create(AOwner : TComponent);override;
    Destructor 	destroy; override;
    property	  Designer : TCustomDesigner read FDesigner;
    property	  LinkedCtrl : TControl read FLinkedCtrl write SetLinkedCtrl;
    property	  Pen : TPen read FPen write SetPen;
    property	  BorderSize : integer read FBorderSize write SetBorderSize;
    property    SizeEnabled : Boolean read FSizeEnabled write SetSizeEnabled default true;
    property		OnDesignCtrlChanged : TDesignCtrlChangedEvent
    		read FOnDesignCtrlChanged write FOnDesignCtrlChanged;
  published
    { Published declarations }
  end;

  // x, y is based of PlaceOn
  TPlaceNewCtrlEvent = procedure(PlaceOn : TWinControl; x,y:integer) of object;
  TDeleteEvent =procedure(DeleteCtrl : TControl) of object;

  TDesignFrameClass = class of TCustomControl;

  TCanMoveEvent = procedure (Designer : TCustomDesigner; Ctrl : TControl; var CanMoved : Boolean) of object;
  TCanSizeEvent = procedure (Designer : TCustomDesigner; Ctrl : TControl; var CanSized : Boolean) of object;
  THookCtrlEvent = procedure (Designer : TCustomDesigner; Ctrl : TControl; var CanHook : Boolean) of object;

  // %TCustomDesigner : 设计控件，放置在它上面的控件可以使用鼠标改变大小和位置
  TCustomDesigner = class(TPanel)
  private
    FDesigned: boolean;
    FDesignFrame: TCustomControl;
    FPlaceNewCtrl: boolean;
    FOnPlaceNewCtrl: TPlaceNewCtrlEvent;
    FSaveCursor : TCursor;
    FPlaceCtrlCursor: TCursor;
    //FOnDesignCtrlChanged: TDesignCtrlChangedEvent;
    FOnDelete: TDeleteEvent;
    FNotDesignNewCtrl: boolean;
    FFocusOnNewCtrl: boolean;
    FUpdateingDesignCtrl : Boolean;
    FOnCtrlSizeMove: TNotifyEvent;
    FOnDesignCtrlChanged: TDesignCtrlChangedEvent;
    FOnCanMoveCtrl: TCanMoveEvent;
    FOnHookCtrl: THookCtrlEvent;
    FOnCanSizeCtrl: TCanSizeEvent;
    procedure   CMControlChange(var msg:TCMControlChange); message CM_CONTROLCHANGE;
    procedure   SetDesigned(const Value: boolean);
    procedure   SetOnPlaceNewCtrl(const Value: TPlaceNewCtrlEvent);
    procedure   SetPlaceNewCtrl(const Value: boolean);

    procedure   WMKeyup(var msg : TWMKEYUP);message WM_Keyup;
    procedure   HookControl(Ctrl : TControl);
    procedure   MoveSize(DelX,DelY : Integer; Moving : Boolean);
    procedure   WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;

    procedure   SetPopupMenu(const Value: TPopupMenu);
    function    GetPopupMenu: TPopupMenu; reintroduce;
  protected
    procedure   CtrlPosChanged;
		procedure   MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
    function    GetDesignCtrl: TControl; virtual; abstract;
    procedure   InternalSetDesignCtrl(Acontrol: TControl); virtual; abstract;
    procedure   SetDesignCtrl(Acontrol: TControl);
    procedure   CtrlSizeMove(ACtrl : TControl); virtual; abstract;
    procedure   DoDesignCtrlChanged(DesignCtrl : TControl);
    function    HookThis(acontrol : TControl):boolean; virtual;
    function    CanMoveCtrl(Ctrl : TControl) : Boolean; virtual;
    function    CanSizeCtrl(Ctrl : TControl) : Boolean; virtual;
    procedure   KeyDown(var Key: Word; Shift: TShiftState); override;
    property    DesignFrame : TCustomControl read FDesignFrame;
  public
    Constructor Create(AOwner : TComponent);override;
    Destructor	destroy; override;
    class function getDesignFrameClass : TDesignFrameClass; virtual; abstract;
    procedure 	DesignMsg(var msg);
    property		DesignCtrl : TControl Read GetDesignCtrl write SetDesignCtrl;
    property		PlaceNewCtrl : boolean read FPlaceNewCtrl write SetPlaceNewCtrl;
    // x, y is based of PlaceOn
    procedure		DoPlaceNewCtrl(PlaceOn : TWinControl; x,y:integer);

    // result :=  designed and not csDesigning in ComponentState
    function		Designing : boolean;

    procedure 	UnHookControl(Control : TControl);
  published
    property		Designed : boolean Read FDesigned write SetDesigned;
    property    PopupMenu : TPopupMenu read GetPopupMenu write SetPopupMenu;
    property		PlaceCtrlCursor : TCursor read FPlaceCtrlCursor write FPlaceCtrlCursor default crHandPoint;
    property		OnPlaceNewCtrl : TPlaceNewCtrlEvent read FOnPlaceNewCtrl write SetOnPlaceNewCtrl;
    property    OnCanMoveCtrl : TCanMoveEvent read FOnCanMoveCtrl write FOnCanMoveCtrl;
    property    OnCanSizeCtrl : TCanSizeEvent read FOnCanSizeCtrl write FOnCanSizeCtrl;
    property		OnDesignCtrlChanged : TDesignCtrlChangedEvent
    		read FOnDesignCtrlChanged write FOnDesignCtrlChanged;
    property 		OnDelete: TDeleteEvent Read FOnDelete Write FOnDelete ;
    property		OnKeyDown;
    property		OnKeyUp;
    property		OnKeyPress;
    // NotDesignNewCtrl indecates the control that is inserted newly will not be design.
    property		NotDesignNewCtrl : boolean
   								read FNotDesignNewCtrl write FNotDesignNewCtrl default false;
    property    FocusOnNewCtrl : boolean Read FFocusOnNewCtrl write FFocusOnNewCtrl;
    property 		OnCtrlSizeMove : TNotifyEvent
    							read FOnCtrlSizeMove write FOnCtrlSizeMove ;
    property    OnHookCtrl : THookCtrlEvent read FOnHookCtrl write FOnHookCtrl;
  end;

  TDesigner = class(TCustomDesigner)
  private

  protected
    function    GetDesignCtrl: TControl; override;
    procedure   InternalSetDesignCtrl(Acontrol: TControl); override;
    procedure   CtrlSizeMove(ACtrl: TControl); override;
  public
    Constructor Create(AOwner : TComponent);override;
    class function getDesignFrameClass : TDesignFrameClass; override;
  published

  end;


  TDirection = (drLeft,drRight,drTop,drBottom);
  TDirections = set of TDirection;

// Bounds  of control
// X,Y are mouse position based of screen
function	GetHitDirections(bounds: TRect;x,y : integer):TDirections;

// return AControl's Client rect based of screen
function	GetControlRect(AControl : TControl):TRect;

// Enable or Disable Ctrl's TDesignMsgFilter to set or Unset Designed state
procedure SetCtrlDesigned(AControl : TControl; Designed : boolean);

// Enable or Disable its Children's TDesignMsgFilter to set or Unset Designed state
procedure SetCtrlsDesigned(AControl: TControl; Designed : boolean);

procedure DrawFrame(Canvas : TCanvas; Pen : TPen; ARect : TRect);

function	SetFocusOn(WinCtrl : TWinControl):boolean;

type
  TDesignMsgFilter = class(TMsgFilter)
  private
    Designer : TCustomDesigner;
    // pass WM_NCHITTEST to DesignFrame
    procedure WMNCHITTEST(var msg:TWMNCHITTEST);message WM_NCHITTEST;
    procedure WMNCLBUTTONDOWN(var msg : TWMNCLBUTTONDOWN);message WM_NCLBUTTONDOWN;
    procedure WMNCLBUTTONUP(var msg : TWMNCLBUTTONUP);message WM_NCLBUTTONUP;
    procedure WMNCMouseMove(var msg : TWMNCMouseMove);message WM_NCMouseMove;
    procedure WMLBUTTONDOWN(var msg : TWMLBUTTONDOWN);message WM_LBUTTONDOWN;
    procedure WMNCRBUTTONDown(var Message:TWMNCRBUTTONDown); message WM_NCRBUTTONDown;
    procedure WMNCRBUTTONUP(var Message:TWMNCRBUTTONUP); message WM_NCRBUTTONUP;
    procedure WMSize(var msg : TWMSize);message WM_Size;
    procedure WMMove(var msg : TWMMove);message WM_Move;
    // handle WM_WINDOWPOSCHANGED for Non-Wincontrol
    procedure WMWINDOWPOSCHANGED(var message : TWMWINDOWPOSCHANGED);message WM_WINDOWPOSCHANGED;
    procedure SizeMove;
  protected
    function	PreHandle(var Message: TMessage) : boolean ; override;
    procedure EnableChanged;override;
  public

  published

  end;

  // pass CM_CONTROLCHANGE to other control
  TGroupMsgFilter = class(TMsgFilter)
  private
    OtherControl : TControl;
    procedure CMControlChange(var msg:TCMControlChange); message CM_CONTROLCHANGE;
  protected
    //procedure PreHandle(var Message: TMessage);override;
	end;

procedure HookGroupMsgFilter(Control,OtherControl : TControl);

type
	TChildAction = (act_Hook,act_Unhook,act_Enabled,act_Disabled);

procedure SAllChildren(AControl : TControl; action : TChildAction);

function ChildFromPos(parent : TWinControl;
	const Pos: TPoint; AllowDisabled: Boolean):TControl;

implementation

uses WinUtils,USubs,DebugMemory;

const
  HitTestDEL = 5;

// Bounds  of control
// X,Y are mouse position based of screen
function	GetHitDirections(bounds: TRect; x,y : integer):TDirections;
begin
	result := [];
  if (x>=bounds.left) and (x<=bounds.left+HitTestDEL) then include(result,drLeft);
  if (x<=Bounds.Right) and (x>=Bounds.Right-HitTestDEL) then include(result,drRight);
  if (y>=bounds.top) and (y<=bounds.top+HitTestDEL) then include(result,drTop);
  if (y<=bounds.bottom) and (y>=bounds.bottom-HitTestDEL) then include(result,drBottom);
end;

function	GetControlRect(AControl : TControl):TRect;
begin
  result.TopLeft:=AControl.ClientOrigin;
  result.Right := result.left + AControl.ClientWidth;
  result.bottom:= result.top + AControl.ClientHeight;
end;

procedure SetCtrlDesigned(AControl : TControl; Designed : boolean);
begin
  EnableMsgFilter(AControl,Designed,TDesignMsgFilter);
end;

procedure SetCtrlsDesigned(AControl: TControl; Designed : boolean);
var
  i : integer;
begin
  if Designed then
	    SAllChildren(Acontrol,act_enabled)
    else
      SAllChildren(Acontrol,act_disabled);
  if AControl is TWinControl then
  with AControl as TWinControl do
  for i:=0 to controlCount-1 do
    SetCtrlDesigned(Controls[i],Designed);
end;

function ChildFromPos(parent : TWinControl;
	const Pos: TPoint; AllowDisabled: Boolean):TControl;
var
  TheControl : TControl;
  //P : TPoint;
begin
  //P := parent.ClientToScreen(Pos);
  TheControl := parent.ControlAtPos(
  	parent.ScreenToClient(pos),AllowDisabled);
  result := TheControl;
  while TheControl is TWinControl do
  begin
    result := TheControl;
    TheControl := TWincontrol(result).ControlAtPos(
    		result.ScreenToClient(pos),AllowDisabled);
  end;
end;

{ TDesignMsgFilter }

procedure TDesignMsgFilter.EnableChanged;
begin
  SetCtrlsDesigned(control,Enabled);
end;

function	TDesignMsgFilter.PreHandle(var Message: TMessage) : boolean ;
begin
  case Message.msg of
    WM_KeyDown,WM_KeyUp,WM_SysKeyDown,WM_SysKeyUp,
    WM_Char,WM_SysChar,WM_DeadChar,WM_SysDeadChar:
    begin
      Designer.WndProc(Message);
      result := false;
    end;
  else result := inherited PreHandle(Message);
  end;
end;

procedure TDesignMsgFilter.WMLBUTTONDOWN(var msg: TWMLBUTTONDOWN);
var
  NewMsg : TWMNCLBUTTONDOWN;
  Pos : TPoint;
begin
{  if (csDesigning in Control.ComponentState)
   or (Designer=nil) then exit;}
  if Designer.DesignCtrl<>Control then
  	Designer.DesignCtrl:=Control;
  //if Designer.CanMoveCtrl(Control) then
  // CanMoveCtrl集中到WMNCLBUTTONDOWN处理
  begin
    Pos := Control.ClientToScreen(Point(msg.XPos,msg.YPos));
    NewMsg.msg := WM_NCLBUTTONDOWN;
    NewMsg.HitTest := HTCaption;
    NewMsg.XCursor := Pos.x;
    NewMsg.YCursor := Pos.Y;
    //outputDebugString('TDesignMsgFilter.WMLBUTTONDOWN');
    Designer.DesignMsg(Newmsg);
    //IgnoreMsg(msg);
  end;
end;

procedure TDesignMsgFilter.WMNCHITTEST(var msg: TWMNCHITTEST);
begin
 { if (csDesigning in Control.ComponentState)
   or (Designer=nil) then exit;}
  if Designer.DesignCtrl=Control then
  begin
    Designer.DesignMsg(msg);

  end
  else
    Msg.result:=HTCaption // CanMoveCtrl集中到WMNCLBUTTONDOWN处理
    {
    if Designer.CanMoveCtrl(Control) then
      Msg.result:=HTCaption
    else
      Msg.result:=HTNone;
    }
  //IgnoreMsg(msg);
end;

procedure TDesignMsgFilter.WMNCLBUTTONDOWN(var msg: TWMNCLBUTTONDOWN);
var
	P : TPoint;
  Ctrl : TControl;
begin
{  if (csDesigning in Control.ComponentState)
   or (Designer=nil) then exit;}

  ctrl := Control;

  if control is TWincontrol then
  with control as TWincontrol do
  if controlCount>0 then
  begin
    P := Point(msg.XCursor,msg.YCursor);
    P := ScreenToClient(p);
  	ctrl:=ControlAtPos(p,true);
    //ctrl:=ControlAtPos(p,false); //new
    if ctrl=nil then ctrl := Control;
  end;

  if Designer.DesignCtrl<>Ctrl 	then
  	Designer.DesignCtrl:=Ctrl;
  //outputDebugString('TDesignMsgFilter.WMNCLBUTTONDOWN');

  if (Msg.HitTest<>HTCaption) or Designer.CanMoveCtrl(Ctrl) then
    Designer.DesignMsg(msg);
  //IgnoreMsg(msg);
end;

procedure TDesignMsgFilter.WMNCLBUTTONUP(var msg: TWMNCLBUTTONUP);
begin
{  if (csDesigning in Control.ComponentState)
   or (Designer=nil) then exit;}
  if Designer.DesignCtrl=Control then
  begin
    Designer.DesignMsg(msg);
    //IgnoreMsg(msg);
  end
  else inherited;
end;

procedure TDesignMsgFilter.WMNCMouseMove(var msg: TWMNCMouseMove);
begin
{  if (csDesigning in Control.ComponentState)
   or (Designer=nil) then exit;}
  if (Designer.DesignCtrl=Control) or ((Designer.DesignCtrl<>nil) and (Designer.DesignCtrl.Parent=Control)) then
  begin
    Designer.DesignMsg(msg);
    //IgnoreMsg(msg);
  end
  else inherited;
end;

procedure TDesignMsgFilter.WMMove(var msg: TWMMove);
begin
  inherited;
  SizeMove;
end;

procedure TDesignMsgFilter.WMSize(var msg: TWMSize);
begin
	inherited;
  SizeMove;
end;

procedure TDesignMsgFilter.SizeMove;
begin
  if Designer<>nil then Designer.CtrlSizeMove(Control);
end;

procedure TDesignMsgFilter.WMWINDOWPOSCHANGED(
  var message: TWMWINDOWPOSCHANGED);
begin
  inherited;
  SizeMove;
end;

procedure TDesignMsgFilter.WMNCRBUTTONDown(var Message: TWMNCRBUTTONDown);
begin
  if (Designer.DesignCtrl=Control) or ((Designer.DesignCtrl<>nil) and (Designer.DesignCtrl.Parent=Control)) then
    Designer.DesignMsg(Message) else
    inherited;
end;

procedure TDesignMsgFilter.WMNCRBUTTONUP(var Message: TWMNCRBUTTONUP);
begin
  if (Designer.DesignCtrl=Control) or ((Designer.DesignCtrl<>nil) and (Designer.DesignCtrl.Parent=Control)) then
    Designer.DesignMsg(Message) else
    inherited;
end;

{ TCustomDesigner }

procedure TCustomDesigner.CMControlChange(var msg: TCMControlChange);
begin
  if (msg.Inserting) and
    not FNotDesignNewCtrl and
  	not(msg.Control is getDesignFrameClass)
    and HookThis(msg.Control) then
  begin
    HookControl(msg.Control);

    if Designing and FFocusOnNewCtrl then
	     DesignCtrl := msg.control;
  end
  else if not msg.Inserting and
    not (msg.control is GetDesignFrameClass)
    and HookThis(msg.Control) then
    begin
      UnHookControl(msg.control);
    end;
end;

constructor TCustomDesigner.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDesigned := true;
  FDesignFrame :=  getDesignFrameClass.Create(self);
  FPlaceCtrlCursor := crHandPoint;
  FSaveCursor := Cursor;
  FNotDesignNewCtrl := false;
end;

procedure TCustomDesigner.DesignMsg(var msg);
begin
  //DesignFrame.WndProc(TMessage(Msg));
  DesignFrame.HandleNeeded;
  DesignFrame.WindowProc(TMessage(Msg));
end;

destructor TCustomDesigner.destroy;
begin
  FDesignFrame.free;
  inherited destroy;
end;

procedure TCustomDesigner.DoPlaceNewCtrl;
begin
  PlaceNewCtrl := false;
  if Assigned(FOnPlaceNewCtrl) then
    FOnPlaceNewCtrl(PlaceOn,x,y);
end;

procedure TCustomDesigner.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseDown(Button,Shift,X,Y);
  if PlaceNewCtrl then
    DoPlaceNewCtrl(self,x,y);
end;


procedure TCustomDesigner.SetDesigned(const Value: boolean);
begin
	if FDesigned <> Value then
  begin
    FDesigned := Value;
    //DesignFrame.LinkedCtrl := nil;
    SetDesignCtrl(nil);
    //SetCtrlsDesigned(self,Designed);
    SetCtrlsDesigned(self,Designing);
  end;
end;

procedure TCustomDesigner.SetOnPlaceNewCtrl(const Value: TPlaceNewCtrlEvent);
begin
  FOnPlaceNewCtrl := Value;
end;

procedure TCustomDesigner.SetPlaceNewCtrl(const Value: boolean);
begin
  if FPlaceNewCtrl <> Value then
  begin
    //FPlaceNewCtrl := Value and Designed;
    FPlaceNewCtrl := Value and Designing;
    if FPlaceNewCtrl then
    begin
      FSaveCursor := Cursor;
      Cursor := PlaceCtrlCursor;
    end
    else Cursor :=FSaveCursor;
  end;
end;

procedure TCustomDesigner.WMKeyup(var msg: TWMKEYUP);
begin
 { if (msg.Charcode=VK_delete) and Designing//Designed
    and (DesignCtrl<>nil)
    and Assigned(FOnDelete) then
    	FOnDelete(DesignCtrl)
  else inherited ;}
 // new code at arch 12/14
  inherited ;
  if (msg.Charcode=VK_delete) and Designing//Designed
    and (DesignCtrl<>nil)
    and Assigned(FOnDelete) then
    	FOnDelete(DesignCtrl);
end;

function TCustomDesigner.Designing: boolean;
begin
  result :=Designed and not (csDesigning in ComponentState);
end;

procedure TCustomDesigner.CtrlPosChanged;
begin
  if not FUpdateingDesignCtrl and Assigned(OnCtrlSizeMove) then
		OnCtrlSizeMove(self);
end;

procedure TCustomDesigner.HookControl(Ctrl: TControl);
var
  MF : TDesignMsgFilter;
  i : integer;
begin
  if not(Ctrl is getDesignFrameClass) and HookThis(Ctrl) then
  begin
    MF := TDesignMsgFilter(HookMsgFilter(Ctrl,TDesignMsgFilter));
    MF.Designer := self;
    if (Ctrl is TWinControl) and (csAcceptsControls in Ctrl.ControlStyle) then
    begin
      HookGroupMsgFilter(Ctrl,Self);
      with TWinControl(Ctrl) do
        for i:=0 to  ControlCount-1 do
        begin
          HookControl(Controls[i]);
        end;
    end else
      SAllChildren(Ctrl,act_hook);
    SetCtrlDesigned(Ctrl,Designing);
  end;
end;

procedure TCustomDesigner.UnHookControl(Control: TControl);
var
  i : integer;
begin
  if Control=DesignCtrl then
		DesignCtrl := nil;

  UnHookMsgFilter(control,TDesignMsgFilter);
  UnHookMsgFilter(control,TGroupMsgFilter);

  SAllChildren(control,act_Unhook);

  if Control is TWinControl then
    with TWinControl(Control) do
      for i:=0 to  ControlCount-1 do
        UnHookControl(Controls[i]);
end;


procedure TCustomDesigner.DoDesignCtrlChanged(DesignCtrl: TControl);
begin
  if assigned(FOnDesignCtrlChanged) then
    FOnDesignCtrlChanged(DesignCtrl);
end;

function TCustomDesigner.HookThis(acontrol: TControl): boolean;
begin
  result := true;
  if Assigned(FOnHookCtrl) then
    FOnHookCtrl(Self,acontrol,Result);
end;

function TCustomDesigner.CanMoveCtrl(Ctrl: TControl): Boolean;
begin
  Result := true;
  if Assigned(FOnCanMoveCtrl) then
    FOnCanMoveCtrl(Self,Ctrl,Result);
end;

procedure TCustomDesigner.SetDesignCtrl(Acontrol: TControl);
begin
  FUpdateingDesignCtrl := True;
  try
    InternalSetDesignCtrl(Acontrol);
  finally
    FUpdateingDesignCtrl := False;
  end;
end;

procedure TCustomDesigner.MoveSize(DelX, DelY: Integer; Moving: Boolean);
begin
  if DesignCtrl<>nil then
  begin
    if Moving then
      DesignCtrl.SetBounds(DesignCtrl.Left+DelX,DesignCtrl.Top+DelY,DesignCtrl.Width,DesignCtrl.Height)
    else
      DesignCtrl.SetBounds(DesignCtrl.Left,DesignCtrl.Top,DesignCtrl.Width+DelX,DesignCtrl.Height+DelY);
  end;
end;

procedure TCustomDesigner.KeyDown(var Key: Word; Shift: TShiftState);
var
  Moving : Boolean;
begin
  inherited;
  if ssShift in Shift then
    Moving := False
  else if ssCtrl in Shift then
    Moving := True
  else Exit;
  if key=VK_Left then
    MoveSize(-MoveSizeStep,0,Moving)
  else if key=VK_Right then
    MoveSize(MoveSizeStep,0,Moving)
  else if key=VK_Up then
    MoveSize(0,-MoveSizeStep,Moving)
  else if key=VK_Down then
    MoveSize(0,MoveSizeStep,Moving);
end;

procedure TCustomDesigner.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_WANTALLKEYS or DLGC_WANTARROWS or DLGC_WANTTAB;
end;

type
  TControlAccess = class(TControl);

procedure TCustomDesigner.SetPopupMenu(const Value: TPopupMenu);
begin
  inherited PopupMenu := Value;
  TControlAccess(DesignFrame).PopupMenu := Value;
end;

function TCustomDesigner.GetPopupMenu: TPopupMenu;
begin
  Result := inherited PopupMenu;
end;

function TCustomDesigner.CanSizeCtrl(Ctrl: TControl): Boolean;
begin
  Result := True;
  if Assigned(FOnCanSizeCtrl) then
    FOnCanSizeCtrl(Self,Ctrl,Result);
end;

{ TGroupMsgFilter }

procedure TGroupMsgFilter.CMControlChange(var msg: TCMControlChange);
begin
  if control.parent<>nil then
  begin
    //control.parent.windowProc(TMessage(msg));
    OtherControl.windowProc(TMessage(msg));
    //IgnoreMsg(msg);
  end;
  inherited;
end;


procedure DrawFrame(Canvas : TCanvas; Pen : TPen; ARect : TRect);
begin
  canvas.pen := Pen;
  with canvas,ARect do
  begin
    dec(right,pen.width);
    dec(bottom,pen.width);
    MoveTo(left,top);
    LineTo(right,top);
    LineTo(right,bottom);
    LineTo(left,bottom);
    LineTo(left,top);
  end;
end;


{ TDesignFrame }

constructor TDesignFrame.Create(AOwner: TComponent);
begin
  if not (AOwner is TCustomDesigner) then RaiseInvalidParam;
  inherited Create(AOwner);
  //Brush.Style := bsClear;
  ControlStyle := ControlStyle-[csOpaque];
  FPen := TPen.Create;
  FBorderSize := 1;
  FDesigner := TCustomDesigner(AOwner);
  FLinkedCtrl :=nil;
  FSizeEnabled := True;
end;

procedure TDesignFrame.Paint;
var
  SaveIndex: Integer;
begin
  //canvas.FrameRect(ClientRect);
  pen.width := borderSize;
  DrawFrame(canvas,pen,clientRect);
  if LinkedCtrl is TGraphicControl then
  begin
    SaveIndex := SaveDC(canvas.handle);
	  MoveWindowOrg(canvas.handle,BorderSize, BorderSize);
  	LinkedCtrl.perform(wm_paint,Canvas.Handle,0);
  	RestoreDC(canvas.handle, SaveIndex);
  end;
end;

procedure TDesignFrame.WMMove(var msg: TWMMove);
begin
  AdjustLinkedCtrl;
end;

procedure TDesignFrame.WMSize(var msg: TWMSize);
begin
  AdjustLinkedCtrl;
end;

procedure TDesignFrame.AdjustLinkedCtrl;
begin
  if LinkedCtrl<>nil then
  LinkedCtrl.SetBounds(left+BorderSize,Top+BorderSize,
  	width-2*BorderSize,height-2*BorderSize);
  SendToBack;
  Designer.CtrlPosChanged;
end;

procedure TDesignFrame.SetLinkedCtrl(const Value: TControl);
var
  Newvalue : TControl;
  {$ifdef debug}
  s : string;
  {$endif }
begin
  if Designer.Designing and
    ( (value=nil) or not (csLoading in value.ComponentState)) then
	  Newvalue := Value
  else Newvalue :=nil;
  if (Newvalue<>FLinkedCtrl) then
  begin
    FLinkedCtrl := Newvalue;
    if FLinkedCtrl<>nil then
    begin
      FLinkedCtrl.FreeNotification(self);

      SetTheBounds;
      parent := FLinkedCtrl.parent;
      visible := true;
      SendToBack;
      // resolve the display problem when change LinkedCtrl between two TGraphicControls
      if FLinkedCtrl is TGraphicControl then Repaint
      {else if FLinkedCtrl<>nil then FLinkedCtrl.repaint};

      if csLoading in FLinkedCtrl.componentState then exit;

      if FLinkedCtrl is TGraphicControl then
        SetfocusOn(self)
      else if FLinkedCtrl is TWinControl then
        SetfocusOn(FLinkedCtrl as TWinControl);
    end
    else
    begin
      visible:=false;
      setBounds(left,top,0,0);
      parent := Designer;
    end;
    {$ifdef debug}
    s := 'Design:'+GetDebugText(FLinkedCtrl);
    OutputDebugString(pchar(s));
    {$endif}
    if Assigned(FOnDesignCtrlChanged) then
      FOnDesignCtrlChanged(FLinkedCtrl);
  end;
end;

procedure TDesignFrame.WMNCHITTEST(var msg: TWMNCHITTEST);
var
  Dirs : TDirections;
  SelfRect : TRect;
begin
  //if csDesigning in ComponentState then exit;
  SelfRect := GetControlRect(self);
  if not designer.Designing then exit;
  Dirs := GetHitDirections(SelfRect,msg.XPos,msg.YPos);
  if Dirs=[drLeft,drTop] then msg.result:=HTTOPLEFT else
  if Dirs=[drRight,drTop] then msg.result:=HTTOPRight else
  if Dirs=[drLeft,drBottom] then msg.result:=HTBottomLEFT else
  if Dirs=[drRight,drBottom] then msg.result:=HTBottomRight else
  if Dirs=[drLeft] then msg.result:=HTLeft else
  if dirs=[drRight] then msg.result:=HTRight else
  if Dirs=[drTop]	then msg.result:=HTTop else
  if Dirs=[drBottom] then msg.result:=HTBottom else
  if PtInRect(selfRect,point(msg.xpos,msg.ypos)) then
  	msg.result:=HTCaption
  else //msg.result:=HTTRANSPARENT;
    //msg.result:=HTNOWhere;
    msg.result:=HTNone;
  if not SizeEnabled and not (msg.result in [HTCaption,HTNone]) then
    msg.result := HTCaption;
end;

(*
procedure TDesignFrame.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.style := Params.style and not WS_CLIPSIBLINGS;
end;
*)


procedure TDesignFrame.WMERASEBKGND(var Message: TWMERASEBKGND);
begin
  Message.result:=1;
  //inherited;
end;

procedure TDesignFrame.SetPen(const Value: TPen);
begin
  FPen.Assign(Value);
end;

procedure TDesignFrame.SetBorderSize(const Value: integer);
begin
  if value<0 then RaiseInvalidParam;
  FBorderSize := Value;
end;

destructor TDesignFrame.destroy;
begin
  FPen.free;
  inherited destroy;
end;


procedure TDesignFrame.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (LinkedCtrl=AComponent) and (Operation=opRemove) then
    LinkedCtrl:=nil;
  inherited Notification(AComponent,Operation);
end;

procedure TDesignFrame.WMNCLBUTTONDOWN(var msg: TWMNCLBUTTONDOWN);
var
  PlaceOn : TWinControl;
  P1,P2 : TPoint;
  ACtrl : TControl;
begin
	//if not PtInRect(GetControlRect(self),Point(msg.XCursor,msg.YCursor))
  p1 := point(msg.XCursor,msg.YCursor);
  if msg.HitTest=HTMenu then
  begin
    ACtrl := ChildFromPos(Designer,p1,true);
    //ACtrl := ChildFromPos(Designer,p1,false); // new
    LinkedCtrl := ACtrl;
  end;
  if Designer.PlaceNewCtrl and (LinkedCtrl<>nil) then
  begin
    //if LinkedCtrl is TWinControl then PlaceOn := LinkedCtrl as TWinControl
    if csAcceptsControls in LinkedCtrl.controlstyle then PlaceOn := LinkedCtrl as TWinControl
    else PlaceOn := LinkedCtrl.parent;
    P2 := PlaceOn.ScreenToClient(p1);
    Designer.DoPlaceNewCtrl(PlaceOn,p2.x,p2.Y);
  end
  else inherited;
  // force to back
  sendtoback;
end;

procedure TDesignFrame.WndProc(var Message: TMessage);
begin
  case Message.msg of
    WM_KeyDown,WM_KeyUp,WM_SysKeyDown,WM_SysKeyUp,
    WM_Char,WM_SysChar,WM_DeadChar,WM_SysDeadChar:
    begin
      Designer.WindowProc(Message);
    end
  else inherited WndProc(Message);
  end;
end;

function	SetFocusOn(WinCtrl : TWinControl):boolean;
begin
  result:= (WinCtrl<>nil) and WinCtrl.Canfocus;
  if result then WinCtrl.setfocus;
end;

procedure TDesignFrame.InternalSizeMove(ACtrl: TControl);
begin
  if ACtrl=LinkedCtrl then
  begin
    //FLockSizeMove := true;
    SetTheBounds;
    //FLockSizeMove := false;
  end;
end;

procedure TDesignFrame.SetTheBounds;
begin
  SetBounds(FLinkedCtrl.left-BorderSize,FLinkedCtrl.Top-BorderSize,
      	FLinkedCtrl.Width+2*BorderSize,FLinkedCtrl.Height+2*BorderSize);
  Designer.CtrlPosChanged;
end;

function 	NeedSHook(AControl : TControl):boolean;
begin
  result := (AControl is TWinControl)and
   not (csAcceptsControls in Acontrol.controlstyle) and
   not (csDestroying in AControl.ComponentState);
end;

function 	SForEachChild(hwnd : HWND ;	// handle to child window
    lParam : LPARAM  	// application-defined value
   ):BOOL; stdcall;export;
begin
  result := true;
  case TChildaction(lparam) of
    act_Hook 	 : SubClass(hwnd,TPassMouseToParent);
    act_Unhook : ReleaseSubClass(hwnd,TPassMouseToParent);
    act_Enabled : EnableSubClass(hwnd,TPassMouseToParent,true);
    act_Disabled: EnableSubClass(hwnd,TPassMouseToParent,false);
  end;
end;

procedure SAllChildren(AControl : TControl; action : TChildAction);
var
  LParam : longint;
begin
  if NeedSHook(AControl) then
  begin
    LParam := longint(action);
  	EnumChildWindows(TWinControl(AControl).handle,
    	@SForEachChild,lparam);
  end;
end;

procedure HookGroupMsgFilter(Control,OtherControl : TControl);
begin
  TGroupMsgFilter(
    HookMsgFilter(Control,
    TGroupMsgFilter)
  ).OtherControl := OtherControl;
end;

procedure TDesignFrame.WMNCRBUTTONUP(var Message: TWMNCRBUTTONUP);
begin
  inherited;
  Perform(WM_CONTEXTMENU,Handle,MakeLong(Message.XCursor,Message.YCursor));
end;

procedure TDesignFrame.SetSizeEnabled(const Value: Boolean);
begin
  if FSizeEnabled <> Value then
  begin
    FSizeEnabled := Value;
  end;
end;

{ TDesigner }

constructor TDesigner.Create(AOwner: TComponent);
begin
  inherited;
  TDesignFrame(DesignFrame).OnDesignCtrlChanged := DoDesignCtrlChanged;
end;

function TDesigner.GetDesignCtrl: TControl;
begin
  result := TDesignFrame(DesignFrame).LinkedCtrl;
end;

class function TDesigner.getDesignFrameClass: TDesignFrameClass;
begin
  result := TDesignFrame;
end;

procedure TDesigner.InternalSetDesignCtrl(Acontrol: TControl);
begin
  if TDesignFrame(DesignFrame).LinkedCtrl<>Acontrol then
  begin
    TDesignFrame(DesignFrame).LinkedCtrl := Acontrol;
    if Acontrol<>nil then
      TDesignFrame(DesignFrame).SizeEnabled := CanSizeCtrl(Acontrol);
  end;
end;

procedure TDesigner.CtrlSizeMove(ACtrl: TControl);
begin
  if DesignCtrl=ACtrl then
  begin
    TDesignFrame(DesignFrame).InternalSizeMove(ACtrl);
  end;
end;

end.
