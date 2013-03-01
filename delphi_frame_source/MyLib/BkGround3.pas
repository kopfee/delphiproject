unit BkGround3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,extctrls,
  ComWriUtils,ComCtrls,StdCtrls,Buttons,CheckLst,Mask,DBCtrls;

type
  TBackGround = class(TCustomControl)
  private
    { Private declarations }
    //FImage : TImage;
    FPicture	: TPicture;
    NULLBrush : HBrush;
    FTransparent: boolean;
    procedure SetPicture(const Value: TPicture);
    function GetPicture: TPicture;
   { procedure WMCtlColor(var Msg : TWMCtlColor);
    procedure WMCtlColorEdit(var Msg : TWMCtlColor);message WM_CtlColorEdit;
    procedure WMCtlColorBtn(var Msg : TWMCtlColor);message WM_CtlColorBtn;
    procedure WMCtlColorLISTBOX(var Msg : TWMCtlColor);message WM_CtlColorLISTBOX;
    procedure WMCtlColorScrollbar(var Msg : TWMCtlColor);message WM_CtlColorScrollbar;
    procedure WMCtlColorStatic(var Msg : TWMCtlColor);message WM_CtlColorStatic;
    procedure WMCommand(var msg : TWMCommand); message WM_Command;
   }
    procedure CMControlChange(var msg:TCMControlChange); message CM_CONTROLCHANGE;

    //function GetBrush: TBrush;
    //procedure SetBrush(const Value: TBrush);
    procedure BrushChange(sender:TObject);
    procedure PictureChange(sender:TObject);
    procedure SetTransparent(const Value: boolean);
    procedure EnableTransmaker(ctrl : TControl;Transparent : boolean);
  protected
    { Protected declarations }
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint;override;
  public
    { Public declarations }
    constructor Create(AOwner:TComponent);override;
    destructor  Destroy; override;
    procedure 	PaintCtrlBkGround(WinCtrl:TControl;DC:HDC);
    procedure   PaintWindowBkGround(Win:HWnd;DC:HDC);
    // x,y,w,h is the left,top,width,height of the control
    procedure   PaintBKGround(DC:HDC;x,y,W,H : integer);
  published
    { Published declarations }
    property Picture : TPicture read GetPicture write SetPicture;
    property Transparent : boolean read FTransparent write SetTransparent;
    //property Brush : TBrush read GetBrush write SetBrush;

    property Align;
    property Anchors;
    property Brush;
    //property Color;
    property DragKind;
    property DragCursor;
    property DragMode;
    property Font;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property OnCanResize;
    property OnConstrainedResize;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnDockDrop;
    property OnDockOver;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnUnDock;
  end;


  TTransparentMaker = class(TMsgFilter);
  // for ciComplex2
  TTransparentMaker1 = class(TTransparentMaker)
  private
    painting : boolean;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  end;

  {
  TTransparentMaker2 = class(TMsgFilter)
  private
    painting : boolean;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  end;
  }

  // for TGraphicControl
  TTransparentMaker3 = class(TTransparentMaker)
  private
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  end;

  // ciComplex4
  // like TTransparentMaker1
  // but clear background before TTransparentMaker1.WM_Paint
  // for TreeView and ListView
  TTransparentMaker4 = class(TTransparentMaker1)
  private
    //procedure WMERASEBKGND(var Message:TWMERASEBKGND); message WM_ERASEBKGND;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  end;

  // ciComplex3
  // for RadioGroup to resolve invisible problum
  // force children to repaint on self WM_paint
  TTransparentMaker5 = class(TTransparentMaker1)
  private
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  end;

  // pass container's message to BackGround
  TContainerMsgFilter = class(TMsgFilter)
  private
    procedure WMCommand(var msg : TWMCommand); message WM_Command;
  protected
    procedure PreHandle(var Message: TMessage); override;
  end;

  TBackGroundMsgFilter = class(TMsgFilter)
  private
    function GetBackGround: TBackGround;
    procedure WMCtlColor(var Msg : TWMCtlColor);
    procedure WMCtlColorEdit(var Msg : TWMCtlColor);message WM_CtlColorEdit;
    procedure WMCtlColorBtn(var Msg : TWMCtlColor);message WM_CtlColorBtn;
    procedure WMCtlColorLISTBOX(var Msg : TWMCtlColor);message WM_CtlColorLISTBOX;
    procedure WMCtlColorScrollbar(var Msg : TWMCtlColor);message WM_CtlColorScrollbar;
    procedure WMCtlColorStatic(var Msg : TWMCtlColor);message WM_CtlColorStatic;
    procedure WMCommand(var msg : TWMCommand); message WM_Command;
    //procedure CMControlChange(var msg:TCMControlChange); message CM_CONTROLCHANGE;
  public
    property BackGround : TBackGround read GetBackGround;
  end;
