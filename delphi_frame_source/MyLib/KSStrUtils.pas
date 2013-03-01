unit KSStrUtils;
{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>StrUtils
   <What>字符串处理函数
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

interface

uses SysUtils, Classes;

(******************************
  文件名处理
*******************************)

{
  <Function>ExtractOnlyFileName
  <What>取仅仅文件名部分，不包括路径和后缀
  <Params>
    -
  <Return>
  <Exception>
}
function ExtractOnlyFileName(const FileName:string):string;

{
  <Procedure>ParseFileName
  <What>将文件名分解为文件名和后缀两部分
  <Params>
    FullName-完整名称
    FileName-文件名称部分，包含文件路径(如果FullName里面包含路径)
    Ext-文件后缀
  <Exception>
}
procedure ParseFileName(const FullName:string; var FileName,Ext:string);

{
  <Function>RelativeToFull
  <What>将相对路径转换为实际路径。
  <Params>
    Base-相对路径的参照路径
    Relative-需要转换的路径
  <Return>
    如果Relative是一个相对路径（不包含驱动器名称、第一个字符不是'\'），那么返回Base+Relative，
    否则返回Relative
  <Exception>
}
function  RelativeToFull(const Base,Relative : string):string;

{
  <Function>AddPathAndName
  <What>根据路径和文件名合成文件全路径。特别处理了'\'字符
  if path like '*\'
    result := Path + FileName
  else
    result := Path + '\' + FileName
  <Params>
    -
  <Return>
  <Exception>
}
function  AddPathAndName(const Path,FileName: string): string;

{
  <Function>ExpandPath
  <What>保证返回的字符串是可以作为路径，加到文件名以前。
  <Params>
    -
  <Return>
  如果Path为空，返回为空；否则返回值＝Path(Path的最后一个字符是'\')或者Path+'\'
  <Exception>
}
function  ExpandPath(const Path : string) : string;

{
  <Function> 从相对文件名里面获取别名
  <What>
  <Params>
    FileName - 格式是'$(Alias)\path'
  <Return>
  <Exception>
}
function  getAliasFromFileName(const FileName:string): string;

{
  <Procedure>ParseAlias
  <What>分析文件名，返回别名和相对路径部分。
  如果FileName是正确的别名形式'$(Alias)\path'，返回别名和路径；
  否则别名为空，路径和FileName相同
  <Params>
    -
  <Exception>
}
procedure ParseAlias(const FileName:string; var Alias,path:string);

type
  {
    <Class>EAliasNotDefined
    <What>找不到别名的意外
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  EAliasNotDefined = class(Exception);

{
  <Procedure>RaiseAliasNotDefined
  <What>抛出没有别名的意外
  <Params>
    -
  <Exception>
}
procedure RaiseAliasNotDefined(const Alias : string);

(******************************
  汉字处理
*******************************)

{
  <Function>ValidString
  <What>检查字符串是否包含半个汉字
  <Params>
    -
  <Return>
  <Exception>
}
function ValidString(const S:string): boolean;

{
  <Function>ValidPChar
  <What>检查字符串是否包含半个汉字
  <Params>
    -
  <Return>
  <Exception>
}
function ValidPChar(S:pchar): boolean;

{
  <Procedure>CorrectString
  <What>删除半个汉字
  <Params>
    -
  <Exception>
}
procedure CorrectString(const Source:string; var Dest:string);

{
  <Procedure>CorrectPchar
  <What>删除半个汉字
  <Params>
    -
  <Exception>
}
procedure CorrectPchar(Source,Dest:pchar);

(******************************
  字符串处理
*******************************)

{
  <Function>StringMarch
  <What>确定两个字符串的相似程度。区分大小写
  <Params>
    MatchCount - 返回s1,s2前MatchCount个字符相同
  <Return>
    如果完全相同，返回true，否则false
  <Exception>
}
function  StringMarch(S1,S2:pchar; var MatchCount : integer):boolean;

{
  <Function>StartWith
  <What>判断字符串是否以某特定子串开头（不区分大小写）
  <Params>
    -
  <Return>
  <Exception>
}
function  StartWith(const Str,HeadStr:string): boolean;

{
  <Procedure>seperateStr
  <What>将字符串根据分割符号，分解为多个部分
  <Params>
    str - 原始字符串
    seperateChars - 用来分割的字符，是一个集合
    parts - 保存分解以后的各个部分，一行一个
    delBlank - 是否将每部分左右两边的空白删除
  <Exception>
}
procedure seperateStr(const str:string;
  const seperateChars : TSysCharset;
  parts:TStrings;
  delBlank:boolean=true);

{
  <Procedure>seperateStrByBlank
  <What>根据空白分割字符串
  <Params>
    -
  <Exception>
}
procedure seperateStrByBlank(const str:string;
  parts:TStrings);

{
  <Function>IsNumberCode
  <What>检查S是不是由数字组成的。(S='',return true)
  <Params>
    -
  <Return>
  <Exception>
}
function  IsNumberCode(const S:string) : Boolean;

{
  <Function>IsValidChars
  <What>检查字符串的组成
  <Params>
    ValidChars - 允许的字符的集合
  <Return>
  <Exception>
}
function  IsValidChars(const S:string; ValidChars : TSysCharSet) : Boolean;

{
  <Function>ExpandLeft
  <What>如果S的长度小于Base，那么用Base的左边部分填充S的左边部分
  <Params>
    -
  <Return>
  <Exception>
}
function  ExpandLeft(const S,Base : string): string;

{
  <Function>SpcCapToNormal
  <What>将包含转意符号的字符串还原为普通字符串。转意符号只支持'\n'
  <Params>
    -
  <Return>
  <Exception>
  <Example>
  convert '1\n\\2' to '1'#13#10'\2'
}
function SpcCapToNormal(const SpcCap : string): string;

{
  <Function>NormalToSpcCap
  <What>将普通字符串转换为包含转意符号的字符串。转意符号只支持'\n'
  <Params>
    -
  <Return>
  <Exception>
  <Example>
  convert '1'#13#10'\2' to '1\n\\2'
}
function NormalToSpcCap(const Normal: string): string;

implementation

function ExtractOnlyFileName(const FileName:string):string;
var
  Ext : string;
begin
  {result := ExtractFileName(FileName);
  Ext := ExtractFileExt(result);
  result := copy(result,1,length(result)-length(Ext));}
  ParseFileName(ExtractFileName(FileName),result,Ext);
end;

procedure ParseFileName(const FullName:string; var FileName,Ext:string);
begin
  {FileName:= ExtractFileName(FullName);
  Ext := ExtractFileExt(FileName);
  FileName:= copy(result,1,length(FileName)-length(Ext));}
  Ext := ExtractFileExt(FullName);
  FileName:= copy(FullName,1,length(FullName)-length(Ext));
end;

function  RelativeToFull(const Base,Relative : string):string;
var
  Drive : string;
begin
  result := Relative;
  if (Relative<>'') and (Base<>'') then
  begin
    Drive := ExtractFileDrive(Relative);
    if (Drive='') and (Relative[1]<>'\') then
      if Base[length(Base)]='\' then
        Result := Base+Relative
      else
        Result := Base+'\'+Relative
  end;
end;

function  AddPathAndName(const Path,FileName: string): string;
begin
  if path='' then
    Result := FileName
  else
  if path[length(path)]='\' then
    result := Path + FileName
  else
    result := Path + '\' + FileName;
end;

// FileName = $(Alias)\path
function  getAliasFromFileName(const FileName:string): string;
var
  I : integer;
begin
  result:='';
  if length(FileName)>2 then
    if (FileName[1]='$') and (FileName[2]='(') then
    begin
      I := pos(')',Filename);
      if I>0 then
      begin
        result := Copy(FileName,3,I-2-1);
      end
    end
end;

// ParseAlias
procedure ParseAlias(const FileName:string; var Alias,path:string);
var
  I : integer;
begin
  Alias:='';
  Path:=FileName;
  if length(FileName)>2 then
    if (FileName[1]='$') and (FileName[2]='(') then
    begin
      I := pos(')',Filename);
      if I>0 then
      begin
        Alias := Copy(FileName,3,I-2-1);
        Path := Copy(FileName,I+1,length(FileName)-I);
      end;
    end;
end;

procedure RaiseAliasNotDefined(const Alias : string);
begin
  raise EAliasNotDefined.Create('Alias('+Alias+ ') is not defined!');
end;

// 如果s包含半个汉字，返回false
function ValidString(const S:string): boolean;
begin
  result := ValidPChar(pchar(S));
end;

function ValidPChar(S:pchar): boolean;
var
  ChineseCharCount : integer;
begin
  //result:=true;
  ChineseCharCount:=0;
  if S<>nil then
  begin
    while S^<>#0 do
    begin
      if S^>=#$80 then inc(ChineseCharCount)
      else if (ChineseCharCount mod 2)<>0 then
      begin
        result := false;
        exit;
      end;
      inc(S);
    end;
  end;
  result := (ChineseCharCount mod 2)=0;
end;

procedure CorrectString(const Source:string; var Dest:string);
begin
  setLength(Dest,length(Source));
  CorrectPchar(pchar(source),pchar(Dest));
  setLength(Dest,length(pchar(Dest)));
end;

procedure CorrectPchar(Source,Dest:pchar);
begin
  assert(Source<>nil);
  assert(Dest<>nil);
  while Source^<>#0 do
  begin
    if (source^>=#$80) then
    begin
      if (source+1)^>=#$80 then
      begin
        // total
        Dest^:=source^;
        inc(Dest);
        inc(Source);
        Dest^:=source^;
        inc(Dest);
        inc(Source);
      end
      else inc(Source);
    end
    else
    begin
      Dest^:=source^;
      inc(Dest);
      inc(Source);
    end;
  end;
  Dest^:=#0;
end;

// StringMarch 返回S1,S2的相似程度。
//  MatchCount : s1,s2前MatchCount个字符相同(不包含#0)
//  result : true (完全相同)，false(不同)
function  StringMarch(S1,S2:pchar; var MatchCount : integer):boolean;
begin
  result := false;
  if (s1=nil) or (s2=nil) then
  begin
    MatchCount:=0;
  end
  else
  begin
    MatchCount:=0;
    while (s1^<>#0) and (s2^<>#0) do
      if s1^=S2^ then
      begin
        inc(MatchCount);
        inc(s1);
        inc(s2);
      end
      else
      begin
        result := false;
        exit;
      end;
    if s1^=s2^ then result:=true;
  end;
end;

function  StartWith(const Str,HeadStr:string): boolean;
begin
  result := CompareText(Copy(Str,1,length(HeadStr)),HeadStr)=0;
end;

// seperate str by seperateChars
procedure seperateStr(const str:string;
  const seperateChars : TSysCharset;
  parts:TStrings;
  delBlank:boolean=true);
var
  S : string;
  I,L,K : integer;
begin
  parts.clear;
  L := length(str);
  K := 1;
  for I:=1 to L do
  begin
    if str[I] in seperateChars then
    begin
      S:=copy(str,K,I-K);
      if delBlank then S:=trim(S);
      parts.add(S);
      K:=I+1;
    end;
  end;
  if K<=L then
  begin
    //S:=copy(str,K,I-K);
    S:=copy(str,K,L-K+1);
    if delBlank then S:=trim(S);
    parts.add(S);
  end;
end;

procedure seperateStrByBlank(const str:string;
  parts:TStrings);
var
  S : string;
  I : integer;
begin
  parts.clear;
  S := trim(str);
  S:=StringReplace(S,#9,' ',[rfReplaceAll]);
  I := pos(' ',S);
  while I>0 do
  begin
    parts.add(copy(S,1,I-1));
    delete(S,1,I);
    S:=trim(S);
    I := pos(' ',S);
  end;
  if S<>'' then parts.add(S);
end;

// 检查S是不是由数字组成的。(S='',return true)
function  IsNumberCode(const S:string): Boolean;
var
  P : Pchar;
begin
  Result := true;
  P := Pchar(S);
  while (P<>nil) and (P^<>#0) do
  begin
    if (P^<'0') or (P^>'9') then
    begin
      Result := false;
      break;
    end;
    Inc(P);
  end;
end;

// 如果S的长度小于Base，那么用Base的左边部分填充S的左边部分
function  ExpandLeft(const S,Base : string): string;
var
  len1,len2 : integer;
begin
  len1 := Length(Base);
  len2 := Length(S);
  if len2<Len1 then
    Result := Copy(Base,1,Len1-Len2)+S else
    Result := S;
end;

function  ExpandPath(const Path : string) : string;
begin
  if Path<>'' then
  begin
    if Path[Length(Path)]<>'\' then
      Result := Path+'\' else
      Result := Path;
  end else
    Result := Path;
end;

// 检查字符串的组成
function  IsValidChars(const S:string; ValidChars : TSysCharSet) : Boolean;
var
  P : PChar;
begin
  Result := true;
  P := PChar(S);
  while (P<>nil) and (P^<>#0) do
  begin
    if not (P^ in ValidChars) then
    begin
      Result := false;
      Break;
    end;
    Inc(P);
  end;
end;

function SpcCapToNormal(const SpcCap : string): string;
var
	PSpcCap : pchar;
  PResult,PResult2 : pchar;
begin
  if SpcCap='' then
  begin
    result := '';
    exit;
  end;
  SetLength(Result,length(SpcCap));
  PResult := pchar(Result);
  PResult2 := PResult;
	PSpcCap := pchar(SpcCap);
  if PSpcCap<>nil then
  begin
    while PSpcCap^<>#0 do
    begin
    	if PSpcCap[0]='\' then
      	if PSpcCap[1]='n' then
        begin
          PResult[0]:=#13;
          PResult[1]:=#10;
          inc(PSpcCap);
          inc(PResult);
        end
        else if PSpcCap[1]='\' then
        begin
          PResult[0]:='\';
          inc(PSpcCap);
        end
        else
        	//raise EConvertError.Create('SpcCapToNormal error!')
          PResult[0]:=PSpcCap[0]
      else
        PResult[0]:=PSpcCap[0];
      inc(PSpcCap);
      inc(PResult);
    end;
    PResult^:=#0;
  end;
  SetLength(Result,length(PResult2));
end;

function NormalToSpcCap(const Normal: string): string;
var
	PNormal,PResult,PResult2 : PChar;
begin
	if Normal='' then
  begin
    result := '';
    exit;
  end;
  SetLength(result,2*length(Normal));
  PNormal := pchar(normal);
  PResult := pchar(result);
  PResult2 := PResult;
  if PNormal<>nil then
  begin
    while PNormal^<>#0 do
    begin
    	if (PNormal[0]=#13) and (PNormal[1]=#10) then
      begin
          PResult[0]:='\';
          PResult[1]:='n';
          inc(PNormal);
          inc(PResult);
      end
      else if PNormal[0]='\' then
      begin
          PResult[0]:='\';
          PResult[1]:='\';
          inc(PResult);
      end
      else
        PResult[0]:=PNormal[0];
      inc(PNormal);
      inc(PResult);
    end;
    PResult^:=#0;
  end;
  SetLength(Result,length(PResult2));
end;

end.
