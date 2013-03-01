unit compItems;

// %compItems : 包含对应Component的TCollectionItem和TCollection
(*****   Code Written By Huang YanLai   *****)

interface

uses classes,menus,controls;

type
  TComponentCollection = class;

// My Collection Item that contain a component
// note : override GetDisplayName
// when Component changed , it will change call
// TComponentCollection.ItemComponentChanged
  TCICustomComponent = class(TCollectionItem)
  private
    FComponent : TComponent;
    procedure SetComponent(value : TComponent);
  protected
    function  GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection);override;
    property Component : TComponent read FComponent write SetComponent;
  end;

  TCIComponentClass = class of TCICustomComponent;

// My Collection Item that contain a menuItem
// a simple descendant of TCICustomComponent
TCIComponent = class(TCICustomComponent)
published
  property Component ;
end;

TCIMenuItem = class(TCICustomComponent)
private
  function getMenuItem : TMenuItem;
  procedure SetMenuItem(value : TMenuItem);
published
  property  MenuItem : TMenuItem read getMenuItem write SetMenuItem;
end;

// My Collection Item that contain a control
// a simple descendant of TCICustomComponent
TCIControl = class(TCICustomComponent)
private
  function getControl : TControl;
  procedure SetControl(value : TControl);
published
  property  Control : TControl read getControl write SetControl;
end;

// My custom component collection
// enable user to collect a set of component in design time
// note : it must override GetOwner

// user must create one's own descendant
// method Notification handle AComponent's reference
// when AComponent destoyed.
// OnComponentChanged : called when TCICustomComponent.component changed.
TCustomComponentCollection = class(TCollection)
private
  FOwner : TComponent;
  FOnComponentChanged : TNotifyEvent;
  function getComponent(index:integer) : TComponent;
  procedure SetComponent(index:integer;value : TComponent);
protected
  function GetOwner: TPersistent; override;
  procedure Update(Item: TCollectionItem); override;
  property Components[index:integer]:TComponent
    read  GetComponent write SetComponent;
public
  constructor Create(AOwner: TComponent);
  class function ItemClass : TCIComponentClass; virtual;
  property Owner : TComponent read FOwner;
  // sender is TCICustomComponent
  property  OnComponentChanged : TNotifyEvent
      read FOnComponentChanged write FOnComponentChanged;
  procedure Notification(AComponent: TComponent;Operation: TOperation);
  procedure SetComponentsStrProp(const propName : string; const value : string);
  procedure SetComponentsOrdProp(const propName : string; value : longint);
  procedure SetComponentsClassProp(const propName : string; value : TObject);
end;

TComponentCollectionClass = class of TCustomComponentCollection;

// Component Collection
TComponentCollection = class(TCustomComponentCollection)
private
  function getItems(index:integer) : TCIComponent;
public
  class function ItemClass : TCIComponentClass; override;
  property Items [index:integer]:TCIComponent read GetItems ;
  property Components; default;
  procedure AddComponent(Comp : TComponent);
end;

// MenuItem Collection
// MenuItems[index:integer]:TMenuItem
TMenuItemCollection = class(TCustomComponentCollection)
private
  function getItems(index:integer) : TCIMenuItem;
  function getMenuItem(index:integer) : TMenuItem;
  procedure SetMenuItem(index:integer;value : TMenuItem);
public
  class function ItemClass : TCIComponentClass; override;
  property MenuItems[index:integer]:TMenuItem
    read  GetMenuItem write SetMenuItem; default;
  property Items [index:integer]:TCIMenuItem read GetItems ;
end;

// Control Collection
// Controls[index:integer]:TControl
TControlCollection = class(TCustomComponentCollection)
private
  function getItems(index:integer) : TCIControl;
  function getControl(index:integer) : TControl;
  procedure SetControl(index:integer;value : TControl);
public
  class function ItemClass : TCIComponentClass; override;
  property Controls[index:integer]:TControl
    read  GetControl write SetControl; default;
  property Items [index:integer]:TCIControl read GetItems ;
end;

implementation

uses TypUtils;

const
  SNoComponet = 'No component';

constructor TCICustomComponent.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FComponent := nil;
end;

