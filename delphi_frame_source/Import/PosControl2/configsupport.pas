unit configsupport;

interface

uses classes, SysUtils, Dialogs, dbtables, inifiles;

type
{ TPCfgList }
  TPCfgList = class(Tobject)
  private
    procedure ensurenameexist(var Name: string);
    function getboolvalue(Name: string): boolean;
    function getfloatvalue(Name: string): double;
    function getintvalue(Name: string): integer;
    function getlowercasevalue(Name: string): string;
    function getnameexists(Name: string): boolean;
    function getoriginvalue(Name: string): string;
    function getuppercasevalue(Name: string): string;
  protected
    sqlcmd: TQuery;
    cfglist: TStringList;  
    procedure transmitconfig(tslist: TStringList);
  public
    constructor Create; //Note: this is non virtual
    destructor Destroy; override;

    property BoolValues[Name: string]: boolean read getboolvalue;
    property FloatValues[Name: string]: double read getfloatvalue;
    property IntValues[Name: string]: integer read getintvalue;
    property LowerCaseValues[Name: string]: string
                                            read getlowercasevalue;
    property NameExists[Name: string]: boolean read getnameexists;
    property OriginValues[Name: string]: string read getoriginvalue;
    property UpperCaseValues[Name: string]: string
                                            read getuppercasevalue;
  end;

{ TPSysCfg }
  TPSysCfg = class(TPCfgList)
  public
    constructor Create; //Note: this is non override
  end;

{ TPUnitCfg }
  TPUnitCfg = class(TPCfgList)
  public
    constructor Create(cfgobj: string); //Note: this is non override
  end;

{ TPIniCfg }
  TPIniCfg = class(TPCfgList)
  public
    constructor Create; //Note: this is non override
  end;

var
  SysConfig: TPSysCfg;
  UnitConfig: TPUnitCfg;
  IniConfig: TPIniCfg;

function GetLocalCfgGroup: string;

implementation

uses base_delphi_utils, enf_delphi_utils ;

var
	localgroup:string;

{ =================================================================== }
function getconfiggroup(CntCode: string): string;
var
sqlcmd: TQuery;
tstr: string;
begin
sqlcmd:=TQuery.Create(nil);
sqlcmd.DatabaseName:='POS';

