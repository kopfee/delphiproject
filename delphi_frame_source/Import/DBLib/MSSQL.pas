unit MSSQL;

interface

uses windows,msdatatypes;

const
  DBRPCRETURN =1;
  DBRPCDEFAULT=2;
  DBRPCRECOMPILE=1;
  DBRPCRESET    =4;
  DBRPCCURSOR   =8;


  DBSETHOST =1;
  DBSETUSER =2;
  DBSETPWD  =3;
  DBSETAPP  =4;
  DBSETLANG =6;
  DBSETSECURE =7;
  DBVER42   =8;
  DBVER60   =9;
  _DBSETLOGINTIME =10;
  DBSETFALLBACK =12;
  DBNOERR   =-1;
  INT_EXIT  =0;
  INT_CONTINUE=1;
  INT_CANCEL  =2;

  SQLVOID     =$1f;
  SQLTEXT     =$23;
  SQLVARBINARY=$25;
  SQLINTN     =$26;
  SQLVARCHAR  =$27;
  SQLBINARY   =$2d;
  SQLIMAGE    =$22;
  SQLCHAR     =$2f;
  SQLINT1     =$30;
  SQLBIT      =$32;
  SQLINT2     =$34;
  SQLINT4     =$38;
  SQLMONEY    =$3c;
  SQLDATETIME =$3d;
  SQLFLT8     =$3e;
  SQLFLTN     =$6d;
  SQLMONEYN   =$6e;
  SQLDATETIMN =$6f;
  SQLFLT4     =$3b;
  SQLMONEY4   =$7a;
  SQLDATETIM4 =$3a;
  SQLDECIMAL  =$6a;
  SQLNUMERIC  =$6c;

  SUCCEED  =1;
  FAIL  =   0;
  DBUNKNOWN =2;
  SUCCEED_ABORT = 2;
  NO_MORE_RESULTS =2;
  NO_MORE_RPC_RESULTS = 3;

  MORE_ROWS  =  -1;
  NO_MORE_ROWS = -2;
  REG_ROW  = MORE_ROWS;
  BUF_FULL  =  -3;

  // Error numbers (dberrs) DB-Library error codes
 SQLEMEM         =10000;
 SQLENULL        =10001;
 SQLENLOG        =10002;
 SQLEPWD         =10003;
 SQLECONN        =10004;
 SQLEDDNE        =10005;
 SQLENULLO       =10006;
 SQLESMSG        =10007;
 SQLEBTOK        =10008;
 SQLENSPE        =10009;
 SQLEREAD        =10010;
 SQLECNOR        =10011;
 SQLETSIT        =10012;
 SQLEPARM        =10013;
 SQLEAUTN        =10014;
 SQLECOFL        =10015;
 SQLERDCN        =10016;
 SQLEICN         =10017;
 SQLECLOS        =10018;
 SQLENTXT        =10019;
 SQLEDNTI        =10020;
 SQLETMTD        =10021;
 SQLEASEC        =10022;
 SQLENTLL        =10023;
 SQLETIME        =10024;
 SQLEWRIT        =10025;
 SQLEMODE        =10026;
 SQLEOOB         =10027;
 SQLEITIM        =10028;
 SQLEDBPS        =10029;
 SQLEIOPT        =10030;
 SQLEASNL        =10031;
 SQLEASUL        =10032;
 SQLENPRM        =10033;
 SQLEDBOP        =10034;
 SQLENSIP        =10035;
 SQLECNULL       =10036;
 SQLESEOF        =10037;
 SQLERPND        =10038;
 SQLECSYN        =10039;
 SQLENONET       =10040;
 SQLEBTYP        =10041;
 SQLEABNC        =10042;
 SQLEABMT        =10043;
 SQLEABNP        =10044;
 SQLEBNCR        =10045;
 SQLEAAMT        =10046;
 SQLENXID        =10047;
 SQLEIFNB        =10048;
 SQLEKBCO        =10049;
 SQLEBBCI        =10050;
 SQLEKBCI        =10051;
 SQLEBCWE        =10052;
 SQLEBCNN        =10053;
 SQLEBCOR        =10054;
 SQLEBCPI        =10055;
 SQLEBCPN        =10056;
 SQLEBCPB        =10057;
 SQLEVDPT        =10058;
 SQLEBIVI        =10059;
 SQLEBCBC        =10060;
 SQLEBCFO        =10061;
 SQLEBCVH        =10062;
 SQLEBCUO        =10063;
 SQLEBUOE        =10064;
 SQLEBWEF        =10065;
 SQLEBTMT        =10066;
 SQLEBEOF        =10067;
 SQLEBCSI        =10068;
 SQLEPNUL        =10069;
 SQLEBSKERR      =10070;
 SQLEBDIO        =10071;
 SQLEBCNT        =10072;
 SQLEMDBP        =10073;
 SQLINIT         =10074;
 SQLCRSINV       =10075;
 SQLCRSCMD       =10076;
 SQLCRSNOIND     =10077;
 SQLCRSDIS       =10078;
 SQLCRSAGR       =10079;
 SQLCRSORD       =10080;
 SQLCRSMEM       =10081;
 SQLCRSBSKEY     =10082;
 SQLCRSNORES     =10083;
 SQLCRSVIEW      =10084 ;
 SQLCRSBUFR      =10085  ;
 SQLCRSFROWN     =10086 ;
 SQLCRSBROL      =10087 ;
 SQLCRSFRAND     =10088 ;
 SQLCRSFLAST     =10089 ;
 SQLCRSRO        =10090;
 SQLCRSTAB       =10091;
 SQLCRSUPDTAB    =10092;
 SQLCRSUPDNB     =10093;
 SQLCRSVIIND     =10094;
 SQLCRSNOUPD     =10095;
 SQLCRSOS2       =10096;
 SQLEBCSA        =10097;
 SQLEBCRO        =10098;
 SQLEBCNE        =10099;
 SQLEBCSK        =10100;
 SQLEUVBF        =10101;
 SQLEBIHC        =10102;
 SQLEBWFF        =10103;
 SQLNUMVAL       =10104;
 SQLEOLDVR       =10105;
 SQLEBCPS	       =10106;
 SQLEDTC 	       =10107;
 SQLENOTIMPL	   =10108;
 SQLENONFLOAT	   =10109;
 SQLECONNFB      =10110;


