unit AbilityManager;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Menus,Forms, Dialogs,CompItems,dbtables,db, ComWriUtils;

type
{ TCustomAbilityManager
property:
         Enabled,
         Visible,
         VisibleOnEnabled
Note:    if  VisibleOnEnabled is true , 
         set Enabled will automaticall set visible
Event:   
         OnEnableChanged ,
         OnVisibleChanged
You must override method : (call inherited method after your own codes)
         CheckEnabled,
         CheckVisible
Note: See TSimpleAbilityManager.CheckEnabled and so on.
Exp:
         if You change enabled , it will bring a call to CheckEnabled.
          in CheckEnabled , it call OnVisibleChanged        
Note: to make sure assosiated component's ability is corect,
      directly call checkEnabled or  CheckVisible.
}
  TCustomAbilityManager = class(TComponent)
  private
    { Private declarations }
    FEnabled : boolean;
    FVisible  : boolean;
    FVisibleOnEnabled : boolean;
    FOnEnableChanged : TNotifyEvent;
    FOnVisibleChanged : TNotifyEvent;
    procedure setEnabled(value : boolean);
    procedure SetVisible(value : boolean);
    procedure SetVisibleOnEnabled(value : boolean);
  protected
    { Protected declarations }
    procedure InternalCheckEnabled; virtual; abstract;
    procedure InternalCheckVisible; virtual; abstract;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure CheckEnabled;
    procedure CheckVisible;
  published
    { Published declarations }
    property  Enabled : boolean read FEnabled write SetEnabled default true;
    property  Visible : boolean read FVisible write SetVisible default true;
    property VisibleOnEnabled : boolean
              read FVisibleOnEnabled write SetVisibleOnEnabled;
    property OnEnableChanged : TNotifyEvent
              read FOnEnableChanged write FOnEnableChanged;
    property OnVisibleChanged : TNotifyEvent
              read FOnVisibleChanged write FOnVisibleChanged;
  end;

  //  TSimpleAbilityManager have a  MenuItem and a Control,
  // and can control their ability(Visible and Enabled
  // by set TSimpleAbilityManager.visible or enabled.
  TSimpleAbilityManager = class(TCustomAbilityManager)
  private
    FMenuItem : TMenuItem;
    FControl  : TControl;
    procedure SetMenuItem(value : TMenuItem);
    procedure SetControl(value : TControl);
  protected
    {procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;}
    procedure InternalCheckEnabled; override;
    procedure InternalCheckVisible; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property  MenuItem : TMenuItem read FMenuItem write SetMenuItem;
    property  Control : TControl Read FControl write SetControl;
  end;

  // TGroupAbilityManager  have a set of MenuItem and a set of Control,
  // and can control their ability(Visible and Enabled
  // by set TSimpleAbilityManager.visible or enabled.
  // The set of  MenuItem : MenuItems
  // The set of control : Controls
  TGroupAbilityManager = class(TCustomAbilityManager)
  private
    FMenuItems : TMenuItemCollection;
    FControls  : TControlCollection;
    procedure ComponentChanged(Sender : TObject);
    procedure SetMenuItems(value : TMenuItemCollection);
    procedure SetControls(value : TControlCollection);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure InternalCheckEnabled; override;
    procedure InternalCheckVisible; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor destroy; override;
  published
    property  MenuItems : TMenuItemCollection
      read FMenuItems write SetMenuItems;
    property  Controls : TControlCollection
      Read FControls write SetControls;
  end;

  TCustomAbilityProvider = class;

{
 "TCustomAuthorityProvider" provides user's Authority
 that be used by a "TCustomAbilityProvider" to deside
 the ability of a "TCustomAbilityManager".
}

