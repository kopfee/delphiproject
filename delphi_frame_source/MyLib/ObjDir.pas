unit ObjDir;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>对象目录服务
   一组相关对象注册在一个Category下面
   <What>
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}


interface

uses Classes, Contnrs;

type
  TForEachObjectProc = procedure (Obj : TObject) of object;
  TForEachObjectProc2 = procedure (Obj : TObject; Param : Pointer);
  TFindObjectProc = procedure (Obj : TObject; var Finded : Boolean) of object;
  TFindObjectProc2 = procedure (Obj : TObject; const Name:string; ID : integer; var Finded : Boolean);

  TObjectCategory = class(TObjectList)
  private
    FName: string;
  protected

  public
    constructor Create(AName : string; AOwnsObjects: Boolean);
    destructor  Destroy;override;
    property    Name : string read FName;

    procedure   ForEachObject(Proc : TForEachObjectProc); overload;
    procedure   ForEachObject(Param : Pointer; Proc : TForEachObjectProc2); overload;
    function    FindObject(Proc : TFindObjectProc): TObject; overload;
    function    FindObject(const AName:string; ID : Integer; Proc : TFindObjectProc2): TObject; overload;
  end;

  TObjectDirectory = class(TObjectList)
  private

  protected

  public
    function    CreateCategory(const CategoryName : string; AOwnsObjects: Boolean):TObjectCategory;
    function    GetCategory(const CategoryName : string):TObjectCategory;
    procedure   AddObject(const CategoryName : string; Obj : TObject);
    procedure   RemoveObject(const CategoryName : string; Obj : TObject);
  end;

  TDirectoriedObject = class
  private

  protected

  public
    constructor Create;
    destructor  Destroy;override;
    class function GetCategoryName : string; virtual; abstract;
  end;


procedure InitObjectDirectory;

function  CreateCategory(const CategoryName : string; AOwnsObjects: Boolean):TObjectCategory;

function  GetCategory(const CategoryName : string):TObjectCategory;

procedure AddObject(const CategoryName : string; Obj : TObject);

procedure RemoveObject(const CategoryName : string; Obj : TObject);

implementation

uses SysUtils,SafeCode;

var
  ObjectDirectory : TObjectDirectory=nil;

procedure InitObjectDirectory;
begin
  if ObjectDirectory=nil then
    ObjectDirectory := TObjectDirectory.Create;
end;

function  CreateCategory(const CategoryName : string; AOwnsObjects: Boolean):TObjectCategory;
begin
  InitObjectDirectory;
  Assert(ObjectDirectory<>nil);
  Result := ObjectDirectory.CreateCategory(CategoryName,AOwnsObjects);
end;

function  GetCategory(const CategoryName : string):TObjectCategory;
begin
  InitObjectDirectory;
  Assert(ObjectDirectory<>nil);
  Result := ObjectDirectory.GetCategory(CategoryName);
end;

procedure AddObject(const CategoryName : string; Obj : TObject);
begin
  InitObjectDirectory;
  Assert(ObjectDirectory<>nil);
  ObjectDirectory.AddObject(CategoryName,Obj);
end;

procedure RemoveObject(const CategoryName : string; Obj : TObject);
begin
  if ObjectDirectory<>nil then
    ObjectDirectory.RemoveObject(CategoryName,Obj);
end;

{ TObjectCategory }

constructor TObjectCategory.Create(AName: string; AOwnsObjects: Boolean);
begin
  InitObjectDirectory;
  Assert(ObjectDirectory<>nil);
  inherited Create(AOwnsObjects);
  FName := AName;
  ObjectDirectory.Add(Self);
end;

destructor TObjectCategory.Destroy;
begin
  if ObjectDirectory<>nil then
    ObjectDirectory.Extract(Self);
  inherited;
end;

function TObjectCategory.FindObject(Proc: TFindObjectProc): TObject;
var
  I,L : Integer;
  Finded : Boolean;
begin
  Assert(Assigned(Proc));
  L := Count-1;
  Finded := False;
  for I:=0 to L do
  begin
    Result := Items[I];
    Proc(Result,Finded);
    if Finded then
      Exit;
  end;
  Result := nil;
end;

function TObjectCategory.FindObject(const AName:string; ID : Integer; Proc: TFindObjectProc2): TObject;
var
  I,L : Integer;
  Finded : Boolean;
begin
  Assert(Assigned(Proc));
  L := Count-1;
  Finded := False;
  for I:=0 to L do
  begin
    Result := Items[I];
    Proc(Result, AName, ID, Finded);
    if Finded then
      Exit;
  end;
  Result := nil;
end;

procedure TObjectCategory.ForEachObject(Proc: TForEachObjectProc);
var
  I,L : Integer;
begin
  Assert(Assigned(Proc));
  L := Count-1;
  for I:=0 to L do
    Proc(Items[I]);
end;

procedure TObjectCategory.ForEachObject(Param : Pointer; Proc: TForEachObjectProc2);
var
  I,L : Integer;
begin
  Assert(Assigned(Proc));
  L := Count-1;
  for I:=0 to L do
    Proc(Items[I],Param);
end;

{ TObjectDirectory }

function TObjectDirectory.CreateCategory(const CategoryName: string;
  AOwnsObjects: Boolean): TObjectCategory;
begin
  Result := GetCategory(CategoryName);
  if Result<>nil then
  begin
    if Result.OwnsObjects<>AOwnsObjects then
      raise Exception.Create('Cannot create category '+CategoryName);
  end else
  begin
    Result := TObjectCategory.Create(CategoryName,AOwnsObjects);
  end;
end;

function TObjectDirectory.GetCategory(
  const CategoryName: string): TObjectCategory;
var
  I : Integer;
  L : Integer;
begin
  L := Count-1;
  for I:=0 to L do
  begin
    Result := TObjectCategory(Items[I]);
    if SameText(Result.Name,CategoryName) then
      Exit;
  end;
  Result := nil;
end;

procedure TObjectDirectory.AddObject(const CategoryName: string;
  Obj: TObject);
var
  Category : TObjectCategory;
begin
  Category := GetCategory(CategoryName);
  CheckObject(Category,'Category not exists.');
  Category.Add(Obj);
end;

procedure TObjectDirectory.RemoveObject(const CategoryName: string;
  Obj: TObject);
var
  Category : TObjectCategory;
begin
  Category := GetCategory(CategoryName);
  CheckObject(Category,'Category not exists.');
  Category.Extract(Obj);
end;

{ TDirectoriedObject }

constructor TDirectoriedObject.Create;
begin
  AddObject(GetCategoryName,Self);
end;

destructor TDirectoriedObject.Destroy;
begin
  RemoveObject(GetCategoryName,Self);
  inherited;
end;

initialization
  InitObjectDirectory;

finalization
  FreeAndNil(ObjectDirectory);

end.
