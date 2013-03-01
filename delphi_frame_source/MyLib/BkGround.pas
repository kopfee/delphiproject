unit BkGround;

{ %BkGround : 包含背景控件，使得其上的控件透明 }

(*****   Code Written By Huang YanLai   *****)

{ an debug program in \HuangYL\Mylib\BackGround
1)透明效果时的色彩失真.
  256 color : OK
  24bit color : 失真
solution :
  in TBackGround.PaintBKGround add:
  if not theBitmap.Monochrome then
     SetStretchBltMode(DC, STRETCH_DELETESCANS);

2)透明背景上面的TWinControl 没有画出来.
 in TBackGround.PictureChange
 change
   repaint
 to
   invalidate
}

{ 	ciSimple 	: On CtrlColor event set BKMode and the NULL brush
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
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,extctrls,
  ComWriUtils,ComCtrls,StdCtrls,Buttons,CheckLst,Mask,DBCtrls;

type
  TBackGround = class;

  TFilterControlEvent = procedure(sender : TBackGround;
    control : TControl; var TransparentIt : boolean) of object;

  TBackGround = class(TCustomControl)
  private
    { Private declarations }
    FPicture	: TPicture;
    NULLBrush : HBrush;
    FTransparent: boolean;
    FOnFilterControl: TFilterControlEvent;
    FTiled: boolean;
    FTempCanvas : TCanvas;
    procedure SetPicture(const Value: TPicture);
    function 	GetPicture: TPicture;
   	procedure CMControlChange(var msg:TCMControlChange); message CM_CONTROLCHANGE;
    procedure BrushChange(sender:TObject);
    procedure PictureChange(sender:TObject);
    procedure SetTransparent(const Value: boolean);
    procedure EnableTransmaker(ctrl : TControl;Transparent : boolean);
    function  NeedTransparent(control:TControl):boolean;
    procedure SetTiled(const Value: boolean);
    // new add to optimize
    procedure WMERASEBKGND(var Message:TMessage); message WM_ERASEBKGND;
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
    Property Tiled : boolean read FTiled write SetTiled default false;
    property Picture : TPicture read GetPicture write SetPicture;
    property Transparent : boolean read FTransparent write SetTransparent;
    property OnFilterControl : TFilterControlEvent
      read FOnFilterControl write FOnFilterControl;
    property Align;
    property Anchors;
    property Color;
    //property Brush;
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
    procedure WMERASEBKGND(var Message:TWMERASEBKGND); message WM_ERASEBKGND;
    procedure WMVScroll(var message : TWMScroll);message WM_VScroll;
    procedure WMHScroll(var message : TWMScroll);message WM_HScroll;
    procedure WMScroll(var message : TWMScroll);
  end;
  {
  // for ciComplex1
  TTransparentMaker2 = class(TMsgFilter)
  private
    painting : boolean;
    //procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMERASEBKGND(var Message:TWMERASEBKGND); message WM_ERASEBKGND;
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
  // for RadioGroup and Panels to resolve invisible problum
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
    function	PreHandle(var Message: TMessage) : boolean ;override;
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
procedure RegisterNotTransparentControlClass(AClass : TClass);

implementation

uses DrawUtils,TypUtils,ConvertUtils, {NewComCtrls,} JPEG;


const
  CtrlNum = 22-3-1;
  CtrlInfos : array [0..CtrlNum-1] of TCtrlInfo
 = ( (ClassType :TCustomLabel;		CtrlType :ciSimple;				color : clBtnFace; HasChild : false
 				;NeedClearBrush : false),
 		 (ClassType :TCustomRichEdit;	CtrlType :ciComplex2;	color : clWhite; 	 HasChild : false;NeedClearBrush : false),
     //(ClassType :TCustomRichEdit2;	CtrlType :ciComplex2;	color : clWhite; 	 HasChild : false;NeedClearBrush : false),
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
     (ClassType :TScrollBox;CtrlType :{ciSimple;}ciComplex2;							color : clBtnFace; HasChild : true;NeedClearBrush : false),
     (ClassType :TCustomStaticText;CtrlType :ciComplex1{ciSimple};			color : clBtnFace; HasChild : false;NeedClearBrush : false),
     //(ClassType :TCustomMaskEdit;	CtrlType :ciSimple;				color : clWhite),
     (ClassType :TCustomTreeView;	CtrlType :ciComplex4;	color : clWhite; HasChild : false;NeedClearBrush : false),
     (ClassType :TCustomListView;	CtrlType :ciComplex4;	color : clWhite; HasChild : false;NeedClearBrush : false),
     (ClassType :TSpeedButton;		CtrlType :ciComplex1;				color : clBtnFace; HasChild : false;NeedClearBrush : false),
     (ClassType :TCustomComboBox;	CtrlType :ciSimple;	color : clWhite; HasChild : true;NeedClearBrush : false) );

  defaultColor = clWhite;

var
  RegisterCtrls : TList;
  NotTransparentControls : TList;

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

procedure RegisterNotTransparentControlClass(AClass : TClass);
begin
  NotTransparentControls.Add(pointer(AClass));
end;

var
  PaintingWindows : TNumberList;

{ TBackGround }

procedure TBackGround.BrushChange(sender: TObject);
begin
  if not (picture.graphic is TBitmap) then //repaint;
    invalidate;
end;

procedure TBackGround.CMControlChange(var msg: TCMControlChange);
var
  CtrlType : TCtrlType;
//  WinStyle : longWord;
  winstyle : integer;
begin
  with msg do
  begin
  //if (control is TBackGround) then exit;
  if not NeedTransparent(control) then
  	exit;
  if Inserting then
  begin
    //if (control is TBackGround) then exit;
    // for TLabel and so on
    if Control is TLabel then
	    Control.ControlStyle := control.ControlStyle - [csOpaque];
    // resolve the problem with SpeedButton flat style
    if Control is TSpeedButton then
    	(Control as TSpeedButton).transparent := false;
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
      // enable for 10/09-1
      //ciComplex1 : hookMsgFilter(control,TTransparentMaker2);
      ciComplex2,ciUnknown : hookMsgFilter(control,TTransparentMaker1);
      ciComplex3 : hookMsgFilter(control,TTransparentMaker5);
      ciComplex4 : hookMsgFilter(control,TTransparentMaker4);
    	end;
    end
    else
    	if (control is TGraphicControl)
        and (CtrlType<>ciSimple)
      then hookMsgFilter(control,TTransparentMaker3);
    EnableMsgFilter(control,self.FTransparent,TTransparentMaker);

    //new add
    if control is TScrollingWinControl then
    with control as TWincontrol do
    begin
      winstyle := GetWindowLong(handle,GWL_STYLE);
			winstyle := winstyle or WS_CLIPCHILDREN;
      SetWindowLong(handle,GWL_STYLE,winstyle);
    end;
  end // end if insert
  //else UnhookMsgFilter(control);
  // begin add release
  else
  begin
    UnHookMsgFilter(control,TTransparentMaker);
    UnHookMsgFilter(control,TContainerMsgFilter);
  end; // end if insert else
  // end add release
  end; // with
end;

constructor TBackGround.Create(AOwner: TComponent);
{var
  LogBrush : TLogBrush;}
begin
  inherited Create(AOwner);
  width := 100;
  height := 100;
  ControlStyle := ControlStyle + [csAcceptsControls];
  FPicture := TPicture.Create;
  FPicture.OnChange := PictureChange;
  NULLBrush := GetStockObject(NULL_BRUSH);
  Brush.OnChange := BrushChange;
  HookMsgFilter(self,TBackGroundMsgFilter);
  FTransparent := true;

  FTiled := false;
  FTempCanvas := TCanvas.Create;
end;

procedure TBackGround.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.style := Params.style and not WS_CLIPCHILDREN;
  { if set WS_CLIPCHILDREN : there are  problems
  	1)when set transparent is false, then drag them.
    2)when picture changed, foreground win-controls
    do not change their backgrounds.
  }
