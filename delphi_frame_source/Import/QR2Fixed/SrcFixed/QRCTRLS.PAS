{ :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: QuickReport 2.0 for Delphi 1.0/2.0/3.0                  ::
  ::                                                         ::
  :: QRCTRLS.PAS - Common printable controls                 ::
  ::                                                         ::
  :: Copyright (c) 1997 QuSoft AS                            ::
  :: All Rights Reserved                                     ::
  ::                                                         ::
  :: web: http://www.qusoft.no   mail: support@qusoft.no     ::
  ::                             fax: +47 22 41 74 91        ::
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: }

(*{$define proversion}*)

unit Qrctrls;

interface

{$ifdef win32}
uses messages, windows, classes, controls, stdctrls,sysutils, graphics, buttons,
     forms, extctrls, dialogs, printers, db, DBtables, ComCtrls, RichEdit,
     QRPrntr, Quickrpt, QR2Const{$ifdef proversion}{$ifdef notyet}, olectnrs{$endif}{$endif};
{$else}
uses messages, wintypes, winprocs, classes, controls, stdctrls,sysutils, graphics, buttons,
     forms, extctrls, dialogs, printers, DB, DBTables, QRPrntr, Quickrpt, QR2Const, dbitypes, dbiprocs;
{$endif}

{$R-}
{$B-} { QuickReport source assumes boolean expression short-circuit  }

type
  { Forward declarations }
  TQRExpr = class;

  TQRLabelOnPrintEvent = procedure (sender : TObject; var Value : string) of object;

  { TQRCustomLabel - base class for printable text components }
  TQRCustomLabel = class(TQRPrintable)
  private
    DoneFormat : boolean;
    FAutoSize : boolean;
    FAutoStretch : boolean;
{$ifndef win32}
    FBuffer : pointer;
    FBufferSize : longint;
{$endif}
    FCaption : string;
    FFontSize : integer;
    FFormattedLines : TStrings;
    FLines : TStrings;
    FOnPrint : TQRLabelOnPrintevent;
    FWordWrap : boolean;
    MaxWidth : integer;
    UpdatingBounds : boolean;
    function GetCaption : string;
    procedure SetAutoStretch(Value : boolean);
    procedure SetCaption(Value : string);
    procedure SetLines(Value : TStrings);
    procedure SetWordWrap(Value : boolean);
    procedure PaintToCanvas(aCanvas : TCanvas; aRect : TRect; CanExpand : boolean; LineHeight : integer);
    procedure PrintToCanvas(aCanvas : TCanvas; aLeft, aTop, aWidth, aHeight, LineHeight : extended;
                            CanExpand : boolean);
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
  protected
    procedure FormatLines; virtual;
    procedure Loaded; override;
    procedure SetName(const Value: TComponentName); override;
    procedure SetParent(AParent: TWinControl); override;
{$ifndef win32}
    property Buffer : pointer read FBuffer write FBuffer;
    property BufferSize : longint read FBufferSize write FBufferSize;
{$endif}
    property OnPrint : TQRLabelOnPrintEvent read FOnPrint write FOnPrint;
    procedure DefineProperties(Filer: TFiler); override;
    procedure ReadFontSize(Reader : TReader); virtual;
    procedure WriteFontSize(Writer : TWriter); virtual;
    procedure ReadVisible(Reader : TReader); virtual;
    procedure WriteDummy(Writer : TWriter); virtual;
    procedure Paint; override;
    procedure Prepare; override;
    procedure Print(OfsX, OfsY : integer); override;
    procedure SetAlignment(Value : TAlignment); override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    property Alignment;
    property AutoSize : boolean read FAutoSize write FAutoSize;
    property AutoStretch : boolean read FAutoStretch write SetAutoStretch;
    property Caption : string read GetCaption write SetCaption stored true;
    property Color;
    property Font;
    property Lines : TStrings read FLines write SetLines;
    property WordWrap : boolean read FWordWrap write SetWordWrap;
  end;

  { TQRLabel - printable component with published Caption property }
  TQRLabel = class(TQRCustomLabel)
  public
  published
    property Alignment;
    property AlignToBand;
    property AutoSize;
    property AutoStretch;
    property Caption;
    property Color;
    property Font;
    property OnPrint;
    property ParentFont;
    property Transparent;
    property WordWrap;
  end;

  { TQRMemo - printable memo component (published Lines property) }
  TQRMemo = class(TQRCustomLabel)
  protected
    procedure DefineProperties(Filer : TFiler); override;
    procedure ReadTabStop(Reader : TReader); virtual;
    procedure WriteDummy2(Writer : TWriter); virtual;           
  public
    procedure Paint; override;
    procedure Print(OfsX, OfsY : integer); override;
  published
    property Alignment;
    property AlignToBand;
    property AutoSize;
    property AutoStretch;
    property Color;
    property Font;
    property Lines;
    property ParentFont;
    property Transparent;
    property WordWrap;
  end;

  { TQRDBText }
  TQRDBText = class(TQRCustomLabel)
  private
    Field : TField;
    FieldNo : integer;
    FieldOK : boolean;
    DataSourceName : string[30];
    FDataSet : TDataSet;
    FDataField : string;
    FMask : string;
    procedure SetDataSet(Value : TDataSet);
    procedure SetDataField(Value : string);
    procedure SetMask(Value : string);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Prepare; override;
    procedure Print(OfsX, OfsY : integer); override;
    procedure ReadValues(Reader : TReader); virtual;
    procedure Unprepare; override;
    procedure WriteValues(Writer : TWriter); virtual;
  public
    constructor Create(AOwner : TComponent); override;
  published
    property Alignment;
    property AlignToBand;
    property AutoSize;
    property AutoStretch;
    property Color;
    property DataSet : TDataSet read FDataSet write SetDataSet;
    property DataField : string read FDataField write SetDataField;
    property Font;
    property Mask : string read FMask write SetMask;
    property OnPrint;
    property ParentFont;
    property Transparent;
    property WordWrap;
  end;

  { TQRExpr }
  TQRExpr = class(TQRCustomLabel)
  private
    Evaluator : TQREvaluator;
    FExpression : string;
    FMask : string;
    FMaster : TComponent;
    FResetAfterPrint : boolean;
    function GetValue : TQREvResult;
    procedure SetExpression(Value : string);
    procedure SetMask(Value : string);
  protected
    procedure Prepare; override;
    procedure Unprepare; override;
    procedure QRNotification(Sender : TObject; Operation : TQRNotifyOperation); override;
    procedure Print(OfsX, OfsY : integer); override;
    procedure SetMaster(AComponent : TComponent);
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Reset;
    property Value : TQREvResult read GetValue;
  published
    property Alignment;
    property AlignToBand;
    property AutoSize;
    property AutoStretch;
    property Font;
    property Color;
    property Master : TComponent read FMaster write SetMaster;
    property OnPrint;
    property ParentFont;
    property ResetAfterPrint : boolean read FResetAfterPrint write FResetAfterPrint;
    property Transparent;
    property WordWrap;
    property Expression : string read FExpression write SetExpression;
    property Mask : string read FMask write SetMask;
  end;

  { TQRSysData }
  TQRSysDataType = (qrsTime,
                    qrsDate,
                    qrsDateTime,
                    qrsPageNumber,
                    qrsReportTitle,
                    qrsDetailCount,
                    qrsDetailNo);

  TQRSysData = class(TQRCustomLabel)
  private
    FData : TQRSysDataType;
    FText : string;
    procedure SetData(Value : TQRSysDataType);
    procedure SetText(Value : string);
    procedure CreateCaption;
  protected
    procedure Print(OfsX, OfsY : integer); override;
  public
    constructor Create(AOwner : TComponent); override;
  published
    property Alignment;
    property AlignToBand;
    property AutoSize;
    property Color;
    property Data : TQRSysDataType read FData write SetData;
    property Font;
    property OnPrint;
    property ParentFont;
    property Text : string read FText write SetText;
    property Transparent;
  end;

  { TQRShape }
  TQRShapeType = (qrsRectangle,qrsCircle,qrsVertLine,qrsHorLine,qrsTopAndBottom,qrsRightAndLeft);

  TQRShape = class(TQRPrintable)
  private
    FShape : TQRShapeType;
    FBrush : TBrush;
    FPen : TPen;
    procedure SetBrush(Value : TBrush);
    procedure SetPen(Value : TPen);
    procedure SetShape(Value : TQRShapeType);
  protected
    procedure Paint; override;
    procedure Print(OfsX, OfsY : integer); override;
    procedure StyleChanged(sender : TObject);
    procedure DefineProperties(Filer: TFiler); override;
    procedure ReadVisible(Reader : TReader); virtual;
    procedure WriteDummy(Writer : TWriter); virtual;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
  published
    property Brush : TBrush read FBrush write SetBrush;
    property Height default 65;
    property Pen : TPen read FPen write Setpen;
    property Shape : TQRShapeType Read FShape write SetShape;
    property Width default 65;
  end;

  { TQRImage }
  TQRImage = class(TQRPrintable)
  private
    FPicture: TPicture;
    FAutoSize: Boolean;
    FStretch: Boolean;
    FCenter: Boolean;
    function GetCanvas: TCanvas;
    procedure PictureChanged(Sender: TObject);
    procedure SetAutoSize(Value: Boolean);
    procedure SetCenter(Value: Boolean);
    procedure SetPicture(Value: TPicture);
    procedure SetStretch(Value: Boolean);
  protected
    function GetPalette: HPALETTE; override;
    procedure Paint; override;
    procedure Print(OfsX, OfsY : integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Canvas: TCanvas read GetCanvas;
  published
    property AutoSize: Boolean read FAutoSize write SetAutoSize default False;
    property Center: Boolean read FCenter write SetCenter default False;
    property Picture: TPicture read FPicture write SetPicture;
    property Stretch: Boolean read FStretch write SetStretch default False;
  end;

  { TQRDBImage }
  TQRDBImage = class(TQRPrintable)
  private
    FField : TField;
    FDataSet : TDataSet;
    FDataField : string;
    FPicture: TPicture;
    FStretch: boolean;
    FCenter: boolean;
    FPictureLoaded: boolean;
    procedure PictureChanged(Sender: TObject);
    procedure SetCenter(Value: Boolean);
    procedure SetDataField(const Value: string);
    procedure SetDataSet(Value: TDataSet);
    procedure SetPicture(Value: TPicture);
    procedure SetStretch(Value: Boolean);
  protected
    function GetPalette: HPALETTE; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure Prepare; override;
    procedure Print(OfsX, OfsY : integer); override;
    procedure UnPrepare; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadPicture;
    property Field: TField read FField;
    property Picture: TPicture read FPicture write SetPicture;
  published
    property Center: boolean read FCenter write SetCenter default True;
    property DataField: string read FDataField write SetDataField;
    property DataSet: TDataSet read FDataSet write SetDataSet;
    property Stretch: boolean read FStretch write SetStretch default False;
  end;

{$ifdef win32}

  { TQRRichEdit - TQRCustomRichEdit descendant with some special settings }
  TQRRichEdit = class(TCustomRichEdit)
  public
    property BorderStyle;
  end;

  { TQRRichText }
  TQRCustomRichText = class(TQRPrintable)
  private
    FAutoStretch : boolean;
    FParentRichEdit : TRichEdit;
    FRichEdit : TQRRichEdit;
    function GetAlignment : TAlignment;
    function GetColor : TColor;
    function GetFont : TFont;
    function GetLines : TStrings;
    procedure SetAlignment(Value : TAlignment); override;
    procedure SetColor(Value : TColor);
    procedure SetFont(Value : TFont);
    procedure SetLines(Value : TStrings);
    procedure SetParentRichEdit(Value : TRichEdit);
  protected
    property Lines : TStrings read GetLines write SetLines;
    property ParentRichEdit : TRichEdit read FParentRichEdit write SetParentRichEdit;
    procedure Print(OfsX, OfsY : integer); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight : integer); override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
  published
    property Alignment : TAlignment read GetAlignment write SetAlignment;
    property AutoStretch : boolean read FAutoStretch write FAutoStretch;
    property Color : TColor read GetColor write SetColor;
    property Font : TFont read GetFont write SetFont;
  end;

  { TQRRichText }
  TQRRichText = class(TQRCustomRichText)
  published
    property Lines;
    property ParentRichEdit;
  end;

  { TQRDBRichText }
  TQRDBRichText = class(TQRCustomRichText)
  private
    Field : TField;
    FDataField : string;
    FDataSet : TDataSet;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetDataSet(Value : TDataSet);
    procedure Prepare; override;
    procedure Unprepare; override;
    procedure Print(OfsX, OfsY : integer); override;
  published
    property DataField : string read FDataField write FDataField;
    property DataSet : TDataSet read FDataSet write SetDataSet;
  end;

