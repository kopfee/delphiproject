unit QueryDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, RxQuery, SpeedBar, Grids, RXCtrls, RXSplit, StdCtrls,
  ExtCtrls, DBGrids, RXDBCtrl, ComCtrls, MaxMin, Menus, InfoDlg, MxArrays,
  PDBGrid;

const
  MinLines = 10;

type
  TFieldInfo = class
    DisplayName : string;
    FieldName : string;
    FieldType : TFieldType;
    PickList : TStringList;
  end;

  TFieldItem = class
    Data : string;
    DisplayName : string;
    FieldName : string;
    FieldType : TFieldType;
    Operator : string;
    PickList : TStringList;
  end;

  { TfrmQuery }

  TfrmQuery = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    SpeedBar1: TSpeedBar;
    lstFields: TTextListBox;
    RxSplitter1: TRxSplitter;
    grdExpression: TRxDrawGrid;
    SpeedbarSection1: TSpeedbarSection;
    btnAdd: TSpeedItem;
    btnAddAll: TSpeedItem;
    btnRemove: TSpeedItem;
    btnRemoveAll: TSpeedItem;
    SpeedbarSection2: TSpeedbarSection;
    btnRun: TSpeedItem;
    SpeedbarSection3: TSpeedbarSection;
    btnClose1: TSpeedItem;
    GridQuery: TRxQuery;
    GridSource: TDataSource;
    PopupMenu1: TPopupMenu;
    Show1: TMenuItem;
    SpeedBar2: TSpeedBar;
    SpeedbarSection4: TSpeedbarSection;
    btnAppend: TSpeedItem;
    SpeedbarSection5: TSpeedbarSection;
    btnClose2: TSpeedItem;
    bthSelectAll: TSpeedItem;
    stuMessage: TStatusBar;
    grdResult: TPDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnAddAllClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnRemoveAllClick(Sender: TObject);
    function grdExpressionAcceptEditKey(Sender: TObject;
      var Key: Char): Boolean;
    procedure grdExpressionDrawCell(Sender: TObject; Col, Row: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure grdExpressionGetEditMask(Sender: TObject; ACol,
      ARow: Integer; var Value: String);
    procedure grdExpressionGetEditStyle(Sender: TObject; ACol,
      ARow: Integer; var Style: TInplaceEditStyle);
    procedure grdExpressionGetEditText(Sender: TObject; ACol,
      ARow: Integer; var Value: String);
    procedure grdExpressionGetPicklist(Sender: TObject; ACol,
      ARow: Integer; PickList: TStrings);
    procedure grdExpressionSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String);
    procedure grdExpressionShowEditor(Sender: TObject; ACol, ARow: Integer;
      var AllowEdit: Boolean);
    procedure btnRunClick(Sender: TObject);
    procedure grdResultDblClick(Sender: TObject);
    procedure Show1Click(Sender: TObject);
    procedure btnClose1Click(Sender: TObject);
    procedure btnClose2Click(Sender: TObject);
    procedure btnAppendClick(Sender: TObject);
    procedure bthSelectAllClick(Sender: TObject);
  private
    { Private declarations }
    FTableName: string;
    FRelatedTable : TTable;
    function GetDatabaseName:string;
    procedure SetDatabaseName(const Value : string);
  public
    { Public declarations }
    FieldsList : TList;
    GridList : TList;
    procedure RemoveAllGridList;
    function AppendToDataset(Dataset : TTable;var Correct,Wrong : integer;Deselect : Boolean): Boolean;
  published
    property DatabaseName : string read GetDatabaseName write SetDatabaseName;
    property TableName : string read FTableName write FTableName;
    property RelatedTable : TTable read FRelatedTable write FRelatedTable;
  end;

  { TTransTable }

  TTransTable = class(TPersistent)
  private
    FItems : TList;
    procedure ReadBinaryData(Stream: TStream);
    procedure WriteBinaryData(Stream: TStream);
    function GetFieldInfo(index: integer):TFieldInfo;
    function GetCount:integer;
    procedure Assign(Source : TPersistent);override;
  protected
    procedure DefineProperties(Filer: TFiler); override;
  public
    constructor Create;virtual;
    destructor Destroy;override;

    procedure Add(NewItem: TFieldInfo);
    procedure Clear;
    property Items[index : integer]:TFieldInfo read GetFieldInfo;
    property Count:integer read GetCount;
  end;

  { TQueryDialog }

  TQueryDialog = class(TComponent)
  private
    { Private declarations }
    FDatabaseName : string;
    FTableName : string;
    FTransTable : TTransTable;
    FQForm : TfrmQuery;

  protected
    { Protected declarations }
    procedure SetDatabaseName(Value: string);
    procedure SetTableName(Value: string);
    function GetRelatedTable:TTable;
    procedure SetRelatedTable(Value: TTable);

  public
    { Public declarations }
    procedure Execute;
    function AppendToTable(Table : TTable;var Correct,Wrong:integer):Boolean;
    function PicklistByName(AName : string):TStrings;
  published
    { Published declarations }
    property DatabaseName:string read FDatabaseName write SetDatabaseName;
    property TableName:string read FTableName write SetTableName;
    property TransTable:TTransTable read FTransTable write FTransTable;
    property RelatedTable: TTable read GetRelatedTable write SetRelatedTable;

    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
  end;

