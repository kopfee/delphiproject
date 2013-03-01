unit EditExts;
{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>EditExts
   <What>扩充的输入控件
   <Written By> Huang YanLai (黄燕来)
   <History>
   1.1 对数字输入控件的按键消息处理进行了修改，原来不能让下层自动处理ESC/ALT+F4等等消息，现在可以了。
   1.0
**********************************************}


{ TODO :
Bug1:Text可以任意指定(非法字符串)
Bug2:设置Value过大，Text变成科学计数法 ，产生出"E' }
(*****   Code Written By Huang YanLai   *****)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs,StdCtrls,ExtCtrls;

type
  { keys:
      '0'..'9','+','-','.'
      back,delete : 删除最后一个字符
      shift+delete : 清空
      deleteChar : 删除最后一个字符
      ClearChar : 清空
  }
  {
  Notes : 解决了关键的bug。
  原来使用缺省的AutoSize属性(来自TControl)。
  但是如果AutoSize=True的时候，因为各种原因（文字大小变化、对齐等等）多次更改控件的大小以后，控件的大小变为不正常，变为0。
  修正的方法是：
  1、设置继承的AutoSize=False。
  2、增加一个新的AutoSize属性。
  }

  TKSDigitalEdit = class(TCustomControl)
  private
    { Private declarations }
    FAllowPoint: boolean;
    FAllowNegative: boolean;
    FUserSeprator: boolean;
    FOnChange: TNotifyEvent;
    FReadOnly: boolean;
    FDeleteChar: char;
    FRedNegative: boolean;
    FNegativeColor: TColor;
    FMaxIntLen: integer;
    FPrecision: integer;
    FClearChar: char;
    FLeading: string;
    FBorderStyle: TBorderStyle;
    FErrorBeep: boolean;
    FAutoselect:boolean;           //add
    FSelectedTextColor:TColor;       //add
    FSelectedColor:TColor;      //add
    FSelected : Boolean;
    FAutoSize: Boolean;
    procedure   WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure   SetUserSeprator(const Value: boolean);
    procedure   WMSetFocus(var Message:TWMSetFocus); message WM_SetFocus;
    procedure   WMKillFocus(var Message:TWMKillFocus); message WM_KillFocus;
    procedure   HandleDelete;
    procedure   SetNegativeColor(const Value: TColor);
    procedure   SetRedNegative(const Value: boolean);
    procedure   SetSelectedTextColor(const Value: TColor);        //add
    procedure   SetSelectedColor(const Value: TColor);       //add
    procedure   SetLeading(const Value: string);
    procedure   SetBorderStyle(const Value: TBorderStyle);
    procedure   CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure   CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure   CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure   SetSelected(const Value: Boolean);
    function    GetValue: Double;
    procedure   SetValue(const Value: Double);
    procedure   SetReadOnly(const Value: boolean);
    procedure   SetAutoSize(const Value: Boolean);
    procedure   UpdateHeight;
    procedure   WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure   CMWANTSPECIALKEY(var Message:TMessage); message CM_WANTSPECIALKEY;
  protected
    { Protected declarations }
    procedure   Paint; override;
    procedure   PaintBorder(var R:TRect); dynamic;
    procedure   PaintText(var R:TRect);   dynamic;
    procedure   KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure   KeyUp(var Key: Word; Shift: TShiftState); override;
    //procedure   KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure   KeyPress(var Key: Char); override;        //modify
    function    acceptKey(key:char):boolean;  dynamic;
    procedure   HandleKey(Key:char);          dynamic;
    procedure   Change; dynamic;
    function    CanAddDigital(const AText:string): boolean; dynamic;
    procedure   Loaded; override;
    procedure   ReadOnlyChanged; dynamic;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    function    GetDisplayText : string; dynamic;
    procedure   Clear;
    property    Selected : Boolean read FSelected write SetSelected;
  published
    { Published declarations }
    property    AutoSize: Boolean read FAutoSize write SetAutoSize default False;
    property    AllowPoint : boolean read FAllowPoint write FAllowPoint default false;
    property    AllowNegative : boolean read FAllowNegative write FAllowNegative default false;
    property    UserSeprator : boolean read FUserSeprator write SetUserSeprator  default false;
    property    ReadOnly : boolean read FReadOnly write SetReadOnly default false;
    property    DeleteChar : char read FDeleteChar write FDeleteChar default #0;
    property    ClearChar : char read FClearChar write FClearChar default #0;
    property    RedNegative : boolean read FRedNegative write SetRedNegative default false;
    property    NegativeColor : TColor read FNegativeColor write SetNegativeColor default clRed;
    property    Precision : integer read FPrecision write FPrecision default -1;
    property    MaxIntLen : integer read FMaxIntLen write FMaxIntLen default -1;
    property    Leading : string read FLeading write SetLeading;
    property    BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property    ErrorBeep : boolean read FErrorBeep write FErrorBeep default false;
    property    OnChange : TNotifyEvent read FOnChange write FOnChange;
    property    AutoSelect: boolean read FAutoselect write FAutoselect default True;  //add
    property    SelectedColor: TColor read FSelectedColor write SetSelectedColor default clNavy;//add
    property    SelectedTextColor:TColor read FSelectedTextColor write SetSelectedTextColor default clwhite; //add
    property    Value : Double read GetValue write SetValue;

    property Anchors;
    //property AutoSize default true;
    property BiDiMode;
    //property BorderStyle;
    property Color default clWhite;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnClick;
    property OnDblClick;
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
    property OnStartDock;
    property OnStartDrag;
  end;

procedure Register;

implementation

//uses LogFile;

procedure Register;
begin
  RegisterComponents('UserCtrls', [TKSDigitalEdit]);
end;

{ TKSDigitalEdit }

constructor TKSDigitalEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 121;
  Height := 25;
  TabStop := True;
  ParentColor := False;
  Text:='0';
  inherited AutoSize := False;
  FAutoSize := False;
  FAllowPoint:=false;
  FAllowNegative:=false;
  FUserSeprator:=false;
  FReadOnly := false;
  FDeleteChar := #0;
  FClearChar  := #0;
  FRedNegative := false;
  FNegativeColor := clRed;
  FPrecision:=-1;
  FMaxIntLen:=-1;
  FBorderStyle:=bsSingle;
  FErrorBeep := false;
  FSelectedTextColor:=clwhite;
  FSelectedColor:=clNavy;
  FAutoselect := True;
end;

function TKSDigitalEdit.acceptKey(key: char): boolean;
begin
  result := not ReadOnly and
    (
    (key in ['0'..'9',char(VK_Back),DeleteChar,ClearChar]) or
    ( (key in ['+','-']) and AllowNegative) or
    ( (key='.') and AllowPoint)
    );
end;

procedure TKSDigitalEdit.HandleKey(Key: char);
var
  l : integer;
  AText : string;
begin
  if key=#0 then exit;
  AText := text;
  if Selected then
  begin
    FSelected := False;
    AText := '0';
  end;
  l := length(AText);
  if (key=char(VK_Back)) or ((key=DeleteChar)) then
  begin
    //if l>0 then text:=Copy(AText,1,l-1);
    HandleDelete;
  end
  else if key=ClearChar then Clear
  else if key in ['0'..'9'] then
  begin
    if AText='0' then
      Text:=key
    else if CanAddDigital(AText) then
    begin
      text:=Atext+key;
    end;
  end
  else if (key in ['+','-']) and (l>0) then
  begin
    {if AText[1]='-' then
      delete(AText,1,1);
    if (key='-') and (AText<>'0') then AText:='-'+AText;}
    if AText[1]='-' then
      // no matter when key='+' or key='-'
      delete(AText,1,1)
    else if (key='-') and (AText<>'0') then
      // positive to negative
      AText:='-'+AText;
    Text:=AText;
  end
  else if (key='.') and (pos('.',AText)<=0) then
    Text:=AText+'.';
end;

procedure TKSDigitalEdit.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if acceptKey(Key) then
  begin
    HandleKey(Key);
    Key := #0;
  end
  else if ErrorBeep then Beep;
end;

procedure TKSDigitalEdit.Paint;
var
  r : TRect;
begin
  HideCaret(Handle);
  r := GetClientRect;
  {
  if R.Right-R.Left=0 then
  begin
    WriteLog(Format('TKSDigitalEdit=(%d,%d)',[Width,Height]));
  end;
  }
  PaintBorder(r);
  InflateRect(r,-1,-1);
  PaintText(r);
  ShowCaret(Handle);
end;

procedure TKSDigitalEdit.PaintBorder(var R:TRect);
begin
  Canvas.Brush.Color := Color;
  Canvas.FillRect(r);
  if BorderStyle=bsSingle then
    if Ctl3D then
      Frame3D(Canvas,r,clBlack,clBtnHighlight,2)
    else Frame3D(Canvas,r,clBlack,clBlack,1);
end;

procedure TKSDigitalEdit.PaintText(var R:TRect);
var
  AText : string;
begin
  Canvas.Font := Font;
  if RedNegative then
  begin
    AText := Text;
    if (length(AText)>0) and (AText[1]='-') then
      Canvas.Font.Color := NegativeColor;
  end;
  WINDOWS.DrawText(Canvas.handle,pchar(FLeading),-1,R,
    DT_Left or DT_SINGLELINE	or DT_VCENTER	);
  if Selected then
  begin
    Canvas.Font.Color := SelectedTextColor;
    Canvas.Brush.Color := SelectedColor;
  end;
  AText := GetDisplayText;
  //OutputDebugString(PChar(AText));
  WINDOWS.DrawText(Canvas.handle,pchar(AText),-1,R,
    DT_RIGHT or DT_SINGLELINE	or DT_VCENTER	);
end;

function TKSDigitalEdit.GetDisplayText: string;
var
  i,l : integer;
  AText : string;
  PositivePart,NegativePart : string;
  Negativechar : char;
begin
  AText :=text;
  if (AText='') or not UserSeprator then
    result := Atext
  else
  begin
    if AText[1] in ['-','+']  then
    begin
      Negativechar:=AText[1];
      delete(Atext,1,1);
    end
    else
    begin
      Negativechar:=#0;
    end;
    i:=pos('.',Atext);
    if i>0 then
    begin
      PositivePart := copy(AText,1,i-1);
      NegativePart := copy(AText,i,length(Atext)-i+1);
    end
    else
    begin
      PositivePart := AText;
      NegativePart := '';
    end;

    result := NegativePart;
    l := length(PositivePart);
    for i:=0 to l-1 do
    begin
      result := PositivePart[l-i]+result;
      if ( ((i+1) mod 3)=0 ) and (i<>l-1) then
        result := ','+result;
    end;
    if Negativechar<>#0 then result := Negativechar+result;
  end;
end;

procedure TKSDigitalEdit.CMTextChanged(var Message: TMessage);
begin
  inherited;
  Change;
end;

procedure TKSDigitalEdit.WMLButtonDown(var Message: TWMLButtonDown);
begin
  inherited;
  if CanFocus then SetFocus;
end;

procedure TKSDigitalEdit.SetUserSeprator(const Value: boolean);
begin
  if FUserSeprator <> Value then
  begin
    FUserSeprator := Value;
    Invalidate;
  end;
end;

procedure TKSDigitalEdit.Change;
begin
  if assigned(FOnChange) then FOnChange(self);
  Invalidate;
end;

procedure TKSDigitalEdit.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited ;
  DestroyCaret;
  Selected := False;
end;

procedure TKSDigitalEdit.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited ;
  CreateCaret(Handle, 0, 2, abs(Font.Height));
  SetCaretPos(width-4,(Height-abs(Font.Height))div 2);
  ShowCaret(handle);
  if AutoSelect then
    Selected := True;
end;

procedure TKSDigitalEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key,Shift);
  if (key=VK_Delete) and not ReadOnly then
  begin
    if not (ssShift in Shift) then HandleDelete
    else Clear;
    Key := 0;
  end
  else if Key in [VK_LEFT,VK_RIGHT,VK_UP,VK_DOWN] then
  begin
    Selected := False;
    Key := 0;
  end;
