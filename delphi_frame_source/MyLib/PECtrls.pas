unit PECtrls;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,ComWriUtils,TypInfo,TypUtils,LibMessages,checklst;

const
	pe_UpdateProperties = 1;
	pe_RefreshProperties = 2;

type
// Object Run-Time Properties Editor
	TObjectEditor = class(TCompCommonAttrs)
  private
    FProperties: TPropertyAnalyse;
    FImmediate: boolean;
    procedure 	SetEditingObject(const Value: TObject);
    function 		GetEditingObject: TObject;
  protected

  public
    constructor Create(AOwner : TComponent); override;
    function		Available : boolean;
    property 		Properties : TPropertyAnalyse read FProperties;
    // =>EditingObject
    procedure 	UpdateProps;
    // EditingObject =>
    procedure 	RefreshProps;
    property 		EditingObject: TObject
    							read GetEditingObject write SetEditingObject;
  published
    property 		Immediate : boolean read FImmediate write FImmediate;
  end;

// Component Run-Time Properties Editor
  TCompEditor = class(TObjectEditor)
  private
    function 	GetEditingComponent: TComponent;
    procedure SetEditingComponent(const Value: TComponent);
  public

  protected
  	procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  published
    property 	EditingComponent : TComponent
						    	read GetEditingComponent write SetEditingComponent;
  end;

// The Base Class of Run-Time Property Editor
  TCustomPELink = class(TComponent)
  private
    FSource: 	TObjectEditor;
    FPropName: string;
    FProp: TProperty;
    FCtrlPropName: string;
    FEditCtrl: TControl;
    FUpdating : boolean;
    FCtrlProp: TProperty;
    FEventName: string;
    FEventProp: TProperty;
    procedure SetSource(const Value: TObjectEditor);
    procedure ObjPropChanged;
    procedure LMComAttrsChanged(var message : TMessage);message LM_ComAttrsChanged;
    procedure LMComAttrsNotify(var message : TMessage);message LM_ComAttrsNotify;
    procedure SetPropName(const Value: string);
    function 	GetEditingObject: TObject;
    // called when user changed the value of the property of the EditingObject
    procedure PropValueChanged;
    procedure SetCtrlPropName(const Value: string);
    procedure SetEditCtrl(const Value: TControl);
    procedure SetEventName(const Value: string);
  protected
  	property 	Prop : TProperty read FProp;
    property 	CtrlProp : TProperty read FCtrlProp;
    property	EventProp : TProperty read FEventProp;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure InternalRefrshProp; virtual;
    procedure InstallEventHandler(installed : boolean); virtual;

    property 	Source : TObjectEditor
    						read FSource write SetSource;
    property 	PropName : string
    						read FPropName write SetPropName;
    property 	EditCtrl : TControl
    						read FEditCtrl write SetEditCtrl;
    property 	EventName : string
    						read FEventName write SetEventName;
    property 	CtrlPropName : string
    						read FCtrlPropName write SetCtrlPropName;
  public
  	constructor Create(AOwner : TComponent); override;
    destructor 	destroy; override;
    function 		Available : boolean; virtual;
    property		EditingObject : TObject read GetEditingObject;
    procedure 	DoOnChange(sender : TObject);

    procedure 	RefreshProp;
    procedure 	UpdateProp; virtual;
  published

	end;

  TPELink = class(TCustomPELink)
  private

  protected

  public

  published
    property 	Source;
    property 	PropName;
    property 	EditCtrl;
    property 	EventName;
    property 	CtrlPropName;
  end;

  TPEComboLink = class(TCustomPELink)
  private
    FAutoList: boolean;
    function 	GetCustomComboBox: TCustomComboBox;
    procedure SetCustomComboBox(const Value: TCustomComboBox);
    procedure SetAutoList(const Value: boolean);
  protected
  	procedure InternalRefrshProp; override;
  public
  	constructor Create(AOwner : TComponent); override;
    function 	Available : boolean; override;
    procedure UpdateProp; override;
  published
    property 	Source;
    property 	PropName;
    property 	ComboBox : TCustomComboBox
    						read GetCustomComboBox write SetCustomComboBox;
    property 	AutoList : boolean read FAutoList write SetAutoList default true;
  end;

  TCheckListLink = class(TCustomPELink)
  private
    FAutoList: boolean;
    function 	GetCheckList: TCheckListBox;
    procedure SetCheckList(const Value: TCheckListBox);
    procedure SetAutoList(const Value: boolean);
  protected
  	procedure 	InternalRefrshProp; override;
  public
  	constructor Create(AOwner : TComponent); override;
    function 	Available : boolean; override;
    procedure UpdateProp; override;
  published
    property 	Source;
    property 	PropName;
    property 	CheckList: TCheckListBox
    						read GetCheckList write SetCheckList;
    property 	AutoList : boolean read FAutoList write SetAutoList default true;
  end;

procedure Register;

implementation

uses ExtUtils;

procedure Register;
begin
  RegisterComponents('PropEditors',
	  [TCompEditor,TPELink,
    TPEComboLink,TCheckListLink]);
