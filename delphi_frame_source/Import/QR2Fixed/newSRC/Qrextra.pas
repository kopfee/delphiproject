{ :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: QuickReport 2.0 for Delphi 1.0/2.0/3.0                  ::
  ::                                                         ::
  :: QREXTRA.PAS -  Additional QuickReport classes           ::
  ::                                                         ::
  :: Copyright (c) 1997 QuSoft AS                            ::
  :: All Rights Reserved                                     ::
  ::                                                         ::
  :: web: http://www.qusoft.no    mail: support@qusoft.no    ::
  ::                              fax: +47 22 41 74 91       ::
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: }

{$define proversion}

unit qrextra;

interface

{$R-}
{$T-} { We don't need (nor want) this type checking! }
{$B-} { QuickReport source assumes boolean expression short-circuit  }

{$ifdef win32}
uses windows, sysutils, classes, controls, stdctrls, extctrls,graphics, buttons,
     forms, dialogs, printers, db, clipbrd, qrprntr, quickrpt, qrctrls, qrexpbld
     ;
{$else}
uses wintypes, winprocs, sysutils, classes, controls, stdctrls, extctrls, graphics,
     buttons, forms, dialogs, printers, db, clipbrd, qrprntr, quickrpt, qrctrls,
     QRExpbld ;
{$endif}

type
  { Forward declarations }
{$ifdef proversion}
  TQREditor = class;
{$endif}

  { TQRAsciiExportFilter }
  TQRAsciiExportFilter = class(TQRExportFilter)
  private
    LineCount : integer;
    Lines : array[0..200] of string;
    aFile : text;
    XFactor,
    YFactor : extended;
  protected
    function GetFilterName : string; override;
    function GetDescription : string; override;
    function GetExtension : string; override;
  public
    procedure Start(PaperWidth, PaperHeight : integer; Font : TFont); override;
    procedure EndPage; override;
    procedure Finish; override;
    procedure NewPage; override;
    procedure TextOut(X,Y : extended; Font : TFont; BGColor : TColor; Alignment : TAlignment; Text : string); override;
  end;

  { TQRBuilder - base report builder class }
  TQRBuilder = class(TComponent)
  private
    FActive : boolean;
    FFont : TFont;
    FOrientation : TPrinterOrientation;
    FReport : TQuickRep;
    FTitle : string;
    NameList : TStrings;
  protected
    function NewName(AClassName : string) : string;
    procedure BuildFramework; virtual;
    procedure RenameObjects;
    procedure SetActive(Value : boolean); virtual;
    procedure SetOrientation(Value : TPrinterOrientation); virtual;
    procedure SetTitle(Value : string); virtual;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function FetchReport : TQuickRep;
    property Active : boolean read FActive write SetActive;
    property Font : TFont read FFont write FFont;
    property Orientation : TPrinterOrientation read FOrientation write SetOrientation;
    property Report : TQuickRep read FReport write FReport;
    property Title : string read FTitle write SetTitle;
  published
  end;

  { TQRListBuilder - Simple list report builder class }
  TQRListBuilder = class(TQRBuilder)
  private
    FDataSet : TDataSet;
    FFields : TStrings;
    procedure SetFields(Value : TStrings);
  protected
    procedure SetActive(Value : boolean); override;
    procedure BuildList; virtual;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure AddAllFields;
    property DataSet : TDataSet read FDataSet write FDataSet;
    property Fields : TStrings read FFields write SetFields;
  end;

{$ifdef proversion}
  { TQREditor - Report editor component }
  TQREditor = class(TCustomControl)
  private
    FDesigner : TQRDesigner;
    FToolbar : TPanel;
    EditorToolbar : TQRToolbar;
    QuickRepToolbar : TQRToolbar;
    CustomBandToolbar : TQRToolbar;
    CustomLabelToolbar : TQRToolbar;
    ExprToolbar : TQRToolbar;
    ShapeToolbar : TQRToolbar;
    FEditPanel : TPanel;
    FEditArea : TScrollBox;
    FFilename : string;
    FOnNewReport : TNotifyEvent;
    FOnOpenReport : TNotifyEvent;
    FOnCloseReport : TNotifyEvent;
    FOnSaveReport : TNotifyEvent;
    FReport : TQuickRep;
    FStatusBar : TPanel;
    HiddenForm : TForm;
    procedure InitButtons;
    procedure SetReport(Value : TQuickRep);
  protected
    function GetEditing : boolean;
    procedure ClickButton(Sender : TObject); virtual;
    procedure SetSelectedComponent(Sender : TObject); virtual;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure CloseReport;
    procedure DataSetup;
    procedure ReportLayout;
    procedure NewReport;
    procedure OpenReport;
    procedure OpenReportFile(aFilename : string);
    procedure SaveReport;
    procedure SaveReportFile(aFilename : string);
    property Designer : TQRDesigner read FDesigner;
    property EditArea : TScrollBox read FEditArea;
    property Editing : boolean read GetEditing;
    property Filename : string read FFilename write FFilename;
    property Report : TQuickRep read FReport write SetReport;
    property StatusBar : TPanel read FStatusBar;
    property ToolBar : TPanel read FToolBar;
  published
    property Align;
    property OnNewReport : TNotifyEvent read FOnNewReport write FOnNewReport;
    property OnOpenReport : TNotifyEvent read FOnOpenReport write FOnOpenReport;
    property OnCloseReport : TNotifyEvent read FOnCloseReport write FOnCloseReport;
    property OnSaveReport : TNotifyEvent read FOnSaveReport write FOnSaveReport;
  end;
{$endif}

  { Report builder procedures }

  procedure QRCreateList(var AReport : TQuickRep; AOwner : TComponent;
                         aDataSet : TDataSet; aTitle : string; aFieldList : TStrings);

  function AllDataSets(Form : TForm; IncludeDataModules : boolean) : TStrings;
  procedure PopulateFontSizeCombo(aCombo : TComboBox);

{$ifdef proversion}
function QRLoadReport(Filename : string) : TQuickRep;

procedure QRFreeReport(aReport : TQuickRep);
{$endif}

implementation

uses QR2Const;

{var
  QRToolbarLibrary : TQRLibrary;}

const
  cqrToolBarHeight = 90;
  cqrStatusBarHeight = 20;

  cQRFontSizeCount = 16;
  cQRFontSizes : array[1..cQRFontSizeCount] of integer =
      (8, 9, 10, 11, 12, 14, 16, 18, 20, 22, 24, 26, 28, 36, 48, 72);

{ Utility routines }

procedure PopulateFontSizeCombo(aCombo : TComboBox);
var
  I : integer;
begin
  aCombo.Items.Clear;
  for I := 1 to cQRFontSizeCount do
    aCombo.Items.Add(IntToStr(cQRFontSizes[I]));
end;

function AllDataSets(Form : TForm; IncludeDataModules : boolean) : TStrings;
var
  J : integer;

  procedure AddForm(Form : TForm);
  var
    I : integer;
  begin
    for I:=0 to Form.ComponentCount - 1 do
      if Form.Components[I] is TDataSet then
        Result.AddObject(TDataSet(Form.Components[I]).Name, Form.Components[I]);
  end;
{$ifdef win32}
  procedure AddDM(DM : TDataModule);
  var
    I : integer;
  begin
    for I:=0 to DM.ComponentCount - 1 do
      if DM.Components[I] is TDataSet then
        Result.AddObject(TDataSet(DM.Components[I]).Name, DM.Components[I]);
  end;
{$endif}

begin
  Result := TStringList.Create;
  if Form <> nil then
    AddForm(Form);
{$ifdef win32}
  if IncludeDataModules then
    for J := 0 to Screen.DataModuleCount - 1 do
      AddDM(Screen.DataModules[J]);
{$endif}
end;

function dup(aChar : Char; Count : integer) : string;
var
  I : integer;
begin
  result := '';
  for I := 1 to Count do result := result + aChar;
end;

{$ifdef proversion}

function QRLoadReport(Filename : string) : TQuickRep;
{ a QRLoadReport'ed report should always be freed with QRFreeReport }
var
  aForm : TForm;
begin
  result := nil;
  try
    aForm := TForm.Create(Application);
    ReadComponentResFile(Filename, aForm);
    if (aForm.ComponentCount > 0) and (aForm.Components[0] is TQuickRep) then
      result := TQuickRep(aForm.Components[0]);
  except
    ShowMessage(LoadStr(SqrErrorLoading));
  end;
end;

procedure QRFreeReport(aReport : TQuickRep);
begin
  aReport.Owner.Free;
end;

{$endif}

{ TQRAsciiExportFilter }

function TQRAsciiExportFilter.GetDescription : string;
begin
  result := LoadStr(SqrAsciiFilterDescription);
end;

function TQRAsciiExportFilter.GetFilterName : string;
begin
  result := LoadStr(SqrAsciiFilterName);
end;

function TQRAsciiExportFilter.GetExtension : string;
begin
  result := LoadStr(SQrAsciiFilterExtension);
end;

procedure TQRAsciiExportFilter.Start(PaperWidth, PaperHeight : integer; Font : TFont);
begin
  AssignFile(aFile, Filename);
  Rewrite(aFile);
  YFactor := Font.Size * (254 / 72);
  XFactor := Font.Size * (254 / 72);
  LineCount:=round(PaperHeight / YFactor);
end;

procedure TQRAsciiExportFilter.EndPage;
var
  I : integer;
begin
  for I := 0 to LineCount - 1 do
    if length(Lines[I]) > 0 then Writeln(aFile, Lines[I]);
end;

procedure TQRAsciiExportFilter.Finish;
begin
  CloseFile(aFile);
end;

procedure TQRAsciiExportFilter.NewPage;
var
  I : integer;
begin
  for I := 0 to 200 do
    Lines[I] := '';
end;

procedure TQRAsciiExportFilter.TextOut(X, Y : Extended; Font : TFont; BGColor : TColor; Alignment : TAlignment; Text : string);
var
  aLine : string;
begin
  X := X / XFactor * 1.7;
  Y := Y / YFactor;
  if Alignment=taRightJustify then
    X := X - Length(Text);
  aLine := Lines[round(Y)];
  if length(aLine) < X then
    aLine:=aLine+dup(' ', round(X) - length(aLine));
  Delete(aLine, round(X), Length(Text));
  Insert(Text, aLine, round(X));
  Lines[round(Y)] := aLine;
end;

{ TQRBuilder }

type
  TNameCount = class
  public
    Count : integer;
  end;

constructor TQRBuilder.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FActive := false;
  FReport := nil;
  Font := TFont.Create;
  Font.Name := 'Arial'; {<-- do not resource }
  Orientation := poPortrait;
  NameList := TStringList.Create;
end;

destructor TQRBuilder.Destroy;
var
  I : integer;
begin
  FFont.Free;
  Active := false;
  for I := 0 to NameList.Count - 1 do
    TNameCount(NameList.Objects[I]).Free;
  NameList.Free;
  inherited Destroy;
end;

function TQRBuilder.FetchReport : TQuickRep;
begin
  if Active then
  begin
    Result := Report;
    FReport := nil;
    FActive := false;
  end else
    Result := nil;
end;

function TQRBuilder.NewName(AClassName : string) : string;
var
  Value : integer;
  Index : integer;
begin
  Delete(AClassName, 1, 1);
  Index := NameList.IndexOf(AClassName);
  if Index >= 0 then
  begin
    with TNameCount(NameList.Objects[Index]) do
      Count := Count + 1;
    Value := TNameCount(NameList.Objects[Index]).Count;
  end else
  begin
    NameList.Add(AClassName);
    Index := NameList.Count - 1;
    NameList.Objects[Index] := TNameCount.Create;
    TNameCount(NameList.Objects[Index]).Count := 1;
    Value := 1;
  end;
  Result := AClassName + IntToStr(Value);
end;

procedure TQRBuilder.RenameObjects;
var
  I : integer;
  aName : string;
begin
  for I := 0 to Report.Owner.ComponentCount - 1 do
  begin
    aName := Report.Owner.Components[I].Name;
    if aName = '' then
    begin
      aName := Report.Owner.Components[I].ClassName;
      Delete(aName, 1, 1);
      Report.Owner.Components[I].Name := UniqueName(Report.Owner, aName);
    end;
  end;
end;

procedure TQRBuilder.SetOrientation(Value : TPrinterOrientation);
begin
  FOrientation := Value;
  if Active then
    Report.Page.Orientation := Orientation;
end;

procedure TQRBuilder.SetTitle(Value : string);
begin
  FTitle := Value;
  if Active then
    Report.ReportTitle := Title;
end;

procedure TQRBuilder.BuildFramework;
var
  HadBand : boolean;
begin
  if FReport = nil then
  begin
    FReport := TQuickRep.Create(Owner);
    FReport.Parent := TWinControl(Owner);
    with Report do
    begin
      Visible := false;
      Page.Orientation := Orientation;
      Font := Self.Font;
      if Title <> '' then
      begin
        if not Bands.HasTitle then
          Bands.HasTitle := true;
        with TQRLabel(Bands.TitleBand.AddPrintable(TQRLabel)) do
        begin
          AutoSize := true;
          Alignment := taCenter;
          AlignToBand := True;
          Font.Name := 'Arial'; {<-- do not resource }
          Font.Size := 14;
          Font.Style := [fsBold];
          Caption := Title;
        end;
      end;
      if not Bands.HasPageFooter then
      begin
        Bands.HasPageFooter := true;
        HadBand := false;
      end else
        HadBand := true;
      with TQRSysData(Bands.PageFooterBand.AddPrintable(TQRSysData)) do
      begin
        Alignment := taRightJustify;
        AlignToBand := true;
        Data := qrsPageNumber;
        Text := LoadStr(SqrPage) + ' ';
        if not HadBand then
          Bands.PageFooterBand.Height := round(Height * 1.5);
      end
    end
  end
end;

procedure TQRBuilder.SetActive(Value : boolean);
begin
  if Value <> FActive then
  begin
    if Value then
      BuildFramework
    else
      FReport.Free;
    FActive := Value;
  end;
end;

{ TQRListBuilder }

constructor TQRListBuilder.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FFields := TStringList.Create;
end;

destructor TQRListBuilder.Destroy;
begin
  FFields.Free;
  inherited Destroy;
end;

procedure TQRListBuilder.SetActive;
begin
  if Value <> Active then
  begin
    if Value and assigned(FDataSet) then
    begin
      inherited SetActive(true);
      BuildList;
    end else
      inherited SetActive(false);
  end;
end;

procedure TQRListBuilder.SetFields(Value : TStrings);
begin
  FFields.Assign(Value);
end;

procedure TQRListBuilder.BuildList;
var
  I : integer;
  aField : TField;
  aExpr : TQRExpr;
  aLabel : TQRLabel;
  aHeight : integer;
  HadDetail : boolean;
  HadColHead : boolean;

  procedure AddField(AField : TField);
  begin
    if (pos(' ', AField.FieldName) = 0) and
       (pos('/', AField.FieldName) = 0) and
       (pos('\', AField.FieldName) = 0) and
       (pos('&', AField.FieldName) = 0) and
       (pos('%', AField.FieldName) = 0) and
       (pos('-', AField.FieldName) = 0) then
    begin
      aLabel := TQRLabel(Report.Bands.ColumnHeaderBand.AddPrintable(TQRLabel));
      aHeight := aLabel.Height;
      aLabel.AutoSize := true;
      aLabel.Caption := Dup('X', aField.DisplayWidth);
      aLabel.AutoSize := false;
  {$ifdef win32}
      aLabel.Caption := aField.DisplayName;
  {$else}
      aLabel.Caption:=aField.DisplayLabel;
  {$endif}
      aLabel.Frame.DrawBottom := true;
      aExpr := TQRExpr(Report.Bands.DetailBand.AddPrintable(TQRExpr));
      aExpr.AutoSize := false;
      aExpr.Expression := '[' + AField.FieldName + ']';
      aExpr.Left := aLabel.Left;
      aExpr.Width := aLabel.Width;
      aExpr.Alignment := aField.Alignment;
      if (aExpr.Left + aExpr.Width > Report.Bands.DetailBand.Width) and
        (Orientation = poPortrait) then
        Orientation := poLandscape;
      if aExpr.Left + aExpr.Width > Report.Bands.DetailBand.Width then
      begin
        aLabel.Free;
        aExpr.Free;
      end;
    end;
  end;

begin
  HadDetail := Report.Bands.HasDetail;
  HadColHead := Report.Bands.HasColumnHeader;
  if not HadColHead then Report.Bands.HasColumnHeader := true;
  if not HadDetail then Report.Bands.HasDetail := true;
  aHeight := round(Report.Bands.DetailBand.Height / 1.5);
  Report.DataSet := DataSet;
  if DataSet <> nil then
  begin
    if FFields.Count > 0 then
    begin
      for I := 0 to FFields.Count-1 do
      begin
        AField := DataSet.FieldByName(FFields[I]);
        if AField <> nil then
          AddField(AField);
      end;
    end else
    begin
      for I := 0 to DataSet.FieldCount - 1 do
      begin
        AField := DataSet.Fields[I];
        if aField.Visible then AddField(AField);
      end
    end
  end;
  if not HadDetail then Report.Bands.DetailBand.Height := round(aHeight*1.5);
  if not HadColHead then Report.Bands.ColumnHeaderBand.Height := round(aHeight*1.5);
  RenameObjects;
end;

procedure TQRListBuilder.AddAllFields;
var
  I : integer;
begin
  FFields.Clear;
  for I := 0 to DataSet.FieldCount - 1 do
    FFields.Add(DataSet.Fields[I].Name);
end;

procedure QRCreateList(var AReport : TQuickRep; AOwner : TComponent;
                       aDataSet : TDataSet; ATitle : string; aFieldList : TStrings);
begin
  with TQRListBuilder.Create(AOwner) do
  try
    DataSet := aDataSet;
    Title := aTitle;
    Report := aReport;
    if aFieldList <> nil then
      Fields := aFieldList;
    Active := true;
    if Active then AReport := FetchReport;
  finally
    free;
  end;
end;

{$ifdef proversion}
{ TQREditorToolbar }

type
  TQREditorToolbar = class(TQRToolbar)
  protected
    New : TSpeedButton;
    Open : TSpeedButton;
    Preview : TSpeedButton;
    Print : TSpeedButton;
    PrintSetup : TSpeedButton;
    Save : TSpeedButton;
    Copy : TSpeedButton;
    Paste : TSpeedButton;
    NewField : TSpeedButton;
    NewShape : TSpeedButton;
    NewImage : TSpeedButton;
    FitInWindow : TSpeedButton;
    FitInWidth : TSpeedButton;
    FullSize : TSpeedButton;
    Options : TSpeedButton;
    DataSetup : TSpeedButton;
  public
    constructor Create(AOwner : TComponent); override;
    procedure SetButtons(State : boolean);
    procedure NewClick(Sender : TObject);
    procedure OpenClick(Sender : TObject);
    procedure PreviewClick(Sender : TObject);
    procedure PrintClick(Sender : TObject);
    procedure PrintSetupClick(Sender : TObject);
    procedure SaveClick(Sender : TObject);
    procedure CopyClick(Sender : TObject);
    procedure PasteClick(Sender : TObject);
    procedure NewFieldClick(Sender : TObject);
    procedure NewShapeClick(Sender : TObject);
    procedure NewImageClick(Sender : TObject);
    procedure ClickFitInWindow(Sender : TObject);
    procedure ClickFitInWidth(Sender : TObject);
    procedure ClickFullSize(Sender : TObject);
    procedure OptionsClick(Sender : TObject);
    procedure DataClick(Sender : TObject);
  end;

constructor TQREditorToolbar.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  New := AddButton('', 'QRNEWBITMAP', LoadStr(SqrNewReport), 0, NewClick);
  Open := AddButton('', 'QROPENBITMAP', LoadStr(SqrLoadReport), 0, OpenClick);
  Save := AddButton('', 'QRSAVEBITMAP', LoadStr(SqrSaveReport), 0, SaveClick);
  AddSpace;
  Preview := AddButton('', 'QRPREVBITMAP', LoadStr(SqrPreview), 0, PreviewClick);
  Print := AddButton('', 'QRPRINTBITMAP', LoadStr(SqrPrint), 0, PrintClick);
  PrintSetup := AddButton('', 'QRPRINTSETUPBITMAP', LoadStr(SqrPrinterSetup), 0, PrintSetupClick);
  AddSpace;
{  Copy := AddButton('', 'QRCOPYBITMAP', LoadStr(SqrCopy), 0, CopyClick);
  Paste := AddButton('', 'QRPASTEBITMAP', LoadStr(SqrPaste), 0, PasteClick);
  AddSpace;}
  NewField := AddButton('', 'QRINSFIELDBITMAP', '', 0, NewFieldClick);
  NewShape := AddButton('', 'QRINSSHAPEBITMAP', '', 0, NewShapeClick);
  {NewImage := AddButton('', 'QRINSPICTBITMAP', '', 0, NewImageClick);}
  AddSpace;
  FitInWindow := AddButton('', 'QRZOOMTOFITBITMAP', '', 1, ClickFitInWindow);
  FitInWidth := AddButton('', 'QRZOOMTOWIDTHBITMAP', '', 1, ClickFitInWidth);
  FullSize := AddButton('', 'QRZOOMTO100BITMAP', '', 1, ClickFullSize);
  AddSpace;
  Options := AddButton(LoadStr(SqrLayout), '', '', 0, OptionsClick);
  Options.Width := 50;
  CurrentX := CurrentX+26;
  AddSpace;
  DataSetup := AddButton(LoadStr(SqrData), '', '', 0, DataClick);
  DataSetup.Width := 50;
  SetButtons(false);
end;

procedure TQREditorToolbar.SetButtons(State : boolean);
var
  CompOK : boolean;
begin
  CompOK := State;
  New.Enabled := not CompOK;
  Save.Enabled := CompOK;
  Preview.Enabled := CompOK;
  Print.Enabled := CompOK;
  PrintSetup.Enabled := CompOK;
  {Copy.Enabled := CompOK;
  Paste.Enabled := CompOK;}
  NewField.Enabled := CompOK;
  NewShape.Enabled := CompOK;
  {NewImage.Enabled := CompOK;}
  FitInWindow.Enabled := CompOK;
  FitInWidth.Enabled := CompOK;
  FullSize.Enabled := CompOK;
  Options.Enabled := CompOK;
  DataSetup.Enabled := CompOK;
end;

procedure TQREditorToolbar.NewFieldClick(Sender : TObject);
begin
  TQREditor(Component).Designer.AddComponent(TQRExpr);
end;

procedure TQREditorToolbar.NewShapeClick(Sender : TObject);
begin
  TQREditor(Component).Designer.AddComponent(TQRShape);
end;

procedure TQREditorToolbar.NewImageClick(Sender : TObject);
begin
  TQREditor(Component).Designer.AddComponent(TQRImage);
end;

procedure TQREditorToolbar.ClickFitInWindow(Sender : TObject);
var
  Zoom1,
  Zoom2 : integer;
begin
  TQREditor(Component).Report.Zoom:=100;
  Zoom1:=round(TQREditor(Component).Width/TQREditor(Component).Report.Width*95);
  Zoom2:=round(TQREditor(Component).FEditPanel.Height/TQREditor(Component).Report.Height*95);
  if Zoom1<Zoom2 then
    TQREditor(Component).Report.Zoom:=Zoom1
  else
    TQREditor(Component).Report.Zoom:=Zoom2;
  FitInWindow.Down:=true;
end;

procedure TQREditorToolbar.ClickFitInWidth(Sender : TObject);
begin
  TQREditor(Component).Report.Zoom:=100;
  TQREditor(Component).Report.Zoom:=round(TQREditor(Component).Width/TQREditor(Component).Report.Width*95);
  FitInWidth.Down:=true;
end;

procedure TQREditorToolbar.ClickFullSize(Sender : TObject);
begin
  TQREditor(Component).Report.Zoom:=100;
  FullSize.Down:=true;
end;

procedure TQREditorToolbar.NewClick(Sender : TObject);
begin
  TQREditor(Component).NewReport;
  SetButtons(true);
end;

procedure TQREditorToolbar.OpenClick(Sender : TObject);
begin
  TQREditor(Component).OpenReport;
  SetButtons(true);
end;

procedure TQREditorToolbar.PreviewClick(Sender : TObject);
begin
  TQREditor(Component).Report.Preview;
end;

procedure TQREditorToolbar.PrintClick(Sender : TObject);
begin
  TQREditor(Component).Report.Print;
end;

procedure TQREditorToolbar.PrintSetupClick(Sender : TObject);
begin
  TQREditor(Component).Report.PrinterSetup;
end;

procedure TQREditorToolbar.CopyClick(Sender : TObject);
begin
  if TQREditor(Component).Designer.EditControl is TQRPrintable then
    ClipBoard.SetComponent(TQREditor(Component).Designer.EditControl);
  Paste.Enabled:=true;
end;

procedure TQREditorToolbar.PasteClick(Sender : TObject);
begin
  if TQREditor(Component).Designer.EditControl is TQRCustomBand then
    ClipBoard.GetComponent(TQREditor(Component).Report,TQREditor(Component).Designer.EditControl);
end;

procedure TQREditorToolbar.SaveClick(Sender : TObject);
begin
  TQREditor(Component).SaveReport;
end;

procedure TQREditorToolbar.OptionsClick(Sender : TObject);
begin
  TQREditor(Component).ReportLayout;
end;

procedure TQREditorToolbar.DataClick(Sender : TObject);
begin
  TQREditor(Component).DataSetup;
end;

{ TQuickRepToolbar }

type
  TQuickRepToolbar = class(TQRToolbar)
  private
    PageHeader : TCheckBox;
    Title : TCheckBox;
    ColumnHeader : TCheckBox;
    Detail : TCheckBox;
    Summary : TCheckBox;
    PageFooter : TCheckBox;
  protected
    procedure SetComponent(Value : TComponent); override;
  public
    constructor Create(AOwner : TComponent); override;
    procedure PageHeaderClick(Sender : TObject);
    procedure TitleClick(Sender : TObject);
    procedure ColumnHeaderClick(Sender : TObject);
    procedure DetailClick(Sender : TObject);
    procedure SummaryClick(Sender : TObject);
    procedure PageFooterClick(Sender : TObject);
  end;

constructor TQuickRepToolbar.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  PageHeader := AddCheckBox(LoadStr(SqrPgHeader), QRBandTypeName(rbPageHeader), PageHeaderClick);
  Title := AddCheckBox(LoadStr(SqrTitle), QRBandTypeName(rbTitle), TitleClick);
  ColumnHeader := AddCheckBox(LoadStr(SqrColHdr), QRBandTypeName(rbColumnHeader), ColumnHeaderClick);
  Detail := AddCheckBox(LoadStr(SqrDetail), QRBandTypeName(rbDetail), DetailClick);
  Summary := AddCheckBox(LoadStr(SqrSummary), QRBandTypeName(rbSummary), SummaryClick);
  PageFooter := AddCheckBox(LoadStr(SqrPgFooter), QRBandTypeName(rbPageFooter),PageFooterClick);
end;

procedure TQuickRepToolbar.SetComponent(Value : TComponent);
begin
  inherited SetComponent(Value);
  if Value<>nil then
  begin
    PageHeader.Checked := TQuickRep(Component).Bands.HasPageHeader;
    Title.Checked := TQuickRep(Component).Bands.HasTitle;
    ColumnHeader.Checked := TQuickRep(Component).Bands.HasColumnHeader;
    Detail.Checked := TQuickRep(Component).Bands.HasDetail;
    Summary.Checked := TQuickRep(Component).Bands.HasSummary;
    PageFooter.Checked := TQuickRep(Component).Bands.HasPageFooter;
  end;
  EndSetComponent;
end;

procedure TQuickRepToolbar.PageHeaderClick(Sender : TObject);
begin
  if CBClickOK then
  begin
    TQuickRep(Component).Bands.HasPageHeader := not TQuickRep(Component).Bands.HasPageHeader;
    PageHeader.Checked := TQuickRep(Component).Bands.HasPageHeader;
  end
end;

procedure TQuickRepToolbar.TitleClick(Sender : TObject);
begin
  if CBClickOK then
  begin
    TQuickRep(Component).Bands.HasTitle := not TQuickRep(Component).Bands.HasTitle;
    Title.Checked := TQuickRep(Component).Bands.HasTitle;
  end;
end;

procedure TQuickRepToolbar.ColumnHeaderClick(Sender : TObject);
begin
  if CBClickOK then
  begin
    TQuickRep(Component).Bands.HasColumnHeader := not TQuickRep(Component).Bands.HasColumnHeader;
    ColumnHeader.Checked := TQuickRep(Component).Bands.HasColumnHeader;
  end
end;

procedure TQuickRepToolbar.DetailClick(Sender : TObject);
begin
  if CBClickOK then
  begin
    TQuickRep(Component).Bands.HasDetail := not TQuickRep(Component).Bands.HasDetail;
    Detail.Checked := TQuickRep(Component).Bands.HasDetail;
  end
end;

procedure TQuickRepToolbar.SummaryClick(Sender : TObject);
begin
  if CBClickOK then
  begin
    TQuickRep(Component).Bands.HasSummary := not TQuickRep(Component).Bands.HasSummary;
    Summary.Checked := TQuickRep(Component).Bands.HasSummary;
  end
end;

procedure TQuickRepToolbar.PageFooterClick(Sender : TObject);
begin
  if CBClickOK then
  begin
    TQuickRep(Component).Bands.HasPageFooter := not TQuickRep(Component).Bands.HasPageFooter;
    PageFooter.Checked := TQuickRep(Component).Bands.HasPageFooter;
  end
end;

{ TQRCustomBandToolbar }

type
  TQRCustomBandToolbar = class (TQRToolbar)
  private
    FrameLeft : TSpeedButton;
    FrameTop : TSpeedButton;
    FrameBottom : TSpeedButton;
    FrameRight : TSpeedButton;
    HasChild : TCheckBox;
    Info : TLabel;
  protected
    procedure FrameLeftClick(Sender : TObject);
    procedure FrameTopClick(Sender : TObject);
    procedure FrameRightClick(Sender : TObject);
    procedure FrameBottomClick(Sender : TObject);
    procedure HasChildClick(Sender : TObject);
    procedure SetComponent(Value : TComponent); override;
  public
    constructor Create(AOwner : TComponent); override;
  end;

constructor TQRCustomBandToolbar.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  AddSpace;
  Info := TLabel.Create(Self);
  with Info do
  begin
    Parent := Self;
    Font.Name := 'Arial';
    Font.Size := 10;
    AutoSize := false;
    Width := 90;
    Left := CurrentX;
    Top := (Self.Height-Height) div 2;
  end;
  CurrentX := 100;
  FrameLeft := AddButton('', 'QRFRAMELEFTBITMAP', LoadStr(SqrLeftFrame), 1, FrameLeftClick);
  FrameTop := AddButton('', 'QRFRAMETOPBITMAP', LoadStr(SqrTopFrame), 2, FrameTopClick);
  FrameBottom := AddButton('', 'QRFRAMEBTMBITMAP', LoadStr(SqrBottomFrame), 3, FrameBottomClick);
  FrameRight := AddButton('', 'QRFRAMERIGHTBITMAP', LoadStr(SqrRightFrame), 4, FrameRightClick);
  AddSpace;
  HasChild := AddCheckBox(LoadStr(SqrChildBand), '', HasChildClick);
end;

procedure TQRCustomBandToolbar.SetComponent(Value : TComponent);
begin
  inherited SetComponent(Value);
  if Value<>nil then
  begin
    Info.Caption := QRBandTypeName(TQRCustomBand(Value).BandType);
    FrameLeft.Down := TQRCustomBand(Component).Frame.DrawLeft;
    FrameTop.Down := TQRCustomBand(Component).Frame.DrawTop;
    FrameBottom.Down := TQRCustomBand(Component).Frame.DrawBottom;
    FrameRight.Down := TQRCustomBand(Component).Frame.DrawRight;
    HasChild.Checked := TQRCustomBand(Component).HasChild;
  end;
  EndSetComponent;
end;

procedure TQRCustomBandToolbar.FrameLeftClick(Sender : TObject);
begin
  TQRCustomBand(Component).Frame.DrawLeft := not TQRCustomBand(Component).Frame.DrawLeft;
  FrameLeft.Down := TQRCustomBand(Component).Frame.DrawLeft;
end;

procedure TQRCustomBandToolbar.FrameTopClick(Sender : TObject);
begin
  TQRCustomBand(Component).Frame.DrawTop := not TQRCustomBand(Component).Frame.DrawTop;
  FrameTop.Down := TQRCustomBand(Component).Frame.DrawTop;
end;

procedure TQRCustomBandToolbar.FrameBottomClick(Sender : TObject);
begin
  TQRCustomBand(Component).Frame.DrawBottom := not TQRCustomBand(Component).Frame.DrawBottom;
  FrameBottom.Down := TQRCustomBand(Component).Frame.DrawBottom;
end;

procedure TQRCustomBandToolbar.FrameRightClick(Sender : TObject);
begin
  TQRCustomBand(Component).Frame.DrawRight := not TQRCustomBand(Component).Frame.DrawRight;
  FrameRight.Down := TQRCustomBand(Component).Frame.DrawRight;
end;

procedure TQRCustomBandToolbar.HasChildClick(Sender : TObject);
begin
  if CBClickOK then
  begin
    TQRCustomBand(Component).HasChild := not TQRCustomBand(Component).HasChild;
    HasChild.Checked := TQRCustomBand(Component).HasChild;
  end;
end;

{ TQRCustomLabelToolbar - toolbar for TQRCustomLabel component }
type
  TQRCustomLabelToolbar = class(TQRToolbar)
  private
    AlignCenter : TSpeedButton;
    AlignLeft : TSpeedButton;
    AlignRight : TSpeedButton;
    BkColor : TSpeedButton;
    Bold : TSpeedButton;
    FontColor : TSpeedButton;
    FontName : TComboBox;
    FontSize : TComboBox;
    FontSizeList : TStrings;
    FrameLeft : TSpeedButton;
    FrameRight : TSpeedButton;
    FrameTop : TSpeedButton;
    FrameBottom : TSpeedButton;
    Italic : TSpeedButton;
    UnderLn : TSpeedButton;
    AutoSizeButton : TSpeedButton;
  protected
    procedure AlignClick(Sender : TObject);
    procedure BoldClick(Sender : TObject);
    procedure BkColorClick(Sender : TObject);
    procedure FontColorClick(Sender : TObject);
    procedure FontNameDropDown(Sender : TObject);
    procedure FontNameExit(Sender : TObject);
    procedure FontNameKeyPress(Sender: TObject; var Key: Char);
    procedure FontSizeExit(Sender : TObject);
    procedure FontSizeKeyPress(Sender: TObject; var Key: Char);
    procedure FrameClick(Sender : TObject);
    procedure ItalicClick(Sender : TObject);
    procedure UnderlnClick(Sender : TObject);
    procedure AutoSizeClick(Sender : TObject);
    procedure SetComponent(Value : TComponent); override;
    procedure SetParent(AParent : TWinControl); override;
  public
    constructor Create(AOwner : TComponent); override;
  published
  end;

constructor TQRCustomLabelToolbar.Create(AOwner : TComponent);
var
  I : integer;
begin
  inherited Create(AOwner);
  FontName := TComboBox.Create(Self);
  with FontName do
  begin
    Parent := self;
    Top := cQRToolbarMargin;
    Left := cQRToolbarMargin;
    Width := 130;
    OnKeyPress := FontNameKeyPress;
    OnExit := FontNameExit;
    OnClick := FontNameExit;
    OnDropDown := FontNameDropDown;
    Sorted := true;
  end;
  CurrentX := 130;
  AddSpace;

  FontSize := TComboBox.Create(Self);
  with FontSize do
  begin
    Parent := Self;
    Top := cQRToolbarMargin;
    Left := CurrentX;
    Width := 50;
    CurrentX := CurrentX + 50;
    OnKeyPress := FontSizeKeyPress;
    OnExit := FontSizeExit;
    OnClick := FontSizeExit;
  end;
  AddSpace;
  FontSizeList := TStringList.Create;
  for I := 1 to cQRFontSizeCount do
    FontSizeList.Add(IntToStr(cQRFontSizes[I]));
  Bold := AddButton('', 'QRBOLDBITMAP', LoadStr(SqrBold), 2, BoldClick);
  Italic := AddButton('', 'QRITALICBITMAP', LoadStr(SqrItalic), 3, ItalicClick);
  UnderLn := AddButton('', 'QRULINEBITMAP', LoadStr(SqrUnderline), 4, UnderLnClick);
  AddSpace;
  AlignLeft := AddButton('', 'QRALLEFTBITMAP', LoadStr(SqrLeftAlign), 1, AlignClick);
  AlignCenter := AddButton('', 'QRALCENTERBITMAP', LoadStr(SqrCenter), 1, AlignClick);
  AlignRight := AddButton('', 'QRALRIGHTBITMAP', LoadStr(SqrRightAlign), 1, AlignClick);
  AddSpace;
  FontColor := AddButton('', 'QRFONTCOLORBITMAP', LoadStr(SqrFontColor), 0, FontColorClick);
  BkColor := AddButton('', 'QRBKCOLORBITMAP', LoadStr(SqrBackgroundColor), 0, BkColorClick);
  AddSpace;
  FrameLeft := AddButton('', 'QRFRAMELEFTBITMAP', LoadStr(SqrLeftFrame), 5, FrameClick);
  FrameTop := AddButton('', 'QRFRAMETOPBITMAP', LoadStr(SqrTopFrame), 6, FrameClick);
  FrameBottom := AddButton('', 'QRFRAMEBTMBITMAP', LoadSTr(SqrBottomFrame), 7, FrameClick);
  FrameRight := AddButton('' , 'QRFRAMERIGHTBITMAP', LoadStr(SqrRightFrame), 8, FrameClick);
  AddSpace;
  AutoSizeButton := AddButton('', 'QRAUTOSIZEBITMAP', 'Autosize', 9, AutoSizeClick);
end;

procedure TQRCustomLabelToolbar.SetComponent(Value : TComponent);
begin
  inherited SetComponent(Value);
  if Value<>nil then
    with TQRCustomLabel(Value) do
    begin
      FontName.Text := Font.Name;
      FontSize.Text := IntToStr(Font.Size);
      Bold.Down := fsBold in Font.Style;
      Italic.Down := fsItalic in Font.Style;
      Underln.Down := fsUnderline in Font.Style;
      FrameLeft.Down := Frame.DrawLeft;
      FrameTop.Down := Frame.DrawTop;
      FrameBottom.Down := Frame.DrawBottom;
      FrameRight.Down := Frame.DrawRight;
      AlignLeft.Down := Alignment=taLeftJustify;
      AlignCenter.Down := Alignment=taCenter;
      AlignRight.Down := Alignment=taRightJustify;
      AutoSizeButton.Down := AutoSize;
    end;
end;

procedure TQRCustomLabelToolbar.SetParent(AParent : TWinControl);
begin
  inherited SetParent(AParent);
  if AParent <> nil then
  begin
  end;
end;

procedure TQRCustomLabelToolbar.BoldClick(Sender : TObject);
begin
  with TQRCustomLabel(Component) do
  begin
    if fsBold in Font.Style then
      Font.Style := Font.Style - [fsBold]
    else
      Font.Style := Font.Style + [fsBold];
    Bold.Down := fsBold in Font.Style;
  end;
end;

procedure TQRCustomLabelToolbar.FontNameKeyPress(Sender : TObject; var Key: Char);
begin
  if Key=#13 then
    FontNameExit(Self);
end;

procedure TQRCustomLabelToolbar.FontNameDropDown(Sender : TObject);
begin
  if FontName.Items.Count = 0 then
    FontName.Items := GetFonts;
end;

procedure TQRCustomLabelToolbar.FontNameExit(Sender : TObject);
begin
  TQRCustomLabel(Component).Font.Name := FontName.Text;
  FontName.Text := TQRCustomLabel(Component).Font.Name;
end;

procedure TQRCustomLabelToolbar.FontSizeKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
    FontSizeExit(Self)
  else
    if not (Key in [#8, '0'..'9']) then
      Key:=#0;
end;

procedure TQRCustomLabelToolbar.FontSizeExit(Sender : TObject);
var
  I, J : integer;
begin
  val(FontSize.Text,I,J);
  if J=0 then
    TQRCustomLabel(Component).Font.Size := I
  else
    Text := IntToStr(TQRCustomLabel(Component).Font.Size);
end;

procedure TQRCustomLabelToolbar.ItalicClick(Sender : TObject);
begin
  with TQRCustomLabel(Component) do
  begin
    if fsItalic in Font.Style then
      Font.Style := Font.Style - [fsItalic]
    else
      Font.Style := Font.Style + [fsItalic];
    Italic.Down := fsItalic in Font.Style;
  end;
end;

procedure TQRCustomLabelToolbar.UnderLnClick(Sender : TObject);
begin
  with TQRCustomLabel(Component) do
  begin
    if fsUnderline in Font.Style then
      Font.Style := Font.Style - [fsUnderline]
    else
      Font.Style := Font.Style + [fsUnderline];
    UnderLn.Down := fsUnderline in Font.Style;
  end;
end;

procedure TQRCustomLabelToolbar.AlignClick(Sender : TObject);
var
  SomeAlign : TAlignment;
begin
  if Sender = AlignLeft then
    SomeAlign := taLeftJustify
  else
    if Sender =AlignCenter then
      SomeAlign := taCenter
    else
      SomeAlign := taRightJustify;
  TQRCustomLabel(Component).Alignment := SomeAlign;
end;

procedure TQRCustomLabelToolbar.AutoSizeClick(Sender : TObject);
begin
  TQRCustomLabel(Component).AutoSize := not TQRCustomLabel(Component).AutoSize;
end;

procedure TQRCustomLabelToolbar.BkColorClick(Sender : TObject);
begin
  with TColorDialog.Create(Self) do
  try
    Color:=TQRCustomLabel(Component).Color;
    if Execute then
      TQRCustomLabel(Component).Color:=Color;
  finally
    Free;
  end;
end;

procedure TQRCustomLabelToolbar.FontColorClick(Sender : TObject);
begin
  with TColorDialog.Create(Self) do
  try
    Color:=TQRCustomLabel(Component).Font.Color;
    if Execute then
      TQRCustomLabel(Component).Font.Color:=Color;
  finally
    Free;
  end;
end;

procedure TQRCustomLabelToolbar.FrameClick(Sender : TObject);
var
  aLabel : TQRCustomLabel;
begin
  aLabel:=TQRCustomLabel(Component);
  if Sender=FrameLeft then
  begin
    aLabel.Frame.DrawLeft:=not aLabel.Frame.DrawLeft;
    FrameLeft.Down:=ALabel.Frame.DrawLeft;
  end else
    if Sender=FrameTop then
    begin
      aLabel.Frame.DrawTop:=not aLabel.Frame.DrawTop;
      FrameTop.Down:=ALabel.Frame.DrawTop;
    end else
      if Sender=FrameBottom then
      begin
        aLabel.Frame.DrawBottom:=not aLabel.Frame.DrawBottom;
        FrameBottom.Down:=aLabel.Frame.DrawBottom;
      end else
        if Sender=FrameRight then
        begin
          aLabel.Frame.DrawRight:=not aLabel.Frame.DrawRight;
          FrameRight.Down:=aLabel.Frame.DrawRight;
        end;
end;

{ TQRShapeToolbar }
type
  TQRShapeToolbar = class(TQRToolbar)
  private
    Rectangle : TSpeedButton;
    Circle : TSpeedButton;
    VertLine : TSpeedButton;
    HorzLine : TSpeedButton;
    TopAndBottom : TSpeedButton;
    RightAndLeft : TSpeedButton;
    PenColor : TSpeedButton;
    BrushColor : TSpeedButton;
  public
    constructor Create(AOwner : TComponent); override;
    procedure ShapeButtonClick(Sender : TObject);
    procedure ColorButtonClick(Sender : TObject);
  end;

{ TQRShapeToolbar }

constructor TQRShapeToolbar.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  Rectangle:=AddButton('','QRRECTANGLEBITMAP',LoadStr(SqrRectangle),1,ShapeButtonClick);
  Circle:=AddButton('','QRCIRCLEBITMAP',LoadStr(SqrCircle),1,ShapeButtonClick);
  VertLine:=AddButton('','QRVERTLINEBITMAP',LoadStr(SqrVertLine),1,ShapeButtonClick);
  HorzLine:=AddButton('','QRHORZLINEBITMAP',LoadStr(SqrHorzLine),1,ShapeButtonClick);
  TopAndBottom:=AddButton('','QRTOPBOTTOMBITMAP',LoadStr(SqrTopBottom),1,ShapeButtonClick);
  RightAndLeft:=AddButton('','QRLEFTRIGHTBITMAP',LoadStr(SqrRightLeft),1,ShapeButtonClick);
  AddSpace;
  PenColor:=AddButton('','QRBKCOLORBITMAP',LoadStr(SqrFrameColor),0,ColorButtonClick);
  BrushColor:=AddButton('','QRBKCOLORBITMAP',LoadStr(SqrBackgroundColor),0,ColorButtonClick);

end;

procedure TQRShapeToolbar.ShapeButtonClick(Sender : TObject);
begin
  with TQRShape(Component) do
    if Sender=Rectangle then
    begin
      Shape:=qrsRectangle;
      Rectangle.Down:=true;
    end else
      if Sender=Circle then
      begin
        Shape:=qrsCircle;
        Circle.Down:=true;
      end else
        if Sender=VertLine then
        begin
          Shape:=qrsVertLine;
          VertLine.Down:=true;
        end else
          if Sender=HorzLine then
          begin
            Shape:=qrsHorLine;
            HorzLine.Down:=true;
          end else
            if Sender=TopAndBottom then
            begin
              Shape:=qrsTopAndBottom;
              TopAndBottom.Down:=true;
            end else
            begin
              Shape:=qrsRightAndLeft;
              RightAndLeft.Down:=true;
            end;
end;

procedure TQRShapeToolbar.ColorButtonClick(Sender : TObject);
begin
end;

{ TQRExprToolbar }
type
  TQRExprToolbar = class(TQRToolbar)
  private
    CancelButton : TSpeedButton;
    Edit : TEdit;
    OKButton : TSpeedButton;
    WizardButton : TSpeedButton;
  protected
    procedure CancelClick(Sender : TObject);
    procedure ExpressionKeyPress(Sender: TObject; var Key: Char);
    procedure OKClick(Sender : TObject);
    procedure SetBounds(ALeft, ATop, AWidth, AHeight : integer); override;
    procedure SetComponent(Value : TComponent); override;
    procedure SetEditWidth;
    procedure WizardClick(Sender : TObject);
  public
    constructor Create(AOwner : TComponent); override;
  end;

constructor TQRExprToolbar.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  OKButton:=AddButton('','QROKBITMAP',LoadStr(SqrOK),0,OKClick);
  CancelButton:=AddButton('','QRCANCELBITMAP',LoadStr(SqrCancel),0,CancelClick);
  WizardButton:=AddButton('','QRFUNCTIONBITMAP',LoadStr(SqrExprWizard),0,WizardClick);
  Edit:=TEdit.Create(Self);
  with Edit do
  begin
    Parent:=Self;
    Left:=CurrentX;
    Top:=cQRToolbarMargin;
    Width:=300;
    OnKeyPress:=ExpressionKeyPress;
  end;
  SetEditWidth;
end;

procedure TQRExprToolbar.SetComponent(Value : TComponent);
begin
  inherited SetComponent(Value);
  if Value<>nil then
  begin
    Edit.Text:=TQRExpr(Value).Expression;
    TQRExpr(Component).Expression:=TQRExpr(Component).Expression;
  end;
end;

procedure TQRExprToolbar.OKClick(Sender : TObject);
begin
  TQRExpr(Component).Expression:=Edit.Text;
end;

procedure TQRExprToolbar.CancelClick(Sender : TObject);
begin
  Edit.Text:=TQRExpr(Component).Expression;
end;

procedure TQRExprToolbar.ExpressionKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
    OKClick(Self);
end;

procedure TQRExprToolbar.SetBounds(ALeft, ATop, AWidth, AHeight : integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  SetEditWidth;
end;

procedure TQRExprToolbar.SetEditWidth;
begin
  if assigned(Edit) then
    Edit.Width:=Width-Edit.Left-cQRToolbarMargin;
end;

procedure TQRExprToolbar.WizardClick(Sender : TObject);
var
  AValue : string;
begin
  AValue:=Edit.Text;
  if GetExpression('', AValue , TForm(TQRExpr(Component).ParentReport.Owner)) then
  begin
    Edit.Text:=AValue;
    OKClick(Self);
  end;
end;

{ TQREditor }

constructor TQREditor.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FDesigner := TQRDesigner.Create(Self);
  FDesigner.OnSelectComponent := SetSelectedComponent;
  Height := 200;
  Width := 250;
  FToolBar := TPanel.Create(Self);
  with FToolBar do
  begin
    Parent := Self;
    Align := alTop;
    Height := cqrToolBarHeight;
    Caption := '';
    ControlStyle := ControlStyle - [csAcceptsControls, csCaptureMouse, csClickEvents];
    BevelInner := bvNone;
    BevelOuter := bvNone;
    Font.Name := 'Arial'; {<-- do not resource }
  end;
  EditorToolbar:=TQREditorToolbar.Create(Self);
  with EditorToolbar do
  begin
    Parent := FToolbar;
    Component := Self;
    Visible := true;
    Top := 0;
    Left := 0;
  end;
  FStatusBar := TPanel.Create(Self);
  FStatusBar.Parent := self;
  with FStatusBar do
  begin
    Align := alBottom;
    Height := cqrStatusBarHeight;
    Caption := '';
    ControlStyle := ControlStyle - [csAcceptsControls, csCaptureMouse, csClickEvents];
    BevelInner := bvNone;
    BevelOuter := bvNone;
  end;
  FEditPanel := TPanel.Create(Self);
  FEditPanel.Parent := self;
  with FEditPanel do
  begin
    Top := cqrToolBarHeight + 1;
    Align := alClient;
    BevelOuter := bvLowered;
  end;
  FEditArea := TScrollBox.Create(Self);
  FEditArea.Parent := FEditPanel;
  with FEditArea do
  begin
    Top := 1;
    Align := alClient;
    BorderStyle := bsNone;
{$ifdef win32}
    VertScrollbar.Tracking := true;
    HorzScrollbar.Tracking := true;
{$endif}
  end;
  InitButtons;
  HiddenForm := TForm.Create(Self);
  ExprToolbar := TQRExprToolbar.Create(Self);
  with ExprToolbar do
  begin
    Parent := Toolbar;
    Component := nil;
  end;
  QuickRepToolbar:=TQuickRepToolbar.Create(Self);
  with QuickRepToolbar do
  begin
    Parent := Toolbar;
    Component := nil;
    Top := EditorToolbar.Top+EditorToolbar.Height + 1;
  end;
  CustomBandToolbar := TQRCustomBandToolbar.Create(Self);
  with CustomBandToolbar do
  begin
    Parent := Toolbar;
    Component := nil;
    Top := EditorToolbar.Top + EditorToolbar.Height + 1;
  end;
  CustomLabelToolbar := TQRCustomLabelToolbar.Create(Self);
  with CustomLabelToolbar do
  begin
    Parent := Toolbar;
    Component := nil;
    Top := EditorToolbar.Top + EditorToolbar.Height + 1;
{    TQRCustomLabelToolbar(CustomLabelToolbar).FontName.Items := GetFonts;}
  end;
  ExprToolbar := TQRExprToolbar.Create(Self);
  with ExprToolbar do
  begin
    Parent := Toolbar;
    Component := nil;
    Top := CustomLabelToolbar.Top + CustomLabelToolbar.Height + 1;
  end;
  ShapeToolbar := TQRShapeToolbar.Create(Self);
  with ShapeToolbar do
  begin
    Parent := Toolbar;
    Component := nil;
    Top := EditorToolbar.Top + EditorToolbar.Height + 1;
  end;
  Filename := '';
end;

destructor TQREditor.Destroy;
begin
  FDesigner.StopEdit;
  FDesigner.Free;
  FStatusBar.Free;
  FToolbar.Free;
  FEditArea.Free;
  FEditPanel.Free;
  inherited Destroy;
end;

function TQREditor.GetEditing : boolean;
begin
  Result := FReport <> nil;
end;

procedure TQREditor.SetReport(Value : TQuickRep);
begin
  FReport := Value;
  if Value <> nil then
  begin
    FReport.Parent := FEditArea;
    Designer.Edit(FReport);
  end;
  with TQREditorToolbar(EditorToolbar) do
    SetButtons(Editing);
end;

procedure TQREditor.InitButtons;
begin
end;

procedure TQREditor.NewReport;
begin
  if assigned(FOnNewReport) then
    FOnNewReport(Self);
  if Editing then CloseReport;
  Report := TQuickRep.Create(HiddenForm);
end;

procedure TQREditor.SaveReport;
begin
  if Filename = '' then
  begin
    with TSaveDialog.Create(Application) do
    try
      Filter := 'QuickReport|*.QR'; {<-- do not resource }
      DefaultExt := 'QR';           {<-- do not resource }
      if Execute then
        SaveReportFile(Filename);
    finally
      Free;
    end;
  end else
    SaveReportFile(Filename);
end;

procedure TQREditor.CloseReport;
begin
  if Editing then
  begin
    if assigned(FOnCloseReport) then
      FOnCloseReport(Self);
    Designer.StopEdit;
    Report.Free;
    Report := nil;
    Filename := '';
  end;
end;

procedure TQREditor.SaveReportFile(aFilename : string);
begin
  if aFilename<>'' then
  begin
    Self.Filename := aFilename;
    if assigned(FOnSaveReport) then
      FOnSaveReport(Self);
    Designer.StopEdit;
    FReport.Parent := HiddenForm;
      WriteComponentResFile(Filename, HiddenForm);
    FReport.Parent := FEDitArea;
    Designer.Edit(Report);
  end
end;

procedure TQREditor.OpenReport;
begin
  with TOpenDialog.Create(Application) do
  try
    Filter:='QuickReport|*.QR';
    if Execute then
      OpenReportFile(Filename);
  finally
    Free;
  end;
end;

procedure TQREditor.OpenReportFile(aFilename : string);
begin
  while HiddenForm.ComponentCount > 0 do
    HiddenForm.Components[0].Free;
  try
    ReadComponentResFile(aFilename,HiddenForm);
    Report := TQuickRep(HiddenForm.Components[0]);
    Report.parent := EditArea;
    Self.Filename := aFilename;
    if Report <> nil then
      Designer.Edit(Report);
    if assigned(FOnOpenReport) then
      FOnOpenReport(Self);
  except
    ShowMessage(LoadStr(SqrErrorLoading));
  end;
end;

procedure TQREditor.DataSetup;
begin
  with TQRDataSetup.Create(Application) do
  try
    QuickRep := Report;
    ShowModal;
  finally
    Free
  end
end;

procedure TQREditor.ReportLayout;
begin
  with TQRCompEd.Create(Self) do
  try
    AvailableDataSets:=AllDataSets(TForm(Report.Owner),true);
    QuickRep := Report;
    ShowModal;
  finally
    Free;
  end
end;

procedure TQREditor.SetSelectedComponent(Sender : TObject);
begin
  if Sender<>FDesigner.EditControl then
  begin
    QuickRepToolbar.Visible:=Sender is TQuickRep;
    CustomBandToolbar.Visible:=Sender is TQRCustomBand;
    CustomLabelToolbar.Visible:=Sender is TQRCustomLabel;
    ExprToolbar.Visible:=Sender is TQRExpr;
    ShapeToolbar.Visible:=Sender is TQRShape;
    if Sender is TQuickRep then
      QuickRepToolbar.Component:=TComponent(Sender)
    else
      if Sender is TQRCustomBand then
        CustomBandToolbar.Component:=TComponent(Sender)
      else
        if Sender is TQRExpr then
        begin
          ExprToolbar.Component:=TComponent(Sender);
          CustomLabelToolbar.Component:=TComponent(Sender);
        end else
          if Sender is TQRShape then
            ShapeToolbar.Component:=TComponent(Sender);
  end;
end;

procedure TQREditor.ClickButton(Sender : TObject);
begin
end;

{$endif}

initialization
{  QRToolbarLibrary:=TQRLibrary.Create;}
  QRExportFilterLibrary.AddFilter(TQRAsciiExportFilter);
  //RegisterClasses([TQuickRep, TQRBand, TQRGroup, TQRSubDetail, TQRExpr, TQRShape, TTable, TQuery]);
  RegisterClasses([TQuickRep, TQRBand, TQRGroup, TQRSubDetail, TQRExpr, TQRShape]);
end.