end;

procedure TKSDigitalEdit.HandleDelete;
var
  AText : string;
  l : integer;
begin
  AText := text;
  l := length(AText);
  if l>0 then Atext:=Copy(AText,1,l-1);
  if (AText='') or (AText='-') or (AText='+') then
    AText:='0';
  Text:=AText;
end;

procedure TKSDigitalEdit.SetNegativeColor(const Value: TColor);
begin
  if FNegativeColor <> Value then
  begin
    FNegativeColor := Value;
    if RedNegative then
      Invalidate;
  end;
end;

procedure TKSDigitalEdit.SetRedNegative(const Value: boolean);
begin
  if FRedNegative <> Value then
  begin
    FRedNegative := Value;
    Invalidate;
  end;
end;
//begin add
procedure TKSDigitalEdit.SetSelectedTextColor(const Value: TColor);
begin
  if FSelectedTextColor <> Value then
  begin
    FSelectedTextColor:= Value;
    Invalidate;
  end;
end;
procedure TKSDigitalEdit.SetSelectedColor(const Value: TColor);
begin
  if FSelectedColor <> Value then
  begin
    FSelectedColor:= Value;
    Invalidate;
  end;
end;
 //end add
function TKSDigitalEdit.CanAddDigital(const AText: string): boolean;
var
  i,l : integer;
