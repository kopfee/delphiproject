unit OpenServer;

(*****   Code Written By Huang YanLai   *****)

{$ALIGN OFF} // turn off alignment of fields in record types.

interface

uses Windows,MSDataTypes;

//  Include miscellaneous Open Data Services definitions
//
{import from    <srvmisc.h>}
// NT related defines (used in original NT port)
//
type
 THREAD = DWORD	;

const
 SRV_INDEFINITE_WAIT 	=-1;

type
 SEL  =	char;
 HSEM = char;

// define constants
//
const
 DEFAULT_SERVER_NAME = 'Server';

// Values for TDSVERSION - 4.2.0.0
//
 SRV_TDSV1  = 4;
 SRV_TDSV2  = 2;
 SRV_TDSV3  = 0;
 SRV_TDSV4  = 0;

// Values for PROGVERSION - 0.6.0.0
//
 SRV_SRVV1   =0;
 SRV_SRVV2   =6;
 SRV_SRVV3   =0;
 SRV_SRVV4   =0;

// Sizes of fields in loginrec
 SRV_MAXNAME =30;	// maximum login names
 SRV_MAXREM  =255; // maximum length of remote password name
 SRV_MAXFILENAME =64; // maximum size of filename
 SRV_PKTLEN  =6;   // maximum size of packet size string
 SRV_HOSTIDLEN	=8;	// maximum size of host id field

// define model
//
{ SRVAPI  FAR CDECL }

type
  SRVRETCODE= integer ;        // SUCCEED or FAIL

// values for linterface type

const
 LDEFSQL     =0;
 LXSQL       =1;
 LSQL        =2;
 LSQL2_1     =3;
 LSQL2_2     =4;

// values for ltype field

 LSERVER      =$1;
 LREMUSER     =$2;
 LSECURE 	    =$8;

// possible storage types
//
 INT4_LSB_HI    =0;   // LSB is hi byte (e.g. 68000)
 INT4_LSB_LO    =1;   // LSB is low byte (e.g. Intel)
 INT2_LSB_HI    =2;   // LSB is hi byte (e.g. 68000)
 INT2_LSB_LO    =3;   // LSB is low byte (e.g. Intel)
 FLT_IEEE       =4;   // IEEE 754 floating point
 FLT_VAXD       =5;   // VAX 'D' floating point format
 CHAR_ASCII     =6;   // ASCII character set
 CHAR_EBCDID    =7;   // EBCDIC character set
 TWO_I4_LSB_HI  =8;   // LSB is hi byte (e.g. 68000)
 TWO_I4_LSB_LO  =9;   // LSB is low byte (e.g. Intel)
 FLT_IEEE_LO	=10;  // LSB is low byte (e.g. MSDOS)
 FLT_ND5000		=11;  // ND5000 float format
 FLT4_IEEE_HI	=12;  // IEEE 4-byte floating point, LSB is hi byte
 FLT4_IEEE_LO	=13;  // IEEE 4-byte floating point, LSB is lo byte
 FLT4_VAXF		=14;  // VAX "F" floating point format
 FLT4_ND50004	=15;  // ND5000 4-byte float format
 TWO_I2_LSB_HI	=16;  // LSB is hi byte
 TWO_I2_LSB_LO	=17;  // LSB is lo byte
 MAX_REQUEST    =17;

{ values for Sun
** lint2 = INT2_LSB_HI
** lint4 = int4_LSB_HI
** lchar = CHAR_ASCII
** lflt  = FLT_IEEE
** ldate = TWO_I4_LSB_HI
}

{ values for VAX
** lint2 = INT2_LSB_LO
** lint4 = int4_LSB_LO
** lchar = CHAR_ASCII
** lflt  = FLT_VAXD
** ldate = TWO_I4_LSB_LO
}

{ values for Intel
** lint2 = INT2_LSB_LO
** lint4 = int4_LSB_LO
** lchar = CHAR_ASCII
** lflt  = FLT_IEEE
** ldate = TWO_I4_LSB_LO
}

// DBMS type for dbwhichDBMS
//
const
 DB2            =1;
 SQL_SERVER     =2;
 GDK_SERVER     =3;
 DBASE          =4;
 SQLDS          =5;
 EEDM           =6;
 AS400          =7;
 SQLBASE        =8;
 ORACLE         =9;
 INGRES         =10;
 CL1            =11;
 BLUEPRINT      =12;
 RDB            =13;
 NONSTOP_SQL    =14;
 TERADATA       =15;
 INFORMIX       =16;
 XDB            =17;
 IDMS_R         =18;
 HPIMAGE        =19;
 BRITTON_LEE    =20;
 VSAM           =21;


//  Include Open Data Services structure definitions
//
{import from    <srvstruc.h>}
//
// Structure related defines
//
{
#define SRV_SERVBSIZE(a)                            \
            ((WORD)(a->srvio.packetsize) > (WORD)0  \
            ? (WORD)(a->srvio.packetsize)           \
            : (WORD)512)
}
const
 SRV_DEFAULT_SERVBSIZE   =512;
 MAX_NETLIBS             =16;      // Maximum server side net-libs
 SRV_SERVNETFUNCS	=11;
// WARNING! There is code that assumes it can get to the "last" input
// buffer by looking at the current->pNext buffer. (i.e. It assumes
// SRV_NUMINPUTBUFS == 2).
//
 const SRV_NUMINPUTBUFS=2;

//#ifdef BRIDGE
   SRV_CLIENTNETFUNCS    =12;
//#endif

// longint (CDECL *LGFARPROC)();
type
  LGFARPROC = function ():longint; CDECL;
  SRVHandleProc = function (p:pointer):integer;cdecl;

  PSRV_HANDLER = ^SRV_HANDLER;
  SRV_HANDLER = record 
    previous : PSRV_HANDLER ;
    next : PSRV_HANDLER ;
    last : PSRV_HANDLER ;
    //int (* handler)(void *);
    handler : SRVHandleProc;
  end ;

 PSRV_PEVENTS = ^SRV_PEVENTS;
 SRV_PEVENTS = record
	 srv_attention : PSRV_HANDLER ;
	 srv_connect : PSRV_HANDLER ;
	 srv_disconnect : PSRV_HANDLER ;
	 srv_rpc : PSRV_HANDLER ;
	 srv_language : PSRV_HANDLER ;
	 srv_start : PSRV_HANDLER ;
	 srv_stop : PSRV_HANDLER ;
	 srv_sleep : PSRV_HANDLER ;
	 srv_restart : PSRV_HANDLER ;
	 srv_transmgr : PSRV_HANDLER ;
	 srv_oledb : PSRV_HANDLER ;
 end;

 PSRV_EVENTS = ^SRV_EVENTS;
 SRV_EVENTS = record
    srv_hndl_attention : SRVHandleProc;  // ( SRV_PROC   * )
    srv_hndl_connect : SRVHandleProc;    // ( SRV_PROC   * )
    srv_hndl_disconnect:SRVHandleProc; // ( SRV_PROC   * :
    srv_hndl_restart:SRVHandleProc;    // ( SRV_SERVER * :
    srv_hndl_rpc:SRVHandleProc;        // ( SRV_PROC   * :
    srv_hndl_sleep:SRVHandleProc;      // ( SRV_SERVER * :
    srv_hndl_language:SRVHandleProc;   // ( SRV_PROC   * :
    srv_hndl_start:SRVHandleProc;      // ( SRV_SERVER * :
    srv_hndl_stop:SRVHandleProc;	// ( SRV_SERVER * :
    srv_hndl_attention_ack:SRVHandleProc;  // ( SRV_PROC * :
    srv_hndl_transmgr:SRVHandleProc;	// ( SRV_PROC * :
    srv_hndl_insertexec:SRVHandleProc;	// ( SRV_PROC * :
    srv_hndl_oledb:SRVHandleProc;	// ( SRV_PROC * :
 end ;

 //SRV_PROC=record;
 PSRV_PROC = ^SRV_PROC;

 PSRV_SUBCHANNEL = ^SRV_SUBCHANNEL;
 SRV_SUBCHANNEL = record
	srvproc : PSRV_PROC;
  threadHDL : THandle ;
  threadID : THREAD ;
	ss_handle : THandle ;
	cs_handle : THandle ;
	hEvent : THandle ;
	status : BOOL ;
	site_srvproc : PSRV_PROC ;
	index : DWORD ;
	master_list : ^PSRV_PROC;
 end;

