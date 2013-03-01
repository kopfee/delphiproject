unit PropertyEditor;

interface

uses
  SysUtils,dsgnintf,classes, extctrls, stdctrls, LookupControls, controls,extdlgs, typinfo,
  DbTables, DBLists, DB, QueryDialog, DQueryDialog, PTable, PLabelPanel,PKindEdit,
  PGoodsEdit, PRelationEdit,PStaffEdit,PDBCounterEdit,PDBStaffEdit,
  PLookupEdit ,PDBLookupEdit  ,PLookupCombox  ,PDBLookupCombox,
  Pimage,PBitBtn,PDBEdit,PDBVendorEdit,PDBKindEdit,PDBMemonoEdit,
  PCounterEdit,PMemoEdit;
procedure Register;

implementation

{ TFilenameProperty}

type
  TPPicFileNameProperty = class (TStringProperty)
    public
      function GetAttributes: TPropertyAttributes; override;
      procedure Edit; override;
    end;

function TPPicFileNameProperty.GetAttributes: TPropertyAttributes;
begin
     Result := [paDialog];
end;

procedure TPPicFileNameProperty.Edit ;
var dlg: TOpenPictureDialog;
begin
     dlg := TOpenPictureDialog.Create(nil);
     try
     if dlg.Execute then
        SetValue(dlg.FileName);
     finally
        dlg.Free;
     end;
end;

{ TPSubFieldControlProperty }

type
TPUpperProperty = class (TStringProperty)
    public
          function GetValue: string; override;
          procedure SetValue(const Value: string); override;
    end;

function TPUpperProperty.GetValue : string;
begin
     Result := UpperCase(inherited GetValue);
end;

procedure TPUpperProperty.SetValue( const Value: string);
begin
     inherited SetValue(UpperCase(Value));
end;

type

  TPSubFieldControlProperty = class(TComponentProperty)
    procedure GetValues(Proc: TGetStrProc); override;
  end;


procedure TPSubFieldControlProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  Component: TComponent;
begin
  for I := 0 to Designer.Form.ComponentCount - 1 do begin
    Component := Designer.Form.Components[I];
    //if (Component.InheritsFrom(TPLabelPanel)) and (Component.Name <> '') then
    if (Component.InheritsFrom(TPLabelPanel)
          or (Component is TCustomLabel) or (Component is TCustomPanel) )
       and (Component.Name <> '') then
      Proc(Component.Name);
  end;
end;

{ TPDBStringProperty }

type
  TPDBStringProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValueList(List: TStrings); virtual;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

function TPDBStringProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

procedure TPDBStringProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  Values: TStringList;
begin
  Values := TStringList.Create;
  try
    GetValueList(Values);
    for I := 0 to Values.Count - 1 do Proc(Values[I]);
  finally
    Values.Free;
  end;
end;

procedure TPDBStringProperty.GetValueList(List: TStrings);
begin
end;

{ TPDatabaseNameProperty }

