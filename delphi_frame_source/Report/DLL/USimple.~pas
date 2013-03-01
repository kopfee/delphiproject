unit USimple;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Spin;

type
  TfmSimpleTest = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    btnPreview1: TButton;
    Label2: TLabel;
    edCompanyName: TEdit;
    Label3: TLabel;
    edCustNo: TEdit;
    Label4: TLabel;
    edCustName: TEdit;
    edFileName1: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    edFileName2: TEdit;
    lsCustNo: TListBox;
    lsMoney: TListBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    edNumber: TSpinEdit;
    btnProduce: TButton;
    btnPreview2: TButton;
    Label10: TLabel;
    Label11: TLabel;
    procedure btnPreview1Click(Sender: TObject);
    procedure btnProduceClick(Sender: TObject);
    procedure btnPreview2Click(Sender: TObject);
  private
    { Private declarations }
    procedure DoError(const Msg : string);
    procedure CheckCall(R : Integer);
  public
    { Public declarations }
    // 数据库游标
    DataCursor : Integer;
    RecordCount : Integer;
    RecordBof : Boolean;
    RecordEof : Boolean;
  end;

var
  fmSimpleTest: TfmSimpleTest;

// 回调函数。将TfmSimpleTest对象当做Dataset
procedure MyFirst(Dataset : Pointer); stdcall;
procedure MyNext(Dataset : Pointer); stdcall;
procedure MyPrior(Dataset : Pointer); stdcall;
procedure MyLast(Dataset : Pointer); stdcall;
function  MyEof(Dataset : Pointer):LongBool; stdcall;
function  MyBof(Dataset : Pointer):LongBool; stdcall;
function  MyFieldCount(Dataset : Pointer):Integer; stdcall;
function  MyGetFieldName(Dataset : Pointer; FieldIndex : Integer; Buffer : PChar; Len : Integer):Integer; stdcall;
function  MyGetFieldDataType(Dataset : Pointer; FieldIndex : Integer):Integer; stdcall;
function  MyGetInteger(Dataset : Pointer; FieldIndex : Integer):Integer; stdcall;
function  MyGetFloat(Dataset : Pointer; FieldIndex : Integer):Double; stdcall;
function  MyGetString(Dataset : Pointer; FieldIndex : Integer; Buffer : PChar; Len : Integer):Integer; stdcall;
function  MyGetDateTime(Dataset : Pointer; FieldIndex : Integer):TDatetime; stdcall;

// 将string复制到Buffer的函数
function  CopyString(const Source : string; Buffer : PChar; Len : Integer):Integer;

implementation

uses RPDBCB, RPDLLIntf;

{$R *.DFM}

procedure TfmSimpleTest.CheckCall(R: Integer);
begin
  // 检查调用的返回值
  if R<>RPEOK then
    DoError(Format('错误码:%d',[R]));
end;

procedure TfmSimpleTest.DoError(const Msg: string);
begin
  // 抛出意外
  raise Exception.Create(Msg);
end;

procedure TfmSimpleTest.btnProduceClick(Sender: TObject);
var
  Count : Integer;
  I : Integer;
begin
  lsCustNo.Items.BeginUpdate;
  lsMoney.Items.BeginUpdate;
  lsCustNo.Items.Clear;
  lsMoney.Items.Clear;

  // 产生数据
  Count := edNumber.Value;
  for I:=1 to Count do
  begin
    lsCustNo.Items.Add(Format('%8.8d',[I]));
    lsMoney.Items.Add(Format('%d',[I*100]));
  end;

  lsCustNo.Items.EndUpdate;
  lsMoney.Items.EndUpdate;
end;

procedure TfmSimpleTest.btnPreview1Click(Sender: TObject);
var
  MyHandle : Pointer;
begin
  // 创建报表句柄
  MyHandle := NewReportInfo();
  if MyHandle<>nil then
  begin
    try
      // 装载报表文件
      CheckCall(LoadFromFile(MyHandle,PChar(edFileName1.Text)));
      // 设置数据,注意字段名和报表里面的FieldName匹配
      CheckCall(SetVariant(MyHandle,'公司名称',PChar(edCompanyName.Text)));
      CheckCall(SetVariant(MyHandle,'客户号',PChar(edCustNo.Text)));
      CheckCall(SetVariant(MyHandle,'姓名',PChar(edCustName.Text)));
      // 预览
      CheckCall(Preview(MyHandle));
    finally
      // 最后一定要释放该句柄
      FreeReportInfo(MyHandle);
    end;
  end else
    DoError('无法创建报表句柄');
end;

procedure TfmSimpleTest.btnPreview2Click(Sender: TObject);
var
  MyHandle : Pointer;
  DataRecord : TDatasetRecord;
