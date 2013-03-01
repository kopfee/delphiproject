unit BkGround2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,extctrls,
  ComWriUtils,ComCtrls,StdCtrls,Buttons,Mask;

type
  TBackGround = class(TCustomControl)
  private
    FImage : TImage;
    //FSwitch : boolean;
    FBrush : HBrush;
    procedure SetPicture(const Value: TPicture);
    function GetPicture: TPicture;
    procedure WMCtlColor(var Msg : TWMCtlColor);
    procedure WMCtlColorEdit(var Msg : TWMCtlColor);message WM_CtlColorEdit;
    procedure WMCtlColorBtn(var Msg : TWMCtlColor);message WM_CtlColorBtn;
    procedure WMCtlColorLISTBOX(var Msg : TWMCtlColor);message WM_CtlColorLISTBOX;
    procedure WMCtlColorScrollbar(var Msg : TWMCtlColor);message WM_CtlColorScrollbar;
    procedure WMCtlColorStatic(var Msg : TWMCtlColor);message WM_CtlColorStatic;
    procedure WMCommand(var msg : TWMCommand); message WM_Command;
    { Private declarations }
    procedure CMControlChange(var msg:TCMControlChange); message CM_CONTROLCHANGE;
  protected
    { Protected declarations }
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    constructor Create(AOwner:TComponent);override;
    destructor  Destroy; override;
    procedure 	PaintCtrlBkGround(WinCtrl:TWinControl;DC:HDC);
  published
    { Published declarations }
    property Picture : TPicture read GetPicture write SetPicture;

    property Align;
    property Anchors;
    property Color;
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

  TTransparentMaker = class(TMsgFilter)
  private
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  end;

  TContainerMsgFilter = class(TMsgFilter)
  private
   // procedure CMControlChange(var msg:TCMControlChange); message CM_CONTROLCHANGE;
    procedure WMCommand(var msg : TWMCommand); message WM_Command;
  protected
    procedure PreHandle(var Message: TMessage); override;
  end;

//  procedure TransPaintTheWindow(AHandle : HWnd; BK : TBackGround; color : TColor);

procedure Register;

implementation

uses DrawUtils,TypUtils;

procedure Register;
begin
  RegisterComponents('users', [TBackGround]);
end;

type
  TCtrlType = (ciSimple,ciComplex,ciMostComplex,ciUnknown);

type
  TCtrlInfo = record
    ClassType : TClass;
    CtrlType : TCtrlType;
    color : TColor;
    HasChild : boolean;
  end;

const
  CtrlNum = 19-4;
  CtrlInfos : array [0..CtrlNum-1] of TCtrlInfo
 = ( (ClassType :TCustomLabel;		CtrlType :ciSimple;				color : clBtnFace; HasChild : false),
 		 (ClassType :TCustomRichEdit;	CtrlType :ciMostComplex;	color : clWhite; 	 HasChild : false),
     //(ClassType :TCustomMemo;			CtrlType :ciComplex;			color : clWhite),
 		 (ClassType :TCustomEdit;			CtrlType :ciComplex;			color : clWhite; HasChild : false),
     //(ClassType :TBitBtn;		CtrlType :ciMostComplex;				color : clBtnFace),
     (ClassType :TButton;					CtrlType :ciMostComplex;	color : clBtnFace; HasChild : false),
     (ClassType :TRadioButton;		CtrlType :ciSimple;				color : clBtnFace; HasChild : false),
     (ClassType :TCustomCheckBox;	CtrlType :ciSimple;				color : clBtnFace; HasChild : false),
     (ClassType :TCustomListBox;	CtrlType :ciComplex;			color : clWhite; HasChild : false),
     (ClassType :TCustomPanel;		CtrlType :cimostComplex;	color : clBtnFace; HasChild : true),
     //(ClassType :TCustomRadioGroup;CtrlType :cimostComplex;	color : clBtnFace),
     (ClassType :TCustomGroupBox;	CtrlType :cimostComplex;	color : clBtnFace; HasChild : true),
     (ClassType :TScrollBox;CtrlType :ciSimple;							color : clBtnFace; HasChild : true),
     (ClassType :TCustomStaticText;CtrlType :ciSimple;			color : clBtnFace; HasChild : false),
     //(ClassType :TCustomMaskEdit;	CtrlType :ciSimple;				color : clWhite),
     (ClassType :TCustomTreeView;	CtrlType :ciMostComplex;	color : clWhite; HasChild : false),
     (ClassType :TCustomListView;	CtrlType :ciMostComplex;	color : clWhite; HasChild : false),
     (ClassType :TSpeedButton;		CtrlType :ciSimple;				color : clWhite; HasChild : false),
     (ClassType :TCustomComboBox;	CtrlType :ciMostComplex;	color : clWhite; HasChild : true) );

  defaultColor = clWhite;

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
  for i:=0 to CtrlNum-1 do
    if control is CtrlInfos[i].ClassType then
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

