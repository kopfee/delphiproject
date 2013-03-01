unit Lookup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,Buttons, DBGrids, Grids, DBCtrls;

type
  TLookupComboStyle = (csDropDown, csDropDownList);
  TLookupListOption = (loColLines, loRowLines, loTitles);
  TLookupListOptions = set of TLookupListOption;

  {TLookupCombo = class;}

  TLookupList = class(TCustomDBGrid)
  private
    FOptions: TLookupListOptions;
   // FListFieldName : string;
    FColumn : TColumn ;
    //FOnListClick: TNotifyEvent;
    procedure SetOptions(Value: TLookupListOptions);
    {procedure SetListField(value : string);}
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Options: TLookupListOptions read FOptions write SetOptions default [];
    //property OnClick: TNotifyEvent read FOnListClick write FOnListClick;
   // property ListFieldname : string read FListFieldName write SetListField;
    property Column : TColumn Read FColumn;
    property DataSource;
    property Align;
    property BorderStyle;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnStartDrag;
  end;

(*
  TPopupLookupList = class(TLookupList)
  private
    FCombo: TLookupCombo;
    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    function CanEdit: Boolean; override;
    procedure LinkActive(Value: Boolean); override;
  public
    property RowCount;
    constructor Create(AOwner: TComponent); override;
  end;

  TLookupCombo = class(TCustomEdit)
  private
    { Private declarations }
    FCanvas: TControlCanvas;
    FDropDownCount: Integer;
    FDropDownWidth: Integer;
    FTextMargin: Integer;
    FGrid: TPopupGrid;
    FButton: TSpeedButton;
    FBtnControl: TWinControl;
    FStyle: TDBLookupComboStyle;
    FOnDropDown: TNotifyEvent;
    function GetLookupSource: TDataSource;
    function GetLookupDisplay: string;
    function GetLookupField: string;
    function GetReadOnly: Boolean;
    function GetValue: string;
    function GetDisplayValue: string;
    function GetMinHeight: Integer;
    function GetOptions: TDBLookupListOptions;
    function CanEdit: Boolean;
    function Editable: Boolean;
    procedure SetValue(const NewValue: string);
    procedure SetDisplayValue(const NewValue: string);
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    procedure SetLookupSource(Value: TDataSource);
    procedure SetLookupDisplay(const Value: string);
    procedure SetLookupField(const Value: string);
    procedure SetReadOnly(Value: Boolean);
    procedure SetOptions(Value: TDBLookupListOptions);
    procedure SetStyle(Value: TDBLookupComboStyle);
    procedure UpdateData(Sender: TObject);
    procedure NonEditMouseDown(var Message: TWMLButtonDown);
    procedure DoSelectAll;
    procedure SetEditRect;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CANCELMODE;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure Change; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure GridClick (Sender: TObject);
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DropDown; dynamic;
    procedure CloseUp; dynamic;
    property Value: string read GetValue write SetValue;
    property DisplayValue: string read GetDisplayValue write SetDisplayValue;
  published
    property LookupSource: TDataSource read GetLookupSource write SetLookupSource;
    property LookupDisplay: string read GetLookupDisplay write SetLookupDisplay;
    property LookupField: string read GetLookupField write SetLookupField;
    property Options: TDBLookupListOptions read GetOptions write SetOptions default [];
    property Style: TDBLookupComboStyle read FStyle write SetStyle default csDropDown;
    property AutoSelect;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property DropDownCount: Integer read FDropDownCount write FDropDownCount default 8;
    property DropDownWidth: Integer read FDropDownWidth write FDropDownWidth default 0;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown: TNotifyEvent read FOnDropDown write FOnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

  TMyComboButton = class(TSpeedButton)
  protected
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  end;
 *)
procedure Register;

implementation

uses DBConsts, BDEConst;