{$ifdef notyet}

  TQROleCtrl = class(TQRPrintable)
  private
    OleContainer : TOleContainer;
  protected
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure Paint; override;
{$ifdef ver100}
    procedure GetChildren(Proc: TGetChildProc; Root : TComponent); override;
{$else}
    procedure GetChildren(Proc: TGetChildProc); override;
{$endif}
    procedure ReadState(Reader: TReader); override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Edit;
    procedure New;
    procedure Print(Xofs, YOfs : integer); override;
  end;

{$endif}

{$endif}

{ TQRDBCalc - included for backwards compatibility }

  TQRCalcOperation = (qrcSum, qrcCount, qrcMax, qrcMin, qrcAverage);

  TQRDBCalc = class(TQRExpr)
  private
    FDataField : string;
    FDataSource : TDataSource;
    FOperation : TQRCalcOperation;
    FResetBand : TQRBand;
  protected
    function GetPrintMask : string;
    procedure SetDataField(Value : string);
    procedure SetOperation(Value : TQRCalcOperation);
    procedure SetPrintMask(Value : string);
  published
    property DataField : string read FDataField write SetDataField;
    property DataSource : TDataSource read FDataSource write FDataSource;
    property OnPrint;
    property Operation : TQRCalcOperation  read FOperation write SetOperation;
    property ParentFont;
    property PrintMask : string read GetPrintMask write SetPrintMask;
    property ResetBand : TQRBand read FResetBand write FResetBand;
  end;

implementation

function GetWords(aString : string) : TStrings;
var
  I : integer;
begin
  result := TStringList.Create;
  I := pos(' ', aString);
  while i > 0 do
  begin
    result.Add(copy(aString, 1, I - 1));
    Delete(aString, 1, I);
    I := pos(' ', aString);
  end;
  if length(aString) > 0 then
    result.Add(aString);
end;

function RTrimString(strString : string) : string;
var
  intEnd : integer;
begin
  intEnd := Length(strString);
  while (copy(strString, intEnd, 1) = ' ') and (intEnd > 1) do
    dec(intEnd);
  strString := Copy(strString, 1, intEnd);
  Result := strString;
end;


{ TQRCustomLabel }

constructor TQRCustomLabel.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FAutoSize := true;
  FAutoStretch := false;
  FWordWrap := true;
  FLines := TStringList.Create;
  FFormattedLines := TStringList.Create;
  DoneFormat := false;
  Caption := '';
  Transparent := false;
  UpdatingBounds := false;
  FFontSize := 0;
{$ifndef win32}
  BufferSize := 0;
{$endif}
end;

destructor TQRCustomLabel.Destroy;
begin
  FLines.Free;
  FFormattedLines.Free;
{$ifndef win32}
  if BufferSize > 0 then
    FreeMem(FBuffer, FBufferSize);
{$endif}
  inherited Destroy;
end;

function TQRCustomLabel.GetCaption : string;
begin
  result := FCaption;
end;

procedure TQRCustomLabel.DefineProperties(Filer: TFiler);
begin
  Filer.DefineProperty('FontSize', ReadFontSize, WriteFontSize, true); { <-- do not resource}
  Filer.DefineProperty('Visible', ReadVisible, WriteDummy, false);
  inherited DefineProperties(Filer);
end;

procedure TQRCustomLabel.ReadFontSize(Reader : TReader);
begin
  FFontSize := Reader.ReadInteger;
end;

procedure TQRCustomLabel.ReadVisible(Reader : TReader);
begin
  Enabled := Reader.ReadBoolean;
end;

procedure TQRCustomLabel.WriteFontSize(Writer : TWriter);
begin
  Writer.WriteInteger(Font.Size);
end;

procedure TQRCustomLabel.WriteDummy(Writer : TWriter);
begin
end;

procedure TQRCustomLabel.Loaded;
begin
  inherited Loaded;
  if FFontSize > 0 then
    Font.Size := FFontSize;
end;

procedure TQRCustomLabel.CMFontChanged(var Message: TMessage);
begin
  inherited;
  FormatLines;
end;

procedure TQRCustomLabel.Prepare;
begin
  inherited Prepare;
  Caption := copy(Caption, 1, length(Caption));
end;

procedure TQRCustomLabel.FormatLines;
{$ifdef win32}
var
  I : integer;
  aStrings : TStrings;
  Words : TStrings;
  aLine : string;
  aWidth : integer;
  ParentRepOK : boolean;
