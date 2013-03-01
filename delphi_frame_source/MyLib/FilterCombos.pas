unit FilterCombos;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>FilterCombos
   <What>一个根据输入内容自动过滤下拉框内容的下拉框控件
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

interface

uses Windows, Messages, SysUtils, Classes, Controls, StdCtrls, Buttons, Graphics;

type
  TKSCustomFilterComboBox = class;
  {
    <Class>TKSPopupList
    <What>下拉出来的列表框
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TKSPopupList = class(TCustomListBox)
  private
    FCombo :    TKSCustomFilterComboBox;
    FRowCount : Integer;
    //procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    //procedure   CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure   WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
  protected
  	procedure   CreateParams(var Params: TCreateParams); override;
    procedure   CreateWnd; override;
    //procedure   Click; override;
    procedure   DoSelected;
  public
    constructor Create(AOwner: TComponent); override;
    property    RowCount : Integer read FRowCount write FRowCount ;
  published

  end;

  TGetSelectedTextEvent = procedure (Sender : TKSCustomFilterComboBox; var AText : string) of object;

  {
    <Class>TKSCustomFilterComboBox
    <What>一个根据输入内容自动过滤下拉框内容的下拉框控件。
    继承自TCustomEdit，使用TKSPopupList作为弹出的下拉框。
    <Properties>
      AutoDropDown  - 当获得输入焦点或者输入文字的时候自动弹出下拉框
      DropDownCount - 下拉框的行数
      DropDownWidth - 下拉框的宽度，0表示和该控件大小相同
      Style         - 下拉框的风格
      PopupList     - 下拉的列表框对象
      ItemIndex     - 列表框的选择索引
      Items         - 列表框包含的文字项目
    <Methods>
      DropDown      - 弹出下拉框
      CloseUp       - 关闭下拉框
      FilterList    - 过滤下拉框的内容
    <Event>
      OnSelected    - 当选择以后触发
      OnDropDown    - 弹出下拉框的时候触发
      OnDrawItem    - 画下拉框的一个项目
      OnMeasureItem -
      OnGetSelectedText - 选择项目以后更新编辑框的文字
  }
  TKSCustomFilterComboBox = class(TCustomEdit)
  private
    FList: TKSPopupList;
    FButton: TSpeedButton;
    FBtnControl: TWinControl;
    FDropDownCount: Integer;
    FDropDownWidth: Integer;
    FOnDropDown: TNotifyEvent;
    FTextMargin : integer;
    FOnSelected: TNotifyEvent;
    FAutoDropDown: Boolean;
    FLastText : string;
    FNotInitList : Boolean;
    FOnGetItems: TNotifyEvent;
    FAutoClear: Boolean;
    FOnGetSelectedText: TGetSelectedTextEvent;
    procedure   ButtonClick(sender : TObject);
    procedure   SetEditRect;
    procedure   WMSize(var Message: TWMSize); message WM_Size;
    function    GetMinHeight: Integer;
    procedure   CMExit(var Message: TCMExit); message CM_EXIT;
    procedure   CMCancelMode(var Message: TCMCancelMode); message CM_CANCELMODE;
    procedure   WMCancelMode(var Message: TMessage); message WM_CANCELMODE;
    procedure   WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure   CMBiDiModeChanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    function    GetItems : TStrings;
    procedure   SetItems(const Value: TStrings);
    function    GetStyle: TListBoxStyle;
    procedure   SetStyle(const Value: TListBoxStyle);
    function    GetOnDrawItem: TDrawItemEvent;
    function    GetOnMeasureItem: TMeasureItemEvent;
    procedure   SetOnDrawItem(const Value: TDrawItemEvent);
    procedure   SetOnMeasureItem(const Value: TMeasureItemEvent);
    procedure   WM_KeyDown(var Message:TWMKey); message WM_KeyDown;
    procedure   WM_KeyUp(var Message:TWMKey); message WM_KeyUp;
    function    GetItemIndex: Integer;
    procedure   SetItemIndex(const Value: Integer);
    function    GetListFont: TFont;
    procedure   SetListFont(const Value: TFont);
  protected
    procedure   CreateParams(var Params: TCreateParams); override;
    procedure   CreateWnd; override;
    // notes : when dropdown, the keyboard focus is on self , not the list
    procedure   KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure   KeyPress(var Key: Char); override;
    procedure   Loaded; override;
    procedure   InternalFilterList; virtual;
    procedure   DoEnter; override;
    procedure   Change; override;
    procedure   ListSelected; virtual;
    procedure   InternalSelected; virtual;

    property    AutoDropDown : Boolean read FAutoDropDown write FAutoDropDown default True;
    property    AutoClear : Boolean read FAutoClear write FAutoClear default False;
    property    DropDownCount: Integer read FDropDownCount write FDropDownCount default 8;
    property    DropDownWidth: Integer read FDropDownWidth write FDropDownWidth default 0;
    property    Style: TListBoxStyle read GetStyle write SetStyle default lbStandard;
    property    ListFont : TFont read GetListFont write SetListFont;
    property    OnSelected : TNotifyEvent read FOnSelected write FOnSelected;
    property    OnDropDown: TNotifyEvent read FOnDropDown write FOnDropDown;
    property    OnFilterItems : TNotifyEvent read FOnGetItems write FOnGetItems;
    property    OnDrawItem: TDrawItemEvent read GetOnDrawItem write SetOnDrawItem;
    property    OnMeasureItem: TMeasureItemEvent read GetOnMeasureItem write SetOnMeasureItem;
    property    OnGetSelectedText : TGetSelectedTextEvent read FOnGetSelectedText write FOnGetSelectedText;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
    procedure   DropDown; dynamic;
    procedure   CloseUp; dynamic;
    procedure   FilterList(ForceUpdate : Boolean=False); virtual;
    property    Items : TStrings read GetItems write SetItems;
    property    PopupList : TKSPopupList read FList;
    property    ItemIndex : Integer read GetItemIndex write SetItemIndex;
  published

  end;

  TKSFilterComboBox = class(TKSCustomFilterComboBox)
  private

  protected

  public

  published
    property    AutoDropDown;
    property    AutoClear;
    property    DropDownCount;
    property    DropDownWidth;
    property    ListFont;
    property    Style;
    property    OnSelected;
    property    OnDropDown;
    property    OnFilterItems;
    property    OnDrawItem;
    property    OnMeasureItem;
    property    OnGetSelectedText;

    property    Anchors;
    property    Constraints;
    property    AutoSelect;
    property    CharCase;
    property    Color;
    property    Ctl3D;
    property    DragCursor;
    property    DragMode;
    property    Enabled;
    property    Font;
    property    ImeMode;
    property    ImeName;
    property    MaxLength;
    property    ParentColor;
    property    ParentCtl3D;
    property    ParentFont;
    property    ParentShowHint;
    property    PopupMenu;
    property    ShowHint;
    property    TabOrder;
    property    TabStop;
    property    Text;
    property    Visible;
    property    OnChange;
    property    OnClick;
    property    OnDblClick;
    property    OnDragDrop;
    property    OnDragOver;
    property    OnEndDrag;
    property    OnEnter;
    property    OnExit;
    property    OnKeyDown;
    property    OnKeyPress;
    property    OnKeyUp;
    property    OnMouseDown;
    property    OnMouseMove;
    property    OnMouseUp;
    property    OnStartDrag;
  end;


implementation

uses Forms;

{ TKSCustomFilterComboBox }

constructor TKSCustomFilterComboBox.Create(AOwner: TComponent);
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
  FList := TKSPopupList.Create(Self);
  FList.Parent := Self;
  FList.Visible := False;
  FList.FComBo := self;
  Height := 25;
  FDropDownCount := 8;
  FAutoDropDown := True;
  FAutoClear := False;
  FNotInitList := True;
end;

destructor TKSCustomFilterComboBox.Destroy;
begin
  inherited;
end;

procedure TKSCustomFilterComboBox.ButtonClick;
begin
  if not FList.Visible then
    if (Handle <> GetFocus) and CanFocus then
    begin
      SetFocus;
      if GetFocus <> Handle then Exit;
    end;
  if FList.Visible then
  begin
    OutputDebugString('Button Click');
    CloseUp;
  end else
    DropDown;
end;

procedure TKSCustomFilterComboBox.CloseUp;
begin
  OutputDebugString('CloseUp');
  FList.Visible := False;
  //MouseCapture := false;
end;

procedure TKSCustomFilterComboBox.DropDown;
var
  //ItemCount: Integer;
  P: TPoint;
  Y: Integer;
  {GridWidth, GridHeight, }BorderWidth: Integer;
  //SysBorderWidth, SysBorderHeight: Integer;
begin
  FilterList(FNotInitList);
  if not FList.Visible and (Width > 20) then
  begin
    if Assigned(FOnDropDown) then FOnDropDown(Self);
    (*
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
    //old
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
    *)

    //new

    if DropDownCount<0 then
      FList.RowCount :=1
    else
      FList.RowCount:=DropDownCount;

    BorderWidth:=0;
    FList.Height:=(FList.ItemHeight + BorderWidth) *
      FList.RowCount+ 4;

    if FDropDownWidth > 0 then
      FList.Width := FDropDownWidth
    else
      FList.Width := Width;


    P := Parent.ClientToScreen(Point(Left, Top));
    Y := P.Y + Height;
    if Y + FList.Height > Screen.Height then Y := P.Y - FList.Height;
    SetWindowPos(FList.Handle, HWND_TOP, P.X, Y, 0, 0,
      SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWINDOW);

    FList.Visible := True;

    Windows.SetFocus(Handle);
    //MouseCapture := true;
  end;
end;

procedure TKSCustomFilterComboBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style {or ES_MULTILINE} or WS_CLIPCHILDREN;
end;

procedure TKSCustomFilterComboBox.CreateWnd;
begin
  inherited CreateWnd;
  SetEditRect;
  FList.HandleNeeded;
end;

procedure TKSCustomFilterComboBox.SetEditRect;
var
  Loc: TRect;
begin
  Loc.Bottom := ClientHeight + 1;  {+1 is workaround for windows paint bug}
  Loc.Right := FBtnControl.Left - 2;
  Loc.Top := 0;
  Loc.Left := 0;
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@Loc));
end;

