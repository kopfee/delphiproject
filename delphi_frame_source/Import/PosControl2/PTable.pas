unit PTable;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBClient, dbtables, bdeprov, LookupControls;

type
  TPTable = class(TClientDataSet)
  private
    { Private declarations }
    FQuery: TQuery;
    FProvider: TProvider;
    FEditParams: TParams;

    FDatabaseName: string;
    FTableName: string;

    procedure SetDatabaseName(Value: string);
    procedure SetTableName(Value: string);
  protected
    { Protected declarations }
    procedure OpenCursor(InfoQuery: Boolean); override;
    procedure InternalRefresh; override;
    procedure InternalDelete; override;
    procedure InternalPost; override;
    procedure InternalEdit; override;
    procedure Post; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
  published
    { Published declarations }
    property DatabaseName:string read FDatabaseName write SetDatabaseName;
    property TableName:string read FTableName write SetTableName;
  end;

procedure Register;

implementation

procedure TPTable.SetDatabaseName(Value: string);
begin
  if csLoading in ComponentState then
    FDatabaseName := Value
  else
    if Active then
    begin
      raise EOperationInvalid.Create('Can''t change DatabaseName while Active is True.');
      exit;
    end
    else
      FDatabaseName := Value;
end;

procedure TPTable.SetTableName(Value: string);
begin
  if csLoading in ComponentState then
    FTableName := Value
  else
    if Active then
    begin
      raise EOperationInvalid.Create('Can''t change TableName while Active is True.');
      exit;
    end
    else
      FTableName := Value;
end;

constructor TPTable.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FProvider := TProvider.Create(Self);
  FQuery := TQuery.Create(Self);
  FEditParams := TParams.Create;
end;

destructor TPTable.Destroy;
begin
  FEditParams.Free;
  FQuery.Free;
  FProvider.Free;

  inherited Destroy;
end;

procedure TPTable.OpenCursor(InfoQuery: Boolean);
begin
  FQuery.Close;
  if FQuery.DatabaseName <> FDatabaseName then
    FQuery.DatabaseName := FDatabaseName;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('Select * from '+FTableName);
  FQuery.Open;
  FProvider.DataSet := FQuery;
  Provider := FProvider.Provider;
  inherited OpenCursor(InfoQuery);
end;

procedure TPTable.InternalRefresh;
begin
  CancelUpdates;
  FQuery.Close;
  if FQuery.DatabaseName <> FDatabaseName then
    FQuery.DatabaseName := FDatabaseName;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('Select * from '+FTableName);
  FQuery.Open;
  FProvider.DataSet := FQuery;
  Provider := FProvider.Provider;
  inherited InternalRefresh;
end;

procedure TPTable.InternalDelete;
var
  i:integer;
begin
  if IndexFieldCount > 0 then
  begin
    if not IsEmpty then
    begin
      FQuery.Close;
      FQuery.SQL.Clear;
      FQuery.SQL.Add('Delete from '+FTableName+' where ');
      for i := 0 to IndexFieldCount-1 do
      begin
        if IndexFields[i].IsNull then
        begin
          FQuery.SQL.Add('('+IndexFields[i].FieldName+' is NULL) ');
        end
        else
        begin
          FQuery.SQL.Add(IndexFields[i].FieldName+'=:'+IndexFields[i].FieldName);
          FQuery.ParamByName(IndexFields[i].FieldName).DataType
            := IndexFields[i].DataType;
          FQuery.ParamByName(IndexFields[i].FieldName).Value
            := IndexFields[i].Value;
        end;
        if i <> IndexFieldCount-1 then FQuery.SQL.Add(' and ');
      end;
      FQuery.ExecSQL;
    end;
    inherited InternalDelete;
  end
  else
    Showmessage('IndexFieldName not specialized!');
end;

procedure TPTable.InternalEdit;
var
  i:integer;
  NewParam:TParam;
