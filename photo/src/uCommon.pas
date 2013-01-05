unit uCommon;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, DBGridEh,
    Dialogs, StdCtrls, ExtCtrls, INIFiles, Ora, DB, AES, jpeg, DBGridEhImpExp,
    ShellAPI;
const
    // 权限管理, 模块号
    Mdl_ifUse = 0; //是否可用
    Mdl_limit = 1; //权限管理
    Mdl_photoStat = 2; //拍照统计
    Mdl_photoQuery = 3; //拍照查询
    Mdl_import = 4; //导入照片
    Mdl_export = 5; //导出照片
    Mdl_addCust = 6; //添加人员信息
    Mdl_EditCust = 7; //修改人员信息

    Mdl_stuPrint = 8; //学生卡打印
    Mdl_empPrint = 9; //教师卡打印
    Mdl_delphoto = 10; //删除照片
    mdl_savephoto = 11; //保存照片
    mdl_custImport = 12; //人员添加

    selectH = 316;
    selectW = 230;
    imgW = 420;

    sCustomerConfig = '..\config\' + 'customer.ini';
    sDbConfig = '..\config\' + 'dbconfig.ini';
    sPrintTemplateDir = '..\print\';
    CryptKey = 'Splus321'; //加密种子密钥为ksykt123
var
    useRemoteSoft: Boolean; //使用第三方远景拍摄软件,使用为true

    ifconn: Boolean; //是否连接上数据库
    apppath: string; //系统文件路径
    connStr: string; //数据库连接字符串
    dbName: string; //数据库名称
    dburl: string; //数据库连接串
    dbUid: string; //登录数据库用户名
    dbPwd: string; //登录数据库密码

    tblPhoto: string; //照片表
    tblDept: string; //部门表
    tblSpec: string; //专业表
    tblDict: string; //数据字典
    tblCust: string; //客户表
    tblArea: string; //区域表
    tblCutType: string; //客户类别表
    tblLimit: string; //权限表
    tblFeeType: string; //收费类别表
    tblSysKey: string; //系统键值表
    tblCard: string; //卡表

    custId: string; //客户号
    stuempNo: string; //学工号
    custName: string; //姓名
    custType: string; //人员类别
    custState: string; //客户状态
    custArea: string; //客户所在区域
    custSex: string; //性别
    custCardId: string; //身份证号
    custDeptNo: string; //客户所在部门号
    custSpecNo: string; //客户所在专业号
    custRegTime: string; //客户注册时间
    custFeeType: string; //收费类别
    classNo: string; //班级
    batchNo: string; //批次号
    extField1: string; //扩展字段1
    extField2: string; //扩展字段2

    pPhoto: string; //照片
    PMinPhoto: string; //小照片
    pIfCard: string; //是否制卡
    pCardDate: string; //制卡日期
    pCardTime: string; //制卡时间
    pPhotoDate: string; //拍照日期
    pPhotoTime: string; //拍照时间
    pPhotoDTime: string; //拍照精确时间，到毫秒
    res_1: string; //预留字段
    res_2: string;
    res_3: string;

    lmtOperCode: string; //操作员代码
    lmtOperName: string; //操作员名称
    lmtBeginDate: string; //生效时间
    lmtEndDate: string; //实效时间
    lmtpwd: string; //密码
    lmtLimit: string; //权限
    lmtEnabled: string; //是否可用

    deptCode: string; //部门代码
    deptName: string; //部门名称
    deptParent: string; //父类代码
    deptLevel: string; //部门级别

    specCode: string; //专业代码
    specName: string; //专业名称

    dictNo: string; //字典编号
    dictValue: string; //字典子编号
    dictCaption: string; //字典名称

    areaNo: string; //区域编号
    areaName: string; //区域名称
    areaFather: string; //区域父编号

    typeNo: string; //类别编号
    typeName: string; //类别名称

    cpIfCard: string; //卡片打印中显示是否制卡
    cpCardDate: string; //制卡日期
    cpCardTime: string; //制卡时间


    loginLimit: string; //登录后客户的权限
    loginName: string; //登录名
    loginPwd: string; //登录密码

    feeFeeType: string; //类别代码
    feeFeeName: string; //类别名称

    keyCode: string; //键值代码
    keyName: string; //键值名称
    keyValue: string; //键值数据
    keyMaxValue: string; //最大键值
    keyCustId: string; //客户号在键值表中的代码

    cardCardId: string; //卡号
    cardStateId: string; //卡状态
    cardCustId: string; //客户号

    photopath: string; //照片所在位置
    photopre: string; //照片前缀
    diskpath: string; //本地位置

    rotate: Boolean; //是否旋转
    angle: Integer; //旋转角度

    minWidth: Integer; //小照片的宽度
    minHeight: Integer; //小照片的高度

    //取景框设置显示及位置设置
    ve_visible: Boolean;
    veL_top: Integer;
    veL_left: Integer;
    veL_height: Integer;

    veR_top: Integer;
    veR_left: Integer;
    veR_height: Integer;

    veT_top: Integer;
    veT_left: Integer;
    veT_width: Integer;

    veB_top: Integer;
    veB_left: Integer;
    veB_width: Integer;

    veA_top: Integer;
    veA_left: Integer;
    veA_width: Integer;

    pageOrien: string;