type
  TCtrlType = (ciSimple,ciComplex1,ciComplex2,ciComplex3,ciComplex4,ciUnknown);

  { ciSimple 	: On CtrlColor event set BKMode and the NULL brush
    ciComplex1 : On CtrlColor event set BKMode and the NULL brush
    						then paint the BK and itself
    ciComplex2:
    					On CtrlColor event set BKMode and the NULL brush, then make it repaint
    					In WM_Paint, use Membitmap and special treatments
              use TTransparentMaker1
    ciComplex3: use TTransparentMaker5
    ciComplex4:
              use TTransparentMaker4 base of TTransparentMaker1
  }
type
  TCtrlInfo = record
    ClassType : TClass;
    CtrlType : TCtrlType;
    color : TColor;
    HasChild : boolean;
    NeedClearBrush : boolean;
  end;

  PCtrlInfo = ^TCtrlInfo;

// usage :
// must pass "const pointer" to RegisterCtrlInfo and UnRegisterCtrlInfo
procedure RegisterCtrlInfo(p : PCtrlInfo);
procedure UnRegisterCtrlInfo(p : PCtrlInfo);

implementation

uses DrawUtils,TypUtils;


const
  CtrlNum = 21-3;
  CtrlInfos : array [0..CtrlNum-1] of TCtrlInfo
 = ( (ClassType :TCustomLabel;		CtrlType :ciSimple;				color : clBtnFace; HasChild : false
 				;NeedClearBrush : false),
 		 (ClassType :TCustomRichEdit;	CtrlType :ciComplex2;	color : clWhite; 	 HasChild : false;NeedClearBrush : false),
     //(ClassType :TCustomMemo;			CtrlType :ciComplex1;			color : clWhite),
 		 (ClassType :TCustomEdit;			CtrlType :ciComplex1;			color : clWhite; HasChild : false;NeedClearBrush : false),
     (ClassType :TDBEdit;			CtrlType :ciComplex2;			color : clWhite; HasChild : false;NeedClearBrush : false),
     //(ClassType :TBitBtn;		CtrlType :ciComplex2;				color : clBtnFace),
     (ClassType :TButton;					CtrlType :ciComplex2;	color : clBtnFace; HasChild : false;NeedClearBrush : false),
     (ClassType :TRadioButton;		CtrlType :ciComplex1;				color : clBtnFace; HasChild : false;NeedClearBrush : false),
     (ClassType :TCustomCheckBox;	CtrlType :ciComplex1;				color : clBtnFace; HasChild : false;NeedClearBrush : false),
     (ClassType :TCustomListBox;	CtrlType :ciComplex1;			color : clWhite; HasChild : false;NeedClearBrush : true),
     (ClassType :TCheckListBox;		CtrlType :ciComplex4;			color : clWhite; HasChild : false;NeedClearBrush : false),
     (ClassType :TCustomPanel;		CtrlType :ciComplex3;	color : clBtnFace; HasChild : true;NeedClearBrush : false),
     (ClassType :TCustomRadioGroup;CtrlType :ciComplex3;	color : clBtnFace; HasChild : true;NeedClearBrush : false),
     (ClassType :TCustomGroupBox;	CtrlType :ciComplex3;	color : clBtnFace; HasChild : true;NeedClearBrush : false),
     (ClassType :TScrollBox;CtrlType :ciSimple;							color : clBtnFace; HasChild : true;NeedClearBrush : false),
     (ClassType :TCustomStaticText;CtrlType :ciComplex1{ciSimple};			color : clBtnFace; HasChild : false;NeedClearBrush : false),
     //(ClassType :TCustomMaskEdit;	CtrlType :ciSimple;				color : clWhite),
     (ClassType :TCustomTreeView;	CtrlType :ciComplex4;	color : clWhite; HasChild : false;NeedClearBrush : false),
     (ClassType :TCustomListView;	CtrlType :ciComplex4;	color : clWhite; HasChild : false;NeedClearBrush : false),
     (ClassType :TSpeedButton;		CtrlType :ciComplex1;				color : clBtnFace; HasChild : false;NeedClearBrush : false),
     (ClassType :TCustomComboBox;	CtrlType :ciSimple;	color : clWhite; HasChild : true;NeedClearBrush : false) );

  defaultColor = clWhite;