{ TBackGround }

procedure TBackGround.CMControlChange(var msg: TCMControlChange);
var
  CtrlType : TCtrlType;
begin
  with msg do
  if Inserting then
  begin
    Control.ControlStyle := control.ControlStyle - [csOpaque];
    //if csAcceptsControls in control.controlstyle then
    if CtrlHasChild(Control) then
      hookMsgFilter(control,TContainerMsgFilter);
    if control is TWinControl then
    begin
      (control as TWinControl).brush.style := bsClear;
    end;
    CtrlType := GetCtrlType(control);
    case CtrlType of
    //  ciComplex : hookMsgFilter(control,TTransparentMaker);
      ciMostComplex,ciUnknown : hookMsgFilter(control,TTransparentMaker);
    end;
  end
  //else UnhookMsgFilter(control);
end;

constructor TBackGround.Create(AOwner: TComponent);
var
  LogBrush : TLogBrush;
begin
  inherited Create(AOwner);
  width := 100;
  height := 100;
  ControlStyle := ControlStyle + [csAcceptsControls];
  FImage:=TImage.Create(self);
  FImage.align:=alClient;
  insertControl(FImage);
  LogBrush.lbStyle := BS_NULL;
  FBrush := CreateBrushIndirect(LogBrush);
  //Brush.Handle := FBrush;
  Brush.style := bsClear;
end;

procedure TBackGround.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.style := Params.style and not WS_CLIPCHILDREN;
end;

destructor TBackGround.Destroy;
begin
  FImage.free;
  inherited destroy;
end;

function TBackGround.GetPicture: TPicture;
begin
  result := FImage.Picture;
end;

procedure TBackGround.PaintCtrlBkGround(WinCtrl: TWinControl; DC: HDC);
var
  oldPalette : HPalette;
  origin : TPoint;
begin
  origin.x := 0;//WinCtrl.left;
  origin.y := 0;//WinCtrl.top;
  origin:=WinCtrl.ClientToScreen(origin);
  origin:=ScreenToClient(origin);
  oldPalette:=SelectPalette(DC,FImage.picture.bitmap.Palette,true);
  try
    RealizePalette(DC);
		BitBlt(DC,0,0,WinCtrl.ClientWidth,WinCtrl.ClientHeight,
    	FImage.picture.bitmap.canvas.handle,origin.x,origin.y,SRCCOPY);
  finally
    SelectPalette(DC,OldPalette,false);
  end;
end;

procedure TBackGround.SetPicture(const Value: TPicture);
begin
  FImage.Picture.assign(Value);
end;

procedure TBackGround.WMCommand(var msg: TWMCommand);
begin
  inherited;
  invalidateRect(msg.Ctl,nil,false);
  {if msg.NotifyCode=EN_Update then
     invalidateRect(msg.Ctl,nil,false);}
end;

procedure TBackGround.WMCtlColor(var Msg: TWMCtlColor);
var
  DC : HDC;
  WinCtrl : TWinControl;
begin
  setBKMode(msg.ChildDC,transparent);
  msg.Result:= FBrush;
  WinCtrl:=FindControl(Msg.ChildWnd);
  if (winCtrl<>nil) and not (csPaintCopy in winCtrl.controlstate)then
  begin
    if GetCtrlType(winCtrl)<>ciComplex then exit;
    winCtrl.controlstate := winCtrl.controlstate + [csPaintCopy];
    if winCtrl<>nil then
    begin
      DC := GetDC(Msg.ChildWnd);
		  try
		    PaintCtrlBkGround(WinCtrl,DC);
		    WinCtrl.perform(WM_Paint,DC,0);
		  finally
        winCtrl.controlstate := winCtrl.controlstate - [csPaintCopy];
		    releaseDC(Msg.ChildWnd,DC);
		  end;
      cancelDC(msg.childDC);
    end;
  end;
  //inherited;
end;

procedure TBackGround.WMCtlColorBtn(var Msg: TWMCtlColor);
begin
  WMCtlColor(Msg);
end;

procedure TBackGround.WMCtlColorEdit(var Msg: TWMCtlColor);
begin
  WMCtlColor(Msg);
end;

procedure TBackGround.WMCtlColorLISTBOX(var Msg: TWMCtlColor);
var
  Ctrl : TWinControl;
begin
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

{ TTransparentMaker }

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