procedure getphotoconfigs;
procedure AddData(cbb: TComboBox; sqlstr: string);
function subString(ssname: string; str: string; posi: string): string;
function sqlExec(sqlstr: string; rname: string): string;
function getDeptName(sDeptCode: string): string;
function getSName(ssCode: string): string;
function getAreaName(sareaNo: string): string;
function getStatesName(StateNo: string): string;
function getTypeName(stypeNo: string): string;
function getCardNo(custId: string): string;

function queryBaseInfoSql(sstuempNo: string; sareaId: string; scustId: string): string;
function getPhotoInfo(scustId: string): TJpegImage;

function getJpgNo(jpgName: string): string;

function ExportData(SaveDialog1: TSaveDialog; DBGridEh1: TDBGridEh): Boolean;

function haveStuEmpNo(sstuEmpNo: string): Boolean;

function qryOperSql(soperCode: string; spwd: string): string;

function judgelimit(oper: string; code: integer): boolean;

procedure insertPhotoData(sCustId, sStuempNo: string);

function getMaxCustId(): Integer;

function addCustInfo(sstuempNo, sname, stype, sArea, scardId, sDept, sSpec, sFeeType: string): Boolean;

procedure delFileBat(filePath, fileName: string);

function getDbTime: string;

implementation

uses uDM, mainUnit;
{-------------------------------------------------------------------------------
  过程名:    getphotoconfigs得到照片库中的配置文件
  参数:      无
  返回值:    无
-------------------------------------------------------------------------------}

procedure getphotoconfigs;
var
    photoinifile: TIniFile;
    dbconfig: TIniFile;