constructor TLookupList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //FTitleOffset := 0;
  //FUpdateFields := False;
  //FHiliteRow := -1;
  inherited Options := [dgRowSelect];
  FixedCols := 0;
  FixedRows := 0;
  Width := 121;
  Height := 97;
  Columns.clear;
  FColumn := Columns.add;
end;

procedure TLookupList.SetOptions(Value: TLookupListOptions);
var
  NewGridOptions: TDBGridOptions;
begin
  if FOptions <> Value then
  begin
    FOptions := Value;
    //FTitleOffset := 0;
    NewGridOptions := [dgRowSelect];
    if loColLines in Value then
      NewGridOptions := NewGridOptions + [dgColLines];
    if loRowLines in Value then
      NewGridOptions := NewGridOptions + [dgRowLines];
    if loTitles in Value then
    begin
      //FTitleOffset := 1;
      NewGridOptions := NewGridOptions + [dgTitles];
    end;
    inherited Options := NewGridOptions;
  end;
end;

{
procedure TLookupList.SetListField(value : string);
begin
  FColumn.Filed
end;
}
{ TLookupCombo }
(*
constructor TLookupCombo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoSize := False;
  FFieldLink := TFieldDataLink.Create;
  FFieldLink.Control := Self;
  FFieldLink.OnDataChange := DataChange;
  FFieldLink.OnEditingChange := EditingChange;
  FFieldLink.OnUpdateData := UpdateData;
  FFieldLink.OnActiveChange := FieldLinkActive;
  FBtnControl := TWinControl.Create(Self);
  FBtnControl.Width := 17;
  FBtnControl.Height := 17;
  FBtnControl.Visible := True;
  FBtnControl.Parent := Self;
  FButton := TComboButton.Create(Self);
  FButton.SetBounds(0, 0, FBtnControl.Width, FBtnControl.Height);
  FButton.Glyph.Handle := LoadBitmap(0, PChar(32738));
  FButton.Visible := True;
  FButton.Parent := FBtnControl;
  FGrid := TPopupGrid.Create(Self);
  FGrid.FCombo := Self;
  FGrid.Parent := Self;
  FGrid.Visible := False;
  FGrid.OnClick := GridClick;
  Height := 25;
  FDropDownCount := 8;
end;

destructor TLookupCombo.Destroy;
begin
  FFieldLink.OnDataChange := nil;
  FFieldLink.Free;
  FFieldLink := nil;
  inherited Destroy;
end;

procedure TLookupCombo.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FFieldLink <> nil) then
  begin
    if (AComponent = DataSource) then DataSource := nil
    else if (AComponent = LookupSource) then
      LookupSource := nil;
  end;
end;

function TLookupCombo.Editable: Boolean;
begin
  Result := (FFieldLink.DataSource = nil) or
    ((FGrid.FValueFld = FGrid.FDisplayFld) and (FStyle <> csDropDownList));
end;

function TLookupCombo.CanEdit: Boolean;
begin
  Result := (FFieldLink.DataSource = nil) or
    (FFieldLink.Editing and Editable);
end;

procedure TLookupCombo.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if Key in [VK_BACK, VK_DELETE, VK_INSERT] then
  begin
    if Editable then
      FFieldLink.Edit;
    if not CanEdit then
      Key := 0;
  end
  else if not Editable and (Key in [VK_HOME, VK_END, VK_LEFT, VK_RIGHT]) then
    Key := 0;

  if (Key in [VK_UP, VK_DOWN, VK_NEXT, VK_PRIOR]) then
  begin
    if not FGrid.Visible then DropDown
    else begin
      FFieldLink.Edit;
      if (FFieldLink.DataSource = nil) or FFieldLink.Editing then
        FGrid.KeyDown(Key, Shift);
    end;
    Key := 0;
  end;
end;

