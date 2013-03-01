unit CoolCtrls;

// %CoolCtrls : 具有特殊外观的Label,Button
(*****   Code Written By Huang YanLai   *****)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs,StdCtrls,ComCtrls,
  Buttons,ImgList,AppearUtils,LibMessages,ComWriUtils,
  ExtCtrls,AbilityManager;

const
  LM_ButtonDown = LM_BASE + 50;

type
  // %TCoolLabel : 对Lable扩充，具有位图
  TCoolLabel = class(TCustomLabel)
  private
    { Private declarations }
    FAppearances: TAppearances;
    FDisabledLook: integer;
    FMouseOverLook: integer;
    FNormalLook: integer;
    FIsMouseOver : boolean;
    FImageIndex: integer;
    FMargin:    Integer;
    FSpacing:   Integer;
    FLayout:    TButtonLayout;
    FShadowed:  boolean;
    FShadowColor: TColor;
    FShadowXIns: Integer;
    FShadowYIns: Integer;
    procedure   CMMouseEnter(var message : TMessage);message CM_MouseEnter;
    procedure   CMMouseLeave(var message : TMessage);message CM_MouseLeave;
    procedure   SetAppearances(const Value: TAppearances);
    procedure   SetDisabledLook(const Value: integer);
    procedure   SetMouseOverLook(const Value: integer);
    procedure   SetNormalLook(const Value: integer);
    procedure   LookChanged;
    procedure   LMAppearChanged(var message : TMessage);message LM_AppearChanged;
    procedure   SetImageIndex(const Value: integer);
    procedure   SetLayout(const Value: TButtonLayout);
    procedure   SetMargin(const Value: Integer);
    procedure   SetSpacing(const Value: Integer);
    procedure   SetShadowColor(const Value: TColor);
    procedure   SetShadowed(const Value: boolean);
    procedure   SetShadowXIns(const Value: Integer);
    procedure   SetShadowYIns(const Value: Integer);
  protected
    { Protected declarations }
    procedure   Notification(AComponent: TComponent;
                  Operation: TOperation); override;
    procedure   Paint; override;
    procedure   DrawText(TextBounds : TRect;BiDiFlags: LongInt);
    //procedure   DoDrawText(var Rect: TRect; Flags: Longint); override;
    procedure   SetDrawFont(index : integer);
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
  published
    { Published declarations }
    property    Appearances : TAppearances
                  read FAppearances write SetAppearances;
    property    DisabledLook : integer
                  read FDisabledLook write SetDisabledLook default -1;
    property    MouseOverLook : integer
                  read FMouseOverLook write SetMouseOverLook default -1;
    property    NormalLook : integer
                  read FNormalLook write SetNormalLook default -1;
    property    ImageIndex : integer
                  read FImageIndex write SetImageIndex default -1;
    property    Layout: TButtonLayout
                  read FLayout write SetLayout default blGlyphLeft;
    property    Margin: Integer
                  read FMargin write SetMargin default 0;
    property    Spacing: Integer
                  read FSpacing write SetSpacing default 4;
    property    Shadowed : boolean
                  read FShadowed write SetShadowed default false;
    property    ShadowColor : TColor
                  read FShadowColor write SetShadowColor default clBtnShadow;
    property    ShadowXIns : Integer
                  read FShadowXIns write SetShadowXIns default 1;
    property    ShadowYIns : Integer
                  read FShadowYIns write SetShadowYIns default 1;
    // inherited properties
    property Align;
    //property Alignment;
    property Anchors;
    //property AutoSize;
    property BiDiMode;
    property Caption;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FocusControl;
    //property Font;
    property ParentBiDiMode;
    property ParentColor;
    //property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    //property ShowAccelChar;
    property ShowHint;
    property Transparent;
    property Visible;
    //property WordWrap;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  //TCtrlOutlookClass = class of TCtrlOutlook;
  TCtrlOutlook = class(TCompCommonAttrs)
  private
    FColor: TColor;
    FImages: TCustomImageList;
    FFont: TFont;
    procedure   SetColor(const Value: TColor);
    procedure   SetFont(const Value: TFont);
    procedure   SetImages(const Value: TCustomImageList);
  protected
    property    Font : TFont
                  read FFont write SetFont;
    property    Color : TColor
                  read FColor write SetColor default clBtnFace;
    property    Images : TCustomImageList
                  read FImages write SetImages;
    procedure   FontChanged(Sender : TObject); dynamic;
    procedure   PenChanged(Sender : TObject); dynamic;
    procedure   Notification(AComponent: TComponent;
                  Operation: TOperation); override;
    procedure   UpdateColorAttr(var OldValue : TColor;
                  NewValue : TColor);
  public
    constructor Create(AOwner : TComponent); override;
    destructor  destroy; override;
    procedure   Assign(Source: TPersistent); override;
  published

  end;

  TCoolGraphCtrl = class(TCustomLabel)
  private
    FOutlook: TCtrlOutlook;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FAutoDownUp: boolean;
    FDown: boolean;
    FGroupIndex: integer;
    FAllowAllUp: Boolean;
    FAbilityMan: TCustomAbilityManager;
    FHalfTransparent: boolean;
    FTransparent: Boolean;
    //FShortcut: TShortcut;
    procedure   CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure   CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure   CMMouseEnter(var message : TMessage);message CM_MouseEnter;
    procedure   CMMouseLeave(var message : TMessage);message CM_MouseLeave;
    procedure   LMComAttrsChanged(var message : TMessage);
                  message LM_ComAttrsChanged;
    procedure   SetOutlook(const Value: TCtrlOutlook);
    procedure   SetImageIndex(const Value: integer);
    procedure   SetDown(const Value: boolean);
    procedure   SetGroupIndex(const Value: integer);
    procedure   LMButtonDown(var message : TMessage);message LM_ButtonDown;
    procedure   UpdateExclusive;
    procedure   SetAllowAllUp(const Value: Boolean);
    function    GetEnabled: boolean; reintroduce;
    function    GetVisible: boolean;
    procedure   SetAbilityMan(const Value: TCustomAbilityManager);
    procedure   SetEnabled(const Value: boolean); reintroduce;
    procedure   SetVisible(const Value: boolean);
    function 		GetCaption: TCaption;
    procedure 	SetCaption(const Value: TCaption);
    procedure   SetHalfTransparent(const Value: boolean);
    procedure   SetTransparent(const Value: Boolean);
  protected
    FImageIndex: integer; // direct access for animate

    FIsMouseOver: boolean;
    FIsMouseDown: boolean; // left button down
    procedure   MouseEnetr; dynamic;
    procedure   MouseLeave; dynamic;
    procedure   MouseDown(Button: TMouseButton; Shift: TShiftState;
                  X, Y: Integer); override;
    procedure   MouseUp(Button: TMouseButton; Shift: TShiftState;
                  X, Y: Integer); override;
    procedure   MouseOverChanged; dynamic;
    procedure   MouseDownChanged; dynamic;
    procedure   DownChanged; dynamic;
    procedure   OutlookChanged; dynamic;
    procedure   LookChanged; dynamic;
    procedure   Notification(AComponent: TComponent;
                  Operation: TOperation); override;
    function    HaveImage: boolean; dynamic;
    procedure   Paint; override;
    // can change ClientRect for borders
    procedure   ClearBKGND(ACanvas : TCanvas; var ClientRect : TRect); dynamic;
    procedure   PaintBKGND(ACanvas : TCanvas;var ClientRect : TRect); virtual;
    procedure   PaintImage(var ImageRect : TRect); virtual;
    procedure   PaintText(var TextBounds : TRect); virtual;
    procedure   PaintBorder(ACanvas : TCanvas; var ClientRect : TRect); virtual;
    procedure   DrawCtrlMask(ACanvas : TCanvas); virtual;
    procedure   CalcRect(const ClientRect : TRect;
                  var ImageRect,TextBounds : TRect); virtual;
    procedure   GetBrush(ACanvas : TCanvas); virtual;
    function    GetBKColor : TColor; dynamic;
    procedure   GetTextFont; virtual;
    procedure   UpdateAbility; dynamic;
    function    isOpaque : boolean; virtual;
    procedure   CheckOpaque;
    procedure   Loaded; override;
    // properties
    property    Down : boolean
                  read FDown write SetDown;
    property    AutoDownUp : boolean
                  read FAutoDownUp write FAutoDownUp default true;
    property    GroupIndex : integer
                  read FGroupIndex write SetGroupIndex default 0;
    property    AllowAllUp: Boolean
                  read FAllowAllUp write SetAllowAllUp default False;
    property    Outlook : TCtrlOutlook
                  read FOutlook write SetOutlook ;
    property    AbilityMan : TCustomAbilityManager
                  read FAbilityMan write SetAbilityMan;
    property    Enabled : boolean
                  read GetEnabled write SetEnabled;
    property    Visible : boolean
                  read GetVisible write SetVisible;
    property    ImageIndex : integer
                  read FImageIndex write SetImageIndex default -1;
    property    OnMouseEnter : TNotifyEvent
                  read FOnMouseEnter write FOnMouseEnter;
    property    OnMouseLeave : TNotifyEvent
                  read FOnMouseLeave write FOnMouseLeave;
    property 		Caption : TCaption read GetCaption write SetCaption;
    property    Transparent: Boolean read FTransparent write SetTransparent default False;
    property    HalfTransparent : boolean read FHalfTransparent write SetHalfTransparent default false;
    //property    Shortcut : TShortcut read FShortcut write FShortcut;
  public
    constructor Create(AOwner : TComponent); override;
  end;

  // %TLabelOutlook: 决定TCoolLabelX的外观
  TLabelOutlook = class(TCtrlOutlook)
  private
    FShadowed: boolean;
    FShadowXIns: Integer;
    FMargin: Integer;
    FSpacing: Integer;
    FShadowYIns: Integer;
    FLayout: TButtonLayout;
    FShadowColor: TColor;
    FMouseOverFont: TFont;
    FDisabledFont: TFont;
    FShadowImage: boolean;
    FShadowItalic: boolean;
    FMouseDownFont: TFont;
    FMouseOverColor: TColor;
    FMouseDownColor: TColor;
    FDisabledColor: TColor;
    FDisabledBKIndex: integer;
    FMouseDownBKIndex: integer;
    FBKIndex: integer;
    FMouseOverBKIndex: integer;
    FBackImages: TCustomImageList;
    FFocusImage: Boolean;
    procedure   SetDisabledFont(const Value: TFont);
    procedure   SetLayout(const Value: TButtonLayout);
    procedure   SetMargin(const Value: Integer);
    procedure   SetMouseOverFont(const Value: TFont);
    procedure   SetShadowColor(const Value: TColor);
    procedure   SetShadowed(const Value: boolean);
    procedure   SetShadowXIns(const Value: Integer);
    procedure   SetShadowYIns(const Value: Integer);
    procedure   SetSpacing(const Value: Integer);
    procedure   SetShadowImage(const Value: boolean);
    procedure   SetShadowItalic(const Value: boolean);
    procedure   SetMouseDownFont(const Value: TFont);
    procedure   SetDisabledColor(const Value: TColor);
    procedure   SetMouseDownColor(const Value: TColor);
    procedure   SetMouseOverColor(const Value: TColor);
    procedure   SetBackImages(const Value: TCustomImageList);
    procedure   SetBKIndex(const Value: integer);
    procedure   SetDisabledBKIndex(const Value: integer);
    procedure   SetMouseDownBKIndex(const Value: integer);
    procedure   SetMouseOverBKIndex(const Value: integer);
    procedure   SetFocusImage(const Value: Boolean);
  protected
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  destroy; override;
    procedure   Assign(Source: TPersistent); override;
  published
    property    DisabledFont : TFont
                  read FDisabledFont write SetDisabledFont;
    property    MouseOverFont : TFont
                  read FMouseOverFont write SetMouseOverFont;
    property    MouseDownFont : TFont
                  read FMouseDownFont write SetMouseDownFont;
    property    Layout: TButtonLayout
                  read FLayout write SetLayout default blGlyphLeft;
    property    Margin: Integer
                  read FMargin write SetMargin default -1;
    property    Spacing: Integer
                  read FSpacing write SetSpacing default 4;
    property    Shadowed : boolean
                  read FShadowed write SetShadowed default true;
    property    ShadowColor : TColor
                  read FShadowColor write SetShadowColor default clBtnShadow;
    property    ShadowXIns : Integer
                  read FShadowXIns write SetShadowXIns default 2;
    property    ShadowYIns : Integer
                  read FShadowYIns write SetShadowYIns default 2;
    property    ShadowItalic : boolean
                  read FShadowItalic write SetShadowItalic default false;
    property    ShadowImage : boolean
                  read FShadowImage write SetShadowImage default false;
    property    MouseDownColor : TColor
                  read FMouseDownColor write SetMouseDownColor default clBtnFace;
    property    DisabledColor : TColor
                  read FDisabledColor write SetDisabledColor default clBtnFace;
    property    MouseOverColor : TColor
                  read FMouseOverColor write SetMouseOverColor default clBtnFace;
    property    FocusImage : Boolean read FFocusImage write SetFocusImage default False;               
    property    Font;
    Property    Color;
    Property    Images;

    property    BackImages : TCustomImageList
                  read FBackImages write SetBackImages;
    property    DisabledBKIndex  : integer read FDisabledBKIndex write SetDisabledBKIndex;
    property    MouseOverBKIndex : integer read FMouseOverBKIndex write SetMouseOverBKIndex;
    property    MouseDownBKIndex : integer read FMouseDownBKIndex write SetMouseDownBKIndex;
    property    BKIndex : integer read FBKIndex write SetBKIndex;
  end;

  // %TCustomCoolLabelX: 对Lable扩充，外观由TLabelOutlook决定
  TCustomCoolLabelX = class(TCoolGraphCtrl)
  private
    function    Getoutlook: TLabelOutlook;
    procedure   Setoutlook(const Value: TLabelOutlook);
  protected
    procedure   PaintImage(var ImageRect : TRect); override;
    procedure   PaintText(var TextBounds : TRect); override;
    procedure   CalcRect(const ClientRect : TRect;
                  var ImageRect,TextBounds : TRect); override;
    procedure   GetTextFont; override;
    procedure   MouseOverChanged; override;
    //procedure   MouseDownChanged; override;
    procedure   DownChanged; override;
    function    GetBKColor : TColor; override;
    property    Outlook : TLabelOutlook
                  read Getoutlook write Setoutlook;
    function    HasBKImage: boolean;
    procedure   PaintBKGND(ACanvas : TCanvas;var ClientRect : TRect); override;
    procedure   PaintBKImage(ACanvas : TCanvas;Index : integer; var ClientRect : TRect);
  public

  end;

  TCoolLabelX = class(TCustomCoolLabelX)
  published
    property    Down;
    property    AutoDownUp;
    property    GroupIndex;
    property    AllowAllUp;

    property    ImageIndex;
    property    Outlook;
    property    AbilityMan;
    property    HalfTransparent;
    //property    Shortcut;
    property Align;
    //property Alignment;
    property Anchors;
    //property AutoSize;
    property BiDiMode;
    property Caption;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FocusControl;
    //property Font;
    property ParentBiDiMode;
    property ParentColor;
    //property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    //property ShowAccelChar;
    property ShowHint;
    property Transparent;
    property Visible;
    //property WordWrap;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnMouseEnter;
    property OnMouseLeave;
  end;

  TButtonShape = (bsRect,bsEllipse,bsRoundRect,bsRoundSide);

  // %TButtonOutlook : 决定TCustomCoolButton的外观
  TButtonOutlook = class(TLabelOutlook)
  private
    FFlat: boolean;
    FBorderWidth: integer;
    FBrightColor: TColor;
    FDullColor: TColor;
    FShape: TButtonShape;
    {FDullPen: TPen;
    FBrightPen: TPen;
    procedure   SetBrightPen(const Value: TPen);
    procedure   SetDullPen(const Value: TPen);}
    procedure   SetFlat(const Value: boolean);
    procedure   SetBorderWidth(const Value: integer);
    procedure   SetBrightColor(const Value: TColor);
    procedure   SetDullColor(const Value: TColor);
    procedure   SetShape(const Value: TButtonShape);
  protected

  public
    constructor Create(AOwner : TComponent); override;
    destructor  destroy; override;
    procedure   Assign(Source: TPersistent); override;
  published
    property    Flat : boolean
                  read FFlat write SetFlat default false;
    {property    BrightPen : TPen
                  read FBrightPen write SetBrightPen;
    property    DullPen : TPen
                  read FDullPen write SetDullPen;}
    property    BrightColor : TColor
                  read FBrightColor write SetBrightColor  default clWhite;
    property    DullColor : TColor
                  read FDullColor write SetDullColor default clBtnShadow;
    property    BorderWidth : integer
                  read FBorderWidth write SetBorderWidth default 1;
    property    Shape : TButtonShape read FShape write SetShape default bsRect;
  end;

  // %TCustomCoolButton : 按键。外观由TButtonOutlook决定
  TCustomCoolButton = class(TCustomCoolLabelX)
  private
    function    Getoutlook: TButtonOutlook;
    procedure   Setoutlook(const Value: TButtonOutlook);
    procedure   CMHitTest(var Message: TCMHitTest); message CM_HITTEST;
  protected
    property    Outlook : TButtonOutlook
                  read Getoutlook write Setoutlook;
    procedure   ClearBKGND(ACanvas : TCanvas; var ClientRect : TRect); override;
    //procedure   PaintBKGND(ACanvas : TCanvas;var ClientRect : TRect); override;
    procedure   DrawCtrlMask(ACanvas : TCanvas); override;
    procedure   PaintBorder(ACanvas : TCanvas; var ClientRect : TRect); override;
    function    isOpaque : boolean; override;
    procedure   OutlookChanged; override;
  public

  end;

  TCoolButton = class(TCustomCoolButton)
  published
    property    Down;
    property    AutoDownUp;
    property    GroupIndex;
    property    AllowAllUp;

    property    ImageIndex;
    property    Outlook;
    property    AbilityMan;
    property    HalfTransparent;
    //property    Shortcut;
      
    property Align;
    //property Alignment;
    property Anchors;
    //property AutoSize;
    property BiDiMode;
    property Caption;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FocusControl;
    //property Font;
    property ParentBiDiMode;
    property ParentColor;
    //property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    //property ShowAccelChar;
    property ShowHint;
    property Transparent;
    property Visible;
    //property WordWrap;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnMouseEnter;
    property OnMouseLeave;
  end;

  // %TPenExample : 显示Pen的效果的控件
  TPenExample = class(TCustomControl)
  private
    FPen: TPen;
    FBevelWidth: TBevelWidth;
    FBorderStyle: TBorderStyle;
    FBorderWidth: TBorderWidth;
    FBevelInner: TPanelBevel;
    FBevelOuter: TPanelBevel;
    procedure   SetPen(const Value: TPen);
    procedure   SetBevelInner(const Value: TPanelBevel);
    procedure   SetBevelOuter(const Value: TPanelBevel);
    procedure   SetBevelWidth(const Value: TBevelWidth);
    procedure   SetBorderStyle(const Value: TBorderStyle);
    procedure   SetBorderWidth(const Value: TBorderWidth);
    procedure   PenChanged(Sender : TObject);
  protected
    procedure   Paint; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  destroy; override;
  published
    property    Pen : TPen read FPen write SetPen;

    property    BevelInner: TPanelBevel read FBevelInner write SetBevelInner default bvNone;
    property    BevelOuter: TPanelBevel read FBevelOuter write SetBevelOuter default bvRaised;
    property    BevelWidth: TBevelWidth read FBevelWidth write SetBevelWidth default 1;
    property    BorderWidth: TBorderWidth read FBorderWidth write SetBorderWidth default 0;
    property    BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsNone;

    property Align;
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D;
    property UseDockManager default True;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  // %TAniButtonOutlook : 设定TCustomAniCoolButton的外观
  TAniButtonOutlook = class(TButtonOutlook)
  private
    FAnimateOnNormal: boolean;
    FAnimateOnOver: boolean;
    FAnimateOnDown: boolean;
    function    GetAnimate: boolean;
    function    GetInterval: integer;
    procedure   SetAnimate(const Value: boolean);
    procedure   SetAnimateOnDown(const Value: boolean);
    procedure   SetAnimateOnNormal(const Value: boolean);
    procedure   SetAnimateOnOver(const Value: boolean);
    procedure   SetInterval(const Value: integer);
  protected
    Timer :     TTimer;
    procedure   OnTimer(sender : TObject); virtual;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  destroy; override;
  published
    property    Interval : integer
      read GetInterval write SetInterval ;
    property    Animate : boolean
      read GetAnimate write SetAnimate;
    property    AnimateOnNormal : boolean
      read FAnimateOnNormal write SetAnimateOnNormal default false;
    property    AnimateOnOver : boolean
      read FAnimateOnOver write SetAnimateOnOver default true;
    property    AnimateOnDown : boolean
      read FAnimateOnDown write SetAnimateOnDown default false;
  end;

  // %TCustomAniCoolButton : 动画按键。外观由TAniButtonOutlook决定
  TCustomAniCoolButton = class(TCustomCoolButton)
  private
    FEndIndex: integer;
    FStartIndex: integer;
    procedure   LMComAttrsNotify(var message : TMessage);message LM_ComAttrsNotify;
    function    Getoutlook: TAniButtonOutlook;
    procedure   SetEndIndex(const Value: integer);
    procedure   Setoutlook(const Value: TAniButtonOutlook);
    procedure   SetStartIndex(const Value: integer);
  protected
    property    Outlook : TAniButtonOutlook
      read Getoutlook write Setoutlook;
    property    StartIndex : integer
      read FStartIndex write SetStartIndex default -1;
    property    EndIndex : integer
      read FEndIndex write SetEndIndex default -1;
    procedure   Paint; override;
    procedure   MouseOverChanged; override;
    procedure   DownChanged;override;
  public
    constructor Create(AOwner : TComponent); override;
  end;

  TAniCoolButton = class(TCustomAniCoolButton)
  published
    //property    ImageIndex;
    property    Down;
    property    AutoDownUp;
    property    GroupIndex;
    property    AllowAllUp;

    property    Outlook;
    property    AbilityMan;
    property    StartIndex;
    property    EndIndex;
    property    HalfTransparent;
    //property    Shortcut;
      
    property Align;
    property Anchors;
    property BiDiMode;
    property Caption;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FocusControl;
    property ParentBiDiMode;
    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    //property ShowAccelChar;
    property ShowHint;
    property Transparent;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnMouseEnter;
    property OnMouseLeave;
  end;

