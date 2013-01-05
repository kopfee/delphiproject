unit uExport;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ExtCtrls, StdCtrls, GridsEh, DBGridEh, ComCtrls, DB, Ora,
    DBCtrls, Mask, DBCtrlsEh, DBLookupEh, INIFiles, jpeg, ADODB;

type
    TfrmExport = class(TForm)
        pnlTop: TPanel;
        Label1: TLabel;
        Label2: TLabel;
        Label3: TLabel;
        Label4: TLabel;
        Label5: TLabel;
        Label6: TLabel;
        chkCust: TCheckBox;
        pnl1: TPanel;
        mmoSql: TMemo;
        Label7: TLabel;
        pnl2: TPanel;
        Label8: TLabel;
        lstError: TListBox;
        btnQuery: TButton;
        btnExport: TButton;
        btnExit: TButton;
        pnl3: TPanel;
        dbgrdhData: TDBGridEh;
        Label9: TLabel;
        edtStuEmpNo: TEdit;
        edtName: TEdit;
        dtpBegin: TDateTimePicker;
        dtpEnd: TDateTimePicker;
        cbbDept: TDBLookupComboboxEh;
        cbbType: TDBLookupComboboxEh;
        cbbSpec: TDBLookupComboboxEh;
        ProgressBar1: TProgressBar;
        cbbArea: TDBLookupComboboxEh;
        Label10: TLabel;
        dsType: TDataSource;
        dsDept: TDataSource;
        dsArea: TDataSource;
        dsSpec: TDataSource;
        dsQuery: TDataSource;
        SaveDialog1: TSaveDialog;
        Label11: TLabel;
        grp1: TGroupBox;
        chkSetSize: TCheckBox;
        lbl1: TLabel;
        lbl2: TLabel;
        edtWidth: TEdit;
        edtHeight: TEdit;
        lbl3: TLabel;
        lbl4: TLabel;
        Label12: TLabel;
        procedure FormShow(Sender: TObject);
        procedure btnQueryClick(Sender: TObject);
        procedure btnExitClick(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure btnExportClick(Sender: TObject);
        procedure edtWidthChange(Sender: TObject);
        procedure edtWidthClick(Sender: TObject);
        procedure edtWidthKeyPress(Sender: TObject; var Key: Char);
        procedure edtHeightKeyPress(Sender: TObject; var Key: Char);
        procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    private
        { Private declarations }

        TempStringList: TStrings;
        procedure fillCbbData();
        procedure queryData();
    public
        { Public declarations }
    end;

var
    frmExport: TfrmExport;

implementation

uses Udm, uCommon, TLoggerUnit, uConst;

{$R *.dfm}

procedure TfrmExport.FormShow(Sender: TObject);
begin
    closeQuery;
    fillCbbData();
    dtpBegin.Date := (Date() - 365 * 5);
    dtpEnd.Date := Date();
    TempStringList := TStringList.Create;
end;

procedure TfrmExport.fillCbbData;
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

procedure TfrmExport.queryData;
var
    sqlStr: string;
begin
    if chkCust.Checked = True then begin
        sqlStr := mmoSql.Text;
    end
    else begin
        sqlStr := photoQuery;

        sqlStr := sqlStr + ' and photo.' + pPhotoDate + '>=' + #39 + formatdatetime('yyyymmdd', dtpBegin.Date) + #39;
        sqlStr := sqlStr + ' and photo.' + pPhotoDate + '<=' + #39 + formatdatetime('yyyymmdd', dtpEnd.Date) + #39;
        if edtStuEmpNo.Text <> '' then
            sqlStr := sqlStr + ' and cust.' + stuempNo + '=' + #39 + edtStuEmpNo.Text + #39;
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
    end;
    dbgrdhData.Columns[0].FieldName := custId;
    dbgrdhData.Columns[1].FieldName := stuempNo;
    dbgrdhData.Columns[2].FieldName := custName;
    dbgrdhData.Columns[3].FieldName := deptName;
    dbgrdhData.Columns[4].FieldName := specName;
    dbgrdhData.Columns[5].FieldName := typeName;
    dbgrdhData.Columns[6].FieldName := classNo;
    frmdm.qryQuery.Close;
    frmdm.qryQuery.SQL.Clear;
    frmdm.qryQuery.SQL.Add(sqlStr);
    TLogger.GetInstance.Debug('照片导出查询--' + sqlstr);
    //qryQuery.SQL.SaveToFile('123.txt');
    frmdm.qryQuery.Open;
    if not frmdm.qryQuery.IsEmpty then begin
        frmdm.qryQuery.First;
        while not frmdm.qryQuery.Eof do begin
            //if qryQuery.fieldbyname(custId).AsString<>'' then
            TempStringList.Add(frmdm.qryQuery.fieldbyname(custId).AsString);
            frmdm.qryQuery.Next;
        end;
    end;
end;

procedure TfrmExport.btnQueryClick(Sender: TObject);
begin
    if dtpBegin.Date > dtpEnd.Date then begin
        showmessage('你选择的开始日期大于结束日期，请从新选择！');
        exit;
    end;
    TempStringList.Clear;
    queryData();
end;

procedure TfrmExport.btnExitClick(Sender: TObject);
begin
    close();
end;

procedure TfrmExport.FormDestroy(Sender: TObject);
begin
    TempStringList.Destroy;
end;

procedure TfrmExport.btnExportClick(Sender: TObject);
var
    i: integer;
    M1: TMemoryStream;
    Fjpg: TJpegImage;
    picPath: string;
    photoName: string;
    tmpQuery: TOraQuery;

    Fbmp: TBitmap;
    Buffer: Word;

    tmpBmp: TBitmap;
    OldGraphics: TBitmap;
    expJpg: TJPEGImage;
begin
    if TempStringList.Count <= 0 then begin
        ShowMessage('请先查询数据,然后再导出！');
        Exit;
    end;
    if chkSetSize.Checked then begin
        try
            if (StrToInt(edtWidth.Text) < 30) or (StrToInt(edtHeight.Text) < 40) then

                if StrToInt(edtWidth.Text) < 300 then
                    if Application.MessageBox('照片宽度像素小于300时，照片质量可能受到影响，你确定使用该像素要导出吗？', PChar(Application.Title), MB_YESNO + mb_iconquestion) = idno then
                        Exit;
        except
            on ex: Exception do begin
                ShowMessage(ex.Message + ' 宽度像素不能小于30，请输入有效的像素值！');
                Exit;
            end;
        end;
    end;
    if ExportData(SaveDialog1, dbgrdhData) = False then
        Exit;

    picPath := SaveDialog1.Title;
    picpath := picpath + formatdatetime('yyyymmdd', Date());
    if not directoryExists(picpath) then
        if not CreateDir(picpath) then
            raise Exception.Create('不能创建文件夹：' + picpath);

    frmdm.qryQuery.First;
    ProgressBar1.Min := 0;
    ProgressBar1.Max := TempStringList.Count;
    for i := 0 to TempStringList.Count - 1 do begin
        //**************************************************************************
        tmpQuery := nil;
        M1 := nil;
        Fjpg := nil;
        Fbmp := nil;
        try
            tmpQuery := TOraQuery.Create(nil);
            tmpQuery.Connection := frmdm.conn;
            tmpQuery.Close;
            tmpQuery.SQL.Clear;
            tmpQuery.SQL.Add('select p.' + custId + ',c.' + stuempNo + ',p.' + pPhoto + ' from ' + tblPhoto);
            tmpQuery.SQL.Add(' p left join ' + tblCust + ' c on p.' + custId + '=c.' + custId);
            tmpQuery.SQL.Add(' where p.' + custId + '=' + #39 + TempStringList.Strings[i] + #39);
            tmpQuery.Open;
            if not tmpQuery.IsEmpty then begin
                photoName := tmpQuery.FieldByName(stuempNo).AsString;
                Fjpg := TJpegImage.Create;
                M1 := TMemoryStream.Create;
                M1.Clear;
                if TBlobField(tmpQuery.FieldByName(pPhoto)).AsString <> null then
                    TBlobField(tmpQuery.FieldByName(pPhoto)).SaveToStream(M1);
                M1.Position := 0;
                M1.ReadBuffer(Buffer, 2);
                if M1.Size > 10 then begin
                    M1.Position := 0;
                    if Buffer = $4D42 then begin
                        Fbmp := TBitmap.Create;
                        Fbmp.LoadFromStream(M1);
                        Fjpg.Assign(Fbmp);
                    end
                    else begin
                        FJpg.LoadFromStream(M1);
                    end;

                    //自定义照片大小导出
                    if chkSetSize.Checked then begin
                        OldGraphics := nil;
                        tmpBmp := nil;
                        expJpg := nil;
                        try
                            OldGraphics := TBitmap.Create;
                            //先把jpg格式的照片转换为bmp格式
                            OldGraphics.Assign(Fjpg);

                            //重新定义照片的大小
                            tmpBmp := TBitmap.Create;
                            tmpBmp.Width := StrToInt(edtWidth.Text);
                            tmpBmp.Height := StrToInt(edtHeight.Text);
                            tmpBmp.Canvas.StretchDraw(Rect(0, 0, tmpBmp.Width, tmpBmp.Height), OldGraphics);

                            //重新把照片转换为jpg格式
                            expJpg := TJPEGImage.Create;
                            expJpg.Assign(tmpBmp);
                            expJpg.SaveToFile(picpath + '\' + photoName + '.jpg');
                        finally
                            OldGraphics.Free;
                            tmpBmp.Free;
                            expJpg.Free;
                        end;
                    end
                    else begin
                        FJpg.SaveToFile(picpath + '\' + photoName + '.jpg');
                    end;
                end
                else begin
                    lstError.items.add('学/工号：' + photoName + '信息导出失败！');
                    Continue;
                end;
            end;
        finally
            if Fbmp <> nil then
                Fbmp.Free;
            M1.Free;
            FJpg.Free;
            tmpQuery.Destroy;
        end;
        frmdm.qryQuery.Next;
        ProgressBar1.Position := i + 1;
    end;
    ShowMessage('完成导出人员照片信息，文件存放位置--' + picpath);
    ProgressBar1.Position := 0;
end;

procedure TfrmExport.edtWidthChange(Sender: TObject);
var
    w, h: Integer;
begin
    if (Sender = edtWidth) and (ActiveControl = edtWidth) then begin
        try
            if Trim(edtWidth.Text) = '' then
                w := 0
            else
                w := StrToInt(edtWidth.Text);
        except
            ShowMessage('请输入有效的照片宽度！');
            Exit;
        end;
        edtHeight.Text := IntToStr(Round((w * 4) / 3));
    end
    else
        if (Sender = edtHeight) and (ActiveControl = edtHeight) then begin
            try
                if Trim(edtHeight.Text) = '' then
                    h := 0
                else
                    h := StrToInt(edtHeight.Text);
            except
                ShowMessage('请输入有效的照片高度！');
                Exit;
            end;
            edtWidth.Text := IntToStr(Round((h * 3) / 4));
        end;
end;

procedure TfrmExport.edtWidthClick(Sender: TObject);
begin
    TEdit(Sender).SelectAll;

end;

procedure TfrmExport.edtWidthKeyPress(Sender: TObject; var Key: Char);
begin
    if (Key = #13) then begin
        Key := #0;
        edtHeight.SetFocus;
    end
    else
        if not (Key in ['0'..'9', #8]) then begin
            Key := #0;
        end;

end;

procedure TfrmExport.edtHeightKeyPress(Sender: TObject; var Key: Char);
begin
    if (Key = #13) then begin
        Key := #0;
        //ModalResult := mrOk;
    end;

end;

procedure TfrmExport.FormCloseQuery(Sender: TObject;
    var CanClose: Boolean);
begin
    frmDm.qryQuery.Close;
end;

end.