//
// define structures
//

 TRANSLATION_INFO = record
    flag : BOOL ;                      // data translation flag
    int2 : procedure (var v:shortint); //void (*int2)(short*);           // 2-byte integer swap function
    int4 : procedure (var v:longint); //void (*int4)(longint*);            // 4-byte integer swap function
    recvflt: procedure (var v:single); //void (*recvflt)(float*);        // receive 8-byte float translation function
    sendflt: procedure (var v:single); //void (*sendflt)(float*);        // send 8-byte float translation function
    recvflt4: procedure (var v:single); //void (*recvflt4)(float*);       // receive 4-byte float translation function
    sendflt4: procedure (var v:single); //void (*sendflt4)(float*);       // send 4-byte float translation function
    recvchar: procedure (p:pchar; i:integer); //void (*recvchar)(char *, int);  // ASCII translation function
    sendchar: procedure (p:pchar; i:integer); //void (*sendchar)(char *, int);  // ASCII translation function
    twoint4: procedure (p:pchar); //void (*twoint4)(char *);        // 2 4-byte integer swap function
    twoint2: procedure (p:pchar); //void (*twoint2)(char *);        // 2 2-byte interger swap function
 end ;


 //srv_server=record;
 //srv_queuehead=record;
 //srv_comport=record;
 Psrv_server = ^srv_server;
 Psrv_queuehead = ^srv_queuehead;
 Psrv_comport = ^srv_comport;

 SRV_PARAMS = record
    server : psrv_server     ;
    srvproc : psrv_proc       ;
    queuehead : psrv_queuehead ;
    comport : psrv_comport	 ;
    threadID : THREAD   ;
    threadHDL : THandle ;
 end ;
{
#if defined( _MSSQLRISC_)
  #pragma pack(2)
#endif
}
//  SRV_LOGIN
//     The (TDS 4.0) login record received from the server client at login time.
//

 SRV_NameString = array[0..SRV_MAXNAME-1] of BYTE;
 SRV_LOGINREC = record 
    lhostname : SRV_NameString;    // name of host or generic
    lhostnlen : BYTE ;         // length of lhostname
    lusername : SRV_NameString;    // name of user
    lusernlen : BYTE ;         // length of lusername
    lpw : SRV_NameString;  // password (plaintext)
    lpwnlen : BYTE ;           // length of lpw
	  lhostproc : array[0..SRV_HOSTIDLEN-1] of byte;	 // host process identification
	  lunused : array[0..SRV_MAXNAME-SRV_HOSTIDLEN - 6-1] of byte;	 // unused
    lapptype : array[0..6-1] of BYTE;	    // Application specific.
    lhplen: BYTE ;            // length of host process id
    lint2 :               BYTE;         // type of int2 on this host
    lint4 :               BYTE;         // type of int4 on this host
    lchar :               BYTE;         // type of char
    lflt :                BYTE;         // type of float
    ldate :               BYTE;         // type of datetime
    lusedb :              BYTE;         // notify on exec of use db cmd
    ldmpld :              BYTE;         // disallow use of dump/load and bulk insert
    linterface :          BYTE;         // SQL interface type
    ltype :               BYTE;         // type of network connection
    spare : array[0..7-1] of BYTE;          // NOTE: Apparently used by System-10
    lappname : SRV_NameString; // application name
    lappnlen : BYTE ;          // length of appl name
    lservname : SRV_NameString;    // name of server
    lservnlen : BYTE ;         // length of lservname
    lrempw : array [0..$ff-1] of BYTE;      // passwords for remote servers
    lrempwlen : BYTE ;         // length of lrempw
    ltds : array[0..4-1] of BYTE;           // tds version
    lprogname  : array[0..DBPROGNLEN-1] of BYTE ; // client program name
    lprognlen : BYTE ;         // length of client program name
    lprogvers : array[0..4-1] of BYTE;      // client program version
    lnoshort : BYTE ;          // NEW: auto convert of short datatypes
    lflt4 : BYTE ;             // NEW: type of flt4 on this host
    ldate4 : BYTE ;            // NEW: type of date4 on this host
    llanguage: SRV_NameString;    // NEW: initial language
    llanglen : BYTE ;          // NEW: length of language
    lsetlang : BYTE ;          // NEW: notify on language change
    slhier : short ;           // NEW: security label hierarchy
    slcomp : array [0..8-1] of BYTE;         // NEW: security components
    slspare : shortint ;          // NEW: security label spare
    slrole : BYTE ;            // NEW: security login role
    lcharset: SRV_NameString; // character set name (unused)
    lcharsetlen : BYTE ;       // length of character set (unused)
    lsetcharset : BYTE ;       // notify on character set change (unused)
    lpacketsize : array[0..SRV_PKTLEN-1] of BYTE ; // length of TDS packets
    lpacketsizelen : BYTE ;    // length of lpacketsize
    ldummy : array[0..3-1] of BYTE ;         // NEW: pad to longword
  end ;

(*
//
//  SRV_LOGIN_OLDTDS
//     The login record received from "old" TDS 2.0 or 3.4 server clients.
//     The format is basically the same as 4.0, it is just shorter (no server
//     name or password, etc appended at the end).
//
 record srv_login_oldtds {
    BYTE lhostname[SRV_MAXNAME];    // name of host or generic
    BYTE lhostnlen;         // length of lhostname
    BYTE lusername[SRV_MAXNAME];    // name of user
    BYTE lusernlen;         // length of lusername
    BYTE lpw[SRV_MAXNAME];  // password (plaintext)
    BYTE lpwnlen;           // length of lpw
    BYTE lhostproc[SRV_MAXNAME];    // host process identification
    BYTE lhplen;            // length of host process id
    BYTE lint2;             // type of int2 on this host
    BYTE lint4;             // type of int4 on this host
    BYTE lchar;             // type of char
    BYTE lflt;              // type of float
    BYTE ldate;             // type of datetime
    BYTE lusedb;            // notify on exec of use db cmd
    BYTE ldmpld;            // disallow use of dump/load and bulk insert
    BYTE linterface;        // SQL interface type
    BYTE spare[8];          // spare fields
    BYTE lappname[SRV_MAXNAME]; // application name
    BYTE lappnlen;          // length of appl name
    BYTE ldummy;         // pad length to even boundary

} SRV_LOGIN_OLDTDS;
*)
{
#if defined( _MSSQLRISC_)
  #pragma pack()
#endif
}
// Define structure for ODS statistics

 SRV_STATS = record
    NumReads : integer ;
    NumWrites : integer ;
 end ;

// Define list elements used in queuing
// network request.
  PSRV_LISTHEAD = ^SRV_LISTHEAD;
  PSRV_LISTENTRY = ^SRV_LISTENTRY;

 SRV_QUEUEHEAD = record
    Flink : PSRV_QUEUEHEAD ;
    Blink : PSRV_QUEUEHEAD ;
    ListHead : PSRV_LISTHEAD  ;
 end;

 SRV_LISTHEAD = record
    Flink : PSRV_LISTENTRY ;
    Blink : PSRV_LISTENTRY ;
    NumListEntries : integer    ;
    NumReadRequest : integer    ;
    MaxQueueLength : integer    ;
    ListLock : longint   ;
    ListEvent : THandle ;
 end ;

 SRV_LISTENTRY = record
    Flink : PSRV_LISTENTRY ;
    Blink : PSRV_LISTENTRY ;
    pSrvProc : psrv_proc;
 end;

// Define routines to manage list entries.

//
//  VOID
//  InitializeListHead(
//  PSRV_LISTENTRY ListHead
//      );
//

