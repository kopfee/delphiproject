unit AppearUtils;

// %AppearUtils : 包含控制控件外观的组件
(*****   Code Written By Huang YanLai   *****)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  ImgList,Controls, Forms, Dialogs;

type
  TAppearance = class(TCollectionItem)
  private
    FColor:     TColor;
    FFont:      TFont;
    FCaption:   string;
    procedure   OnFontChange(sender : TObject);
    procedure   SetColor(const Value: TColor);
    procedure   SetFont(const Value: TFont);
    procedure   SetCaption(const Value: string);
  protected
    function    GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection);override;
    destructor  destroy; override;
  published
    property    Font : TFont read FFont write SetFont;
    property    Color : TColor read FColor write SetColor;
    property    Caption : string read FCaption write SetCaption;
  end;

  TAppearanceCollection = class(TOwnedCollection)
  private
    FOnItemChanged: TNotifyEvent;
    function    GetItems(index: integer): TAppearance;
  protected
    procedure   Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent);
    property    Items[index : integer] : TAppearance
                  read GetItems ;default;
    // OnItemChanged, sender is TCollectionItem
    // if sender is nil, all items changed.
    property    OnItemChanged : TNotifyEvent
                  read FOnItemChanged write FOnItemChanged;
  end;

  // %TAppearances :
  TAppearances = class(TComponent)
  private
    { Private declarations }
    FItems:     TAppearanceCollection;
    FClients :  TList;
    FDefaultColor:  TColor;
    FDefaultFont:   TFont;
    FImages:    TCustomImageList;
    procedure   SetItems(const Value: TAppearanceCollection);
    procedure   ItemChanged(sender : TObject);
    // index indecate which item changed
    procedure   UpdateClientBy(Index : integer);
    function    GetColors(index: integer): TColor;
    function    GetFonts(index: integer): TFont;
    procedure   SetDefaultColor(const Value: TColor);
    procedure   SetDefaultFont(const Value: TFont);
    procedure   SetImages(const Value: TCustomImageList);
  protected
    { Protected declarations }
    procedure   Notification(AComponent: TComponent;
                  Operation: TOperation); override;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor  destroy; override;
    procedure   AddClient(Client : TComponent);
    procedure   RemoveClient(Client : TComponent);
    procedure   UpdateClients;
    property    Fonts[index : integer] : TFont read GetFonts;
    property    Colors[index : integer] : TColor read GetColors;
  published
    { Published declarations }
    property    Items : TAppearanceCollection
                  read FItems write SetItems;
    property    DefaultColor : TColor
                  read FDefaultColor write SetDefaultColor;
    property    DefaultFont : TFont
                  read FDefaultFont write SetDefaultFont;
    property    Images : TCustomImageList read FImages write SetImages;
  end;

  {
   How to use TAppearances
    if AComponent.Appearances refer to TAppearances,
   add three methods to AComponent:
    1) AComponent.SetAppr(value : TAppearances);
    begin
      if FAppearances=value then exit;
      if FAppearances<>nil then
        FAppearances.removeClient(self);
      FAppearances:= value;
      if FAppearances<>nil then
        FAppearances.AddClient(self);
      repaint;
    end;

    2) AComponent.Notification(AComponent: TComponent;
                  Operation: TOperation); override;
    begin
      inherited Notification(AComponent,Operation);
      if (AComponent=FAppearances) and (Operation=opRemove) then
        FAppearances:= nil;
    end;

    3) AComponent.LMAppearChanged(var message : TMessage);message LM_AppearChanged;
    begin
      repaint;
    end;
  }

implementation

uses LibMessages,SafeCode;

{ TAppearance }

constructor TAppearance.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FFont := TFont.Create;
  FFont.OnChange := OnFontChange;
  FColor := clBtnFace;
end;

destructor TAppearance.destroy;
begin
  FFont.OnChange := nil;
  FFont.free;
  inherited destroy;
end;

