(* Based on ComCtrls.
  1) First, Copy from ComCtrls.
  2) Delete all classes except those classes
  that associated with TCustomRichEdit;
  3) Rename TCustomRichEdit, TRichEdit, TTTextAttributes and so on,
  get TCustomRichEdit2,TRichEdit2 and so on.
  4) Modify TCustomRichEdit2.CreateParams
procedure TCustomRichEdit2.CreateParams(var Params: TCreateParams);
const
  //RichEditModuleName = 'RICHED32.DLL';
  RichEditModuleName = 'RICHED20.DLL';
  HideScrollBars: array[Boolean] of DWORD = (ES_DISABLENOSCROLL, 0);
  HideSelections: array[Boolean] of DWORD = (ES_NOHIDESEL, 0);
var
  OldError: Longint;
begin
  OldError := SetErrorMode(SEM_NOOPENFILEERRORBOX);
  FLibHandle := LoadLibrary(RichEditModuleName);
  if (FLibHandle > 0) and (FLibHandle < HINSTANCE_ERROR) then FLibHandle := 0;
  SetErrorMode(OldError);
  inherited CreateParams(Params);
  CreateSubClass(Params, 'RICHEDIT20A');
  with Params do
  begin
    Style := Style or HideScrollBars[FHideScrollBars] or
      HideSelections[HideSelection];
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
  end;
end;
  5) Modify TRichEditStrings.Insert
procedure TRichEditStrings.Insert(Index: Integer; const S: string);
var
  L: Integer;
  Selection: TCharRange;
  Fmt: PChar;
  Str: string;
begin
  if Index >= 0 then
  begin
    Selection.cpMin := SendMessage(RichEdit.Handle, EM_LINEINDEX, Index, 0);
    if Selection.cpMin >= 0 then Fmt := '%s'#13#10
    else begin
      Selection.cpMin :=
        SendMessage(RichEdit.Handle, EM_LINEINDEX, Index - 1, 0);
      if Selection.cpMin < 0 then Exit;
      L := SendMessage(RichEdit.Handle, EM_LINELENGTH, Selection.cpMin, 0);
      if L = 0 then Exit;
      Inc(Selection.cpMin, L);
      Fmt := #13#10'%s';
    end;
    Selection.cpMax := Selection.cpMin;
    SendMessage(RichEdit.Handle, EM_EXSETSEL, 0, Longint(@Selection));
    Str := Format(Fmt, [S]);
    SendMessage(RichEdit.Handle, EM_REPLACESEL, 0, LongInt(PChar(Str)));
   { if RichEdit.SelStart <> (Selection.cpMax + Length(Str)) then
      raise EOutOfResources.Create(sRichEditInsertError);}
  end;
end;

*)

unit NewComCtrls;

{$R-}

interface

uses Messages, Windows, SysUtils, CommCtrl, Classes, Controls, Forms,
  Menus, Graphics, StdCtrls, RichEdit, ToolWin, ImgList, ExtCtrls;

type
  TCustomRichEdit2 = class;

  TAttributeType2 = (atSelected, atDefaultText);
  TConsistentAttribute2 = (caBold, caColor, caFace, caItalic,
    caSize, caStrikeOut, caUnderline, caProtected);
  TConsistentAttributes2 = set of TConsistentAttribute2;

  TTextAttributes2 = class(TPersistent)
  private
    RichEdit: TCustomRichEdit2;
    FType: TAttributeType2;
    procedure GetAttributes(var Format: TCharFormat);
    function GetCharset: TFontCharset;
    function GetColor: TColor;
    function GetConsistentAttributes: TConsistentAttributes2;
    function GetHeight: Integer;
    function GetName: TFontName;
    function GetPitch: TFontPitch;
    function GetProtected: Boolean;
    function GetSize: Integer;
    function GetStyle: TFontStyles;
    procedure SetAttributes(var Format: TCharFormat);
    procedure SetCharset(Value: TFontCharset);
    procedure SetColor(Value: TColor);
    procedure SetHeight(Value: Integer);
    procedure SetName(Value: TFontName);
    procedure SetPitch(Value: TFontPitch);
    procedure SetProtected(Value: Boolean);
    procedure SetSize(Value: Integer);
    procedure SetStyle(Value: TFontStyles);
  protected
    procedure InitFormat(var Format: TCharFormat);
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(AOwner: TCustomRichEdit2; AttributeType: TAttributeType2);
    procedure Assign(Source: TPersistent); override;
    property Charset: TFontCharset read GetCharset write SetCharset;
    property Color: TColor read GetColor write SetColor;
    property ConsistentAttributes: TConsistentAttributes2 read GetConsistentAttributes;
    property Name: TFontName read GetName write SetName;
    property Pitch: TFontPitch read GetPitch write SetPitch;
    property Protected: Boolean read GetProtected write SetProtected;
    property Size: Integer read GetSize write SetSize;
    property Style: TFontStyles read GetStyle write SetStyle;
    property Height: Integer read GetHeight write SetHeight;
  end;

{ TParaAttributes2 }

  TNumberingStyle2 = (nsNone, nsBullet);

  TParaAttributes2 = class(TPersistent)
  private
    RichEdit: TCustomRichEdit2;
    procedure GetAttributes(var Paragraph: TParaFormat);
    function GetAlignment: TAlignment;
    function GetFirstIndent: Longint;
    function GetLeftIndent: Longint;
    function GetRightIndent: Longint;
    function GetNumbering: TNumberingStyle2;
    function GetTab(Index: Byte): Longint;
    function GetTabCount: Integer;
    procedure InitPara(var Paragraph: TParaFormat);
    procedure SetAlignment(Value: TAlignment);
    procedure SetAttributes(var Paragraph: TParaFormat);
    procedure SetFirstIndent(Value: Longint);
    procedure SetLeftIndent(Value: Longint);
    procedure SetRightIndent(Value: Longint);
    procedure SetNumbering(Value: TNumberingStyle2);
    procedure SetTab(Index: Byte; Value: Longint);
    procedure SetTabCount(Value: Integer);
  public
    constructor Create(AOwner: TCustomRichEdit2);
    procedure Assign(Source: TPersistent); override;
    property Alignment: TAlignment read GetAlignment write SetAlignment;
    property FirstIndent: Longint read GetFirstIndent write SetFirstIndent;
    property LeftIndent: Longint read GetLeftIndent write SetLeftIndent;
    property Numbering: TNumberingStyle2 read GetNumbering write SetNumbering;
    property RightIndent: Longint read GetRightIndent write SetRightIndent;
    property Tab[Index: Byte]: Longint read GetTab write SetTab;
    property TabCount: Integer read GetTabCount write SetTabCount;
  end;


