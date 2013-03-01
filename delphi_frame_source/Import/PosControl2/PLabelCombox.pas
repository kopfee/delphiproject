unit PLabelCombox;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  stdctrls, dbtables, extctrls, RxCtrls, dbctrls, db, SelectDlg, PLabelPanel,
  LookupControls;

type
  TPLabelCombox = class(TCustomControl)
  private
    FComboBox: TComboBox;
    FLabel: TRxLabel;
    FLabelStyle: TLabelStyle;
    FParentFont: Boolean;
  protected
    function GetCaption:TCaption;
    function GetComboBoxWidth:integer;
    function GetComboClick:TNotifyEvent;
    function GetComboCtl3D:Boolean;
    function GetComboDblClick:TNotifyEvent;
    function GetComboDrawItem: TDrawItemEvent;
    function GetComboDropDown: TNotifyEvent;
    function GetComboDropDownCount:Integer;
    function GetComboDroppedDown: Boolean;
    function GetComboExit:TNotifyEvent;
    function GetComboEnter:TNotifyEvent;
    function GetComboItemHeight:Integer;
    function GetComboItemIndex: Integer;
    function GetComboItems:TStrings;
    function GetComboKeyDown:TKeyEvent ;
    function GetComboKeyPress:TKeyPressEvent;
    function GetComboKeyUp:TKeyEvent;
    function GetComboMaxLength:Integer;
    function GetComboMeasureItem: TMeasureItemEvent;
    function GetComboOnChange:TNotifyEvent;
    function GetComboSelLength: Integer;
    function GetComboSelStart: Integer;
    function GetComboSelText: string;
    function GetComboShowHint:Boolean;
    function GetComboSorted:Boolean;
    function GetComboStyle:TComboBoxStyle;
    function GetComboTabOrder:TTabOrder;
    function GetComboTabStop:Boolean;
    function GetComboText:TCaption;
    function GetFont:TFont;
    function GetLabelFont: TFont;
    procedure Paint;override;
    procedure SetCaption(Value: TCaption);
    procedure SetComboBoxWidth(Value: integer);
    procedure SetComboClick(Value:TNotifyEvent);
    procedure SetComboCtl3D(Value:Boolean);
    procedure SetComboDblClick(Value:TNotifyEvent);
    procedure SetComboDrawItem(Value:TDrawItemEvent);
    procedure SetComboDropDownCount(Value:Integer);
    procedure SetComboDroppedDown(Value:Boolean);
    procedure SetComboEnter(Value:TNotifyEvent);
    procedure SetComboExit(Value:TNotifyEvent);
    procedure SetComboItemHeight(Value:Integer);
    procedure SetComboItemIndex(Value:Integer);
    procedure SetComboItems(Value:TStrings);
    procedure SetComboKeyDown(Value:TKeyEvent);
    procedure SetComboKeyPress(Value:TKeyPressEvent);
    procedure SetComboKeyUp(Value:TKeyEvent);
    procedure SetComboMaxLength(Value:Integer);
    procedure SetComboMeasureItem(Value:TMeasureItemEvent);
    procedure SetComboOnChange(Value:TNotifyEvent);
    procedure SetComboOnDropDown(Value:TNotifyEvent);
    procedure SetComboSelLength(Value:Integer);
    procedure SetComboSelStart(Value:Integer);
    procedure SetComboSelText(Value:string);
    procedure SetComboShowHint(Value:Boolean);
    procedure SetComboSorted(Value:Boolean);
    procedure SetComboStyle(Value:TComboBoxStyle);
    procedure SetComboTabOrder(Value:TTabOrder);
    procedure SetComboTabStop(Value:Boolean);
    procedure SetComboText(Value:TCaption);
    procedure SetLabelFont(Value: TFont);
    procedure SetLabelStyle(Value: TLabelStyle);
    procedure SetParentFont(Value: Boolean);
    procedure SetFont(Value: TFont);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    function ComboCanFocus: Boolean;
    function ComboFocused: Boolean;
    procedure ComboClear;
    procedure ComboSelectAll;
    procedure ComboSetFocus;

    property ComboDroppedDown: Boolean read GetComboDroppedDown write SetComboDroppedDown;
    property ComboItemIndex: Integer read GetComboItemIndex write SetComboItemIndex;
    property ComboSelLength: Integer read GetComboSelLength write SetComboSelLength;
    property ComboSelStart: Integer read GetComboSelStart write SetComboSelStart;
    property ComboSelText: string read GetComboSelText write SetComboSelText;
  published
    property Caption:TCaption read GetCaption write SetCaption;
    property ComboBoxWidth:integer read GetComboBoxWidth write SetComboBoxWidth;
    property ComboCtl3D:Boolean read GetComboCtl3D write SetComboCtl3D;
    property ComboDropDownCount:Integer read GetComboDropDownCount write SetComboDropDownCount;
    property ComboItems:TStrings read GetComboItems write SetComboItems;
    property ComboItemHeight:Integer read GetComboItemHeight write SetComboItemHeight;
    property ComboMaxLength:Integer read GetComboMaxLength write SetComboMaxLength;
    property ComboShowHint:Boolean read GetComboShowHint write SetComboShowHint;
    property ComboSorted:Boolean read GetComboSorted write SetComboSorted;
    property ComboStyle:TComboBoxStyle read GetComboStyle write SetComboStyle;
    property LabelStyle: TLabelStyle read FLabelStyle write SetLabelStyle default Normal;
    property ComboTabOrder:TTabOrder read GetComboTabOrder write SetComboTabOrder;
    property ComboTabStop:Boolean read GetComboTabStop write SetComboTabStop;
    property ComboText:TCaption read GetComboText write SetComboText;
    property Enabled;
    property Font:TFont read GetFont write SetFont;
    property LabelFont: TFont read GetLabelFont write SetLabelFont;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont : Boolean read FParentFont write SetParentFont;
    property ParentShowHint;
    property TabOrder;
    property Visible;

    property OnComboChange: TNotifyEvent read GetComboOnChange write SetComboOnChange;
    property OnComboClick:TNotifyEvent read GetComboClick write SetComboClick;
    property OnComboDblClick:TNotifyEvent read GetComboDblClick write SetComboDblClick;
    property OnComboEnter:TNotifyEvent read GetComboEnter write SetComboEnter;
    property OnComboExit:TNotifyEvent read GetComboExit write SetComboExit;
    property OnComboKeyDown:TKeyEvent read GetComboKeyDown write SetComboKeyDown;
    property OnComboKeyPress:TKeyPressEvent read GetComboKeyPress write SetComboKeyPress;
    property OnComboKeyUp:TKeyEvent read GetComboKeyUp write SetComboKeyUp;
    property OnComboDropDown: TNotifyEvent read GetComboDropDown write SetComboOnDropDown;
    property OnComboDrawItem: TDrawItemEvent read GetComboDrawItem write SetComboDrawItem;
    property OnComboMeasureItem: TMeasureItemEvent read GetComboMeasureItem write SetComboMeasureItem;
  end;