procedure TLookupCombo.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if (Key in [#32..#255]) and (FFieldLink.Field <> nil) and
    not FFieldLink.Field.IsValidChar(Key) and Editable then
  begin
    Key := #0;
    MessageBeep(0)
  end;

  case Key of
    ^H, ^V, ^X, #32..#255:
      begin
        if Editable then FFieldLink.Edit;
        if not CanEdit then Key := #0;
      end;
    char(VK_RETURN):
      Key := #0;
    char(VK_ESCAPE):
      begin
        if not FGrid.Visible then
          FFieldLink.Reset
        else CloseUp;
        DoSelectAll;
        Key := #0;
      end;
  end;
end;

procedure TLookupCombo.Change;
begin
  if FFieldLink.Editing then FFieldLink.Modified;
  inherited Change;
end;

function TLookupCombo.GetDataSource: TDataSource;
begin
  Result := FFieldLink.DataSource;
end;

procedure TLookupCombo.SetDataSource(Value: TDataSource);
begin
  if (Value <> nil) and (Value = LookupSource) then
    raise EInvalidOperation.Create (SLookupSourceError);
  if (Value <> nil) and (LookupSource <> nil) and (Value.DataSet <> nil) and
    (Value.DataSet = LookupSource.DataSet) then
    raise EInvalidOperation.Create(SLookupSourceError);
  FFieldLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TLookupCombo.GetLookupSource: TDataSource;
begin
  Result := FGrid.LookupSource;
end;

procedure TLookupCombo.SetLookupSource(Value: TDataSource);
begin
  if (Value <> nil) and ((Value = DataSource) or
    ((Value.DataSet <> nil) and (Value.DataSet = FFieldLink.DataSet))) then
    raise EInvalidOperation.Create(SLookupSourceError);
  FGrid.LookupSource := Value;
  DataChange(Self);
  if Value <> nil then Value.FreeNotification(Self);
end;

procedure TLookupCombo.SetLookupDisplay(const Value: string);
begin
  FGrid.LookupDisplay := Value;
  FGrid.InitFields(True);
  SetValue('');
  DataChange(Self);
end;

function TLookupCombo.GetLookupDisplay: string;
begin
  Result := FGrid.LookupDisplay;
end;

procedure TLookupCombo.SetLookupField(const Value: string);
begin
  FGrid.LookupField := Value;
  FGrid.InitFields(True);
  DataChange(Self);
end;

function TLookupCombo.GetLookupField: string;
begin
  Result := FGrid.LookupField;
end;

function TLookupCombo.GetDataField: string;
begin
  Result := FFieldLink.FieldName;
end;

procedure TLookupCombo.SetDataField(const Value: string);
begin
  FFieldLink.FieldName := Value;
end;

procedure TLookupCombo.DataChange(Sender: TObject);
begin
  if (FFieldLink.Field <> nil) and not (csLoading in ComponentState) then
    Value := FFieldLink.Field.AsString
  else Text := '';
end;

function TLookupCombo.GetValue: String;
begin
  if Editable then
    Result := Text else
    Result := FGrid.Value;
end;

function TLookupCombo.GetDisplayValue: String;
begin
  Result := Text;
end;

procedure TLookupCombo.SetDisplayValue(const NewValue: String);
begin
  if FGrid.DisplayValue <> NewValue then
    if FGrid.DataLink.Active then
    begin
      FGrid.DisplayValue := NewValue;
      Text := FGrid.DisplayValue;
    end;
end;

procedure TLookupCombo.SetValue(const NewValue: String);
begin
  if FGrid.DataLink.Active and FFieldLink.Active and
    ((DataSource = LookupSource) or
    (DataSource.DataSet = LookupSource.DataSet)) then
    raise EInvalidOperation.Create(SLookupSourceError);
  if (FGrid.Value <> NewValue) or (Text <> NewValue) then
    if FGrid.DataLink.Active then
    begin
      FGrid.Value := NewValue;
      Text := FGrid.DisplayValue;
    end;
end;

function TLookupCombo.GetReadOnly: Boolean;
begin
  Result := FFieldLink.ReadOnly;
end;

procedure TLookupCombo.SetReadOnly(Value: Boolean);
begin
  FFieldLink.ReadOnly := Value;
  inherited ReadOnly := not CanEdit;
end;

procedure TLookupCombo.EditingChange(Sender: TObject);
begin
  inherited ReadOnly := not CanEdit;
end;

procedure TLookupCombo.UpdateData(Sender: TObject);
begin
  if FFieldLink.Field <> nil then
    if Editable then
      FFieldLink.Field.AsString := Text else
      FFieldLink.Field.AsString := FGrid.Value;
end;

procedure TLookupCombo.FieldLinkActive(Sender: TObject);
begin
  if FFieldLink.Active and FGrid.DataLink.Active then
  begin
    FGrid.SetValue('');
    DataChange(Self)
  end;
end;

procedure TLookupCombo.WMPaste(var Message: TMessage);
begin
  if Editable then FFieldLink.Edit;
  if CanEdit then inherited;
end;

procedure TLookupCombo.WMCut(var Message: TMessage);
begin
  if Editable then FFieldLink.Edit;
  if CanEdit then inherited;
end;

procedure TLookupCombo.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE or WS_CLIPCHILDREN;
end;

procedure TLookupCombo.CreateWnd;
begin
  inherited CreateWnd;
  SetEditRect;
  FGrid.HandleNeeded;
  DataChange(Self);
end;

procedure TLookupCombo.SetEditRect;
var
  Loc: TRect;
begin
  Loc.Bottom := ClientHeight + 1;  {+1 is workaround for windows paint bug}
  Loc.Right := FBtnControl.Left - 2;
  Loc.Top := 0;
  Loc.Left := 0;
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@Loc));
end;

