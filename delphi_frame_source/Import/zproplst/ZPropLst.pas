
{*******************************************************}
{       Run-Time Object Inspector component v1.2        }
{       Author: Gennadie Zuev                           }
{	E-mail: zuev@micex.ru                           }
{	Web: http://unicorn.micex.ru/users/gena         }
{                                                       }
{       Copyright (c) 1999 Gennadie Zuev     	        }
{                                                       }
{*******************************************************}

// Modified By Huangyanlai ÐÞ¸Ä£º»ÆÑàÀ´

{ Revision History:

  Version 1.4  // Modified By Huangyanlai
  ===========
+ support Delphi6 (set search path to \ToolsAPI.D6 )

  Version 1.3
  =========== // Modified By Huangyanlai
+ support Property Display Name
+ support Rename Event
+ support Property Filter
+ support Root Property
+ support OnModified Event

  Version 1.2
  ===========
+ Fixed rare "division by zero" error in VisibleRowCount function
+ When setting CurObj any unsaved changes in InplaceEdit are discarded
+ Added events OnChanging, OnChange
+ Fixed bug with visible scrollbar on empty PropList
+ Added "autocomplete" feature for enum properties
+ Fixed bug with changing Ctl3D property at run-time

  Version 1.1
  ===========
+ Now compatible with Delphi 2, 3, 4 and 5. In Delphi 5 you may need to compile
  Delphi5\Source\Toolsapi\DsgnIntf.pas and put resulting DCU in Delphi5\Lib
  folder
+ In Delphi 5 TPropertyEditor custom drawing is supported
+ if ShowHint is True, hint window will be shown when you move the mouse over
  a long property value (not working in D2)
+ Vertical scrollbar can be flat now (in D4, D5)
+ "+"/"-" button next to collapsed property can look like that found in Delphi 5
+ Two events were added (in D2 only one event)
+ Corrected some bugs in destructor

  Version 1.0
  ===========
  Initial Delphi 4 version.


  TZPropList property & events
  ============================

 (public)
  CurObj          - determines the object we are viewing|editing
  Modified        - True if any property of CurObj was modified
  VisibleRowCount - idicates number of rows that can fit in the visible area
  RowHeight       - height of a single row

 (published)
  Filter          - determines what kind of properties to show
  IntegralHeight  - determines whether to display the partial items
  Middle          - width of first column (containing property names)
  NewButtons      - determines whether to use D4 or D5 style when
                    displaing "+"/"-" button next to collapsed property
  PropColor       - color used to display property values
  ScrollBarStyle  - can make vertical scrollbar flat (D4&5)

  OnNewObject     - occurs when a new value is assigned to CurObj
  OnHint          - occurs when the mouse pauses over the property, whose
                    value is too long and doesn't fit in view. You can change
                    hint color, position and text here (absent in D2)
}

unit ZPropLst;

{$I KSConditions.INC }

interface

uses
{ !!! In Delphi 5 you may need to compile Delphi5\Source\Toolsapi\DsgnIntf.pas
  and put resulting DCU in Delphi5\Lib folder }
  Windows, Messages, Classes, Graphics, Controls, TypInfo, StdCtrls,
    SysUtils, Forms {$IFDEF VCL50_UP}, Menus {$ENDIF}
    {$ifdef VCL60_UP }
      ,DesignIntf, DesignEditors, VCLEditors, IniFiles
    {$else}
      ,dsgnintf
    {$endif}
    ;

type
  TZPropList = class;

  TZPropType = (ptSimple, ptEllipsis, ptPickList);

  TZPopupList = class(TCustomListBox)
  private
    FSearchText: string;
    FSearchTickCount: Integer;
  protected
    procedure CreateWnd; override;
    procedure KeyPress(var Key: Char); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Hide;
  end;

  TZInplaceEdit = class;
  TZListButton = class(TCustomControl)
  private
    FButtonWidth: Integer;
    FPressed: Boolean;
    FArrow: Boolean;
    FTracking: Boolean;
    FActiveList: TZPopupList;
    FListVisible: Boolean;
    FEditor: TZInplaceEdit;
    FPropList: TZPropList;
{$IFDEF VCL50_UP}
    FListItemHeight: Integer;
{$ENDIF}
    procedure TrackButton(X, Y: Integer);
    procedure StopTracking;
    procedure DropDown;
    procedure CloseUp(Accept: Boolean);
    procedure ListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DoDropDownKeys(var Key: Word; Shift: TShiftState);
    function Editor: {$ifdef VCL60_UP }IProperty{$else}TPropertyEditor{$endif};
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CANCELMODE;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMCancelMode(var Msg: TWMKillFocus); message WM_CANCELMODE;
{$IFDEF VCL50_UP}
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure MeasureHeight(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure DrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
{$ENDIF}
  protected
    procedure KeyPress(var Key: Char); override;
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Hide;
  end;

  TZInplaceEdit = class(TCustomEdit)
  private
    FPropList: TZPropList;
    FClickTime: Integer;
    FListButton: TZListButton;
    FAutoUpdate: Boolean;
    FPropType: TZPropType;
    FIgnoreChange: Boolean;
    procedure InternalMove(const Loc: TRect; Redraw: Boolean);
    procedure BoundsChanged;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure DblClick; override;
    procedure WndProc(var Message: TMessage); override;
    procedure Change; override;
    procedure AutoComplete(const S: string);
  public
    constructor Create(AOwner: TComponent); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Move(const Loc: TRect);
    procedure UpdateLoc(const Loc: TRect);
    procedure SetFocus; override;
  end;

  PZEditor = ^TZEditor;
  TZEditor = record
    peEditor: {$ifdef VCL60_UP } IProperty; {$else} TPropertyEditor; {$endif}
    peIdent: Integer;
    peNode: Boolean;
    peExpanded: Boolean;
    //begin hyl modified
    peName : string;
    //end hyl modified
  end;

  TZEditorList = class(TList)
  private
    FPropList: TZPropList;
    function GetEditor(AIndex: Integer): PZEditor;
  public
    procedure Clear;{$IFDEF VCL40_up}override;{$ENDIF}
    procedure Add(Editor: PZEditor);
    procedure DeleteEditor(Index: Integer);
    function IndexOfPropName(const PropName: string;
      StartIndex: Integer): Integer;
    function FindPropName(const PropName: string): Integer;
    constructor Create(APropList: TZPropList);
    property Editors[AIndex: Integer]: PZEditor read GetEditor; default;
  end;

{$IFDEF VCL40_prior}
  TZFormDesigner = class(TFormDesigner)
{$ELSE}
  {$ifdef VCL60_UP }
  TZFormDesigner = class(TInterfacedObject, IDesigner)
  {$else}
  TZFormDesigner = class(TInterfacedObject, IFormDesigner)
  {$endif}
{$ENDIF}
  private
    FPropList: TZPropList;
{$IFDEF VCL40_prior}
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure GetSelections(List: TComponentList); override;
    procedure SetSelections(List: TComponentList); override;
  {$IFDEF VCL30}
    procedure AddInterfaceMember(const MemberText: string); override;
  {$ENDIF}
{$ELSE}
    { begin Delphi5.IDesignerNotify }
    procedure Modified; {$IFDEF VCL40_prior} override; {$ENDIF}
    {$ifndef VCL60_UP }
    procedure Notification(AnObject: TPersistent; Operation: TOperation);
    {$endif}

    { end Delphi5.IDesignerNotify }

    { begin Delphi5.IDesigner }
    {$ifndef VCL60_UP }
    function GetCustomForm: TCustomForm;
    procedure SetCustomForm(Value: TCustomForm);
    function GetIsControl: Boolean;
    procedure SetIsControl(Value: Boolean);
    {$endif}
    procedure GetSelections(const List: IDesignerSelections);
    procedure SetSelections(const List: IDesignerSelections);
    { end Delphi5.IDesigner }
    {$ifndef VCL60_UP }
    procedure AddToInterface(InvKind: Integer; const Name: string; VT: Word;
      const TypeInfo: string);
    {$endif}
    procedure GetProjectModules(Proc: TGetModuleProc);
    function GetAncestorDesigner : {$ifdef VCL60_UP } IDesigner; {$else} IFormDesigner; {$endif}
    function IsSourceReadOnly: Boolean;
{$ENDIF}
    { begin Delphi5.IDesigner }
    {$ifndef VCL60_UP }
    function IsDesignMsg(Sender: TControl; var Message: TMessage): Boolean; {$IFDEF VCL40_prior} override; {$ENDIF}
    procedure PaintGrid; {$IFDEF VCL40_prior} override; {$ENDIF}
    procedure ValidateRename(AComponent: TComponent;
      const CurName, NewName: string); {$IFDEF VCL40_prior} override; {$ENDIF}
    {$endif}
    function UniqueName(const BaseName: string): string; {$IFDEF VCL40_prior} override; {$ENDIF}
    function GetRoot: TComponent; {$IFDEF VCL40_prior} override; {$ENDIF}
    { end Delphi5.IDesigner }

    { begin Delphi5.IFormDesigner }
    function CreateMethod(const Name: string; TypeData: PTypeData): TMethod; {$IFDEF VCL40_prior} override; {$ENDIF}
    function GetMethodName(const Method: TMethod): string; {$IFDEF VCL40_prior} override; {$ENDIF}
    procedure GetMethods(TypeData: PTypeData; Proc: TGetStrProc); {$IFDEF VCL40_prior} override; {$ENDIF}
    function GetPrivateDirectory: string; {$IFDEF VCL40_prior} override; {$ENDIF}
    function MethodExists(const Name: string): Boolean; {$IFDEF VCL40_prior} override; {$ENDIF}
    procedure RenameMethod(const CurName, NewName: string); {$IFDEF VCL40_prior} override; {$ENDIF}
    procedure SelectComponent(Instance: {$IFDEF VCL20}TComponent{$ELSE}TPersistent{$ENDIF}); {$IFDEF VCL40_prior} override; {$ENDIF}
    procedure ShowMethod(const Name: string); {$IFDEF VCL40_prior} override; {$ENDIF}
    procedure GetComponentNames(TypeData: PTypeData; Proc: TGetStrProc); {$IFDEF VCL40_prior} override; {$ENDIF}
    function GetComponent(const Name: string): TComponent; {$IFDEF VCL40_prior} override; {$ENDIF}
    function GetComponentName(Component: TComponent): string; {$IFDEF VCL40_prior} override; {$ENDIF}
    function MethodFromAncestor(const Method: TMethod): Boolean; {$IFDEF VCL40_prior} override; {$ENDIF}
    function CreateComponent(ComponentClass: TComponentClass; Parent: TComponent;
      Left, Top, Width, Height: Integer): TComponent; {$IFDEF VCL40_prior} override; {$ENDIF}
    function IsComponentLinkable(Component: TComponent): Boolean; {$IFDEF VCL40_prior} override; {$ENDIF}
    procedure MakeComponentLinkable(Component: TComponent); {$IFDEF VCL40_prior} override; {$ENDIF}
    procedure Revert(Instance: TPersistent; PropInfo: PPropInfo); {$IFDEF VCL40_prior} override; {$ENDIF}
{$IFNDEF VCL20}
    function GetObject(const Name: string): TPersistent; {$IFDEF VCL40_prior} override; {$ENDIF}
    function GetObjectName(Instance: TPersistent): string; {$IFDEF VCL40_prior} override; {$ENDIF}
    procedure GetObjectNames(TypeData: PTypeData; Proc: TGetStrProc); {$IFDEF VCL40_prior} override; {$ENDIF}
    function GetIsDormant: Boolean; {$IFDEF VCL40_prior} override; {$ENDIF}
    {$ifndef VCL60_UP }
    function HasInterface: Boolean; {$IFDEF VCL40_prior} override; {$ENDIF}
    function HasInterfaceMember(const Name: string): Boolean; {$IFDEF VCL40_prior} override; {$ENDIF}
    {$endif}
{$ENDIF}
{$IFDEF VCL50_UP}
    {$ifndef VCL60_UP }
    function GetContainerWindow: TWinControl;
    procedure SetContainerWindow(const NewContainer: TWinControl);
    {$endif}
    function GetScrollRanges(const ScrollPosition: TPoint): TPoint;
    procedure Edit(const Component: {$ifdef VCL60_UP }  TComponent {$else} IComponent {$endif});
    {$ifndef VCL60_UP }
    function BuildLocalMenu(Base: TPopupMenu; Filter: TLocalMenuFilters): TPopupMenu;
    {$endif}
    procedure ChainCall(const MethodName, InstanceName, InstanceMethod: string;
      TypeData: PTypeData);
    procedure CopySelection;
    procedure CutSelection;
    function CanPaste: Boolean;
    procedure PasteSelection;
    procedure DeleteSelection {$ifdef VCL60_UP }(ADoAll: Boolean = False){$endif};
    procedure ClearSelection;
    procedure NoSelection;
    procedure ModuleFileNames(var ImplFileName, IntfFileName, FormFileName: string);
    function GetRootClassName: string;
    { end Delphi5.IFormDesigner }
{$ENDIF}
{$ifdef VCL60_UP }
    { more Delphi6 IDesigner }
    procedure Activate;
    function GetPathAndBaseExeName: string;
    function GetBaseRegKey: string;
    function GetIDEOptions: TCustomIniFile;
    function CreateCurrentComponent(Parent: TComponent; const Rect: TRect): TComponent;
    function IsComponentHidden(Component: TComponent): Boolean;
    function GetShiftState: TShiftState;
    procedure ModalEdit(EditKey: Char; const ReturnWindow: IActivatable);
    procedure SelectItemName(const PropertyName: string);
    procedure Resurrect;
{$endif}
  public
    constructor Create(APropList: TZPropList);
  end;

  TNewObjectEvent = procedure (Sender: TZPropList; OldObj,
    NewObj: TObject) of object;
{$IFNDEF VCL20}
  THintEvent = procedure (Sender: TZPropList; Prop: {$ifdef VCL60_UP }IProperty{$else}TPropertyEditor{$endif};
    HintInfo: PHintInfo) of object;
{$ENDIF}
  TChangingEvent = procedure (Sender: TZPropList; Prop: {$ifdef VCL60_UP }IProperty{$else}TPropertyEditor{$endif};
    var CanChange: Boolean) of object;
  TChangeEvent = procedure (Sender: TZPropList; Prop: {$ifdef VCL60_UP }IProperty{$else}TPropertyEditor{$endif}) of object;
  //begin hyl modified
  TValidateRenameEvent = procedure(AComponent: TComponent;
    const CurName, NewName: string) of object;
  TPropFilterEvent = procedure (Sender : TZPropList; var Editor : PZEditor) of object;
  //end hyl modified


  TZPropList = class(TCustomControl)
  private
    FCurObj: TObject;
    FPropCount: Integer;
    FEditors: TZEditorList;
    FRowHeight: Integer;
    FHasScrollBar: Boolean;
    FTopRow: Integer;
    FCurrent: Integer;
    FVertLine: Integer;
    FHitTest: TPoint;
    FDividerHit: Boolean;
    FInplaceEdit: TZInplaceEdit;
    FInUpdate: Boolean;
    FPropColor: TColor;
    FDesigner: TZFormDesigner;
    FIntegralHeight: Boolean;
    FDefFormProc: Pointer;
    FFormHandle: HWND;
    FFilter: TTypeKinds;
    FModified: Boolean;
    FCurrentIdent: Integer;
    FCurrentPos: Integer;
    FTracking: Boolean;
    FNewButtons: Boolean;
    FDestroying: Boolean;
    FBorderStyle: TBorderStyle;
{$IFDEF VCL40_up}
    FScrollBarStyle: TScrollBarStyle;
{$ENDIF}
    FOnNewObject: TNewObjectEvent;
{$IFNDEF VCL20}
    FOnHint: THintEvent;
{$ENDIF}
    FOnChanging: TChangingEvent;
    FOnChange: TChangeEvent;
    //begin hyl modified
    FOnModified : TNotifyEvent;
    FRoot : TComponent;
    FOnValidateRename : TValidateRenameEvent;
    FOnFilterProp : TPropFilterEvent;
    procedure SetRoot(const Value : TComponent);
    procedure DoValidateRename(AComponent: TComponent; const CurName, NewName: string);
    //end hyl modified
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure CMDesignHitTest(var Msg: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure CMCancelMode(var Msg: TMessage); message CM_CANCELMODE;
{$IFNDEF VCL20}
    procedure CMHintShow(var Msg: TCMHintShow); message CM_HINTSHOW;
{$ENDIF}
    procedure SetCurObj(const Value: TObject);
    procedure UpdateScrollRange;
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;
    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
    procedure WMCancelMode(var Msg: TMessage); message WM_CANCELMODE;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure ModifyScrollBar(ScrollCode: Integer);
    procedure MoveTop(NewTop: Integer);
    function MoveCurrent(NewCur: Integer): Boolean;
    procedure InvalidateSelection;
    function VertLineHit(X: Integer): Boolean;
    function YToRow(Y: Integer): Integer;
    procedure SizeColumn(X: Integer);
    function GetValue(Index: Integer): string;
    function GetPrintableValue(Index: Integer): string;
    procedure DoEdit(E: {$ifdef VCL60_UP }IProperty{$else}TPropertyEditor{$endif}; DoEdit: Boolean; const Value: string);
    procedure SetValue(Index: Integer; const Value: string);
    procedure CancelMode;
    function GetEditRect: TRect;
    function UpdateText(Exiting: Boolean): Boolean;
    procedure SetPropColor(const Value: TColor);
    function ColumnSized(X: Integer): Boolean;
    procedure FreePropList;
    procedure InitPropList;
    {$ifdef VCL60_UP }
    procedure PropEnumProc(const Prop: IProperty);
    {$else}
    procedure PropEnumProc(Prop: TPropertyEditor);
    {$endif}
    procedure SetIntegralHeight(const Value: Boolean);
    procedure FormWndProc(var Message: TMessage);
    procedure SetFilter(const Value: TTypeKinds);
    procedure ChangeCurObj(const Value: TObject);
    function GetName(Index: Integer): string;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    function GetValueRect(ARow: Integer): TRect;
    procedure SetNewButtons(const Value: Boolean);
    procedure SetMiddle(const Value: Integer);
{$IFDEF VCL40_up}
    procedure SetScrollBarStyle(const Value: TScrollBarStyle);
{$ENDIF}
    procedure NodeClicked;
    function ButtonHit(X: Integer): Boolean;
    procedure SetBorderStyle(Value: TBorderStyle);
    function GetFullPropName(Index: Integer): string;
  protected
    procedure Paint; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure DblClick; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    function GetPropType: TZPropType;
    procedure Edit;
    function Editor: {$ifdef VCL60_UP }IProperty{$else}TPropertyEditor{$endif};
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure UpdateEditor(CallActivate: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitCurrent(const PropName: string);
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure CreateParams(var Params: TCreateParams); override;
    function VisibleRowCount: Integer;
    procedure MarkModified;
    procedure ClearModified;
    procedure Synchronize;
    procedure SetFocus; override;
    property CurObj: TObject read FCurObj write SetCurObj;
    property Modified: Boolean read FModified;
    property RowHeight: Integer read FRowHeight;
    property PropCount: Integer read FPropCount;
    property InplaceEdit: TZInplaceEdit read FInplaceEdit;
    //begin hyl modified
    property  Root : TComponent read FRoot write SetRoot;
    property  Editors: TZEditorList read FEditors;
    //end hyl modified
  published
    property PropColor: TColor read FPropColor write SetPropColor default clNavy;
    property IntegralHeight: Boolean read FIntegralHeight
      write SetIntegralHeight default False;
    property Filter: TTypeKinds read FFilter write SetFilter default tkProperties;
    property NewButtons: Boolean read FNewButtons write SetNewButtons
      default {$IFDEF VCL50_UP}True{$ELSE}False{$ENDIF};
    property Middle: Integer read FVertLine write SetMiddle default 85;
{$IFDEF VCL40_up}
    property ScrollBarStyle: TScrollBarStyle read FScrollBarStyle
      write SetScrollBarStyle default ssRegular;
{$ENDIF}
    property OnNewObject: TNewObjectEvent read FOnNewObject write FOnNewObject;
{$IFNDEF VCL20}
    property OnHint: THintEvent read FOnHint write FOnHint;
{$ENDIF}
    property OnChanging: TChangingEvent read FOnChanging write FOnChanging;
    property OnChange: TChangeEvent read FOnChange write FOnChange;
    // begin add
    property OnModified : TNotifyEvent read FOnModified write FOnModified;
    property OnValidateRename : TValidateRenameEvent read FOnValidateRename write FOnValidateRename;
    property OnFilterProp : TPropFilterEvent read FOnFilterProp write FOnFilterProp;
    // end add
    property Align;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property Color default clBtnFace;
    property Ctl3D;
    property Cursor;
    property Enabled;
    property Font;
    property ParentColor default False;
    property ParentFont;
    property ParentShowHint default False;
    property PopupMenu;
    property ShowHint default True;
    property TabOrder;
    property TabStop default True;
    property Visible;
  end;

procedure Register;

implementation

uses
  CommCtrl{$IFDEF VCL30}, Menus {$ENDIF};

const
  MINCOLSIZE   = 32;
  DROPDOWNROWS = 8;

procedure Register;
begin
  RegisterComponents('Gena''s', [TZPropList]);
end;

{ Return mimimum of two signed integers }
function EMax(A, B: Integer): Integer;
asm
{     ->EAX     A
        EDX     B
      <-EAX     Min(A, B) }

        CMP     EAX,EDX
        JGE     @@Exit
        MOV     EAX,EDX
  @@Exit:
end;

{ Return maximum of two signed integers }
function EMin(A, B: Integer): Integer;
asm
{     ->EAX     A
        EDX     B
      <-EAX     Max(A, B) }

        CMP     EAX,EDX
        JLE     @@Exit
        MOV     EAX,EDX
  @@Exit:
end;

{ TZEditorList }

constructor TZEditorList.Create(APropList: TZPropList);
begin
  inherited Create;
  FPropList := APropList;
end;

procedure TZEditorList.DeleteEditor(Index: Integer);
var
  P: PZEditor;
begin
  P := Editors[Index];
  {$ifdef VCL60_UP }
  P.peEditor := nil;
  {$else}
  P.peEditor.Free;
  {$endif}
  FreeMem(P);
end;

function TZEditorList.IndexOfPropName(const PropName: string;
  StartIndex: Integer): Integer;
var
  I: Integer;
begin
  if StartIndex < Count then
  begin
    Result := 0;
    for I := StartIndex to Count - 1 do
      if Editors[I].peEditor.GetName = PropName then
      begin
        Result := I;
        Exit;
      end;
  end
  else
    Result := -1;
end;

function TZEditorList.FindPropName(const PropName: string): Integer;
var
  S, Prop: string;
  I: Integer;
begin
  Result := -1;
  S := PropName;
  while S <> '' do        // Expand subproperties
  begin
    I := Pos('\', S);
    if I > 0 then
    begin
      Prop := Copy(S, 1, I - 1);
      System.Delete(S, 1, I);
    end
    else
    begin
      Prop := S;
      S := '';
    end;

    I := IndexOfPropName(Prop, Succ(Result));
    if I <= Result then Exit;
    Result := I;

    if S <> '' then
      with Editors[Result]^ do
        if peNode then
          if not peExpanded then
          begin
            FPropList.FCurrentIdent := peIdent + 1;
            FPropList.FCurrentPos := Result + 1;
            try
              peEditor.GetProperties(FPropList.PropEnumProc);
            except
            end;
            peExpanded := True;
            FPropList.FPropCount := Count;
          end
        else Exit;
  end;
end;

procedure TZEditorList.Add(Editor: PZEditor);
begin
  inherited Add(Editor);
end;

procedure TZEditorList.Clear;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do DeleteEditor(I);
  inherited;
end;

function TZEditorList.GetEditor(AIndex: Integer): PZEditor;
begin
  Result := Items[AIndex];
end;

{ TZPopupList }

constructor TZPopupList.Create(AOwner: TComponent);
begin
  inherited;
  Parent := AOwner as TWinControl;
  ParentCtl3D := False;
  Ctl3D := False;
  Visible := False;
  TabStop := False;
{$IFDEF VCL50_UP}
  Style := lbOwnerDrawVariable;
{$ELSE}
  IntegralHeight := True;
{$ENDIF}
end;

procedure TZPopupList.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do
  begin
    Style := Style or WS_BORDER;
    ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
    X := -200;  // move listbox offscreen
{$IFDEF VCL40_up}
    AddBiDiModeExStyle(ExStyle);
{$ENDIF}
    WindowClass.Style := CS_SAVEBITS;
  end;
end;

procedure TZPopupList.CreateWnd;
begin
  inherited;
{  if not (csDesigning in ComponentState) then
  begin}
    Windows.SetParent(Handle, 0);
    CallWindowProc(DefWndProc, Handle, WM_SETFOCUS, 0, 0);
//  end;
end;

procedure TZPopupList.Hide;
begin
  if HandleAllocated and IsWindowVisible(Handle) then
  begin
    SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or
      SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);
  end;
end;

procedure TZPopupList.KeyPress(var Key: Char);
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
        SendMessage(Handle, LB_SELECTSTRING, WORD(-1), Longint(PChar(FSearchText)));
        Key := #0;
      end;
  end;
  inherited Keypress(Key);
end;

{ TZListButton }

constructor TZListButton.Create(AOwner: TComponent);
begin
  inherited;
  FEditor := AOwner as TZInplaceEdit;
  FPropList := FEditor.FPropList;
  FButtonWidth := GetSystemMetrics(SM_CXVSCROLL);
  FActiveList := TZPopupList.Create(Self);
  FActiveList.OnMouseUp := ListMouseUp;
{$IFDEF VCL50_UP}
  FActiveList.OnMeasureItem := MeasureHeight;
  FActiveList.OnDrawItem := DrawItem;
{$ENDIF}
end;

procedure TZListButton.Hide;
begin
  if HandleAllocated and IsWindowVisible(Handle) then
  begin
//    Invalidate;
    SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_HIDEWINDOW or SWP_NOZORDER or
      SWP_NOREDRAW);
  end;
end;

procedure TZListButton.Paint;
var
  R: TRect;
  Flags, X, Y, W: Integer;
begin
  R := ClientRect;
  InflateRect(R, 1, 1);
  Flags := 0;

  with Canvas do
    if FArrow then
    begin
      if FPressed then Flags := DFCS_FLAT or DFCS_PUSHED;
      DrawFrameControl(Handle, R, DFC_SCROLL, Flags or DFCS_SCROLLCOMBOBOX);
    end
    else
    begin
      if FPressed then Flags := BF_FLAT;
      DrawEdge(Handle, R, EDGE_RAISED, BF_RECT or BF_MIDDLE or Flags);
      X := R.Left + ((R.Right - R.Left) shr 1) - 1 + Ord(FPressed);
      Y := R.Top + ((R.Bottom - R.Top) shr 1) - 1 + Ord(FPressed);
      W := FButtonWidth shr 3;
      if W = 0 then W := 1;
      PatBlt(Handle, X, Y, W, W, BLACKNESS);
      PatBlt(Handle, X - (W + W), Y, W, W, BLACKNESS);
      PatBlt(Handle, X + W + W, Y, W, W, BLACKNESS);
    end;
end;

procedure TZListButton.TrackButton(X, Y: Integer);
var
  NewState: Boolean;
  R: TRect;
begin
  R := ClientRect;
  NewState := PtInRect(R, Point(X, Y));
  if FPressed <> NewState then
  begin
    FPressed := NewState;
    Invalidate;
  end;
end;

function TZListButton.Editor: {$ifdef VCL60_UP }IProperty{$else}TPropertyEditor{$endif};
begin
  Result := FPropList.Editor;
end;

type
  TGetStrFunc = function(const Value: string): Integer of object;
  
procedure TZListButton.DropDown;
var
  I, M, W: Integer;
  P: TPoint;
  MCanvas: TCanvas;
  AddValue: TGetStrFunc;
  {$ifdef VCL60_UP }
  CustomPropertyListDrawing : ICustomPropertyListDrawing;
  {$endif}
begin
  if not FListVisible then
  begin
    FActiveList.Clear;
    with Editor do
    begin
      FActiveList.Sorted := paSortList in GetAttributes;
      AddValue := FActiveList.Items.Add;
      GetValues(TGetStrProc(AddValue));
      SendMessage(FActiveList.Handle, LB_SELECTSTRING, WORD(-1), Longint(PChar(GetValue)));
    end;

    with FActiveList do
    begin
      M := EMax(1, EMin(Items.Count, DROPDOWNROWS));
      {$IFDEF VCL50_UP}
      I := FListItemHeight;
      MeasureHeight(nil, 0, I);
      {$ELSE}
      I := ItemHeight;
      {$ENDIF}
      Height := M * I + 2;
      width := Self.Width + FEditor.Width + 1;
    end;

    with FActiveList do
    begin
      M := ClientWidth;
      MCanvas := FPropList.Canvas;
      for I := 0 to Items.Count - 1 do
      begin
        W := MCanvas.TextWidth(Items[I]) + 4;
        {$ifdef VCL60_UP }
          if Editor.QueryInterface(ICustomPropertyListDrawing,CustomPropertyListDrawing)=S_OK then
          begin
            CustomPropertyListDrawing.ListMeasureWidth(Editor.GetName, MCanvas, W);
            CustomPropertyListDrawing := nil;
          end;
        {$else}
          {$IFDEF VCL50_UP}
          with Editor do
            ListMeasureWidth(GetName, MCanvas, W);
          {$ENDIF}
        {$endif}
        if W > M then M := W;
      end;
      ClientWidth := M;
      W := Self.Parent.ClientWidth;
      if Width > W then Width := W;
    end;

    P := Parent.ClientToScreen(Point(Left + Width, Top + Height));
    with FActiveList do
    begin
      if P.Y + Height > Screen.Height then P.Y := P.Y - Self.Height - Height;
      SetWindowPos(Handle, HWND_TOP, P.X - Width, P.Y,
        0, 0, SWP_NOSIZE + SWP_SHOWWINDOW);
      SetActiveWindow(Handle);
    end;
    SetFocus;
    FListVisible := True;
  end;
end;

procedure TZListButton.CloseUp(Accept: Boolean);
var
  ListValue: string;
  Ch: Char;
begin
  if FListVisible then
  begin
    with FActiveList do
    begin
      if (ItemIndex >= 0) and (ItemIndex < Items.Count) then
        ListValue := Items[ItemIndex] else Accept := False;
//    Invalidate;
      Hide;
      Ch := #27; // Emulate ESC  
      FEditor.KeyPress(Ch);
    end;
    FListVisible := False;
    if Accept then  // Emulate ENTER keypress
    begin
      FEditor.Text := ListValue;
      FEditor.Modified := True;
      Ch := #13;
      FEditor.KeyPress(Ch);
    end;
    if Focused then FEditor.SetFocus;
  end;
end;                    

procedure TZListButton.StopTracking;
begin
  if FTracking then
  begin
    TrackButton(-1, -1);
    FTracking := False;
//    MouseCapture := False;
  end;
end;

procedure TZListButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if FListVisible then
      CloseUp(False)
    else
    begin
//      MouseCapture := True;
      FTracking := True;
      TrackButton(X, Y);
      if FArrow then DropDown;
    end;
  end;
  inherited;
end;

procedure TZListButton.MouseMove(Shift: TShiftState; X, Y: Integer);
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
  inherited;
end;

procedure TZListButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  WasPressed: Boolean;
begin
  WasPressed := FPressed;
  StopTracking;
  if (Button = mbLeft) and not FArrow and WasPressed then FEditor.DblClick;
  inherited;
end;

procedure TZListButton.ListMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    CloseUp(PtInRect(FActiveList.ClientRect, Point(X, Y)));
end;

procedure TZListButton.DoDropDownKeys(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN, VK_ESCAPE:
      if FListVisible and not (ssAlt in Shift) then
      begin
        CloseUp(Key = VK_RETURN);
        Key := 0;
      end;
    else
  end;
end;

procedure TZListButton.CMCancelMode(var Message: TCMCancelMode);
begin
  inherited;
  if (Message.Sender <> Self) and (Message.Sender <> FActiveList) then
    CloseUp(False);
end;

procedure TZListButton.WMCancelMode(var Msg: TWMKillFocus);
begin
  StopTracking;
  inherited;
end;

procedure TZListButton.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  CloseUp(False);
end;

procedure TZListButton.KeyPress(var Key: Char);
begin
  if FListVisible then FActiveList.KeyPress(Key);
end;

procedure TZListButton.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_KEYDOWN, WM_SYSKEYDOWN, WM_CHAR:
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

procedure TZListButton.WMGetDlgCode(var Msg: TWMGetDlgCode);
begin
  Msg.Result := DLGC_WANTARROWS;
end;

{$IFDEF VCL50_UP}
procedure TZListButton.MeasureHeight(Control: TWinControl; Index: Integer;
  var Height: Integer);
{$ifdef VCL60_UP }
var
  CustomPropertyListDrawing : ICustomPropertyListDrawing;
{$endif}
begin
  Height := FListItemHeight;
  {$ifdef VCL60_UP }
    if Editor.QueryInterface(ICustomPropertyListDrawing,CustomPropertyListDrawing)=S_OK then
    begin
      CustomPropertyListDrawing.ListMeasureHeight(Editor.GetName, FActiveList.Canvas, Height);
      CustomPropertyListDrawing := nil;
    end;
  {$else}
    with Editor do
      ListMeasureHeight(GetName, FActiveList.Canvas, Height);
  {$endif}

end;

procedure TZListButton.DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
{$ifdef VCL60_UP }
var
  CustomPropertyListDrawing : ICustomPropertyListDrawing;
{$endif}
begin
  with FActiveList do
    {$ifdef VCL60_UP }
      if Editor.QueryInterface(ICustomPropertyListDrawing,CustomPropertyListDrawing)=S_OK then
      begin
        CustomPropertyListDrawing.ListDrawValue(Items[Index], Canvas,
          Rect, odSelected in State);
        CustomPropertyListDrawing := nil;
      end else
      begin
        Canvas.TextRect(Rect, Rect.Left + 1, Rect.Top + 1, Items[Index]);
      end;
    {$else}
      Editor.ListDrawValue(Items[Index], Canvas,
        Rect, odSelected in State);
    {$endif}
end;

procedure TZListButton.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Canvas.Font := FPropList.Font;
  FListItemHeight := Canvas.TextHeight('Wg') + 2;
end;
{$ENDIF}

{ TZInplaceEdit }

constructor TZInplaceEdit.Create(AOwner: TComponent);
begin
  inherited;
  Parent := AOwner as TWinControl;
  FPropList := AOwner as TZPropList;
  FListButton := TZListButton.Create(Self);
  FListButton.Parent := Parent;
  ParentCtl3D := False;
  Ctl3D := False;
  TabStop := False;
  BorderStyle := bsNone;
  Visible := False;
end;

procedure TZInplaceEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE;
end;

procedure TZInplaceEdit.InternalMove(const Loc: TRect; Redraw: Boolean);
var
  W, H: Integer;
  ButtonVisible: Boolean;
begin
  if IsRectEmpty(Loc) then Exit;
  Redraw := Redraw or not IsWindowVisible(Handle);
  with Loc do
  begin
    W := Right - Left;
    H := Bottom - Top;
    FPropType := FPropList.GetPropType;
    ButtonVisible := (FPropType <> ptSimple);

    if ButtonVisible then Dec(W, FListButton.FButtonWidth);
    SetWindowPos(Handle, HWND_TOP, Left, Top, W, H,
      SWP_SHOWWINDOW or SWP_NOREDRAW);
    if ButtonVisible then
    begin
      FListButton.FArrow := FPropType = ptPickList;
      SetWindowPos(FListButton.Handle, HWND_TOP, Left + W, Top,
        FListButton.FButtonWidth, H, SWP_SHOWWINDOW or SWP_NOREDRAW);
    end
    else FListButton.Hide;
  end;
  BoundsChanged;

  if Redraw then
  begin
    Invalidate;
    FListButton.Invalidate;
  end;
  if FPropList.Focused then Windows.SetFocus(Handle);
end;

procedure TZInplaceEdit.BoundsChanged;
var
  R: TRect;
begin
  R := Rect(2, 1, Width - 2, Height);
  SendMessage(Handle, EM_SETRECTNP, 0, Integer(@R));
  SendMessage(Handle, EM_SCROLLCARET, 0, 0);
end;

procedure TZInplaceEdit.UpdateLoc(const Loc: TRect);
begin
  InternalMove(Loc, False);
end;

procedure TZInplaceEdit.Move(const Loc: TRect);
begin
  InternalMove(Loc, True);
end;

procedure TZInplaceEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
//  OutputDebugString('KeyDown');
  if (Key = VK_DOWN) and (ssAlt in Shift) then
    with FListButton do
  begin
    if (FPropType = ptPickList) and not FListVisible then DropDown;
    Key := 0;
  end;
  FIgnoreChange := Key = VK_DELETE;
  FPropList.KeyDown(Key, Shift);
  if Key in [VK_UP, VK_DOWN, VK_PRIOR, VK_NEXT] then Key := 0;
end;

procedure TZInplaceEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
//  OutputDebugString('KeyUp');
  FPropList.KeyUp(Key, Shift);
end;

procedure TZInplaceEdit.SetFocus;
begin
  if IsWindowVisible(Handle) then
    Windows.SetFocus(Handle);
end;

procedure TZInplaceEdit.WMSetFocus(var Msg: TWMSetFocus);
begin
  inherited;
  DestroyCaret;
  CreateCaret(Handle, 0, 1, FPropList.Canvas.TextHeight('A'));
  ShowCaret(Handle);
end;

procedure TZInplaceEdit.KeyPress(var Key: Char);
begin
//  OutputDebugString('KeyPress');
//  FPropList.KeyPress(Key);
  FIgnoreChange := (Key = #8) or (SelText <> '');
  case Key of
    #10: DblClick;  // Ctrl + ENTER;
    #13: if Modified then FPropList.UpdateText(True) else SelectAll;
    #27: with FPropList do
           if paRevertable in Editor.getAttributes then UpdateEditor(False);
    else Exit;
  end;
  Key := #0;
end;

procedure TZInplaceEdit.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  if (Msg.FocusedWnd <> FPropList.Handle) and
    (Msg.FocusedWnd <> FListButton.Handle) then
    if not FPropList.UpdateText(True) then SetFocus;
end;

procedure TZInplaceEdit.DblClick;
begin
  FPropList.Edit;
end;

procedure TZInplaceEdit.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_LBUTTONDOWN:
      begin
        if UINT(GetMessageTime - FClickTime) < GetDoubleClickTime then
          Message.Msg := WM_LBUTTONDBLCLK;
        FClickTime := 0;
      end;
  end;
  inherited;
end;

procedure TZInplaceEdit.AutoComplete(const S: string);
var
  I: Integer;
  Values: TStringList;
  AddValue: TGetStrFunc;
begin
  Values := TStringList.Create;
  try
    AddValue := Values.Add;
    FPropList.Editor.GetValues(TGetStrProc(AddValue));
    for I := 0 to Values.Count - 1 do
      if StrLIComp(PChar(S), PChar(Values[I]), Length(S)) = 0 then
      begin
        SendMessage(Handle, WM_SETTEXT, 0, Integer(Values[I]));
        SendMessage(Handle, EM_SETSEL, Length(S), Length(Values[I]));
        Modified := True;
        Break;
      end;
  finally
    Values.Free;
  end;
end;

procedure TZInplaceEdit.Change;
begin
  inherited;
  if Modified then
  begin
//    OutputDebugString(PChar('Change, Text = "' + Text + '"'));
    if (FPropType = ptPickList) and not FIgnoreChange then
      AutoComplete(Text);
    FIgnoreChange := False;
    if FAutoUpdate then FPropList.UpdateText(False);
  end;
end;

{ TZPropList }

constructor TZPropList.Create(AOwner: TComponent);
const
  PropListStyle = [csCaptureMouse, csOpaque, csDoubleClicks];
begin
  inherited;
  FInplaceEdit := TZInplaceEdit.Create(Self);
  FPropColor := clNavy;
  FEditors := TZEditorList.Create(Self);
  FDesigner := TZFormDesigner.Create(Self);
{$IFDEF VCL40_up}
  FDesigner._AddRef;
{$ENDIF}
{$IFDEF VCL50_UP}
  FNewButtons := True;
{$ENDIF}  
  FCurrent := -1;
  FFilter := tkProperties;
  FBorderStyle := bsSingle;

  if NewStyleControls then
    ControlStyle := PropListStyle else
    ControlStyle := PropListStyle + [csFramed];
  Color := clBtnFace;
  ParentColor := False;
  TabStop := True;
  SetBounds(Left, Top, 200, 200);
  FVertLine := 85;
  ShowHint := True;
  ParentShowHint := False;
//  CurObj := Self;
//  DoubleBuffered := False;
end;

procedure TZPropList.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style + WS_TABSTOP;
    Style := Style + WS_VSCROLL;
    WindowClass.style := CS_DBLCLKS;
    if FBorderStyle = bsSingle then
      if NewStyleControls and Ctl3D then
      begin
        Style := Style and not WS_BORDER;
        ExStyle := ExStyle or WS_EX_CLIENTEDGE;
      end
      else
        Style := Style or WS_BORDER;
  end;
end;

procedure TZPropList.InitCurrent(const PropName: string);
begin
//  FCurrent := FEditors.FindPropName(PropName);
  MoveCurrent(FEditors.FindPropName(PropName));
//  if Assigned(FInplaceEdit) then FInplaceEdit.Move(GetEditRect);
end;

procedure TZPropList.FreePropList;
begin
  FEditors.Clear;
  FPropCount := 0;
end;

procedure TZPropList.InitPropList;
var
  Components:
  {$ifdef VCL60_UP }
     IDesignerSelections
  {$else}
     {$IFDEF VCL50_UP}TDesignerSelectionList{$ELSE}TComponentList{$ENDIF}
  {$endif};
begin
  Components :=
  {$ifdef VCL60_UP }
     CreateSelectionList;
  {$else}
     {$IFDEF VCL50_UP}TDesignerSelectionList{$ELSE}TComponentList{$ENDIF}.Create;
  {$endif}
  try
    Components.Add({$IFDEF VCL20}TComponent{$ELSE}TPersistent{$ENDIF}(FCurObj));
    FCurrentIdent := 0;
    FCurrentPos := 0;
    GetComponentProperties(Components, FFilter, FDesigner, PropEnumProc);
    FPropCount := FEditors.Count;
  finally
    {$ifdef VCL60_UP }
    Components := nil;
    {$else}
    Components.Free;
    {$endif}
  end;
end;

function TZPropList.GetFullPropName(Index: Integer): string;
begin
  Result := FEditors[Index].peEditor.GetName;
  while Index > 0 do
  begin
    if FEditors[Pred(Index)].peIdent <> FEditors[Index].peIdent then
      Result := FEditors[Pred(Index)].peEditor.GetName + '\' + Result;
    Dec(Index);
  end;
end;

procedure TZPropList.ChangeCurObj(const Value: TObject);
var
  SavedPropName: string;
begin
  if (FCurrent >= 0) and (FCurrent < FPropCount) then
    SavedPropName := GetFullPropName(FCurrent)
  else SavedPropName := '';

  FCurObj := Value;
  FreePropList;
  if not FDestroying then
  begin
    InitCurrent('');

    if Assigned(Value) then
    begin
      InitPropList;
      InitCurrent(SavedPropName);
      UpdateEditor(True);
    end;

    Invalidate;
    UpdateScrollRange;
  end;
end;

procedure TZPropList.SetCurObj(const Value: TObject);
begin
  if FCurObj <> Value then
  begin
    if Assigned(FOnNewObject) then FOnNewObject(Self, FCurObj, Value);
    if not FDestroying then
      FInplaceEdit.Modified := False;
    FModified := False;
    ChangeCurObj(Value);

    if Value is TComponent then
      TComponent(Value).FreeNotification(Self);
  end;
end;

procedure TZPropList.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Canvas.Font := Font;
  FRowHeight := Canvas.TextHeight('Wg') + 3;
  Invalidate;
  UpdateScrollRange;
  FInplaceEdit.Move(GetEditRect);
end;

procedure TZPropList.UpdateScrollRange;
var
  si: TScrollInfo;
  diVisibleCount, diCurrentPos: Integer;
begin
  if not FHasScrollBar or not HandleAllocated or not Showing then Exit;

  { Temporarily mark us as not having scroll bars to avoid recursion }
  FHasScrollBar := False;
  try
    with si do
    begin
      cbSize := SizeOf(TScrollInfo);
      fMask := SIF_RANGE + SIF_PAGE + SIF_POS;
      nMin := 0;
      diVisibleCount := VisibleRowCount;
      diCurrentPos := FTopRow;

      if FPropCount <= diVisibleCount then
      begin
        nPage := 0;
        nMax := 0;
      end
      else
      begin
        nPage := diVisibleCount;
        nMax := FPropCount - 1;
      end;

      if diCurrentPos + diVisibleCount > FPropCount then
        diCurrentPos := EMax(0, FPropCount - diVisibleCount);
      nPos := diCurrentPos;
      {$IFDEF VCL40_prior}
      SetScrollInfo(Handle, SB_VERT, si, True);
      {$ELSE}
      FlatSB_SetScrollInfo(Handle, SB_VERT, si, True);
      {$ENDIF}
      MoveTop(diCurrentPos);
    end;
  finally
    FHasScrollBar := True;
  end;
end;

function TZPropList.VisibleRowCount: Integer;
begin
  if FRowHeight > 0 then // avoid division by zero
    Result := EMin(ClientHeight div FRowHeight, FPropCount)
  else
    Result := FPropCount;
end;

procedure TZPropList.CMShowingChanged(var Message: TMessage);
begin
  inherited;
  if Showing then
  begin
    FHasScrollBar := True;
    Perform(CM_FONTCHANGED, 0, 0);
    FInplaceEdit.FListButton.Perform(CM_FONTCHANGED, 0, 0);
    if csDesigning in ComponentState then CurObj := Self;
    Parent.Realign;
{    UpdateScrollRange;
    InitCurrent;
    UpdateEditor(True);}
  end;
end;

procedure TZPropList.WMEraseBkGnd(var Msg: TWMEraseBkGnd);
begin
  Msg.Result := 1;
end;

procedure TZPropList.WMSize(var Msg: TWMSize);
begin
  inherited;
  if FRowHeight <= 0 then Exit;
  ColumnSized(FVertLine);         // move divider if needed
  Invalidate;
  FInplaceEdit.UpdateLoc(GetEditRect);
  UpdateScrollRange;
end;

procedure TZPropList.ModifyScrollBar(ScrollCode: Integer);
var
  OldPos, NewPos, MaxPos: Integer;
  si: TScrollInfo;
begin
  OldPos := FTopRow;
  NewPos := OldPos;

  with si do
  begin
    cbSize := SizeOf(TScrollInfo);
    fMask := SIF_ALL;
    {$IFDEF VCL40_prior}
    GetScrollInfo(Handle, SB_VERT, si);
    {$ELSE}
    FlatSB_GetScrollInfo(Handle, SB_VERT, si);
    {$ENDIF}
    MaxPos := nMax - Integer(nPage) + 1;

    case ScrollCode of
      SB_LINEUP: Dec(NewPos);
      SB_LINEDOWN: Inc(NewPos);
      SB_PAGEUP: Dec(NewPos, nPage);
      SB_PAGEDOWN: Inc(NewPos, nPage);
      SB_THUMBPOSITION, SB_THUMBTRACK: NewPos := nTrackPos;
      SB_TOP: NewPos := nMin;
      SB_BOTTOM: NewPos := MaxPos;
      else Exit;
    end;

{    if NewPos < 0 then NewPos := 0;
    if NewPos > MaxPos then NewPos := MaxPos;}
    MoveTop(NewPos);
  end;
end;

procedure TZPropList.WMVScroll(var Msg: TWMVScroll);
begin
  ModifyScrollBar(Msg.ScrollCode);
end;

procedure TZPropList.MoveTop(NewTop: Integer);
var
  VertCount, ShiftY: Integer;
  ScrollArea: TRect;
begin
  if NewTop < 0 then NewTop := 0;
  VertCount := VisibleRowCount;
  if NewTop + VertCount > FPropCount then
    NewTop := FPropCount - VertCount;

  if NewTop = FTopRow then Exit;

  ShiftY := (FTopRow - NewTop) * FRowHeight;
  FTopRow := NewTop;
  ScrollArea := ClientRect;
  {$IFDEF VCL40_prior}
  SetScrollPos(Handle, SB_VERT, NewTop, True);
  {$ELSE}
  FlatSB_SetScrollPos(Handle, SB_VERT, NewTop, True);
  {$ENDIF}
  if Abs(ShiftY) >= VertCount * FRowHeight then
    InvalidateRect(Handle, @ScrollArea, True)
  else
    ScrollWindowEx(Handle, 0, ShiftY,
      @ScrollArea, @ScrollArea, 0, nil, SW_INVALIDATE);

  FInplaceEdit.Move(GetEditRect);
end;

function TZPropList.GetValueRect(ARow: Integer): TRect;
var
  RowStart: Integer;
begin
  RowStart := (ARow - FTopRow) * FRowHeight;
  Result := Rect(FVertLine + 1, RowStart, ClientWidth, RowStart + FRowHeight - 1);
end;

function TZPropList.GetEditRect: TRect;
begin
  Result := GetValueRect(FCurrent);
end;

procedure TZPropList.Paint;

{  procedure DrawValue(const S: string; R: TRect; XOfs: Integer);
  begin
    ExtTextOut(Canvas.Handle, R.Left + XOfs, R.Top + 1,
      ETO_CLIPPED or ETO_OPAQUE, @R, PChar(S), Length(S), nil);
  end;}

  procedure DrawName(Index: Integer; R: TRect; XOfs: Integer);
  var
    S: string;
    E: PZEditor;
    BColor, PColor: TColor;
    YOfs: Integer;
  begin
    if FNewButtons then
    begin
      E := FEditors[Index];
      //begin hyl modified
      //S := E.peEditor.GetName;
      S := E.peName;
      //end hyl modified

      Inc(XOfs, R.Left + E.peIdent * 10);
      ExtTextOut(Canvas.Handle, XOfs + 11, R.Top + 1,
        ETO_CLIPPED or ETO_OPAQUE, @R, PChar(S), Length(S), nil);

      if E.peNode then
        with Canvas do
      begin
        BColor := Brush.Color;
        PColor := Pen.Color;
        Brush.Color := clWindow;
        Pen.Color := Font.Color;

        YOfs := R.Top + (FRowHeight - 9) shr 1;
        Rectangle(XOfs, YOfs, XOfs + 9, YOfs + 9);
        PolyLine([Point(XOfs + 2, YOfs + 4), Point(XOfs + 7, YOfs + 4)]);
        if not E.peExpanded then
          PolyLine([Point(XOfs + 4, YOfs + 2), Point(XOfs + 4, YOfs + 7)]);

        Brush.Color := BColor;
        Pen.Color := PColor;
      end;
    end
    else
    begin
      Canvas.TextRect(R, R.Left + XOfs, R.Top + 1, GetName(Index));
    end;
  end;


  function GetPenColor(Color: Integer): Integer;
  type
    TRGB = record
      R, G, B, A: Byte;
    end;
  begin
    // produce slightly darker color
    if Color < 0 then Color := GetSysColor(Color and $FFFFFF);
    Dec(TRGB(Color).R, EMin(TRGB(Color).R, $10));
    Dec(TRGB(Color).G, EMin(TRGB(Color).G, $10));
    Dec(TRGB(Color).B, EMin(TRGB(Color).B, $10));
    Result := Color;
  end;

var
  RedrawRect, NameRect, ValueRect, CurRect: TRect;
  FirstRow, LastRow, Y, RowIdx, CW, Offset: Integer;
  NameColor: TColor;
  DrawCurrent: Boolean;
  {$ifdef VCL60_UP }
  CustomPropertyDrawing: ICustomPropertyDrawing;
  {$endif}
begin
  if FRowHeight < 1 then Exit;
  FInplaceEdit.Move(GetEditRect);

  with Canvas do
  begin
    RedrawRect := ClipRect;
    FirstRow := RedrawRect.Top div FRowHeight;
    LastRow := EMin(FPropCount - FTopRow - 1, (RedrawRect.Bottom - 1) div FRowHeight);
    if LastRow + FTopRow = Pred(FCurrent) then Inc(LastRow); // Selection occupies 2 rows

{with RedrawRect do
  Form1.p1.Caption := Format('%d, %d, %d, %d: %d-%d',
    [Left, Top, Right, Bottom, FirstRow, LastRow]);}

    NameRect := Bounds(0, FirstRow * FRowHeight, FVertLine, FRowHeight - 1);
    ValueRect := NameRect;
    ValueRect.Left := FVertLine + 2;
    CW := ClientWidth;
    ValueRect.Right := CW;
    Brush.Color := Self.Color;
    Pen.Color := GetPenColor(Self.Color);
    Font := Self.Font;
    NameColor := Font.Color;
    DrawCurrent := False;

    for Y := FirstRow to LastRow do
    begin
      RowIdx := Y + FTopRow;
      Font.Color := NameColor;

      if RowIdx = FCurrent then
      begin
        CurRect := Rect(0, NameRect.Top - 2, CW, NameRect.Bottom + 1);
        DrawCurrent := True;
        Inc(NameRect.Left); // Space for DrawEdge
        DrawName(RowIdx, NameRect, 1);
        Dec(NameRect.Left);
      end
      else
      begin
        if RowIdx <> Pred(FCurrent) then
        begin
          Offset := 0;
          PolyLine([Point(0, NameRect.Bottom), Point(CW, NameRect.Bottom)]);
        end
        else
          Offset := 1;
        Dec(NameRect.Bottom, Offset);
        DrawName(RowIdx, NameRect, 2);
        Inc(NameRect.Bottom, Offset);
        Font.Color := FPropColor;

        {$IFDEF VCL50}
        FEditors[RowIdx].peEditor.PropDrawValue(Self.Canvas, ValueRect, False);
        {$ELSE}
          {$ifdef VCL60_UP }
        if FEditors[RowIdx].peEditor.QueryInterface(ICustomPropertyDrawing,CustomPropertyDrawing)=S_OK then
        begin
          CustomPropertyDrawing.PropDrawValue(Self.Canvas, ValueRect, False);
          CustomPropertyDrawing:= nil;
        end else
        begin
          {$endif}
        // Default Drawing
        Dec(ValueRect.Bottom, Offset);
        TextRect(ValueRect, ValueRect.Left + 1, ValueRect.Top + 1,
          GetPrintableValue(RowIdx));
        Inc(ValueRect.Bottom, Offset);
          {$ifdef VCL60_UP }
        end;
          {$endif}
        {$ENDIF}
      end;

      OffsetRect(NameRect, 0, FRowHeight);
      OffsetRect(ValueRect, 0, FRowHeight);
    end;

    Dec(NameRect.Bottom, FRowHeight - 1);
    NameRect.Right := CW;
    ValueRect := Rect(FVertLine, RedrawRect.Top, 10, NameRect.Bottom - 1);
    DrawEdge(Handle, ValueRect, EDGE_ETCHED, BF_LEFT);

    if DrawCurrent then
    begin
      DrawEdge(Handle, CurRect, BDR_SUNKENOUTER, BF_LEFT + BF_BOTTOM + BF_RIGHT);
      DrawEdge(Handle, CurRect, EDGE_SUNKEN, BF_TOP);
    end;

    if NameRect.Bottom < RedrawRect.Bottom then
    begin
      Brush.Color := Self.Color;
      RedrawRect.Top := NameRect.Bottom;
      FillRect(RedrawRect);
    end;
  end;
end;

procedure TZPropList.WMGetDlgCode(var Msg: TWMGetDlgCode);
begin
  Msg.Result := DLGC_WANTARROWS;
end;

procedure TZPropList.KeyDown(var Key: Word; Shift: TShiftState);
var
  PageHeight, NewCurrent: Integer;
begin
  inherited KeyDown(Key, Shift);
  NewCurrent := FCurrent;
  PageHeight := VisibleRowCount - 1;
  case Key of
    VK_UP: Dec(NewCurrent);
    VK_DOWN: Inc(NewCurrent);
    VK_NEXT: Inc(NewCurrent, PageHeight);
    VK_PRIOR: Dec(NewCurrent, PageHeight);
    else Exit;
  end;
  MoveCurrent(NewCurrent);
end;

procedure TZPropList.InvalidateSelection;
var
  R: TRect;
  RowStart: Integer;
begin
  RowStart := (FCurrent - FTopRow) * FRowHeight;
  R := Rect(0, RowStart - 2, ClientWidth, RowStart + FRowHeight + 1);
  InvalidateRect(Handle, @R, True);
end;

function TZPropList.MoveCurrent(NewCur: Integer): Boolean;
var
  NewTop, VertCount: Integer;
begin
  Result := UpdateText(True);
  if not Result then Exit;

  if NewCur < 0 then NewCur := 0;
  if NewCur >= FPropCount then NewCur := FPropCount - 1;
  if NewCur = FCurrent then Exit;

  InvalidateSelection;
  FCurrent := NewCur;
  InvalidateSelection;

  NewTop := FTopRow;
  VertCount := VisibleRowCount;
  if NewCur < NewTop then NewTop := NewCur;
  if NewCur >= NewTop + VertCount then NewTop := NewCur - VertCount + 1;
  
  FInplaceEdit.Move(GetEditRect);
  UpdateEditor(True);
  MoveTop(NewTop);
end;

procedure TZPropList.MarkModified;
begin
  FModified := True;
  // begin add
  if Assigned(OnModified) then
    OnModified(self);
  // end add
end;

procedure TZPropList.ClearModified;
begin
  FModified := False;
end;

procedure TZPropList.Synchronize;
begin
  MarkModified;
  Invalidate;
  UpdateEditor(False);
end;

procedure TZPropList.UpdateEditor(CallActivate: Boolean);
var
  Attr: TPropertyAttributes;
begin
  if Assigned(FInplaceEdit) and (FCurrent >= 0) then
  with FInplaceEdit, Editor do
  begin
    if CallActivate then Activate;
    MaxLength := GetEditLimit;
    Attr := GetAttributes;
    ReadOnly := paReadOnly in Attr;
    FAutoUpdate := paAutoUpdate in Attr;
    Text := GetPrintableValue(FCurrent);
    SelectAll;
    Modified := False;
  end;
end;

function TZPropList.UpdateText(Exiting: Boolean): Boolean;
begin
  Result := True;
  if not FInUpdate and Assigned(FInplaceEdit) and
    (FCurrent >= 0) and (FInplaceEdit.Modified) then
  begin
    FInUpdate := True;
    try
      SetValue(FCurrent, FInplaceEdit.Text);
    except
      Result := False;
      FTracking := False;
      Application.ShowException(Exception(ExceptObject));
    end;
    if Exiting then UpdateEditor(False);
    Invalidate;            // repaint all dependent properties
    FInUpdate := False;
  end;
end;

procedure TZPropList.WMNCHitTest(var Msg: TWMNCHitTest);
begin
  inherited;
  FHitTest := ScreenToClient(SmallPointToPoint(Msg.Pos));
end;

function TZPropList.VertLineHit(X: Integer): Boolean;
begin
  Result := Abs(X - FVertLine) < 3;
end;

function TZPropList.ButtonHit(X: Integer): Boolean;
begin
// whether we hit collapse/expand button next to property with subproperties
  if FCurrent >= 0 then
  begin
    Dec(X, FEditors[FCurrent].peIdent * 10);
    Result := (X > 0) and (X < 12);
  end
  else
    Result := False;
end;

procedure TZPropList.SetBorderStyle(Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TZPropList.WMSetCursor(var Msg: TWMSetCursor);
var
  Cur: HCURSOR;
begin
  Cur := 0;
  if (Msg.HitTest = HTCLIENT) and VertLineHit(FHitTest.X) then
    Cur := Screen.Cursors[crHSplit];
  if Cur <> 0 then SetCursor(Cur) else inherited;
end;

procedure TZPropList.CMDesignHitTest(var Msg: TCMDesignHitTest);
begin
  Msg.Result := Integer(FDividerHit or VertLineHit(Msg.XPos));
end;

function TZPropList.YToRow(Y: Integer): Integer;
begin
  Result := FTopRow + Y div FRowHeight;
end;

procedure TZPropList.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if not (csDesigning in ComponentState) and
    (CanFocus or (GetParentForm(Self) = nil)) then SetFocus;

  if ssDouble in Shift then DblClick
  else
  begin
    FDividerHit := VertLineHit(X) and (Button = mbLeft);
    if not FDividerHit and (Button = mbLeft) then
    begin
      if not MoveCurrent(YToRow(Y)) then Exit;
      if FNewButtons and ButtonHit(X) then NodeClicked
      else
      begin
        FTracking := True;
        FInplaceEdit.FClickTime := GetMessageTime;
      end;
    end;
  end;

  inherited;
end;

procedure TZPropList.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if FDividerHit then SizeColumn(X)
  else
    if FTracking and (ssLeft in Shift) then MoveCurrent(YToRow(Y));

  inherited;
end;

procedure TZPropList.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  FDividerHit := False;
  FTracking := False;
  inherited;
end;

function TZPropList.ColumnSized(X: Integer): Boolean;
var
  NewSizingPos: Integer;
begin
  NewSizingPos := EMax(MINCOLSIZE, EMin(X, ClientWidth - MINCOLSIZE));
  Result := NewSizingPos <> FVertLine;
  FVertLine := NewSizingPos
end;

procedure TZPropList.SizeColumn(X: Integer);
begin
  if ColumnSized(X) then
  begin
    Invalidate;
    FInplaceEdit.UpdateLoc(GetEditRect);
  end;
end;

procedure TZPropList.CMCancelMode(var Msg: TMessage);
begin
  inherited;
  CancelMode;
end;

procedure TZPropList.CancelMode;
begin
  FDividerHit := False;
  FTracking := False;
end;

procedure TZPropList.WMCancelMode(var Msg: TMessage);
begin
  inherited;
  CancelMode;
end;

destructor TZPropList.Destroy;
begin
  FDestroying := True;
  FHasScrollBar := False;      // disable UpdateScrollRange
  FInplaceEdit := nil;
  CurObj := nil;
  {$IFDEF VCL40_prior}
  FDesigner.Free;
  {$ELSE}
  FDesigner._Release;         
  {$ENDIF}
  FEditors.Free;
  inherited;
end;

procedure TZPropList.WMSetFocus(var Msg: TWMSetFocus);
begin
  inherited;
  FInplaceEdit.SetFocus;
end;

function TZPropList.GetName(Index: Integer): string;
var
  Ident: Integer;
begin
  with FEditors[Index]^ do
  begin
    Ident := peIdent shl 1;
    if not peNode then Inc(Ident, 2);
    Result := peEditor.GetName;
    if peNode then
      if peExpanded then Result := '- ' + Result
      else Result := '+' + Result;
    Result := StringOfChar(' ', Ident) + Result;
  end;
end;

function TZPropList.GetValue(Index: Integer): string;
begin
  Result := FEditors[Index].peEditor.GetValue;
end;

function TZPropList.GetPrintableValue(Index: Integer): string;
var
  I: Integer;
  P: PChar;
begin
  Result := GetValue(Index);
  UniqueString(Result);
  P := Pointer(Result);
  for I := 0 to Length(Result) - 1 do
  begin
    if P^ < #32 then P^ := '.';
    Inc(P);
  end;
end;

type
  THPropEdit = class(TPropertyEditor)
  end;

procedure TZPropList.DoEdit(E: {$ifdef VCL60_UP }IProperty{$else}TPropertyEditor{$endif}; DoEdit: Boolean; const Value: string);
var
  CanChange: Boolean;
  Obj: Integer;
  IsObject : Boolean;
  OrdValue : Integer;
begin
  CanChange := True;
  if Assigned(FOnChanging) then FOnChanging(Self, E, CanChange);
  if CanChange then
  begin
    Obj := 0;
    IsObject := {E is TClassProperty} E.GetPropType^.Kind=tkClass;
    OrdValue := 0;
    if IsObject then
      OrdValue :=
        {$ifdef VCL60_UP }
        GetOrdProp(FCurObj, E.GetName);
        {$else}
        THPropEdit(E).GetOrdValue;
        {$endif}
    if IsObject then Obj := OrdValue;
    if DoEdit then E.Edit else E.SetValue(Value);
    if IsObject and (Obj <> OrdValue)
      and FEditors[FCurrent].peExpanded then NodeClicked; // collapse modified prop
    if Assigned(FOnChange) then FOnChange(Self, E);
  end;
end;

procedure TZPropList.SetValue(Index: Integer; const Value: string);
begin
  DoEdit(FEditors[Index].peEditor, False, Value);
end;

procedure TZPropList.SetPropColor(const Value: TColor);
begin
  if FPropColor <> Value then
  begin
    FPropColor := Value;
    Invalidate;
  end;
end;

function TZPropList.GetPropType: TZPropType;
var
  Attr: TPropertyAttributes;
begin
  Result := ptSimple;
  if (FCurrent >= 0) and (FCurrent < FPropCount) then
  begin
    Attr := Editor.GetAttributes;
    if paValueList in Attr then Result := ptPickList
    else
      if paDialog in Attr then Result := ptEllipsis;
  end;
end;

{$ifdef VCL60_UP }
procedure TZPropList.PropEnumProc(const Prop: IProperty);
{$else}
procedure TZPropList.PropEnumProc(Prop: TPropertyEditor);
{$endif}
var
  P: PZEditor;
begin
  New(P);
  P.peEditor := Prop;
  P.peIdent := FCurrentIdent;
  P.peExpanded := False;
  P.peNode := paSubProperties in Prop.GetAttributes;
  //begin hyl modified
  P.peName := P.peEditor.GetName;
  if Assigned(FOnFilterProp) then
    FOnFilterProp(Self,P);
  if P<>nil then
  begin
    FEditors.Insert(FCurrentPos, P);
    Inc(FCurrentPos);
  end;
  //end hyl modified
end;

procedure TZPropList.Edit;
begin
  DoEdit(Editor, True, '');
  UpdateEditor(False);
  Invalidate;            // repaint all dependent properties
end;

procedure TZPropList.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  NCH: Integer;
begin
  if FIntegralHeight and (FRowHeight > 0) then
  begin
    NCH := Height - ClientHeight;
    AHeight := ((AHeight - NCH) div FRowHeight) * FRowHeight + NCH;
  end;
  inherited;
end;

procedure TZPropList.SetIntegralHeight(const Value: Boolean);
begin
  if FIntegralHeight <> Value then
  begin
    FIntegralHeight := Value;
    {$IFDEF VCL40_prior}
    Parent.Realign;
    {$ELSE}
    AdjustSize;
    {$ENDIF}
  end;
end;

{$IFDEF VCL40_up}
const
  Styles: array[TScrollBarStyle] of Integer = (FSB_REGULAR_MODE,
    FSB_ENCARTA_MODE, FSB_FLAT_MODE);
{$ENDIF}

procedure TZPropList.DestroyWnd;
begin
  if FFormHandle <> 0 then
  begin
    SetWindowLong(FFormHandle, GWL_WNDPROC, Integer(FDefFormProc));
    FFormHandle := 0;
  end;
  inherited;
end;

procedure TZPropList.CreateWnd;
// begin
var
  Form : TCustomForm;
// end
begin
  inherited;
  {$IFDEF VCL40_up}
  ShowScrollBar(Handle, SB_BOTH, False);
  InitializeFlatSB(Handle);
  FlatSB_SetScrollProp(Handle, WSB_PROP_VSTYLE,
    Styles[FScrollBarStyle], False);
  {$ENDIF}

  if not (csDesigning in ComponentState) then
  begin
    {
    FFormHandle := GetParentForm(Self).Handle;
    }
    // begin
    Form := GetParentForm(Self);
    if Form<>nil then
      FFormHandle := Form.Handle else
      FFormHandle := 0;
    // end

    if FFormHandle <> 0 then
      FDefFormProc := Pointer(SetWindowLong(FFormHandle, GWL_WNDPROC,
        Integer({$ifdef VCL60_UP }Classes.{$else}Forms.{$endif}MakeObjectInstance(FormWndProc))));
  end;
end;

procedure TZPropList.FormWndProc(var Message: TMessage);
begin
  with Message do
  begin
    if (Msg = WM_NCLBUTTONDOWN) or (Msg = WM_LBUTTONDOWN) then
      FInplaceEdit.FListButton.CloseUp(False);
    Result := CallWindowProc(FDefFormProc, FFormHandle, Msg, WParam, LParam);
  end;
end;

procedure TZPropList.SetFilter(const Value: TTypeKinds);
begin
  if FFilter <> Value then
  begin
    FFilter := Value;
    ChangeCurObj(FCurObj);
  end;
end;

procedure TZPropList.CMCtl3DChanged(var Message: TMessage);
begin
  RecreateWnd;
  inherited;
end;

procedure TZPropList.DblClick;
begin
  inherited;
  NodeClicked;
end;

procedure TZPropList.NodeClicked;
var
  Index, CurIdent, AddedCount, NewTop: Integer;
begin
// Expand|collapse node subproperties
  if (FCurrent >= 0) and (FEditors[FCurrent].peNode) then
    with FEditors[FCurrent]^ do
  begin
    if peExpanded then
    begin
      Index := FCurrent + 1;
      CurIdent := peIdent;
      while (Index < FEditors.Count) and
        (FEditors[Index].peIdent > CurIdent) do
      begin
        FEditors.DeleteEditor(Index);
        FEditors.Delete(Index);
      end
    end
    else
    begin
      FCurrentIdent := peIdent + 1;
      FCurrentPos := FCurrent + 1;
      try
        Editor.GetProperties(PropEnumProc);
      except
      end;
    end;

    peExpanded := not peExpanded;
    AddedCount := FEditors.Count - FPropCount;
    FPropCount := FEditors.Count;
    if AddedCount > 0 then  // Bring expanded properties in view
    begin
      Dec(AddedCount, VisibleRowCount - 1);
      if AddedCount > 0 then AddedCount := 0;
      NewTop := FCurrent + AddedCount;
      if NewTop > FTopRow then MoveTop(NewTop);
    end
{    else
      if AddedCount = 0 then peNode := False};
    Invalidate;
    UpdateScrollRange;
  end;
end;

function TZPropList.Editor: {$ifdef VCL60_UP }IProperty{$else}TPropertyEditor{$endif};
begin
  Result := FEditors[FCurrent].peEditor;
end;


procedure TZPropList.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and not FDestroying then
  begin
    if AComponent = FCurObj then CurObj := nil;
    //begin hyl modified
    if AComponent=Root then
      Root := nil;
    //end hyl modified
  end;
end;

{$IFNDEF VCL20}
procedure TZPropList.CMHintShow(var Msg: TCMHintShow);
var
  Row, W: Integer;
  S: string;
{$IFDEF VCL50_UP}
  W2: Integer;
{$ENDIF}
{$ifdef VCL60_UP }
  CustomPropertyListDrawing : ICustomPropertyListDrawing;
{$endif}
begin
  with Msg, HintInfo^ do
  begin
    Result := 1;
    Row := YToRow(CursorPos.Y);
    if (CursorPos.X > FVertLine) and (Row < FPropCount) then
    begin
      S := GetValue(Row);
      CursorRect := GetValueRect(Row);
      if Pos(#10, S) > 0 then         // Multiline string
        W := MaxInt
      else
      begin
        W := Canvas.TextWidth(S);
        {$IFDEF VCL50_UP}
        W2 := W;
          {$ifdef VCL60_UP }
          if FEditors[Row].peEditor.QueryInterface(ICustomPropertyListDrawing,CustomPropertyListDrawing)=S_OK then
          begin
            CustomPropertyListDrawing.ListMeasureWidth(S, Canvas, W2);
            CustomPropertyListDrawing := nil;
          end;
          {$else}
          FEditors[Row].peEditor.ListMeasureWidth(S, Canvas, W2);
          {$endif}
        if W2 <> W then W := W2 + 4; // add extra space in case of custom drawing
        {$ENDIF}
      end;

      if W >= CursorRect.Right - CursorRect.Left - 1 then
      begin
        Inc(CursorRect.Bottom);
        HintPos := ClientToScreen(
          Point(CursorRect.Left - 1, CursorRect.Top - 2));
        HintStr := S;
        if Assigned(FOnHint) then FOnHint(Self, FEditors[Row].peEditor, HintInfo);
        Result := 0;
      end;
    end;
  end;
end;
{$ENDIF}

{$IFDEF VCL40_up}
procedure TZPropList.SetScrollBarStyle(const Value: TScrollBarStyle);
begin
  if FScrollBarStyle <> Value then
  begin
    FScrollBarStyle := Value;
    FlatSB_SetScrollProp(Handle, WSB_PROP_VSTYLE, Styles[Value], True);
  end;
end;
{$ENDIF}

procedure TZPropList.SetNewButtons(const Value: Boolean);
begin
  if FNewButtons <> Value then
  begin
    FNewButtons := Value;
    Invalidate;
  end;
end;

procedure TZPropList.SetMiddle(const Value: Integer);
begin
  SizeColumn(Value);
end;

procedure TZPropList.SetFocus;
begin
  if IsWindowVisible(Handle) then inherited SetFocus;
end;

//begin hyl modified
procedure TZPropList.SetRoot(const Value : TComponent);
begin
  if FRoot <> Value then
  begin
    FRoot := Value;
    if FRoot<>nil then
      FRoot.FreeNotification(Self);
  end;

end;

procedure TZPropList.DoValidateRename(AComponent: TComponent; const CurName, NewName: string);
begin
  if Assigned(FOnValidateRename) then
    FOnValidateRename(AComponent,CurName,NewName);
end;
//end hyl modified

{ TZFormDesigner }

constructor TZFormDesigner.Create(APropList: TZPropList);
begin
  inherited Create;
  FPropList := APropList;
end;

function TZFormDesigner.CreateComponent(ComponentClass: TComponentClass;
  Parent: TComponent; Left, Top, Width, Height: Integer): TComponent;
begin
// Not used by TPropertyEditor
  Result := nil;
end;

function TZFormDesigner.CreateMethod(const Name: string;
  TypeData: PTypeData): TMethod;
begin
{ CreateMethod is the abstract prototype of a method that creates an event
  handler. Call CreateMethod to add an event handler to the unit of the object
  returned by the GetRoot method. Allocate a TTypeData structure and fill in
  the MethodKind, ParamCount, and ParamList fields. The event handler gets the
  name specified by the Name parameter and the type specified by the TypeData
  parameter. CreateMethod returns a method pointer to the new event handler }
  Result.Code := nil;
  Result.Data := nil;
end;

{$IFDEF VCL40_up}
function TZFormDesigner.GetAncestorDesigner: {$ifdef VCL60_UP } IDesigner; {$else} IFormDesigner; {$endif}
begin
// Not used by TPropertyEditor
  Result := nil;
end;

procedure TZFormDesigner.GetProjectModules(Proc: TGetModuleProc);
begin
// Not used by TPropertyEditor
end;

function TZFormDesigner.IsSourceReadOnly: Boolean;
begin
// Not used by TPropertyEditor
  Result := True;
end;

{$ifndef VCL60_UP }
function TZFormDesigner.GetCustomForm: TCustomForm;
begin
// Not used by TPropertyEditor
  Result := nil;
end;

procedure TZFormDesigner.SetCustomForm(Value: TCustomForm);
begin
// Not used by TPropertyEditor
end;

function TZFormDesigner.GetIsControl: Boolean;
begin
// Not used by TPropertyEditor
  Result := False;
end;

procedure TZFormDesigner.SetIsControl(Value: Boolean);
begin
// Not used by TPropertyEditor
end;

procedure TZFormDesigner.AddToInterface(InvKind: Integer;
  const Name: string; VT: Word; const TypeInfo: string);
begin
// Not used by TPropertyEditor
end;
{$endif}

{$ENDIF}

function TZFormDesigner.GetComponent(const Name: string): TComponent;
begin
{ GetComponent is the abstract prototype for a method that returns the
  component with the name passed as a parameter. Call GetComponent to access a
  component given its name. If the component is not in the current root object,
  the Name parameter should include the name of the entity in which it resides }
  { // old
  Result := nil;
  }
  //begin hyl modified
  if FPropList.Root<>nil then
    Result := FPropList.Root.FindComponent(Name)
  else
    Result := nil;
  //end hyl modified
end;

function TZFormDesigner.GetComponentName(Component: TComponent): string;
begin
{ GetComponentName is the abstract prototype of a method that returns the name
  of the component passed as its parameter. Call GetComponentName to obtain the
  name of a component. This is the inverse of GetComponent }
  if Assigned(Component) then
    Result := Component.Name
  else
    Result := '';
end;

procedure TZFormDesigner.GetComponentNames(TypeData: PTypeData;
  Proc: TGetStrProc);
var
  AClassType : TClass;
  i : integer;
begin
{ GetComponentNames is the abstract prototype of a method that implements a
  callback for every component that can be assigned a property of a specified
  type. Use GetComponentNames to call the procedure specified by the Proc
  parameter for every component that can be assigned a property that matches
  the TypeData parameter. For each component, Proc is called with its S
  parameter set to the name of the component. This parameter can be used to
  obtain a reference to the component by calling the GetComponent method }

  //begin hyl modified
  if FPropList.Root<>nil then
  begin
    AClassType := TypeData^.ClassType;
    with FPropList.Root do
      for i:=0 to ComponentCount-1 do
        if Components[i].InheritsFrom(AClassType) and (Components[i].Name<>'') then
          Proc(Components[i].Name);
  end;
  //end hyl modified
end;

{$IFNDEF VCL20}
function TZFormDesigner.GetIsDormant: Boolean;
begin
// Not used by TPropertyEditor
  Result := False;
end;

{$ifndef VCL60_UP }
function TZFormDesigner.HasInterface: Boolean;
begin
// Not used by TPropertyEditor
  Result := False;
end;

function TZFormDesigner.HasInterfaceMember(const Name: string): Boolean;
begin
// Not used by TPropertyEditor
  Result := False;
end;
{$endif}

function TZFormDesigner.GetObject(const Name: string): TPersistent;
begin
// Not used by TPropertyEditor
  Result := nil;
end;

function TZFormDesigner.GetObjectName(Instance: TPersistent): string;
begin
// Not used by TPropertyEditor
  Result := 'IFormDesigner.GetObjectName';
end;

procedure TZFormDesigner.GetObjectNames(TypeData: PTypeData;
  Proc: TGetStrProc);
begin
// Not used by TPropertyEditor
end;
{$ENDIF}

function TZFormDesigner.GetMethodName(const Method: TMethod): string;
var
  Instance: TComponent;
begin
{ GetMethodName is the abstract prototype of a method that returns the name of
  a specified event handler. Call GetMethodName to obtain the name of an event
  handler given a pointer to it }
  Instance := Method.Data;
  if Assigned(Instance) then
    Result := Instance.Name + '.' + Instance.MethodName(Method.Code)
  else
    Result := '';
end;

procedure TZFormDesigner.GetMethods(TypeData: PTypeData;
  Proc: TGetStrProc);
begin
{ GetMethods is the abstract prototype of a method that implements a callback
  for every method of a specified type.
  Use GetMethods to call the procedure specified by the Proc parameter for every
  event handler that matches the TypeData parameter. For each event handler,
  Proc is called with its S parameter set to the name of the method. This
  parameter can be used to bring up a code editor for the method by calling the
  ShowMethod method }
end;

function TZFormDesigner.GetPrivateDirectory: string;
begin
// Not used by TPropertyEditor
  Result := '';
end;

function TZFormDesigner.GetRoot: TComponent;
begin
// Not used by TPropertyEditor
  Result := nil;
end;

{$IFDEF VCL40_prior}
procedure TZFormDesigner.GetSelections(List: TComponentList);
{$ELSE}
procedure TZFormDesigner.GetSelections(const List: IDesignerSelections);
{$ENDIF}
begin
// Not used by TPropertyEditor
end;

function TZFormDesigner.IsComponentLinkable(
  Component: TComponent): Boolean;
begin
// Not used by TPropertyEditor
  Result := False;
end;

{$ifndef VCL60_UP }
function TZFormDesigner.IsDesignMsg(Sender: TControl;
  var Message: TMessage): Boolean;
begin
// Not used by TPropertyEditor
  Result := False;
end;
{$endif}

procedure TZFormDesigner.MakeComponentLinkable(Component: TComponent);
begin
// Not used by TPropertyEditor
end;

function TZFormDesigner.MethodExists(const Name: string): Boolean;
begin
{ MethodExists is the abstract prototype for a method that indicates whether
  an event handler with a specified name already exists.
  Call MethodExists to determine whether an event handler with a given name
  has already been created. If MethodExists returns True, the specified event
  handler exists and can be displayed by calling the ShowMethod method. If
  MethodExists returns False, the specified event handler does not exist, and
  can be created by calling the CreateMethod method }
  Result := False;
end;

function TZFormDesigner.MethodFromAncestor(const Method: TMethod): Boolean;
begin
// Not used by TPropertyEditor
  Result := True;
end;

procedure TZFormDesigner.Modified;
begin
{ The Modified method notifes property and component editors when a change
  is made to a component. }
  FPropList.MarkModified;
end;

{$IFDEF VCL30}
procedure TZFormDesigner.AddInterfaceMember(const MemberText: string);
begin
// Not used by TPropertyEditor
end;
{$ENDIF}

{$ifndef VCL60_UP }
{$IFDEF VCL40_prior}
procedure TZFormDesigner.Notification(AComponent: TComponent; Operation: TOperation);
{$ELSE}
procedure TZFormDesigner.Notification(AnObject: TPersistent;
  Operation: TOperation);
{$ENDIF}
begin
// Not used by TPropertyEditor
end;

procedure TZFormDesigner.PaintGrid;
begin
// Not used by TPropertyEditor
end;
{$endif}

procedure TZFormDesigner.RenameMethod(const CurName, NewName: string);
begin
{ RenameMethod is the abstract prototype for a method that renames an existing
  event handler.
  Call RenameMethod to provide an event handler with a new name. The CurName
  parameter specifies the current name of the event handler, and the NewName
  parameter specifies the value that the name should be changed to }
end;

procedure TZFormDesigner.Revert(Instance: TPersistent;
  PropInfo: PPropInfo);
begin
// Used by TPropertyEditor, but not called from TZPropList component
end;

procedure TZFormDesigner.SelectComponent(Instance: {$IFDEF VCL20}TComponent{$ELSE}TPersistent{$ENDIF});
begin
// Not used by TPropertyEditor
end;

{$IFDEF VCL40_prior}
procedure TZFormDesigner.SetSelections(List: TComponentList);
{$ELSE}
procedure TZFormDesigner.SetSelections(const List: IDesignerSelections);
{$ENDIF}
begin
// Not used by TPropertyEditor
end;

procedure TZFormDesigner.ShowMethod(const Name: string);
begin
{ ShowMethod is the abstract prototype for a method that activates the code
  editor with the input cursor in a specified event handler.
  Call ShowMethod to allow the user to edit the method specified by the Name
  parameter }
end;

function TZFormDesigner.UniqueName(const BaseName: string): string;
begin
// Not used by TPropertyEditor
end;

{$ifndef VCL60_UP }
procedure TZFormDesigner.ValidateRename(AComponent: TComponent;
  const CurName, NewName: string);
begin
  //begin hyl modified
  FPropList.DoValidateRename(AComponent,CurName, NewName);
  //end hyl modified
end;
{$endif}

{$IFDEF VCL50_UP}
{$ifndef VCL60_UP }
function TZFormDesigner.GetContainerWindow: TWinControl;
begin
// Not used by TPropertyEditor
  Result := nil;
end;

procedure TZFormDesigner.SetContainerWindow(const NewContainer: TWinControl);
begin
// Not used by TPropertyEditor
end;
{$endif}

function TZFormDesigner.GetScrollRanges(const ScrollPosition: TPoint): TPoint;
begin
// Not used by TPropertyEditor
  Result := ScrollPosition;
end;

procedure TZFormDesigner.Edit(const Component: {$ifdef VCL60_UP }  TComponent {$else} IComponent {$endif});
begin
// Not used by TPropertyEditor
end;

{$ifndef VCL60_UP }
function TZFormDesigner.BuildLocalMenu(Base: TPopupMenu; Filter: TLocalMenuFilters): TPopupMenu;
begin
// Not used by TPropertyEditor
  Result := Base;
end;
{$endif}


procedure TZFormDesigner.ChainCall(const MethodName, InstanceName, InstanceMethod: string;
  TypeData: PTypeData);
begin
{ Used internally when creating event methods that call another event handler
  inherited from a frame. ChainCall is used internally to generate the method
  call to an inherited method. Applications should not use this method }
end;

procedure TZFormDesigner.CopySelection;
begin
// Not used by TPropertyEditor
end;

procedure TZFormDesigner.CutSelection;
begin
// Not used by TPropertyEditor
end;

function TZFormDesigner.CanPaste: Boolean;
begin
// Not used by TPropertyEditor
  Result := False;
end;

procedure TZFormDesigner.PasteSelection;
begin
// Not used by TPropertyEditor
end;

procedure TZFormDesigner.DeleteSelection;
begin
// Not used by TPropertyEditor
end;

procedure TZFormDesigner.ClearSelection;
begin
// Not used by TPropertyEditor
end;

procedure TZFormDesigner.NoSelection;
begin
// Not used by TPropertyEditor
end;

procedure TZFormDesigner.ModuleFileNames(var ImplFileName, IntfFileName, FormFileName: string);
begin
// Not used by TPropertyEditor
end;

function TZFormDesigner.GetRootClassName: string;
begin
{ Returns the class name for the root component. Call GetRootClassName to
  obtain the name of the component returned by the GetRoot method }
  Result := '';
end;
{$ENDIF}

{$ifdef VCL60_UP }
procedure TZFormDesigner.Activate;
begin
// Not used by TPropertyEditor
end;

function TZFormDesigner.GetPathAndBaseExeName: string;
begin
// Not used by TPropertyEditor
  Result := '';
end;

function TZFormDesigner.GetBaseRegKey: string;
begin
// Not used by TPropertyEditor
  Result := '';
end;

function TZFormDesigner.GetIDEOptions: TCustomIniFile;
begin
// Not used by TPropertyEditor
  Result := nil;
end;

function TZFormDesigner.CreateCurrentComponent(Parent: TComponent; const Rect: TRect): TComponent;
begin
// Not used by TPropertyEditor
  Result := nil;
end;

function TZFormDesigner.IsComponentHidden(Component: TComponent): Boolean;
begin
// Not used by TPropertyEditor
  Result := False;
end;

function TZFormDesigner.GetShiftState: TShiftState;
begin
// Not used by TPropertyEditor
  Result := [];
end;

procedure TZFormDesigner.ModalEdit(EditKey: Char; const ReturnWindow: IActivatable);
begin
// Not used by TPropertyEditor
end;

procedure TZFormDesigner.SelectItemName(const PropertyName: string);
begin
// Not used by TPropertyEditor
end;

procedure TZFormDesigner.Resurrect;
begin
// Not used by TPropertyEditor
end;
{$endif}

procedure RegPropEdit(PropertyType: PTypeInfo; EditorClass: TPropertyEditorClass);
begin
  RegisterPropertyEditor(PropertyType, nil, '', EditorClass);
end;

initialization

// Register common property editors
  RegPropEdit(TypeInfo(TCaption), TCaptionProperty);
  RegPropEdit(TypeInfo(TColor), TColorProperty);
  RegPropEdit(TypeInfo(TComponentName), TComponentNameProperty);
  RegPropEdit(TypeInfo(TComponent), TComponentProperty);
  RegPropEdit(TypeInfo(TCursor), TCursorProperty);
{$IFNDEF VCL20}
  RegPropEdit(TypeInfo(TDate), TDateProperty);
  RegPropEdit(TypeInfo(TDateTime), TDateTimeProperty);
  RegPropEdit(TypeInfo(TFontCharset), TFontCharsetProperty);
  RegPropEdit(TypeInfo(TImeName), TImeNameProperty);
  RegPropEdit(TypeInfo(TTime), TTimeProperty);
{$ENDIF}
  RegPropEdit(TypeInfo(TFontName), TFontNameProperty);
  RegPropEdit(TypeInfo(TFont), TFontProperty);
  RegPropEdit(TypeInfo(TModalResult), TModalResultProperty);
  RegPropEdit(TypeInfo(TShortCut), TShortCutProperty);
  RegPropEdit(TypeInfo(TTabOrder), TTabOrderProperty);
{$IFDEF VCL50_UP}
  RegPropEdit(TypeInfo(TBrushStyle), TBrushStyleProperty);
  RegPropEdit(TypeInfo(Int64), TInt64Property);
  RegPropEdit(TypeInfo(TPenStyle), TPenStyleProperty);
{$ENDIF}

end.

