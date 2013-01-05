unit uLimit;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ExtCtrls, GridsEh, DBGridEh, StdCtrls, Buttons, DB, Ora,
    ADODB;

type
    TfrmLimit = class(TForm)
        pnl1: TPanel;
        dbgrdhDb: TDBGridEh;
        lbl1: TLabel;
        Label1: TLabel;
        Label2: TLabel;
        Label3: TLabel;
        Label4: TLabel;
        Label5: TLabel;
        grpLimit: TGroupBox;
        edtCode: TEdit;
        edtName: TEdit;
        edtBegin: TEdit;
        edtEnd: TEdit;
        edtpwd: TEdit;
        edtRepwd: TEdit;
        chkStat: TCheckBox;
        chkQuery: TCheckBox;
        chkLimit: TCheckBox;
        chkImport: TCheckBox;
        chkExport: TCheckBox;
        chkAddCust: TCheckBox;
        chkEditCust: TCheckBox;
        chkStuPrint: TCheckBox;
        chkEmpPrint: TCheckBox;
        chkDelPhoto: TCheckBox;
        chkSavePhoto: TCheckBox;
        chkEnabled: TCheckBox;
        btnAdd: TBitBtn;
        btnSave: TBitBtn;
        btnExit: TBitBtn;
        dsQuery: TDataSource;
        BitBtn1: TBitBtn;
        CheckBox1: TCheckBox;
        procedure btnExitClick(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure btnAddClick(Sender: TObject);
        procedure btnSaveClick(Sender: TObject);
        procedure qryQueryAfterScroll(DataSet: TDataSet);
        procedure BitBtn1Click(Sender: TObject);
    private
        { Private declarations }
        operType: string;
        procedure queryOperList();
        procedure fillDataInfo();
        function getSelect(limitStr: string; iPos: Integer): Boolean;
        function selectForLimit(): string;
        procedure addLimitInfo();
        procedure editLimitInfo();
        procedure clearSelect();
        function ifHaveOper(operCode: string): Boolean;
        procedure delLimitInfo();
        function FormatDate(str: string): boolean;
    public
        { Public declarations }
    end;

var
    frmLimit: TfrmLimit;

implementation

uses AES, ElAES, uCommon, Udm;

{$R *.dfm}

procedure TfrmLimit.btnExitClick(Sender: TObject);
begin
    close();
end;

procedure TfrmLimit.fillDataInfo;
var
    i: Integer;
    itag: Integer;
begin
    clearSelect();
    operType := 'edit';
    edtCode.Enabled := False;
    if frmdm.qryQuery.Active = False then
        queryOperList();
    edtBegin.Text := frmdm.qryQuery.fieldbyname(lmtBeginDate).AsString;
    edtEnd.Text := frmdm.qryQuery.fieldbyname(lmtEndDate).AsString;
    edtCode.Text := frmdm.qryQuery.fieldbyname(lmtOperCode).AsString;
    edtName.Text := frmdm.qryQuery.fieldbyname(lmtOperName).AsString;
    edtpwd.Text := DecryptString(frmdm.qryQuery.fieldbyname(lmtpwd).AsString, CryptKey);
    edtRepwd.Text := edtpwd.Text;
    for i := 0 to grpLimit.ControlCount - 1 do begin
        if grpLimit.Controls[i] is TCheckBox then begin
            itag := TCheckBox(grpLimit.Controls[i]).Tag;
            TCheckBox(grpLimit.Controls[i]).Checked := getSelect(frmdm.qryQuery.fieldbyname(lmtLimit).AsString, itag);
        end;
    end;
end;

procedure TfrmLimit.FormShow(Sender: TObject);
begin
    dbgrdhDb.Columns[0].FieldName := lmtOperCode;
    dbgrdhDb.Columns[1].FieldName := lmtOperName;
    edtBegin.Text := FormatDateTime('yyyymmdd', Date);
    edtEnd.Text := FormatDateTime('yyyymmdd', Date);
    queryOperList();
end;

function TfrmLimit.getSelect(limitStr: string; iPos: Integer): Boolean;
var
    ss: string;
begin
    ss := Copy(limitStr, iPos + 1, 1);
    if ss = '0' then
        Result := False
    else
        Result := True;
end;

procedure TfrmLimit.queryOperList;
var
    sqlStr: string;
begin
    sqlStr := qryOperSql('', '');
    frmdm.qryQuery.Close;
    frmdm.qryQuery.SQL.Clear;
    frmdm.qryQuery.SQL.Add(sqlStr);
    frmdm.qryQuery.Open;
    if not frmdm.qryQuery.IsEmpty then
        fillDataInfo();
end;

procedure TfrmLimit.btnAddClick(Sender: TObject);
var
    i: Integer;
begin
    operType := 'add';
    edtCode.Enabled := True;
    clearSelect;
    for i := 0 to pnl1.ControlCount - 1 do
        if pnl1.Controls[i] is TEdit then
            TEdit(pnl1.Controls[i]).Text := '';
    edtBegin.Text := FormatDateTime('yyyymmdd', Date);
    edtEnd.Text := FormatDateTime('yyyymmdd', Date);

end;

{-------------------------------------------------------------------------------
  过程名:    TfrmLimit.selectForLimit把选择的权限信息组成字符串
  参数:      无
  返回值:    string
-------------------------------------------------------------------------------}

function TfrmLimit.selectForLimit: string;
var
    i: Integer;
    itag: Integer;
    limitStr: string;
    sIfUse: string; //是否可用
    slimit: string; //权限管理
    sphotoStat: string; //拍照统计
    sphotoQuery: string; //拍照查询
    simport: string; //导入照片
    sexport: string; //导出照片
    saddCust: string; //添加人员信息
    sEditCust: string; //修改人员信息

    sstuPrint: string; //学生卡打印
    sempPrint: string; //教师卡打印
    sdelphoto: string; //删除照片
    ssavephoto: string; //保存照片
    scustImport: string; //人员信息批量导入
    procedure chkLimit(itag: Integer; lmt: string);
    begin
        case itag of
            0: sIfUse := lmt;
            1: slimit := lmt;
            2: sphotoStat := lmt;
            3: sphotoQuery := lmt;
            4: simport := lmt;
            5: sexport := lmt;
            6: saddCust := lmt;
            7: sEditCust := lmt;
            8: sstuPrint := lmt;
            9: sempPrint := lmt;
            10: sdelphoto := lmt;
            11: ssavephoto := lmt;
            12: scustImport := lmt;
        else

        end;
    end;
begin
    limitStr := '';
    for i := 0 to grpLimit.ControlCount - 1 do begin
        itag := TCheckBox(grpLimit.Controls[i]).Tag;
        if grpLimit.Controls[i] is TCheckBox then begin
            if TCheckBox(grpLimit.Controls[i]).Checked then begin
                chkLimit(itag, '1');
            end
            else begin
                chkLimit(itag, '0');
            end;
        end;
    end;
    limitStr := sIfUse + slimit + sphotoStat + sphotoQuery + simport + sexport + saddCust + sEditCust;
    limitStr := limitStr + sstuPrint + sempPrint + sdelphoto + ssavephoto + scustImport;
    Result := Trim(limitStr);
end;

procedure TfrmLimit.addLimitInfo;
var
    operQuery: TOraQuery;
    operStr: string;
begin
    if ifHaveOper(Trim(edtCode.Text)) then begin
        ShowMessage('该登录名已经存在，请重新输入！');
        edtCode.SetFocus;
        Exit;
    end;
    operStr := 'insert into ' + tblLimit + '(' + lmtOperCode + ',' + lmtOperName + ',' + lmtBeginDate + ',';
    operStr := operStr + lmtEndDate + ',' + lmtpwd + ',' + lmtLimit + ')values(';
    operStr := operStr + #39 + edtcode.Text + #39 + ',';
    operStr := operStr + #39 + edtName.Text + #39 + ',';
    operStr := operStr + #39 + edtbegin.Text + #39 + ',';
    operStr := operStr + #39 + edtend.Text + #39 + ',';
    operStr := operStr + #39 + EncryptString(trim(edtpwd.Text), CryptKey) + #39 + ',';
    operStr := operStr + #39 + selectForLimit() + #39 + ')';
    operQuery := nil;
    try
        operQuery := TOraQuery.Create(nil);
        operQuery.Connection := frmdm.conn;

        operQuery.Close;
        operQuery.SQL.Clear;
        operQuery.SQL.Add(operStr);

        frmdm.conn.StartTransaction;
        try
            operQuery.ExecSQL;
            frmdm.conn.Commit;
            if Application.MessageBox(PChar('保存人员信息成功，你是否要继续添加！'), PChar(Application.Title), MB_ICONQUESTION + mb_yesno) = idyes then
                btnAdd.Click;
        except
            on e: Exception do begin
                frmdm.conn.Rollback;
                ShowMessage('添加人员信息失败，请检查原因--' + e.Message);
            end;
        end;
    finally
        operQuery.Destroy;
    end;
end;

procedure TfrmLimit.editLimitInfo;
var
    operQuery: TOraQuery;
    operStr: string;
begin
    operStr := 'update ' + tblLimit + ' set ' + lmtOperName + '=' + #39 + edtName.Text + #39 + ',';
    operStr := operStr + lmtBeginDate + '=' + #39 + edtBegin.Text + #39 + ',';
    operStr := operStr + lmtEndDate + '=' + #39 + edtEnd.Text + #39 + ',';
    operStr := operStr + lmtpwd + '=' + #39 + EncryptString(trim(edtpwd.Text), CryptKey) + #39 + ',';
    operStr := operStr + lmtLimit + '=' + #39 + selectForLimit() + #39 + ' where ';
    operStr := operStr + lmtOperCode + '=' + #39 + edtCode.Text + #39;
    operQuery := nil;
    try
        operQuery := TOraQuery.Create(nil);
        operQuery.Connection := frmdm.conn;

        operQuery.Close;
        operQuery.SQL.Clear;
        operQuery.SQL.Add(operStr);
        frmdm.conn.StartTransaction;
        try
            operQuery.ExecSQL;
            frmdm.conn.Commit;
            ShowMessage('保存人员信息成功！');
        except
            frmdm.conn.Rollback;
            ShowMessage('保存人员信息失败，请检查原因！');
        end;
    finally
        operQuery.Destroy;
    end;
end;

procedure TfrmLimit.btnSaveClick(Sender: TObject);
begin
    if Trim(edtCode.Text) = '' then begin
        ShowMessage('登录名不能为空，请输入！');
        edtCode.SetFocus;
        Exit;
    end;
    if Trim(edtpwd.Text) = '' then begin
        ShowMessage('密码输入不能为空！');
        edtpwd.SetFocus;
        Exit;
    end;
    if Trim(edtpwd.Text) <> Trim(edtRepwd.Text) then begin
        ShowMessage('两次输入的密码不一样，请重新输入！');
        edtpwd.SetFocus;
        Exit;
    end;
    if (edtBegin.Text <> '') and (length(edtBegin.Text) <> 8) then begin
        showmessage('生效时间的位数不对，请重新输入！');
        edtBegin.SetFocus;
        exit;
    end;
    if (edtEnd.Text <> '') and (length(edtEnd.Text) <> 8) then begin
        showmessage('失效时间的位数不对，请重新输入！');
        edtEnd.SetFocus;
        exit;
    end;
    if formatdate(trim(edtBegin.text)) = false then begin
        edtBegin.SetFocus;
        exit;
    end;
    if formatdate(trim(edtEnd.text)) = false then begin
        edtEnd.SetFocus;
        exit;
    end;

    if Trim(edtCode.Text) = 'admin' then begin
        ShowMessage('不能修改管理员信息！');
        Exit;
    end;
    if operType = 'add' then
        addLimitInfo();
    if operType = 'edit' then
        editLimitInfo();

    queryOperList();
end;

procedure TfrmLimit.qryQueryAfterScroll(DataSet: TDataSet);
begin
    fillDataInfo();
end;

procedure TfrmLimit.clearSelect;
var
    i: Integer;
begin
    for i := 0 to grpLimit.ControlCount - 1 do
        if grpLimit.Controls[i] is TCheckBox then
            TCheckBox(grpLimit.Controls[i]).Checked := False;
end;

function TfrmLimit.ifHaveOper(operCode: string): Boolean;
var
    sqlStr: string;
    tmpQuery: TOraQuery;
begin
    sqlStr := 'select count(*)as num from ' + tblLimit + ' where ' + lmtOperCode + '=' + #39 + edtCode.Text + #39;
    tmpQuery := nil;
    try
        tmpQuery := TOraQuery.Create(nil);
        tmpQuery.Connection := frmdm.conn;
        tmpQuery.Close;
        tmpQuery.sql.Clear;
        tmpQuery.SQL.Add(sqlstr);
        tmpQuery.Open;
        if tmpQuery.FieldByName('num').AsInteger = 0 then
            Result := False
        else
            Result := True;
    finally
        tmpQuery.Destroy;
    end;
end;

procedure TfrmLimit.delLimitInfo;
var
    sqlStr: string;
    tmpQuery: TOraQuery;
begin
    sqlStr := 'delete from ' + tblLimit + ' where ' + lmtOperCode + '=' + #39 + edtCode.Text + #39;
    tmpQuery := nil;
    try
        tmpQuery := TOraQuery.Create(nil);
        tmpQuery.Connection := frmdm.conn;
        tmpQuery.Close;
        tmpQuery.sql.Clear;
        tmpQuery.SQL.Add(sqlstr);
        tmpQuery.Prepared;
        tmpQuery.ExecSQL;
    finally
        tmpQuery.Destroy;
    end;
end;

procedure TfrmLimit.BitBtn1Click(Sender: TObject);
begin
    if Trim(edtCode.Text) = 'admin' then begin
        ShowMessage('你不能删除管理员！');
        Exit;
    end;
    if Application.MessageBox(PChar('你确定要删除该操作员吗？'), PChar(Application.Title), MB_ICONQUESTION + mb_yesno) = idno then
        Exit;
    delLimitInfo();
    queryOperList();
end;

function TfrmLimit.FormatDate(str: string): boolean;
begin
    if trim(str) = '' then begin
        result := true;
        exit;
    end;
    if (strtoint(copy(str, 5, 2)) > 12) or (strtoint(copy(str, 5, 2)) < 1) then begin
        showmessage('月份输入有误！');
        result := false;
        exit;
    end;
    if (strtoint(copy(str, 7, 2)) > 31) or (strtoint(copy(str, 7, 2)) < 1) then begin
        showmessage('日输入有误！');
        result := false;
        exit;
    end;
    {
    if (strtoint(copy(str, 9, 2)) > 24) or (strtoint(copy(str, 9, 2)) < 1) then
    begin
      showmessage('小时输入有误！');
      result := false;
      exit;
    end;
    if (strtoint(copy(str, 11, 2)) > 60) or (strtoint(copy(str, 11, 2)) < 0) then
    begin
      showmessage('分钟输入有误！');
      result := false;
      exit;
    end;
    if (strtoint(copy(str, 13, 2)) > 60) or (strtoint(copy(str, 13, 2)) < 0) then
    begin
      showmessage('秒钟输入有误！');
      result := false;
      exit;
    end;
    }
    result := true;

end;

end.
