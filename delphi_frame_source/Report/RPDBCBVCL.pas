unit RPDBCBVCL;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>RPDBCBVCL
   <What>基于TDataset实现RPDBCB定义的数据集访问回调函数。
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

interface

{$IFDEF VER90}
  {$DEFINE Delphi2}
  {$DEFINE Prior4}
{$ENDIF}

{$IFDEF VER100}
  {$DEFINE Delphi3}
  {$DEFINE Prior4}
{$ENDIF}

{$IFDEF VER120}
  {$DEFINE Delphi4}
  {$DeFINE Post4}
{$ENDIF}

{$IFDEF VER130}
  {$DEFINE Delphi5}
  {$DeFINE Post4}
{$ENDIF}

uses Classes, DB, RPDBCB;

procedure DBFirst(Dataset : Pointer); stdcall;
procedure DBNext(Dataset : Pointer); stdcall;
procedure DBPrior(Dataset : Pointer); stdcall;
procedure DBLast(Dataset : Pointer); stdcall;
function  DBBOF(Dataset : Pointer):LongBool; stdcall;
function  DBEOF(Dataset : Pointer):LongBool; stdcall;
function  DBFieldCount(Dataset : Pointer):Integer; stdcall;
// FieldIndex : 0..FieldCount-1
function  DBGetFieldName(Dataset : Pointer; FieldIndex : Integer; Buffer : PChar; Len : Integer):Integer; stdcall;
// Should return gfdtInteger(0),gfdtFloat(1),gfdtString,gfdtDate,gfdtOther,gfdtBinary for Datatype
function  DBGetFieldDataType(Dataset : Pointer; FieldIndex : Integer):Integer; stdcall;
function  DBGetInteger(Dataset : Pointer; FieldIndex : Integer):Integer; stdcall;
function  DBGetFloat(Dataset : Pointer; FieldIndex : Integer):Double; stdcall;
function  DBGetString(Dataset : Pointer; FieldIndex : Integer; Buffer : PChar; Len : Integer):Integer; stdcall;
//function  DBGetString(Dataset : Pointer; FieldIndex : Integer):PChar; stdcall;
function  DBGetDateTime(Dataset : Pointer; FieldIndex : Integer):TDatetime; stdcall;

function  NewDBDatasetRecord(Dataset : TDataset):  PDatasetRecord;

procedure FreeDBDatasetRecord(var P : PDatasetRecord);

implementation

uses SysUtils;

procedure DBFirst(Dataset : Pointer); stdcall;
begin
  TDataset(Dataset).First;
end;

procedure DBNext(Dataset : Pointer); stdcall;
begin
  TDataset(Dataset).Next;
end;

procedure DBPrior(Dataset : Pointer); stdcall;
begin
  TDataset(Dataset).Prior;
end;

procedure DBLast(Dataset : Pointer); stdcall;
begin
  TDataset(Dataset).Last;
end;

function  DBBOF(Dataset : Pointer):LongBool; stdcall;
begin
  Result := TDataset(Dataset).Bof;
end;

function  DBEOF(Dataset : Pointer):LongBool; stdcall;
begin
  Result := TDataset(Dataset).Eof;
end;

function  DBFieldCount(Dataset : Pointer):Integer; stdcall;
begin
  Result := TDataset(Dataset).FieldCount;
end;

// FieldIndex : 0..FieldCount-1
function  DBGetFieldName(Dataset : Pointer; FieldIndex : Integer; Buffer : PChar; Len : Integer):Integer; stdcall;
var
  S : string;
begin
  S := TDataset(Dataset).Fields[FieldIndex].FieldName;
  Result := Length(S);
  if Buffer<>nil then
    StrLCopy(Buffer,PChar(S),Len);
end;

// Should return gfdtInteger(0),gfdtFloat(1),gfdtString,gfdtDate,gfdtOther,gfdtBinary for Datatype
function  DBGetFieldDataType(Dataset : Pointer; FieldIndex : Integer):Integer; stdcall;
begin
  case TDataset(Dataset).Fields[FieldIndex].DataType of
    ftString {$IFDEF Post4} ,ftFixedChar, ftWideString {$ENDIF} :
      Result:=cdtString;
    ftSmallint, ftInteger, ftWord, ftAutoInc {$IFDEF Post4}, ftLargeint {$ENDIF}:
      Result:=cdtInteger;
    ftFloat, ftCurrency, ftBCD :
      Result:=cdtFloat;
    ftDate, ftTime, ftDateTime :
      Result:=cdtDate;
  else
    Result:= cdtOther;
  end;
end;

function  DBGetInteger(Dataset : Pointer; FieldIndex : Integer):Integer; stdcall;
begin
  Result := TDataset(Dataset).Fields[FieldIndex].AsInteger;
end;

function  DBGetFloat(Dataset : Pointer; FieldIndex : Integer):Double; stdcall;
begin
  Result := TDataset(Dataset).Fields[FieldIndex].AsFloat;
end;

function  DBGetString(Dataset : Pointer; FieldIndex : Integer; Buffer : PChar; Len : Integer):Integer; stdcall;
var
  S : string;
begin
  S := TDataset(Dataset).Fields[FieldIndex].AsString;
  Result := Length(s);
  if Buffer<>nil then
    StrLCopy(Buffer,PChar(S),Len);
end;

function  DBGetDateTime(Dataset : Pointer; FieldIndex : Integer):TDatetime; stdcall;
begin
  Result := TDataset(Dataset).Fields[FieldIndex].AsDateTime;
end;

function  NewDBDatasetRecord(Dataset : TDataset):  PDatasetRecord;
begin
  New(Result);
  Result^.Dataset := Dataset;
  with Result^ do
  begin
    First := DBFirst;
    Next := DBNext;
    Prior := DBPrior;
    Last := DBLast;
    EOF := DBEOF;
    Bof := DBBof;
    FieldCount := DBFieldCount;
    GetFieldName := DBGetFieldName;
    GetFieldDataType := DBGetFieldDataType;
    GetInteger := DBGetInteger;
    GetFloat := DBGetFloat;
    GetString := DBGetString;
    GetDateTime := DBGetDateTime;
  end;
end;

procedure FreeDBDatasetRecord(var P : PDatasetRecord);
begin
  Dispose(P);
end;

end.