{ TCustomRichEdit2 }

  TRichEditResizeEvent = procedure(Sender: TObject; Rect: TRect) of object;
  TRichEditProtectChange = procedure(Sender: TObject;
    StartPos, EndPos: Integer; var AllowChange: Boolean) of object;
  TRichEditSaveClipboard = procedure(Sender: TObject;
    NumObjects, NumChars: Integer; var SaveClipboard: Boolean) of object;
  TSearchType = (stWholeWord, stMatchCase);
  TSearchTypes = set of TSearchType;

  TConversion = class(TObject)
  public
    function ConvertReadStream(Stream: TStream; Buffer: PChar; BufSize: Integer): Integer; virtual;
    function ConvertWriteStream(Stream: TStream; Buffer: PChar; BufSize: Integer): Integer; virtual;
  end;

  TConversionClass = class of TConversion;

  PConversionFormat = ^TConversionFormat;
  TConversionFormat = record
    ConversionClass: TConversionClass;
    Extension: string;
    Next: PConversionFormat;
  end;

  PRichEditStreamInfo = ^TRichEditStreamInfo;
  TRichEditStreamInfo = record
    Converter: TConversion;
    Stream: TStream;
  end;

  TCustomRichEdit2 = class(TCustomMemo)
  private
    FLibHandle: THandle;
    FHideScrollBars: Boolean;
    FSelAttributes: TTextAttributes2;
    FDefAttributes: TTextAttributes2;
    FParagraph: TParaAttributes2;
    FOldParaAlignment: TAlignment;
    FScreenLogPixels: Integer;
    FRichEditStrings: TStrings;
    FMemStream: TMemoryStream;
    FOnSelChange: TNotifyEvent;
    FHideSelection: Boolean;
    FModified: Boolean;
    FDefaultConverter: TConversionClass;
    FOnResizeRequest: TRichEditResizeEvent;
    FOnProtectChange: TRichEditProtectChange;
    FOnSaveClipboard: TRichEditSaveClipboard;
    FPageRect: TRect;
    procedure CMBiDiModeChanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
    function GetPlainText: Boolean;
    function ProtectChange(StartPos, EndPos: Integer): Boolean;
    function SaveClipboard(NumObj, NumChars: Integer): Boolean;
    procedure SetHideScrollBars(Value: Boolean);
    procedure SetHideSelection(Value: Boolean);
    procedure SetPlainText(Value: Boolean);
    procedure SetRichEditStrings(Value: TStrings);
    procedure SetDefAttributes(Value: TTextAttributes2);
    procedure SetSelAttributes(Value: TTextAttributes2);
    procedure WMNCDestroy(var Message: TWMNCDestroy); message WM_NCDESTROY;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SETCURSOR;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMSetFont(var Message: TWMSetFont); message WM_SETFONT;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure RequestSize(const Rect: TRect); virtual;
    procedure SelectionChange; dynamic;
    procedure DoSetMaxLength(Value: Integer); override;
    function GetCaretPos: TPoint; override;
    function GetSelLength: Integer; override;
    function GetSelStart: Integer; override;
    function GetSelText: string; override;
    procedure SetSelLength(Value: Integer); override;
    procedure SetSelStart(Value: Integer); override;
    property HideSelection: Boolean read FHideSelection write SetHideSelection default True;
    property HideScrollBars: Boolean read FHideScrollBars
      write SetHideScrollBars default True;
    property Lines: TStrings read FRichEditStrings write SetRichEditStrings;
    property OnSaveClipboard: TRichEditSaveClipboard read FOnSaveClipboard
      write FOnSaveClipboard;
    property OnSelectionChange: TNotifyEvent read FOnSelChange write FOnSelChange;
    property OnProtectChange: TRichEditProtectChange read FOnProtectChange
      write FOnProtectChange;
    property OnResizeRequest: TRichEditResizeEvent read FOnResizeRequest
      write FOnResizeRequest;
    property PlainText: Boolean read GetPlainText write SetPlainText default False;
  public
    DebugLength : integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear; override;
    function FindText(const SearchStr: string;
      StartPos, Length: Integer; Options: TSearchTypes): Integer;
    function GetSelTextBuf(Buffer: PChar; BufSize: Integer): Integer; override;
    procedure Print(const Caption: string); virtual;
    class procedure RegisterConversionFormat(const AExtension: string;
      AConversionClass: TConversionClass);
    property DefaultConverter: TConversionClass
      read FDefaultConverter write FDefaultConverter;
    property DefAttributes: TTextAttributes2 read FDefAttributes write SetDefAttributes;
    property SelAttributes: TTextAttributes2 read FSelAttributes write SetSelAttributes;
    property PageRect: TRect read FPageRect write FPageRect;
    property Paragraph: TParaAttributes2 read FParagraph;
  end;

  TRichEdit2 = class(TCustomRichEdit2)
  published
    property Align;
    property Alignment;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property BorderWidth;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property HideScrollBars;
    property ImeMode;
    property ImeName;
    property Constraints;
    property Lines;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PlainText;
    property PopupMenu;
    property ReadOnly;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property WantTabs;
    property WantReturns;
    property WordWrap;
    property OnChange;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnProtectChange;
    property OnResizeRequest;
    property OnSaveClipboard;
    property OnSelectionChange;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

uses Printers, Consts, ComStrs, ActnList, StdActns;

const
  SectionSizeArea = 8;
  RTFConversionFormat: TConversionFormat = (
    ConversionClass: TConversion;
    Extension: 'rtf';
    Next: nil);
  TextConversionFormat: TConversionFormat = (
    ConversionClass: TConversion;
    Extension: 'txt';
    Next: @RTFConversionFormat);
  ShellDllName = 'shell32.dll';
  ComCtlDllName = 'comctl32.dll';

var
  ConversionFormatList: PConversionFormat = @TextConversionFormat;
  ShellModule: THandle;
  ComCtlVersion: Integer;

function InitCommonControl(CC: Integer): Boolean;
var
  ICC: TInitCommonControlsEx;
begin
  ICC.dwSize := SizeOf(TInitCommonControlsEx);
  ICC.dwICC := CC;
  Result := InitCommonControlsEx(ICC);
  if not Result then InitCommonControls;
end;

procedure CheckCommonControl(CC: Integer);
begin
  if not InitCommonControl(CC) then
    raise EComponentError.Create(SInvalidComCtl32);
end;

function GetShellModule: THandle;
var
  OldError: Longint;
begin
  if ShellModule = 0 then
  begin
    OldError := SetErrorMode(SEM_NOOPENFILEERRORBOX);
    ShellModule := GetModuleHandle(ShellDllName);
    if ShellModule < HINSTANCE_ERROR then
      ShellModule := LoadLibrary(ShellDllName);
    if (ShellModule > 0) and (ShellModule < HINSTANCE_ERROR) then
      ShellModule := 0;
    SetErrorMode(OldError);
  end;
  Result := ShellModule;
end;

function GetComCtlVersion: Integer;
var
  FileName: string;
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
begin
  if ComCtlVersion = 0 then
  begin
    FileName := ComCtlDllName;
    InfoSize := GetFileVersionInfoSize(PChar(FileName), Wnd);
    if InfoSize <> 0 then
    begin
      GetMem(VerBuf, InfoSize);
      try
        if GetFileVersionInfo(PChar(FileName), Wnd, InfoSize, VerBuf) then
          if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
            ComCtlVersion := FI.dwFileVersionMS;
      finally
        FreeMem(VerBuf);
      end;
    end;
  end;
  Result := ComCtlVersion;