const
  // TAniButtonOutlook Notify Code
  abOnTimer = 1;

implementation

uses CompUtils,DrawUtils;

{ TCoolLabel }

constructor TCoolLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoSize := false;
  FImageIndex := -1;
  FNormalLook := -1;
  FMouseOverLook := -1;
  FDisabledLook := -1;
  FIsMouseOver := false;
  FSpacing := 4;
  FLayout := blGlyphLeft;
  FMargin := 0;
  FShadowColor := clBtnShadow;
  FShadowed := false;
  FShadowXIns := 1;
end;

procedure TCoolLabel.CMMouseEnter(var message: TMessage);
begin
  inherited;
  FIsMouseOver := true;
  //repaint;
  invalidate;
end;

procedure TCoolLabel.CMMouseLeave(var message: TMessage);
begin
  inherited;
  FIsMouseOver := false;
  //repaint;
  invalidate;
end;

procedure TCoolLabel.LookChanged;
begin
  if FAppearances<>nil then
    //repaint;
    invalidate;
end;

procedure TCoolLabel.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (AComponent=FAppearances) and
    (Operation=opRemove) then
   FAppearances := nil;
end;

procedure TCoolLabel.SetAppearances(const Value: TAppearances);
begin
  if FAppearances=value then exit;
  if FAppearances<>nil then
        FAppearances.removeClient(self);
  FAppearances:= value;
  if FAppearances<>nil then
        FAppearances.AddClient(self);
  //repaint;
  invalidate;