// The severity levels are defined here
 EXINFO          =1;  // Informational, non-error
 EXUSER          =2;  // User error
 EXNONFATAL      =3;  // Non-fatal error
 EXCONVERSION    =4;  // Error in DB-LIBRARY data conversion
 EXSERVER        =5;  // The Server has returned an error flag
 EXTIME          =6;  // We have exceeded our timeout period while
                           // waiting for a response from the Server - the
                           // DBPROCESS is still alive
 EXPROGRAM       =7;  // Coding error in user program
 EXRESOURCE      =8;  // Running out of resources - the DBPROCESS may be dead
 EXCOMM          =9;  // Failure in communication with Server - the DBPROCESS is dead
 EXFATAL         =10; // Fatal error - the DBPROCESS is dead
 EXCONSISTENCY   =11; // Internal software error  - notify MS Technical Supprt

  MAXCOLNAMELEN =30;
  MAXTABLENAME  =30;
  MAXNAME       =31;
  
  CI_REGULAR=1;
  CI_ALTERNATE=2;
  CI_CURSOR=3;

type
  LPDBCOL = ^TDBCOL;
  TDBCOL = packed record
	  SizeOfStruct:DBINT ;
	  Name : array[0..MAXCOLNAMELEN] of CHAR  ;
	  ActualName : array[0..MAXCOLNAMELEN] of CHAR  ;
	  TableName : array[0..MAXTABLENAME] of CHAR;
	  _Type : smallint ;  // SHORTInt
	  UserType : DBINT ;
	  MaxLength : DBINT ;
	  Precision : BYTE  ;
	  Scale : BYTE  ;
	  VarLength : BOOL  ;     // TRUE, FALSE
	  _Null : BYTE  ;          // TRUE, FALSE or DBUNKNOWN
	  CaseSensitive : BYTE  ; // TRUE, FALSE or DBUNKNOWN
	  Updatable : BYTE  ;     // TRUE, FALSE or DBUNKNOWN
	  Identity : BOOL  ;      // TRUE, FALSE
  end ;

