unit DBListOne;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, stdCtrls,Forms, Dialogs,
  Grids, DBGrids,Buttons,DB,DBTables,DBCtrls;

type
  TCustomDBListOne = class(TCustomDBGrid)
  private
    { Private declarations }
    function GetDataField: string;
    procedure SetDataField(const Value: string);
    function GetSelectText: string;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    function GetDataSource: TDataSource;
    procedure SetDataSource(const Value: TDataSource);
  protected
    { Protected declarations }
    FFieldLink: TFieldDataLink;
    procedure SetColumnAttributes; override;
    property DataField : string read GetDataField write SetDataField;
    property DataSource : TDataSource Read GetDataSource write SetDataSource;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    property RowCount;
    property SelectText : string read GetSelectText;
  published
    { Published declarations }
  end;

  TDBListOne = class(TCustomDBListOne)
  published
    property Align;
    {$ifdef VER110}
    property Anchors;
    property Constraints;
    property DragKind;
    property OnEndDock;
    property OnStartDock;
    {$endif}
    property BorderStyle;
    property Color;
    property Ctl3D;
    property DataSource;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnCellClick;
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

    property DataField;
  end;

  TDBComboList = class;

  TPopupList = class(TCustomDBListOne)
  private
    FCombo : TDBComboList;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
  protected
    procedure CreateWnd; override;
  public
    constructor Create(AOwner: TComponent); override;
    property OnColEnter;
  published

  end;

  TDBComboList = class(TCustomEdit)
  private
    FList: TPopupList;
    FButton: TSpeedButton;
    FBtnControl: TWinControl;
    FDropDownCount: Integer;
    FDropDownWidth: Integer;
    FOnDropDown: TNotifyEvent;
    FTextMargin : integer;
    function GetDataField: string;
    function GetDataSource: TDataSource;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(const Value: TDataSource);
    procedure ButtonClick(sender : TObject);
    procedure SetEditRect;
    procedure WMSize(var Message: TWMSize); message WM_Size;
    function GetMinHeight: Integer;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure DataChanged(sender : TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Loaded; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure DropDown; dynamic;
    procedure CloseUp; dynamic;
  published
    property DataSource : TDataSource read GetDataSource write setDataSource;
    property DataField : string read GetDataField write SetDataField;

    {$ifdef VER110}
    property Anchors;
    property Constraints;
    {$endif}
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

implementation

{ TCustomDBListOne }

constructor TCustomDBListOne.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  options := [dgAlwaysShowSelection];
  Columns.clear;
  Columns.Add;
  FFieldLink := TFieldDataLink.Create;
  FFieldLink.Control := Self;
  FFieldLink.DataSource := inherited DataSource;
end;

destructor TCustomDBListOne.Destroy;
begin
  FFieldLink.Free;
  FFieldLink := nil;
  inherited Destroy;
end;

function TCustomDBListOne.GetDataField: string;
begin
  result := Columns[0].Fieldname;
end;

function TCustomDBListOne.GetDataSource: TDataSource;
begin
  result := inherited DataSource;
end;

function TCustomDBListOne.GetSelectText: string;
begin
  result := GetFieldValue(0);
end;

procedure TCustomDBListOne.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (Operation = opRemove)
  and (FFieldLink <> nil)
  and (AComponent = DataSource) then
    FFieldLink.DataSource := nil;
end;

procedure TCustomDBListOne.SetColumnAttributes;
var
  CWidth : integer;
begin
  inherited SetColumnAttributes;
  CWidth := width - GetSystemMetrics(SM_CXHSCROLL) - 1 - 4 ;
  if CWidth<0 then CWidth := 0;
  Columns[0].width :=CWidth;
end;

procedure TCustomDBListOne.SetDataField(const Value: string);
begin
  Columns[0].Fieldname := value;
  FFieldLink.Fieldname := value;
end;

procedure TCustomDBListOne.SetDataSource(const Value: TDataSource);
begin
  inherited DataSource := value;
  FFieldLink.DataSource := value;
end;

procedure TCustomDBListOne.WMSize(var Message: TWMSize);
begin
  inherited;
  SetColumnAttributes;
end;

{ TDBComboList }

constructor TDBComboList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoSize := False;
  FBtnControl := TWinControl.Create(Self);
  FBtnControl.Width := 17;
  FBtnControl.Height := 17;
  FBtnControl.Visible := True;
  FBtnControl.Parent := Self;
  FButton := TSpeedButton.Create(Self);
  FButton.SetBounds(0, 0, FBtnControl.Width, FBtnControl.Height);
  FButton.Glyph.Handle := LoadBitmap(0, PChar(32738));
  FButton.Visible := True;
  FButton.Parent := FBtnControl;
  FButton.OnClick := ButtonClick;
  FList := TPopupList.Create(Self);
  FList.Parent := Self;
  FList.Visible := False;
  FList.FComBo := self;
  FList.FFieldLink.OnDataChange := DataChanged;
  FList.FFieldLink.OnActiveChange := DataChanged;
  Height := 25;
  FDropDownCount := 8;
  ReadOnly := true;
end;

destructor TDBComboList.Destroy;
begin
  FList.FFieldLink.OnDataChange := nil;
  FList.FFieldLink.OnActiveChange := nil;
  FList.free;
  inherited Destroy;
end;

function TDBComboList.GetDataField: string;
begin
  result := FList.DataField;
end;

function TDBComboList.GetDataSource: TDataSource;
begin
  result :=  FList.DataSource;
end;

procedure TDBComboList.SetDataField(const Value: string);
begin
  FList.DataField := value;
end;

procedure TDBComboList.setDataSource(const Value: TDataSource);
begin
  FList.DataSource := value;
end;

procedure TDBComboList.ButtonClick;
begin
  if not FList.Visible then
      if (Handle <> GetFocus) and CanFocus then
      begin
        SetFocus;
        if GetFocus <> Handle then Exit;
      end;
  if FList.Visible then CloseUp
    else DropDown;
end;

procedure TDBComboList.CloseUp;
begin
  FList.Visible := False;
end;

procedure TDBComboList.DropDown;
var
  ItemCount: Integer;
  P: TPoint;
  Y: Integer;
  GridWidth, GridHeight, BorderWidth: Integer;
  SysBorderWidth, SysBorderHeight: Integer;
begin
  if not FList.Visible and (Width > 20) then
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
   { if loRowLines in Options then
      BorderWidth := 1 else}
      BorderWidth := 0;
    GridHeight := (FList.DefaultRowHeight + BorderWidth) *
      (ItemCount {+ FList.FTitleOffset}) + 2;
    FList.Height := GridHeight;
    if ItemCount > FList.RowCount then
    begin
      ItemCount := FList.RowCount;
      GridHeight := (FList.DefaultRowHeight + BorderWidth) *
        (ItemCount {+ FList.FTitleOffset}) + 4;
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
      SetWindowPos(FList.Handle, 0, P.X, Y, GridWidth, GridHeight, SWP_NOACTIVATE) else
      SetWindowPos (FList.Handle, 0, P.X + Width - GridWidth, Y, GridWidth, GridHeight, SWP_NOACTIVATE);
    FList.Visible := True;
    Windows.SetFocus(Handle);
  end;
end;

procedure TDBComboList.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE or WS_CLIPCHILDREN;
end;

procedure TDBComboList.CreateWnd;
begin
  inherited CreateWnd;
  SetEditRect;
  FList.HandleNeeded;
end;

procedure TDBComboList.SetEditRect;
var
  Loc: TRect;
begin
  Loc.Bottom := ClientHeight + 1;  {+1 is workaround for windows paint bug}
  Loc.Right := FBtnControl.Left - 2;
  Loc.Top := 0;
  Loc.Left := 0;
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@Loc));
end;

