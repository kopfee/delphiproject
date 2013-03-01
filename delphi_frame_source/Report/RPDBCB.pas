unit RPDBCB;
{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>RPDBCB
   <What>实现报表需要的数据集的回调函数声明
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

interface

const
  // 定义字段数据类型
  cdtInteger=0; // 32bits 有符号整数
  cdtFloat=1;   // double
  cdtString=2;  // PChar
  cdtDate=3;    // TDateTime
  cdtOther=4;
  cdtBinary=5;

type
  // 定义访问数据集的回调函数类型。注意调用方式都是stdcall。函数的第一个参数都是Dataset : Pointer
  TDBStdProc = procedure (Dataset : Pointer); stdcall;
  TDBFirstProc = TDBStdProc;
  TDBNextProc = TDBStdProc;
  TDBPriorProc = TDBStdProc;
  TDBLastProc = TDBStdProc;
  TDBBofProc = function (Dataset : Pointer):LongBool; stdcall;
  TDBEofProc = function (Dataset : Pointer):LongBool; stdcall;
  TDBFieldCount = function (Dataset : Pointer):Integer; stdcall;
  // FieldIndex 从0开始
  // TDBGetFieldName返回实际长度。可以用Buffer=nil的调用先获得实际长度，然后为Buffer分配内存，最后再次调用这个函数
  TDBGetFieldName = function (Dataset : Pointer; FieldIndex : Integer; Buffer : PChar; Len : Integer):Integer; stdcall;
  // Should return gfdtInteger(0),gfdtFloat(1),gfdtString,gfdtDate,gfdtOther,gfdtBinary for Datatype
  TDBGetFieldDataType = function (Dataset : Pointer; FieldIndex : Integer):Integer; stdcall;
  TDBGetInteger = function (Dataset : Pointer; FieldIndex : Integer):Integer; stdcall;
  TDBGetFloat = function (Dataset : Pointer; FieldIndex : Integer):Double; stdcall;
  // TDBGetString返回实际长度。可以用Buffer=nil的调用先获得实际长度，然后为Buffer分配内存，最后再次调用这个函数
  TDBGetString = function  (Dataset : Pointer; FieldIndex : Integer; Buffer : PChar; Len : Integer):Integer; stdcall;
  TDBGetDateTime = function (Dataset : Pointer; FieldIndex : Integer):TDatetime; stdcall;

  {
    <record>
    <What>TDatasetRecord
    <Field>
      Dataset - 指针，用来标志数据集。这个值被传递到对下面的函数的调用中。
      First   - 将数据集的光标移动到最前面。调用后Bof应该返回True。
      Next    - 将数据集的光标向后移动一行。
      Prior   - 将数据集的光标向前移动一行。
      Last    - 将数据集的光标移动到最后面。调用后Eof应该返回True。
      Bof     - 数据集的光标是否在最前面。
      Eof     - 数据集的光标是否在最后面。
      FieldCount  - 返回数据集的字段数目。
      GetFieldName - 返回数据集的字段名称。
      GetFieldDataType - 返回数据集的字段数据类型。
      GetInteger  - 获得字段的整数值
      GetFloat    - 获得字段的浮点数值
      GetString   - 获得字段的整数值
      GetDateTime - 获得字段的整数值
  }
  TDatasetRecord = packed record
    Dataset : Pointer;
    First   : TDBFirstProc;
    Next    : TDBNextProc;
    Prior   : TDBPriorProc;
    Last    : TDBLastProc;
    Bof     : TDBBofProc;
    Eof     : TDBEofProc;
    FieldCount : TDBFieldCount;
    GetFieldName  : TDBGetFieldName;
    GetFieldDataType  : TDBGetFieldDataType;
    GetInteger    : TDBGetInteger;
    GetFloat      : TDBGetFloat;
    GetString     : TDBGetString;
    GetDateTime   : TDBGetDateTime;
  end;

  PDatasetRecord = ^TDatasetRecord;

implementation

end.