type
  TPDatabaseNameProperty = class(TPDBStringProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

procedure TPDatabaseNameProperty.GetValueList(List: TStrings);
begin
     Session.GetDatabaseNames(List);
end;

{ TPMemoEditTableNameProperty }

type
  TPMemoEditTableNameProperty = class(TPDBStringProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

procedure TPMemoEditTableNameProperty.GetValueList(List: TStrings);
begin
  Session.GetTableNames((GetComponent(0) as TPMemoEdit).DatabaseName,
    '', True, False, List);
end;

{ TPmemoeditFieldNameProperty }

type
  TPMemoEditFieldNameProperty = class(TPDBStringProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

procedure TPMemoEditFieldNameProperty.GetValueList(List: TStrings);
var
  Table: TTable;
begin
  begin
    Table := TTable.Create(GetComponent(0) as TPMemoEdit);
    try
      with GetComponent(0) as TPMemoEdit do
      begin
           if DataBaseName = '' then
           begin
                List.Clear;
                exit;
           end;
        Table.DatabaseName := DatabaseName;
        Table.TableName := TableName;
        Table.GetFieldNames(List);
      end;
    finally
      Table.Free;
    end;
  end;
end;

{ TPmemoeditForeignFieldNameProperty }

type
  TPMemoEditForeignFieldNameProperty = class(TPDBStringProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

procedure TPMemoEditForeignFieldNameProperty.GetValueList(List: TStrings);
var
  Table: TTable;
begin
  begin
    Table := TTable.Create(GetComponent(0) as TPMemoEdit);
    try
      with GetComponent(0) as TPMemoEdit do
      begin
        Table.DatabaseName := DatabaseName;
        Table.TableName := RefrenTableName;
        Table.GetFieldNames(List);
      end;
    finally
      Table.Free;
    end;
  end;
end;

{ TPTableNameProperty }

type
  TPTableNameProperty = class(TPDBStringProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

procedure TPTableNameProperty.GetValueList(List: TStrings);
begin
  Session.GetTableNames((GetComponent(0) as TQueryDialog).DatabaseName,
    '', True, False, List);
end;

{ TPDTableNameProperty }

type
  TPDTableNameProperty = class(TPDBStringProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

procedure TPDTableNameProperty.GetValueList(List: TStrings);
begin
  Session.GetTableNames((GetComponent(0) as TDQueryDialog).DatabaseName,
    '', True, False, List);
end;


{ TPTableTableNameProperty }

type
  TPTableTableNameProperty = class(TPDBStringProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

procedure TPTableTableNameProperty.GetValueList(List: TStrings);
begin
  Session.GetTableNames((GetComponent(0) as TPTable).DatabaseName,
    '', True, False, List);
end;

{ TPLookupControlDataSourceProperty}

type
    TPLookupControlDataSourceProperty = class ( TPDBStringProperty)
    public
          procedure GetValueList(List: TStrings);override;
    end;

procedure TPLookupControlDataSourceProperty.GetValueList(List: TStrings);
var i : integer;
begin

end;

{ TPCounterEditTableNameProperty }
type
  TPCounterEditTableNameProperty = class(TPDBStringProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

procedure TPCounterEditTableNameProperty.GetValueList(List: TStrings);
begin
  Session.GetTableNames((GetComponent(0) as TPCounterEdit).DatabaseName,
    '', True, False, List);
end;

type
  TPLookupControlTableNameProperty = class(TPDBStringProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

procedure TPLookupControlTableNameProperty.GetValueList(List: TStrings);
begin
  Session.GetTableNames((GetComponent(0) as TPLookupControl).DatabaseName,
    '', True, False, List);
end;

{ TPLookupControlFieldNameProperty }

type
  TPLookupControlFieldNameProperty = class(TPDBStringProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

procedure TPLookupControlFieldNameProperty.GetValueList(List: TStrings);
var
  Table: TTable;
begin
  begin
    Table := TTable.Create(GetComponent(0) as TPLookupControl);
    try
      with GetComponent(0) as TPLookupControl do
      begin
        Table.DatabaseName := DatabaseName;
        Table.TableName := TableName;
        Table.GetFieldNames(List);
      end;
    finally
      Table.Free;
    end;
  end;
end;
{ TPRelationTableNameProperty }

type
  TPRelationTableNameProperty = class(TPDBStringProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

procedure TPRelationTableNameProperty.GetValueList(List: TStrings);
begin
  Session.GetTableNames((GetComponent(0) as TPRelationEdit).DatabaseName,
    '', True, False, List);
end;

{ TPRelationFieldNameProperty }

type
  TPRelationFieldNameProperty = class(TPDBStringProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

procedure TPRelationFieldNameProperty.GetValueList(List: TStrings);
var
  Table: TTable;
begin
  begin
    Table := TTable.Create(GetComponent(0) as TPRelationEdit);
    try
      with GetComponent(0) as TPRelationEdit do
      begin
        Table.DatabaseName := DatabaseName;
        Table.TableName := TableName;
        Table.GetFieldNames(List);
      end;
    finally
      Table.Free;
    end;
  end;
end;

 { TPMasterKeyFieldProperty }

type
  TPMasterKeyFieldProperty = class(TPDBStringProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

procedure TPMasterKeyFieldProperty.GetValueList(List: TStrings);
var
  Table: TTable;
begin
  begin
    Table := TTable.Create(GetComponent(0) as TDQueryDialog);
    try
      with GetComponent(0) as TDQueryDialog do
      begin
        Table.DatabaseName := DatabaseName;
        Table.TableName := MasterTableName;
        Table.GetFieldNames(List);
      end;
    finally
      Table.Free;
    end;
  end;
end;

 { TPDetailKeyFieldProperty }

type
  TPDetailKeyFieldProperty = class(TPDBStringProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

procedure TPDetailKeyFieldProperty.GetValueList(List: TStrings);
var
  Table: TTable;
begin
  begin
    Table := TTable.Create(GetComponent(0) as TDQueryDialog);
    try
      with GetComponent(0) as TDQueryDialog do
      begin
        Table.DatabaseName := DatabaseName;
        Table.TableName := DetailTableName;
        Table.GetFieldNames(List);
      end;
    finally
      Table.Free;
    end;
  end;
end;



{ TPDBLookupControlFieldProperty }

type
  TPDBLookupControlFieldProperty = class(TPDBStringProperty)
  public
    procedure GetValueList(List: TStrings); override;
    function GetDataSourcePropName: string; virtual;
  end;

function TPDBLookupControlFieldProperty.GetDataSourcePropName: string;
begin
  Result := 'DataSource';
end;

procedure TPDBLookupControlFieldProperty.GetValueList(List: TStrings);
var
  Instance: TComponent;
  PropInfo: PPropInfo;
  DataSource: TDataSource;
begin
  Instance := TComponent(GetComponent(0));
  PropInfo := TypInfo.GetPropInfo(Instance.ClassInfo, GetDataSourcePropName);
  if (PropInfo <> nil) and (PropInfo^.PropType^.Kind = tkClass) then
  begin
    DataSource := TObject(GetOrdProp(Instance, PropInfo)) as TDataSource;
    if (DataSource <> nil) then
      TTable(DataSource.DataSet).GetFieldNames(List);
  end;
end;


procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(string), TPBitBtn, 'PicFileName',
    TPPicFileNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TPImage, 'PreDefPicFileName',
    TPPicFileNameProperty);

  RegisterPropertyEditor(TypeInfo(string), nil, 'ResourceName',
    TPUpperProperty);
  RegisterPropertyEditor(TypeInfo(TControl), TPLookupCombox, 'ListFieldControl',
    TPSubFieldControlProperty);
  RegisterPropertyEditor(TypeInfo(TControl), TPDBLookupCombox, 'ListFieldControl',
    TPSubFieldControlProperty);
  RegisterPropertyEditor(TypeInfo(TControl), TPLookupEdit, 'ListFieldControl',
    TPSubFieldControlProperty);
  RegisterPropertyEditor(TypeInfo(TControl), TPDBLookupEdit, 'ListFieldControl',
    TPSubFieldControlProperty);
  RegisterPropertyEditor(TypeInfo(TControl), TPDBEdit, 'ListFieldControl',
    TPSubFieldControlProperty);
  RegisterPropertyEditor(TypeInfo(TControl), TPDBCounterEdit, 'ListFieldControl',
    TPSubFieldControlProperty);
  RegisterPropertyEditor(TypeInfo(TControl), TPDBVendorEdit, 'ListFieldControl',
    TPSubFieldControlProperty);
  RegisterPropertyEditor(TypeInfo(TControl), TPDBStaffEdit, 'ListFieldControl',
    TPSubFieldControlProperty);
  RegisterPropertyEditor(TypeInfo(TControl), TPDBKindEdit, 'ListFieldControl',
    TPSubFieldControlProperty);
  RegisterPropertyEditor(TypeInfo(TControl), TPDBMemonoEdit, 'ListFieldControl',
    TPSubFieldControlProperty);


  RegisterPropertyEditor(TypeInfo(string), TQueryDialog, 'DatabaseName',
    TPDatabaseNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TQueryDialog, 'TableName',
    TPTableNameProperty);

  RegisterPropertyEditor(TypeInfo(string), TPMemoEdit, 'DataBaseName',
    TPDatabaseNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TPMemoEdit, 'TableName',
    TPMemoEditTableNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TPMemoEdit, 'ForeignTableName',
    TPMemoEditTableNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TPMemoEdit, 'FieldName',
    TPMemoEditFieldNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TPMemoEdit, 'ForeignFieldName',
    TPMemoEditForeignFieldNameProperty);

  RegisterPropertyEditor(TypeInfo(string), TPCounterEdit, 'DataBaseName',
    TPDatabaseNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TPCounterEdit, 'TableName',
    TPCounterEditTableNameProperty);

  RegisterPropertyEditor(TypeInfo(string), TPLookupControl, 'DatabaseName',
    TPDatabaseNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TPLookupControl, 'TableName',
    TPLookupControlTableNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TPLookupControl, 'KeyField',
    TPLookupControlFieldNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TPLookupControl, 'ListField',
    TPLookupControlFieldNameProperty);

  RegisterPropertyEditor(TypeInfo(string), TPDBLookupCombox, 'DataField',
    TPDBLookupControlFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TPDBLookupEdit, 'DataField',
    TPDBLookupControlFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TPDBCounterEdit, 'DataField',
    TPDBLookupControlFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TPDBStaffEdit, 'DataField',
    TPDBLookupControlFieldProperty);

  RegisterPropertyEditor(TypeInfo(string), TPTable, 'DatabaseName',
    TPDatabaseNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TPTable, 'TableName',
    TPTableTableNameProperty);

  RegisterPropertyEditor(TypeInfo(string), TDQueryDialog, 'DatabaseName',
    TPDatabaseNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TDQueryDialog, 'MasterTableName',
    TPDTableNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TDQueryDialog, 'DetailTableName',
    TPDTableNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TDQueryDialog, 'MasterKeyField',
    TPMasterKeyFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TDQueryDialog, 'DetailKeyField',
    TPDetailKeyFieldProperty);

  RegisterPropertyEditor(TypeInfo(string), TPKindEdit, 'DatabaseName',
    TPDatabaseNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TPGoodsEdit, 'DatabaseName',
    TPDatabaseNameProperty);

  RegisterPropertyEditor(TypeInfo(string), TPRelationEdit, 'DatabaseName',
    TPDatabaseNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TPRelationEdit, 'TableName',
    TPRelationTableNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TPRelationEdit, 'LookField',
    TPRelationFieldNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TPRelationEdit, 'LookSubField',
    TPRelationFieldNameProperty);

  RegisterPropertyEditor(TypeInfo(string), TPStaffEdit, 'DatabaseName',
    TPDatabaseNameProperty);


end;

end.