{TCustomAuthorityProvider
 property:
          count : the number of  TCustomAbilityProvider that refer to this
          AbilityProviders : the list of TCustomAbilityProvider that refer to this
 Event:
          OnAuthorityChanged
 You must override method:
          GetAuthorityAsInteger
          GetAuthorityAsString
 if Authority Changed ,you descendant class must call AuthorityChanged
 that will call each TCustomAbilityProvider's CalculateAbility to
 see if the ability of TCustomAbilityProvider should be change,
 than call OnAuthorityChanged.
}
  TCustomAuthorityProvider = class(TComponent)
  private
    FOnAuthorityChanged : TNotifyEvent;
    procedure AddAbilityProvider(ap : TCustomAbilityProvider);
    procedure RemoveAbilityProvider(ap : TCustomAbilityProvider);
    function getCount : integer;
    function getAbilityProviders(index : integer) : TCustomAbilityProvider;
//    procedure SetAbilityProviders(index : integer;value : TCustomAbilityProvider);
  protected
    FAbilityProviders : TList;
    procedure AuthorityChanged;
  public
    constructor create(AOwner: TComponent); override;
    destructor destroy;override;
    property AbilityProviders[index : integer] : TCustomAbilityProvider
      read GetAbilityProviders{write SetAbilityProviders} ;default;
    property Count : integer read GetCount;
    function GetAuthorityAsInteger : integer; virtual; abstract;
    function GetAuthorityAsString : string; virtual; abstract;
  published
    property  OnAuthorityChanged : TNotifyEvent
      read FOnAuthorityChanged write FOnAuthorityChanged;
  end;

  { TSimpleAuthorityProvider
    property:
             AuthorityAsInteger
             AuthorityAsString
  }
  TSimpleAuthorityProvider = class(TCustomAuthorityProvider)
  private
    FAuthorityAsInteger : integer;
    FAuthorityAsString : string;
    procedure SetAuthorityAsInteger(value : integer);
    procedure SetAuthorityAsString(value : string);
  protected
  public
    function GetAuthorityAsInteger : integer;override;
    function GetAuthorityAsString : string;override;
  published
    property AuthorityAsInteger : integer
      read FAuthorityAsInteger write setAuthorityAsInteger;
    property AuthorityAsString : string
      read FAuthorityAsString write setAuthorityAsString;
  end;

  { TCustomAbilityProvider link a TCustomAuthorityProvider 
    and a TCustomAbilityManager.
    When ability may be changed(for example AuthorityProvider is cahnged),
    you shoud call CalculateAbility to respond changes.
    in CalculateAbility:
      call InternalCalc to calculate enabled ,
      if enabled changed, it will call AbilityChanged.
      In AbilityChanged , it calls checkEnabled and OnAbilityChanged.
    property:
             AbilityManager
             AuthorityProvider
             DefaultEnabled  
    event:   OnAbilityChanged.   
    In descendant class , you must override InternalCalc
  }
  TCustomAbilityProvider = class(TComponent)
  private
    FAbilityManager : TCustomAbilityManager;
    FAuthorityProvider: TCustomAuthorityProvider;
    FOnAbilityChanged : TNotifyEvent;
    FDefaultEnabled : boolean;
    procedure SetAbilityManager(value : TCustomAbilityManager);
    procedure SetAuthorityProvider(value : TCustomAuthorityProvider);
    procedure SetEnabled(value : boolean);
    procedure SetDefaultEnabled(value : boolean);
    procedure CalculateAbility;
    // if AuthorityProvider is nil , Enabled value will be DefaultEnabled
    // otherwise simple call InternalCalc, and set enabled value.
    procedure AbilityChanged;
  protected
    FEnabled : boolean;
    {procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;}
    procedure CheckEnabled;
    // InternalCalc is to calculate if ability state
    // Not to assige enabled value in InternalCalc
    // It's return value will be assiged to enabled
    function InternalCalc: boolean;virtual;abstract;
  public
    constructor create(AOwner: TComponent); override;
    destructor destroy;override;
    property Enabled : boolean read FEnabled write SetEnabled;
  published
    property  AbilityManager : TCustomAbilityManager
      read FAbilityManager write setAbilityManager;
    property AuthorityProvider : TCustomAuthorityProvider
      read FAuthorityProvider write SetAuthorityProvider;
    property OnAbilityChanged : TNotifyEvent
      read FOnAbilityChanged write FOnAbilityChanged;
    // if AuthorityProvider is nil , Enabled value will be DefaultEnabled
    property DefaultEnabled : boolean
      read FDefaultEnabled write SetDefaultEnabled default false;
  end;

  { TAbilityProvider
    It's type: (enabled = result)
    aptBitMask :     result := ((AsInteger and AuthorityAsInteger)=AsInteger);
    aptLevelHigher:  result := AuthorityAsInteger>AsInteger ;
    aptLevelLower :  result := AuthorityAsInteger<AsInteger ;
    aptSubString :   result := pos(AsString,AuthorityAsString)>0;
    aptCharAt :      result := AuthorityAsString[asInteger]=asString[1];
    aptCustom :      if Assigned(FOnCustomCalc)
                        then  FOnCustomCalc(self)
                        else  result := DefaultEnabled;
    It overrides InternalCalc.                          
    property: 
              ProviderType
              AsInteger
              AsString
              AuthorityAsInteger(readonly)
              AuthorityAsString(readonly)
   Event :    OnCustomCalc ( when ProviderType=aptCustom,
                           be called in InternalCalc )
  }
  TAbilityProviderType = (aptBitMask,aptLevelHigher,aptLevelLower,aptSubString,
                          aptCharAt,aptCustom);

  TAbilityProvider = class;

  TCalcAbilityEvent = procedure (sender : TAbilityProvider;
    var result : boolean) of object;

  TAbilityProvider = class(TCustomAbilityProvider)
  private
    FProviderType :  TAbilityProviderType;
    FAsInteger : Integer;
    FAsString : String;
    FOnCustomCalc : TCalcAbilityEvent;
    procedure SetAsInteger(value : integer);
    procedure SetAsString(value : String);
    function GetAuthorityAsInteger: integer;
    function GetAuthorityAsString: String;
    procedure SetProviderType(value : TAbilityProviderType);
  protected
    function InternalCalc: boolean; override;
  public
    constructor create(AOwner: TComponent); override;
    property AuthorityAsInteger : integer read GetAuthorityAsInteger;
    property AuthorityAsString : string read GetAuthorityAsString;
  published
    property ProviderType :  TAbilityProviderType
      read FProviderType write SetProviderType default aptCustom;
    property AsInteger : Integer read FAsInteger write SetAsInteger default 0;
    property AsString : String read FAsString write SetAsString;
    property OnCustomCalc : TCalcAbilityEvent
      read FOnCustomCalc write FOnCustomCalc;
  end;

  { TDBAuthorityProvider is database-AuthorityProvider
    It uses a "AuthorityQuery" to find the Authority of a special "UserID".
    AuthorityQuery.SQL like:
   " select authority
    from users
    where UserID=:UserID "
       TDBAuthorityProvider pass UserID to AuthorityQuery.params[0],
    and receive authority from AuthorityQuery.fileds[0].
    Note: if :UserID is integer, the UseID you entered must can be convert
    to integer.
      select return value must be integer or string!
   }
  TAuthorityValueType = (avtInteger,avtString);
  TDBAuthorityProvider = class(TCustomAuthorityProvider)
  private
    FActive : boolean;
    FUserID : string;
    FAuthorityQuery:TQuery;
    FDefaultAuthorityInteger : integer ;
    FDefaultAuthorityString : string;
    FAuthorityAsInteger : integer ;
    FAuthorityAsString : string;
    FAuthorityValueType : TAuthorityValueType;
    FStreamedActive : boolean;
    FautoActive: boolean;
    FSeperateChar: char;
    procedure SetActive(value : boolean);
    procedure SetAuthorityQuery(value : TQuery);
    procedure SetuserID(value : string);
    procedure SetDefaultAuthorityInteger(value : integer);
    procedure SetDefaultAuthoritystring(value : string);
    // set FAuthorityAsInteger and FAuthorityAsString
    // if successful return true , active = true.
    function DoAuthorityQuery:boolean;
    procedure SetautoActive(const Value: boolean);
  protected
    {procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;}
    procedure Loaded; override;
  public
    constructor create(AOwner: TComponent); override;
    property AuthorityValueType : TAuthorityValueType read FAuthorityValueType;
    // QueryAuthority gets the Authority from AuthorityQuery.
    // if successful, return true and active is true.
    function QueryAuthority : boolean;
    function GetAuthorityAsInteger : integer;override;
    function GetAuthorityAsString : string;override;
    procedure TryAutoactive;
  published
    property autoActive : boolean read FautoActive write SetautoActive;
    property Active : boolean read FActive write SetActive;
    property AuthorityQuery:TQuery read FAuthorityQuery write SetAuthorityQuery;
    property UserID : string read FUserID write SetUserID;
    property DefaultAuthorityInteger : integer
      read FDefaultAuthorityInteger write SetDefaultAuthorityInteger;
    property DefaultAuthorityString : string
      read FDefaultAuthoritystring write SetDefaultAuthoritystring;
    property SeperateChar : char read FSeperateChar write FSeperateChar;
  end;