end;

procedure TCoolLabel.SetDisabledLook(const Value: integer);
begin
  if FDisabledLook <> Value then
  begin
    FDisabledLook := Value;
    LookChanged;
  end;
end;

procedure TCoolLabel.SetMouseOverLook(const Value: integer);
begin
  if FMouseOverLook <> Value then
  begin
    FMouseOverLook := Value;
    LookChanged;
  end;
end;

procedure TCoolLabel.SetNormalLook(const Value: integer);
begin
  if FNormalLook <> Value then
  begin
    FNormalLook := Value;
    LookChanged;
  end;
end;

procedure TCoolLabel.SetImageIndex(const Value: integer);
begin
  FImageIndex := Value;
  LookChanged;
end;

procedure TCoolLabel.SetLayout(const Value: TButtonLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    LookChanged;
  end;
end;

procedure TCoolLabel.SetMargin(const Value: Integer);
begin
  if FMargin <> Value then
  begin
    FMargin := Value;
    LookChanged;
  end;
end;

procedure TCoolLabel.SetSpacing(const Value: Integer);
begin
  if FSpacing <> Value then
  begin
    FSpacing := Value;
    LookChanged;
  end;
end;

procedure TCoolLabel.SetShadowColor(const Value: TColor);
begin
  if FShadowColor <> Value then
  begin
    FShadowColor := Value;
    //Repaint;
    invalidate;
  end;
end;

procedure TCoolLabel.SetShadowed(const Value: boolean);
begin
  if FShadowed <> Value then
  begin
    FShadowed := Value;
    //Repaint;
    invalidate;
  end;
end;

procedure TCoolLabel.Paint;
var
  Offset,GraphSize,GlyphPos : TPoint;
  Client, TextBounds : TRect;
  haveImage : boolean;
  BiDiFlags : LongInt;
begin
  with Canvas do
  begin
    if not Transparent then
    begin
      Brush.Color := Self.Color;
      Brush.Style := bsSolid;
      FillRect(ClientRect);
    end;
    Brush.Style := bsClear;
    Client := ClientRect;
    // set font
    if not Enabled then
      SetDrawFont(FDisabledLook)
    else
      if FIsMouseOver then
        SetDrawFont(FMouseOverLook)
    else
      SetDrawFont(FNormalLook);
  end;

  // calculate text and graph rect
  Offset := point(0,0);
  GraphSize := point(0,0);
  //flags := ;
  BiDiFlags := DrawTextBiDiModeFlags(0);
  haveImage := (Appearances<>nil)
    and (Appearances.Images<>nil)
    and (imageIndex>=0)
    and (imageIndex<Appearances.Images.Count);
  if haveImage then
    GraphSize := point( Appearances.Images.width,
                        Appearances.Images.Height);
  CalcLayout(Canvas, Client, Offset, Text, GraphSize,Layout, Margin, Spacing,
    GlyphPos, TextBounds,BiDiFlags);
  // Draw image
  if haveImage then
  begin
    if FIsMouseOver then
      Appearances.Images.DrawingStyle := dsNormal
    else
      Appearances.Images.DrawingStyle := dsFocus;
    Appearances.Images.Draw(Canvas,GlyphPos.x,GlyphPos.y,
                            imageIndex,Enabled);
  end;
  // Draw txet
  DrawText(TextBounds,BiDiFlags);
end;

{
procedure TCoolLabel.DoDrawText(var Rect: TRect; Flags: Integer);
begin

  //DrawButtonText(Canvas, Caption, TextBounds, State, BiDiFlags);
  inherited DoDrawText(TextBounds,Flags);
end;
}
procedure TCoolLabel.SetDrawFont(index: integer);
begin
  if (FAppearances<>nil) and
    (FAppearances.Fonts[index]<>nil) then
    Canvas.Font := FAppearances.Fonts[index]
  else
    Canvas.Font := Font;
end;

procedure TCoolLabel.LMAppearChanged(var message: TMessage);
begin
  //repaint;
  invalidate;
end;


procedure TCoolLabel.DrawText(TextBounds: TRect;BiDiFlags: LongInt);
var
  SaveColor : TColor;
begin
  with Canvas do
  begin
    Brush.Style := bsClear;
    {
    if not Enabled then
    begin
      OffsetRect(TextBounds, 1, 1);
      Font.Color := clBtnHighlight;
      windows.DrawText(Handle, PChar(Caption), Length(Caption), TextBounds,
        DT_CENTER or DT_VCENTER or BiDiFlags);
      OffsetRect(TextBounds, -1, -1);
      Font.Color := clBtnShadow;
      windows.DrawText(Handle, PChar(Caption), Length(Caption), TextBounds,
        DT_CENTER or DT_VCENTER or BiDiFlags);
    end else
      windows.DrawText(Handle, PChar(Caption), Length(Caption), TextBounds,
        DT_CENTER or DT_VCENTER or BiDiFlags);
    }
    if Shadowed then
    begin
      SaveColor := Font.Color;
      // paint shadow
      Font.Color := ShadowColor;
      OffsetRect(TextBounds, FShadowXIns,FShadowYIns);
      windows.DrawText(Handle, PChar(Text), Length(Text), TextBounds,
        DT_CENTER or DT_VCENTER or BiDiFlags);
      // paint text
      Font.Color := SaveColor;
      OffsetRect(TextBounds, -FShadowXIns, -FShadowYIns);
      windows.DrawText(Handle, PChar(Text), Length(Text), TextBounds,
        DT_CENTER or DT_VCENTER or BiDiFlags);
    end
    else
      windows.DrawText(Handle, PChar(Text), Length(Text), TextBounds,
        DT_CENTER or DT_VCENTER or BiDiFlags)
  end;
end;


procedure TCoolLabel.SetShadowXIns(const Value: Integer);
var
  Min : integer;
begin
  {if Height>Width then
    Min := Width div 2
  else
    Min := Height div 2;}
  Min := Width div 2;
  if (FShadowXIns <> Value)
    and (FShadowXIns<Min)
    and (FShadowXIns>-Min) then
  begin
    FShadowXIns := Value;
    if Shadowed then //Repaint;
      invalidate;
  end;
end;

procedure TCoolLabel.SetShadowYIns(const Value: Integer);
var
  Min : integer;
begin
  {if Height>Width then
    Min := Width div 2
  else
    Min := Height div 2;}
  Min := Height div 2;
  if (FShadowYIns <> Value)
    and (FShadowYIns<Min)
    and (FShadowYIns>-Min) then
  begin
    FShadowYIns := Value;
    if Shadowed then //Repaint;
      invalidate;
  end;
end;

{ TCtrlOutlook }

procedure TCtrlOutlook.Assign(Source: TPersistent);
begin
  if source is TCtrlOutlook then
  with source as TCtrlOutlook do
  begin
    self.BeginUpdate;
    self.FImages := Images;
    self.FColor  := Color;
    self.FFont.Assign(Font);
    self.EndUpdate;
  end
  else
    inherited Assign(Source);
end;

constructor TCtrlOutlook.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFont := TFont.Create;
  FFont.OnChange := FontChanged;
  FColor := clBtnFace;
end;

destructor TCtrlOutlook.destroy;
begin
  FFont.free;
  inherited destroy;
end;

procedure TCtrlOutlook.FontChanged(Sender: TObject);
begin
  //UpdateClients;
  PropChanged;
end;

procedure TCtrlOutlook.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (Operation=opRemove) and
    (AComponent=FImages) then
    Images := nil;
end;

procedure TCtrlOutlook.PenChanged(Sender: TObject);
begin
  PropChanged;
end;

procedure TCtrlOutlook.SetColor(const Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    //UpdateClients;
    PropChanged;
  end;
end;

procedure TCtrlOutlook.SetFont(const Value: TFont);
begin
  if FFont <> Value then
  begin
    FFont.Assign(Value);
  end;
end;

procedure TCtrlOutlook.SetImages(const Value: TCustomImageList);
begin
  if FImages <> Value then
  begin
    FImages := Value;
    if FImages<>nil then
      FImages.FreeNotification(self);
    //UpdateClients;
    PropChanged;
  end;
end;

procedure TCtrlOutlook.UpdateColorAttr(var OldValue: TColor;
  NewValue: TColor);
begin
  if OldValue<>NewValue then
  begin
    OldValue:=NewValue;
    PropChanged;
  end;
end;

{ TCoolGraphCtrl }

constructor TCoolGraphCtrl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FImageIndex := -1;
  FOutlook := nil;
  AutoSize := false;
  FIsMouseDown := false;
  FIsMouseOver := false;
  FAutoDownUp := true;
  FDown := false;
  FGroupIndex := 0;
  FAllowAllUp := false;
end;

function TCoolGraphCtrl.HaveImage: boolean;
begin
  haveImage := (FOutlook<>nil)
    and (FOutlook.Images<>nil)
    and (imageIndex>=0)
    and (imageIndex<FOutlook.Images.Count);
end;

procedure TCoolGraphCtrl.LMComAttrsChanged(var message: TMessage);
begin
  if message.wparam = integer(FOutlook) then
    OutlookChanged
  else if message.wparam = integer(FAbilityMan) then
    UpdateAbility;
  inherited;
end;

procedure TCoolGraphCtrl.CMMouseEnter(var message: TMessage);
begin
  inherited;
  MouseEnetr;
end;

procedure TCoolGraphCtrl.CMMouseLeave(var message: TMessage);
begin
  inherited;
  MouseLeave;
end;

procedure TCoolGraphCtrl.MouseEnetr;
begin
  FIsMouseOver := true;
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(self);
  MouseOverChanged;
end;

procedure TCoolGraphCtrl.MouseLeave;
begin
  FIsMouseOver := false;
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(self);
  MouseOverChanged;
end;

procedure TCoolGraphCtrl.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if Operation=opRemove then
    if (AComponent=FOutlook) then
      Outlook:= nil
    else if (AComponent=FAbilityMan) then
      FAbilityMan := nil;
end;

procedure TCoolGraphCtrl.OutlookChanged;
begin
  //Repaint;
  invalidate;
end;

procedure TCoolGraphCtrl.SetOutlook(const Value: TCtrlOutlook);
begin
  {if FOutlook <> Value then
  begin
    if FOutlook<>nil then
      FOutlook.RemoveClient(self);
    FOutlook := Value;
    if FOutlook<>nil then
      FOutlook.AddClient(self);
    //Repaint;
    invalidate;
  end;}
  if SetCommonAttrsProp(self,TCompCommonAttrs(FOutlook),value) then
    //invalidate;
    OutlookChanged;
end;

procedure TCoolGraphCtrl.Paint;
var
  Rect : TRect;
  ImageRect,TextBounds: TRect;
  OriDC : integer;
  Mem : TMemoryDC;
  Mask : TMemoryDC;
begin
  Rect := ClientRect;
  if Transparent and HalfTransparent then
  begin
    Mem := nil;
    Mask := nil;
    try
      Mem := TMemoryDC.Create(width,height,Canvas.handle);
      Mask := CreateMaskDC(width,height);
      // draw BK to Mem
      PaintBKGND(Mem.Canvas,Rect);
      // create Mask
      DrawCtrlMask(Mask.Canvas);
      SetHalfTransMask(Mask,clWhite);
      // Halt Transparent draw
      TransparentStretchBlt(Canvas.handle,0,0,width,height,
        Mem.DC,0,0,width,Height,Mask.DC,0,0);
    finally
      Mask.free;
      Mem.free;
    end;
  end
  else PaintBKGND(Canvas,Rect);
  Rect := ClientRect;
  PaintBorder(Canvas,Rect);
  GetTextFont;
  CalcRect(rect,ImageRect,TextBounds);
  if HaveImage then
  begin
    // avoid PaintImage change text font
    OriDC := SaveDC(Canvas.handle);
    PaintImage(ImageRect);
    RestoreDC(Canvas.handle,OriDC);
  end;
  PaintText(TextBounds);
end;

procedure TCoolGraphCtrl.CalcRect(const ClientRect: TRect; var ImageRect,
  TextBounds: TRect);
begin

end;

procedure TCoolGraphCtrl.PaintBKGND(ACanvas : TCanvas;var ClientRect: TRect);
begin
  {with Canvas do
  begin
    GetBrush;
    FillRect(ClientRect);
  end;}
  GetBrush(ACanvas);
  ClearBKGND(ACanvas,ClientRect)
end;

procedure TCoolGraphCtrl.PaintImage(var ImageRect: TRect);
begin

end;

procedure TCoolGraphCtrl.PaintText(var TextBounds: TRect);
begin

end;

procedure TCoolGraphCtrl.GetBrush(ACanvas : TCanvas);
begin
  with ACanvas do
  begin
    if transparent and not HalfTransparent then
    begin
      brush.Style := bsClear;
    end
    else
    begin
      brush.Style := bsSolid;
      brush.Color := GetBKColor;
    end;
  end;
end;

function TCoolGraphCtrl.GetBKColor: TColor;
begin
  if FOutlook<>nil then
    result := FOutlook.Color
  else
    result := Color;
end;

procedure TCoolGraphCtrl.GetTextFont;
begin
  if FOutlook<>nil then
    Canvas.Font := FOutlook.Font
  else
    Canvas.Font := Font;
end;

procedure TCoolGraphCtrl.LookChanged;
begin
  //Repaint;
  invalidate;
end;

procedure TCoolGraphCtrl.SetImageIndex(const Value: integer);
begin
  if FImageIndex<>value then
  begin
    FImageIndex:= Value;
    //Repaint;
    invalidate;
  end;
end;

procedure TCoolGraphCtrl.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button,Shift,X,Y);
  if button=mbLeft then
  begin
    FIsMouseDown := true;
    MouseDownChanged;
  end;
end;

procedure TCoolGraphCtrl.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseUp(Button,Shift,X,Y);
  if button=mbLeft then
  begin
    FIsMouseDown := false;
    MouseDownChanged;
  end;
end;

procedure TCoolGraphCtrl.MouseDownChanged;
begin
  if Enabled and AutoDownUp then
  begin
    // Down := FIsMouseDown;
    if FIsMouseDown then Down := true
    else if FGroupIndex=0 then Down := false;
  end;
end;

procedure TCoolGraphCtrl.MouseOverChanged;
begin

end;

procedure TCoolGraphCtrl.DownChanged;
begin

end;


procedure TCoolGraphCtrl.SetDown(const Value: boolean);
begin
  if FDown <> Value then
  begin
    FDown := Value;
    if FGroupIndex > 0 then
      if FDown then UpdateExclusive
      else if not FAllowAllUp then FDown := true;
    DownChanged;
  end;
    {if FDown then
    begin
      if
      if FDown and (not FAllowAllUp) then Exit;
      FDown := Value;
      if Value then
      begin
        if FState = bsUp then Invalidate;
        FState := bsExclusive
      end
      else
      begin
        FState := bsUp;
        Repaint;
      end;
      if Value then
    end;}
end;

procedure TCoolGraphCtrl.SetGroupIndex(const Value: integer);
begin
  if FGroupIndex <> Value then
  begin
    FGroupIndex := Value;
    UpdateExclusive;
  end;
end;

procedure TCoolGraphCtrl.UpdateExclusive;
var
  Msg: TMessage;
begin
  if (FGroupIndex <> 0) and (Parent <> nil) then
  begin
    Msg.Msg := LM_ButtonDown;
    Msg.WParam := FGroupIndex;
    Msg.LParam := Longint(Self);
    Msg.Result := 0;
    Parent.Broadcast(Msg);
  end;
end;

procedure TCoolGraphCtrl.LMButtonDown(var message: TMessage);
var
  Sender: TCoolGraphCtrl;
begin
  if Message.WParam = FGroupIndex then
  begin
    Sender := TCoolGraphCtrl(Message.LParam);
    if Sender <> Self then
    begin
      if Sender.Down and FDown then
      begin
        {FDown := False;
        FState := bsUp;
        Invalidate;}
        //Down := False;
        FDown := false;
        DownChanged;
      end;
      FAllowAllUp := Sender.AllowAllUp;
    end;
  end;
end;

procedure TCoolGraphCtrl.SetAllowAllUp(const Value: Boolean);
begin
  if FAllowAllUp <> Value then
  begin
    FAllowAllUp := Value;
    UpdateExclusive;
  end;
end;

function TCoolGraphCtrl.GetEnabled: boolean;
begin
  result := inherited Enabled;
end;

function TCoolGraphCtrl.GetVisible: boolean;
begin
  result := inherited visible;
end;

procedure TCoolGraphCtrl.SetAbilityMan(const Value: TCustomAbilityManager);
begin
  {if FAbilityMan<> Value then
  begin
    if FAbilityMan<>nil then
      FAbilityMan.RemoveClient(self);
    FAbilityMan:= Value;
    if FAbilityMan<>nil then
      FAbilityMan.AddClient(self);
    UpdateAbility;
  end;}
  if SetCommonAttrsProp(self,TCompCommonAttrs(FAbilityMan),value) then
    UpdateAbility;
end;

procedure TCoolGraphCtrl.SetEnabled(const Value: boolean);
begin
  if FAbilityMan=nil then
    inherited Enabled := value;
end;

procedure TCoolGraphCtrl.SetVisible(const Value: boolean);
begin
  if FAbilityMan=nil then
    inherited visible := value;
end;

procedure TCoolGraphCtrl.UpdateAbility;
begin
  if FAbilityMan<>nil then
  begin
    inherited visible := FAbilityMan.visible;
    inherited Enabled := FAbilityMan.enabled;
  end;
end;

function TCoolGraphCtrl.GetCaption: TCaption;
begin
  result := NormalToSpcCap(inherited Caption);
end;

procedure TCoolGraphCtrl.SetCaption(const Value: TCaption);
begin
  inherited Caption := SpcCapToNormal(value);
end;

procedure TCoolGraphCtrl.ClearBKGND(ACanvas : TCanvas; var ClientRect: TRect);
begin
  ACanvas.FillRect(ClientRect);
end;

procedure TCoolGraphCtrl.SetHalfTransparent(const Value: boolean);
begin
  if FHalfTransparent <> Value then
  begin
    FHalfTransparent := Value;
    if Transparent then Invalidate;
  end;
end;

procedure TCoolGraphCtrl.DrawCtrlMask(ACanvas: TCanvas);
begin
  with ACanvas do
  begin
    Brush.color := clBlack;
    FillRect(ClientRect);
  end;
end;

procedure TCoolGraphCtrl.PaintBorder(ACanvas: TCanvas;
  var ClientRect: TRect);
begin

end;

procedure TCoolGraphCtrl.SetTransparent(const Value: Boolean);
begin
  if FTransparent<>value then
  begin
    FTransparent:=value;
    CheckOpaque;
  end;
end;

function TCoolGraphCtrl.isOpaque: boolean;
begin
  result := not FTransparent;
end;

procedure TCoolGraphCtrl.CheckOpaque;
begin
  if isOpaque then
  begin
    ControlStyle := ControlStyle + [csOpaque];
    outputDebugString('isOpaque');
  end
  else
  begin
    ControlStyle := ControlStyle - [csOpaque];
    outputDebugString('Not isOpaque');
  end;
end;

procedure TCoolGraphCtrl.Loaded;
begin
  inherited Loaded;
  CheckOpaque;
end;

procedure TCoolGraphCtrl.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if (IsAccel(CharCode, Caption) {or (Shortcut=CurKeyToShortCut(Message)) })
      and Enabled and Visible and (Parent <> nil) and Parent.Showing then
    begin
      if GroupIndex>0 then
      begin
        if not Down then
        begin
          Down := true;
          Click;
        end;
      end
      else Click;
      Result := 1;
    end else
      inherited;
end;

procedure TCoolGraphCtrl.CMDialogKey(var Message: TCMDialogKey);
begin
  inherited;
  //CMDialogChar(Message);
end;

{ TLabelOutlook }

procedure TLabelOutlook.Assign(Source: TPersistent);
begin
  if Source is TLabelOutlook then
  begin
    BeginUpdate;
    inherited Assign(Source);
    with Source as TLabelOutlook do
    begin
      self.FShadowed := Shadowed;
      self.FShadowItalic := ShadowItalic;
      self.FShadowColor := ShadowColor;
      self.FShadowImage := ShadowImage;
      self.FShadowXIns := ShadowXIns;
      self.FShadowYIns := ShadowYIns;
      self.FMargin := Margin;
      self.Spacing := Spacing;
      self.FLayout := Layout;
      self.FDisabledFont.Assign(DisabledFont);
      self.FMouseDownFont.Assign(MouseDownFont);
      self.FMouseOverFont.Assign(MouseOverFont);
      self.FMouseOverColor := MouseOverColor;
      self.FMouseDownColor := MouseDownColor;
      self.FDisabledColor := DisabledColor;
    end;
    EndUpdate;
  end
  else
    inherited Assign(Source);
end;

constructor TLabelOutlook.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDisabledFont := TFont.Create;
  FDisabledFont.OnChange := FontChanged;
  FMouseOverFont := TFont.Create;
  FMouseOverFont.OnChange := FontChanged;
  FMouseDownFont := TFont.Create;
  FMouseDownFont.OnChange := FontChanged;
  FShadowed := true;
  FShadowColor := clBtnShadow;
  FMouseOverColor := clBtnFace;
  FMouseDownColor := clBtnFace;
  FDisabledColor := clBtnFace;
  FShadowXIns := 2;
  FShadowYIns := 2;
  FShadowImage := false;
  FShadowItalic := false;
  FSpacing := 4;
  FMargin := -1;
  FLayout := blGlyphLeft;
end;

destructor TLabelOutlook.destroy;
begin
  FMouseOverFont.OnChange := nil;
  FMouseOverFont.free;
  FDisabledFont.OnChange := nil;
  FDisabledFont.free;
  inherited destroy;
end;

procedure TLabelOutlook.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (AComponent=FBackImages) and (Operation=opRemove) then
    BackImages:=nil;
end;

procedure TLabelOutlook.SetBackImages(const Value: TCustomImageList);
begin
  if FBackImages<>value then
  begin
    FBackImages:=value;
    if FBackImages<>nil then FBackImages.FreeNotification(self);
    PropChanged;
  end;
end;

procedure TLabelOutlook.SetBKIndex(const Value: integer);
begin
  UpdateIntAttr(FBKIndex,Value);
end;

procedure TLabelOutlook.SetDisabledBKIndex(const Value: integer);
begin
  UpdateIntAttr(FDisabledBKIndex,Value);
end;

procedure TLabelOutlook.SetMouseDownBKIndex(const Value: integer);
begin
  UpdateIntAttr(FMouseDownBKIndex,Value);
end;

procedure TLabelOutlook.SetMouseOverBKIndex(const Value: integer);
begin
  UpdateIntAttr(FMouseOverBKIndex,Value);
end;

procedure TLabelOutlook.SetDisabledColor(const Value: TColor);
begin
  UpdateColorAttr(FDisabledColor,Value);
end;

procedure TLabelOutlook.SetDisabledFont(const Value: TFont);
begin
  if FDisabledFont<>value then
  begin
    FDisabledFont.Assign(Value);
    //UpdateClients;
  end;
end;

procedure TLabelOutlook.SetLayout(const Value: TButtonLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    //UpdateClients;
    PropChanged;
  end;
end;

procedure TLabelOutlook.SetMargin(const Value: Integer);
begin
  UpdateIntAttr(FMargin,value);
end;

procedure TLabelOutlook.SetMouseDownColor(const Value: TColor);
begin
  UpdateColorAttr(FMouseDownColor,Value);
end;

procedure TLabelOutlook.SetMouseDownFont(const Value: TFont);
begin
  if FMouseDownFont <> Value then
  begin
    FMouseDownFont.Assign(Value);
  end;
end;

procedure TLabelOutlook.SetMouseOverColor(const Value: TColor);
begin
  UpdateColorAttr(FMouseOverColor,Value);
end;

procedure TLabelOutlook.SetMouseOverFont(const Value: TFont);
begin
  if FMouseOverFont <> Value then
  begin
    FMouseOverFont.Assign(Value);
  end;
end;

procedure TLabelOutlook.SetShadowColor(const Value: TColor);
begin
  UpdateColorAttr(FShadowColor,Value);
end;

procedure TLabelOutlook.SetShadowed(const Value: boolean);
begin
  UpdateBoolAttr(FShadowed,value);
end;

procedure TLabelOutlook.SetShadowImage(const Value: boolean);
begin
  UpdateBoolAttr(FShadowImage,value);
end;

procedure TLabelOutlook.SetShadowItalic(const Value: boolean);
begin
  UpdateBoolAttr(FShadowItalic,value);
end;

procedure TLabelOutlook.SetShadowXIns(const Value: Integer);
begin
  UpdateIntAttr(FShadowXIns,value);
end;

procedure TLabelOutlook.SetShadowYIns(const Value: Integer);
begin
  UpdateIntAttr(FShadowYIns,value);
end;

procedure TLabelOutlook.SetSpacing(const Value: Integer);
begin
  UpdateIntAttr(FSpacing,value);
end;

procedure TLabelOutlook.SetFocusImage(const Value: Boolean);
begin
  UpdateBoolAttr(FFocusImage,Value);
end;

{ TCustomCoolLabelX }

function TCustomCoolLabelX.Getoutlook: TLabelOutlook;
begin
  result := TLabelOutlook(inherited Outlook);
end;

procedure TCustomCoolLabelX.Setoutlook(const Value: TLabelOutlook);
begin
  inherited Outlook := value;
end;

procedure TCustomCoolLabelX.GetTextFont;
begin
  if FOutlook<>nil then
    if not Enabled then
      Canvas.Font := Outlook.DisabledFont
    else if Down then
      Canvas.Font := outlook.MouseDownFont
    else if FIsMouseOver then
      Canvas.Font := Outlook.MouseOverFont
    else
      Canvas.Font := Outlook.Font
  else
    inherited GetTextFont;
end;

procedure TCustomCoolLabelX.CalcRect(const ClientRect: TRect; var ImageRect,
  TextBounds: TRect);
var
  GlyphSize : TPoint;
  Layout: TButtonLayout;
  Margin, Spacing: Integer;
  Offset : TPoint;
  BiDiFlags : LongInt;
  SaveFontStyles : TFontStyles;
begin
  if Outlook<>nil then
  begin
    Margin := outlook.Margin;
    Spacing := outlook.Spacing;
    Layout := outlook.Layout;
    if HaveImage then
      GlyphSize := point(outlook.Images.width,
                         outlook.Images.Height)
    else
      GlyphSize := point(0,0);
  end
  else
  begin
    Margin := 0;
    Spacing := 0;
    Layout := blGlyphLeft;
    GlyphSize := point(0,0);
  end;
  Offset := point(0,0);
  BiDiFlags := DrawTextBiDiModeFlags(0);
  // add fsItalic to font.Style to get more rect for shadow text
  SaveFontStyles := canvas.font.Style;
  canvas.font.Style := SaveFontStyles + [fsItalic];
  CalcLayout(Canvas, ClientRect,
    Offset, Text, GlyphSize,Layout,
    Margin, Spacing,
    ImageRect.topLeft, TextBounds,BiDiFlags);
  canvas.font.Style := SaveFontStyles;
  with ImageRect do
  begin
    right := left + GlyphSize.x;
    Bottom :=Top  + GlyphSize.y;
  end;
end;

procedure TCustomCoolLabelX.PaintImage(var ImageRect: TRect);
begin
  if FIsMouseOver or Down or not Outlook.FocusImage then
    Outlook.Images.DrawingStyle := dsNormal
  else
    Outlook.Images.DrawingStyle := dsFocus;
  // draw image shadow
  if Enabled and Outlook.ShadowImage
    and not Down then
  begin
    //OffsetRect(ImageRect, outlook.ShadowXIns,outlook.ShadowYIns);
    Outlook.Images.Draw(Canvas,
      ImageRect.left+outlook.ShadowXIns,
      ImageRect.top+outlook.ShadowYIns,
      imageIndex,false);
    //OffsetRect(ImageRect, -outlook.ShadowXIns,-outlook.ShadowYIns);
  end;
  // draw image
  if Enabled and Down then
    Outlook.Images.Draw(Canvas,
      ImageRect.left+outlook.ShadowXIns,
      ImageRect.top+outlook.ShadowYIns,
      imageIndex,true)
  else
    Outlook.Images.Draw(Canvas,ImageRect.left,ImageRect.top,
      imageIndex,Enabled);
end;

procedure TCustomCoolLabelX.PaintText(var TextBounds: TRect);
var
  SaveColor : TColor;
  BiDiFlags : integer;
begin
  BiDiFlags := DrawTextBiDiModeFlags(0);
  //GetTextFont;
  with Canvas do
  begin
    //Refresh;
    Brush.Style := bsClear;
    if (outlook<>nil) and outlook.Shadowed then
    begin
      if enabled and Down then
      begin
        // paint down
        // go to shadow pos
        OffsetRect(TextBounds, outlook.ShadowXIns,outlook.ShadowYIns);
        //Font := outlook.MouseDownFont;
        windows.DrawText(Handle, PChar(Text), Length(Text), TextBounds,
          DT_CENTER or DT_VCENTER or BiDiFlags);
      end
      else // not down
      begin
        if enabled then
        begin
          // paint shadow only when enabled
          SaveColor := Font.Color;
          Font.Color := outlook.ShadowColor;
          if outlook.ShadowItalic then
            Font.Style := Font.Style + [fsItalic];
          OffsetRect(TextBounds, outlook.ShadowXIns,outlook.ShadowYIns);
          windows.DrawText(Handle, PChar(Text), Length(Text), TextBounds,
            DT_CENTER or DT_VCENTER or BiDiFlags);
          Font.Color := SaveColor;
          OffsetRect(TextBounds, -outlook.ShadowXIns, -outlook.ShadowYIns);
        end;
        // paint text
        if outlook.ShadowItalic then
          Font.Style := Font.Style - [fsItalic];
        windows.DrawText(Handle, PChar(Text), Length(Text), TextBounds,
          DT_CENTER or DT_VCENTER or BiDiFlags);
      end;
    end
    else
      // not shadowed
      windows.DrawText(Handle, PChar(Text), Length(Text), TextBounds,
        DT_CENTER or DT_VCENTER or BiDiFlags)
  end;
end;
{
procedure TCustomCoolLabelX.MouseDownChanged;
begin
  if enabled then repaint;
end;
}
procedure TCustomCoolLabelX.MouseOverChanged;
begin
  //if enabled then repaint;
  if enabled then invalidate;
end;

function TCustomCoolLabelX.GetBKColor: TColor;
begin
  if Outlook<>nil then
    if not Enabled then
      result := Outlook.DisabledColor
    else if Down then
      result := Outlook.MouseDownColor
    else if FIsMouseOver then
      result := Outlook.MouseOverColor
    else
      result := Outlook.Color
  else
    result := inherited GetBKColor;
end;

procedure TCustomCoolLabelX.DownChanged;
begin
  //repaint;
  invalidate;
end;

procedure TCustomCoolLabelX.PaintBKGND(ACanvas : TCanvas;var ClientRect: TRect);
begin
  if HasBKImage then
  begin
    if not Enabled then
      PaintBKImage(ACanvas,Outlook.DisabledBKIndex,ClientRect)
    else if FIsMouseDown then
      PaintBKImage(ACanvas,Outlook.MouseDownBKIndex,ClientRect)
    else if FIsMouseOver then
      PaintBKImage(ACanvas,Outlook.MouseOverBKIndex,ClientRect)
    else PaintBKImage(ACanvas,Outlook.BKIndex,ClientRect);
  end
  else inherited PaintBKGND(ACanvas,ClientRect);
end;

function TCustomCoolLabelX.HasBKImage: boolean;
begin
  result := (Outlook<>nil) and (Outlook.BackImages<>nil);
end;

procedure TCustomCoolLabelX.PaintBKImage(ACanvas : TCanvas;Index: integer; var ClientRect : TRect);
var
  DrawIndex : integer;
begin
  DrawIndex := Index;
  if (DrawIndex<0) or (DrawIndex>=Outlook.BackImages.Count) then
    DrawIndex:=Outlook.BKIndex;
  if (DrawIndex<0) or (DrawIndex>=Outlook.BackImages.Count) then
    inherited PaintBKGND(ACanvas,ClientRect)
  else Outlook.BackImages.Draw(ACanvas,ClientRect.left,ClientRect.Top,DrawIndex,true);
end;

{ TButtonOutlook }

procedure TButtonOutlook.Assign(Source: TPersistent);
begin
  if Source is TButtonOutlook then
  begin
    BeginUpdate;
    inherited Assign(Source);
    with Source as TButtonOutlook do
    begin
      Self.FFlat := Flat;
      {Self.FBrightPen.Assign(BrightPen);
      self.FDullPen.Assign(DullPen);}
      self.FBorderWidth := BorderWidth;
      self.FBrightColor := BrightColor;
      self.FDullColor := DullColor;
    end;
    EndUpdate;
  end
  else
    inherited Assign(Source);
end;

constructor TButtonOutlook.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {FDullPen := TPen.Create;
  FDullPen.Color := clBtnShadow;
  FDullPen.Width := 1;

  FBrightPen := TPen.Create;
  FBrightPen.color := clBtnHighlight;
  FBrightPen.Width := 1;

  FDullPen.OnChange := PenChanged;
  FBrightPen.OnChange := PenChanged;}
  FBorderWidth := 1;
  FBrightColor := clWhite;
  FDullColor := clBtnShadow;
end;

destructor TButtonOutlook.destroy;
begin
  {FBrightPen.OnChange := nil;
  FBrightPen.free;
  FDullPen.OnChange := nil;
  FDullPen.free;}
  inherited destroy;
end;

procedure TButtonOutlook.SetBorderWidth(const Value: integer);
begin
  UpdateIntAttr(FBorderWidth,Value);
end;

procedure TButtonOutlook.SetBrightColor(const Value: TColor);
begin
  UpdateColorAttr(FBrightColor,Value);
end;

procedure TButtonOutlook.SetDullColor(const Value: TColor);
begin
  UpdateColorAttr(FDullColor,Value);
end;

{
procedure TButtonOutlook.SetBrightPen(const Value: TPen);
begin
  FBrightPen.Assign(Value);
end;
}
{
procedure TButtonOutlook.SetDullPen(const Value: TPen);
begin
  FDullPen.Assign(Value);
end;
}
procedure TButtonOutlook.SetFlat(const Value: boolean);
begin
  UpdateBoolAttr(FFlat,value);
end;


procedure TButtonOutlook.SetShape(const Value: TButtonShape);
begin
  {//FShape := Value;
  assert(sizeof(integer)=sizeof(FShape));
  UpdateIntAttr(Integer(FShape),value);}
  if FShape<>value then
  begin
    FShape:=value;
    PropChanged;
  end;
end;

{ TCustomCoolButton }

function TCustomCoolButton.Getoutlook: TButtonOutlook;
begin
  result := TButtonOutlook(inherited outlook);
end;

procedure TCustomCoolButton.Setoutlook(const Value: TButtonOutlook);
begin
  inherited outlook := value;
end;

//procedure TCustomCoolButton.PaintBKGND(ACanvas : TCanvas;var ClientRect: TRect);

procedure TCustomCoolButton.ClearBKGND(ACanvas : TCanvas; var ClientRect: TRect);
var
  R : integer;
begin
  if (Outlook<>nil) then
    with ACanvas,ClientRect do
    if Brush.Style<>bsClear then
    begin
      Pen.Color := Brush.Color;
      case Outlook.Shape of
        bsRect :       FillRect(ClientRect);
        bsEllipse :    Ellipse(left,top,right-1,bottom-1);
        bsRoundRect :
                       begin
                         if self.width<self.Height then R:=self.width div 4
                          else R:=self.Height div 4;
                         RoundRect(left,top,right-1,bottom-1,2*R,2*R);
                       end;
        bsRoundSide :
                       begin
                         if self.width<self.Height then R:=self.width div 2
                          else R:=self.Height div 2;
                         RoundRect(left,top,right-1,bottom-1,2*R,2*R);
                       end;

      end;
      //InflateRect(ClientRect,-1,-1);
      {case Outlook.Shape of
        bsRect :       FillRect(ClientRect);
        bsEllipse :    Ellipse(left,top,right,bottom);
        bsRoundRect :
                       begin
                         if self.width<self.Height then R:=self.width div 4
                          else R:=self.Height div 4;
                         RoundRect(left,top,right,bottom,2*R,2*R);
                       end;
        bsRoundSide :
                       begin
                         if self.width<self.Height then R:=self.width div 2
                          else R:=self.Height div 2;
                         RoundRect(left,top,right,bottom,2*R,2*R);
                       end;
      end}
    end
  else inherited  ClearBKGND(ACanvas,ClientRect);
end;

procedure TCustomCoolButton.DrawCtrlMask(ACanvas: TCanvas);
var
  R : integer;
begin
  if Outlook<>nil then
    with ACanvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := clWhite;
      FillRect(ClientRect);
      Brush.Color := clBlack;
      Pen.Color := clBlack;
      case Outlook.Shape of
        bsRect :       FillRect(ClientRect);
        bsEllipse :    Ellipse(0,0,Width-1,Height-1);
        bsRoundRect :
                       begin
                         if self.width<self.Height then R:=self.width div 4
                          else R:=self.Height div 4;
                         RoundRect(0,0,Width-1,Height-1,2*R,2*R);
                       end;
        bsRoundSide :
                       begin
                         if self.width<self.Height then R:=self.width div 2
                          else R:=self.Height div 2;
                         RoundRect(0,0,Width-1,Height-1,2*R,2*R);
                       end;
      end;
    end
  else inherited DrawCtrlMask(ACanvas);
end;

procedure TCustomCoolButton.PaintBorder(ACanvas: TCanvas;
  var ClientRect: TRect);
var
  TopLeftColor,BottomRightColor : TColor;
  WillPaint : boolean;
  R : integer;
begin
  if Outlook<>nil then
  with Acanvas do
  begin
    Brush.Bitmap := nil;
    Brush.Style := bsSolid;
    Pen.Style := psSolid;

    // set pen1,pen2,WillPaint
    WillPaint := true;
    if Down then
    begin // button is down
      TopLeftColor := Outlook.DullColor;
      BottomRightColor := Outlook.BrightColor;
    end
    else
    begin // button is up
      TopLeftColor := Outlook.BrightColor;
      BottomRightColor := Outlook.DullColor;
      WillPaint := not Outlook.flat or
        (Outlook.Flat and Enabled and FIsMouseOver);
    end;
    if WillPaint then
    case Outlook.Shape of
      bsRect : Frame3D(ACanvas,ClientRect,
                  TopLeftColor,BottomRightColor,
                  Outlook.BorderWidth);
      bsEllipse : EllipseFrame(ACanvas,ClientRect,
                    TopLeftColor,BottomRightColor,
                    Outlook.BorderWidth);
      bsRoundRect :
                    begin
                      if width<Height then R:=width div 4
                      else R:=Height div 4;
                      RoundRectFrame(ACanvas,ClientRect,R,
                        TopLeftColor,BottomRightColor,
                        Outlook.BorderWidth);
                    end;
      bsRoundSide :
                   begin
                     if self.width<self.Height then R:=self.width div 2
                      else R:=self.Height div 2;
                     RoundRectFrame(ACanvas,ClientRect,R,
                        TopLeftColor,BottomRightColor,
                        Outlook.BorderWidth);
                   end;

    end;
  end;
end;


procedure TCustomCoolButton.CMHitTest(var Message: TCMHitTest);
var
  TheRegion : HRGN;
  R : integer;
begin
  if Outlook<>nil then
  begin
    TheRegion:=0;
    case Outlook.Shape of
        bsRect :       TheRegion := CreateRectRgn(0,0,width,height);
        bsEllipse :    TheRegion := CreateEllipticRgn(0,0,width,height);
        bsRoundRect :
                       begin
                         if width<Height then R:=width div 4
                          else R:=Height div 4;
                         TheRegion := CreateRoundRectRgn(0,0,width,height,2*R,2*R);
                       end;
        bsRoundSide :
                       begin
                         if width<Height then R:=width div 2
                         else R:=Height div 2;
                         TheRegion := CreateRoundRectRgn(0,0,width,height,2*R,2*R);
                       end;

    end;
    if PtInRegion(TheRegion, message.XPos,message.YPos) then
      message.Result :=1
    else message.Result :=0;
    DeleteObject(TheRegion);
  end
  else inherited ;
end;

function TCustomCoolButton.isOpaque: boolean;
begin
  if Outlook<>nil then
    result := not FTransparent and (Outlook.Shape=bsRect)
  else result := inherited isOpaque;
end;

procedure TCustomCoolButton.OutlookChanged;
begin
  CheckOpaque;
  inherited OutlookChanged;
end;

{ TPenExample }

constructor TPenExample.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPen := TPen.Create;
  FPen.OnChange := PenChanged;
  width := 200;
  Height := 50;
  FBevelWidth := 1;
  FBevelInner := bvNone;
  FBevelOuter := bvRaised;
end;

destructor TPenExample.destroy;
begin
  FPen.OnChange := nil;
  FPen.free;
  inherited destroy;
end;

procedure TPenExample.Paint;
var
  Rect: TRect;
  TopColor, BottomColor: TColor;
  Y : integer;

  procedure AdjustColors(Bevel: TPanelBevel);
  begin
    TopColor := clBtnHighlight;
    if Bevel = bvLowered then TopColor := clBtnShadow;
    BottomColor := clBtnShadow;
    if Bevel = bvLowered then BottomColor := clBtnHighlight;
  end;

begin
  // draw frame
  // copy code from TCustomPanel
  Canvas.pen.style := psSolid;
  Rect := GetClientRect;
  if BevelOuter <> bvNone then
  begin
    AdjustColors(BevelOuter);
    Frame3D(Canvas, Rect, TopColor, BottomColor, BevelWidth);
  end;
  Frame3D(Canvas, Rect, Color, Color, BorderWidth);
  if BevelInner <> bvNone then
  begin
    AdjustColors(BevelInner);
    Frame3D(Canvas, Rect, TopColor, BottomColor, BevelWidth);
  end;

  with Canvas do
  begin
    // draw background
    Brush.Color := Color;
    FillRect(Rect);
    // draw line
    Pen := self.pen;
    with Rect do
    begin
      Y := Rect.top + (Rect.Bottom-Rect.top-pen.width) div 2;
      MoveTo(left+2,Y);
      LineTo(right-2,Y);
    end;
  end;
end;

procedure TPenExample.PenChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TPenExample.SetBevelInner(const Value: TPanelBevel);
begin
  FBevelInner := Value;
  Invalidate;
end;

procedure TPenExample.SetBevelOuter(const Value: TPanelBevel);
begin
  FBevelOuter := Value;
  Invalidate;
end;

procedure TPenExample.SetBevelWidth(const Value: TBevelWidth);
begin
  FBevelWidth := Value;
  Invalidate;
end;

procedure TPenExample.SetBorderStyle(const Value: TBorderStyle);
begin
  FBorderStyle := Value;
  Invalidate;
end;

procedure TPenExample.SetBorderWidth(const Value: TBorderWidth);
begin
  FBorderWidth := Value;
  Invalidate;
end;

procedure TPenExample.SetPen(const Value: TPen);
begin
  if FPen<>value then
    FPen.Assign(Value);
end;

{ TAniButtonOutlook }

constructor TAniButtonOutlook.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Timer := TTimer.Create(self);
  Timer.OnTimer := OnTimer;
  FAnimateOnNormal := false;
  FAnimateOnOver := true;
  FAnimateOnDown := false;
end;

destructor TAniButtonOutlook.destroy;
begin
  Timer.free;
  inherited destroy;
end;

function TAniButtonOutlook.GetAnimate: boolean;
begin
  result := Timer.Enabled;
end;

function TAniButtonOutlook.GetInterval: integer;
begin
  result := Timer.Interval;
end;

procedure TAniButtonOutlook.SetAnimate(const Value: boolean);
begin
  Timer.Enabled := value;
end;

procedure TAniButtonOutlook.SetAnimateOnDown(const Value: boolean);
begin
  FAnimateOnDown := Value;
end;

procedure TAniButtonOutlook.SetAnimateOnNormal(const Value: boolean);
begin
  FAnimateOnNormal := Value;
end;

procedure TAniButtonOutlook.SetAnimateOnOver(const Value: boolean);
begin
  FAnimateOnOver := Value;
end;

procedure TAniButtonOutlook.SetInterval(const Value: integer);
begin
  Timer.Interval := value;
end;

procedure TAniButtonOutlook.OnTimer(sender: TObject);
begin
  NotifyClients(abOnTimer);
end;

{ TCustomAniCoolButton }

constructor TCustomAniCoolButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStartIndex := -1;
  FEndIndex := -1;
end;

function TCustomAniCoolButton.Getoutlook: TAniButtonOutlook;
begin
  result := TAniButtonOutlook(inherited outlook);
end;

procedure TCustomAniCoolButton.Setoutlook(const Value: TAniButtonOutlook);
begin
  inherited Outlook := value;
end;

procedure TCustomAniCoolButton.SetStartIndex(const Value: integer);
begin
  if FStartIndex <> Value then
  begin
    FStartIndex := Value;
    ImageIndex := Value;
  end;
end;

procedure TCustomAniCoolButton.SetEndIndex(const Value: integer);
begin
  FEndIndex := Value;
end;

procedure TCustomAniCoolButton.LMComAttrsNotify(var message: TMessage);
var
  Ani : boolean;
  TempIndex : integer;
begin
  if enabled and (outlook<>nil) and
    (message.lparam=abOnTimer)  then
  with outlook do
  begin
    TempIndex := StartIndex;
    // check StartIndex, EndIndex
    Ani := (StartIndex>=0) and (StartIndex<EndIndex);
    if ani then
    begin
      // check animate in the current state
      if down then
        ani := AnimateOnDown
      else if FIsMouseOver then
        ani := AnimateOnOver
      else
        ani := AnimateOnNormal;

      if ani then
      begin
        TempIndex := ImageIndex;
        Inc(TempIndex);
        if TempIndex>EndIndex then
          TempIndex:=StartIndex;
      end
    end;
    //ImageIndex := TempIndex;
    // new version to optimize the animate
    FImageIndex := TempIndex;
    Paint;
  end;
end;

procedure TCustomAniCoolButton.Paint;
begin
  if not Enabled then
    FImageIndex := StartIndex
  else
  if Outlook<>nil then
    if Down and not Outlook.AnimateOnDown then
      FImageIndex := StartIndex
    else if FIsMouseOver and not Outlook.AnimateOnOver then
      FImageIndex := StartIndex
    else if not down and not FIsMouseOver and
      not Outlook.AnimateOnNormal then
      FImageIndex := StartIndex;
  inherited Paint;
end;

procedure TCustomAniCoolButton.DownChanged;
begin
  inherited DownChanged;
  if Enabled and Down and (Outlook<>nil)
    and Outlook.AnimateOnDown
    and (ImageIndex=StartIndex)
    and (StartIndex>=0)
    and (EndIndex>StartIndex) then
  ImageIndex := StartIndex + 1;
end;

procedure TCustomAniCoolButton.MouseOverChanged;
begin
  inherited MouseOverChanged;
  if Enabled and FIsMouseOver and (Outlook<>nil)
    and Outlook.AnimateOnOver
    and (ImageIndex=StartIndex)
    and (StartIndex>=0)
    and (EndIndex>StartIndex) then
  ImageIndex := StartIndex + 1;
end;

end.
