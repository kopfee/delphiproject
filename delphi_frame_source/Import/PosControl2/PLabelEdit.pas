unit PLabelEdit;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  stdctrls, dbtables, extctrls, RxCtrls, dbctrls, db, SelectDlg, PLabelPanel,
  LookupControls;

type
  TPLabelEdit = class(TCustomControl)
  private
    FEdit: TEdit;
    FLabel: TRxLabel;
    FLabelStyle: TLabelStyle;
  protected
    function GetCaption:TCaption;
    function GetEditAutoSelect:Boolean;
    function GetEditBorderStyle:TBorderStyle;
    function GetEditCharCase:TEditCharCase;
    function GetEditClick:TNotifyEvent;
    function GetEditCtl3D:Boolean;
    function GetEditDblClick:TNotifyEvent;
    function GetEditEnter:TNotifyEvent;
    function GetEditExit:TNotifyEvent;
    function GetEditHideSelection:Boolean;
    function GetEditKeyDown:TKeyEvent ;
    function GetEditKeyPress:TKeyPressEvent;
    function GetEditKeyUp:TKeyEvent;
    function GetEditMaxLength:Integer;
    function GetEditMouseDown:TMouseEvent ;
    function GetEditMouseMove:TMouseMoveEvent;
    function GetEditMouseUp:TMouseEvent;
    function GetEditModified:Boolean;
    function GetEditOEMConvert:Boolean;
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

    procedure SetCaption(Value: TCaption);
    procedure SetEditAutoSelect(Value:Boolean);
    procedure SetEditBorderStyle(Value:TBorderStyle);
    procedure SetEditCharCase(Value:TEditCharCase);
    procedure SetEditClick(Value:TNotifyEvent);
    procedure SetEditCtl3D(Value:Boolean);
    procedure SetEditDblClick(Value:TNotifyEvent);
    procedure SetEditEnter(Value:TNotifyEvent);
    procedure SetEditExit(Value:TNotifyEvent);
    procedure SetEditHideSelection(Value:Boolean);
    procedure SetEditKeyDown(Value:TKeyEvent);
    procedure SetEditKeyPress(Value:TKeyPressEvent);
    procedure SetEditKeyUp(Value:TKeyEvent);
    procedure SetEditMaxLength(Value:Integer);
    procedure SetEditModified(Value:Boolean);
    procedure SetEditMouseDown(Value:TMouseEvent);
    procedure SetEditMouseMove(Value:TMouseMoveEvent);
    procedure SetEditMouseUp(Value:TMouseEvent);
    procedure SetEditOEMConvert(Value:Boolean);
    procedure SetEditOnChange(Value:TNotifyEvent);
    procedure SetEditPasswordChar(Value:Char);
    procedure SetEditSelLength(Value:Integer);
    procedure SetEditSelStart(Value:Integer);
    procedure SetEditSelText(Value:string);
    procedure SetEditShowHint(Value:Boolean);
    procedure SetEditTabOrder(Value: TTabOrder);
    procedure SetEditTabStop(Value:Boolean);
    procedure SetEditText(Value:TCaption);
    procedure SetEditWidth(Value: integer);
    procedure SetFont(Value: TFont);
    procedure SetRdOnly(Value: Boolean);
    procedure SetLabelFont(Value: TFont);
    procedure SetLabelStyle(Value: TLabelStyle);
    procedure Paint;override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    function EditCanFocus: Boolean;
    function EditFocused: Boolean;
    function EditGetSelTextBuf(Buffer: PChar; BufSize: Integer): Integer;
    procedure EditClear;
    procedure EditClearSelection;
    procedure EditCopyToClipboard;
    procedure EditCutToClipboard;
    procedure EditPasteFromClipboard;
    procedure EditSelectAll;
    procedure EditSetSelTextBuf(Buffer: PChar);
    procedure EditSetFocus;
    procedure SelectAll;

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
    property EditHideSelection: Boolean read GetEditHideSelection write SetEditHideSelection;
    property EditMaxLength: Integer read GetEditMaxLength write SetEditMaxLength;
    property EditOEMConvert: Boolean read GetEditOEMConvert write SetEditOEMConvert;
    property EditPasswordChar: Char read GetEditPasswordChar write SetEditPasswordChar;
    property EditShowHint:Boolean read GetEditShowHint write SetEditShowHint;
    property EditTabOrder:TTabOrder read GetEditTabOrder write SetEditTabOrder;
    property EditTabStop:Boolean read GetEditTabStop write SetEditTabStop;
    property EditText:TCaption read GetEditText write SetEditText;
    property EditWidth:integer read GetEditWidth write SetEditWidth;
    property Enabled;
    property Font:TFont read GetFont write SetFont;
    property LabelFont: TFont read GetLabelFont write SetLabelFont;
    property LabelStyle: TLabelStyle read FLabelStyle write SetLabelStyle default Normal;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
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

