unit DQueryDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RXCtrls, RXSplit, ExtCtrls, SpeedBar, ComCtrls, DBGrids, RXDBCtrl, Grids,
  StdCtrls, Db, DBTables, RxQuery, QueryDialog, MxArrays, MaxMin, PDBGrid;

type

 { TfrmDQuery }

  TfrmDQuery = class(TForm)
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    SpeedBar1: TSpeedBar;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    RxSplitter1: TRxSplitter;
    Panel4: TPanel;
    Panel5: TPanel;
    RxSplitter2: TRxSplitter;
    Panel6: TPanel;
    RxLabel1: TRxLabel;
    RxLabel2: TRxLabel;
    RxLabel3: TRxLabel;
    RxLabel4: TRxLabel;
    lstMasterFields: TTextListBox;
    lstDetailFields: TTextListBox;
    grdMasterExpression: TRxDrawGrid;
    grdDetailExpression: TRxDrawGrid;
    TabSheet1: TTabSheet;
    Panel7: TPanel;
    RxSplitter3: TRxSplitter;
    Panel8: TPanel;
    RxLabel5: TRxLabel;
    RxLabel6: TRxLabel;
    SpeedbarSection1: TSpeedbarSection;
    btnMasterAdd: TSpeedItem;
    btnMasterAddAll: TSpeedItem;
    btnMasterRemove: TSpeedItem;
    btnMasterRemoveAll: TSpeedItem;
    SpeedbarSection2: TSpeedbarSection;
    btnDetailAdd: TSpeedItem;
    btnDetailAddAll: TSpeedItem;
    btnDetailRemove: TSpeedItem;
    btnDetailRemoveAll: TSpeedItem;
    SpeedbarSection3: TSpeedbarSection;
    btnRun: TSpeedItem;
    SpeedbarSection4: TSpeedbarSection;
    btnClose: TSpeedItem;
    MasterQuery: TRxQuery;
    DetailQuery: TRxQuery;
    MasterSource: TDataSource;
    DetailSource: TDataSource;
    grdMasterResult: TDBGrid;
    grdDetailResult: TDBGrid;
    btnExport: TSpeedItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnMasterAddClick(Sender: TObject);
    procedure btnDetailAddClick(Sender: TObject);
    procedure btnMasterAddAllClick(Sender: TObject);
    procedure btnDetailAddAllClick(Sender: TObject);
    procedure btnMasterRemoveClick(Sender: TObject);
    procedure btnDetailRemoveClick(Sender: TObject);
    procedure btnMasterRemoveAllClick(Sender: TObject);
    procedure btnDetailRemoveAllClick(Sender: TObject);
    function grdMasterExpressionAcceptEditKey(Sender: TObject;
      var Key: Char): Boolean;
    function grdDetailExpressionAcceptEditKey(Sender: TObject;
      var Key: Char): Boolean;
    procedure grdMasterExpressionDrawCell(Sender: TObject; Col,
      Row: Integer; Rect: TRect; State: TGridDrawState);
    procedure grdDetailExpressionDrawCell(Sender: TObject; Col,
      Row: Integer; Rect: TRect; State: TGridDrawState);
    procedure grdMasterExpressionGetEditMask(Sender: TObject; ACol,
      ARow: Integer; var Value: String);
    procedure grdDetailExpressionGetEditMask(Sender: TObject; ACol,
      ARow: Integer; var Value: String);
    procedure grdMasterExpressionGetEditStyle(Sender: TObject; ACol,
      ARow: Integer; var Style: TInplaceEditStyle);
    procedure grdDetailExpressionGetEditStyle(Sender: TObject; ACol,
      ARow: Integer; var Style: TInplaceEditStyle);
    procedure grdMasterExpressionGetEditText(Sender: TObject; ACol,
      ARow: Integer; var Value: String);
    procedure grdDetailExpressionGetEditText(Sender: TObject; ACol,
      ARow: Integer; var Value: String);
    procedure grdMasterExpressionGetPicklist(Sender: TObject; ACol,
      ARow: Integer; PickList: TStrings);
    procedure grdDetailExpressionGetPicklist(Sender: TObject; ACol,
      ARow: Integer; PickList: TStrings);
    procedure grdMasterExpressionSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String);
    procedure grdDetailExpressionSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String);
    procedure grdMasterExpressionShowEditor(Sender: TObject; ACol,
      ARow: Integer; var AllowEdit: Boolean);
    procedure grdDetailExpressionShowEditor(Sender: TObject; ACol,
      ARow: Integer; var AllowEdit: Boolean);
    procedure btnCloseClick(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
  private
    { Private declarations }
    FMasterTableName: string;
    FDetailTableName: string;
    FMasterKeyField: string;
    FDetailKeyField: string;

    function GetDatabaseName:string;
    procedure SetDatabaseName(const Value : string);

    procedure AddClick(AlstFields: TTextListBox;AGridList: TList;AgrdExpression: TRxDrawGrid);
    procedure AddAllClick(AlstFields: TTextListBox;AGridList: TList;AgrdExpression: TRxDrawGrid);
    procedure RemoveClick(AGridList: TList;AgrdExpression: TRxDrawGrid);
    procedure RemoveAllClick(AGridList: TList;AgrdExpression: TRxDrawGrid);

    function grdExpressionAcceptEditKey(AGridList: TList;AgrdExpression: TRxDrawGrid;
      var Key: Char): Boolean;
    procedure grdExpressionDrawCell(AGridList: TList;AgrdExpression: TRxDrawGrid; Col,
      Row: Integer; Rect: TRect; State: TGridDrawState);
    procedure grdExpressionGetEditMask(AGridList: TList; ACol,
      ARow: Integer; var Value: String);
    procedure grdExpressionGetEditStyle(AGridList: TList; ACol,
      ARow: Integer; var Style: TInplaceEditStyle);
    procedure grdExpressionGetEditText(AGridList: TList; ACol,
      ARow: Integer; var Value: String);
    procedure grdExpressionGetPicklist(AGridList: TList; ACol,
      ARow: Integer; PickList: TStrings);
    procedure grdExpressionSetEditText(AGridList: TList; AgrdExpression: TRxDrawGrid; ACol,
      ARow: Integer; const Value: String);
    procedure grdExpressionShowEditor(AGridList: TList; ACol,
      ARow: Integer; var AllowEdit: Boolean);
  public
    { Public declarations }
    MasterFieldsList : TList;
    DetailFieldsList : TList;
    MasterGridList : TList;
    DetailGridList : TList;

    procedure RemoveAllGridList(List: TList);
    procedure RemoveFieldsList(List: TList);

    property MasterKeyField : string read FMasterKeyField write FMasterKeyField;
    property DetailKeyField : string read FDetailKeyField write FDetailKeyField;
  published
    property DatabaseName : string read GetDatabaseName write SetDatabaseName;
    property MasterTableName : string read FMasterTableName write FMasterTableName;
    property DetailTableName : string read FDetailTableName write FDetailTableName;
  end;

  { TDQueryDialog }

  TDQueryDialog = class(TComponent)
  private
    { Private declarations }
    FDatabaseName : string;
    FMasterTableName : string;
    FDetailTableName : string;
    FMasterTransTable : TTransTable;
    FDetailTransTable : TTransTable;
    FMasterKeyField : string;
    FDetailKeyField : string;

    FQForm : TfrmDQuery;

  protected
    { Protected declarations }
    procedure SetDatabaseName(Value: string);
    procedure SetMasterTableName(Value: string);
    procedure SetDetailTableName(Value: string);

  public
    { Public declarations }
    //procedure Execute;
    function    MasterDataset : TDataset;
    function    MasterGrid : TDBGrid;
    function Execute:integer;
    function MasterPicklistByName(AName : string):TStrings;
    function DetailPicklistByName(AName : string):TStrings;
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
  published
    { Published declarations }
    property DatabaseName:string read FDatabaseName write SetDatabaseName;
    property MasterTableName:string read FMasterTableName write SetMasterTableName;
    property DetailTableName:string read FDetailTableName write SetDetailTableName;
    property MasterTransTable:TTransTable read FMasterTransTable write FMasterTransTable;
    property DetailTransTable:TTransTable read FDetailTransTable write FDetailTransTable;
    property MasterKeyField:string read FMasterKeyField write FMasterKeyField;
    property DetailKeyField:string read FDetailKeyField write FDetailKeyField;

  end;

procedure Register;

implementation

{$R *.DFM}

procedure Register;
begin
  RegisterComponents('PosControl', [TDQueryDialog]);
end;


function TfrmDQuery.GetDatabaseName:string;
begin
  Result := MasterQuery.DatabaseName;
end;

procedure TfrmDQuery.SetDatabaseName(const Value : string);
begin
  if MasterQuery.DatabaseName <> Value then
  begin
    MasterQuery.Close;
    DetailQuery.Close;
    MasterQuery.DatabaseName := Value;
    DetailQuery.DatabaseName := Value;
  end;
end;

procedure TfrmDQuery.FormCreate(Sender: TObject);
begin
  MasterFieldsList := TList.Create;
  DetailFieldsList := TList.Create;

  MasterGridList := TList.Create;
  DetailGridList := TList.Create;

  grdMasterExpression.RowCount := MinLines;
  grdMasterExpression.ColWidths[0] := 10;
  grdMasterExpression.ColWidths[1] := 120;
  grdMasterExpression.ColWidths[2] := 80;
  grdMasterExpression.ColWidths[3] := 140;

  grdDetailExpression.RowCount := MinLines;
  grdDetailExpression.ColWidths[0] := 10;
  grdDetailExpression.ColWidths[1] := 120;
  grdDetailExpression.ColWidths[2] := 80;
  grdDetailExpression.ColWidths[3] := 140;
end;

procedure TfrmDQuery.FormDestroy(Sender: TObject);
begin
  RemoveAllGridList(MasterGridList);
  RemoveAllGridList(DetailGridList);
  MasterGridList.Free;
  DetailGridList.Free;

  RemoveFieldsList(MasterFieldsList);
  RemoveFieldsList(DetailFieldsList);
  MasterFieldsList.Free;
  DetailFieldsList.Free;
end;

procedure TfrmDQuery.RemoveAllGridList(List: TList);
var
  i: integer;
begin
  with List do
  begin
    for i := 0 to Count-1 do
    begin
      TFieldItem(Items[i]).PickList := nil;
      TFieldItem(Items[i]).Free;
    end;
    Clear;
  end;
end;

procedure TfrmDQuery.RemoveFieldsList(List: TList);
var
  i: integer;
begin
  with List do
  begin
    for i:=0 to Count-1 do
    begin
      if TFieldInfo(Items[i]).PickList<>nil then
         TFieldInfo(Items[i]).PickList.Free;
      TFieldInfo(Items[i]).Free;
    end;
    Clear;
  end;
end;

procedure TfrmDQuery.AddClick(AlstFields: TTextListBox;AGridList: TList;AgrdExpression: TRxDrawGrid);
var
  i : integer;
  NewItem : TFieldItem;
begin
  with AlstFields do
  begin
    for i := 0 to Items.Count-1 do
      if Selected[i] then
      begin
        NewItem := TFieldItem.Create;
        NewItem.FieldName := (Items.Objects[i] as TFieldInfo).FieldName;
        NewItem.DisplayName := (Items.Objects[i] as TFieldInfo).DisplayName;
        NewItem.FieldType := (Items.Objects[i] as TFieldInfo).FieldType;
        NewItem.PickList := (Items.Objects[i] as TFieldInfo).PickList;
        NewItem.Data := '';
        NewItem.Operator := '<';
        AGridList.Add(NewItem);
        Selected[i] := False;
      end;
    AgrdExpression.RowCount := Max(AGridList.Count+1,MinLines);
    AgrdExpression.Repaint;
  end;
end;

procedure TfrmDQuery.btnMasterAddClick(Sender: TObject);
begin
  AddClick(lstMasterFields,MasterGridList,grdMasterExpression);
end;

procedure TfrmDQuery.btnDetailAddClick(Sender: TObject);
begin
  AddClick(lstDetailFields,DetailGridList,grdDetailExpression);
end;

procedure TfrmDQuery.AddAllClick(AlstFields: TTextListBox;AGridList: TList;AgrdExpression: TRxDrawGrid);
var
  i : integer;
  NewItem : TFieldItem;
begin
 with AlstFields do
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
      AGridList.Add(NewItem);
      Selected[i] := False;
    end;
    AgrdExpression.RowCount := Max(AGridList.Count+1,MinLines);
    AgrdExpression.Repaint;
  end;
end;

procedure TfrmDQuery.btnMasterAddAllClick(Sender: TObject);
begin
  AddAllClick(lstMasterFields,MasterGridList,grdMasterExpression);
end;

procedure TfrmDQuery.btnDetailAddAllClick(Sender: TObject);
begin
  AddAllClick(lstDetailFields,DetailGridList,grdDetailExpression);
end;

procedure TfrmDQuery.RemoveClick(AGridList: TList;AgrdExpression: TRxDrawGrid);
begin
  with AgrdExpression do
  begin
    if Row<=AGridList.Count then
    begin
      EditorMode := False;
      TFieldItem(AGridList.Items[Row-1]).PickList := nil;
      TFieldItem(AGridList.Items[Row-1]).Free;
      AGridList.Delete(Row-1);
      RowCount := Max(AGridList.Count+1,MinLines);
      repaint;
    end;
  end;
end;


procedure TfrmDQuery.btnMasterRemoveClick(Sender: TObject);
begin
  RemoveClick(MasterGridList,grdMasterExpression);
end;

procedure TfrmDQuery.btnDetailRemoveClick(Sender: TObject);
begin
  RemoveClick(DetailGridList,grdDetailExpression);
end;

procedure TfrmDQuery.RemoveAllClick(AGridList: TList;AgrdExpression: TRxDrawGrid);
begin
  AgrdExpression.Col := 1;
  RemoveAllGridList(AGridList);
  AgrdExpression.RowCount := Max(AGridList.Count+1,MinLines);
  AgrdExpression.Repaint;
  AgrdExpression.Row := 1;
end;


procedure TfrmDQuery.btnMasterRemoveAllClick(Sender: TObject);
begin
  RemoveAllClick(MasterGridList,grdMasterExpression);
end;

procedure TfrmDQuery.btnDetailRemoveAllClick(Sender: TObject);
begin
  RemoveAllClick(DetailGridList,grdDetailExpression);
end;

function TfrmDQuery.grdExpressionAcceptEditKey(AGridList: TList;AgrdExpression: TRxDrawGrid;
      var Key: Char): Boolean;
begin
  Result := True;
  case AgrdExpression.Col of
    2 : Result := False;
    3 : Case TFieldItem(AGridList.Items[AgrdExpression.Row-1]).FieldType of
          ftDate, ftDateTime : if not (Key in ['0'..'9']) then
                                         Result := False;
          ftSmallint, ftInteger, ftWord : if not (Key in['0'..'9','+','-']) then Result := False;
          ftFloat : if not (Key in ['0'..'9','+','-','.']) then Result := False;
        end;
  end;
end;


function TfrmDQuery.grdMasterExpressionAcceptEditKey(Sender: TObject;
  var Key: Char): Boolean;
begin
  Result := grdExpressionAcceptEditKey(MasterGridList,grdMasterExpression,Key);
end;

function TfrmDQuery.grdDetailExpressionAcceptEditKey(Sender: TObject;
  var Key: Char): Boolean;
begin
  Result := grdExpressionAcceptEditKey(DetailGridList,grdDetailExpression,Key);
end;

procedure TfrmDQuery.grdExpressionDrawCell(AGridList: TList;AgrdExpression: TRxDrawGrid; Col,
  Row: Integer; Rect: TRect; State: TGridDrawState);
begin
  if Row=0 then
  begin
    case Col of
      1 : AgrdExpression.DrawStr(Rect,'字段名',taCenter);
      2 : AgrdExpression.DrawStr(Rect,'运算符',taCenter);
      3 : AgrdExpression.DrawStr(Rect,'条件值',taCenter);
    end;
  end
  else if Row<=AGridList.Count then
  begin
    case Col of
      1 : AgrdExpression.DrawStr(Rect,TFieldItem(AGridList.Items[Row-1]).DisplayName,taRightJustify);
      2 : AgrdExpression.DrawStr(Rect,TFieldItem(AGridList.Items[Row-1]).Operator,taCenter);
      3 : AgrdExpression.DrawStr(Rect,TFieldItem(AGridList.Items[Row-1]).Data,taLeftJustify);
    end;
  end;
end;


procedure TfrmDQuery.grdMasterExpressionDrawCell(Sender: TObject; Col,
  Row: Integer; Rect: TRect; State: TGridDrawState);
begin
  grdExpressionDrawCell(MasterGridList,grdMasterExpression,Col,Row,Rect,State);
end;

procedure TfrmDQuery.grdDetailExpressionDrawCell(Sender: TObject; Col,
  Row: Integer; Rect: TRect; State: TGridDrawState);
begin
  grdExpressionDrawCell(DetailGridList,grdDetailExpression,Col,Row,Rect,State);
end;

procedure TfrmDQuery.grdExpressionGetEditMask(AGridList: TList; ACol,
   ARow: Integer; var Value: String);
begin
  case ACol of
    3 : begin
          case TFieldItem(AGridList.Items[ARow-1]).FieldType of
            ftDate, ftDateTime : Value := '!99/99/00;1;_';
          end;
        end;
  end;
end;


procedure TfrmDQuery.grdMasterExpressionGetEditMask(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
begin
  grdExpressionGetEditMask(MasterGridList,ACol,ARow,Value);
end;

procedure TfrmDQuery.grdDetailExpressionGetEditMask(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
begin
  grdExpressionGetEditMask(DetailGridList,ACol,ARow,Value);
end;

procedure TfrmDQuery.grdExpressionGetEditStyle(AGridList: TList; ACol,
      ARow: Integer; var Style: TInplaceEditStyle);
begin
  Case ACol of
    2 : Style :=iePicklist;
    3 : begin
          case TFieldItem(AGridList.Items[ARow-1]).FieldType of
            ftString : if TFieldItem(AGridList.Items[ARow-1]).Picklist.Count>0 then
                         Style := iePicklist;
          end;
        end;
  end;
end;

procedure TfrmDQuery.grdMasterExpressionGetEditStyle(Sender: TObject; ACol,
  ARow: Integer; var Style: TInplaceEditStyle);
begin
  grdExpressionGetEditStyle(MasterGridList,ACol,ARow,Style);
end;

procedure TfrmDQuery.grdDetailExpressionGetEditStyle(Sender: TObject; ACol,
  ARow: Integer; var Style: TInplaceEditStyle);
begin
  grdExpressionGetEditStyle(DetailGridList,ACol,ARow,Style);
end;

procedure TfrmDQuery.grdExpressionGetEditText(AGridList: TList; ACol,
      ARow: Integer; var Value: String);
begin
 if ARow<=AGridList.Count then
  begin
    case ACol of
      2 : Value := TFieldItem(AGridList.Items[ARow-1]).Operator;
      3 : Value := TFieldItem(AGridList.Items[ARow-1]).Data;
    end;
  end;
end;


procedure TfrmDQuery.grdMasterExpressionGetEditText(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
begin
  grdExpressionGetEditText(MasterGridList,ACol,ARow,Value);
end;

procedure TfrmDQuery.grdDetailExpressionGetEditText(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
begin
  grdExpressionGetEditText(DetailGridList,ACol,ARow,Value);
end;

procedure TfrmDQuery.grdExpressionGetPicklist(AGridList: TList; ACol,
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
          case TFieldItem(AGridList.Items[ARow-1]).FieldType of
            ftString: begin
                        PickList.Add('LIKE');
                        PickList.Add('NOT LIKE');
                      end;
            ftDate, ftDateTime : ;
            ftSmallint, ftInteger, ftWord, ftFloat : ;
          end;
        end;
    3 : begin
          case TFieldItem(AGridList.Items[ARow-1]).FieldType of
            ftString : if TFieldItem(AGridList.Items[ARow-1]).PickList.Count > 0 then
                         PickList.Assign(TFieldItem(AGridList.Items[ARow-1]).PickList);
          end;
        end;
  end;
end;


procedure TfrmDQuery.grdMasterExpressionGetPicklist(Sender: TObject; ACol,
  ARow: Integer; PickList: TStrings);
begin
  grdExpressionGetPicklist(MasterGridList,ACol,ARow,PickList);
end;

procedure TfrmDQuery.grdDetailExpressionGetPicklist(Sender: TObject; ACol,
  ARow: Integer; PickList: TStrings);
begin
  grdExpressionGetPicklist(DetailGridList,ACol,ARow,PickList);
end;

procedure TfrmDQuery.grdExpressionSetEditText(AGridList: TList; AgrdExpression: TRxDrawGrid; ACol,
      ARow: Integer; const Value: String);
begin
  Case AgrdExpression.Col of
    2 : TFieldItem(AGridList.Items[ARow-1]).Operator := Value;
    3 : TFieldItem(AGridList.Items[ARow-1]).Data := Value;
  end;
end;

procedure TfrmDQuery.grdMasterExpressionSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  grdExpressionSetEditText(MasterGridList,grdMasterExpression,ACol,ARow,Value);
end;

procedure TfrmDQuery.grdDetailExpressionSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  grdExpressionSetEditText(DetailGridList,grdDetailExpression,ACol,ARow,Value);
end;

procedure TfrmDQuery.grdExpressionShowEditor(AGridList: TList; ACol,
      ARow: Integer; var AllowEdit: Boolean);
begin
  if (ACol=1) or (ARow>AGridList.Count) then AllowEdit := False;
end;


procedure TfrmDQuery.grdMasterExpressionShowEditor(Sender: TObject; ACol,
  ARow: Integer; var AllowEdit: Boolean);
begin
  grdExpressionShowEditor(MasterGridList,ACol,ARow,AllowEdit);
end;

procedure TfrmDQuery.grdDetailExpressionShowEditor(Sender: TObject; ACol,
  ARow: Integer; var AllowEdit: Boolean);
begin
  grdExpressionShowEditor(DetailGridList,ACol,ARow,AllowEdit);
end;

procedure TfrmDQuery.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmDQuery.btnRunClick(Sender: TObject);
var
  i : integer;
  tmpField : TField;
  OldShortDateFormat: string;
begin

  MasterQuery.Close;
  MasterQuery.SQL.Clear;
  DetailQuery.Close;
  DetailQuery.SQL.Clear;

  if (DatabaseName<>'') and (MasterTableName<>'') and (DetailTableName<>'') then
  begin
    grdMasterExpression.EditorMode := False;
    grdDetailExpression.EditorMode := False;
    // begin Master
    try
      if (Pos('.',FMasterTableName)<>0) or (Pos('.',FDetailTableName)<>0) then
      begin
        MasterQuery.SQL.Add('Select * from '+FMasterTableName+' As M ');
        MasterQuery.SQL.Add(' where ');
        MasterQuery.SQL.Add('(Select Count(*) from '+FDetailTableName+' As D where ');
        MasterQuery.SQL.Add('D'+'.'+FDetailKeyField+'='+'M'+'.'+FMasterKeyField);
      end
      else
      begin
        MasterQuery.SQL.Add('Select * from '+FMasterTableName);
        MasterQuery.SQL.Add(' where ');
        MasterQuery.SQL.Add('(Select Count(*) from '+FDetailTableName+' where ');
        MasterQuery.SQL.Add(FDetailTableName+'.'+FDetailKeyField+'='+FMasterTableName+'.'+FMasterKeyField);
      end;

      OldShortDateFormat := ShortDateFormat;
      ShortDateFormat := 'mm'+DateSeparator+'dd'+DateSeparator+'yy';

      for i := 0 to DetailGridList.Count-1 do
      begin
        with TFieldItem(DetailGridList.Items[i]) do
        begin
          MasterQuery.SQL.Add(' and '+FieldName+' '+Operator+' '+':DParam'+IntToStr(i));
          MasterQuery.Params.ParamByName('DParam'+IntToStr(i)).DataType := FieldType;
          MasterQuery.Params.ParamByName('DParam'+IntToStr(i)).Text := Data;
        end;
      end;

      MasterQuery.SQL.Add(')>0 ');

      if MasterGridList.Count>0 then
      begin
        for i := 0 to MasterGridList.Count-1 do
        begin
          with TFieldItem(MasterGridList.Items[i]) do
          begin
            MasterQuery.SQL.Add(' and '+FieldName+' '+Operator+' '+':MParam'+IntToStr(i));
            MasterQuery.Params.ParamByName('MParam'+IntToStr(i)).DataType := FieldType;
            MasterQuery.Params.ParamByName('MParam'+IntToStr(i)).Text := Data;
          end;
        end;
      end;
      MasterQuery.Open;
    except
      on Exception do
      begin
        ShowMessage('条件错误或数据库为空！');
        ShortDateFormat := OldShortDateFormat;
        Exit;
      end;
    end;

    ShortDateFormat := OldShortDateFormat;
    {
    for i := 0 to MasterFieldsList.Count-1 do
    begin
      tmpField := MasterQuery.FindField(TFieldInfo(MasterFieldsList.Items[i]).FieldName);
      if tmpField <> nil then
        tmpField.DisplayLabel := TFieldInfo(MasterFieldsList.Items[i]).DisplayName;
    end; }
    grdMasterResult.Columns.Clear;
    with grdMasterResult.Columns do
    for i:=0 to MasterFieldsList.Count-1 do
    with Add do
    begin
      FieldName := TFieldInfo(MasterFieldsList.Items[i]).FieldName;
      Title.Caption := TFieldInfo(MasterFieldsList.Items[i]).DisplayName;
    end;

    // end Master

    // start Detail
    DetailQuery.SQL.Add('Select * from '+FDetailTableName);
    try
      DetailQuery.SQL.Add(' where '+FDetailKeyField+'=:'+FMasterKeyField);
      DetailQuery.ParamByName(FMasterKeyField).DataType :=
            MasterQuery.FieldByName(FMasterKeyField).DataType;
      if DetailGridList.Count>0 then
      begin
        OldShortDateFormat := ShortDateFormat;
        ShortDateFormat := 'mm'+DateSeparator+'dd'+DateSeparator+'yy';
        for i := 0 to DetailGridList.Count-1 do
        begin
          with TFieldItem(DetailGridList.Items[i]) do
          begin
            DetailQuery.SQL.Add(' and '+FieldName+' '+Operator+' '+':DParam'+IntToStr(i));
            DetailQuery.Params.ParamByName('DParam'+IntToStr(i)).DataType := FieldType;
            DetailQuery.Params.ParamByName('DParam'+IntToStr(i)).Text := Data;
          end;
        end;
      end;
      ShortDateFormat := OldShortDateFormat;
      DetailQuery.Open;
      PageControl1.SelectNextPage(True);
    except
      on Exception do
      begin
        ShowMessage('条件错误或数据库为空！');
        ShortDateFormat := OldShortDateFormat;
        Exit;
      end;
    end;

    {
    for i := 0 to DetailFieldsList.Count-1 do
    begin
      tmpField := DetailQuery.FindField(TFieldInfo(DetailFieldsList.Items[i]).FieldName);
      if tmpField <> nil then
        tmpField.DisplayLabel := TFieldInfo(DetailFieldsList.Items[i]).DisplayName;
    end; }

    grdDetailResult.Columns.Clear;
    with grdDetailResult.Columns do
    for i:=0 to DetailFieldsList.Count-1 do
    with Add do
    begin
      FieldName := TFieldInfo(DetailFieldsList.Items[i]).FieldName;
      Title.Caption := TFieldInfo(DetailFieldsList.Items[i]).DisplayName;
    end;
    // end Detail
  end;
end;

  { TDQueryDialog }

constructor TDQueryDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FQForm := TfrmDQuery.Create(Self);
  FMasterTransTable := TTransTable.Create;
  FDetailTransTable := TTransTable.Create;
end;

destructor TDQueryDialog.Destroy;
begin
  if Assigned(FQForm) then
    FQForm.Free;
  FMasterTransTable.Clear;
  FMasterTransTable.Free;
  FDetailTransTable.Clear;
  FDetailTransTable.Free;
  inherited Destroy;
end;

procedure TDQueryDialog.SetDatabaseName(Value: string);
begin
  if (Value <> FDatabaseName) then
  begin
    FDatabaseName := Value;
    if not (csLoading in ComponentState) then
    begin
      FMasterTableName :='';
      FMasterTransTable.Clear;
      FDetailTableName :='';
      FDetailTransTable.Clear;
    end;
  end;
end;

procedure TDQueryDialog.SetMasterTableName(Value : string);
var
  i : integer;
  Table : TTable;
  NewItem : TFieldInfo;
begin
  if (Value <> FMasterTableName) then
  begin
    FMasterTableName := Value;
    if not (csLoading in ComponentState) then
    begin
      FMasterTransTable.Clear;
      Table := TTable.Create(Self);
      Table.DatabaseName := FDatabaseName;
      Table.TableName := FMasterTableName;
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
          FMasterTransTable.Add(NewItem);
        end;
      end;
      Table.Free;
    end;
  end;
end;

procedure TDQueryDialog.SetDetailTableName(Value : string);
var
  i : integer;
  Table : TTable;
  NewItem : TFieldInfo;
begin
  if (Value <> FDetailTableName) then
  begin
    FDetailTableName := Value;
    if not (csLoading in ComponentState) then
    begin
      FDetailTransTable.Clear;
      Table := TTable.Create(Self);
      Table.DatabaseName := FDatabaseName;
      Table.TableName := FDetailTableName;
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
          FDetailTransTable.Add(NewItem);
        end;
      end;
      Table.Free;
    end;
  end;
end;

function TDQueryDialog.MasterPicklistByName(AName : string):TStrings;
var
  i : integer;
begin
  Result := nil;
  for i := 0 to FMasterTransTable.Count-1 do
  begin
    if (FMasterTransTable.Items[i].FieldName = AName) and (FMasterTransTable.Items[i].FieldType = ftString) then
    begin
      Result := FMasterTransTable.Items[i].Picklist;
      Exit;
    end;
  end;
end;

function TDQueryDialog.DetailPicklistByName(AName : string):TStrings;
var
  i : integer;
begin
  Result := nil;
  for i := 0 to FDetailTransTable.Count-1 do
  begin
    if (FDetailTransTable.Items[i].FieldName = AName) and (FDetailTransTable.Items[i].FieldType = ftString) then
    begin
      Result := FDetailTransTable.Items[i].Picklist;
      Exit;
    end;
  end;
end;

function TDQueryDialog.Execute:integer;
//procedure TDQueryDialog.Execute;
var
  i : integer;
  NewItem : TFieldInfo;
begin
  if FMasterTransTable.Count <= 0 then
    ShowMessage('无主字段存在！')
  else if FDetailTransTable.Count <= 0 then
    ShowMessage('无从字段存在！')
  else
  begin
    if (DatabaseName <> FQForm.DatabaseName)
       or (MasterTableName <> FQForm.MasterTableName)
       or (DetailTableName <> FQForm.DetailTableName)
       or (MasterKeyField <> FQForm.MasterKeyField)
       or (DetailKeyField <> FQForm.DetailKeyField) then
    begin
      FQForm.RemoveAllGridList(FQForm.MasterGridList);
      FQForm.RemoveAllGridList(FQForm.DetailGridList);
      FQForm.DatabaseName := DatabaseName;
      FQForm.MasterTableName := MasterTableName;
      FQForm.DetailTableName := DetailTableName;
      FQForm.MasterKeyField := MasterKeyField;
      FQForm.DetailKeyField := DetailKeyField;
    end;

    with FQForm do
    begin
      lstMasterFields.Clear;
      lstDetailFields.Clear;
      RemoveFieldsList(MasterFieldsList);
      RemoveFieldsList(DetailFieldsList);
    end;

    for i := 0 to FMasterTransTable.Count-1 do
    begin
      NewItem := TFieldInfo.Create;
      NewItem.FieldName := FMasterTransTable.Items[i].FieldName;
      if FMasterTransTable.Items[i].DisplayName <> '' then
      begin
        NewItem.DisplayName := FMasterTransTable.Items[i].DisplayName;
      (*else
        ewItem.DisplayName := {'Bug:'+}FMasterTransTable.Items[i].FieldName;*)
        NewItem.FieldType := FMasterTransTable.Items[i].FieldType;
        NewItem.PickList := TStringList.Create;
        NewItem.PickList.Assign(FMasterTransTable.Items[i].PickList);
        FQForm.MasterFieldsList.Add(NewItem);
        if NewItem.FieldType in [ftString, ftSmallint, ftInteger, ftWord, ftFloat, ftDateTime, ftDate] then
          FQForm.lstMasterFields.Items.AddObject(NewItem.DisplayName,NewItem);
      end;
    end;

    for i := 0 to FDetailTransTable.Count-1 do
    begin
      NewItem := TFieldInfo.Create;
      NewItem.FieldName := FDetailTransTable.Items[i].FieldName;
      if FDetailTransTable.Items[i].DisplayName <> '' then
      begin
        NewItem.DisplayName := FDetailTransTable.Items[i].DisplayName;
      {else
        NewItem.DisplayName := FDetailTransTable.Items[i].FieldName;}
        NewItem.FieldType := FDetailTransTable.Items[i].FieldType;
        NewItem.PickList := TStringList.Create;
        NewItem.PickList.Assign(FDetailTransTable.Items[i].PickList);
        FQForm.DetailFieldsList.Add(NewItem);
        if NewItem.FieldType in [ftString, ftSmallint, ftInteger, ftWord, ftFloat, ftDateTime, ftDate] then
          FQForm.lstDetailFields.Items.AddObject(NewItem.DisplayName,NewItem);
      end;
    end;

    result := FQForm.ShowModal;
  end;
end;


function    TDQueryDialog.MasterDataset : TDataset;
begin
  result := FQForm.MasterQuery;
end;

function  TDQueryDialog.MasterGrid : TDBGrid;
begin
  result := FQForm.grdMasterResult;
end;


procedure TfrmDQuery.btnExportClick(Sender: TObject);
begin
  modalResult:=mrYes;
end;


end.