end;


procedure SetComCtlStyle(Ctl: TWinControl; Value: Integer; UseStyle: Boolean);
var
  Style: Integer;
begin
  if Ctl.HandleAllocated then
  begin
    Style := GetWindowLong(Ctl.Handle, GWL_STYLE);
    if not UseStyle then Style := Style and not Value
    else Style := Style or Value;
    SetWindowLong(Ctl.Handle, GWL_STYLE, Style);
  end;
end;


{ TTextAttributes2 }

constructor TTextAttributes2.Create(AOwner: TCustomRichEdit2;
  AttributeType: TAttributeType2);
begin
  inherited Create;
  RichEdit := AOwner;
  FType := AttributeType;
end;

procedure TTextAttributes2.InitFormat(var Format: TCharFormat);
begin
  FillChar(Format, SizeOf(TCharFormat), 0);
  Format.cbSize := SizeOf(TCharFormat);
end;

function TTextAttributes2.GetConsistentAttributes: TConsistentAttributes2;
var
  Format: TCharFormat;
begin
  Result := [];
  if RichEdit.HandleAllocated and (FType = atSelected) then
  begin
    InitFormat(Format);
    SendMessage(RichEdit.Handle, EM_GETCHARFORMAT,
      WPARAM(FType = atSelected), LPARAM(@Format));
    with Format do
    begin
      if (dwMask and CFM_BOLD) <> 0 then Include(Result, caBold);
      if (dwMask and CFM_COLOR) <> 0 then Include(Result, caColor);
      if (dwMask and CFM_FACE) <> 0 then Include(Result, caFace);
      if (dwMask and CFM_ITALIC) <> 0 then Include(Result, caItalic);
      if (dwMask and CFM_SIZE) <> 0 then Include(Result, caSize);
      if (dwMask and CFM_STRIKEOUT) <> 0 then Include(Result, caStrikeOut);
      if (dwMask and CFM_UNDERLINE) <> 0 then Include(Result, caUnderline);
      if (dwMask and CFM_PROTECTED) <> 0 then Include(Result, caProtected);
    end;
  end;
end;

procedure TTextAttributes2.GetAttributes(var Format: TCharFormat);
begin
  InitFormat(Format);
  if RichEdit.HandleAllocated then
    SendMessage(RichEdit.Handle, EM_GETCHARFORMAT,
      WPARAM(FType = atSelected), LPARAM(@Format));
end;

procedure TTextAttributes2.SetAttributes(var Format: TCharFormat);
var
  Flag: Longint;
begin
  if FType = atSelected then Flag := SCF_SELECTION
  else Flag := 0;
  if RichEdit.HandleAllocated then
    SendMessage(RichEdit.Handle, EM_SETCHARFORMAT, Flag, LPARAM(@Format))
end;

function TTextAttributes2.GetCharset: TFontCharset;
var
  Format: TCharFormat;
begin
  GetAttributes(Format);
  Result := Format.bCharset;
end;

procedure TTextAttributes2.SetCharset(Value: TFontCharset);
var
  Format: TCharFormat;
begin
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_CHARSET;
    bCharSet := Value;
  end;
  SetAttributes(Format);
end;

function TTextAttributes2.GetProtected: Boolean;
var
  Format: TCharFormat;
begin
  GetAttributes(Format);
  with Format do
    if (dwEffects and CFE_PROTECTED) <> 0 then
      Result := True else
      Result := False;
end;

procedure TTextAttributes2.SetProtected(Value: Boolean);
var
  Format: TCharFormat;
begin
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_PROTECTED;
    if Value then dwEffects := CFE_PROTECTED;
  end;
  SetAttributes(Format);
end;

function TTextAttributes2.GetColor: TColor;
var
  Format: TCharFormat;
begin
  GetAttributes(Format);
  with Format do
    if (dwEffects and CFE_AUTOCOLOR) <> 0 then
      Result := clWindowText else
      Result := crTextColor;
end;

procedure TTextAttributes2.SetColor(Value: TColor);
var
  Format: TCharFormat;
begin
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_COLOR;
    if Value = clWindowText then
      dwEffects := CFE_AUTOCOLOR else
      crTextColor := ColorToRGB(Value);
  end;
  SetAttributes(Format);
end;

function TTextAttributes2.GetName: TFontName;
var
  Format: TCharFormat;
begin
  GetAttributes(Format);
  Result := Format.szFaceName;
end;

procedure TTextAttributes2.SetName(Value: TFontName);
var
  Format: TCharFormat;
begin
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_FACE;
    StrPLCopy(szFaceName, Value, SizeOf(szFaceName));
  end;
  SetAttributes(Format);
end;

function TTextAttributes2.GetStyle: TFontStyles;
var
  Format: TCharFormat;
begin
  Result := [];
  GetAttributes(Format);
  with Format do
  begin
    if (dwEffects and CFE_BOLD) <> 0 then Include(Result, fsBold);
    if (dwEffects and CFE_ITALIC) <> 0 then Include(Result, fsItalic);
    if (dwEffects and CFE_UNDERLINE) <> 0 then Include(Result, fsUnderline);
    if (dwEffects and CFE_STRIKEOUT) <> 0 then Include(Result, fsStrikeOut);
  end;
end;

procedure TTextAttributes2.SetStyle(Value: TFontStyles);
var
  Format: TCharFormat;
begin
  InitFormat(Format);
  with Format do
  begin
    dwMask := CFM_BOLD or CFM_ITALIC or CFM_UNDERLINE or CFM_STRIKEOUT;
    if fsBold in Value then dwEffects := dwEffects or CFE_BOLD;
    if fsItalic in Value then dwEffects := dwEffects or CFE_ITALIC;
    if fsUnderline in Value then dwEffects := dwEffects or CFE_UNDERLINE;
    if fsStrikeOut in Value then dwEffects := dwEffects or CFE_STRIKEOUT;
  end;
  SetAttributes(Format);
end;

function TTextAttributes2.GetSize: Integer;
var
  Format: TCharFormat;
begin
  GetAttributes(Format);
  Result := Format.yHeight div 20;
end;

procedure TTextAttributes2.SetSize(Value: Integer);
var
  Format: TCharFormat;
begin
  InitFormat(Format);
  with Format do
  begin
    dwMask := Integer(CFM_SIZE);
    yHeight := Value * 20;
  end;
  SetAttributes(Format);
end;

function TTextAttributes2.GetHeight: Integer;
begin
  Result := MulDiv(Size, RichEdit.FScreenLogPixels, 72);
end;

procedure TTextAttributes2.SetHeight(Value: Integer);
begin
  Size := MulDiv(Value, 72, RichEdit.FScreenLogPixels);
