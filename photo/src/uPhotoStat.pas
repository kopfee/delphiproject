unit uPhotoStat;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, DBGridEh, StdCtrls, Mask, DBCtrlsEh, DBLookupEh, ExtCtrls, DB,
    ADODB, ComCtrls, GridsEh, Buttons, IniFiles;

type
    TfrmPhotoStat = class(TForm)
        pnl1: TPanel;
        cbbType: TDBLookupComboboxEh;
        cbbDept: TDBLookupComboboxEh;
        cbbSpec: TDBLookupComboboxEh;
        cbbArea: TDBLookupComboboxEh;
        Label2: TLabel;
        Label3: TLabel;
        Label4: TLabel;
        Label5: TLabel;
        dtpBegin: TDateTimePicker;
        dtpEnd: TDateTimePicker;
        chkDate: TCheckBox;
        dbgrdhData: TDBGridEh;
        BitBtn1: TBitBtn;
        btnOper: TBitBtn;
        BitBtn2: TBitBtn;
        dsType: TDataSource;
        dsDept: TDataSource;
        dsArea: TDataSource;
        dsSpec: TDataSource;
        dsQuery: TDataSource;
        SaveDialog1: TSaveDialog;
        Label1: TLabel;
        Label6: TLabel;
        procedure BitBtn1Click(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure btnOperClick(Sender: TObject);
        procedure BitBtn2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    private
        { Private declarations }

        procedure fillCbb();
        procedure queryData();
    public
        { Public declarations }
    end;

var
    frmPhotoStat: TfrmPhotoStat;

implementation

uses Udm, uCommon, uConst;

{$R *.dfm}

procedure TfrmPhotoStat.BitBtn1Click(Sender: TObject);
begin
    Close;
end;

procedure TfrmPhotoStat.fillCbb;
begin
    frmdm.qryDept.Close;
    frmdm.qryDept.SQL.Clear;
    frmdm.qryDept.SQL.Add(deptQuery);
    frmdm.qryDept.Open;
    cbbDept.ListField := deptName;
    cbbDept.KeyField := deptCode;

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

procedure TfrmPhotoStat.FormShow(Sender: TObject);
begin
    fillCbb();
    dtpEnd.Date := Date();
    dtpBegin.Date := Date();
    dbgrdhData.Columns[0].FieldName := areaName;
    dbgrdhData.Columns[1].FieldName := deptName;
    dbgrdhData.Columns[2].FieldName := specName;
    dbgrdhData.Columns[3].FieldName := 'totNum';
    dbgrdhData.Columns[4].FieldName := 'photoNum';
    dbgrdhData.Columns[5].FieldName := 'unPhotoNum';
    dbgrdhData.Columns[3].Footer.FieldName := 'totNum';
    dbgrdhData.Columns[4].Footer.FieldName := 'photoNum';
    dbgrdhData.Columns[5].Footer.FieldName := 'unPhotoNum';

end;

procedure TfrmPhotoStat.btnOperClick(Sender: TObject);
begin
    if (chkDate.Checked) and (dtpBegin.Date > dtpEnd.Date) then begin
        showmessage('你选择的开始日期大于结束日期，请从新选择！');
        exit;
    end;
    queryData();
    dbgrdhData.SumList.Active := true;
end;

procedure TfrmPhotoStat.queryData;
var
    sqlStr: string;
begin
    sqlStr := photoStats;
    if chkDate.Checked then begin
        sqlStr := sqlStr + ' and photo.' + pPhotoDate + '>=' + #39 + formatdatetime('yyyymmdd', dtpBegin.Date) + #39;
        sqlStr := sqlStr + ' and photo.' + pPhotoDate + '<=' + #39 + formatdatetime('yyyymmdd', dtpEnd.Date) + #39;
    end;
    if cbbArea.Text <> '' then
        sqlStr := sqlStr + ' and cust.' + custArea + '=' + inttostr(cbbArea.KeyValue);
    if cbbDept.Text <> '' then
        sqlStr := sqlStr + ' and cust.' + custDeptNo + '=' + #39 + cbbdept.KeyValue + #39;
    if cbbType.Text <> '' then
        sqlStr := sqlStr + ' and cust.' + custType + '=' + inttostr(cbbType.KeyValue);
    if cbbSpec.Text <> '' then
        sqlStr := sqlStr + ' and cust.' + custSpecNo + '=' + #39 + cbbspec.KeyValue + #39;

    sqlStr := sqlStr + ' group by area.' + areaName + ',dept.' + deptName + ', spec.' + specName;
    sqlStr := sqlStr + ' order by area.' + areaName;
    frmdm.qryQuery.Close;
    frmdm.qryQuery.SQL.Clear;
    frmdm.qryQuery.SQL.Add(sqlStr);
    frmdm.qryQuery.Open;
    if frmdm.qryQuery.IsEmpty then
        ShowMessage('没有你指定条件的数据，请重新选择统计条件！');

end;

procedure TfrmPhotoStat.BitBtn2Click(Sender: TObject);
begin
    if frmdm.qryQuery.IsEmpty then begin
        ShowMessage('请先查询数据，然后再导出！');
        Exit;
    end;
    ExportData(SaveDialog1, dbgrdhData);
end;

procedure TfrmPhotoStat.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    frmDm.qryQuery.Close;
end;

end.