begin
  if Parent <> nil then
  begin
    ParentRepOK := ParentReport <> nil;
    if assigned(FFormattedLines) then
      FFormattedLines.Free;
    aStrings := TStringList.Create;
    if Caption <> '' then
    begin
      aStrings.Add(Caption)
    end else
      aStrings.Assign(FLines);
    if not AutoSize and WordWrap then
    begin
      FFormattedLines := TStringList.Create;
      Canvas.Font.Assign(Font);
      Canvas.Font.Size := round(Canvas.Font.Size * Zoom / 100);
      for I := 0 to aStrings.Count - 1 do
      begin
        Words := GetWords(aStrings[I]);
        aLine := '';
        if Words.Count > 0 then
        begin
          while Words.Count > 0 do
          begin
            if ParentRepOK then
              aWidth := round(ParentReport.TextWidth(Font, aLine + Words[0] + ' ') * Zoom / 100)
            else
              aWidth := Canvas.TextWidth(aLine + Words[0] + ' ');
            if (aWidth > Width) and (aLine <> '') then
            begin
              FFormattedLines.Add(aLine);
              aLine := '';
            end;
            if Length(aLine)>0 then
              aLine := aLine + ' ';
            aLine := aLine + Words[0];
            Words.Delete(0);
          end;
          if aLine<>'' then
            FFormattedLines.Add(aLine);
        end else
          FFormattedLines.Add('');
        Words.Free;
      end;
      aStrings.Free;
    end else
      FFormattedLines := aStrings;
    DoneFormat := true;
{$else}
var
  BufSize : longint;
  ABuffer : PChar;
  ParentRepOK : boolean;
  aWord : string;
  Words : TStrings;
  Counter : longint;
  I : longint;
  aChar : Char;
  aLine : string;
  aWidth : longint;

  procedure SubmitWord(Word : string);
  begin
    if ParentRepOK then
    begin
      if not AutoSize then
      begin
        aWidth := round(longint(ParentReport.TextWidth(Font, aLine + Word + ' ')) * Zoom / 100);
        if (aWidth > Width) and (aLine <> '') then
        begin
          FFormattedLines.Add(aLine);
          aLine := '';
        end;
      end;
      aLine := aLine + Word + ' ';
    end
  end;

  procedure BuildFromBuffer;
  var
    I : integer;
  begin
    try
      Words := TStringList.Create;
      aWord := '';
      aLine := '';
      if BufferSize > 0 then
      begin
        for I := 0 to BufferSize - 1 do
        begin
          aChar := ABuffer[I];
          if aChar = ' ' then
          begin
            SubmitWord(aWord);
{            if aLine <> '' then
              aLine := aLine + ' ';}
            aWord := '';
          end else
            if aChar = #10 then
            begin
              SubmitWord(aWord);
              if aLine = '' then
                FFormattedLines.Add(' ')
              else
                FFormattedLines.Add(aLine);
              aLine := '';
              aWord := '';
            end else
              if aChar <> #13 then aWord := aWord + aChar;
        end;
        SubmitWord(aWord);
        if (length(aLine) > 0) and (aLine[length(aLine)] = ' ') then
          Delete(aLine, Length(aLine), 1);
        if aLine<> '' then FFormattedLines.Add(aLine);
      end;
    finally
      Words.Free;
    end;
  end;

  procedure BuildFromList;
  var
    I : integer;
    J : integer;
  begin
    if not AutoSize and WordWrap then
    begin
      for I := 0 to FLines.Count - 1 do
      begin
        aLine := '';
        Words := GetWords(FLines[I]);
        for J := 0 to Words.Count - 1 do
          SubmitWord(Words[J]);
        if Length(aLine) > 0 then
          FFormattedLines.Add(aLine);
      end;
      Words.Free;
    end else
      FFormattedLines.Assign(FLines);
  end;

begin
  if Parent <> nil then
  begin
    if assigned(FFormattedLines) then
      FFormattedLines.Clear
    else
      FFormattedLines := TStringList.Create;
    ParentRepOK := ParentReport <> nil;
    if (Caption <> '') or (BufferSize > 0) then
    try
      if Caption <> '' then
      begin
        ABuffer := StrAlloc(length(Caption) + 1);
        StrPCopy(ABuffer, Caption);
        BufferSize := StrLen(ABuffer);
      end else
        if BufferSize > 0 then
          ABuffer := Buffer
        else
          BufferSize := 0;
      BuildFromBuffer;
    finally
      if Caption <> '' then
      begin
        StrDispose(ABuffer);
        BufferSize := 0;
      end;
    end else
      if Lines.Count > 0 then
        BuildFromList;

{$endif}
    if AutoSize and not UpdatingBounds then
    begin
      MaxWidth := 0;
      Canvas.Font := Font;
      Canvas.Font.Size := round(Canvas.Font.Size * Zoom / 100);
      for I := 0 to FFormattedLines.Count - 1 do
      begin
        if ParentRepOK then
          aWidth := round(longint(ParentReport.TextWidth(Font, FFormattedLines[I])) * Zoom / 100)
        else
          aWidth := Canvas.TextWidth(FFormattedLines[I]);
        if aWidth > MaxWidth then
          MaxWidth := aWidth;
      end;
      if Frame.DrawLeft then
        MaxWidth := MaxWidth + Frame.Width;
      if Frame.DrawRight then
        MaxWidth := MaxWidth + Frame.Width;
      UpdatingBounds := true;
      Width := MaxWidth;
      if (Lines.Count = 0) then
      begin
        if ParentRepOK then
          Height := round(ParentReport.TextHeight(Font, 'W') * Zoom / 100) + 1
        else
          Height := Canvas.TextHeight('W');
      end;
      UpdatingBounds := false;
    end else
      if not AutoSize and not UpdatingBounds then
      begin
        if ParentRepOK then
          if Height < (round(ParentReport.TextHeight(Font, 'W') * Zoom / 100) + 1) then
            Height := round(ParentReport.TextHeight(Font, 'W') * Zoom / 100) + 1;
      end;
  end;
end;

procedure TQRCustomLabel.SetLines(Value : TStrings);
begin
  FLines.Assign(Value);
  Caption := '';
  Invalidate;
end;

procedure TQRCustomLabel.PaintToCanvas(aCanvas : TCanvas; aRect : TRect; CanExpand : boolean; LineHeight: integer);
var
  I : integer;
  StartX : integer;
  StartY : integer;
  Cap : string;
  VPos : integer;
  Flags : integer;
begin
  FormatLines;
  Flags := 0;
{  if AutoSize then Flags := 0 else Flags := ETO_CLIPPED;}
  if not Transparent then
  begin
    aCanvas.Brush.Color := Color;
    aCanvas.Brush.Style := bsSolid;
    aCanvas.Fillrect(aRect);
  end;
  StartY := aRect.Top;
  StartX := aRect.Left;
  if Frame.AnyFrame then
  begin
    if Frame.DrawTop and (Frame.Width > 0 ) then
      StartY := StartY + round(Frame.Width / 72 * Screen.PixelsPerInch * Zoom / 100);
    if Frame.DrawLeft then
      StartX := StartX + round(Frame.Width / 72 * Screen.PixelsPerInch * Zoom / 100)
  end;
  aRect.Right := aRect.Right - aRect.Left;
  aRect.Left := 0;
  aRect.Bottom := aRect.Bottom - aRect.Top;
  aRect.Top := 0;
{$ifdef win32}
  SetBkMode(aCanvas.Handle, Windows.Transparent);
{$else}
  SetBkMode(aCanvas.Handle, WinTypes.Transparent);
{$endif}
  begin
    case Alignment of
      TaLeftJustify : SetTextAlign(aCanvas.Handle, TA_Left + TA_Top + TA_NoUpdateCP);
      TaRightJustify: begin
          SetTextAlign(aCanvas.Handle, TA_Right + TA_Top + TA_NoUpdateCP);
          StartX := StartX + aRect.Right;
        end;
      TaCenter : begin
          SetTextAlign(aCanvas.Handle, TA_Center + TA_Top + TA_NoUpdateCP);
          StartX := StartX + (aRect.Right - aRect.Left) div 2;
        end;
    end;
  end;
  for I := 0 to FFormattedLines.Count - 1 do
  begin
    VPos := StartY + I * LineHeight;
    begin
      Cap := FFormattedLines[I];
      if Length(Cap) > 0 then
        ExtTextOut(aCanvas.Handle, StartX, VPos, Flags, @aRect, @Cap[1], length(Cap), nil);
    end;
  end;
end;

procedure TQRCustomLabel.PrintToCanvas(aCanvas : TCanvas;
                                       aLeft, aTop, aWidth, aHeight,
                                       LineHeight : extended;
                                       CanExpand : boolean);
var
  aRect : TRect;
  ControlBottom : extended;
  X, Y : extended;
  I : integer;
  ChangeX : extended;
  GetNewCanvas : boolean;
  SavedCaption : string;
  NewCaption : string;
  HasSaved : boolean;
  Flags : integer;
  {$ifndef win32}
  aLine : string;
  {$endif}
