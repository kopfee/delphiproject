unit DebugMemory;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> DebugMemory
   <What> µ÷ÊÔÄÚ´æÐ¹Â©
   <Written By> Huang YanLai
   <History>
**********************************************}

interface

uses Sysutils,Classes;

{$ASSERTIONS ON}

{ use AddNew and RemoveOld to found these errors:
 1. a same pointer or object has been Added beyond once.
 2. a pointer or an object has been freed beyond once.
 3. when program terminate, some pointers or objects have not been freed.
}

{ when you alloc a memory or new an object,
call AddNew.
}
procedure AddNew(value : Pointer);

{ when you free a memory or destroy an object,
call RemoveOld.
}
procedure RemoveOld(value : Pointer);

{ use TPointerRecord to debug a group of pointers or objects.
  when you alloc a memory or new an object,
call AddNew.
  when you free a memory or destroy an object,
call RemoveOld.
  before program termenate, free TPointerRecord.
  use TPointerRecord to found these errors:
 1. a same pointer or object has been Added beyond once.
 2. a pointer or an object has been freed beyond once.
 3. when program terminate, some pointers or objects have not been freed.
}
type
  TPointerRecord = class(TList)
  public
    procedure Add(value : Pointer);
    procedure Remove(value : Pointer);
    procedure BeforeDestruction; override;
  end;

  function  GetDebugText(AObject : TObject):string;


procedure LogCreate(obj : TOBject);

procedure LogDestroy(obj : TOBject);

implementation

uses Windows,LogFile;

{$ifdef DEBUG}

var
  Pointers : TList;

procedure AddNew(value : Pointer);
begin
  assert(Pointers.IndexOf(value)<0);
  Pointers.Add(value);
end;

procedure RemoveOld(value : Pointer);
var
  i : integer;
begin
  i:= Pointers.Remove(value);
  assert(i>=0);
end;

{$else}

procedure AddNew(value : Pointer);
begin

end;

procedure RemoveOld(value : Pointer);
begin

end;

{$endif}

{ TPointerRecord }

{$ifdef DEBUG}

procedure TPointerRecord.Add(value: Pointer);
begin
  assert(IndexOf(value)<0);
  inherited Add(value);
end;

procedure TPointerRecord.BeforeDestruction;
begin
  Assert(count=0);
end;

procedure TPointerRecord.Remove(value: Pointer);
var
  i : integer;
begin
  i:= inherited Remove(value);
  assert(i>=0);
end;

{$else}

procedure TPointerRecord.Add(value: Pointer);
begin

end;

procedure TPointerRecord.BeforeDestruction;
begin

end;

procedure TPointerRecord.Remove(value: Pointer);
begin

end;

{$endif}

{$ifdef debug}

function  GetDebugText(AObject : TObject):string;
begin
  if AObject=nil then
    result:='nil'
  else
    if AObject is TComponent then
      result:=AObject.className+'['
        +(AObject as TComponent).Name +','
        +IntToHex(Integer(AObject),8)+']'
    else
      result:=AObject.className+'['
        +IntToHex(Integer(AObject),8)+']';
end;

{$else}

function  GetDebugText(AObject : TObject):string;
begin

end;

{$endif}

procedure LogCreate(obj : TOBject);
begin
  WriteLog(format('%s[%8.8x] create.',[obj.className,integer(obj)]),lcConstruct_Destroy);
  //outputDebugString(pchar(format('%s[%8.8x] create.',[obj.className,integer(obj)])));
  AddNew(obj);
end;

procedure LogDestroy(obj : TOBject);
begin
  //outputDebugString(pchar(format('%s[%8.8x] Destroy.',[obj.className,integer(obj)])));
  WriteLog(format('%s[%8.8x] Destroy.',[obj.className,integer(obj)]),lcConstruct_Destroy);
  RemoveOld(obj);
end;


initialization
  {$ifdef DEBUG}
  pointers := TList.Create;
	{$endif}

finalization
  {$ifdef DEBUG}
  Assert(pointers.count=0);
  pointers.free;
	{$endif}
end.
