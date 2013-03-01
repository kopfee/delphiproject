unit ServerImp;

interface

uses
  ComObj, ActiveX, DataServer_TLB, StdVcl,MSSQLAcs,BasicDataAccess_TLB,BDAImp;

type
  TTestData = class(TAutoObject, ITestData)
  private
    FAcs : TMSSQLAcsEx;
  protected
    function exec(const sql: WideString): IHDataset; safecall;
    function Get_connected: WordBool; safecall;
    procedure connect(const hostName, serverName, user, password: WideString);
      safecall;
    { Protected declarations }
  public
    procedure   Initialize; override;
    Destructor  Destroy;override;
  end;

implementation

uses ComServ,DBAIntf;

function TTestData.exec(const sql: WideString): IHDataset;
var
  dataset : THDataset;
begin
  FAcs.ExecSQL(sql);
  dataset := THDataset.Create(IDBAccess(FAcs));
  dataset.clearFields;
  dataset.addAllExistFields;
  dataset.Open(10);
  result := IHDataset(dataset);
end;

function TTestData.Get_connected: WordBool;
begin
  result := FAcs.Connected;
end;

procedure TTestData.connect(const hostName, serverName, user,
  password: WideString);
begin
  FAcs.HostName := hostName;
  FAcs.serverName := serverName;
  FAcs.UserName := user;
  FAcs.Password := password;
  FAcs.Timeout := 30;
  FAcs.Connect;
  FAcs.isSupportCompute := true;
end;

destructor TTestData.Destroy;
begin
  FAcs.free;
  inherited;
end;

procedure TTestData.Initialize;
begin
  inherited;
  FAcs := TMSSQLAcsEx.create;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTestData, Class_TestData,
    ciMultiInstance, tmApartment);
end.
