unit CompGroup;

// %CompGroup : 包含各种“组件集合”

(*****   Code Written By Huang YanLai   *****)

interface

uses messages,classes,SysUtils,controls,extctrls,compItems,
  typUtils,graphics,dialogs, ComWriUtils;

type
  // %TCustomComponentGroup : 组件集合基类
  TCustomComponentGroup = class(TComponent)
  private
    FComponents : TCustomComponentCollection;
    procedure SetComponents(value : TCustomComponentCollection);
    {function GetCount: integer;
    function GetTheComponent(index: integer): TComponent;}
  protected
    property Components : TCustomComponentCollection
      read FComponents write setComponents;
    class function ComponentCollectionClass : TComponentCollectionClass;
      virtual;
    procedure ComponentChanged(Sender : TObject); virtual;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    {property  count : integer read GetCount;
    property  TheComponent[index : integer] : TComponent read GetTheComponent;}
    constructor Create(AOwner: TComponent); override;
    destructor 	destroy; override;
  published
  end;

  // %TComponentGroup : 组件集合
  TComponentGroup = class(TCustomComponentGroup)
  private
    function 	GetComponents: TComponentCollection;
    procedure SetComponents(const Value: TComponentCollection);
  protected
    class function ComponentCollectionClass : TComponentCollectionClass;
      override;
  public
    procedure AddComponent(AComponent : TComponent);
  published
    property Components : TComponentCollection
     read GetComponents write SetComponents;
  end;

  // %TAppearanceGroup : 具有一致外观(字体，颜色)的组件集合
   TAppearanceGroup = class(TComponentGroup)
   private
    Fcolor: TColor;
    Ffont: TFont;
    FFontProperty: string;
    FColorProperty: string;
    procedure Setcolor(const Value: TColor);
    procedure Setfont(const Value: TFont);
    procedure SetColorProperty(const Value: string);
    procedure SetFontProperty(const Value: string);
    function  isColorPropertyStored: boolean;
    function  isFontPropertyStored: boolean;
   protected
     procedure ComponentChanged(Sender : TObject); override;
   public
     constructor  Create(AOwner: TComponent); override;
     destructor   destroy; override;
     procedure    checkColor;
     procedure    CheckFont;
   published
     property     color : TColor read Fcolor write Setcolor;
     property     font:TFont read Ffont write Setfont;
     // new
     property     ColorProperty : string read FColorProperty write SetColorProperty
                    stored isColorPropertyStored;
     property     FontProperty : string read FFontProperty write SetFontProperty
                    stored isFontPropertyStored;
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
   // %TAppearanceProxy : 外观代理，和FontDialog,ColorDialog,ProxyComponent关联。
   //用户鼠标点击以后，出现FontDialog/ColorDialog,修改外观代理的Font/Color，然后通过外观代理修改ProxyComponent的Font/Color
    TAppearanceProxy = class(TPanel)
    private
      FProxyComponent: TComponent;
      FOnFontChanged: TNotifyEvent;
      FOnColorChanged: TNotifyEvent;
      FFontDialog: TFontDialog;
      FColorDialog: TColorDialog;
      FConfigFontOn: TConfigOnEvent;
      FConfigColorOn: TConfigOnEvent;
      FFontProperty: string;
      FColorProperty: string;
      FInitFromComponent: boolean;
      FUpdating:boolean;
      procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
      procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
      procedure SetProxyComponent(const Value: TComponent);
      procedure configOn(event :TConfigOnEvent);
      procedure SetConfigColorOn(const Value: TConfigOnEvent);
      procedure SetConfigFontOn(const Value: TConfigOnEvent);
      procedure SetColorDialog(const Value: TColorDialog);
      procedure SetFontDialog(const Value: TFontDialog);

      procedure SetColorProperty(const Value: string);
      procedure SetFontProperty(const Value: string);
      function  isColorPropertyStored: boolean;
      function  isFontPropertyStored: boolean;
      procedure SynchronizeComponent;
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

      // new
      property ColorProperty : string read FColorProperty write SetColorProperty
                  stored isColorPropertyStored;
      property FontProperty : string read FFontProperty write SetFontProperty
                  stored isFontPropertyStored;
      property InitFromComponent : boolean read FInitFromComponent write FInitFromComponent default false;
   end;

