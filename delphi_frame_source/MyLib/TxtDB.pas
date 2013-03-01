unit TxtDB;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> TxtDB
   <What> 实现内存数据结果集
   <Written By> Huang YanLai
   <History>
**********************************************}


interface

uses SysUtils,Classes,contnrs;

const
  HTMLPackChars = ['<','>',#0..#31,'"','''','\'];
  DefaultPackChars = ['"',#0..#31,'\'];

type
  PByte = ^Byte;
  TTextField = class;
  TTextDataset = class;

  TTextField = class
  private
    FSize: integer;
    FFieldName: string;
    FDisplayName: string;
    FDataset:   TTextDataset;
    FOffset:    integer;
    function    GetValue: string;
    procedure   SetValue(const Value: string);
    function    GetExtraByte: byte;
    procedure   SetExtraByte(const Value: byte);
  public
    // ASize is the field size,AOffset is offset from row buffer pointer
    constructor Create(ADataset : TTextDataset; ASize : integer;AOffset : integer);
    property    Dataset : TTextDataset read FDataset;
    property    FieldName : string read FFieldName write FFieldName;
    property    DisplayName : string read FDisplayName write FDisplayName;
    property    Size : integer read FSize;
    property    Offset : integer read FOffset;
    property    Value : string read GetValue write SetValue;
    // return data buffer for advanced usage
    function    GetDataBuffer : Pchar;
    function    GetExtraBytePointer : PByte;
    property    ExtraByte : byte read GetExtraByte write SetExtraByte;
  end;

  TDataBuffer = class
  private
    FRowSize: integer;
    FMaxRows: integer;
    FSize: integer;
    FCount: integer;
    FBuffer: Pointer;
    FNextBuffer: TDataBuffer;
    FPriorBuffer: TDataBuffer;
  public
    constructor Create(ARowSize,AMaxRows:integer);
    Destructor  Destroy;override;
    property    Buffer : Pointer read FBuffer;
    property    Size : integer read FSize;
    property    MaxRows : integer read FMaxRows;
    property    RowSize : integer read FRowSize ;
    property    PriorBuffer : TDataBuffer read FPriorBuffer write FPriorBuffer;
    property    NextBuffer : TDataBuffer  read FNextBuffer write FNextBuffer;
    property    Count : integer read FCount;
    function    CanAppend: boolean;
    // %Append return row buffer pointer
    function    Append : pointer;
    function    RowBuffer(RowIndex : integer): pointer;
  end;

  TTextDataset = class
  private
    FFirstBuffer,
    FLastBuffer,
    FCurBuffer : TDataBuffer;
    FCurRow    : Pointer;
    FFields    : TObjectList;
    FBufferMaxRows : integer;
    FRowSize:   integer;
    FCount  :   integer;
    FOffset :   integer;
    FCursor,FBuffCursor :   integer;
    FEof: boolean;
    FBof: boolean;
    FMinRowsPerBuffer: Integer;
    function    CreateBuffer : TDataBuffer;
    // %ClearFields only clear Field objects, not free data memory
    procedure   ClearFields;
    function    GetFields(index: integer): TTextField;
    procedure   CalculateMemory;
    procedure   SetCursor(const Value: integer);
  protected

  public
    constructor Create;
    Destructor  Destroy;override;
    // [fieldname,displayname,fieldsize]
    procedure   CreateFields(const FieldDescA : array of const); overload;
    // <Field>       ::= "<DisplayName>"="<FieldName>"[<FieldLength>]
    // <Fields>      ::= <Field>|<Field>,<Fields>
    procedure   CreateFields(const FieldDescS : String); overload;
    procedure   BeginCreateField;
    function    CreateField(const FieldName,DisplayName:string; FieldSize:integer): TTextField;
    procedure   EndCreateField;
    property    RowSize : integer read FRowSize;
    function    FieldByName(const AFieldName:string): TTextField;
    function    FindField(const AFieldName:string): TTextField;
    function    FieldCount: integer;
    property    Fields[index : integer]: TTextField read GetFields;
    procedure   Clear;
    procedure   ClearData;
    procedure   Append;
    procedure   AppendData(const data : array of string); overload;
    procedure   AppendData(const dataStr : string); overload;
    procedure   first;
    procedure   Next;
    procedure   Prior;
    procedure   Last;
    property    Eof : boolean read FEof;
    property    Bof : boolean read FBof;
    property    Count : integer read FCount;
    function    Available : boolean;
    procedure   CheckAvailable;
    property    Cursor : integer read FCursor write SetCursor;
    property    CurRow : pointer read FCurRow;
    property    MinRowsPerBuffer : Integer read FMinRowsPerBuffer write FMinRowsPerBuffer;
  published

  end;

  TCharset = set of char;

  TTextDataStore = class
  private
    FDataset: TTextDataset;
    FPackchars : TCharset;
    procedure   ReadFieldDesc(Stream:TStream);
    procedure   WriteFieldDesc(Stream:TStream);
  public
    constructor Create(ADataset : TTextDataset;const apackChars : TCharset=DefaultPackChars);
    property    Dataset : TTextDataset read FDataset;
    procedure   LoadFromStream(Stream:TStream);
    procedure   SaveToStream(Stream:TStream);
    procedure   LoadFromFile(const FileName:String);
    procedure   SaveToFile(const FileName:String);
    //  for Expert's usage
    procedure   AppendDataFromStream(Stream:TStream);
    function    SaveDataToStream(Stream:TStream;ARowCount : integer):integer;
  end;

  TTextStreamReader = class
  private
    FStream: TStream;
  public
    constructor Create(AStream : TStream);
    property    Stream : TStream read FStream;
    procedure   SkipBlank;
    function    ReadChar:char;
    procedure   CheckChar(ACh : Char);
    function    ReadUntil(UntilChar:char): string;
    function    Eof : boolean;
    function    peekChar:char;
  end;

const
  MemoryBufferBlockSize = 4 * 1024;

function  getReadableText(const S:string):string;

function  packString(const s:string; const packChars : TCharset):string;

function  unpackString(const s:string):string;

implementation

uses SafeCode;

{ TTextField }

constructor TTextField.Create(ADataset : TTextDataset; ASize : integer;AOffset : integer);
begin
  inherited Create;
  FDataset := ADataset;
  FSize := ASize;
  FOffset := AOffset;
end;

function TTextField.GetDataBuffer: Pchar;
begin
  result :=  pchar(FDataset.FCurRow);
  CheckPtr(result,'No TextField Buffer!');
  inc(result,FOffset);
end;

function TTextField.GetExtraBytePointer: PByte;
begin
  result :=  pbyte(FDataset.FCurRow);
  CheckPtr(result,'No TextField Buffer!');
  inc(result,FOffset+FSize);
end;


function TTextField.GetExtraByte: byte;
begin
  result := GetExtraBytePointer^;
end;

procedure TTextField.SetExtraByte(const Value: byte);
begin
  GetExtraBytePointer^ := value;
end;


function TTextField.GetValue: string;
var
  DataBuffer : PChar;
begin
  DataBuffer := GetDataBuffer;
  result := String(pchar(DataBuffer));
end;

procedure TTextField.SetValue(const Value: string);
var
  DataBuffer : PChar;
  le : integer;
begin
  DataBuffer := GetDataBuffer;
  FillChar(DataBuffer^,FSize,0);
  le := length(value);
  if le>FSize then le:=FSize;
  Move(pchar(Value)^,DataBuffer^,le)
end;


{ TDataBuffer }

constructor TDataBuffer.Create(ARowSize, AMaxRows: integer);
begin
  Assert(ARowSize>1);
  Assert(AMaxRows>1);
  inherited Create;
  FRowSize := ARowSize;
  FMaxRows := AMaxRows;
  FSize := FRowSize * FMaxRows;
  GetMem(FBuffer,FSize);
  FillChar(FBuffer^,Fsize,0);
  FCount:=0;
  FNextBuffer := nil;
  FPriorBuffer := nil;
end;

destructor TDataBuffer.Destroy;
begin
  FreeMem(FBuffer,FSize);
  inherited;
end;

function TDataBuffer.CanAppend: boolean;
begin
  result := FCount<FMaxRows;
end;

function TDataBuffer.Append: pointer;
begin
  CheckTrue(CanAppend,'Error : Cannot Append.');
  result := FBuffer;
  inc(pchar(result),FRowSize*FCount);
  inc(FCount);
  fillChar(result^,FRowSize,0);
end;

function TDataBuffer.RowBuffer(RowIndex: integer): pointer;
begin
  if (RowIndex>=FCount) or (RowIndex<0) then
    result:=nil else
    begin
      result:=FBuffer;
      inc(pchar(result),FRowSize*RowIndex);
    end;
end;

{ TTextDataset }

constructor TTextDataset.Create;
begin
  inherited;
  FFields := TObjectList.Create;
  FFirstBuffer:= nil;
  FLastBuffer := nil;
  FCurBuffer := nil;
  FCurRow := nil;
  FCount := 0;
  FBufferMaxRows := 0;
  FRowSize  := 0;
  FMinRowsPerBuffer := 8;
end;

destructor TTextDataset.Destroy;
begin
  Clear;
  FFields.free;
  inherited;
end;

procedure TTextDataset.Clear;
begin
  ClearData;
  ClearFields;
end;

procedure TTextDataset.ClearData;
var
  BuffObj,NextBuffObj : TDataBuffer;
begin
  BuffObj := FFirstBuffer;
  while BuffObj<>nil do
  begin
    NextBuffObj := BuffObj.NextBuffer;
    BuffObj.free;
    BuffObj := NextBuffObj;
  end;
  FFirstBuffer := nil;
  FLastBuffer := nil;
  FCurBuffer := nil;
  FCurRow := nil;
  FCount := 0;
  FBof := true;
  FEof := true;
  FCursor := 0;
  FBuffCursor := 0;
end;

procedure TTextDataset.ClearFields;
begin
  FFields.Clear;
end;

function TTextDataset.CreateField(const FieldName, DisplayName: string;
  FieldSize: integer): TTextField;
begin
  Result := TTextField.Create(self,FieldSize,FOffset);
  Result.FFieldName := FieldName;
  Result.FDisplayName := DisplayName;
  // one char for #0
  inc(FOffset,FieldSize+1);
  FFields.Add(result);
end;

procedure TTextDataset.BeginCreateField;
begin
  Clear;
  FOffset := 0;
end;

procedure TTextDataset.EndCreateField;
begin
  CalculateMemory;
end;


procedure TTextDataset.CreateFields(const FieldDescS: String);
begin

end;

procedure TTextDataset.CreateFields(const FieldDescA: array of const);
var
  i : integer;
  le : integer;
  FieldName,DisplayName:string;
  FieldSize:integer;
begin
  i := 0;
  le := length(FieldDescA);
  BeginCreateField;
  CheckTrue((le mod 3)=0,'Error : (TTextDataset.CreateFields)FieldDescA Length Error');
  while i<le do
  begin
    with FieldDescA[i] do
    case VType of
      vtString :      FieldName := VString^;
      vtAnsiString :  FieldName := string(VAnsiString);
      vtChar       :  FieldName := VChar;
    else
      CheckTrue(false,'Error : (TTextDataset.CreateFields)FieldDescA DataType Error');
    end;
    with FieldDescA[i+1] do
    case VType of
      vtString :      DisplayName := VString^;
      vtAnsiString :  DisplayName := string(VAnsiString);
      vtChar       :  DisplayName := VChar;
    else
      CheckTrue(false,'Error : (TTextDataset.CreateFields)FieldDescA DataType Error');
    end;
    CheckTrue(FieldDescA[i+2].VType=vtInteger,'Error : (TTextDataset.CreateFields)FieldDescA DataType Error');
    FieldSize := FieldDescA[i+2].VInteger;
    CreateField(FieldName,DisplayName,FieldSize);
    inc(i,3);
  end;
  EndCreateField;
end;

procedure TTextDataset.CalculateMemory;
begin
  FRowSize := FOffset;
  checkTrue(FRowSize>0,'TextDataset Rowsize Error!');
  FBufferMaxRows := MemoryBufferBlockSize div FRowSize;
  if FBufferMaxRows<8 then FBufferMaxRows:=MinRowsPerBuffer;
end;

function TTextDataset.CreateBuffer: TDataBuffer;
begin
  Result := TDataBuffer.Create(FRowSize,FBufferMaxRows);
end;


procedure TTextDataset.Append;
var
  NewBuff : TDataBuffer;
begin
  CheckAvailable;
  if FFirstBuffer=nil then
  begin
    // init buffers
    FFirstBuffer := CreateBuffer;
    FLastBuffer := FFirstBuffer;
    FCurBuffer := FFirstBuffer;
  end;
  if not FLastBuffer.CanAppend then
  begin
    NewBuff := CreateBuffer;
    NewBuff.PriorBuffer := FLastBuffer;
    FLastBuffer.NextBuffer := NewBuff;
    FLastBuffer := NewBuff;
  end;
  FCurBuffer := FLastBuffer;
  FCurRow := FLastBuffer.Append;
  inc(FCount);
  // set cursor
  FCursor := FCount-1;
  FBuffCursor := FCurBuffer.Count-1;
  //FEof := true;
  FEof := false;
  FBof := false;
end;

procedure TTextDataset.AppendData(const dataStr: string);
begin
  CheckAvailable;
end;

procedure TTextDataset.AppendData(const data: array of string);
var
  i : integer;
  le : integer;
begin
  CheckAvailable;
  le := length(data);
  CheckTrue(le<=FieldCount,'Error : (TTextDataset.AppendData)len>FieldCount');
  Append;
  for i:=0 to le-1 do
    Fields[i].Value := data[i];
end;

function TTextDataset.FieldByName(const AFieldName: string): TTextField;
begin
  result := FindField(AFieldName);
  CheckObject(result,'Error : not TTextField '+AFieldName);
end;

function TTextDataset.FindField(const AFieldName: string): TTextField;
var
  i : integer;
begin
  Result := nil;
  for i:=0 to Fieldcount-1 do
    if CompareText(Fields[i].FieldName,AFieldName)=0 then
    begin
      Result := Fields[i];
      break;
    end;
end;

function TTextDataset.FieldCount: integer;
begin
  result := FFields.Count;
end;

function TTextDataset.GetFields(index: integer): TTextField;
begin
  result := TTextField(FFields[index]);
end;

procedure TTextDataset.first;
begin
  CheckAvailable;
  FCursor := 0;
  FBuffCursor := 0;
  FBof := true;
  if FCount=0 then
    FEof := true else
    begin
      FEof := false;
      FCurBuffer := FFirstBuffer;
      FCurRow := FCurBuffer.FBuffer;
    end;
end;

procedure TTextDataset.Last;
begin
  CheckAvailable;
  FCursor := FCount-1;
  FEof := true;
  if FCount=0 then
    FBof := true else
    begin
      FBof := false;
      FCurBuffer := FLastBuffer;
      FBuffCursor := FCurBuffer.Count-1;
      FCurRow := FCurBuffer.RowBuffer(FBuffCursor);
    end;
end;

procedure TTextDataset.Next;
begin
  CheckAvailable;
  if (FCursor>=FCount-1) OR (FCount=0) then
    begin
      FEof := true;
      // new add
      if FCount>0 then FBof := false;
      // end new
    end else
    begin
      FBof := false;
      inc(FCursor);
      inc(FBuffCursor);
      if FBuffCursor>=FCurBuffer.Count then
      begin
        FCurBuffer:=FCurBuffer.NextBuffer;
        FBuffCursor:=0;
        Assert(FCurBuffer<>nil);
      end;
      FCurRow := FCurBuffer.RowBuffer(FBuffCursor);
    end;
end;

procedure TTextDataset.Prior;
begin
  CheckAvailable;
  if (FCursor<=0) OR (FCount=0) then
    begin
      FBof := true;
      // new add
      if FCount>0 then FEof := false;
      // end new
    end  else
    begin
      FEof := false;
      dec(FCursor);
      dec(FBuffCursor);
      if FBuffCursor<0 then
      begin
        FCurBuffer:=FCurBuffer.PriorBuffer;
        FBuffCursor:=FCurBuffer.count-1;
        Assert(FCurBuffer<>nil);
      end;
      FCurRow := FCurBuffer.RowBuffer(FBuffCursor);
    end;
end;

function TTextDataset.Available: boolean;
begin
  result := FFields.Count>0;
end;

procedure TTextDataset.CheckAvailable;
begin
  CheckTrue(Available,'Error : TTextDataset not Available');
end;

// function utilities
function  getReadableText(const S:string):string;
var
  i,le : integer;
begin
  result := '';
  le := length(s);
  for i:=1 to le do
  begin
    if ((s[i]>#33) and (s[i]<>'"')) then
      result:=result+s[i];
  end;
end;

procedure TTextDataset.SetCursor(const Value: integer);
var
  Rest : integer;
begin
  if FCursor <> Value  then
  begin
    FCursor:=value;
    {  // old version : bug when count=0,value<0, then feof => false *
    if FCursor>=FCount then
    begin
      FCursor:=FCount-1;
      FEof := true;
    end else
    if FCursor<FCount-1 then FEof := false;
    if FCursor<0 then
    begin
      FCursor:=0;
      FBof := true;
    end else
    if FCursor>0 then FBof:=false;
    }
    if FCursor>=FCount then
    begin
      FCursor:=FCount-1;
      FEof := true;
    end;
    if FCursor<0 then
    begin
      FCursor:=0;
      FBof := true;
    end;
    // now 0<=FCusor<=FCount (FCusor=FCount, when FCount=0)
    if FCursor<FCount-1 then FEof := false;
    if FCursor>0 then FBof:=false;
    // new version
    if FCount>0 then
    begin
      Rest := FCursor;
      FCurBuffer := FFirstBuffer;
      while FCurBuffer.Count<=Rest do
      begin
        dec(Rest,FCurBuffer.Count);
        FCurBuffer := FCurBuffer.NextBuffer;
      end;
      FBuffCursor := Rest;
      FCurRow := FCurBuffer.RowBuffer(FBuffCursor);
    end;
  end;
end;

{ TTextDataStore }

constructor TTextDataStore.Create(ADataset: TTextDataset;const apackChars : TCharset=DefaultPackChars);
begin
  FDataset  := ADataset;
  FPackchars := apackChars;
end;

procedure TTextDataStore.LoadFromFile(const FileName: String);
var
  FS : TFileStream;
begin
  FS := TFileStream.Create(Filename,fmOpenRead);
  try
    LoadFromStream(FS);
  finally
    FS.free;
  end;
end;


procedure TTextDataStore.SaveToFile(const FileName: String);
var
  FS : TFileStream;
begin
  FS := TFileStream.Create(Filename,fmCreate);
  try
    SaveToStream(FS);
  finally
    FS.free;
  end;
end;

procedure TTextDataStore.ReadFieldDesc(Stream: TStream);
var
  Reader : TTextStreamReader;
  DisplayName,FieldName,FieldSize : string;
  ch : char;
begin
  Dataset.BeginCreateField;
  try
    Reader := TTextStreamReader.Create(Stream);
    try
      repeat
        Reader.CheckChar('"');
        DisplayName := UnpackString(Reader.ReadUntil('"'));
        Reader.CheckChar('=');
        Reader.CheckChar('"');
        FieldName := UnpackString(Reader.ReadUntil('"'));
        Reader.CheckChar('[');
        FieldSize := Trim(Reader.ReadUntil(']'));
        Dataset.CreateField(FieldName,DisplayName,StrToInt(FieldSize));
        Reader.SkipBlank;
        ch := Reader.ReadChar;
        if ch=';' then
          break else
          checkTrue(ch=',','[1]Check Char , but is '+ch);
      until false;
    finally
      Reader.free;
    end;
    Dataset.EndCreateField;
  Except
    Dataset.Clear;
  end;
end;

procedure TTextDataStore.LoadFromStream(Stream: TStream);
begin
  ReadFieldDesc(Stream);
  AppendDataFromStream(Stream);
end;

procedure TTextDataStore.AppendDataFromStream(Stream: TStream);
var
  Reader : TTextStreamReader;
  col : integer;
  value : string;
  ch : char;
begin
  Reader:=nil;
  try
    Dataset.CheckAvailable;
    Reader := TTextStreamReader.Create(Stream);
    Reader.SkipBlank;
    while not Reader.eof do
    begin
      if Reader.peekChar='.' then break; // data end
      Dataset.Append;
      col := 0;
      repeat
        Reader.CheckChar('"');
        Value := UnpackString(Reader.ReadUntil('"'));
        checkTrue(col<Dataset.FieldCount,'Column out of range');
        Dataset.Fields[col].value := Value;
        inc(col);
        Reader.SkipBlank;
        ch := Reader.ReadChar;
        if ch=';' then
          break else
          checkTrue(ch=',','[2]Check Char , but is '+ch
            +' cols:'+IntToStr(col)+ ' rows:'+IntToStr(FDataset.Count));
      until false;
      Reader.SkipBlank;
    end;
  finally
    Reader.free;
  end;
end;

procedure TTextDataStore.WriteFieldDesc(Stream: TStream);
var
  i : integer;
  S : string;
begin
  S := '';
  for i:=0 to Dataset.Fieldcount-1 do
  begin
    if i>0 then s:=s+',';
    // <Field> ::= "<DisplayName>"="<FieldName>"[<FieldLength>]
    with Dataset.Fields[i] do
      S := S + format('"%s"="%s"[%d]',
        [PackString(DisplayName,FPackchars),
         PackString(FieldName,FPackchars),
         Size]);
  end;
  s := s+';'#13#10;
  Stream.Write(pchar(s)^,length(s));
end;

function  TTextDataStore.SaveDataToStream(Stream:TStream;ARowCount: integer):integer;
var
  i : integer;
  s : string;
begin
  Dataset.CheckAvailable;
  // write data
  with dataset do
  begin
    //first;
    Result := 0;
    while (not eof) and ((ARowCount>Result) or (ARowCount<0)) do
    begin
      s := '';
      for i:=0 to Fieldcount-1 do
      begin
        if i>0 then s:=s+',';
        s:=s+'"'+PackString(Fields[i].value,FPackchars)+'"';
      end;
      s:=s+';'#13#10;
      Stream.Write(s[1],length(s));
      next;
      inc(Result);
    end;
  end;
end;

procedure TTextDataStore.SaveToStream(Stream: TStream);
begin
  Dataset.CheckAvailable;
  WriteFieldDesc(Stream);
  Dataset.first;
  SaveDataToStream(Stream,-1);
end;


{
function TTextDataStore.ReadUntil(Stream: TStream;
  UntilChar: char): string;
begin

end;
}
{ TTextStreamReader }

constructor TTextStreamReader.Create(AStream: TStream);
begin
  FStream := AStream;
end;

function TTextStreamReader.ReadChar: char;
begin
  Stream.Read(result,sizeof(char));
end;

procedure TTextStreamReader.CheckChar(ACh: Char);
var
  c : char;
begin
  SkipBlank;
  c:=ReadChar;
  CheckTrue(ACh=c,'CheckChar Error Need '+ACh+' but is '+c);
end;

function TTextStreamReader.ReadUntil(UntilChar: char): string;
var
  ch : char;
begin
  result := '';
  while Stream.Position<Stream.Size do
  begin
    Stream.Read(ch,sizeof(char));
    if ch<>UntilChar then
      result := result + ch else
      break;
  end;
end;

procedure TTextStreamReader.SkipBlank;
var
  Ch : Char;
begin
  while Stream.Position<Stream.Size do
  begin
    Stream.Read(ch,sizeof(char));
    if (ch>#32) and (ch<>' ') then
    begin
      Stream.Position := Stream.Position - sizeof(char);
      break;
    end;
  end;
end;

function TTextStreamReader.Eof: boolean;
begin
  Result := Stream.Position>=Stream.Size;
end;

function TTextStreamReader.peekChar: char;
begin
  if not eof then
  begin
    Stream.Read(result,sizeof(char));
    Stream.seek(-1,soFromCurrent);
  end else
    result := #0;
end;

const
  HexChars : string[16] = '0123456789ABCDEF';

function  packString(const s:string; const packChars : TCharset):string;
var
  i,l : integer;
  p1,p2 : pchar;
begin
  l := length(s);
  if l=0 then
    result := '' else
    begin
      i := 0;
      setLength(result,3*l);
      p1 := pchar(s);
      p2 := pchar(result);
      while p1^<>#0 do
      begin
        if p1^ in packChars then
        begin
          // need pack
          p2^:='\';
          inc(p2);
          p2^:=HexChars[1 + byte(p1^) shr 4];
          inc(p2);
          p2^:=HexChars[1 + byte(p1^) and $0F];
          inc(p2);
          inc(p1);
          i:=i+3;
        end else
        begin
          p2^:=p1^;
          inc(p1);
          inc(p2);
          inc(i);
        end;
      end;
      p2^:=#0;
      setLength(result,i);
    end;
end;

function  unpackString(const s:string):string;

  function hex2int(c: char) : byte;
  begin
    if (c>='0') and (c<='9') then
      result:=byte(c)-byte('0')
    else if (c>='A') and (c<='F') then
      result:=10+byte(c)-byte('A')
    else if (c>='a') and (c<='f') then
      result:=10+byte(c)-byte('a')
    else result:=0;
  end;

var
  i,l : integer;
  p1,p2 : pchar;
  char1,char2:char;
begin
  l := length(s);
  if l=0 then
    result := '' else
    begin
      i := 0;
      setLength(result,l);
      p1 := pchar(s);
      p2 := pchar(result);
      while p1^<>#0 do
      begin
        if p1^='\'  then
        begin
          // need unpack
          inc(p1);
          char1:=p1^;
          inc(p1);
          char2:=p1^;
          inc(p1);
          p2^ := char(hex2int(char1) shl 4+hex2int(char2));
          inc(p2);
          inc(i);
        end else
        begin
          p2^:=p1^;
          inc(p1);
          inc(p2);
          inc(i);
        end;
      end;
      p2^:=#0;
      setLength(result,i);
    end;
end;
end.
