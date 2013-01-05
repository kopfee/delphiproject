unit uModifyPwd;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, Buttons, Ora;

type
    TfrmModifyPwd = class(TForm)
        lbl1: TLabel;
        lblName: TLabel;
        Label1: TLabel;
        edtOld: TEdit;
        Label2: TLabel;
        edtNew: TEdit;
        Label3: TLabel;
        edtVerify: TEdit;
        btnOk: TBitBtn;
        btnCancle: TBitBtn;
        procedure btnCancleClick(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure btnOkClick(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    frmModifyPwd: TfrmModifyPwd;

implementation

uses AES, ElAES, uCommon, Udm;

{$R *.dfm}

procedure TfrmModifyPwd.btnCancleClick(Sender: TObject);
begin
    Close;
end;

procedure TfrmModifyPwd.FormShow(Sender: TObject);
begin
    lblName.Caption := loginName;

end;

procedure TfrmModifyPwd.btnOkClick(Sender: TObject);
var
    operQuery: TOraQuery;
    operStr: string;
begin
    if Trim(edtOld.Text) <> loginPwd then begin
        ShowMessage('你输入的原密码不正确，请重新输入！');
        edtOld.SetFocus;
        Exit;
    end;
    if Trim(edtNew.Text) = '' then begin
        ShowMessage('新密码不能为空！');
        edtNew.SetFocus;
        Exit;
    end;
    if Trim(edtNew.Text) <> Trim(edtVerify.Text) then begin
        ShowMessage('新密码和验证密码不正确，请重新输入！');
        edtNew.Text;
        Exit;
    end;

    operStr := 'update ' + tblLimit + ' set ';
    operStr := operStr + lmtpwd + '=' + #39 + EncryptString(trim(edtNew.Text), CryptKey) + #39;
    operStr := operStr + ' where ' + lmtOperCode + '=' + #39 + loginName + #39;
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
            loginPwd := Trim(edtNew.Text);
            ShowMessage('修改操作员密码成功！');
            close;
        except
            frmdm.conn.Rollback;
            ShowMessage('修改操作员密码失败，请检查网络是否连通！');
        end;
    finally
        operQuery.Destroy;
    end;

end;

end.