const
  StdColorProp = 'Color';
  StdFontProp = 'Font';

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
{
function TCustomComponentGroup.GetCount: integer;
begin
  result := Components.Count;
end;

function TCustomComponentGroup.GetTheComponent(index: integer): TComponent;
begin
  result := FComponents.Components[index];
end;
}
// TComponentGroup

procedure TComponentGroup.AddComponent(AComponent: TComponent);
begin
  Components.AddComponent(AComponent);
end;

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
  FColorProperty := StdColorProp ;
  FFontProperty := StdFontProp ;
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
                    SetOrdProperty(AComponent,ColorProperty,color);
                    SetClassProperty(AComponent,FontProperty,font);
                  end;
         end
    else begin
           checkcolor;
           checkfont;
         end;
end;

procedure TAppearanceGroup.checkColor;
begin
  components.SetComponentsOrdProp(ColorProperty,color);
end;

procedure TAppearanceGroup.CheckFont;
begin
  components.SetComponentsClassProp(FontProperty,font);
end;

procedure TAppearanceGroup.SetColorProperty(const Value: string);
begin
  if (CompareText(FColorProperty,Value)<>0) and (Value<>'') then
  begin
    FColorProperty := Value;
    checkColor;
  end;
end;

procedure TAppearanceGroup.SetFontProperty(const Value: string);
begin
  if (CompareText(FFontProperty,Value)<>0) and (Value<>'') then
  begin
    FFontProperty := Value;
    checkFont;
  end;
end;

function TAppearanceGroup.isColorPropertyStored: boolean;
begin
  result := CompareText(FColorProperty,StdColorProp)<>0;
end;

function TAppearanceGroup.isFontPropertyStored: boolean;
begin
  result := CompareText(FFontProperty,StdFontProp)<>0;
end;

{ TAppearanceProxy }

procedure TAppearanceProxy.CheckColor;
begin
  if ProxyComponent<>nil
    then SetOrdProperty(ProxyComponent,ColorProperty,color);
end;

procedure TAppearanceProxy.CheckFont;
begin
  if ProxyComponent<>nil
    then SetClassProperty(ProxyComponent,FontProperty,font);
end;

procedure TAppearanceProxy.CMColorChanged(var Message: TMessage);
begin
  if not FUpdating then
  begin
    checkColor;
    if assigned(OnColorChanged)
      then OnColorChanged(self);
  end;
  inherited;
end;

procedure TAppearanceProxy.CMFontChanged(var Message: TMessage);
begin
  if not FUpdating then
  begin
    checkfont;
    if assigned(OnfontChanged)
      then OnfontChanged(self);
  end;
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
  FColorProperty := StdColorProp ;
  FFontProperty := StdFontProp ;
  FInitFromComponent := false;
  FUpdating := false;
end;

function TAppearanceProxy.isColorPropertyStored: boolean;
begin
  result := CompareText(FColorProperty,StdColorProp)<>0;
end;

function TAppearanceProxy.isFontPropertyStored: boolean;
begin
  result := CompareText(FFontProperty,StdFontProp)<>0;
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

procedure TAppearanceProxy.SetColorProperty(const Value: string);
begin
  if (CompareText(FColorProperty,Value)<>0) and (Value<>'') then
  begin
    FColorProperty := Value;
    //checkColor;
    SynchronizeComponent;
  end;
end;

procedure TAppearanceProxy.SetFontProperty(const Value: string);
begin
  if (CompareText(FFontProperty,Value)<>0) and (Value<>'') then
  begin
    FFontProperty := Value;
    //checkFont;
    SynchronizeComponent;
  end;
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
         SynchronizeComponent;
       end;
end;



procedure TAppearanceProxy.SynchronizeComponent;
var
  NewValue : longint;
  NewFont : TObject;
begin
  if FProxyComponent<>nil then
    if InitFromComponent then
    begin
      FUpdating := true;
      try
        if GetOrdProperty(FProxyComponent,ColorProperty,NewValue) then
          Color := TColor(NewValue);
        NewFont := GetClassProperty(FProxyComponent,FontProperty);
        if NewFont is TFont then
          Font := TFont(NewFont);
      finally
       FUpdating := false;
      end;
    end
    else
    begin
     checkColor;
     checkFont;
    end;
end;

end.
