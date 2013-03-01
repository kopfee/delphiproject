unit ShortcutEx;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TShortcutItem = class(TCollectionItem)
  private
    FShortcut: TShortcut;
    FOnShortcut: TNotifyEvent;
    procedure SetShortcut(const Value: TShortcut);
  protected
    function  GetDisplayName: string; override;
  public
    function  Trigger(Sender : TObject):boolean;
  published
    property  Shortcut : TShortcut read FShortcut write SetShortcut;
    property  OnShortcut : TNotifyEvent read FOnShortcut write FOnShortcut;
  end;


  TShortcutCollection = class(TOwnedCollection)
  private

  protected

  public
    constructor Create(AOwner: TPersistent);
    function    FindItem(Shortcut : TShortcut) : TShortcutItem;
  published

  end;


  TShortcutHandler = class(TComponent)
  private
    { Private declarations }
    FShortcuts: TShortcutCollection;
    FAutoSet: boolean;
    procedure   SetShortcuts(const Value: TShortcutCollection);
    procedure   SetAutoSet(const Value: boolean);
    procedure   InstallFormKeyDown;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    procedure   KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    function    Trigger(shortcut : TShortcut):boolean;
  published
    { Published declarations }
    property    AutoSet : boolean read FAutoSet write SetAutoSet default true;
    property    Shortcuts : TShortcutCollection read FShortcuts write SetShortcuts;
  end;

procedure Register;

implementation

uses Menus;

procedure Register;
begin
  RegisterComponents('Users', [TShortcutHandler]);
end;

{ TShortcutItem}

function TShortcutItem.GetDisplayName: string;
begin
  result := ShortCutToText(FShortcut);
end;

procedure TShortcutItem.SetShortcut(const Value: TShortcut);
begin
  if FShortcut <> Value then
  begin
    FShortcut := Value;
    changed(false);
  end;
end;

function  TShortcutItem.Trigger(Sender : TObject):boolean;
begin
  if assigned(OnShortcut) then
  begin
    OnShortcut(Sender);
    result := true;
  end
  else result:=false;
end;

{ TShortcutCollection }

constructor TShortcutCollection.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner,TShortcutItem);
end;

function TShortcutCollection.FindItem(Shortcut: TShortcut): TShortcutItem;
var
  i : integer;
begin
  for i:=0 to count-1 do
  begin
    result := TShortcutItem(Items[i]);
    if result.Shortcut=Shortcut then exit;
  end;
  result := nil;
end;

{ TShortcutHandler }

constructor TShortcutHandler.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FShortcuts :=  TShortcutCollection.Create(self);
  FAutoSet := true;
  InstallFormKeyDown;
end;

destructor TShortcutHandler.Destroy;
begin
  FShortcuts.free;
  inherited Destroy;
end;

type
  TFormAccess=class(TCustomForm);

procedure TShortcutHandler.InstallFormKeyDown;
var
  form : TCustomForm;
begin
  if not (csDesigning in ComponentState) then
  begin
    if Owner is TCustomForm then
    begin
      form := TCustomForm(Owner);
      form.KeyPreview := true;
      TFormAccess(form).OnKeyDown := KeyDown;
    end;
  end;
end;

procedure TShortcutHandler.KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Shortcut : TShortcut;
  i : integer;
begin
  i := byte(Shift);
  Shortcut := Menus.ShortCut(key,Shift);
  {$ifdef debug }
  outputDebugString(pchar('key:'+IntToStr(key)
    +' Shift:'+IntToHex(i,4)
    +' Short:'+ShortCutToText(Shortcut)));
  {$endif}
  if Trigger(Shortcut) then key:=0;
end;

procedure TShortcutHandler.SetAutoSet(const Value: boolean);
begin
  if FAutoSet <> Value then
  begin
    FAutoSet := Value;
    if FAutoSet then InstallFormKeyDown;
  end;
end;

procedure TShortcutHandler.SetShortcuts(const Value: TShortcutCollection);
begin
  if FShortcuts <> Value then
  begin
    FShortcuts.Assign(Value);
  end;
end;

function  TShortcutHandler.Trigger(shortcut : TShortcut):boolean;
var
  Item :  TShortcutItem;
begin
  Item :=FShortcuts.FindItem(shortcut);
  if Item<>nil then
    result := Item.Trigger(Item)
  else result := false;
end;

end.
