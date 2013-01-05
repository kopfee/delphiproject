unit uConst;

interface

uses mysql, SysUtils, ActiveX;
const
    CryptKey = 'CRM54321'; //加密种子密钥
    sDbConfig = '..\config\' + 'config.ini';
    sSqlInsertMsgOrder = 'insert into msg_order (orderId,orderUrl,content,createTime,createId) values (%s,%s,%s,date_format(sysdate(),"%Y%m%d%H%i%s"),%s)';

var
    dburl, dbpass, dbuser, dbname: string; //数据库连接信息
    bEncrypted, bDebug: boolean;
    iMessage_interval: integer;
    LibHandle: PMYSQL;
    mySQL_Res: PMYSQL_RES;
    gLoginUserId, gLoginUserName: string; //登陆用户ID
    gSqlInsertCustomer: string;
    gImportCustomerCols: integer;

function getKeyId(nSql: string): string;
function replaceKeyWords(original: string): string;
function getUUID(): string;
function replaceUUID(original, uuidString: string): string;

implementation

function getKeyId(nSql: string): string;
var
    MYSQL_ROW: PMYSQL_ROW;
begin
    result := '';
    if (mysql_real_query(LibHandle, PAnsiChar(nSql), Length(nSql)) <> 0) then
        raise Exception.Create(mysql_error(LibHandle));
    if mySQL_Res <> nil then
        mysql_free_result(mySQL_Res);
    mySQL_Res := mysql_store_result(LibHandle);
    if (mysql_num_rows(mySQL_Res) > 0) then begin
        mysql_data_seek(mySQL_Res, 0);
        MYSQL_ROW := mysql_fetch_row(mySQL_Res);
        result := MYSQL_ROW^[0];
    end;
end;

function replaceKeyWords(original: string): string;
begin
    result := StringReplace(original, '$userId', QuoteString(gLoginUserId), [rfReplaceAll]);
end;

function replaceUUID(original, uuidString: string): string;
begin
    result := StringReplace(original, '$UUID', QuoteString(uuidString), [rfReplaceAll]);
end;


function getUUID(): string;
var
    TmpGUID: TGUID;
begin
    result := '';
    if CoCreateGUID(TmpGUID) = S_OK then
        result := GUIDToString(TmpGUID);
    result := StringReplace(result, '{', '', [rfReplaceAll]);
    result := LowerCase(StringReplace(result, '}', '', [rfReplaceAll]));
end;
end.

 