unit PStaffEdit;
//原则：存在的域内容必然是正确的。
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs,
  stdctrls, dbtables;

const
  PREFIXCODEWIDTH = 2;
  ERNCODEWIDTH = 4;

type
  TPStaffEdit = class(TCustomControl)
  private
    FPrefixEdit: TEdit;//前缀框的内容要么为'', 要么为合法(齐长)的代码
    FErnEdit: TEdit;
    FNameEdit: TEdit;
    DBQuery: TQuery;

    FAutoCheck: boolean;//是否在onexit时自动进行格式化并进行合法检查
    FMustExist: boolean;//合法检查时是否要求当前ERN已存在
    FSynchroSearch: boolean;//是否在OnChange时自动侦测prefix和name域

    procedure linkevents;
    procedure unlinkevents;
    procedure checkwidth(width: integer);
    procedure settlewidth;//在三段子长度确定的情况下整理构件长度
    function getmatchingprefix: boolean;
    function getmatchinginfo: boolean;

    procedure ErnOnChange(Sender: TObject);
    procedure ErnOnExit(Sender: TObject);

    function getdatabasename: string;
    procedure putdatabasename(alias: string);
    function getprefixwidth: integer;
    procedure putprefixwidth(width: integer);
    function geternwidth: integer;
    procedure puternwidth(width: integer);
    function getnamewidth: integer;
    procedure putnamewidth(width: integer);
    function getprefix: string;
    function getern: string;
    procedure putern(ern: string);
    function getstaffname: string;
    function getreadonly: boolean;
    function getfont: TFont;
    procedure putfont(fvalue: TFont);
    procedure putreadonly(bvalue: boolean);
    function getinnerern: string;
    procedure putinnerern(innerern: string);
    procedure putsynchrosearch(bvalue: boolean);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetFocus; override;
    function checkstate: integer;//手工合法性检查函数：
               //-1:值空；0-成功；1-ERN标识不合法；2-ERN不存在于库中
    procedure validcheck;//全权处理式的合法检查
  published
    property Enabled;

    property DatabaseName: string
             read getdatabasename write putdatabasename;
    property PrefixWidth: integer
             read getprefixwidth write putprefixwidth default 21;
    property ErnWidth: integer
             read geternwidth write puternwidth default 37;
    property NameWidth: integer
             read getnamewidth write putnamewidth default 65;
    property Prefix: string read getprefix;
    property Ern: string read getern write putern;
    property StaffName: string read getstaffname;
    property Font: TFont read getfont write putfont;
    property ReadOnly: boolean read getreadonly write putreadonly;
    property AutoCheck: boolean read FAutoCheck write FAutoCheck;
    property MustExist: boolean read FMustExist write FMustExist;
    property InnerErn: string read getinnerern write putinnerern;
    property SynchroSearch: boolean
             read FSynchroSearch write putsynchrosearch;
    property TabOrder;
  end;

function formatern(var ern: string): boolean;

procedure Register;

implementation

uses base_delphi_utils, c_showmessage_util;
//=================================================================
function formatern(var ern: string): boolean;
begin
result:=identifilize(ern, ERNCODEWIDTH);
if result then ern:=UpperCase(ern);
end;
//=================================================================
function TPStaffEdit.checkstate: integer;//手工合法性检查函数：
var  // -1:值空；0-成功；1-ERN标识不合法；2-ERN不存在于库中
tstr: string;
tempbool: boolean;
begin
result:=0;
tstr:=trim(FErnEdit.Text);
if (tstr='') then  //判是否空值
  begin
    result:=-1;
    exit;
  end;
tempbool:=formatern(tstr);  //判格式是否合法
if not(tempbool) then
  begin
    result:=1;
    exit;
  end;
FErnEdit.Text:=tstr;
tempbool:=getmatchinginfo;  //判相应工号是否已存在
//此处曾将函数直接置于if句内，但发现步进流程会跳过result:=2达到exit;
//可能存在内部优化。
if not(tempbool) then
  begin
    result:=2;
    exit;
  end;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.checkwidth(width: integer);
begin
if (width<0) then
  begin
    showmessage('Width can''t be less than zero.');
    abort;
  end;
end;
//-----------------------------------------------------------------
constructor TPStaffEdit.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     FPrefixEdit:=TEdit.Create(Self);
     FPrefixEdit.Parent:=Self;
     FPrefixEdit.TabStop:=false;
     FErnEdit:=TEdit.Create(Self);
     FErnEdit.Parent:=Self;
     FNameEdit:=TEdit.Create(Self);
     FNameEdit.Parent:=Self;
     FNameEdit.TabStop:=false;
     DBQuery:=TQuery.Create(Self);

     PrefixWidth:=21;
     ErnWidth:=37;
     NameWidth:=65;
     (inherited Font).Size:= 9;
     Height:=24;