end;

destructor TBackGround.Destroy;
begin
  FTempCanvas.free;
  FPicture.free;
  inherited destroy;
end;

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

function TBackGround.NeedTransparent(control:TControl): boolean;
var
  i : integer;
  {$ifdef debug}
  s : string;
  {$endif}
begin
  result := not (control is TBackGround);
  if result then
    for i:=0 to NotTransparentControls.count-1 do
      if control is TClass(NotTransparentControls[i]) then
      begin
        result := false;
        //exit;
        break;
      end;
  if result and Assigned(FOnFilterControl) then
    FOnFilterControl(self,control,result);
  {$ifdef debug}
  s := 'BK:'+IntToHex(integer(self),8)+':'
    +'CTRL:'+control.ClassName+':'
    +'Need:'+BoolToStr(result)+':'
    +'Trans:'+BoolToStr(self.FTransparent);
  OutputDebugString(pchar(s));
  {$endif}
end;
{
procedure TBackGround.Paint;
begin
  if (FPicture.graphic is TBitmap)
  	or (FPicture.graphic is TJpegImage) then
		 Canvas.StretchDraw(clientRect,FPicture.graphic)
  else
  begin
    canvas.Brush := brush;
    Canvas.FillRect(clientRect);
  end;
end;
}
procedure TBackGround.Paint;
begin
	with FPicture do
		if (graphic<>nil) and (graphic.width>0) and (graphic.height>0) then
    	if Tiled then
        TileDraw(Canvas,graphic,ClientWidth,ClientHeight)
      else if (graphic is TBitmap)
	  			or (FPicture.graphic is TJpegImage) then
						Canvas.StretchDraw(clientRect,FPicture.graphic)
        else
        	TileDraw(Canvas,graphic,ClientWidth,ClientHeight)
	  else // no graph
  	begin
    	canvas.Brush := brush;
	    Canvas.FillRect(clientRect);
  	end;