implementation

// TAbilityManager

constructor TCustomAbilityManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FVisible := true;
  FEnabled := true;
  FVisibleOnEnabled := false;
  FOnEnableChanged := nil;
  FOnVisibleChanged := nil;
end;

procedure TCustomAbilityManager.setEnabled(value : boolean);
begin
  if value <> FEnabled
    then begin
      FEnabled := value;
      if FVisibleOnEnabled
        then begin
          FVisible := FEnabled;
          checkVisible;
        end;
      CheckEnabled;
    end;
end;

procedure TCustomAbilityManager.SetVisible(value : boolean);
begin
  if not FVisibleOnEnabled and (value <> FVisible)
    then begin
      FVisible := value;
      CheckVisible;
    end;
end;

procedure TCustomAbilityManager.SetVisibleOnEnabled(value : boolean);
begin
  if FVisibleOnEnabled<>value
    then begin
      FVisibleOnEnabled:=value;
      if FVisibleOnEnabled and (FVisible <> FEnabled)
        then begin
          FVisible := FEnabled;
          checkVisible;
        end;
    end;
end;

procedure TCustomAbilityManager.CheckEnabled;
begin
  if not (csDestroying in componentState)
  then begin
    InternalCheckEnabled;
    if assigned(FOnEnableChanged) then FOnEnableChanged(self);
  end;
