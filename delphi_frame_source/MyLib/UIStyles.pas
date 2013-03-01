unit UIStyles;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> UIStyles
   <What> 提供界面风格(字体颜色)的统一管理
   <Written By> Huang YanLai
   <History>
    2000/10/09 修改了 TUIStyleManager.FindStyleItem 的bug,
      TUICustomStyle.FindStyleItem 和 TUIStyleManager.FindStyleItem对name='',始终返回nil
**********************************************}


interface

uses sysUtils,classes,graphics,CompGroup;

type
  // forward declare

  TUIStyleManager = class;
  TUICustomStyle = class;
  TUICustomStyleItem = class;
  TUICustomStyleItems = class;
  TUICustomStyleItemClass = class of TUICustomStyleItem;


  TUIStyleItem = class;
  //TUIStyleItems = class;
  TUICustomStyleItemLink = class;

  TUIStyleManager = class(TObject)
  private
    FStyles: TList;
    FLinks: TList;
  protected
    procedure   RemoveItem(Item : TUICustomStyleItem);
  public
    constructor Create;
    Destructor  Destroy;override;
    procedure   AddStyle(Style:TUICustomStyle);
    procedure   RemoveStyle(Style:TUICustomStyle);
    procedure   AddLink(Link:TUICustomStyleItemLink);
    procedure   RemoveLink(Link:TUICustomStyleItemLink);
    function    FindStyleItem(Name:string; ItemClass : TUICustomStyleItemClass):TUICustomStyleItem;

    { Changed:
      各种影响界面风格的对象属性发生变化的时候被调用。
  可能的情况和参数
1、界面风格对象(TUICustomStyle)的活动属性发生变化：参数为nil。
2、界面风格元素对象(TUICustomStyleItem)的名字发生变化：参数为包含该界面风格元素对象的界面风格对象(TUICustomStyle)。
3、界面风格元素对象(TUIStyleItem)的字体、颜色发生变化：参数为该界面风格元素对象(TUIStyleItem)。
    }
    procedure   Changed(Target:TObject);
    procedure   ActiveStyles(const StyleName : string);
    property    Styles : TList read FStyles;
    property    Links : TList read FLinks;
  published

  end;

  TUICustomStyle = class(TComponent)
  private
    FActive: boolean;
    FItems: TUICustomStyleItems;
    FStyleName: string;
    FGroupIndex: integer;
    procedure   SetActive(const Value: boolean);
    procedure   SetItems(const Value: TUICustomStyleItems);
    procedure   SetGroupIndex(const Value: integer);
    procedure   CheckGroup;
  protected

  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    class function GetItemClass : TUICustomStyleItemClass; virtual;
    property    Items : TUICustomStyleItems read FItems write SetItems;
    //procedure   Changed(Target:TObject);
    function    FindStyleItem(ItemName:string) :TUICustomStyleItem;
  published
    property    Active : boolean read FActive write SetActive;
    property    StyleName : string read FStyleName write FStyleName;
    property    GroupIndex : integer read FGroupIndex write SetGroupIndex default 0;
  end;

  TUIStyle = class(TUICustomStyle)
  private

  protected

  public
    class function GetItemClass : TUICustomStyleItemClass; override;
  published
    property    Items;
  end;

  TUIStyleItemName = type String;
  TCommandName = type string;

  TUICustomStyleItem = class(TCollectionItem)
  private
    FName: TUIStyleItemName;
    FStyle: TUICustomStyle;
    procedure   SetName(const Value: TUIStyleItemName);
  protected
    function    GetDisplayName: string; override;
    // Changed
    // if KeyChanged=true, it is to say that TUICustomStyle behavior is changed
    procedure   Changed(KeyChanged : Boolean);
  public
    constructor Create(Collection: TCollection); override;
    Destructor  Destroy;override;
    property    Style : TUICustomStyle read FStyle;
  published
    property    Name  : TUIStyleItemName read FName write SetName;
  end;

  TUIStyleItem = class(TUICustomStyleItem)
  private
    FColor: TColor;
    FFont: TFont;
    procedure   SetFont(const Value: TFont);
    procedure   DoOnFontChange(Sender : TObject);
    procedure   SetColor(const Value: TColor);
  protected

  public
    constructor Create(Collection: TCollection); override;
    Destructor  Destroy;override;
    procedure   Assign(Source : TPersistent);  override;
  published
    property    Color : TColor read FColor write SetColor;
    property    Font : TFont   read FFont write SetFont;
  end;

  TUICustomStyleItems = class(TOwnedCollection)
  private
    FStyle : TUICustomStyle;
    function    GetItem(Index: Integer): TUICustomStyleItem;
    procedure   SetItem(Index: Integer; const Value: TUICustomStyleItem);
  protected

  public
    constructor Create(AOwner:TUICustomStyle; ItemClass : TUICustomStyleItemClass);
    property    Items[Index: Integer]: TUICustomStyleItem read GetItem write SetItem; default;
    property    Style : TUICustomStyle read FStyle;
  published

  end;

  (*
  TUIStyleItems = class(TOwnedCollection)
  private
    function    GetItem(Index: Integer): TUIStyleItem;
    procedure   SetItem(Index: Integer; const Value: TUIStyleItem);
  protected

  public
    constructor Create(AOwner:TUICustomStyle);
    property    Items[Index: Integer]: TUIStyleItem read GetItem write SetItem; default;
  published

  end;
  *)
  
  TUICustomStyleItemLink = class(TObject)
  private
    FStyleItemName: TUIStyleItemName;
    FOnChange: TNotifyEvent;
    FStyleItem: TUICustomStyleItem;
    FItemClass: TUICustomStyleItemClass;
    procedure   SetStyleItem(const Value: TUICustomStyleItem);
    procedure   SetStyleItemName(const Value: TUIStyleItemName);
  protected
    procedure   Changed;
  public
    constructor Create(AItemClass : TUICustomStyleItemClass);
    Destructor  Destroy;override;
    procedure   Notify(Target:TObject);
    function    IsAvailable : boolean;
    property    StyleItem : TUICustomStyleItem read FStyleItem write SetStyleItem;
    property    StyleItemName : TUIStyleItemName read FStyleItemName write SetStyleItemName;
    property    ItemClass : TUICustomStyleItemClass read FItemClass;
    property    OnChange : TNotifyEvent read FOnChange write FOnChange;
  end;

  TUIStyleItemLink = class(TUICustomStyleItemLink)
  private
    function    GetStyleItem: TUIStyleItem;
    procedure   SetStyleItem(const Value: TUIStyleItem);
  protected

  public
    constructor Create;
    property    StyleItem : TUIStyleItem read GetStyleItem write SetStyleItem;
  end;

  TCtrlStyleGroup = class(TAppearanceGroup)
  private
    FLink : TUICustomStyleItemLink;
    procedure   OnStyleChange(Sender : TObject);
    function    GetStyleItemName: TUIStyleItemName;
    procedure   SetStyleItemName(const Value: TUIStyleItemName);
  protected

  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
  published
    property    StyleItemName : TUIStyleItemName read GetStyleItemName write SetStyleItemName;
  end;