//自定义构件Font.Size的确可随Parent变化但大小不变，故还不如先行固定。

FPrefixEdit.Color:=clSilver;
FPrefixEdit.ReadOnly:=true;
FErnEdit.MaxLength:=ERNCODEWIDTH;
FNameEdit.Color:=clSilver;
FNameEdit.ReadOnly:=true;
//color for ernedit needed ?
linkevents;
end;
//-----------------------------------------------------------------
destructor TPStaffEdit.Destroy;
begin
FPrefixEdit.Free;
FErnEdit.Free;
FNameEdit.Free;
DBQuery.Free;
inherited Destroy;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.ErnOnChange(Sender: TObject);
begin
if (FErnEdit.Modified) then
  begin
    FPrefixEdit.Text:='';
    FNameEdit.Text:='';
    if (FSynchroSearch) then  getmatchinginfo;
  end;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.ErnOnExit(Sender: TObject);
begin
if (FAutoCheck) then  validcheck;
end;
//-----------------------------------------------------------------
function TPStaffEdit.getdatabasename: string;
begin
result:=DBQuery.DatabaseName;
end;
//-----------------------------------------------------------------
function TPStaffEdit.getern: string;
begin
result:=FErnEdit.Text;
end;
//-----------------------------------------------------------------
function TPStaffEdit.geternwidth: integer;
begin
result:=FErnEdit.Width;
end;
//-----------------------------------------------------------------
function TPStaffEdit.getfont: TFont;
begin
result:=(inherited Font);
end;
//-----------------------------------------------------------------
function TPStaffEdit.getinnerern: string;
begin
if (FPrefixEdit.Text='') then  result:=''
else  result:=FPrefixEdit.Text+FErnEdit.Text;
      //根据“原则”，存在必定合理
