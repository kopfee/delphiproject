unit EditExts;

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
  TDigitalEdit = class(TCustomControl)
  private
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
    Ftextbackground:TColor;       //add
    Fframebackground:TColor;      //add
    { Private declarations }
    procedure   WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure   SetUserSeprator(const Value: boolean);
    procedure   WMSetFocus(var Message:TWMSetFocus); message WM_SetFocus;
    procedure   WMKillFocus(var Message:TWMKillFocus); message WM_KillFocus;
    procedure   HandleDelete;
    procedure   SetNegativeColor(const Value: TColor);
    procedure   SetRedNegative(const Value: boolean);
    procedure   Settextbackground(const Value: TColor);        //add
    procedure   Setframebackground(const Value: TColor);       //add
    procedure   SetLeading(const Value: string);
    procedure   SetBorderStyle(const Value: TBorderStyle);
    procedure   UpdateHeight;
    procedure   CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure   CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure   CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
  protected
    { Protected declarations }
    procedure   Paint; override;
    procedure   PaintBorder(var R:TRect); dynamic;
    procedure   PaintText(var R:TRect);   dynamic;
    procedure   KeyDown(var Key: Word; Shift: TShiftState); override;
    //procedure   KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure   KeyPress(var Key: Char); override;        //modify
    function    acceptKey(key:char):boolean;  dynamic;
    procedure   HandleKey(Key:char);          dynamic;
    procedure   Change; dynamic;
    function    CanAddDigital(const AText:string): boolean; dynamic;
    procedure   AdjustSize; override;
    procedure   Loaded; override;
    procedure   DoDrawText(var Rect: TRect); dynamic;    //add
    procedure   DoDrawRect;                              //add
    procedure  DeleteDrawRect(var Rect: TRect);          //add
  
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    function    GetDisplayText : string; dynamic;
    procedure   Clear;
  published
    { Published declarations }
    property    AllowPoint : boolean read FAllowPoint write FAllowPoint default false;
    property    AllowNegative : boolean read FAllowNegative write FAllowNegative default false;
    property    UserSeprator : boolean read FUserSeprator write SetUserSeprator  default false;
    property    ReadOnly : boolean read FReadOnly write FReadOnly default false;
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
    property    AutoSelect: boolean read FAutoselect write FAutoselect default false;  //add
    property    FrameBackground: TColor read Fframebackground write Setframebackground default clNavy;//add
    property    TextBackground:TColor read Ftextbackground write Settextbackground default clwhite; //add
    property Anchors;
    //property AutoSelect;
    property AutoSize default true;
    property BiDiMode;
    //property BorderStyle;
    //property CharCase;
    property Color default clWhite;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    //property HideSelection;
    property ImeMode;
    property ImeName;
    //property MaxLength;
    //property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    //property PasswordChar;
    property PopupMenu;
    //
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
var
 station:boolean;
implementation

procedure Register;
begin
  RegisterComponents('UserCtrls', [TDigitalEdit]);
end;

{ TDigitalEdit }

constructor TDigitalEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 121;
  Height := 25;
  TabStop := True;
  ParentColor := False;
  Text:='0';
  AutoSize:=true;
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
  Ftextbackground:=clwhite;
  Fframebackground:=clNavy;
end;

function TDigitalEdit.acceptKey(key: char): boolean;
begin
  result := not ReadOnly and
    (
    (key in ['0'..'9',char(VK_Back),DeleteChar,ClearChar]) or
    ( (key in ['+','-']) and AllowNegative) or
    ( (key='.') and AllowPoint)
    );
end;

procedure TDigitalEdit.HandleKey(Key: char);
var
  l : integer;
  AText : string;
begin
  if key=#0 then exit;
  AText := text;
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

procedure TDigitalEdit.KeyPress(var Key: Char);
var
  AText : string;
begin
  inherited KeyPress(Key);
  AText := Text;
  //begin add
  if AText='0' then
  begin
  if acceptKey(Key) then
  begin
    HandleKey(Key);
    Key := #0;
  end
  else if ErrorBeep then Beep;
  end
  else
  if station then
  begin
  paint;
  text:='0';
  station:=false;
 if acceptKey(Key) then
  begin
    HandleKey(Key);
    Key := #0;
  end
  else if ErrorBeep then Beep;
  end
  else
  if AText<>'0' then
  begin
  if acceptKey(Key) then
  begin
    HandleKey(Key);
    Key := #0;
  end
  else if ErrorBeep then Beep;
  end
  //end add
end;

procedure TDigitalEdit.Paint;
var
  r : TRect;
begin
  HideCaret(Handle);
  r := GetClientRect;
  PaintBorder(r);
  InflateRect(r,-1,-1);
  PaintText(r);
  ShowCaret(Handle);
end;

procedure TDigitalEdit.PaintBorder(var R:TRect);
begin
  Canvas.Brush.Color := Color;
  Canvas.FillRect(r);
  if BorderStyle=bsSingle then
    if Ctl3D then
      Frame3D(Canvas,r,clBlack,clBtnHighlight,2)
    else Frame3D(Canvas,r,clBlack,clBlack,1);
end;

procedure TDigitalEdit.PaintText(var R:TRect);
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
  WINDOWS.DrawText(Canvas.handle,pchar(GetDisplayText),-1,R,
    DT_RIGHT or DT_SINGLELINE	or DT_VCENTER	);
end;