procedure Register;


implementation

{$R *.DFM}

 { TfrmQuery }

function TfrmQuery.GetDatabaseName:string;
begin
  Result := GridQuery.DatabaseName;
end;

procedure TfrmQuery.SetDatabaseName(const Value : string);
begin
  if GridQuery.DatabaseName <> Value then
  begin
    GridQuery.Close;
    GridQuery.DatabaseName := Value;
  end;
end;

procedure TfrmQuery.FormCreate(Sender: TObject);
begin
  FieldsList := TList.Create;
  GridList := TList.Create;
  grdExpression.RowCount := MinLines;
  grdExpression.ColWidths[0] := 10;
  grdExpression.ColWidths[1] := 120;
  grdExpression.ColWidths[2] := 80;
  grdExpression.ColWidths[3] := 160;
end;

procedure TfrmQuery.FormDestroy(Sender: TObject);
var
  i : integer;
begin
  RemoveAllGridList;
  GridList.Free;
  with FieldsList do
  begin
    for i:=0 to Count-1 do
    begin
      if TFieldInfo(Items[i]).PickList<>nil then
         TFieldInfo(Items[i]).PickList.Free;
      TFieldInfo(Items[i]).Free;
    end;
  end;
  FieldsList.Free;
end;

procedure TfrmQuery.btnAddClick(Sender: TObject);
var
  i : integer;
  NewItem : TFieldItem;
begin
  with lstFields do
  begin
    for i:=0 to Items.Count-1 do
      if Selected[i] then
      begin
        NewItem := TFieldItem.Create;
        NewItem.FieldName := (Items.Objects[i] as TFieldInfo).FieldName;
        NewItem.DisplayName := (Items.Objects[i] as TFieldInfo).DisplayName;
        NewItem.FieldType := (Items.Objects[i] as TFieldInfo).FieldType;
        NewItem.PickList := (Items.Objects[i] as TFieldInfo).PickList;
        NewItem.Data := '';
        NewItem.Operator := '<';
        GridList.Add(NewItem);
        Selected[i] := False;
      end;
    grdExpression.RowCount := Max(GridList.Count+1,MinLines);
    grdExpression.Repaint;
  end;
end;

procedure TfrmQuery.btnAddAllClick(Sender: TObject);
var
  i : integer;
  NewItem : TFieldItem;
begin
 with lstFields do
  begin
    for i:=0 to Items.Count-1 do
    begin
      NewItem := TFieldItem.Create;
      NewItem.FieldName := (Items.Objects[i] as TFieldInfo).FieldName;
      NewItem.DisplayName := (Items.Objects[i] as TFieldInfo).DisplayName;
      NewItem.FieldType := (Items.Objects[i] as TFieldInfo).FieldType;
      NewItem.PickList := (Items.Objects[i] as TFieldInfo).PickList;
      NewItem.Data := '';
      NewItem.Operator := '<';
      GridList.Add(NewItem);
      Selected[i] := False;
    end;
    grdExpression.RowCount := Max(GridList.Count+1,MinLines);
    grdExpression.Repaint;
  end;