{
 InitializeListHead(TYPE, ListHead) (\
    (ListHead)->Flink = (ListHead)->Blink = (TYPE)(ListHead))
}
//
//  BOOLEAN
//  IsListEmpty(
//  PSRV_LISTENTRY ListHead
//      );
//
{
 IsListEmpty(ListHead) (\
    ( ((ListHead)->Flink == (ListHead)) ? TRUE : FALSE ) )
}
//
//  SRV_LISTENTRY
//  RemoveHeadList(
//  TYPE,
//  TYPE ListHead
//      );
//
(*
 RemoveHeadList(TYPE,ListHead) \
    (TYPE)(ListHead)->Flink;\
    {\
    TYPE FirstEntry;\
        FirstEntry = (ListHead)->Flink;\
    FirstEntry->Flink->Blink = (TYPE)(ListHead);\
        (ListHead)->Flink = FirstEntry->Flink;\
    }
*)
//
//  VOID
//  RemoveEntryList(
//  PSRV_LISTENTRY Entry
//      );
//
(*
 RemoveEntryList(Entry) {\
    PSRV_LISTENTRY _EX_Entry;\
        _EX_Entry = (Entry);\
        _EX_Entry->Blink->Flink = _EX_Entry->Flink;\
        _EX_Entry->Flink->Blink = _EX_Entry->Blink;\
    }
*)
//
//  VOID
//  InsertTailList(
//  PSRV_LISTHEAD  ListHead,
//  PSRV_LISTENTRY Entry
//      );
//
(*
 InsertTailList(ListHead,Entry) \
    (Entry)->Flink = (ListHead);\
    (Entry)->Blink = (ListHead)->Blink;\
    (ListHead)->Blink->Flink = (Entry);\
    (ListHead)->Blink = (Entry);\
    InterlockedIncrement(&(ListHead)->NumListEntries);
*)
//
//  VOID
//  InsertHeadList(
//  PSRV_LISTHEAD  ListHead,
//  PSRV_LISTENTRY Entry
//      );
//
(*
 InsertHeadList(ListHead,Entry) \
    (Entry)->Flink = (ListHead)->Flink;\
    (Entry)->Blink = (ListHead);\
    (ListHead)->Flink->Blink = (Entry);\
    (ListHead)->Flink = (Entry);\
    InterlockedIncrement(&(ListHead)->NumListEntries);
*)
//
//  VOID
//  InsertHeadQueue(
//  PSRV_QUEUEHEAD  ListHead,
//  PSRV_QUEUEHEAD  Entry
//      );
//
(*
 InsertHeadQueue(ListHead,Entry) \
    (Entry)->Flink = (ListHead)->Flink;\
    (Entry)->Blink = (ListHead);\
    (ListHead)->Flink->Blink = (Entry);\
    (ListHead)->Flink = (Entry);
*)
//
//  VOID
//  InsertTailQueue(
//  PSRV_QUEUEHEAD  ListHead,
//  PSRV_QUEUEHEAD  Entry
//      );
//
(*
 InsertTailQueue(ListHead,Entry) \
    (Entry)->Flink = (ListHead);\
    (Entry)->Blink = (ListHead)->Blink;\
    (ListHead)->Blink->Flink = (Entry);\
    (ListHead)->Blink = (Entry);
*)
//
//  VOID
//  RemoveEntryQueue(
//  PSRV_QUEUEHEAD Entry
//      );
//
(*
 RemoveEntryQueue(Entry) {\
    PSRV_QUEUEHEAD _EX_Entry;\
        _EX_Entry = (Entry);\
        _EX_Entry->Blink->Flink = _EX_Entry->Flink;\
        _EX_Entry->Flink->Blink = _EX_Entry->Blink;\
    }
*)

// Configuration structure.

 SRV_FILENAME_String =  array[0..SRV_MAXFILENAME-1] of char;

 Unsigned = longword;
 PSRV_CONFIG = ^TSRV_CONFIG;
 TSRV_CONFIG = record
    connections : Unsigned;          // maximum allowed client connections
    stacksize : Unsigned;            // stack size of new threads created
    log_file_open : BOOL;        // flag indicating log file open
    log_handle : THandle;           // THandle of openned log file
    log_file_name : SRV_FILENAME_String;    // name of log file
    print_recv : BOOL ;           // dump reads to screen
    print_send : BOOL ;           // dump sends to screen
    remote_access : BOOL ;        // flag indicating remote server access
    max_remote_sites : Unsigned;     // simultaneous remote sites accessing
    max_remote_connections : Unsigned ;   // maximum allowed in/out remote connections
    numConnectsPerThread : WORD      ; // Number of connections to monitor per network thread
    MaxWorkingThreads : WORD      ;    // Max number of working threads
    MinWorkingThreads : WORD      ;    // Min Number of working threads
    ConcurrentThreads : WORD      ;    // Min Number of working threads
    WorkingThreadTimeout : DWORD     ; // Time to wait before exiting when idle
    max_packets : unsigned  ;          // maximum number of network packets buffered
    //
    // Multi Server Side Net-Library support
    //
    numNetLibs : WORD      ;
    spare : WORD      ;
    SSNetLibs : array [0..MAX_NETLIBS-1,0..SRV_SERVNETFUNCS-1] of LGFARPROC;         // NetLib Function ptrs
    SSModules : array[0..MAX_NETLIBS-1] of THandle ;                           // NetLib Module handles
    connect_names : array[0..MAX_NETLIBS-1,0..SRV_MAXFILENAME-1] of char ;      // NetLib connection names
    connect_dlls : array[0..MAX_NETLIBS-1,0..SRV_MAXFILENAME-1] of char;       // NetLib names
    connect_versions : array[0..MAX_NETLIBS-1,0..SRV_MAXFILENAME-1] of char;   // NetLib versions
    server_name : SRV_FILENAME_String; // Server name
    local_only : BOOL      ;           // flag indicating local access only
    unpack_rpc : BOOL      ;           // flag indicating if RPCs should be unpacked
    max_packetsize : unsigned  ;       // maximum network packet size
	  dflt_packetsize : unsigned  ;		// The default packet size.

    ThreadPriority : integer       ;  // Priority of thread in class.
    ansi : BOOL ;	// flag indicating if ANSI codepage is used
    tdsversion : array[0..4-1] of BYTE;
    progversion : array[0..4-1] of BYTE;
    threadaffinity : DWORD     ;			// thread affinity option
{$ifdef BRIDGE}
    THandle      CSModule;                       // Client NetLib Module THandle
    LGFARPROC   CSNetLib[SRV_CLIENTNETFUNCS];   // NetLib Function ptrs
    char        client_name[SRV_MAXFILENAME];   // Client side name
    BOOL        bAuditConnects;                 // flag indicating if connects should be logged
{$endif}
end;

//
//  SRV_TDSHDR
//  The first 8 bytes of each network packet constitute the packet
//  header.
//
 SRV_TDSHDR = record
    _type : BYTE        ;       // io packet type
    status : BYTE        ;     // io packet status
    length : DBUSMALLINT ;     // io packet length
    channel : DBUSMALLINT ;    // io packet subchannel
    packet : BYTE        ;     // io packet number
    window : BYTE        ;     // io packet window size
 end ;

//  SRV_INPUTBUF
//  This structure maintains the read information when
//  pre-reading packets.
//
 PSRV_INPUTBUF = ^SRV_INPUTBUF;
 SRV_INPUTBUF = record
    pBuffer : PBYTE;
    ioStatus : DWORD  ;
    ioRecvCnt : DWORD  ;
    pNext : PSRV_INPUTBUF ;
 end ;

// SRV_COMPORT_QUEUE
// Queue entry for completion port requests.
//
 PSRV_COMPORT_QUEUE = ^SRV_COMPORT_QUEUE;
 SRV_COMPORT_QUEUE = record
	Flink : PSRV_COMPORT_QUEUE;
	Blink : PSRV_COMPORT_QUEUE;
 end ;

// SRV_COMPORT_BUF
//	Description of a buffer passed through the srv_post_completion_queue
//  entry point. These buffers are typically posted by the server to
//	perform work on a worker thread that can't be handled by the currently
//	executing thread.
//
 SRV_COMPORT_BUF = record
	queue : SRV_COMPORT_QUEUE	;
	// Overlapped structure passed through srv_post_completion_queue
	// overlapped.Offset contains the address of this structure such that
	//
	overlapped : OVERLAPPED	;
	message_size : DWORD		;
	message : array[0..0] of BYTE;
 end ;

//
//  SRV_IO
//  This is the data structure used for reading and writing client
//  connection data for a particular server task.
//
 SRV_IO = record
    server_ep : pointer;       // server side endpoint
{$ifdef BRIDGE}
    client_ep : pointer;       // client side endpoint
    fCSerror : BOOL;        // flag indicate client-side error
{$endif}
    cs_sub_handle : THandle ;  // client-side subchannel local THandle
    outbuff : PBYTE;        // send: start of send buffer
    p_outbuff : PBYTE;      // send: next place in buffer
    n_outbuff : WORD;      // send: room left in send buffer
    inbuff : PBYTE;         // recv: start of read buffer
    p_inbuff : PBYTE;       // recv: next place in buffer
    n_inbuff : WORD ;       // recv: room left in read buffer
    SQLspanned : integer ;     // flag indicating that the SQL command
                                //  has spanned more that 1 network buffer.
    cbflag : integer ;	  				// flag indicating that a client buffer is
                                //  available.
    channel : DBUSMALLINT ;        // io packet subchannel
    packet : BYTE        ;         // io packet number
    window : BYTE        ;         // io packet window size
    ioEvent : THandle      ;        // io event THandle
    ioOverlapped : OVERLAPPED  ;   // io overlapped structure.
    pNextInBuf : PSRV_INPUTBUF;  // current io input buffer index
    ioInputBuffers : array[0..SRV_NUMINPUTBUFS-1] of SRV_INPUTBUF ; // io input buffers
    ss_sub_handle : THandle;  // server-side subchannel local THandle
    packetsize : WORD ;	    // TDS packet size