end;
{
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
}

type
	TJpegImageAccess = class(TJpegImage);

procedure TBackGround.PaintBKGround(DC: HDC; x, y, W, H: integer);
var
  sx,sy,sw,sh : integer;
  XRate,YRate : real;
  oldPalette : HPalette;
  theBitmap : TBitmap;
  {// new add
  DoHalftone: Boolean;
  Pt: TPoint;
  BPP: Integer;}
begin
  if (width=0) or (height=0) then exit;
  if FTiled and (picture.Graphic<>nil) then
  begin
    FTempCanvas.handle := DC;
    try
      TileDrawEx(FTempCanvas,
        picture.Graphic,
        x,y,w,h,
        x,y);
    finally
      FTempCanvas.handle := 0;
    end;
  end
  else // not tiled
  begin
    if (picture.Graphic is TBitmap) then
       theBitmap:=TBitmap(picture.Graphic)
    else if (picture.Graphic is TJpegImage) then
       theBitmap := TJpegImageAccess(picture.Graphic).bitmap
    else theBitmap := nil;

    if theBitmap<>nil then
    begin
    	XRate := theBitmap.Width / width;
	    YRate := theBitmap.Height/ Height;
    	sx := round(x*XRate);
	    sy := round(y*YRate);
  	  sW := round(w*XRate);
  	  sH := round(h*YRate);
      {SelectPalette(DC,theBitmap.Palette,true);
       in 256 color device system:
       the last param value  foreground , background
          true                  medium      medium
          false                  GOOD       bad
       conclusion :
          I choice true
      }
    	oldPalette:=SelectPalette(DC,theBitmap.Palette,true);
  	  try
    	  RealizePalette(DC);

        {BPP := GetDeviceCaps(DC, BITSPIXEL) *
        GetDeviceCaps(DC, PLANES);
        DoHalftone := false;
        DoHalftone := (BPP <= 8) ;//and (BPP < (FDIB.dsbm.bmBitsPixel * FDIB.dsbm.bmPlanes));
        if DoHalftone then
        begin
          GetBrushOrgEx(DC, pt);
          SetStretchBltMode(DC, HALFTONE);
          SetBrushOrgEx(DC, pt.x, pt.y, @pt);
        end else }if not theBitmap.Monochrome then
          SetStretchBltMode(DC, STRETCH_DELETESCANS);

  	    StretchBlt(DC,0,0,w,h,theBitmap.canvas.handle,sx,sy,sw,sh,SRCCOPY);
    	finally
      	SelectPalette(DC,OldPalette,true);
    	end;
    end
    else // no Bitmap
    begin
      FillRect(DC,rect(0,0,w,h),brush.Handle);
    end;
  end;
end;

procedure TBackGround.PaintCtrlBkGround(WinCtrl: TControl; DC: HDC);
var
  origin : TPoint;
begin
  origin.x := 0;
  origin.y := 0;
  origin:=WinCtrl.ClientToScreen(origin);
  origin:=ScreenToClient(origin);
  PaintBKGround(DC,origin.x,origin.y,WinCtrl.ClientWidth,WinCtrl.ClientHeight);