end;

procedure TfrmQuery.btnRemoveClick(Sender: TObject);
begin
  with grdExpression do
  begin
    if Row<=GridList.Count then
    begin
      EditorMode := False;
      TFieldItem(GridList.Items[Row-1]).PickList := nil;
      TFieldItem(GridList.Items[Row-1]).Free;
      GridList.Delete(Row-1);
      RowCount := Max(GridList.Count+1,MinLines);
      repaint;
    end;
  end;
end;

procedure TfrmQuery.btnRemoveAllClick(Sender: TObject);
begin
  grdExpression.Col := 1;
  RemoveAllGridList;
  grdExpression.RowCount := Max(GridList.Count+1,MinLines);
  grdExpression.Repaint;
  grdExpression.Row := 1;
end;

procedure TfrmQuery.RemoveAllGridList;
var
  i : integer;
begin
  with GridList do
  begin
    for i := 0 to Count-1 do
    begin
      TFieldItem(Items[i]).PickList := nil;
      TFieldItem(Items[i]).Free;
    end;  
    Clear;
  end;
end;

function TfrmQuery.grdExpressionAcceptEditKey(Sender: TObject;
  var Key: Char): Boolean;
begin
  Result := True;
  case grdExpression.Col of
    2 : Result := False;
    3 : Case TFieldItem(GridList.Items[grdExpression.Row-1]).FieldType of
          ftDate, ftDateTime : if not (Key in ['0'..'9']) then
                                         Result := False;
          ftSmallint, ftInteger, ftWord : if not (Key in['0'..'9','+','-']) then Result := False;
          ftFloat : if not (Key in ['0'..'9','+','-','.']) then Result := False;
        end;
  end;
end;

procedure TfrmQuery.grdExpressionDrawCell(Sender: TObject; Col,
  Row: Integer; Rect: TRect; State: TGridDrawState);
begin
  if Row=0 then
  begin
    case Col of
      1 : grdExpression.DrawStr(Rect,'字段名',taCenter);
      2 : grdExpression.DrawStr(Rect,'运算符',taCenter);
      3 : grdExpression.DrawStr(Rect,'条件值',taCenter);
    end;
  end
  else if Row<=GridList.Count then
  begin
    case Col of
      1 : grdExpression.DrawStr(Rect,TFieldItem(GridList.Items[Row-1]).DisplayName,taRightJustify);
      2 : grdExpression.DrawStr(Rect,TFieldItem(GridList.Items[Row-1]).Operator,taCenter);
      3 : grdExpression.DrawStr(Rect,TFieldItem(GridList.Items[Row-1]).Data,taLeftJustify);
    end;
  end;
end;