end ;

//
//  SRV_COLDESC: column description array (used by srv_describe & srv_sendrow)
//
 PSRV_COLDESC = ^SRV_COLDESC;
 SRV_COLDESC = record
    otype : longword ;        // output data type
    olen : longword ;         // length
    itype : longword ;        // input data type
    ilen : longword ;         // length
    data : PBYTE;		// data buffer address
    user_type : DBINT    ;		// user-defined data type
    precision : BYTE     ; 	// precision
    scale : BYTE     ;		// scale
 end ;

//
//  SRV_RPCp: RPC parameter information
//
 PSRV_RPCp = ^SRV_RPCp;
 SRV_RPCp = record
    len : BYTE          ;          // length of RPC parameter name
    rpc_name : PBYTE;     // pointer to the RPC parameter name
    status : BYTE          ;       // return status, 1 = passed by reference
    user_type : longword ;    // User-defined data type
    _type : BYTE ;         // data type
    maxlen : longword ;       // maximum possible data length
    actual_len : longword ;   // actual data length
    value : pointer;        // the actual data
 end ;

 SRV_COMPORT = record
    hdl : THandle ;
    cpu : DWORD  ;
 end  ;

//
//  SRV_PROC:   This is the main connection structure
//
 SRV_PROC = record
    tdsversion : WORD          ;   // version of tds detected from client
                                //   0x3400 = 3.4, 0x4000 = 4.0
    status : WORD          ;       // status of this SRV_PROC
    srvio : SRV_IO        ;        // I/O structure of srvproc
    login : SRV_LOGINREC  ;        // login record received from the client
    langbuff : pointer;     // pointer to language buffer
    langlen : longword;      // length of language buffer
    event : longword;        // event variable
    server : pointer;       // pointer to associated SRV_SERVER structure
    threadstack : pchar;  // stack pointer of event thread stack
    threadID : THREAD;     // thead ID associated with this SRV_PROC
    threadHDL : THandle;    // thread THandle for resume and suspend
    iowakeup : THandle;     // event THandle to wait on for overlapped io
                                // and more. Passed on to SQL Server and netlibs.
    exited : THandle;       // semaphore indicating that thread
                                //  associated with this SRV_PROC has exited
    rowsent : DBINT;      // # of rows sent to client
    coldescp : PSRV_COLDESC;     // pointer to column description array
    coldescno : DBUSMALLINT  ;    // count of column descriptions
    colnamep : PBYTE;     // pointer to column name list
    colnamelen : WORD;   // length of column name list
    userdata : pointer;     // pointer to user's private data area
    event_data : pointer;   // pointer to event data area
    serverlen : BYTE;    // length of server name
    servername : pointer;   // name of server

    //  RPC info
    //
    rpc_active : BYTE;          // flag indicating active RPC (TRUE=active)
    rpc_server_len : BYTE;      // length of RPC server name
    rpc_server : pointer;          // name of RPC server
    rpc_database_len : BYTE;    // length of RPC database name
    rpc_database : pointer;        // name of RPC database
    rpc_owner_len : BYTE;       // length of RPC owner name
    rpc_owner : pointer;           // name of RPC owner
    rpc_proc_len : BYTE;        // length of RPC or stored procecedure name
    rpc_proc_name : pointer;       // name of RPC or stored procedure
    rpc_proc_number : longword;     // number of RPC "procedure_name;number"
    rpc_linenumber : longword;      // line number batch error occurred on.
    rpc_options : word ;         // recompile option flag (bit 0)
    rpc_num_params : word ;      // number of RPC parameters
    rpc_params : ^PSRV_RPCp;          // array of pointers to each RPC paramater

    // Return information for non-remote procedure call client command.
    // This information is provided by the function srv_returnval().
    // flag indicating active non-RPC values (TRUE = active)
    //
    non_rpc_active : BYTE ;

    // number of non-RPC parameters
    //
    non_rpc_num_params : word;

    // array of pointers to each non-RPC paramater
    //
    non_rpc_params : ^PSRV_RPCp;

    // temporary work buffer
    //
    temp_buffer : array[0..100-1] of char ;

    // array of subchannel structures
    //
    subprocs : ^PSRV_SUBCHANNEL ;

    // Data Translation information
    //
    translation_info : TRANSLATION_INFO     ;
    IOListEntry : srv_listentry ;
    CommandListEntry : srv_listentry ;
    pNetListHead : PSRV_LISTHEAD        ;
    bNewPacket : BOOL;
    StatusCrit : longint;	// critical section to check attentions
    serverdata : pointer ;    // private data area used ONLY by SQL Server
    subchannel : PSRV_SUBCHANNEL;

    // Pre && Post Handler pointers
    //
    pre_events : PSRV_PEVENTS;
    post_events : PSRV_PEVENTS;

    // current position in language buffer used by processRPC
	//
    p_langbuff : pointer;

	  fSecureLogin : BOOL;

	// Set by the server when making an outbound call to an XP.
	//
	  fInExtendedProc : BOOL;
  (*
	// If TRUE indicates the current buffer is from
	// srv_post_completion_queue and the buffer should be
	// deallocated when the current work is completed.  If
	// FALSE the current buffer came from the network and a
	// new read should be posted on the net.
	//
	unsigned    fLocalPost:1;

	// If TRUE an XP associated with this srvproc made a call back into
	// the server on a bound connection. This flag is used to allow the
	// calling session to wait for logout processing of the XP to complete
	//
	unsigned	fMadeBoundCall:1;

	// Filler to align after flags above.
	//
	unsigned	uFill1:30;
  *)
  _fFlag : longword;
	// List of requests posted using srv_post_completion_queue. Entries are
	// dynamically allocated inside srv_post_completion_queue and enqueued
	// in netIOCompletionRoutine. After the request has been processed the
	// entry is removed from this queue and deallocated.
	//
	// NOTE: Must hold SRV_PROC spinlock while altering queue.
	//
	comport_queue : SRV_COMPORT_QUEUE	;

    // Data pointers reserved for the Starfighter team
    //
    pSF1 : pointer;    // Currently in use by SQLTrace
    pSF2 : pointer;    // Reserved

    // Pre and Post handler semephores used during handler instals
    // and deinstals.
    //
    hPreHandlerMutex : THandle ;
    hPostHandlerMutex : THandle ;
	  bSAxp : BOOL ;		// Used by XP's to determine if running as SA
end;

  PSRV_CONTROL = ^SRV_CONTROL;
  SRV_CONTROL = record
    status : longword;        // status of process
    connects : longword;      // current number of connections

    srvprocs : ^PSRV_PROC;    // array of SRV_PROC connection structures

    // semaphore indicating that the connects counter is being accessed or
    // modified
    //
    connects_sem : THandle ;

    // semaphore indicating that thread has started
    //
    start_sem : THandle ;

    // semaphore indicating that some event has occurred
    //
    event_sem : THandle ;

    // semaphore indicating that log file is being written to
    //
    log_sem : THandle ;

    // shutdown critical section
    //
    ShutDownCrit : longint ;

    // Network list critical section
    //
    NetQueueCrit : longint ;

    // Thread Pool critical section
    //
    ThreadPoolCrit : longint ;

    // print screen critical section
    //
    ScrnPrnt : longint ;

    remote_sites : longword ;      // current number of remote sites connected
    remote_connects : longword ;   // current number of in/out remote connections

    // semaphore indicating that the remote sites counter is being accessed or
    // modified
    //
    remote_sites_sem : THandle ;

    // semaphore indicating that the remote connections counter is being accessed or
    // modified
    //
    remote_connects_sem : THandle ;

    // network request queue list
    //
    netQueueList : SRV_QUEUEHEAD ;
    numNetQueueEntries : integer           ;
    maxNetQueueEntries : integer           ;

    // command queue list
    //
    CommandQueueHead : PSRV_LISTHEAD ;

    // Server statistics.
    //
    Stats : SRV_STATS   ;

    pSharedCounter : ^DWORD;

    srvproc_mutex : THandle ;

    dwWorkingThreadCnt : DWORD  ;
    maxWorkingThreadCnt : DWORD  ;

    comport : PSRV_COMPORT;
    num_comports : BYTE   ;

    ProcessorCnt : BYTE   ;

end ;

