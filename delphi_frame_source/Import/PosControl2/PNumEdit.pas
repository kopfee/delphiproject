unit PNumEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;


type
  TPrecision = -1..20;

  TPNumEdit = class(TCustomEdit)
  private
    FInternalChanging : Boolean;
    FMaxValue : Double;
    FMaxLimited : Boolean;
    FMinValue : Double;
    FMinLimited : Boolean;
    FNeedFloat : Boolean;
    FOldPos : Integer;
    FOldText : string;
    FPrecision : TPrecision;

  protected
    function GetCurValue: Double;
    function GetRdOnly:Boolean;
    procedure Change;override;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure KeyPress(var Key: Char); override;
    procedure Loaded;override;
    procedure SetMaxLimited(Value: Boolean);
    procedure SetMaxValue(Value: Double);
    procedure SetMinLimited(Value: Boolean);
    procedure SetMinValue(Value: Double);
    procedure SetNeedFloat(Value: Boolean);
    procedure SetPrecision(Value: TPrecision);
    procedure SetRdOnly(Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    property CurValue : Double read GetCurValue;
  published
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property CharCase;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property MaxLimited : Boolean read FMaxLimited write SetMaxLimited;
    property MaxValue : Double read FMaxValue write SetMaxValue;
    property MinLimited : Boolean read FMinLimited write SetMinLimited;
    property MinValue : Double read FMinValue write SetMinValue;
    property NeedFloat : Boolean read FNeedFloat write SetNeedFloat;
    property OEMConvert;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property Precision : TPrecision read FPrecision write SetPrecision default -1;
    property RdOnly: Boolean read GetRdOnly write SetRdOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
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

procedure Register;

implementation

function TPNumEdit.GetRdOnly:Boolean;
begin
     Result := ReadOnly;
end;

procedure TPNumEdit.SetRdOnly(Value: Boolean);
begin
     ReadOnly := Value;
     if Value then
        Color := clSilver
     else
         Color := clWhite;
end;

constructor TPNumEdit.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     Precision := -1;
     FInternalChanging := True;
     Font.Size := 9;
     Font.Name := 'ËÎÌו';
     ParentFont := False;
     Text := '0';
end;

procedure TPNumEdit.Loaded;
begin
     inherited Loaded;
     FInternalChanging := False;
end;

procedure TPNumEdit.Change;
begin
     inherited Change;
end;

procedure TPNumEdit.CMExit(var Message: TCMExit);
var AError : Boolean;
    tmpDouble : Double;
    tmpInt : Integer;
    ALen,APos : Integer;
begin
     AError := False;
     if (not FInternalChanging) then
     begin
          if FNeedFloat then
          begin
               try
                  if (Text<>'') and (Text<>'-') and (Text<>'+') then
                  begin
                       if FPrecision<>-1 then
                       begin
                            ALen := Length(Text);
                            APos := Pos('.',Text);
                            if APos<>0 then
                               if (ALen-APos)>FPrecision then AError := True;
                       end;
                       try
                          tmpDouble := StrToFloat(Text);
                       except
                             AError := True;
                       end;
                       if FMaxLimited and (tmpDouble>FMaxValue) then AError := True;
                       if FMinLimited and (tmpDouble<FMinValue) then AError := True;
                  end;
               except
                     AError := True;
               end;
          end
          else
              begin
                   try
                      if (Text<>'') and (Text<>'+') and (Text<>'-') then
                      begin
                           tmpInt := StrToInt(Text);
                           if FMaxLimited and (tmpInt>FMaxValue) then AError := True;
                           if FMinLimited and (tmpInt<FMinValue) then AError := True;
                      end;
                   except
                         AError := True;
                   end;
              end;
          if AError then
          begin
               FInternalChanging := True;
               Text := FOldText;
               SelStart := FOldPos;
               Beep;
               FInternalChanging := False;
          end;
          inherited ;
     end;
end;

procedure TPNumEdit.KeyPress(var Key: Char);
begin
     if not( Key in ['0','1','2','3','4','5','6','7','8','9','+','-','.',#8] )then
     begin
          Key := #0;
     end;
     inherited;
end;

procedure TPNumEdit.CMEnter(var Message: TCMEnter);
begin
     FOldText := Text;
     FOldPos := SelStart;
end;

function TPNumEdit.GetCurValue: Double;
begin
     if Text='' then
        Result := 0
     else
         Result := StrToFloat(Text);
end;

procedure TPNumEdit.SetNeedFloat(Value: Boolean);
begin
     FNeedFloat := Value;
     FInternalChanging := True;
     Text := '';
     FInternalChanging := False;
end;

procedure TPNumEdit.SetMaxValue(Value: Double);
begin
     FMaxValue := Value;
     FInternalChanging := True;
     Text := '';
     FInternalChanging := False;
end;

procedure TPNumEdit.SetMaxLimited(Value: Boolean);
begin
     FMaxLimited := Value;
     FInternalChanging := True;
     Text := '';
     FInternalChanging := False;
end;

procedure TPNumEdit.SetMinValue(Value: Double);
begin
     FMinValue := Value;
     FInternalChanging := True;
     Text := '';
     FInternalChanging := False;
end;

procedure TPNumEdit.SetMinLimited(Value: Boolean);
begin
     FMinLimited := Value;
     FInternalChanging := True;
     Text := '';
     FInternalChanging := False;
end;

procedure TPNumEdit.SetPrecision(Value: TPrecision);
begin
     FPrecision := Value;
     FInternalChanging := True;
     Text := '';
     FInternalChanging := False;
end;

procedure Register;
begin
     RegisterComponents('PosControl', [TPNumEdit]);
end;

end.

