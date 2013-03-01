unit WVEditors;

{$I KSConditions.INC }

interface

uses Windows, Sysutils, Classes, TypUtils, WorkViews, DesignUtils,
  WVCommands, WVCmdReq, WVCmdTypeInfo, DataTypes
  {$ifdef VCL60_UP }
    ,DesignIntf, DesignEditors
  {$else}
    ,dsgnintf
  {$endif}
;

type
  TWVFieldNameProperty = class(TStringProperty)
  private
    FProperty : TProperty;
  public
    procedure   Initialize; override;
    destructor  Destroy;override;
    function    GetAttributes: TPropertyAttributes; override;
    procedure   GetValues(Proc: TGetStrProc); override;
  end;

  TWVDomainNameProperty = class(TStringProperty)
  private

  public
    function    GetAttributes: TPropertyAttributes; override;
    procedure   GetValues(Proc: TGetStrProc); override;
  end;

  // 为各种CollectionItem服务，要求这些Collection的Owner应该包含WorkView属性
  TWVFieldNameProperty2 = class(TWVFieldNameProperty)
  private

  public
    procedure   GetValues(Proc: TGetStrProc); override;
  end;

  // for TWVFieldParamBinding
  TWVParamNameProperty = class(TStringProperty)
  private

  public
    function    GetAttributes: TPropertyAttributes; override;
    procedure   GetValues(Proc: TGetStrProc); override;
  end;

  TWVIDProperty = class(TStringProperty)
  private

  public
    function    GetAttributes: TPropertyAttributes; override;
    procedure   GetValues(Proc: TGetStrProc); override;
  end;

  TWVFieldNamesProperty = class(TStringProperty)
  protected
    function    GetWorkView : TWorkView; virtual; abstract;
  public
    function    GetAttributes: TPropertyAttributes; override;
    procedure   Edit; override;
  end;

  // for TWVField
  TWVFieldNamesProperty1 = class(TWVFieldNamesProperty)
  protected
    function    GetWorkView : TWorkView; override;
  end;

  // for TWVFieldMonitor
  TWVFieldNamesProperty2 = class(TWVFieldNamesProperty)
  protected
    function    GetWorkView : TWorkView; override;
  end;

  // for TWorkView
  TWVWorkViewEditor = class(TUseDefaultPropertyEditor)
  protected
    procedure   AddFields;
  public
    procedure   ExecuteVerb(Index: Integer); override;
    function    GetVerb(Index: Integer): string; override;
    function    GetVerbCount: Integer; override;
  end;

  // for TWorkView
  TWVCommandTypeInfoEditor = class(TUseDefaultPropertyEditor)
  protected
    procedure   Init; override;
    procedure   AddParams;
  public
    procedure   ExecuteVerb(Index: Integer); override;
    function    GetVerb(Index: Integer): string; override;
    function    GetVerbCount: Integer; override;
  end;


  TWVRequestEditor = class(TUseDefaultPropertyEditor)
  protected
    procedure   Init; override;
    procedure   AddRequestBindings;
  public
    procedure   ExecuteVerb(Index: Integer); override;
    function    GetVerb(Index: Integer): string; override;
    function    GetVerbCount: Integer; override;
  end;

  TWVDBGridEditor = class(TUseDefaultPropertyEditor)
  protected
    procedure   Init; override;
    procedure   AddColumns;
  public
    procedure   ExecuteVerb(Index: Integer); override;
    function    GetVerb(Index: Integer): string; override;
    function    GetVerbCount: Integer; override;
  end;

function  GetDataTypeFromFieldName(const FieldName : string) : TKSDataType;

resourcestring
  SFields = 'Edit WorkView Fields';
  SMonitors = 'Edit WorkView FieldMonitors';
  SAddFields = 'Add WorkView Fields';
  SCommandParams = 'Edit Command Params';
  SAddCommandParams = 'Add Command Params';
  SRequestBindings= 'Edit Request Bindings';
  SAddRequestBindings= 'Add All Existed Request Bindings';
  SDBGridColumns = 'Edit Columns';
  SAddDBGridColumns = 'Add Columns';


implementation

uses WVSelFieldNames, WVMemoDlg, KSStrUtils, DB, DBGrids;

type
  TPersistentAccess = class(TPersistent);

