unit PDBNormalDateEdit;

interface
            
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ToolEdit, PDateEdit,dbctrls,db;

type
  TPDBNormalDateEdit = class(TPDateEdit)
  private
    FDataLink : TFieldDataLink;
  protected
    { Protected declarations }
    function AcceptPopup(var Value: Variant): Boolean; override;
    function GetField : TField;
    function GetDataField : string;
    function GetDataSource : TDataSource;

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
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
  end;

procedure Register;

implementation

constructor TPDBNormalDateEdit.Create(AOwner : TComponent);
begin
     inherited Create(AOwner);
     FDataLink := TFieldDataLink.Create ;
     FDataLink.Control := Self;
     FDataLink.OnDataChange := DataChange;
     FDataLink.OnUpDateData := UpdateData;
     FDataLink.OnActiveChange := ActiveChange;
     Enabled := True;
end;

destructor TPDBNormalDateEdit.Destroy;
begin
     FDataLink.Free;
     FDataLink := nil;
     inherited Destroy;
end;

procedure TPDBNormalDateEdit.SetDataSource(Value : TDataSource);
begin
     FDataLink.DataSource := Value;
//     Enabled := FDataLink.Active and (FDataLink.Field <> nil) and (not FDataLink.Field.ReadOnly);
end;

procedure TPDBNormalDateEdit.SetDataField(Value : string);
begin
     try FDataLink.FieldName := Value;
     finally
//            Enabled := FDataLink.Active and (FDataLink.Field <> nil) and (not FDataLink.Field.ReadOnly);
     end;
end;

procedure TPDBNormalDateEdit.ActiveChange (Sender : TObject);
begin
//     Enabled := FDataLink.Active and (FDataLink.Field <> nil) and (not FDataLink.Field.ReadOnly);
end;

procedure TPDBNormalDateEdit.UpdateData (Sender : TObject);
var ok : Boolean;
    date : TDateTime;
begin
     ok := True;
     try
        date := StrToDate(text);
     except
           ok := False;
     end;
     if (FDataLink.Field <> nil) and ok then// and (FDataLink.Field is  TDateField) then
        FDataLink.Field.AsString := text;

end;

procedure TPDBNormalDateEdit.DataChange(sender : TObject);
begin
     if (FDataLink.Field <> nil) then //and (FDataLink.Field is TDateField) then
        text := FDataLink.Field.AsString
     else
         text := '';
end;

function TPDBNormalDateEdit.GetDataField : string;
begin
     Result := FDataLink.FieldName;
end;

function TPDBNormalDateEdit.GetDataSource : TDataSource;
begin
     Result := FDataLink.DataSource;
end;

function TPDBNormalDateEdit.GetField : TField;
begin
     Result := FDataLink.Field;
end;

function TPDBNormalDateEdit.AcceptPopup(var Value: Variant): Boolean;
begin
     FDataLink.Edit;
     Result := inherited AcceptPopup(Value);
     FDataLink.Modified;
end;

procedure TPDBNormalDateEdit.CMExit(var Message : TCMExit);
begin
 	 try
       		 FDataLink.UpdateRecord ;
		//UpdateData;
	 except
		SetFocus;
		raise;
     end;
	 inherited;
end;

procedure Register;
begin
  RegisterComponents('Poscontrol2', [TPDBNormalDateEdit]);
end;

end.
