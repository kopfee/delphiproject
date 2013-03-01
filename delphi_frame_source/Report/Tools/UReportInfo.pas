unit UReportInfo;
                                           
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Contnrs, RPCtrls, RPDB, RPProcessors, RPEasyReports, DB;

type
  TRPDataEntry = class(TCollectionItem)
  private
    FFromFirst: Boolean;
    FControllerName: string;
    FDatasetName: string;
    FGroups: TStrings;
    procedure   SetGroups(const Value: TStrings);
    procedure   SetControllerName(const Value: string);
    procedure   SetDatasetName(const Value: string);
  protected
    function    GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor  Destroy;override;
  published
    property    DatasetName : string read FDatasetName write SetDatasetName;
    property    ControllerName : string read FControllerName write SetControllerName;
    property    Groups : TStrings read FGroups write SetGroups;
    property    FromFirst: Boolean read FFromFirst write FFromFirst  default true;
  end;

  TReportInfo = class(TDataModule)
  //TReportInfo = class(TFrame)
    Report: TRDReport;
  private
    { Private declarations }
    FVariantValues: TStrings;
    FFieldMapping: TStrings;
    FDataEntries: TCollection;
    FControllers: TObjectList;
    FProcessor: TReportProcessor;
    FEnvironment: TRPDataEnvironment;
    FEasyReport: TRPEasyReport;
    //FDatasets: TObjectList;
    FOwnedDatasets : TObjectList;
    {FCountLabel : Integer;
    FCountShape : Integer;
    FCountPicture : Integer;}
    procedure   SetFieldMapping(const Value: TStrings);
    procedure   SetVariantValues(const Value: TStrings);
    procedure   SetDataEntries(const Value: TCollection);
    function    GetEntryCount: Integer;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
    procedure   Clear;
    procedure   New;
    procedure   SaveToFile(const FileName:string);
    procedure   LoadFromFile(const FileName:string);
    //
    function    NewSimpleBand : TRDSimpleBand;
    function    NewGroupBand : TRDGroupBand;
    function    NewRepeatBand : TRDRepeatBand;
    function    NewLabel: TRDLabel;
    function    NewShape: TRDShape;
    function    NewPicture: TRDPicture;
    //
    procedure   CheckCreate;
    procedure   ClearReport;
    procedure   CreateReport;
    procedure   AddDataset(Dataset : TRPDataset);
    procedure   AddDatasource(const DatasetName : string; Datasource : TDatasource);
    function    IndexOfDataset(const DatasetName:string): Integer;
    function    IndexOfController(const ControllerName:string): Integer;
    procedure   Print;
    procedure   Preview;
    property    Environment : TRPDataEnvironment read FEnvironment;
    property    EasyReport : TRPEasyReport read FEasyReport;
    property    Processor : TReportProcessor read FProcessor;
    property    EntryCount : Integer read GetEntryCount;
    property    Controllers : TObjectList read FControllers;
    //property    Datasets: TObjectList read FDatasets;
  published
    property    FieldMapping : TStrings read FFieldMapping write SetFieldMapping;
    property    VariantValues : TStrings read FVariantValues write SetVariantValues;
    property    DataEntries : TCollection read FDataEntries write SetDataEntries;
  end;

  TCustomReportFileStore = class(TObject)
  private
    FFileExt: string;
    FDescription: string;
    procedure   SetFileExt(const Value: string);
  public
    constructor Create(const AFileExt : string; const ADescription : string=''; IsDefault : Boolean=False); virtual;
    destructor  Destroy;override;
    procedure   SaveToFile(ReportInfo : TReportInfo; const FileName:string); virtual; abstract;
    procedure   LoadFromFile(ReportInfo : TReportInfo; const FileName:string); virtual; abstract;
    function    IsDefault : Boolean;
    property    FileExt : string read FFileExt write SetFileExt; // lowercase
    property    Description : string  read FDescription write FDescription;
  end;

  TResReportFileStore = class(TCustomReportFileStore)
  private

  public
    constructor Create(const AFileExt : string; const ADescription : string='';  IsDefault : Boolean=False); override;
    procedure   SaveToFile(ReportInfo : TReportInfo; const FileName:string); override;
    procedure   LoadFromFile(ReportInfo : TReportInfo; const FileName:string); override;
  end;

  TReportFileStores = class(TObject)
  private
    FStores : TObjectList;
    FDefaultStore: TCustomReportFileStore;
    procedure   Add(Store : TCustomReportFileStore);
    procedure   Remove(Store : TCustomReportFileStore);
  public
    constructor Create;
    destructor  Destroy;override;
    function    FindStore(const FileExt:string): TCustomReportFileStore;
    property    DefaultStore : TCustomReportFileStore read FDefaultStore write FDefaultStore;
    property    Stores : TObjectList read FStores;
    procedure   GetFileInfo(var FileFilters, DefaultExt : string);
  end;

