unit PEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TPEdit = class(TCustomEdit)
  private
    { Private declarations }
  protected
    { Protected declarations }
    function GetRdOnly:Boolean;
    procedure SetRdOnly(Value: Boolean);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property CharCase;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property OEMConvert;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
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

constructor TPEdit.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     self.Font.Size := 9;
     self.Font.Name := 'ËÎÌו';
     self.ParentFont := False;
end;

function TPEdit.GetRdOnly:Boolean;
begin
     Result := ReadOnly;
end;

procedure TPEdit.SetRdOnly(Value: Boolean);
begin
     ReadOnly := Value;
     if Value then
        Color := clSilver
     else
         Color := clWhite;
end;

procedure Register;
begin
     RegisterComponents('PosControl2', [TPEdit]);
end;

end.