end;
//-----------------------------------------------------------------
function TPStaffEdit.getmatchinginfo: boolean;
//考虑可能发生在用户交互期间，只能暗中进行试探性格式化，不能影响ErnEdit
//的内容。
var
tstr: string;
begin
FNameEdit.Text:='';
if (FPrefixEdit.Text='') then getmatchingprefix;
result:=(FPrefixEdit.Text<>'');//前缀是否存在即唯一决定当前ERN是否存在
if result then  //看是否真实Staff而非虚拟员工，尽量找到NAME。
  begin
    DBQuery.Active:=false;
    DBQuery.SQL.Clear;
    tstr:='select cname from tbstaff '
         +'where Upper(ern)='''+InnerErn+''' ';
    DBQuery.SQL.Add(tstr);
    DBQuery.Open;
    if (DBQuery.RecordCount=1) then
      begin
        FNameEdit.Text:=DBQuery.fieldbyname('cname').asstring;
      end
    else if (DBQuery.RecordCount>1) then
      begin
        showmessage('TPStaffEdit.getmatchinginfo:'+#13
                   +'confusing InnerErn['+InnerErn+'].');
        abort;
      end;
    DBQuery.Active:=false;
  end;
end;
//-----------------------------------------------------------------
function TPStaffEdit.getmatchingprefix: boolean;
//考虑可能发生在用户交互期间，只能暗中进行试探性格式化，不能影响ErnEdit
//的内容。
var
tempern, tstr: string;
begin
result:=false;
FPrefixEdit.Text:='';
tempern:=trim(FErnEdit.Text);
if (tempern='') then  exit;
if formatern(tempern) then
  begin
    DBQuery.Active:=false;
    DBQuery.SQL.Clear;
    tstr:='select prefix=substring(ern, 1, '+inttostr(PREFIXCODEWIDTH)+') '
         +'from tbstaff '
         +'where upper(stuff(ern, 1, '+inttostr(PREFIXCODEWIDTH)+', ''-''))=''-'+tempern+''' '
         +'  and deletetag=0';
    DBQuery.SQL.Add(tstr);
    DBQuery.Open;
    if (DBQuery.RecordCount=0) then  //进一步检查是否虚拟员工
      begin
        DBQuery.Active:=false;
        DBQuery.SQL.Clear;
        tstr:='select prefix=substring(ern, 1, '+inttostr(PREFIXCODEWIDTH)+') '
             +'from securityinfo '
             +'where upper(stuff(ern, 1, '+inttostr(PREFIXCODEWIDTH)
             +', ''-''))=''-'+tempern+''' ';
        DBQuery.SQL.Add(tstr);
        DBQuery.Open;
      end;
    if (DBQuery.RecordCount>0) then
      begin
        result:=true;
        FPrefixEdit.Text:=DBQuery.fieldbyname('prefix').asstring;
      end;
    DBQuery.Active:=false;
  end;
end;
//-----------------------------------------------------------------
function TPStaffEdit.getstaffname: string;
begin
result:=FNameEdit.Text;
end;
//-----------------------------------------------------------------
function TPStaffEdit.getnamewidth: integer;
begin
result:=FNameEdit.Width;
end;
//-----------------------------------------------------------------
function TPStaffEdit.getprefix: string;
begin
result:=FPrefixEdit.Text;
end;
//-----------------------------------------------------------------
function TPStaffEdit.getprefixwidth: integer;
begin
result:=FPrefixEdit.Width;
end;
//-----------------------------------------------------------------
function TPStaffEdit.getreadonly: boolean;
begin
result:=FErnEdit.ReadOnly;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.linkevents;
begin
FErnEdit.OnChange:=ErnOnChange;
FErnEdit.OnExit:=ErnOnExit;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.Paint;
begin
FPrefixEdit.Height:=Height;
FErnEdit.Height:=Height;
FNameEdit.Height:=Height;
FNameEdit.Width:=Width-FPrefixEdit.Width-FErnEdit.Width+2;
inherited Paint;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.putdatabasename(alias: string);
begin
DBQuery.Active:=false;
DBQuery.DatabaseName:=alias;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.putern(ern: string);
begin
FErnEdit.Text:=ern;//等价于交互输入，由OnChange负责处理相应事务。
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.puternwidth(width: integer);
begin
checkwidth(width);
FErnEdit.Width:=width;
settlewidth;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.putfont(fvalue: TFont);
begin
(inherited Font).Assign(fvalue);
Height:=FErnEdit.Height;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.putinnerern(innerern: string);
var  //本函数不得利用OnChange来进行自动匹配(因为机制执行序列不同)
tmpprefix, tmpname: string;
tempbool: boolean;
len: integer;
begin
innerern:=trim(innerern);
len:=Length(innerern);
if (len=0) then
  begin
    tmpprefix:='';
    tmpname:='';
  end
else if (len<=PREFIXCODEWIDTH) then
  begin
    showmessage('TPStaffEdit.putinnerern:'+#13
               +'invalid InnerErn['+innerern+'], ERN may be NULL.');
    abort;
  end
else
  begin
    tmpprefix:=Copy(innerern, 1, PREFIXCODEWIDTH);
    tempbool:=nformat(tmpprefix, PREFIXCODEWIDTH);
    if not(tempbool) then
      begin
        showmessage('TPStaffEdit.putinnerern:'+#13+innerern
                   +'''s prefix is invalid.');
        abort;
      end;
    tmpname:=
      UpperCase(Copy(innerern, PREFIXCODEWIDTH+1, len-PREFIXCODEWIDTH));
  end;

unlinkevents;
FPrefixEdit.Text:=tmpprefix;
FErnEdit.Text:=tmpname;
FNameEdit.Text:='';
if (FSynchroSearch) then getmatchinginfo;
linkevents;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.putnamewidth(width: integer);
begin
checkwidth(width);
FNameEdit.Width:=width;
settlewidth;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.putprefixwidth(width: integer);
begin
checkwidth(width);
FPrefixEdit.Width:=width;
settlewidth;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.putreadonly(bvalue: boolean);
begin
FErnEdit.ReadOnly:=bvalue;
if bvalue then  FErnEdit.Color:=clSilver
else  FErnEdit.Color:=clWhite;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.putsynchrosearch(bvalue: boolean);
begin
FSynchroSearch:=bvalue;
if (bvalue)and(FNameEdit.Text='') then  getmatchinginfo;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.SetFocus;
begin
FErnEdit.SetFocus; 
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.settlewidth;
begin
FErnEdit.Left:=FPrefixEdit.Left+FPrefixEdit.Width-1;
FNameEdit.Left:=FErnEdit.Left+FErnEdit.Width-1;
Width:=FNameEdit.Left+FNameEdit.Width;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.unlinkevents;
begin
FErnEdit.OnChange:=nil;
FErnEdit.OnExit:=nil;
end;
//-----------------------------------------------------------------
procedure TPStaffEdit.validcheck;//全权处理式的合法检查
var
i: integer;
begin
i:=checkstate;
case i of
  -1: ;
  0: ;
  2: if (FMustExist) then
       begin
         c_showmessage('未在库中搜索到当前输入工号的记录，请检查');
         abort;
       end;
else begin
         c_showmessage('当前输入工号无效，请检查');
         abort;
     end;
end;  // of case
end;
//=================================================================
procedure Register;
begin
  RegisterComponents('Samples', [TPStaffEdit]);
end;

end.
