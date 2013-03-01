unit dblib;

interface
uses windows,SysUtils,Dialogs;
const
    DBRPCRETURN =1;
    DBRPCDEFAULT=2;
    DBRPCRECOMPILE=1;
    DBRPCRESET    =4;
    DBRPCCURSOR   =8;
    NO_MORE_RPC_RESULTS = 3;
    DBVER60=    9;

    DBSETHOST =1;
    DBSETUSER =2;
    DBSETPWD  =3;
    DBSETAPP  =4;
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
    NO_MORE_ROWS =-2;
    NO_MORE_RESULTS =2;

type
    ESQLERROR=class(Exception);
    dbrec=record
       host:array[0..80] of char;
       lock:boolean;
    end;
    tdblib = class
    public
         login:pointer;
         dbproc:pointer;
         newresult:boolean;
         cmdstring:string;
         dbeof:boolean;
         dbrecdata:dbrec;
         lserver,luser,ldata,lpass,lhost:string;
         function sqllogin:boolean;
         function sqlconnect(server,user,data,pass,host:string):boolean;
         procedure sqlclose;
         function  sqlcmd(cmd:string):boolean;
         function  sqladd(cmd:string):boolean;
         function  eof:integer;
         function  sqldata(colin:integer):string;
         function  sqlopen:boolean;
         function  sqlexec:boolean;
         function  sqloutdata(colin:integer):string;
         function  sqlretdata:integer;
         function  sqlnumrets:integer;
         procedure processcmd(cmd:string);
         procedure processopen;
         procedure processpara(paramname:string;status:integer;stype:integer;maxlen:integer;datalen:integer;value:pbyte);
         procedure next;
    end;

    function errhandle(PDBPROCESS:pointer;severity:integer;dberr:integer;oserr:integer;dberrstr:lpcstr;oserrstr:lpcstr):integer;cdecl;
    function msghandle(PDBPROCESS:pointer;msgno:integer;msgstate:integer;severity:integer;msgtext:lpcstr):integer;cdecl;
    function dbinit:lpcstr;far;external 'ntwdblib.dll';
    function dblogin:pointer;far;external 'ntwdblib.dll';
    function dberrhandle(errhandle:farproc):farproc;cdecl;external 'ntwdblib.dll';
    function dbmsghandle(msghandle:farproc):farproc;cdecl;external 'ntwdblib.dll';
    function dbprocerrhandle(PLOGINREC:pointer;errhandle:farproc):farproc;cdecl;external 'ntwdblib.dll';
    function dbprocmsghandle(PLOGINREC:pointer;msghandle:farproc):farproc;cdecl;external 'ntwdblib.dll';
    function dbsetlname(PLOGINREC:pointer; value:LPCSTR; mode:integer):integer;cdecl;external 'ntwdblib.dll';
    function dbopen(PLOGINREC:pointer; server:LPCSTR):pointer;cdecl;external 'ntwdblib.dll';
    function dbdead(PDBPROCESS:pointer):boolean;cdecl;external 'ntwdblib.dll';
    function dbuse(PDBPROCESS:pointer; data:LPCSTR):integer;cdecl;external 'ntwdblib.dll';
    function dbcmd(PDBPROCESS:pointer; cmd:LPCSTR):integer;cdecl;external 'ntwdblib.dll';
    procedure dbexit;cdecl;external 'ntwdblib.dll';
    function dbsqlexec(PDBPROCESS:pointer):integer;cdecl;external 'ntwdblib.dll';
    function dbcoltype(PDBPROCESS:pointer;col:integer):integer;cdecl;external 'ntwdblib.dll';
    function dbdata(PDBPROCESS:pointer;col:integer):pbyte;cdecl;external 'ntwdblib.dll';
    function dbprtype(datatype:integer):lpcstr;cdecl;external 'ntwdblib.dll';
    function dbresults(PDBPROCESS:pointer):integer;cdecl;external 'ntwdblib.dll';
    function dbnextrow(PDBPROCESS:pointer):integer;cdecl;external 'ntwdblib.dll';
    procedure dbfreebuf(PDBPROCESS:pointer);cdecl;external 'ntwdblib.dll';
    function dblastrow(PDBPROCESS:pointer):integer;cdecl;external 'ntwdblib.dll';
    function dbclose( PDBPROCESS:pointer):integer;cdecl;external 'ntwdblib.dll';
    function dbconvert(PDBPROCESS:pointer;srctype:integer;src:pbyte;srclen:integer;desttype:integer;dest:pbyte;destlen:integer):integer;cdecl;external 'ntwdblib.dll';
    function dbdatlen(PDBPROCESS:pointer;col:integer):integer;cdecl;external 'ntwdblib.dll';
    function dbcanquery(PDBPROCESS:pointer):integer;cdecl;external 'ntwdblib.dll';
    function dbcancel(PDBPROCESS:pointer):integer;cdecl;external 'ntwdblib.dll';
    function dbisavail(PDBPROCESS:pointer):boolean;cdecl;external 'ntwdblib.dll';
    procedure dbsetuserdata(PDBPROCESS:pointer;LPVOID:pointer);cdecl;external 'ntwdblib.dll';
    function  dbgetuserdata(PDBPROCESS:pointer):pointer;cdecl;external 'ntwdblib.dll';
    function  dbstrlen(PDBPROCESS:pointer):integer;cdecl;external 'ntwdblib.dll';
    function  dbstrcpy(PDBPROCESS:pointer;start:integer;numbytes:integer;dest:lpcstr):integer;cdecl;external 'ntwdblib.dll';
    procedure dbwinexit;cdecl;external 'ntwdblib.dll';
    function  dbretdata(PDBPROCESS:pointer;retnum:integer):pbyte;cdecl;external 'ntwdblib.dll';
    function  dbretlen(PDBPROCESS:pointer;retnum:integer):integer;cdecl;external 'ntwdblib.dll';
    function  dbretname(PDBPROCESS:pointer;retnum:integer):LPCSTR;cdecl;external 'ntwdblib.dll';
    function  dbretstatus(PDBPROCESS:pointer):integer;cdecl;external 'ntwdblib.dll';
    function  dbrettype(PDBPROCESS:pointer;retnum:integer):integer;cdecl;external 'ntwdblib.dll';
    function  dbrpcinit(PDBPROCESS:pointer;rpcname:LPCSTR;options:word):integer;cdecl;external 'ntwdblib.dll';
    function  dbrpcparam(PDBPROCESS:pointer;paramname:LPCSTR;status:byte;stype:integer;maxlen:integer;datalen:integer;value:pbyte):integer;cdecl;external 'ntwdblib.dll';
    function  dbrpcsend(PDBPROCESS:pointer):integer;cdecl;external 'ntwdblib.dll';
    function  dbrpcexec(PDBPROCESS:pointer):integer;cdecl;external 'ntwdblib.dll';
    function  dbnumrets( PDBPROCESS:pointer):integer;cdecl;external 'ntwdblib.dll';
    function  dbsettime(seconds:integer):integer;cdecl;external 'ntwdblib.dll';
    function  dbsetlogintime(seconds:integer):integer;cdecl;external 'ntwdblib.dll';

