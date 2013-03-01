unit Safecode;

interface

uses Sysutils;

type
  EUnexpectedValue = class(exception);

procedure RaiseUnexpectedValue;

procedure CheckZero(n:integer);

procedure CheckNotZero(n:integer);

procedure CheckTrue(b : boolean);

procedure CheckObject(obj : TObject);

procedure CheckPtr(Ptr : Pointer);

type
  EInvalidParam = class(Exception);
  EIndexOutOfRange = class(Exception);
  ECannotDo = class(Exception);

procedure RaiseInvalidParam;
procedure RaiseIndexOutOfRange;
procedure RaiseConvertError;
procedure RaiseCannotDo(const info:string);

procedure CheckRange(index,min,max : integer);

implementation

procedure RaiseUnexpectedValue;
begin
  raise EUnexpectedValue.create(
   'An unexpected value that may be due to a unsuccessfal call');
end;

procedure CheckZero(n:integer);
begin
  if (n<>0) then RaiseUnexpectedValue;
end;

procedure CheckNotZero(n:integer);
begin
  if (n=0) then RaiseUnexpectedValue;
end;

procedure CheckTrue(b : boolean);
begin
  if not b then RaiseUnexpectedValue;
end;

procedure CheckObject(obj : TObject);
begin
  if obj=nil then RaiseUnexpectedValue;
end;

procedure CheckPtr(Ptr : Pointer);
begin
  if Ptr=nil then RaiseUnexpectedValue;
end;

procedure RaiseInvalidParam;
begin
  raise EInvalidParam.create('Invalid Property Type');
end;

procedure RaiseIndexOutOfRange;
begin
  raise EIndexOutOfRange.create('Index out of range');
end;

procedure RaiseConvertError;
begin
  raise EConvertError.Create('A convert error!');
end;

procedure RaiseCannotDo(const info:string);
begin
  raise ECannotDo.Create(info);
end;

procedure CheckRange(index,min,max : integer);
begin
  if (index<min) or (index>max) then
    RaiseIndexOutOfRange;
end;

end.