begin
    photoinifile := nil;
    dbconfig := nil;
    if FileExists(apppath + sCustomerConfig) = false then begin
        Application.MessageBox('系统配置文件已经被破坏，请与系统管理员联系！',
            '系统错误！', mb_ok + mb_iconerror);
        Application.Terminate;
    end;
    try
        photoinifile := TIniFile.Create(apppath + sCustomerConfig);
        dbconfig := TIniFile.Create(apppath + sDbConfig);

        tblPhoto := photoinifile.ReadString('tablename', 'tblphoto', '');
        tblDept := photoinifile.ReadString('tablename', 'tbldept', '');
        tblSpec := photoinifile.ReadString('tablename', 'tblspec', '');
        tblDict := photoinifile.ReadString('tablename', 'tbldict', '');
        tblCust := photoinifile.ReadString('tablename', 'tblcust', '');
        tbllimit := photoinifile.ReadString('tablename', 'tbllimit', '');
        tblArea := photoinifile.ReadString('tablename', 'tblArea', '');
        tblCutType := photoinifile.ReadString('tablename', 'tblCutType', '');
        tblFeeType := photoinifile.ReadString('tablename', 'tblFeeType', '');
        tblSysKey := photoinifile.ReadString('tablename', 'tblSysKey', '');
        tblCard := photoinifile.ReadString('tablename', 'tblCard', '');

        custId := photoinifile.ReadString('fieldname', 'custId', '');
        stuempNo := photoinifile.ReadString('fieldname', 'stuempNo', '');
        custName := photoinifile.ReadString('fieldname', 'custName', '');
        custType := photoinifile.ReadString('fieldname', 'custType', '');
        custState := photoinifile.ReadString('fieldname', 'custState', '');
        custArea := photoinifile.ReadString('fieldname', 'custArea', '');
        custSex := photoinifile.ReadString('fieldname', 'custSex', '');
        custcardId := photoinifile.ReadString('fieldname', 'custcardId', '');
        custDeptNo := photoinifile.ReadString('fieldname', 'custDeptNo', '');
        custSpecNo := photoinifile.ReadString('fieldname', 'custSpecNo', '');
        custRegTime := photoinifile.ReadString('fieldname', 'custRegTime', '');
        custFeeType := photoinifile.ReadString('fieldname', 'custFeeType', '');
        classNo := photoinifile.ReadString('fieldname', 'classNo', '');
        batchNo := photoinifile.ReadString('fieldname', 'batchNo', '');
        extField1 := photoinifile.ReadString('fieldname', 'extField1', '');
        extField2 := photoinifile.ReadString('fieldname', 'extField2', '');

        pPhoto := photoinifile.ReadString('fieldname', 'pPhoto', '');
        PMinPhoto := photoinifile.ReadString('fieldname', 'pMinPhoto', '');
        pIfCard := photoinifile.ReadString('fieldname', 'pIfCard', '');
        pCardDate := photoinifile.ReadString('fieldname', 'pCardDate', '');
        pCardTime := photoinifile.ReadString('fieldname', 'pCardTime', '');
        pPhotoDate := photoinifile.ReadString('fieldname', 'pPhotoDate', '');
        pPhotoTime := photoinifile.ReadString('fieldname', 'pPhotoTime', '');
        pPhotoDTime := photoinifile.ReadString('fieldname', 'pPhotoDTime', '');
        res_1 := photoinifile.ReadString('fieldname', 'res_1', '');
        res_2 := photoinifile.ReadString('fieldname', 'res_2', '');
        res_3 := photoinifile.ReadString('fieldname', 'res_3', '');

        lmtOperCode := photoinifile.ReadString('fieldname', 'lmtOperCode', '');
        lmtOperName := photoinifile.ReadString('fieldname', 'lmtOperName', '');
        lmtBeginDate := photoinifile.ReadString('fieldname', 'lmtBeginDate', '');
        lmtEndDate := photoinifile.ReadString('fieldname', 'lmtEndDate', '');
        lmtpwd := photoinifile.ReadString('fieldname', 'lmtpwd', '');
        lmtLimit := photoinifile.ReadString('fieldname', 'lmtLimit', '');
        lmtEnabled := photoinifile.ReadString('fieldname', 'lmtEnabled', '');

        deptCode := photoinifile.ReadString('fieldname', 'deptCode', '');
        deptName := photoinifile.ReadString('fieldname', 'deptName', '');
        deptParent := photoinifile.ReadString('fieldname', 'deptParent', '');
        deptLevel := photoinifile.ReadString('fieldname', 'deptLevel', '');

        specCode := photoinifile.ReadString('fieldname', 'specCode', '');
        specName := photoinifile.ReadString('fieldname', 'specName', '');

        dictNo := photoinifile.ReadString('fieldname', 'dictNo', '');
        dictValue := photoinifile.ReadString('fieldname', 'dictValue', '');
        dictCaption := photoinifile.ReadString('fieldname', 'dictCaption', '');

        areaNo := photoinifile.ReadString('fieldname', 'areaNo', '');
        areaName := photoinifile.ReadString('fieldname', 'areaName', '');
        areaFather := photoinifile.ReadString('fieldname', 'areaFather', '');

        typeName := photoinifile.ReadString('fieldname', 'typeName', '');
        typeNo := photoinifile.ReadString('fieldname', 'typeNo', '');

        feeFeeType := photoinifile.ReadString('fieldname', 'feeFeeType', '');
        feeFeeName := photoinifile.ReadString('fieldname', 'feeFeeName', '');

        keyCode := photoinifile.ReadString('fieldname', 'keyCode', '');
        keyName := photoinifile.ReadString('fieldname', 'keyName', '');
        keyValue := photoinifile.ReadString('fieldname', 'keyValue', '');
        keyMaxValue := photoinifile.ReadString('fieldname', 'keyMaxValue', '');
        keyCustId := photoinifile.ReadString('fieldname', 'keyCustId', '');

        cardCardId := photoinifile.ReadString('fieldname', 'cardCardId', '');
        cardStateId := photoinifile.ReadString('fieldname', 'cardStateId', '');
        cardCustId := photoinifile.ReadString('fieldname', 'cardCustId', '');

        useRemoteSoft := photoinifile.ReadBool('photo_config', 'remotecapture', True);

        photopath := photoinifile.ReadString('photo_config', 'photopath', '');
        photopre := photoinifile.ReadString('photo_config', 'photopre', '');
        diskpath := photoinifile.ReadString('photo_config', 'diskpath', '');

        rotate := photoinifile.ReadBool('photo_config', 'rotate', True);
        angle := photoinifile.ReadInteger('photo_config', 'angle', 0);

        minWidth := photoinifile.ReadInteger('photo_config', 'width', 0);
        minHeight := photoinifile.ReadInteger('photo_config', 'height', 0);
        if (minWidth / minHeight) <> 0.75 then
            minHeight := Round(minWidth * 4 / 3 + 1);
        pageOrien := photoinifile.ReadString('photo_config', 'orientation', 'P');

        ve_visible := photoinifile.ReadBool('photoviewbox', 'visible', False);
        if ve_visible = False then
            Exit;
        veL_top := photoinifile.ReadInteger('photoviewbox', 'lneL_top', 0);
        veL_left := photoinifile.ReadInteger('photoviewbox', 'lneL_left', 0);
        veL_height := photoinifile.ReadInteger('photoviewbox', 'lneL_height', 0);

        veR_top := photoinifile.ReadInteger('photoviewbox', 'lneR_top', 0);
        veR_left := photoinifile.ReadInteger('photoviewbox', 'lneR_left', 0);
        veR_height := photoinifile.ReadInteger('photoviewbox', 'lneR_height', 0);

        veT_top := photoinifile.ReadInteger('photoviewbox', 'lneT_top', 0);
        veT_left := photoinifile.ReadInteger('photoviewbox', 'lneT_left', 0);
        veT_width := photoinifile.ReadInteger('photoviewbox', 'lneT_width', 0);

        veB_top := photoinifile.ReadInteger('photoviewbox', 'lneB_top', 0);
        veB_left := photoinifile.ReadInteger('photoviewbox', 'lneB_left', 0);
        veB_width := photoinifile.ReadInteger('photoviewbox', 'lneB_width', 0);

        veA_top := photoinifile.ReadInteger('photoviewbox', 'lneA_top', 0);
        veA_left := photoinifile.ReadInteger('photoviewbox', 'lneA_left', 0);
        veA_width := photoinifile.ReadInteger('photoviewbox', 'lneA_width', 0);

        dburl := DecryptString(dbconfig.readstring('database', 'dbServer', '127.0.0.2:1521:yktdb'), CryptKey);
        dbUid := DecryptString(dbconfig.readstring('database', 'dbUser', 'ykt'), CryptKey);
        dbPwd := DecryptString(dbconfig.readstring('database', 'dbPass', 'password'), CryptKey);
    finally
        photoinifile.Destroy;
        dbconfig.Destroy;
    end;