begin
  Flags := 0;
{  if AutoSize then Flags := 0; else Flags := ETO_CLIPPED;}
{  if Transparent then Flags := Flags + ETO_OPAQUE;}
  HasSaved := false;
  if (Caption <> '') and assigned(FOnPrint) then
  begin
    SavedCaption := Caption;
    NewCaption := Caption;
    FOnPrint(Self, NewCaption);
    if NewCaption <> Caption then
    begin
      Caption := NewCaption;
      HasSaved := true;
    end;
  end else
    FormatLines;
  if ParentReport.FinalPass and not Transparent then
    with aCanvas do
    begin
      Pen.Width := 0;
      Brush.Color := Color;
      Brush.Style := bsSolid;
      FillRect(rect(QRPrinter.XPos(aLeft),
                    QRPrinter.YPos(aTop),
                    QRPrinter.XPos(aLeft + aWidth),
                    QRPrinter.YPos(aTop + aHeight)));
    end;
  if ParentReport.FinalPass then
{$ifndef win32}
    if QRPrinter.Destination = qrdPrinter then
{$endif}
{    IntersectClipRect(QRPrinter.Canvas.Handle,
                      QRPrinter.XPos(aLeft),
                      QRPrinter.YPos(aTop),
                      QRPrinter.XPos(aLeft + aWidth),
                      QRPrinter.YPos(aTop + aHeight));}

  if Frame.AnyFrame then
  begin
    if Frame.DrawTop then
      aTop := aTop + round(Frame.Width / 72 * 254 );
    if Frame.DrawLeft then
      aLeft := aLeft + round(Frame.Width / 72 * 254 )
  end;

  { Get our rectangle for the next line }
  aRect := Rect(0, 0, QRPrinter.XSize(aWidth), QRPrinter.YSize(LineHeight));

  { Calculate some stuff... }
  ControlBottom := aTop + aHeight + 1;
  X := aLeft;
  Y := aTop;
  {$ifdef win32}
  SetBkMode(aCanvas.Handle, Windows.Transparent);
  {$else}
  SetBkMode(aCanvas.Handle, WinTypes.Transparent);
  {$endif}
  { Set the attributes and update X for alignment }
  case Alignment of
    TaLeftJustify : SetTextAlign(aCanvas.Handle, TA_Left + TA_Top + TA_NoUpdateCP);
    TaRightJustify: begin
        SetTextAlign(aCanvas.Handle, TA_Right + TA_Top + TA_NoUpdateCP);
        X := X + aWidth;
      end;
    TaCenter : begin
        SetTextAlign(aCanvas.Handle, TA_Center + TA_Top + TA_NoUpdateCP);
        X := X + aWidth / 2;
      end;
  end;

  { Print text lines ... }
  for I := 0 to FFormattedLines.Count - 1 do
  begin
    if (Y + LineHeight > ControlBottom) then
    begin
      if CanExpand and (Length(RTrimString(FFormattedLines[I])) > 0) then
      begin
        GetNewCanvas := not TQRCustomBand(Parent).CanExpand(LineHeight);
        TQRCustomBand(Parent).ExpandBand(LineHeight, Y, ChangeX);
        if GetNewCanvas then
        begin
          aCanvas := QRPrinter.Canvas;
          aCanvas.Font := Self.Font;
{$ifdef win32}
          SetBkMode(aCanvas.Handle, Windows.Transparent);
{$else}
          SetBkMode(aCanvas.Handle, WinTypes.Transparent);
{$endif}
          case Alignment of
            TaLeftJustify : SetTextAlign(aCanvas.Handle, TA_Left + TA_Top + TA_NoUpdateCP);
            TaRightJustify: SetTextAlign(aCanvas.Handle, TA_Right + TA_Top + TA_NoUpdateCP);
            TaCenter : SetTextAlign(aCanvas.Handle, TA_Center + TA_Top + TA_NoUpdateCP);
          end;
        end;
        ControlBottom := Y + LineHeight;
{$ifdef win32}
{        SelectClipRgn(QRPrinter.Canvas.Handle, 0);}
{$endif}
        if ParentReport.FinalPass and not Transparent then
          aCanvas.FillRect(rect(QRPrinter.XPos(X), QRPrinter.YPos(Y),
                        QRPrinter.XPos(X + aWidth), QRPrinter.YPos(ControlBottom)));
{$ifndef win32}
        if QRPrinter.Destination = qrdPrinter then
{$endif}
        if ParentReport.FinalPass then
{          IntersectClipRect(QRPrinter.Canvas.Handle,
                            QRPrinter.XPos(X),
                            QRPrinter.YPos(Y),
                            QRPrinter.XPos(X + aWidth),
                            QRPrinter.YPos(ControlBottom));}
      end else
        break;
    end;
    if ParentReport.FinalPass and (length(FFormattedLines[I]) > 0) then
    begin
  {$ifdef win32}
      ExtTextOut(aCanvas.Handle, QRPrinter.XPos(X), QRPrinter.YPos(Y),
        Flags, @aRect, @FFormattedLines[I][1], length(FFormattedLines[I]), nil);
  {$else}
      aLine := FFormattedLines[I];
      ExtTextOut(aCanvas.Handle, QRPrinter.XPos(X), QRPrinter.YPos(Y),
        Flags, @aRect, @aLine[1], length(aLine),nil);
  {$endif}
    end;
    if ParentReport.Exporting then
      ParentReport.ExportFilter.TextOut(X, Y, Font, Color, Alignment, FFormattedLines[I]);
    Y := Y + LineHeight;
  end;
{  SelectClipRgn(QRPrinter.Canvas.Handle, 0);}
  if HasSaved then
    Caption := SavedCaption;
end;

procedure TQRCustomLabel.Paint;
begin
  Canvas.Font.Assign(Font);
  if Canvas.Font.Size <> round(Font.Size * Zoom / 100) then
    Canvas.Font.Size := round(Font.Size * Zoom / 100);
  inherited Paint;
  PaintToCanvas(Canvas, rect(0, 0, Width, Height), false, round(Canvas.TextHeight('W')));
  PaintCorners;
end;

procedure TQRCustomLabel.Print(OfsX, OfsY : integer);
var
  aCanvas : TCanvas;
begin
{$ifdef win32}
  aCanvas := QRPrinter.Canvas;
{$else}
  if QRPrinter.Destination = qrdPrinter then
    aCanvas := QRPrinter.Canvas
  else
  begin
    aCanvas := Canvas;
    with QRPrinter do
    begin
      Canvas.Font := Font;
    end;
  end;
{$endif}
  aCanvas.Font := Font;
  with QRPrinter do
    PrintToCanvas(QRPrinter.Canvas,
                  OfsX + Size.Left, OfsY + Size.Top,
                  Size.Width, Size.Height,
                  aCanvas.TextHeight('W') / QRPrinter.YFactor, AutoStretch);
  inherited Print(OfsX, OfsY);
end;

procedure TQRCustomLabel.SetAutoStretch(Value : boolean);
begin
  FAutoStretch := Value;
  Invalidate;
end;

procedure TQRCustomLabel.SetCaption(Value : string);
begin
  FCaption := Value;
  FormatLines;
  Invalidate;
end;

procedure TQRCustomLabel.SetName(const Value: TComponentName);
begin
  if ((Caption = '') or (Caption = Name)) then
    Caption := Value;
  inherited SetName(Value);
end;

procedure TQRCustomLabel.SetParent(AParent : TWinControl);
begin
  inherited SetParent(AParent);
  FormatLines;
end;

procedure TQRCustomLabel.SetAlignment(Value : TAlignment);
begin
  inherited SetAlignment(Value);
  if Value <> taLeftJustify then
    AutoSize := false;
end;

procedure TQRCustomLabel.SetWordWrap(Value : boolean);
begin
  FWordWrap := Value;
  Invalidate;
end;

{ TQRMemo }

procedure TQRMemo.DefineProperties(Filer: TFiler);
begin
  Filer.DefineProperty('TabStop', ReadTabStop, WriteDummy2, false); { <-- do not resource}
  inherited DefineProperties(Filer);
end;

procedure TQRMemo.ReadTabStop(Reader : TReader);
begin
  Reader.ReadBoolean;
end;

procedure TQRMemo.WriteDummy2(Writer : TWriter);
begin
end;

procedure TQRMemo.Paint;
begin
  if (Lines.Count > 0) and (Caption > '') then
    Caption := '';
  inherited Paint;
end;

procedure TQRMemo.Print(OfsX, OfsY : integer);
begin
  if (Lines.Count>0) and (Caption>'') then
    Caption := '';
  inherited Print(OfsX, OfsY);
end;

{ TQRDBText }

constructor TQRDBText.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  DataSourceName := '';
end;