end;

procedure TBackGround.PaintWindowBkGround(Win: HWnd; DC: HDC);
var
  origin : TPoint;
  rect : TRect;
begin
  origin.x := 0;
  origin.y := 0;
  windows.ClientToScreen(Win,origin);
  origin:=ScreenToClient(origin);
  windows.GetClientRect(win,rect);
  PaintBKGround(DC,origin.x,origin.y,rect.right,rect.Bottom);
end;

procedure TBackGround.PictureChange(sender: TObject);
begin
  { Do not use 'repaint', otherwise it will bring about an error:
  when Picture Changed, the background overlaped the foreground win-controls.
  repaint;
  }
  invalidate;
end;

procedure TBackGround.SetPicture(const Value: TPicture);
begin
  FPicture.assign(Value);
end;

procedure TBackGround.SetTiled(const Value: boolean);
begin
  if FTiled<>Value then
  begin
		FTiled := Value;
    Invalidate;
  end;
end;

procedure TBackGround.SetTransparent(const Value: boolean);
begin
  if (FTransparent <> Value)  then
  begin
    FTransparent := Value;
    EnableMsgFilter(self,FTransparent,TBackGroundMsgFilter);
    EnableTransmaker(self,FTransparent);
    //repaint;
    if not (csLoading in componentState)
      and (parent<>nil) then
    begin
      InvalidateRect(handle,nil,false);
      UpdateWindow(handle);
    end;
  end;
end;

procedure TBackGround.WMERASEBKGND(var Message: TMessage);
begin
  message.result := 1;
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

procedure TTransparentMaker1.WMERASEBKGND(var Message: TWMERASEBKGND);
begin
  inherited;
  //message.result := 1;
  {//
  IgnoreMsg(message);
  //inherited ;
  }
end;

procedure TTransparentMaker1.WMHScroll(var message: TWMScroll);
begin
	inherited;
  WMScroll(message);
end;

procedure TTransparentMaker1.WMVScroll(var message: TWMScroll);
begin
	inherited;
  WMScroll(message);
end;

procedure TTransparentMaker1.WMScroll(var message: TWMScroll);
begin
  Control.Invalidate;
end;

procedure TTransparentMaker1.WMPaint(var Message: TWMPaint);
var
  DC, MemDC: HDC;
  MemBitmap, OldBitmap: HBITMAP;
  AHandle : HWnd;
  color : TColor;
  BK : TBackGround;
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
	  if message.dc=0 then DC := GetDC(Ahandle)
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
        TColorRef(color));
      {StretchBltTransparent(DC,0,0,control.Clientwidth,control.Clientheight,
        MemDC,0,0,control.width,control.height,0,
        color);}
	  finally
      if message.dc=0 then releaseDC(AHandle,DC);
      ValidateRect(AHandle,nil);
      SelectObject(MemDC, OldBitmap);
      DeleteDC(MemDC);
      DeleteObject(MemBitmap);
      //IgnoreMsg(TMessage(message));
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
        TColorRef(color));
	  finally
      SelectObject(MemDC, OldBitmap);
      DeleteDC(MemDC);
      DeleteObject(MemBitmap);
      //IgnoreMsg(TMessage(message));
     { if FreeDC then ReleaseDC(handle,Message.DC);
      ValidateRect(handle,nil);}
  	end;
  end;
end;

{ TTransparentMaker4 }

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
  with (control as TWinControl) do
  for i:=0 to controlCount-1 do
    if controls[i] is TWinControl then
      InvalidateRect((controls[i] as TWinControl).handle,nil,false);
end;

{ TContainerMsgFilter }
function	TContainerMsgFilter.PreHandle(var Message: TMessage) : boolean ;
var
	BK : TBackGround;
begin
  result := inherited PreHandle(Message);
  BK := FindBackGround(control);
  // pass WM_CtrlColor and CM_ControlChange to The BackGround Object
  if (BK<>nil) then
  case message.Msg of
	  WM_CtlColorEdit,
    WM_CtlColorBtn,
    WM_CtlColorLISTBOX,
    WM_CtlColorScrollbar,
    WM_CtlColorStatic :
    //CM_ControlChange :
  begin
    with message do
	    result:=BK.perform(msg,WParam,LParam);
    result := false;
  end;
    CM_ControlChange :
  begin
    with message do
	    result:=BK.perform(msg,WParam,LParam);
    	//IgnoreMsg(message);
  end;
  end;
