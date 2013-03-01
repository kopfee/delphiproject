unit enf_delphi_utils;
//Delphi平台的对象及功能调用的改进型, 或带有重要使用限制的自编功能调用.
interface

uses Windows, SysUtils, classes, forms, dbtables,
Dialogs;

procedure dbfresh(DataSet: TDBDataSet);
procedure clear_associatedobjlist(list: TStrings);
function getappname: string;
procedure overwriteinicfg(objlist, sourcelist: TStringList);
function getwindir: string;
function getwinsysdir: string;
procedure ReadyQuery(dbqry: TQuery; sqlcmd: string);
procedure AbortWithMsg(msg: string);

implementation

//=====================================================================
procedure dbfresh(DataSet: TDBDataSet);
var
priornum, i: integer;
//Property RecNo经测试恒为-1，故不可用。
begin
DataSet.DisableControls;
priornum:=0;
if (DataSet.Active) then
  while not(DataSet.BOF) do
    begin
      DataSet.Prior;
      priornum:=priornum+1;
    end;  // of while & if
if (priornum>0) then Dec(priornum);  //按BOF的定义微调相对位移
DataSet.Close;
DataSet.Open;
for i:=1 to priornum do DataSet.Next;
DataSet.EnableControls;
end;
//---------------------------------------------------------------------
procedure clear_associatedobjlist(list: TStrings);
var
baseobj: TObject;
i: integer;
begin
for i:=0 to (list.Count-1) do
if assigned(list.Objects[i]) then
  begin
    baseobj:=list.Objects[i];
    baseobj.Free;
    list.Objects[i]:=nil;
  end;
end;
//----------------------------------------------------------------------
function getappname: string;
var
tstr: string;
i: integer;
begin
tstr:=application.ExeName;
tstr:=ExtractFileName(tstr);  //去路径.
i:=Pos('.', tstr);  //去扩展名.
result:=Copy(tstr, 1, i-1);
end;
//----------------------------------------------------------------------
procedure overwriteinicfg(objlist, sourcelist: TStringList);
//覆盖类似 NAME=VALUE 的INI配置:
//同名的以新值覆盖旧值; 原无的补充进目标配置;
//此外不对目标配置作其它变动.
var
i, k: integer;
tstr: string;
begin
for i:=0 to (sourcelist.Count-1) do
  begin
    tstr:=sourcelist.Strings[i];
    k:=Pos('=', tstr);
    if (k=0) then continue;  //源配置中非 NAME=VALUE 格式的字串被忽略.
    tstr:=sourcelist.Names[i];
    k:=objlist.IndexOfName(tstr);
    if (k>=0) then  objlist.Values[tstr]:=sourcelist.Values[tstr]
    else objlist.Add(sourcelist.Strings[i]);
  end;  // of for
end;
//----------------------------------------------------------------------
function getwindir: string;
var
len, i: integer;
pch: PChar;
tstr: string;
begin
len:=32;  //先从本地系统目录检索INI文件.
pch:=AllocMem(len);
i:=GetWindowsDirectory(pch, len);
if (i>len) then
  begin
    len:=i;
    ReallocMem(pch, len);
    i:=GetWindowsDirectory(pch, len);
  end;
if (i=0)or(i>len) then
  begin
    result:='';
  end
else  //已成功地获取系统目录.
  begin
    tstr:=string(pch);
    if (tstr[i]<>'\') then  tstr:=tstr+'\';  //保证返回字串以'\'结尾.
    result:=tstr;
  end;  // of else
FreeMem(pch);
end;
//----------------------------------------------------------------------
function getwinsysdir: string;
var
len, i: integer;
pch: PChar;
tstr: string;
begin
len:=32;  //先从本地系统目录检索INI文件.
pch:=AllocMem(len);
i:=GetSystemDirectory(pch, len);
if (i>len) then
  begin
    len:=i;
    ReallocMem(pch, len);
    i:=GetSystemDirectory(pch, len);
  end;
if (i=0)or(i>len) then
  begin
    result:='';
  end
else  //已成功地获取系统目录.
  begin
    tstr:=string(pch);
    if (tstr[i]<>'\') then  tstr:=tstr+'\';  //保证返回字串以'\'结尾.
    result:=tstr;
  end;  // of else
FreeMem(pch);
end;
//----------------------------------------------------------------------
procedure ReadyQuery(dbqry: TQuery; sqlcmd: string);
begin
dbqry.Active:=false;
dbqry.SQL.Clear;
sqlcmd:=trim(sqlcmd);
if (sqlcmd<>'') then  dbqry.SQL.Add(sqlcmd);
end;
//----------------------------------------------------------------------
procedure AbortWithMsg(msg: string);
begin
Showmessage(msg);
Abort;
end;
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//----------------------------------------------------------------------

end.

{  遍历计数过程太慢且界面表现不佳
procedure dbfresh(DataSet: TDBDataSet);
begin
DataSet.Close;
DataSet.Open;
end;
}