end;

{-------------------------------------------------------------------------------
  过程名:    AddData向下拉列表中添加数据
  参数:      cbb:TComboBox;sqlstr:string
  返回值:    无
-------------------------------------------------------------------------------}

procedure AddData(cbb: TComboBox; sqlstr: string);
var
    qryExecSQL: TOraQuery;
begin
    qryExecSQL := nil; //frmdm.qryQuery;
    try
        qryExecSQL := TOraQuery.Create(Application.MainForm);
        qryExecSQL.Connection := frmdm.conn;
        //qryExecSQL.LockType := ltUnspecified;
        cbb.Items.Clear;
        cbb.Items.Add('');
        qryExecSQL.Close;
        qryExecSQL.sql.Clear;
        qryExecSQL.SQL.Add(sqlstr);
        qryExecSQL.Prepared;
        qryExecSQL.Open;
        if not qryExecSQL.IsEmpty then begin
            qryExecSQL.First;
            while not qryExecSQL.Eof do begin
                cbb.Items.Add(qryExecSQL.Fields[1].Text + '-' + qryexecSql.Fields[0].Text);
                qryExecSQL.Next;
            end;
            //cbb.Sorted := True;
        end;
    finally
        qryExecSQL.Destroy;
    end;
end;

{-------------------------------------------------------------------------------
  过程名:    subString
  参数:      ssname:string;str:string;posi:string字符串，分割字符串，截取方向
  返回值:    string
-------------------------------------------------------------------------------}

function subString(ssname: string; str: string; posi: string): string;
begin
    if LowerCase(posi) = 'l' then
        Result := Copy(ssname, 0, Pos(str, ssname) - 1);
    if LowerCase(posi) = 'r' then
        Result := Copy(ssname, Pos(str, ssname) + 1, Length(ssname));
end;