procedure TDBComboList.WMSize(var Message: TWMSize);
var
  MinHeight: Integer;
begin
  inherited;
  if (csDesigning in ComponentState) then
    FList.SetBounds(0, Height + 1, 10, 10);
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

procedure TDBComboList.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if (key in [VK_ESCAPE,VK_SPACE,VK_RETURN,VK_BACK]) then
  begin
    Closeup;
    key := 0;
  end;

  if (Key in [VK_UP, VK_DOWN, VK_NEXT, VK_PRIOR]) then
  begin
    if not FList.Visible then DropDown
    else begin
      FList.KeyDown(Key, Shift);
    end;
    Key := 0;
  end;
end;

function TDBComboList.GetMinHeight: Integer;
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



procedure TDBComboList.CMExit(var Message: TCMExit);
begin
  inherited;
  Closeup;
end;

procedure TDBComboList.DataChanged;
begin
  text := FList.SelectText;
end;

procedure TDBComboList.Loaded;
begin
  inherited Loaded;
  DataChanged(nil);
end;

{ TPopupList }

constructor TPopupList.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
  FAcquireFocus := false;
  TabStop := False;
end;

procedure TPopupList.CreateWnd;
begin
  inherited CreateWnd;
  if not (csDesigning in ComponentState) then
    Windows.SetParent(Handle, 0);
  CallWindowProc(DefWndProc, Handle, WM_SETFOCUS, 0, 0);
end;


procedure TPopupList.WMLButtonUp(var Message: TWMLButtonUp);
begin
  inherited;
  FCombo.CloseUp;
end;

end.
