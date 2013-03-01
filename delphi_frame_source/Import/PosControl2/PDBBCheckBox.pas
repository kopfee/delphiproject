unit PDBBCheckBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,dbctrls,db;

type
  TPDBBCheckBox = class(TCustomCheckBox)
  private
    { Private declarations }
    FDataLink: TFieldDataLink;
  protected
    { Protected declarations }
    function GetDataSource: TDataSource;
    function GetDataField: string;
    function GetField : TField;
    function GetReadOnly: Boolean;

    procedure ActiveChange(Sender: TObject);
    procedure Click; override;
    procedure DataChange(Sender: TObject);
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetDataField(value : string);
    procedure SetDataSource( Value : TDataSource);
    procedure SetReadOnly(Value: Boolean);
    procedure UpdateData(Sender: TObject);
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
   public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Field: TField read GetField;
  published
    { Published declarations }
    property Alignment;
    property AllowGrayed;
    property Caption;
    property Checked;
    property Color;
    property Ctl3D;
    property DataSource : TDataSource read GetDataSource write SetDataSource;
    property DataField: string read GetDataField write SetDataField ;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ShowHint;
    property State;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
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

constructor TPDBBCheckBox.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     FDataLink := TFieldDataLink.Create;
     FDataLink.Control := self;
     FDataLink.OnDataChange := DataChange;
     FDataLink.OnUpdateData := UpdateData;
     FDataLink.OnActiveChange := ActiveChange;
     Font.Size := 11;
     Font.Name := 'ËÎÌו';
     Enabled := False;
end;

destructor TPDBBCheckBox.Destroy ;
begin
     FDataLink.Free;
     FDataLink := nil;
     inherited Destroy;
end;

function TPDBBCheckBox.GetDataField : string;
begin
     Result := FDataLink.FieldName;
end;

function TPDBBCheckBox.GetDataSource : TDataSource;
begin
     Result := FDataLink.DataSource ;
end;

function TPDBBCheckBox.GetField : TField;
begin
     Result := FDataLink.Field;
end;

function TPDBBCheckBox.GetReadOnly: Boolean;
begin
     Result := FDataLink.ReadOnly;
end;

procedure TPDBBCheckBox.ActiveChange(Sender: TObject) ;
begin
     Enabled := FDataLink.Active and (FDataLink.Field <> nil) and not (FDataLink.Field.ReadOnly);
end;

procedure TPDBBCheckBox.Click ;
begin
     if Self.ReadOnly then  exit;
     FDataLink.Edit ;
     inherited;
     FDataLink.Modified;
     try
        FDataLink.UpdateRecord;
     except
        SetFocus;
        raise;
     end;
end;

procedure TPDBBCheckBox.DataChange(Sender: TObject);
begin
     if (FDataLink.Field <> nil) then
        if (FDataLink.Field.AsInteger) = 0 then
           self.Checked := False
        else
            Self.Checked := True;
end;

procedure TPDBBCheckBox.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
     if AHeight < 20 then
        AHeight := 20;
     if AHeight >50 then
        AHeight := 50;
     inherited;
end;

procedure TPDBBCheckBox.SetDataField(Value: string);
begin
     try
        FDataLink.FieldName := Value;
     finally
        Enabled := FDataLink.Active and (FDataLink.Field <> nil) and not FDataLink.Field.ReadOnly;
     end;
end;

procedure TPDBBCheckBox.SetDataSource(Value: TDataSource);
begin
     FDataLink.Datasource := Value;
     Enabled := FDataLink.Active and (FDataLink.Field <> nil) and (not FDataLink.Field.ReadOnly);
end;

procedure TPDBBCheckBox.SetReadOnly(Value: Boolean);
begin
     FDataLink.ReadOnly := Value;
end;

procedure TPDBBCheckBox.UpdateData(Sender: TObject);
begin
     if (FDataLink.Field <> nil) then
        if not self.Checked then
           FDataLink.Field.AsInteger := 0
        else
           FDataLink.Field.AsInteger := 1;
end;

procedure TPDBBCheckBox.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
     if readonly then
          exit
     else
         inherited;
end;

procedure TPDBBCheckBox.WMLButtonDown(var Message: TWMLButtonDown);
begin
     if readonly then
          exit
     else
         inherited;
end;

procedure Register;
begin
     RegisterComponents('PosControl2', [TPDBBCheckBox]);
end;

end.