procedure TLookupCombo.WMSize(var Message: TWMSize);
var
  MinHeight: Integer;
begin
  inherited;
  if (csDesigning in ComponentState) then
    FGrid.SetBounds(0, Height + 1, 10, 10);
  MinHeight := GetMinHeight;
  if Height < MinHeight then Height := MinHeight
  else begin
    if NewStyleControls then
      FBtnControl.SetBounds(ClientWidth - FButton.Width, 0, FButton.Width, ClientHeight)
    else
      FBtnControl.SetBounds(ClientWidth - FButton.Width, 1, FButton.Width, ClientHeight - 1);
    FButton.Height := FBtnControl.Height;
    SetEditRect;
  end;
end;

function TLookupCombo.GetMinHeight: Integer;
var
  DC: HDC;
  SaveFont: HFont;
  I: Integer;
  SysMetrics, Metrics: TTextMetric;
begin
  DC := GetDC(0);
  GetTextMetrics(DC, SysMetrics);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  I := SysMetrics.tmHeight;
  if I > Metrics.tmHeight then I := Metrics.tmHeight;
  FTextMargin := I div 4;
  Result := Metrics.tmHeight + FTextMargin + GetSystemMetrics(SM_CYBORDER) * 4 + 1;
end;

procedure TLookupCombo.WMPaint(var Message: TWMPaint);
var
  PS: TPaintStruct;
  ARect: TRect;
  TextLeft, TextTop: Integer;
  Focused: Boolean;
  DC: HDC;
const
  Formats: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT,
    DT_CENTER or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX);
