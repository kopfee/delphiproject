unit UDemo;


interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Variants,
    Dialogs, Grids, StdCtrls, ExtCtrls, ComCtrls, mysql, Menus, RzTray,
    RzEdit, RzBckgnd, RzLstBox, RzPanel, RzSplit, RzListVw, Buttons, ComObj,
    ExcelXP, OleServer;

type
    TfrmMain = class(TForm)
        RzTrayIcon1: TRzTrayIcon;
        PopupMenu1: TPopupMenu;
        N1: TMenuItem;
        RzMemo1: TRzMemo;
        Timer1: TTimer;
        RzListView1: TRzListView;
        StatusBar1: TStatusBar;
        Splitter1: TSplitter;
        Panel1: TPanel;
        btnImport: TButton;
        BitBtn1: TBitBtn;
        OpenDialog1: TOpenDialog;
        Button1: TButton;
        procedure FormDestroy(Sender: TObject);
        procedure N1Click(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure RzListView1SelectItem(Sender: TObject; Item: TListItem;
            Selected: Boolean);
        procedure Timer1Timer(Sender: TObject);
        procedure btnImportClick(Sender: TObject);
        procedure Button1Click(Sender: TObject);
    private

    public
        procedure addMsg(mId: string);
    end;

var
    frmMain: TfrmMain;
    gTotalRows, gTotalCols: integer;
    xlsFilename: string;
    Excel: OleVariant;
    gInsertSql: string;
const
    iSheet = 1;

procedure getInitMessage();
procedure getNextMessage();
procedure InsertMsgOrderData(nRow, nCol: integer);
function InsertCustomerData(nRow: integer): boolean;

implementation

uses uConst, FormWait;
{$R *.dfm}

{$WARNINGS OFF}


procedure getInitMessage();
begin
    frmMain.addMsg('0');
end;

procedure getNextMessage();
var
    startPos: string;
begin
    if trim(frmMain.StatusBar1.Panels.Items[0].Text) = '' then
        startPos := '0'
    else
        startPos := trim(frmMain.StatusBar1.Panels.Items[0].Text);

    frmMain.addMsg(startPos);
end;

procedure InsertMsgOrderData(nRow, nCol: integer);
begin
    gInsertSql := format(sSqlInsertMsgOrder,
        [
        QuoteString(trim(Excel.WorkSheets[iSheet].Cells[nRow, nCol - 2].value)),
            QuoteString(trim(Excel.WorkSheets[iSheet].Cells[nRow, nCol - 1].value)),
            QuoteString(trim(Excel.WorkSheets[iSheet].Cells[nRow, nCol].value)),
            QuoteString(gLoginUserId)
            ]);
    if (mysql_real_query(LibHandle, PAnsiChar(gInsertSql), Length(gInsertSql)) <> 0) then
        raise Exception.Create(mysql_error(LibHandle));
end;

function InsertCustomerData(nRow: integer): boolean;
var
    fields: string;
    i: integer;
    custId: string;
    sqlRelationShip, sqlInsertEmail, emailId: string;
    hasEmail: boolean;
begin
    result := false;
    hasEmail := false;
    gInsertSql := '';
    fields := '';
    custId := getUUID();
    emailId := getUUID();
    sqlInsertEmail := 'insert into email_addresses (id,email_address,email_address_caps,date_created) values (%s,%s,%s,now())';
    sqlRelationShip := 'insert into email_addr_bean_rel (id,email_address_id,bean_id,primary_address,date_created,bean_module) values(%s,%s,%s,%d,now(),"Accounts")';

    if gImportCustomerCols > 0 then begin
        for i := 1 to gImportCustomerCols do begin
            if i = 6 then begin
                if (trim(Excel.WorkSheets[iSheet].Cells[nRow, i].value) <> '') then begin
                    sqlInsertEmail := format(sqlInsertEmail, [QuoteString(emailId),
                        QuoteString(trim(Excel.WorkSheets[iSheet].Cells[nRow, i].value)),
                            QuoteString(UpperCase(trim(Excel.WorkSheets[iSheet].Cells[nRow, i].value)))]);
                    sqlRelationShip := format(sqlRelationShip, [QuoteString(getUUID()), QuoteString(emailId), QuoteString(custId), 1]);
                    hasEmail := true;
                end;
            end
            else if (i = gImportCustomerCols) then begin
                fields := fields + QuoteString(trim(Excel.WorkSheets[iSheet].Cells[nRow, i].value));
            end
            else begin
                fields := fields + QuoteString(trim(Excel.WorkSheets[iSheet].Cells[nRow, i].value)) + ',';
            end;

        end;
        result := true;
    end;

    gInsertSql := replaceUUID(replaceKeyWords(format(gSqlInsertCustomer, [fields])), custId);

    if bDebug then begin
        frmMain.RzMemo1.Lines.Add('gInsertSql=' + gInsertSql);
        frmMain.RzMemo1.Lines.Add('sqlInsertEmail=' + sqlInsertEmail);
        frmMain.RzMemo1.Lines.Add('sqlRelationShip=' + sqlRelationShip);
    end;

    if (mysql_real_query(LibHandle, PAnsiChar(gInsertSql), Length(gInsertSql)) <> 0) then begin
        raise Exception.Create(mysql_error(LibHandle));
        result := true;
        exit;
    end;
    if hasEmail then begin
        if (mysql_real_query(LibHandle, PAnsiChar(sqlInsertEmail), Length(sqlInsertEmail)) <> 0) then begin
            raise Exception.Create(mysql_error(LibHandle));
            result := true;
            exit;
        end;
        if (mysql_real_query(LibHandle, PAnsiChar(sqlRelationShip), Length(sqlRelationShip)) <> 0) then begin
            raise Exception.Create(mysql_error(LibHandle));
            result := true;
            exit;
        end;
    end;


    {
id CHAR(36) NOT NULL,
        name VARCHAR(150),
        date_entered DATETIME,
        date_modified DATETIME,
        modified_user_id CHAR(36),
        created_by CHAR(36),
        description text,
        deleted TINYINT(1) DEFAULT '0',
        assigned_user_id CHAR(36),
        account_type VARCHAR(50),
        industry VARCHAR(50),
        annual_revenue VARCHAR(100),
        phone_fax VARCHAR(100),
        billing_address_street VARCHAR(150),
        billing_address_city VARCHAR(100),
        billing_address_state VARCHAR(100),
        billing_address_postalcode VARCHAR(20),
        billing_address_country VARCHAR(255),
        rating VARCHAR(100),
        phone_office VARCHAR(100),
        phone_alternate VARCHAR(100),
        website VARCHAR(255),
        ownership VARCHAR(100),
        employees VARCHAR(10),
        ticker_symbol VARCHAR(10),
        shipping_address_street VARCHAR(150),
        shipping_address_city VARCHAR(100),
        shipping_address_state VARCHAR(100),
        shipping_address_postalcode VARCHAR(20),
        shipping_address_country VARCHAR(255),
        parent_id CHAR(36),
        sic_code VARCHAR(10),
        campaign_id CHAR(36),
}

end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
    RzListView1.ClearSelection;
    try
        if mySQL_Res <> nil then
            mysql_free_result(mySQL_Res);
        if libmysql_status = LIBMYSQL_READY then
            mysql_close(LibHandle);
        libmysql_free;
    except

    end;
end;


procedure TfrmMain.N1Click(Sender: TObject);
begin
    halt(1);
end;

procedure TfrmMain.addMsg(mId: string);
var
    sql: string;
    row_count, field_count: int64;
    MYSQL_ROW: PMYSQL_ROW;
    i: integer;
    rowItem: TListItem;
begin
    sql := 'select id,orderId,orderUrl,content,createTime,updateTime,createId,updateId from '
        + QuoteName('msg_order')
        + ' where 1=1'
        + ' and id>' + mId
        + ' and updateTime is null '
        + ' order by id desc'
        + ' limit 0,50 ';
    ;

    if (mysql_real_query(LibHandle, PAnsiChar(sql), Length(sql)) <> 0) then
        raise Exception.Create(mysql_error(LibHandle));
    //Get Data
    if mySQL_Res <> nil then
        mysql_free_result(mySQL_Res);
    mySQL_Res := mysql_store_result(LibHandle);
    if mySQL_Res <> nil then begin
        row_count := mysql_num_rows(mySQL_Res);
        field_count := mysql_num_fields(mySQL_Res);
    end;

    StatusBar1.Panels.Items[1].Text := format('total record: %d', [row_count]);
    StatusBar1.Panels.Items[2].Text := format('total fields: %d', [field_count]);

    if (row_count > 0) then begin
        //RzListView1.Items.Clear;
        for i := 0 to row_count - 1 do begin
            mysql_data_seek(mySQL_Res, i);
            MYSQL_ROW := mysql_fetch_row(mySQL_Res);
            if MYSQL_ROW <> nil then begin
                rowItem := RzListView1.Items.Add;
                rowItem.Caption := MYSQL_ROW^[0];
                //rowItem.SubItems.Add(MYSQL_ROW^[0]);
                rowItem.SubItems.Add(MYSQL_ROW^[1]);
                //rowItem.SubItems.Add(MYSQL_ROW^[2]);
                rowItem.SubItems.Add(MYSQL_ROW^[3]);

                if i = 0 then begin
                    StatusBar1.Panels.Items[0].Text := MYSQL_ROW^[0];
                end;
            end;

        end;
    end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
    RzListView1.Items.Clear;
    with TFromWaitThread.Create(getInitMessage, '正在获取最新消息，请稍后...') do begin
        FreeOnTerminate := True;
        Resume;
    end;
    button1.Visible := bDebug;
end;

procedure TfrmMain.RzListView1SelectItem(Sender: TObject; Item: TListItem;
    Selected: Boolean);
var
    sql: string;
    MYSQL_ROW: PMYSQL_ROW;
begin
    rzMemo1.Lines.clear;
    sql := 'select id,orderId,orderUrl,content,createTime,updateTime,createId,updateId from '
        + QuoteName('msg_order')
        + ' where 1=1'
        + ' and id= ' + Item.Caption
        + ' order by createTime desc'
        ;

    if (mysql_real_query(LibHandle, PAnsiChar(sql), Length(sql)) <> 0) then
        raise Exception.Create(mysql_error(LibHandle));
    //Get Data
    if mySQL_Res <> nil then
        mysql_free_result(mySQL_Res);
    mySQL_Res := mysql_store_result(LibHandle);
    mysql_data_seek(mySQL_Res, 0);
    MYSQL_ROW := mysql_fetch_row(mySQL_Res);
    if MYSQL_ROW <> nil then begin
        rzMemo1.Lines.Add(format('订单号： %s', [MYSQL_ROW^[1]]));
        rzMemo1.Lines.Add(format('网站链接为： %s', [MYSQL_ROW^[2]]));
        rzMemo1.Lines.Add(format('详细信息： %s', [MYSQL_ROW^[3]]));
        rzMemo1.Lines.Add(format('创建时间： %s', [MYSQL_ROW^[4]]));
        rzMemo1.Lines.Add(format('创建人： %s', [MYSQL_ROW^[6]]));
    end;
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
    with TFromWaitThread.Create(getNextMessage, '正在获取最新消息，请稍后...') do begin
        FreeOnTerminate := True;
        Resume;
    end;
end;

procedure TfrmMain.btnImportClick(Sender: TObject);
var
    iRow: integer;
begin
    opendialog1.InitialDir := ExtractFileDir(paramstr(0));
    OpenDialog1.Title := '请选择相应的Excel文件';
    OpenDialog1.Filter := 'Excel(*.xls,*.xlsx)|*.xls;*.xlsx';

    if OpenDialog1.Execute then begin
        xlsFilename := OpenDialog1.FileName;
        try
            Excel := CreateOLEObject('Excel.Application');
        except
            Application.MessageBox('Excel没有安装！', '提示信息', MB_OK + MB_ICONASTERISK + MB_DEFBUTTON1 + MB_APPLMODAL);
            Exit;
        end;

        Excel.Visible := false;
        Excel.WorkBooks.Open(xlsFilename);
        gTotalRows := Excel.WorkSheets[iSheet].UsedRange.Rows.Count;
        gTotalCols := Excel.WorkSheets[iSheet].UsedRange.Columns.Count;

        try
            for iRow := 2 to gTotalRows do begin
                //InsertMsgOrderData(iRow, gTotalCols);
                InsertCustomerData(iRow);
            end;
            Excel.WorkBooks.Close;
            MessageBox(GetActiveWindow(), '数据导入成功!', '提示', MB_OK + MB_ICONWARNING);
        except
            Application.MessageBox('导入数据出错！请检查文件的格式是否正确！', '提示信息', MB_OK + MB_ICONASTERISK
                + MB_DEFBUTTON1 + MB_APPLMODAL);
        end;


        Excel.Quit;
        Excel := Unassigned;
    end;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
    showmessage(getUUID() + ',,' + getUUID() + ',,,' + IntToStr(Length(getUUID())));
end;

end.

