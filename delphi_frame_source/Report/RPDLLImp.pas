unit RPDLLImp;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>RPDLLImp
   <What>实现了一个打印报表的动态连接库的接口函数
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

interface

uses RPDBCB;

// 定义错误信息
const
  RPEOK = 0;
  RPEError = -1;
  RPEHandleError = -2;
  RPELoad = -3;
  RPECreate = -4;
  RPBinding = -5;
  RPNotCreate = -6;
  RPOutputText = -7;

type
  TReportInfoHandle = Pointer;

{ 标准的调用顺序
  1、NewReportInfo
  2、LoadFromFile
  3、BingDataset
  4、SetVariant（可选）
  5、Print/Preview/PrintToFile
  6、FreeReportInfo
}
// 创建报表句柄
function  NewReportInfo : TReportInfoHandle; stdcall;

// 释放报表句柄
procedure FreeReportInfo(Handle : TReportInfoHandle); stdcall;

// 读取报表格式文件
function  LoadFromFile(Handle : TReportInfoHandle; FileName : PChar):Integer; stdcall;

// 绑定数据集结构。数据集结构定义见RPDBCB.pas。调用者必须实现这些回调函数
function  BingDataset(Handle : TReportInfoHandle; DatasetName : PChar; DatasetRecord : PDatasetRecord):Integer; stdcall;

// 打印
function  Print(Handle : TReportInfoHandle):Integer; stdcall;

// 预览
function  Preview(Handle : TReportInfoHandle):Integer; stdcall;

// 设置变量的值
function  SetVariant(Handle : TReportInfoHandle; Name,Value : PChar):Integer; stdcall;

// 清除报表
function  Clear(Handle : TReportInfoHandle):Integer; stdcall;

// 打印到指定的文件
function  PrintToFile(Handle : TReportInfoHandle; FormatFileName, OuputFileName : PChar):Integer; stdcall;

implementation

uses Classes, RPDBCBImp, RPDesignInfo, TextOutScripts, LogFile;

function  NewReportInfo : TReportInfoHandle; stdcall;
var
  RI : TReportInfo;
begin
  RI := TReportInfo.Create(nil);
  RI.NewDataEntriesClass(TRPCBDataEntries);
  Result := TReportInfoHandle(RI);
end;

procedure FreeReportInfo(Handle : TReportInfoHandle); stdcall;
begin
  if Handle<>nil then
    TReportInfo(Handle).Free;
end;

function  LoadFromFile(Handle : TReportInfoHandle; FileName : PChar):Integer; stdcall;
begin
  if Handle<>nil then
  begin
    Result := RPEOK;
    try
      Result := RPELoad;
      TReportInfo(Handle).LoadFromFile(FileName);
      Result := RPECreate;
      TReportInfo(Handle).CreateReport;
      Result := RPEOK;
    except
      WriteException;
    end;
  end else
    Result := RPEHandleError;
end;

function  BingDataset(Handle : TReportInfoHandle; DatasetName : PChar; DatasetRecord : PDatasetRecord):Integer; stdcall;
begin
  if Handle<>nil then
  begin
    try
      TRPCBDataEntries(TReportInfo(Handle).DataEntries).AddRecord(DatasetName, DatasetRecord);
      Result := RPEOK;
    except
      Result := RPBinding;
      WriteException;
    end;
  end else
    Result := RPEHandleError;
end;

function  Print(Handle : TReportInfoHandle):Integer; stdcall;
begin
  if Handle<>nil then
  begin
    try
      TReportInfo(Handle).Print;
      Result := RPEOK;
    except
      Result := RPEError;
      WriteException;
    end;
  end else
    Result := RPEHandleError;
end;

function  Preview(Handle : TReportInfoHandle):Integer; stdcall;
begin
  if Handle<>nil then
  begin
    try
      TReportInfo(Handle).Preview;
      Result := RPEOK;
    except
      Result := RPEError;
      WriteException;
    end;
  end else
    Result := RPEHandleError;
end;

function  SetVariant(Handle : TReportInfoHandle; Name,Value : PChar):Integer; stdcall;
begin
  if Handle<>nil then
  begin
    try
      {
      if TReportInfo(Handle).Environment=nil then
        Result := RPNotCreate else
      begin
        TReportInfo(Handle).Environment.VariantValues.Values[Name]:=Value;
        Result := RPEOK;
      end;
      }
      TReportInfo(Handle).SetVariantValue(Name,Value);
      Result := RPEOK;
    except
      Result := RPEError;
      WriteException;
    end;
  end else
    Result := RPEHandleError;
end;

function  Clear(Handle : TReportInfoHandle):Integer; stdcall;
begin
  if Handle<>nil then
  begin
    try
      TReportInfo(Handle).Clear;
      Result := RPEOK;
    except
      Result := RPEError;
      WriteException;
    end;
  end else
    Result := RPEHandleError;
end;

function  PrintToFile(Handle : TReportInfoHandle; FormatFileName, OuputFileName : PChar):Integer; stdcall;
var
  ScriptContext : TScriptContext;
begin
  if Handle<>nil then
  begin
    if TReportInfo(Handle).Environment=nil then
      Result := RPNotCreate else
    begin
      try
        ScriptContext := TScriptContext.Create(nil);
        try
          ScriptContext.Environment := TReportInfo(Handle).Environment;
          Result := RPELoad;
          ScriptContext.LoadScripts(string(FormatFileName));
          Result := RPOutputText;
          ScriptContext.Output(string(OuputFileName));
          Result := RPEOK;
        finally
          ScriptContext.Free;
        end;
      except
        Result := RPEError;
        WriteException;
      end;
    end;
  end else
    Result := RPEHandleError;
end;

initialization
  openLogFile('',true,false);
end.