SRV_SERVER = record
    SSNetLib : array[0..SRV_SERVNETFUNCS-1] of LGFARPROC;  // Server Side NetLib functions
    SSModule : THandle;                    // Server Side DLL
    ep_size : DWORD      ;
    listen_ep : pointer;
{$ifdef BRIDGE}
    CSNetLib : array[0..SRV_CLIENTNETFUNCS-1] of LGFARPROC; // Client Side NetLib functions
    CSModule : THandle    ;                     // Client Side DLL
    client_name : SRV_FILENAME_String;
{$endif}
    net_threadID : THREAD ;        // thead ID of client network event thread
    net_threadHDL : THandle ;       // thread THandle for resume and suspend

    //
    // connection information
    //
    connect_name : SRV_FILENAME_String;
    connect_dll : SRV_FILENAME_String;
    connect_version : SRV_FILENAME_String;

    //
    // temporary work buffer
    //
    temp_buffer : array[0..100-1] of char ;
    //
    // server configuration information
    //
    config : TSRV_CONFIG ;
    // server control information
    //
    control : PSRV_CONTROL;

    // define the event handlers
    //
    events : PSRV_EVENTS;

    // Pre && Post Handler pointers
    pre_events : PSRV_PEVENTS;
    post_events : PSRV_PEVENTS;

    // Pre and Post handler semephores
    //
    hPreHandlerMutex : THandle ;    // Single writer
    hPostHandlerMutex :  THandle ;
    hPreHandlerSem : THandle ;      // Multiple reader
    hPostHandlerSem : THandle ;

end ;

// Private structure used to export server entry points as ODS callbacks
// for SQLServer use only.
//
 ODS_CALLBACKS = record
   sql_getbindtoken : function (p:pointer;  pch:pchar) : integer; cdecl;
	 sql_getdtcxact : procedure (p:pointer; var p2 : pointer); cdecl;
   sql_startinexec : function (p:pointer):  integer ; cdecl;
   sql_stopinexec :  procedure (p:pointer); cdecl;
    // Place new callbacks at the end of the structure.
 end ;

//  Include Open Data Services token definitions
//
{import from    <srvtok.h>}
//  TDS tokens
//
const
 SRV_TDS_TEXT            =$23;
 SRV_TDS_VARBINARY       =$25;
 SRV_TDS_INTN            =$26;
 SRV_TDS_VARCHAR         =$27;
 SRV_TDS_LOGIN           =$ad;
 SRV_TDS_BINARY          =$2d;
 SRV_TDS_IMAGE           =$22;
 SRV_TDS_CHAR            =$2f;
 SRV_TDS_INT1            =$30;
 SRV_TDS_BIT             =$32;
 SRV_TDS_INT2            =$34;
 SRV_TDS_INT4            =$38;
 SRV_TDS_MONEY           =$3c;
 SRV_TDS_DATETIME        =$3d;
 SRV_TDS_FLT8            =$3e;
 SRV_TDS_FLTN            =$6d;
 SRV_TDS_MONEYN          =$6e;
 SRV_TDS_DATETIMN        =$6f;
 SRV_TDS_OFFSET          =$78;
 SRV_TDS_RETURNSTATUS    =$79;
 SRV_TDS_PROCID          =$7c;
 SRV_TDS_COLNAME         =$a0;
 SRV_TDS_COLFMT          =$a1;
 SRV_TDS2_COLFMT         =$2a; // Only used on TDS 2.0, 3.4
 SRV_TDS_TABNAME         =$a4;
 SRV_TDS_COLINFO         =$a5;
 SRV_TDS_ORDER           =$a9;
 SRV_TDS_ERROR           =$aa;
 SRV_TDS_INFO            =$ab;
 SRV_TDS_RETURNVALUE     =$ac;
 SRV_TDS_CONTROL         =$ae;
 SRV_TDS_ROW             =$d1;
 SRV_TDS_DONE            =$fd;
 SRV_TDS_DONEPROC        =$fe;
 SRV_TDS_DONEINPROC      =$ff;

//
// These are version 4.2 additions
//
 SRV_TDS_FLT4             =$3b;
 SRV_TDS_MONEY4           =$7a;
 SRV_TDS_DATETIM4         =$3a;

 SRV_TDS_NULL             =$1f;    //Null parameter from server

//
// These are version 4.6 additions
//
 SRV_TDS_ENVCHANGE       =$e3;

//
// These are version 6.0 additions
//
 SRV_TDS_NUMERIC         =$3f;
 SRV_TDS_NUMERICN        =$6c;

 SRV_TDS_DECIMAL         =$37;
 SRV_TDS_DECIMALN        =$6a;

//  Include Open Data Services constant definitions
//
{import from    <srvconst.h>}
//
// Symbol types.  These are passed to srv_symbol to translate Open Data Services
// symbols.
//
const
 SRV_ERROR      =0;
 SRV_DONE       =1;
 SRV_DATATYPE   =2;
 SRV_EVENT_      =4; // SRV_EVENT

// define srv_symbol() SRV_ERRORs
//
 SRV_ENO_OS_ERR    =0;
 SRV_INFO          = 1;
 SRV_FATAL_PROCESS = 10;
 SRV_FATAL_SERVER  = 19;

// define event values
//
 SRV_CONTINUE       =0;
 SRV_LANGUAGE       =1;
 SRV_CONNECT        =2;
 SRV_RPC            =3;
 SRV_RESTART        =4;
 SRV_DISCONNECT     =5;
 SRV_ATTENTION      =6;
 SRV_SLEEP          =7;
 SRV_START          =8;
 SRV_STOP           =9;
 SRV_EXIT           =10;
 SRV_CANCEL         =11;
 SRV_SETUP          =12;
 SRV_CLOSE          =13;
 SRV_PRACK          =14;
 SRV_PRERROR        =15;
 SRV_ATTENTION_ACK  =16;
 SRV_SKIP	          =17;
 SRV_TRANSMGR	      =18;
 SRV_INSERTEXEC	    =19;
 SRV_OLEDB	        =20;

 SRV_INTERNAL_HANDLER =99;
 SRV_PROGRAMMER_DEFINED  =100;

// define configuration values
//
 SRV_SERVERNAME          =0;   // not a configuration option
 SRV_CONNECTIONS         =1;
 SRV_LOGFILE             =2;
 SRV_STACKSIZE           =3;
 SRV_PRINT_RECV          =4;
 SRV_PRINT_SEND          =5;
 SRV_VERSION             =6;
 SRV_REMOTE_ACCESS       =7;
 SRV_REMOTE_SITES        =8;
 SRV_REMOTE_CONNECTIONS  =9;
 SRV_MAX_PACKETS         =10;
 SRV_MAXWORKINGTHREADS	=11;
 SRV_MINWORKINGTHREADS	=12;
 SRV_THREADTIMEOUT	=13;
 SRV_CONCURRENTTHREADS	=14;
 SRV_LOCAL_ONLY		=15;
 SRV_UNPACK_RPC		=16;
 SRV_MAX_PACKETSIZE	=17;
 SRV_THREADPRIORITY	=18;
 SRV_ANSI_CODEPAGE	=19;
 SRV_REMOTENAME		=20;
 SRV_TDS_VERSION 	=21;
 SRV_PROG_VERSION	=22;
//#ifdef BRIDGE
 SRV_CONNECTION_NAMES	=23;
 SRV_CURRENT_CONNECTS	=24;
 SRV_AUDIT_CONNECTS	=25;
//#endif
	SRV_DEFAULT_PACKETSIZE	=26;
 SRV_PASSTHROUGH		=27;
 SRV_THREADAFFINITY	=28;

// define thread priority values
//
 SRV_PRIORITY_LOW      =THREAD_PRIORITY_LOWEST;
 SRV_PRIORITY_NORMAL   =THREAD_PRIORITY_NORMAL;
 SRV_PRIORITY_HIGH     =THREAD_PRIORITY_HIGHEST;
 SRV_PRIORITY_CRITICAL =THREAD_PRIORITY_TIME_CRITICAL;

// define server values
//

 dbTrue = 1;        // TRUE
 dbFalse = 0;       // FALSE
 dbSUCCEED = 1;     // SUCCEED
 dbFAIL = 0;        // FAIL


//#if !defined( SRV_DUPLICATE_HANDLER )

 SRV_DUPLICATE_HANDLER	=2;

//#endif

 SRV_NULLTERM   =-1;   // Indicates a null terminated string

//#if !defined( STDEXIT)

 STDEXIT     =0;   // Normal exit valule

//#endif

//#if !defined( ERREXIT)

 ERREXIT     =1;   // Error exit value

//#endif

//  Message types
//
 SRV_MSG_INFO    =1;
 SRV_MSG_ERROR   =2;


