unit WVDBBinders;

interface

uses SysUtils, Classes, DataTypes, WorkViews, DB;

type
  TWVDBBinder = class;
  TWVDBBinding = class;

  TWVDBBindingEvent = procedure (Binding : TWVDBBinding; ADBField : TField; AWVField : TWVField ) of object;

  TWVDBBinding = class(TCollectionItem)
  private
    FBinder : TWVDBBinder;
    FFieldName: string;
    FWVFieldName: string;
    FDataPresentType: TDataPresentType;
    FDataPresentParam: string;
    FOnBinding: TWVDBBindingEvent;
    procedure   UpdateBinding;
  protected
    function    GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    procedure   Assign(Source: TPersistent); override;
    property    Binder : TWVDBBinder read FBinder;
  published
    property    FieldName : string read FFieldName write FFieldName;
    property    WVFieldName : string read FWVFieldName write FWVFieldName;
    property    DataPresentType : TDataPresentType read FDataPresentType write FDataPresentType;
    property    DataPresentParam : string read FDataPresentParam write FDataPresentParam;
    property    OnBinding : TWVDBBindingEvent read FOnBinding write FOnBinding;
  end;

  { TODO : 在运行的时候修改WorkView里面的字段，TWVDBBinder无法自动更新。 }
  TWVDBBinder = class(TComponent)
  private
    FDataSource: TDataSource;
    FWorkView: TWorkView;
    FDataset: TDataset;
    FFieldName: string;
    FField: TWVField;
    FBindings: TCollection;
    FHideUnbindingFields: Boolean;
    FOnBinding: TNotifyEvent;
    procedure   SetDataSource(const Value: TDataSource);
    procedure   SetWorkView(const Value: TWorkView);
    procedure   UpdateField;
    procedure   UpdateDataset;
    procedure   SetDataset(const Value: TDataset);
    procedure   SetFieldName(const Value: string);
    procedure   LMWorkViewNotify(var Message:TWVMessage); message LM_WorkViewNotify;
    procedure   SetBindings(const Value: TCollection);
  protected
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure   Loaded; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
    procedure   UpdateBindings;
    property    Dataset : TDataset read FDataset write SetDataset;
    property    Field : TWVField read FField;
  published
    property    DataSource : TDataSource read FDataSource write SetDataSource;
    property    WorkView : TWorkView read FWorkView write SetWorkView;
    property    FieldName : string read FFieldName write SetFieldName;
    property    Bindings : TCollection read FBindings write SetBindings;
    property    HideUnbindingFields : Boolean read FHideUnbindingFields write FHideUnbindingFields;
    property    OnBinding : TNotifyEvent read FOnBinding write FOnBinding;
  end;


implementation

type
  TOwnedCollectionAccess = class(TOwnedCollection);

{ TWVDBBinder }

constructor TWVDBBinder.Create(AOwner: TComponent);
begin
  inherited;
  FBindings := TOwnedCollection.Create(Self, TWVDBBinding);
end;

destructor TWVDBBinder.Destroy;
begin
  FreeAndNil(FBindings);
  inherited;
end;

procedure TWVDBBinder.LMWorkViewNotify(var Message: TWVMessage);
begin
  if (Message.Field=Field) and (Field<>nil) then
  begin
    case Message.NotifyCode of
      WV_FieldValueChanged : UpdateDataset;
    end;
  end;
end;

procedure TWVDBBinder.Loaded;
begin
  inherited;
  UpdateField;
end;

procedure TWVDBBinder.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if Operation=opRemove then
  begin
    if AComponent=FDataSource then
      FDataSource := nil
    else if AComponent=FWorkView then
      FWorkView := nil
    else if AComponent=FDataset then
      FDataset := nil;
  end;
end;

procedure TWVDBBinder.SetBindings(const Value: TCollection);
begin
  FBindings.Assign(Value);
end;

procedure TWVDBBinder.SetDataset(const Value: TDataset);
begin
  if FDataset <> Value then
  begin
    FDataset := Value;
    if FDataset<>nil then
      FDataset.FreeNotification(Self);
    if FDataSource<>nil then
      FDataSource.Dataset := Dataset;
    UpdateBindings;
  end;
end;

procedure TWVDBBinder.SetDataSource(const Value: TDataSource);
begin
  if FDataSource <> Value then
  begin
    FDataSource := Value;
    if FDataSource<>nil then
    begin
      FDataSource.FreeNotification(Self);
      FDataSource.Dataset := Dataset;
    end;
  end;
end;

procedure TWVDBBinder.SetFieldName(const Value: string);
begin
  if FFieldName <> Value then
  begin
    FFieldName := Value;
    UpdateField;
  end;
end;

procedure TWVDBBinder.SetWorkView(const Value: TWorkView);
begin
  if FWorkView <> Value then
  begin
    if FWorkView<>nil then
      FWorkView.RemoveClient(Self);
    FWorkView := Value;
    if FWorkView<>nil then
      FWorkView.AddClient(Self);
    UpdateField;
  end;
end;

procedure TWVDBBinder.UpdateBindings;
var
  I : Integer;
  Binding : TWVDBBinding;
begin
  if (Dataset<>nil) and (WorkView<>nil) then
  begin
    if HideUnbindingFields then
      for I:=0 to Dataset.FieldCount-1 do
      begin
        Dataset.Fields[I].Visible := False;
      end;
    for I:=0 to Bindings.Count-1 do
    begin
      Binding := TWVDBBinding(Bindings.Items[I]);
      Binding.UpdateBinding;
    end;
    if Assigned(OnBinding) then
      OnBinding(Self);
  end;
end;

procedure TWVDBBinder.UpdateDataset;
var
  Obj : TObject;
begin
  Obj := nil;
  if (FField<>nil) and (FField.DataType=kdtObject) then
    Obj := FField.Data.AsObject;
  if Obj is TDataset then
    Dataset := TDataset(Obj) else
    Dataset := nil;
end;

procedure TWVDBBinder.UpdateField;
begin
  // Find Field
  FField := nil;
  if (FWorkView<>nil) and (FFieldName<>'') and not (csLoading in ComponentState) then
    FField := FWorkView.FindField(FFieldName);
  UpdateDataset;
end;

{ TWVDBBinding }

constructor TWVDBBinding.Create(Collection: TCollection);
begin
  inherited;
  FBinder := TWVDBBinder(TOwnedCollectionAccess(Collection).GetOwner);
end;

procedure TWVDBBinding.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TWVDBBinding then
  with TWVDBBinding(Source) do
  begin
    FFieldName := Self.FFieldName;
    FWVFieldName := Self.FWVFieldName;
  end else
    inherited;
end;

procedure TWVDBBinding.UpdateBinding;
var
  ADBField : TField;
  AWVField : TWVField;
begin
  if (Binder.Dataset<>nil) and (Binder.WorkView<>nil) then
  begin
    ADBField := Binder.Dataset.FindField(FFieldName);
    AWVField := Binder.WorkView.FindField(FWVFieldName);
    if (ADBField<>nil) and (AWVField<>nil) then
    begin
      ADBField.DisplayLabel := AWVField.Caption;
      ADBField.Index := Self.Index;
      ADBField.Visible := True;
    end;
    if (ADBField<>nil) and (DataPresentType<>'') then
      WVSetFieldEventHanlder(ADBField,DataPresentType,DataPresentParam);
    if Assigned(OnBinding) then
      OnBinding(Self, ADBField, AWVField);
  end;
end;

function TWVDBBinding.GetDisplayName: string;
begin
  Result := FieldName + ' - ' + WVFieldName;
end;

end.