procedure Register;

implementation

constructor TPLabelCombox.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);

     FLabel := TRxLabel.Create(Self);
     FLabel.Parent := Self;
     FLabel.ShadowSize := 0;
     FLabel.Layout := tlCenter;
     FLabel.AutoSize := False;
     FLabel.Visible := True;
     FLabel.Font.Size := 11;
     FLabel.Font.Name := 'ËÎÌו';
     FLabel.ParentFont := False;

     LabelStyle := Normal;

     FComboBox := TComboBox.Create(Self);
     FComboBox.Parent := Self;
     FComboBox.Visible := True;
     FComboBox.Font.Size := 9;
     FComboBox.Font.Name := 'ËÎÌו';
     FComboBox.ParentFont := False;

     FLabel.FocusControl := FComboBox;

     FLabel.Height := FComboBox.Height;
     Height := FComboBox.Height;

     FLabel.Width := 60;
     FComboBox.Width :=120;
     FComboBox.Left:=60;
     Width := FLabel.Width+FComboBox.Width;
     ParentFont := False;
end;

function TPLabelCombox.GetLabelFont: TFont;
begin
     Result := FLabel.Font;
end;

procedure TPLabelCombox.SetLabelFont(Value: TFont);
begin
     FLabel.Font := Value;
end;

procedure TPLabelCombox.SetParentFont(Value: Boolean);
begin
     inherited;
     FComboBox.ParentFont := Value;
     Flabel.ParentFont := Value;
     FParentFont := Value;
end;

destructor TPLabelCombox.Destroy ;
begin
     FComboBox.Free;
     FLabel.Free;
     inherited Destroy;
end;

function TPLabelCombox.GetComboBoxWidth:integer;
begin
     Result := FComboBox.Width;
end;

procedure TPLabelCombox.SetComboBoxWidth(Value: integer);
begin
     FComboBox.Width := Value;
     FComboBox.Left := Width-Value;
     FLabel.Width := FComboBox.Left;
end;

function TPLabelCombox.GetFont:TFont;
begin
     Result := FComboBox.Font;
end;

