unit PLabelMaskEdit;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  stdctrls, dbtables, extctrls, RxCtrls, dbctrls, db, SelectDlg, PLabelPanel,
  LookupControls, Mask;

type
  TPLabelMaskEdit = class(TCustomControl)
  private
    FEdit: TMaskEdit;
    FLabel: TRxLabel;
    FLabelStyle: TLabelStyle;
    FParentFont: Boolean;


  protected
    function GetCaption:TCaption;
    function GetEditAutoSelect:Boolean;
    function GetEditBorderStyle:TBorderStyle;
    function GetEditCharCase:TEditCharCase;
    function GetEditClick:TNotifyEvent;
    function GetEditCtl3D:Boolean;
    function GetEditDblClick:TNotifyEvent;
    function GetEditEditText: string;
    function GetEditEnter:TNotifyEvent;
    function GetEditExit:TNotifyEvent;
    function GetEditKeyDown:TKeyEvent ;
    function GetEditKeyPress:TKeyPressEvent;
    function GetEditKeyUp:TKeyEvent;
    function GetEditEditMask: string;
    function GetEditMasked: Boolean;
    function GetEditMaxLength:Integer;
    function GetEditModified:Boolean;
    function GetEditMouseDown:TMouseEvent ;
    function GetEditMouseMove:TMouseMoveEvent;
    function GetEditMouseUp:TMouseEvent;
    function GetEditOnChange:TNotifyEvent;
    function GetEditPasswordChar:Char;
    function GetEditSelLength:Integer;
    function GetEditSelStart:Integer;
    function GetEditSelText:string;
    function GetEditShowHint:Boolean;
    function GetEditTabOrder:TTabOrder;
    function GetEditTabStop:Boolean;
    function GetEditText:TCaption;
    function GetEditWidth:integer;
    function GetFont:TFont;
    function GetLabelFont: TFont;
    function GetRdOnly:Boolean;
    procedure Paint;override;
    procedure SetCaption(Value: TCaption);
    procedure SetEditAutoSelect(Value:Boolean);
    procedure SetEditBorderStyle(Value:TBorderStyle);
    procedure SetEditCharCase(Value:TEditCharCase);
    procedure SetEditClick(Value:TNotifyEvent);
    procedure SetEditCtl3D(Value:Boolean);
    procedure SetEditDblClick(Value:TNotifyEvent);
    procedure SetEditEditText(Value: string);
    procedure SetEditEnter(Value:TNotifyEvent);
    procedure SetEditExit(Value:TNotifyEvent);
    procedure SetEditKeyDown(Value:TKeyEvent);
    procedure SetEditKeyPress(Value:TKeyPressEvent);
    procedure SetEditKeyUp(Value:TKeyEvent);
    procedure SetEditEditMask(Value : string);
    procedure SetEditMaxLength(Value:Integer);
    procedure SetEditModified(Value:Boolean);
    procedure SetEditMouseDown(Value:TMouseEvent);
    procedure SetEditMouseMove(Value:TMouseMoveEvent);
    procedure SetEditMouseUp(Value:TMouseEvent);
    procedure SetEditOnChange(Value:TNotifyEvent);
    procedure SetParentFont(Value: Boolean);
    procedure SetEditPasswordChar(Value:Char);
    procedure SetEditSelLength(Value:Integer);
    procedure SetEditSelStart(Value:Integer);
    procedure SetEditSelText(Value:string);
    procedure SetEditShowHint(Value:Boolean);
    procedure SetEditTabOrder(Value: TTabOrder);
    procedure SetEditTabStop(Value:Boolean);
    procedure SetEditText(Value:TCaption);
    procedure SetEditWidth(Value: integer);
    procedure SetLabelFont(Value: TFont);
    procedure SetFont(Value: TFont);
    procedure SetLabelStyle(Value: TLabelStyle);
    procedure SetRdOnly(Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;

    function EditCanFocus: Boolean;
    function EditFocused: Boolean;
    function EditGetTextLen: Integer;
    function EditGetSelTextBuf(Buffer: PChar; BufSize: Integer): Integer;
    procedure EditCopyToClipboard;
    procedure EditClear;
    procedure EditClearSelection;
    procedure EditCutToClipboard;
    procedure EditSelectAll;
    procedure EditSetFocus;
    procedure EditSetSelTextBuf(Buffer: PChar);
    procedure EditPasteFromClipboard;
    procedure EditValidateEdit;

    property EditEditText: string read GetEditEditText write SetEditEditText;
    property EditIsMasked: Boolean read GetEditMasked;
    property EditModified: Boolean read GetEditModified write SetEditModified;
    property EditSelLength: Integer read GetEditSelLength write SetEditSelLength;
    property EditSelStart: Integer read GetEditSelStart write SetEditSelStart;
    property EditSelText: string read GetEditSelText write SetEditSelText;
  published
    property Caption:TCaption read GetCaption write SetCaption;
    property EditAutoSelect: Boolean read GetEditAutoSelect write SetEditAutoSelect;
    property EditBorderStyle: TBorderStyle read GetEditBorderStyle write SetEditBorderStyle;
    property EditCharCase: TEditCharCase read GetEditCharCase write SetEditCharCase;
    property EditCtl3D:Boolean read GetEditCtl3D write SetEditCtl3D;
    property EditEditMask: string read GetEditEditMask write SetEditEditMask;
    property EditMaxLength: Integer read GetEditMaxLength write SetEditMaxLength;
    property EditPasswordChar: Char read GetEditPasswordChar write SetEditPasswordChar;
    property EditShowHint:Boolean read GetEditShowHint write SetEditShowHint;
    property EditTabOrder:TTabOrder read GetEditTabOrder write SetEditTabOrder;
    property EditTabStop:Boolean read GetEditTabStop write SetEditTabStop;
    property EditText:TCaption read GetEditText write SetEditText;
    property EditWidth:integer read GetEditWidth write SetEditWidth;
    property Enabled;
    property Font:TFont read GetFont write SetFont;
    property LabelStyle: TLabelStyle read FLabelStyle write SetLabelStyle default Normal;
    property LabelFont: TFont read GetLabelFont write SetLabelFont;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont : Boolean read FParentFont write SetParentFont;
    property ParentShowHint;
    property RdOnly: Boolean read GetRdOnly write SetRdOnly;
    property Visible;

    property OnEditChange: TNotifyEvent read GetEditOnChange write SetEditOnChange;
    property OnEditClick:TNotifyEvent read GetEditClick write SetEditClick;
    property OnEditDblClick:TNotifyEvent read GetEditDblClick write SetEditDblClick;
    property OnEditEnter:TNotifyEvent read GetEditEnter write SetEditEnter;
    property OnEditExit:TNotifyEvent read GetEditExit write SetEditExit;
    property OnEditKeyDown:TKeyEvent read GetEditKeyDown write SetEditKeyDown;
    property OnEditKeyPress:TKeyPressEvent read GetEditKeyPress write SetEditKeyPress;
    property OnEditKeyUp:TKeyEvent read GetEditKeyUp write SetEditKeyUp;
    property OnEditMouseDown:TMouseEvent read GetEditMouseDown write SetEditMouseDown;
    property OnEditMouseMove:TMouseMoveEvent read GetEditMouseMove write SetEditMouseMove;
    property OnEditMouseUp:TMouseEvent read GetEditMouseUp write SetEditMouseUp;
  end;

procedure Register;

implementation

constructor TPLabelMaskEdit.Create(AOwner: TComponent);
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

     FEdit := TMaskEdit.Create(Self);
     FEdit.Parent := Self;
     FEdit.Visible := True;
     FEdit.Font.Size := 9;
     FEdit.Font.Name := 'ËÎÌו';
     FEdit.ParentFont := False;

     FLabel.FocusControl := FEdit;

     Height := 24;
     FLabel.Height := Height;
     FEdit.Height := Height;

     Width := 200;
     FEdit.Width := 140;
     FLabel.Width := Width-FEdit.Width;
     FEdit.Left := FLabel.Width;
     ParentFont := False;
end;

procedure TPLabelMaskEdit.SetParentFont(Value: Boolean);
begin
     inherited;
     FLabel.ParentFont := Value;
     Flabel.ParentFont := Value;
     FParentFont := Value;
end;

destructor TPLabelMaskEdit.Destroy ;
begin
     FEdit.Free;
     FLabel.Free;
     inherited Destroy;
end;

function TPLabelMaskEdit.GetLabelFont: TFont;
begin
     Result := FLabel.Font;
end;

procedure TPLabelMaskEdit.SetLabelFont(Value: TFont);
begin
     FLabel.Font := Value;
end;

function TPLabelMaskEdit.GetRdOnly:Boolean;
begin
     Result := FEdit.ReadOnly;
end;

procedure TPLabelMaskEdit.SetRdOnly(Value: Boolean);
begin
     FEdit.ReadOnly := Value;
     if Value then
        FEdit.Color := clSilver
     else
     FEdit.Color := clWhite;
end;

function TPLabelMaskEdit.GetEditWidth:integer;
begin
     Result := FEdit.Width;
end;

procedure TPLabelMaskEdit.SetEditWidth(Value: integer);
begin
     FEdit.Width := Value;
     FEdit.Left := Width-Value;
     FLabel.Width := FEdit.Left;
end;

function TPLabelMaskEdit.GetFont:TFont;
begin
     Result := FEdit.Font;
end;

procedure TPLabelMaskEdit.SetFont(Value: TFont);
begin
     FEdit.Font := Value;
     FLabel.Font := Value;
     FLabel.Height := FEdit.Height;
     Height := FEdit.Height;
     SetLabelStyle(LabelStyle);
end;

function TPLabelMaskEdit.GetCaption:TCaption;
begin
     Result := FLabel.Caption;
end;

procedure TPLabelMaskEdit.SetCaption(Value: TCaption);
begin
     FLabel.Caption := Value;
end;

procedure TPLabelMaskEdit.SetLabelStyle (Value: TLabelStyle);
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

procedure TPLabelMaskEdit.Paint;
begin
     inherited Paint;
     FLabel.Height := Height;
     FEdit.Height := Height;
     FLabel.Width := Width-FEdit.Width;
     FEdit.Left := FLabel.Width;
end;

function TPLabelMaskEdit.GetEditModified:Boolean;
begin
     Result := FEdit.Modified;
end;

procedure TPLabelMaskEdit.SetEditModified(Value:Boolean);
begin
     FEdit.Modified:= Value;
end;

function TPLabelMaskEdit.GetEditSelLength:Integer;
begin
     Result := FEdit.SelLength;
end;

procedure TPLabelMaskEdit.SetEditSelLength(Value:Integer);
begin
     FEdit.SelLength:= Value;
end;

function TPLabelMaskEdit.GetEditSelStart:Integer;
begin
     Result := FEdit.SelStart;
end;

procedure TPLabelMaskEdit.SetEditSelStart(Value:Integer);
begin
     FEdit.SelStart:= Value;
end;

function TPLabelMaskEdit.GetEditSelText:string;
begin
     Result := FEdit.SelText;
end;

procedure TPLabelMaskEdit.SetEditSelText(Value:string);
begin
     FEdit.SelText:= Value;
end;

function TPLabelMaskEdit.GetEditAutoSelect:Boolean;
begin
     Result := FEdit.AutoSelect;
end;

procedure TPLabelMaskEdit.SetEditAutoSelect(Value:Boolean);
begin
     FEdit.AutoSelect:= Value;
end;

function TPLabelMaskEdit.GetEditBorderStyle:TBorderStyle;
begin
     Result := FEdit.BorderStyle;
end;

procedure TPLabelMaskEdit.SetEditBorderStyle(Value:TBorderStyle);
begin
     FEdit.BorderStyle:= Value;
end;

function TPLabelMaskEdit.GetEditCharCase:TEditCharCase;
begin
     Result := FEdit.CharCase;
end;

procedure TPLabelMaskEdit.SetEditCharCase(Value:TEditCharCase);
begin
     FEdit.CharCase:= Value;
end;

function TPLabelMaskEdit.GetEditMaxLength:Integer;
begin
     Result := FEdit.MaxLength;
end;

procedure TPLabelMaskEdit.SetEditMaxLength(Value:Integer);
begin
     FEdit.MaxLength:= Value;
end;

function TPLabelMaskEdit.GetEditPasswordChar:Char;
begin
     Result := FEdit.PasswordChar;
end;

procedure TPLabelMaskEdit.SetEditPasswordChar(Value:Char);
begin
     FEdit.PasswordChar:= Value;
end;

function TPLabelMaskEdit.GetEditCtl3D:Boolean;
begin
     Result := FEdit.Ctl3D;
end;

procedure TPLabelMaskEdit.SetEditCtl3D(Value:Boolean);
begin
     FEdit.Ctl3D:= Value;
end;

function TPLabelMaskEdit.GetEditShowHint:Boolean;
begin
     Result := FEdit.ShowHint;
end;

procedure TPLabelMaskEdit.SetEditShowHint(Value:Boolean);
begin
     FEdit.ShowHint:= Value;
end;

function TPLabelMaskEdit.GetEditTabOrder:TTabOrder;
begin
     Result := FEdit.TabOrder;
end;

procedure TPLabelMaskEdit.SetEditTabOrder(Value: TTabOrder);
begin
     FEdit.TabOrder := Value;
end;

function TPLabelMaskEdit.GetEditTabStop:Boolean;
begin
     Result := FEdit.TabStop;
end;

procedure TPLabelMaskEdit.SetEditTabStop(Value:Boolean);
begin
     FEdit.TabStop := Value;
end;

function TPLabelMaskEdit.GetEditText:TCaption;
begin
     Result := FEdit.Text;
end;

procedure TPLabelMaskEdit.SetEditText(Value:TCaption);
begin
     FEdit.Text:= Value;
end;

function TPLabelMaskEdit.GetEditEditMask: string;
begin
     Result := FEdit.EditMask;
end;

procedure TPLabelMaskEdit.SetEditEditMask(Value : string);
begin
     FEdit.EditMask := Value;
end;

function TPLabelMaskEdit.GetEditMasked: Boolean;
begin
     Result := FEdit.IsMasked;
end;

function TPLabelMaskEdit.GetEditEditText: string;
begin
     Result := FEdit.EditText;
end;

procedure TPLabelMaskEdit.SetEditEditText(Value: string);
begin
     FEdit.EditText := Value;
end;

function TPLabelMaskEdit.GetEditOnChange:TNotifyEvent;
begin
     Result := FEdit.OnChange;
end;

procedure TPLabelMaskEdit.SetEditOnChange(Value:TNotifyEvent);
begin
     FEdit.OnChange:= Value;
end;

function TPLabelMaskEdit.GetEditClick:TNotifyEvent;
begin
     Result := FEdit.OnClick;
end;

procedure TPLabelMaskEdit.SetEditClick(Value:TNotifyEvent);
begin
     FEdit.OnClick:= Value;
end;

function TPLabelMaskEdit.GetEditDblClick:TNotifyEvent;
begin
     Result := FEdit.OnDblClick;
end;

procedure TPLabelMaskEdit.SetEditDblClick(Value:TNotifyEvent);
begin
     FEdit.OnDblClick:= Value;
end;

function TPLabelMaskEdit.GetEditEnter:TNotifyEvent;
begin
     Result := FEdit.OnEnter;
end;

procedure TPLabelMaskEdit.SetEditEnter(Value:TNotifyEvent);
begin
     FEdit.OnEnter:= Value;
end;

function TPLabelMaskEdit.GetEditExit:TNotifyEvent;
begin
     Result := FEdit.OnExit;
end;

procedure TPLabelMaskEdit.SetEditExit(Value:TNotifyEvent);
begin
     FEdit.OnExit:= Value;
end;

function TPLabelMaskEdit.GetEditKeyDown:TKeyEvent ;
begin
     Result := FEdit.OnKeyDown;
end;

procedure TPLabelMaskEdit.SetEditKeyDown(Value:TKeyEvent);
begin
     FEdit.OnKeyDown:= Value;
end;

function TPLabelMaskEdit.GetEditKeyPress:TKeyPressEvent;
begin
     Result := FEdit.OnKeyPress;
end;

procedure TPLabelMaskEdit.SetEditKeyPress(Value:TKeyPressEvent);
begin
     FEdit.OnKeyPress:= Value;
end;

function TPLabelMaskEdit.GetEditKeyUp:TKeyEvent;
begin
     Result := FEdit.OnKeyUp;
end;

procedure TPLabelMaskEdit.SetEditKeyUp(Value:TKeyEvent);
begin
     FEdit.OnKeyUp:= Value;
end;

function TPLabelMaskEdit.GetEditMouseDown:TMouseEvent ;
begin
     Result := FEdit.OnMouseDown;
end;

procedure TPLabelMaskEdit.SetEditMouseDown(Value:TMouseEvent);
begin
     FEdit.OnMouseDown:= Value;
end;

function TPLabelMaskEdit.GetEditMouseMove:TMouseMoveEvent;
begin
     Result := FEdit.OnMouseMove;
end;

procedure TPLabelMaskEdit.SetEditMouseMove(Value:TMouseMoveEvent);
begin
     FEdit.OnMouseMove:= Value;
end;

function TPLabelMaskEdit.GetEditMouseUp:TMouseEvent;
begin
     Result := FEdit.OnMouseUp;
end;

procedure TPLabelMaskEdit.SetEditMouseUp(Value:TMouseEvent);
begin
     FEdit.OnMouseUp:= Value;
end;

procedure TPLabelMaskEdit.EditClear;
begin
     FEdit.Clear;
end;

procedure TPLabelMaskEdit.EditClearSelection;
begin
     FEdit.ClearSelection;
end;

procedure TPLabelMaskEdit.EditCopyToClipboard;
begin
     FEdit.CopyToClipboard;
end;

procedure TPLabelMaskEdit.EditCutToClipboard;
begin
     FEdit.CutToClipboard;
end;

procedure TPLabelMaskEdit.EditPasteFromClipboard;
begin
     FEdit.PasteFromClipboard;
end;

function TPLabelMaskEdit.EditGetSelTextBuf(Buffer: PChar; BufSize: Integer): Integer;
begin
     Result := FEdit.GetSelTextBuf(Buffer,BufSize)
end;

procedure TPLabelMaskEdit.EditSelectAll;
begin
     FEdit.SelectAll;
end;

procedure TPLabelMaskEdit.EditSetSelTextBuf(Buffer: PChar);
begin
     FEdit.SetSelTextBuf(Buffer);
end;

function TPLabelMaskEdit.EditCanFocus: Boolean;
begin
     Result := FEdit.CanFocus;
end;

function TPLabelMaskEdit.EditFocused: Boolean;
begin
     Result := FEdit.Focused;
end;

procedure TPLabelMaskEdit.EditSetFocus;
begin
     FEdit.SetFocus;
end;

procedure TPLabelMaskEdit.EditValidateEdit;
begin
     FEdit.ValidateEdit;
end;

function TPLabelMaskEdit.EditGetTextLen: Integer;
begin
     Result := FEdit.GetTextLen;
end;


procedure Register;
begin
     RegisterComponents('PosControl', [TPLabelMaskEdit]);
end;

end.