var
  UIStyleManager : TUIStyleManager;

procedure   AddStyle(Style:TUICustomStyle);
procedure   RemoveStyle(Style:TUICustomStyle);
procedure   AddLink(Link:TUICustomStyleItemLink);
procedure   RemoveLink(Link:TUICustomStyleItemLink);
function    FindStyleItem(const Name:string; ItemClass : TUICustomStyleItemClass):TUICustomStyleItem;
procedure   UIStyleChanged(Target:TObject);

function    FindColorOfStyle(const Name:string; var Color : TColor) : Boolean;
function    FindColorOfStyle2(const Name:string; DefaultColor : TColor) : TColor;
function    FindFontOfStyle(const Name:string; Font : TFont) : Boolean;

procedure   ActiveStyles(const StyleName : string);

implementation

procedure   AddStyle(Style:TUICustomStyle);
begin
  if UIStyleManager<>nil then
    UIStyleManager.AddStyle(Style);
end;

procedure   RemoveStyle(Style:TUICustomStyle);
begin
  if UIStyleManager<>nil then
    UIStyleManager.RemoveStyle(Style);
end;

procedure   AddLink(Link:TUICustomStyleItemLink);
begin
  if UIStyleManager<>nil then
    UIStyleManager.AddLink(Link);
end;