constructor TPLabelEdit.Create(AOwner: TComponent);
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

     FEdit := TEdit.Create(Self);
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
end;

destructor TPLabelEdit.Destroy ;
begin
     FEdit.Free;
     FLabel.Free;
     inherited Destroy;
end;

function TPLabelEdit.GetLabelFont : TFont;
begin
     Result := FLabel.Font;
end;

procedure TPLabelEdit.SetLabelFont(Value: TFont);
begin
     FLabel.Font := Value;
end;

function TPLabelEdit.GetRdOnly:Boolean;
begin
     Result := FEdit.ReadOnly;
end;

procedure TPLabelEdit.SetRdOnly(Value: Boolean);
begin
     FEdit.ReadOnly := Value;
     if Value then
        FEdit.Color := clSilver
     else
         FEdit.Color := clWhite;
end;

function TPLabelEdit.GetEditWidth:integer;
begin
     Result := FEdit.Width;
end;

procedure TPLabelEdit.SetEditWidth(Value: integer);
begin
     FEdit.Width := Value;
     FEdit.Left := Width-Value;
     FLabel.Width := FEdit.Left;
end;

function TPLabelEdit.GetFont:TFont;
begin
     Result := FEdit.Font;
end;

procedure TPLabelEdit.SetFont(Value: TFont);
begin
     FEdit.Font := Value;
     FLabel.Font := Value;
     FLabel.Height := FEdit.Height;
     Height := FEdit.Height;
     SetLabelStyle(LabelStyle);
end;

function TPLabelEdit.GetCaption:TCaption;
begin
     Result := FLabel.Caption;
end;

procedure TPLabelEdit.SetCaption(Value: TCaption);
begin
     FLabel.Caption := Value;
end;

procedure TPLabelEdit.SetLabelStyle (Value: TLabelStyle);
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

procedure TPLabelEdit.Paint;
begin
     inherited Paint;
     FLabel.Height := Height;
     FEdit.Height := Height;
     FLabel.Width := Width-FEdit.Width;
     FEdit.Left := FLabel.Width;
end;


function TPLabelEdit.GetEditModified:Boolean;
begin
     Result := FEdit.Modified;
end;

procedure TPLabelEdit.SetEditModified(Value:Boolean);
begin
     FEdit.Modified:= Value;
end;

function TPLabelEdit.GetEditSelLength:Integer;
begin
     Result := FEdit.SelLength;
end;

procedure TPLabelEdit.SetEditSelLength(Value:Integer);
begin
     FEdit.SelLength:= Value;
end;

procedure TPLabelEdit.SelectAll;
begin
     FEdit.selectall;
end;

function TPLabelEdit.GetEditSelStart:Integer;
begin
     Result := FEdit.SelStart;
end;

procedure TPLabelEdit.SetEditSelStart(Value:Integer);
begin
     FEdit.SelStart:= Value;
end;