sqlcmd.SQL.Clear;
tstr:='select configgroup from tbbranch '
     +'where Upper(branch_no)='''+CntCode+''' ';
sqlcmd.SQL.Add(tstr);
sqlcmd.Open;
if (sqlcmd.RecordCount<>1) then
  begin
    showmessage('Fatal Error in getconfiggroup:'+#13
               +'CntCode not in tbBranch.');
    sqlcmd.Active:=false;
    abort;
  end;
result:=sqlcmd.fieldbyname('configgroup').asstring;
result:=UpperCase(trim(result));
sqlcmd.Active:=false;

sqlcmd.Free;
end;
//-----------------------------------------------------------------
function GetLocalCfgGroup: string;
begin
	if localgroup <> '' then
	begin
		Result:=localgroup;
		exit;
	end;

result:=getconfiggroup(SysConfig.UpperCaseValues['LOCALCODE']);
end;
//-----------------------------------------------------------------

{ TPCfgList ========================================================= }
constructor TPCfgList.Create;
begin
sqlcmd:=TQuery.Create(nil);
sqlcmd.DatabaseName:='POS';
cfglist:=TStringList.Create;
cfglist.Duplicates:=dupError;
end;
//-----------------------------------------------------------------
destructor TPCfgList.Destroy;
begin
cfglist.Free;
sqlcmd.Free;
end;
//-----------------------------------------------------------------
procedure TPCfgList.ensurenameexist(var Name: string);
begin
if not(NameExists[Name]) then
  begin
    showmessage('TPCfgList: Config Info ['+Name+'] not exist.');
    abort;
  end;
end;
//-----------------------------------------------------------------
function TPCfgList.getboolvalue(Name: string): boolean;
var
tstr: string;
begin
result:=false;
ensurenameexist(Name);
tstr:=trim(cfglist.Values[Name]);
if (tstr='1') then result:=true
else if (tstr='0') then result:=false
else begin
       showmessage('TPCfgList.getboolvalue: '+#13
                  +'Config Info: '+Name+'='+tstr+' is invalid.');
       abort;
     end;
end;
//-----------------------------------------------------------------
function TPCfgList.getfloatvalue(Name: string): double;
var
tstr: string;
dtemp: double;
itemp: integer;
begin
ensurenameexist(Name);
tstr:=cfglist.Values[Name];
Val(tstr, dtemp, itemp);
if (itemp>0) then
  begin
    showmessage('TPCfgList.getfloatvalue: '+#13
               +'Config Info: '+Name+'='+tstr+' is invalid.');
    abort;
  end;
result:=dtemp;
end;
//-----------------------------------------------------------------
function TPCfgList.getintvalue(Name: string): integer;
var
tstr: string;
btemp: boolean;
begin
ensurenameexist(Name);
tstr:=cfglist.Values[Name];
btemp:=nformat(tstr, -1);
if not(btemp) then
  begin
    showmessage('TPCfgList.getintvalue: '+#13
               +'Config Info: '+Name+'='+tstr+' is invalid.');
    abort;
  end;
result:=strtoint(tstr);
end;
//-----------------------------------------------------------------
function TPCfgList.getlowercasevalue(Name: string): string;
var
tstr: string;
begin
ensurenameexist(Name);
tstr:=cfglist.Values[Name];
result:=LowerCase(trim(tstr));
end;
//-----------------------------------------------------------------
function TPCfgList.getnameexists(Name: string): boolean;
var
i: integer;
begin
Name:=UpperCase(trim(Name));
i:=cfglist.IndexOfName(Name);
result:=(i>=0);
end;
//-----------------------------------------------------------------
function TPCfgList.getoriginvalue(Name: string): string;
var
tstr: string;
begin
ensurenameexist(Name);
tstr:=cfglist.Values[Name];
result:=trim(tstr);
end;
//-----------------------------------------------------------------
function TPCfgList.getuppercasevalue(Name: string): string;
var
tstr: string;
begin
ensurenameexist(Name);
tstr:=cfglist.Values[Name];
result:=UpperCase(trim(tstr));
end;
//-----------------------------------------------------------------
procedure TPCfgList.transmitconfig(tslist: TStringList);
var
tstr: string;
begin
sqlcmd.First;
while not(sqlcmd.EOF) do
  begin
    tstr:=UpperCase(trim(sqlcmd.fieldbyname('name').asstring))+'=';
    tstr:=tstr+UpperCase(trim(sqlcmd.fieldbyname('value').asstring));
    tslist.Add(tstr);
    sqlcmd.Next;
  end;  // of while
end;
//-----------------------------------------------------------------

{ TPSysCfg ========================================================== }
constructor TPSysCfg.Create;
var
tstr, localgroup: string;
templist: TStringList;
begin
inherited Create;

sqlcmd.SQL.Clear;
tstr:='select name, value from tbconfigdt '
     +'where Upper(object)=''SYSTEM'' '
     +'  and rtrim(groupid) is null';
sqlcmd.SQL.Add(tstr);
sqlcmd.Open;
transmitconfig(cfglist);
sqlcmd.Active:=false;
localgroup:=getconfiggroup(UpperCaseValues['LOCALCODE']);
sqlcmd.SQL.Clear;
tstr:='select name, value from tbconfigdt '
     +'where Upper(object)=''SYSTEM'' '
     +'  and Upper(groupid)='''+localgroup+''' ';
sqlcmd.SQL.Add(tstr);
sqlcmd.Open;
templist:=TStringList.Create;
transmitconfig(templist);
sqlcmd.Active:=false;
overwriteinicfg(cfglist, templist);
templist.Free;
end;
//-----------------------------------------------------------------

{ TPUnitCfg ========================================================= }
constructor TPUnitCfg.Create(cfgobj: string);
var
tstr, localgroup: string;
templist: TStringList;
begin
inherited Create;
cfgobj:=UpperCase(trim(cfgobj));

sqlcmd.SQL.Clear;
tstr:='select name, value from tbconfigdt '
     +'where Upper(object)='''+cfgobj+''' '
     +'  and rtrim(groupid) is null';//注：在该集合中不存在LocalCode.
sqlcmd.SQL.Add(tstr);
sqlcmd.Open;
transmitconfig(cfglist);
sqlcmd.Active:=false;
localgroup:=GetLocalCfgGroup;
sqlcmd.SQL.Clear;
tstr:='select name, value from tbconfigdt '
     +'where Upper(object)='''+cfgobj+''' '
     +'  and Upper(groupid)='''+localgroup+''' ';
sqlcmd.SQL.Add(tstr);
sqlcmd.Open;
templist:=TStringList.Create;
transmitconfig(templist);
sqlcmd.Active:=false;
overwriteinicfg(cfglist, templist);
templist.Free;
end;
//-----------------------------------------------------------------

{ TPIniCfg ========================================================== }
constructor TPIniCfg.Create;
var
inifile: TIniFile;
begin
inherited Create;
//inifile:=TIniFile.Create(securityDM.INI_PATH);  //无论成功与否都可以.
//inifile.ReadSectionValues('LOCAL_MACHINE', cfglist);
//inifile.Free;
end;
//-----------------------------------------------------------------


initialization

	localgroup:='';

end.
