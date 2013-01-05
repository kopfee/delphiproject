unit uPhotoQuery;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ExtCtrls, DBGridEh, StdCtrls, Mask, DBCtrlsEh, DBLookupEh,
    Buttons, GridsEh, IniFiles, DB, jpeg, Ora, DBAccess;

type
    TfrmPhotoQuery = class(TForm)
        pnl1: TPanel;
        Label5: TLabel;
        Label2: TLabel;
        cbbType: TDBLookupComboboxEh;
        cbbArea: TDBLookupComboboxEh;
        Label3: TLabel;
        Label4: TLabel;
        cbbSpec: TDBLookupComboboxEh;
        cbbDept: TDBLookupComboboxEh;
        Label1: TLabel;
        Label6: TLabel;
        edtStuEmpNo: TEdit;
        edtName: TEdit;
        rgPhoto: TRadioGroup;
        btnOper: TBitBtn;
        BitBtn2: TBitBtn;
        BitBtn1: TBitBtn;
        dbgrdhDb: TDBGridEh;
        dsType: TDataSource;
        dsDept: TDataSource;
        dsArea: TDataSource;
        dsSpec: TDataSource;
        dsQuery: TDataSource;
        SaveDialog1: TSaveDialog;
        btnPhoto: TBitBtn;
        pnlPhoto: TPanel;
        imgPhoto: TImage;
        lbl1: TLabel;
        edtCardId: TEdit;
        btnMakeCard: TBitBtn;
        procedure BitBtn1Click(Sender: TObject);
        procedure BitBtn2Click(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure btnOperClick(Sender: TObject);
        procedure btnPhotoClick(Sender: TObject);
        procedure dbgrdhDbCellClick(Column: TColumnEh);
        procedure btnMakeCardClick(Sender: TObject);
        procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    private
        { Private declarations }
        procedure fillCbb();
        procedure queryData();
        procedure showPhoto(scustId: string);
    public
        { Public declarations }
        wType: string;
    end;

var
    frmPhotoQuery: TfrmPhotoQuery;

implementation

uses uConst, uCommon, Udm, mainUnit, uCardPrintTemp, uCardPrintTemp_W;

{$R *.dfm}

procedure TfrmPhotoQuery.BitBtn1Click(Sender: TObject);
begin
    close();
end;

procedure TfrmPhotoQuery.BitBtn2Click(Sender: TObject);
begin
    with frmdm do begin
        if qryQuery.IsEmpty then begin
            ShowMessage('请先查询数据，然后再导出！');
            Exit;
        end;
        ExportData(SaveDialog1, dbgrdhdb);
    end;

end;

procedure TfrmPhotoQuery.fillCbb;
begin
    frmdm.qryDept.Close;
    frmdm.qryDept.SQL.Clear;
    frmdm.qryDept.SQL.Add(deptQuery);
    frmdm.qryDept.Open;
    cbbDept.KeyField := deptCode;
    cbbDept.ListField := deptName;

    frmdm.qryType.Close;
    frmdm.qryType.SQL.Clear;
    frmdm.qryType.SQL.Add(typeQuery);
    frmdm.qryType.Open;
    cbbType.KeyField := typeNo;
    cbbType.ListField := typeName;


    frmdm.qrySpec.Close;
    frmdm.qrySpec.SQL.Clear;
    frmdm.qrySpec.SQL.Add(specQuery);
    frmdm.qrySpec.Open;
    cbbSpec.KeyField := specCode;
    cbbSpec.ListField := specName;

    frmdm.qryArea.Close;
    frmdm.qryArea.SQL.Clear;
    frmdm.qryArea.SQL.Add(areaQuery);
    frmdm.qryArea.Open;
    cbbArea.KeyField := areaNo;
    cbbArea.ListField := areaName;

end;

procedure TfrmPhotoQuery.FormShow(Sender: TObject);
begin
    fillCbb();
    dbgrdhDb.Columns[0].FieldName := custId;
    dbgrdhDb.Columns[1].FieldName := stuempNo;
    dbgrdhDb.Columns[2].FieldName := custName;
    dbgrdhDb.Columns[3].FieldName := typeName;
    dbgrdhDb.Columns[4].FieldName := specName;
    dbgrdhDb.Columns[5].FieldName := deptName;
    dbgrdhDb.Columns[6].FieldName := areaName;
    dbgrdhDb.Columns[7].FieldName := custCardId;
    dbgrdhDb.Columns[2].Footer.FieldName := custName;
end;

procedure TfrmPhotoQuery.queryData;
var
    sqlStr: string;
begin
    sqlStr := photoQuery;
    if edtStuEmpNo.Text <> '' then
        sqlStr := sqlStr + ' and cust.' + stuempNo + ' like ' + #39 + '%' + edtStuEmpNo.Text + '%' + #39;
    if edtName.Text <> '' then
        sqlStr := sqlStr + ' and cust.' + custName + ' like ' + #39 + '%' + edtname.Text + '%' + #39;
    if cbbArea.Text <> '' then
        sqlStr := sqlStr + ' and cust.' + custArea + '=' + inttostr(cbbArea.KeyValue);
    if cbbDept.Text <> '' then
        sqlStr := sqlStr + ' and cust.' + custDeptNo + '=' + #39 + cbbdept.KeyValue + #39;
    if cbbType.Text <> '' then
        sqlStr := sqlStr + ' and cust.' + custType + '=' + inttostr(cbbType.KeyValue);
    if cbbSpec.Text <> '' then
        sqlStr := sqlStr + ' and cust.' + custSpecNo + '=' + #39 + cbbspec.KeyValue + #39;
    if edtCardId.Text <> '' then
        sqlStr := sqlStr + ' and cust.' + custCardId + '=' + #39 + trim(edtCardId.Text) + #39;

    if rgPhoto.ItemIndex = 0 then
        sqlStr := sqlStr + ' and photo.' + pPhotoDate + ' is not null'
    else if rgPhoto.ItemIndex = 1 then
        sqlStr := sqlStr + ' and photo.' + pPhotoDate + ' is null'
    else
        sqlStr := sqlStr + '';


    frmdm.qryQuery.Close;
    frmdm.qryQuery.SQL.Clear;
    frmdm.qryQuery.SQL.Add(sqlStr);
    frmdm.qryQuery.Prepared;
    frmdm.qryQuery.Open;
    if frmdm.qryQuery.IsEmpty then
        ShowMessage('没有数据，请重新选择统计条件！');
end;

procedure TfrmPhotoQuery.btnOperClick(Sender: TObject);
begin
    queryData();
end;

procedure TfrmPhotoQuery.btnPhotoClick(Sender: TObject);
begin
    if dbgrdhDb.DataSource.DataSet.IsEmpty then begin
        ShowMessage('请先查询并选择一个要拍照的人员，然后再拍照');
        Exit;
    end;
    frmMain.iCustId := dbgrdhDb.DataSource.DataSet.fieldbyname(custId).AsInteger;
    frmMain.ifPhoto := True;
    Self.Close;
end;

procedure TfrmPhotoQuery.showPhoto(scustId: string);
var
    Fjpg: TJpegImage;
begin
    Fjpg := nil;
    imgPhoto.Picture.Graphic := nil;
    try
        Fjpg := TJpegImage.Create;
        Fjpg := getPhotoInfo(scustId);
        if Fjpg = nil then
            pnlphoto.Caption := '没有照片'
        else
            imgPhoto.Picture.Graphic := Fjpg;
    finally
        Fjpg.Free;
    end;
end;

procedure TfrmPhotoQuery.dbgrdhDbCellClick(Column: TColumnEh);
begin
    if (frmdm.qryQuery.IsEmpty or frmdm.qryQuery.Active = False) then
        Exit;
    if dbgrdhDb.DataSource.DataSet.IsEmpty then
        Exit;
    showPhoto(dbgrdhDb.DataSource.DataSet.fieldbyname(custId).AsString);

end;

procedure TfrmPhotoQuery.btnMakeCardClick(Sender: TObject);
begin
    if dbgrdhDb.DataSource.DataSet.IsEmpty then begin
        ShowMessage('请先查询并选择一个要拍照的人员，然后再拍照');
        Exit;
    end;
    if wType = 'k' then begin
        frmCardPrintTemp.ifMakeCard := True;
        frmCardPrintTemp.iCustId := dbgrdhDb.DataSource.DataSet.fieldbyname(custId).AsInteger;
    end
    else if wType = 'w' then begin
        frmCardPrintTemp_W.ifMakeCard := True;
        frmCardPrintTemp_W.iCustId := dbgrdhDb.DataSource.DataSet.fieldbyname(custId).AsInteger;
    end;
    Self.Close;

end;

procedure TfrmPhotoQuery.FormCloseQuery(Sender: TObject;
    var CanClose: Boolean);
begin
    frmDm.qryQuery.Close;
end;

end.

