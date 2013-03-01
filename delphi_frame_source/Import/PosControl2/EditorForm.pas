unit EditorForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, RXCtrls, Grids, QueryDialog, Db;

type
  TfrmDisplayEditor = class(TForm)
    grdName: TRxDrawGrid;
    memPicklist: TMemo;
    RxLabel1: TRxLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure memPicklistExit(Sender: TObject);
    procedure grdNameDrawCell(Sender: TObject; Col, Row: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure grdNameShowEditor(Sender: TObject; ACol, ARow: Integer;
      var AllowEdit: Boolean);
    procedure grdNameGetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: String);
    procedure grdNameSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure grdNameSelectCell(Sender: TObject; Col, Row: Integer;
      var CanSelect: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    InternalList : TList;
  end;

implementation

{$R *.DFM}

procedure TfrmDisplayEditor.FormCreate(Sender: TObject);
begin
  grdName.ColWidths[0] := 100;
  grdName.ColWidths[1] := 150;
  memPicklist.Enabled := False;
end;

procedure TfrmDisplayEditor.memPicklistExit(Sender: TObject);
begin
  TFieldInfo(InternalList.Items[grdName.Row-1]).PickList.Assign(memPicklist.Lines);
end;

procedure TfrmDisplayEditor.grdNameDrawCell(Sender: TObject; Col,
  Row: Integer; Rect: TRect; State: TGridDrawState);
begin
  if Row=0 then
    case Col of
      0 : grdName.DrawStr(Rect,'FieldName',taCenter);
      1 : grdName.DrawStr(Rect,'DisplayName',taCenter);
    end
  else
    case Col of
      0 : grdName.DrawStr(Rect,TFieldInfo(InternalList.Items[Row-1]).FieldName,taLeftJustify);
      1 : grdName.DrawStr(Rect,TFieldInfo(InternalList.Items[Row-1]).DisplayName,taLeftJustify);
    end;
end;

procedure TfrmDisplayEditor.grdNameShowEditor(Sender: TObject; ACol,
  ARow: Integer; var AllowEdit: Boolean);
begin
  if (ACol=0) then
    AllowEdit := False
  else
    AllowEdit := True;  
end;

procedure TfrmDisplayEditor.grdNameGetEditText(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
begin
  case ACol of
    1 : Value := TFieldInfo(InternalList.Items[ARow-1]).DisplayName;
  end;
end;

procedure TfrmDisplayEditor.grdNameSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  case ACol of
    1 : TFieldInfo(InternalList.Items[ARow-1]).DisplayName := Value;
  end;
end;

procedure TfrmDisplayEditor.grdNameSelectCell(Sender: TObject; Col,
  Row: Integer; var CanSelect: Boolean);
begin
  memPicklist.Enabled := False;
  memPicklist.Lines := TFieldInfo(InternalList.Items[Row-1]).Picklist;
  RxLabel1.Caption := 'PickList';
  case TFieldInfo(InternalList.Items[Row-1]).FieldType of
    ftString : begin
                 memPicklist.Enabled := True;
                 RxLabel1.Caption :='PickList of '+TFieldInfo(InternalList.Items[Row-1]).FieldName;
               end;  
  end;
end;

end.
