unit PBaseMemoEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask;

type
  TPBaseMemoEdit = class(TCustomMaskEdit)
  private
    { Private declarations }
    FBackText: string;
    FCanExtend: Boolean;
    FEnPreFix: Boolean;
    FCurrentCNT: string;
    FExtending: boolean;
    FFullLength: integer;
  protected
    { Protected declarations }
    procedure BackText;
    procedure Change; override;
    procedure DoExit;override;
    procedure DoExtend;
    procedure KeyPress(var Key: Char);override;
    procedure SetFullLength(Value: integer);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property CanExtend: Boolean read FCanExtend write FCanExtend;
    property CharCase;
    property CurrentCNT:string read FCurrentCNT write FCurrentCNT;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property EditMask;
    property EnPreFix: Boolean read FEnPreFix write FEnPreFix;
    property Font;
    property FullLength:integer read FFullLength write SetFullLength default 12;
    property ImeMode;
    property ImeName;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
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

constructor TPBaseMemoEdit.Create(AOwner:TComponent);
begin
     inherited Create(AOwner);    
     FullLength := 12;
     FExtending := False;
     FCanExtend := True;
     Font.Size := 9;
     Font.Name := 'ËÎÌו';
     ParentFont := False;
     Text := '';
end;

procedure TPBaseMemoEdit.SetFullLength(Value: integer);
begin
     if (Value>0) and (Value>=Length(FCurrentCNT)) then
     begin
          FFullLength := Value;
          MaxLength := Value;
          FExtending := True;
          Text := '';
          FExtending := False;
     end;
end;

procedure TPBaseMemoEdit.BackText;
begin
     if FBackText <> Text then
        FBackText := Text;
end;

procedure TPBaseMemoEdit.DoExtend;
var i:integer;
    CurLen,TextLen:integer;
    tmpText: string;
begin
     if not FCanExtend then exit;

     CurLen := Length(CurrentCNT);
     TextLen := Length(FBackText);
     tmpText := CurrentCNT;

     if (TextLen >= FullLength-CurLen) then
        tmpText := tmpText + Copy(FBackText,TextLen-(FullLength-CurLen)+1,FullLength-CurLen)
     else
     begin
          for i := 1 to FullLength-CurLen-TextLen do
          tmpText := tmpText + '0';
          tmpText := tmpText + FBackText;
     end;
     FExtending := True;
     Text := tmpText;
     FExtending := False;
end;

procedure TPBaseMemoEdit.Change;
begin
     if not FExtending then
        inherited Change;
end;

procedure TPBaseMemoEdit.KeyPress(var Key: Char);
begin
     inherited KeyPress(Key);
     if Key = #13 then
     begin
          BackText;
          if  (Text <> '' )and (FEnPreFix <> False)then
              DoExtend;
     end;
end;

procedure TPBaseMemoEdit.DoExit;
begin
     if self.ClassType = TPBaseMemoEdit then
        BackText
     else
         text := FBackText;
     if  (Text <> '' )and (FEnPreFix <> False)then
          DoExtend;
     inherited DoExit;
end;

procedure Register;
begin
//     RegisterComponents('PosControl2', [TPBaseMemoEdit]);
end;

end.
