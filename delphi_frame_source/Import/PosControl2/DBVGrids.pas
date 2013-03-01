{*********************************************************************************}
{
File Name.......: DBVGrids.zip
File Description: Implementation of a Vertical DBGrid based on Vcl's DBGrids.pas.
Targets.........: Delphi 3.
Author Name.....: George Vavoylogiannis
EMail...........: georgev@hol.gr
WEB.............: http://users.hol.gr/~georgev
File Status.....: Freeware
Category........: Database components.


  For a long time till a few months, i was trying to find a solution for
  vertical grid. I found a few grid components that claimed to be vertical, but
  this was far from tue.
  So one day i decided to have a better look at the DBGrids.pas in Borland VCL source.
  "Bit by bit" as we say in Greece i started changing the code and finally
  a TRUE VERTICAL DBGRID component is what we have here.

  I wonder why Borland did't think about this. After all it seems so SIMPLE!!!

  NEW PROPERTIES
  Vertical: Boolean, set to True and and the grid becomes VERTICAL
  OnlyOne: Boolean, set to true if you want the grid to display only one record
           at a time (the curent record).
  TitlesWidth: integer, set the vertical column title's width.

  NOTE: because all the code is duplicated from the VCL, all the classes are
  redefined (TColumn, TDBGridColumns, TGridDatalink e.t.c).
  The columns editor works fine except that it does not bring the fields list.
  This is something that i may do in future versions but if someone find's a
  way to solve it or even has property editor for the columns please drop me
  an E-Mail.


Free to use and redistribute, but my name must
appear somewhere in the source code, or in the software.
No warranty is given by the author, expressed or implied.

WARNING! THE CODE IS PROVIDED AS IS WITH NO GUARANTEES OF ANY KIND!
USE THIS AT YOUR OWN RISK - YOU ARE THE ONLY PERSON RESPONSIBLE FOR
ANY DAMAGE THIS CODE MAY CAUSE - YOU HAVE BEEN WARNED!

}
{**********************************************************************************}

unit DBVGrids;

{$R-}

interface

uses Windows, SysUtils, Messages, Classes, Controls, Forms, StdCtrls,
  Graphics, Grids, DBCtrls, Db, Menus, DBGrids, DsgnIntf;

type
  TColumnValue = (cvColor, cvWidth, cvFont, cvAlignment, cvReadOnly, cvTitleColor,
    cvTitleCaption, cvTitleAlignment, cvTitleFont, cvImeMode, cvImeName);
  TColumnValues = set of TColumnValue;

const
  ColumnTitleValues = [cvTitleColor..cvTitleFont];
  cm_DeferLayout = WM_USER + 100;

{ TColumn defines internal storage for column attributes.  Values assigned
  to properties are stored in this object, the grid- or field-based default
  sources are not modified.  Values read from properties are the previously
  assigned value, if any, or the grid- or field-based default values if
  nothing has been assigned to that property. This class also publishes the
  column attribute properties for persistent storage.  }
type
  TColumn = class;
  TCustomVDBGrid = class;

  TColumnTitle = class(TPersistent)
  private
    FColumn: TColumn;
    FCaption: string;
    FFont: TFont;
    FColor: TColor;
    FAlignment: TAlignment;
    procedure FontChanged(Sender: TObject);
    function GetAlignment: TAlignment;
    function GetColor: TColor;
    function GetCaption: string;
    function GetFont: TFont;
    function IsAlignmentStored: Boolean;
    function IsColorStored: Boolean;
    function IsFontStored: Boolean;
    function IsCaptionStored: Boolean;
    procedure SetAlignment(Value: TAlignment);
    procedure SetColor(Value: TColor);
    procedure SetFont(Value: TFont);
    procedure SetCaption(const Value: string); virtual;
  protected
    procedure RefreshDefaultFont;
  public
    constructor Create(Column: TColumn);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function DefaultAlignment: TAlignment;
    function DefaultColor: TColor;
    function DefaultFont: TFont;
    function DefaultCaption: string;
    procedure RestoreDefaults; virtual;
  published
    property Alignment: TAlignment read GetAlignment write SetAlignment
      stored IsAlignmentStored;
    property Caption: string read GetCaption write SetCaption stored IsCaptionStored;
    property Color: TColor read GetColor write SetColor stored IsColorStored;
    property Font: TFont read GetFont write SetFont stored IsFontStored;
  end;

  TColumnButtonStyle = (cbsAuto, cbsEllipsis, cbsNone);

  TColumn = class(TCollectionItem)
  private
    FField: TField;
    FFieldName: string;
    FColor: TColor;
    FWidth: Integer;
    FTitle: TColumnTitle;
    FFont: TFont;
    FImeMode: TImeMode;
    FImeName: TImeName;
    FPickList: TStrings;
    FPopupMenu: TPopupMenu;
    FDropDownRows: Cardinal;
    FButtonStyle: TColumnButtonStyle;
    FAlignment: TAlignment;
    FReadonly: Boolean;
    FAssignedValues: TColumnValues;
    procedure FontChanged(Sender: TObject);
    function  GetAlignment: TAlignment;
    function  GetColor: TColor;
    function  GetField: TField;
    function  GetFont: TFont;
    function  GetImeMode: TImeMode;
    function  GetImeName: TImeName;
    function  GetPickList: TStrings;
    function  GetReadOnly: Boolean;
    function  GetWidth: Integer;
    function  IsAlignmentStored: Boolean;
    function  IsColorStored: Boolean;
    function  IsFontStored: Boolean;
    function  IsImeModeStored: Boolean;
    function  IsImeNameStored: Boolean;
    function  IsReadOnlyStored: Boolean;
    function  IsWidthStored: Boolean;
    procedure SetAlignment(Value: TAlignment); virtual;
    procedure SetButtonStyle(Value: TColumnButtonStyle);
    procedure SetColor(Value: TColor);
    procedure SetField(Value: TField); virtual;
    procedure SetFieldName(const Value: String);
    procedure SetFont(Value: TFont);
    procedure SetImeMode(Value: TImeMode); virtual;
    procedure SetImeName(Value: TImeName); virtual;
    procedure SetPickList(Value: TStrings);
    procedure SetPopupMenu(Value: TPopupMenu);
    procedure SetReadOnly(Value: Boolean); virtual;
    procedure SetTitle(Value: TColumnTitle);
    procedure SetWidth(Value: Integer); virtual;
  protected
    function  CreateTitle: TColumnTitle; virtual;
    function  GetGrid: TCustomVDBGrid;
    function GetDisplayName: string; override;
    procedure RefreshDefaultFont;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function  DefaultAlignment: TAlignment;
    function  DefaultColor: TColor;
    function  DefaultFont: TFont;
    function  DefaultImeMode: TImeMode;
    function  DefaultImeName: TImeName;
    function  DefaultReadOnly: Boolean;
    function  DefaultWidth: Integer;
    procedure RestoreDefaults; virtual;
    property  Grid: TCustomVDBGrid read GetGrid;
    property  AssignedValues: TColumnValues read FAssignedValues;
    property  Field: TField read GetField write SetField;
  published
    property  Alignment: TAlignment read GetAlignment write SetAlignment
      stored IsAlignmentStored;
    property  ButtonStyle: TColumnButtonStyle read FButtonStyle write SetButtonStyle
      default cbsAuto;
    property  Color: TColor read GetColor write SetColor stored IsColorStored;
    property  DropDownRows: Cardinal read FDropDownRows write FDropDownRows default 7;
    property  FieldName: String read FFieldName write SetFieldName;
    property  Font: TFont read GetFont write SetFont stored IsFontStored;
    property  ImeMode: TImeMode read GetImeMode write SetImeMode stored IsImeModeStored;
    property  ImeName: TImeName read GetImeName write SetImeName stored IsImeNameStored;
    property  PickList: TStrings read GetPickList write SetPickList;
    property  PopupMenu: TPopupMenu read FPopupMenu write SetPopupMenu;
    property  ReadOnly: Boolean read GetReadOnly write SetReadOnly
      stored IsReadOnlyStored;
    property  Title: TColumnTitle read FTitle write SetTitle;
    property  Width: Integer read GetWidth write SetWidth stored IsWidthStored;
  end;

  TColumnClass = class of TColumn;

  TDBGridColumnsState = (csDefault, csCustomized);

  TDBGridColumns = class(TCollection)
  private
    FGrid: TCustomVDBGrid;
    function GetColumn(Index: Integer): TColumn;
    function GetState: TDBGridColumnsState;
    procedure SetColumn(Index: Integer; Value: TColumn);
    procedure SetState(NewState: TDBGridColumnsState);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(Grid: TCustomVDBGrid; ColumnClass: TColumnClass);
    function  Add: TColumn;
    procedure LoadFromFile(const Filename: string);
    procedure LoadFromStream(S: TStream);
    procedure RestoreDefaults;
    procedure RebuildColumns;
    procedure SaveToFile(const Filename: string);
    procedure SaveToStream(S: TStream);
    property State: TDBGridColumnsState read GetState write SetState;
    property Grid: TCustomVDBGrid read FGrid;
    property Items[Index: Integer]: TColumn read GetColumn write SetColumn; default;
  end;

  TGridDataLink = class(TDataLink)
  private
    FGrid: TCustomVDBGrid;
    FFieldCount: Integer;
    FFieldMapSize: Integer;
    FFieldMap: Pointer;
    FModified: Boolean;
    FInUpdateData: Boolean;
    FSparseMap: Boolean;
    function GetDefaultFields: Boolean;
    function GetFields(I: Integer): TField;
  protected
    procedure ActiveChanged; override;
    procedure DataSetChanged; override;
    procedure DataSetScrolled(Distance: Integer); override;
    procedure FocusControl(Field: TFieldRef); override;
    procedure EditingChanged; override;
    procedure LayoutChanged; override;
    procedure RecordChanged(Field: TField); override;
    procedure UpdateData; override;
    function  GetMappedIndex(ColIndex: Integer): Integer;
  public
    constructor Create(AGrid: TCustomVDBGrid);
    destructor Destroy; override;
    function AddMapping(const FieldName: string): Boolean;
    procedure ClearMapping;
    procedure Modified;
    procedure Reset;
    property DefaultFields: Boolean read GetDefaultFields;
    property FieldCount: Integer read FFieldCount;
    property Fields[I: Integer]: TField read GetFields;
    property SparseMap: Boolean read FSparseMap write FSparseMap;
  end;

  TBookmarkList = class
  private
    FList: TStringList;
    FGrid: TCustomVDBGrid;
    FCache: TBookmarkStr;
    FCacheIndex: Integer;
    FCacheFind: Boolean;
    FLinkActive: Boolean;
    function GetCount: Integer;
    function GetCurrentRowSelected: Boolean;
    function GetItem(Index: Integer): TBookmarkStr;
    procedure SetCurrentRowSelected(Value: Boolean);
    procedure StringsChanged(Sender: TObject);
  protected
    function CurrentRow: TBookmarkStr;
    function Compare(const Item1, Item2: TBookmarkStr): Integer;
    procedure LinkActive(Value: Boolean);
  public
    constructor Create(AGrid: TCustomVDBGrid);
    destructor Destroy; override;
    procedure Clear;           // free all bookmarks
    procedure Delete;          // delete all selected rows from dataset
    function  Find(const Item: TBookmarkStr; var Index: Integer): Boolean;
    function  IndexOf(const Item: TBookmarkStr): Integer;
    function  Refresh: Boolean;// drop orphaned bookmarks; True = orphans found
    property Count: Integer read GetCount;
    property CurrentRowSelected: Boolean read GetCurrentRowSelected
      write SetCurrentRowSelected;
    property Items[Index: Integer]: TBookmarkStr read GetItem; default;
  end;

  TDBGridOption = (dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator,
    dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect,
    dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect);
  TDBGridOptions = set of TDBGridOption;

  { The VDBGrid's DrawDataCell virtual method and OnDrawDataCell event are only
    called when the grid's Columns.State is csDefault.  This is for compatibility
    with existing code. These routines don't provide sufficient information to
    determine which column is being drawn, so the column attributes aren't
    easily accessible in these routines.  Column attributes also introduce the
    possibility that a column's field may be nil, which would break existing
    DrawDataCell code.   DrawDataCell, OnDrawDataCell, and DefaultDrawDataCell
    are obsolete, retained for compatibility purposes. }
  TDrawDataCellEvent = procedure (Sender: TObject; const Rect: TRect; Field: TField;
    State: TGridDrawState) of object;

  { The VDBGrid's DrawColumnCell virtual method and OnDrawColumnCell event are
    always called, when the grid has defined column attributes as well as when
    it is in default mode.  These new routines provide the additional
    information needed to access the column attributes for the cell being
    drawn, and must support nil fields.  }

  TDrawColumnCellEvent = procedure (Sender: TObject; const Rect: TRect;
    DataCol: Integer; Column: TColumn; State: TGridDrawState) of object;
  TDBGridClickEvent = procedure (Column: TColumn) of object;

  TCustomVDBGrid = class(TCustomGrid)
  private
    FIndicators: TImageList;
    FTitleFont: TFont;
    FReadOnly: Boolean;
    FOriginalImeName: TImeName;
    FOriginalImeMode: TImeMode;
    FUserChange: Boolean;
    FLayoutFromDataset: Boolean;
    FOptions: TDBGridOptions;
    FTitleOffset, FIndicatorOffset: Byte;
    FUpdateLock: Byte;
    FLayoutLock: Byte;
    FInColExit: Boolean;
    FDefaultDrawing: Boolean;
    FSelfChangingTitleFont: Boolean;
    FSelecting: Boolean;
    FSelRow: Integer;
    FDataLink: TGridDataLink;
    FOnColEnter: TNotifyEvent;
    FOnColExit: TNotifyEvent;
    FOnDrawDataCell: TDrawDataCellEvent;
    FOnDrawColumnCell: TDrawColumnCellEvent;
    FEditText: string;
    FColumns: TDBGridColumns;
    FOnEditButtonClick: TNotifyEvent;
    FOnColumnMoved: TMovedEvent;
    FBookmarks: TBookmarkList;
    FSelectionAnchor: TBookmarkStr;
    FVertical: Boolean;
    FOnlyOne: Boolean; 
    FTitlesWidth: integer;
    FOnCellClick: TDBGridClickEvent;
    FOnTitleClick:TDBGridClickEvent;
    function AcquireFocus: Boolean;
    procedure DataChanged;
    procedure EditingChanged;
    function GetDataSource: TDataSource;
    function GetFieldCount: Integer;
    function GetFields(FieldIndex: Integer): TField;
    function GetSelectedField: TField;
    function GetSelectedIndex: Integer;
    procedure InternalLayout;
    procedure MoveCol(RawCol: Integer);
    procedure ReadColumns(Reader: TReader);
    procedure RecordChanged(Field: TField);
    procedure SetIme;
    procedure SetColumns(Value: TDBGridColumns);
    procedure SetDataSource(Value: TDataSource);
    procedure SetOptions(Value: TDBGridOptions);
    procedure SetSelectedField(Value: TField);
    procedure SetSelectedIndex(Value: Integer);
    procedure SetTitleFont(Value: TFont);
    procedure TitleFontChanged(Sender: TObject);
    procedure UpdateData;
    procedure UpdateActive;
    procedure UpdateIme;
    procedure UpdateScrollBar;
    procedure UpdateRowCount;
    procedure WriteColumns(Writer: TWriter);
    procedure SetVertical(Value: Boolean); 
    procedure SetOnlyOne(Value: Boolean); 
    procedure SetTitlesWidth(Value: integer); 
    function TabStopRow(Arow: integer): Boolean;
    procedure CMExit(var Message: TMessage); message CM_EXIT;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMParentFontChanged(var Message: TMessage); message CM_PARENTFONTCHANGED;
    procedure CMDeferLayout(var Message); message cm_DeferLayout;
    procedure CMDesignHitTest(var Msg: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMIMEStartComp(var Message: TMessage); message WM_IME_STARTCOMPOSITION;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SetFOCUS;
    procedure WMKillFocus(var Message: TMessage); message WM_KillFocus;
  protected
    FUpdateFields: Boolean;
    FAcquireFocus: Boolean;
    FUpdatingEditor: Boolean;
    function  RawToDataColumn(ACol: Integer): Integer;
    function  DataToRawColumn(ACol: Integer): Integer;
    function  AcquireLayoutLock: Boolean;
    procedure BeginLayout;
    procedure BeginUpdate;
    procedure CancelLayout;
    function  CanEditAcceptKey(Key: Char): Boolean; override;
    function  CanEditModify: Boolean; override;
    function  CanEditShow: Boolean; override;
    procedure CellClick(Column: TColumn); dynamic;
    procedure ColumnMoved(FromIndex, ToIndex: Longint); override;
    procedure RowMoved(FromIndex, ToIndex: Longint); override;
    procedure ColEnter; dynamic;
    procedure ColExit; dynamic;
    procedure ColWidthsChanged; override;
    function  CreateColumns: TDBGridColumns; dynamic;
    function  CreateEditor: TInplaceEdit; override;
    procedure CreateWnd; override;
    procedure DeferLayout;
    procedure DefaultHandler(var Msg); override;
    procedure DefineFieldMap; virtual;
    procedure DefineProperties(Filer: TFiler); override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
    procedure DrawDataCell(const Rect: TRect; Field: TField;
      State: TGridDrawState); dynamic; { obsolete }
    procedure DrawColumnCell(const Rect: TRect; DataCol: Integer;
      Column: TColumn; State: TGridDrawState); dynamic;
    procedure EditButtonClick; dynamic;
    procedure EndLayout;
    procedure EndUpdate;
    function  GetColField(DataCol: Integer): TField;
    function  GetEditLimit: Integer; override;
    function  GetEditMask(ACol, ARow: Longint): string; override;
    function  GetEditText(ACol, ARow: Longint): string; override;
    function  GetFieldValue(ACol: Integer): string;
    function  HighlightCell(DataCol, DataRow: Integer; const Value: string;
      AState: TGridDrawState): Boolean; virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure LayoutChanged; virtual;
    procedure LinkActive(Value: Boolean); virtual;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Scroll(Distance: Integer); virtual;
    procedure SetColumnAttributes; virtual;
    procedure SetEditText(ACol, ARow: Longint; const Value: string); override;
    function  StoreColumns: Boolean;
    procedure TimedScroll(Direction: TGridScrollDirection); override;
    procedure TitleClick(Column: TColumn); dynamic;
    property Columns: TDBGridColumns read FColumns write SetColumns;
    property DefaultDrawing: Boolean read FDefaultDrawing write FDefaultDrawing default True;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DataLink: TGridDataLink read FDataLink;
    property IndicatorOffset: Byte read FIndicatorOffset;
    property LayoutLock: Byte read FLayoutLock;
    property Options: TDBGridOptions read FOptions write SetOptions
      default [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines,
      dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit];
    property ParentColor default False;
    property ReadOnly: Boolean read FReadOnly write FReadOnly default False;
    property SelectedRows: TBookmarkList read FBookmarks;
    property TitleFont: TFont read FTitleFont write SetTitleFont;
    property UpdateLock: Byte read FUpdateLock;
    property OnColEnter: TNotifyEvent read FOnColEnter write FOnColEnter;
    property OnColExit: TNotifyEvent read FOnColExit write FOnColExit;
    property OnDrawDataCell: TDrawDataCellEvent read FOnDrawDataCell
      write FOnDrawDataCell; { obsolete }
    property OnDrawColumnCell: TDrawColumnCellEvent read FOnDrawColumnCell
      write FOnDrawColumnCell;
    property OnEditButtonClick: TNotifyEvent read FOnEditButtonClick
      write FOnEditButtonClick;
    property OnColumnMoved: TMovedEvent read FOnColumnMoved write FOnColumnMoved;
    property OnCellClick: TDBGridClickEvent read FOnCellClick write FOnCellClick;
    property OnTitleClick: TDBGridClickEvent read FOnTitleClick write FOnTitleClick;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DefaultDrawDataCell(const Rect: TRect; Field: TField;
      State: TGridDrawState); { obsolete }
    procedure DefaultDrawColumnCell(const Rect: TRect; DataCol: Integer;
      Column: TColumn; State: TGridDrawState);
    function ValidFieldIndex(FieldIndex: Integer): Boolean;
    property EditorMode;
    property FieldCount: Integer read GetFieldCount;
    property Fields[FieldIndex: Integer]: TField read GetFields;
    property SelectedField: TField read GetSelectedField write SetSelectedField;
    property SelectedIndex: Integer read GetSelectedIndex write SetSelectedIndex;
    property Vertical: Boolean read FVertical write SetVertical default False;
    property OnlyOne: Boolean read FOnlyOne write SetOnlyOne default False;
    property TitlesWidth: integer read FTitlesWidth write SetTitlesWidth;
  end;

  TVDBGrid = class(TCustomVDBGrid)
  public
    property Canvas;
    property SelectedRows;
  published
    property Align;
    property BorderStyle;
    property Color;
    property Columns stored False; //StoreColumns;
    property Ctl3D;
    property DataSource;
    property DefaultDrawing;
    property DragCursor;
    property DragMode;
    property Enabled;
    property FixedColor;
    property Font;
    property ImeMode;
    property ImeName;
    property Options;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property TitleFont;
    property Visible;
    property Vertical;
    property OnlyOne; 
    property DefaultColWidth; 
    property TitlesWidth; 
    property OnCellClick;
    property OnColEnter;
    property OnColExit;
    property OnColumnMoved;
    property OnDrawDataCell;  { obsolete }
    property OnDrawColumnCell;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditButtonClick;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnStartDrag;
    property OnTitleClick;
  end;

const
  IndicatorWidth = 11;

procedure Register;

implementation

uses DBConsts, Dialogs;

{$R dbvgrids.res}

procedure Register;
begin
  RegisterComponents('Data Controls',  [ TVDBGrid ]);
//  RegisterPropertyEditor(TypeInfo(TDBGridColumns), TCustomVDBGrid,
//                        'Columns', TDBGridColumnsEditor);
end;

const
  bmArrow = 'DBVGARROW';
  bmEdit = 'DBVEDIT';
  bmInsert = 'DBVINSERT';
  bmMultiDot = 'DBVMULTIDOT';
  bmMultiArrow = 'DBVMULTIARROW';

  MaxMapSize = (MaxInt div 2) div SizeOf(Integer);  { 250 million }

{ Error reporting }

procedure RaiseGridError(const S: string);
begin
  raise EInvalidGridOperation.Create(S);
end;

procedure KillMessage(Wnd: HWnd; Msg: Integer);
// Delete the requested message from the queue, but throw back
// any WM_QUIT msgs that PeekMessage may also return
var
  M: TMsg;
begin
  M.Message := 0;
  if PeekMessage(M, Wnd, Msg, Msg, pm_Remove) and (M.Message = WM_QUIT) then
    PostQuitMessage(M.wparam);
end;

{ TVDBGridInplaceEdit }

{ TVDBGridInplaceEdit adds support for a button on the in-place editor,
  which can be used to drop down a table-based lookup list, a stringlist-based
  pick list, or (if button style is esEllipsis) fire the grid event
  OnEditButtonClick.  }

type
  TEditStyle = (esSimple, esEllipsis, esPickList, esDataList);
  TPopupListbox = class;

  TVDBGridInplaceEdit = class(TInplaceEdit)
  private
    FButtonWidth: Integer;
    FDataList: TDBLookupListBox;
    FPickList: TPopupListbox;
    FActiveList: TWinControl;
    FLookupSource: TDatasource;
    FEditStyle: TEditStyle;
    FListVisible: Boolean;
    FTracking: Boolean;
    FPressed: Boolean;
    procedure ListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SetEditStyle(Value: TEditStyle);
    procedure StopTracking;
    procedure TrackButton(X,Y: Integer);
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CancelMode;
    procedure WMCancelMode(var Message: TMessage); message WM_CancelMode;
    procedure WMKillFocus(var Message: TMessage); message WM_KillFocus;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message wm_LButtonDblClk;
    procedure WMPaint(var Message: TWMPaint); message wm_Paint;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SetCursor;
  protected
    procedure BoundsChanged; override;
    procedure CloseUp(Accept: Boolean);
    procedure DoDropDownKeys(var Key: Word; Shift: TShiftState);
    procedure DropDown;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure PaintWindow(DC: HDC); override;
    procedure UpdateContents; override;
    procedure WndProc(var Message: TMessage); override;
    property  EditStyle: TEditStyle read FEditStyle write SetEditStyle;
    property  ActiveList: TWinControl read FActiveList write FActiveList;
    property  DataList: TDBLookupListBox read FDataList;
    property  PickList: TPopupListbox read FPickList;
  public
    constructor Create(Owner: TComponent); override;
  end;

{ TPopupListbox }

  TPopupListbox = class(TCustomListbox)
  private
    FSearchText: String;
    FSearchTickCount: Longint;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  end;

procedure TPopupListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or WS_BORDER;
    ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
    WindowClass.Style := CS_SAVEBITS;
  end;
end;

procedure TPopupListbox.CreateWnd;
begin
  inherited CreateWnd;
  Windows.SetParent(Handle, 0);
  CallWindowProc(DefWndProc, Handle, wm_SetFocus, 0, 0);
end;

procedure TPopupListbox.Keypress(var Key: Char);
var
  TickCount: Integer;
begin
  case Key of
    #8, #27: FSearchText := '';
    #32..#255:
      begin
        TickCount := GetTickCount;
        if TickCount - FSearchTickCount > 2000 then FSearchText := '';
        FSearchTickCount := TickCount;
        if Length(FSearchText) < 32 then FSearchText := FSearchText + Key;
        SendMessage(Handle, LB_SelectString, WORD(-1), Longint(PChar(FSearchText)));
        Key := #0;
      end;
  end;
  inherited Keypress(Key);
end;

procedure TPopupListbox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  TVDBGridInPlaceEdit(Owner).CloseUp((X >= 0) and (Y >= 0) and
      (X < Width) and (Y < Height));
end;


constructor TVDBGridInplaceEdit.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  FLookupSource := TDataSource.Create(Self);
  FButtonWidth := GetSystemMetrics(SM_CXVSCROLL);
  FEditStyle := esSimple;
end;

procedure TVDBGridInplaceEdit.BoundsChanged;
var
  R: TRect;
begin
  SetRect(R, 2, 2, Width - 2, Height);
  if FEditStyle <> esSimple then Dec(R.Right, FButtonWidth);
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@R));
  SendMessage(Handle, EM_SCROLLCARET, 0, 0);
  if SysLocale.Fareast then
    SetImeCompositionWindow(Font, R.Left, R.Top);
