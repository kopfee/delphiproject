unit FilterStreams;

interface

uses SysUtils, Classes;

const
  FilterBufferSize = 1024;

type
  PByte = ^Byte;
  
  IStreamFilter = interface
    function    Read(Stream : TStream; var Buffer; Count: Longint): Longint;
    function    Write(Stream : TStream; const Buffer; Count: Longint): Longint;
    function    Seek(Stream : TStream; Offset: Longint; Origin: Word): Longint;
  end;

  TFilterStream = class(TStream)
  private
    FOriginStream : TStream;
    FFilter : IStreamFilter;
  protected

  public
    constructor Create(AOriginStream : TStream; AFilter : IStreamFilter);
    destructor  Destroy; override;
    function    Read(var Buffer; Count: Longint): Longint; override;
    function    Write(const Buffer; Count: Longint): Longint; override;
    function    Seek(Offset: Longint; Origin: Word): Longint; override;
    property    OriginStream : TStream read FOriginStream;
    property    Filter : IStreamFilter read FFilter;
  end;

  TXorFilter =  class(TInterfacedObject, IStreamFilter)
  private
    FKey : string;
    FKeyLength : Integer;
    FKeyIndex : Integer;
  public
    constructor Create(const AKey : string);
    function    Read(Stream : TStream; var Buffer; Count: Longint): Longint;
    function    Write(Stream : TStream; const Buffer; Count: Longint): Longint;
    function    Seek(Stream : TStream; Offset: Longint; Origin: Word): Longint;
    property    Key : string read FKey;
  end;

implementation

{ TFilterStream }

constructor TFilterStream.Create(AOriginStream: TStream; AFilter : IStreamFilter);
begin
  Assert((AOriginStream<>nil) and (AFilter<>nil));
  FOriginStream := AOriginStream;
  FFilter := AFilter;
end;

destructor TFilterStream.Destroy;
begin
  FFilter := nil;
  inherited;
end;

function TFilterStream.Read(var Buffer; Count: Integer): Longint;
begin
  Result := Filter.Read(OriginStream,Buffer,Count);
end;

function TFilterStream.Seek(Offset: Integer; Origin: Word): Longint;
begin
  Result := Filter.Seek(OriginStream,Offset,Origin);
end;

function TFilterStream.Write(const Buffer; Count: Integer): Longint;
begin
  Result := Filter.Write(OriginStream,Buffer,Count);
end;

{ TXorFilter }

constructor TXorFilter.Create(const AKey: string);
begin
  FKey := AKey;
  FKeyLength := Length(FKey);
  Assert(FKeyLength>0);
  FKeyIndex := 0;
end;

function TXorFilter.Read(Stream: TStream; var Buffer;
  Count: Integer): Longint;
var
  I : Integer;
  P : PByte;
begin
  Result := Stream.Read(Buffer,Count);
  P := @Buffer;
  for I:=0 to Result-1 do
  begin
    P^ := P^ xor Ord(Key[FKeyIndex+1]);
    FKeyIndex := (FKeyIndex+1) mod FKeyLength;
    Inc(P);
  end;
end;

function TXorFilter.Write(Stream: TStream; const Buffer;
  Count: Integer): Longint;
var
  I : Integer;
  PBuffer, PFilterBuffer : PByte;
  FilterBuffer : array[0..FilterBufferSize-1] of Byte;
  BufferSize : Integer;
  WriteSize  : Integer;
begin
  Result := 0;
  PBuffer := @Buffer;

  while Count>0 do
  begin
    if Count>FilterBufferSize then
      BufferSize := FilterBufferSize else
      BufferSize := Count;
    Move(PBuffer^,FilterBuffer,BufferSize);
    Inc(PBuffer, BufferSize);
    Dec(Count, BufferSize);
    PFilterBuffer := @FilterBuffer;
    for I:=0 to BufferSize-1 do
    begin
      PFilterBuffer^ := PFilterBuffer^ xor Ord(Key[FKeyIndex+1]);
      FKeyIndex := (FKeyIndex+1) mod FKeyLength;
      Inc(PFilterBuffer);
    end;
    WriteSize := Stream.Write(FilterBuffer,BufferSize);;
    Inc(Result,WriteSize);
    if WriteSize<BufferSize then
      Break;
  end;
end;

function TXorFilter.Seek(Stream: TStream; Offset: Integer;
  Origin: Word): Longint;
begin
  Result := Stream.Seek(Offset,Origin);
  FKeyIndex := Result mod FKeyLength;
end;

end.
