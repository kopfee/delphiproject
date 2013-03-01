unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edHost: TEdit;
    edServer: TEdit;
    edUser: TEdit;
    edPassword: TEdit;
    btnConnect: TButton;
    procedure btnConnectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses MSSQL,MSSQLAcs;

{$R *.DFM}

procedure TForm1.btnConnectClick(Sender: TObject);
var
  FDBLogin,FDBProc : pointer;
  FHostName,FUserName,FPassword,FServerName : string;
  FTimeout : integer;
begin
  FServerName := edServer.text;
  FHostName := edHost.text;
  FUserName := edUser.text;
  FPassword := edPassword.text;
  FTimeout := 30;
  FDBLogin:=dblogin;
  CheckLibCall(FDBLogin<>nil,'getLogin');
  if FHostName<>'' then
    checkLibCall(dbsetlname(FDBLogin,pchar(FHostName),DBSETHOST)=SUCCEED,'dbsetlname');
  checkLibCall(dbsetlname(FDBLogin,pchar(FUserName),DBSETUSER)=SUCCEED,'dbsetlname');
  checkLibCall(dbsetlname(FDBLogin,pchar(FPassword),DBSETPWD)=SUCCEED,'dbsetlname');
  checkLibCall(dbsetlname(FDBLogin,nil,DBVER60)=SUCCEED,'dbsetlname');
  checkLibCall(dbsetlogintime(FTimeout)=succeed,'dbsetlogintime');
  FDBProc := dbopen(FDBLogin,pchar(FServerName));
  CheckLibCall(FDBProc<>nil,'dbopen');
  showMessage('OK');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  dbinit;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  dbexit;
end;

end.