type
  PDBPROCESS=pointer;
  PLOGINREC=pointer;
  PDBHANDLE=pointer;
  
  dbrec=record
    host:array[0..80] of char;
    lock:boolean;
  end;

  TDBDateTime4 = packed record
    numdays : word;          // Days since Jan 1, 1900
    nummins : word;          // Minutes since midnight
  end;

  TDBDateTime = packed record
    numdays : integer;          // Days since Jan 1, 1900
    nummini : integer;          // 300ths of a second since midnight
  end;

  TDBMoney = packed record
    mhigh : integer;
    mlow  : longword;
  end;


  TDBMoney4 = longint;

  TErrHandleProc =  function (PDBPROCESS:pointer;
                              severity:integer;
                              dberr:integer;
                              oserr:integer;
                              dberrstr:lpcstr;
                              oserrstr:lpcstr):integer;cdecl;

  TMsgHandleProc =  function (dbproc : PDBPROCESS ; msgno :integer; msgstate :integer ;
               severity : integer ; msgtext,srvname,procname : pchar;
					     line : word):integer; cdecl;

function dbinit:lpcstr;cdecl;
function dblogin:pointer;cdecl;
procedure dbfreelogin(pdblogin : pointer); cdecl;
//function dberrhandle(errhandle:farproc):farproc;cdecl;
//function dbmsghandle(msghandle:farproc):farproc;cdecl;
function dberrhandle(errhandle:TErrHandleProc):farproc;cdecl;
function dbmsghandle(msghandle:TMsgHandleProc):farproc;cdecl;
//function dbprocerrhandle(PLOGINREC:pointer;errhandle:farproc):farproc;cdecl;
//function dbprocmsghandle(PLOGINREC:pointer;msghandle:farproc):farproc;cdecl;
function dbprocerrhandle(pdbhandle:pointer;errhandle:TErrHandleProc):farproc;cdecl;
function dbprocmsghandle(pdbhandle:pointer;msghandle:TMsgHandleProc):farproc;cdecl;
function dbsetlname(PLOGINREC:pointer; value:LPCSTR; mode:integer):integer;cdecl;
function dbopen(PLOGINREC:pointer; server:LPCSTR):pointer;cdecl;
function dbdead(PDBPROCESS:pointer):boolean;cdecl;
function dbuse(PDBPROCESS:pointer; data:LPCSTR):integer;cdecl;
function dbcmd(PDBPROCESS:pointer; cmd:LPCSTR):integer;cdecl;
procedure dbexit;cdecl;
function dbsqlexec(PDBPROCESS:pointer):integer;cdecl;
function  dbnumcols(PDBPROCESS:pointer):integer;cdecl;
function  dbcolname(PDBPROCESS:pointer; column : integer):pchar; cdecl;
function  dbcoltype(PDBPROCESS:pointer;col:integer):integer;cdecl;
function  dbcollen(PDBPROCESS:pointer;col:integer):integer;cdecl;
function dbdata(PDBPROCESS:pointer;col:integer):pbyte;cdecl;
function dbprtype(datatype:integer):lpcstr;cdecl;
function dbresults(PDBPROCESS:pointer):integer;cdecl;
function dbnextrow(PDBPROCESS:pointer):integer;cdecl;
procedure dbfreebuf(PDBPROCESS:pointer);cdecl;
function dblastrow(PDBPROCESS:pointer):integer;cdecl;
function dbclose( PDBPROCESS:pointer):integer;cdecl;
function dbconvert(PDBPROCESS:pointer;srctype:integer;src:pbyte;srclen:integer;desttype:integer;dest:pbyte;destlen:integer):integer;cdecl;
function dbdatlen(PDBPROCESS:pointer;col:integer):integer;cdecl;
function dbcanquery(PDBPROCESS:pointer):integer;cdecl;
function dbcancel(PDBPROCESS:pointer):integer;cdecl;
function dbisavail(PDBPROCESS:pointer):boolean;cdecl;
procedure dbsetuserdata(PDBPROCESS:pointer;LPVOID:pointer);cdecl;
function  dbgetuserdata(PDBPROCESS:pointer):pointer;cdecl;
function  dbstrlen(PDBPROCESS:pointer):integer;cdecl;
function  dbstrcpy(PDBPROCESS:pointer;start:integer;numbytes:integer;dest:lpcstr):integer;cdecl;
procedure dbwinexit;cdecl;
function  dbretdata(PDBPROCESS:pointer;retnum:integer):pbyte;cdecl;
function  dbretlen(PDBPROCESS:pointer;retnum:integer):integer;cdecl;
function  dbretname(PDBPROCESS:pointer;retnum:integer):LPCSTR;cdecl;
function  dbretstatus(PDBPROCESS:pointer):integer;cdecl;
function  dbrettype(PDBPROCESS:pointer;retnum:integer):integer;cdecl;
function  dbrpcinit(PDBPROCESS:pointer;rpcname:LPCSTR;options:word):integer;cdecl;
function  dbrpcparam(PDBPROCESS:pointer;paramname:LPCSTR;status:byte;stype:integer;maxlen:integer;datalen:integer;value:pbyte):integer;cdecl;
function  dbrpcsend(PDBPROCESS:pointer):integer;cdecl;
function  dbrpcexec(PDBPROCESS:pointer):integer;cdecl;
function  dbnumrets( PDBPROCESS:pointer):integer;cdecl;
function  dbsettime(seconds:integer):integer;cdecl;
function  dbsetlogintime(seconds:integer):integer;cdecl;

