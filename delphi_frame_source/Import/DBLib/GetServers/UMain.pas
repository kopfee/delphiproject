unit UMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    lsServers: TListBox;
    btnGetServers: TButton;
    Label1: TLabel;
    procedure btnGetServersClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

function GetSQLServers(Servers : TStrings): Boolean;

implementation

uses MSSQL;

{$R *.DFM}

function GetSQLServers(Servers : TStrings): Boolean;
var
  NamesBuffer : Array[0..1024-1] of char;
  ServerCount : word;
  P,P1 : PChar;
  Status : Integer;
begin
  Servers.Clear;
  FillChar(NamesBuffer,SizeOf(NamesBuffer),0);
  ServerCount := 0;
  Status := dbserverenum(BOTH__SEARCH,@NamesBuffer[0],SizeOf(NamesBuffer),ServerCount);
  Result := (Status<=MORE_DATA) or (((Status and NET_NOT_AVAIL)<>0) and (ServerCount>0));
  if Result then
  begin
    P := @NamesBuffer[0];
    while p^<>#0 do
    begin
      P1 := P;
      while P^<>#0 do
        Inc(P);
      Servers.Add(String(P1));
      Inc(P); // skip this null char
    end;
  end;
end;

procedure TForm1.btnGetServersClick(Sender: TObject);
begin
  GetSQLServers(lsServers.Items);  
end;

end.
