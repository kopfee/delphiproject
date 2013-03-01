unit BDACore;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>BDACore
   <What>为了支持对IDispatch的实现而准备。
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

interface

uses windows,ActiveX,ComObj;

const
  BDATypeLibName = 'BasicDataAccess.tlb';

{
  <Function>getBDATypeLib
  <What>为了支持对IDispatch的实现而准备。
  <Params>
    -
  <Return>
  <Exception>
}
function getBDATypeLib : ITypeLib;

resourcestring
  SCannotFindTypeLib = '不能找到COM类型库文件(BasicDataAccess.tlb)';

implementation

uses BasicDataAccess_TLB, RegSvrUtils, SysUtils, KSStrUtils;

var
  StdBDA: ITypeLib = nil;

function getBDATypeLib : ITypeLib;
begin
  result := StdBDA;
end;

procedure InitTypeLib;
var
  R : HResult;
  TypeLibFile : string;
  ModuleName : array[0..MAX_PATH-1] of Char;
begin
  R := LoadRegTypeLib(LIBID_BasicDataAccess, 1, 0, 0, StdBDA);
  if not Succeeded(R) then
  begin
    TypeLibFile := BDATypeLibName;
    // 如果该文件不在当前目录下面，使用模块所在目录下面的文件
    if not FileExists(TypeLibFile) then
    begin
      FillChar(ModuleName,SizeOf(ModuleName),0);
      GetModuleFileName(hInstance,@ModuleName,SizeOf(ModuleName)-1);
      TypeLibFile := string(PChar(@ModuleName));
      TypeLibFile := AddPathAndName(ExtractFilePath(TypeLibFile),BDATypeLibName);
    end;
    //MessageBox(0,PChar(TypeLibFile),'Debug',MB_OK	or MB_ICONINFORMATION or MB_APPLMODAL);
    RegisterComServer(TypeLibFile, rtTypeLib, raReg);
    if not Succeeded(LoadRegTypeLib(LIBID_BasicDataAccess, 1, 0, 0, StdBDA)) then
      raise Exception.Create(SCannotFindTypeLib);
  end;
end;

initialization
  InitTypeLib;

end.