function  dbfcmd (p : PDBPROCESS; s : LPCSTR; i:integer):integer;cdecl;
function  dbcolinfo(pdbhandle:PDBHANDLE ;
            _type : Integer; column,computeid : DBInt; lpdbcol : LPDBCOL):integer; cdecl;

// support compute clause
function  dbnumcompute(dbproc : pointer) : integer;cdecl;
function  dbnumalts(dbproc : pointer;computeid : integer):integer;cdecl;
function dbadlen(dbproc : pointer;computeid : integer;column : integer) : integer; cdecl;
function dbadata(dbproc : pointer;computeid : integer;column : integer) : pointer; cdecl;
function dbaltcolid(dbproc : pointer;computeid : integer;column : integer) : integer; cdecl;
function dbaltlen(dbproc : pointer;computeid : integer;column : integer) : integer; cdecl;
function dbaltop(dbproc : pointer;computeid : integer;column : integer) : integer; cdecl;
function dbalttype(dbproc : pointer;computeid : integer;column : integer) : integer; cdecl;

function  dbrowtype(p:PDBPROCESS):integer; cdecl;
function  dbhasretstat(p:PDBPROCESS):BOOL; cdecl;
function  dbiscount(p:PDBPROCESS):BOOL;cdecl;
function  dbcount(p:PDBPROCESS):DBINT;cdecl;
function  dbsqlok(p:PDBPROCESS):DBINT;cdecl;

// Searches for the names of Microsoft? SQL Servers?locally, over the network, or both.
function  dbserverenum(searchmode:word;
            servnamebuf: pchar;
            sizeservnamebuf : word;
            var numentries : word):integer; cdecl;
const

// Search Mode
  LOC_SEARCH = 1;
  NET_SEARCH = 2;
  BOTH__SEARCH = LOC_SEARCH or NET_SEARCH;

