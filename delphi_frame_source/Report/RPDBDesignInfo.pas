unit RPDBDesignInfo;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>RPSimpleReports
   <What>提供一个简单的报表使用工具
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

interface

uses SysUtils, Classes, Contnrs, DB, RPBands, RPCtrls, RPDB, RPDBVCL,
  RPProcessors, RPEasyReports, RPDesignInfo, TextOutScripts;

const
  RPMaxDatasets = 5;

type
  TDatasetIndexs = 0..RPMaxDatasets-1;

  TRPBrowseDatasetType = (bdtNormal, bdtBlockRead, bdtDisableControls);
  {
    <Class>TDBReportInfo
    <What>
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
    <Notes>
      注意在编写代码在程序中修改DatasetNames和DataSources以后，应该调用Clear，保证以后重新创建Report。
  }
  TDBReportInfo = class(TReportInfo)
  private
    FDatasetNames : array[TDatasetIndexs] of string;
    FDataSources  : array[TDatasetIndexs] of TDataSource;
    FBlockReadSize: Integer;
    FBrowseDatasetType: TRPBrowseDatasetType;
    FTextFormatFileName: TFileName;
    function    GetDatasetName(Index: Integer): string;
    function    GetDataSource(Index: Integer): TDataSource;
    procedure   SetDatasetName(Index: Integer; const Value: string);
    procedure   SetDataSource(Index: Integer; const Value: TDataSource);
    procedure   RemoveDataSource(DataSource : TDataSource);
  protected
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure   InternalRepareReport; override;
    procedure   BeforePrint; override;
    procedure   AfterPrint; override;
    procedure   BeginOutput(ADataEntries : TRPDBDataEntries);
    procedure   EndOutput(ADataEntries : TRPDBDataEntries);
  public
    constructor Create(AOwner : TComponent); override;
    procedure   PrintToFile(const TextFileName : string);
    property    DatasetNames[Index : Integer] : string read GetDatasetName write SetDatasetName;
    property    DataSources[Index : Integer] : TDataSource read GetDataSource write SetDataSource;
  published
    property    DatasetName1 : string index 0 read GetDatasetName write SetDatasetName ;
    property    DataSource1 : TDataSource index 0 read GetDataSource write SetDataSource;
    property    DatasetName2 : string index 1 read GetDatasetName write SetDatasetName ;
    property    DataSource2 : TDataSource index 1 read GetDataSource write SetDataSource;
    property    DatasetName3 : string index 2 read GetDatasetName write SetDatasetName ;
    property    DataSource3 : TDataSource index 2 read GetDataSource write SetDataSource;
    property    DatasetName4 : string index 3 read GetDatasetName write SetDatasetName ;
    property    DataSource4 : TDataSource index 3 read GetDataSource write SetDataSource;
    property    DatasetName5 : string index 4 read GetDatasetName write SetDatasetName ;
    property    DataSource5 : TDataSource index 4 read GetDataSource write SetDataSource;
    property    BlockReadSize : Integer read FBlockReadSize write FBlockReadSize default 1;
    property    BrowseDatasetType : TRPBrowseDatasetType read FBrowseDatasetType write FBrowseDatasetType default bdtNormal;
    property    TextFormatFileName : TFileName read FTextFormatFileName write FTextFormatFileName;
    property    FileName;
  end;


implementation

{ TDBReportInfo }

constructor TDBReportInfo.Create(AOwner: TComponent);
begin
  inherited;
  NewDataEntriesClass(TRPDBDataEntries);
  FBlockReadSize := 1;
  FBrowseDatasetType := bdtNormal;
end;

procedure TDBReportInfo.AfterPrint;
begin
  inherited;
  EndOutput(TRPDBDataEntries(DataEntries));
end;

procedure TDBReportInfo.BeforePrint;
begin
  inherited;
  BeginOutput(TRPDBDataEntries(DataEntries));
end;

function TDBReportInfo.GetDatasetName(Index: Integer): string;
begin
  Result := FDatasetNames[Index];
end;

function TDBReportInfo.GetDataSource(Index: Integer): TDataSource;
begin
  Result := FDataSources[Index];
end;

procedure TDBReportInfo.InternalRepareReport;
var
  I : Integer;
begin
  inherited;
  Assert(DataEntries is TRPDBDataEntries);
  for I:=0 to RPMaxDatasets-1 do
  begin
    if (FDataSources[I]<>nil) and (FDatasetNames[I]<>'') then
      if TRPDBDataEntries(DataEntries).IndexOfDataset(FDatasetNames[I])>=0 then
        TRPDBDataEntries(DataEntries).AddDatasource(FDatasetNames[I],FDataSources[I]);
  end;
end;

procedure TDBReportInfo.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation=opRemove) and (AComponent is TDataSource) then
    RemoveDataSource(TDataSource(AComponent));
end;

procedure TDBReportInfo.RemoveDataSource(DataSource: TDataSource);
var
  I : Integer;
begin
  for I:=0 to RPMaxDatasets-1 do
  begin
    if FDataSources[I]=DataSource then
      FDataSources[I]:=nil;
  end;
end;

procedure TDBReportInfo.SetDatasetName(Index: Integer;
  const Value: string);
begin
  FDatasetNames[Index] := Value;
end;

procedure TDBReportInfo.SetDataSource(Index: Integer;
  const Value: TDataSource);
begin
  FDataSources[Index] := Value;
  if Value<>nil then
    Value.FreeNotification(Self);
end;

procedure TDBReportInfo.PrintToFile(const TextFileName: string);
var
  ScriptContext : TScriptContext;
  OutputEnvironment : TRPDataEnvironment;
  I : Integer;
begin
  ScriptContext := nil;
  OutputEnvironment := nil;
  try
    OutputEnvironment := TRPDataEnvironment.Create(nil);
    ScriptContext := TScriptContext.Create(nil);
    ScriptContext.Environment := OutputEnvironment;
    ScriptContext.LoadScripts(TextFormatFileName);
    for I:=0 to RPMaxDatasets-1 do
    begin
      if ScriptContext.DataEntries.IndexOfDataset(DatasetNames[I])>=0 then
        ScriptContext.DataEntries.AddDatasource(DatasetNames[I],DataSources[I]);
    end;
    BeginOutput(ScriptContext.DataEntries);
    ScriptContext.Output(TextFileName);
  finally
    if ScriptContext<>nil then
      EndOutput(ScriptContext.DataEntries);
    ScriptContext.Free;
    OutputEnvironment.Free;
  end;
end;

procedure TDBReportInfo.BeginOutput(ADataEntries : TRPDBDataEntries);
begin
  case FBrowseDatasetType of
    bdtNormal           : ;
    bdtBlockRead        : if BlockReadSize>0 then
                            ADataEntries.SetBlockReadSize(BlockReadSize);
    bdtDisableControls  : ADataEntries.DisableControls;
  end;
end;

procedure TDBReportInfo.EndOutput(ADataEntries : TRPDBDataEntries);
begin
  case FBrowseDatasetType of
    bdtNormal           : ;
    bdtBlockRead        : if BlockReadSize>0 then
                            ADataEntries.SetBlockReadSize(0);
    bdtDisableControls  : ADataEntries.EnableControls;
  end;
end;

end.
