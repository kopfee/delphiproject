unit ConvertUtils;
{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>ConvertUtils
   <What>数据类型转换的函数
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}


interface

uses SysUtils;

(******************************
  转换
*******************************)
// Bool to String Conversion
const
  BoolStrs : array[boolean] of String[5]
    = ('false','true');

function BoolToStr(b:boolean):string;

// Enums To Flags convert.
// Enums likes TSmallSet
type
  TSmallSet = set of 0..(sizeof(LongWord)*8-1);

function 	EnumsToFlags(const Enums;
	const ConvertTable : array of LongWord): LongWord;

// Enum is integer or Enum
// TheSet is integer or a samll set
function 	EnumInSet(const Enum,TheSet): boolean;

function  HexToInt(const s:string): longword;

{ TextToInt
 examples :
      s       result
    123         123
    $12AB       4779
}
function  TextToInt(const s:string): longword;

type
  TFractionType=(ftRound,ftTrunc);

const
  DigtalStr:array[0..9] of String=('零','壹','贰','叁','肆','伍','陆','柒','捌','玖');
  PlusMoneyStr:array[0..6] of String=('元','拾','佰','仟','万','亿','佶');
  NegativeMoneyStr:array[0..2] of String=('角','分','厘');

// Function:    大写金额显示
// Written:     Zeng ChuangNeng
// Date:        2001.8.16
function MoneyToStr(Value: Extended;ShowZero:Boolean=true;Decimals:integer=2;FractionType:TFractionType=ftRound): string;

implementation

function BoolToStr(b:boolean):string;
begin
  result := BoolStrs[b];
end;

function 	EnumsToFlags(const Enums;
	const ConvertTable : array of LongWord): LongWord;
var
  i : integer;
begin
  result := 0;
  for i:=low(ConvertTable) to high(ConvertTable) do
    if i in TSmallSet(Enums) then
    	result := result or ConvertTable[i];
end;

function 	EnumInSet(const Enum,TheSet): boolean;
begin
  result := Integer(Enum) in TSmallSet(TheSet);
end;

function  HexToInt(const s:string): longword;
var
  i : integer;
  c : char;
  dig : longword;
begin
  if length(s)>8 then
    Raise EConvertError.Create('Hex string is too long.');
  result := 0;
  for i:=1 to length(s) do
  begin
    c := UpCase(s[i]);
    if (c>='0') and (c<='9') then
      dig:=ord(c)-ord('0')
    else if (c>='A') and (c<='F') then
      dig:=ord(c)-ord('A')+10
    else
      Raise EConvertError.Create('Hex string is bad.');
    result := (result shl 4) or dig;
  end;
end;

function  TextToInt(const s:string): longword;
begin
  if s='' then raise EConvertError.Create('Error in : TextToInt');
  if s[1]='$' then
    result:=HexToInt(copy(s,2,length(s)-1))
  else
    result := StrToInt(s);
end;


function GetNegativeMoneyStr(Value: Extended;ShowZero:Boolean;Decimals:integer;FractionType:TFractionType): string;
var
  i:integer;
  MonNegative:Int64;
  s:string;
  P,Dig:integer;
begin
  s:='';
  Value:=Frac(Abs(Value));
  if Decimals=0 then
  begin
    Result:='整';
    exit;
  end;
  for i:=1 to Decimals do Value:=Value*10;
  if FractionType=ftRound then MonNegative:=Round(Value)
                           else MonNegative:=Trunc(Value);
  if MonNegative=0 then s:='整'
  else
  begin
    P:=Decimals-1;
    if Decimals>0 then
    while MonNegative<>0 do
    begin
      Dig:=Round(Frac(MonNegative/10)*10);
      MonNegative:=MonNegative div 10;
      if Dig>0 then s:=DigtalStr[Dig]+NegativeMoneyStr[P]+s;
      P:=P-1;
    end;
  end;
  Result:=s;
end;

function GetStrPos(AStr:string):integer;
var
  i:integer;
begin
  Result:=-1;
  for i:=0 to High(PlusMoneyStr) do
  if AStr=PlusMoneyStr[i] then
  begin
    Result:=i;
    Break;
  end;
end;

procedure DeleteZero(Var AStr:WideString);
var
  i,sum,m,n:integer;
begin
  i:=1;
  sum:=Length(AStr);
  while i<=sum do
  begin
    if AStr[i]='0' then
    begin
      if AStr[i+1]='元' then Delete(Astr,i,1)
      else if AStr[i+1]='0' then Delete(Astr,i+1,1)
      else
      begin
        m:=GetStrPos(AStr[i-1]);
        n:=GetStrPos(AStr[i+1]);
        if (m<0) or (n<0) then
        begin
          i:=i+1;
          Continue;
        end;
        if m<n then Delete(Astr,i,1)
               else Delete(Astr,i+1,1);
      end;
      sum:=sum-1;
      Continue;
    end;
    i:=i+1;
  end;
end;

procedure ReplaceDigtal(Var AStr:WideString);
var
  i:integer;
  MyS:WideString;
  Cell:string;
begin
  MyS:='';
  for i:=1 to Length(Astr) do
  begin
    Cell:=Astr[i];
    if Length(Cell)=1 then MyS:=MyS+DigtalStr[StrToInt(Cell)]
    else MyS:=MyS+Cell;
  end;
  Astr:=MyS;
end;


function MoneyToStr(Value: Extended;ShowZero:Boolean=true;Decimals:integer=2;FractionType:TFractionType=ftRound): string;
var
  MonPlus:Int64;
  s:WideString;
  Dig:0..9;
  P:integer;
  StepStr:string;
  PStr:integer;
  PStop:integer;
  Max:integer;
  Temp:Extended;
begin
  if Value=0 then
  begin
    if ShowZero then Result:='零'
                 else Result:='';
    exit;
  end;
  Temp:=ABS(Value);
  if (Decimals=0) and (FractionType=ftRound) then MonPlus:=Round(Temp)
                                              else MonPlus:=Trunc(Temp);
  s:='';
  StepStr:='01234';
  PStr:=1;
  PStop:=5;
  Max:=4;
  while MonPlus<>0 do
  begin
    P:=StrToInt(StepStr[PStr]);
    Dig:=Round(Frac(MonPlus/10)*10);
    MonPlus:=MonPlus div 10;
    s:=IntToStr(Dig)+PlusMoneyStr[P]+s;

    if PStr=PStop then
    begin
      PStop:=2*PStop-1;
      StepStr:=StepStr+Copy(StepStr,2,Length(StepStr)-2)+IntToStr(Max+1);
      Max:=Max+1;
    end;
    PStr:=PStr+1;
  end;

  DeleteZero(s);
  ReplaceDigtal(s);

  s:=s+GetNegativeMoneyStr(Value,ShowZero,Decimals,FractionType);

  if Value<0 then s:='负'+s;
  Result:=s;
end;

end.