end;

procedure TCustomAbilityManager.CheckVisible;
begin
  if not (csDestroying in componentState)
  then begin
    InternalCheckVisible;
    if assigned(FOnVisibleChanged) then FOnVisibleChanged(self);
  end;
end;


constructor TSimpleAbilityManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FControl := nil;
  FMenuItem := nil;
  registerRefProp(self,'Control');
  registerRefProp(self,'MenuItem');
end;

procedure TSimpleAbilityManager.InternalCheckEnabled;
begin
  if FMenuItem<>nil
    then FMenuItem.enabled := FEnabled;
  if FControl<>nil
    then FControl.enabled := FEnabled;
end;

procedure TSimpleAbilityManager.InternalCheckVisible;
begin
  if FMenuItem<>nil
    then FMenuItem.Visible := FVisible;
  if FControl<>nil
    then FControl.Visible := FVisible;
end;

procedure TSimpleAbilityManager.SetMenuItem(value : TMenuItem);
begin
  if value <> FMenuItem
    then begin
      FMenuItem := value;
      if FMenuItem<>nil
        then begin
          FMenuItem.Visible := Visible;
          FMenuItem.enabled := Enabled;
          ReferTo(value);
        end;
    end;
end;

procedure TSimpleAbilityManager.SetControl(value : TControl);
begin
  if value <> FControl
    then begin
      FControl := value;
      if FControl<>nil
        then begin
          FControl.Visible := Visible;
          FControl.enabled := Enabled;
          ReferTo(value);
        end;
    end;