procedure TKSCustomFilterComboBox.WMSize(var Message: TWMSize);
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

procedure TKSCustomFilterComboBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (key in [VK_ESCAPE,{VK_SPACE,}VK_RETURN{,VK_BACK}]) then
  begin
    OutputDebugString('keyDown');
    if key in [{VK_SPACE,}VK_RETURN] then
    // selected
      ListSelected
    else
    // cancel
      Closeup;
    key := 0;
  end
  else if (Key in [VK_UP, VK_DOWN, VK_NEXT, VK_PRIOR]) then
  begin
    if not FList.Visible then
      DropDown;
    Key := 0;
  end
  else if AutoDropDown and not FList.Visible then
    DropDown;
  inherited KeyDown(Key, Shift);
end;

function TKSCustomFilterComboBox.GetMinHeight: Integer;
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


procedure TKSCustomFilterComboBox.CMExit(var Message: TCMExit);
begin
  inherited;
  OutputDebugString('CMExit');
  Closeup;
end;

procedure TKSCustomFilterComboBox.Loaded;
begin
  inherited Loaded;
end;

procedure TKSCustomFilterComboBox.CMBiDiModeChanged(var Message: TMessage);
begin
  inherited;
  FList.BiDiMode := BiDiMode;
end;

procedure TKSCustomFilterComboBox.CMCancelMode(var Message: TCMCancelMode);
begin
  if (Message.Sender <> Self) and (Message.Sender <> FList) and (Message.Sender <> FButton) then
  begin
    OutputDebugString('CMCancelMode');
    CloseUp;
  end;