procedure TQRDBText.SetDataSet(Value : TDataSet);
begin
  FDataSet := Value;
{$ifdef win32}
  if Value<>nil then
    Value.FreeNotification(self);
{$endif}
end;

procedure TQRDBText.SetDataField(Value : string);
begin
  FDataField := Value;
  Caption := Value;
end;

procedure TQRDBText.Loaded;
var
  aComponent : TComponent;
begin
  inherited Loaded;
  if DataSourceName<>'' then
  begin
    aComponent := Owner.FindComponent(DataSourceName);
    if (aComponent <> nil) and (aComponent is TDataSource) then
      DataSet:=TDataSource(aComponent).DataSet;
  end;
end;

procedure TQRDBText.DefineProperties(Filer: TFiler);
begin
  Filer.DefineProperty('DataSource',ReadValues,WriteValues,false);
  inherited DefineProperties(Filer);
end;

procedure TQRDBText.ReadValues(Reader : TReader);
begin
  DataSourceName := Reader.ReadIdent;
end;

procedure TQRDBtext.WriteValues(Writer : TWriter);
begin
end;

procedure TQRDBText.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
    if AComponent = FDataSet then
      FDataSet := nil;
end;

procedure TQRDBText.SetMask(Value : string);
begin
  FMask := Value;
end;

procedure TQRDBText.Prepare;
begin
  inherited Prepare;
  if assigned(FDataSet) then
  begin
    Field := FDataSet.FindField(FDataField);
    if Field <> nil then
    begin
      FieldNo := Field.Index;
      FieldOK := true;
      if (Field is TMemoField) or (Field is TBlobField) then
      begin
        Caption := '';
      end;
    end;
  end else
  begin
    Field := nil;
    FieldOK := false;
  end;
end;

procedure TQRDBText.Print(OfsX, OfsY : integer);
{$ifndef win32}
var
  BytesRead : longint;
  DataLoss : WordBool;
{$endif}
begin
  if FieldOK then
  begin
    if FDataSet.DefaultFields then
      Field := FDataSet.Fields[FieldNo];
  end
  else
    Field := nil;
  if assigned(Field) then
  begin
    try
      if (Field is TMemoField) or
         (Field is TBlobField) then
      begin
  {$ifdef win32}
        Lines.Text := TMemoField(Field).AsString;
  {$else}
        if BufferSize > 0 then
          FreeMem(FBuffer, BufferSize);
        with Field do
        begin
          dbiOpenBlob(DataSet.Handle, DataSet.ActiveBuffer, FieldNo, dbiReadOnly);
          dbiGetBlobSize(DataSet.Handle, DataSet.ActiveBuffer, FieldNo, FBufferSize);
          GetMem(FBuffer, BufferSize);
          dbiGetBlob(DataSet.Handle, DataSet.ActiveBuffer, FieldNo, 0, BufferSize, FBuffer, BytesRead);
          dbiFreeBlob(DataSet.Handle, DataSet.ActiveBuffer, FieldNo);
          if BufferSize > 0 then
            dbiNativeToAnsi(DataSet.Locale, FBuffer, FBuffer, BufferSize, DataLoss);
        end
  {$endif}
      end else
        if (Mask = '') or (Field is TStringField) then
          if not (Field is TBlobField) then
            Caption := Field.DisplayText
          else
            Caption := Field.AsString
        else
        begin
          if (Field is TIntegerField) or
             (Field is TSmallIntField) or
             (Field is TWordField) then
             Caption := FormatFloat(Mask, TIntegerField(Field).Value * 1.0)
          else
            if (Field is TFloatField) or
               (Field is TCurrencyField) or
               (Field is TBCDField) then
               Caption := FormatFloat(Mask,TFloatField(Field).Value)
            else
              if (Field is TDateTimeField) or
                 (Field is TDateField) or
                 (Field is TTimeField) then Caption := FormatDateTime(Mask,TDateTimeField(Field).Value);
        end;
    except
      Caption := '';
    end;
  end else
    Caption := '';
  inherited Print(OfsX,OfsY);
end;

procedure TQRDBText.Unprepare;
begin
  Field := nil;
  inherited Unprepare;
  if DataField <> '' then
    SetDataField(DataField) { Reset component caption }
  else
    SetDataField(Name);
end;

{ TQRExpr }

constructor TQRExpr.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  Evaluator := TQREvaluator.Create;
  FExpression := '';
  FMask := '';
end;

destructor TQRExpr.Destroy;
begin
  Evaluator.Free;
  inherited Destroy;
end;

function TQRExpr.GetValue : TQREvResult;
begin
  if Evaluator.Prepared then
    result := Evaluator.Value
  else
    result.Kind := resError;
  if result.Kind=resError then
    result.strResult := LoadStr(SqrErrorInExpr);
end;

procedure TQRExpr.Reset;
begin
   Evaluator.Reset;
end;

procedure TQRExpr.SetMaster(AComponent : TComponent);
begin
  FMaster := AComponent;
end;

procedure TQRExpr.QRNotification(Sender : TObject; Operation : TQRNotifyOperation);
begin
  inherited QRNotification(Sender, Operation);
  case Operation of
    qrMasterDataAdvance : begin
                            Evaluator.Aggregate := true;
                            Evaluator.Value;
                            Evaluator.Aggregate := false;
                          end;
  end;
end;

procedure TQRExpr.Prepare;
begin
  inherited Prepare;
  Evaluator.DataSets := ParentReport.AllDataSets;
  Evaluator.Prepare(FExpression);
  if assigned(FMaster) then
  begin
    if Master is TQuickRep then
      TQuickRep(Master).AddNotifyClient(Self)
    else
      if Master is TQRSubDetail then
        TQRSubDetail(Master).AddNotifyClient(Self);
  end else
    if Evaluator.IsAggreg then ParentReport.AddNotifyClient(Self);
  Reset;
end;

procedure TQRExpr.Unprepare;
begin
  Evaluator.DataSets := nil;
  Evaluator.Unprepare;
  inherited Unprepare;
  SetExpression(Expression); { Reset component caption... }
end;

procedure TQRExpr.Print(OfsX, OfsY : integer);
var
  aValue : TQREvResult;
begin
  aValue := Evaluator.Value;
  case aValue.Kind of
    resInt : Caption := FormatFloat(Mask, aValue.IntResult*1.0);
    resString : Caption := aValue.strResult;
    resDouble : Caption := FormatFloat(Mask,aValue.DblResult);
    resBool : if aValue.booResult then Caption := 'True' else Caption := 'False'; {<-- do not resource }
    resError : Caption := FExpression;
  end;
  inherited Print(OfsX, OfsY);
  if ResetAfterPrint then Reset;
end;

procedure TQRExpr.SetExpression(Value : string);
begin
  FExpression := Value;
  if Value='' then
    Caption := '(' + LoadStr(SqrNone) + ')'
  else
    Caption := Value;
  Invalidate;
end;

procedure TQRExpr.SetMask(Value : string);
begin
  FMask := Value;
  SetExpression(Expression);
end;

{ TQRSysData }

constructor TQRSysData.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FText := '';
  CreateCaption;
end;

procedure TQRSysData.Print(OfsX,OfsY : integer);
begin
  case FData of
    qrsTime : Caption := FText+FormatDateTime('t',SysUtils.Time);
    qrsDate : Caption := FText+FormatDateTime('c',SysUtils.Date);
    qrsDateTime : Caption := FText+FormatDateTime('c',Now);
    qrsPageNumber : Caption := FText+IntToStr(ParentReport.PageNumber);
    qrsReportTitle: Caption := FText+ParentReport.ReportTitle;
    qrsDetailCount: Caption := FText+IntToStr(ParentReport.RecordCount);
    qrsDetailNo : Caption := FText+IntToStr(ParentReport.RecordNumber);
  end;
  inherited Print(OfsX,OfsY);
end;

procedure TQRSysData.CreateCaption;
begin
  case FData of
    qrsTime : Caption := FText+'('+LoadStr(SqrTime)+')';
    qrsDate : Caption := FText+'('+LoadStr(SqrDate)+')';
    qrsDateTime : Caption := FText+'('+LoadStr(SqrDateTime)+')';
    qrsPageNumber : Caption := FText+'('+LoadStr(SqrPageNum)+')';
    qrsReportTitle: Caption := FText+'('+LoadStr(SqrReportTitle)+')';
    qrsDetailCount: Caption := FText+'('+LoadStr(SqrDetailCount)+')';
    qrsDetailNo : Caption := Ftext+'('+LoadStr(SqrDetailNo)+')';
  end;
  Invalidate;
end;

procedure TQRSysData.SetData(Value : TQRSysDataType);
begin
  FData := Value;
  CreateCaption;
end;

