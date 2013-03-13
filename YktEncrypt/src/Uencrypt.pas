unit Uencrypt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, RzButton;

type
  TfrmEncrypt = class(TForm)
    pnl1: TPanel;
    lbl1: TLabel;
    Label1: TLabel;
    edtKey: TEdit;
    cbbLength: TComboBox;
    grpSource: TGroupBox;
    mmoSource: TMemo;
    GroupBox1: TGroupBox;
    mmoencrypt: TMemo;
    GroupBox2: TGroupBox;
    mmoDecrypt: TMemo;
    btnEncrypt: TRzButton;
    btnDecrypy: TRzButton;
    btnClose: TRzButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnEncryptClick(Sender: TObject);
    procedure btnDecrypyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEncrypt: TfrmEncrypt;

implementation

uses AES, ElAES;

{$R *.DFM}

procedure TfrmEncrypt.FormCreate(Sender: TObject);
begin
   cbblength.ItemIndex:=0;
end;

procedure TfrmEncrypt.btnCloseClick(Sender: TObject);
begin
  close();
end;

procedure TfrmEncrypt.btnEncryptClick(Sender: TObject);
begin
  case cbbLength.ItemIndex of
    0: mmoencrypt.Text := EncryptString(mmoSource.Text, edtKey.Text);
    1: mmoencrypt.Text := EncryptString(mmoSource.Text, edtKey.Text, kb192);
    2: mmoencrypt.Text := EncryptString(mmoSource.Text, edtKey.Text, kb256);
  end;

end;

procedure TfrmEncrypt.btnDecrypyClick(Sender: TObject);
begin
  case cbbLength.ItemIndex of
    0: mmoDecrypt.Text := DecryptString(mmoencrypt.Text, edtKey.Text);
    1: mmoDecrypt.Text := DecryptString(mmoencrypt.Text, edtKey.Text, kb192);
    2: mmoDecrypt.Text := DecryptString(mmoencrypt.Text, edtKey.Text, kb256);
  end;

end;

end.
