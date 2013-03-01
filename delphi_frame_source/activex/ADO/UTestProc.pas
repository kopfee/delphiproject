unit UTestProc;

{
  This is a test program. That tests the return value of a stored-procedure
in ADO.
  The test DB-Server is TestServer
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,ADODB_TLB;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    edAccount: TEdit;
    Label2: TLabel;
    edNewAccount: TEdit;
    Label3: TLabel;
    edResult: TEdit;
    btnExec: TButton;
    edResult2: TEdit;
    ListBox1: TListBox;
    procedure btnExecClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Conn : _Connection;
    Cmd : _Command;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  // connect to DB
  Conn := CoConnection.Create;
  Conn.Open('DRIVER=SQL Server;SERVER=TestServer;DATABASE=sw2000;User Id=sw;PASSWORD=sw123',
    '','',0);
  // create command
  Cmd := CoCommand.Create;
  Cmd.Set_ActiveConnection(Conn);
  cmd.CommandType := 1;
	cmd.CommandTimeout := 10;
end;

(*
procedure TForm1.btnExecClick(Sender: TObject);
var
  SQLText : string;
  Affect : OleVariant;
  Params : OLEvariant;
  Result : integer;
  return : OleVariant;
begin
  SQLText := 'custStockRegister 100,1,1,'''+edAccount.text
	  +''',null,'''+edNewAccount.text
	  +''',null,null,null,null,null,null';
  cmd.CommandText := SQLText;
  //cmd.Parameters.Delete(0);
  cmd.Parameters.Append(cmd.CreateParameter('return',adInteger,adParamReturnValue,4,0));
  Params := null;
  //Params := VarArrayOf([]);
  //VarClear(Params);
  cmd.Execute(Affect,Params,adCmdText);
  //if varType(Params)
 { if VarIsArray(Params) then
  begin
    edResult.Text := 'out Params count: '
      + IntToStr(VarArrayHighBound(Params,1))
  end
  else}
  begin
    if cmd.Parameters.count>0 then
    begin
      //Result := cmd.Parameters.Item[0].value;
      //edResult.Text :=IntToStr(result);
      edResult.Text := cmd.Parameters.Item[0].Name;
      return := cmd.Parameters.Item[0].value;
      result := varType(return);
      edResult.Text :=edResult.Text+ IntToStr(result);
      edResult2.Text :=return;
    end;
  end;
end;
*)

function GetVariantText(v : Variant):string;
begin
  case VarType(V) of
    varEmpty : result:='<Empty>';
    varNull : result:='<Null>';
    varSmallint..varOleStr,varBoolean, varString : result := String(V);
    else result:='<Other>';
  end;
end;

procedure TForm1.btnExecClick(Sender: TObject);
var
  i : integer;
  Disp : OLEvariant;
begin
  cmd.CommandText := 'custStockRegister';
  cmd.CommandType := adCmdStoredProc;
  cmd.Parameters.Refresh;
  for i:=1 to cmd.Parameters.count-1 do
  begin
    cmd.Parameters.item[i].value:=null;
  end;
  cmd.Parameters.item['@function_id'].value:=100;
  cmd.Parameters.item['@customer_id'].value:=1;
  cmd.Parameters.item['@seid'].value:=1;
  cmd.Parameters.item['@stock_account'].value:=edAccount.text;
  cmd.Parameters.item['@report_account'].value:=edNewAccount.text;
  //cmd.Execute(Affect,Params,adCmdStoredProc);
  Disp := cmd;
  Disp.Execute;
  ListBox1.items.clear;
  for i:=0 to cmd.Parameters.count-1 do
  begin
    ListBox1.items.Add(format('%d:%s:%s',
      [i,cmd.Parameters.item[i].Name,GetVariantText(cmd.Parameters.item[i].value)]));
  end;
  if cmd.Parameters.count>0 then
  begin
    edResult.Text :=cmd.Parameters.item['RETURN_VALUE'].value;
  end;
end;

end.