begin
  l:=length(AText);
  i:=pos('.',Atext);
  if i>0 then
  begin
    // after point
    result := (Precision<0) or (l-i<Precision);
  end
  else
  begin
    // before point
    result := (MaxIntLen<0) or (l=0) or (l<MaxIntLen)
       or ((Atext[1]='-') and (l-1<MaxIntLen));
  end;
end;

procedure TKSDigitalEdit.Clear;
begin
  Text:='0';
end;

procedure TKSDigitalEdit.SetLeading(const Value: string);
begin
  if FLeading <> Value then
  begin
    FLeading := Value;
    Invalidate;
  end;
end;

procedure TKSDigitalEdit.SetBorderStyle(const Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    if AutoSize then
      UpdateHeight else
      invalidate;
  end;
end;

const
  Margin = 1;

procedure TKSDigitalEdit.CMFontChanged(var Message: TMessage);
begin
  Inherited;
  UpdateHeight;
end;

procedure TKSDigitalEdit.CMCtl3DChanged(var Message: TMessage);
begin
  inherited;
  UpdateHeight;
end;

procedure TKSDigitalEdit.Loaded;
begin
  inherited Loaded;
  UpdateHeight;
end;

procedure TKSDigitalEdit.SetSelected(const Value: Boolean);
begin
  if FSelected <> Value then
  begin
    FSelected := Value;
    Invalidate;
  end;
end;

function TKSDigitalEdit.GetValue: Double;
begin
  Result := StrToFloat(Text);
end;

procedure TKSDigitalEdit.SetValue(const Value: Double);
var
  aPrecision, aDigits: Integer;
begin
  if AllowPoint then
    if Precision>=0 then
      aDigits := Precision else
      aDigits := 18
  else
    aDigits := 0;
  aPrecision := 15;
  Text := FloatToStrF(Value,ffFixed,aPrecision,aDigits);
end;

procedure TKSDigitalEdit.SetReadOnly(const Value: boolean);
begin
  if FReadOnly <> Value then
  begin
    FReadOnly := Value;
    ReadOnlyChanged;
  end;
end;

procedure TKSDigitalEdit.ReadOnlyChanged;
begin

end;


procedure TKSDigitalEdit.SetAutoSize(const Value: Boolean);
begin
  if FAutoSize <> Value then
  begin
    FAutoSize := Value;
    UpdateHeight;
  end;
end;

procedure TKSDigitalEdit.UpdateHeight;
var
  Delta : integer;
  NewHeight : integer;
begin
  //OutputDebugString(PChar(Format('Before UpdateHeight : %d,%d,%d,%d',[Left, Top, Width, Height])));
  if AutoSize and HandleAllocated and not (csLoading in ComponentState) and not (csReading in ComponentState) then
  begin
    if BorderStyle=bsNone then
      Delta:=0
    else if Ctl3D then
      Delta:=2*2
    else Delta:=2*1;

    NewHeight := Abs(Font.Height)+Delta+2*Margin;
    SetBounds(Left, Top, Width, NewHeight);
    {
    // 下面注释的方法，解说不正确。关键在于不能使用缺省的AutoSize属性。
    // 直接调用API，关键是SWP_NOSENDCHANGING标志，避免TWinControl错误的更新大小（否则，错误地更新为0）
    SetWindowPos(Handle, 0, Left, Top, Width, NewHeight, SWP_NOACTIVATE or SWP_NOMOVE or
      SWP_NOZORDER or SWP_NOSENDCHANGING);
    }
  end;
  //OutputDebugString(PChar(Format('After UpdateHeight : %d,%d,%d,%d',[Left, Top, Width, Height])));
end;

procedure   TKSDigitalEdit.WMGetDlgCode(var Message: TWMGetDlgCode); 
begin
  inherited;
  Message.Result := Message.Result {or DLGC_WANTALLKEYS} or DLGC_WANTARROWS or DLGC_WANTCHARS;
end;

procedure TKSDigitalEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key in [VK_LEFT,VK_RIGHT,VK_UP,VK_DOWN,VK_DELETE] then
  begin
    Key := 0;
  end;
end;

procedure TKSDigitalEdit.CMWANTSPECIALKEY(var Message: TMessage);
begin
  inherited;
  if Message.WParam=VK_RETURN then
    Message.Result := 1;
end;

end.
