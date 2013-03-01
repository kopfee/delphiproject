unit PDBCustomMemonoEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ToolEdit, PDateEdit,dbctrls,db,PBaseMemoEdit;

type
  TPDBCustomMemonoEdit = class(TPBaseMemoEdit)
  private
    FCustomDataLink : TFieldDataLink;
  protected
    { Protected declarations }
    function GetDataField : string;
    function GetDataSource : TDataSource;
    function GetField : TField;
    procedure ActiveChange(Sender : TObject);
    procedure CMExit(var Message : TCMExit); message CM_EXIT;
    procedure DataChange(Sender : TObject);
    procedure SetDataField(Value : string);
    procedure SetDataSource(Value : TDataSource);
    procedure UpdateData(Sender : TObject);
  public
    { Public declarations }
    Constructor Create(AOwner: TComponent) ; override;
    Destructor Destroy; override;
    property Field: TField read GetField;
  published
    { Published declarations }
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property CharCase;
    property Color;
    property Ctl3D;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
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

implementation

constructor TPDBCustomMemonoEdit.Create(AOwner : TComponent);
begin
     inherited Create(AOwner);
     FCustomDataLink := TFieldDataLink.Create ;
     FCustomDataLink.Control := Self;
     FCustomDataLink.OnDataChange := DataChange;
     FCustomDataLink.OnUpDateData := UpdateData;
     FCustomDataLink.OnActiveChange := ActiveChange;
     Enabled := False;
end;

destructor TPDBCustomMemonoEdit.Destroy;
begin
     FCustomDataLink.Free;
     FCustomDataLink := nil;
     inherited Destroy;
end;

procedure TPDBCustomMemonoEdit.SetDataSource(Value : TDataSource);
begin
     FCustomDataLink.DataSource := Value;
     Enabled := FCustomDataLink.Active and (FCustomDataLink.Field <> nil) and (not FCustomDataLink.Field.ReadOnly);
     Enabled := Enabled;
end;

procedure TPDBCustomMemonoEdit.SetDataField(Value : string);
begin
     try FCustomDataLink.FieldName := Value;
     finally
            Enabled := FCustomDataLink.Active and (FCustomDataLink.Field <> nil) and (not FCustomDataLink.Field.ReadOnly);
            Enabled := Enabled;
     end;
end;

procedure TPDBCustomMemonoEdit.ActiveChange (Sender : TObject);
begin
     Enabled := FCustomDataLink.Active and (FCustomDataLink.Field <> nil) and (not FCustomDataLink.Field.ReadOnly);
     Enabled := Enabled;
end;

procedure TPDBCustomMemonoEdit.UpdateData (Sender : TObject);
begin
     if (FCustomDataLink.Field <> nil)then
     begin
          FCustomDataLink.Field.AsString := Text;
     end;
end;

procedure TPDBCustomMemonoEdit.DataChange(sender : TObject);
begin
     if (FCustomDataLink.Field <> nil) then
     begin
          text := FCustomDataLink.Field.AsString;
     end
     else
          text := '';
end;

function TPDBCustomMemonoEdit.GetDataField : string;
begin
     Result := FCustomDataLink.FieldName;
end;

function TPDBCustomMemonoEdit.GetDataSource : TDataSource;
begin
     Result := FCustomDataLink.DataSource;
end;

function TPDBCustomMemonoEdit.GetField : TField;
begin
     Result := FCustomDataLink.Field;
end;


procedure TPDBCustomMemonoEdit.CMExit(var Message : TCMExit);
begin
     BackText;
     FCustomDataLink.Edit;
     inherited;
     FCustomDataLink.Modified;

     try
     	 FCustomDataLink.UpdateRecord ;
     except
     	SetFocus;
     	raise;
     end;
end;


end.