procedure   RemoveLink(Link:TUICustomStyleItemLink);
begin
  if UIStyleManager<>nil then
    UIStyleManager.RemoveLink(Link);
end;

function    FindStyleItem(const Name:string; ItemClass : TUICustomStyleItemClass):TUICustomStyleItem;
begin
  if UIStyleManager<>nil then
    Result := UIStyleManager.FindStyleItem(Name,ItemClass)
  else
    Result := nil;
end;

procedure   UIStyleChanged(Target:TObject);
begin
  if UIStyleManager<>nil then
    UIStyleManager.Changed(Target);
end;

function    FindColorOfStyle(const Name:string; var Color : TColor) : Boolean;
var
  StyleItem : TUIStyleItem;
begin
  StyleItem := TUIStyleItem(FindStyleItem(Name,TUIStyleItem));
  Result := StyleItem<>nil;
  if Result then
    Color := StyleItem.Color;
end;

function    FindColorOfStyle2(const Name:string; DefaultColor : TColor) : TColor;
begin
  Result := DefaultColor;
  FindColorOfStyle(Name,Result);
end;

function    FindFontOfStyle(const Name:string; Font : TFont) : Boolean;
var
  StyleItem : TUIStyleItem;
begin
  StyleItem := TUIStyleItem(FindStyleItem(Name,TUIStyleItem));
  Result := StyleItem<>nil;
  if Result then
    Font.Assign(StyleItem.Font);
end;

procedure   ActiveStyles(const StyleName : string);
begin
  if UIStyleManager<>nil then
    UIStyleManager.ActiveStyles(StyleName);
end;

{ TUIStyleManager }

constructor TUIStyleManager.Create;
begin
  FStyles := TList.create;
  FLinks := TList.create;
end;

destructor TUIStyleManager.Destroy;
begin
  FreeAndNil(FStyles);
  FreeAndNil(FLinks);
  inherited;
end;

procedure TUIStyleManager.AddLink(Link: TUICustomStyleItemLink);
begin
  if FLinks<>nil then
    FLinks.Add(Link);
end;

procedure TUIStyleManager.AddStyle(Style: TUICustomStyle);
begin
  if FStyles<>nil then
    FStyles.Add(Style);
end;

function TUIStyleManager.FindStyleItem(Name: string;
  ItemClass : TUICustomStyleItemClass): TUICustomStyleItem;
var
  i : integer;
  Style : TUICustomStyle;
begin
  if Name<>'' then
    for i:=0 to FStyles.count-1 do
    begin
      Style := TUICustomStyle(FStyles[i]);
      if (Style.Active) and Style.GetItemClass.InheritsFrom(ItemClass) then
      begin
        Result := Style.FindStyleItem(Name);
        if Result<>nil then
          exit;
      end;
    end;
  Result := nil;
end;

procedure TUIStyleManager.RemoveLink(Link: TUICustomStyleItemLink);
begin
  if FLinks<>nil then
    FLinks.Remove(Link);
end;

procedure TUIStyleManager.RemoveStyle(Style: TUICustomStyle);
begin
  if FStyles<>nil then
    FStyles.Remove(Style);
end;

procedure TUIStyleManager.Changed(Target: TObject);
var
  AStyle : TUICustomStyle;
  i : integer;
begin
  AStyle := nil;
  if Target is TUICustomStyle then
    AStyle := TUICustomStyle(Target)
  else if Target is TUICustomStyleItem then
    AStyle := TUICustomStyleItem(Target).Style;
  if (AStyle=nil) or (AStyle.Active) then
  begin
    for i:=0 to FLinks.count-1 do
      TUICustomStyleItemLink(FLinks[i]).Notify(Target);
  end;
end;

procedure TUIStyleManager.RemoveItem(Item : TUICustomStyleItem);
var
  i : integer;
begin
  for i:=0 to FLinks.count-1 do
  begin
    with TUICustomStyleItemLink(FLinks[i]) do
      if StyleItem=Item then
        StyleItem:=nil;
  end;
end;

procedure TUIStyleManager.ActiveStyles(const StyleName: string);
var
  I : Integer;
begin
  for I:=0 to FStyles.Count-1 do
  begin
    if SameText(TUICustomStyle(FStyles[I]).StyleName,StyleName) then
      TUICustomStyle(FStyles[I]).Active := True;
  end;