end;

procedure TContainerMsgFilter.WMCommand(var msg: TWMCommand);
begin
  inherited; 
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

function TBackGroundMsgFilter.GetBackGround: TBackGround;
begin
  result := TBackGround(control);
end;

procedure TBackGroundMsgFilter.WMCommand(var msg: TWMCommand);
begin
  {* old }
  inherited;
  if msg.NotifyCode=EN_Update then
     invalidateRect(msg.Ctl,nil,false);
  {* new 10/09.1}
 { if (msg.NotifyCode=EN_Update)
    //or (msg.NotifyCode=EN_VSCROLL)
    //or (msg.NotifyCode=EN_HSCROLL)
   then
     invalidateRect(msg.Ctl,nil,false);}
end;

procedure TBackGroundMsgFilter.WMCtlColor(var Msg: TWMCtlColor);
var
  DC : HDC;
  CtrlType : TCtrlType;
begin
  { must call defaultHandler to display the proper color of memo.
  }
  DefaultHandler(msg);
  {setBKMode(msg.ChildDC,transparent);
  msg.Result:= NULLBrush;}
  // if not find the wincontrol, treat it as ciComplex1
  // because CtrlType=ciUnknown
  //ignoreMsg(msg);
  if GetWindowCtrlType(msg.ChildWnd,CtrlType) then
  begin
    if (CtrlType=ciComplex2) then
      begin
        // repaint for buttons.
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
  { disable for 10/09.1}
  // CtrlType = ciComplex1
  // Is the window  painting ?
  //if CtrlType<>ciComplex1 then exit; // new add.
  { treat ciUnknown as ciComplex1 to
    resolve comboxbox's edit box paint.
  }
  if PaintingWindows.indexOf(Msg.ChildWnd)<0 then
  begin
    // if not in painting , do painting
    PaintingWindows.Add(Msg.ChildWnd);
    DC := GetDC(Msg.ChildWnd);
		  try
		    background.PaintWindowBkGround(Msg.ChildWnd,DC);
        //invalidateRect(msg.childWnd,nil,false);
		    sendmessage(msg.ChildWnd,WM_Paint,DC,0);
		  finally
		    releaseDC(Msg.ChildWnd,DC);
        PaintingWindows.remove(Msg.ChildWnd);
		  end;
      //cancelDC(msg.childDC);
      // new add.
      //ValidateRect(Msg.ChildWnd,nil);
  end;
  //}
end;

procedure TBackGroundMsgFilter.WMCtlColorBtn(var Msg: TWMCtlColor);
begin
  WMCtlColor(Msg);
end;

procedure TBackGroundMsgFilter.WMCtlColorEdit(var Msg: TWMCtlColor);
begin
  WMCtlColor(Msg);
end;

// resolve the problum with ComboBox
procedure TBackGroundMsgFilter.WMCtlColorLISTBOX(var Msg: TWMCtlColor);
begin
  if findControl(msg.childwnd)<>nil then
  	WMCtlColor(Msg)
  else inherited;  
end;

procedure TBackGroundMsgFilter.WMCtlColorScrollbar(var Msg: TWMCtlColor);
begin
  WMCtlColor(Msg);
end;

procedure TBackGroundMsgFilter.WMCtlColorStatic(var Msg: TWMCtlColor);
begin
  WMCtlColor(Msg);
end;

{ TTransparentMaker2 }
{
procedure TTransparentMaker2.WMERASEBKGND(var Message: TWMERASEBKGND);
var
  BK : TBackGround;
  controlname : string;
begin
  message.result := 1;
  controlname := control.name;
  BK := FindBackGround(control);
  BK.PaintWindowBkGround(
    TWinControl(Control).handle,
    message.DC);
end;
}


initialization
  PaintingWindows := TNumberList.create;
  RegisterCtrls := TList.create;
  NotTransparentControls := TList.create;
 // RegisterCtrlInfo(@CtrlInfo1);
  RegisterNotTransparentControlClass(TImage);
  RegisterNotTransparentControlClass(TBevel);
  RegisterNotTransparentControlClass(TShape);
finalization
 // UnRegisterCtrlInfo(@CtrlInfo1);
  NotTransparentControls.free;
  RegisterCtrls.free;
  PaintingWindows.free;
end.