procedure TfrmQuery.grdExpressionGetEditMask(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
begin
  case ACol of
    3 : begin
          case TFieldItem(GridList.Items[ARow-1]).FieldType of
            ftDate, ftDateTime : Value := '!99/99/00;1;_';
          end;
        end;
  end;
end;

procedure TfrmQuery.grdExpressionGetEditStyle(Sender: TObject; ACol,
  ARow: Integer; var Style: TInplaceEditStyle);
begin
  Case ACol of
    2 : Style :=iePicklist;
    3 : begin
          case TFieldItem(GridList.Items[ARow-1]).FieldType of
            ftString : if TFieldItem(GridList.Items[ARow-1]).Picklist.Count>0 then
                         Style := iePicklist;
          end;
        end;
  end;
end;

procedure TfrmQuery.grdExpressionGetEditText(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
begin
 if ARow<=GridList.Count then
  begin
    case ACol of
      2 : Value := TFieldItem(GridList.Items[ARow-1]).Operator;
      3 : Value := TFieldItem(GridList.Items[ARow-1]).Data;
    end;
  end;
end;

procedure TfrmQuery.grdExpressionGetPicklist(Sender: TObject; ACol,
  ARow: Integer; PickList: TStrings);
begin
  Case ACol of
    2 : begin
          PickList.Add('<');
          PickList.Add('<=');
          PickList.Add('>');
          PickList.Add('>=');
          PickList.Add('=');
          PickList.Add('<>');
          case TFieldItem(GridList.Items[ARow-1]).FieldType of
            ftString: begin
                        PickList.Add('LIKE');
                        PickList.Add('NOT LIKE');
                      end;
            ftDate, ftDateTime : ;
            ftSmallint, ftInteger, ftWord, ftFloat : ;
          end;
        end;
    3 : begin
          case TFieldItem(GridList.Items[ARow-1]).FieldType of
            ftString : if TFieldItem(GridList.Items[ARow-1]).PickList.Count > 0 then
                         PickList.Assign(TFieldItem(GridList.Items[ARow-1]).PickList);
          end;
        end;
  end;
end;

procedure TfrmQuery.grdExpressionSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  Case grdExpression.Col of
    2 : TFieldItem(GridList.Items[ARow-1]).Operator := grdExpression.InPlaceEditor.Text;
    3 : TFieldItem(GridList.Items[ARow-1]).Data := grdExpression.InPlaceEditor.Text;
  end;
end;

procedure TfrmQuery.grdExpressionShowEditor(Sender: TObject; ACol,
  ARow: Integer; var AllowEdit: Boolean);
begin
  if (ACol=1) or (ARow>GridList.Count) then AllowEdit := False;
end;

procedure TfrmQuery.btnRunClick(Sender: TObject);
var
  i : integer;
  tmpField : TField;
  OldShortDateFormat: string;
begin
  GridQuery.Close;
  GridQuery.SQL.Clear;
  if (DatabaseName<>'') and (TableName<>'') then
  begin
    grdExpression.EditorMode := False;
    GridQuery.SQL.Add('Select * from '+FTableName);
    try
      if GridList.Count>0 then
      begin
        OldShortDateFormat := ShortDateFormat;
        ShortDateFormat := 'mm'+DateSeparator+'dd'+DateSeparator+'yy';
        GridQuery.SQL.Add(' where ');
        for i := 0 to GridList.Count-1 do
        begin
          with TFieldItem(GridList.Items[i]) do
          begin
            GridQuery.SQL.Add(FieldName+' '+Operator+' '+':Param'+IntToStr(i));
            if i<>GridList.Count-1 then GridQuery.SQL.Add(' and ');
            GridQuery.Params.ParamByName('Param'+IntToStr(i)).DataType := FieldType;
            GridQuery.Params.ParamByName('Param'+IntToStr(i)).Text := Data;
          end;
        end;
      end;
      ShortDateFormat := OldShortDateFormat;
      GridQuery.Open;
      if GridQuery.RecordCount <= 0 then
        stuMessage.SimpleText := '无符合条件的记录！'
      else
      begin
        stuMessage.SimpleText := '查询成功：'+IntToStr(GridQuery.RecordCount)+'条记录符合条件！';
        PageControl1.SelectNextPage(True);
      end;
    except
      on Exception do
      begin
        stuMessage.SimpleText := '查询失败';
        Application.MessageBox('条件错误或数据库为空！','错误',MB_OK);
        ShortDateFormat := OldShortDateFormat;
        Exit;
      end;
    end;

    for i := 0 to FieldsList.Count-1 do
    begin
      tmpField := GridQuery.FindField(TFieldInfo(FieldsList.Items[i]).FieldName);
      if tmpField <> nil then
        tmpField.DisplayLabel := TFieldInfo(FieldsList.Items[i]).DisplayName;
    end;

  end;
end;

procedure TfrmQuery.grdResultDblClick(Sender: TObject);
var
  InfoForm : TfrmInfoDlg;
begin
  InfoForm := TfrmInfoDlg.Create(Self);
  if (GridQuery.Active) then
    if (GridQuery.RecordCount > 0) then
    begin
      InfoForm.DataSet := GridQuery;
      InfoForm.ShowModal;
    end;
  InfoForm.Free;
end;

procedure TfrmQuery.Show1Click(Sender: TObject);
begin
  grdResultDblClick(Sender);
end;

procedure TfrmQuery.btnClose1Click(Sender: TObject);
begin
  Close;
end;


function TfrmQuery.AppendToDataset(Dataset : TTable; var Correct,Wrong : integer;Deselect : Boolean): Boolean;
var
  FieldIndex: TSmallIntArray;
  tmpBookmarks: TStrings;
  tmpField : TField;
  i,j : integer;
begin
  FieldIndex := TSmallIntArray.Create(10,0);
  tmpBookmarks := TStringList.Create;

  Correct := 0;
  Wrong := grdResult.SelectedRows.Count;

  if Dataset.Active then
  begin
    Result := True;
    for i := 0 to GridQuery.FieldCount-1 do
    begin
      tmpField := Dataset.FindField(GridQuery.Fields[i].FieldName);
      if tmpField <> nil then
        if tmpField.DataType = GridQuery.Fields[i].DataType then
          FieldIndex.Add(i);
    end;
  end
  else
    Result := False;

  if (grdResult.SelectedRows.Count>0) and (FieldIndex.Count>0) and Result then
  begin
    Dataset.DisableControls;
    GridQuery.DisableControls;

    for i := 0 to grdResult.SelectedRows.Count-1 do
      tmpBookmarks.Add(string(grdResult.SelectedRows.Items[i]));

    for i := 0 to tmpBookmarks.Count-1 do
    begin
      GridQuery.Bookmark := TBookmarkStr(tmpBookmarks.Strings[i]);
      Dataset.Append;
      for j := 0 to FieldIndex.Count-1 do
      begin
        Dataset.FieldByName(GridQuery.Fields[FieldIndex.Items[j]].FieldName).Value :=
           GridQuery.Fields[FieldIndex.Items[j]].Value;
      end;
      try
        Dataset.Post;
        Correct := Correct + 1;
        Wrong := Wrong -1;
        if Deselect then
          grdResult.SelectedRows.CurrentRowSelected := False;
      except
        on Exception do
        begin
          DataSet.Cancel;
          Result := False;
        end;
      end;
    end;

    GridQuery.EnableControls;
    Dataset.EnableControls;
  end;

  tmpBookmarks.Free;
  FieldIndex.Free;
end;


procedure TfrmQuery.btnClose2Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmQuery.btnAppendClick(Sender: TObject);
var
  Correct,Wrong : Integer;
begin
  if not Assigned(FRelatedTable) then
    stuMessage.SimpleText := '无相关表！'
  else
  begin
    if not AppendToDataset(FRelatedTable,Correct,Wrong,True) then
      stuMessage.SimpleText := IntToStr(Correct)+'条记录插入正确：'+
                  IntToStr(Wrong)+'条记录插入异常！'
    else
    begin
      if (Correct=0) and (Wrong=0) then
        stuMessage.SimpleText := '无记录被选择！'
      else
        stuMessage.SimpleText := '全部正确插入！';
    end;
  end;
end;

procedure TfrmQuery.bthSelectAllClick(Sender: TObject);
var
  ABookmark: TBookmark;
begin
  with grdResult do
  begin
    if (dgMultiSelect in Options) and DataSource.DataSet.Active then
    begin
      with DataSource.Dataset do
      begin
        if (BOF and EOF) then Exit;
        DisableControls;
        try
          ABookmark := GetBookmark;
          try
            First;
            while not EOF do begin
              SelectedRows.CurrentRowSelected := True;
              Next;
            end;
          finally
            try
              GotoBookmark(ABookmark);
            except
            end;
            FreeBookmark(ABookmark);
          end;
        finally
          EnableControls;
        end;
      end;
    end;
  end;
end;

 { TTransTable }
constructor TTransTable.Create;
begin
  FItems := TList.Create;
end;

destructor TTransTable.Destroy;
begin
  Clear;
  FItems.Free;
  inherited Destroy;
end;

procedure TTransTable.Add(NewItem: TFieldInfo);
begin
  FItems.Add(NewItem);
end;

procedure TTransTable.Clear;
var
  i : integer;
begin
  for i := 0  to FItems.Count-1 do
  begin
    with TFieldInfo(FItems.Items[i]) do
    begin
      PickList.Free;
      Free;
    end;
  end;
  FItems.Clear;
end;

function TTransTable.GetFieldInfo(index : integer):TFieldInfo;
begin
  if (index >= 0) and (index < FItems.Count) then
    Result := TFieldInfo(FItems.Items[index])
  else
    Result := nil;
end;

function TTransTable.GetCount:integer;
begin
  Result := FItems.Count;
end;

procedure TTransTable.DefineProperties(Filer: TFiler);

  function WriteData: Boolean;
  begin
    if Filer.Ancestor <> nil then
      Result := True else
      Result := Count > 0;
  end;

begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('Data', ReadBinaryData, WriteBinaryData,
    True);
end;

procedure TTransTable.ReadBinaryData(Stream: TStream);
var
  I,j: Integer;
  Temp,Cnt1,Cnt2: Integer;
  s: string;
  NewItem: TFieldInfo;
begin
  Clear;
  with Stream do
  begin
    ReadBuffer(Cnt1,SizeOf(Cnt1));
    for I := 0 to Cnt1-1 do
    begin
      NewItem := TFieldInfo.Create;
      with NewItem do
      begin
        ReadBuffer(Temp, SizeOf(Temp));
        SetLength(s,Temp);
        ReadBuffer(PChar(s)^,Temp);
        FieldName := s;

        ReadBuffer(Temp, SizeOf(Temp));
        SetLength(s,Temp);
        ReadBuffer(PChar(s)^,Temp);
        DisplayName := s;

        ReadBuffer(FieldType,SizeOf(FieldType));

        PickList := TStringList.Create;
        ReadBuffer(Cnt2,SizeOf(Cnt2));
        for j := 0 to Cnt2-1 do
        begin
          ReadBuffer(Temp, SizeOf(Temp));
          SetLength(s,Temp);
          ReadBuffer(PChar(s)^,Temp);
          PickList.Add(s);
        end;
      end;
      FItems.Add(NewItem);
    end;
  end;
end;


procedure TTransTable.WriteBinaryData(Stream: TStream);
var
  I,j: Integer;
  Temp: Integer;
  s: string;
begin
  with Stream do
  begin
    Temp := Count;
    WriteBuffer(Temp, SizeOf(Temp));
    for I := 0 to Count - 1 do
      with TFieldInfo(FItems.Items[I]) do
      begin
        Temp := Length(FieldName);
        WriteBuffer(Temp, SizeOf(Temp));
        WriteBuffer(PChar(FieldName)^, Temp);

        Temp := Length(DisplayName);
        WriteBuffer(Temp, SizeOf(Temp));
        WriteBuffer(PChar(DisplayName)^, Temp);

        WriteBuffer(FieldType, SizeOf(FieldType));

        Temp := PickList.Count;
        WriteBuffer(Temp,SizeOf(Temp));
        for j := 0 to PickList.Count-1 do
        begin
          s := PickList.Strings[j];
          Temp := Length(s);
          WriteBuffer(Temp,SizeOf(Temp));
          WriteBuffer(PChar(s)^,Temp);
        end;
      end;
  end;
end;

procedure TTransTable.Assign(Source : TPersistent);
var
  i : integer;
  NewItem : TFieldInfo;
begin
  if Source is TTransTable then
  begin
    Clear;
    with (Source as TTransTable) do
    begin
      for i := 0 to Count-1 do
      begin
          NewItem := TFieldInfo.Create;
          NewItem.FieldName := Items[i].FieldName;
          NewItem.DisplayName := Items[i].DisplayName;
          NewItem.FieldType := Items[i].FieldType;
          NewItem.PickList := TStringList.Create;
          NewItem.PickList.Assign(Items[i].PickList);
          FItems.Add(NewItem);
      end;
    end;
  end;
end;


 { TQueryDialog }

constructor TQueryDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FQForm := TfrmQuery.Create(Self);
  FTransTable := TTransTable.Create;
end;

destructor TQueryDialog.Destroy;
begin
  if Assigned(FQForm) then
    FQForm.Free;
  FTransTable.Clear;
  FTransTable.Free;
  inherited Destroy;
end;

procedure TQueryDialog.SetDatabaseName(Value: string);
begin
  if (Value <> FDatabaseName) then
  begin
    FDatabaseName := Value;
    if not (csLoading in ComponentState) then
    begin
      FTableName :='';
      FTransTable.Clear;
    end;
  end;
end;

procedure TQueryDialog.SetTableName(Value : string);
var
  i : integer;
  Table : TTable;
  NewItem : TFieldInfo;
begin
  if (Value <> FTableName) then
  begin
    FTableName := Value;
    if not (csLoading in ComponentState) then
    begin
      FTransTable.Clear;
      Table := TTable.Create(Self);
      Table.DatabaseName := FDatabaseName;
      Table.TableName := FTableName;
      try
        Table.Active := True;
      except
        on Exception do;
      end;
      if Table.Active then
      begin
        for i := 0 to Table.FieldCount-1 do
        begin
          NewItem := TFieldInfo.Create;
          NewItem.FieldName := Table.Fields[i].FieldName;
          NewItem.DisplayName := '';
          NewItem.FieldType := TFieldType(Table.Fields[i].DataType);
          NewItem.PickList := TStringList.Create;
          FTransTable.Add(NewItem);
        end;
      end;
      Table.Free;
    end;
  end;
end;

function TQueryDialog.GetRelatedTable:TTable;
begin
  Result := FQForm.RelatedTable;
end;


procedure TQueryDialog.SetRelatedTable(Value : TTable);
begin
  if Value <> FQForm.RelatedTable then
    FQForm.RelatedTable := Value;
end;

function TQueryDialog.AppendToTable(Table : TTable;var Correct,Wrong :Integer):Boolean;
begin
    Result := FQForm.AppendToDataset(Table,Correct,Wrong,False);
end;

procedure TQueryDialog.Execute;
var
  i : integer;
  NewItem : TFieldInfo;
begin
  if FTransTable.Count <= 0 then
    Application.MessageBox('无字段存在！','错误',MB_OK)
  else
  begin
    if (DatabaseName <> FQForm.DatabaseName) or (TableName <> FQForm.TableName) then
    begin
      FQForm.RemoveAllGridList;
      FQForm.DatabaseName := DatabaseName;
      FQForm.TableName := TableName;
    end;

    with FQForm do
    begin
      lstFields.Clear;
      with FieldsList do
      begin
        for i:=0 to Count-1 do
        begin
          if TFieldInfo(Items[i]).PickList<>nil then
            TFieldInfo(Items[i]).PickList.Free;
          TFieldInfo(Items[i]).Free;
        end;
      end;
      FieldsList.Clear;
    end;
    for i := 0 to FTransTable.Count-1 do
    begin
      NewItem := TFieldInfo.Create;
      NewItem.FieldName := FTransTable.Items[i].FieldName;
      if FTransTable.Items[i].DisplayName <> '' then
        NewItem.DisplayName := FTransTable.Items[i].DisplayName
      else
        NewItem.DisplayName := FTransTable.Items[i].FieldName;
      NewItem.FieldType := FTransTable.Items[i].FieldType;
      NewItem.PickList := TStringList.Create;
      NewItem.PickList.Assign(FTransTable.Items[i].PickList);
      FQForm.FieldsList.Add(NewItem);
      if NewItem.FieldType in [ftString, ftSmallint, ftInteger, ftWord, ftFloat, ftDateTime, ftDate] then
        FQForm.lstFields.Items.AddObject(NewItem.DisplayName,NewItem);
    end;
    FQForm.Show;
  end;
end;

function TQueryDialog.PicklistByName(AName : string):TStrings;
var
  i : integer;
begin
  Result := nil;
  for i := 0 to FTransTable.Count-1 do
  begin
    if (FTransTable.Items[i].FieldName = AName) and (FTransTable.Items[i].FieldType = ftString) then
    begin
      Result := FTransTable.Items[i].Picklist;
      Exit;
    end;
  end;
end;

procedure Register;
begin
  RegisterComponents('PosControl', [TQueryDialog]);
end;



end.