const
  DefaultReportFileExt = '.rpt';

var
  ReportFileStores : TReportFileStores;

implementation

uses SafeCode, RPDBVCL, CompUtils;

{$R *.DFM}

{ TReportInfo }

constructor TReportInfo.Create(AOwner: TComponent);
begin
  inherited;
  FVariantValues:= TStringList.Create;
  FFieldMapping:= TStringList.Create;
  FDataEntries:= TOwnedCollection.Create(Self,TRPDataEntry);
end;

destructor TReportInfo.Destroy;
begin
  ClearReport;
  FFieldMapping.Free;
  FVariantValues.Free;
  inherited;
end;

procedure TReportInfo.Clear;
begin
  DestroyComponents;
  FieldMapping.Clear;
  VariantValues.Clear;
  DataEntries.Clear;
end;

procedure TReportInfo.CreateReport;
var
  i : integer;
  //Dataset : TRPDataset;
  Controller : TRPDatasetController;
begin
  ClearReport;

  FEnvironment:= TRPDataEnvironment.Create(Self);
  FEnvironment.FieldMapping := FieldMapping;
  FEnvironment.VariantValues := VariantValues;

  FProcessor:= TReportProcessor.Create(Self);
  FProcessor.DesignedReport := Report;

  FEasyReport:= TRPEasyReport.Create(Self);
  FEasyReport.Enviroment := FEnvironment;
  FEasyReport.Processor := FProcessor;

  //FDatasets:= TObjectList.Create;
  FOwnedDatasets := TObjectList.Create;
  FControllers:= TObjectList.Create;
  for i:=0 to DataEntries.Count-1 do
    with TRPDataEntry(DataEntries.Items[i]) do
    begin
      {Dataset := TRPDBDataset.Create(Self);
      Dataset.DatasetName := DatasetName;
      Dataset.Enviroment := Environment;
      FDatasets.Add(Dataset);}

      Controller := TRPDatasetController.Create(Self);
      Controller.ControllerName := ControllerName;
      Controller.Groups := Groups;
      //Controller.Dataset := Dataset;
      Controller.FromFirst := FromFirst;
      Controller.Enviroment := Environment;
      FControllers.Add(Controller);
    end;
  FProcessor.CreateReportFromDesign;
end;

procedure TReportInfo.ClearReport;
begin
  FreeAndNil(FControllers);
  FreeAndNil(FProcessor);
  FreeAndNil(FEnvironment);
  FreeAndNil(FEasyReport);
  //FreeAndNil(FDatasets);
  FreeAndNil(FOwnedDatasets);
end;

function TReportInfo.GetEntryCount: Integer;
begin
  Result := FDataEntries.Count;
end;

procedure TReportInfo.LoadFromFile(const FileName: string);
var
  Ext : string;
  Store : TCustomReportFileStore;
begin
  Ext := ExtractFileExt(FileName);
  Store := ReportFileStores.FindStore(Ext);
  CheckObject(Store,'Cannot load to '+Ext+' file!');
  Store.LoadFromFile(Self,FileName);
end;

procedure TReportInfo.New;
begin
  Clear;
  InitInheritedComponent(Self, TFrame);
end;

function TReportInfo.NewGroupBand: TRDGroupBand;
begin
  Result := TRDGroupBand.Create(Self);
end;