// define SRV_PROC->status values
//
 SRV_LOGGING_IN =$1;   // slot is free for used
 SRV_FREE_       =$2;   // slot is free for used
 SRV_SUSPENDED  =$4;   // thread is in suspended state
 SRV_DEAD       =$8;   // thread is dead
 SRV_KILL       =$10;   // thread needs to be killed
 SRV_RUNNING    =$20;   // thread is running
 SRV_ATTN       =$40;   // client has sent an attention signal for this thread
 SRV_WAITING    =$80;   // waiting for next command
 SRV_IOERROR    =$100;	// io error occured
 SRV_QUEUED     =$200;	// srvproc has been placed on command queue
 SRV_INEXEC     =$400;	// inserting data into local table
//#ifdef BRIDGE
 SRV_ATTN_MIMIC =$800;	  // client side does not support OOB
//#endif

//  Done packet status fields.
//
 SRV_DONE_FINAL  =$0000;
 SRV_DONE_MORE   =$0001;
 SRV_DONE_ERROR  =$0002;
 SRV_DONE_INXACT =$0004;
 SRV_DONE_PROC   =$0008;
 SRV_DONE_COUNT  =$0010;
 SRV_DONE_ATTN   =$0020;
 SRV_DONE_RPC_IN_BATCH   =$0080;

//  RPC return parameter type
//
 SRV_PARAMRETURN =$0001;

//  Event types
//
 SRV_EQUEUED =$1;
 SRV_EIMMEDIATE =$2;

//  Field types used as field argument to srv_pfield().
//
// SRV_LANGUAGE 1   already defined above
// SRV_EVENT    4   already defined above

 SRV_SPID       =10;
 SRV_NETSPID    =11;
 SRV_TYPE       =12;
 SRV_STATUS     =13;
 SRV_RMTSERVER  =14;
 SRV_HOST       =15;
 SRV_USER       =16;
 SRV_PWD        =17;
 SRV_CPID       =18;
 SRV_APPLNAME   =19;
 SRV_TDS        =20;
 SRV_CLIB       =21;
 SRV_LIBVERS    =22;
 SRV_ROWSENT    =23;
 SRV_BCPFLAG    =24;
 SRV_NATLANG    =25;
 SRV_PIPEHANDLE =26;
 SRV_NETWORK_MODULE	   =27;
 SRV_NETWORK_VERSION	 =28;
 SRV_NETWORK_CONNECTION =29;
 SRV_LSECURE	 = 30;
 SRV_SAXP	  =31;

// define the different TDS versions.
//
 SRV_TDS_NONE   =0;
 SRV_TDS_2_0    =1;
 SRV_TDS_3_4    =2;
 SRV_TDS_4_2    =3;
 SRV_TDS_6_0    =4;

// define initial number of network threads
// to start when ODS is started.

 SRV_INITIALNETTHREADCNT =1;

// define RPC_ACTIVE flags

 SRV_RPC_ACTIVE              =1;
 SRV_RPC_DISABLE_OUTPARAMS   =2;

// define the ENV_CHANGE types
 SRV_ENV_PACKETSIZE 	=4;

//
// Flush status for write_buffer
//
 SRV_NO_FLUSH	=0;
 SRV_FLUSH_EOM	=1;
 SRV_FLUSH_MORE	=2;

//
// Numeric array to convert precision to internal length.
//
{
extern unsigned char SrvPrecToLen[];
extern unsigned char SrvLenToPrec[];
}

//  Include Open Data Services datatype definitions
//
{import from    <srvtypes.h>}
//
//  Defines for server types
//
const
 SRVTEXT        =SRV_TDS_TEXT;
 SRVVARBINARY   =SRV_TDS_VARBINARY;
 SRVINTN        =SRV_TDS_INTN;
 SRVVARCHAR     =SRV_TDS_VARCHAR;
 SRVLOGIN       =SRV_TDS_LOGIN;
 SRVBINARY      =SRV_TDS_BINARY;
 SRVIMAGE       =SRV_TDS_IMAGE;
 SRVCHAR        =SRV_TDS_CHAR;
 SRVINT1        =SRV_TDS_INT1;
 SRVBIT         =SRV_TDS_BIT;
 SRVINT2        =SRV_TDS_INT2;
 SRVINT4        =SRV_TDS_INT4;
 SRVMONEY       =SRV_TDS_MONEY;
 SRVDATETIME    =SRV_TDS_DATETIME;
 SRVFLT8        =SRV_TDS_FLT8;
 SRVFLTN        =SRV_TDS_FLTN;
 SRVMONEYN      =SRV_TDS_MONEYN;
 SRVDATETIMN    =SRV_TDS_DATETIMN;
 SRVOFFSET      =SRV_TDS_OFFSET;
 SRVRETURNSTATUS =SRV_TDS_RETURNSTATUS;
 SRVPROCID      =SRV_TDS_PROCID;
 SRVCOLNAME     =SRV_TDS_COLNAME;
 SRVCOLFMT      =SRV_TDS_COLFMT;
 SRVTABNAME     =SRV_TDS_TABNAME;
 SRVCOLINFO     =SRV_TDS_COLINFO;
 SRVORDER       =SRV_TDS_ORDER;
 SRVERROR       =SRV_TDS_ERROR;
 SRVINFO        =SRV_TDS_INFO;
 SRVRETURNVALUE =SRV_TDS_RETURNVALUE;
 SRVCONTROL     =SRV_TDS_CONTROL;
 SRVROW         =SRV_TDS_ROW;
 SRVDONE        =SRV_TDS_DONE;
 SRVDONEPROC    =SRV_TDS_DONEPROC;
 SRVDONEINPROC  =SRV_TDS_DONEINPROC;

//
// These are version 4.2 additions
//
 SRVFLT4        =SRV_TDS_FLT4;
 SRVMONEY4      =SRV_TDS_MONEY4;
 SRVDATETIM4    =SRV_TDS_DATETIM4;

 SRVNULL        =SRV_TDS_NULL;    // Null parameter from server

//
// These are version 6.0 additions
//
 SRVNUMERIC	=SRV_TDS_NUMERIC;
 SRVNUMERICN	=SRV_TDS_NUMERICN;

 SRVDECIMAL	=SRV_TDS_DECIMAL;
 SRVDECIMALN	=SRV_TDS_DECIMALN;

//  Include Open Data Services MACRO definitions and function prototypes
//
{import from    <srvapi.h>}
//
//  Define Macro's External API's
//
function  srv_getconfig(server : PSRV_SERVER):PSRV_CONFIG; cdecl;

function  srv_getserver(srvproc : PSRV_PROC):PSRV_SERVER; cdecl;

function  srv_got_attention(srvproc : PSRV_PROC):BOOL; cdecl;

function  srv_eventdata( pointer : PSRV_PROC):pointer; cdecl;

//
//  Define Macro's
//
(*
#define SRV_GETCONFIG(a)	srv_getconfig	  ( a )
#define SRV_GETSERVER(a)	srv_getserver	  ( a )
#define SRV_GOT_ATTENTION(a)	srv_got_attention ( a )
#define	SRV_EVENTDATA(a)	srv_eventdata	  ( a )
#define	SRV_IODEAD(a)		srv_iodead	  ( a )
#define	SRV_TDSVERSION(a)	srv_tdsversion	  ( a )
*)
//
//  Define Other External API's
//
function  srv_alloc(size :  DBINT):pointer; cdecl;

function srv_bmove(from : pointer; _to:pointer;
		      count : DBINT ):integer; cdecl;

function srv_bzero(location:pointer; count : DBINT):integer; cdecl;

function  srv_config( config : PSRV_CONFIG ;
		       option : DBINT		;
		       value : PDBCHAR;
		       valuelen : integer):integer; cdecl;

function  srv_config_alloc():PSRV_CONFIG; cdecl;

function  srv_convert(srvproc : PSRV_PROC;
			srctype : integer;
			src : pointer;
			srclen : DBINT;
			desttype : integer;
			dest : pointer;
			destlen : DBINT	):integer; cdecl;

function srv_describe(srvproc :  PSRV_PROC;
			 colnumber : integer;
			 columnname : PDBCHAR;
			 namelen : integer		;
			 desttype : DBINT		;
			 destlen : DBINT		;
			 srctype : DBINT		;
			 srclen : DBINT		;
			 srcdata : pointer):integer; cdecl;

type
  srv_errHandleProc = function ( server : PSRV_SERVER ;
				   srvproc : PSRV_PROC ;
				   srverror : integer;
				   severity : BYTE;
				   state : BYTE;
				   oserrnum : integer;
				   errtext : PDBCHAR;
				   errtextlen : integer;
				   oserrtext : PDBCHAR;
				   oserrtextlen : integer):integer; cdecl;