// Search Return
  ENUM_SUCCESS = 0;
  MORE_DATA = 1;
  NET_NOT_AVAIL = 2;
  OUT_OF_MEMORY = 4;
  NOT_SUPPORTED = 8;
  ENUM_INVALID_PARAM = 16;

implementation

const
  DBLibDLL = 'ntwdblib.dll';

function dbinit:lpcstr;cdecl;external DBLibDLL;
function dblogin:pointer;cdecl;external DBLibDLL;
procedure dbfreelogin(pdblogin : pointer); cdecl; external DBLibDLL;
//function dberrhandle(errhandle:farproc):farproc;cdecl;external DBLibDLL;
//function dbmsghandle(msghandle:farproc):farproc;cdecl;external DBLibDLL;
function dberrhandle(errhandle:TErrHandleProc):farproc;cdecl; external DBLibDLL;
function dbmsghandle(msghandle:TMsgHandleProc):farproc;cdecl; external DBLibDLL;
//function dbprocerrhandle(PLOGINREC:pointer;errhandle:farproc):farproc;cdecl;external DBLibDLL;
//function dbprocmsghandle(PLOGINREC:pointer;msghandle:farproc):farproc;cdecl;external DBLibDLL;
function dbprocerrhandle(pdbhandle:pointer;errhandle:TErrHandleProc):farproc;cdecl; external DBLibDLL;
function dbprocmsghandle(pdbhandle:pointer;msghandle:TMsgHandleProc):farproc;cdecl; external DBLibDLL;
function dbsetlname(PLOGINREC:pointer; value:LPCSTR; mode:integer):integer;cdecl;external DBLibDLL;
function dbopen(PLOGINREC:pointer; server:LPCSTR):pointer;cdecl;external DBLibDLL;
function dbdead(PDBPROCESS:pointer):boolean;cdecl;external DBLibDLL;
function dbuse(PDBPROCESS:pointer; data:LPCSTR):integer;cdecl;external DBLibDLL;
function dbcmd(PDBPROCESS:pointer; cmd:LPCSTR):integer;cdecl;external DBLibDLL;
procedure dbexit;cdecl;external DBLibDLL;
function dbsqlexec(PDBPROCESS:pointer):integer;cdecl;external DBLibDLL;
function  dbnumcols(PDBPROCESS:pointer):integer;cdecl; external DBLibDLL;
function  dbcolname (PDBPROCESS:pointer; column : integer):pchar; cdecl; external DBLibDLL;
function dbcoltype(PDBPROCESS:pointer;col:integer):integer;cdecl;external DBLibDLL;
function  dbcollen(PDBPROCESS:pointer;col:integer):integer;cdecl;external DBLibDLL;
function dbdata(PDBPROCESS:pointer;col:integer):pbyte;cdecl;external DBLibDLL;