procedure TPLabelCombox.SetFont(Value: TFont);
begin
     FComboBox.Font.Assign(Value);
     FLabel.Font.Assign(Value);
     FLabel.Height := FComboBox.Height;
     Height := FComboBox.Height;
     SetLabelStyle(LabelStyle);
end;

function TPLabelCombox.GetCaption:TCaption;
begin
     Result := FLabel.Caption;
end;

procedure TPLabelCombox.SetCaption(Value: TCaption);
begin
     FLabel.Caption := Value;
end;

procedure TPLabelCombox.SetLabelStyle (Value: TLabelStyle);
begin
     FLabelStyle := Value;
     case Value of
     Normal: begin
             FLabel.Font.Color := clBlack;
             FLabel.Font.Style := [];
           end;
     Notnil: begin
             FLabel.Font.Color := clTeal;
             FLabel.Font.Style := [];
           end;
     Conditional: begin
             FLabel.Font.Color := clBlack;
             FLabel.Font.Style := [fsUnderline];
           end;
     NotnilAndConditional: begin
             FLabel.Font.Color := clTeal;
             FLabel.Font.Style := [fsUnderline];
           end;
     end;
end;

procedure TPLabelCombox.Paint;
begin
     inherited Paint;
     FLabel.Height := FComboBox.Height;
     Height := FComboBox.Height;
     FComboBox.Left := Width-FComboBox.Width;
     FLabel.Width := FComboBox.Left;
end;

function TPLabelCombox.GetComboDroppedDown: Boolean;
begin
     Result := FCombobox.DroppedDown ;
end;

procedure TPLabelCombox.SetComboDroppedDown(Value:Boolean);
begin
     FCombobox.DroppedDown := Value;
end;

function TPLabelCombox.GetComboItemIndex: Integer;
begin
     Result := FComboBox.ItemIndex ;
end;

procedure TPLabelCombox.SetComboItemIndex(Value:Integer);
begin
     FComboBox.ItemIndex := Value;
end;

function TPLabelCombox.GetComboSelLength: Integer;
begin
     Result := FComboBox.SelLength ;
end;

procedure TPLabelCombox.SetComboSelLength(Value:Integer);
begin
     FComboBox.SelLength := Value;
end;

function TPLabelCombox.GetComboSelStart: Integer;
begin
     Result := FComboBox.SelStart ;
end;

procedure TPLabelCombox.SetComboSelStart(Value:Integer);
begin
     FComboBox.SelStart := Value;
end;

function TPLabelCombox.GetComboSelText: string;
begin
     Result := FComboBox.SelText ;
end;

procedure TPLabelCombox.SetComboSelText(Value:string);
begin
     FComboBox.SelText := Value;
end;

function TPLabelCombox.GetComboStyle:TComboBoxStyle;
begin
     Result := FComboBox.Style
end;

procedure TPLabelCombox.SetComboStyle(Value:TComboBoxStyle);
begin
     FComboBox.Style := Value;
end;

function TPLabelCombox.GetComboCtl3D:Boolean;
begin
     Result := FComboBox.Ctl3D
end;

procedure TPLabelCombox.SetComboCtl3D(Value:Boolean);
begin
     FComboBox.Ctl3D := Value;
end;

function TPLabelCombox.GetComboDropDownCount:Integer;
begin
     Result := FComboBox.DropDownCount
end;

procedure TPLabelCombox.SetComboDropDownCount(Value:Integer);
begin
     FComboBox.DropDownCount := Value;
end;

function TPLabelCombox.GetComboItemHeight:Integer;
begin
     Result := FComboBox.ItemHeight
end;

procedure TPLabelCombox.SetComboItemHeight(Value:Integer);
begin
     FComboBox.ItemHeight := Value;
end;

function TPLabelCombox.GetComboItems:TStrings;
begin
     Result := FComboBox.Items
end;

procedure TPLabelCombox.SetComboItems(Value:TStrings);
begin
     FComboBox.Items := Value;
end;

function TPLabelCombox.GetComboMaxLength:Integer;
begin
     Result := FComboBox.MaxLength
end;

procedure TPLabelCombox.SetComboMaxLength(Value:Integer);
begin
     FComboBox.MaxLength := Value;
end;

function TPLabelCombox.GetComboShowHint:Boolean;
begin
     Result := FComboBox.ShowHint
end;

procedure TPLabelCombox.SetComboShowHint(Value:Boolean);
begin
     FComboBox.ShowHint := Value;
end;

function TPLabelCombox.GetComboSorted:Boolean;
begin
     Result := FComboBox.Sorted
end;

