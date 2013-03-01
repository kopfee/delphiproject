unit RPDLLIntf;
{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>RPDLLIntf
   <What>定义了一个打印报表的动态连接库的接口函数
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

interface

uses RPDBCB;

const
  // 定义错误信息
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

const
  DLLName = 'RPCBDLL.DLL';

function  NewReportInfo : TReportInfoHandle; stdcall; external DLLName;

procedure FreeReportInfo(Handle : TReportInfoHandle); stdcall; external DLLName;

function  LoadFromFile(Handle : TReportInfoHandle; FileName : PChar):Integer; stdcall; external DLLName;

function  BingDataset(Handle : TReportInfoHandle; DatasetName : PChar; DatasetRecord : PDatasetRecord):Integer; stdcall; external DLLName;

function  Print(Handle : TReportInfoHandle):Integer; stdcall; external DLLName;

function  Preview(Handle : TReportInfoHandle):Integer; stdcall; external DLLName;

function  SetVariant(Handle : TReportInfoHandle; Name,Value : PChar):Integer; stdcall; external DLLName;

function  Clear(Handle : TReportInfoHandle):Integer; stdcall; external DLLName;

function  PrintToFile(Handle : TReportInfoHandle; FormatFileName, OuputFileName : PChar):Integer; stdcall; external DLLName;

end.
