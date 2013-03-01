{ :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: QuickReport 2.0 for Delphi 1.0/2.0/3.0                  ::
  ::                                                         ::
  :: QRDATASU.PAS -  QuickReport data setup dialog           ::
  ::                                                         ::
  :: Copyright (c) 1997 QuSoft AS                            ::
  :: All Rights Reserved                                     ::
  ::                                                         ::
  :: web: http://www.qusoft.no    mail: support@qusoft.no    ::
  ::                              fax: +47 22 41 74 91       ::
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: }

unit qrdatasu;

interface

uses
{$ifdef win32}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls, db, dbtables, filectrl, quickrpt;
{$else}
  Wintypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls, db, dbtables, filectrl, quickrpt;
{$endif}

type
  TQRDataSetup = class(TForm)
    DataType: TRadioGroup;
    AliasGB: TGroupBox;
    BrowseButton: TButton;
    DataBaseName: TComboBox;
    TableGroup: TGroupBox;
    TableName: TComboBox;
    FilterExpression: TEdit;
    Label1: TLabel;
    FilterLabel: TLabel;
    SQLGroup: TGroupBox;
    SQL: TMemo;
    OpenSQL: TButton;
    OKButton: TBitBtn;
    BitBtn2: TBitBtn;
    Label3: TLabel;
    IndexName: TComboBox;
    procedure DataTypeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BrowseButtonClick(Sender: TObject);
    procedure DataBaseNameChange(Sender: TObject);
    procedure TableNameChange(Sender: TObject);
    procedure SQLChange(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    FReport : TQuickRep;
    TableComp : TTable;
    QueryComp : TQuery;
  protected
    procedure GetEditValues;
    procedure SetReport(Value : TQuickRep);
    procedure SetData;
  public
    property QuickRep : TQuickRep read FReport write SetReport;
  end;

var
  QRDataSetup: TQRDataSetup;

implementation

{$R *.DFM}

procedure Enable(Control : TWinControl; Enabled : boolean);
var
  i : integer;
begin
  Control.Enabled:=Enabled;
  for i:=0 to Control.ControlCount-1 do
    Control.Controls[I].Enabled:=Enabled;
end;

procedure TQRDataSetup.GetEditValues;
begin
  case DataType.ItemIndex of
    0 : begin
          TableName.Items.Clear;
          IndexName.Items.Clear;
          TableName.Text := '';
          IndexName.Text := '';
          FilterExpression.Text := '';
          SQL.Lines.Clear;
        end;
    1 : begin
          if TableComp.DatabaseName <> '' then
          begin
            DatabaseNameChange(Self);
            DatabaseName.Text := TableComp.DatabaseName
          end else
            TableComp.DatabaseName := DatabaseName.Text;
          TableName.Text := TableComp.TableName;
          IndexName.Text := TableComp.IndexName;
          {$ifdef win32}
          FilterExpression.Text := TableComp.Filter;
          {$endif}
          SQL.Lines.Clear;
        end;
    2 : begin
          TableName.Items.Clear;
          IndexName.Items.Clear;
          TableName.Text := '';
          IndexName.Text := '';
          FilterExpression.Text := '';
          SQL.Lines.Assign(QueryComp.SQL);
          if QueryComp.DatabaseName <> '' then
          begin
            DatabaseName.Text := QueryComp.DatabaseName;
            DatabaseNameChange(Self)
          end else
            QueryComp.DatabaseName := DatabaseName.Text;
        end;
  end;
end;

procedure TQRDataSetup.SetData;
begin
  case DataType.ItemIndex of
    1 : begin
          TableComp.Active := false;
          TableComp.DatabaseName := DatabaseName.Text;
          TableComp.TableName := TableName.Text;
          TableComp.IndexName := IndexName.Text;
          {$ifdef win32}
          TableComp.Filter := FilterExpression.Text;
          if FilterExpression.Text <> '' then
            TableComp.Filtered := true;
          {$endif}
          if TableComp.TableName <> '' then
            TableComp.Active := true;
        end;
    2: begin
         QueryComp.Active := false;
         QueryComp.SQL.Assign(SQL.Lines);
         QueryComp.DatabaseName := DatabaseName.Text;
         QueryComp.Active := true;
       end;
  end
end;

procedure TQRDataSetup.DataTypeClick(Sender: TObject);
begin
  Enable(TableGroup,DataType.ItemIndex = 1);
  Enable(SQLGroup, DataType.ItemIndex = 2);
  case DataType.ItemIndex of
    0 : begin
          if TableComp <> nil then
          begin
            TableComp.Free;
            TableComp := nil;
          end;
          if assigned(QueryComp) then
          begin
            QueryComp.Free;
            QueryComp := nil;
          end;
        end;
    1 : begin
          if TableComp = nil then
          begin
            TableComp := TTable.Create(FReport.Owner);
            TableComp.Name := UniqueName(FReport.Owner, 'Table'); {<-- do not resource}
            FReport.DataSet := TableComp;
          end;
          if assigned(QueryComp) then
          begin
            QueryComp.Free;
            QueryComp := nil;
          end;
        end;
    2 : begin
          if QueryComp = nil then
          begin
            QueryComp := TQuery.Create(FReport.Owner);
            QueryComp.Name := UniqueName(FReport.Owner, 'Query');  {<-- do not resource}
            FReport.DataSet := QueryComp;
          end;
          if assigned(TableComp) then begin
            TableComp.Free;
            TableComp := nil;
          end;
        end;
    end;
    GetEditValues;
end;

procedure TQRDataSetup.FormCreate(Sender: TObject);
begin
  Session.GetDatabaseNames(DataBaseName.Items);
{$ifndef win32}
  FilterExpression.Visible := false;
  FilterLabel.Visible := false;
{$endif}
  GetEditValues;
end;

procedure TQRDataSetup.SetReport(Value : TQuickRep);
begin
  FReport := Value;
  if FReport.DataSet <> nil then
  begin
    if FReport.DataSet is TTable then
    begin
      TableComp := TTable(FReport.DataSet);
      DataType.ItemIndex := 1;
    end;
    if FReport.DataSet is TQuery then
    begin
      QueryComp := TQuery(FReport.DataSet);
      DataType.ItemIndex := 2;
    end;
  end;
  DataTypeClick(Self);
end;

procedure TQRDataSetup.BrowseButtonClick(Sender: TObject);
var
  ADirectory : String;
begin
  ADirectory := '';
  if SelectDirectory(ADirectory,[],0) then
    DatabaseName.Text:=ADirectory;
  DatabaseNameChange(Self);
end;

procedure TQRDataSetup.DataBaseNameChange(Sender: TObject);
begin
  Session.GetTableNames(DatabaseName.Text, '', true, false, TableName.Items);
  case DataType.ItemIndex of
    1 : if TableName.Items.IndexOf(TableName.Text) = -1 then
           TableName.Text := '';
  end;
end;


procedure TQRDataSetup.TableNameChange(Sender: TObject);
begin
  if TableName.Text <> TableComp.TableName then
  begin
    TableComp.Active := false;
    TableComp.IndexName := '';
    TableComp.DatabaseName := DatabaseName.Text;
    TableComp.TableName := TableName.Text;
    if TableName.Text <> '' then
      TableComp.Active := true;
    IndexName.Items.Clear;
    IndexName.Text := '';
    TableComp.GetIndexNames(IndexName.Items);
  end
end;

procedure TQRDataSetup.SQLChange(Sender: TObject);
begin
  OpenSQL.Enabled := true;
end;

procedure TQRDataSetup.OKButtonClick(Sender: TObject);
begin
  SetData;
end;

end.