function TCICustomComponent.GetDisplayName: string;
begin
  if FComponent=nil
    then result:= SNoComponet
    else result:= FComponent.name;
end;

procedure TCICustomComponent.SetComponent(value : TComponent);
begin
  if FComponent<>value
    then begin
      FComponent:=value;
      changed(false);
    end;
end;

function TCIMenuItem.getMenuItem : TMenuItem;
begin
  result := TMenuItem(Component);
end;

procedure TCIMenuItem.SetMenuItem(value : TMenuItem);
begin
  Component := value;
end;

//                 TCIControl
function TCIControl.getControl : TControl;
begin
  result := TControl(Component);
end;

procedure TCIControl.SetControl(value : TControl);
begin
  Component := value;
end;

// TCustomComponentCollection
constructor TCustomComponentCollection.Create(AOwner: TComponent);
begin
  inherited Create(ItemClass);
  FOwner := AOwner;
end;

class function TCustomComponentCollection.ItemClass : TCIComponentClass;
begin
  result := TCICustomComponent;
end;

function TCustomComponentCollection.GetOwner: TPersistent;
begin
  result := FOwner;
end;

procedure TCustomComponentCollection.Update(Item: TCollectionItem);
begin
  if  Assigned(FOnComponentChanged)then
      begin
        FOnComponentChanged(TCICustomComponent(item));
      end;
end;

procedure TCustomComponentCollection.Notification(AComponent: TComponent;Operation: TOperation);
var
  i : integer;
begin
  if Operation = opRemove
  then for i:=0 to count-1 do
        if (items[i] as TCICustomComponent).component=AComponent
          then (items[i] as TCICustomComponent).component:=nil;
end;

function TCustomComponentCollection.getComponent(index:integer) : TComponent;
begin
  result := (items[index]as TCICustomComponent).Component;
end;

procedure TCustomComponentCollection.SetComponent(index:integer;value : TComponent);
begin
  (items[index]as TCICustomComponent).Component := value;
end;

procedure TCustomComponentCollection.SetComponentsStrProp
   (const propName : string; const value : string);
var
  i : integer;
begin
  for i:=0 to count-1 do
    SetStringProperty(Components[i],propName,value);
end;

procedure TCustomComponentCollection.SetComponentsOrdProp
   (const propName : string; value : longint);
var
  i : integer;
begin
  for i:=0 to count-1 do
    SetOrdProperty(Components[i],propName,value);
end;

procedure TCustomComponentCollection.SetComponentsClassProp
   (const propName : string; value : TObject);
var
  i : integer;
begin
  for i:=0 to count-1 do
    SetClassProperty(Components[i],propName,value);
end;

// TComponentCollection

class function TComponentCollection.ItemClass : TCIComponentClass;
begin
  result := TCIComponent;
end;

function TComponentCollection.getItems(index:integer) : TCIComponent;
begin
  result := TCIComponent(inherited items[index]);
end;

procedure TComponentCollection.AddComponent(Comp: TComponent);
var
  NewItem : TCIComponent;
begin
  NewItem := TCIComponent(Add);
  NewItem.Component := Comp;
end;

// TMenuItemCollection

class function TMenuItemCollection.ItemClass : TCIComponentClass;
begin
  result := TCIMenuItem;
end;

function TMenuItemCollection.getItems(index:integer) : TCIMenuItem;
begin
  result := TCIMenuItem(inherited items[index]);
end;

function TMenuItemCollection.getMenuItem(index:integer) : TMenuItem;
begin
  result := items[index].MenuItem;
end;

procedure TMenuItemCollection.SetMenuItem(index:integer;value : TMenuItem);
begin
  items[index].MenuItem := value;
end;

//TControlCollection

class function TControlCollection.ItemClass : TCIComponentClass;
begin
  result := TCIControl;
end;

function TControlCollection.getItems(index:integer) : TCIControl;
begin
  result := TCIControl(inherited items[index]);
end;

function TControlCollection.getControl(index:integer) : TControl;
begin
  result := items[index].Control;
end;

procedure TControlCollection.SetControl(index:integer;value : TControl);
begin
  items[index].Control := value;
end;


end.