end;

procedure TKSCustomFilterComboBox.WMCancelMode(var Message: TMessage);
begin
  inherited;
end;

procedure TKSCustomFilterComboBox.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  OutputDebugString('WMKillFocus');
  CloseUp;
end;


procedure TKSCustomFilterComboBox.ListSelected;
begin
  CloseUp;
  if Assigned(FOnSelected) then
    FOnSelected(self);
  InternalSelected;
end;

procedure TKSCustomFilterComboBox.DoEnter;
begin
  inherited;
  if FAutoClear then
    Text := '';
  if FAutoDropDown then
    DropDown;
end;

procedure TKSCustomFilterComboBox.FilterList(ForceUpdate : Boolean);
begin
  FNotInitList := False;
  if ForceUpdate or (FLastText<>Text) then
  begin
    FLastText := Text;
    InternalFilterList;
  end;
end;

procedure TKSCustomFilterComboBox.Change;
begin
  inherited;
  FilterList;
end;

function TKSCustomFilterComboBox.GetItems: TStrings;
begin
  Result := FList.Items;
end;

procedure TKSCustomFilterComboBox.SetItems(const Value: TStrings);
begin
  FList.Items := Value;
end;

procedure TKSCustomFilterComboBox.InternalSelected;
var
  AText : string;