procedure FillWorkFieldNames(WorkView : TWorkView; Proc: TGetStrProc);
var
  I : Integer;
begin
  if WorkView=nil then Exit;
  try
    for i:=0 to WorkView.WorkFields.Count-1 do
    begin
      if TWVField(WorkView.WorkFields.Items[I]).Name<>'' then
        Proc(TWVField(WorkView.WorkFields.Items[I]).Name);
    end;
  except

  end;
end;

{ TWVFieldNameProperty }

procedure TWVFieldNameProperty.Initialize;
begin
  inherited;
  FProperty := TProperty.Create(nil,nil);
end;

destructor TWVFieldNameProperty.Destroy;
begin
  FProperty.Free;
  inherited;
end;

function TWVFieldNameProperty.GetAttributes: TPropertyAttributes;
begin
  result := (inherited GetAttributes) + [paValueList, paSortList];
end;

procedure TWVFieldNameProperty.GetValues(Proc: TGetStrProc);
var
  WorkView : TWorkView;
begin
  FProperty.CreateByName(GetComponent(0),'WorkView');
  if FProperty.Available then
  begin
    WorkView := TWorkView(FProperty.AsObject);
    if WorkView is TWorkView then
      FillWorkFieldNames(WorkView,Proc);
  end;
end;

{ TWVDomainNameProperty }

function TWVDomainNameProperty.GetAttributes: TPropertyAttributes;
begin
  result := (inherited GetAttributes) + [paValueList];
end;

procedure TWVDomainNameProperty.GetValues(Proc: TGetStrProc);
var
  I : Integer;
  S : string;
begin
  Assert(FieldDomainManager<>nil);
  for I:=0 to FieldDomainManager.Count-1 do
  begin
    S := FieldDomainManager.Domains[I].DomainName;
    if S<>'' then
      Proc(S);
  end;
end;

{ TWVFieldNameProperty2 }

procedure TWVFieldNameProperty2.GetValues(Proc: TGetStrProc);
var
  WorkView : TWorkView;
  CollectionItem : TCollectionItem;
  Comp : TPersistent;
begin
  CollectionItem := TCollectionItem(GetComponent(0));
  if (CollectionItem is TCollectionItem) then
  begin
    Comp := TPersistentAccess(CollectionItem.Collection).GetOwner;
    FProperty.CreateByName(Comp,'WorkView');
    if FProperty.Available then
    begin
      WorkView := TWorkView(FProperty.AsObject);
      if WorkView is TWorkView then
        FillWorkFieldNames(WorkView,Proc);
    end;
  end;
end;

{ TWVParamNameProperty }

function TWVParamNameProperty.GetAttributes: TPropertyAttributes;
begin
  result := (inherited GetAttributes) + [paValueList];
end;

procedure TWVParamNameProperty.GetValues(Proc: TGetStrProc);
var
  ID : TWVCommandID;
  Version : TWVCommandVersion;
  Binding : TWVFieldParamBinding;
begin
  Binding := TWVFieldParamBinding(GetComponent(0));
  if Binding is TWVFieldParamBinding then
  begin
    ID := Binding.Request.ID;
    Version := Binding.Request.Version;
    FillCommandParamNames(ID,Version,Proc);
  end;
end;

{ TWVIDProperty }

function TWVIDProperty.GetAttributes: TPropertyAttributes;
begin
  result := (inherited GetAttributes) + [paValueList];
end;

procedure TWVIDProperty.GetValues(Proc: TGetStrProc);
var
  I, Count : Integer;
  CommandTypeInfo : TWVCommandTypeInfo;
begin
  if GetComponent(0) is TWVCommandTypeInfo then
    Exit;
  Count := GetCommandTypeInfoCount;
  for I:=0 to Count-1 do
  begin
    CommandTypeInfo := GetCommandTypeInfo(I);
    if CommandTypeInfo.ID<>'' then
      Proc(CommandTypeInfo.ID);
  end;
end;

{ TWVFieldNamesProperty }

procedure TWVFieldNamesProperty.Edit;
var
  WorkView : TWorkView;
  FieldNames : string;
begin
  WorkView := GetWorkView;
  if WorkView<>nil then
  begin
    FieldNames := GetStrValue;
    if SelectFieldNames(WorkView,FieldNames) then
    begin
      SetStrValue(FieldNames);
      Modified;
    end;
  end;