var
  RegisterCtrls : TList;

procedure RegisterCtrlInfo(p : PCtrlInfo);
begin
  if (p<>nil) and (RegisterCtrls.indexof(p)<0) then
    RegisterCtrls.Add(p);
end;

procedure UnRegisterCtrlInfo(p : PCtrlInfo);
begin
  RegisterCtrls.remove(p);
end;

// get control match information index
// if not find ,return -1
function GetMatch(control : TControl):integer;
var
  i : integer;
begin
  for i:=0 to CtrlNum-1 do
    if control.classtype = CtrlInfos[i].ClassType then
    begin
      result := i;
      exit;
    end;
  for i:=0 to RegisterCtrls.count-1 do
    if control.classtype = TCtrlInfo(RegisterCtrls[i]^).ClassType then
    begin
      result := i;
      exit;
    end;
  for i:=0 to CtrlNum-1 do
    if control is CtrlInfos[i].ClassType then
    begin
      result := i;
      exit;
    end;
  for i:=0 to RegisterCtrls.count-1 do
    if control is TCtrlInfo(RegisterCtrls[i]^).ClassType then
    begin
      result := i;
      exit;
    end;
  result:=-1;
end;

function GetCtrlType(control : TControl):TCtrlType;
var
  i : integer;
begin
  i := GetMatch(control);
  if i=-1 then result := ciUnknown
  else result:=CtrlInfos[i].CtrlType;
end;

function GetCtrlColor(Control : TControl):TColor;
var
  i : integer;
begin
  if not GetOrdProperty(control,'color',longint(result)) then
  begin
    i := GetMatch(control);
	  if i=-1 then result := defaultColor
	  else result:=CtrlInfos[i].color;
  end;
end;

function CtrlHasChild(Control : TControl):boolean;
var
  i : integer;
begin
  if csAcceptsControls in control.controlstyle then result := true
  else
  begin
	  i := GetMatch(control);
		if i=-1 then result := false
	  else result:=CtrlInfos[i].HasChild;
  end;
end;

function CtrlNeedClearBrush(Control : TControl):boolean;
var
  i : integer;
begin
  if not (control is TWinControl) then result:=false
  else
  begin
    i := GetMatch(control);
		if i=-1 then result := false
	  else result:=CtrlInfos[i].NeedClearBrush;
  end;
end;

// if there isn't a wincontrol , return false
function GetWindowCtrlType(win : HWnd; var CtrlType : TCtrlType):boolean;
var
  Ctrl : TWinControl;
begin
  Ctrl := FindControl(win);
  if ctrl=nil then
  begin
    ctrlType:=ciUnknown;
    result:=false
  end
  else
  begin
		ctrlType:=GetCtrlType(ctrl);
    result := true;
  end;
end;

var
  PaintingWindows : TNumberList;

{ TBackGround }

procedure TBackGround.BrushChange(sender: TObject);
begin
  if not (picture.graphic is TBitmap) then repaint;
end;

procedure TBackGround.CMControlChange(var msg: TCMControlChange);
var
  CtrlType : TCtrlType;
  WinStyle : longWord;
begin
  with msg do
  if Inserting then
  begin
    if (control is TBackGround) then exit;
    // for TLabel and so on
    Control.ControlStyle := control.ControlStyle - [csOpaque];
    //SetOrdProperty(control,'Transparent',integer(true));

    if CtrlHasChild(Control) then
      hookMsgFilter(control,TContainerMsgFilter);

    CtrlType := GetCtrlType(control);

    if control is TWinControl then
    begin
      if CtrlNeedClearBrush(control) then
        (control as TWinControl).brush.style := bsClear;

     { WinStyle := GetWindowLong((control as TWinControl).handle,GWL_STYLE);
      WinStyle := WinStyle and not WS_CLIPCHILDREN;
      SetWindowLong((control as TWinControl).handle,GWL_STYLE,WinStyle);
     }
  	  case CtrlType of
     // ciComplex1 : hookMsgFilter(control,TTransparentMaker2);
      ciComplex2,ciUnknown : hookMsgFilter(control,TTransparentMaker1);
      ciComplex3 : hookMsgFilter(control,TTransparentMaker5);
      ciComplex4 : hookMsgFilter(control,TTransparentMaker4);
    	end;
    end
    else
    	if (control is TGraphicControl)
        and (CtrlType<>ciSimple)
      then hookMsgFilter(control,TTransparentMaker3);
  end
  //else UnhookMsgFilter(control);