begin
  // 创建报表句柄
  MyHandle := NewReportInfo();
  if MyHandle<>nil then
  begin
    try
      // 装载报表文件
      CheckCall(LoadFromFile(MyHandle,PChar(edFileName2.Text)));
      CheckCall(SetVariant(MyHandle,'公司名称',PChar(edCompanyName.Text)));
      // 初始化记录
      DataRecord.Dataset             :=Self; // 将本身TfmSimpleTest类型的对象作为结果集指针
      DataRecord.First               :=MyFirst;
      DataRecord.Next                :=MyNext;
      DataRecord.Prior               :=MyPrior;
      DataRecord.Last                :=MyLast;
      DataRecord.Bof                 :=MyBof;
      DataRecord.Eof                 :=MyEof;
      DataRecord.FieldCount          :=MyFieldCount;
      DataRecord.GetFieldName        :=MyGetFieldName;
      DataRecord.GetFieldDataType    :=MyGetFieldDataType;
      DataRecord.GetInteger          :=MyGetInteger;
      DataRecord.GetFloat            :=MyGetFloat;
      DataRecord.GetString           :=MyGetString;
      DataRecord.GetDateTime         :=MyGetDateTime;
      // 初始化数据集
      RecordCount := lsCustNo.Items.Count;
      MyFirst(Self);
      //
      CheckCall(BingDataset(MyHandle,'客户资金',@DataRecord));
      // 预览
      CheckCall(Preview(MyHandle));
    finally
      // 最后一定要释放该句柄
      FreeReportInfo(MyHandle);
    end;
  end else
    DoError('无法创建报表句柄');
end;

procedure MyFirst(Dataset : Pointer); stdcall;
begin
  // 将光标移动到最前面, 注意设置RecordBof和RecordEof
  with TfmSimpleTest(Dataset) do
  begin
    DataCursor:=0;
    RecordBof := True;
    RecordEof := RecordCount=0;
  end;
end;

procedure MyNext(Dataset : Pointer); stdcall;
begin
  // 光标后移一行, 注意设置RecordBof和RecordEof
  with TfmSimpleTest(Dataset) do
  begin
    DataCursor:=DataCursor+1;
    RecordBof := RecordCount=0;
    if DataCursor>=RecordCount then
    begin
      DataCursor:=RecordCount-1;
      RecordEof := True;
    end;
  end;
end;

procedure MyPrior(Dataset : Pointer); stdcall;
begin
  // 光标前移一行, 注意设置RecordBof和RecordEof
  with TfmSimpleTest(Dataset) do
  begin
    DataCursor:=DataCursor-1;
    RecordEof := RecordCount=0;
    if DataCursor<0 then
    begin
      DataCursor:=0;
      RecordBof := True;
    end;
  end;
end;

procedure MyLast(Dataset : Pointer); stdcall;
begin
  // 将光标移动到最后面, 注意设置RecordBof和RecordEof
  with TfmSimpleTest(Dataset) do
  begin
    DataCursor:=RecordCount-1;
    RecordBof := RecordCount=0;
    RecordEof := True;
  end;
end;

function  MyEof(Dataset : Pointer):LongBool; stdcall;
begin
  with TfmSimpleTest(Dataset) do
    Result := RecordEof;
end;

function  MyBof(Dataset : Pointer):LongBool; stdcall;
begin
  with TfmSimpleTest(Dataset) do
    Result := RecordBof;
end;

function  MyFieldCount(Dataset : Pointer):Integer; stdcall;
begin
  Result := 2;
end;

function  CopyString(const Source : string; Buffer : PChar; Len : Integer):Integer;
var
  L : Integer;
begin
  // 返回实际字符串的大小
  Result := Length(Source);
  if Buffer<>nil then
  begin
    // 如果Buffer有效，复制字符串
    L := Result;
    if Len<Result then
      L := Len;
    Move(PChar(Source)^,Buffer^,L);
  end;
end;

function  MyGetFieldName(Dataset : Pointer; FieldIndex : Integer; Buffer : PChar; Len : Integer):Integer; stdcall;
begin
  // 返回字段名称
  case FieldIndex of
    0 : Result := CopyString('客户号',Buffer,Len);
    1 : Result := CopyString('资金余额',Buffer,Len);
  else
  begin
    Result := 0;
    // 本例子里面不会执行到这里
    Assert(False);
  end;
  end;
end;

function  MyGetFieldDataType(Dataset : Pointer; FieldIndex : Integer):Integer; stdcall;
begin
  // 返回字段数据类型
  case FieldIndex of
    0 : Result := cdtString;
    1 : Result := cdtFloat;
  else  
  begin
    Result := 0;
    // 本例子里面不会执行到这里
    Assert(False);
  end;
  end;
end;

function  MyGetInteger(Dataset : Pointer; FieldIndex : Integer):Integer; stdcall;
begin
  // 本例子里面不会执行到这里
  Assert(False);
  Result := 0;
end;

function  MyGetFloat(Dataset : Pointer; FieldIndex : Integer):Double; stdcall;
begin
  // 返回当前行的资金情况，浮点数类型
  Assert(FieldIndex=1);
  with TfmSimpleTest(Dataset) do
  begin
    Result := StrToFloat(lsMoney.Items[DataCursor]);
  end;
end;

function  MyGetString(Dataset : Pointer; FieldIndex : Integer; Buffer : PChar; Len : Integer):Integer; stdcall;
begin
  // 返回当前行的客户号，字符串类型
  Assert(FieldIndex=0);
  with TfmSimpleTest(Dataset) do
  begin
    Result := CopyString(lsCustNo.Items[DataCursor],Buffer,Len);
  end;
end;

function  MyGetDateTime(Dataset : Pointer; FieldIndex : Integer):TDatetime; stdcall;
begin
  // 本例子里面不会执行到这里
  Assert(False);
  Result := 0;
end;

end.
