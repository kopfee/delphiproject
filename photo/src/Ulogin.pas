unit Ulogin;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, Db, ADODB, ExtCtrls, RzButton;

type
    TloginForm = class(TForm)
        Panel1: TPanel;
        Label1: TLabel;
        Label2: TLabel;
        edtpwd: TEdit;
        edtOper: TEdit;
        btnLogin: TRzBitBtn;
        btnExit: TRzBitBtn;
        Image1: TImage;
        procedure btnExitClick(Sender: TObject);
        procedure btnLoginClick(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    loginForm: TloginForm;

implementation

uses uCommon, Udm, AES;

{$R *.DFM}

procedure TloginForm.btnExitClick(Sender: TObject);
begin
    Application.Terminate;
end;

procedure TloginForm.btnLoginClick(Sender: TObject);
var
    sqlstr: string;
    sBegin: string;
    sEnd: string;
begin
    sqlstr := qryOperSql(Trim(edtOper.Text), '');
    frmdm.qryQuery.close;
    frmdm.qryQuery.sql.clear;
    frmdm.qryQuery.sql.add(sqlstr);
    frmdm.qryQuery.Open;

    if (Trim(edtOper.Text) = '') then begin
        MessageDlg('操作员帐号不能为空！', mtError, [mbOk], 0);
        ModalResult := mrNone;
        edtOper.SetFocus;
        exit;
    end;

    if frmdm.qryQuery.IsEmpty then begin
        MessageDlg('该操作员帐号不存在，请重新输入', mtError, [mbOk], 0);
        edtOper.SetFocus;
        ModalResult := mrNone;
        exit;
    end;
    loginPwd := Trim(DecryptString(frmdm.qryQuery.FieldByName(lmtpwd).asstring, CryptKey));
    loginName := frmdm.qryQuery.FieldByName(lmtOperCode).asstring;
    if Trim(edtpwd.Text) <> loginPwd then begin
        MessageDlg('操作员与密码不一致，请重新输入', mtError, [mbOk], 0);
        edtOper.SetFocus;
        ModalResult := mrNone;
        exit;
    end;
    sBegin := frmdm.qryQuery.FieldByName(lmtBeginDate).asstring;
    sEnd := frmdm.qryQuery.FieldByName(lmtEndDate).asstring;
    loginLimit := frmdm.qryQuery.FieldByName(lmtLimit).asstring;

    if judgelimit(loginLimit, Mdl_ifUse) = False then begin
        MessageDlg('操作员账号已经停用，请联系系统管理员', mtError, [mbOk], 0);
        edtOper.SetFocus;
        ModalResult := mrNone;
        Exit;
    end;
    close;

end;


end.