end;

function TTextAttributes2.GetPitch: TFontPitch;
var
  Format: TCharFormat;
begin
  GetAttributes(Format);
  case (Format.bPitchAndFamily and $03) of
    DEFAULT_PITCH: Result := fpDefault;
    VARIABLE_PITCH: Result := fpVariable;
    FIXED_PITCH: Result := fpFixed;
  else
    Result := fpDefault;
  end;
end;

procedure TTextAttributes2.SetPitch(Value: TFontPitch);
var
  Format: TCharFormat;
begin
  InitFormat(Format);
  with Format do
  begin
    case Value of
      fpVariable: Format.bPitchAndFamily := VARIABLE_PITCH;
      fpFixed: Format.bPitchAndFamily := FIXED_PITCH;
    else
      Format.bPitchAndFamily := DEFAULT_PITCH;
    end;
  end;
  SetAttributes(Format);
end;

procedure TTextAttributes2.Assign(Source: TPersistent);
begin
  if Source is TFont then
  begin
    Color := TFont(Source).Color;
    Name := TFont(Source).Name;
    Charset := TFont(Source).Charset;
    Style := TFont(Source).Style;
    Size := TFont(Source).Size;
    Pitch := TFont(Source).Pitch;
  end
  else if Source is TTextAttributes2 then
  begin
    Color := TTextAttributes2(Source).Color;
    Name := TTextAttributes2(Source).Name;
    Charset := TTextAttributes2(Source).Charset;
    Style := TTextAttributes2(Source).Style;
    Pitch := TTextAttributes2(Source).Pitch;
  end
  else inherited Assign(Source);
end;

procedure TTextAttributes2.AssignTo(Dest: TPersistent);
begin
  if Dest is TFont then
  begin
    TFont(Dest).Color := Color;
    TFont(Dest).Name := Name;
    TFont(Dest).Charset := Charset;
    TFont(Dest).Style := Style;
    TFont(Dest).Size := Size;
    TFont(Dest).Pitch := Pitch;
  end
  else if Dest is TTextAttributes2 then
  begin
    TTextAttributes2(Dest).Color := Color;
    TTextAttributes2(Dest).Name := Name;
    TTextAttributes2(Dest).Charset := Charset;
    TTextAttributes2(Dest).Style := Style;
    TTextAttributes2(Dest).Pitch := Pitch;
  end
  else inherited AssignTo(Dest);
end;

{ TParaAttributes2 }

constructor TParaAttributes2.Create(AOwner: TCustomRichEdit2);
begin
  inherited Create;
  RichEdit := AOwner;
end;

procedure TParaAttributes2.InitPara(var Paragraph: TParaFormat);
begin
  FillChar(Paragraph, SizeOf(TParaFormat), 0);
  Paragraph.cbSize := SizeOf(TParaFormat);
end;

procedure TParaAttributes2.GetAttributes(var Paragraph: TParaFormat);
begin
  InitPara(Paragraph);
  if RichEdit.HandleAllocated then
    SendMessage(RichEdit.Handle, EM_GETPARAFORMAT, 0, LPARAM(@Paragraph));
end;

procedure TParaAttributes2.SetAttributes(var Paragraph: TParaFormat);
begin
  RichEdit.HandleNeeded; { we REALLY need the handle for BiDi }
  if RichEdit.HandleAllocated then
  begin
    if RichEdit.UseRightToLeftAlignment then
      if Paragraph.wAlignment = PFA_LEFT then
        Paragraph.wAlignment := PFA_RIGHT
      else if Paragraph.wAlignment = PFA_RIGHT then
        Paragraph.wAlignment := PFA_LEFT;
    SendMessage(RichEdit.Handle, EM_SETPARAFORMAT, 0, LPARAM(@Paragraph));
  end;
end;

function TParaAttributes2.GetAlignment: TAlignment;
var
  Paragraph: TParaFormat;
begin
  GetAttributes(Paragraph);
  Result := TAlignment(Paragraph.wAlignment - 1);
end;

procedure TParaAttributes2.SetAlignment(Value: TAlignment);
var
  Paragraph: TParaFormat;
begin
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_ALIGNMENT;
    wAlignment := Ord(Value) + 1;
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes2.GetNumbering: TNumberingStyle2;
var
  Paragraph: TParaFormat;
begin
  GetAttributes(Paragraph);
  Result := TNumberingStyle2(Paragraph.wNumbering);
end;

procedure TParaAttributes2.SetNumbering(Value: TNumberingStyle2);
var
  Paragraph: TParaFormat;
begin
  case Value of
    nsBullet: if LeftIndent < 10 then LeftIndent := 10;
    nsNone: LeftIndent := 0;
  end;
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_NUMBERING;
    wNumbering := Ord(Value);
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes2.GetFirstIndent: Longint;
var
  Paragraph: TParaFormat;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.dxStartIndent div 20
end;

procedure TParaAttributes2.SetFirstIndent(Value: Longint);
var
  Paragraph: TParaFormat;
begin
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_STARTINDENT;
    dxStartIndent := Value * 20;
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes2.GetLeftIndent: Longint;
var
  Paragraph: TParaFormat;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.dxOffset div 20;
end;

procedure TParaAttributes2.SetLeftIndent(Value: Longint);
var
  Paragraph: TParaFormat;
begin
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_OFFSET;
    dxOffset := Value * 20;
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes2.GetRightIndent: Longint;
var
  Paragraph: TParaFormat;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.dxRightIndent div 20;
end;

procedure TParaAttributes2.SetRightIndent(Value: Longint);
var
  Paragraph: TParaFormat;