implementation

uses spx_main,ustru;

function errhandle(PDBPROCESS:pointer;severity:integer;dberr:integer;oserr:integer;dberrstr:lpcstr;oserrstr:lpcstr):integer;
var s:string;
    host:string;
    cmdlen:integer;
    cmdbuf:array[0..1024] of char;
begin
    if ((PDBPROCESS = nil) or (DBDEAD(PDBPROCESS))) then
    begin
	result:=INT_CANCEL;
        main_form.logmess(LOGT_MESSAGE,0,'与数据库的连接断开');
        exit;
    end;
    result:=INT_CANCEL;
    host:=dbrec(dbgetuserdata(PDBPROCESS)^).host;
    cmdlen:=dbstrlen(PDBPROCESS);
    dbstrcpy(PDBPROCESS,0,cmdlen+2,cmdbuf);
    s:=strpas(cmdbuf);
    main_form.logmess(LOGT_MESSAGE,0,s);
    s:=format('DB-LIBRARY error:%s', [dberrstr]);
    main_form.logmess(LOGT_MESSAGE,0,s);
    if (oserr <> DBNOERR) then
    begin
	s:=format('Operating-system error:%s', [oserrstr]);
        main_form.logmess(LOGT_MESSAGE,0,s);
    end;
end;

function msghandle(PDBPROCESS:pointer;msgno:integer;msgstate:integer;severity:integer;msgtext:lpcstr):integer;
var s:string;
    host:string;
    cmdlen:integer;
    cmdbuf:array[0..1024] of char;
begin
    if (msgno <> 5701) then
    begin
        host:=dbrec(dbgetuserdata(PDBPROCESS)^).host;
        cmdlen:=dbstrlen(PDBPROCESS);
        dbstrcpy(PDBPROCESS,0,cmdlen+2,cmdbuf);
        s:=strpas(cmdbuf);
        main_form.logmess(LOGT_MESSAGE,0,s);
        s:=format('SQL Server message %d, state %d, severity %d:%s',
	   [msgno, msgstate, severity, string(msgtext)]);
        main_form.logmess(LOGT_MESSAGE,0,s);
        if msgno = 1205 then
        begin
            result:=INT_CANCEL;
            dbclose(PDBPROCESS);
            exit;
        end;
    end;
    result:=0;