function dbprtype(datatype:integer):lpcstr;cdecl;external DBLibDLL;
function dbresults(PDBPROCESS:pointer):integer;cdecl;external DBLibDLL;
function dbnextrow(PDBPROCESS:pointer):integer;cdecl;external DBLibDLL;
procedure dbfreebuf(PDBPROCESS:pointer);cdecl;external DBLibDLL;
function dblastrow(PDBPROCESS:pointer):integer;cdecl;external DBLibDLL;
function dbclose( PDBPROCESS:pointer):integer;cdecl;external DBLibDLL;
function dbconvert(PDBPROCESS:pointer;srctype:integer;src:pbyte;srclen:integer;desttype:integer;dest:pbyte;destlen:integer):integer;cdecl;external DBLibDLL;
function dbdatlen(PDBPROCESS:pointer;col:integer):integer;cdecl;external DBLibDLL;
function dbcanquery(PDBPROCESS:pointer):integer;cdecl;external DBLibDLL;
function dbcancel(PDBPROCESS:pointer):integer;cdecl;external DBLibDLL;
function dbisavail(PDBPROCESS:pointer):boolean;cdecl;external DBLibDLL;
procedure dbsetuserdata(PDBPROCESS:pointer;LPVOID:pointer);cdecl;external DBLibDLL;
function  dbgetuserdata(PDBPROCESS:pointer):pointer;cdecl;external DBLibDLL;
function  dbstrlen(PDBPROCESS:pointer):integer;cdecl;external DBLibDLL;
function  dbstrcpy(PDBPROCESS:pointer;start:integer;numbytes:integer;dest:lpcstr):integer;cdecl;external DBLibDLL;
procedure dbwinexit;cdecl;external DBLibDLL;
function  dbretdata(PDBPROCESS:pointer;retnum:integer):pbyte;cdecl;external DBLibDLL;
function  dbretlen(PDBPROCESS:pointer;retnum:integer):integer;cdecl;external DBLibDLL;
function  dbretname(PDBPROCESS:pointer;retnum:integer):LPCSTR;cdecl;external DBLibDLL;
function  dbretstatus(PDBPROCESS:pointer):integer;cdecl;external DBLibDLL;
function  dbrettype(PDBPROCESS:pointer;retnum:integer):integer;cdecl;external DBLibDLL;
function  dbrpcinit(PDBPROCESS:pointer;rpcname:LPCSTR;options:word):integer;cdecl;external DBLibDLL;
function  dbrpcparam(PDBPROCESS:pointer;paramname:LPCSTR;status:byte;stype:integer;maxlen:integer;datalen:integer;value:pbyte):integer;cdecl;external DBLibDLL;
function  dbrpcsend(PDBPROCESS:pointer):integer;cdecl;external DBLibDLL;
function  dbrpcexec(PDBPROCESS:pointer):integer;cdecl;external DBLibDLL;
function  dbnumrets( PDBPROCESS:pointer):integer;cdecl;external DBLibDLL;
function  dbsettime(seconds:integer):integer;cdecl;external DBLibDLL;
function  dbsetlogintime(seconds:integer):integer;cdecl;external DBLibDLL;

// support compute clause
function  dbnumcompute(dbproc : pointer) : integer;cdecl; external DBLibDLL;
function  dbnumalts(dbproc : pointer;computeid : integer):integer;cdecl; external DBLibDLL;
function dbadlen(dbproc : pointer;computeid : integer;column : integer) : integer; cdecl;external DBLibDLL;
function dbadata(dbproc : pointer;computeid : integer;column : integer) : pointer; cdecl;external DBLibDLL;
function dbaltcolid(dbproc : pointer;computeid : integer;column : integer) : integer; cdecl;external DBLibDLL;
function dbaltlen(dbproc : pointer;computeid : integer;column : integer) : integer; cdecl;external DBLibDLL;
function dbaltop(dbproc : pointer;computeid : integer;column : integer) : integer; cdecl;external DBLibDLL;
function dbalttype(dbproc : pointer;computeid : integer;column : integer) : integer; cdecl;external DBLibDLL;

function  dbfcmd (p : PDBPROCESS; s : LPCSTR; i:integer):integer;cdecl; external DBLibDLL;
function  dbcolinfo(pdbhandle:PDBHANDLE ;
            _type : Integer; column,computeid : DBInt; lpdbcol : LPDBCOL):integer; cdecl; external DBLibDLL;

function  dbrowtype(p:PDBPROCESS):integer; cdecl; external DBLibDLL;
function  dbhasretstat(p:PDBPROCESS):BOOL; cdecl; external DBLibDLL;
function  dbiscount(p:PDBPROCESS):BOOL;cdecl;external DBLibDLL;
function  dbcount(p:PDBPROCESS):DBINT;cdecl;external DBLibDLL;
function  dbsqlok(p:PDBPROCESS):DBINT;cdecl;external DBLibDLL;

function  dbserverenum(searchmode:word;
            servnamebuf: pchar;
            sizeservnamebuf : word;
            var numentries : word):integer; cdecl;external DBLibDLL;

end.