begin
  if Editable then
  begin
    inherited;
    Exit;
  end;

  if FCanvas = nil then
  begin
    FCanvas := TControlCanvas.Create;
    FCanvas.Control := Self;
  end;

  DC := Message.DC;
  if DC = 0 then DC := BeginPaint(Handle, PS);
  FCanvas.Handle := DC;
  try
    Focused := GetFocus = Handle;
    FCanvas.Font := Font;
    with FCanvas do
    begin
      ARect := ClientRect;
      Brush.Color := clWindowFrame;
      FrameRect(ARect);
      InflateRect(ARect, -1, -1);
      Brush.Style := bsSolid;
      Brush.Color := Color;
      FillRect (ARect);
      TextTop := FTextMargin;
      ARect.Left := ARect.Left + 2;
      ARect.Right := FBtnControl.Left - 2;
      TextLeft := FTextMargin;
      if Focused then
      begin
        Brush.Color := clHighlight;
        Font.Color := clHighlightText;
        ARect.Top := ARect.Top + 2;
        ARect.Bottom := ARect.Bottom - 2;
      end;
      ExtTextOut(FCanvas.Handle, TextLeft, TextTop, ETO_OPAQUE or ETO_CLIPPED, @ARect,
        PChar(Text), Length(Text), nil);
      if Focused then
        DrawFocusRect(ARect);
    end;
  finally
    FCanvas.Handle := 0;
    if Message.DC = 0 then EndPaint(Handle, PS);
  end;
end;

procedure TLookupCombo.CMFontChanged(var Message: TMessage);
begin
  inherited;
  GetMinHeight;
end;

procedure TLookupCombo.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  FButton.Enabled := Enabled;
end;

procedure TLookupCombo.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  CloseUp;
end;

procedure TLookupCombo.CMCancelMode(var Message: TCMCancelMode);
begin
  with Message do
    if (Sender <> Self) and (Sender <> FBtnControl) and
      (Sender <> FButton) and (Sender <> FGrid) then CloseUp;
end;

procedure TLookupCombo.CMHintShow(var Message: TMessage);
begin
  Message.Result := Integer(FGrid.Visible);
end;

procedure TLookupCombo.DropDown;
var
  ItemCount: Integer;
  P: TPoint;
  Y: Integer;
  GridWidth, GridHeight, BorderWidth: Integer;
  SysBorderWidth, SysBorderHeight: Integer;
begin
  if not FGrid.Visible and (Width > 20) then
  begin
    if Assigned(FOnDropDown) then FOnDropDown(Self);
    ItemCount := DropDownCount;
    if ItemCount = 0 then ItemCount := 1;
    SysBorderWidth := GetSystemMetrics(SM_CXBORDER);
    SysBorderHeight := GetSystemMetrics(SM_CYBORDER);
    P := ClientOrigin;
    if NewStyleControls then
    begin
      Dec(P.X, 2 * SysBorderWidth);
      Dec(P.Y, SysBorderHeight);
    end;
    if loRowLines in Options then
      BorderWidth := 1 else
      BorderWidth := 0;
    GridHeight := (FGrid.DefaultRowHeight + BorderWidth) *
      (ItemCount + FGrid.FTitleOffset) + 2;
    FGrid.Height := GridHeight;
    if ItemCount > FGrid.RowCount then
    begin
      ItemCount := FGrid.RowCount;
      GridHeight := (FGrid.DefaultRowHeight + BorderWidth) *
        (ItemCount + FGrid.FTitleOffset) + 4;
    end;
    if NewStyleControls then
      Y := P.Y + ClientHeight + 3 * SysBorderHeight else
      Y := P.Y + Height - 1;
    if (Y + GridHeight) > Screen.Height then
    begin
      Y := P.Y - GridHeight + 1;
      if Y < 0 then
      begin
        if NewStyleControls then
          Y := P.Y + ClientHeight + 3 * SysBorderHeight else
          Y := P.Y + Height - 1;
      end;
    end;
    GridWidth := DropDownWidth;
    if GridWidth = 0 then
    begin
      if NewStyleControls then
        GridWidth := Width + 2 * SysBorderWidth else
        GridWidth := Width - 4;
    end;
    if NewStyleControls then
      SetWindowPos(FGrid.Handle, 0, P.X, Y, GridWidth, GridHeight, SWP_NOACTIVATE) else
      SetWindowPos (FGrid.Handle, 0, P.X + Width - GridWidth, Y, GridWidth, GridHeight, SWP_NOACTIVATE);
    if Length(LookupField) = 0 then
      FGrid.DisplayValue := Text;
    FGrid.Visible := True;
    Windows.SetFocus(Handle);
  end;