end;

{ TObjectEditor }

function TObjectEditor.Available: boolean;
begin
  result := Properties.AnalysedObject<>nil;
end;

constructor TObjectEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FProperties := TPropertyAnalyse.create;
end;


function TObjectEditor.GetEditingObject: TObject;
begin
  result := Properties.AnalysedObject;
end;


procedure TObjectEditor.RefreshProps;
begin
  NotifyClients(pe_RefreshProperties);
end;

procedure TObjectEditor.SetEditingObject(const Value: TObject);
begin
  if  Properties.AnalysedObject<> Value then
  begin
    Properties.AnalysedObject := Value;
    PropChanged;
  end;
end;

procedure TObjectEditor.UpdateProps;
begin
  NotifyClients(pe_UpdateProperties);
end;

{ TCompEditor }

function TCompEditor.GetEditingComponent: TComponent;
begin
  result := TComponent(EditingObject);
end;

procedure TCompEditor.SetEditingComponent(const Value: TComponent);
begin
  EditingObject := value;
  if value<>nil then
    value.FreeNotification(self);
end;

procedure TCompEditor.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (Operation=opRemove)
  	and (AComponent=EditingComponent) then
    EditingObject := nil;
end;

{ TPECtrl }

constructor TCustomPELink.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEditCtrl := nil;
  FProp := TProperty.Create(nil,nil);
  FCtrlProp := TProperty.Create(nil,nil);
  FEventProp:= TProperty.Create(nil,nil);
end;

destructor TCustomPELink.destroy;
begin
	FProp.free;
  FCtrlProp.free;
  FEventProp.free;
  inherited destroy;
end;