procedure TQRSysData.SetText(Value : String);
begin
  FText := Value;
  CreateCaption;
end;

{ TQRShape }

constructor TQRShape.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  width := 65;
  Height := 65;
  FPen := TPen.Create;
  FBrush := TBrush.Create;
  FBrush.OnChange := StyleChanged;
  FPen.OnChange := StyleChanged;
end;

procedure TQRShape.DefineProperties(Filer: TFiler);
begin
  Filer.DefineProperty('Visible', ReadVisible, WriteDummy, false); { <-- do not resource }
  inherited DefineProperties(Filer);
end;

procedure TQRShape.ReadVisible(Reader : TReader);
begin
  Enabled := Reader.ReadBoolean;
end;

procedure TQRShape.WriteDummy(Writer : TWriter);
begin
end;

procedure TQRShape.StyleChanged(Sender : TObject);
begin
  invalidate;
end;

procedure TQRShape.SetShape(Value : TQRShapeType);
begin
  if FShape <> value then
  begin
    FShape := Value;
    Invalidate;
  end
end;

procedure TQRShape.SetBrush(Value : TBrush);
begin
  FBrush.Assign(Value);
end;

procedure TQRShape.SetPen(Value : TPen);
begin
  FPen.Assign(value);
end;

procedure TQRShape.Paint;
begin
  inherited paint;
  with Canvas do
  begin
    Pen := FPen;
    Brush := FBrush;
    Case FShape of
      qrsRectangle : Rectangle(0,0,Width,Height);
      qrsCircle : Ellipse(0,0,Width,Height);
      qrsHorLine : begin
          MoveTo(0,Height div 2);
          LineTo(Width,Height div 2);
        end;
      qrsVertLine : begin
          MoveTo(Width div 2,0);
          LineTo(Width div 2,Height);
        end;
      qrsTopAndBottom : begin
          MoveTo(0,0);
          LineTo(Width,0);
          MoveTo(0,Height-1);
          LineTo(Width,Height-1);
        end;
      qrsRightAndLeft : begin
          MoveTo(0,0);
          LineTo(0,Height);
          MoveTo(Width-1,0);
          LineTo(Width-1,Height);
        end
    end
  end
end;

procedure TQRShape.Print(OfsX,OfsY : Integer);
begin
  if ParentReport.FinalPass then
  begin
    QRPrinter.Canvas.Brush := Brush;
    QRPrinter.Canvas.Pen := Pen;
    with QRPrinter do
    begin
      with Canvas do
      begin
        case FShape of
          qrsRectangle : Rectangle(XPos(OfsX + Size.Left), YPos(OfsY + Size.Top),
            XPos(OfsX+Size.Left + Size.Width), YPos(OfsY + Size.Top + Size.Height));
          qrsCircle : Ellipse(XPos(OfsX + Size.Left), YPos(OfsY + Size.Top),
            XPos(OfsX+Size.Left + Size.Width), YPos(OfsY + Size.Top + Size.Height));
          qrsHorLine : begin
              MoveTo(XPos(OfsX + Size.Left), YPos(OfsY + Size.Top + Size.Height / 2));
              LineTo(XPos(OfsX + Size.Left + Size.Width),YPos(OfsY + Size.Top + Size.Height/2));
            end;
          qrsVertLine : begin
              MoveTo(XPos(OfsX+Size.Left + Size.Width / 2), YPos(OfsY + Size.Top));
              LineTo(XPos(OfsX+Size.Left + Size.Width / 2), Ypos(OfsY + Size.Height + Size.Top));
            end;
          qrsTopAndBottom : begin
              MoveTo(XPos(OfsX + Size.Left), YPos(OfsY + Size.Top));
              LineTo(Xpos(OfsX + Size.Left + Size.Width), YPos(OfsY + Size.Top));
              MoveTo(Xpos(OfsX + Size.Left), YPos(OfsY + Size.Top + Size.Height));
              LineTo(Xpos(OfsX + Size.Left + Size.Width), Ypos(OfsY + Size.Top + Size.Height));
            end;
          qrsRightAndLeft : Begin
              MoveTo(XPos(OfsX + Size.Left), YPos(OfsY + Size.Top));
              LineTo(Xpos(OfsX + Size.Left), YPos(OfsY + Size.Top + Size.Height));
              MoveTo(XPos(OfsX + Size.Left + Size.Width), YPos(OfsY + Size.Top));
              LineTo(XPos(OfsX + Size.Left + Size.Width), YPos(OfsY + Size.Top + Size.Height));
            end
        end
      end
    end
  end
end;

destructor TQRShape.Destroy;
begin
  FPen.Free;
  FBrush.Free;
  inherited Destroy;
end;

{ TQRImage }

{$ifndef win32}
  procedure PrintBitmap(aCanvas : TCanvas; Dest : TRect; Bitmap : TBitmap);
  var
    Info : PBitmapInfo;
    InfoSize : integer;
    Image : Pointer;
    ImageSize : longint;
  begin
    with Bitmap do
    begin
      GetDIBSizes(Handle, InfoSize, ImageSize);
      try
        Info := MemAlloc(InfoSize);
        try
          Image := MemAlloc(ImageSize);
          GetDIB(Handle, Palette, Info^, Image^);
          with Info^.bmiHeader do
            StretchDIBits(aCanvas.Handle, Dest.Left, Dest.Top,
              Dest.RIght - Dest.Left, Dest.Bottom - Dest.Top,
              0, 0, biWidth, biHeight, Image, Info^, DIB_RGB_COLORS, SRCCOPY);
        finally
          FreeMem(Image, ImageSize);
        end;
      finally
        FreeMem(Info, InfoSize);
      end;
    end;
  end;
{$endif}

constructor TQRImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPicture := TPicture.Create;
  FPicture.OnChange := PictureChanged;
  Height := 105;
  Width := 105;
end;

destructor TQRImage.Destroy;
begin
  FPicture.Free;
  inherited Destroy;
end;

function TQRImage.GetPalette: HPALETTE;
begin
  Result := 0;
  if FPicture.Graphic is TBitmap then
    Result := TBitmap(FPicture.Graphic).Palette;
end;

procedure TQRImage.Paint;
var
  Dest: TRect;
begin
  if csDesigning in ComponentState then
    with inherited Canvas do
    begin
      Pen.Style := psDash;
      Brush.Style := bsClear;
      Rectangle(0, 0, Width, Height);
    end;
  if Stretch then
    Dest := ClientRect
  else if Center then
    Dest := Bounds((Width - Picture.Width) div 2, (Height - Picture.Height) div 2,
      Picture.Width, Picture.Height)
  else
    Dest := Rect(0, 0, Picture.Width, Picture.Height);
  if Zoom <> 100 then
  begin
    Dest.Right := Dest.Left + (Dest.Right - Dest.Left) * Zoom div 100;
    Dest.Bottom := Dest.Top + (Dest.Bottom - Dest.Top) * Zoom div 100;
  end;
  with inherited Canvas do
    StretchDraw(Dest, Picture.Graphic);
end;

procedure TQRImage.Print(OfsX,OfsY : Integer);
var
  Dest : TRect;
  DC, SavedDC : THandle;
begin
  Dest.Top := QRPrinter.YPos(OfsY + Size.Top);
  Dest.Left := QRPrinter.XPos(OfsX + Size.Left);
  Dest.Right := QRPrinter.XPos(OfsX + Size.Width + Size.Left);
  Dest.Bottom := QRPrinter.YPos(OfsY + Size.Height + Size.Top);
  if Stretch then
  begin
{$ifdef win32}
    with QRPrinter.Canvas do
      StretchDraw(Dest,Picture.Graphic);
{$else}
    if Picture.Graphic is TBitmap then
      PrintBitmap(QRPrinter.Canvas, Dest, TBitmap(Picture.Graphic))
    else
      with QRPrinter.Canvas do
        StretchDraw(Dest, Picture.Graphic);
{$endif}
  end else
  begin
    IntersectClipRect(QRPrinter.Canvas.Handle, Dest.Left, Dest.Top, Dest.Right, Dest.Bottom);
    DC := QRPrinter.Canvas.Handle;
    SavedDC := SaveDC(DC);
    Dest.Right := Dest.Left +
      round(Picture.Width / Screen.PixelsPerInch * 254 * ParentReport.QRPrinter.XFactor);
    Dest.Bottom := Dest.Top +
      round(Picture.Height / Screen.PixelsPerInch * 254 * ParentReport.QRPrinter.YFactor);
    if Center then OffsetRect(Dest,
      (QRPrinter.XSize(Size.Width) -
        round(Picture.Width / Screen.PixelsPerInch * 254 * ParentReport.QRPrinter.XFactor)) div 2,
      (QRPrinter.YSize(Size.Height) -
        round(Picture.Height / Screen.PixelsPerInch * 254 * ParentReport.QRPrinter.YFactor)) div 2);
{$ifdef win32}
    QRPrinter.Canvas.StretchDraw(Dest, Picture.Graphic);
{$else}
    if Picture.Graphic is TBitmap then
      PrintBitmap(QRPrinter.Canvas, Dest, TBitmap(Picture.Graphic))
    else
      QRPrinter.Canvas.StretchDraw(Dest, Picture.Graphic);
{$endif}
   RestoreDC(DC, SavedDC);
   SelectClipRgn(QRPrinter.Canvas.Handle, 0);
  end;
