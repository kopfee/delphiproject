unit Container;

// %Container : 载体

(*****   Code Written By Huang YanLai   *****)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,CMUtils, ComWriUtils;

type
  // %TContainer : 载体
  TContainer = class(TCustomPanel)
  private
    { Private declarations }
    FOnCreate:  TNotifyEvent;
    FOnDestroy: TNotifyEvent;
    FDesigned:  boolean;
    procedure   LoadWhenCreate;
    procedure   SetDesigned(const Value: boolean);
  protected
    { Protected declarations }
    procedure   GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    // %IsAloneDesign : 返回是否是TContainer的子类，这个子类安装到Delphi的设计环境中
    function    IsAloneDesign: boolean;
    procedure   DelphiDesignedComponent(ADesigned : boolean);
  public
    { Public declarations }
    property    Designed : boolean
                  read FDesigned  write SetDesigned;
    constructor Create(AOwner: TComponent); override;
    constructor CreateWithParent(AOwner : TComponent; AParent : TWinControl); virtual;
    destructor 	Destroy; override;
    property 		Align;
  published
    { Published declarations }
    property OnCreate: TNotifyEvent read FOnCreate write FOnCreate ;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy ;
  // not publish "Align"
    property Alignment;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderWidth;
    property BorderStyle;
    property DragCursor;
    property DragMode;
    property Enabled;
    property FullRepaint;
    property Caption;
    property Color;
    property Ctl3D;
    property Font;
    property Locked;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDrag;
  end;

  TContainerClass = class of TContainer;

  { how to use  TContainerProxy.
    (I) create in design time
      (1) in design time
           a) new a container and design it
           b) place a ContainerProxy on a form,
           set its ContainerClassName.
      (2) in runtime , it will automatically load the container.
    (II) create in run time
      In run time, create a ContainerProxy.
        a) set its ContainerClassName and call loadbyClassname
        or  b) loadbyClassname(MyContainerClassName)
        or  c) create my container and assign it to container property.
  }
  // %TContainerProxy : 在设计时代表TContainer的位置大小
  TContainerProxy = class(TPanel)
  private
    FContainer : TContainer;
    FContainerClassName : string;
    procedure SetContainer(value : TContainer);
  protected
    procedure Loaded; override;
  public
    //OwnContainer : boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  // if you set Container, OwnContainer=false
    { if s='' use ContainerClassName.
      if successful ContainerClassName:=s
        and OwnContainer=true
    }
    procedure LoadbyClassname(const s:string);
    procedure ReleaseContainer;
  published
     property ContainerClassName : string
       read FContainerClassName write FContainerClassName;
     property Container : TContainer
      read FContainer write SetContainer;
  end;

  EInvalidClassName = class(Exception);

implementation

uses Consts,MsgFilters
{$ifdef Ver140}
,RTLConsts
{$endif}
  ;

constructor TContainer.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);
  LoadWhenCreate;
  FDesigned := false;
  if IsAloneDesign then
  begin
    ControlStyle := ControlStyle - [csAcceptsControls];
    DelphiDesignedComponent(false);
    Designed := true;
  end;
end;

constructor TContainer.CreateWithParent(AOwner: TComponent;
  AParent: TWinControl);
begin
  inherited Create(AOwner);
  Parent := AParent;
  LoadWhenCreate;
end;

procedure TContainer.LoadWhenCreate;
begin
  ControlStyle := ControlStyle - [csSetCaption];
  // when design time
  // if TContainer as an component not as an form,
  // owner is not TApplication
  if (ClassType <> TContainer) and
    (not (csDesigning in ComponentState)
      //or (Owner=nil) or not (Owner is TApplication)
      or IsAloneDesign
    ) then
  begin
    if not InitInheritedComponent(Self, TContainer) then
      raise EResNotFound.CreateFmt(SResNotFound, [ClassName]);
    try
      if Assigned(FOnCreate) then FOnCreate(Self);
    except
      Application.HandleException(Self);
    end;
  end;
end;

destructor TContainer.Destroy;
begin
  if Assigned(FOnDestroy) then
    try
      FOnDestroy(Self);
    except
      Application.HandleException(Self);
    end;
  inherited Destroy;
end;

function   TContainer.IsAloneDesign: boolean;
begin
  {result := (csDesigning in ComponentState) and
    ((Owner=nil) or not (Owner is TApplication));}
  result := (csDesigning in ComponentState) and
    (Owner is TCustomForm);
  {if result then ShowMessage('Alone')
  else ShowMessage('Not Alone');}
end;

procedure TContainer.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
  inherited GetChildren(Proc, Root);
  CommonGetChildren(Self,Proc,Root);
end;

procedure TContainer.SetDesigned(const Value: boolean);
begin
  if FDesigned<>Value then
  begin
    FDesigned := Value;
    InstallMouseTrans(self,Value);
  end;
end;

type
  TComponentAccess = class(TComponent);

procedure TContainer.DelphiDesignedComponent(ADesigned: boolean);
var
  I: Integer;
begin
  for I := 0 to ComponentCount - 1 do
    TComponentAccess(Components[I]).SetDesigning(ADesigned);
end;

// TContainerProxy
constructor TContainerProxy.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FContainer := nil;
  FContainerClassName := '';
  //OwnContainer := false;
  RegisterRefProp(self,'Container');
end;

destructor TContainerProxy.Destroy;
begin
  //ReleaseContainer;
  inherited destroy;
end;

procedure TContainerProxy.SetContainer(value : TContainer);
begin
  if value<>FContainer
  then begin
         ReleaseContainer;
         FContainer := value;
         if (FContainer<>nil) then
           if not (csDesigning in ComponentState) then
           begin
             FContainer.align := alClient;
             {  insertControl(FContainer);

             		This call may bring a error when program terminate
             because :
             		if FContainer is created by self,
             FContainer.parent is self,
             and FContainer has already been inserted,
             therefore, this call will insert it again!

             }
             FContainer.parent := self;
           end
           else FContainerClassName:= value.className;
         //OwnContainer := false;
         referTo(value);
       end;
end;

procedure TContainerProxy.LoadbyClassname(const s:string);
var
  AClass : TContainerClass;
  LoadClassName : string;
begin
  if (s='')
    then LoadClassName:=ContainerClassName
    else LoadClassName:=s;
  if LoadClassName='' then exit;
  AClass := TContainerClass(GetClass(LoadClassName));
  if AClass=nil then
    raise EInvalidClassName.create('Invalid Class Name!(Maybe unregister)');
  //Container := AClass.create(self);
  Container := AClass.CreateWithParent(self,self);
  //OwnContainer := true;
  ContainerClassName := LoadClassName;
end;

procedure TContainerProxy.Loaded;
begin
  inherited loaded;
  if not (csdesigning in ComponentState) and (FContainer=nil)
    then LoadbyClassname('');
end;

procedure TContainerProxy.ReleaseContainer;
begin
  //if OwnContainer and (FContainer<>nil)
  if (FContainer<>nil)  and (FContainer.owner=self)
    then begin
           //OwnContainer := false;
           if not (csDestroying in FContainer.componentState)
             then FContainer.free;
           FContainer := nil;
         end;
end;


end.
