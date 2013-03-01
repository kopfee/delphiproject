unit TextUtils;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> TextUtils
   <What> 用于处理文本的工具
   <Written By> Huang YanLai
   <History>
**********************************************}


interface

uses classes,sysUtils;

type
  {
    <Class>TTextFilter
    <What>文本过滤器。用于从流里面读取/写入文本
    <Properties>
      -
    <Methods>
      Create - 根据一个流或者文件创建过滤器。
    <Event>
      -
  }
  TTextFilter = class
  private
    FStream: TStream;
    FOwnStream: boolean;
    procedure   SetStream(const Value: TStream);
    procedure   FreeStream;
  protected
    function    CreateFileStream(const FileName:string): TStream; virtual; abstract;
  public
    constructor Create(aStream : TStream); overload;
    constructor Create(const FileName:string); overload;
    Destructor  Destroy;override;
    property    Stream : TStream read FStream write SetStream;
  end;

  {
    <Class>TTextWriter
    <What>文本写入过滤器
    <Properties>
      -
    <Methods>
      Print - 写入一个字符串或者字符串列表。
      Println - 写入一个字符串和换行符号
    <Event>
      -
  }
  TTextWriter = class(TTextFilter)
  private

  protected
    function    CreateFileStream(const FileName:string): TStream; override;
  public
    procedure   Print(const s:string); overload;
    procedure   Print(const strs:TStrings); overload;
    procedure   Println(const s:string);
  end;

  {
    <Class>TTextReader
    <What>文本读入过滤器
    <Properties>
      IsFilterLines - 在Readln的时候，是否去掉两边的多余空格并且过滤掉注释行
      CommonChar - 注释行的起始字符
    <Methods>
      ReadChar - 读一个字符
      Readln - 读一行字符
      Eof - 是否结束
    <Event>
      -
  }
  TTextReader = class(TTextFilter)
  private
    FIsFilterLines: Boolean;
    FCommonChar: Char;
    function    InternalReadln : String;
  protected
    function    CreateFileStream(const FileName:string): TStream; override;
  public
    function    ReadBuffer(var Buffer; Size:Integer):Integer;
    function    ReadChar: Char;
    function    Readln : String;
    function    Eof : Boolean;
    property    IsFilterLines : Boolean read FIsFilterLines write FIsFilterLines;
    property    CommonChar : Char read FCommonChar write FCommonChar;
  end;

implementation

uses safeCode;

{ TTextFilter }

constructor TTextFilter.Create(aStream: TStream);
begin
  FStream:=aStream;
  FOwnStream := false;
end;

constructor TTextFilter.Create(const FileName: string);
begin
  FOwnStream := true;
  FStream := CreateFileStream(FileName);
end;

destructor TTextFilter.Destroy;
begin
  FreeStream;
  inherited;
end;

procedure TTextFilter.FreeStream;
begin
  if (FStream<>nil) and (FOwnStream) then
  begin
    FreeAndNil(FStream);
    FOwnStream:=false;
  end;
end;

procedure TTextFilter.SetStream(const Value: TStream);
begin
  CheckObject(Value,'Stream Invalid');
  if FStream<>value then
  begin
    FreeStream;
    FStream:=value;
  end;
end;

{ TTextWriter }

procedure TTextWriter.Print(const s: string);
begin
  FStream.WriteBuffer(pchar(s)^,length(s));
end;

function TTextWriter.CreateFileStream(const FileName: string): TStream;
begin
  Result := TFileStream.Create(FileName,fmCreate);
end;

procedure TTextWriter.Print(const strs: TStrings);
begin
  strs.SaveToStream(FStream);
end;

procedure TTextWriter.Println(const s: string);
const
  lineBreak : array[0..1] of char = (#13,#10);
begin
  FStream.WriteBuffer(pchar(s)^,length(s));
  FStream.WriteBuffer(lineBreak,sizeof(lineBreak));
end;

{ TTextReader }

function TTextReader.CreateFileStream(const FileName: string): TStream;
begin
  Result := TFileStream.Create(FileName,fmOpenRead);
end;

function TTextReader.Eof: Boolean;
begin
  Result := FStream.Position>=FStream.Size;
end;

function TTextReader.InternalReadln: String;
var
  AChar : Char;
begin
  Result := '';
  while FStream.Position<FStream.Size do
  begin
    FStream.Read(AChar,Sizeof(AChar));
    if not (AChar in [#13,#10]) then
      Result := Result + AChar
    else
    begin
      // skip #13, #10
      while (FStream.Position<FStream.Size) and (AChar in [#13,#10]) do
        FStream.Read(AChar,Sizeof(AChar));
      if not (AChar in [#13,#10]) then
        FStream.Seek(-1,soFromCurrent);
      Break;
    end;
  end;
end;

function TTextReader.ReadBuffer(var Buffer; Size: Integer): Integer;
begin
  Result := FStream.Read(Buffer,Size);
end;

function TTextReader.ReadChar: Char;
begin
  FStream.Read(Result,sizeof(Result));
end;

function TTextReader.Readln: String;
begin
  Result := '';
  while not eof do
  begin
    Result := InternalReadln;
    if not FIsFilterLines then
      Break
    else
    begin
      Result := Trim(Result);
      if (Result<>'') and (Result[1]<>FCommonChar) then
        Break
      else
        Result := '';
    end;
  end
end;

end.
