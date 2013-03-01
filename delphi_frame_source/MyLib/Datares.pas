unit Datares;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
{$ifdef delphi3}
  TOwnedCollection = class(TCollection)
  private
    FOwner: TPersistent;
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);
  end;
{$endif}

  TDRItem = class(TCollectionItem)
  private
    FnKey2: integer;
    FnKey1: integer;
    FsKey2: string;
    FsKey1: string;
    Fstrings: TStringlist;
    procedure   Setstrings(const Value: TStringlist);
  protected
    function    GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    Destructor  Destroy;override;
    procedure   Assign(Source: TPersistent); override;
  published
    property    nKey1 : integer read FnKey1 write FnKey1 default 0;
    property    nKey2 : integer read FnKey2 write FnKey2 default 0;
    property    sKey1 : string read FsKey1 write FsKey1 ;
    property    sKey2 : string read FsKey2 write FsKey2 ;
    property    Strings : TStringlist read Fstrings write Setstrings;
  end;

  TDRCollection = class(TOwnedCollection)
  private
    function GetItems(index: integer): TDRItem;
  public
    constructor Create(AOwner : TPersistent);
    property    Items[index:integer] : TDRItem read GetItems; default;
  end;

  TDatares = class(TComponent)
  private
    FItems: TDRCollection;
    procedure SetItems(const Value: TDRCollection);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
  published
    { Published declarations }
    property    Items : TDRCollection read FItems write SetItems;
  end;


implementation

{$ifdef delphi3}

{ TOwnedCollection }

constructor TOwnedCollection.Create(AOwner: TPersistent;
  ItemClass: TCollectionItemClass);
begin
  FOwner := AOwner;
  inherited Create(ItemClass);
end;

function TOwnedCollection.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

{$endif}

{ TDRItem }

constructor TDRItem.Create(Collection: TCollection);
begin
  inherited;
  Fstrings := TStringList.Create;
end;

destructor TDRItem.Destroy;
begin
  Fstrings.free;
  inherited;
end;

function TDRItem.GetDisplayName: string;
begin
  result := FsKey1;
end;

procedure TDRItem.Setstrings(const Value: TStringlist);
begin
  Fstrings.assign(Value);
end;

procedure TDRItem.Assign(Source: TPersistent);
begin
  if Source is TDRItem then
  with TDRItem(Source) do
  begin
    self.FnKey1 := nKey1;
    self.FnKey2 := nKey2;
    self.FsKey1 := sKey1;
    self.FsKey2 := sKey2;
    self.Fstrings.Assign(Strings);
  end else
  inherited ;
end;

{ TDRCollection }

constructor TDRCollection.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner,TDRItem);
end;

function TDRCollection.GetItems(index: integer): TDRItem;
begin
  result := TDRItem(inherited items[index]);
end;

{ TDatares }

constructor TDatares.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TDRCollection.Create(self);
end;

destructor TDatares.Destroy;
begin
  FItems.free;
  inherited;
end;

procedure TDatares.SetItems(const Value: TDRCollection);
begin
  FItems.assign(Value);
end;

end.