(*
procedure TransPaintTheWindow(AHandle : HWnd; BK : TBackGround;Color : TColor);
var
  DC, MemDC: HDC;
  MemBitmap, OldBitmap: HBITMAP;
  AHandle : HWnd;
  BK : TBackGround;
begin
  if AHandle=0 then exit;
	MemBitmap :=0;
  MemDC := 0;
	OldBitmap :=0;
	invalidaterect(AHandle,nil,false);
  defaultHandler(Message);
	DC := GetDC(Ahandle);
	  try
		  MemBitmap := CreateCompatibleBitmap(DC, control.ClientRect.Right, control.ClientRect.Bottom);
    	MemDC := CreateCompatibleDC(0);
	    OldBitmap := SelectObject(MemDC, MemBitmap);
      // copy DC to MemDC
      BitBlt(MemDC,0,0,control.ClientRect.Right, control.ClientRect.Bottom,DC,0,0,SRCCOPY);
      // paint background to DC

     { if control.parent is TBackGround then
        (control.parent as TBackGround).PaintCtrlBkGround(TWinControl(control),dc)
      else BitBlt(DC,0,0,control.ClientRect.Right, control.ClientRect.Bottom,0,0,0,Whiteness);}
     BK := FindBackGround(control);
     if BK<>nil then
       BK.PaintCtrlBkGround(TWinControl(control),dc)
     else  BitBlt(DC,0,0,control.ClientRect.Right, control.ClientRect.Bottom,0,0,0,Whiteness);
     { // for test
      //BitBlt(TestCanvas.handle,x1,y2,width,height,BGBitmap.Canvas.handle,0,0,SRCCOPY);
      BitBlt(TestCanvas.handle,x1,y1,width,height,DC,0,0,SRCCOPY);
      BitBlt(TestCanvas.handle,x2,y2,width,height,MemDC,0,0,SRCCOPY);
      // end test}

      StretchBltTransparent(DC,0,0,control.width,control.height,
        MemDC,0,0,control.width,control.height,0,
        color);
      ValidateRect(AHandle,nil);
	  finally
      releaseDC(AHandle,DC);
      SelectObject(MemDC, OldBitmap);
      DeleteDC(MemDC);
      DeleteObject(MemBitmap);
  	end;
end;
*)
procedure TTransparentMaker.WMPaint(var Message: TWMPaint);
var
  DC, MemDC: HDC;
  MemBitmap, OldBitmap: HBITMAP;
  AHandle : HWnd;
  color : TColor;
  BK : TBackGround;
begin
    AHandle := handle;
    if AHandle=0 then exit;
    bypass:=true;
    color := GetCtrlColor(Control);
		MemBitmap :=0;
  	MemDC := 0;
	  OldBitmap :=0;
	  invalidaterect(AHandle,nil,false);
  	defaultHandler(Message);
	  DC := GetDC(Ahandle);
	  try
		  MemBitmap := CreateCompatibleBitmap(DC, control.ClientRect.Right, control.ClientRect.Bottom);
    	MemDC := CreateCompatibleDC(0);
	    OldBitmap := SelectObject(MemDC, MemBitmap);
      // copy DC to MemDC
      BitBlt(MemDC,0,0,control.ClientRect.Right, control.ClientRect.Bottom,DC,0,0,SRCCOPY);
      // paint background to DC
     BK := FindBackGround(control);
     if BK<>nil then
       BK.PaintCtrlBkGround(TWinControl(control),dc)
     else  BitBlt(DC,0,0,control.ClientRect.Right, control.ClientRect.Bottom,0,0,0,Whiteness);

      StretchBltTransparent(DC,0,0,control.width,control.height,
        MemDC,0,0,control.width,control.height,0,
        color);
      ValidateRect(AHandle,nil);
	  finally
      releaseDC(AHandle,DC);
      SelectObject(MemDC, OldBitmap);
      DeleteDC(MemDC);
      DeleteObject(MemBitmap);
  	end;
end;

{ TContainerMsgFilter }
(*
procedure TContainerMsgFilter.CMControlChange(var msg: TCMControlChange);
var
	BK : TBackGround;
begin
  bypass := true;
  BK := FindBackGround(control);
  if (BK<>nil) then BK.dispatch(msg);
end;
*)
procedure TContainerMsgFilter.PreHandle(var Message: TMessage);
var
	BK : TBackGround;
begin
  BK := FindBackGround(control);
  if (BK<>nil) then
  case message.Msg of
	  WM_CtlColorEdit,
    WM_CtlColorBtn,
    WM_CtlColorLISTBOX,
    WM_CtlColorScrollbar,
    WM_CtlColorStatic,
   // WM_Command,
    CM_ControlChange :
  begin
    bypass:=true;
    BK.dispatch(message);
    //BK.WMCtlColor(TWMCtlColor(Message));
  end;
  end;
end;


procedure TContainerMsgFilter.WMCommand(var msg: TWMCommand);
{var
	BK : TBackGround;}
begin
  if FindControl(msg.Ctl)<>nil
    then invalidateRect(msg.Ctl,nil,false)
  	else invalidateRect(handle,nil,false);
end;

end.