{-------------------------------------------------------------------------------
  过程名:    getDeptName根据部门编码返回部门名称
  参数:      sDeptCode:string
  返回值:    string
-------------------------------------------------------------------------------}

function getDeptName(sDeptCode: string): string;
var
    sqlstr: string;
begin
    sqlstr := 'select ' + deptname + ' from ' + tblDept + ' where ' + deptcode + '=' + QuotedStr(sDeptCode);
    Result := sqlExec(sqlstr, deptname);
end;

{-------------------------------------------------------------------------------
  过程名:    getSName根据专业编码返回专业名称
  参数:      ssCode:string
  返回值:    string
-------------------------------------------------------------------------------}

function getSName(ssCode: string): string;
var
    sqlstr: string;
begin
    sqlstr := 'select ' + specName + ' from ' + tblSpec + ' where ' + specCode + '=' + QuotedStr(ssCode);
    Result := sqlExec(sqlstr, specName);
end;

{-------------------------------------------------------------------------------
  过程名:    sqlExec根据代码查找相关的名称，并返回。把其它的函数修改为调用此
  参数:      sqlstr:string;rname:string
  返回值:    string
-------------------------------------------------------------------------------}

function sqlExec(sqlstr: string; rname: string): string;
var
    tempQuery: TOraQuery;
begin
    tempQuery := nil;
    try
        tempQuery := TOraQuery.Create(nil);
        tempQuery.Connection := frmDM.conn;
        tempQuery.Close;
        tempQuery.SQL.Clear;
        tempQuery.SQL.Add(sqlstr);
        tempQuery.Open;
        if not tempQuery.IsEmpty then
            Result := tempQuery.fieldbyname(rname).AsString
        else
            Result := '';
    finally
        tempQuery.Destroy;
    end;
end;
{-------------------------------------------------------------------------------
  过程名:    getAreaName根据区域编号取得区域名称
  参数:      areaNo:string
  返回值:    String
-------------------------------------------------------------------------------}

function getAreaName(sareaNo: string): string;
var
    sqlstr: string;
begin
    sqlstr := 'select ' + areaName + ' from ' + tblArea + ' where 1=1 and ';
    sqlstr := sqlstr + areaNo + '=' + QuotedStr(sareaNo);
    Result := sqlExec(sqlstr, areaName);
end;

{-------------------------------------------------------------------------------
  过程名:    getStatesName取得状态名称
  参数:      StateNo:string
  返回值:    String
-------------------------------------------------------------------------------}

function getStatesName(StateNo: string): string;
var
    sqlstr: string;
begin
    sqlstr := 'select ' + dictCaption + ' from ' + tblDict + ' where ' + dictNo + '=9 and ';
    sqlstr := sqlstr + dictValue + '=' + QuotedStr(StateNo);
    Result := sqlExec(sqlstr, dictCaption);
end;

{-------------------------------------------------------------------------------
  过程名:    getTypeName取得类别名称
  参数:      typeNo:string
  返回值:    String
-------------------------------------------------------------------------------}

function getTypeName(stypeNo: string): string;
var
    sqlstr: string;
begin
    sqlstr := 'select ' + typeName + ' from ' + tblCutType + ' where ' + typeNo + '=' + stypeNo;
    Result := sqlExec(sqlstr, typeName);
end;

{-------------------------------------------------------------------------------
  过程名:    getTypeName取得卡号
  参数:      typeNo:string
  返回值:    String
-------------------------------------------------------------------------------}

function getCardNo(custId: string): string;
var
    sqlstr: string;
begin
    sqlstr := 'select ' + cardCardId + ' from ' + tblCard + ' where ' + cardStateId;
    sqlstr := sqlstr + ' in (' + #39 + '1' + #39 + ') and ' + cardCustId + '=' + custId;
    Result := sqlExec(sqlstr, cardCardId);
end;

function queryBaseInfoSql(sstuempNo: string; sareaId: string; scustId: string): string;
var
    sqlStr: string;
begin
    sqlStr := 'select ' + custId + ',' + stuempNo + ',' + custName + ',' + custType + ',' + custState;
    sqlStr := sqlStr + ',' + custArea + ',' + custCardId + ',' + custDeptNo + ',' + custSpecNo + ',' + classNo;
    sqlStr := sqlStr + ',' + custRegTime + ',' + custFeeType; //+','+extfield1+','+extfield2;
    sqlStr := sqlStr + ' from ' + tblCust + ' where 1>0';
    if Trim(sstuempNo) <> '' then
        sqlStr := sqlStr + ' and ' + stuempNo + '=' + #39 + sstuempNo + #39;
    if Trim(sareaId) <> '' then
        sqlStr := sqlStr + ' and ' + custArea + '=' + sareaId;
    if Trim(scustId) <> '' then
        sqlStr := sqlStr + ' and ' + custId + '=' + scustId;

    Result := sqlStr;