begin
  if FList.ItemIndex>=0 then
    AText := FList.Items[FList.ItemIndex] else
    AText := Text;
  if Assigned(OnGetSelectedText) then
    OnGetSelectedText(Self,AText);
  Text := AText;
end;

procedure TKSCustomFilterComboBox.InternalFilterList;
begin
  if Assigned(OnFilterItems) then
    OnFilterItems(Self);
end;

function TKSCustomFilterComboBox.GetStyle: TListBoxStyle;
begin
  Result := FList.Style;
end;

procedure TKSCustomFilterComboBox.SetStyle(const Value: TListBoxStyle);
begin
  FList.Style := Value;
end;

function TKSCustomFilterComboBox.GetOnDrawItem: TDrawItemEvent;
begin
  Result := FList.OnDrawItem;
end;

function TKSCustomFilterComboBox.GetOnMeasureItem: TMeasureItemEvent;
begin
  Result := FList.OnMeasureItem;
end;

procedure TKSCustomFilterComboBox.SetOnDrawItem(const Value: TDrawItemEvent);
begin
  FList.OnDrawItem := Value;
end;

procedure TKSCustomFilterComboBox.SetOnMeasureItem(
  const Value: TMeasureItemEvent);
begin
  FList.OnMeasureItem := Value;
end;

procedure TKSCustomFilterComboBox.WM_KeyDown(var Message: TWMKey);
begin
  if (Message.CharCode in [VK_UP, VK_DOWN, VK_NEXT, VK_PRIOR]) and FList.Visible then
  begin
    // 将方向键传递给列表框，让它选择项目
    FList.Perform(Message.Msg,TMessage(Message).WParam,TMessage(Message).LParam);
  end else
    inherited;
end;

procedure TKSCustomFilterComboBox.WM_KeyUp(var Message: TWMKey);
begin
  if Message.CharCode in [VK_UP, VK_DOWN, VK_NEXT, VK_PRIOR] then
  begin
    FList.Perform(Message.Msg,TMessage(Message).WParam,TMessage(Message).LParam);
  end else
    inherited;
end;

function TKSCustomFilterComboBox.GetItemIndex: Integer;
begin
  Result := FList.ItemIndex;
end;

procedure TKSCustomFilterComboBox.SetItemIndex(const Value: Integer);
begin
  FList.ItemIndex := Value;
end;

function TKSCustomFilterComboBox.GetListFont: TFont;
begin
  Result := FList.Font;
end;

procedure TKSCustomFilterComboBox.SetListFont(const Value: TFont);
begin
  FList.Font := Value;
end;

procedure TKSCustomFilterComboBox.KeyPress(var Key: Char);
begin
  inherited;
  // Enter #13, Ctrl + Enter #10
  if (Key=#13) or (Key=#10)  then
    Key:=#0;
end;

{ TKSPopupList }

constructor TKSPopupList.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
  TabStop := False;
end;

procedure TKSPopupList.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := (Params.ExStyle and not WS_EX_APPWINDOW) or WS_EX_TOOLWINDOW	;
end;

procedure TKSPopupList.CreateWnd;
begin
  inherited CreateWnd;
  if not (csDesigning in ComponentState) then
    Windows.SetParent(Handle, 0);
  CallWindowProc(DefWndProc, Handle, WM_SETFOCUS, 0, 0);
end;

procedure TKSPopupList.WMLButtonUp(var Message: TWMLButtonUp);
begin
  // 仅在鼠标点击的时候触发选择操作。不应该重载Click方法，因为Click方法无法区分键盘事件和鼠标。
  inherited;
  DoSelected;
end;

procedure TKSPopupList.DoSelected;
begin
  OutputDebugString('Selected');
  FCombo.ListSelected;
end;

{ TKSFilterComboBox }


end.