end;
{
procedure TSimpleAbilityManager.Notification(AComponent: TComponent;
      Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if operation=opRemove
    then begin
      if AComponent=FControl then FControl:=nil;
      if AComponent=FMenuItem then FMenuItem:=nil;
    end;
end;
}
constructor TGroupAbilityManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMenuItems := TMenuItemCollection.Create(self);
  FControls  := TControlCollection.create(self);
  FMenuItems.OnComponentChanged := ComponentChanged;
  FControls.OnComponentChanged := ComponentChanged;
end;

destructor TGroupAbilityManager.destroy;
begin
  FControls.free;
  FMenuItems.free;
  inherited destroy;
end;

procedure TGroupAbilityManager.Notification(AComponent: TComponent;
      Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if Operation=opRemove
  then begin
   { for i:=0 to FMenuItems.count-1 do
      if FMenuItems.MenuItems[i] = AComponent
        then FMenuItems.MenuItems[i]:=nil;
    for i:=0 to FControls.count-1 do
      if FControls.Controls[i] = AComponent
        then FControls.Controls[i]:=nil;}
    FMenuItems.Notification(AComponent,Operation);
    FControls.Notification(AComponent,Operation);
  end;
end;

procedure TGroupAbilityManager.InternalCheckEnabled;
var
  i : integer;
begin
  for i:=0 to FMenuItems.count-1 do
    if FMenuItems[i]<>nil then FMenuItems[i].enabled:=enabled;
  for i:=0 to FControls.count-1 do
    if FControls[i]<>nil then FControls[i].enabled:=enabled;
end;

procedure TGroupAbilityManager.InternalCheckVisible;
var
  i : integer;
begin
  for i:=0 to FMenuItems.count-1 do
    if FMenuItems[i]<>nil then FMenuItems[i].visible:=visible;
  for i:=0 to FControls.count-1 do
    if FControls[i]<>nil then FControls[i].visible:=visible;
end;

procedure TGroupAbilityManager.ComponentChanged(Sender : TObject);
var
  AComponent : TComponent;
begin
  if sender<>nil
  then begin
    AComponent :=(sender as TCICustomComponent).component;
    if AComponent<>nil
      then if AComponent is TMenuItem
           then begin
             (AComponent as TMenuItem).visible := visible;
             (AComponent as TMenuItem).enabled := enabled;
           end
           else if AComponent is TControl
           then begin
             (AComponent as TControl).visible := visible;
             (AComponent as Tcontrol).enabled := enabled;
           end;
   end
   else begin
          checkVisible;
          checkEnabled;
        end;
end;

procedure TGroupAbilityManager.SetMenuItems(value : TMenuItemCollection);
begin
  if FMenuItems<>value
    then begin
           FMenuItems.assign(value);
           ComponentChanged(nil);
         end;
end;

procedure TGroupAbilityManager.SetControls(value : TControlCollection);
begin
  if FControls<>value
    then begin
           FControls.assign(value);
           ComponentChanged(nil);
         end;
end;

// TCustomAbilityProvider
constructor TCustomAbilityProvider.create(AOwner: TComponent);
begin
  inherited create(AOwner);
  FAbilityManager := nil;
  FAuthorityProvider:= nil;
  FEnabled := false;
  FOnAbilityChanged := nil;
  FDefaultEnabled := false;
  registerRefProp(self,'AbilityManager');
  registerRefProp(self,'AuthorityProvider');
end;

destructor TCustomAbilityProvider.destroy;
begin
  FOnAbilityChanged := nil;
  // remove from AuthorityProvider's list
  AuthorityProvider:= nil;
  inherited destroy;
end;
{
procedure TCustomAbilityProvider.Notification(AComponent: TComponent;
      Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if Operation=opRemove
    then if AComponent=AbilityManager
           then AbilityManager:=nil
         else if AComponent=AuthorityProvider
                then begin
                  // not direct use AuthorityProvider because of adviding
                  // remove it from a destroying AuthorityProvider's list
                  FAuthorityProvider:=nil;
                  CalculateAbility;
                end;
end;
}
procedure TCustomAbilityProvider.CheckEnabled;
begin
  if AbilityManager<>nil then AbilityManager.enabled := enabled;
end;

procedure TCustomAbilityProvider.SetEnabled(value : boolean);
begin
  if FEnabled <> value
    then begin
           FEnabled := value;
           AbilityChanged;
         end;
end;

procedure TCustomAbilityProvider.SetAbilityManager(value : TCustomAbilityManager);
begin
  if value<>FAbilityManager
    then begin
           FAbilityManager:=value;
           CheckEnabled;
           referTo(value);
         end;
end;

procedure TCustomAbilityProvider.SetAuthorityProvider(value : TCustomAuthorityProvider);
begin
  if value<>FAuthorityProvider
    then begin
      if (FAuthorityProvider<>nil)
        then FAuthorityProvider.removeAbilityProvider(self);
      FAuthorityProvider := value;
      if FAuthorityProvider<>nil
        then FAuthorityProvider.AddAbilityProvider(self);
      CalculateAbility;
      referTo(value);
    end;
end;

procedure TCustomAbilityProvider.SetDefaultEnabled(value : boolean);
begin
  if DefaultEnabled<>value
    then begin
           FDefaultEnabled:=value;
           if FAuthorityProvider=nil then Enabled := DefaultEnabled;
         end;
end;

procedure TCustomAbilityProvider.AbilityChanged;
begin
  checkEnabled;
  if assigned(FOnAbilityChanged) then FOnAbilityChanged(self);
end;

procedure TCustomAbilityProvider.CalculateAbility;
begin
  if  AuthorityProvider=nil
    then Enabled := DefaultEnabled
    else Enabled := InternalCalc;
end;

// TCustomAuthorityProvider
constructor TCustomAuthorityProvider.create(AOwner: TComponent);
begin
  inherited create(AOwner);
  FAbilityProviders := TList.Create;
  FOnAuthorityChanged := nil;
end;


destructor TCustomAuthorityProvider.destroy;
begin
  FAbilityProviders.Free;
  inherited destroy;
end;

procedure TCustomAuthorityProvider.AddAbilityProvider(ap : TCustomAbilityProvider);
begin
  FAbilityProviders.add(ap);
end;

procedure TCustomAuthorityProvider.RemoveAbilityProvider(ap : TCustomAbilityProvider);
begin
  if not (csDestroying in componentState)
    then FAbilityProviders.remove(ap);
end;

function TCustomAuthorityProvider.getCount : integer;
begin
  result := FAbilityProviders.count;
end;

function TCustomAuthorityProvider.getAbilityProviders(index : integer) : TCustomAbilityProvider;
begin
  result := TCustomAbilityProvider(FAbilityProviders.items[index]);
end;

{
procedure TCustomAuthorityProvider.SetAbilityProviders
           (index : integer;value : TCustomAbilityProvider);
begin

end;
}

procedure TCustomAuthorityProvider.AuthorityChanged;
var
  i : integer;
  AP : TCustomAbilityProvider;
begin
  for i:=0 to count-1 do
  begin
    ap := AbilityProviders[i];
    if ap<>nil then ap.calculateAbility;
  end;
  if assigned(FOnAuthorityChanged) then FOnAuthorityChanged(self);
end;

// TSimpleAuthorityProvider
procedure TSimpleAuthorityProvider.SetAuthorityAsInteger(value : integer);
begin
  if value <>FAuthorityAsInteger
  then begin
         FAuthorityAsInteger:=value;
         AuthorityChanged;
       end;
end;

procedure TSimpleAuthorityProvider.SetAuthorityAsString(value : string);
begin
  if value <>FAuthorityAsString
  then begin
         FAuthorityAsString:=value;
         AuthorityChanged;
       end;
end;

function TSimpleAuthorityProvider.GetAuthorityAsInteger : integer;
begin
  result := FAuthorityAsInteger;
end;

function TSimpleAuthorityProvider.GetAuthorityAsString : string;
begin
  result := FAuthorityAsString;
end;

//TAbilityProvider
constructor TAbilityProvider.create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAsInteger := 0;
  FAsString := '';
  FOnCustomCalc := nil;
  FProviderType := aptCustom;
end;

procedure TAbilityProvider.SetAsInteger(value : integer);
begin
  if FAsInteger<>value
    then begin
           FAsInteger:=value;
           CalculateAbility;
         end;
end;

procedure TAbilityProvider.SetAsString(value : String);
begin
  if FAsString<>value
    then begin
           FAsString:=value;
           CalculateAbility;
         end;
end;

procedure TAbilityProvider.SetProviderType(value : TAbilityProviderType);
begin
  if FProviderType<>value
    then begin
           FProviderType:=value;
           CalculateAbility;
         end;
end;

function TAbilityProvider.GetAuthorityAsInteger: integer;
begin
  if AuthorityProvider<>nil
    then result := AuthorityProvider.getAuthorityAsInteger
    else result := 0;
end;

function TAbilityProvider.GetAuthorityAsString: String;
begin
  if AuthorityProvider<>nil
    then result := AuthorityProvider.getAuthorityAsString
    else result := '';
end;

function TAbilityProvider.InternalCalc: boolean;
begin
  case FProviderType of
    aptBitMask :     result := ((AsInteger and AuthorityAsInteger)=AsInteger);
    aptLevelHigher:  result := AuthorityAsInteger>AsInteger ;
    aptLevelLower :  result := AuthorityAsInteger<AsInteger ;
    aptSubString :   result := pos(AsString,AuthorityAsString)>0;
    aptCharAt :      result := AuthorityAsString[asInteger]=asString[1];
    aptCustom :      if Assigned(FOnCustomCalc)
                        then  FOnCustomCalc(self,result)
                        else  result := DefaultEnabled;
  end;
end;


//  TDBAuthorityProvider
constructor TDBAuthorityProvider.create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RegisterRefProp(self,'AuthorityQuery');
  SeperateChar := '|';
end;

procedure TDBAuthorityProvider.SetActive(value : boolean);
begin
  if csReading in ComponentState then
    FStreamedActive := Value
  else
    if value<>FActive
    then begin
           if (value=true) and (AuthorityQuery<>nil)
             then QueryAuthority
             else begin
               FActive:=false;
               AuthorityChanged;
             end;
         end;
end;

procedure TDBAuthorityProvider.Loaded;
begin
  inherited loaded;
  if FStreamedActive
    then begin
           if (AuthorityQuery<>nil) then QueryAuthority;
         end;
end;

procedure TDBAuthorityProvider.SetAuthorityQuery(value : TQuery);
begin
  if value<>FAuthorityQuery
    then begin
      FAuthorityQuery:=value;
      Active := false;
      {if FAuthorityQuery=nil then FActive:=false;
      AuthorityChanged;}
      TryAutoActive;
      referTo(value);
    end;
end;

procedure TDBAuthorityProvider.SetuserID(value : string);
begin
  if value<>FUserID
    then begin
           FUserID := value;
           if Active
             then QueryAuthority
             else tryAutoActive;
         end;
end;

procedure TDBAuthorityProvider.SetDefaultAuthorityInteger(value : integer);
begin
  if value<>FDefaultAuthorityInteger
    then begin
           FDefaultAuthorityInteger := value;
           if not active then AuthorityChanged;
         end;
end;

procedure TDBAuthorityProvider.SetDefaultAuthoritystring(value : string);
begin
  if value<>FDefaultAuthoritystring
    then begin
           FDefaultAuthoritystring := value;
           if not active then AuthorityChanged;
         end;
end;

function TDBAuthorityProvider.QueryAuthority : boolean;
begin
  result := DoAuthorityQuery;
  FActive := result;
  AuthorityChanged;
end;

function TDBAuthorityProvider.DoAuthorityQuery:boolean;
var
  param :  TParam;
  field :  TField;
  StrValue : string;
  intValue : integer;
begin
  result := false;
  AuthorityQuery.active := false;
  param := AuthorityQuery.Params[0];
  if param.datatype in [ftSmallInt,ftInteger,ftWord]
    then Param.asInteger:=StrToInt(FUserID)
    else Param.asString := FUserID;
  try
    AuthorityQuery.active := true;
    AuthorityQuery.first;
    // begin add
    {FAuthorityAsString := FDefaultAuthorityString;
    FAuthorityAsInteger := FDefaultAuthorityInteger;}
    StrValue := '';
    IntValue := FDefaultAuthorityInteger;

    // end add
    {if not AuthorityQuery.EOF
      then begin}
      while not AuthorityQuery.EOF do
      begin
       { FAuthorityAsInteger:=AuthorityQuery.Fields[0].AsInteger;}
        Field := AuthorityQuery.Fields[0];
        if field.dataType in [ftSmallInt,ftInteger,ftWord]
          then begin
                 //FAuthorityAsInteger := field.asInteger;
                 IntValue := field.asInteger;
                 //FAuthorityAsString := IntToStr(FAuthorityAsInteger);
                 //FAuthorityAsString := FDefaultAuthorityString;
                 FAuthorityValueType := avtInteger;
               end
          else begin
                 //if FAuthorityAsString = '' then
                   //FAuthorityAsString := field.asString
                 if StrValue = '' then  
                   StrValue := field.asString
                 else
                  { FAuthorityAsString := FAuthorityAsString
                    + SeperateChar + field.asString;}
                   StrValue := StrValue + SeperateChar + field.asString;
                 //FAuthorityAsInteger := FDefaultAuthorityInteger;
                 FAuthorityValueType := avtString;
               end;
        result := true;
        if FAuthorityValueType = avtString then
          AuthorityQuery.Next
        else
          break;
      end;
    AuthorityQuery.active := false;

    if StrValue<>'' then
      FAuthorityAsString := StrValue
    else
      FAuthorityAsString := FDefaultAuthorityString;

    FAuthorityAsInteger := IntValue;
  except
    AuthorityQuery.active := false;
  end;
end;

function TDBAuthorityProvider.GetAuthorityAsInteger : integer;
begin
  if Active
     then result:=  FAuthorityAsInteger
     else result:=  FDefaultAuthorityInteger;
end;

function TDBAuthorityProvider.GetAuthorityAsString : string;
begin
  if Active
     then result:=  FAuthorityAsstring
     else result:=  FDefaultAuthoritystring;
end;
{
procedure TDBAuthorityProvider.Notification(AComponent: TComponent;
      Operation: TOperation);
begin
  if (operation=opRemove) and (AComponent=AuthorityQuery)
    then AuthorityQuery:=nil;
end;
}

procedure TDBAuthorityProvider.SetautoActive(const Value: boolean);
begin
  if value<>FautoActive then
  begin
    FautoActive := Value;
    tryAutoactive;
  end;
end;

procedure TDBAuthorityProvider.TryAutoactive;
begin
  if autoActive and (AuthorityQuery<>nil) then
  begin
    QueryAuthority;
  end;
end;

end.