end;

function TQRImage.GetCanvas: TCanvas;
var
  Bitmap: TBitmap;
begin
  if Picture.Graphic = nil then
  begin
    Bitmap := TBitmap.Create;
    try
      Bitmap.Width := Width;
      Bitmap.Height := Height;
      Picture.Graphic := Bitmap;
    finally
      Bitmap.Free;
    end;
  end;
  if Picture.Graphic is TBitmap then
    Result := TBitmap(Picture.Graphic).Canvas
  else
    Result := nil;
{    raise EInvalidOperation.CreateRes(SImageCanvasNeedsBitmap)};
end;

procedure TQRImage.SetAutoSize(Value: Boolean);
begin
  FAutoSize := Value;
  PictureChanged(Self);
end;

procedure TQRImage.SetCenter(Value: Boolean);
begin
  if FCenter <> Value then
  begin
    FCenter := Value;
    PictureChanged(Self);
  end;
end;

procedure TQRImage.SetPicture(Value: TPicture);
begin
  FPicture.Assign(Value);
end;

procedure TQRImage.SetStretch(Value: Boolean);
begin
  if Value <> FStretch then
  begin
    FStretch := Value;
    PictureChanged(Self);
  end;
end;

procedure TQRImage.PictureChanged(Sender: TObject);
begin
  if AutoSize and (Picture.Width > 0) and (Picture.Height > 0) then
    SetBounds(Left, Top, Picture.Width, Picture.Height);
  if (Picture.Graphic is TBitmap) and (Picture.Width >= Width) and
    (Picture.Height >= Height) then
    ControlStyle := ControlStyle + [csOpaque] else
    ControlStyle := ControlStyle - [csOpaque];
  Invalidate;
end;

{ TQRDBImage }

constructor TQRDBImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csFramed, csOpaque];
  Width := 105;
  Height := 105;
  FPicture := TPicture.Create;
  FPicture.OnChange := PictureChanged;
  FCenter := True;
end;

destructor TQRDBImage.Destroy;
begin
  FPicture.Free;
  inherited Destroy;
end;

procedure TQRDBImage.Prepare;
begin
  inherited Prepare;
  if assigned(FDataSet) then
  begin
    FField := DataSet.FindField(FDataField);
    if Field is TBlobField then
    begin
      Caption := '';
    end;
  end else
    FField := nil;
end;

procedure TQRDBImage.Print(OfsX, OfsY : integer);
var
  H: integer;
  Dest: TRect;
  DrawPict: TPicture;
begin
  with QRPrinter.Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Color;
    DrawPict := TPicture.Create;
    H := 0;
    try
      if assigned(FField) and (FField is TBlobField) then
      begin
        DrawPict.Assign(FField);
        if (DrawPict.Graphic is TBitmap) and
          (DrawPict.Bitmap.Palette <> 0) then
        begin
          H := SelectPalette(Handle, DrawPict.Bitmap.Palette, false);
          RealizePalette(Handle);
        end;
        Dest.Left := QRPrinter.XPos(OfsX + Size.Left);
        Dest.Top := QRPrinter.YPos(OfsY + Size.Top);
        Dest.Right := QRPrinter.XPos(OfsX + Size.Width + Size.Left);
        Dest.Bottom := QRPrinter.YPos(OfsY + Size.Height + Size.Top);
        if Stretch then
        begin
          if (DrawPict.Graphic = nil) or DrawPict.Graphic.Empty then
            FillRect(Dest)
          else
{$ifdef win32}
            with QRPrinter.Canvas do
              StretchDraw(Dest,Picture.Graphic);
{$else}
            if Picture.Graphic is TBitmap then
              PrintBitmap(QRPrinter.Canvas, Dest, TBitmap(Picture.Graphic))
            else
              with QRPrinter.Canvas do
                StretchDraw(Dest, Picture.Graphic);
{$endif}
        end else
        begin
          IntersectClipRect(Handle, Dest.Left, Dest.Top, Dest.Right, Dest.Bottom);
          Dest.Right := Dest.Left +
            round(DrawPict.Width / Screen.PixelsPerInch * 254 * ParentReport.QRPrinter.XFactor);
          Dest.Bottom := Dest.Top +
            round(DrawPict.Height / Screen.PixelsPerInch * 254 * ParentReport.QRPrinter.YFactor);
          if Center then OffsetRect(Dest,
            (QRPrinter.XSize(Size.Width) -
              round(DrawPict.Width / Screen.PixelsPerInch * 254 * ParentReport.QRPrinter.XFactor)) div 2,
            (QRPrinter.YSize(Size.Height) -
              round(DrawPict.Height / Screen.PixelsPerInch * 254 * ParentReport.QRPrinter.YFactor)) div 2);
{$ifdef win32}
          QRPrinter.Canvas.StretchDraw(Dest, DrawPict.Graphic);
{$else}
          if DrawPict.Graphic is TBitmap then
            PrintBitmap(QRPrinter.Canvas, Dest, TBitmap(DrawPict.Graphic))
          else
            QRPrinter.Canvas.StretchDraw(Dest, DrawPict.Graphic);
{$endif}
          SelectClipRgn(Handle, 0);
        end;
      end;
    finally
      if H <> 0 then SelectPalette(Handle, H, True);
      DrawPict.Free;
    end;
  end;
  inherited Print(OfsX,OfsY);
end;

procedure TQRDBImage.Unprepare;
begin
  FField := nil;
  inherited Unprepare;
end;

procedure TQRDBImage.SetDataSet(Value: TDataSet);
begin
  FDataSet := Value;
{$ifdef win32}
  if Value <> nil then Value.FreeNotification(Self);
{$endif}
end;

procedure TQRDBImage.SetDataField(const Value: string);
begin
  FDataField := Value;
end;

function TQRDBImage.GetPalette: HPALETTE;
begin
  Result := 0;
  if FPicture.Graphic is TBitmap then
    Result := TBitmap(FPicture.Graphic).Palette;
end;

procedure TQRDBImage.SetCenter(Value: Boolean);
begin
  if FCenter <> Value then
  begin
    FCenter := Value;
    Invalidate;
  end;
end;

procedure TQRDBImage.SetPicture(Value: TPicture);
begin
  FPicture.Assign(Value);
end;

procedure TQRDBImage.SetStretch(Value: Boolean);
begin
  if FStretch <> Value then
  begin
    FStretch := Value;
    Invalidate;
  end;
end;

procedure TQRDBImage.Paint;
var
  W, H: Integer;
  R: TRect;
  S: string;
begin
  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Color;
    Font := Self.Font;
    if Field <> nil then
      S := Field.DisplayLabel
    else S := Name;
    S := '(' + S + ')';
    W := TextWidth(S);
    H := TextHeight(S);
    R := ClientRect;
    TextRect(R, (R.Right - W) div 2, (R.Bottom - H) div 2, S);
  end;
  Inherited Paint;
end;

procedure TQRDBImage.PictureChanged(Sender: TObject);
begin
  FPictureLoaded := True;
  Invalidate;
end;

procedure TQRDBImage.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = DataSet) then
    DataSet := nil;
end;

procedure TQRDBImage.LoadPicture;
begin
  if not FPictureLoaded and (Field is TBlobField) then
    Picture.Assign(FField);
end;

{$ifdef win32}

{ TQRCusomRichText }

constructor TQRCustomRichText.Create(AOwner : TComponent);
begin
  FRichEdit := nil;
  inherited Create(AOwner);
  FRichEdit := TQRRichEdit.Create(Self);
  FRichEdit.Parent := self;
  FRichEdit.BorderStyle := bsNone;
  AutoStretch := false;
  Width := 100;
  Height := 100;
end;

destructor TQRCustomRichText.Destroy;
begin
  FRichEdit.Free;
  inherited Destroy;
end;

function TQRCustomRichText.GetAlignment : TAlignment;
begin
  result := FRichEdit.Alignment;
end;

function TQRCustomRichText.GetColor : TColor;
begin
  result := FRichEdit.Color;
end;

function TQRCustomRichText.GetFont : TFont;
begin
  result := FRichEdit.Font;
end;

function TQRCustomRichText.GetLines : TStrings;
begin
  result := FRichEdit.Lines;
end;