end;

function tdblib.sqllogin:boolean;
begin
    login:=dblogin;
end;

procedure tdblib.processcmd(cmd:string);
var sqlerror:esqlerror;
begin
    if dbproc <> nil then
    begin
        dbcanquery(dbproc);
        dbcancel(dbproc);
        dbfreebuf(dbproc);
        if dbrpcinit(dbproc,pchar(cmd),DBRPCRESET) = 0 then
        begin
            dbclose(dbproc);
            dbproc:=nil;
            sqlerror:=esqlerror.Create('SQLERROR');
            raise sqlerror;
            exit;
        end;
    end
    else
    begin
        sqlconnect(lserver,luser,ldata,lpass,lhost);
        if dbproc = nil then
        begin
            sqlerror:=esqlerror.Create('SQLERROR');
            raise sqlerror;
            exit;
        end;
        sqlerror:=esqlerror.create('SQLERROR');
        raise sqlerror;
    end;
end;

procedure tdblib.processopen;
var sqlerror:esqlerror;
begin
    if dbrpcexec(dbproc) = 0 then
    begin
        sqlerror:=esqlerror.Create('SQLERROR');
        raise sqlerror;
        exit;
    end;
    newresult:=true;
    next;
end;

function tdblib.sqlnumrets:integer;
begin
    result:=dbnumrets(dbproc);
end;

procedure tdblib.processpara(paramname:string;status:integer;stype:integer;maxlen:integer;datalen:integer;value:pbyte);
var sqlerror:esqlerror;
begin
    if dbrpcparam(dbproc,pchar(paramname),status,stype,maxlen,datalen,value)=0 then
    begin
        sqlerror:=esqlerror.Create('SQLERROR');
        raise sqlerror;
    end;
end;

function tdblib.sqlretdata:integer;
begin
    result:=dbretstatus(dbproc);
end;

function tdblib.sqlconnect(server,user,data,pass,host:string):boolean;
var sqlerror:esqlerror;
begin
    lserver:=server;
    luser:=user;
    ldata:=data;
    lpass:=pass;
    lhost:=host;
    dbsetlname(login,pchar(user),DBSETUSER);
    dbsetlname(login,pchar(pass),DBSETPWD);
    dbsetlname(login,pchar(host),DBSETHOST);
    dbsetlname(login,nil,DBVER60);

    dbproc:=dbopen(login,pchar(server));
    if dbproc = nil then
    begin
        result:=false;
        sqlerror:=esqlerror.Create('SQLERROR');
        raise sqlerror;
        exit;
    end
    else
    begin
        dbuse(dbproc,pchar(data));
        strpcopy(dbrecdata.host,host);
        dbsetuserdata(dbproc,@dbrecdata);
        result:=true;
    end;
end;

procedure tdblib.sqlclose;
begin
    dbclose(dbproc);
end;

function  tdblib.sqlcmd(cmd:string):boolean;
var sqlerror:esqlerror;
begin
    if dbproc <> nil then
    begin
        dbcanquery(dbproc);
        dbcancel(dbproc);
        dbfreebuf(dbproc);
        if dbcmd(dbproc,pchar(cmd)) = 0 then
        begin
            dbclose(dbproc);
            dbproc:=nil;
            sqlerror:=esqlerror.create('SQLERROR');
            raise sqlerror;
            exit;
        end;
        cmdstring:=cmd;
    end
    else
    begin
        sqlconnect(lserver,luser,ldata,lpass,lhost);
        if dbproc = nil then
        begin
            sqlerror:=esqlerror.create('SQLERROR');
            raise sqlerror;
            exit;
        end;
        sqlerror:=esqlerror.create('SQLERROR');
        raise sqlerror;
    end;
end;

function  tdblib.sqladd(cmd:string):boolean;
begin
    dbcmd(dbproc,pchar(cmd));
    cmdstring:=cmdstring+cmd;
end;

function  tdblib.eof:integer;
begin
    if dbeof = true then
    begin
       result:=1;
    end
    else
    begin
       result:=0;
    end;
end;

function  tdblib.sqldata(colin:integer):string;
var dest:pbyte;
    ds:array [0..512] of char;
    dfest:pbyte;
    fds:array[0..64] of char;
    i:integer;
    s:string;
    ctype:integer;
    col:integer;