function TPLabelEdit.GetEditSelText:string;
begin
     Result := FEdit.SelText;
end;

procedure TPLabelEdit.SetEditSelText(Value:string);
begin
     FEdit.SelText:= Value;
end;

function TPLabelEdit.GetEditAutoSelect:Boolean;
begin
     Result := FEdit.AutoSelect;
end;

procedure TPLabelEdit.SetEditAutoSelect(Value:Boolean);
begin
     FEdit.AutoSelect:= Value;
end;

function TPLabelEdit.GetEditBorderStyle:TBorderStyle;
begin
     Result := FEdit.BorderStyle;
end;

procedure TPLabelEdit.SetEditBorderStyle(Value:TBorderStyle);
begin
     FEdit.BorderStyle:= Value;
end;

function TPLabelEdit.GetEditCharCase:TEditCharCase;
begin
     Result := FEdit.CharCase;
end;

procedure TPLabelEdit.SetEditCharCase(Value:TEditCharCase);
begin
     FEdit.CharCase:= Value;
end;

function TPLabelEdit.GetEditHideSelection:Boolean;
begin
     Result := FEdit.HideSelection;
end;

procedure TPLabelEdit.SetEditHideSelection(Value:Boolean);
begin
     FEdit.HideSelection:= Value;
end;

function TPLabelEdit.GetEditMaxLength:Integer;
begin
     Result := FEdit.MaxLength;
end;

procedure TPLabelEdit.SetEditMaxLength(Value:Integer);
begin
     FEdit.MaxLength:= Value;
end;

function TPLabelEdit.GetEditOEMConvert:Boolean;
begin
     Result := FEdit.OEMConvert;
end;

procedure TPLabelEdit.SetEditOEMConvert(Value:Boolean);
begin
     FEdit.OEMConvert:= Value;
end;

function TPLabelEdit.GetEditPasswordChar:Char;
begin
     Result := FEdit.PasswordChar;
end;

procedure TPLabelEdit.SetEditPasswordChar(Value:Char);
begin
     FEdit.PasswordChar:= Value;
end;

function TPLabelEdit.GetEditCtl3D:Boolean;
begin
     Result := FEdit.Ctl3D;
end;

procedure TPLabelEdit.SetEditCtl3D(Value:Boolean);
begin
     FEdit.Ctl3D:= Value;
end;

function TPLabelEdit.GetEditShowHint:Boolean;
begin
     Result := FEdit.ShowHint;
end;

procedure TPLabelEdit.SetEditShowHint(Value:Boolean);
begin
     FEdit.ShowHint:= Value;
end;

function TPLabelEdit.GetEditTabOrder:TTabOrder;
begin
     Result := FEdit.TabOrder;
end;

procedure TPLabelEdit.SetEditTabOrder(Value: TTabOrder);
begin
     FEdit.TabOrder := Value;
end;

function TPLabelEdit.GetEditTabStop:Boolean;
begin
     Result := FEdit.TabStop;
end;

procedure TPLabelEdit.SetEditTabStop(Value:Boolean);
begin
     FEdit.TabStop := Value;
end;

function TPLabelEdit.GetEditText:TCaption;
begin
     Result := FEdit.Text;
end;

procedure TPLabelEdit.SetEditText(Value:TCaption);
begin
     FEdit.Text:= Value;
end;

function TPLabelEdit.GetEditOnChange:TNotifyEvent;
begin
     Result := FEdit.OnChange;
end;

procedure TPLabelEdit.SetEditOnChange(Value:TNotifyEvent);
begin
     FEdit.OnChange:= Value;
end;

function TPLabelEdit.GetEditClick:TNotifyEvent;
begin
     Result := FEdit.OnClick;
end;

procedure TPLabelEdit.SetEditClick(Value:TNotifyEvent);
begin
     FEdit.OnClick:= Value;
end;

function TPLabelEdit.GetEditDblClick:TNotifyEvent;
begin
     Result := FEdit.OnDblClick;