end;

function TWVFieldNamesProperty.GetAttributes: TPropertyAttributes;
begin
  result := (inherited GetAttributes) + [paDialog];
end;


{ TWVFieldNamesProperty1 }

function TWVFieldNamesProperty1.GetWorkView: TWorkView;
begin
  if GetComponent(0) is TWVField then
    Result := TWVField(GetComponent(0)).WorkView else
    Result := nil;
end;

{ TWVFieldNamesProperty2 }

function TWVFieldNamesProperty2.GetWorkView: TWorkView;
begin
  if GetComponent(0) is TWVFieldMonitor then
    Result := TWVFieldMonitor(GetComponent(0)).WorkView else
    Result := nil;
end;

{ TWVWorkViewEditor }

procedure TWVWorkViewEditor.AddFields;
var
  Dialog : TdlgMemo;
  I{, K} : Integer;
  WorkView : TWorkView;
  Field : TWVField;
  FieldName : string;
  DataField : string;
  Parts : TStringList;
begin
  WorkView := TWorkView(Component);

  Dialog := TdlgMemo.Create(nil);
  Parts := TStringList.Create;
  try
    if Dialog.Execute(SAddFields) then
    begin
      for I:=0 to Dialog.Memo.Count-1 do
      begin
          {
          // Tab => space
          FieldName := Trim(StringReplace(Dialog.Memo[I],#9,' ',[rfReplaceAll]));
          K := Pos(' ',FieldName);
          if K>0 then
          begin
            DataField := Trim(System.Copy(FieldName,K+1,Length(FieldName)));
            FieldName := System.Copy(FieldName,1,K);
          end else
          begin
            DataField := '';
          end;
          }
        seperateStrByBlank(Dialog.Memo[I],Parts);
        if Parts.Count>0 then
        begin
          Field := TWVField(WorkView.WorkFields.Add);
          FieldName := Parts[0];
          if Parts.Count>0 then
            DataField := Parts[1] else
            DataField := '';
          Field.Caption := FieldName;
          Field.Name := FieldName;
          Field.DataField := DataField;
          if DataField<>'' then
          begin
            Field.GroupIndex := 1;
            Field.DataType := GetDataTypeFromFieldName(DataField);
          end else
          begin
            Field.GroupIndex := 0;
          end;
        end;
      end;
    end;
  finally
    Parts.Free;
    Dialog.Free;
  end;
end;

procedure TWVWorkViewEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0 :
    begin
      FPropName := 'WorkFields';
      inherited ;
    end;
    1 :
    begin
      FPropName := 'FieldsMonitors';
      inherited ;
    end;
    2 :
    begin
      AddFields;
    end;
  else inherited;
  end;
end;

function TWVWorkViewEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0 : Result := SFields;
    1 : Result := SMonitors;
    2 : Result := SAddFields;
  else
    Result := inherited GetVerb(Index);
  end;
end;

function TWVWorkViewEditor.GetVerbCount: Integer;
begin
  Result := 3;
end;

{ TWVCommandTypeInfoEditor }

procedure TWVCommandTypeInfoEditor.AddParams;
var
  Dialog : TdlgMemo;
  I{, K} : Integer;
  CommandTypeInfo : TWVCommandTypeInfo;
  Param : TWVParam;
  ParamName : string;
  Parts : TStringList;
begin
  CommandTypeInfo := TWVCommandTypeInfo(Component);

  Dialog := TdlgMemo.Create(nil);
  Parts := TStringList.Create;
  try
    if Dialog.Execute(SAddCommandParams) then
    begin
      for I:=0 to Dialog.Memo.Count-1 do
      begin
        seperateStrByBlank(Dialog.Memo[I],Parts);
        if Parts.Count>0 then
        begin
          Param := TWVParam(CommandTypeInfo.Params.Add);
          ParamName := Parts[0];
          Param.ParamName := ParamName;
          if Parts.Count>1 then
            Param.ParamDataType := GetDataTypeFromFieldName(Parts[1]);
        end;
      end;
    end;
  finally
    Parts.Free;
    Dialog.Free;
  end;
end;

procedure TWVCommandTypeInfoEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0 : inherited ;
    1 : AddParams;
  else inherited;
  end;
end;

function TWVCommandTypeInfoEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0 : Result := SCommandParams;
    1 : Result := SAddCommandParams;
  else
    Result := inherited GetVerb(Index);
  end;
end;

function TWVCommandTypeInfoEditor.GetVerbCount: Integer;
begin
  Result := 2;
end;

procedure TWVCommandTypeInfoEditor.Init;
begin
  inherited;
  FPropName := 'Params';
end;


{ TWVRequestEditor }

procedure TWVRequestEditor.AddRequestBindings;
var
  ID : TWVCommandID;
  Version : TWVCommandVersion;
  I : Integer;
  CommandTypeInfo : TWVCommandTypeInfo;
  Binding : TWVFieldParamBinding;
  Param : TWVParam;
  Request : TWVRequest;
  WorkView : TWorkView;
  Field : TWVField;
begin
  Request := TWVRequest(Component);
  WorkView := Request.WorkView;
  ID := Request.ID;
  Version := Request.Version;
  CommandTypeInfo := FindCommandTypeInfo(ID,Version);
  if CommandTypeInfo<>nil then
  begin
    for i:=0 to CommandTypeInfo.Params.Count-1 do
    begin
      Param := TWVParam(CommandTypeInfo.Params.Items[I]);
      if Param.ParamName<>'' then
      begin
        Binding := TWVFieldParamBinding(Request.Bindings.Add);
        Binding.ParamName := Param.ParamName;
        if WorkView<>nil then
          Field := WorkView.FindField(Param.ParamName) else
          Field := nil;
        if Field<>nil then
          Binding.FieldName := Param.ParamName;
        case Param.ParamType of
          WVCommands.ptInput:  Binding.Direction := bdField2Param;
          WVCommands.ptOutput: Binding.Direction := bdParam2Field;
          WVCommands.ptInputOutput: Binding.Direction := bdBiDirection;
        end;
      end;
    end;
  end;
end;


procedure TWVRequestEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0 : inherited;
    1 : AddRequestBindings;
  else inherited;
  end;
end;

function TWVRequestEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0 : Result := SRequestBindings;
    1 : Result := SAddRequestBindings;
  else
    Result := inherited GetVerb(Index);
  end;
end;

function TWVRequestEditor.GetVerbCount: Integer;
begin
  Result := 2;
end;


procedure TWVRequestEditor.Init;
begin
  inherited;
  FPropName := 'Bindings';
end;

function  GetDataTypeFromFieldName(const FieldName : string) : TKSDataType;
begin
  if FieldName='' then
    Result := kdtString else
    case FieldName[1] of
      's','S','v','V' : Result := kdtString;
      'l','L' : Result := kdtInteger;
      'd','D' : Result := kdtFloat;
    else
      if SameText(FieldName,'@Return') then
        Result := kdtInteger
      else if SameText(FieldName,'@Dataset') then
        Result := kdtObject
      else
        Result := kdtString;
    end;
end;

{ TWVDBGridEditor }

procedure TWVDBGridEditor.AddColumns;
var
  Dialog : TdlgMemo;
  I : Integer;
  Grid : TDBGrid;
  Column : TColumn;
  Parts : TStringList;
begin
  Grid := TDBGrid(Component);
  Dialog := TdlgMemo.Create(nil);
  Parts := TStringList.Create;
  try
    if Dialog.Execute(SAddCommandParams) then
    begin
      for I:=0 to Dialog.Memo.Count-1 do
      begin
        seperateStrByBlank(Dialog.Memo[I],Parts);
        if Parts.Count>0 then
        begin
          Column := TColumn(Grid.Columns.Add);
          Column.Title.Caption:= Parts[0];
          if Parts.Count>1 then
            Column.FieldName := Parts[1];
        end;
      end;
    end;
  finally
    Parts.Free;
    Dialog.Free;
  end;
end;

procedure TWVDBGridEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0 : inherited ;
    1 : AddColumns;
  else inherited;
  end;
end;

function TWVDBGridEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0 : Result := SDBGridColumns;
    1 : Result := SAddDBGridColumns;
  else
    Result := inherited GetVerb(Index);
  end;
end;

function TWVDBGridEditor.GetVerbCount: Integer;
begin
  Result := 2;
end;

procedure TWVDBGridEditor.Init;
begin
  inherited;
  FPropName := 'Columns';
end;

end.