begin
    col:=colin+1;
    dest:=@ds;
    dfest:=@fds;
    ctype:=dbcoltype(dbproc,col);
    if ((ctype = SQLMONEYN) or (ctype = SQLMONEY) or (ctype = SQLMONEY4)) then
    begin
        i:=dbconvert(dbproc,ctype,dbdata(dbproc,col),dbdatlen(dbproc,col),SQLFLT8,dfest,80);
        i:=dbconvert(dbproc,SQLFLT8,dfest,i,SQLCHAR,dest,80);
    end
    else
    begin
        i:=dbconvert(dbproc,ctype,dbdata(dbproc,col),dbdatlen(dbproc,col),SQLCHAR,dest,80);
    end;
    ds[i]:=char(0);
    if ((ctype = SQLMONEYN) or (ctype = SQLMONEY) or (ctype = SQLMONEY4) or (ctype = SQLFLTN) or (ctype = SQLFLT8)) then
    begin
        s:=trim(strpas(ds));
        if s = '' then
        begin
            result:='0.00';
        end
        else
        begin
            result:=s;
        end;
    end
    else
    begin
        if (i > 1) then
        begin
            result:=trim(strpas(ds));
        end
        else
        begin
            result:=strpas(ds);
        end;
    end;
end;

function  tdblib.sqloutdata(colin:integer):string;
var dest:pbyte;
    ds:array [0..512] of char;
    dfest:pbyte;
    fds:array[0..64] of char;
    i:integer;
    s:string;
    ctype:integer;
    col:integer;
begin
    col:=colin+1;
    dest:=@ds;
    dfest:=@fds;
    ctype:=dbrettype(dbproc,col);
    if ((ctype = SQLMONEYN) or (ctype = SQLMONEY) or (ctype = SQLMONEY4)) then
    begin
        i:=dbconvert(dbproc,ctype,dbretdata(dbproc,col),dbretlen(dbproc,col),SQLFLT8,dfest,80);
        i:=dbconvert(dbproc,SQLFLT8,dfest,i,SQLCHAR,dest,80);
    end
    else
    begin
        i:=dbconvert(dbproc,ctype,dbretdata(dbproc,col),dbretlen(dbproc,col),SQLCHAR,dest,80);
    end;
    ds[i]:=char(0);
    if ((ctype = SQLMONEYN) or (ctype = SQLMONEY) or (ctype = SQLMONEY4) or (ctype = SQLFLTN) or (ctype = SQLFLT8)) then
    begin
        s:=trim(strpas(ds));
        if s = '' then
        begin
            result:='0.00';
        end
        else
        begin
            result:=s;
        end;
    end
    else
    begin
        if (i > 1) then
        begin
            result:=trim(strpas(ds));
        end
        else
        begin
            result:=strpas(ds);
        end;
    end;
end;

function  tdblib.sqlopen:boolean;
var sqlerror:esqlerror;
begin
    if dbsqlexec(dbproc) = 0 then
    begin
        sqlerror:=esqlerror.Create('SQLERROR');
        raise sqlerror;
        newresult:=true;
        exit;
    end;
    newresult:=true;
    next;
end;

function  tdblib.sqlexec:boolean;
var sqlerror:esqlerror;
begin
    if dbsqlexec(dbproc) = 0 then
    begin
        sqlerror:=esqlerror.Create('SQLERROR');
        raise sqlerror;
    end;
    newresult:=true;
end;

procedure tdblib.next;
label start;
var retcode:integer;
    sqlerror:esqlerror;
begin
     start:
     if newresult = true then
     begin
         newresult:=false;
         retcode:=dbresults(dbproc);
         if retcode = 0 then
         begin
             sqlerror:=esqlerror.Create('SQLERROR');
             raise sqlerror;
             exit;
         end;
         if (retcode <> NO_MORE_RESULTS) and (retcode <> NO_MORE_RPC_RESULTS) then
         begin
             if (retcode = SUCCEED) then
             begin
                 retcode:=dbnextrow(dbproc);
                 if retcode = 0 then
                 begin
                     sqlerror:=esqlerror.Create('SQLERROR');
                     raise sqlerror;
                     exit;
                 end;
                 if (retcode <> NO_MORE_ROWS) then
                 begin
                     dbeof:=false;
                     exit;
                 end
                 else
                 begin
                     newresult:=true;
                     goto start;
                 end;
             end;
         end
         else
         begin
             dbeof:=true;
             exit;
         end;
     end
     else
     begin
         retcode:=dbnextrow(dbproc);
         if retcode = 0 then
         begin
             sqlerror:=esqlerror.Create('SQLERROR');
             raise sqlerror;
             exit;
         end;
         if (retcode <> NO_MORE_ROWS) then
         begin
             dbeof:=false;
             exit;
         end
         else
         begin
             newresult:=true;
             goto start;
         end;
     end;
end;

end.
