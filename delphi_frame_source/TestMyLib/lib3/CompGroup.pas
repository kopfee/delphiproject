unit CompGroup;

interface

uses messages,classes,controls,extctrls,compItems,
  typUtils,graphics,dialogs, ComWriUtils;

type

  TCustomComponentGroup = class(TComponent)
  private
    FComponents : TCustomComponentCollection;
    procedure SetComponents(value : TCustomComponentCollection);
  protected
    property Components : TCustomComponentCollection
      read FComponents write setComponents;
    class function ComponentCollectionClass : TComponentCollectionClass;
      virtual;
    procedure ComponentChanged(Sender : TObject); virtual;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor 	destroy; override;
  published
  end;

  TComponentGroup = class(TCustomComponentGroup)
  private
    function 	GetComponents: TComponentCollection;
    procedure SetComponents(const Value: TComponentCollection);
  protected
    class function ComponentCollectionClass : TComponentCollectionClass;
      override;
  published
    property Components : TComponentCollection
     read GetComponents write SetComponents;
  end;

   TAppearanceGroup = class(TComponentGroup)
   private
    Fcolor: TColor;
    Ffont: TFont;
    procedure Setcolor(const Value: TColor);
    procedure Setfont(const Value: TFont);
   protected
     procedure ComponentChanged(Sender : TObject); override;
   public
     constructor Create(AOwner: TComponent); override;
     destructor destroy; override;
     procedure checkColor;
     procedure CheckFont;
   published
     property color : TColor read Fcolor write Setcolor;
     property font:TFont read Ffont write Setfont;
   end;

   TConfigOnEvent = (coeNone,coeLeftClick,coeRightClick,coeLeftDblClick,coeRightDblClick);
   {
       TAppearanceProxy is proxy for Appearance.
       TAppearanceProxy is descendent from TPanel.
       ProxyComponent.color is the same color of TAppearanceProxy.
       ProxyComponent.font is the same font of TAppearanceProxy.
       ProxyComponent can be a label, a editbox or a TAppearanceGroup.
       Method ConfigColor and ConfigFont will bring about a dialog to
     config its color or font.(Note : you must set colorDialog
     and fontDialog property.
       Events are OnColorChanged and OnFontChanged.
       If property ConfigColorOn is coeLeftClick and you left click ths
     panel , Method ConfigColor will be called automatically.ConfigFontOn
     is alike. Their valid values are :
       coeNone,coeLeftClick,coeRightClick,coeLeftDblClick,coeRightDblClick.
   }
   TAppearanceProxy = class(TPanel)
   private
     FProxyComponent: TComponent;
     FOnFontChanged: TNotifyEvent;
     FOnColorChanged: TNotifyEvent;
     FFontDialog: TFontDialog;
     FColorDialog: TColorDialog;
     FConfigFontOn: TConfigOnEvent;
     FConfigColorOn: TConfigOnEvent;
     procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
     procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
     procedure SetProxyComponent(const Value: TComponent);
     procedure configOn(event :TConfigOnEvent);
    procedure SetConfigColorOn(const Value: TConfigOnEvent);
    procedure SetConfigFontOn(const Value: TConfigOnEvent);
    procedure SetColorDialog(const Value: TColorDialog);
    procedure SetFontDialog(const Value: TFontDialog);

   protected
     {procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;}
     procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
   public
     constructor Create(AOwner: TComponent); override;
     procedure CheckFont;
     procedure CheckColor;
     // configXXXX show a dialog to config color or font
     // you must set ColorDialog and FontDialog
     procedure ConfigColor;
     procedure ConfigFont;
   published
     Property OnColorChanged:TNotifyEvent read FOnColorChanged write FOnColorChanged ;
     property OnFontChanged:TNotifyEvent read FOnFontChanged write FOnFontChanged ;
     property ProxyComponent : TComponent read FProxyComponent write SetProxyComponent;
     property ColorDialog : TColorDialog  read FColorDialog write SetColorDialog;
     property FontDialog : TFontDialog  read FFontDialog write SetFontDialog;
     // ConfigXXXOn decides which event hapents  configXXX will be called.
     property ConfigColorOn : TConfigOnEvent  read FConfigColorOn write SetConfigColorOn;
     property ConfigFontOn : TConfigOnEvent  read FConfigFontOn write SetConfigFontOn;
   end;

implementation

constructor TCustomComponentGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FComponents := ComponentCollectionClass.create(self);
  FComponents.OnComponentChanged := ComponentChanged;
end;

class function TCustomComponentGroup.ComponentCollectionClass : TComponentCollectionClass;
begin
  result := TCustomComponentCollection;
end;

destructor TCustomComponentGroup.destroy;
begin
  FComponents.free;
  inherited destroy;
end;

procedure TCustomComponentGroup.SetComponents(value : TCustomComponentCollection);
begin
  FComponents.assign(value);
end;

procedure TCustomComponentGroup.ComponentChanged(Sender: TObject);
begin

end;

procedure TCustomComponentGroup.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  components.Notification(AComponent,Operation);
end;

// TComponentGroup
class function TComponentGroup.ComponentCollectionClass : TComponentCollectionClass;
begin
  result := TComponentCollection;
end;

function TComponentGroup.GetComponents: TComponentCollection;
begin
  result := TComponentCollection(inherited components);
end;

procedure TComponentGroup.SetComponents(const Value: TComponentCollection);
begin
  inherited components := value;
end;

{ TAppearanceGroup }

constructor TAppearanceGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColor := clBtnFace;
  FFont := TFont.create;
end;

destructor TAppearanceGroup.destroy;
begin
  FFont.free;
  inherited destroy;
end;

procedure TAppearanceGroup.Setcolor(const Value: TColor);
begin
  if fcolor<>value
    then begin
           Fcolor := Value;
           ComponentChanged(nil);
         end;
end;

procedure TAppearanceGroup.Setfont(const Value: TFont);
begin
  if FFont<>value
    then begin
           Ffont.assign(Value);
           ComponentChanged(nil);
         end;
end;

procedure TAppearanceGroup.ComponentChanged(Sender: TObject);
var
  AComponent : TComponent;
begin
  if sender<>nil
    then begin
           AComponent :=(sender as TCICustomComponent).component;
           if AComponent<>nil
             then begin
                    SetOrdProperty(AComponent,'color',color);
                    SetClassProperty(AComponent,'font',font);
                  end;
         end
    else begin
           checkcolor;
           checkfont;
         end;
end;

procedure TAppearanceGroup.checkColor;
begin
  components.SetComponentsOrdProp('color',color);
end;

procedure TAppearanceGroup.CheckFont;
begin
  components.SetComponentsClassProp('font',font);
end;

{ TAppearanceProxy }

procedure TAppearanceProxy.CheckColor;
begin
  if ProxyComponent<>nil
    then SetOrdProperty(ProxyComponent,'color',color);
end;

procedure TAppearanceProxy.CheckFont;
begin
  if ProxyComponent<>nil
    then SetClassProperty(ProxyComponent,'font',font);
end;

procedure TAppearanceProxy.CMColorChanged(var Message: TMessage);
begin
  checkColor;
  if assigned(OnColorChanged)
    then OnColorChanged(self);
  inherited;
end;

procedure TAppearanceProxy.CMFontChanged(var Message: TMessage);
begin
  checkfont;
  if assigned(OnfontChanged)
    then OnfontChanged(self);
  inherited;
end;

procedure TAppearanceProxy.ConfigColor;
begin
  if ColorDialog<>nil
  then begin
         ColorDialog.color := color;
         if ColorDialog.execute
           then color := ColorDialog.color;
       end;
end;

procedure TAppearanceProxy.ConfigFont;
begin
  if fontDialog<>nil
  then begin
         fontDialog.font := font;
         if fontDialog.execute
           then font := fontDialog.font;
       end;
end;

procedure TAppearanceProxy.configOn(event: TConfigOnEvent);
begin
  if ConfigColorOn=event then configColor;
  if configFontOn=event then configFont;
end;

constructor TAppearanceProxy.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  registerRefProp(self,'FontDialog');
  registerRefProp(self,'ColorDialog');
  registerRefProp(self,'ProxyComponent');
end;

procedure TAppearanceProxy.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button,shift,x,y);
  if ssdouble in shift
  then begin
         if button=mbLeft then configOn(coeLeftDblClick)
         else if button=mbRight then configOn(coeRightDblClick);
       end
  else begin
         if button=mbLeft then configOn(coeLeftClick)
         else if button=mbRight then configOn(coeRightClick);
       end;
end;
{
procedure TAppearanceProxy.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if operation=opRemove
  then if AComponent=ProxyComponent then ProxyComponent:=nil
  else if AComponent=ColorDialog then ColorDialog:=nil
  else if AComponent=FontDialog then FontDialog:=nil
end;
}

procedure TAppearanceProxy.SetColorDialog(const Value: TColorDialog);
begin
  FColorDialog := Value;
  referTo(value);
end;

procedure TAppearanceProxy.SetConfigColorOn(const Value: TConfigOnEvent);
begin
  FConfigColorOn := Value;
end;

procedure TAppearanceProxy.SetConfigFontOn(const Value: TConfigOnEvent);
begin
  FConfigFontOn := Value;
end;

procedure TAppearanceProxy.SetFontDialog(const Value: TFontDialog);
begin
  FFontDialog := Value;
  referTo(value);
end;

procedure TAppearanceProxy.SetProxyComponent(const Value: TComponent);
begin
  if FProxyComponent<>value
  then begin
         FProxyComponent := Value;
         checkColor;
         checkFont;
       end;
end;

end.