begin
  InitPara(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_RIGHTINDENT;
    dxRightIndent := Value * 20;
  end;
  SetAttributes(Paragraph);
end;

function TParaAttributes2.GetTab(Index: Byte): Longint;
var
  Paragraph: TParaFormat;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.rgxTabs[Index] div 20;
end;

procedure TParaAttributes2.SetTab(Index: Byte; Value: Longint);
var
  Paragraph: TParaFormat;
begin
  GetAttributes(Paragraph);
  with Paragraph do
  begin
    rgxTabs[Index] := Value * 20;
    dwMask := PFM_TABSTOPS;
    if cTabCount < Index then cTabCount := Index;
    SetAttributes(Paragraph);
  end;
end;

function TParaAttributes2.GetTabCount: Integer;
var
  Paragraph: TParaFormat;
begin
  GetAttributes(Paragraph);
  Result := Paragraph.cTabCount;
end;

procedure TParaAttributes2.SetTabCount(Value: Integer);
var
  Paragraph: TParaFormat;
begin
  GetAttributes(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_TABSTOPS;
    cTabCount := Value;
    SetAttributes(Paragraph);
  end;
end;

procedure TParaAttributes2.Assign(Source: TPersistent);
var
  I: Integer;
begin
  if Source is TParaAttributes2 then
  begin
    Alignment := TParaAttributes2(Source).Alignment;
    FirstIndent := TParaAttributes2(Source).FirstIndent;
    LeftIndent := TParaAttributes2(Source).LeftIndent;
    RightIndent := TParaAttributes2(Source).RightIndent;
    Numbering := TParaAttributes2(Source).Numbering;
    for I := 0 to MAX_TAB_STOPS - 1 do
      Tab[I] := TParaAttributes2(Source).Tab[I];
  end
  else inherited Assign(Source);
end;


{ TConversion }

function TConversion.ConvertReadStream(Stream: TStream; Buffer: PChar; BufSize: Integer): Integer;
begin
  Result := Stream.Read(Buffer^, BufSize);
end;

function TConversion.ConvertWriteStream(Stream: TStream; Buffer: PChar; BufSize: Integer): Integer;
begin
  Result := Stream.Write(Buffer^, BufSize);
end;

{ TRichEditStrings }

const
  ReadError = $0001;
  WriteError = $0002;
  NoError = $0000;

type
  TSelection2 = record
    StartPos, EndPos: Integer;
  end;

  TRichEditStrings = class(TStrings)
  private
    RichEdit: TCustomRichEdit2;
    FPlainText: Boolean;
    FConverter: TConversion;
    procedure EnableChange(const Value: Boolean);
  protected
    function Get(Index: Integer): string; override;
    function GetCount: Integer; override;
    procedure Put(Index: Integer; const S: string); override;
    procedure SetUpdateState(Updating: Boolean); override;
    procedure SetTextStr(const Value: string); override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    procedure AddStrings(Strings: TStrings); override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override;
    procedure LoadFromFile(const FileName: string); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToFile(const FileName: string); override;
    procedure SaveToStream(Stream: TStream); override;
    property PlainText: Boolean read FPlainText write FPlainText;
  end;

destructor TRichEditStrings.Destroy;
begin
  FConverter.Free;
  inherited Destroy;
end;

procedure TRichEditStrings.AddStrings(Strings: TStrings);
var
  SelChange: TNotifyEvent;
begin
  SelChange := RichEdit.OnSelectionChange;
  RichEdit.OnSelectionChange := nil;
  try
    inherited AddStrings(Strings);
  finally
    RichEdit.OnSelectionChange := SelChange;
  end;
end;

function TRichEditStrings.GetCount: Integer;
begin
  Result := SendMessage(RichEdit.Handle, EM_GETLINECOUNT, 0, 0);
  if SendMessage(RichEdit.Handle, EM_LINELENGTH, SendMessage(RichEdit.Handle,
    EM_LINEINDEX, Result - 1, 0), 0) = 0 then Dec(Result);
end;

function TRichEditStrings.Get(Index: Integer): string;
var
  Text: array[0..4095] of Char;
  L: Integer;
begin
  Word((@Text)^) := SizeOf(Text);
  L := SendMessage(RichEdit.Handle, EM_GETLINE, Index, Longint(@Text));
  if (Text[L - 2] = #13) and (Text[L - 1] = #10) then Dec(L, 2);
  SetString(Result, Text, L);
end;

procedure TRichEditStrings.Put(Index: Integer; const S: string);
var
  Selection: TCharRange;
begin
  if Index >= 0 then
  begin
    Selection.cpMin := SendMessage(RichEdit.Handle, EM_LINEINDEX, Index, 0);
    if Selection.cpMin <> -1 then
    begin
      Selection.cpMax := Selection.cpMin +
        SendMessage(RichEdit.Handle, EM_LINELENGTH, Selection.cpMin, 0);
      SendMessage(RichEdit.Handle, EM_EXSETSEL, 0, Longint(@Selection));
      SendMessage(RichEdit.Handle, EM_REPLACESEL, 0, Longint(PChar(S)));
    end;
  end;
end;

procedure TRichEditStrings.Insert(Index: Integer; const S: string);
var
  L: Integer;
  Selection: TCharRange;
  Fmt: PChar;
  Str: string;
begin
  if Index >= 0 then
  begin
    Selection.cpMin := SendMessage(RichEdit.Handle, EM_LINEINDEX, Index, 0);
    if Selection.cpMin >= 0 then Fmt := '%s'#13#10
    else begin
      Selection.cpMin :=
        SendMessage(RichEdit.Handle, EM_LINEINDEX, Index - 1, 0);
      if Selection.cpMin < 0 then Exit;
      L := SendMessage(RichEdit.Handle, EM_LINELENGTH, Selection.cpMin, 0);
      if L = 0 then Exit;
      Inc(Selection.cpMin, L);
      Fmt := #13#10'%s';
    end;
    Selection.cpMax := Selection.cpMin;
    SendMessage(RichEdit.Handle, EM_EXSETSEL, 0, Longint(@Selection));
    Str := Format(Fmt, [S]);
    SendMessage(RichEdit.Handle, EM_REPLACESEL, 0, LongInt(PChar(Str)));
   { if RichEdit.SelStart <> (Selection.cpMax + Length(Str)) then
      raise EOutOfResources.Create(sRichEditInsertError);}
  end;
end;

procedure TRichEditStrings.Delete(Index: Integer);
const
  Empty: PChar = '';
var
  Selection: TCharRange;
begin
  if Index < 0 then Exit;
  Selection.cpMin := SendMessage(RichEdit.Handle, EM_LINEINDEX, Index, 0);
  if Selection.cpMin <> -1 then
  begin
    Selection.cpMax := SendMessage(RichEdit.Handle, EM_LINEINDEX, Index + 1, 0);
    if Selection.cpMax = -1 then
      Selection.cpMax := Selection.cpMin +
        SendMessage(RichEdit.Handle, EM_LINELENGTH, Selection.cpMin, 0);
    SendMessage(RichEdit.Handle, EM_EXSETSEL, 0, Longint(@Selection));
    SendMessage(RichEdit.Handle, EM_REPLACESEL, 0, Longint(Empty));
  end;
end;

procedure TRichEditStrings.Clear;
begin
  RichEdit.Clear;
end;

procedure TRichEditStrings.SetUpdateState(Updating: Boolean);
begin
  if RichEdit.Showing then
    SendMessage(RichEdit.Handle, WM_SETREDRAW, Ord(not Updating), 0);
  if not Updating then begin
    RichEdit.Refresh;
    RichEdit.Perform(CM_TEXTCHANGED, 0, 0);
  end;
end;

procedure TRichEditStrings.EnableChange(const Value: Boolean);
var
  EventMask: Longint;
begin
  with RichEdit do
  begin
    if Value then
      EventMask := SendMessage(Handle, EM_GETEVENTMASK, 0, 0) or ENM_CHANGE
    else
      EventMask := SendMessage(Handle, EM_GETEVENTMASK, 0, 0) and not ENM_CHANGE;
    SendMessage(Handle, EM_SETEVENTMASK, 0, EventMask);
  end;
end;

procedure TRichEditStrings.SetTextStr(const Value: string);
begin
  EnableChange(False);
  try
    inherited SetTextStr(Value);
  finally
    EnableChange(True);
  end;
end;

function AdjustLineBreaks(Dest, Source: PChar): Integer; assembler;
asm
        PUSH    ESI
        PUSH    EDI
        MOV     EDI,EAX
        MOV     ESI,EDX
        MOV     EDX,EAX
        CLD
@@1:    LODSB
@@2:    OR      AL,AL
        JE      @@4
        CMP     AL,0AH
        JE      @@3
        STOSB
        CMP     AL,0DH
        JNE     @@1
        MOV     AL,0AH
        STOSB
        LODSB
        CMP     AL,0AH
        JE      @@1
        JMP     @@2
@@3:    MOV     EAX,0A0DH
        STOSW
        JMP     @@1
@@4:    STOSB
        LEA     EAX,[EDI-1]
        SUB     EAX,EDX
        POP     EDI
        POP     ESI
end;

function StreamSave(dwCookie: Longint; pbBuff: PByte;
  cb: Longint; var pcb: Longint): Longint; stdcall;
var
  StreamInfo: PRichEditStreamInfo;
begin
  Result := NoError;
  StreamInfo := PRichEditStreamInfo(Pointer(dwCookie));
  try
    pcb := 0;
    if StreamInfo^.Converter <> nil then
      pcb := StreamInfo^.Converter.ConvertWriteStream(StreamInfo^.Stream, PChar(pbBuff), cb);
  except
    Result := WriteError;
  end;
end;

function StreamLoad(dwCookie: Longint; pbBuff: PByte;
  cb: Longint; var pcb: Longint): Longint; stdcall;
var
  Buffer, pBuff: PChar;
  StreamInfo: PRichEditStreamInfo;
begin
  Result := NoError;
  StreamInfo := PRichEditStreamInfo(Pointer(dwCookie));
  Buffer := StrAlloc(cb + 1);
  try
    cb := cb div 2;
    pcb := 0;
    pBuff := Buffer + cb;
    try
      if StreamInfo^.Converter <> nil then
        pcb := StreamInfo^.Converter.ConvertReadStream(StreamInfo^.Stream, pBuff, cb);
      if pcb > 0 then
      begin
        pBuff[pcb] := #0;
        if pBuff[pcb - 1] = #13 then pBuff[pcb - 1] := #0;
        pcb := AdjustLineBreaks(Buffer, pBuff);
        Move(Buffer^, pbBuff^, pcb);
      end;
    except
      Result := ReadError;
    end;
  finally
    StrDispose(Buffer);
  end;
end;

procedure TRichEditStrings.LoadFromStream(Stream: TStream);
var
  EditStream: TEditStream;
  Position: Longint;
  TextType: Longint;
  StreamInfo: TRichEditStreamInfo;
  Converter: TConversion;
begin
  StreamInfo.Stream := Stream;
  if FConverter <> nil then Converter := FConverter
  else Converter := RichEdit.DefaultConverter.Create;
  StreamInfo.Converter := Converter;
  try
    with EditStream do
    begin
      dwCookie := LongInt(Pointer(@StreamInfo));
      pfnCallBack := @StreamLoad;
      dwError := 0;
    end;
    Position := Stream.Position;
    if PlainText then TextType := SF_TEXT
    else TextType := SF_RTF;
    SendMessage(RichEdit.Handle, EM_STREAMIN, TextType, Longint(@EditStream));
    if (TextType = SF_RTF) and (EditStream.dwError <> 0) then
    begin
      Stream.Position := Position;
      if PlainText then TextType := SF_RTF
      else TextType := SF_TEXT;
      SendMessage(RichEdit.Handle, EM_STREAMIN, TextType, Longint(@EditStream));
      if EditStream.dwError <> 0 then
        raise EOutOfResources.Create(sRichEditLoadFail);
    end;
  finally
    if FConverter = nil then Converter.Free;
  end;
end;

procedure TRichEditStrings.SaveToStream(Stream: TStream);
var
  EditStream: TEditStream;
  TextType: Longint;
  StreamInfo: TRichEditStreamInfo;
  Converter: TConversion;
begin
  if FConverter <> nil then Converter := FConverter
  else Converter := RichEdit.DefaultConverter.Create;
  StreamInfo.Stream := Stream;
  StreamInfo.Converter := Converter;
  try
    with EditStream do
    begin
      dwCookie := LongInt(Pointer(@StreamInfo));
      pfnCallBack := @StreamSave;
      dwError := 0;
    end;
    if PlainText then TextType := SF_TEXT
    else TextType := SF_RTF;
    SendMessage(RichEdit.Handle, EM_STREAMOUT, TextType, Longint(@EditStream));
    if EditStream.dwError <> 0 then
      raise EOutOfResources.Create(sRichEditSaveFail);
  finally
    if FConverter = nil then Converter.Free;
  end;
end;

procedure TRichEditStrings.LoadFromFile(const FileName: string);
var
  Ext: string;
  Convert: PConversionFormat;
begin
  Ext := AnsiLowerCaseFileName(ExtractFileExt(Filename));
  System.Delete(Ext, 1, 1);
  Convert := ConversionFormatList;
  while Convert <> nil do
    with Convert^ do
      if Extension <> Ext then Convert := Next
      else Break;
  if Convert = nil then
    Convert := @TextConversionFormat;
  if FConverter = nil then FConverter := Convert^.ConversionClass.Create;
  try
    inherited LoadFromFile(FileName);
  except
    FConverter.Free;
    FConverter := nil;
    raise;
  end;
end;

procedure TRichEditStrings.SaveToFile(const FileName: string);
var
  Ext: string;
  Convert: PConversionFormat;
begin
  Ext := AnsiLowerCaseFileName(ExtractFileExt(Filename));
  System.Delete(Ext, 1, 1);
  Convert := ConversionFormatList;
  while Convert <> nil do
    with Convert^ do
      if Extension <> Ext then Convert := Next
      else Break;
  if Convert = nil then
    Convert := @TextConversionFormat;
  if FConverter = nil then FConverter := Convert^.ConversionClass.Create;
  try
    inherited SaveToFile(FileName);
  except
    FConverter.Free;
    FConverter := nil;
    raise;
  end;
end;

{ TRichEdit }

constructor TCustomRichEdit2.Create(AOwner: TComponent);
var
  DC: HDC;
begin
  inherited Create(AOwner);
  FSelAttributes := TTextAttributes2.Create(Self, atSelected);
  FDefAttributes := TTextAttributes2.Create(Self, atDefaultText);
  FParagraph := TParaAttributes2.Create(Self);
  FRichEditStrings := TRichEditStrings.Create;
  TRichEditStrings(FRichEditStrings).RichEdit := Self;
  TabStop := True;
  Width := 185;
  Height := 89;
  AutoSize := False;
  DoubleBuffered := False;
  FHideSelection := True;
  HideScrollBars := True;
  DC := GetDC(0);
  FScreenLogPixels := GetDeviceCaps(DC, LOGPIXELSY);
  DefaultConverter := TConversion;
  ReleaseDC(0, DC);
  FOldParaAlignment := Alignment;
  Perform(CM_PARENTBIDIMODECHANGED, 0, 0);
end;

destructor TCustomRichEdit2.Destroy;
begin
  FSelAttributes.Free;
  FDefAttributes.Free;
  FParagraph.Free;
  FRichEditStrings.Free;
  FMemStream.Free;
  inherited Destroy;
end;

procedure TCustomRichEdit2.Clear;
begin
  inherited Clear;
  Modified := False;
end;

procedure TCustomRichEdit2.CreateParams(var Params: TCreateParams);
const
  //RichEditModuleName = 'RICHED32.DLL';
  RichEditModuleName = 'RICHED20.DLL';
  HideScrollBars: array[Boolean] of DWORD = (ES_DISABLENOSCROLL, 0);
  HideSelections: array[Boolean] of DWORD = (ES_NOHIDESEL, 0);
var
  OldError: Longint;
begin
  OldError := SetErrorMode(SEM_NOOPENFILEERRORBOX);
  FLibHandle := LoadLibrary(RichEditModuleName);
  if (FLibHandle > 0) and (FLibHandle < HINSTANCE_ERROR) then FLibHandle := 0;
  SetErrorMode(OldError);
  inherited CreateParams(Params);
  CreateSubClass(Params, 'RICHEDIT20A');
  with Params do
  begin
    Style := Style or HideScrollBars[FHideScrollBars] or
      HideSelections[HideSelection];
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
  end;
end;

procedure TCustomRichEdit2.CreateWnd;
var
  Plain, DesignMode: Boolean;
begin
  inherited CreateWnd;
  if (SysLocale.FarEast) and not (SysLocale.PriLangID = LANG_JAPANESE) then
    Font.Charset := GetDefFontCharSet;
  SendMessage(Handle, EM_SETEVENTMASK, 0,
    ENM_CHANGE or ENM_SELCHANGE or ENM_REQUESTRESIZE or
    ENM_PROTECTED);
  SendMessage(Handle, EM_SETBKGNDCOLOR, 0, ColorToRGB(Color));
  if FMemStream <> nil then
  begin
    Plain := PlainText;
    FMemStream.ReadBuffer(DesignMode, sizeof(DesignMode));
    PlainText := DesignMode;
    try
      Lines.LoadFromStream(FMemStream);
      FMemStream.Free;
      FMemStream := nil;
    finally
      PlainText := Plain;
    end;
  end;
  Modified := FModified;
end;

procedure TCustomRichEdit2.DestroyWnd;
var
  Plain, DesignMode: Boolean;
begin
  FModified := Modified;
  FMemStream := TMemoryStream.Create;
  Plain := PlainText;
  DesignMode := (csDesigning in ComponentState);
  PlainText := DesignMode;
  FMemStream.WriteBuffer(DesignMode, sizeof(DesignMode));
  try
    Lines.SaveToStream(FMemStream);
    FMemStream.Position := 0;
  finally
    PlainText := Plain;
  end;
  inherited DestroyWnd;
end;

procedure TCustomRichEdit2.WMNCDestroy(var Message: TWMNCDestroy);
begin
  inherited;
  if FLibHandle <> 0 then FreeLibrary(FLibHandle);
end;

procedure TCustomRichEdit2.WMSetFont(var Message: TWMSetFont);
begin
  FDefAttributes.Assign(Font);
end;

procedure TCustomRichEdit2.CMFontChanged(var Message: TMessage);
begin
  FDefAttributes.Assign(Font);
end;

procedure TCustomRichEdit2.DoSetMaxLength(Value: Integer);
begin
  SendMessage(Handle, EM_EXLIMITTEXT, 0, Value);
end;

function TCustomRichEdit2.GetCaretPos;
var
  CharRange: TCharRange;
begin
  SendMessage(Handle, EM_EXGETSEL, 0, LongInt(@CharRange));
  Result.X := CharRange.cpMax;
  Result.Y := SendMessage(Handle, EM_EXLINEFROMCHAR, 0, Result.X);
  Result.X := Result.X - SendMessage(Handle, EM_LINEINDEX, -1, 0);
end;

function TCustomRichEdit2.GetSelLength: Integer;
var
  CharRange: TCharRange;
begin
  SendMessage(Handle, EM_EXGETSEL, 0, Longint(@CharRange));
  Result := CharRange.cpMax - CharRange.cpMin;
end;

function TCustomRichEdit2.GetSelStart: Integer;
var
  CharRange: TCharRange;
begin
  SendMessage(Handle, EM_EXGETSEL, 0, Longint(@CharRange));
  Result := CharRange.cpMin;
end;

function TCustomRichEdit2.GetSelTextBuf(Buffer: PChar; BufSize: Integer): Integer;
var
  S: string;
begin
  S := GetSelText;
  Result := Length(S);
  if BufSize < Length(S) then Result := BufSize;
  StrPLCopy(Buffer, S, Result);
end;

function TCustomRichEdit2.GetSelText: string;
{var
  Length: Integer;}
begin
  //SetLength(Result, GetSelLength + 1);
  //Length := SendMessage(Handle, EM_GETSELTEXT, 0, Longint(PChar(Result)));
  //SetLength(Result, Length);
  // for MBCS
  SetLength(Result, (GetSelLength + 1)*2);
  // must clear memory.
  FillMemory(pchar(result),(GetSelLength)*2+1,0);
  SendMessage(Handle, EM_GETSELTEXT, 0, Longint(PChar(Result)));
  DebugLength := StrLen(pchar(Result));
  SetLength(Result,DebugLength);
end;

procedure TCustomRichEdit2.CMBiDiModeChanged(var Message: TMessage);
var
  AParagraph: TParaFormat;
begin
  HandleNeeded; { we REALLY need the handle for BiDi }
  inherited;
  Paragraph.GetAttributes(AParagraph);
  AParagraph.dwMask := PFM_ALIGNMENT;
  AParagraph.wAlignment := Ord(Alignment) + 1;
  Paragraph.SetAttributes(AParagraph);
end;

procedure TCustomRichEdit2.SetHideScrollBars(Value: Boolean);
begin
  if HideScrollBars <> Value then
  begin
    FHideScrollBars := value;
    RecreateWnd;
  end;
end;

procedure TCustomRichEdit2.SetHideSelection(Value: Boolean);
begin
  if HideSelection <> Value then
  begin
    FHideSelection := Value;
    SendMessage(Handle, EM_HIDESELECTION, Ord(HideSelection), LongInt(True));
  end;
end;

procedure TCustomRichEdit2.SetSelAttributes(Value: TTextAttributes2);
begin
  SelAttributes.Assign(Value);
end;

procedure TCustomRichEdit2.SetSelLength(Value: Integer);
var
  CharRange: TCharRange;
begin
  SendMessage(Handle, EM_EXGETSEL, 0, Longint(@CharRange));
  CharRange.cpMax := CharRange.cpMin + Value;
  SendMessage(Handle, EM_EXSETSEL, 0, Longint(@CharRange));
  SendMessage(Handle, EM_SCROLLCARET, 0, 0);
end;

procedure TCustomRichEdit2.SetDefAttributes(Value: TTextAttributes2);
begin
  DefAttributes.Assign(Value);
end;

function TCustomRichEdit2.GetPlainText: Boolean;
begin
  Result := TRichEditStrings(Lines).PlainText;
end;

procedure TCustomRichEdit2.SetPlainText(Value: Boolean);
begin
  TRichEditStrings(Lines).PlainText := Value;
end;

procedure TCustomRichEdit2.CMColorChanged(var Message: TMessage);
begin
  inherited;
  SendMessage(Handle, EM_SETBKGNDCOLOR, 0, ColorToRGB(Color))
end;

procedure TCustomRichEdit2.SetRichEditStrings(Value: TStrings);
begin
  FRichEditStrings.Assign(Value);
end;

procedure TCustomRichEdit2.SetSelStart(Value: Integer);
var
  CharRange: TCharRange;
begin
  CharRange.cpMin := Value;
  CharRange.cpMax := Value;
  SendMessage(Handle, EM_EXSETSEL, 0, Longint(@CharRange));
end;

procedure TCustomRichEdit2.Print(const Caption: string);
var
  Range: TFormatRange;
  LastChar, MaxLen, LogX, LogY, OldMap: Integer;
begin
  FillChar(Range, SizeOf(TFormatRange), 0);
  with Printer, Range do
  begin
    Title := Caption;
    BeginDoc;
    hdc := Handle;
    hdcTarget := hdc;
    LogX := GetDeviceCaps(Handle, LOGPIXELSX);
    LogY := GetDeviceCaps(Handle, LOGPIXELSY);
    if IsRectEmpty(PageRect) then
    begin
      rc.right := PageWidth * 1440 div LogX;
      rc.bottom := PageHeight * 1440 div LogY;
    end
    else begin
      rc.left := PageRect.Left * 1440 div LogX;
      rc.top := PageRect.Top * 1440 div LogY;
      rc.right := PageRect.Right * 1440 div LogX;
      rc.bottom := PageRect.Bottom * 1440 div LogY;
    end;
    rcPage := rc;
    LastChar := 0;
    MaxLen := GetTextLen;
    chrg.cpMax := -1;
    // ensure printer DC is in text map mode
    OldMap := SetMapMode(hdc, MM_TEXT);
    SendMessage(Handle, EM_FORMATRANGE, 0, 0);    // flush buffer
    try
      repeat
        chrg.cpMin := LastChar;
        LastChar := SendMessage(Self.Handle, EM_FORMATRANGE, 1, Longint(@Range));
        if (LastChar < MaxLen) and (LastChar <> -1) then NewPage;
      until (LastChar >= MaxLen) or (LastChar = -1);
      EndDoc;
    finally
      SendMessage(Handle, EM_FORMATRANGE, 0, 0);  // flush buffer
      SetMapMode(hdc, OldMap);       // restore previous map mode
    end;
  end;
end;

var
  Painting: Boolean = False;

procedure TCustomRichEdit2.WMPaint(var Message: TWMPaint);
var
  R, R1: TRect;
begin
  if GetUpdateRect(Handle, R, True) then
  begin
    with ClientRect do R1 := Rect(Right - 3, Top, Right, Bottom);
    if IntersectRect(R, R, R1) then InvalidateRect(Handle, @R1, True);
  end;
  if Painting then
    Invalidate
  else begin
    Painting := True;
    try
      inherited;
    finally
      Painting := False;
    end;
  end;
end;

procedure TCustomRichEdit2.WMSetCursor(var Message: TWMSetCursor);
var
  P: TPoint;
begin
  inherited;
  if Message.Result = 0 then
  begin
    Message.Result := 1;
    GetCursorPos(P);
    with PointToSmallPoint(P) do
      case Perform(WM_NCHITTEST, 0, MakeLong(X, Y)) of
        HTVSCROLL,
        HTHSCROLL:
          Windows.SetCursor(Screen.Cursors[crArrow]);
        HTCLIENT:
          Windows.SetCursor(Screen.Cursors[crIBeam]);
      end;
  end;
end;

procedure TCustomRichEdit2.CNNotify(var Message: TWMNotify);
begin
  with Message do
    case NMHdr^.code of
      EN_SELCHANGE: SelectionChange;
      EN_REQUESTRESIZE: RequestSize(PReqSize(NMHdr)^.rc);
      EN_SAVECLIPBOARD:
        with PENSaveClipboard(NMHdr)^ do
          if not SaveClipboard(cObjectCount, cch) then Result := 1;
      EN_PROTECTED:
        with PENProtected(NMHdr)^.chrg do
          if not ProtectChange(cpMin, cpMax) then Result := 1;
    end;
end;

function TCustomRichEdit2.SaveClipboard(NumObj, NumChars: Integer): Boolean;
begin
  Result := True;
  if Assigned(OnSaveClipboard) then OnSaveClipboard(Self, NumObj, NumChars, Result);
end;

function TCustomRichEdit2.ProtectChange(StartPos, EndPos: Integer): Boolean;
begin
  Result := False;
  if Assigned(OnProtectChange) then OnProtectChange(Self, StartPos, EndPos, Result);
end;

procedure TCustomRichEdit2.SelectionChange;
begin
  if Assigned(OnSelectionChange) then OnSelectionChange(Self);
end;

procedure TCustomRichEdit2.RequestSize(const Rect: TRect);
begin
  if Assigned(OnResizeRequest) then OnResizeRequest(Self, Rect);
end;

function TCustomRichEdit2.FindText(const SearchStr: string;
  StartPos, Length: Integer; Options: TSearchTypes): Integer;
var
  Find: TFindText;
  Flags: Integer;
begin
  with Find.chrg do
  begin
    cpMin := StartPos;
    cpMax := cpMin + Length;
  end;
  Flags := 0;
  if stWholeWord in Options then Flags := Flags or FT_WHOLEWORD;
  if stMatchCase in Options then Flags := Flags or FT_MATCHCASE;
  Find.lpstrText := PChar(SearchStr);
  Result := SendMessage(Handle, EM_FINDTEXT, Flags, LongInt(@Find));
end;

procedure AppendConversionFormat(const Ext: string; AClass: TConversionClass);
var
  NewRec: PConversionFormat;
begin
  New(NewRec);
  with NewRec^ do
  begin
    Extension := AnsiLowerCaseFileName(Ext);
    ConversionClass := AClass;
    Next := ConversionFormatList;
  end;
  ConversionFormatList := NewRec;
end;

class procedure TCustomRichEdit2.RegisterConversionFormat(const AExtension: string;
  AConversionClass: TConversionClass);
begin
  AppendConversionFormat(AExtension, AConversionClass);
end;

initialization

finalization
  if ShellModule <> 0 then FreeLibrary(ShellModule);

end.