end;

constructor TBackGround.Create(AOwner: TComponent);
{var
  LogBrush : TLogBrush;}
begin
  inherited Create(AOwner);
  width := 100;
  height := 100;
  ControlStyle := ControlStyle + [csAcceptsControls];
  {FImage:=TImage.Create(self);
  FImage.align:=alClient;
  FImage.stretch := true;}
  FPicture := TPicture.Create;
  FPicture.OnChange := PictureChange;
  //insertControl(FImage);
  //LogBrush.lbStyle := BS_NULL;
  //NULLBrush := CreateBrushIndirect(LogBrush);
  NULLBrush := GetStockObject(NULL_BRUSH);
  Brush.OnChange := BrushChange;
  //Brush.style := bsClear;
  HookMsgFilter(self,TBackGroundMsgFilter);
  FTransparent := true;
end;

procedure TBackGround.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.style := Params.style and not WS_CLIPCHILDREN;
end;

destructor TBackGround.Destroy;
begin
  //FImage.free;
  FPicture.free;
  inherited destroy;
end;

(*
function TBackGround.GetBrush: TBrush;
begin
  result := canvas.Brush;
end;
*)
procedure TBackGround.EnableTransmaker(ctrl: TControl;
  Transparent: boolean);
var
  i : integer;
begin
  if not (ctrl is TWinControl) then exit;
  with (ctrl as TWinControl) do
  begin
    if ctrlNeedClearBrush(ctrl) then
      if transparent then Brush.style:=bsClear
      else Brush.style:=bsSolid;
	  for i:=0 to controlcount-1 do
  	  if not (controls[i] is TBackGround) then
    	begin
      	EnableMsgFilter(controls[i],Transparent,TTransparentMaker);
	      EnableTransmaker(controls[i],Transparent);
  	  end;
  end;
end;

function TBackGround.GetPicture: TPicture;
begin
  result := FPicture;
end;

procedure TBackGround.Paint;
begin
  if FPicture.graphic is TBitmap then
		 Canvas.StretchDraw(clientRect,FPicture.Bitmap)
  else
  begin
    canvas.Brush := brush;
    Canvas.FillRect(clientRect);
  end;
end;

procedure TBackGround.PaintBKGround(DC: HDC; x, y, W, H: integer);
var
  sx,sy,sw,sh : integer;
  XRate,YRate : real;
  oldPalette : HPalette;
begin
  if (width=0) or (height=0) then exit;
  if (picture.Graphic is TBitmap) then
  begin
  XRate := picture.bitmap.Width / width;
  YRate := picture.bitmap.Height/ Height;
  sx := round(x*XRate);
  sy := round(y*YRate);
  sW := round(w*XRate);
  sH := round(h*YRate);
  oldPalette:=SelectPalette(DC,picture.bitmap.Palette,true);
  try
    RealizePalette(DC);
	 {	BitBlt(DC,0,0,WinCtrl.ClientWidth,WinCtrl.ClientHeight,
    	FImage.picture.bitmap.canvas.handle,origin.x,origin.y,SRCCOPY);}
    StretchBlt(DC,0,0,w,h,picture.bitmap.canvas.handle,sx,sy,sw,sh,SRCCOPY);
  finally
    SelectPalette(DC,OldPalette,false);
  end;
  end
  else
  begin
    FillRect(DC,rect(0,0,w,h),brush.Handle);
  end;
end;

procedure TBackGround.PaintCtrlBkGround(WinCtrl: TControl; DC: HDC);
var
  //oldPalette : HPalette;
  origin : TPoint;