function srv_errhandle(handler:srv_errHandleProc):srv_errHandleProc; cdecl;

function srv_event(srvproc : PSRV_PROC ;
		      event : integer;
		      data : PBYTE):integer; cdecl;

function srv_free(ptr : pointer):integer; cdecl;

function srv_getuserdata(srvproc : PSRV_PROC):pointer; cdecl;

function srv_getbindtoken(srvproc : PSRV_PROC; token_buf : pchar):integer; cdecl;

function srv_getdtcxact(srvproc : PSRV_PROC; var ppv:pointer):integer; cdecl;

type
  svr_handlerProc = function (p:pointer):integer; cdecl;

function srv_handle(server : PSRV_SERVER ;event : DBINT	;
				  handler: svr_handlerProc):svr_handlerProc; cdecl;

function srv_impersonate_client(srvproc : PSRV_PROC):integer; cdecl;

function srv_init(config : PSRV_CONFIG ;
		     connectname : PDBCHAR;
		     namelen : integer):PSRV_SERVER; cdecl;

function srv_iodead(BOOL : PSRV_PROC):BOOL; cdecl;

function srv_langcpy(srvproc : PSRV_PROC;
			start : longint		;
			nbytes : longint		;
			buffer : PDBCHAR):longint; cdecl;

function srv_langlen(srvproc : PSRV_PROC):longint; cdecl;

function srv_langptr(srvproc : PSRV_PROC ):pointer; cdecl;

function srv_log(server : PSRV_SERVER ;
		    datestamp : BOOL	     ;
		    msg : PDBCHAR;
		    msglen : integer):integer; cdecl;

function srv_paramdata(srvproc : PSRV_PROC ;
			  n : integer):pointer; cdecl;

function srv_paramlen(srvproc : PSRV_PROC ;
			 n : integer):integer; cdecl;

function srv_parammaxlen(srvproc : PSRV_PROC ;
			    n : integer):integer; cdecl;

function srv_paramname(srvproc : PSRV_PROC ;
			  n : integer		 ;
			  len:PInt):PDBCHAR; cdecl;

function srv_paramnumber(srvproc : PSRV_PROC ;
			    name : PDBCHAR;
			    len : integer):integer; cdecl;

function srv_paramset(srvproc : PSRV_PROC ;
			 n : integer		;
			 data : pointer;
			 len : integer):integer; cdecl;

function srv_paramstatus(srvproc : PSRV_PROC ;
			     n  : integer ):integer;  cdecl;

function srv_paramtype(srvproc : PSRV_PROC ;
			  n : integer):integer; cdecl;


function srv_pfield(srvproc : PSRV_PROC ;
		       field : integer	      ;
		       len : PInt):PDBCHAR;  cdecl;

function srv_returnval(srvproc : PSRV_PROC ;
			  valuename : PDBCHAR;
			  len : integer		 ;
			  status : BYTE		 ;
			  _type : DBINT 	 ;
			  maxlen : DBINT 	 ;
			  datalen : DBINT 	 ;
			  value : pointer):integer; cdecl;

function srv_revert_to_self(srvproc :  PSRV_PROC  ):integer; cdecl;

function srv_rpcdb(srvproc : PSRV_PROC ;
		      len  : PInt):PDBCHAR; cdecl;

function srv_rpcname(srvproc : PSRV_PROC ;
			len : PInt):PDBCHAR; cdecl;

function srv_rpcnumber(srvproc : PSRV_PROC):integer; cdecl;

function srv_rpcoptions(srvproc : PSRV_PROC  ):DBUSMALLINT; cdecl;

function srv_rpcowner(srvproc : PSRV_PROC ;
			 len : PInt):PDBCHAR; cdecl;

function srv_rpcparams(srvproc : PSRV_PROC):integer; cdecl;

function srv_run(server : PSRV_SERVER ):integer; cdecl;

function srv_senddone(srvproc : PSRV_PROC ;
			 status : DBUSMALLINT	;
			 curcmd : DBUSMALLINT	;
			 count : DBINT):integer; cdecl;

function srv_sendmsg(srvproc : PSRV_PROC ;
			msgtype : integer;
			msgnum : DBINT;
			msgclass : DBTINYINT;
			state : DBTINYINT ;
			rpcname : PDBCHAR;
			rpcnamelen : integer;
			linenum : DBUSMALLINT;
			message : PDBCHAR;
			msglen : integer):integer; cdecl;

function srv_sendrow( srvproc : PSRV_PROC  ):integer; cdecl;

function srv_sendstatus(srvproc : PSRV_PROC ;
			   status : DBINT):integer; cdecl;

function srv_setcoldata(srvproc : PSRV_PROC ;
			   column : integer;
			   data : pointer):integer; cdecl;

function srv_setcollen(srvproc : PSRV_PROC ;
			  column : integer;
			  len : integer):integer; cdecl;

function srv_setuserdata( srvproc:PSRV_PROC;
			    ptr:pointer):integer; cdecl;

function srv_setutype( srvproc:PSRV_PROC;
			 column:integer;
			 usertype:DBINT):integer; cdecl;

function srv_sfield( server:PSRV_SERVER;
		       field:integer;
		       len:PINT):PDBCHAR; cdecl;

function srv_symbol( _type : integer	 ;
		       symbol : integer	 ;
		       len:PINT):PDBCHAR; cdecl;

function srv_tdsversion( srvproc : PSRV_PROC ):integer; cdecl;

function srv_willconvert(srctype:integer;
			    desttype:integer ):BOOL; cdecl;

function srv_writebuf( srvproc : PSRV_PROC ;
             ptr : pointer ;
             count : WORD ):integer; cdecl;

function srv_get_text(srvproc: PSRV_PROC;
			 var outlen:longint):integer; cdecl;

procedure srv_ackattention(srvproc : PSRV_PROC); cdecl;

function srv_terminatethread(srvproc : PSRV_PROC):integer; cdecl;

function srv_sendstatistics(srvproc : PSRV_PROC ):integer;cdecl;

function srv_clearstatistics(srvproc : PSRV_PROC ):integer;cdecl;

function srv_setevent(server : PSRV_SERVER ; event : integer ):integer; cdecl;

function srv_message_handler(srvproc : PSRV_PROC ;errornum : integer; severity:BYTE ;
		state : BYTE ; oserrnum:integer ; errtext : pchar ; errtextlen:integer;
		oserrtext : pchar; oserrtextlen:integer ):integer; cdecl;

function srv_pre_handle(server : PSRV_SERVER ;
			     srvproc : PSRV_PROC ;
			     event : DBINT ;
           handler : svr_handlerProc;
				   remove :  BOOL ):integer; cdecl;

function srv_post_handle(server : PSRV_SERVER ;
			     srvproc : PSRV_PROC ;
			     event : DBINT ;
           handler : svr_handlerProc;
				   remove : BOOL ):integer; cdecl;

function srv_ansi_sendmsg(srvproc : PSRV_PROC ;
			msgtype : integer;
			msgnum : DBINT;
			msgclass : DBTINYINT ;
			state : DBTINYINT;
			rpcname : pDBCHAR;
			rpcnamelen : integer;
			linenum : DBUSMALLINT;
			message : PDBCHAR;
			msglen : integer):integer; cdecl;

function srv_post_completion_queue(srvproc : PSRV_PROC ;
			inbuf : PDBCHAR;
			inbuflen : integer):integer; cdecl;



implementation

const
  ODSDLL = 'opends60.dll';

function  srv_getconfig(server : PSRV_SERVER):PSRV_CONFIG; external ODSDLL;

function  srv_getserver(srvproc : PSRV_PROC):PSRV_SERVER; external ODSDLL;

function  srv_got_attention(srvproc : PSRV_PROC):BOOL; external ODSDLL;

function  srv_eventdata( pointer : PSRV_PROC):pointer; external ODSDLL;

//
//  Define Macro's
//
(*
#define SRV_GETCONFIG(a)	srv_getconfig	  ( a )
#define SRV_GETSERVER(a)	srv_getserver	  ( a )
#define SRV_GOT_ATTENTION(a)	srv_got_attention ( a )
#define	SRV_EVENTDATA(a)	srv_eventdata	  ( a )
#define	SRV_IODEAD(a)		srv_iodead	  ( a )
#define	SRV_TDSVERSION(a)	srv_tdsversion	  ( a )
*)
//
//  Define Other External API's
//
function  srv_alloc(size :  DBINT):pointer; external ODSDLL;

function srv_bmove(from : pointer; _to:pointer;
		      count : DBINT ):integer; external ODSDLL;

