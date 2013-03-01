unit PDBTimeEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, PTimeEdit,dbctrls,db;

type
  TPDBTimeEdit = class(TPTimeEdit)
  private
    { Private declarations }
    FDataLink: TFieldDataLink;
    FBackText: string;
  protected
    { Protected declarations }
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
    procedure SetText(Value: string); override;
  published
    { Published declarations }
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
  end;

procedure Register;

implementation

constructor TPDBTimeEdit.Create(AOwner : TComponent);
begin
     inherited Create(AOwner);
     FBackText := '';
     FDataLink := TFieldDataLink.Create ;
     FDataLink.Control := Self;
     FDataLink.OnDataChange := DataChange;
     FDataLink.OnUpDateData := UpdateData;
     FDataLink.OnActiveChange := ActiveChange;
     Enabled := True;
end;

destructor TPDBTimeEdit.Destroy;
begin
     FDataLink.Free;
     FDataLink := nil;
     inherited Destroy;
end;

procedure TPDBTimeEdit.SetDataSource(Value : TDataSource);
begin
     FDataLink.DataSource := Value;
end;

procedure TPDBTimeEdit.SetDataField(Value : string);
begin
     try FDataLink.FieldName := Value;
     finally
//            Enabled := FDataLink.Active and (FDataLink.Field <> nil) and (not FDataLink.Field.ReadOnly);
     end;
end;

procedure TPDBTimeEdit.ActiveChange (Sender : TObject);
begin
end;

procedure TPDBTimeEdit.UpdateData (Sender : TObject);
var ok : Boolean;
    time : TDateTime;
begin
     ok := True;
     try
        time := strtotime(text);
     except
           ok := False;
     end;
     if (FDataLink.Field <> nil) and ok then// and (FDataLink.Field is  TDateField) then
        FDataLink.Field.AsString := text;

end;

procedure TPDBTimeEdit.DataChange(sender : TObject);
begin
     if (FDataLink.Field <> nil) then //and (FDataLink.Field is TDateField) then
        text := (FDataLink.Field.AsString)
     else
         text := '';
end;

function TPDBTimeEdit.GetDataField : string;
begin
     Result := FDataLink.FieldName;
end;

function TPDBTimeEdit.GetDataSource : TDataSource;
begin
     Result := FDataLink.DataSource;
end;

function TPDBTimeEdit.GetField : TField;
begin
     Result := FDataLink.Field;
end;

procedure TPDBTimeEdit.CMExit(var Message : TCMExit);
begin
     JudgeText;
     FBackText := text;
     FDataLink.Edit;
     Text := FBackText;
     FDataLink.Modified;
     try
        FDataLink.UpdateRecord ;
     except
           SetFocus;
           raise;
     end;
	 inherited;
end;

procedure TPDBTimeEdit.SetText(Value: string);
begin
     if Value <> Text then
     begin
          FDataLink.Edit;
          Text := Value;
          JudgeText;
          FDataLink.Modified;
          try
             FDataLink.UpdateRecord ;
          except
                SetFocus;
                raise;
          end;
     end;
end;

procedure Register;
begin
     RegisterComponents('PosControl2', [TPDBTimeEdit]);
end;

end.