function TReportInfo.NewLabel: TRDLabel;
begin
  Result := TRDLabel.Create(Self);
  Result.Name := Format('L_%8.8x',[Integer(Result)]);
  Result.Caption := '';
end;

function TReportInfo.NewPicture: TRDPicture;
begin
  Result := TRDPicture.Create(Self);
  Result.Name := Format('P_%8.8x',[Integer(Result)]);
end;

function TReportInfo.NewRepeatBand: TRDRepeatBand;
begin
  Result := TRDRepeatBand.Create(Self);
end;

function TReportInfo.NewShape: TRDShape;
begin
  Result := TRDShape.Create(Self);
  Result.Name := Format('S_%8.8x',[Integer(Result)]);
end;

function TReportInfo.NewSimpleBand: TRDSimpleBand;
begin
  Result := TRDSimpleBand.Create(Self);
end;

procedure TReportInfo.SaveToFile(const FileName: string);
var
  Ext : string;
  Store : TCustomReportFileStore;
begin
  Ext := ExtractFileExt(FileName);
  Store := ReportFileStores.FindStore(Ext);
  CheckObject(Store,'Cannot save to '+Ext+' file!');
  Store.SaveToFile(Self,FileName);
end;

procedure TReportInfo.SetDataEntries(const Value: TCollection);
begin
  FDataEntries.Assign(Value);
end;

procedure TReportInfo.SetFieldMapping(const Value: TStrings);
begin
  FFieldMapping.Assign(Value);
end;

procedure TReportInfo.SetVariantValues(const Value: TStrings);
begin
  FVariantValues.Assign(Value);
end;

procedure TReportInfo.Preview;
begin
  CheckCreate;
  EasyReport.Preview;
end;

procedure TReportInfo.Print;
begin
  CheckCreate;
  EasyReport.Print;
end;

procedure TReportInfo.CheckCreate;
begin
  if EasyReport=nil then
    CreateReport;
end;

procedure TReportInfo.AddDataset(Dataset: TRPDataset);
var
  i : integer;
begin
  Assert(FControllers<>nil);
  i := IndexOfDataset(Dataset.DatasetName);
  CheckTrue(i>=0,'No Entry For '+Dataset.DatasetName);
  Dataset.Enviroment := Environment;
  TRPDatasetController(Controllers[i]).Dataset := Dataset;
end;

procedure TReportInfo.AddDatasource(const DatasetName: string;
  Datasource: TDatasource);
var
  i : integer;
  Dataset: TRPDBDataset;
begin
  Assert(FControllers<>nil);
  i := IndexOfDataset(DatasetName);
  CheckTrue(i>=0,'No Entry For '+DatasetName);
  Dataset:= TRPDBDataset.Create(Self);
  Dataset.Enviroment := Environment;
  Dataset.DatasetName := DatasetName;
  Dataset.DataSource := Datasource;
  FOwnedDatasets.Add(Dataset);
  TRPDatasetController(Controllers[i]).Dataset := Dataset;
end;


function TReportInfo.IndexOfController(
  const ControllerName: string): Integer;
var
  i : integer;
begin
  for i:=0 to FDataEntries.Count-1 do
    if CompareText(TRPDataEntry(FDataEntries.Items[i]).ControllerName,ControllerName)=0 then
    begin
      Result := i;
      Exit;
    end;
  Result := -1;
end;

function TReportInfo.IndexOfDataset(const DatasetName: string): Integer;
var
  i : integer;
begin
  for i:=0 to FDataEntries.Count-1 do
    if CompareText(TRPDataEntry(FDataEntries.Items[i]).DatasetName,DatasetName)=0 then
    begin
      Result := i;
      Exit;
    end;
  Result := -1;
end;


{ TCustomReportFileStore }

constructor TCustomReportFileStore.Create(const AFileExt: string; const ADescription : string='';
  IsDefault : Boolean=False);
begin
  FFileExt := LowerCase(AFileExt);
  Assert(ReportFileStores<>nil);
  ReportFileStores.Add(Self);
  if IsDefault then
    ReportFileStores.DefaultStore := Self;
  if ADescription<>'' then
    FDescription := ADescription else
    FDescription := 'Files (*'+AFileExt+')';