end;

procedure TLookupCombo.CloseUp;
begin
  FGrid.Visible := False;
end;

procedure TLookupCombo.GridClick(Sender: TObject);
begin
  FFieldLink.Edit;
  if (FFieldLink.DataSource = nil) or FFieldLink.Editing then
  begin
    FFieldLink.Modified;
    Text := FGrid.DisplayValue;
  end;
end;

procedure TLookupCombo.SetStyle(Value: TDBLookupComboStyle);
begin
  if FStyle <> Value then
    FStyle := Value;
end;

procedure TLookupCombo.WMLButtonDown(var Message: TWMLButtonDown);
begin
  if Editable then
    inherited
  else
    NonEditMouseDown(Message);
end;

procedure TLookupCombo.WMLButtonUp(var Message: TWMLButtonUp);
begin
  if not Editable then MouseCapture := False;
  inherited;
end;

procedure TLookupCombo.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  if Editable then
    inherited
  else
    NonEditMouseDown(Message);
end;

procedure TLookupCombo.NonEditMouseDown(var Message: TWMLButtonDown);
var
  CtrlState: TControlState;
begin
  SetFocus;
  HideCaret (Handle);

  if FGrid.Visible then CloseUp
  else DropDown;

  MouseCapture := True;
  if csClickEvents in ControlStyle then
  begin
    CtrlState := ControlState;
    Include(CtrlState, csClicked);
    ControlState := CtrlState;
  end;
  with Message do
    MouseDown(mbLeft, KeysToShiftState(Keys), XPos, YPos);
end;

procedure MouseDragToGrid(Ctrl: TControl; Grid: TPopupGrid; X, Y: Integer);
var
  pt, clientPt: TPoint;
begin
  if Grid.Visible then
  begin
    pt.X := X;
    pt.Y := Y;
    pt := Ctrl.ClientToScreen (pt);
    clientPt := Grid.ClientOrigin;
    if (pt.X >= clientPt.X) and (pt.Y >= clientPt.Y) and
       (pt.X <= clientPt.X + Grid.ClientWidth) and
       (pt.Y <= clientPt.Y + Grid.ClientHeight) then
    begin
      Ctrl.Perform(WM_LBUTTONUP, 0, MakeLong (X, Y));
      pt := Grid.ScreenToClient(pt);
      Grid.Perform(WM_LBUTTONDOWN, 0, MakeLong (pt.x, pt.y));
    end;
  end;
end;

procedure TLookupCombo.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
  if (ssLeft in Shift) and not Editable and (GetCapture = Handle) then
    MouseDragToGrid(Self, FGrid, X, Y);
end;

procedure TLookupCombo.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  if not Editable then HideCaret(Handle);
end;

procedure TLookupCombo.CMExit(var Message: TCMExit);
begin
  try
    FFieldLink.UpdateRecord;
  except
    DoSelectAll;
    SetFocus;
    raise;
  end;
  inherited;
  if not Editable then Invalidate;
end;

procedure TLookupCombo.CMEnter(var Message: TCMGotFocus);
begin
  if AutoSelect and not (csLButtonDown in ControlState) then DoSelectAll;
  inherited;
  if not Editable then Invalidate;
end;

procedure TLookupCombo.DoSelectAll;
begin
  if Editable then SelectAll;
end;

procedure TLookupCombo.SetOptions(Value: TDBLookupListOptions);
begin
  FGrid.Options := Value;
end;

function TLookupCombo.GetOptions: TDBLookupListOptions;
begin
  Result := FGrid.Options;
end;

procedure TLookupCombo.Loaded;
begin
  inherited Loaded;
  DataChange(Self);
end;

*)
procedure Register;
begin
  RegisterComponents('User', [TLookupList]);
end;


end.