function srv_bzero(location:pointer; count : DBINT):integer; external ODSDLL;

function  srv_config( config : PSRV_CONFIG ;
		       option : DBINT		;
		       value : PDBCHAR;
		       valuelen : integer):integer; external ODSDLL;

function  srv_config_alloc():PSRV_CONFIG; external ODSDLL;

function  srv_convert(srvproc : PSRV_PROC;
			srctype : integer;
			src : pointer;
			srclen : DBINT;
			desttype : integer;
			dest : pointer;
			destlen : DBINT	):integer; external ODSDLL;

function srv_describe(srvproc :  PSRV_PROC;
			 colnumber : integer;
			 columnname : PDBCHAR;
			 namelen : integer		;
			 desttype : DBINT		;
			 destlen : DBINT		;
			 srctype : DBINT		;
			 srclen : DBINT		;
			 srcdata : pointer):integer; external ODSDLL;

function srv_errhandle(handler:srv_errHandleProc):srv_errHandleProc; external ODSDLL;

function srv_event(srvproc : PSRV_PROC ;
		      event : integer;
		      data : PBYTE):integer; external ODSDLL;

function srv_free(ptr : pointer):integer; external ODSDLL;

function srv_getuserdata(srvproc : PSRV_PROC):pointer; external ODSDLL;

function srv_getbindtoken(srvproc : PSRV_PROC; token_buf : pchar):integer; external ODSDLL;

function srv_getdtcxact(srvproc : PSRV_PROC; var ppv:pointer):integer; external ODSDLL;

function srv_handle(server : PSRV_SERVER ;event : DBINT	;
				  handler: svr_handlerProc):svr_handlerProc; external ODSDLL;

function srv_impersonate_client(srvproc : PSRV_PROC):integer; external ODSDLL;

function srv_init(config : PSRV_CONFIG ;
		     connectname : PDBCHAR;
		     namelen : integer):PSRV_SERVER; external ODSDLL;

function srv_iodead(BOOL : PSRV_PROC):BOOL; external ODSDLL;

function srv_langcpy(srvproc : PSRV_PROC;
			start : longint		;
			nbytes : longint		;
			buffer : PDBCHAR):longint; external ODSDLL;

function srv_langlen(srvproc : PSRV_PROC):longint; external ODSDLL;

function srv_langptr(srvproc : PSRV_PROC ):pointer; external ODSDLL;

function srv_log(server : PSRV_SERVER ;
		    datestamp : BOOL	     ;
		    msg : PDBCHAR;
		    msglen : integer):integer; external ODSDLL;

function srv_paramdata(srvproc : PSRV_PROC ;
			  n : integer):pointer; external ODSDLL;

function srv_paramlen(srvproc : PSRV_PROC ;
			 n : integer):integer; external ODSDLL;

function srv_parammaxlen(srvproc : PSRV_PROC ;
			    n : integer):integer; external ODSDLL;

function srv_paramname(srvproc : PSRV_PROC ;
			  n : integer		 ;
			  len:PInt):PDBCHAR; external ODSDLL;

function srv_paramnumber(srvproc : PSRV_PROC ;
			    name : PDBCHAR;
			    len : integer):integer; external ODSDLL;

function srv_paramset(srvproc : PSRV_PROC ;
			 n : integer		;
			 data : pointer;
			 len : integer):integer; external ODSDLL;

function srv_paramstatus(srvproc : PSRV_PROC ;
			     n  : integer ):integer;  external ODSDLL;

function srv_paramtype(srvproc : PSRV_PROC ;
			  n : integer):integer; external ODSDLL;


function srv_pfield(srvproc : PSRV_PROC ;
		       field : integer	      ;
		       len : PInt):PDBCHAR;  external ODSDLL;

function srv_returnval(srvproc : PSRV_PROC ;
			  valuename : PDBCHAR;
			  len : integer		 ;
			  status : BYTE		 ;
			  _type : DBINT 	 ;
			  maxlen : DBINT 	 ;
			  datalen : DBINT 	 ;
			  value : pointer):integer; external ODSDLL;

function srv_revert_to_self(srvproc :  PSRV_PROC  ):integer; external ODSDLL;

function srv_rpcdb(srvproc : PSRV_PROC ;
		      len  : PInt):PDBCHAR; external ODSDLL;

function srv_rpcname(srvproc : PSRV_PROC ;
			len : PInt):PDBCHAR; external ODSDLL;

function srv_rpcnumber(srvproc : PSRV_PROC):integer; external ODSDLL;

function srv_rpcoptions(srvproc : PSRV_PROC  ):DBUSMALLINT; external ODSDLL;

function srv_rpcowner(srvproc : PSRV_PROC ;
			 len : PInt):PDBCHAR; external ODSDLL;

function srv_rpcparams(srvproc : PSRV_PROC):integer; external ODSDLL;

function srv_run(server : PSRV_SERVER ):integer; external ODSDLL;

function srv_senddone(srvproc : PSRV_PROC ;
			 status : DBUSMALLINT	;
			 curcmd : DBUSMALLINT	;
			 count : DBINT):integer; external ODSDLL;

function srv_sendmsg(srvproc : PSRV_PROC ;
			msgtype : integer;
			msgnum : DBINT;
			msgclass : DBTINYINT;
			state : DBTINYINT ;
			rpcname : PDBCHAR;
			rpcnamelen : integer;
			linenum : DBUSMALLINT;
			message : PDBCHAR;
			msglen : integer):integer; external ODSDLL;

function srv_sendrow( srvproc : PSRV_PROC  ):integer; external ODSDLL;

function srv_sendstatus(srvproc : PSRV_PROC ;
			   status : DBINT):integer; external ODSDLL;

function srv_setcoldata(srvproc : PSRV_PROC ;
			   column : integer;
			   data : pointer):integer; external ODSDLL;

function srv_setcollen(srvproc : PSRV_PROC ;
			  column : integer;
			  len : integer):integer; external ODSDLL;

function srv_setuserdata( srvproc:PSRV_PROC;
			    ptr:pointer):integer; external ODSDLL;

function srv_setutype( srvproc:PSRV_PROC;
			 column:integer;
			 usertype:DBINT):integer; external ODSDLL;

function srv_sfield( server:PSRV_SERVER;
		       field:integer;
		       len:PINT):PDBCHAR; external ODSDLL;

function srv_symbol( _type : integer	 ;
		       symbol : integer	 ;
		       len:PINT):PDBCHAR; external ODSDLL;

function srv_tdsversion( srvproc : PSRV_PROC ):integer; external ODSDLL;

function srv_willconvert(srctype:integer;
			    desttype:integer ):BOOL; external ODSDLL;

function srv_writebuf( srvproc : PSRV_PROC ;
             ptr : pointer ;
             count : WORD ):integer; external ODSDLL;

function srv_get_text(srvproc: PSRV_PROC;
			 var outlen:longint):integer; external ODSDLL;

procedure srv_ackattention(srvproc : PSRV_PROC); external ODSDLL;

function srv_terminatethread(srvproc : PSRV_PROC):integer; external ODSDLL;

function srv_sendstatistics(srvproc : PSRV_PROC ):integer;external ODSDLL;

function srv_clearstatistics(srvproc : PSRV_PROC ):integer;external ODSDLL;

function srv_setevent(server : PSRV_SERVER ; event : integer ):integer; external ODSDLL;

function srv_message_handler(srvproc : PSRV_PROC ;errornum : integer; severity:BYTE ;
		state : BYTE ; oserrnum:integer ; errtext : pchar ; errtextlen:integer;
		oserrtext : pchar; oserrtextlen:integer ):integer; external ODSDLL;

function srv_pre_handle(server : PSRV_SERVER ;
			     srvproc : PSRV_PROC ;
			     event : DBINT ;
           handler : svr_handlerProc;
				   remove :  BOOL ):integer; external ODSDLL;

function srv_post_handle(server : PSRV_SERVER ;
			     srvproc : PSRV_PROC ;
			     event : DBINT ;
           handler : svr_handlerProc;
				   remove : BOOL ):integer; external ODSDLL;

function srv_ansi_sendmsg(srvproc : PSRV_PROC ;
			msgtype : integer;
			msgnum : DBINT;
			msgclass : DBTINYINT ;
			state : DBTINYINT;
			rpcname : pDBCHAR;
			rpcnamelen : integer;
			linenum : DBUSMALLINT;
			message : PDBCHAR;
			msglen : integer):integer; external ODSDLL;

function srv_post_completion_queue(srvproc : PSRV_PROC ;
			inbuf : PDBCHAR;
			inbuflen : integer):integer; external ODSDLL;

end.