end;

destructor TCustomReportFileStore.Destroy;
begin
  {Assert(ReportFileStores<>nil);}
  if ReportFileStores<>nil then
    ReportFileStores.Remove(Self);
  inherited;
end;

function TCustomReportFileStore.IsDefault: Boolean;
begin
  Assert(ReportFileStores<>nil);
  Result := ReportFileStores.DefaultStore = Self;
end;

procedure TCustomReportFileStore.SetFileExt(const Value: string);
begin
  FFileExt := LowerCase(Value);
end;

{ TResReportFileStore }

constructor TResReportFileStore.Create(const AFileExt: string; const ADescription : string='';
  IsDefault : Boolean=False);
begin
  inherited;
  RegisterClasses([TRDSimpleBand,TRDGroupBand,TRDRepeatBand,TRDReport,
    TRDLabel,TRDShape,TRDPicture]);
end;

procedure TResReportFileStore.LoadFromFile(ReportInfo: TReportInfo;
  const FileName: string);
begin
  ReportInfo.Clear;
  TryReadComponentResFile(FileName,ReportInfo);
  //ReadComponentResFile(FileName,ReportInfo);
end;

procedure TResReportFileStore.SaveToFile(ReportInfo: TReportInfo;
  const FileName: string);
begin
  WriteComponentResFile(FileName,ReportInfo);
end;

{ TReportFileStores }

constructor TReportFileStores.Create;
begin
  FStores := TObjectList.Create;
  FDefaultStore := nil;
end;

destructor TReportFileStores.Destroy;
begin
  FStores.Clear;
  FreeAndNil(FStores);
  inherited;
end;

procedure TReportFileStores.Remove(Store: TCustomReportFileStore);
begin
  FStores.Extract(Store);
  if DefaultStore=Store then
    DefaultStore:=nil;
end;

procedure TReportFileStores.Add(Store: TCustomReportFileStore);
begin
  FStores.Add(Store);
end;

function TReportFileStores.FindStore(
  const FileExt: string): TCustomReportFileStore;
var
  i : integer;
  Ext : string;
begin
  Ext := LowerCase(FileExt);
  for i:=0 to FStores.count-1 do
  begin
    Result := TCustomReportFileStore(FStores[i]);
    if Ext=Result.FileExt then
      Exit;
  end;
  Result := DefaultStore;
end;

procedure TReportFileStores.GetFileInfo(var FileFilters,
  DefaultExt: string);
var
  i : integer;
begin
  FileFilters := '';
  DefaultExt := '';
  for i:=0 to FStores.count-1 do
  begin
    if i>0 then
      FileFilters := FileFilters +'|';
    with TCustomReportFileStore(FStores[i]) do
      FileFilters := Format('%s%s|*%s',[FileFilters,Description,FileExt]);
  end;
  if DefaultStore<>nil then
    DefaultExt := DefaultStore.FileExt;
  Delete(DefaultExt,1,1); // delete '.'
end;

{ TRPDataEntry }

constructor TRPDataEntry.Create(Collection: TCollection);
begin
  inherited;
  FGroups := TStringList.Create;
  FFromFirst := true;
end;

destructor TRPDataEntry.Destroy;
begin
  FGroups.Free;
  inherited;
end;

function TRPDataEntry.GetDisplayName: string;
begin
  Result := ControllerName;
end;

procedure TRPDataEntry.SetControllerName(const Value: string);
begin
  FControllerName := Value;
  if FDatasetName='' then
    FDatasetName := Value;
end;

procedure TRPDataEntry.SetDatasetName(const Value: string);
begin
  FDatasetName := Value;
  if FControllerName='' then
    FControllerName:= Value;
end;

procedure TRPDataEntry.SetGroups(const Value: TStrings);
begin
  FGroups.Assign(Value);
end;

initialization
  ReportFileStores := TReportFileStores.Create;
  TResReportFileStore.Create(DefaultReportFileExt,'',true);

finalization
  FreeAndNil(ReportFileStores);
end.
