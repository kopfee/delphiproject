unit Ulogin;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, Db, ADODB, ExtCtrls, RzButton, inifiles, IdHTTP;

type
    TloginForm = class(TForm)
        Panel1: TPanel;
        Label1: TLabel;
        Label2: TLabel;
        edtpwd: TEdit;
        edtOper: TEdit;
        btnLogin: TRzBitBtn;
        btnExit: TRzBitBtn;
        procedure btnExitClick(Sender: TObject);
        procedure btnLoginClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    loginForm: TloginForm;

implementation

uses AES, UDemo, uConst, mysql, md5, uLkJSON;

{$R *.DFM}

procedure TloginForm.btnExitClick(Sender: TObject);
begin
    Application.Terminate;
end;

procedure TloginForm.btnLoginClick(Sender: TObject);
var
    isLogin: boolean;
    md5pass: string;
    jsonString: string;
    idhtp1: TIdHTTP;
    responseString, sessionId: string;
    Params: TStrings;
    js: TlkJSONobject;
begin
    if (trim(edtOper.Text) = '') then begin
        MessageDlg('操作员号不能为空！', mtError, [mbOk], 0);
        edtOper.SetFocus;
        exit;
    end;
    if (trim(edtpwd.Text) = '') then begin
        MessageDlg('操作员密码不能为空！', mtError, [mbOk], 0);
        edtpwd.SetFocus;
        exit;
    end;

    md5pass := MD5Print(MD5String(trim(edtpwd.Text)));
    jsonString := format('{"user_auth":{"user_name":"%s","password":"%s"}}', [trim(edtOper.Text), md5pass]);
    idhtp1 := TidHTTp.create(self);
    Params := TStringList.Create;
    Params.Add('method=login');
    Params.Add('input_type=JSON');
    Params.Add('response_type=JSON');
    Params.Add('rest_data=' + jsonString);

    try
        responseString := idhtp1.Post('http://crm.lynnhawk.com/service/v4_1/rest.php', Params);
        js := TlkJSON.ParseText(responseString) as TlkJSONobject;
        sessionId := js.Field['id'].Value;
        isLogin := true;
        js.Free;
    except
        responseString := 'error';
        isLogin := false;
        js.Free;
    end;
    Params.Free;

    if (isLogin) then begin
        gLoginUserName := trim(edtOper.Text);
        gLoginUserId := getKeyId('select id from users where user_name ="' +gLoginUserName + '"');
        loginForm.Hide;
        Application.CreateForm(TFrmMain, frmMain);
        frmMain.Timer1.Interval := iMessage_interval * 1000 * 60;
        frmMain.Timer1.Enabled := true;
        frmMain.ShowModal;
        frmMain.Free;
        Application.Terminate;
    end
    else begin
        ShowMessage('用户名密码验证失败，请重新输入！');
        edtOper.SetFocus;
    end;
end;


procedure TloginForm.FormCreate(Sender: TObject);
var
    configIni: TIniFile;
    MyResult: Integer;
begin
    libmysql_fast_load(nil);

    if mySQL_Res <> nil then begin
        mysql_free_result(mySQL_Res);
        mySQL_Res := nil;
    end;
    if LibHandle <> nil then begin
        mysql_close(LibHandle);
        LibHandle := nil;
    end;
    LibHandle := mysql_init(nil);
    if LibHandle = nil then begin
        raise Exception.Create('mysql_init failed');
    end;

    configIni := TIniFile.Create(sDbConfig);
    bEncrypted := configIni.ReadBool('system', 'encrypted', true);
    bDebug := configIni.ReadBool('system', 'debug', false);
    iMessage_interval := configIni.ReadInteger('system', 'message_interval', 5);
    gSqlInsertCustomer := trim(configIni.readstring('crm', 'importCustomer', ''));
    gImportCustomerCols := configIni.ReadInteger('crm', 'importCustomerCols', 0);
    if (bEncrypted) then begin
        dburl := DecryptString(configIni.readstring('crm', 'serverurl', '192.168.3.254'), CryptKey);
        dbuser := DecryptString(configIni.readstring('crm', 'username', 'root'), CryptKey);
        dbpass := DecryptString(configIni.readstring('crm', 'password', 'wd12345678'), CryptKey);
        dbname := DecryptString(configIni.readstring('crm', 'dbname', 'sugarcrm'), CryptKey);
    end
    else begin
        dburl := configIni.readstring('crm', 'serverurl', '192.168.3.254');
        dbuser := configIni.readstring('crm', 'username', 'root');
        dbpass := configIni.readstring('crm', 'password', 'wd12345678');
        dbname := configIni.readstring('crm', 'dbname', 'sugarcrm');

        configIni.WriteString('crm', 'serverurl', EncryptString(Trim(dburl), CryptKey));
        configIni.WriteString('crm', 'username', EncryptString(Trim(dbuser), CryptKey));
        configIni.WriteString('crm', 'password', EncryptString(Trim(dbpass), CryptKey));
        configIni.WriteString('crm', 'dbname', EncryptString(Trim(dbname), CryptKey));
        configIni.WriteBool('system', 'encrypted', true);

    end;

    configIni.Free;


    if (mysql_real_connect(LibHandle,
        PAnsiChar(AnsiString(dburl)),
        PAnsiChar(AnsiString(dbuser)),
        PAnsiChar(AnsiString(dbpass)),
        nil, 0, nil, 0) = nil) then begin
        raise Exception.Create(mysql_error(LibHandle));
    end;

    mysql_set_character_set(LibHandle, 'gbk');
    MyResult := mysql_select_db(LibHandle, PAnsiChar(AnsiString(dbname)));
    if MyResult <> 0 then begin
        raise Exception.Create(mysql_error(LibHandle));
        Application.Terminate;
    end;
end;

end.