function TDigitalEdit.GetDisplayText: string;
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

procedure TDigitalEdit.CMTextChanged(var Message: TMessage);
begin
  inherited;
  Change;
end;

procedure TDigitalEdit.WMLButtonDown(var Message: TWMLButtonDown);
begin
  inherited;
  if CanFocus then SetFocus;
end;

procedure TDigitalEdit.SetUserSeprator(const Value: boolean);
begin
  if FUserSeprator <> Value then
  begin
    FUserSeprator := Value;
    Invalidate;
  end;
end;

procedure TDigitalEdit.Change;
begin
  if assigned(FOnChange) then FOnChange(self);
  Invalidate;
end;

procedure TDigitalEdit.WMKillFocus(var Message: TWMKillFocus);
var
  r:TRect;
begin
  inherited ;
  DestroyCaret;
  DeleteDrawRect(r);
  paint;
end;

procedure TDigitalEdit.WMSetFocus(var Message: TWMSetFocus);
var

  atext : string;
   r : TRect;
begin
  inherited ;
  atext := text;
  r := GetClientRect;
  //begin add
  if FAutoselect then
   begin
   if atext<>'0'then
  begin
    DoDrawText(r);
    CreateCaret(Handle, 0, 2, abs(Font.Height));
    SetCaretPos(width-4,(Height-abs(Font.Height))div 2);
    ShowCaret(handle);
    end

  else
  begin
  CreateCaret(Handle, 0, 2, abs(Font.Height));
  SetCaretPos(width-4,(Height-abs(Font.Height))div 2);
  ShowCaret(handle);
  end
  end
  else
  CreateCaret(Handle, 0, 2, abs(Font.Height));
  SetCaretPos(width-4,(Height-abs(Font.Height))div 2);
  ShowCaret(handle);

  //end add


end;

procedure TDigitalEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key,Shift);
  if (key=VK_Delete) and not ReadOnly then
  begin
    if not (ssShift in Shift) then HandleDelete
    else Clear;
  end;
end;

procedure TDigitalEdit.HandleDelete;
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

procedure TDigitalEdit.SetNegativeColor(const Value: TColor);
begin
  if FNegativeColor <> Value then
  begin
    FNegativeColor := Value;
    if RedNegative then
      Invalidate;
  end;
end;

procedure TDigitalEdit.SetRedNegative(const Value: boolean);
begin
  if FRedNegative <> Value then
  begin
    FRedNegative := Value;
    Invalidate;
  end;
end;
//begin add
procedure TDigitalEdit.Settextbackground(const Value: TColor);
begin
  if Ftextbackground <> Value then
  begin
    Ftextbackground:= Value;
    Invalidate;
  end;
end;
procedure TDigitalEdit.Setframebackground(const Value: TColor);
begin
  if Fframebackground <> Value then
  begin
    Fframebackground:= Value;
    Invalidate;
  end;
end;
 //end add
function TDigitalEdit.CanAddDigital(const AText: string): boolean;
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

procedure TDigitalEdit.Clear;
begin
  Text:='0';
end;

procedure TDigitalEdit.SetLeading(const Value: string);
begin
  if FLeading <> Value then
  begin
    FLeading := Value;
    Invalidate;
  end;
end;

procedure TDigitalEdit.SetBorderStyle(const Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    if AutoSize then UpdateHeight
    else invalidate;
  end;
end;

const
  Margin = 1;
procedure TDigitalEdit.UpdateHeight;
var
  Delta : integer;
begin
  if not (csLoading in ComponentState) then
  begin
    if BorderStyle=bsNone then
      Delta:=0
    else if Ctl3D then
      Delta:=2*2
    else Delta:=2*1;

    //Height := abs(Font.Height)+Delta+2*Margin;
    SetBounds(Left, Top, Width, abs(Font.Height)+Delta+2*Margin);
  end;
end;

procedure TDigitalEdit.AdjustSize;
begin
  UpdateHeight;
end;

procedure TDigitalEdit.CMFontChanged(var Message: TMessage);
begin
  Inherited;
  if AutoSize then UpdateHeight;
end;

procedure TDigitalEdit.CMCtl3DChanged(var Message: TMessage);
begin
  inherited;
  if AutoSize then UpdateHeight;
end;

procedure TDigitalEdit.Loaded;
begin
  inherited Loaded;
  if AutoSize then UpdateHeight;
end;
//begin add
procedure TDigitalEdit.DoDrawText(var Rect: TRect);
var
  Text: string;
begin
    DoDrawRect;
    Text := GetDisplayText;
    Canvas.Font := Font;
    OffsetRect(Rect, 1, 1);
    Canvas.Font.Color := Ftextbackground;
    DrawText(Canvas.Handle, PChar(Text), Length(Text)+1, Rect,
    DT_Right or DT_SINGLELINE	or DT_VCENTER);

end;
procedure TDigitalEdit.DoDrawRect;
var

 X, Y: Integer;
begin
X:= Width - Length(text);
 Y:= (Height - abs(font.Height))div 2;
 Canvas.brush.Color:=Fframebackground;
 Rectangle(canvas.Handle,X,Y,X+Length(text),Y+abs(font.Height));
 station:=true;
 end;

procedure TDigitalEdit.DeleteDrawRect(var Rect: TRect);
begin
  canvas.Brush.color:=clwhite;
  FillRect(canvas.Handle,Rect,brush.handle);
  end;

//end add
end.