begin
  FEditParams.Clear;
  for  i := 0  to IndexFieldCount-1 do
    with FEditParams do
    begin
      NewParam := TParam.Create(FEditParams,ptUnknown);
      NewParam.Name := 'OLD_'+IndexFields[i].FieldName;
      if IndexFields[i].IsNull then
        NewParam.Clear
      else
      begin
        NewParam.DataType := IndexFields[i].DataType;
        NewParam.Value := IndexFields[i].Value;
      end;
    end;
end;

procedure TPTable.Post;
begin
  try
    inherited Post;
  except
    on E: EDatabaseError do
    begin
      if E.Message <> 'Dataset not in edit or insert mode' then
         raise;
    end;
  end;
end;

procedure TPTable.InternalPost;
var
  i : integer;
  Commer : Boolean;
  NotNullCount : integer;
begin
  case State of
    dsInsert : begin
                 FQuery.Close;
                 FQuery.SQL.Clear;
                 FQuery.SQL.Add('Insert into '+FTableName+' (');

                 NotNullCount := 0;
                 Commer := False;
                 for i := 0 to FieldCount-1 do
                 begin
                   if not Fields[i].IsNull then
                   begin
                     if Commer then FQuery.SQL.Add(',');
                     FQuery.SQL.Add(Fields[i].FieldName);
                     Commer := True;
                     Inc(NotNullCount);
                   end;
                 end;
                 FQuery.SQL.Add(') values ( ');

                 if NotNullCount >0 then
                 begin
                   Commer := False;
                   for i := 0 to FieldCount-1 do
                   begin
                     if not Fields[i].IsNull then
                     begin
                       if Commer then FQuery.SQL.Add(',');
                       FQuery.SQL.Add(':'+Fields[i].FieldName);
                       FQuery.ParamByName(Fields[i].FieldName).DataType
                         := Fields[i].DataType;
                       FQuery.ParamByName(Fields[i].FieldName).Value
                         := Fields[i].Value;
                       Commer := True;
                     end;
                   end;
                   FQuery.SQL.Add(')');
                   FQuery.ExecSQL;
                 end
                 else
                   Exit;
               end;
    dsEdit : begin
                 FQuery.Close;
                 FQuery.SQL.Clear;
                 FQuery.Params.Clear;
                 FQuery.SQL.Add('Update '+FTableName+' Set ');

                 Commer := False;
                 for i := 0 to FieldCount-1 do
                 begin
                   if Commer then FQuery.SQL.Add(',');
                   if Fields[i].IsNull then
                   begin
                     FQuery.SQL.Add(Fields[i].FieldName+'= NULL ');
                   end
                   else
                   begin
                     FQuery.SQL.Add(Fields[i].FieldName+'=:'+Fields[i].FieldName);
                     FQuery.ParamByName(Fields[i].FieldName).DataType
                       := Fields[i].DataType;
                     FQuery.ParamByName(Fields[i].FieldName).Value
                       := Fields[i].Value;
                   end;
                   Commer := True;
                 end;

                 FQuery.SQL.Add(' where ');
                 Commer := False;
                 for  i := 0  to IndexFieldCount-1 do
                 begin
                   if Commer then FQuery.SQL.Add(' and ');
                   Commer := True;
                   if FEditParams.ParamByName('OLD_'+IndexFields[i].FieldName).IsNull then
                   begin
                     FQuery.SQL.Add('('+IndexFields[i].FieldName+' is NULL) ');
                   end
                   else
                   begin
                     FQuery.SQL.Add(IndexFields[i].FieldName+'=:OLD_'+Fields[i].FieldName);
                     FQuery.ParamByName('OLD_'+IndexFields[i].FieldName).DataType
                       := FEditParams.ParamByName('OLD_'+IndexFields[i].FieldName).DataType;
                     FQuery.ParamByName('OLD_'+IndexFields[i].FieldName).Value
                       := FEditParams.ParamByName('OLD_'+IndexFields[i].FieldName).Value;
                   end;
                 end;

                 FQuery.ExecSQL;
             end;
  end;
  inherited InternalPost;
end;

procedure Register;
begin
  RegisterComponents('PosControl', [TPTable]);
end;

end.