end;

{ TUICustomStyle }

constructor TUICustomStyle.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TUICustomStyleItems.Create(self,GetItemClass);
  AddStyle(self);
  FGroupIndex:=0;
end;

destructor TUICustomStyle.Destroy;
begin
  RemoveStyle(self);
  FItems.free;
  inherited;
end;
{
procedure TUICustomStyle.Changed(Target: TObject);
begin
  (*if (UIStyleManager<>nil) and
    ((Target=nil) // active changed
    or FActive) then
    UIStyleManager.Changed(Target); *)
  if (UIStyleManager<>nil) then
    UIStyleManager.Changed(Target);
end;
}
procedure TUICustomStyle.SetActive(const Value: boolean);
begin
  if FActive <> Value then
  begin
    FActive := Value;
    CheckGroup;
    UIStyleChanged(nil);
  end;
end;

procedure TUICustomStyle.SetItems(const Value: TUICustomStyleItems);
begin
  FItems.Assign(Value);
end;

function TUICustomStyle.FindStyleItem(ItemName: string): TUICustomStyleItem;
var
  i : integer;
begin
  if Name<>'' then
    for i:=0 to Items.count-1 do
    begin
      Result := TUICustomStyleItem(Items.Items[i]);
      if SameText(Result.Name,ItemName) then
        exit;
    end;
  result := nil;
end;

procedure TUICustomStyle.SetGroupIndex(const Value: integer);
begin
  if FGroupIndex <> Value then
  begin
    FGroupIndex := Value;
    CheckGroup;
  end;
end;

procedure TUICustomStyle.CheckGroup;
var
  i : integer;
  Style : TUICustomStyle;
begin
  if (GroupIndex<>0) and Active and (UIStyleManager<>nil) then
  begin
    for i:=0 to UIStyleManager.Styles.count-1 do
    begin
      Style := TUICustomStyle(UIStyleManager.Styles[i]);
      if (style.GroupIndex=GroupIndex) and (style<>self) then
      begin
        style.Active:=false;
        break; // there is at most one active style other than this
      end;
    end;
  end;
end;

class function TUICustomStyle.GetItemClass: TUICustomStyleItemClass;
begin
  Result := TUICustomStyleItem;
end;

{ TUICustomStyleItem }

procedure TUICustomStyleItem.Changed(KeyChanged: Boolean);
begin
  if KeyChanged then
    UIStyleChanged(FStyle)
  else
    UIStyleChanged(self);
end;

constructor TUICustomStyleItem.Create(Collection: TCollection);
begin
  inherited;
  Assert(Collection is TUICustomStyleItems);
  FStyle := TUICustomStyleItems(Collection).FStyle;
end;

destructor TUICustomStyleItem.Destroy;
begin
  if UIStyleManager<>nil then UIStyleManager.RemoveItem(self);
  inherited;
end;

function TUICustomStyleItem.GetDisplayName: string;
begin
  result := FName;
end;

procedure TUICustomStyleItem.SetName(const Value: TUIStyleItemName);
begin
  if FName <> Value then
  begin
    FName := Value;
    Changed(true);
  end;
end;


{ TUIStyleItem }

procedure TUIStyleItem.Assign(Source: TPersistent);
begin
  if Source is TUIStyleItem then
    with TUIStyleItem(Source) do
    begin
      self.Name := '';
      self.Font.Assign(Font);
      self.Color := Color;
      self.Name := Name;
    end
  else
    inherited;
end;

constructor TUIStyleItem.Create(Collection: TCollection);
begin
  inherited;
  FFont := TFont.create;
  FFont.OnChange:=DoOnFontChange;
  FColor := clWhite;
end;

destructor TUIStyleItem.Destroy;
begin
  inherited;
  FFont.free;
end;
(*
procedure TUIStyleItem.Changed(Target:TObject);
begin
  FStyle.Changed(Target);
end;
*)
procedure TUIStyleItem.DoOnFontChange(Sender: TObject);
begin
  Changed(false);
end;

