unit RPDesignInfo;

interface

uses Windows, Messages, SysUtils, Classes, Contnrs, RPBands, RPCtrls, RPDB,
  RPProcessors, RPEasyReports, RPPrintObjects;

type
  TReportInfo = class(TComponent)
  private
    { Private declarations }
    FVariantValues: TStrings;
    FFieldMapping: TStrings;
    FDataEntries: TRPDataEntries;
    FProcessor: TReportProcessor;
    FEnvironment: TRPDataEnvironment;
    FEasyReport: TRPEasyReport;
    FOnError: TOnReportEngineErrorEvent;
    FFileName: string;
    FOnPrint: TIsPrintEvent;
    FLoading : Boolean;
    FPreviewState: Boolean;
    FOnPrintProgress: TPrintProgressEvent;
    FTitle: string;
    //FDatasets: TObjectList;
    {FCountLabel : Integer;
    FCountShape : Integer;
    FCountPicture : Integer;}
    procedure   SetFieldMapping(const Value: TStrings);
    procedure   SetVariantValues(const Value: TStrings);
    procedure   SetDataEntries(const Value: TRPDataEntries);
    procedure   DoAfterLoad;
    procedure   SetFileName(const Value: string);
  protected
    procedure   GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure   ValidateRename(AComponent: TComponent;
      const CurName, NewName: string); override;
    procedure   InternalRepareReport; virtual;
    procedure   SetName(const NewName: TComponentName); override;
    procedure   BeforePrint; virtual;
    procedure   AfterPrint; virtual;
    property    FileName : string read FFileName write SetFileName;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
    // for Design
    procedure   Clear;
    procedure   New;
    // Notes : File Format Is Defined By TCustomReportFileStore
    procedure   SaveToFile(const FileName:string);
    procedure   LoadFromFile(const FileName:string);
    // Notes : Stream is always resource format.
    procedure   SaveToStream(Stream : TStream);
    procedure   LoadFromStream(Stream : TStream);
    function    NewSimpleBand : TRDSimpleBand;
    function    NewGroupBand : TRDGroupBand;
    function    NewRepeatBand : TRDRepeatBand;
    function    NewLabel: TRDLabel;
    function    NewShape: TRDShape;
    function    NewPicture: TRDPicture;
    // for Print
    procedure   NewDataEntriesClass(EntriesClass : TRPDataEntriesClass);
    procedure   CheckCreate;
    procedure   ClearReport;
    procedure   CreateReport;
    procedure   Print(StartPage : Integer=0; EndPage : Integer=0);
    procedure   Preview(StartPage : Integer=0; EndPage : Integer=0);
    property    Environment : TRPDataEnvironment read FEnvironment;
    property    EasyReport : TRPEasyReport read FEasyReport;
    property    Processor : TReportProcessor read FProcessor;
    //property    Datasets: TObjectList read FDatasets;
    // 简化的调用方法，根据文件名FileName获取报表格式，创建相应的对象
    procedure   PrepareReport;
    function    SetCtrlPrintable(const ID:string; Printable : Boolean):Boolean;
    procedure   SetVariantValue(const Name,Value : string);
    property    PreviewState : Boolean read FPreviewState;
  published
    Report: TRDReport;
    property    FieldMapping : TStrings read FFieldMapping write SetFieldMapping;
    property    VariantValues : TStrings read FVariantValues write SetVariantValues;
    property    DataEntries : TRPDataEntries read FDataEntries write SetDataEntries;
    property    Title : string read FTitle write FTitle;
    property    OnError : TOnReportEngineErrorEvent read FOnError write FOnError;
    property    OnPrint : TIsPrintEvent read FOnPrint write FOnPrint;
    property    OnPrintProgress : TPrintProgressEvent read FOnPrintProgress write FOnPrintProgress;
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

uses SafeCode, CompUtils;

{ TReportInfo }

constructor TReportInfo.Create(AOwner: TComponent);
begin
  inherited;
  FVariantValues:= TStringList.Create;
  FFieldMapping:= TStringList.Create;
  FDataEntries:= TRPDataEntries.Create(Self);
  FLoading := False;
  New;
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
  ClearReport;
  DestroyComponents;
  Report := nil;
  FieldMapping.Clear;
  VariantValues.Clear;
  DataEntries.Clear;
end;

procedure TReportInfo.CreateReport;
begin
  ClearReport;

  FEnvironment:= TRPDataEnvironment.Create(Self);

  FProcessor:= TReportProcessor.Create(Self);
  FProcessor.DesignedReport := Report;

  FEasyReport:= TRPEasyReport.Create(Self);
  FEasyReport.Environment := Environment;
  FEasyReport.Processor := FProcessor;

  FDataEntries.CreateControllers(Environment);
  //FDatasets:= TObjectList.Create;

  FProcessor.CreateReportFromDesign;
end;

procedure TReportInfo.ClearReport;
begin
  DataEntries.ClearControllers;
  FreeAndNil(FProcessor);
  FreeAndNil(FEnvironment);
  FreeAndNil(FEasyReport);
  //FreeAndNil(FDatasets);
end;

