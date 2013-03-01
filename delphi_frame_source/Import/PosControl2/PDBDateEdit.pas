unit PDBDateEdit;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  stdctrls, dbtables, extctrls, RxCtrls, dbctrls, db, SelectDlg, PLabelPanel,
  LookupControls, PDBNormalDateEdit;

type
  TPDBDateEdit = class(TCustomControl)
  private
    FEdit: TPDBNormalDateEdit;
    FLabel: TRxLabel;
    FLabelStyle: TLabelStyle;
    FSpace: integer;
    function  GetCaptionWidth: integer;
    function  GetEditFont: TFont;
    procedure SetCaptionWidth(const Value: integer);
    procedure SetEditFont(const Value: TFont);
    procedure WMSetFocus(var Message:TMessage); message WM_SetFocus;
    procedure UpdateCtrlSizes;
    function  GetAlignment: TAlignment;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetSpace(const Value: integer);
  protected
    procedure   SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;

    function GetCaption: TCaption;
    function GetCheckResult: Boolean;
    function GetEditAutoSelect: Boolean;
    function GetEditClick: TNotifyEvent;
    function GetColor: TColor;
    function GetEditCtl3D: Boolean;
    function GetEditDblClick: TNotifyEvent;
    function GetEditEnter: TNotifyEvent;
    function GetEditHideSelection: Boolean;
    function GetEditKeyDown: TKeyEvent ;
    function GetEditKeyPress: TKeyPressEvent;
    function GetEditKeyUp: TKeyEvent;
    function GetEditMaxLength: Integer;
    function GetEditModified: Boolean;
    function GetEditMouseDown: TMouseEvent ;
    function GetEditMouseMove: TMouseMoveEvent;
    function GetEditMouseUp: TMouseEvent;
    function GetEditOnChange: TNotifyEvent;
    function GetReadonly: Boolean;
    function GetEditSelLength: Integer;
    function GetEditSelStart: Integer;
    function GetEditSelText: string;
    function GetEditShowHint: Boolean;
    function GetEditText: TCaption;
    //function GetEditWidth: integer;
    function GetExit: TNotifyEvent;
    //function GetFont: TFont;
    function GetLabelFont: TFont;
    function GetRdOnly: Boolean;
    function GetTabStop: Boolean;
    function GetText: string;

    //procedure Paint;override;
    procedure SetCaption(Value: TCaption);
    procedure SetCheckResult(Value: Boolean);
    procedure SetColor(Value: TColor);
    procedure SetEditAutoSelect(Value:Boolean);
    procedure SetEditClick(Value:TNotifyEvent);
    procedure SetEditCtl3D(Value:Boolean);
    procedure SetEditDblClick(Value:TNotifyEvent);
    procedure SetEditEnter(Value:TNotifyEvent);
    procedure SetExit(Value:TNotifyEvent);
    procedure SetEditHideSelection(Value:Boolean);
    procedure SetEditKeyDown(Value:TKeyEvent);
    procedure SetEditKeyPress(Value:TKeyPressEvent);
    procedure SetEditKeyUp(Value:TKeyEvent);
    procedure SetEditMouseDown(Value:TMouseEvent);
    procedure SetEditMouseMove(Value:TMouseMoveEvent);
    procedure SetEditMouseUp(Value:TMouseEvent);
    procedure SetEditMaxLength(Value:Integer);
    procedure SetEditModified(Value:Boolean);
    procedure SetEditOnChange(Value:TNotifyEvent);
    procedure SetEditShowHint(Value:Boolean);
    procedure SetEditSelLength(Value:Integer);
    procedure SetEditSelStart(Value:Integer);
    procedure SetEditSelText(Value:string);
    procedure SetEditText(Value:TCaption);
    //procedure SetEditWidth(Value: integer);
    //procedure SetFont(Value: TFont);
    procedure SetLabelFont(Value: TFont);
    procedure SetLabelStyle(Value: TLabelStyle);
    procedure SetRdOnly(Value: Boolean);
    procedure SetReadonly(Value: Boolean);
    procedure SetTabStop(Value: Boolean);
    procedure SetText(Value : string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;

    function EditCanFocus: Boolean;
    function EditFocused: Boolean;
    function EditGetSelTextBuf(Buffer: PChar; BufSize: Integer): Integer;
    function GetField : TField;
    function GetDataField : string;
    function GetDataSource : TDataSource;

    //procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure EditClear;
    procedure EditClearSelection;
    procedure EditCopyToClipboard;
    procedure EditCutToClipboard;
    procedure EditPasteFromClipboard;
    procedure EditSelectAll;
    procedure EditSetSelTextBuf(Buffer: PChar);
    procedure EditSetFocus;
    procedure SelectAll;
    procedure SetDataSource(Value: TDataSource);
    procedure SetDataField(Value : string);

    property EditModified: Boolean read GetEditModified write SetEditModified;
    property EditSelLength: Integer read GetEditSelLength write SetEditSelLength;
    property EditSelStart: Integer read GetEditSelStart write SetEditSelStart;
    property EditSelText: string read GetEditSelText write SetEditSelText;
  published
    property Caption:TCaption read GetCaption write SetCaption;
    property Color: TColor read GetColor write SetColor;
    property CheckResult : Boolean read GetCheckResult write SetCheckResult;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    //property EditWidth:integer read GetEditWidth write SetEditWidth;
    property CaptionWidth : integer read GetCaptionWidth Write SetCaptionWidth;
    property EditAutoSelect: Boolean read GetEditAutoSelect write SetEditAutoSelect;
    property EditHideSelection: Boolean read GetEditHideSelection write SetEditHideSelection;
    property EditMaxLength: Integer read GetEditMaxLength write SetEditMaxLength;
    property EditCtl3D:Boolean read GetEditCtl3D write SetEditCtl3D;
    property EditShowHint:Boolean read GetEditShowHint write SetEditShowHint;
    property EditText:TCaption read GetEditText write SetEditText;
    //property Font:TFont read GetFont write SetFont;
    property EditFont:TFont read GetEditFont write SetEditFont;
    property LabelFont: TFont read GetLabelFont write SetLabelFont;
    property LabelStyle: TLabelStyle read FLabelStyle write SetLabelStyle default Normal;
    property ParentColor;
    property ParentCtl3D;
    //property ParentFont;
    property ParentShowHint;
    property RdOnly: Boolean read GetRdOnly write SetRdOnly;
    property Readonly : Boolean read GetReadonly write SetReadonly;
    property Text: string read GetText write SetText;
    property TabOrder;
    property TabStop: Boolean read GetTabStop write SetTabStop;
    property Visible;

    property OnEditChange: TNotifyEvent read GetEditOnChange write SetEditOnChange;
    property OnEditClick:TNotifyEvent read GetEditClick write SetEditClick;
    property OnEditDblClick:TNotifyEvent read GetEditDblClick write SetEditDblClick;
    property OnEditEnter:TNotifyEvent read GetEditEnter write SetEditEnter;
    property OnExit:TNotifyEvent read GetExit write SetExit;
    property OnEditKeyDown:TKeyEvent read GetEditKeyDown write SetEditKeyDown;
    property OnEditKeyPress:TKeyPressEvent read GetEditKeyPress write SetEditKeyPress;
    property OnEditKeyUp:TKeyEvent read GetEditKeyUp write SetEditKeyUp;
    property OnEditMouseDown:TMouseEvent read GetEditMouseDown write SetEditMouseDown;
    property OnEditMouseMove:TMouseMoveEvent read GetEditMouseMove write SetEditMouseMove;
    property OnEditMouseUp:TMouseEvent read GetEditMouseUp write SetEditMouseUp;

    property  Alignment : TAlignment read GetAlignment write SetAlignment;
    property  Space : integer read FSpace write SetSpace default 0;
  end;

procedure Register;

implementation

constructor TPDBDateEdit.Create(AOwner: TComponent);
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

     LabelStyle := Normal;

     FEdit := TPDBNormalDateEdit.Create(Self);
     FEdit.Parent := Self;
     FEdit.Visible := True;
     FEdit.Font.Size := 9;
     FEdit.Font.Name := 'ËÎÌו';

     FLabel.FocusControl := FEdit;

     Height := 24;
     FLabel.Height := Height;
     FEdit.Height := Height;

     Width := 150;
     FEdit.Width := 100;
     FLabel.Width := Width-FEdit.Width;
     FEdit.Left := FLabel.Width;
     ParentFont := False;
end;

destructor TPDBDateEdit.Destroy ;
begin
     FEdit.Free;
     FLabel.Free;
     inherited Destroy;
end;

function TPDBDateEdit.GetRdOnly:Boolean;
begin
     Result := FEdit.ReadOnly;
end;

procedure TPDBDateEdit.SetRdOnly(Value: Boolean);
begin
     FEdit.ReadOnly := Value;
     if Value then
        FEdit.Color := clSilver
     else
         FEdit.Color := clWhite;
end;
{
function TPDBDateEdit.GetEditWidth:integer;
begin
     Result := FEdit.Width;
end;

procedure TPDBDateEdit.SetEditWidth(Value: integer);
begin
     FEdit.Width := Value;
     FEdit.Left := Width-Value;
     FLabel.Width := FEdit.Left;
end;
}
function TPDBDateEdit.GetLabelFont: TFont;
begin
     Result := FLabel.Font ;
end;

procedure TPDBDateEdit.SetLabelFont(Value: TFont);
begin
     FLabel.Font := Value;
end;
{
function TPDBDateEdit.GetFont: TFont;
begin
     Result := FEdit.Font;
end;

procedure TPDBDateEdit.SetFont(Value: TFont);
begin
     FEdit.Font := Value;
     FLabel.Font := Value;
     FLabel.Height := FEdit.Height;
     Height := FEdit.Height;
     SetLabelStyle(LabelStyle);
end;
}
function TPDBDateEdit.GetCaption:TCaption;
begin
     Result := FLabel.Caption;
end;

procedure TPDBDateEdit.SetCaption(Value: TCaption);
begin
     FLabel.Caption := Value;
end;

procedure TPDBDateEdit.SetLabelStyle (Value: TLabelStyle);
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
{
procedure TPDBDateEdit.Paint;
begin
     FLabel.Height := Height;
     FEdit.Height := Height;
     FLabel.Width := Width-FEdit.Width;
     FEdit.Left := FLabel.Width;
     inherited Paint;
end;
}
function TPDBDateEdit.GetEditModified:Boolean;
begin
     Result := FEdit.Modified;
end;

procedure TPDBDateEdit.SetEditModified(Value:Boolean);
begin
     FEdit.Modified:= Value;
end;

function TPDBDateEdit.GetEditSelLength:Integer;
begin
     Result := FEdit.SelLength;
end;

procedure TPDBDateEdit.SetEditSelLength(Value:Integer);
begin
     FEdit.SelLength:= Value;
end;

procedure TPDBDateEdit.SelectAll;
begin
     FEdit.selectall;
end;

function TPDBDateEdit.GetEditSelStart:Integer;
begin
     Result := FEdit.SelStart;
end;

procedure TPDBDateEdit.SetEditSelStart(Value:Integer);
begin
     FEdit.SelStart:= Value;
end;

function TPDBDateEdit.GetEditSelText:string;
begin
     Result := FEdit.SelText;
end;

procedure TPDBDateEdit.SetEditSelText(Value:string);
begin
     FEdit.SelText:= Value;
end;

function TPDBDateEdit.GetEditAutoSelect:Boolean;
begin
     Result := FEdit.AutoSelect;
end;

procedure TPDBDateEdit.SetEditAutoSelect(Value:Boolean);
begin
     FEdit.AutoSelect:= Value;
end;

function TPDBDateEdit.GetEditHideSelection:Boolean;
begin
     Result := FEdit.HideSelection;
end;

procedure TPDBDateEdit.SetEditHideSelection(Value:Boolean);
begin
     FEdit.HideSelection:= Value;
end;

function TPDBDateEdit.GetEditMaxLength:Integer;
begin
     Result := FEdit.MaxLength;
end;

procedure TPDBDateEdit.SetEditMaxLength(Value:Integer);
begin
     FEdit.MaxLength:= Value;
end;

function TPDBDateEdit.GetEditCtl3D:Boolean;
begin
     Result := FEdit.Ctl3D;
end;

procedure TPDBDateEdit.SetEditCtl3D(Value:Boolean);
begin
     FEdit.Ctl3D:= Value;
end;

function TPDBDateEdit.GetEditShowHint:Boolean;
begin
     Result := FEdit.ShowHint;
end;

procedure TPDBDateEdit.SetEditShowHint(Value:Boolean);
begin
     FEdit.ShowHint:= Value;
end;


function TPDBDateEdit.GetEditText:TCaption;
begin
     Result := FEdit.Text;
end;

procedure TPDBDateEdit.SetEditText(Value:TCaption);
begin
     FEdit.Text:= Value;
end;

function TPDBDateEdit.GetEditOnChange:TNotifyEvent;
begin
     Result := FEdit.OnChange;
end;

procedure TPDBDateEdit.SetEditOnChange(Value:TNotifyEvent);
begin
     FEdit.OnChange:= Value;
end;

function TPDBDateEdit.GetEditClick:TNotifyEvent;
begin
     Result := FEdit.OnClick;
end;

procedure TPDBDateEdit.SetEditClick(Value:TNotifyEvent);
begin
     FEdit.OnClick:= Value;
end;

function TPDBDateEdit.GetEditDblClick:TNotifyEvent;
begin
     Result := FEdit.OnDblClick;
end;

procedure TPDBDateEdit.SetEditDblClick(Value:TNotifyEvent);
begin
     FEdit.OnDblClick:= Value;
end;

function TPDBDateEdit.GetEditEnter:TNotifyEvent;
begin
     Result := FEdit.OnEnter;
end;

procedure TPDBDateEdit.SetEditEnter(Value:TNotifyEvent);
begin
     FEdit.OnEnter:= Value;
end;

function TPDBDateEdit.GetExit:TNotifyEvent;
begin
     Result := FEdit.OnExit;
end;

procedure TPDBDateEdit.SetExit(Value:TNotifyEvent);
begin
     FEdit.OnExit:= Value;
end;

function TPDBDateEdit.GetEditKeyDown:TKeyEvent ;
begin
     Result := FEdit.OnKeyDown;
end;

procedure TPDBDateEdit.SetEditKeyDown(Value:TKeyEvent);
begin
     FEdit.OnKeyDown:= Value;
end;

function TPDBDateEdit.GetEditKeyPress:TKeyPressEvent;
begin
     Result := FEdit.OnKeyPress;
end;

procedure TPDBDateEdit.SetEditKeyPress(Value:TKeyPressEvent);
begin
     FEdit.OnKeyPress:= Value;
end;

function TPDBDateEdit.GetEditKeyUp:TKeyEvent;
begin
     Result := FEdit.OnKeyUp;
end;

procedure TPDBDateEdit.SetEditKeyUp(Value:TKeyEvent);
begin
     FEdit.OnKeyUp:= Value;
end;

function TPDBDateEdit.GetEditMouseDown:TMouseEvent ;
begin
     Result := FEdit.OnMouseDown;
end;

procedure TPDBDateEdit.SetEditMouseDown(Value:TMouseEvent);
begin
     FEdit.OnMouseDown:= Value;
end;

function TPDBDateEdit.GetEditMouseMove:TMouseMoveEvent;
begin
     Result := FEdit.OnMouseMove;
end;

procedure TPDBDateEdit.SetEditMouseMove(Value:TMouseMoveEvent);
begin
     FEdit.OnMouseMove:= Value;
end;

function TPDBDateEdit.GetEditMouseUp:TMouseEvent;
begin
     Result := FEdit.OnMouseUp;
end;

procedure TPDBDateEdit.SetEditMouseUp(Value:TMouseEvent);
begin
     FEdit.OnMouseUp:= Value;
end;

procedure TPDBDateEdit.EditClear;
begin
     FEdit.Clear;
end;

procedure TPDBDateEdit.EditClearSelection;
begin
     FEdit.ClearSelection;
end;

procedure TPDBDateEdit.EditCopyToClipboard;
begin
     FEdit.CopyToClipboard;
end;

procedure TPDBDateEdit.EditCutToClipboard;
begin
     FEdit.CutToClipboard;
end;

procedure TPDBDateEdit.EditPasteFromClipboard;
begin
     FEdit.PasteFromClipboard;
end;

function TPDBDateEdit.EditGetSelTextBuf(Buffer: PChar; BufSize: Integer): Integer;
begin
     Result := FEdit.GetSelTextBuf(Buffer,BufSize)
end;

procedure TPDBDateEdit.EditSelectAll;
begin
     FEdit.SelectAll;
end;

procedure TPDBDateEdit.EditSetSelTextBuf(Buffer: PChar);
begin
     FEdit.SetSelTextBuf(Buffer);
end;

function TPDBDateEdit.EditCanFocus: Boolean;
begin
     Result := FEdit.CanFocus;
end;

function TPDBDateEdit.EditFocused: Boolean;
begin
     Result := FEdit.Focused;
end;

procedure TPDBDateEdit.EditSetFocus;
begin
     FEdit.SetFocus;
end;

procedure TPDBDateEdit.SetDataSource(Value: TDataSource);
begin
     FEdit.DataSource := Value;
end;

function TPDBDateEdit.GetDataSource : TDataSource;
begin
     Result := FEdit.DataSource;
end;

procedure TPDBDateEdit.SetDataField(Value : string);
begin
     FEdit.DataField := Value;
end;

function TPDBDateEdit.GetDataField : string;
begin
     Result := FEdit.DataField;
end;

function TPDBDateEdit.GetField : TField;
begin
     Result := FEdit.Field;
end;

procedure TPDBDateEdit.SetCheckResult(Value: Boolean);
begin
     FEdit.CheckResult := Value;
end;

function TPDBDateEdit.GetCheckResult:Boolean;
begin
     Result := FEdit.CheckResult
end;

procedure TPDBDateEdit.SetText(Value: string);
begin
     if FEdit.Text <> Value then
        FEdit.Text := Text;
end;

function TPDBDateEdit.GetText ;
begin
     Result := FEdit.Text;
end;
{
procedure TPDBDateEdit.CMFocusChanged(var Message: TCMFocusChanged);
begin
    if Message.Sender.name = self.Name  then
      FEdit.SetFocus ;
end;
}

procedure TPDBDateEdit.SetColor(Value: TColor);
begin
     FEdit.Color := Value;
end;

function TPDBDateEdit.GetColor: TColor;
begin
     Result := FEdit.Color;
end;

procedure TPDBDateEdit.SetTabStop(Value: Boolean);
begin
     FEdit.TabStop := Value;
end;

function TPDBDateEdit.GetTabStop: Boolean;
begin
     Result := FEdit.TabStop ;
end;

procedure TPDBDateEdit.SetReadonly(Value: Boolean);
begin
     FEdit.ReadOnly := Value;
end;

function TPDBDateEdit.GetReadonly: Boolean;
begin
     Result := FEdit.ReadOnly;
end;

procedure Register;
begin
     RegisterComponents('PosControl2', [TPDBDateEdit]);
end;

function TPDBDateEdit.GetCaptionWidth: integer;
begin
  result := FLabel.Width;
end;

function TPDBDateEdit.GetEditFont: TFont;
begin
  result := FEdit.Font;
end;

procedure TPDBDateEdit.SetCaptionWidth(const Value: integer);
begin
  FLabel.Width:=value;
  UpdateCtrlSizes;
end;

procedure TPDBDateEdit.SetEditFont(const Value: TFont);
begin
  FEdit.Font:=value;
end;

procedure TPDBDateEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  UpdateCtrlSizes;
end;

procedure TPDBDateEdit.UpdateCtrlSizes;
begin
  FLabel.Height:=height;
  FEdit.Height:=height;
  FEdit.left:=FLabel.width+FSpace;
  FEdit.width:=width-FLabel.width-FSpace;
end;

procedure TPDBDateEdit.WMSetFocus(var Message: TMessage);
begin
  inherited;
  if FEdit.CanFocus then FEdit.SetFocus;
end;

function TPDBDateEdit.GetAlignment: TAlignment;
begin
  result := FLabel.Alignment;
end;

procedure TPDBDateEdit.SetAlignment(const Value: TAlignment);
begin
  FLabel.Alignment := value;
end;

procedure TPDBDateEdit.SetSpace(const Value: integer);
begin
  if (FSpace<>Value) and (Value>=0) then
  begin
    FSpace := Value;
    UpdateCtrlSizes;
  end;
end;

end.