end;

procedure TPLabelEdit.SetEditDblClick(Value:TNotifyEvent);
begin
     FEdit.OnDblClick:= Value;
end;

function TPLabelEdit.GetEditEnter:TNotifyEvent;
begin
     Result := FEdit.OnEnter;
end;

procedure TPLabelEdit.SetEditEnter(Value:TNotifyEvent);
begin
     FEdit.OnEnter:= Value;
end;

function TPLabelEdit.GetEditExit:TNotifyEvent;
begin
     Result := FEdit.OnExit;
end;

procedure TPLabelEdit.SetEditExit(Value:TNotifyEvent);
begin
     FEdit.OnExit:= Value;
end;

function TPLabelEdit.GetEditKeyDown:TKeyEvent ;
begin
     Result := FEdit.OnKeyDown;
end;

procedure TPLabelEdit.SetEditKeyDown(Value:TKeyEvent);
begin
     FEdit.OnKeyDown:= Value;
end;

function TPLabelEdit.GetEditKeyPress:TKeyPressEvent;
begin
     Result := FEdit.OnKeyPress;
end;

procedure TPLabelEdit.SetEditKeyPress(Value:TKeyPressEvent);
begin
     FEdit.OnKeyPress:= Value;
end;

function TPLabelEdit.GetEditKeyUp:TKeyEvent;
begin
     Result := FEdit.OnKeyUp;
end;

procedure TPLabelEdit.SetEditKeyUp(Value:TKeyEvent);
begin
     FEdit.OnKeyUp:= Value;
end;

function TPLabelEdit.GetEditMouseDown:TMouseEvent ;
begin
     Result := FEdit.OnMouseDown;
end;

procedure TPLabelEdit.SetEditMouseDown(Value:TMouseEvent);
begin
     FEdit.OnMouseDown:= Value;
end;

function TPLabelEdit.GetEditMouseMove:TMouseMoveEvent;
begin
     Result := FEdit.OnMouseMove;
end;

procedure TPLabelEdit.SetEditMouseMove(Value:TMouseMoveEvent);
begin
     FEdit.OnMouseMove:= Value;
end;

function TPLabelEdit.GetEditMouseUp:TMouseEvent;
begin
     Result := FEdit.OnMouseUp;
end;

procedure TPLabelEdit.SetEditMouseUp(Value:TMouseEvent);
begin
     FEdit.OnMouseUp:= Value;
end;

procedure TPLabelEdit.EditClear;
begin
     FEdit.Clear;
end;

procedure TPLabelEdit.EditClearSelection;
begin
     FEdit.ClearSelection;
end;

procedure TPLabelEdit.EditCopyToClipboard;
begin
     FEdit.CopyToClipboard;
end;

procedure TPLabelEdit.EditCutToClipboard;
begin
     FEdit.CutToClipboard;
end;

procedure TPLabelEdit.EditPasteFromClipboard;
begin
     FEdit.PasteFromClipboard;
end;

function TPLabelEdit.EditGetSelTextBuf(Buffer: PChar; BufSize: Integer): Integer;
begin
     Result := FEdit.GetSelTextBuf(Buffer,BufSize)
end;

procedure TPLabelEdit.EditSelectAll;
begin
     FEdit.SelectAll;
end;

procedure TPLabelEdit.EditSetSelTextBuf(Buffer: PChar);
begin
     FEdit.SetSelTextBuf(Buffer);
end;

function TPLabelEdit.EditCanFocus: Boolean;
begin
     Result := FEdit.CanFocus;
end;

function TPLabelEdit.EditFocused: Boolean;
begin
     Result := FEdit.Focused;
end;

procedure TPLabelEdit.EditSetFocus;
begin
     FEdit.SetFocus;
end;

procedure Register;
begin
     RegisterComponents('PosControl', [TPLabelEdit]);
end;

end.