end;


function getPhotoInfo(scustId: string): TJPEGImage;
var
    sqlStr: string;
    qrySQL: TOraQuery;
    F3: TMemoryStream;
    Fjpg: TJpegImage;
    Fbmp: TBitmap;
    Buffer: Word;
begin
    sqlStr := 'select ' + pPhoto + ',' + pIfCard + ',' + pPhotoDate + ',' + pPhotoTime;
    sqlStr := sqlStr + ',' + pcardDate + ',' + pCardTime;
    sqlStr := sqlStr + ' from ' + tblPhoto + ' where ' + custId + '=' + scustId;
    qrySQL := nil;
    Fbmp := nil;
    //Fjpg:=nil;
    Result := nil;
    cpIfCard := '';
    cpCardDate := '';
    cpCardTime := '';
    F3 := TMemoryStream.Create;
    try
        qrySQL := TOraQuery.Create(nil);
        qrySQL.Connection := frmdm.conn;
        qrySQL.Close;
        qrySQL.SQL.Clear;
        qrySQL.SQL.Add(sqlStr);
        qrySQL.Prepared;
        qrySQL.Open;
        if not qrySQL.IsEmpty then begin
            qrySQL.First;
            cpIfCard := qrySQL.fieldbyname(pIfCard).AsString;
            cpCardDate := qrySQL.fieldbyname(pCardDate).AsString;
            cpCardTime := qrySQL.fieldbyname(pCardTime).AsString;
            TBlobField(qrySQL.fieldbyname(pPhoto)).savetoStream(F3);

            if (f3.Size = 0) then begin
                result := nil;
                Exit;
            end;
            F3.Position := 0;
            F3.ReadBuffer(Buffer, 2); //读取文件的前２个字节，放到Buffer里面
            try
                Fjpg := TJpegImage.create;

                if Buffer = $4D42 then {//如果前两个字节是以4D42[低位到高位] (bmp)} begin
                    //ShowMessage('BMP'); //那么这个是BMP格式的文件
                    Fbmp := TBitmap.Create;
                    F3.Position := 0;
                    if F3.Size > 10 then begin
                        Fbmp.LoadFromStream(F3);
                        Fjpg.Assign(Fbmp);
                        Result := Fjpg;
                    end;
                end
                else {//如果前两个字节是以D8FF[低位到高位] (JPEG)} begin
                    //ShowMessage('JPEG'); //........一样　下面不注释了
                    F3.Position := 0;
                    if F3.Size > 10 then begin
                        FJpg.LoadFromStream(F3);
                        Result := Fjpg;
                    end;
                end;
                //Fjpg := TJpegImage.Create;
            finally
                //if Fjpg<>nil then
                  //Fjpg.Free;
                if Fbmp <> nil then
                    Fbmp.Free;
                F3.Destroy;
            end;
        end;
    finally
        qrySQL.Destroy;
    end;
end;

{-------------------------------------------------------------------------------
  过程名:    getJpgNo取得照片的编号
  参数:      jpgName:string
  返回值:    string
-------------------------------------------------------------------------------}

function getJpgNo(jpgName: string): string;
begin
    result := subString(jpgName, '.', 'l');
end;

{-------------------------------------------------------------------------------
  过程名:    ExportData
  参数:      SaveDialog1: TSaveDialog;DBGridEh1: TDBGridEh
  返回值:    无
-------------------------------------------------------------------------------}

function ExportData(SaveDialog1: TSaveDialog; DBGridEh1: TDBGridEh): Boolean;
var
    ExpClass: TDBGridEhExportClass;
    Ext: string;
begin
    Result := False;
    try
        begin
            SaveDialog1.FileName := '导出数据' + formatdatetime('yyyymmdd', date());
            DBGridEh1.Selection.SelectAll;
            if SaveDialog1.Execute then begin
                case SaveDialog1.FilterIndex of
                    4: begin
                            ExpClass := TDBGridEhExportAsText; Ext := 'txt'; end;
                    2: begin
                            ExpClass := TDBGridEhExportAsHTML; Ext := 'htm'; end;
                    3: begin
                            ExpClass := TDBGridEhExportAsRTF; Ext := 'rtf'; end;
                    1: begin
                            ExpClass := TDBGridEhExportAsXLS; Ext := 'xls'; end;
                else
                    ExpClass := nil; Ext := '';
                end;
                if ExpClass <> nil then begin
                    if UpperCase(Copy(SaveDialog1.FileName, Length(SaveDialog1.FileName) - 2, 3)) <> UpperCase(Ext) then
                        SaveDialog1.FileName := SaveDialog1.FileName + '.' + Ext;
                    SaveDBGridEhToExportFile(ExpClass, DBGridEh1, SaveDialog1.FileName, False);
                end;
                Result := True;
            end;
        end;
    except
        showmessage('导出失败！请检查...');
    end;
end;

{-------------------------------------------------------------------------------
  过程名:    TfrmAddCustInfo.haveStuEmpNo检查是否存在学工号
  参数:      无
  返回值:    Boolean存在返回true，否则返回false
-------------------------------------------------------------------------------}

function haveStuEmpNo(sstuEmpNo: string): Boolean;
var
    tmpQuery: TOraQuery;
    strSql: string;
begin
    strSql := queryBaseInfoSql(sstuEmpNo, '', '');
    tmpQuery := nil;
    Result := False;
    try
        tmpQuery := TOraQuery.Create(nil);
        tmpQuery.Connection := frmdm.conn;
        tmpQuery.Close;
        tmpQuery.SQL.Clear;
        tmpQuery.SQL.Add(strSql);
        tmpQuery.Open;
        if not tmpQuery.IsEmpty then
            Result := True;
    finally
        tmpQuery.Destroy;
    end;
end;

{-------------------------------------------------------------------------------
  过程名:    qryOperSql
  参数:      soperCode:string;spwd:string
  返回值:    string
-------------------------------------------------------------------------------}

function qryOperSql(soperCode: string; spwd: string): string;
var
    sqlStr: string;
begin
    sqlStr := 'select ' + lmtOperCode + ',' + lmtOperName + ',' + lmtBeginDate + ',' + lmtEndDate;
    sqlStr := sqlStr + ',' + lmtpwd + ',' + lmtLimit + ',' + lmtEnabled + ' from ' + tblLimit;
    sqlStr := sqlStr + ' where 1>0 ';
    if soperCode <> '' then
        sqlStr := sqlStr + ' and ' + lmtOperCode + '=' + #39 + sopercode + #39;
    if spwd <> '' then
        sqlStr := sqlStr + ' and ' + lmtpwd + '=' + #39 + DecryptString(spwd, CryptKey) + #39;

    Result := sqlStr;
end;

function judgelimit(oper: string; code: integer): boolean;
begin
    if copy(oper, code + 1, 1) = '1' then
        result := true
    else
        result := false;
end;

{-------------------------------------------------------------------------------
  过程名:    insertPhotoData
  参数:      sCustId, sStuempNo: string
  返回值:    无
-------------------------------------------------------------------------------}

procedure insertPhotoData(sCustId, sStuempNo: string);
var
    photoQuery: TOraQuery;
    photoStr: string;
begin
    photoQuery := nil;
    try
        photoQuery := TOraQuery.Create(nil);
        photoQuery.Connection := frmdm.conn;
        //photoQuery.LockType := ltUnspecified;
        photoQuery.Close;
        photoQuery.SQL.Clear;
        photoQuery.SQL.Add('select count(*) as num from ' + tblPhoto + ' where ' + custId + '=' + sCustId);
        photoQuery.Open;
        if photoQuery.FieldByName('num').AsInteger = 0 then begin
            photoStr := 'insert into ' + tblPhoto + '(' + custId + ',' + stuempNo + ')values(';
            photoStr := photoStr + sCustId + ',';
            photoStr := photoStr + #39 + sStuempNo + #39 + ')';
            photoQuery.Close;
            photoQuery.SQL.Clear;
            photoQuery.SQL.Add(photoStr);
            photoQuery.ExecSQL;
        end;
    finally
        photoQuery.Free;
    end;
end;

{-------------------------------------------------------------------------------
  过程名:    getMaxCustId取客户号
  参数:      无
  返回值:    Integer
-------------------------------------------------------------------------------}

function getMaxCustId: Integer;
var
    tmpQuery: TOraQuery;
    sqlStr: string;
    icustId: Integer;
begin
    sqlStr := 'select ' + keyValue + ' from ' + tblSysKey + ' where ' + keyCode + '=' + #39 + keyCustId + #39;
    tmpQuery := nil;
    icustId := 0;
    try
        tmpQuery := TOraQuery.Create(nil);
        tmpQuery.Connection := frmdm.conn;
        tmpQuery.Close;
        tmpQuery.SQL.Clear;
        tmpQuery.SQL.Add(sqlStr);
        tmpQuery.Open;
        if not tmpQuery.IsEmpty then
            icustId := tmpQuery.fieldbyname(keyValue).AsInteger;
        Result := icustId + 1;
    finally
        tmpQuery.Destroy;
    end;
end;

function addCustInfo(sstuempNo, sname, stype, sArea, scardId, sDept, sSpec, sFeeType: string): Boolean;
var
    custQuery: TOraQuery;
    keyQuery: TOraQuery;
    keyStr: string;
    custStr: string;
    icustId: Integer;
begin
    Result := False;
    icustId := getMaxCustId();
    custStr := 'insert into ' + tblCust + '(' + custId + ',' + stuempNo + ',' + custName + ',';
    custStr := custStr + custType + ',' + custState + ',' + custArea + ',' + custCardId + ',';
    custStr := custStr + custDeptNo + ',' + custSpecNo + ',' + custRegTime + ',' + feeFeeType + ')values(';
    custStr := custStr + inttostr(icustId) + ',';
    custStr := custStr + #39 + sstuempNo + #39 + ',';
    custStr := custStr + #39 + sname + #39 + ',';
    custStr := custStr + stype + ',';
    custStr := custStr + '1' + ',';
    custStr := custStr + sArea + ',';
    custStr := custStr + #39 + scardId + #39 + ',';
    custStr := custStr + #39 + sDept + #39 + ',';
    custStr := custStr + #39 + sSpec + #39 + ',';
    custStr := custStr + #39 + formatdatetime('yyyymmdd', now()) + #39 + ',';
    custStr := custStr + sFeeType + ')';
    keyStr := 'update ' + tblSysKey + ' set ' + keyValue + '=' + inttostr(icustId);
    keyStr := keyStr + ' where ' + keyCode + '=' + #39 + keyCustId + #39; ;
    custQuery := nil;
    //keyQuery := nil;
    try
        custQuery := TOraQuery.Create(nil);
        custQuery.Connection := frmdm.conn;

        custQuery.Close;
        custQuery.SQL.Clear;
        custQuery.SQL.Add(custStr);

        keyQuery := TOraQuery.Create(nil);
        keyQuery.Connection := frmdm.conn;

        keyQuery.Close;
        keyQuery.SQL.Clear;
        keyQuery.SQL.Add(keyStr);

        frmdm.conn.StartTransaction;
        try
            keyQuery.ExecSQL;
            custQuery.ExecSQL;
            frmdm.conn.Commit;
            Result := True;
        except

            frmdm.conn.Rollback;
            Result := False;
        end;
    finally
        custQuery.Destroy;
    end;
end;
{-------------------------------------------------------------------------------
  过程名:    delFileBat批量删除文件
  参数:      filePath,fileName:string
  返回值:    Boolean
-------------------------------------------------------------------------------}

procedure delFileBat(filePath, fileName: string);
var
    FileDir: string;
    FileStruct: TSHFileOpStruct;
begin
    try
        FileDir := filePath + '\' + filename;
        FileStruct.Wnd := 0;
        FileStruct.wFunc := FO_delete;
        FileStruct.pFrom := Pchar(FileDir + #0);
        FileStruct.fFlags := FOF_NOCONFIRMATION;
        FileStruct.pTo := '';
        if SHFileOperation(FileStruct) = 0 then
            Exit;
    except
    end;
end;


function getDbTime: string;
var
    tmpQuery: TOraQuery;
    sqlStr: string;
begin
    sqlStr := 'select to_char(current_timestamp,''YYYYMMDDHH24MISSFF'') dbtime from dual';

    try
        tmpQuery := TOraQuery.Create(nil);
        tmpQuery.Connection := frmdm.conn;
        tmpQuery.Close;
        tmpQuery.SQL.Clear;
        tmpQuery.SQL.Add(sqlStr);
        tmpQuery.Open;
        Result := tmpQuery.fieldbyname('dbtime').AsString;
    finally
        tmpQuery.Free;
    end;
end;

end.

