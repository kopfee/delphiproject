unit PTimeEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask;

type
  TPTimeEdit = class(TCustomMaskEdit)
  private
    { Private declarations }
    FCheckResult: Boolean;
    FRdOnly: Boolean;
  protected
    { Protected declarations }
    procedure JudgeText;
    procedure SetRdOnly(Value: Boolean);
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure CMExit(var Message: TCMExit);   message CM_EXIT;
    property CheckResult: Boolean read FCheckResult write FCheckResult;
    procedure SetText(Value: string); dynamic;
  published
    { Published declarations }

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
    property ImeMode;
    property ImeName;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property RdOnly: Boolean read FRdOnly write SetRdOnly;
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

procedure Register;
begin
     RegisterComponents('PosControl2', [TPTimeEdit]);
end;

procedure TPTimeEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
     if AHeight < 20 then
        AHeight := 20;
     if AHeight >50 then
        AHeight := 50;
     inherited;
end;

procedure TPTimeEdit.SetRdOnly(Value: Boolean);
begin
     FRdOnly := Value;
     ReadOnly := Value;
     if Value then
        Color := clSilver
     else
        Color := clWhite;
end;

procedure TPTimeEdit.CMExit(var Message: TCMExit);
begin
     if Text <> '  :  :  ' then
     begin
          FCheckResult := True;
          try StrToTime(text)
          except
               FCheckResult := False;
          end;
     end
     else
     begin
         FCheckResult := False;
     end;
     inherited;
end;

constructor TPTimeEdit.Create(AOwner: TComponent);
begin
     inherited;
     Height := 20;
     EditMask := '!90:00:00;1; ';
     Font.Size := 9;
     Font.Name := 'ËÎÌו';
end;

procedure TPTimeEdit.JudgeText;
var s1,s2,s3,temp: string;
begin
     temp := Text;
     s1 := trim(temp[1] + temp[2]);
     if strtoint(s1) < 10 then
        s1 := '0' + s1;
     s2 := trim(temp[4] + temp[5]);
     if strtoint(s2) < 10 then
        s2 := '0' + s2;
     s3 := trim(temp[7] + temp[8]);
     if strtoint(s3) < 10 then
        s3 := '0' + s3;
     temp := s1 + ':' + s2 + ':' + s3;
     Text := temp;
end;

procedure TPTimeEdit.SetText(Value: string);
begin
     if Value <> Text then
        Text := Value;
end;

end.