procedure TUIStyleItem.SetColor(const Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    Changed(false);
  end;
end;

procedure TUIStyleItem.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

{ TUICustomStyleItemLink }

constructor TUICustomStyleItemLink.Create(AItemClass : TUICustomStyleItemClass);
begin
  inherited Create;
  FItemClass := AItemClass;
  FStyleItemName:='';
  FStyleItem:=nil;
  AddLink(self);
end;

destructor TUICustomStyleItemLink.Destroy;
begin
  RemoveLink(self);
  inherited;
end;

procedure TUICustomStyleItemLink.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(self);
end;

procedure TUICustomStyleItemLink.SetStyleItem(const Value: TUICustomStyleItem);
begin
  if FStyleItem <> Value then
  begin
    FStyleItem := Value;
    if FStyleItem<>nil then
      FStyleItemName:=FStyleItem.Name;
    Changed;
  end;
end;

procedure TUICustomStyleItemLink.SetStyleItemName(const Value: TUIStyleItemName);
begin
  if FStyleItemName <> Value then
  begin
    FStyleItemName := Value;
    StyleItem := FindStyleItem(FStyleItemName, FItemClass);
  end;
end;

function TUICustomStyleItemLink.IsAvailable: boolean;
begin
  result := FStyleItem<>nil;
end;

procedure TUICustomStyleItemLink.Notify(Target: TObject);
begin
  if Target is TUICustomStyleItem then
  begin
    if Target=FStyleItem then
      Changed;
  end
  else
  begin
    StyleItem := FindStyleItem(FStyleItemName, FItemClass);
    if (Target is TUICustomStyle) and (FStyleItem<>nil) then
    begin
      if Target=FStyleItem.Style then
        Changed;
    end
  end;
end;

{ TCtrlStyleGroup }

constructor TCtrlStyleGroup.Create(AOwner: TComponent);
begin
  inherited;
  FLink:=TUICustomStyleItemLink.create(TUIStyleItem);
  FLink.OnChange:=OnStyleChange;
end;

destructor TCtrlStyleGroup.Destroy;
begin
  FreeAndNil(FLink);
  inherited;
end;

function TCtrlStyleGroup.GetStyleItemName: TUIStyleItemName;
begin
  result := FLink.FStyleItemName;
end;

procedure TCtrlStyleGroup.OnStyleChange(Sender: TObject);
begin
  if FLink.IsAvailable then
  begin
    Font:=TUIStyleItem(FLink.FStyleItem).Font;
    Color:= TUIStyleItem(FLink.FStyleItem).Color;
  end;
end;

procedure TCtrlStyleGroup.SetStyleItemName(const Value: TUIStyleItemName);
begin
  FLink.StyleItemName := Value;
end;

{ TUICustomStyleItems }

constructor TUICustomStyleItems.Create(AOwner: TUICustomStyle; ItemClass : TUICustomStyleItemClass);
begin
  inherited Create(AOwner,ItemClass);
  FStyle := AOwner;
end;

function TUICustomStyleItems.GetItem(Index: Integer): TUICustomStyleItem;
begin
  Result := TUICustomStyleItem(inherited Items[index]);
end;

procedure TUICustomStyleItems.SetItem(Index: Integer; const Value: TUICustomStyleItem);
begin
  inherited SetItem(index,Value);
end;

(*
{ TUIStyleItems }

constructor TUIStyleItems.Create(AOwner: TUICustomStyle);
begin
  inherited Create(AOwner,TUIStyleItem);
end;

function TUIStyleItems.GetItem(Index: Integer): TUIStyleItem;
begin
  Result := TUIStyleItem(inherited Items[Index]);
end;

procedure TUIStyleItems.SetItem(Index: Integer; const Value: TUIStyleItem);
begin
  inherited Items[Index]:=value;
end;
*)

{ TUIStyleItemLink }

constructor TUIStyleItemLink.Create;
begin
  inherited Create(TUIStyleItem);
end;

function TUIStyleItemLink.GetStyleItem: TUIStyleItem;
begin
  Result := TUIStyleItem(FStyleItem);
end;

procedure TUIStyleItemLink.SetStyleItem(const Value: TUIStyleItem);
begin
  inherited StyleItem:=value;
end;

{ TUIStyle }

class function TUIStyle.GetItemClass: TUICustomStyleItemClass;
begin
  Result := TUIStyleItem;
end;

initialization
  UIStyleManager := TUIStyleManager.create;

finalization
  FreeAndNil(UIStyleManager);

end.

