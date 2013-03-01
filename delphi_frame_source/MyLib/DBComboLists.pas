unit DBComboLists;

{
  %ComboLists : 包含几个下拉框
}
(*****   Code Written By Huang YanLai   *****)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,LibMessages,ComWriUtils, DB, DBTables, dbctrls, ComboLists;

type
  // %TCustomCodeValues : 包含一系列的Code-Value组(代码表)
  // %TDBCodeValues : 通过Query从数据库获得Code-Value组
  TDBCodeValues = class(TCustomCodeValues)
  private
    FQuery: TQuery;
    FSQL: TStrings;
    FActive: boolean;
    procedure   SetQuery(const Value: TQuery);
    procedure   SetSQL(const Value: TStrings);
    procedure   SetActive(const Value: boolean);
    procedure   LoadFromQuery;
  protected
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure   Loaded; override;
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    procedure   Update;
  published
    property    NameCaseSen;
    property    ValueCaseSen;
    property    IsCodeSorted;
    property    Active : boolean read FActive write SetActive;
    property    SQL : TStrings read FSQL write SetSQL;
    property    Query : TQuery read FQuery write SetQuery;
  end;

  // %TDBComboBoxList : 数据敏感的TComboList，数据库保存Code,控件中显示/选择Value
  TDBComboBoxList = class(TComboList)
  private
    FDataLink : TFieldDataLink;
    procedure   CMExit(var Message: TCMExit); message CM_EXIT;
    procedure   CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
    function    GetDataField: string;
    function    GetDataSource: TDataSource;
    function    GetField: TField;
    function    GetReadOnly: Boolean;
    procedure   SetDataField(const Value: string);
    procedure   SetDataSource(const Value: TDataSource);
    procedure   SetReadOnly(const Value: Boolean);

    procedure   UpdateData(Sender: TObject);
    procedure   DataChange(Sender: TObject);
    procedure   EditingChange(Sender: TObject);
  protected
    procedure   Change; override;
    procedure   Click; override;
    procedure   Loaded; override;
    procedure   Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure   WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    function    ExecuteAction(Action: TBasicAction): Boolean; override;
    function    UpdateAction(Action: TBasicAction): Boolean; override;
    property    Field: TField read GetField;
  published
    property    DataField: string read GetDataField write SetDataField;
    property    DataSource: TDataSource read GetDataSource write SetDataSource;
    property    ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
  end;

implementation

{ TDBCodeValues }

constructor TDBCodeValues.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSQL := TSTringList.Create;
end;

destructor TDBCodeValues.Destroy;
begin
  FSQL.free;
  inherited Destroy;
end;

procedure TDBCodeValues.Loaded;
begin
  inherited Loaded;
  if FActive and (FQuery<>nil) then
    LoadFromQuery;
end;

procedure TDBCodeValues.LoadFromQuery;
begin
  try
    Query.Active := false;
    Query.SQL.Clear;
    Query.SQL.Assign(SQL);
    Query.Active := true;

    Update;
    FActive := true;
  except
    FActive := false;
  end;
end;

procedure TDBCodeValues.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (AComponent=FQuery) and (Operation=opRemove) then
    FQuery:=nil;
end;

procedure TDBCodeValues.SetActive(const Value: boolean);
begin
  if FActive <> Value then
  begin
    if Value then
    begin
      if not (csLoading in ComponentState) and (Query<>nil) then
        LoadFromQuery
      else FActive := true;  
    end
    else  FActive:=false;
  end;
end;

procedure TDBCodeValues.SetQuery(const Value: TQuery);
begin
  if FQuery <> Value then
  begin
    FQuery := Value;
    if FQuery<>nil then FQuery.FreeNotification(self);
  end;
end;

procedure TDBCodeValues.SetSQL(const Value: TStrings);
begin
  if FSQL<>Value then
    FSQL.Assign(Value);
end;

procedure TDBCodeValues.Update;
begin
  FMap.Clear;
  if Query<>nil then
  while not Query.eof do
  begin
    FMap.Add(Query.Fields[0].AsString,
             Query.Fields[1].AsString  );
    Query.next;
  end;
  PropChanged;
end;

{ TDBComboBoxList }

constructor TDBComboBoxList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
  FDataLink.OnEditingChange := EditingChange;
end;

destructor TDBComboBoxList.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TDBComboBoxList.Change;
begin
  FDataLink.Edit;
  inherited Change;
  FDataLink.Modified;
end;

procedure TDBComboBoxList.Click;
begin
  FDataLink.Edit;
  inherited Click;
  FDataLink.Modified;
end;

procedure TDBComboBoxList.CMExit(var Message: TCMExit);
begin
  try
    FDataLink.UpdateRecord;
  except
    SelectAll;
    SetFocus;
    raise;
  end;
  inherited;
end;

procedure TDBComboBoxList.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

function TDBComboBoxList.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

function TDBComboBoxList.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

function TDBComboBoxList.GetField: TField;
begin
  Result := FDataLink.Field;
end;

function TDBComboBoxList.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TDBComboBoxList.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

procedure TDBComboBoxList.SetDataSource(const Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

procedure TDBComboBoxList.SetReadOnly(const Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

procedure TDBComboBoxList.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then DataChange(Self);
end;

procedure TDBComboBoxList.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TDBComboBoxList.ExecuteAction(Action: TBasicAction): Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TDBComboBoxList.UpdateAction(Action: TBasicAction): Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

procedure TDBComboBoxList.WndProc(var Message: TMessage);
begin
  if not (csDesigning in ComponentState) then
    case Message.Msg of
      WM_COMMAND:
        if TWMCommand(Message).NotifyCode = CBN_SELCHANGE then
          if not FDataLink.Edit then
          begin
            if Style <> csSimple then
              PostMessage(Handle, CB_SHOWDROPDOWN, 0, 0);
            Exit;
          end;
      CB_SHOWDROPDOWN:
        if Message.WParam <> 0 then FDataLink.Edit else
          if not FDataLink.Editing then DataChange(Self); {Restore text}
    end;
  inherited WndProc(Message);
end;

procedure TDBComboBoxList.DataChange(Sender: TObject);
begin
  if not (Style = csSimple) and DroppedDown then Exit;
  if FDataLink.Field <> nil then
    Code := FDataLink.Field.text;
end;

procedure TDBComboBoxList.EditingChange(Sender: TObject);
begin
  //SetEditReadOnly;
end;

procedure TDBComboBoxList.UpdateData(Sender: TObject);
begin
  FDataLink.Field.Text := Code;
end;

end.
