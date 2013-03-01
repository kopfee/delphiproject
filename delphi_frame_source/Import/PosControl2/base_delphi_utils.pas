unit base_delphi_utils;
//自编的具有独特功能的调用工具包.
interface

uses SysUtils, Dialogs, registry, Windows;

function strtochar( const sstr: string ): char;
function countsubstring( const str: string; const substr: string )
                       : integer;
function nformat( var str:string; len:integer ) : boolean ;
function identifilize( var str:string; len:integer ) : boolean ;
function dateformat( var str:string; const separator:string ): boolean ;
procedure logicalexplink( var objectexp:string; const optype:char;
                          const appendexp:string );//粗放型的.
procedure switchtolongyear(var tstr:string; const separator:string);
procedure switchtoshortyear(var tstr:string; const separator:string);
function gethostname: string;
function getusername: string;
function milliseconddiff(starttime: Tdatetime; endtime: Tdatetime)
                        : integer;

implementation

//====================================================================
{
function AsciiValue( ch: char ): Byte;
var
b: Byte;
p: Pointer;
begin
p:=@b;
PChar(p)^:=ch;
result:=b;
end;
//--------------------------------------------------------------------
function AsciiChar( code: Byte ): char;
var
b: Byte;
p: Pointer;
begin
b:=code;
p:=@b;
result:=PChar(p)^;
end;
//--------------------------------------------------------------------
}
function strtochar( const sstr: string ): char;
begin
if (sstr='') then      //当sstr为空时,返回#0.
  result:=#0
else                //否则返回sstr的第一个字符.
  result:=sstr[1];
end;
//--------------------------------------------------------------------
function countsubstring( const str: string; const substr: string )
                       : integer;
var
i, len : integer;
stemp: string;
begin
if substr='' then   //若substr为空,返回 -1 (视为失败)
  begin
    result:=-1;
    exit;
  end;
stemp:=str;
len:=length(substr);
result:=0;
i:=pos(substr, stemp);
while (i<>0) do
  begin
    result:=result+1;
    delete(stemp,1,i+len-1);  //清除整个当前子串(不重叠计数).
    i:=pos(substr, stemp);
  end;
end;
//--------------------------------------------------------------------
function nformat( var str:string; len:integer ) : boolean ;
var
i, l :integer;
ch:string;
allnumflag:boolean;
begin
str:=trim(str);     //预先去除目标串的前导空格和后缀空格.
l:=length(str);
if (len<=0) then len:=l;  //当len参数<=0时, 视要求为----"自然长度"
if l>len then       //目标串超长,视为不合法.
  begin
    result:=false;
    exit;
  end;
if l>0 then         //目标串不够长,则补充前导零.
   for i:=l+1 to len do str:= '0' + str
else                //目标串为空串,视为不合法.
   begin
     result:=false;
     exit;
   end;
allnumflag:=true;   //以下检测目标串是否为全数字串.
l:=1;
while allnumflag and (l<=len) do
  begin
    ch:=copy(str,l,1);
    allnumflag:=( (ch>='0') and (ch<='9') );
    l:=l+1;
  end;
result:=allnumflag;
end;
//--------------------------------------------------------------------
function dateformat( var str:string; const separator:string ): boolean ;
label invalid;
var    // eg. '02/28/1997'
month, day, year, i: integer;
resultstring, stemp, spart: string;
btemp: boolean;
begin
stemp:=str;
i:=countsubstring(stemp, separator);
if i<>2 then goto invalid;    //目标串中所含separator数不等于2,必非法.

i:=pos(separator, stemp);     //截取月份,测试其合法性.
spart:=copy(stemp, 1, i-1);
btemp:=nformat(spart, 2);
if not(btemp)or(spart='') then goto invalid;
month:=strtoint(spart);
if (month<1) or (month>12) then goto invalid;
resultstring:=spart + separator;//合法:则将经规范过的月份值
delete(stemp, 1, i);            //     转移至resultstring.

i:=pos(separator, stemp);     //截取日期,初步测试其合法性.
spart:=copy(stemp, 1, i-1);
btemp:=nformat(spart, 2);
if not(btemp)or(spart='') then goto invalid;
day:=strtoint(spart);
if (day<1) or (day>31) then goto invalid;
resultstring:=resultstring+spart+separator;//初步合法:则将经规范过的
delete(stemp, 1, i);                       //日期值转移至resultstring.

spart:=stemp;       //截取年份,测试其合法性.
btemp:=nformat(spart, 4);
if not(btemp)or(spart='') then goto invalid;
year:=strtoint(spart);
resultstring:=resultstring+spart;       //合法:则将经规范过的年份值(4位)
stemp:='';                              //    转移至resultstring.

if (month=2) then   //再次测试在平,闰年条件下日期(尤其在二月时)的合法性.
  begin
    if day>29 then goto invalid;
    if ((year mod 4)<>0)or(((year mod 100)=0)and((year mod 400)<>0)) then
        if day>28 then goto invalid;
  end
else if (month=4)or(month=6)or(month=9)or(month=11) then
  begin
    if day>30 then goto invalid;
  end;

  str:=resultstring;
  result:=true;
  exit;
invalid:
  str:=resultstring+stemp;
  result:=false;
  exit;