procedure TPLabelCombox.SetComboSorted(Value:Boolean);
begin
     FComboBox.Sorted := Value;
end;

function TPLabelCombox.GetComboTabOrder:TTabOrder;
begin
     Result := FComboBox.TabOrder
end;

procedure TPLabelCombox.SetComboTabOrder(Value:TTabOrder);
begin
     FComboBox.TabOrder := Value;
end;

function TPLabelCombox.GetComboTabStop:Boolean;
begin
     Result := FComboBox.TabStop
end;

procedure TPLabelCombox.SetComboTabStop(Value:Boolean);
begin
     FComboBox.TabStop := Value;
end;

function TPLabelCombox.GetComboText:TCaption;
begin
     Result := FComboBox.Text
end;

procedure TPLabelCombox.SetComboText(Value:TCaption);
begin
     FComboBox.Text := Value;
end;

function TPLabelCombox.GetComboOnChange:TNotifyEvent;
begin
     Result := FComboBox.OnChange;
end;

procedure TPLabelCombox.SetComboOnChange(Value:TNotifyEvent);
begin
     FComboBox.OnChange:= Value;
end;

function TPLabelCombox.GetComboClick:TNotifyEvent;
begin
     Result := FComboBox.OnClick;
end;

procedure TPLabelCombox.SetComboClick(Value:TNotifyEvent);
begin
     FComboBox.OnClick:= Value;
end;

function TPLabelCombox.GetComboDblClick:TNotifyEvent;
begin
     Result := FComboBox.OnDblClick;
end;

procedure TPLabelCombox.SetComboDblClick(Value:TNotifyEvent);
begin
     FComboBox.OnDblClick:= Value;
end;

function TPLabelCombox.GetComboEnter:TNotifyEvent;
begin
     Result := FComboBox.OnEnter;
end;

procedure TPLabelCombox.SetComboEnter(Value:TNotifyEvent);
begin
     FComboBox.OnEnter:= Value;
end;

function TPLabelCombox.GetComboExit:TNotifyEvent;
begin
     Result := FComboBox.OnExit;
end;

procedure TPLabelCombox.SetComboExit(Value:TNotifyEvent);
begin
     FComboBox.OnExit:= Value;
end;

function TPLabelCombox.GetComboKeyDown:TKeyEvent ;
begin
     Result := FComboBox.OnKeyDown;
end;

procedure TPLabelCombox.SetComboKeyDown(Value:TKeyEvent);
begin
     FComboBox.OnKeyDown:= Value;
end;

function TPLabelCombox.GetComboKeyPress:TKeyPressEvent;
begin
     Result := FComboBox.OnKeyPress;
end;

procedure TPLabelCombox.SetComboKeyPress(Value:TKeyPressEvent);
begin
     FComboBox.OnKeyPress:= Value;
end;

function TPLabelCombox.GetComboKeyUp:TKeyEvent;
begin
     Result := FComboBox.OnKeyUp;
end;

procedure TPLabelCombox.SetComboKeyUp(Value:TKeyEvent);
begin
     FComboBox.OnKeyUp:= Value;
end;

function TPLabelCombox.GetComboDropDown: TNotifyEvent;
begin
     Result := FComboBox.OnDropDown;
end;

procedure TPLabelCombox.SetComboOnDropDown(Value:TNotifyEvent);
begin
     FComboBox.OnDropDown := Value;
end;

function TPLabelCombox.GetComboDrawItem: TDrawItemEvent;
begin
     Result := FComboBox.OnDrawItem;
end;

procedure TPLabelCombox.SetComboDrawItem(Value:TDrawItemEvent);
begin
     FComboBox.OnDrawItem := Value;
end;

function TPLabelCombox.GetComboMeasureItem: TMeasureItemEvent;
begin
     Result := FComboBox.OnMeasureItem;
end;

procedure TPLabelCombox.SetComboMeasureItem(Value:TMeasureItemEvent);
begin
     FComboBox.OnMeasureItem := Value;
end;

procedure TPLabelCombox.ComboClear;
begin
     FComboBox.Clear;
end;

procedure TPLabelCombox.ComboSelectAll;
begin
     FComboBox.SelectAll;
end;

function TPLabelCombox.ComboCanFocus: Boolean;
begin
     Result := FComboBox.CanFocus;
end;

function TPLabelCombox.ComboFocused: Boolean;
begin
     Result := FComboBox.Focused;
end;

procedure TPLabelCombox.ComboSetFocus;
begin
     FComboBox.SetFocus;
end;


procedure Register;
begin
     RegisterComponents('PosControl', [TPLabelCombox]);
end;

end.

