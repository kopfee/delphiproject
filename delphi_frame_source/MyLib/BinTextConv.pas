unit BinTextConv;

interface

uses Classes;

const
  BytesPerLine = 32;

procedure BinToText(BinS,TextS : TStream);

procedure TextToBin(TextS,BinS : TStream);

implementation

procedure BinToText(BinS,TextS : TStream);
var
  Buffer: array[0..BytesPerLine - 1] of Char;
  Text: array[0..BytesPerLine * 2 - 1] of Char;
  count : integer;
const
  LineBreak : array[0..1] of char = (#13,#10);
begin
  while BinS.Position<BinS.Size do
  begin
    count := BinS.Read(Buffer,BytesPerLine);
    if count>0 then
    begin
      BinToHex(Buffer,Text,count);
      TextS.Write(Text,Count*2);
      TextS.Write(LineBreak,2);
    end
    else break;
  end;
end;

{
procedure TextToBin(TextS,BinS : TStream);
var
  Buffer: array[0..BytesPerLine - 1 + 1] of Char;
  Text: array[0..BytesPerLine * 2 - 1 + 2] of Char;
  count,ConvCount : integer;
  Start : integer;
  i : integer;
begin
  while TextS.Position<TextS.Size do
  begin
    count := TextS.Read(Text,BytesPerLine*2+2);
    Start := 0;
    if count>0 then
    begin
      for i:=0 to count-1 do
      begin
        if not (Text[i] in ['0'..'9','A'..'F']) then
          if i>start then
          begin
            ConvCount:=HexToBin(Pchar(@Text[Start]),Buffer,i-Start);
            BinS.Write(Buffer,ConvCount);
            Start := i+1;
          end;
      end;
      if count>Start then
      begin
        ConvCount:=HexToBin(Pchar(@Text[Start]),Buffer,count-Start);
        BinS.Write(Buffer,ConvCount);
      end;
    end
    else break;
  end;
end;
}

procedure TextToBin(TextS,BinS : TStream);
var
  Buffer: array[0..BytesPerLine - 1 ] of Char;
  Text: array[0..BytesPerLine * 2 - 1] of Char;
  count,ConvCharCount : integer;
  Start : integer;
  i : integer;
  BufferCount : integer;

  function  convertText(StartIndex,Chars:integer):integer;
  begin
    result:=HexToBin(Pchar(@Text[StartIndex]),Buffer,Chars);
    BinS.Write(Buffer,result);
  end;

begin
  BufferCount := 0;
  while TextS.Position<TextS.Size do
  begin
    count := TextS.Read(pchar(@Text[BufferCount])^,BytesPerLine*2-BufferCount);
    if count>0 then
    begin
      Start := 0;
      count := BufferCount + count;
      for i:=0 to count-1 do
      begin
        if not (Text[i] in ['0'..'9','A'..'F']) then
        begin
          if i>start then convertText(Start,i-Start);
          Start := i+1;
        end;
      end;
      if count>Start then
      begin
        ConvCharCount := count-Start;
        if (ConvCharCount mod 2)<>0 then dec(ConvCharCount);
        if ConvCharCount>0 then convertText(Start,ConvCharCount);
        BufferCount := count - Start - ConvCharCount;
        if BufferCount>0 then
        begin
          Assert(BufferCount=1);
          Text[0]:=Text[count-1];
        end;
      end;
    end
    else
    begin
      //count := BufferCount;
      break;
    end;
  end;
  // treat last chars
  if BufferCount>0 then
  begin
    Assert(BufferCount=1);
    convertText(0,1);
  end;
end;

end.