procedure TReportInfo.LoadFromFile(const FileName: string);
var
  Ext : string;
  Store : TCustomReportFileStore;
begin
  Ext := ExtractFileExt(FileName);
  Store := ReportFileStores.FindStore(Ext);
  CheckObject(Store,'Cannot load to '+Ext+' file!');

  Clear;
  try
    FLoading := True;
  finally
    Store.LoadFromFile(Self,FileName);
    FLoading := False;
    DoAfterLoad;
  end;
end;

procedure TReportInfo.New;
begin
  Clear;
  Report := TRDReport.Create(Self);
  Report.Name := 'Report';
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

procedure TReportInfo.SetDataEntries(const Value: TRPDataEntries);
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

procedure TReportInfo.Preview(StartPage : Integer=0; EndPage : Integer=0);
begin
  CheckCreate;
  FPreviewState := True;
  BeforePrint;
  try
    EasyReport.Preview(StartPage,EndPage);
  finally
    AfterPrint;
    FPreviewState := False;
  end;
end;

procedure TReportInfo.Print(StartPage : Integer=0; EndPage : Integer=0);
begin
  CheckCreate;
  FPreviewState := False;
  BeforePrint;
  try
    EasyReport.Print(StartPage,EndPage);
  finally
    AfterPrint;
  end;
end;

procedure TReportInfo.CheckCreate;
begin
  if EasyReport=nil then
    CreateReport;
end;

procedure TReportInfo.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  I: Integer;
  OwnedComponent: TComponent;
begin
  inherited GetChildren(Proc, Root);
  if Root = Self then
  begin
    if (Report<>nil) and (Report.HasParent) then
      Proc(Report);
    for I := 0 to ComponentCount - 1 do
    begin
      OwnedComponent := Components[I];
      if not OwnedComponent.HasParent then Proc(OwnedComponent);
    end;
  end;
end;

procedure TReportInfo.LoadFromStream(Stream: TStream);
begin
  Clear;
  try
    FLoading := True;
    Stream.ReadComponentRes(Self);
  finally
    FLoading := False;
  end;
  DoAfterLoad;
end;

procedure TReportInfo.SaveToStream(Stream: TStream);
begin
  Stream.WriteComponentRes(Self.ClassName, Self);
end;

procedure TReportInfo.NewDataEntriesClass(
  EntriesClass: TRPDataEntriesClass);
var
  Temp : TRPDataEntries;
begin
  Temp := EntriesClass.Create(Self);
  Temp.Assign(DataEntries);
  DataEntries.Free;
  FDataEntries := Temp;
end;

procedure TReportInfo.ValidateRename(AComponent: TComponent; const CurName,
  NewName: string);
begin
  inherited;
  // 当控件被删除的时候允许改变名字！
  if (AComponent=Report)
    and not (csFreeNotification in AComponent.ComponentState)
    and not (csDestroying	in AComponent.ComponentState)
    and (CurName<>NewName) and not SameText(NewName,'Report') then
    Abort;
end;

procedure TReportInfo.DoAfterLoad;
var
  I : Integer;
begin
  if Report=nil then
  begin
    // correct name for report object
    for I:=0 to ComponentCount-1 do
    begin
      if Components[I] is TRDReport then
      begin
        Components[I].Name := 'Report';
        Break;
      end;
    end;
  end;
  CheckObject(Report,'Cannot load Report!');
end;

procedure TReportInfo.PrepareReport;
begin
  if Report=nil then
  begin
    LoadFromFile(FileName);
    CreateReport;
    InternalRepareReport;
  end;
end;

function TReportInfo.SetCtrlPrintable(const ID: string;
  Printable: Boolean): Boolean;
var
  Ctrl : TRPPrintItemCtrl;
begin
  CheckObject(Processor,'Error : No Processor');
  Ctrl := Processor.FindPrintCtrl(ID);
  Result := Ctrl<>nil;
  if Result then
    Ctrl.IsPrint := Printable;
end;

procedure TReportInfo.SetFileName(const Value: string);
begin
  if FFileName <> Value then
  begin
    FFileName := Value;
    Clear;
  end;
end;

procedure TReportInfo.SetVariantValue(const Name, Value: string);
begin
  VariantValues.Values[Name] := Value;
  if Environment<>nil then
    Environment.VariantValues.Values[Name] := Value;
end;

procedure TReportInfo.InternalRepareReport;
begin

end;

procedure TReportInfo.SetName(const NewName: TComponentName);
begin
  if not FLoading then
    inherited;
end;

procedure TReportInfo.AfterPrint;
begin

end;

procedure TReportInfo.BeforePrint;
begin
  // 从原来的 CreateReport移过来
  FEnvironment.VariantValues := VariantValues;
  FEnvironment.FieldMapping := FieldMapping;
  
  FProcessor.Title := Title;
  FProcessor.OnError := OnError;
  FProcessor.OnPrint := OnPrint;
  FProcessor.OnPrintProgress := OnPrintProgress;
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

initialization
  ReportFileStores := TReportFileStores.Create;
  TResReportFileStore.Create(DefaultReportFileExt,'',true);

finalization
  FreeAndNil(ReportFileStores);
end.
