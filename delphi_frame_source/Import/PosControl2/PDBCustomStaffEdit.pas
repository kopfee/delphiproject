unit PDBCustomStaffEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ToolEdit, PDateEdit,dbctrls,db,PNumEdit;

type
  TPDBCustomStaffEdit = class(TEdit)
  private
    FBErn : string;
    FCustomStaffDataLink : TFieldDataLink;
  protected
    { Protected declarations }
    function GetDataField : string;
    function GetDataSource : TDataSource;
    function GetErn: string;
    function GetField : TField;
    function GetWholeErn: string;
    procedure ActiveChange(Sender : TObject);
    procedure CMExit(var Message : TCMExit); message CM_EXIT;
    procedure change; override;
    procedure DataChange(Sender : TObject);
    procedure SetDataField(Value : string);
    procedure SetDataSource(Value : TDataSource);
    procedure SetErn(Value : string);
    procedure SetWholeErn(Value : string);
    procedure UpdateData(Sender : TObject);
  public
    { Public declarations }
    Constructor Create(AOwner: TComponent) ; override;
    Destructor Destroy; override;
    property Field: TField read GetField;
    property WholeErn : string read GetWholeErn write SetWholeErn;
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
    property Ern: string read GetErn write setErn;
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

procedure Register;

implementation

constructor TPDBCustomStaffEdit.Create(AOwner : TComponent);
begin
     inherited Create(AOwner);
     FCustomStaffDataLink := TFieldDataLink.Create ;
     FCustomStaffDataLink.Control := Self;
     FCustomStaffDataLink.OnDataChange := DataChange;
     FCustomStaffDataLink.OnUpDateData := UpdateData;
     FCustomStaffDataLink.OnActiveChange := ActiveChange;
     Font.Size := 9;
     Font.Name := 'ËÎÌו';
     Enabled := False;
end;

destructor TPDBCustomStaffEdit.Destroy;
begin
     FCustomStaffDataLink.Free;
     FCustomStaffDataLink := nil;
     inherited Destroy;
end;

procedure TPDBCustomStaffEdit.SetDataSource(Value : TDataSource);
begin
     FCustomStaffDataLink.DataSource := Value;
     Enabled := FCustomStaffDataLink.Active and (FCustomStaffDataLink.Field <> nil) and (not FCustomStaffDataLink.Field.ReadOnly);
     Enabled := Enabled;
end;

procedure TPDBCustomStaffEdit.SetDataField(Value : string);
begin
     try FCustomStaffDataLink.FieldName := Value;
     finally
            Enabled := FCustomStaffDataLink.Active and (FCustomStaffDataLink.Field <> nil) and (not FCustomStaffDataLink.Field.ReadOnly);
            Enabled := Enabled;
     end;
end;

procedure TPDBCustomStaffEdit.ActiveChange (Sender : TObject);
begin
     Enabled := FCustomStaffDataLink.Active and (FCustomStaffDataLink.Field <> nil) and (not FCustomStaffDataLink.Field.ReadOnly);
     Enabled := Enabled;
end;

procedure TPDBCustomStaffEdit.UpdateData (Sender : TObject);
begin
     if (FCustomStaffDataLink.Field <> nil)then
     begin
          FCustomStaffDataLink.Field.AsString := WholeErn;
     end;

end;

function  TPDBCustomStaffEdit.GetErn : string;
begin
     Result := Text;
end;

procedure TPDBCustomStaffEdit.SetErn(Value : string);
begin
     if Text <> Value then
        Text := Value;
end;

function TPDBCustomStaffEdit.GetWholeErn: string;
begin
     Result := FBErn + Text;
end;

procedure TPDBCustomStaffEdit.SetWholeErn(Value : string);
begin
     FCustomStaffDataLink.Edit;

     FBErn := Value[1]+ Value[2];
     text := pchar(pointer(integer(pointer(Value))+2));
     FCustomStaffDataLink.Modified;
end;

procedure TPDBCustomStaffEdit.DataChange(sender : TObject);
var temp : string;
begin
     if (FCustomStaffDataLink.Field <> nil) then //and (FCustomStaffDataLink.Field is TDateField) then
     begin
          temp := FCustomStaffDataLink.Field.AsString;
          if temp <> '' then  WholeErn := temp
          else
          begin
               FBErn := '';
               text := '';
          end
     end
     else
     begin
          FBErn := '';
          text := '';
     end;
end;

function TPDBCustomStaffEdit.GetDataField : string;
begin
     Result := FCustomStaffDataLink.FieldName;
end;

function TPDBCustomStaffEdit.GetDataSource : TDataSource;
begin
     Result := FCustomStaffDataLink.DataSource;
end;

function TPDBCustomStaffEdit.GetField : TField;
begin
     Result := FCustomStaffDataLink.Field;
end;

procedure TPDBCustomStaffEdit.change;
begin
  FCustomStaffDataLink.Modified;
  inherited change;
end;

procedure TPDBCustomStaffEdit.CMExit(var Message : TCMExit);
begin
   {inherited;
 	 try
     FCustomStaffDataLink.UpdateRecord ;
	 except
     SetFocus;
     raise;
   end;}
  try
    FCustomStaffDataLink.UpdateRecord;
  except
    SelectAll;
    SetFocus;
    raise;
  end;
  //SetFocused(False);
  //CheckCursor;
  DoExit;
end;

procedure Register;
begin
     RegisterComponents('PosControl2', [TPDBCustomStaffEdit]);
end;

end.