end;

procedure TVDBGridInplaceEdit.CloseUp(Accept: Boolean);
var
  MasterField: TField;
  ListValue: Variant;
begin
  if FListVisible then
  begin
    if GetCapture <> 0 then SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
    if FActiveList = FDataList then
      ListValue := FDataList.KeyValue
    else
      if FPickList.ItemIndex <> -1 then
        ListValue := FPickList.Items[FPicklist.ItemIndex];
    SetWindowPos(FActiveList.Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or
      SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);
    FListVisible := False;
    if Assigned(FDataList) then
      FDataList.ListSource := nil;
    FLookupSource.Dataset := nil;
    Invalidate;
    if Accept then
      if FActiveList = FDataList then
        with TCustomVDBGrid(Grid), Columns[SelectedIndex].Field do
        begin
          MasterField := DataSet.FieldByName(KeyFields);
          if MasterField.CanModify then
          begin
            DataSet.Edit;
            MasterField.Value := ListValue;
          end;
        end
      else
        if (not VarIsNull(ListValue)) and EditCanModify then
          with TCustomVDBGrid(Grid), Columns[SelectedIndex].Field do
            Text := ListValue;
  end;
end;

procedure TVDBGridInplaceEdit.DoDropDownKeys(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_UP, VK_DOWN:
      if ssAlt in Shift then
      begin
        if FListVisible then CloseUp(True) else DropDown;
        Key := 0;
      end;
    VK_RETURN, VK_ESCAPE:
      if FListVisible and not (ssAlt in Shift) then
      begin
        CloseUp(Key = VK_RETURN);
        Key := 0;
      end;
  end;
end;

procedure TVDBGridInplaceEdit.DropDown;
var
  P: TPoint;
  I,J,Y: Integer;
  Column: TColumn;
begin
  if not FListVisible and Assigned(FActiveList) then
  begin
    FActiveList.Width := Width;
    with TCustomVDBGrid(Grid) do
      Column := Columns[SelectedIndex];
    if FActiveList = FDataList then
    with Column.Field do
    begin
      FDataList.Color := Color;
      FDataList.Font := Font;
      FDataList.RowCount := Column.DropDownRows;
      FLookupSource.DataSet := LookupDataSet;
      FDataList.KeyField := LookupKeyFields;
      FDataList.ListField := LookupResultField;
      FDataList.ListSource := FLookupSource;
      FDataList.KeyValue := DataSet.FieldByName(KeyFields).Value;
{      J := Column.DefaultWidth;
      if J > FDataList.ClientWidth then
        FDataList.ClientWidth := J;
}    end
    else
    begin
      FPickList.Color := Color;
      FPickList.Font := Font;
      FPickList.Items := Column.Picklist;
      if FPickList.Items.Count >= Column.DropDownRows then
        FPickList.Height := Column.DropDownRows * FPickList.ItemHeight + 4
      else
        FPickList.Height := FPickList.Items.Count * FPickList.ItemHeight + 4;
      if Column.Field.IsNull then
        FPickList.ItemIndex := -1
      else
        FPickList.ItemIndex := FPickList.Items.IndexOf(Column.Field.Value);
      J := FPickList.ClientWidth;
      for I := 0 to FPickList.Items.Count - 1 do
      begin
        Y := FPickList.Canvas.TextWidth(FPickList.Items[I]);
        if Y > J then J := Y;
      end;
      FPickList.ClientWidth := J;
    end;
    P := Parent.ClientToScreen(Point(Left, Top));
    Y := P.Y + Height;
    if Y + FActiveList.Height > Screen.Height then Y := P.Y - FActiveList.Height;
    SetWindowPos(FActiveList.Handle, HWND_TOP, P.X, Y, 0, 0,
      SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWINDOW);
    FListVisible := True;
    Invalidate;
    Windows.SetFocus(Handle);
  end;
end;

type
  TWinControlCracker = class(TWinControl) end;

procedure TVDBGridInplaceEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (EditStyle = esEllipsis) and (Key = VK_RETURN) and (Shift = [ssCtrl]) then
  begin
    TCustomVDBGrid(Grid).EditButtonClick;
    KillMessage(Handle, WM_CHAR);
  end
  else
    inherited KeyDown(Key, Shift);
end;

procedure TVDBGridInplaceEdit.ListMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    CloseUp(PtInRect(FActiveList.ClientRect, Point(X, Y)));
end;

procedure TVDBGridInplaceEdit.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if (Button = mbLeft) and (FEditStyle <> esSimple) and
    PtInRect(Rect(Width - FButtonWidth, 0, Width, Height), Point(X,Y)) then
  begin
    if FListVisible then
      CloseUp(False)
    else
    begin
      MouseCapture := True;
      FTracking := True;
      TrackButton(X, Y);
      if Assigned(FActiveList) then
        DropDown;
    end;
  end;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TVDBGridInplaceEdit.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  ListPos: TPoint;
  MousePos: TSmallPoint;
begin
  if FTracking then
  begin
    TrackButton(X, Y);
    if FListVisible then
    begin
      ListPos := FActiveList.ScreenToClient(ClientToScreen(Point(X, Y)));
      if PtInRect(FActiveList.ClientRect, ListPos) then
      begin
        StopTracking;
        MousePos := PointToSmallPoint(ListPos);
        SendMessage(FActiveList.Handle, WM_LBUTTONDOWN, 0, Integer(MousePos));
        Exit;
      end;
    end;
  end;
  inherited MouseMove(Shift, X, Y);
end;

procedure TVDBGridInplaceEdit.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  WasPressed: Boolean;
begin
  WasPressed := FPressed;
  StopTracking;
  if (Button = mbLeft) and (FEditStyle = esEllipsis) and WasPressed then
    TCustomVDBGrid(Grid).EditButtonClick;
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TVDBGridInplaceEdit.PaintWindow(DC: HDC);
var
  R: TRect;
  Flags: Integer;
  W: Integer;
begin
  if FEditStyle <> esSimple then
  begin
    SetRect(R, Width - FButtonWidth, 0, Width, Height);
    Flags := 0;
    if FEditStyle in [esDataList, esPickList] then
    begin
      if FActiveList = nil then
        Flags := DFCS_INACTIVE
      else if FPressed then
        Flags := DFCS_FLAT or DFCS_PUSHED;
      DrawFrameControl(DC, R, DFC_SCROLL, Flags or DFCS_SCROLLCOMBOBOX);
    end
    else   { esEllipsis }
    begin
      if FPressed then
        Flags := BF_FLAT;
      DrawEdge(DC, R, EDGE_RAISED, BF_RECT or BF_MIDDLE or Flags);
      Flags := ((R.Right - R.Left) shr 1) - 1 + Ord(FPressed);
      W := Height shr 3;
      if W = 0 then W := 1;
      PatBlt(DC, R.Left + Flags, R.Top + Flags, W, W, BLACKNESS);
      PatBlt(DC, R.Left + Flags - (W * 2), R.Top + Flags, W, W, BLACKNESS);
      PatBlt(DC, R.Left + Flags + (W * 2), R.Top + Flags, W, W, BLACKNESS);
    end;
    ExcludeClipRect(DC, R.Left, R.Top, R.Right, R.Bottom);
  end;
  inherited PaintWindow(DC);
end;

procedure TVDBGridInplaceEdit.SetEditStyle(Value: TEditStyle);
begin
  if Value = FEditStyle then Exit;
  FEditStyle := Value;
  case Value of
    esPickList:
      begin
        if FPickList = nil then
        begin
          FPickList := TPopupListbox.Create(Self);
          FPickList.Visible := False;
          FPickList.Parent := Self;
          FPickList.OnMouseUp := ListMouseUp;
          FPickList.IntegralHeight := True;
          FPickList.ItemHeight := 11;
        end;
        FActiveList := FPickList;
      end;
    esDataList:
      begin
        if FDataList = nil then
        begin
          FDataList := TPopupDataList.Create(Self);
          FDataList.Visible := False;
          FDataList.Parent := Self;
          FDataList.OnMouseUp := ListMouseUp;
        end;
        FActiveList := FDataList;
      end;
  else  { cbsNone, cbsEllipsis, or read only field }
    FActiveList := nil;
  end;
  with TCustomVDBGrid(Grid) do
    Self.ReadOnly := Columns[SelectedIndex].ReadOnly;
  Repaint;
end;

procedure TVDBGridInplaceEdit.StopTracking;
begin
  if FTracking then
  begin
    TrackButton(-1, -1);
    FTracking := False;
    MouseCapture := False;
  end;
end;

procedure TVDBGridInplaceEdit.TrackButton(X,Y: Integer);
var
  NewState: Boolean;
  R: TRect;
begin
  SetRect(R, ClientWidth - FButtonWidth, 0, ClientWidth, ClientHeight);
  NewState := PtInRect(R, Point(X, Y));
  if FPressed <> NewState then
  begin
    FPressed := NewState;
    InvalidateRect(Handle, @R, False);
  end;
end;

procedure TVDBGridInplaceEdit.UpdateContents;
var
  Column: TColumn;
  NewStyle: TEditStyle;
  MasterField: TField;
begin
  with TCustomVDBGrid(Grid) do
    Column := Columns[SelectedIndex];
  NewStyle := esSimple;
  case Column.ButtonStyle of
   cbsEllipsis: NewStyle := esEllipsis;
   cbsAuto:
     if Assigned(Column.Field) then
     with Column.Field do
     begin
       { Show the dropdown button only if the field is editable }
       if FieldKind = fkLookup then
       begin
         MasterField := Dataset.FieldByName(KeyFields);
         { Column.DefaultReadonly will always be True for a lookup field.
           Test if Column.ReadOnly has been assigned a value of True }
         if Assigned(MasterField) and MasterField.CanModify and
           not ((cvReadOnly in Column.AssignedValues) and Column.ReadOnly) then
           with TCustomVDBGrid(Grid) do
             if not ReadOnly and DataLink.Active and not Datalink.ReadOnly then
               NewStyle := esDataList
       end
       else
       if Assigned(Column.Picklist) and (Column.PickList.Count > 0) and
         not Column.Readonly then
         NewStyle := esPickList;
     end;
  end;
  EditStyle := NewStyle;
  inherited UpdateContents;
end;

procedure TVDBGridInplaceEdit.CMCancelMode(var Message: TCMCancelMode);
begin
  if (Message.Sender <> Self) and (Message.Sender <> FActiveList) then
    CloseUp(False);
end;

procedure TVDBGridInplaceEdit.WMCancelMode(var Message: TMessage);
begin
  StopTracking;
  inherited;
end;

procedure TVDBGridInplaceEdit.WMKillFocus(var Message: TMessage);
begin
  if SysLocale.FarEast then
  begin
    ImeName := Screen.DefaultIme;
    ImeMode := imDontCare;
  end;
  inherited;
  CloseUp(False);
end;

procedure TVDBGridInplaceEdit.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  with Message do
  if (FEditStyle <> esSimple) and
    PtInRect(Rect(Width - FButtonWidth, 0, Width, Height), Point(XPos, YPos)) then
    Exit;
  inherited;
end;

procedure TVDBGridInplaceEdit.WMPaint(var Message: TWMPaint);
begin
  PaintHandler(Message);
end;

procedure TVDBGridInplaceEdit.WMSetCursor(var Message: TWMSetCursor);
var
  P: TPoint;
begin
  GetCursorPos(P);
  if (FEditStyle <> esSimple) and
    PtInRect(Rect(Width - FButtonWidth, 0, Width, Height), ScreenToClient(P)) then
    Windows.SetCursor(LoadCursor(0, idc_Arrow))
  else
    inherited;
end;

procedure TVDBGridInplaceEdit.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    wm_KeyDown, wm_SysKeyDown, wm_Char:
      if EditStyle in [esPickList, esDataList] then
      with TWMKey(Message) do
      begin
        DoDropDownKeys(CharCode, KeyDataToShiftState(KeyData));
        if (CharCode <> 0) and FListVisible then
        begin
          with TMessage(Message) do
            SendMessage(FActiveList.Handle, Msg, WParam, LParam);
          Exit;
        end;
      end
  end;
  inherited;
end;


{ TGridDataLink }

type
  TIntArray = array[0..MaxMapSize] of Integer;
  PIntArray = ^TIntArray;

constructor TGridDataLink.Create(AGrid: TCustomVDBGrid);
begin
  inherited Create;
  FGrid := AGrid;
end;

destructor TGridDataLink.Destroy;
begin
  ClearMapping;
  inherited Destroy;
end;

function TGridDataLink.GetDefaultFields: Boolean;
var
  I: Integer;
begin
  Result := True;
  if DataSet <> nil then Result := DataSet.DefaultFields;
  if Result and SparseMap then
  for I := 0 to FFieldCount-1 do
    if PIntArray(FFieldMap)^[I] < 0 then
    begin
      Result := False;
      Exit;
    end;
end;

function TGridDataLink.GetFields(I: Integer): TField;
begin
  if (0 <= I) and (I < FFieldCount) and (PIntArray(FFieldMap)^[I] >= 0) then
    Result := DataSet.Fields[PIntArray(FFieldMap)^[I]]
  else
    Result := nil;
end;

function TGridDataLink.AddMapping(const FieldName: string): Boolean;
var
  Field: TField;
  NewSize: Integer;
begin
  Result := True;
  if FFieldCount >= MaxMapSize then RaiseGridError(STooManyColumns);
  if SparseMap then
    Field := DataSet.FindField(FieldName)
  else
    Field := DataSet.FieldByName(FieldName);

  if FFieldCount = FFieldMapSize then
  begin
    NewSize := FFieldMapSize;
    if NewSize = 0 then
      NewSize := 8
    else
      Inc(NewSize, NewSize);
    if (NewSize < FFieldCount) then
      NewSize := FFieldCount + 1;
    if (NewSize > MaxMapSize) then
      NewSize := MaxMapSize;
    ReallocMem(FFieldMap, NewSize * SizeOf(Integer));
    FFieldMapSize := NewSize;
  end;
  if Assigned(Field) then
  begin
    PIntArray(FFieldMap)^[FFieldCount] := Field.Index;
    Field.FreeNotification(FGrid);
  end
  else
    PIntArray(FFieldMap)^[FFieldCount] := -1;
  Inc(FFieldCount);
end;

procedure TGridDataLink.ActiveChanged;
begin
  FGrid.LinkActive(Active);
end;

procedure TGridDataLink.ClearMapping;
begin
  if FFieldMap <> nil then
  begin
    FreeMem(FFieldMap, FFieldMapSize * SizeOf(Integer));
    FFieldMap := nil;
    FFieldMapSize := 0;
    FFieldCount := 0;
  end;
end;

procedure TGridDataLink.Modified;
begin
  FModified := True;
end;

procedure TGridDataLink.DataSetChanged;
begin
  FGrid.DataChanged;
  FModified := False;
end;

procedure TGridDataLink.DataSetScrolled(Distance: Integer);
begin
  FGrid.Scroll(Distance);
end;

procedure TGridDataLink.LayoutChanged;
var
  SaveState: Boolean;
begin
  { FLayoutFromDataset determines whether default column width is forced to
    be at least wide enough for the column title.  }
  SaveState := FGrid.FLayoutFromDataset;
  FGrid.FLayoutFromDataset := True;
  try
    FGrid.LayoutChanged;
  finally
    FGrid.FLayoutFromDataset := SaveState;
  end;
  inherited LayoutChanged;
end;

procedure TGridDataLink.FocusControl(Field: TFieldRef);
begin
  if Assigned(Field) and Assigned(Field^) then
  begin
    FGrid.SelectedField := Field^;
    if (FGrid.SelectedField = Field^) and FGrid.AcquireFocus then
    begin
      Field^ := nil;
      FGrid.ShowEditor;
    end;
  end;
end;

procedure TGridDataLink.EditingChanged;
begin
  FGrid.EditingChanged;
end;

procedure TGridDataLink.RecordChanged(Field: TField);
begin
  FGrid.RecordChanged(Field);
  FModified := False;
end;

procedure TGridDataLink.UpdateData;
begin
  FInUpdateData := True;
  try
    if FModified then FGrid.UpdateData;
    FModified := False;
  finally
    FInUpdateData := False;
  end;
end;

function TGridDataLink.GetMappedIndex(ColIndex: Integer): Integer;
begin
  if (0 <= ColIndex) and (ColIndex < FFieldCount) then
    Result := PIntArray(FFieldMap)^[ColIndex]
  else
    Result := -1;
end;

procedure TGridDataLink.Reset;
begin
  if FModified then RecordChanged(nil) else Dataset.Cancel;
end;


{ TColumnTitle }
constructor TColumnTitle.Create(Column: TColumn);
begin
  inherited Create;
  FColumn := Column;
  FFont := TFont.Create;
  FFont.Assign(DefaultFont);
  FFont.OnChange := FontChanged;
end;

destructor TColumnTitle.Destroy;
begin
  FFont.Free;
  inherited Destroy;
end;

procedure TColumnTitle.Assign(Source: TPersistent);
begin
  if Source is TColumnTitle then
  begin
    if cvTitleAlignment in TColumnTitle(Source).FColumn.FAssignedValues then
      Alignment := TColumnTitle(Source).Alignment;
    if cvTitleColor in TColumnTitle(Source).FColumn.FAssignedValues then
      Color := TColumnTitle(Source).Color;
    if cvTitleCaption in TColumnTitle(Source).FColumn.FAssignedValues then
      Caption := TColumnTitle(Source).Caption;
    if cvTitleFont in TColumnTitle(Source).FColumn.FAssignedValues then
      Font := TColumnTitle(Source).Font;
  end
  else
    inherited Assign(Source);
end;

function TColumnTitle.DefaultAlignment: TAlignment;
begin
  Result := taLeftJustify;
end;

function TColumnTitle.DefaultColor: TColor;
var
  Grid: TCustomVDBGrid;
begin
  Grid := FColumn.GetGrid;
  if Assigned(Grid) then
    Result := Grid.FixedColor
  else
    Result := clBtnFace;
end;

function TColumnTitle.DefaultFont: TFont;
var
  Grid: TCustomVDBGrid;
begin
  Grid := FColumn.GetGrid;
  if Assigned(Grid) then
    Result := Grid.TitleFont
  else
    Result := FColumn.Font;
end;

function TColumnTitle.DefaultCaption: string;
var
  Field: TField;
begin
  Field := FColumn.Field;
  if Assigned(Field) then
    Result := Field.DisplayName
  else
    Result := FColumn.FieldName;
end;

procedure TColumnTitle.FontChanged(Sender: TObject);
begin
  Include(FColumn.FAssignedValues, cvTitleFont);
  FColumn.Changed(True);
end;

function TColumnTitle.GetAlignment: TAlignment;
begin
  if cvTitleAlignment in FColumn.FAssignedValues then
    Result := FAlignment
  else
    Result := DefaultAlignment;
end;

function TColumnTitle.GetColor: TColor;
begin
  if cvTitleColor in FColumn.FAssignedValues then
    Result := FColor
  else
    Result := DefaultColor;
end;

function TColumnTitle.GetCaption: string;
begin
  if cvTitleCaption in FColumn.FAssignedValues then
    Result := FCaption
  else
    Result := DefaultCaption;
end;

function TColumnTitle.GetFont: TFont;
var
  Save: TNotifyEvent;
  Def: TFont;
begin
  if not (cvTitleFont in FColumn.FAssignedValues) then
  begin
    Def := DefaultFont;
    if (FFont.Handle <> Def.Handle) or (FFont.Color <> Def.Color) then
    begin
      Save := FFont.OnChange;
      FFont.OnChange := nil;
      FFont.Assign(DefaultFont);
      FFont.OnChange := Save;
    end;
  end;
  Result := FFont;
end;

function TColumnTitle.IsAlignmentStored: Boolean;
begin
  Result := (cvTitleAlignment in FColumn.FAssignedValues) and
    (FAlignment <> DefaultAlignment);
end;

function TColumnTitle.IsColorStored: Boolean;
begin
  Result := (cvTitleColor in FColumn.FAssignedValues) and
    (FColor <> DefaultColor);
end;

function TColumnTitle.IsFontStored: Boolean;
begin
  Result := (cvTitleFont in FColumn.FAssignedValues);
end;

function TColumnTitle.IsCaptionStored: Boolean;
begin
  Result := (cvTitleCaption in FColumn.FAssignedValues) and
    (FCaption <> DefaultCaption);
end;

procedure TColumnTitle.RefreshDefaultFont;
var
  Save: TNotifyEvent;
begin
  if (cvTitleFont in FColumn.FAssignedValues) then Exit;
  Save := FFont.OnChange;
  FFont.OnChange := nil;
  try
    FFont.Assign(DefaultFont);
  finally
    FFont.OnChange := Save;
  end;
end;

procedure TColumnTitle.RestoreDefaults;
var
  FontAssigned: Boolean;
begin
  FontAssigned := cvTitleFont in FColumn.FAssignedValues;
  FColumn.FAssignedValues := FColumn.FAssignedValues - ColumnTitleValues;
  FCaption := '';
  RefreshDefaultFont;
  { If font was assigned, changing it back to default may affect grid title
    height, and title height changes require layout and redraw of the grid. }
  FColumn.Changed(FontAssigned);
end;

procedure TColumnTitle.SetAlignment(Value: TAlignment);
begin
  if (cvTitleAlignment in FColumn.FAssignedValues) and (Value = FAlignment) then Exit;
  FAlignment := Value;
  Include(FColumn.FAssignedValues, cvTitleAlignment);
  FColumn.Changed(False);
end;

procedure TColumnTitle.SetColor(Value: TColor);
begin
  if (cvTitleColor in FColumn.FAssignedValues) and (Value = FColor) then Exit;
  FColor := Value;
  Include(FColumn.FAssignedValues, cvTitleColor);
  FColumn.Changed(False);
end;

procedure TColumnTitle.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TColumnTitle.SetCaption(const Value: string);
begin
  if (cvTitleCaption in FColumn.FAssignedValues) and (Value = FCaption) then Exit;
  FCaption := Value;
  Include(FColumn.FAssignedValues, cvTitleCaption);
  FColumn.Changed(False);
end;


{ TColumn }

constructor TColumn.Create(Collection: TCollection);
var
  Grid: TCustomVDBGrid;
begin
  Grid := nil;
  if Assigned(Collection) and (Collection is TDBGridColumns) then
    Grid := TDBGridColumns(Collection).Grid;
  if Assigned(Grid) then
    Grid.BeginLayout;
  try
    inherited Create(Collection);
    FDropDownRows := 7;
    FButtonStyle := cbsAuto;
    FFont := TFont.Create;
    FFont.Assign(DefaultFont);
    FFont.OnChange := FontChanged;
    FImeMode := imDontCare;
    FImeName := Screen.DefaultIme;
    FTitle := CreateTitle;
  finally
    if Assigned(Grid) then
      Grid.EndLayout;
  end;
end;

destructor TColumn.Destroy;
begin
  FTitle.Free;
  FFont.Free;
  FPickList.Free;
  inherited Destroy;
end;

procedure TColumn.Assign(Source: TPersistent);
begin
  if Source is TColumn then
  begin
    if Assigned(Collection) then Collection.BeginUpdate;
    try
      RestoreDefaults;
      FieldName := TColumn(Source).FieldName;
      if cvColor in TColumn(Source).AssignedValues then
        Color := TColumn(Source).Color;
      if cvWidth in TColumn(Source).AssignedValues then
        Width := TColumn(Source).Width;
      if cvFont in TColumn(Source).AssignedValues then
        Font := TColumn(Source).Font;
      if cvImeMode in TColumn(Source).AssignedValues then
        ImeMode := TColumn(Source).ImeMode;
      if cvImeName in TColumn(Source).AssignedValues then
        ImeName := TColumn(Source).ImeName;
      if cvAlignment in TColumn(Source).AssignedValues then
        Alignment := TColumn(Source).Alignment;
      if cvReadOnly in TColumn(Source).AssignedValues then
        ReadOnly := TColumn(Source).ReadOnly;
      Title := TColumn(Source).Title;
      DropDownRows := TColumn(Source).DropDownRows;
      ButtonStyle := TColumn(Source).ButtonStyle;
      PickList := TColumn(Source).PickList;
      PopupMenu := TColumn(Source).PopupMenu;
    finally
      if Assigned(Collection) then Collection.EndUpdate;
    end;
  end
  else
    inherited Assign(Source);
end;

function TColumn.CreateTitle: TColumnTitle;
begin
  Result := TColumnTitle.Create(Self);
end;

function TColumn.DefaultAlignment: TAlignment;
begin
  if Assigned(Field) then
    Result := FField.Alignment
  else
    Result := taLeftJustify;
end;

function TColumn.DefaultColor: TColor;
var
  Grid: TCustomVDBGrid;
begin
  Grid := GetGrid;
  if Assigned(Grid) then
    Result := Grid.Color
  else
    Result := clWindow;
end;

function TColumn.DefaultFont: TFont;
var
  Grid: TCustomVDBGrid;
begin
  Grid := GetGrid;
  if Assigned(Grid) then
    Result := Grid.Font
  else
    Result := FFont;
end;

function TColumn.DefaultImeMode: TImeMode;
var
  Grid: TCustomVDBGrid;
begin
  Grid := GetGrid;
  if Assigned(Grid) then
    Result := Grid.ImeMode
  else
    Result := FImeMode;
end;

function TColumn.DefaultImeName: TImeName;
var
  Grid: TCustomVDBGrid;
begin
  Grid := GetGrid;
  if Assigned(Grid) then
    Result := Grid.ImeName
  else
    Result := FImeName;
end;

function TColumn.DefaultReadOnly: Boolean;
var
  Grid: TCustomVDBGrid;
begin
  Grid := GetGrid;
  Result := (Assigned(Grid) and Grid.ReadOnly) or (Assigned(Field) and FField.ReadOnly);
end;

function TColumn.DefaultWidth: Integer;
var
  W: Integer;
  RestoreCanvas: Boolean;
  TM: TTextMetric;
begin
  if GetGrid = nil then
  begin
    Result := 64;
    Exit;
  end;
  with GetGrid do
  begin
    if Assigned(Field) then
    begin
      RestoreCanvas := not HandleAllocated;
      if RestoreCanvas then
        Canvas.Handle := GetDC(0);
      try
        Canvas.Font := Self.Font;
        GetTextMetrics(Canvas.Handle, TM);
        Result := Field.DisplayWidth * (Canvas.TextWidth('0') - TM.tmOverhang)
          + TM.tmOverhang + 4;
        if dgTitles in Options then
        begin
          Canvas.Font := Title.Font;
          W := Canvas.TextWidth(Title.Caption) + 4;
          if Result < W then
            Result := W;
        end;
      finally
        if RestoreCanvas then
        begin
          ReleaseDC(0,Canvas.Handle);
          Canvas.Handle := 0;
        end;
      end;
    end
    else
      Result := DefaultColWidth;
  end;
end;

procedure TColumn.FontChanged;
begin
  Include(FAssignedValues, cvFont);
  Title.RefreshDefaultFont;
  Changed(False);
end;

function TColumn.GetAlignment: TAlignment;
begin
  if cvAlignment in FAssignedValues then
    Result := FAlignment
  else
    Result := DefaultAlignment;
end;

function TColumn.GetColor: TColor;
begin
  if cvColor in FAssignedValues then
    Result := FColor
  else
    Result := DefaultColor;
end;

function TColumn.GetField: TField;
var
  Grid: TCustomVDBGrid;
begin    { Returns Nil if FieldName can't be found in dataset }
  Grid := GetGrid;
  if (FField = nil) and (Length(FFieldName) > 0) and Assigned(Grid) and
    Assigned(Grid.DataLink.DataSet) then
  with Grid.Datalink.Dataset do
    if Active or (not DefaultFields) then
      SetField(FindField(FieldName));
  Result := FField;
end;

function TColumn.GetFont: TFont;
var
  Save: TNotifyEvent;
begin
  if not (cvFont in FAssignedValues) and (FFont.Handle <> DefaultFont.Handle) then
  begin
    Save := FFont.OnChange;
    FFont.OnChange := nil;
    FFont.Assign(DefaultFont);
    FFont.OnChange := Save;
  end;
  Result := FFont;
end;

function TColumn.GetGrid: TCustomVDBGrid;
begin
  if Assigned(Collection) and (Collection is TDBGridColumns) then
    Result := TDBGridColumns(Collection).Grid
  else
    Result := nil;
end;

function TColumn.GetDisplayName: string;
begin
  Result := FFieldName;
  if Result = '' then Result := inherited GetDisplayName;
end;

function TColumn.GetImeMode: TImeMode;
begin
  if cvImeMode in FAssignedValues then
    Result := FImeMode
  else
    Result := DefaultImeMode;
end;

function TColumn.GetImeName: TImeName;
begin
  if cvImeName in FAssignedValues then
    Result := FImeName
  else
    Result := DefaultImeName;
end;

function TColumn.GetPickList: TStrings;
begin
  if FPickList = nil then
    FPickList := TStringList.Create;
  Result := FPickList;
end;

function TColumn.GetReadOnly: Boolean;
begin
  if cvReadOnly in FAssignedValues then
    Result := FReadOnly
  else
    Result := DefaultReadOnly;
end;

function TColumn.GetWidth: Integer;
begin
  if cvWidth in FAssignedValues then
    Result := FWidth
  else
    Result := DefaultWidth;
end;

function TColumn.IsAlignmentStored: Boolean;
begin
  Result := (cvAlignment in FAssignedValues) and (FAlignment <> DefaultAlignment);
end;

function TColumn.IsColorStored: Boolean;
begin
  Result := (cvColor in FAssignedValues) and (FColor <> DefaultColor);
end;

function TColumn.IsFontStored: Boolean;
begin
  Result := (cvFont in FAssignedValues);
end;

function TColumn.IsImeModeStored: Boolean;
begin
  Result := (cvImeMode in FAssignedValues) and (FImeMode <> DefaultImeMode);
end;

function TColumn.IsImeNameStored: Boolean;
begin
  Result := (cvImeName in FAssignedValues) and (FImeName <> DefaultImeName);
end;

function TColumn.IsReadOnlyStored: Boolean;
begin
  Result := (cvReadOnly in FAssignedValues) and (FReadOnly <> DefaultReadOnly);
end;

function TColumn.IsWidthStored: Boolean;
begin
  Result := (cvWidth in FAssignedValues) and (FWidth <> DefaultWidth);
end;

procedure TColumn.RefreshDefaultFont;
var
  Save: TNotifyEvent;
begin
  if cvFont in FAssignedValues then Exit;
  Save := FFont.OnChange;
  FFont.OnChange := nil;
  try
    FFont.Assign(DefaultFont);
  finally
    FFont.OnChange := Save;
  end;
end;

procedure TColumn.RestoreDefaults;
var
  FontAssigned: Boolean;
begin
  FontAssigned := cvFont in FAssignedValues;
  FTitle.RestoreDefaults;
  FAssignedValues := [];
  RefreshDefaultFont;
  FPickList.Free;
  FPickList := nil;
  ButtonStyle := cbsAuto;
  Changed(FontAssigned);
end;

procedure TColumn.SetAlignment(Value: TAlignment);
begin
  if (cvAlignment in FAssignedValues) and (Value = FAlignment) then Exit;
  FAlignment := Value;
  Include(FAssignedValues, cvAlignment);
  Changed(False);
end;

procedure TColumn.SetButtonStyle(Value: TColumnButtonStyle);
begin
  if Value = FButtonStyle then Exit;
  FButtonStyle := Value;
  Changed(False);
end;

procedure TColumn.SetColor(Value: TColor);
begin
  if (cvColor in FAssignedValues) and (Value = FColor) then Exit;
  FColor := Value;
  Include(FAssignedValues, cvColor);
  Changed(False);
end;

procedure TColumn.SetField(Value: TField);
begin
  if FField = Value then Exit;
  FField := Value;
  if Assigned(Value) then
    FFieldName := Value.FieldName;
  Changed(False);
end;

procedure TColumn.SetFieldName(const Value: String);
var
  AField: TField;
  Grid: TCustomVDBGrid;
begin
  AField := nil;
  Grid := GetGrid;
  if Assigned(Grid) and Assigned(Grid.DataLink.DataSet) and
    not (csLoading in Grid.ComponentState) and (Length(Value) > 0) then
      AField := Grid.DataLink.DataSet.FindField(Value); { no exceptions }
  FFieldName := Value;
  SetField(AField);
  Changed(False);
end;

procedure TColumn.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  Include(FAssignedValues, cvFont);
  Changed(False);
end;

procedure TColumn.SetImeMode(Value: TImeMode);
begin
  if (cvImeMode in FAssignedValues) or (Value <> DefaultImeMode) then
  begin
    FImeMode := Value;
    Include(FAssignedValues, cvImeMode);
  end;
  Changed(False);
end;

procedure TColumn.SetImeName(Value: TImeName);
begin
  if (cvImeName in FAssignedValues) or (Value <> DefaultImeName) then
  begin
    FImeName := Value;
    Include(FAssignedValues, cvImeName);
  end;
  Changed(False);
end;

procedure TColumn.SetPickList(Value: TStrings);
begin
  if Value = nil then
  begin
    FPickList.Free;
    FPickList := nil;
    Exit;
  end;
  PickList.Assign(Value);
end;

procedure TColumn.SetPopupMenu(Value: TPopupMenu);
begin
  FPopupMenu := Value;
  if Value <> nil then Value.FreeNotification(GetGrid);
end;

procedure TColumn.SetReadOnly(Value: Boolean);
begin
  if (cvReadOnly in FAssignedValues) and (Value = FReadOnly) then Exit;
  FReadOnly := Value;
  Include(FAssignedValues, cvReadOnly);
  Changed(False);
end;

procedure TColumn.SetTitle(Value: TColumnTitle);
begin
  FTitle.Assign(Value);
end;

procedure TColumn.SetWidth(Value: Integer);
begin
  if (cvWidth in FAssignedValues) or (Value <> DefaultWidth) then
  begin
    FWidth := Value;
    Include(FAssignedValues, cvWidth);
  end;
  Changed(False);
end;

{ TPassthroughColumn }

type
  TPassthroughColumnTitle = class(TColumnTitle)
  private
    procedure SetCaption(const Value: string); override;
  end;

  TPassthroughColumn = class(TColumn)
  private
    procedure SetAlignment(Value: TAlignment); override;
    procedure SetField(Value: TField); override;
    procedure SetIndex(Value: Integer); override;
    procedure SetReadOnly(Value: Boolean); override;
    procedure SetWidth(Value: Integer); override;
  protected
    function CreateTitle: TColumnTitle; override;
  end;

{ TPassthroughColumnTitle }

procedure TPassthroughColumnTitle.SetCaption(const Value: string);
var
  Grid: TCustomVDBGrid;
begin
  Grid := FColumn.GetGrid;
  if Assigned(Grid) and (Grid.Datalink.Active) and Assigned(FColumn.Field) then
    FColumn.Field.DisplayLabel := Value
  else
    inherited SetCaption(Value);
end;


{ TPassthroughColumn }

function TPassthroughColumn.CreateTitle: TColumnTitle;
begin
  Result := TPassthroughColumnTitle.Create(Self);
end;

procedure TPassthroughColumn.SetAlignment(Value: TAlignment);
var
  Grid: TCustomVDBGrid;
begin
  Grid := GetGrid;
  if Assigned(Grid) and (Grid.Datalink.Active) and Assigned(Field) then
    Field.Alignment := Value
  else
    inherited SetAlignment(Value);
end;

procedure TPassthroughColumn.SetField(Value: TField);
begin
  inherited SetField(Value);
  if Value = nil then
    FFieldName := '';
  RestoreDefaults;
end;

procedure TPassthroughColumn.SetIndex(Value: Integer);
var
  Grid: TCustomVDBGrid;
  Fld: TField;
begin
  Grid := GetGrid;
  if Assigned(Grid) and Grid.Datalink.Active then
  begin
    Fld := Grid.Datalink.Fields[Value];
    if Assigned(Fld) then
      Field.Index := Fld.Index;
  end;
  inherited SetIndex(Value);
end;

procedure TPassthroughColumn.SetReadOnly(Value: Boolean);
var
  Grid: TCustomVDBGrid;
begin
  Grid := GetGrid;
  if Assigned(Grid) and Grid.Datalink.Active and Assigned(Field) then
    Field.ReadOnly := Value
  else
    inherited SetReadOnly(Value);
end;

procedure TPassthroughColumn.SetWidth(Value: Integer);
var
  Grid: TCustomVDBGrid;
  TM: TTextMetric;
begin
  Grid := GetGrid;
  if Assigned(Grid) then
  begin
    if Grid.HandleAllocated and Assigned(Field) and Grid.FUpdateFields then
    with Grid do
    begin
      Canvas.Font := Self.Font;
      GetTextMetrics(Canvas.Handle, TM);
      Field.DisplayWidth := (Value + (TM.tmAveCharWidth div 2) - TM.tmOverhang - 3)
        div TM.tmAveCharWidth;
    end;
    if (not Grid.FLayoutFromDataset) or (cvWidth in FAssignedValues) then
      inherited SetWidth(Value);
  end
  else
    inherited SetWidth(Value);
end;


{ TDBGridColumns }

constructor TDBGridColumns.Create(Grid: TCustomVDBGrid; ColumnClass: TColumnClass);
begin
  inherited Create(ColumnClass);
  FGrid := Grid;
end;

function TDBGridColumns.Add: TColumn;
begin
  Result := TColumn(inherited Add);
end;

function TDBGridColumns.GetColumn(Index: Integer): TColumn;
begin
  Result := TColumn(inherited Items[Index]);
end;

function TDBGridColumns.GetOwner: TPersistent;
begin
  Result := FGrid;
end;

function TDBGridColumns.GetState: TDBGridColumnsState;
begin
  Result := TDBGridColumnsState((Count > 0) and not (Items[0] is TPassthroughColumn));
end;

procedure TDBGridColumns.LoadFromFile(const Filename: string);
var
  S: TFileStream;
begin
  S := TFileStream.Create(Filename, fmOpenRead);
  try
    LoadFromStream(S);
  finally
    S.Free;
  end;
end;

type
  TColumnsWrapper = class(TComponent)
  private
    FColumns: TDBGridColumns;
  published
    property Columns: TDBGridColumns read FColumns write FColumns;
  end;

procedure TDBGridColumns.LoadFromStream(S: TStream);
var
  Wrapper: TColumnsWrapper;
begin
  Wrapper := TColumnsWrapper.Create(nil);
  try
    Wrapper.Columns := FGrid.CreateColumns;
    S.ReadComponent(Wrapper);
    Assign(Wrapper.Columns);
  finally
    Wrapper.Columns.Free;
    Wrapper.Free;
  end;
end;

procedure TDBGridColumns.RestoreDefaults;
var
  I: Integer;
begin
  BeginUpdate;
  try
    for I := 0 to Count-1 do
      Items[I].RestoreDefaults;
  finally
    EndUpdate;
  end;
end;

procedure TDBGridColumns.RebuildColumns;
var
  I: Integer;
begin
  if Assigned(FGrid) and Assigned(FGrid.DataSource) and
    Assigned(FGrid.Datasource.Dataset) then
  begin
    FGrid.BeginLayout;
    try
      Clear;
      with FGrid.Datasource.Dataset do
        for I := 0 to FieldCount-1 do
          Add.FieldName := Fields[I].FieldName
    finally
      FGrid.EndLayout;
    end
  end
  else
    Clear;
end;

procedure TDBGridColumns.SaveToFile(const Filename: string);
var
  S: TStream;
begin
  S := TFileStream.Create(Filename, fmCreate);
  try
    SaveToStream(S);
  finally
    S.Free;
  end;
end;

procedure TDBGridColumns.SaveToStream(S: TStream);
var
  Wrapper: TColumnsWrapper;
begin
  Wrapper := TColumnsWrapper.Create(nil);
  try
    Wrapper.Columns := Self;
    S.WriteComponent(Wrapper);
  finally
    Wrapper.Free;
  end;
end;

procedure TDBGridColumns.SetColumn(Index: Integer; Value: TColumn);
begin
  Items[Index].Assign(Value);
end;

procedure TDBGridColumns.SetState(NewState: TDBGridColumnsState);
begin
  if NewState = State then Exit;
  if NewState = csDefault then
    Clear
  else
    RebuildColumns;
end;

procedure TDBGridColumns.Update(Item: TCollectionItem);
var
  Raw: Integer;
begin
  if (FGrid = nil) or (csLoading in FGrid.ComponentState) then Exit;
  if Item = nil then
  begin
    FGrid.LayoutChanged;
  end
  else
  begin
    Raw := FGrid.DataToRawColumn(Item.Index);
    if FGrid.Vertical then 
       begin 
       FGrid.InvalidateRow(Raw); 
       {FGrid.ColWidths[Raw] := TColumn(Item).Width;} 
       end 
    else 
       begin 
       FGrid.InvalidateCol(Raw);
       FGrid.ColWidths[Raw] := TColumn(Item).Width;
       end; 
  end;
end;

{ TBookmarkList }

constructor TBookmarkList.Create(AGrid: TCustomVDBGrid);
begin
  inherited Create;
  FList := TStringList.Create;
  FList.OnChange := StringsChanged;
  FGrid := AGrid;
end;

destructor TBookmarkList.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TBookmarkList.Clear;
begin
  if FList.Count = 0 then Exit;
  FList.Clear;
  FGrid.Invalidate;
end;

function TBookmarkList.Compare(const Item1, Item2: TBookmarkStr): Integer;
begin
  with FGrid.Datalink.Datasource.Dataset do
    Result := CompareBookmarks(TBookmark(Item1), TBookmark(Item2));
end;

function TBookmarkList.CurrentRow: TBookmarkStr;
begin
  if not FLinkActive then RaiseGridError(sDataSetClosed);
  Result := FGrid.Datalink.Datasource.Dataset.Bookmark;
end;

function TBookmarkList.GetCurrentRowSelected: Boolean;
var
  Index: Integer;
begin
  Result := Find(CurrentRow, Index);
end;

function TBookmarkList.Find(const Item: TBookmarkStr; var Index: Integer): Boolean;
var
  L, H, I, C: Integer;
begin
  if (Item = FCache) and (FCacheIndex >= 0) then
  begin
    Index := FCacheIndex;
    Result := FCacheFind;
    Exit;
  end;
  Result := False;
  L := 0;
  H := FList.Count - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := Compare(FList[I], Item);
    if C < 0 then L := I + 1 else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        L := I;
      end;
    end;
  end;
  Index := L;
  FCache := Item;
  FCacheIndex := Index;
  FCacheFind := Result;
end;

function TBookmarkList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TBookmarkList.GetItem(Index: Integer): TBookmarkStr;
begin
  Result := FList[Index];
end;

function TBookmarkList.IndexOf(const Item: TBookmarkStr): Integer;
begin
  if not Find(Item, Result) then
    Result := -1;
end;

procedure TBookmarkList.LinkActive(Value: Boolean);
begin
  Clear;
  FLinkActive := Value;
end;

procedure TBookmarkList.Delete;
var
  I: Integer;
begin
  with FGrid.Datalink.Datasource.Dataset do
  begin
    DisableControls;
    try
      for I := FList.Count-1 downto 0 do
      begin
        Bookmark := FList[I];
        Delete;
        FList.Delete(I);
      end;
    finally
      EnableControls;
    end;
  end;
end;

function TBookmarkList.Refresh: Boolean;
var
  I: Integer;
begin
  Result := False;
  with FGrid.DataLink.Datasource.Dataset do
  try
    CheckBrowseMode;
    for I := FList.Count - 1 downto 0 do
      if not BookmarkValid(TBookmark(FList[I])) then
      begin
        Result := True;
        FList.Delete(I);
      end;
  finally
    UpdateCursorPos;
    if Result then FGrid.Invalidate;
  end;
end;

procedure TBookmarkList.SetCurrentRowSelected(Value: Boolean);
var
  Index: Integer;
  Current: TBookmarkStr;
begin
  Current := CurrentRow;
  if (Length(Current) = 0) or (Find(Current, Index) = Value) then Exit;
  if Value then
    FList.Insert(Index, Current)
  else
    FList.Delete(Index);
  FGrid.InvalidateRow(FGrid.Row);
end;

procedure TBookmarkList.StringsChanged(Sender: TObject);
begin
  FCache := '';
  FCacheIndex := -1;
end;


{ TCustomVDBGrid }

var
  DrawBitmap: TBitmap;
  UserCount: Integer;


function IIF(expr: Boolean; caseTrue, caseFalse: variant): variant;
begin
  if expr then Result := caseTrue
  else Result := caseFalse;
end;


procedure UsesBitmap;
begin
  if UserCount = 0 then
    DrawBitmap := TBitmap.Create;
  Inc(UserCount);
end;

procedure ReleaseBitmap;
begin
  Dec(UserCount);
  if UserCount = 0 then DrawBitmap.Free;
end;

function Max(X, Y: Integer): Integer;
begin
  Result := Y;
  if X > Y then Result := X;
end;

procedure WriteText(ACanvas: TCanvas; ARect: TRect; DX, DY: Integer;
  const Text: string; Alignment: TAlignment);
const
  AlignFlags : array [TAlignment] of Integer =
    ( DT_LEFT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX,
      DT_RIGHT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX,
      DT_CENTER or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX );
var
  B, R: TRect;
  I, Left: Integer;
begin
  I := ColorToRGB(ACanvas.Brush.Color);
  if GetNearestColor(ACanvas.Handle, I) = I then
  begin                       { Use ExtTextOut for solid colors }
    case Alignment of
      taLeftJustify:
        Left := ARect.Left + DX;
      taRightJustify:
        Left := ARect.Right - ACanvas.TextWidth(Text) - 3;
    else { taCenter }
      Left := ARect.Left + (ARect.Right - ARect.Left) shr 1
        - (ACanvas.TextWidth(Text) shr 1);
    end;
    ExtTextOut(ACanvas.Handle, Left, ARect.Top + DY, ETO_OPAQUE or
      ETO_CLIPPED, @ARect, PChar(Text), Length(Text), nil);
  end
  else begin                  { Use FillRect and Drawtext for dithered colors }
    DrawBitmap.Canvas.Lock;
    try
      with DrawBitmap, ARect do { Use offscreen bitmap to eliminate flicker and }
      begin                     { brush origin tics in painting / scrolling.    }
        Width := Max(Width, Right - Left);
        Height := Max(Height, Bottom - Top);
        R := Rect(DX, DY, Right - Left - 1, Bottom - Top - 1);
        B := Rect(0, 0, Right - Left, Bottom - Top);
      end;
      with DrawBitmap.Canvas do
      begin
        Font := ACanvas.Font;
        Font.Color := ACanvas.Font.Color;
        Brush := ACanvas.Brush;
        Brush.Style := bsSolid;
        FillRect(B);
        SetBkMode(Handle, TRANSPARENT);
        DrawText(Handle, PChar(Text), Length(Text), R, AlignFlags[Alignment]);
      end;
      ACanvas.CopyRect(ARect, DrawBitmap.Canvas, B);
    finally
      DrawBitmap.Canvas.Unlock;
    end;
  end;
end;

constructor TCustomVDBGrid.Create(AOwner: TComponent);
var
  Bmp: TBitmap;
begin
  inherited Create(AOwner);
  inherited DefaultDrawing := False;
  FAcquireFocus := True;
  Bmp := TBitmap.Create;
  try
    Bmp.LoadFromResourceName(HInstance, bmArrow);
    FIndicators := TImageList.CreateSize(Bmp.Width, Bmp.Height);
    FIndicators.AddMasked(Bmp, clWhite);
    Bmp.LoadFromResourceName(HInstance, bmEdit);
    FIndicators.AddMasked(Bmp, clWhite);
    Bmp.LoadFromResourceName(HInstance, bmInsert);
    FIndicators.AddMasked(Bmp, clWhite);
    Bmp.LoadFromResourceName(HInstance, bmMultiDot);
    FIndicators.AddMasked(Bmp, clWhite);
    Bmp.LoadFromResourceName(HInstance, bmMultiArrow);
    FIndicators.AddMasked(Bmp, clWhite);
  finally
    Bmp.Free;
  end;
  FTitleOffset := 1;
  FIndicatorOffset := 1;
  FUpdateFields := True;
  FOptions := [dgEditing, dgTitles, dgIndicator, dgColumnResize,
    dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit];
  DesignOptionsBoost := [goColSizing];
  VirtualView := True;
  UsesBitmap;
  ScrollBars := ssHorizontal;
  inherited Options := [goFixedHorzLine, goFixedVertLine, goHorzLine,
    goVertLine, goColSizing, goColMoving, goTabs, goEditing];
  FVertical := False; 
  FOnlyOne := False; 
  FTitlesWidth := 100; 
  FColumns := CreateColumns;
  inherited RowCount := 2;
  inherited ColCount := 2;
  FDataLink := TGridDataLink.Create(Self);
  Color := clWindow;
  ParentColor := False;
  FTitleFont := TFont.Create;
  FTitleFont.OnChange := TitleFontChanged;
  FSaveCellExtents := False;
  FUserChange := True;
  FDefaultDrawing := True;
  FUpdatingEditor := False;
  FBookmarks := TBookmarkList.Create(Self);
  HideEditor;
end;

destructor TCustomVDBGrid.Destroy;
begin
  FColumns.Free;
  FColumns := nil;
  FDataLink.Free;
  FDataLink := nil;
  FIndicators.Free;
  FTitleFont.Free;
  FTitleFont := nil;
  FBookmarks.Free;
  FBookmarks := nil;
  inherited Destroy;
  ReleaseBitmap;
end;


procedure TCustomVDBGrid.SetVertical(Value: Boolean);
var i: integer;
begin
  if Value <> FVertical then
     begin
     FVertical := Value;
     if Value then {change to vertical}
        begin
        inherited Options := inherited Options - [goColMoving];
        inherited Options := inherited Options + [goRowMoving];
        ScrollBars := ssVertical;
        for I := FIndicatorOffset to ColCount-1 do 
            ColWidths[I] := DefaultColWidth; 
        end
     else {change to horizontal}
        begin
        inherited Options := inherited Options - [goRowMoving];
        inherited Options := inherited Options + [goColMoving];
        ScrollBars := ssHorizontal;
        end;
     LayoutChanged;
     UpdateScrollBar;
     InvalidateEditor;
     ValidateRect(Handle, nil);
     Invalidate;
     end;
end;



procedure TCustomVDBGrid.SetOnlyOne(Value: Boolean);
begin
  if Value <> FOnlyOne then
     begin
     FOnlyOne := Value;
     LayoutChanged;
     UpdateScrollBar;
     InvalidateEditor;
     ValidateRect(Handle, nil);
     Invalidate;
     end;
end;



procedure TCustomVDBGrid.SetTitlesWidth(Value: integer);
begin
  if Value <> FTitlesWidth then
     begin
     FTitlesWidth := Value;
     if FVertical and (dgTitles in Options) then
        ColWidths[0] := FTitlesWidth;
     end;
end;


function TCustomVDBGrid.AcquireFocus: Boolean;
begin
  Result := True;
  if FAcquireFocus and CanFocus and not (csDesigning in ComponentState) then
  begin
    SetFocus;
    Result := Focused or (InplaceEditor <> nil) and InplaceEditor.Focused;
  end;
end;

function TCustomVDBGrid.RawToDataColumn(ACol: Integer): Integer;
begin
  Result := ACol - FIndicatorOffset;
end;

function TCustomVDBGrid.DataToRawColumn(ACol: Integer): Integer;
begin
  Result := ACol + FIndicatorOffset;
end;

function TCustomVDBGrid.AcquireLayoutLock: Boolean;
begin
  Result := (FUpdateLock = 0) and (FLayoutLock = 0);
  if Result then BeginLayout;
end;

procedure TCustomVDBGrid.BeginLayout;
begin
  BeginUpdate;
  if FLayoutLock = 0 then Columns.BeginUpdate;
  Inc(FLayoutLock);
end;

procedure TCustomVDBGrid.BeginUpdate;
begin
  Inc(FUpdateLock);
end;

procedure TCustomVDBGrid.CancelLayout;
begin
  if FLayoutLock > 0 then
  begin
    if FLayoutLock = 1 then
      Columns.EndUpdate;
    Dec(FLayoutLock);
    EndUpdate;
  end;
end;

function TCustomVDBGrid.CanEditAcceptKey(Key: Char): Boolean;
begin
  with Columns[SelectedIndex] do
    Result := FDatalink.Active and Assigned(Field) and Field.IsValidChar(Key);
end;

function TCustomVDBGrid.CanEditModify: Boolean;
begin
  Result := False;
  if not ReadOnly and FDatalink.Active and not FDatalink.Readonly then
  with Columns[SelectedIndex] do
    if (not ReadOnly) and Assigned(Field) and Field.CanModify
      and (not Field.IsBlob or Assigned(Field.OnSetText)) then
    begin
      FDatalink.Edit;
      Result := FDatalink.Editing;
      if Result then FDatalink.Modified;
    end;
end;

function TCustomVDBGrid.CanEditShow: Boolean;
begin
  Result := (LayoutLock = 0) and inherited CanEditShow;
end;

procedure TCustomVDBGrid.CellClick(Column: TColumn);
begin
  if Assigned(FOnCellClick) then FOnCellClick(Column);
end;

procedure TCustomVDBGrid.ColEnter;
begin
  UpdateIme;
  if Assigned(FOnColEnter) then FOnColEnter(Self);
end;

procedure TCustomVDBGrid.ColExit;
begin
  if Assigned(FOnColExit) then FOnColExit(Self);
end;

procedure TCustomVDBGrid.ColumnMoved(FromIndex, ToIndex: Longint);
begin
  FromIndex := RawToDataColumn(FromIndex);
  ToIndex := RawToDataColumn(ToIndex);
  Columns[FromIndex].Index := ToIndex;
  if Assigned(FOnColumnMoved) then FOnColumnMoved(Self, FromIndex, ToIndex);
end;


procedure TCustomVDBGrid.RowMoved(FromIndex, ToIndex: Longint);
begin
  FromIndex := RawToDataColumn(FromIndex);
  ToIndex := RawToDataColumn(ToIndex);
  Columns[FromIndex].Index := ToIndex;
  if Assigned(FOnColumnMoved) then FOnColumnMoved(Self, FromIndex, ToIndex);
end;


procedure TCustomVDBGrid.ColWidthsChanged;
var
  I: Integer;
begin
  inherited ColWidthsChanged;
  if (FDatalink.Active or (FColumns.State = csCustomized)) and
    AcquireLayoutLock then
  try
   if FVertical then 
    for I := FIndicatorOffset to FColumns.Count - 1 do 
      FColumns[I - FIndicatorOffset].Width := DefaultColWidth 
   else 
    for I := FIndicatorOffset to ColCount - 1 do
      FColumns[I - FIndicatorOffset].Width := ColWidths[I];
  finally
    EndLayout;
  end;
end;

function TCustomVDBGrid.CreateColumns: TDBGridColumns;
begin
  Result := TDBGridColumns.Create(Self, TColumn);
end;

function TCustomVDBGrid.CreateEditor: TInplaceEdit;
begin
  Result := TVDBGridInplaceEdit.Create(Self);
end;

procedure TCustomVDBGrid.CreateWnd;
begin
  BeginUpdate;   { prevent updates in WMSize message that follows WMCreate }
  try
    inherited CreateWnd;
  finally
    EndUpdate;
  end;
  UpdateRowCount;
  UpdateActive;
  UpdateScrollBar;
  FOriginalImeName := ImeName;
  FOriginalImeMode := ImeMode;
end;

procedure TCustomVDBGrid.DataChanged;
begin
  if not HandleAllocated then Exit;
  UpdateRowCount;
  UpdateScrollBar;
  UpdateActive;
  InvalidateEditor;
  ValidateRect(Handle, nil);
  Invalidate;
end;

procedure TCustomVDBGrid.DefaultHandler(var Msg);
var
  P: TPopupMenu;
  Cell: TGridCoord;
begin
  inherited DefaultHandler(Msg);
  if TMessage(Msg).Msg = wm_RButtonUp then
    with TWMRButtonUp(Msg) do
    begin
      Cell := MouseCoord(XPos, YPos);
      if FVertical then 
         begin 
         if (Cell.Y < FTitleOffset) or (Cell.X < 0) then Exit; 
         P := Columns[RawToDataColumn(Cell.Y)].PopupMenu; 
         end 
      else
        begin
        if (Cell.X < FIndicatorOffset) or (Cell.Y < 0) then Exit;
        P := Columns[RawToDataColumn(Cell.X)].PopupMenu;
        end; 
      if (P <> nil) and P.AutoPopup then
      begin
        SendCancelMode(nil);
        P.PopupComponent := Self;
        with ClientToScreen(SmallPointToPoint(Pos)) do
          P.Popup(X, Y);
        Result := 1;
      end;
    end;
end;

procedure TCustomVDBGrid.DeferLayout;
var
  M: TMsg;
begin
  if HandleAllocated and
    not PeekMessage(M, Handle, cm_DeferLayout, cm_DeferLayout, pm_NoRemove) then
    PostMessage(Handle, cm_DeferLayout, 0, 0);
  CancelLayout;
end;

procedure TCustomVDBGrid.DefineFieldMap;
var
  I: Integer;
begin
  if FColumns.State = csCustomized then
  begin   { Build the column/field map from the column attributes }
    DataLink.SparseMap := True;
    for I := 0 to FColumns.Count-1 do
      FDataLink.AddMapping(FColumns[I].FieldName);
  end
  else   { Build the column/field map from the field list order }
  begin
    FDataLink.SparseMap := False;
    with Datalink.Dataset do
      for I := 0 to FieldCount - 1 do
        with Fields[I] do if Visible then Datalink.AddMapping(FieldName);
  end;
end;

procedure TCustomVDBGrid.DefaultDrawDataCell(const Rect: TRect; Field: TField;
  State: TGridDrawState);
var
  Alignment: TAlignment;
  Value: string;
begin
  Alignment := taLeftJustify;
  Value := '';
  if Assigned(Field) then
  begin
    Alignment := Field.Alignment;
    Value := Field.DisplayText;
  end;
  WriteText(Canvas, Rect, 2, 2, Value, Alignment);
end;

procedure TCustomVDBGrid.DefaultDrawColumnCell(const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Value: string;
begin
  Value := '';
  if Assigned(Column.Field) then
    Value := Column.Field.DisplayText;
  WriteText(Canvas, Rect, 2, 2, Value, Column.Alignment);
end;

procedure TCustomVDBGrid.ReadColumns(Reader: TReader);
begin
  Columns.Clear;
  Reader.ReadValue;
  Reader.ReadCollection(Columns);
end;

procedure TCustomVDBGrid.WriteColumns(Writer: TWriter);
begin
  Writer.WriteCollection(Columns);
end;

procedure TCustomVDBGrid.DefineProperties(Filer: TFiler);
begin
  Filer.DefineProperty('Columns', ReadColumns, WriteColumns,
    ((Columns.State = csCustomized) and (Filer.Ancestor = nil)) or
    ((Filer.Ancestor <> nil) and
     ((Columns.State <> TCustomVDBGrid(Filer.Ancestor).Columns.State) or
      (not CollectionsEqual(Columns, TCustomVDBGrid(Filer.Ancestor).Columns)) )));
end;

procedure TCustomVDBGrid.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);

  function RowIsMultiSelected: Boolean;
  var
    Index: Integer;
  begin
    Result := (dgMultiSelect in Options) and Datalink.Active and
      FBookmarks.Find(Datalink.Datasource.Dataset.Bookmark, Index);
  end;

var
  OldActive: Integer;
  Indicator: Integer;
  Highlight: Boolean;
  Value: string;
  DrawColumn: TColumn;
  FrameOffs: Byte;
  MultiSelected: Boolean;
  AACol, AARow: Longint; 
begin
  if csLoading in ComponentState then
  begin
    Canvas.Brush.Color := Color;
    Canvas.FillRect(ARect);
    Exit;
  end;

  AARow := IIF(FVertical, ACol, ARow); 
  AACol := IIF(FVertical, ARow, ACol); 
  Dec(AARow, FTitleOffset); 
  Dec(AACol, FIndicatorOffset); 

  if (gdFixed in AState) and ([dgRowLines, dgColLines] * Options =
    [dgRowLines, dgColLines]) then
  begin
    InflateRect(ARect, -1, -1);
    FrameOffs := 1;
  end
  else
    FrameOffs := 2;

  if (gdFixed in AState) and (AACol < 0) then
  begin
    Canvas.Brush.Color := FixedColor;
    Canvas.FillRect(ARect);
    if Assigned(DataLink) and DataLink.Active  then
    begin
      MultiSelected := False;
      if AARow >= 0 then
      begin
        OldActive := FDataLink.ActiveRecord;
        try
          FDatalink.ActiveRecord := AARow;
          MultiSelected := RowIsMultiselected;
        finally
          FDatalink.ActiveRecord := OldActive;
        end;
      end;
      if (AARow = FDataLink.ActiveRecord) or MultiSelected then
      begin
        Indicator := 0;
        if FDataLink.DataSet <> nil then
          case FDataLink.DataSet.State of
            dsEdit: Indicator := 1;
            dsInsert: Indicator := 2;
            dsBrowse:
              if MultiSelected then
                if (AARow <> FDatalink.ActiveRecord) then 
                  Indicator := 3
                else
                  Indicator := 4;  // multiselected and current row
          end;
        FIndicators.BkColor := FixedColor;
        if FVertical then 
        FIndicators.Draw(Canvas, ARect.Left + FrameOffs, 
          (ARect.Top + ARect.Bottom - FIndicators.Height) shr 1, Indicator) 
        else 
        FIndicators.Draw(Canvas, ARect.Right - FIndicators.Width - FrameOffs,
          (ARect.Top + ARect.Bottom - FIndicators.Height) shr 1, Indicator);
        if AARow = FDatalink.ActiveRecord then 
          FSelRow := AARow + FTitleOffset; 
      end;
    end;
  end
  else with Canvas do
  begin
    DrawColumn := Columns[AACol]; 
    if gdFixed in AState then
    begin
      Font := DrawColumn.Title.Font;
      Brush.Color := DrawColumn.Title.Color;
    end
    else
    begin
      Font := DrawColumn.Font;
      Brush.Color := DrawColumn.Color;
    end;
    if AARow < 0 then with DrawColumn.Title do 
      WriteText(Canvas, ARect, FrameOffs, FrameOffs, Caption, Alignment)
    else if (FDataLink = nil) or not FDataLink.Active then
      FillRect(ARect)
    else
    begin
      Value := '';
      OldActive := FDataLink.ActiveRecord;
      try
        FDataLink.ActiveRecord := AARow; 
        if Assigned(DrawColumn.Field) then
          Value := DrawColumn.Field.DisplayText;
        Highlight := HighlightCell(AACol, AARow, Value, AState); 
        if Highlight then
        begin
          Brush.Color := clHighlight;
          Font.Color := clHighlightText;
        end;
        if FDefaultDrawing then
          WriteText(Canvas, ARect, 2, 2, Value, DrawColumn.Alignment);
        if Columns.State = csDefault then
          DrawDataCell(ARect, DrawColumn.Field, AState);
        DrawColumnCell(ARect, AACol, DrawColumn, AState); 
      finally
        FDataLink.ActiveRecord := OldActive;
      end;
      if FDefaultDrawing and (gdSelected in AState)
        and ((dgAlwaysShowSelection in Options) or Focused)
        and not (csDesigning in ComponentState)
        and not (dgRowSelect in Options)
        and (UpdateLock = 0)
        and (ValidParentForm(Self).ActiveControl = Self) then
        Windows.DrawFocusRect(Handle, ARect);
    end;
  end;
  if (gdFixed in AState) and ([dgRowLines, dgColLines] * Options =
    [dgRowLines, dgColLines]) then
  begin
    InflateRect(ARect, 1, 1);
    DrawEdge(Canvas.Handle, ARect, BDR_RAISEDINNER, BF_BOTTOMRIGHT);
    DrawEdge(Canvas.Handle, ARect, BDR_RAISEDINNER, BF_TOPLEFT);
  end;
end;

procedure TCustomVDBGrid.DrawDataCell(const Rect: TRect; Field: TField;
  State: TGridDrawState);
begin
  if Assigned(FOnDrawDataCell) then FOnDrawDataCell(Self, Rect, Field, State);
end;

procedure TCustomVDBGrid.DrawColumnCell(const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
begin
  if Assigned(OnDrawColumnCell) then
    OnDrawColumnCell(Self, Rect, DataCol, Column, State);
end;

procedure TCustomVDBGrid.EditButtonClick;
begin
  if Assigned(FOnEditButtonClick) then FOnEditButtonClick(Self);
end;

procedure TCustomVDBGrid.EditingChanged;
begin
  if dgIndicator in Options then
    if FVertical then
     InvalidateCell(FSelRow, 0)
    else
     InvalidateCell(0, FSelRow);
end;

procedure TCustomVDBGrid.EndLayout;
begin
  if FLayoutLock > 0 then
  begin
    try
      try
        if FLayoutLock = 1 then
          InternalLayout;
      finally
        if FLayoutLock = 1 then
          FColumns.EndUpdate;
      end;
    finally
      Dec(FLayoutLock);
      EndUpdate;
    end;
  end;
end;

procedure TCustomVDBGrid.EndUpdate;
begin
  if FUpdateLock > 0 then
    Dec(FUpdateLock);
end;

function TCustomVDBGrid.GetColField(DataCol: Integer): TField;
begin
  Result := nil;
  if (DataCol >= 0) and FDatalink.Active and (DataCol < Columns.Count) then
    Result := Columns[DataCol].Field;
end;

function TCustomVDBGrid.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

function TCustomVDBGrid.GetEditLimit: Integer;
begin
  Result := 0;
  if Assigned(SelectedField) and (SelectedField.DataType = ftString) then
    Result := SelectedField.Size;
end;

function TCustomVDBGrid.GetEditMask(ACol, ARow: Longint): string;
begin
  Result := '';
  if FDatalink.Active then
  with Columns[RawToDataColumn(IIF(FVertical, ARow, ACol))] do 
    if Assigned(Field) then
      Result := Field.EditMask;
end;

function TCustomVDBGrid.GetEditText(ACol, ARow: Longint): string;
begin
  Result := '';
  if FDatalink.Active then
  with Columns[RawToDataColumn(IIF(FVertical, ARow, ACol))] do 
    if Assigned(Field) then
      Result := Field.Text;
  FEditText := Result;
end;

function TCustomVDBGrid.GetFieldCount: Integer;
begin
  Result := FDatalink.FieldCount;
end;

function TCustomVDBGrid.GetFields(FieldIndex: Integer): TField;
begin
  Result := FDatalink.Fields[FieldIndex];
end;

function TCustomVDBGrid.GetFieldValue(ACol: Integer): string;
var
  Field: TField;
begin
  Result := '';
  Field := GetColField(ACol);
  if Field <> nil then Result := Field.DisplayText;
end;

function TCustomVDBGrid.GetSelectedField: TField;
var
  Index: Integer;
begin
  Index := SelectedIndex;
  if Index <> -1 then
    Result := Columns[Index].Field
  else
    Result := nil;
end;

function TCustomVDBGrid.GetSelectedIndex: Integer;
begin
  Result := RawToDataColumn(IIF(FVertical, Row, Col)); 
end;

function TCustomVDBGrid.HighlightCell(DataCol, DataRow: Integer;
  const Value: string; AState: TGridDrawState): Boolean;
var
  Index: Integer;
begin
  Result := False;
  if (dgMultiSelect in Options) and Datalink.Active then
    Result := FBookmarks.Find(Datalink.Datasource.Dataset.Bookmark, Index);
  if not Result then
    Result := (gdSelected in AState)
      and ((dgAlwaysShowSelection in Options) or Focused)
        { updatelock eliminates flicker when tabbing between rows }
      and ((UpdateLock = 0) or (dgRowSelect in Options));
end;

procedure TCustomVDBGrid.KeyDown(var Key: Word; Shift: TShiftState);
var
  KeyDownEvent: TKeyEvent;

  procedure ClearSelection;
  begin
    if (dgMultiSelect in Options) then
    begin
      FBookmarks.Clear;
      FSelecting := False;
    end;
  end;

  procedure DoSelection(Select: Boolean; Direction: Integer);
  var
    AddAfter: Boolean;
  begin
    AddAfter := False;
    BeginUpdate;
    try
      if (dgMultiSelect in Options) and FDatalink.Active then
        if Select and (ssShift in Shift) then
        begin
          if not FSelecting then
          begin
            FSelectionAnchor := FBookmarks.CurrentRow;
            FBookmarks.CurrentRowSelected := True;
            FSelecting := True;
            AddAfter := True;
          end
          else
          with FBookmarks do
          begin
            AddAfter := Compare(CurrentRow, FSelectionAnchor) <> -Direction;
            if not AddAfter then
              CurrentRowSelected := False;
          end
        end
        else
          ClearSelection;
      FDatalink.Dataset.MoveBy(Direction);
      if AddAfter then FBookmarks.CurrentRowSelected := True;
    finally
      EndUpdate;
    end;
  end;

  procedure NextRow(Select: Boolean);
  begin
    with FDatalink.Dataset do
    begin
      if (State = dsInsert) and not Modified and not FDatalink.FModified then
        if EOF then Exit else Cancel
      else
        DoSelection(Select, 1);
      if EOF and CanModify and (not ReadOnly) and (dgEditing in Options) then
        Append;
    end;
  end;

  procedure PriorRow(Select: Boolean);
  begin
    with FDatalink.Dataset do
      if (State = dsInsert) and not Modified and EOF and
        not FDatalink.FModified then
        Cancel
      else
        DoSelection(Select, -1);
  end;

  procedure Tab(GoForward: Boolean);
  var
    ACol, Original: Integer;
  begin
    ACol := IIF(FVertical, Row, Col); 
    Original := ACol;
    BeginUpdate;    { Prevent highlight flicker on tab to next/prior row }
    try
      while True do
      begin
        if GoForward then
          Inc(ACol) else
          Dec(ACol);
        if ACol >= IIF(FVertical, RowCount, ColCount) then 
        begin
          NextRow(False);
          ACol := FIndicatorOffset;
        end
        else if ACol < FIndicatorOffset then
        begin
          PriorRow(False);
          ACol := IIF(FVertical, RowCount, ColCount); 
        end;
        if ACol = Original then Exit;
        if FVertical then 
          begin 
          if TabStopRow(ACol) then 
             begin 
             MoveCol(ACol); 
             Exit; 
             end; 
          end 
        else 
        if TabStops[ACol] then
          begin
          MoveCol(ACol);
          Exit;
          end;
      end;
    finally
      EndUpdate;
    end;
  end;

  function DeletePrompt: Boolean;
  var
    Msg: string;
  begin
    if (FBookmarks.Count > 1) then
      Msg := SDeleteMultipleRecordsQuestion
    else
      Msg := SDeleteRecordQuestion;
    Result := not (dgConfirmDelete in Options) or
      (MessageDlg(Msg, mtConfirmation, mbOKCancel, 0) <> idCancel);
  end;

const
  RowMovementKeys = [VK_UP, VK_PRIOR, VK_DOWN, VK_NEXT, VK_HOME, VK_END];

begin
  KeyDownEvent := OnKeyDown;
  if Assigned(KeyDownEvent) then KeyDownEvent(Self, Key, Shift);
  if not FDatalink.Active or not CanGridAcceptKey(Key, Shift) then Exit;
  with FDatalink.DataSet do
   
   if FVertical then
    if ssCtrl in Shift then
    begin
      if (Key in RowMovementKeys) then ClearSelection;
      case Key of
        VK_LEFT, VK_PRIOR: MoveBy(-FDatalink.ActiveRecord);
        VK_RIGHT, VK_NEXT: MoveBy(FDatalink.BufferCount - FDatalink.ActiveRecord - 1);
        VK_UP: MoveCol(FIndicatorOffset);
        VK_DOWN: MoveCol(RowCount - 1);
        VK_HOME: First;
        VK_END: Last;
        VK_DELETE:
          if (not ReadOnly) and not IsEmpty
            and CanModify and DeletePrompt then
          if FBookmarks.Count > 0 then
            FBookmarks.Delete
          else
            Delete;
      end
    end
    else
      case Key of
        VK_LEFT: PriorRow(True);
        VK_RIGHT: NextRow(True);
        VK_UP:
          if dgRowSelect in Options then
            PriorRow(False) else
            MoveCol(Row - 1);
        VK_DOWN:
          if dgRowSelect in Options then
            NextRow(False) else
            MoveCol(Row + 1);
        VK_HOME:
          if (RowCount = FIndicatorOffset+1)
            or (dgRowSelect in Options) then
          begin
            ClearSelection;
            First;
          end
          else
            MoveCol(FIndicatorOffset);
        VK_END:
          if (RowCount = FIndicatorOffset+1)
            or (dgRowSelect in Options) then
          begin
            ClearSelection;
            Last;
          end
          else
            MoveCol(RowCount - 1);
        VK_NEXT:
          begin
            ClearSelection;
            MoveBy(VisibleColCount);
          end;
        VK_PRIOR:
          begin
            ClearSelection;
            MoveBy(-VisibleColCount);
          end;
        VK_INSERT:
          if CanModify and (not ReadOnly) and (dgEditing in Options) then
          begin
            ClearSelection;
            Insert;
          end;
        VK_TAB: if not (ssAlt in Shift) then Tab(not (ssShift in Shift));
        VK_ESCAPE:
          begin
            FDatalink.Reset;
            ClearSelection;
            if not (dgAlwaysShowEditor in Options) then HideEditor;
          end;
        VK_F2: EditorMode := True;
      end
   else
   
    if ssCtrl in Shift then
    begin
      if (Key in RowMovementKeys) then ClearSelection;
      case Key of
        VK_UP, VK_PRIOR: MoveBy(-FDatalink.ActiveRecord);
        VK_DOWN, VK_NEXT: MoveBy(FDatalink.BufferCount - FDatalink.ActiveRecord - 1);
        VK_LEFT: MoveCol(FIndicatorOffset);
        VK_RIGHT: MoveCol(ColCount - 1);
        VK_HOME: First;
        VK_END: Last;
        VK_DELETE:
          if (not ReadOnly) and not IsEmpty
            and CanModify and DeletePrompt then
          if FBookmarks.Count > 0 then
            FBookmarks.Delete
          else
            Delete;
      end
    end
    else
      case Key of
        VK_UP: PriorRow(True);
        VK_DOWN: NextRow(True);
        VK_LEFT:
          if dgRowSelect in Options then
            PriorRow(False) else
            MoveCol(Col - 1);
        VK_RIGHT:
          if dgRowSelect in Options then
            NextRow(False) else
            MoveCol(Col + 1);
        VK_HOME:
          if (ColCount = FIndicatorOffset+1)
            or (dgRowSelect in Options) then
          begin
            ClearSelection;
            First;
          end
          else
            MoveCol(FIndicatorOffset);
        VK_END:
          if (ColCount = FIndicatorOffset+1)
            or (dgRowSelect in Options) then
          begin
            ClearSelection;
            Last;
          end
          else
            MoveCol(ColCount - 1);
        VK_NEXT:
          begin
            ClearSelection;
            MoveBy(VisibleRowCount);
          end;
        VK_PRIOR:
          begin
            ClearSelection;
            MoveBy(-VisibleRowCount);
          end;
        VK_INSERT:
          if CanModify and (not ReadOnly) and (dgEditing in Options) then
          begin
            ClearSelection;
            Insert;
          end;
        VK_TAB: if not (ssAlt in Shift) then Tab(not (ssShift in Shift));
        VK_ESCAPE:
          begin
            FDatalink.Reset;
            ClearSelection;
            if not (dgAlwaysShowEditor in Options) then HideEditor;
          end;
        VK_F2: EditorMode := True;
      end;
end;

procedure TCustomVDBGrid.KeyPress(var Key: Char);
begin
  if not (dgAlwaysShowEditor in Options) and (Key = #13) then
    FDatalink.UpdateData;
  inherited KeyPress(Key);
end;

{ InternalLayout is called with layout locks and column locks in effect }
procedure TCustomVDBGrid.InternalLayout;
var
  I, J, K: Integer;
  Fld: TField;
  Column: TColumn;
  SeenPassthrough: Boolean;
  RestoreCanvas: Boolean;

  function FieldIsMapped(F: TField): Boolean;
  var
    X: Integer;
  begin
    Result := False;
    if F = nil then Exit;
    for X := 0 to FDatalink.FieldCount-1 do
      if FDatalink.Fields[X] = F then
      begin
        Result := True;
        Exit;
      end;
  end;

begin
  if (csLoading in ComponentState) then Exit;

  if HandleAllocated then KillMessage(Handle, cm_DeferLayout);

  { Check for Columns.State flip-flop }
  SeenPassthrough := False;
  for I := 0 to FColumns.Count-1 do
  begin
    if (FColumns[I] is TPassthroughColumn) then
      SeenPassthrough := True
    else
      if SeenPassthrough then
      begin   { We have both custom and passthrough columns. Kill the latter }
        for J := FColumns.Count-1 downto 0 do
        begin
          Column := FColumns[J];
          if Column is TPassthroughColumn then
            Column.Free;
        end;
        Break;
      end;
  end;

  FIndicatorOffset := 0;
  if dgIndicator in Options then
    Inc(FIndicatorOffset);
  FDatalink.ClearMapping;
  if FDatalink.Active then DefineFieldMap;
  if FColumns.State = csDefault then
  begin
     { Destroy columns whose fields have been destroyed or are no longer
       in field map }
    if (not FDataLink.Active) and (FDatalink.DefaultFields) then
      FColumns.Clear
    else
      for J := FColumns.Count-1 downto 0 do
        with FColumns[J] do
        if not Assigned(Field)
          or not FieldIsMapped(Field) then Free;
    I := FDataLink.FieldCount;
    if (I = 0) and (FColumns.Count = 0) then Inc(I);
    for J := 0 to I-1 do
    begin
      Fld := FDatalink.Fields[J];
      if Assigned(Fld) then
      begin
        K := J;
         { Pointer compare is valid here because the grid sets matching
           column.field properties to nil in response to field object
           free notifications.  Closing a dataset that has only default
           field objects will destroy all the fields and set associated
           column.field props to nil. }
        while (K < FColumns.Count) and (FColumns[K].Field <> Fld) do
          Inc(K);
        if K < FColumns.Count then
          Column := FColumns[K]
        else
        begin
          Column := TPassthroughColumn.Create(FColumns);
          Column.Field := Fld;
        end;
      end
      else
        Column := TPassthroughColumn.Create(FColumns);
      Column.Index := J;
    end;
  end
  else
  begin
    { Force columns to reaquire fields (in case dataset has changed) }
    for I := 0 to FColumns.Count-1 do
      FColumns[I].Field := nil;
  end;
  if FVertical then 
     begin 
     RowCount := FColumns.Count + FIndicatorOffset; 
     inherited FixedRows := FIndicatorOffset; 
     end 
  else 
      begin 
      ColCount := FColumns.Count + FIndicatorOffset;
      inherited FixedCols := FIndicatorOffset;
      end; 
  FTitleOffset := 0;
  if dgTitles in Options then FTitleOffset := 1;
  RestoreCanvas := not HandleAllocated;
  if RestoreCanvas then
    Canvas.Handle := GetDC(0);
  try
    Canvas.Font := Font;
    K := Canvas.TextHeight('Wg') + 3;
    if dgRowLines in Options then
      Inc(K, GridLineWidth);
    DefaultRowHeight := K;
    if dgTitles in Options then
    begin
      K := 0;
      for I := 0 to FColumns.Count-1 do
      begin
        Canvas.Font := FColumns[I].Title.Font;
        J := Canvas.TextHeight('Wg') + 4;
        if J > K then K := J;
      end;
      if K = 0 then
      begin
        Canvas.Font := FTitleFont;
        K := Canvas.TextHeight('Wg') + 4;
      end;
      if FVertical and (K > DefaultRowHeight) then 
         DefaultRowHeight := K 
      else 
         RowHeights[0] := K;
    end;
  finally
    if RestoreCanvas then
    begin
      ReleaseDC(0,Canvas.Handle);
      Canvas.Handle := 0;
    end;
  end;
  UpdateRowCount;
  SetColumnAttributes;
  UpdateActive;
  Invalidate;
end;

procedure TCustomVDBGrid.LayoutChanged;
begin
  if FColumns.Count > 0 then
    if FVertical then 
       RowCount := FColumns.Count + FIndicatorOffset 
    else 
       ColCount := FColumns.Count + FIndicatorOffset;
  if AcquireLayoutLock then
    EndLayout;
end;

procedure TCustomVDBGrid.LinkActive(Value: Boolean);
begin
  if not Value then HideEditor;
  FBookmarks.LinkActive(Value);
  LayoutChanged;
  UpdateScrollBar;
  if Value and (dgAlwaysShowEditor in Options) then ShowEditor;
end;

procedure TCustomVDBGrid.Loaded;
begin
  inherited Loaded;
  LayoutChanged;
end;

procedure TCustomVDBGrid.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  Cell: TGridCoord;
  OldCol,OldRow: Integer;
begin
  if not AcquireFocus then Exit;
  if (ssDouble in Shift) and (Button = mbLeft) then
  begin
    DblClick;
    Exit;
  end;
  if Sizing(X, Y) then
  begin
    FDatalink.UpdateData;
    inherited MouseDown(Button, Shift, X, Y)
  end
  else
  begin
    Cell := MouseCoord(X, Y);
    if ((csDesigning in ComponentState) or (dgColumnResize in Options)) and
      (IIF(FVertical, Cell.X, Cell.Y) < FTitleOffset) then 
    begin
      FDataLink.UpdateData;
      inherited MouseDown(Button, Shift, X, Y)
    end
    else
      if FDatalink.Active then
        with Cell do
        begin
          BeginUpdate;   { eliminates highlight flicker when selection moves }
          try
            HideEditor;
            OldCol := Col;
            OldRow := Row;
            if (IIF(FVertical, X, Y) >= FTitleOffset) and (IIF(FVertical, X - Col, Y - Row) <> 0) then 
              FDatalink.Dataset.MoveBy(IIF(FVertical, X - Col, Y - Row)); 
            if IIF(FVertical, Y, X) >= FIndicatorOffset then 
              MoveCol(IIF(FVertical ,Y, X)); 
            if (dgMultiSelect in Options) and FDatalink.Active then
              with FBookmarks do
              begin
                FSelecting := False;
                if ssCtrl in Shift then
                  CurrentRowSelected := not CurrentRowSelected
                else
                begin
                  Clear;
                  CurrentRowSelected := True;
                end;
              end;
            if (Button = mbLeft) and
              (((X = OldCol) and (Y = OldRow)) or (dgAlwaysShowEditor in Options)) then
              ShowEditor         { put grid in edit mode }
            else
              InvalidateEditor;  { draw editor, if needed }
          finally
            EndUpdate;
          end;
        end;
  end;
end;

procedure TCustomVDBGrid.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  Cell: TGridCoord;
  SaveState: TGridState;
begin
  SaveState := FGridState;
  inherited MouseUp(Button, Shift, X, Y);
  if (SaveState = gsRowSizing) or (SaveState = gsColSizing) or
    ((InplaceEditor <> nil) and (InplaceEditor.Visible) and
     (PtInRect(InplaceEditor.BoundsRect, Point(X,Y)))) then Exit;
  Cell := MouseCoord(X,Y);
  if (Button = mbLeft) and (IIF(FVertical, Cell.Y, Cell.X) >= FIndicatorOffset) and 
     (IIF(FVertical, Cell.X, Cell.Y) >= 0) then 
    if IIF(FVertical, Cell.X, Cell.Y) < FTitleOffset then 
      TitleClick(Columns[RawToDataColumn(IIF(FVertical, Cell.Y, Cell.X))]) 
    else
      CellClick(Columns[SelectedIndex]);
end;

procedure TCustomVDBGrid.MoveCol(RawCol: Integer);
var
  OldCol: Integer;
begin
  FDatalink.UpdateData;
  if RawCol >= IIF(FVertical, RowCount, ColCount) then 
    RawCol := IIF(FVertical, RowCount, ColCount) - 1; 
  if RawCol < FIndicatorOffset then RawCol := FIndicatorOffset;
  OldCol := IIF(FVertical, Row, Col);  
  if RawCol <> OldCol then
  begin
    if not FInColExit then
    begin
      FInColExit := True;
      try
        ColExit;
      finally
        FInColExit := False;
      end;
      if IIF(FVertical, Row, Col) <> OldCol then Exit; 
    end;
    if not (dgAlwaysShowEditor in Options) then HideEditor;
    if FVertical then 
       Row := RawCol 
    else 
       Col := RawCol;
    ColEnter;
  end;
end;

procedure TCustomVDBGrid.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  I: Integer;
  NeedLayout: Boolean;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (AComponent is TPopupMenu) then
    begin
      for I := 0 to Columns.Count-1 do
        if Columns[I].PopupMenu = AComponent then
          Columns[I].PopupMenu := nil;
    end
    else if (FDataLink <> nil) then
      if (AComponent = DataSource)  then
        DataSource := nil
      else if (AComponent is TField) then
      begin
        NeedLayout := False;
        BeginLayout;
        try
          for I := 0 to Columns.Count-1 do
            with Columns[I] do
              if Field = AComponent then
              begin
                Field := nil;
                NeedLayout := True;
              end;
        finally
          if NeedLayout and Assigned(FDatalink.Dataset)
            and not FDatalink.Dataset.ControlsDisabled then
            EndLayout
          else
            DeferLayout;
        end;
      end;
  end;
end;

procedure TCustomVDBGrid.RecordChanged(Field: TField);
var
  I: Integer;
  CField: TField;
begin
  if not HandleAllocated then Exit;
  if Field = nil then
    Invalidate
  else
  begin
    for I := 0 to Columns.Count - 1 do
      if Columns[I].Field = Field then
       if FVertical then 
        InvalidateRow(DataToRawColumn(I)) 
       else 
        InvalidateCol(DataToRawColumn(I));
  end;
  CField := SelectedField;
  if ((Field = nil) or (CField = Field)) and
    (Assigned(CField) and (CField.Text <> FEditText)) then
  begin
    InvalidateEditor;
    if InplaceEditor <> nil then InplaceEditor.Deselect;
  end;
end;

procedure TCustomVDBGrid.Scroll(Distance: Integer);
var
  OldRect, NewRect: TRect;
  RowHeight: Integer;
begin
  if not HandleAllocated then Exit;
  if FVertical then 
     OldRect := BoxRect(Col, 0, Col, RowCount - 1) 
  else 
     OldRect := BoxRect(0, Row, ColCount - 1, Row);
  if (FDataLink.ActiveRecord >= IIF(FVertical, ColCount, RowCount) - FTitleOffset) then 
     UpdateRowCount;
  UpdateScrollBar;
  UpdateActive;
  if FVertical then 
     NewRect := BoxRect(Col, 0, Col, RowCount - 1) 
  else 
     NewRect := BoxRect(0, Row, ColCount - 1, Row);
  ValidateRect(Handle, @OldRect);
  InvalidateRect(Handle, @OldRect, False);
  InvalidateRect(Handle, @NewRect, False);
  if Distance <> 0 then
  begin
    HideEditor;
    try
        Invalidate; 
        Exit; 
        {FOLLOWING CODE CAUSED CONFUSION SO ALWAYS INVALIDATE}
      if Abs(Distance) > IIF(FVertical, VisibleColCount, VisibleRowCount) then 
      begin
        Invalidate;
        Exit;
      end
      else
      begin
        RowHeight := DefaultRowHeight;
        if dgRowLines in Options then Inc(RowHeight, GridLineWidth);
        if dgIndicator in Options then
        begin
          if FVertical then 
          OldRect := BoxRect(FSelRow, 0, FSelRow, RowCount - 1) 
          else 
          OldRect := BoxRect(0, FSelRow, ColCount - 1, FSelRow);
          InvalidateRect(Handle, @OldRect, False);
        end;
        if FVertical then 
        NewRect := BoxRect(FTitleOffset, 0, 1000, RowCount - 1) 
        else 
        NewRect := BoxRect(0, FTitleOffset, ColCount - 1, 1000);
        if FVertical then 
        ScrollWindowEx(Handle, -DefaultColWidth * Distance, 0, @NewRect, @NewRect, {VERT ???}
          0, nil, SW_Invalidate) 
        else 
        ScrollWindowEx(Handle, 0, -RowHeight * Distance, @NewRect, @NewRect,
          0, nil, SW_Invalidate);
        if dgIndicator in Options then
        begin
          if FVertical then 
          NewRect := BoxRect(Col, 0, Col, RowCount - 1) 
          else 
          NewRect := BoxRect(0, Row, ColCount - 1, Row);
          InvalidateRect(Handle, @NewRect, False);
        end;
      end;
    finally
      if dgAlwaysShowEditor in Options then ShowEditor;
    end;
  end;
  if UpdateLock = 0 then Update;
end;

procedure TCustomVDBGrid.SetColumns(Value: TDBGridColumns);
begin
  Columns.Assign(Value);
end;

function ReadOnlyField(Field: TField): Boolean;
var
  MasterField: TField;
begin
  Result := Field.ReadOnly;
  if not Result and (Field.FieldKind = fkLookup) then
  begin
    Result := True;
    if Field.DataSet = nil then Exit;
    MasterField := Field.Dataset.FindField(Field.KeyFields);
    if MasterField = nil then Exit;
    Result := MasterField.ReadOnly;
  end;
end;

procedure TCustomVDBGrid.SetColumnAttributes;
var
  I: Integer;
begin
   if not FVertical then 
      for I := 0 to FColumns.Count-1 do
      with FColumns[I] do
        begin
        TabStops[I + FIndicatorOffset] := not ReadOnly and DataLink.Active and
        Assigned(Field) and not (Field.FieldKind = fkCalculated) and not ReadOnlyField(Field);
        ColWidths[I + FIndicatorOffset] := Width;
        end;
   if (dgIndicator in Options) then
     ColWidths[0] := IIF(FVertical, TitlesWidth, IndicatorWidth); 
end;


function TCustomVDBGrid.TabStopRow(Arow: integer): Boolean;
var DataCol: integer;
begin
  Result := False;
  DataCol := RawToDataColumn(ARow);
  if (DataCol >= 0) and (DataCol < FColumns.Count) then
    with FColumns[DataCol] do
     Result := not ReadOnly and DataLink.Active and
     Assigned(Field) and not (Field.FieldKind = fkCalculated) and not ReadOnlyField(Field);
end;


procedure TCustomVDBGrid.SetDataSource(Value: TDataSource);
begin
  if Value = FDatalink.Datasource then Exit;
  FBookmarks.Clear;
  FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
  LinkActive(FDataLink.Active);
end;

procedure TCustomVDBGrid.SetEditText(ACol, ARow: Longint; const Value: string);
begin
  FEditText := Value;
end;

procedure TCustomVDBGrid.SetOptions(Value: TDBGridOptions);
const
  LayoutOptions = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator,
    dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection];
var
  NewGridOptions: TGridOptions;
  ChangedOptions: TDBGridOptions;
begin
  if FOptions <> Value then
  begin
    NewGridOptions := [];
    if dgColLines in Value then
      NewGridOptions := NewGridOptions + [goFixedVertLine, goVertLine];
    if dgRowLines in Value then
      NewGridOptions := NewGridOptions + [goFixedHorzLine, goHorzLine];
    if dgColumnResize in Value then
      if FVertical then 
         NewGridOptions := NewGridOptions + [goColSizing, goRowMoving] 
      else 
         NewGridOptions := NewGridOptions + [goColSizing, goColMoving];
    if dgTabs in Value then Include(NewGridOptions, goTabs);
    if dgRowSelect in Value then
    begin
      Include(NewGridOptions, goRowSelect);
      Exclude(Value, dgAlwaysShowEditor);
      Exclude(Value, dgEditing);
    end;
    if dgEditing in Value then Include(NewGridOptions, goEditing);
    if dgAlwaysShowEditor in Value then Include(NewGridOptions, goAlwaysShowEditor);
    inherited Options := NewGridOptions;
    if dgMultiSelect in (FOptions - Value) then FBookmarks.Clear;
    ChangedOptions := (FOptions + Value) - (FOptions * Value);
    FOptions := Value;
    if ChangedOptions * LayoutOptions <> [] then LayoutChanged;
  end;
end;

procedure TCustomVDBGrid.SetSelectedField(Value: TField);
var
  I: Integer;
begin
  if Value = nil then Exit;
  for I := 0 to Columns.Count - 1 do
    if Columns[I].Field = Value then
      MoveCol(DataToRawColumn(I));
end;

procedure TCustomVDBGrid.SetSelectedIndex(Value: Integer);
begin
  MoveCol(DataToRawColumn(Value));
end;

procedure TCustomVDBGrid.SetTitleFont(Value: TFont);
begin
  FTitleFont.Assign(Value);
  if dgTitles in Options then LayoutChanged;
end;

function TCustomVDBGrid.StoreColumns: Boolean;
begin
  Result := Columns.State = csCustomized;
end;

procedure TCustomVDBGrid.TimedScroll(Direction: TGridScrollDirection);
begin
  if FDatalink.Active then
  begin
    with FDatalink do
    begin
      if sdUp in Direction then
      begin
        DataSet.MoveBy(-ActiveRecord - 1);
        Exclude(Direction, sdUp);
      end;
      if sdDown in Direction then
      begin
        DataSet.MoveBy(RecordCount - ActiveRecord);
        Exclude(Direction, sdDown);
      end;
    end;
    if Direction <> [] then inherited TimedScroll(Direction);
  end;
end;

procedure TCustomVDBGrid.TitleClick(Column: TColumn);
begin
  if Assigned(FOnTitleClick) then FOnTitleClick(Column);
end;

procedure TCustomVDBGrid.TitleFontChanged(Sender: TObject);
begin
  if (not FSelfChangingTitleFont) and not (csLoading in ComponentState) then
    ParentFont := False;
  if dgTitles in Options then LayoutChanged;
end;

procedure TCustomVDBGrid.UpdateActive;
var
  NewRow: Integer;
  Field: TField;
begin
  if FDatalink.Active and HandleAllocated and not (csLoading in ComponentState) then
  begin
    NewRow := FDatalink.ActiveRecord + FTitleOffset;
    if IIF(FVertical, Col, Row) <> NewRow then
    begin
      if not (dgAlwaysShowEditor in Options) then HideEditor;
      if FVertical then 
         MoveColRow(NewRow, Row , False, False) 
      else 
         MoveColRow(Col, NewRow, False, False);
      InvalidateEditor;
    end;
    Field := SelectedField;
    if Assigned(Field) and (Field.Text <> FEditText) then
      InvalidateEditor;
  end;
end;

procedure TCustomVDBGrid.UpdateData;
var
  Field: TField;
begin
  Field := SelectedField;
  if Assigned(Field) then
    Field.Text := FEditText;
end;

procedure TCustomVDBGrid.UpdateRowCount;
begin
  if FVertical then 
     begin 
     if ColCount <= FTitleOffset then ColCount := FTitleOffset + 1; 
     end 
  else
     if RowCount <= FTitleOffset then RowCount := FTitleOffset + 1;
  if FVertical then 
     FixedCols := FTitleOffset 
  else 
     FixedRows := FTitleOffset;
  with FDataLink do
    if not Active or (RecordCount = 0) or not HandleAllocated then
      if FVertical then 
         ColCount := 1 + FTitleOffset 
      else 
         RowCount := 1 + FTitleOffset
    else
    begin
      if FVertical then 
         ColCount := IIF(FOnlyOne,1+ FTitleOffset,1000) 
      else
         RowCount := IIF(FOnlyOne,1+ FTitleOffset,1000);
      FDataLink.BufferCount := IIF(FVertical, VisibleColCount, VisibleRowCount); 
      if FVertical then 
         ColCount := IIF(FOnlyOne,1+FTitleOffset,RecordCount + FTitleOffset) 
      else 
         RowCount := IIF(FOnlyOne,1+FTitleOffset,RecordCount + FTitleOffset);
      if dgRowSelect in Options then
         TopRow := FixedRows;
      UpdateActive;
    end;
end;

procedure TCustomVDBGrid.UpdateScrollBar;
var
  SIOld, SINew: TScrollInfo;
begin
  if FDatalink.Active and HandleAllocated then
    with FDatalink.DataSet do
    begin
      SIOld.cbSize := sizeof(SIOld);
      SIOld.fMask := SIF_ALL;
      if FVertical then 
         GetScrollInfo(Self.Handle, SB_HORZ, SIOld) 
      else 
         GetScrollInfo(Self.Handle, SB_VERT, SIOld);
      SINew := SIOld;
      if IsSequenced then
      begin
        SINew.nMin := 1;
        SINew.nPage := IIF(FVertical, Self.VisibleColCount, Self.VisibleRowCount); 
        SINew.nMax := RecordCount + SINew.nPage -1;
        if State in [dsInactive, dsBrowse, dsEdit] then
          SINew.nPos := RecNo;  // else keep old pos
      end
      else
      begin
        SINew.nMin := 0;
        SINew.nPage := 0;
        SINew.nMax := 4;
        if BOF then SINew.nPos := 0
        else if EOF then SINew.nPos := 4
        else SINew.nPos := 2;
      end;
      if (SINew.nMin <> SIOld.nMin) or (SINew.nMax <> SIOld.nMax) or
        (SINew.nPage <> SIOld.nPage) or (SINew.nPos <> SIOld.nPos) then
        if FVertical then 
           SetScrollInfo(Self.Handle, SB_HORZ, SINew, True) 
        else 
           SetScrollInfo(Self.Handle, SB_VERT, SINew, True);
    end;
end;

function TCustomVDBGrid.ValidFieldIndex(FieldIndex: Integer): Boolean;
begin
  Result := DataLink.GetMappedIndex(FieldIndex) >= 0;
end;

procedure TCustomVDBGrid.CMParentFontChanged(var Message: TMessage);
begin
  inherited;
  if ParentFont then
  begin
    FSelfChangingTitleFont := True;
    try
      TitleFont := Font;
    finally
      FSelfChangingTitleFont := False;
    end;
    LayoutChanged;
  end;
end;

procedure TCustomVDBGrid.CMExit(var Message: TMessage);
begin
  try
    if FDatalink.Active then
      with FDatalink.Dataset do
        if (dgCancelOnExit in Options) and (State = dsInsert) and
          not Modified and not FDatalink.FModified then
          Cancel else
          FDataLink.UpdateData;
  except
    SetFocus;
    raise;
  end;
  inherited;
end;

procedure TCustomVDBGrid.CMFontChanged(var Message: TMessage);
var
  I: Integer;
begin
  inherited;
  BeginLayout;
  try
    for I := 0 to Columns.Count-1 do
      Columns[I].RefreshDefaultFont;
  finally
    EndLayout;
  end;
end;

procedure TCustomVDBGrid.CMDeferLayout(var Message);
begin
  if AcquireLayoutLock then
    EndLayout
  else
    DeferLayout;
end;

procedure TCustomVDBGrid.CMDesignHitTest(var Msg: TCMDesignHitTest);
begin
  inherited;
  if (Msg.Result = 1) and ((FDataLink = nil) or
    ((Columns.State = csDefault) and
     (FDataLink.DefaultFields or (not FDataLink.Active)))) then
    Msg.Result := 0;
end;

procedure TCustomVDBGrid.WMSetCursor(var Msg: TWMSetCursor);
begin
  if (csDesigning in ComponentState) and ((FDataLink = nil) or
     ((Columns.State = csDefault) and
      (FDataLink.DefaultFields or (not FDataLink.Active)))) then
    Windows.SetCursor(LoadCursor(0, IDC_ARROW))
  else inherited;
end;

procedure TCustomVDBGrid.WMSize(var Message: TWMSize);
begin
  inherited;
  if UpdateLock = 0 then UpdateRowCount;
end;

procedure TCustomVDBGrid.WMVScroll(var Message: TWMVScroll);
var
  SI: TScrollInfo;
begin
  if FVertical then 
     begin
     inherited ; 
     Exit; 
     end; 
  if not AcquireFocus then Exit;
  if FDatalink.Active then
    with Message, FDataLink.DataSet do
      case ScrollCode of
        SB_LINEUP: MoveBy(-FDatalink.ActiveRecord - 1);
        SB_LINEDOWN: MoveBy(FDatalink.RecordCount - FDatalink.ActiveRecord);
        SB_PAGEUP: MoveBy(-VisibleRowCount);
        SB_PAGEDOWN: MoveBy(VisibleRowCount);
        SB_THUMBPOSITION:
          begin
            if IsSequenced then
            begin
              SI.cbSize := sizeof(SI);
              SI.fMask := SIF_ALL;
              GetScrollInfo(Self.Handle, SB_VERT, SI);
              if SI.nTrackPos <= 1 then First
              else if SI.nTrackPos >= RecordCount then Last
              else RecNo := SI.nTrackPos;
            end
            else
              case Pos of
                0: First;
                1: MoveBy(-VisibleRowCount);
                2: Exit;
                3: MoveBy(VisibleRowCount);
                4: Last;
              end;
          end;
        SB_BOTTOM: Last;
        SB_TOP: First;
      end;
end;


procedure TCustomVDBGrid.WMHScroll(var Message: TWMHScroll);
var
  SI: TScrollInfo;
begin
  if not FVertical then
     begin
     inherited ;
     Exit;
     end;
  if not AcquireFocus then Exit;
  if FDatalink.Active then
    with Message, FDataLink.DataSet do
      case ScrollCode of
        SB_LINELEFT: MoveBy(-FDatalink.ActiveRecord - 1);
        SB_LINERIGHT: MoveBy(FDatalink.RecordCount - FDatalink.ActiveRecord);
        SB_PAGEUP: MoveBy(-VisibleColCount);
        SB_PAGEDOWN: MoveBy(VisibleColCount);
        SB_THUMBPOSITION:
          begin
            if IsSequenced then
            begin
              SI.cbSize := sizeof(SI);
              SI.fMask := SIF_ALL;
              GetScrollInfo(Self.Handle, SB_HORZ, SI);
              if SI.nTrackPos <= 1 then First
              else if SI.nTrackPos >= RecordCount then Last
              else RecNo := SI.nTrackPos;
            end
            else
              case Pos of
                0: First;
                1: MoveBy(-VisibleColCount);
                2: Exit;
                3: MoveBy(VisibleColCount);
                4: Last;
              end;
          end;
        SB_BOTTOM: Last;
        SB_TOP: First;
      end;
end;


procedure TCustomVDBGrid.SetIme;
var
  Column: TColumn;
begin
  if not SysLocale.Fareast then Exit;

  if FUpdatingEditor or FDataLink.FInUpdateData then
  begin
    ImeName := Screen.DefaultIme;
    ImeMode := imDontCare;
  end
  else
  begin
    Column := Columns[SelectedIndex];
    ImeName := FOriginalImeName;
    ImeMode := FOriginalImeMode;
    if cvImeMode in Column.FAssignedValues then
    begin
      ImeName := Column.ImeName;
      ImeMode := Column.ImeMode;
    end;
  end;

  if InplaceEditor <> nil then
  begin
    TVDBGridInplaceEdit(Self).ImeName := ImeName;
    TVDBGridInplaceEdit(Self).ImeMode := ImeMode;
  end;
end;

procedure TCustomVDBGrid.UpdateIme;
begin
  if not SysLocale.Fareast then Exit;
  SetIme;
  if InplaceEditor <> nil then
    TVDBGridInplaceEdit(Self).SetIme;
end;

procedure TCustomVDBGrid.WMIMEStartComp(var Message: TMessage);
begin
  inherited;
  FUpdatingEditor := True;
  ShowEditor;
  FUpdatingEditor := False;
end;

procedure TCustomVDBGrid.WMSetFocus(var Message: TWMSetFocus);
begin
  SetIme;
  inherited;
end;

procedure TCustomVDBGrid.WMKillFocus(var Message: TMessage);
begin
  ImeName := Screen.DefaultIme;
  ImeMode := imDontCare;
  inherited;
end;

end.