procedure TQRCustomRichText.Print(OfsX, OfsY : integer);
var
  Range: TFormatRange;
  LastChar, MaxLen, LogX, LogY: Integer;
  ARichEdit : TCustomRichEdit;
  ChangeX, Y : extended;
  VSize : extended;
begin
  if assigned(FParentRichEdit) then
    ARichEdit := ParentRichEdit
  else
    ARichEdit := FRichEdit;
  FillChar(Range, SizeOf(TFormatRange), 0);
  with Range do
  begin
    hdc := ParentReport.QRPrinter.Canvas.Handle;
    hdcTarget := hdc;
    LogX := GetDeviceCaps(hdc, LOGPIXELSX);
    LogY := GetDeviceCaps(hdc, LOGPIXELSY);
    rc.Left := QRPrinter.XPos(OfsX + Size.Left)* 1440 div LogX;
    rc.Top := QRPrinter.YPos(OfsY + Size.Top) * 1440 div LogY;
    rc.Right := QRPrinter.XPos(OfsX + Size.Width + Size.Left) *1440 div LogX;
    rc.Bottom := QRPrinter.YPos(OfsY + Size.Height + Size.Top) * 1440 div LogY;
    rcPage := rc;
    LastChar := 0;
    MaxLen := ARichEdit.GetTextLen;
    chrg.cpMax := -1;
    chrg.cpMin := LastChar;
    Y := OfsY + Size.Top;
    VSize := OfsY+Size.Top + Size.Height;
    if AutoStretch then
    begin
      LastChar := SendMessage(ARichEdit.Handle, EM_FORMATRANGE, 0, Longint(@Range));
      while (LastChar < MaxLen) and (LastChar <> -1) do
      begin
        if TQRCustomBand(Parent).CanExpand(50) then
        begin
          TQRCustomBand(Parent).ExpandBand(50, Y, ChangeX);
          VSize := VSize + 50;
          rc.Bottom := QRPrinter.YPos(VSize) * 1440 div LogY;
          LastChar := SendMessage(ARichEdit.Handle, EM_FORMATRANGE, 0, Longint(@Range));
          if (LastChar >= MaxLen) or (LastChar = -1) then
          begin
            LastChar := SendMessage(ARichEdit.Handle, EM_FORMATRANGE, 1, Longint(@Range));
            chrg.cpMin := LastChar;
          end;
        end else
        begin
          LastChar := SendMessage(ARichEdit.Handle, EM_FORMATRANGE, 1, Longint(@Range));
          TQRCustomBand(Parent).ExpandBand(50, Y, ChangeX);
          VSize := Y + 50;
          rc.Top := QRPrinter.YPos(Y) * 1440 div LogY;
          rc.Bottom := QRPrinter.YPos(VSize) * 1440 div LogY;
          rc.Left := rc.Left + QRPrinter.XSize(ChangeX) * 1440 div LogX;
          rc.Right := rc.Right + QRPrinter.XSize(ChangeX) * 1440 div LogX;
          chrg.cpMin := LastChar;
          hdc := ParentReport.QRPrinter.Canvas.Handle;
          hdcTarget := hdc;
         end;
      end;
    end else
      SendMessage(ARichEdit.Handle, EM_FORMATRANGE, 1, Longint(@Range));
  end;
  SendMessage(FRichEdit.Handle, EM_FORMATRANGE, 0, 0);
end;

procedure TQRCustomRichText.SetAlignment(Value : TAlignment);
begin
  FRichEdit.Alignment := Value;
end;

procedure TQRCustomRichText.SetColor(Value : TColor);
begin
  FRichEdit.Color := Value;
end;

procedure TQRCustomRichText.SetFont(Value : TFont);
begin
  FRichEdit.Font := Value;
end;

procedure TQRCustomRichText.SetBounds(ALeft, ATop, AWidth, AHeight : integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  if FRichEdit <> nil then FRichEdit.SetBounds(1, 1, AWidth - 2, AHeight - 2);
end;

procedure TQRCustomRichText.SetLines(Value : TStrings);
begin
  FRichEdit.Lines := Value;
  if assigned(FParentRichEdit) then
    FParentRichEdit.Lines := Value;
end;

procedure TQRCustomRichText.SetParentRichEdit(Value : TRichEdit);
begin
  FParentRichEdit := Value;
  if Value<>nil then
    FRichEdit.Lines := Value.Lines;
end;

{ TQRDBRichText }

procedure TQRDBRichText.SetDataSet(Value : TDataSet);
begin
  FDataSet := Value;
{$ifdef win32}
  if Value<>nil then
    Value.FreeNotification(self);
{$endif}
end;

procedure TQRDBRichText.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
    if AComponent=FDataSet then
      FDataSet := nil;
end;

procedure TQRDBRichText.Prepare;
begin
  inherited Prepare;
  if assigned(FDataSet) then
  begin
    Field := FDataSet.FindField(FDataField);
    if (Field is TBlobField) or (Field is TMemoField) then
    begin
      Caption := '';
    end;
  end else
    Field := nil;
end;

procedure TQRDBRichText.Print(OfsX, OfsY : integer);
begin
  if assigned(Field) then
    if (Field is TMemoField) or
       (Field is TBlobField) then
      Lines.Assign(Field);
  inherited Print(OfsX,OfsY);
end;

procedure TQRDBRichText.Unprepare;
begin
  Field := nil;
  inherited Unprepare;
end;

{$ifdef notyet}

constructor TQROleCtrl.Create(AOwner : TComponent);
begin
  OleContainer := nil;
  inherited Create(AOwner);
  OleContainer := TOleContainer.Create(Self);
  with OleContainer do
  begin
    Parent := Self;
    Left := 1;
    Top := 1;
    BorderStyle := bsNone;
    Visible := false;
  end;
end;

destructor TQROleCtrl.Destroy;
begin
  OleContainer.Free;
  inherited Destroy;
end;

{$ifdef ver100}
procedure TQROleCtrl.GetChildren(Proc: TGetChildProc; Root : TComponent);
{$else}
procedure TQROleCtrl.GetChildren(Proc: TGetChildProc);
{$endif}
begin
  Proc(OleContainer);
end;

procedure TQROleCtrl.ReadState(Reader: TReader);
begin
  if OleContainer <> nil then
    OleContainer.Free;
  inherited ReadState(Reader);
end;

procedure TQROleCtrl.Paint;
var
  EMF : TMetafile;
begin
  inherited Paint;
  EMF := TMetafile.Create;
  EMF.Width := Width;
  EMF.Height := Height;
  with TMetafileCanvas.Create(EMF, 0) do
  try
    OleContainer.PaintTo(Handle, 0, 0);
  finally
    Free;
  end;
  Canvas.StretchDraw(ClientRect, EMF);
  EMF.Free;
end;

procedure TQROleCtrl.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  if OleContainer <> nil then
    OleContainer.SetBounds(0, 0, Width, Height);
end;

procedure TQROleCtrl.Edit;
begin
  with OleContainer do
    if not (State = osEmpty) then
      DoVerb(PrimaryVerb);
end;

procedure TQROleCtrl.New;
begin
  if OleContainer.InsertObjectDialog then Edit;
end;

procedure TQROleCtrl.Print(XOfs, YOfs : integer);
var
  EMF : TMetafile;
begin
  EMF := TMetafile.Create;
  EMF.Width := Width;
  EMF.Height := Height;
  with TMetafileCanvas.Create(EMF, 0) do
  try
    OleContainer.PaintTo(Handle, 0, 0);
  finally
    Free;
  end;
  with ParentReport.QRPrinter do
    Canvas.StretchDraw(Rect(XPos(XOfs + Size.Left),
                            YPos(YOfs+Size.Top),
                            XPos(XOfs+Size.Left+Size.Width),
                            YPos(YOfs+Size.Top+Size.Height)), EMF);
  EMF.Free;
end;

{$endif}

{$endif}

function TQRDBCalc.GetPrintMask : string;
begin
  Result := Mask;
end;

procedure TQRDBCalc.SetDataField(Value : string);
begin
  FDataField := Value;
  SetOperation(Operation);
end;

procedure TQRDBCalc.SetOperation(Value : TQRCalcOperation);
begin
  FOperation := Value;
  case FOperation of
    qrcSum : Expression := 'Sum('+DataField+')';         {<-- do not resource}
    qrcCount : Expression := 'Count';                    {<-- do not resource}
    qrcMax : Expression := 'Max('+DataField+')';         {<-- do not resource}
    qrcMin : Expression := 'Min('+DataField+')';         {<-- do not resource}
    qrcAverage : Expression := 'Average('+DataField+')'; {<-- do not resource}
  end
end;

procedure TQRDBCalc.SetPrintMask(Value : string);
begin
  Mask := Value;
end;

end.
