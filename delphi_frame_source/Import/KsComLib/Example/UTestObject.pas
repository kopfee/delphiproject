unit UTestObject;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, BDAImpEx, KCDataAccess, DBAIntf, StdCtrls, Grids, DBGrids;

type
  TForm1 = class(TForm)
    KCDatabase: TKCDatabase;
    KCDataset: TKCDataset;
    btnTest: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edIP: TEdit;
    edPort: TEdit;
    edDestNo: TEdit;
    edFuncNo: TEdit;
    edAccount: TEdit;
    Label6: TLabel;
    edAccountType: TEdit;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    btnConnect: TButton;
    procedure btnTestClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses LogFile;

{$R *.DFM}

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  KCDatabase.Connected := False;
  btnTest.Enabled := False;
  KCDatabase.GatewayIP := edIP.Text;
  KCDatabase.GatewayPort := StrToInt(edPort.Text);
  KCDatabase.DestNo := StrToInt(edDestNo.Text);
  KCDatabase.FuncNo := StrToInt(edFuncNo.Text);
  KCDatabase.Connected := True;
  btnTest.Enabled := True;
end;

procedure TForm1.btnTestClick(Sender: TObject);
begin
  KCDataset.Params[0].AsString := edAccount.Text;
  KCDataset.Params[1].AsString := edAccountType.Text;
  KCDataset.Open;
end;

initialization
  OpenLogFile('',False,True);

end.
