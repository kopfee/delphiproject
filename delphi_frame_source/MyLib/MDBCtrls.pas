unit MDBCtrls;

{
  Muliti-Usage Data-Aware Controls
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask,DB,DBCtrls,ComWriUtils;

type
  //TMDBCustomEdit = class(TCustomMaskEdit)
  TMDBCustomEdit = class(TMaskEdit)
  private
    { Private declarations }

  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
  published
    { Published declarations }
    property BevelEdges;
    property BevelInner;
    property BevelOuter;
    property BevelKind;
    property BevelWidth;
  end;

  TCustomBevelStyles = class;

  TBevelStyle = class(TPersistent)
  private
    FBevelInner: TBevelCut;
    FBevelOuter: TBevelCut;
    FBevelEdges: TBevelEdges;
    FBevelKind: TBevelKind;
    FBevelWidth: TBevelWidth;
    FOwner: TCustomBevelStyles;
    procedure SetBevelCut(const Index: Integer; const Value: TBevelCut);
    procedure SetBevelEdges(const Value: TBevelEdges);
    procedure SetBevelKind(const Value: TBevelKind);
    procedure SetBevelWidth(const Value: TBevelWidth);
  protected
    property 	Owner : TCustomBevelStyles read FOwner ;
    procedure Changed;
  public
    constructor Create(AOwner : TCustomBevelStyles);
    procedure 	Assign(Source: TPersistent); override;
    procedure 	SetWinControlBevel(WinControl : TWinControl);
  published
    property BevelEdges: TBevelEdges read FBevelEdges write SetBevelEdges;// default [beLeft, beTop, beRight, beBottom];
    property BevelInner: TBevelCut index 0 read FBevelInner write SetBevelCut;// default bvRaised;
    property BevelOuter: TBevelCut index 1 read FBevelOuter write SetBevelCut;// default bvLowered;
    property BevelKind: TBevelKind read FBevelKind write SetBevelKind;// default bkNone;
    property BevelWidth: TBevelWidth read FBevelWidth write SetBevelWidth;// default 1;
  end;

  TInteractMode = (imNormal, // for browse or disabled mode
  	imEditing, // for enabled and input mode
    imFocus);  // for input and focused mode

  TCustomBevelStyles = class(TCompCommonAttrs)
  private
    FNormalStyle: TBevelStyle;
    FFocusStyle: TBevelStyle;
    FEditingStyle: TBevelStyle;
    FOnStyleChanged: TNotifyEvent;
    FEditCtrlContainer: TWinControl;
    FEditing: boolean;
    procedure 	SetStyle(const Index: Integer; const Value: TBevelStyle);
    procedure 	SetEditCtrlContainer(const Value: TWinControl);
    procedure 	SetEditing(const Value: boolean);
  protected
    procedure 	StyleChanged; dynamic;
    procedure 	Notification(AComponent: TComponent;
    								Operation: TOperation); override;
    procedure 	CheckContainer; dynamic;
    procedure 	EditingChanged; dynamic;

    property NormalStyle : TBevelStyle
    					 index 0 read FNormalStyle write SetStyle;
    property EditingStyle : TBevelStyle
    					 index 1 read FEditingStyle write SetStyle;
    property FocusStyle : TBevelStyle
    					 index 2 read FFocusStyle write SetStyle;
    property OnStyleChanged : TNotifyEvent
    						read FOnStyleChanged write FOnStyleChanged ;
    property EditCtrlContainer : TWinControl
    						read FEditCtrlContainer write SetEditCtrlContainer;
    property Editing : boolean read FEditing write SetEditing default false;
  public
  	OldFocusCtrl : TWinControl;
    constructor Create(AOwner : TComponent); override;
    destructor 	destroy; override;
    procedure 	SetCtrlBevel(Ctrl : TWinControl ; InteractMode : TInteractMode);
    procedure 	SetCtrlBevel2(Ctrl : TWinControl ; AEditing : boolean);
    procedure 	SetCtrlBevelEx(Ctrl : TWinControl);
    procedure 	CheckChildCtrls(Ctrl : TWincontrol;
    							ChildClass : TWinControlClass;
                  AEditing:boolean);
    procedure 	CheckChildCtrlsEx(Ctrl : TWincontrol;
    							ChildClass : TWinControlClass);
    procedure   UpdateFocusCtrl;
  published

  end;

  TBevelStyles = class(TCustomBevelStyles)
  published
    property NormalStyle;
    property EditingStyle;
    property FocusStyle;
    property OnStyleChanged;
    property EditCtrlContainer;
    property Editing;
	end;

  TEditingDataLink = class(TDataLink)
  private
    FOnEditingChanged: TNotifyEvent;
  protected
		procedure EditingChanged; override;
  public
    property 	OnEditingChanged : TNotifyEvent
    						read FOnEditingChanged write FOnEditingChanged ;
  end;

  TDBBevelStyles = class(TCustomBevelStyles)
  private
    DataLink : TEditingDataLink;
    procedure 	OnDataLinkEditingChanged(sender : TObject);
    function 		GetDataSource: TDataSource;
    procedure 	SetDataSource(const Value: TDataSource);
  protected
    procedure 	EditingChanged; override;
  public
  	constructor Create(AOwner : TComponent); override;
    destructor 	destroy; override;
  published
    property 	NormalStyle;
    property 	EditingStyle;
    property 	FocusStyle;
    property 	OnStyleChanged;

    property 	DataSource : TDataSource
    						read GetDataSource write SetDataSource;
  end;

//procedure Register;

implementation

uses DrawUtils;
{
procedure Register;
begin
  RegisterComponents('Cools',
  	[TMDBCustomEdit,TBevelStyles,TDBBevelStyles]);
end; }

{ TMDBCustomEdit }

constructor TMDBCustomEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BorderStyle := bsNone;
  //BevelKind := bkSoft;
end;

{ TBevelStyle }

constructor TBevelStyle.Create(AOwner: TCustomBevelStyles);
begin
  inherited Create;
  FOwner := AOwner;
  FBevelEdges := [beLeft, beTop, beRight, beBottom];
  FBevelInner := bvRaised;
  FBevelOuter := bvLowered;
  FBevelWidth := 1;
  FBevelKind := bkNone;
end;

procedure TBevelStyle.Assign(Source: TPersistent);
begin
  if Source is TBevelStyle then
  with Source as TBevelStyle do
  begin
    FBevelInner:=self.FBevelInner;
    FBevelOuter:=self.FBevelOuter;
    FBevelEdges:=self.FBevelEdges;
    FBevelKind:=self.FBevelKind;
    FBevelWidth:=self.FBevelWidth;
    Changed;
  end
  {else
  if Source is TWinControl then
  }
  else
  	inherited	Assign(Source);
end;

procedure TBevelStyle.SetBevelCut(const Index: Integer;
  const Value: TBevelCut);
begin
  case Index of
    0: { BevelInner }
      if Value <> FBevelInner then
      begin
        FBevelInner := Value;
        Changed;
      end;
    1: { BevelOuter }
      if Value <> FBevelOuter then
      begin
        FBevelOuter := Value;
				Changed;
      end;
  end;
end;

procedure TBevelStyle.SetBevelEdges(const Value: TBevelEdges);
begin
  if FBevelEdges <> Value then
  begin
    FBevelEdges := Value;
    Changed;
  end;
end;

procedure TBevelStyle.SetBevelKind(const Value: TBevelKind);
begin
  if  FBevelKind <> Value then
  begin
		FBevelKind := Value;
    Changed;
  end;
end;

procedure TBevelStyle.SetBevelWidth(const Value: TBevelWidth);
begin
  if FBevelWidth <> Value then
  begin
    FBevelWidth := Value;
  end;
end;

procedure TBevelStyle.Changed;
begin
  if FOwner<>nil then
	  FOwner.StyleChanged;
end;

type
	TWinControlAccess = class(TWinControl);

procedure TBevelStyle.SetWinControlBevel(WinControl: TWinControl);
begin
  if WinControl<>nil then
  with TWinControlAccess(WinControl) do
  begin
    BevelInner:=self.FBevelInner;
    BevelOuter:=self.FBevelOuter;
    BevelEdges:=self.FBevelEdges;
    BevelKind:=self.FBevelKind;
    BevelWidth:=self.FBevelWidth;
  end;
end;

{ TCustomBevelStyles }

constructor TCustomBevelStyles.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNormalStyle:= TBevelStyle.Create(self);
  FFocusStyle:= TBevelStyle.Create(self);
  FEditingStyle:= TBevelStyle.Create(self);
  with FFocusStyle do
  begin
    FBevelInner := bvLowered;
    FBevelKind := bkTile;
    FBevelWidth := 2;
  end;
  with FEditingStyle do
  begin
    FBevelEdges := [beBottom];
    FBevelInner := bvLowered;
    FBevelOuter := bvRaised;
    FBevelKind := bkTile;
    FBevelWidth := 2;
  end;
end;

destructor TCustomBevelStyles.destroy;
begin
	FEditingStyle.free;
	FFocusStyle.free;
	FNormalStyle.free;
  inherited destroy;
end;

procedure TCustomBevelStyles.SetStyle(const Index: Integer;
  const Value: TBevelStyle);
begin
  case index of
    0 : if FNormalStyle<>Value then FNormalStyle.Assign(Value);
    1 : if FEditingStyle<>Value then FEditingStyle.Assign(Value);
    2 : if FFocusStyle<>Value then FFocusStyle.Assign(Value);
  end;
end;


procedure TCustomBevelStyles.SetCtrlBevel(Ctrl: TWinControl;
  InteractMode: TInteractMode);
begin
  case InteractMode of
    imNormal  : NormalStyle.SetWinControlBevel(Ctrl);
  	imEditing : EditingStyle.SetWinControlBevel(Ctrl);
    imFocus	: FocusStyle.SetWinControlBevel(Ctrl);
  end;
end;

procedure TCustomBevelStyles.SetCtrlBevel2(Ctrl: TWinControl; AEditing: boolean);
begin
  if ctrl<>nil then
  begin
    if Aediting then
    	if Ctrl.focused then
				SetCtrlBevel(ctrl,imFocus)
      else
        if Ctrl.enabled then
					SetCtrlBevel(ctrl,imEditing)
        else
					SetCtrlBevel(ctrl,imNormal)
    else
			SetCtrlBevel(ctrl,imNormal);
  end;
end;

procedure TCustomBevelStyles.SetCtrlBevelEx(Ctrl: TWinControl);
begin
  SetCtrlBevel2(Ctrl,FEditing);
end;


procedure TCustomBevelStyles.StyleChanged;
begin
  CheckContainer;
  if Assigned(FOnStyleChanged) then
  	FOnStyleChanged(self);
end;

procedure TCustomBevelStyles.CheckChildCtrls(Ctrl: TWincontrol;
	ChildClass : TWinControlClass;
  AEditing: boolean);
var
	i : integer;
begin
  for i:=0 to Ctrl.ControlCount-1 do
  begin
  	if ctrl.controls[i] is ChildClass then
      SetCtrlBevel2(TWinControl(ctrl.controls[i]),AEditing);
    if ctrl.controls[i] is TWincontrol then
			CheckChildCtrls(TWincontrol(ctrl.controls[i]),
      ChildClass,AEditing);
  end;
end;

procedure TCustomBevelStyles.CheckChildCtrlsEx(Ctrl: TWincontrol;
  ChildClass: TWinControlClass);
begin
  CheckChildCtrls(Ctrl,ChildClass,FEditing);
end;

procedure TCustomBevelStyles.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (AComponent=FEditCtrlContainer)
  	and (Operation=opRemove) then
     FEditCtrlContainer := nil;
end;

procedure TCustomBevelStyles.SetEditCtrlContainer(const Value: TWinControl);
begin
  if FEditCtrlContainer <> Value then
  begin
    FEditCtrlContainer := Value;
    if FEditCtrlContainer<>nil then
    	FEditCtrlContainer.FreeNotification(self);
    CheckContainer;
  end;
end;

procedure TCustomBevelStyles.CheckContainer;
begin
  if FEditCtrlContainer<>nil then
    CheckChildCtrlsEx(FEditCtrlContainer,TCustomEdit);
end;

procedure TCustomBevelStyles.SetEditing(const Value: boolean);
begin
  if FEditing<>value then
  begin
    FEditing := Value;
    EditingChanged;
  end;
end;


procedure TCustomBevelStyles.EditingChanged;
begin
  CheckContainer;
end;

procedure TCustomBevelStyles.UpdateFocusCtrl;
begin
  if OldFocusCtrl<>nil then
  	SetCtrlBevelEx(OldFocusCtrl);
  OldFocusCtrl := Screen.ActiveControl;
  if OldFocusCtrl<>nil then
		SetCtrlBevelEx(OldFocusCtrl);
end;

{ TEditingDataLink }

procedure TEditingDataLink.EditingChanged;
begin
  inherited EditingChanged;
  if Assigned(FOnEditingChanged) then
  	OnEditingChanged(self);
end;

{ TDBBevelStyles }

constructor TDBBevelStyles.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DataLink := TEditingDataLink.Create;
  DataLink.OnEditingChanged := OnDataLinkEditingChanged;
end;

destructor TDBBevelStyles.destroy;
begin
  DataLink.free;
  inherited destroy;
end;

type
	TDataSourceAccess = class(TDataSource);

procedure TDBBevelStyles.EditingChanged;
var
	i : integer;
begin
  if Datalink.DataSource<>nil then
  with TDataSourceAccess(Datalink.DataSource) do
  	for i:=0 to DataLinks.count-1 do
      if TObject(DataLinks[i]) is TFieldDataLink then
      	with TFieldDataLink(DataLinks[i]) do
        	if Control is TCustomEdit then
            SetCtrlBevelEx(TWinControl(Control));
end;

function TDBBevelStyles.GetDataSource: TDataSource;
begin
  result := Datalink.DataSource;
end;

procedure TDBBevelStyles.OnDataLinkEditingChanged(sender: TObject);
begin
  Editing := Datalink.Editing;
end;

procedure TDBBevelStyles.SetDataSource(const Value: TDataSource);
begin
  Datalink.DataSource := value;
end;

end.