function TAppearance.GetDisplayName: string;
begin
  if FCaption='' then
    result := 'TAppearance['+IntToStr(Index)+']'
  else
    result := FCaption;
end;

procedure TAppearance.OnFontChange(sender: TObject);
begin
  changed(false);
end;

procedure TAppearance.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Changed(false);
  end;
end;

procedure TAppearance.SetColor(const Value: TColor);
begin
  if FColor<>Value then
  begin
    FColor := Value;
    Changed(false);
  end;
end;

procedure TAppearance.SetFont(const Value: TFont);
begin
  if value<>FFOnt then
    FFont.Assign(Value);
end;

{ TAppearanceCollection }

constructor TAppearanceCollection.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner,TAppearance);
end;

function TAppearanceCollection.GetItems(index: integer): TAppearance;
begin
  //CheckRange(Index,0,count-1);
  result := TAppearance(inherited items[index]);
end;

procedure TAppearanceCollection.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  {Owner := GetOwner;
  if Owner is TComponent then
  with Owner as TComponent do
  begin
    for i:=0 to
  end;}
  if assigned(FOnItemChanged) then
    FOnItemChanged(item);
end;

{ TAppearances }

constructor TAppearances.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Fitems := TAppearanceCollection.Create(self);
  Fitems.OnItemChanged := ItemChanged;
  FClients := TList.Create;
end;

destructor TAppearances.destroy;
begin
  FClients.free;
  FClients := nil;
  Fitems.OnItemChanged := nil;
  Fitems.free;
  inherited destroy;
end;

procedure TAppearances.ItemChanged(sender: TObject);
var
  Index : integer;
begin
  if sender=nil then
    index := -1
  else
    index := TCollectionItem(sender).Index;

  UpdateClientBy(index);
end;

procedure TAppearances.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if Operation=opRemove then
  begin
    if AComponent=FImages then
      //FImages := nil;
      Images := nil;
    RemoveClient(AComponent);
  end;
end;

procedure TAppearances.AddClient(Client: TComponent);
begin
  if (Client<>nil) and
    (FClients.IndexOf(Client)<0) then
  begin
    FClients.Add(Client);
    Client.FreeNotification(self);
  end;
end;

procedure TAppearances.RemoveClient(Client: TComponent);
begin
  if FClients<>nil then
    FClients.Remove(Client);
end;

procedure TAppearances.SetItems(const Value: TAppearanceCollection);
begin
  if FItems <> Value then
  begin
    FItems.Assign(Value);
  end;
end;

procedure TAppearances.UpdateClients;
begin
  UpdateClientBy(-1);
end;

procedure TAppearances.UpdateClientBy(Index: integer);
var
  i : integer;
  msg : TMessage;
begin
  for i:=0 to FClients.Count-1 do
    if TComponent(FClients[i]) is TControl then
      TControl(FClients[i]).Perform(
        LM_AppearChanged,
        index,0)
    else
    begin
      msg.Msg := LM_AppearChanged;
      msg.WParam := index;
      msg.lparam := 0;
      msg.result := 0;
      TComponent(FClients[i]).dispatch(msg);
    end;
end;

function TAppearances.GetColors(index: integer): TColor;
begin
  if (index<0) or (index>=Items.count) then
    result := clBlack
  else
    result := items[index].Color;
end;

function TAppearances.GetFonts(index: integer): TFont;
begin
  if (index<0) or (index>=Items.count) then
    result := nil
  else
    result := items[index].font;
end;

procedure TAppearances.SetDefaultColor(const Value: TColor);
begin
  FDefaultColor := Value;
end;

procedure TAppearances.SetDefaultFont(const Value: TFont);
begin
  if FDefaultFont <> Value then
  begin
    FDefaultFont.Assign(Value);
  end;
end;

procedure TAppearances.SetImages(const Value: TCustomImageList);
begin
  if FImages <> Value then
  begin
    FImages := Value;
    if FImages<>nil then
      FImages.FreeNotification(self);
    UpdateClients;  
  end;
end;

end.