end;
//---------------------------------------------------------------------
function identifilize( var str:string; len:integer ) : boolean ;
var      // 使输入字串'广义标识符'化, 以具备'唯一标识'的能力.
i, l :integer;
begin
str:=trim(str);     //预先去除目标串的前导空格和后缀空格.
l:=length(str);
i:=pos(' ', str);
result:=((l>0)and(l<=len)and(i=0));
//目标串超长或为空串或内含空格,视为不合法.
if (result) then  for i:=l+1 to len do str:=str+' ';
//不够规定长度,则补后缀空格,以保证输出串的格式化.
end;
//---------------------------------------------------------------------
procedure logicalexplink( var objectexp:string; const optype:char;
                          const appendexp:string );
var anotherexp: string;
begin
objectexp:=trim(objectexp);   //尽量缩小字串"体积".
anotherexp:=trim(appendexp);
if (anotherexp='') then       //待加串为空串,则目标串加括号(规范)返回.
  begin
    if (objectexp<>'') then objectexp:='(' + objectexp + ')';
    exit;
  end;
if (objectexp='') then        //目标串原为空串,则取规范后的待加串
  begin                       //    为其新内容.
    objectexp:='(' + anotherexp + ')';
    exit;
  end;
case optype of      //两串皆非空,则按 optype 进行逻辑组合.
  '&': objectexp:='((' + objectexp + ')AND(' + anotherexp + '))';//与
  '|': objectexp:='((' + objectexp + ')OR(' + anotherexp + '))'; //或
  '~': objectexp:='(NOT(' + anotherexp + '))';                     //非
  '^': objectexp:='((' + objectexp + ')XOR(' + anotherexp + '))' //异或
  else    // optype 异常.
    begin
      showmessage('LogicalExpLink error: optype mismatch.');
      abort;
    end;
end;  // of case
end;
//------------------------------------------------------------------
procedure switchtolongyear(var tstr:string; const separator:string);
var       // 仅尽力将串中'年份'部分由'yy'格式转化为'yyyy',不负责纠错.
i, j: integer;
stemp: string;
begin
stemp:=tstr;
i:=pos(separator, stemp);  // 第一个separator
if i=0 then exit;          // 原字串无separator(必错),则原样返回.
delete(stemp, i, 1);
i:=pos(separator, stemp);  // 第二个separator
if i=0 then exit;          // 原字串仅含一个separator(必错),则原样返回.
stemp:=trim( copy(tstr,i+2,length(tstr)-i-2+1) );
j:=length(stemp);
case j of         //整理'年份'字串的末 2位.
  1    : stemp:='0'+stemp;
  2    : ;
  else exit;    //'年份'字串长度 =0(空串)或 >2(已被视为'yyyy'或非法
                  // 超长),则原样返回.
end;  // of case
delete(tstr, i+2, length(tstr)-i-2+1);
stemp:=copy(formatdatetime('yyyy',now), 1, 2)+stemp;
tstr:=tstr+stemp;
end;
//------------------------------------------------------------------
procedure switchtoshortyear(var tstr:string; const separator:string);
var       // 仅尽力将串中'年份'部分由'yyyy'格式转化为'yy',不负责纠错.
i, j: integer;  //一般算法流程下, tstr常常已为合法的'mm/dd/yyyy'格式.
stemp: string;
begin
stemp:=tstr;
i:=pos(separator, stemp);  // 第一个separator
if i=0 then exit;          // 原字串无separator(必错),则原样返回.
delete(stemp, i, 1);
i:=pos(separator, stemp);  // 第二个separator
if i=0 then exit;          // 原字串仅含一个separator(必错),则原样返回.
stemp:=trim( copy(tstr,i+2,length(tstr)-i-2+1) );
j:=length(stemp);
if (j<=2) then exit;//'年份'字串为空或 1<=长度<=2(已被视为'yy'),则原样返回.
stemp:=copy(stemp, j-1, 2);// 一律取'年份'字串的最后2位作为'yy'.
delete(tstr, i+2, length(tstr)-i-2+1);
tstr:=tstr+stemp;
end;
//------------------------------------------------------------------
function gethostname: string;
var
reg: TRegistry;
tstr: string;
boolvar: boolean;
begin
result:='';
reg:=TRegistry.Create;
reg.RootKey:=HKEY_LOCAL_MACHINE;

tstr:='\System\CurrentControlSet\control\ComputerName\ComputerName';
boolvar:=reg.OpenKey(tstr, false);
if (boolvar) then
  begin
    boolvar:=reg.ValueExists('ComputerName');
    if (boolvar) then  result:=reg.ReadString('ComputerName');
  end;
reg.Free;
end;
//------------------------------------------------------------------
function getusername: string;
var
reg: TRegistry;
tstr: string;
boolvar: boolean;
begin
result:='';
reg:=TRegistry.Create;
reg.RootKey:=HKEY_LOCAL_MACHINE;

tstr:='\Network\Logon';
boolvar:=reg.OpenKey(tstr, false);
if (boolvar) then
  begin
    boolvar:=reg.ValueExists('username');
    if (boolvar) then  result:=result+reg.ReadString('username');
  end;
reg.Free;
end;
//------------------------------------------------------------------
function milliseconddiff(starttime: Tdatetime; endtime: Tdatetime)
                        : integer;
var
days: integer;
sta_hh, sta_mi, sta_ss, sta_ms: Word;
end_hh, end_mi, end_ss, end_ms: Word;
begin
DecodeTime(starttime, sta_hh, sta_mi, sta_ss, sta_ms);
DecodeTime(endtime  , end_hh, end_mi, end_ss, end_ms);
days:=trunc(endtime)-trunc(starttime);
result:=(((days*24+end_hh-sta_hh)*60+(end_mi-sta_mi))*60
         +(end_ss-sta_ss))*1000+(end_ms-sta_ms);
end;
//------------------------------------------------------------------
end.