function TCustomPELink.Available: boolean;
begin
  {result := (FSource<>nil)
  	and (FSource.Available);
    //and (FPropName<>'');}
  result := FProp.Available
  	and FCtrlProp.Available;
end;

procedure TCustomPELink.ObjPropChanged;
begin
  if (FSource<>nil)
  	and (FSource.Available)
    and (FPropName<>'') then
  begin
    FProp.CreateByName(FSource.EditingObject,
    	FPropName);
    //if FProp.Available then
  end
  else
  	FProp.Create(nil,nil);
  RefreshProp;
end;

procedure TCustomPELink.LMComAttrsChanged(var message: TMessage);
begin
  inherited ;
  if TObject(message.wparam)=FSource then
		ObjPropChanged;
end;

procedure TCustomPELink.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (Operation=opRemove) then
  	if (AComponent=FSource) then
    	Source:=nil
	  else if (AComponent=FEditCtrl) then
    	EditCtrl:=nil;
end;

procedure TCustomPELink.SetSource(const Value: TObjectEditor);
begin
  {if FSource <> Value then
  begin
    FSource := Value;
    if FSource<>nil then
			FSource.FreeNotification(self);
    ObjPropChanged;
  end;}
  if SetCommonAttrsProp(self,TCompCommonAttrs(FSource),value) then
		ObjPropChanged;	
end;

procedure TCustomPELink.SetPropName(const Value: string);
begin
  if FPropName <> Value then
  begin
    FPropName := Value;
    ObjPropChanged;
  end;
end;

function TCustomPELink.GetEditingObject: TObject;
begin
  result := FProp.Instance;
end;

procedure TCustomPELink.PropValueChanged;
begin
  if available and FSource.Immediate then
    UpdateProp;
end;


procedure TCustomPELink.LMComAttrsNotify(var message: TMessage);
begin
  if (TObject(message.wparam)=FSource) and available then
  case message.lparam of
    pe_UpdateProperties : UpdateProp;
    pe_RefreshProperties : RefreshProp;
  end;
end;

procedure TCustomPELink.DoOnChange(sender: TObject);
begin
  if not FUpdating then
	  PropValueChanged;
end;

procedure TCustomPELink.SetCtrlPropName(const Value: string);
begin
  if FCtrlPropName <> Value then
  begin
    FCtrlPropName := Value;
    FCtrlProp.CreateByName(FEditCtrl,FCtrlPropName);
    if Available then RefreshProp;
  end;
end;

procedure TCustomPELink.SetEditCtrl(const Value: TControl);
begin
  if FEditCtrl <> Value then
  begin
  	if (FEditCtrl<>nil) and
    	not (csDesigning in ComponentState) then
	    InstallEventHandler(false);
    FEditCtrl := Value;
    if FEditCtrl<>nil then
			FEditCtrl.FreeNotification(self);
    if (FEditCtrl<>nil) and
    	not (csDesigning in ComponentState) then
	    InstallEventHandler(true);
    FCtrlProp.CreateByName(FEditCtrl,FCtrlPropName);
    if Available then RefreshProp;
  end;
end;

procedure TCustomPELink.RefreshProp;
begin
  if Available then
  begin
	  FUpdating:=true;
  	InternalRefrshProp;
		FUpdating:=false;
  end;
end;

procedure TCustomPELink.InstallEventHandler(installed: boolean);
var
  Event :TNotifyEvent;
begin
  EventProp.CreateByName(FEditCtrl,FEventName);
  if EventProp.Available and
  	not (csDesigning in componentState) then
  	if Installed then
    begin
      Event := DoOnChange;
			EventProp.AsMethod := TMethod(Event);
    end
    else
    begin
      TMethod(Event).Data := nil;
      TMethod(Event).code := nil;
      EventProp.AsMethod:=TMethod(Event);
    end;
end;

procedure TCustomPELink.SetEventName(const Value: string);
begin
  if FEventName <> Value then
  begin
		InstallEventHandler(false);
    FEventName := Value;
    InstallEventHandler(true);
  end;
end;

procedure TCustomPELink.InternalRefrshProp;
begin
  case Prop.PropType of
    ptOrd :  CtrlProp.AsOrd := Prop.AsOrd;
    ptString : CtrlProp.AsString := Prop.AsString;
    ptFloat : CtrlProp.AsFloat := Prop.AsFloat;
    ptClass : CtrlProp.AsObject := Prop.AsObject;
  else
  	;
  end;
end;

procedure TCustomPELink.UpdateProp;
begin
  case Prop.PropType of
    ptOrd :  Prop.AsOrd := CtrlProp.AsOrd;
    ptString : Prop.AsString := CtrlProp.AsString;
    ptFloat : Prop.AsFloat := CtrlProp.AsFloat;
    ptClass : Prop.AsObject := CtrlProp.AsObject;
  else
  	;
  end;
end;

{ TPEComboLink }

function TPEComboLink.Available: boolean;
begin
  result := Prop.Available and (EditCtrl<>nil)
end;

function TPEComboLink.GetCustomComboBox: TCustomComboBox;
begin
  result := TCustomComboBox(EditCtrl);
end;

procedure TPEComboLink.SetCustomComboBox(const Value: TCustomComboBox);
begin
  EditCtrl := value;
end;

type
  TComboBoixAccess = class(TCustomComboBox);

procedure TPEComboLink.InternalRefrshProp;
begin
	with TComboBoixAccess(ComboBox) do
  case Prop.PropType of
    ptString : Text := Prop.AsString;
    ptOrd : if Prop.TypeKind=tkEnumeration then
    				begin
            	Style := csDropDownList;
              if AutoList then
              begin
								Items.Clear;
								Prop.CopyValuesToStrings(Items);
              end;
              ItemIndex := Items.IndexOfObject(
              	TObject(Prop.AsOrd));
            end;
  end;
end;

procedure TPEComboLink.UpdateProp;
begin
	with TComboBoixAccess(ComboBox) do
  case Prop.PropType of
    ptString : Prop.AsString := Text;
    ptOrd : if Prop.TypeKind=tkEnumeration then
    				begin
            	if ItemIndex>=0 then
								Prop.AsOrd := Integer(Items.Objects[ItemIndex]);
            end;
  end;
end;

constructor TPEComboLink.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEventName := 'OnChange';
  FAutoList := true;
end;


procedure TPEComboLink.SetAutoList(const Value: boolean);
begin
  if FAutoList <> Value then
  begin
    FAutoList := Value;
    if FAutoList then RefreshProp;
  end;
end;

{ TCheckListLink }

constructor TCheckListLink.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEventName := 'OnClickCheck';
  FAutoList := true;
end;

function TCheckListLink.Available: boolean;
begin
  result := Prop.Available and (EditCtrl<>nil);
end;

function TCheckListLink.GetCheckList: TCheckListBox;
begin
  result := TCheckListBox(EditCtrl);
end;

procedure TCheckListLink.SetCheckList(const Value: TCheckListBox);
begin
  EditCtrl := Value;
end;

procedure TCheckListLink.InternalRefrshProp;
var
	i : integer;
  ValueOfSet : integer;
  Enum : integer;
begin
  with CheckList do
  if Prop.TypeKind=tkSet then
  begin
    if AutoList then
    begin
			Items.Clear;
			Prop.CopyValuesToStrings(Items);
    end;
    ValueOfSet := Prop.AsOrd;
    for i:=0 to items.count-1 do
    begin
      Enum := Integer(items.Objects[i]);
      Checked[i]:= EnumInSet(Enum,ValueOfSet);
    end;
  end;
end;

procedure TCheckListLink.UpdateProp;
var
	i : integer;
  SmallSet : TSmallSet;
begin
  with CheckList do
  if Prop.TypeKind=tkSet then
  begin
    SmallSet := [];
    for i:=0 to items.count-1 do
      if Checked[i] then
      	include(SmallSet,Integer(items.Objects[i]));
      {else
      	Exclude(SmallSet,Integer(items.Objects[i]))}
    Prop.PutSET(SmallSet);
  end;
end;

procedure TCheckListLink.SetAutoList(const Value: boolean);
begin
  if FAutoList <> Value then
  begin
    FAutoList := Value;
    if FAutoList then RefreshProp;
  end;
end;

end.