begin
  origin.x := 0;
  origin.y := 0;
  origin:=WinCtrl.ClientToScreen(origin);
  origin:=ScreenToClient(origin);
  PaintBKGround(DC,origin.x,origin.y,WinCtrl.ClientWidth,WinCtrl.ClientHeight);
  (*oldPalette:=SelectPalette(DC,FImage.picture.bitmap.Palette,true);
  try
    RealizePalette(DC);
	 {	BitBlt(DC,0,0,WinCtrl.ClientWidth,WinCtrl.ClientHeight,
    	FImage.picture.bitmap.canvas.handle,origin.x,origin.y,SRCCOPY);}
    BitBlt(DC,0,0,WinCtrl.Width,WinCtrl.Height,
    	FImage.picture.bitmap.canvas.handle,origin.x,origin.y,SRCCOPY);
  finally
    SelectPalette(DC,OldPalette,false);
  end;
  //PaintWindowBkGround(WinCtrl.handle,DC);*)

end;

procedure TBackGround.PaintWindowBkGround(Win: HWnd; DC: HDC);
var
  //oldPalette : HPalette;
  origin : TPoint;
  rect : TRect;
begin
  origin.x := 0;
  origin.y := 0;
  windows.ClientToScreen(Win,origin);
  origin:=ScreenToClient(origin);
  windows.GetClientRect(win,rect);
  PaintBKGround(DC,origin.x,origin.y,rect.right,rect.Bottom);
  //windows.GetWindowRect(win,rect);
 (* oldPalette:=SelectPalette(DC,FImage.picture.bitmap.Palette,true);
  try
    RealizePalette(DC);
		BitBlt(DC,0,0,rect.right,rect.Bottom,
    	FImage.picture.bitmap.canvas.handle,origin.x,origin.y,SRCCOPY);
  finally
    SelectPalette(DC,OldPalette,false);
  end; *)
end;

(*
procedure TBackGround.SetBrush(const Value: TBrush);
begin
  canvas.brush.assign(value);
  if not (picture.graphic is TBitmap) then repaint;
end;
*)
procedure TBackGround.PictureChange(sender: TObject);
begin
  repaint;
end;

procedure TBackGround.SetPicture(const Value: TPicture);
begin
  FPicture.assign(Value);
end;

(*
procedure TBackGround.WMCommand(var msg: TWMCommand);
begin
  inherited;
  //invalidateRect(msg.Ctl,nil,false);
  if msg.NotifyCode=EN_Update then
     invalidateRect(msg.Ctl,nil,false);
end;
*)
{ successful}
(*
procedure TBackGround.WMCtlColor(var Msg: TWMCtlColor);
var
  DC : HDC;
  CtrlType : TCtrlType;
begin
  {setBKMode(msg.ChildDC,transparent);
  msg.Result:= NULLBrush;}
  // if not find the wincontrol, treat it as ciComplex1
  // because CtrlType=ciUnknown
  if GetWindowCtrlType(msg.ChildWnd,CtrlType) then
  begin
    if (CtrlType=ciComplex2) then
      begin
				invalidateRect(msg.childWnd,nil,false);
        exit;
      end;
  end;
  setBKMode(msg.ChildDC,transparent);
  msg.Result:= NULLBrush;
  if (CtrlType=ciComplex4)then
      begin
				invalidateRect(msg.childWnd,nil,false);
        exit;
      end;
  if CtrlType=ciSimple then exit;

  // CtrlType = ciComplex1
  // Is the window  painting ?
  if PaintingWindows.indexOf(Msg.ChildWnd)<0 then
  begin
    // if not in painting , do painting
    PaintingWindows.Add(Msg.ChildWnd);
    DC := GetDC(Msg.ChildWnd);
		  try
		    PaintWindowBkGround(Msg.ChildWnd,DC);
		    sendmessage(msg.ChildWnd,WM_Paint,DC,0);
		  finally
		    releaseDC(Msg.ChildWnd,DC);
        PaintingWindows.remove(Msg.ChildWnd);
		  end;
      cancelDC(msg.childDC);
  end;
end;
*)
(*
procedure TBackGround.WMCtlColorBtn(var Msg: TWMCtlColor);
begin
  WMCtlColor(Msg);
end;

procedure TBackGround.WMCtlColorEdit(var Msg: TWMCtlColor);
begin
  WMCtlColor(Msg);
end;
*)
(*
procedure TBackGround.WMCtlColorLISTBOX(var Msg: TWMCtlColor);
begin
  // for resolve the problum with TComboBox
  if findControl(msg.childwnd)<>nil then WMCtlColor(Msg)
  else inherited;
end;

procedure TBackGround.WMCtlColorScrollbar(var Msg: TWMCtlColor);
begin
  WMCtlColor(Msg);
end;

procedure TBackGround.WMCtlColorStatic(var Msg: TWMCtlColor);
begin
  WMCtlColor(Msg);
end;
*)
procedure TBackGround.SetTransparent(const Value: boolean);
begin
  if (FTransparent <> Value)  then
  begin
    FTransparent := Value;
    EnableMsgFilter(self,FTransparent,TBackGroundMsgFilter);
    EnableTransmaker(self,FTransparent);
    repaint;
  end;
end;

{ TTransparentMaker1 }

function FindBackGround(Control:TControl):TBackGround;
var
  ctrl : Tcontrol;
begin
  result := nil;
  ctrl := control;
  while ctrl<>nil do
  begin
    if ctrl is TBackGround then
    begin
      result := ctrl as TBackGround;
      exit;
    end;
    ctrl := ctrl.parent;
  end;
end;

procedure TTransparentMaker1.WMPaint(var Message: TWMPaint);
var
  DC, MemDC: HDC;
  MemBitmap, OldBitmap: HBITMAP;
  AHandle : HWnd;
  color : TColor;
  BK : TBackGround;
  // New test
  PS : PaintStruct;
  // End New test
begin
    AHandle := handle;
    if AHandle=0 then exit;
    if painting then exit;
    painting := true;
    color := GetCtrlColor(Control);
		MemBitmap :=0;
  	MemDC := 0;
	  OldBitmap :=0;
    BK := FindBackGround(control);
	  invalidaterect(AHandle,nil,false);
  	defaultHandler(Message);
	  if message.dc=0 then DC := GetDC(Ahandle) // disable for test
      //DC := BeginPaint(AHandle,ps) // bad work
      else DC := message.dc;
	  try
		  MemBitmap := CreateCompatibleBitmap(DC, control.ClientRect.Right, control.ClientRect.Bottom);
    	MemDC := CreateCompatibleDC(0);
	    OldBitmap := SelectObject(MemDC, MemBitmap);
      // copy DC to MemDC
      BitBlt(MemDC,0,0,control.ClientRect.Right, control.ClientRect.Bottom,DC,0,0,SRCCOPY);
      //BitBlt(MemDC,0,0,control.width, control.height,DC,0,0,SRCCOPY);
      // paint background to DC
  	  if BK<>nil then
    	  BK.PaintCtrlBkGround(TWinControl(control),dc)
	    else  BitBlt(DC,0,0,control.ClientRect.Right, control.ClientRect.Bottom,0,0,0,Whiteness);
        //BitBlt(DC,0,0,control.width, control.height,0,0,0,Whiteness);

      StretchBltTransparent(DC,0,0,control.width,control.height,
        MemDC,0,0,control.width,control.height,0,
        color);
      {StretchBltTransparent(DC,0,0,control.Clientwidth,control.Clientheight,
        MemDC,0,0,control.width,control.height,0,
        color);}
	  finally
      if message.dc=0 then releaseDC(AHandle,DC); // disable for test
      //endpaint(AHandle,PS); bad work
      ValidateRect(AHandle,nil); // disable for test
      SelectObject(MemDC, OldBitmap);
      DeleteDC(MemDC);
      DeleteObject(MemBitmap);
      IgnoreMsg(TMessage(message));
      painting := false;
  	end;
end;

{ TTransparentMaker2 }
{
procedure TTransparentMaker2.WMPaint(var Message: TWMPaint);
var
  DC : HDC;
  BK : TBackGround;
  oldBrush : HBrush;
begin
  if painting then defaultHandler(message)
  else begin
	  if handle=0 then exit;
    painting := true;
	  bypass := true;
    DC := GetDC(handle);
		try
      BK := FindBackGround(control);
	    if BK<>nil then
  	     BK.PaintCtrlBkGround(TWinControl(control),dc)
    	else  BitBlt(DC,0,0,control.ClientRect.Right, control.ClientRect.Bottom,0,0,0,Whiteness);

      if BK<>nil then
      begin
	      setBKMode(DC,transparent);
  	    oldBrush := SelectObject(DC,BK.NULLBrush);
      end;
      message.dc := DC;
		  defaultHandler(message);
      message.dc := 0;
		finally
      painting := false;
      SelectObject(DC,OldBrush);
      ValidateRect(Handle,nil);
	    releaseDC(handle,DC);
		end;
    //cancelDC(msg.childDC);
  end
end;
}

{ TTransparentMaker3 }

procedure TTransparentMaker3.WMPaint(var Message: TWMPaint);
var
  DC, MemDC: HDC;
  MemBitmap, OldBitmap: HBITMAP;
  color : TColor;
  BK : TBackGround;
//  FreeDC : boolean;
begin
{  if message.DC = 0 then
  begin
    if not (control is TWinControl) then exit;
    FreeDC := true;
    message.DC := GetDC(handle);
  end
  else FreeDC :=false;}
  if Message.DC<>0 then
  begin
   // bypass:=true;
    color := GetCtrlColor(Control);
    DC := message.DC;
    MemBitmap := CreateCompatibleBitmap(DC, control.ClientRect.Right, control.ClientRect.Bottom);
   	MemDC := CreateCompatibleDC(DC);
    OldBitmap := SelectObject(MemDC, MemBitmap);
	  try
      // paint itself image to memDC
      Message.DC := MemDC;
  		defaultHandler(Message);
      Message.DC := DC;
      // paint background to DC
 	    BK := FindBackGround(control);
  	  if BK<>nil then
    	  BK.PaintCtrlBkGround(control,dc)
	    else  BitBlt(DC,0,0,control.ClientRect.Right, control.ClientRect.Bottom,0,0,0,Whiteness);
      // combine the Background and foreground
      StretchBltTransparent(DC,0,0,control.width,control.height,
        MemDC,0,0,control.width,control.height,0,
        color);
	  finally
      SelectObject(MemDC, OldBitmap);
      DeleteDC(MemDC);
      DeleteObject(MemBitmap);
      IgnoreMsg(TMessage(message));
     { if FreeDC then ReleaseDC(handle,Message.DC);
      ValidateRect(handle,nil);}
  	end;
  end;
end;

{ TTransparentMaker4 }
(*
procedure TTransparentMaker4.WMERASEBKGND(var Message: TWMERASEBKGND);
var
  BK : TBackGround;
begin
  BK := FindBackGround(control);
  if BK<>nil then
  begin
    bypass:=true;
    message.result:=1;
    setBKMode(message.DC,transparent);
  	selectObject(message.DC,BK.NULLBrush);
  end;
end;
*)
procedure TTransparentMaker4.WMPaint(var Message: TWMPaint);
var
  DC: HDC;
  AHandle : HWnd;
  BK : TBackGround;
begin
	  AHandle := handle;
    if AHandle=0 then exit;
    BK := FindBackGround(control);
    // clear the background for TreeView and ListView
    if message.dc=0 then DC := GetDC(Ahandle)
    else DC := message.dc;
    try
      if BK<>nil then
    	  BK.PaintCtrlBkGround(TWinControl(control),dc)
	    else  BitBlt(DC,0,0,control.ClientRect.Right, control.ClientRect.Bottom,0,0,0,Whiteness);
    finally
    	if message.dc=0 then releaseDC(AHandle,DC);
    end;
    // end clear the background}
    inherited;
end;

{ TTransparentMaker5 }

procedure TTransparentMaker5.WMPaint(var Message: TWMPaint);
var
  i : integer;
begin
  inherited;
 { Message.msg:=WM_Paint;
  (Control as TWinControl).Broadcast(Message);
  IgnoreMsg(Message);}
  with (control as TWinControl) do
  for i:=0 to controlCount-1 do
    if controls[i] is TWinControl then
      InvalidateRect((controls[i] as TWinControl).handle,nil,false);
end;

{ TContainerMsgFilter }
procedure TContainerMsgFilter.PreHandle(var Message: TMessage);
var
	BK : TBackGround;
begin
  BK := FindBackGround(control);
  // pass WM_CtrlColor and CM_ControlChange to The BackGround Object
  if (BK<>nil) then
  case message.Msg of
	  WM_CtlColorEdit,
    WM_CtlColorBtn,
    WM_CtlColorLISTBOX,
    WM_CtlColorScrollbar,
    WM_CtlColorStatic,
    CM_ControlChange :
  begin
    //bypass:=true;
    //BK.dispatch(message);
    with message do
	    result:=BK.perform(msg,WParam,LParam);
    IgnoreMsg(message);
  end;
  end;
end;

procedure TContainerMsgFilter.WMCommand(var msg: TWMCommand);
begin
  if FindControl(msg.Ctl)<>nil
    then invalidateRect(msg.Ctl,nil,false)
  	else invalidateRect(handle,nil,false);
  // then call the default by MsgFilter
end;

{
const
  CtrlInfo1 : TCtrlInfo
   = (ClassType :TGroupButton;		CtrlType :ciComplex1;				color : clBtnFace; HasChild : false);
}


{ TBackGroundMsgFilter }
(*
procedure TBackGroundMsgFilter.CMControlChange(var msg: TCMControlChange);
var
  CtrlType : TCtrlType;
  WinStyle : longWord;
  Ctrl : TControl;
begin
  Ctrl := Msg.control;
  //with msg do
  if msg.Inserting then
  begin
    if (ctrl is TBackGround) then exit;
    // for TLabel and so on
    ctrl.ControlStyle := ctrl.ControlStyle - [csOpaque];
    //SetOrdProperty(control,'Transparent',integer(true));

    if CtrlHasChild(ctrl) then
      hookMsgFilter(ctrl,TContainerMsgFilter);

    CtrlType := GetCtrlType(ctrl);

    if ctrl is TWinControl then
    begin
      if CtrlNeedClearBrush(ctrl) then
        (ctrl as TWinControl).brush.style := bsClear;

     { WinStyle := GetWindowLong((control as TWinControl).handle,GWL_STYLE);
      WinStyle := WinStyle and not WS_CLIPCHILDREN;
      SetWindowLong((control as TWinControl).handle,GWL_STYLE,WinStyle);
     }
  	  case CtrlType of
     // ciComplex1 : hookMsgFilter(control,TTransparentMaker2);
      ciComplex2,ciUnknown : hookMsgFilter(ctrl,TTransparentMaker1);
      ciComplex3 : hookMsgFilter(ctrl,TTransparentMaker5);
      ciComplex4 : hookMsgFilter(ctrl,TTransparentMaker4);
    	end;
    end
    else
    	if (ctrl is TGraphicControl)
        and (CtrlType<>ciSimple)
      then hookMsgFilter(ctrl,TTransparentMaker3);
  end
  //else UnhookMsgFilter(control);
end;
*)
function TBackGroundMsgFilter.GetBackGround: TBackGround;
begin
  result := TBackGround(control);
end;

procedure TBackGroundMsgFilter.WMCommand(var msg: TWMCommand);
begin
  if msg.NotifyCode=EN_Update then
     invalidateRect(msg.Ctl,nil,false);
end;

procedure TBackGroundMsgFilter.WMCtlColor(var Msg: TWMCtlColor);
var
  DC : HDC;
  CtrlType : TCtrlType;
begin
  {setBKMode(msg.ChildDC,transparent);
  msg.Result:= NULLBrush;}
  // if not find the wincontrol, treat it as ciComplex1
  // because CtrlType=ciUnknown
  ignoreMsg(msg);
  if GetWindowCtrlType(msg.ChildWnd,CtrlType) then
  begin
    if (CtrlType=ciComplex2) then
      begin
				invalidateRect(msg.childWnd,nil,false);
        exit;
      end;
  end;
  setBKMode(msg.ChildDC,transparent);
  msg.Result:= BACKGROUND.NULLBrush;
  if (CtrlType=ciComplex4)then
      begin
				invalidateRect(msg.childWnd,nil,false);
        exit;
      end;
  if CtrlType=ciSimple then exit;

  // CtrlType = ciComplex1
  // Is the window  painting ?
  if PaintingWindows.indexOf(Msg.ChildWnd)<0 then
  begin
    // if not in painting , do painting
    PaintingWindows.Add(Msg.ChildWnd);
    DC := GetDC(Msg.ChildWnd);
		  try
		    background.PaintWindowBkGround(Msg.ChildWnd,DC);
		    sendmessage(msg.ChildWnd,WM_Paint,DC,0);
		  finally
		    releaseDC(Msg.ChildWnd,DC);
        PaintingWindows.remove(Msg.ChildWnd);
		  end;
      cancelDC(msg.childDC);
  end;
end;

procedure TBackGroundMsgFilter.WMCtlColorBtn(var Msg: TWMCtlColor);
begin
  WMCtlColor(Msg);
end;

procedure TBackGroundMsgFilter.WMCtlColorEdit(var Msg: TWMCtlColor);
begin
  WMCtlColor(Msg);
end;

procedure TBackGroundMsgFilter.WMCtlColorLISTBOX(var Msg: TWMCtlColor);
begin
  if findControl(msg.childwnd)<>nil then WMCtlColor(Msg);
end;

procedure TBackGroundMsgFilter.WMCtlColorScrollbar(var Msg: TWMCtlColor);
begin
  WMCtlColor(Msg);
end;

procedure TBackGroundMsgFilter.WMCtlColorStatic(var Msg: TWMCtlColor);
begin
  WMCtlColor(Msg);
end;

initialization
  PaintingWindows := TNumberList.create;
  RegisterCtrls := TList.create;
 // RegisterCtrlInfo(@CtrlInfo1);
finalization
 // UnRegisterCtrlInfo(@CtrlInfo1);
  RegisterCtrls.free;
  PaintingWindows.free;
end.
