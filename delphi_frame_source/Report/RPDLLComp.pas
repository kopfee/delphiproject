unit RPDLLComp;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>RPDLLComp
   <What>包装RPDLLIntf定义的接口函数
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

interface

uses Classes, DB, RPDBCB, RPDLLIntf;

type
  {
    <Class>TDLLReport
    <What>包装RPDLLIntf定义的接口函数类
    <Properties>
      Handle - 报表句柄
    <Methods>
      LoadFromFile  - 读取报表格式文件
      BingDataset   - 绑定数据集。
      Print         - 打印
      Preview       - 预览
      SetVariant    - 设置变量的值
      PrintToFile   - 打印到指定的文件
      Clear         - 清除报表
    <Event>
      -
  }
  TDLLReport = class(TComponent)
  private
    FHandle: TReportInfoHandle;
    FDatasetRecords : TList;
    procedure   CheckError(ErrorCode : Integer);
  protected

  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
    procedure   Clear;
    procedure   LoadFromFile(const FileName : string);
    procedure   BingDataset(const DatasetName : string; Dataset : TDataset);
    procedure   Print;
    procedure   Preview;
    procedure   SetVariant(const Name,Value : string);
    procedure   PrintToFile(const FormatFileName, OuputFileName : string);
    property    Handle : TReportInfoHandle read FHandle;
  published

  end;

implementation

uses SysUtils, RPDBCBVCL;

{ TDLLReport }

constructor TDLLReport.Create(AOwner: TComponent);
begin
  inherited;
  FHandle := NewReportInfo;
  FDatasetRecords := TList.Create;
end;

destructor TDLLReport.Destroy;
begin
  Clear;
  FDatasetRecords.Free;
  FreeReportInfo(Handle);
  inherited;
end;

procedure TDLLReport.BingDataset(const DatasetName: string;
  Dataset: TDataset);
var
  P : PDatasetRecord;
begin
  P := NewDBDatasetRecord(Dataset);
  FDatasetRecords.Add(P);
  CheckError(RPDLLIntf.BingDataset(Handle,PChar(DatasetName),P));
end;

procedure TDLLReport.LoadFromFile(const FileName: string);
begin
  CheckError(RPDLLIntf.LoadFromFile(Handle,PChar(FileName)));
end;

procedure TDLLReport.Preview;
begin
  CheckError(RPDLLIntf.Preview(Handle));
end;

procedure TDLLReport.Print;
begin
  CheckError(RPDLLIntf.Print(Handle));
end;

procedure TDLLReport.SetVariant(const Name, Value: string);
begin
  CheckError(RPDLLIntf.SetVariant(Handle,Pchar(Name),PChar(Value)));
end;

procedure TDLLReport.CheckError(ErrorCode: Integer);
begin
  if ErrorCode<>RPEOK then
    raise Exception.Create('Report DLL Error:'+IntToStr(ErrorCode));
end;

procedure TDLLReport.Clear;
var
  P : PDatasetRecord;
  i : integer;
begin
  for i:=0 to FDatasetRecords.Count-1 do
  begin
    P := PDatasetRecord(FDatasetRecords[i]);
    FreeDBDatasetRecord(P);
  end;
  FDatasetRecords.Clear;
end;

procedure TDLLReport.PrintToFile(const FormatFileName,
  OuputFileName: string);
begin
  CheckError(RPDLLIntf.PrintToFile(Handle,PChar(FormatFileName),PChar(OuputFileName)));
end;

end.
