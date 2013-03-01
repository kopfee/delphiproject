unit PDBFCheckBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,dbctrls,db;

type
  TPDBFCheckBox = class(TCustomCheckBox)
  private
    { Private declarations }
    FDataLink: TFieldDataLink;
    FFalseValue: char;
    FTrueValue: char;
  protected
    { Protected declarations }
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField : TField;
    function GetReadOnly: Boolean;

    procedure ActiveChange(Sender: TObject);
    procedure Click; override;
    procedure DataChange(Sender: TObject);
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetDataField(value : string);
    procedure SetDataSource( Value : TDataSource);
    procedure SetFalseValue(Value: char);
    procedure SetReadOnly(Value: Boolean);
    procedure SetTrueValue(Value: char);
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
    property FalseValue: char read FFalseValue write SetFalseValue;
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
    property TrueValue: char read FTrueValue write SetTrueValue;
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

constructor TPDBFCheckBox.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     FDataLink := TFieldDataLink.Create;
     FDataLink.Control := self;
     FDataLink.OnDataChange := DataChange;
     FDataLink.OnUpdateData := UpdateData;
     FDataLink.OnActiveChange := ActiveChange;
     Enabled := False;
     ReadOnly := False;
     ParentFont := False;
     Font.Size := 11;
     Font.Name := 'ËÎÌו';
     FTrueValue := 'T';
     FFalseValue := 'F';
end;

destructor TPDBFCheckBox.Destroy ;
begin
     FDataLink.Free;
     fDataLink := nil;
     inherited Destroy;
end;

function TPDBFCheckBox.GetDataField : string;
begin
     Result := FDataLink.FieldName;
end;

procedure TPDBFCheckBox.SetDataSource(Value: TDataSource);
begin
     FDataLink.Datasource := Value;
     Enabled := FDataLink.Active and (FDataLink.Field <> nil) and not FDataLink.Field.ReadOnly;
end;

function TPDBFCheckBox.GetDataSource : TDataSource;
begin
     Result := FDataLink.DataSource ;
end;

procedure TPDBFCheckBox.SetDataField(Value: string);
begin
     try
        FDataLink.FieldName := Value;
     finally
        Enabled := FDataLink.Active and (FDataLink.Field <> nil) and not FDataLink.Field.ReadOnly;
     end;
end;

function TPDBFCheckBox.GetField : TField;
begin
     Result := FDataLink.Field;
end;

procedure TPDBFCheckBox.ActiveChange(Sender: TObject) ;
begin
     Enabled := FDataLink.Active and (FDataLink.Field <> nil) and not (FDataLink.Field.ReadOnly);
end;

procedure TPDBFCheckBox.Click ;
begin
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

procedure TPDBFCheckBox.UpdateData(Sender: TObject);
begin
     if (FDataLink.Field <> nil) then
        if self.Checked then
           FDataLink.Field.AsString := FTrueValue
        else
           FDataLink.Field.AsString := FFalseValue;
end;

procedure TPDBFCheckBox.DataChange(Sender: TObject);
begin
     if (FDataLink.Field <> nil) then
        if (FDataLink.Field.AsString) = (FTrueValue) then
           Checked := True
        else
            Checked := False;
end;

procedure TPDBFCheckBox.SetTrueValue(Value: char);
begin
     FTrueValue := Value;
end;

procedure TPDBFCheckBox.SetFalseValue(Value: char);
begin
     FFalseValue := Value;
end;

function TPDBFCheckBox.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TPDBFCheckBox.SetReadOnly(Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

procedure TPDBFCheckBox.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
     if readonly then
          exit
     else
         inherited;
end;

procedure TPDBFCheckBox.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
     if AHeight < 20 then
        AHeight := 20;
     if AHeight >50 then
        AHeight := 50;
     inherited;
end;

procedure TPDBFCheckBox.WMLButtonDown(var Message: TWMLButtonDown);
begin
     if readonly then
          exit
     else
         inherited;
end;

procedure Register;
begin
     RegisterComponents('PosControl2', [TPDBFCheckBox]);
end;

end.
