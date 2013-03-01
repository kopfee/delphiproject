unit RPProcessors;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>RPProcessors
   <What>实现IReportProcessor接口
   TReportProcessor 还完成:
   1、根据设计的报表格式(TRDReport)生成描述报表的对象(TRPReport)。
   2、还提供在打印前，对TRPDatasetController的初始化。
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

interface

uses SysUtils, Classes, Graphics, Controls, Contnrs,
  RPDefines, RPCtrls, RPDB, RPBands, RPPrintObjects;

const
  NoPrintOnFirstPage = '#NoPrintOnFirstPage';
  NoPrintOnLastPage = '#NoPrintOnLastPage';
  PrintOnFirstPage = '#PrintOnFirstPage';
  PrintOnLastPage = '#PrintOnLastPage';

type
  TPredefinedVariantType = (pvtNone,
    pvtPageNumber,          // 打印逻辑页数
    pvtDate,                // 打印日期
    pvtTime,                // 打印时间
    pvtReportPageNumber,    // 报表逻辑页数。一个打印逻辑页可以包含多个报表逻辑页
    pvtPhysicalPageNumber   // 物理页数
    );

  {
    <Class>TCustomReportProcessor
    <What>实现IReportProcessor接口
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TCustomReportProcessor = class(TComponent, IReportProcessor)
  private
    FLineStyles: TLineStyles;
    FPrinter: IBasicPrinter;
  protected
    FReportStatus : TReportStatus;
    // IReportProcessor
    procedure   BeginDoc;
    procedure   EndDoc;
    procedure   AbortDoc;
    procedure   NewPage;
    procedure   ProcessReport(ReportInfo, ReportedObject : TObject; const ARect : TRPRect); virtual; abstract;
    function    GetLineStyles : TLineStyles;
    function    FindField(const FieldName:string): TObject; virtual;
    function    GetVariantText(const FieldName:string;
                  TextFormatType : TRPTextFormatType=tfNone;
                  const TextFormat : string='' ): string; virtual;
    function    IsPrint(ReportInfo, ReportedObject : TObject; var ARect : TRPRect): Boolean; virtual;
    procedure   DoProgress(var ContinuePrint : Boolean); virtual;
    procedure   DoBeforePrint; virtual;
    procedure   DoAfterPrint; virtual;
    function    GetStatus : TReportStatus;
    procedure   SetStatus(Value: TReportStatus);
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    function    GetTitle : string; virtual;
    property    LineStyles : TLineStyles read FLineStyles;
    property    Printer : IBasicPrinter read FPrinter write FPrinter;
    property    ReportStatus : TReportStatus read FReportStatus;
  end;

  TReportProcessor = class;

  TIsPrintEvent = procedure (Processor : TReportProcessor; Ctrl : TRPPrintCtrl; ReportInfo : TRPPrintingInfo; var IsPrint : Boolean) of object;
  TPrintProgressEvent = procedure (Processor : TReportProcessor; var ContinuePrint : Boolean) of object;
  {
    <Class>TReportProcessor
    <What>
    1、根据设计的报表格式(TRDReport)生成描述报表的对象(TRPReport)。
    2、还提供在打印前，对TRPDatasetController的初始化。
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TReportProcessor = class(TCustomReportProcessor)
  private
    FDesignedReport: TRDReport;
    FReport: TRPReport;
    //FDatasetList : TList;
    FDateFormat: string;
    FEnvironment: TRPDataEnvironment;
    FOnPrint: TIsPrintEvent;
    FLastReportInfo : TRPPrintingInfo;
    FOnError: TOnReportEngineErrorEvent;
    FTimeFormat: string;
    FOnPrintProgress: TPrintProgressEvent;
    FBeforePrint: TNotifyEvent;
    FAfterPrint: TNotifyEvent;
    FTitle: string;
    FFixedSize: Boolean;
    FFixedPaperWidth, FFixedPaperHeight : TFloat;
    FFixedOrientation : TRPOrientation;
    procedure   SetDesignedReport(const Value: TRDReport);
    procedure   SetupBand(Band : TRPBand; DesignBand : TRDCustomBand);
    function    CreatePrintBand(DesignBand : TRDSimpleBand): TRPPrintBand;
    procedure   CreateChildren(Band : TRPGroupBand; DesignBand : TRDCustomGroupBand);
    function    CreatePrintItem(RDCtrl: TRDCustomControl): TRPPrintItemCtrl;
    procedure   SetEnvironment(const Value: TRPDataEnvironment);
    procedure   SetupPrinter;
    procedure   RestorePrinter;
  protected
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure   ProcessReport(ReportInfo, ReportedObject : TObject; const ARect : TRPRect); override;
    function    FindField(const FieldName:string): TObject; override;
    function    GetVariantText(const FieldName:string;
                  TextFormatType : TRPTextFormatType=tfNone;
                  const TextFormat : string=''): string; override;
    function    IsPrintCtrl(Ctrl : TRPPrintCtrl; ReportInfo : TRPPrintingInfo): boolean;
    function    IsPrint(ReportInfo, ReportedObject : TObject; var ARect : TRPRect): Boolean; override;
    procedure   DoProgress(var ContinuePrint : Boolean); override;
    procedure   DoBeforePrint; override;
    procedure   DoAfterPrint; override;
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    procedure   NewReport;
    procedure   FreeReport;
    procedure   CreateReportFromDesign;
    procedure   Print(StartPage : Integer=0; EndPage : Integer=0);
    function    FindPrintCtrl(const ID:string): TRPPrintItemCtrl;
    function    GetTitle : string; override;
    property    Report : TRPReport read FReport write FReport;
    property    Environment : TRPDataEnvironment read FEnvironment write SetEnvironment;
    property    OnError : TOnReportEngineErrorEvent read FOnError write FOnError;
    property    FixedSize : Boolean read FFixedSize write FFixedSize default False;
    property    FixedPaperWidth : TFloat read FFixedPaperWidth;
    property    FixedPaperHeight : TFloat read FFixedPaperHeight;
  published
    property    DesignedReport : TRDReport read FDesignedReport write SetDesignedReport;
    property    Title : string read FTitle write FTitle;
    property    DateFormat : string read FDateFormat write FDateFormat;
    property    TimeFormat : string read FTimeFormat write FTimeFormat;
    property    OnPrint : TIsPrintEvent read FOnPrint write FOnPrint;
    property    OnPrintProgress : TPrintProgressEvent read FOnPrintProgress write FOnPrintProgress;
    property    BeforePrint : TNotifyEvent read FBeforePrint write FBeforePrint;
    property    AfterPrint : TNotifyEvent read FAfterPrint write FAfterPrint;
  end;

  TRPGlobe = class(TComponent)
  private
    FOnPrintProgress: TPrintProgressEvent;
    FDefaultProgress: Boolean;
    FBeforePrint: TNotifyEvent;
    FAfterPrint: TNotifyEvent;
  protected
    procedure   DoBeforePrint(Processor : TReportProcessor);
    procedure   DoAfterPrint(Processor : TReportProcessor);
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
    procedure   DoProgress(Processor : TReportProcessor; var ContinuePrint : Boolean);
  published
    property    DefaultProgress : Boolean read FDefaultProgress write FDefaultProgress default True;
    property    OnPrintProgress : TPrintProgressEvent read FOnPrintProgress write FOnPrintProgress;
    property    BeforePrint : TNotifyEvent read FBeforePrint write FBeforePrint;
    property    AfterPrint : TNotifyEvent read FAfterPrint write FAfterPrint;
  end;

const
  pvtBegin = pvtPageNumber;
  pvtEnd = pvtPhysicalPageNumber;
  PredefinedVariantNames : Array[pvtBegin..pvtEnd] of string
    = (
      '#Page',
      '#Date',
      '#Time',
      '#ReportPage',
      '#PhysicalPage'
      );

function FindVariant(const Name:string): TPredefinedVariantType;

var
  RPGlobe : TRPGlobe;

implementation

uses LogFile, SafeCode, RPProgress;

function FindVariant(const Name:string): TPredefinedVariantType;
var
  i : TPredefinedVariantType;
begin
  for i:=pvtBegin to pvtEnd do
    if CompareText(PredefinedVariantNames[i],Name)=0 then
    begin
      Result := i;
      Exit;
    end;
  Result := pvtNone;
end;

{ TCustomReportProcessor }

constructor TCustomReportProcessor.Create(AOwner: TComponent);
begin
  inherited;
  FLineStyles := TLineStyles.Create(Self);
end;

destructor TCustomReportProcessor.Destroy;
begin
  FLineStyles.Free;
  inherited;
end;

procedure TCustomReportProcessor.AbortDoc;
begin
  Assert(FPrinter<>nil);
  FPrinter.AbortDoc;
  DoAfterPrint;
end;

procedure TCustomReportProcessor.BeginDoc;
begin
  Assert(FPrinter<>nil);
  DoBeforePrint;
  FPrinter.BeginDoc(GetTitle);
end;

procedure TCustomReportProcessor.EndDoc;
begin
  Assert(FPrinter<>nil);
  FPrinter.EndDoc;
  DoAfterPrint;
end;

function TCustomReportProcessor.GetLineStyles: TLineStyles;
begin
  Result := FLineStyles;
end;

procedure TCustomReportProcessor.NewPage;
begin
  Assert(FPrinter<>nil);
  FPrinter.NewPage;
end;

function TCustomReportProcessor.FindField(
  const FieldName: string): TObject;
begin
  Result := nil;
end;

function TCustomReportProcessor.GetVariantText(
  const FieldName: string; TextFormatType : TRPTextFormatType=tfNone;
  const TextFormat : string=''): string;
begin
  Result := '';
end;

function TCustomReportProcessor.IsPrint(ReportInfo,
  ReportedObject: TObject; var ARect : TRPRect): Boolean;
begin
  Result := True;
end;

procedure TCustomReportProcessor.DoProgress(var ContinuePrint: Boolean);
begin

end;

procedure TCustomReportProcessor.DoAfterPrint;
begin

end;

procedure TCustomReportProcessor.DoBeforePrint;
begin
  FReportStatus := rsRunning;
end;

function TCustomReportProcessor.GetTitle: string;
begin
  Result := '';
end;

function TCustomReportProcessor.GetStatus: TReportStatus;
begin
  Result := FReportStatus;
end;

procedure TCustomReportProcessor.SetStatus(Value: TReportStatus);
begin
  FReportStatus := Value;
end;

{ TReportProcessor }

constructor TReportProcessor.Create(AOwner: TComponent);
begin
  inherited;
  FReport := nil;
  //FDatasetList := TList.Create;
  FDateFormat := 'yyyy/mm/dd';
  FTimeFormat := 'hh:nn:ss';
  FLastReportInfo := nil;
  FixedSize := False;
end;

destructor TReportProcessor.Destroy;
begin
  //FDatasetList.Free;
  FreeReport;
  inherited;
end;

procedure TReportProcessor.FreeReport;
begin
  if FReport<>nil then
    FreeAndNil(FReport);
end;

procedure TReportProcessor.NewReport;
begin
  if FReport=nil then
    FReport:=TRPReport.Create(nil)
  else
    FReport.Clear;
  FixedSize := False;  
end;

procedure TReportProcessor.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation=opRemove) then
  begin
    if (AComponent=FDesignedReport) then
      FReport := nil;
    if (AComponent=FEnvironment) then
      FEnvironment := nil;
  end;
end;

procedure TReportProcessor.ProcessReport(ReportInfo, ReportedObject: TObject;
  const ARect: TRPRect);
begin
  Assert(Printer<>nil);
  if ReportedObject is TRPPrintCtrl then
  begin
    if IsPrintCtrl(TRPPrintCtrl(ReportedObject), TRPPrintingInfo(ReportInfo)) then
      TRPPrintCtrl(ReportedObject).Print(Self,Printer,ARect);
  end;
end;

procedure TReportProcessor.SetDesignedReport(const Value: TRDReport);
begin
  if FDesignedReport<> Value then
  begin
    FDesignedReport:= Value;
    if FDesignedReport<>nil then
    begin
      FDesignedReport.FreeNotification(Self);
    end;
  end;
end;

procedure TReportProcessor.CreateReportFromDesign;
begin
  CheckObject(FDesignedReport,'DesignedReport is nil');
  NewReport;
  (*
  if Printer<>nil then
  begin
    Report.PageWidth := Printer.Width;
    Report.PageHeight := Printer.Height;
  end;
  *)
  Report.Margin := DesignedReport.Margin;
  Report.Rows := DesignedReport.Rows;
  Report.Columns := DesignedReport.Columns;
  Report.RowSpace := DesignedReport.RowSpace;
  Report.ColumnSpace := DesignedReport.ColumnSpace;
  //Report.BandName := DesignedReport.BandName;
  LineStyles.Assign(DesignedReport.LineStyles);
  SetupBand(Report,DesignedReport);
  FixedSize := DesignedReport.FixedSize;
  if FixedSize then
  begin
    FFixedPaperWidth  := DesignedReport.PaperWidth;
    FFixedPaperHeight := DesignedReport.PaperHeight;
    FFixedOrientation := DesignedReport.Orientation;
  end;
  {$ifdef debug }
  //SaveReport(Report,'c:\reportdebug.txt');
  {$endif}
end;

procedure TReportProcessor.SetupBand(Band: TRPBand;
  DesignBand: TRDCustomBand);
begin
  Band.Width := DesignBand.PrintSize.PrintWidth; //ScreenTransform.Device2PhysicsX(DesignBand.Width);
  Band.Height := DesignBand.PrintSize.PrintHeight; //ScreenTransform.Device2PhysicsY(DesignBand.Height);
  Band.BandName := DesignBand.BandName;
  if Band is TRPSimpleBand then
  begin
    Assert(DesignBand is TRDSimpleBand);
    TRPSimpleBand(Band).OwnObject := true;
    TRPSimpleBand(Band).IsAlignBottom := TRDSimpleBand(DesignBand).IsAlignBottom;
    TRPSimpleBand(Band).IsSpace := TRDSimpleBand(DesignBand).IsSpace;
    TRPSimpleBand(Band).IsForceNewPage := TRDSimpleBand(DesignBand).IsForceNewPage;
    TRPSimpleBand(Band).IsForceEndPage := TRDSimpleBand(DesignBand).IsForceEndPage;
    TRPSimpleBand(Band).NoNewPageAtFirst:= TRDSimpleBand(DesignBand).NoNewPageAtFirst;
    TRPSimpleBand(Band).ReportObject := CreatePrintBand(TRDSimpleBand(DesignBand));
  end
  else
  begin
    if Band is TRPGroupBand then
    begin
      Assert(DesignBand is TRDCustomGroupBand);
      CreateChildren(TRPGroupBand(Band),TRDCustomGroupBand(DesignBand));
    end;
    if Band is TRPRepeatBand then
    begin
      Assert(DesignBand is TRDCustomRepeatBand);
      TRPRepeatBand(Band).Columns := TRDCustomRepeatBand(DesignBand).Columns;
      TRPRepeatBand(Band).Browser.ControllerName := TRDCustomRepeatBand(DesignBand).ControllerName;
      //TRPRepeatBand(Band).Browser.ReportName := ReportName;
      TRPRepeatBand(Band).Browser.GroupingIndex := TRDCustomRepeatBand(DesignBand).GroupIndex;
    end;
  end;
end;

function TReportProcessor.CreatePrintBand(
  DesignBand: TRDSimpleBand): TRPPrintBand;
var
  i,Count : integer;
  RDCtrl : TRDCustomControl;
  PrintCtrl : TRPPrintCtrl;
begin
  Result := TRPPrintBand.Create;
  Result.BandName := DesignBand.BandName;
  Result.Frame := DesignBand.Frame;
  Result.Options := DesignBand.Options;
  if DesignBand.Transparent then
  begin
    Result.Brush.Style := bsClear;
  end
  else
  begin
    Result.Brush.Style := bsSolid;
    Result.Brush.Color := DesignBand.Color;
  end;

  Result.Font := DesignBand.Font;
  Count := DesignBand.ControlCount;
  for i:=0 to Count-1 do
  begin
    PrintCtrl := nil;
    if DesignBand.Controls[i] is TRDCustomControl then
    begin
      RDCtrl := TRDCustomControl(DesignBand.Controls[i]);
      if RDCtrl.IsPrint then
        PrintCtrl := CreatePrintItem(RDCtrl);
    end;
    if PrintCtrl<>nil then
      Result.Items.Add(PrintCtrl);
  end;
end;

procedure TReportProcessor.CreateChildren(Band: TRPGroupBand;
  DesignBand: TRDCustomGroupBand);
var
  i : integer;
  TempList : TList;
  ChildBand : TRPBand;
begin
  { TODO : 需要增加末尾的spaceband的支持 }
  DesignBand.ArrangeChildren;
  TempList := TList.Create;
  try
    for i:=0 to DesignBand.Children.Count-1 do
      if TRDCustomBand(DesignBand.Children[i]).IsPrint then
        TempList.Add(DesignBand.Children[i]);

    TempList.Remove(DesignBand.Lefter);
    TempList.Remove(DesignBand.Righter);
    TempList.Remove(DesignBand.Header);
    TempList.Remove(DesignBand.Footer);
    if (DesignBand.Header<>nil) and (DesignBand.Header.IsPrint) then
    begin
      ChildBand := TRPSimpleBand.Create(Band);
      Band.Header := TRPSimpleBand(ChildBand);
      SetupBand(ChildBand,DesignBand.Header);
    end;
    for i:=0 to TempList.Count-1 do
    begin
      ChildBand := nil;
      if TObject(TempList[i]) is TRDCustomRepeatBand then
        ChildBand := TRPRepeatBand.Create(Band)
      else if TObject(TempList[i]) is TRDCustomGroupBand then
        ChildBand := TRPGroupBand.Create(Band)
      else if TObject(TempList[i]) is TRDSimpleBand then
        ChildBand := TRPSimpleBand.Create(Band);
      Assert(ChildBand<>nil);
      SetupBand(ChildBand,TRDCustomBand(TempList[i]));
    end;
    if (DesignBand.Footer<>nil) and (DesignBand.Footer.IsPrint) then
    begin
      ChildBand := TRPSimpleBand.Create(Band);
      Band.Footer:= TRPSimpleBand(ChildBand);
      SetupBand(ChildBand,DesignBand.Footer);
    end;
    if (DesignBand.Lefter<>nil) and (DesignBand.Lefter.IsPrint) then
    begin
      ChildBand := TRPSimpleBand.Create(Band);
      Band.Lefter:= TRPSimpleBand(ChildBand);
      SetupBand(ChildBand,DesignBand.Lefter);
    end;
    if (DesignBand.Righter<>nil) and (DesignBand.Righter.IsPrint) then
    begin
      ChildBand := TRPSimpleBand.Create(Band);
      Band.Righter := TRPSimpleBand(ChildBand);
      SetupBand(ChildBand,DesignBand.Righter);
    end;
  finally
    TempList.Free;
  end;
end;

procedure TReportProcessor.Print(StartPage : Integer=0; EndPage : Integer=0);
var
  PageWidth, PageHeight : TFloat;
begin
  if Report=nil then
    CreateReportFromDesign;
  Assert(Report<>nil);
  Assert(Printer<>nil);
  SetupPrinter;
  try
    Printer.GetPageSize(PageWidth,PageHeight);
    Report.PageWidth := PageWidth;
    Report.PageHeight := PageHeight;
    Report.StaticMargin.Left := Printer.PaperLeftMargin;
    Report.StaticMargin.Right := Printer.PaperWidth - PageWidth - Report.StaticMargin.Left;
    Report.StaticMargin.Top := Printer.PaperTopMargin;
    Report.StaticMargin.Bottom := Printer.PaperHeight - PageHeight - Report.StaticMargin.Top;
    Report.OnError := OnError;
    //WriteLog(Format('Page = %g * %g',[Report.PageWidth,Report.PageHeight]),lcReport);
    //FDatasetList.Clear;
    //ControllerManager.Init(ReportName,FDatasetList);
    Report.ReportProcessor := Self;
    Report.Environment := Environment;
    FLastReportInfo := nil;
    Report.Print(StartPage,EndPage);
  finally
    Report.ReportProcessor := nil;
    RestorePrinter;
    //FDatasetList.Clear;
  end;
end;
(*
function TReportProcessor.FindField(const FieldName: string): TObject;
var
  i : integer;
begin
  for i:=0 to FDatasetList.Count-1 do
  begin
    Assert(TObject(FDatasetList[i]) is TDataset);
    Result := TDataset(FDatasetList[i]).FindField(FieldName);
    if Result<>nil then
      Exit;
  end;
  Result := nil;
end;
*)

function TReportProcessor.FindField(const FieldName: string): TObject;
begin
  if Environment<>nil then
    Result := Environment.FindField(FieldName) else
    Result := nil;
end;

function TReportProcessor.GetVariantText(
  const FieldName: string; TextFormatType : TRPTextFormatType=tfNone;
  const TextFormat : string=''): string;
var
  index : TPredefinedVariantType;
begin
  Result := '';
  Index := FindVariant(FieldName);
  if Index<>pvtNone then
  begin
    case Index of
      pvtPageNumber : if TextFormatType=tfNormal then
                        Result := Format(TextFormat,[Report.PageNumber]) else
                        Result := IntToStr(Report.PageNumber);
      pvtDate       : if TextFormatType=tfDateTime then
                        Result := FormatDateTime(TextFormat,Now) else
                        Result := FormatDateTime(DateFormat,Now);
      pvtTime       : if TextFormatType=tfDateTime then
                        Result := FormatDateTime(TextFormat,Now) else
                        Result := FormatDateTime(TimeFormat,Now);
      pvtReportPageNumber   : if TextFormatType=tfNormal then
                                Result := Format(TextFormat,[Report.ReportPageNumber]) else
                                Result := IntToStr(Report.ReportPageNumber);
      pvtPhysicalPageNumber : if TextFormatType=tfNormal then
                                Result := Format(TextFormat,[Printer.PageNumber]) else
                                Result := IntToStr(Printer.PageNumber);
      else Result := '';
    end;
  end
  else if Environment<>nil then
  begin
    //Result := Environment.VariantValues.Values[FieldName];
    Result := Environment.GetFieldText(FieldName);
    if TextFormatType=tfNormal then
      Result := Format(TextFormat,[Result]);
  end;
end;

function TReportProcessor.CreatePrintItem(
  RDCtrl: TRDCustomControl): TRPPrintItemCtrl;
begin
  if RDCtrl is TRDLabel then
  begin
    Result := TRPPrintLabel.Create;
    with TRPPrintLabel(Result) do
    begin
      Font := TRDLabel(RDCtrl).Font;
      Text := TRDLabel(RDCtrl).Caption;
      FieldName := TRDLabel(RDCtrl).FieldName;
      HAlign := TRDLabel(RDCtrl).HAlign;
      VAlign := TRDLabel(RDCtrl).VAlign;
      Frame := TRDLabel(RDCtrl).Frame;
      TextFormatType := TRDLabel(RDCtrl).TextFormatType;
      TextFormat := TRDLabel(RDCtrl).TextFormat;
      if RDCtrl.Transparent then
        Brush.Style := bsClear
      else
      begin
        Brush.Style := bsSolid;
        Brush.Color := TRDLabel(RDCtrl).Color;
      end;
    end;
  end
  else if RDCtrl is TRDShape then
  begin
    Result := TRPPrintShape.Create;
    with TRPPrintShape(Result) do
    begin
      LineIndex := TRDShape(RDCtrl).LineIndex;
      FillBrush := TRDShape(RDCtrl).Brush;
      Shape := TRPShapeType(TRDShape(RDCtrl).Shape);
      if RDCtrl.Transparent then
        Brush.Style := bsClear
      else
      begin
        Brush.Style := bsSolid;
        Brush.Color := TRDShape(RDCtrl).Color;
      end;
    end;
  end
  else if RDCtrl is TRDPicture then
  begin
    Result := TRPPrintPicture.Create;
    with TRPPrintPicture(Result) do
    begin
      FieldName := TRDPicture(RDCtrl).FieldName;
      Picture := TRDPicture(RDCtrl).Picture;
      Stretch := TRDPicture(RDCtrl).Stretch;
    end;
  end
  else
  begin
    Result := nil;
    Exit;
  end;
  // set common properties
  {
  Result.PageRect.Left := ScreenTransform.Device2PhysicsX(RDCtrl.Left);
  Result.PageRect.Right:= ScreenTransform.Device2PhysicsX(RDCtrl.Left+RDCtrl.Width);
  Result.PageRect.Top:= ScreenTransform.Device2PhysicsY(RDCtrl.Top);
  Result.PageRect.Bottom:= ScreenTransform.Device2PhysicsY(RDCtrl.Top+RDCtrl.Height);
  Result.RightDistance := ScreenTransform.Device2PhysicsX(RDCtrl.RightDistance);
  Result.BottomDistance := ScreenTransform.Device2PhysicsY(RDCtrl.BottomDistance);
  }
  Result.PageRect.Left  := RDCtrl.PrintSize.PrintLeft;
  Result.PageRect.Right := RDCtrl.PrintSize.PrintLeft+RDCtrl.PrintSize.PrintWidth;
  Result.PageRect.Top   := RDCtrl.PrintSize.PrintTop;
  Result.PageRect.Bottom:= RDCtrl.PrintSize.PrintTop+RDCtrl.PrintSize.PrintHeight;
  Result.RightDistance  := RDCtrl.PrintSize.PrintRightDistance;
  Result.BottomDistance := RDCtrl.PrintSize.PrintBottomDistance;

  Result.Anchors := TRPAnchors(RDCtrl.Anchors);
  Result.Options := RDCtrl.Options;
  Result.ID := RDCtrl.ID;
  Result.Margin := RDCtrl.Margin;
end;

procedure TReportProcessor.SetEnvironment(const Value: TRPDataEnvironment);
begin
  if FEnvironment <> Value then
  begin
    FEnvironment := Value;
    if FEnvironment<>nil then
      FEnvironment.FreeNotification(Self);
  end;
end;

function TReportProcessor.IsPrintCtrl(Ctrl: TRPPrintCtrl;
  ReportInfo: TRPPrintingInfo): boolean;
var
  IsFirstPage, IsLastPage : Boolean;
begin
  if ReportInfo<>nil then
    FLastReportInfo := ReportInfo else
    ReportInfo := FLastReportInfo;

  Result := Ctrl.IsPrint;
  // check print pageheader in the first page
  IsFirstPage := Printer.PageNumber=1;
  IsLastPage  := (ReportInfo<>nil) and (ReportInfo.PrintStack.Count=0);
  if Pos(NoPrintOnFirstPage,Ctrl.Options)>0 then
    Result := not IsFirstPage;
  if Pos(PrintOnFirstPage,Ctrl.Options)>0 then
    Result := IsFirstPage;
  if Pos(NoPrintOnLastPage,Ctrl.Options)>0 then
    Result := not IsLastPage;
  if Pos(PrintOnLastPage,Ctrl.Options)>0 then
    Result := IsLastPage;
  if Assigned(FOnPrint) then
    FOnPrint(Self,Ctrl,ReportInfo,Result);
end;

function TReportProcessor.IsPrint(ReportInfo,
  ReportedObject: TObject; var ARect : TRPRect): Boolean;
begin
  Result := inherited IsPrint(ReportInfo,ReportedObject,ARect);
  if ReportedObject is TRPPrintCtrl then
    Result := IsPrintCtrl(TRPPrintCtrl(ReportedObject),TRPPrintingInfo(ReportInfo));
end;

function TReportProcessor.FindPrintCtrl(
  const ID: string): TRPPrintItemCtrl;
var
  i,j : integer;
  SimpleBands : TList;
  Band : TRPPrintBand;
begin
  CheckTrue(Report<>nil,'Report is nil');
  SimpleBands := TList.Create;
  try
    Report.GetAllSimpleBands(SimpleBands);
    for i:=0 to SimpleBands.Count-1 do
    begin
      Band := TRPPrintBand(TRPSimpleBand(SimpleBands[i]).ReportObject);
      if Band<>nil then
      begin
        for j:=0 to Band.Items.Count-1 do
        begin
          Result := TRPPrintItemCtrl(Band.Items[j]);
          Assert(Result is TRPPrintItemCtrl);
          if CompareText(Result.ID,ID)=0 then
            Exit;
        end;
      end;
    end;
    Result := nil;
  finally
    SimpleBands.Free;
  end;
end;

procedure TReportProcessor.DoProgress(var ContinuePrint: Boolean);
begin
  inherited;
  if Assigned(OnPrintProgress) then
    OnPrintProgress(Self,ContinuePrint)
  else if RPGlobe<>nil then
    RPGlobe.DoProgress(Self,ContinuePrint);
end;

procedure TReportProcessor.DoAfterPrint;
begin
  inherited;
  if Assigned(AfterPrint) then
    AfterPrint(Self)
  else if RPGlobe<>nil then
    RPGlobe.DoAfterPrint(Self);
end;

procedure TReportProcessor.DoBeforePrint;
begin
  inherited;
  if Assigned(BeforePrint) then
    BeforePrint(Self)
  else if RPGlobe<>nil then
    RPGlobe.DoBeforePrint(Self);
end;

function TReportProcessor.GetTitle: string;
begin
  Result := FTitle;
  if (Result='') and (DesignedReport<>nil) then
    Result := DesignedReport.ReportName;
end;

procedure TReportProcessor.SetupPrinter;
begin
  if (Printer<>nil) and (Printer.CanSetPaperSize) and FixedSize then
    Printer.SetPaperSize(FFixedPaperWidth,FFixedPaperHeight,FFixedOrientation);
end;

procedure TReportProcessor.RestorePrinter;
begin
  if (Printer<>nil) and (Printer.CanSetPaperSize) and FixedSize then
    Printer.RestorePaperSize;
end;

{ TRPGlobe }

constructor TRPGlobe.Create(AOwner: TComponent);
begin
  inherited;
  if RPGlobe=nil then
    RPGlobe:=Self;
  DefaultProgress := True;
end;

destructor TRPGlobe.Destroy;
begin
  if RPGlobe=Self then
    RPGlobe:=nil;
  inherited;
end;

procedure TRPGlobe.DoAfterPrint(Processor: TReportProcessor);
begin
  if DefaultProgress then
    ClosePrintProgress;
  if Assigned(AfterPrint) then
    AfterPrint(Processor);
end;

procedure TRPGlobe.DoBeforePrint(Processor: TReportProcessor);
begin
  if Assigned(BeforePrint) then
    BeforePrint(Processor);
  if DefaultProgress then
    ShowPrintProgress(Processor);
end;

procedure TRPGlobe.DoProgress(Processor : TReportProcessor; var ContinuePrint: Boolean);
begin
  if Assigned(OnPrintProgress) then
    OnPrintProgress(Processor,ContinuePrint)
  else if DefaultProgress then
    UpdatePrintProgress(ContinuePrint);
end;

end.
