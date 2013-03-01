unit GateCBS;

interface

uses windows,OpenServer,MSSQL,MSDataTypes;

var
  remote_server : PChar;

const
// Define some user message codes.
//
 SRV_MAXERROR    =20000;
 RPC_UNKNOWN     =SRV_MAXERROR + 1;
 COMPUTE_ROW     =SRV_MAXERROR + 2;
 REMOTE_MSG      =SRV_MAXERROR + 3;
 SEND_FAILED     =SRV_MAXERROR + 4;
 FILTER_ROW      =SRV_MAXERROR + 5;
 BULK_CMD        ='insert bulk';

// This error value must be sent back to the client in the event
// of a failure to login to the target database.  It is used in the
// init_remote() function below.
//
 REMOTE_FAIL =4002;

// Declare the structure to use for our private data area.
// It will be passed to the event handlers in the SRV_PROC structure.
// It contains information to make and use a connection to the remote
// DBMS -- in this case a SQL Server.
//
// A gateway to a non-SQL Server DBMS would contain a different structure.
//
 MAXPARAMS   =255;

type
  PREMOTE_DBMS = ^REMOTE_DBMS;
  TRetParams = array[0..MAXPARAMS-1] of shortint;
  PRetParams = ^TRetParams;
  REMOTE_DBMS = record
    login : PLOGINREC ;    // The SQL Server login structure
    dbproc : PDBPROCESS ;  // The connection to the remote SQL Server
    bulk_mode : BOOL ;         // Flag indicating 'bulk insert' mode
    retparams :  TRetParams; // tag return parameters
    need_filter : BOOL;
    filterColIndex : integer;
  end ;

// Declare the structure to be used for packing column metadata into the user datatype
// field.  This is a new feature of SQL Server 6.0.  The additional column metadata
// is available via dbcolinfo() in DB-Lib.

  TTYPEINFO = record
    typeid : word;			// used to hold the real user datatype
    flags : word;
    (*USHORT  nilable:1, 	// TRUE/FALSE
	    case_sensitive:1,	// TRUE, FALSE
	    updateable:2,	// TRUE, FALSE, UNKNOWN
	    identity:1,		// TRUE/FALSE
	    spare1:1,		// spare fields
	    spare2:2,
	    spare3:8;*)
  end ;

// The remote server name of this gateway
//
var
  Newsrvproc : PSRV_PROC;       // Latest SRV_PROC allocated.

// Mutex used for init_remote()
  init_remote_mutex : THANDLE = 0;

function dbcolntype(dbproc : PDBPROCESS ; column : integer ):integer ; cdecl;

function attn_handler(srvproc : PSRV_PROC):integer; cdecl;

function chk_err(server :PSRV_SERVER ; srvproc :PSRV_PROC ; errornum: integer ;
            severity : BYTE ; state : BYTE ; oserrnum : integer ; errtext : PCHAR ;
            errtextlen : integer ; oserrtext : PDBCHAR ; oserrtextlen : integer ):integer; cdecl;

function init_remote(srvproc : PSRV_PROC):integer; cdecl;

function init_server(server : PSRV_SERVER ):integer; cdecl;

function rpc_execute(srvproc : PSRV_PROC):integer; cdecl;

function exit_remote(srvproc : PSRV_PROC):integer; cdecl;

function lang_execute(srvproc : PSRV_PROC):integer; cdecl;

function handle_results(rmtproc : PDBPROCESS ; srvproc : PSRV_PROC):integer; cdecl;

function remotemsgs(dbproc : PDBPROCESS ; msgno :integer; msgstate :integer ;
               severity : integer ; msgtext,srvname,procname : pchar;
					     line : word):integer; cdecl;

function remoteerr(dbproc : PDBPROCESS ;  severity, dberr, oserr : integer;
              dberrstr, oserrstr : pchar):integer; cdecl;

//procedure void set_remote_server_name(char *name);

function  checkFilter(REMOTE_DBMS : PREMOTE_DBMS):boolean;

function  filterThis(rmtproc: PDBPROCESS; REMOTE_DBMS : PREMOTE_DBMS):boolean;

implementation

uses sysUtils;

function dbcolntype(dbproc : PDBPROCESS ; column : integer ):integer ; cdecl;
begin
  result := dbcoltype(dbproc,column);
end;

function attn_handler(srvproc : PSRV_PROC):integer; cdecl;
begin
  // Open Data Services NT receives client attention events asynchronously.
  	// Being handle_results may be calling dbresults or dbnextrow, we can not
	// process the attention with the dbcancel call here. Instead dbcancel
	// will be called after the attention has been detected using 
	// SRV_GOT_ATTENTION.
  result := SRV_CONTINUE;
end;

function chk_err(server :PSRV_SERVER ; srvproc :PSRV_PROC ; errornum: integer ;
            severity : BYTE ; state : BYTE ; oserrnum : integer ; errtext : PCHAR ;
            errtextlen : integer ; oserrtext : PDBCHAR ; oserrtextlen : integer ):integer; cdecl;
var
  log_buffer,error,oserror : array[0..255] of char;
begin
    move(errtext,error,errtextlen);
    error[errtextlen] := #0;
    move(oserrtext,oserror,  oserrtextlen);
    oserror[oserrtextlen] := #0;

	// Strip out resource information. Get the actual error number.
	  errornum := (errornum and  $0000FFFF);

    // Operating system error?
    //
    if (oserrnum <> SRV_ENO_OS_ERR) then
    begin
      StrFmt(log_buffer, 'SERVER OS ERROR: %d: %s.', [oserrnum, oserror]);
      if (server<>nil) then
			  srv_log(server, TRUE, log_buffer, SRV_NULLTERM) else
        // If application not initialized log to screen
    		writeln(string(log_buffer));
    end;

    // Is this a fatal error for the server?
    //
    if (severity >= SRV_FATAL_SERVER) then
    begin
        StrFmt(log_buffer,
		  			'SERVER: FATAL SERVER ERROR: errornum = %d, severity = %d, state = %d: %s.',
					 [errornum, severity, state, error]);
        if (server<>nil) then
			    srv_log(server, TRUE, log_buffer, SRV_NULLTERM) else
          // If application not initialized log to screen
    		  writeln ('%s', log_buffer);
          result := SRV_EXIT;
          exit;
    end else
    begin
        //
        // Did the 'srvproc' get a fatal error?
        //
        if (severity >= SRV_FATAL_PROCESS) then
        begin
            strFmt(log_buffer,
						  'SERVER: FATAL CONNECT ERROR: errornum = %d, severity = %d, state = %d: %s.',
                     [errornum, severity, state, error]);
        	if (server<>nil) then
				    srv_log(server, TRUE, log_buffer, SRV_NULLTERM) else
            // If application not initialized log to screen
    			  writeln (log_buffer);
            result := SRV_CANCEL;
            exit;
        end;
    end;

    // A non-fatal error or an information message received.
    // We'll pass it through to the client.
    //
    if (srvproc <>nil)  and (server <> nil) then
        if (severity < 10) then
        begin
          // if informational message
            srv_sendmsg(srvproc, SRV_MSG_INFO, errornum, severity, 0,
                        nil, 0, 0, error, SRV_NULLTERM);
        end
        else begin            // must be an error message
            srv_sendmsg(srvproc, SRV_MSG_ERROR, errornum, severity, 0,
                    nil, 0, 0, error, SRV_NULLTERM);
        end
     else begin
        strFmt(log_buffer, 'ODS ERROR: errornum = %d, severity = %d: %s',
                [errornum, severity, error]);
        if (server<>nil) then
			    srv_log(server, TRUE, log_buffer, SRV_NULLTERM) else
          // If application not initialized log to screen
    		  writeln (log_buffer);
    end;
    result := SRV_CONTINUE;
end;

function init_remote(srvproc : PSRV_PROC):integer; cdecl;
var
  str : pchar;
  len : integer;
  remote : PREMOTE_DBMS ; // the private data area to keep
                          // track of the remote DBMS
                          // connection.
  bImpersonated : boolean;
  version : integer;
begin
    // Set Newsrvproc.  This is used if we get an error on
    // the open from DBLIB.  Since there isn't a dbproc,
    // it is clear which srvproc to send the msg back on when the
    // DBLIB error-handler gets called.
    //
    // First lock out any other threads trying to connect using this same
    // function.
    //
    WaitForSingleObject(init_remote_mutex, INFINITE);

    Newsrvproc := srvproc;

   version:=SRV_TDSVERSION(srvproc);
   writeln('client version :',version);
	 if ( version< SRV_TDS_6_0) then
	 begin
		// Send a message to the client that they must be 4.2 or 6.0 clients.
		// 4.2 client could be supported by
		// converting all decimal/numeric values to float before sending to
		// client, and omiting the column metadata packed into srv_setutype in
		// the handle_results() function.
		//
		  srv_sendmsg(srvproc,
					SRV_MSG_ERROR,
					REMOTE_FAIL,
					0,
					0,
					nil,
					0,
					0,
					'Gateway sample application only supports version 6.0 clients or newer.',
					SRV_NULLTERM);

		// Now allow other threads to enter this function.
		//
	    ReleaseMutex(init_remote_mutex);
		  result := SRV_DISCONNECT;
      exit;
    end;

    // Allocate a REMOTE_DBMS information structure.
    //
    remote := PREMOTE_DBMS(srv_alloc(sizeof(REMOTE_DBMS)));

    // Try to open a connection to the remote DBMS.
    //
    if (remote = nil) then
    begin
        // Send a message to the client that
        // the remote connection failed.
        //
        srv_sendmsg(srvproc, SRV_MSG_ERROR, REMOTE_FAIL, 0,
                    0, nil, 0, 0,
                    'Login to remote DBMS failed (srv_alloc).', SRV_NULLTERM);
		    ReleaseMutex(init_remote_mutex);
        result := SRV_DISCONNECT;
        exit;
    end;

    // Set 'bulk insert' mode flag to false.
    //
    remote^.bulk_mode := FALSE;

    // Allocate the LOGINREC structure used to make connections to the
    // remote server. Open the connection in the SRV_CONNECT handler.
    //
    remote^.login := dblogin();

    if (remote^.login = nil) then
    begin
        // Send a message to the client that the
        // remote connection failed.
        //
        srv_sendmsg(srvproc, SRV_MSG_ERROR, REMOTE_FAIL, 0,
                    0, nil, 0, 0,
                    'Login to remote DBMS failed (dblogin).', SRV_NULLTERM);

        // Deallocate the remote structure and set the user data
        // pointer in 'srvproc' to nil so that the disconnect
        // handler won't try to disconnect from the remote dbms.
        //
        srv_free(remote);
		    ReleaseMutex(init_remote_mutex);
        result := SRV_DISCONNECT;
        exit;
    end;
    remote^.dbproc := nil;

    // Set the user name, password, and application name for the remote DBMS.
    //
    DBSETLName(remote^.login, srv_pfield(srvproc, SRV_USER, nil),DBSETUSER);
    DBSETLName(remote^.login, srv_pfield(srvproc, SRV_PWD, nil),DBSETPWD);
    DBSETLName(remote^.login, srv_pfield(srvproc, SRV_APPLNAME, nil),DBSETAPP);
    DBSETLName(remote^.login, srv_pfield(srvproc, SRV_NATLANG, nil),DBSETLANG);

	  // following will let us pass decimal data back to client
	  DBSETLName(remote^.login, nil,DBVER60);

	//if client requested a trusted connection, gateway must do so too
	if (StrComp(srv_pfield(srvproc, SRV_LSECURE, nil),'TRUE')=0) then
		DBSETLName(remote^.login,nil,DBSETSECURE);

	// Even if client hasn't explicitly requested a trusted connection, he may be
	// using integrated security if the server is set to mixed or integrated mode.
	// To handle this case, always tryy to impersonate the client.

	bImpersonated := Boolean(srv_impersonate_client(srvproc));

    // See if client has set Bulk Copy flag
    //
    (*
    if (strcmp(srv_pfield(srvproc, SRV_BCPFLAG, nil), 'TRUE') = 0)
        BCP_SETL(remote->login, TRUE);
    else
        BCP_SETL(remote->login, FALSE);
    *)
    // If no server name was specified as a parameter to the main program,
    // then assume that the name is coming from the client.
    //
    (*
    if (remote_server = nil) or (remote_server[0] = #0) then
    begin
        remote_server := srv_pfield(srvproc, SRV_HOST, nil);
    end;
    *)
    // Try to open a connection to the remote DBMS.
    //
    remote^.dbproc := dbopen(remote^.login,remote_server);
    if (remote^.dbproc = nil) then
    begin
			// Send a message to the client that
			// the remote connection failed.
			//
			srv_sendmsg(srvproc,
					SRV_MSG_ERROR,
					REMOTE_FAIL,
					0,
					0,
					nil,
					0,
					0,
					'Login to remote DBMS failed (dbopen).',
					SRV_NULLTERM);

        // Deallocate the remote structure and set the user data
        // pointer in 'srvproc' to nil so that the disconnect
        // handler won't try to disconnect from the remote DBMS.
        //
      srv_free(remote);
      srv_setuserdata(srvproc, nil);
	 	  ReleaseMutex(init_remote_mutex);
		  if( bImpersonated ) then srv_revert_to_self(srvproc);
      result := (SRV_DISCONNECT);
      exit;
    end else
    begin
        // Connection to the remote DBMS successful.  Save
        // remote data structure in the 'srvproc' so it will be
        // available to the other handlers. We'll also map the remote
        // DBMS connection to our 'srvproc'.
        //
        srv_setuserdata(srvproc, remote);
        dbsetuserdata(remote^.dbproc, srvproc);
    end;

	  ReleaseMutex(init_remote_mutex);

	  // if currently running in user context, don't need to any more
	  if( bImpersonated ) then srv_revert_to_self(srvproc);

    // Display connect info on console
    //
	  str := srv_pfield(srvproc, SRV_CPID, @len);
    str[len] := #0;
	  writeln('Client process ID: ',str);

    str := srv_pfield(srvproc, SRV_USER, @len);
    str[len] := #0;
    writeln('User name: ', str);

    str := srv_pfield(srvproc, SRV_APPLNAME, @len);
    str[len] := #0;
    if (len > 0) then
       writeln('Application program name: ', str);

    str := srv_pfield(srvproc, SRV_RMTSERVER, @len);
    str[len] := #0;
    if (len > 0) then
       writeln('Remote Server: ', str);

    Result := (SRV_CONTINUE);
end;

function init_server(server : PSRV_SERVER ):integer; cdecl;
var
  log_buffer : array[0..256-1] of char;
begin
    // When we get a connection request from a client, we want to
    // call 'init_remote()' to make a connection to the remote
    // server.
    //
    srv_handle(server, SRV_CONNECT, svr_handlerProc(@init_remote));

    // When the client issues a language request, call
    // 'lang_execute()' to send the SQL statement to the remote DBMS.
    //
    srv_handle(server, SRV_LANGUAGE, svr_handlerProc(@lang_execute));

    // When the client issues an RSP, call 'rpc_execute()'
    // to send the RSP to the remote DBMS (the SQL Server).
    //
    srv_handle(server, SRV_RPC, svr_handlerProc(@rpc_execute));

    // When a disconnect request is issued, call 'exit_remote()'
    // to close the connection to the remote DBMS.
    //
    srv_handle(server, SRV_DISCONNECT, svr_handlerProc(@exit_remote));

    // Install the handler that will be called when the
    // gateway receives an attention from one of its
    // clients.
    //
    srv_handle(server, SRV_ATTENTION, svr_handlerProc(@attn_handler));

	 // Initialize dblib and configure for 100 connections
	 //
	  dbinit();
	  //dbsetmaxprocs(100);

    // Now we'll install the message and error handlers for any
    // messages from the remote DBMS.
    //
    dberrhandle(remoteerr);
    dbmsghandle(remotemsgs);

	 // Create mutex to serialize init_remote
	 //
	  init_remote_mutex := CreateMutex(nil, FALSE, nil);

    //  Log Server information to log file
    //
    StrFmt(log_buffer,'Client connections allowed = %s',
      [srv_sfield(server, SRV_CONNECTIONS, nil)]);

    srv_log(server, FALSE, log_buffer, SRV_NULLTERM);
    writeln(String(log_buffer));

    result := SRV_CONTINUE;
end;

function rpc_execute(srvproc : PSRV_PROC):integer; cdecl;
var
  rmtproc : PDBPROCESS ; // Our DBPROCESS pointer
  i :  integer ;                  // Index variable
  params :  shortint ;
  retparam : shortint ;
  paramarray : PRetParams;
	complete_rpc_name : array[0..4 * (MAXNAME + 1)-1] of DBCHAR ; //database.owner.name;#
	rpc_db : PDBCHAR ;
	rpc_owner : PDBCHAR ;
	rpc_name : PDBCHAR ;
	rpc_number : integer ;
	rpc_number_char : array[0..17-1] of char ;
	rpc_paramname : PDBCHAR ;
	rpc_paramstatus : BYTE ;
	rpc_paramtype : integer ;
	rpc_parammaxlen : DBINT ;
	rpc_paramlen : DBINT ;
	rpc_paramdata : pointer;
	numeric : DBNUMERIC  ;		//structure to hold numeric params
begin
  rmtproc := PREMOTE_DBMS (srv_getuserdata(srvproc))^.dbproc;
  paramarray := @PREMOTE_DBMS(srv_getuserdata(srvproc))^.retparams;

	// initialize numeric structure
	FillChar(numeric, sizeof(DBNUMERIC),0);

   // Construct full RPC name and initialize the RPC to the remote DBMS.
   //
	FillChar(complete_rpc_name, sizeof(complete_rpc_name),0);
	rpc_db := srv_rpcdb(srvproc, nil);
	rpc_owner := srv_rpcowner(srvproc, nil);
	rpc_name := srv_rpcname(srvproc, nil);

	if (rpc_db <> nil) then
  begin
		strcat(complete_rpc_name,rpc_db);
		strcat(complete_rpc_name,'.');
	end;
	if (rpc_owner <> nil) then
  begin
		strcat(complete_rpc_name,rpc_owner);
		strcat(complete_rpc_name,'.');
	end;;
	strcat(complete_rpc_name,rpc_name);

	rpc_number := srv_rpcnumber(srvproc);
	if (rpc_number > 0) then
  begin
    strcat(complete_rpc_name,';');
		//itoa(rpc_number,rpc_number_char,10);
    strfmt(rpc_number_char,'%d',[rpc_number]);
		strcat(complete_rpc_name, rpc_number_char);
	end;

	dbrpcinit(rmtproc, complete_rpc_name, srv_rpcoptions(srvproc));

    // Set up any RPC parameters.
    //
  params := srv_rpcparams(srvproc);
  retparam := 1;

  for i := 1 to params do
  begin
    rpc_paramname := srv_paramname(srvproc, i, nil);
    if (strlen(rpc_paramname)=0) then
      rpc_paramname := nil;
    rpc_paramstatus := srv_paramstatus(srvproc, i);
    rpc_paramtype := srv_paramtype(srvproc, i);
    rpc_parammaxlen := srv_parammaxlen(srvproc, i);
    rpc_paramlen := srv_paramlen(srvproc, i);
    rpc_paramdata := srv_paramdata(srvproc, i);

  //  DB-Lib requires maxlen of -1 for fixed-length datatypes, but ODS doesn't
  // always return this.   So set it.
    case (rpc_paramtype) of
      SQLDECIMAL,SQLNUMERIC,SQLBIT,SQLINT1,SQLINT2,SQLINT4,SQLFLT4,SQLDATETIM4,
      SQLMONEY4,SQLMONEY,SQLDATETIME,SQLFLT8: rpc_parammaxlen := -1;
    end;

  // Special handling for decimal types.  DB-Lib treats them as fixed length datatypes
  // that are the full size of a DBNUMERIC.  ODS uses variable-length numeric data
  // and only gives the exact bytes needed to represent the number

    case (rpc_paramtype) of
      SQLDECIMAL,SQLNUMERIC:
      begin
        fillchar(numeric, sizeof(DBNUMERIC),0);
        move(rpc_paramdata^, numeric, rpc_paramlen);
        rpc_paramdata := @numeric;
        // ODS says nil numeric values have a length of 2, dblib expects them to be 0
        if (rpc_paramlen = 2) then rpc_paramlen := 0;
      end;
    end;

    dbrpcparam(rmtproc,rpc_paramname,rpc_paramstatus,rpc_paramtype,
         rpc_parammaxlen,rpc_paramlen, rpc_paramdata);

      // The current rpc may have three parameters, but only the
      // first and third are return parameters.  This means that
      // dbnumrets() returns two parameters, not three.  The first
      // call to dbretdata() referes to the rpc's first parameter,
      // and the second call to dbretdata() refers to the rpc's
      // third parameter.  To handle this, we map each return
      // parameter to its original parameter so we can later
      // reset the return value of the correct return parameters
      // in 'handle_results()'.
      //
    if (srv_paramstatus(srvproc, i) and SRV_PARAMRETURN)<>0 then
    begin
        paramarray^[retparam] := i;
        inc(retparam);
    end;
  end;

  // Send the RPC to the remote DBMS.
  //
  dbrpcsend(rmtproc);
  dbsqlok(rmtproc);

  // Now get the remote DBMS results and pass them back to
  // Open Server client.
  //
  handle_results(rmtproc, srvproc);
  result := SRV_CONTINUE;
end;

function exit_remote(srvproc : PSRV_PROC):integer; cdecl;
var
  str  : pchar;
  len : integer ;
  remote : PREMOTE_DBMS;
begin
    // pointer to target connect structure

    remote := PREMOTE_DBMS(srv_getuserdata(srvproc));

    // Is there a REMOTE_DBMS structure to clean-up?
    //
    if (remote <> nil) then
    begin
        // Is there a live dbproc?
        //
        if (remote^.dbproc <> nil) then
        begin
            dbclose(remote^.dbproc);
        end;
        dbfreelogin(remote^.login);
        srv_free(remote);
    end;

	 // Display info on console
	 //
	  str := srv_pfield(srvproc, SRV_CPID, @len);
    str[len] := #0;
  	writeln('Client connection closed, process ID: ', str);

    result := (SRV_CONTINUE);
end;

function lang_execute(srvproc : PSRV_PROC):integer; cdecl;
var
  rmt_dbms : PREMOTE_DBMS ;  // the remote database pointer
  rmtproc : PDBPROCESS; // our DBPROCESS pointer
  query : PDBCHAR ;      // pointer to language buffer
  query_len : integer ;          // length of query
  status : integer ;             // status of dblib calls
begin
    // Get the remote dbms pointer we saved in the srvproc via
    // srv_setuserdata.
    //
    rmt_dbms := PREMOTE_DBMS(srv_getuserdata(srvproc));

    // Get the pointer to the remote DBPROCESS
    //
    rmtproc := rmt_dbms^.dbproc;

    // Get the pointer to the client language request command buffer.
    //
    query := srv_langptr(srvproc);

    // See if the previous command was a 'bulk insert' command
    //
    if (rmt_dbms^.bulk_mode) then
    begin
        // Get length of the SQL command.
        //
        query_len := srv_langlen(srvproc);

        // If length of data is zero, then send a zero length buffer
        // to the destination SQL Server.  This is required in order to
        // signal the SQL Server that no more data follows.
        //
        if (query_len = -1) then query_len := 0;

        // Place buffer into target SQL server's buffer.  Use
        // dbfcmd() to pass all binary data from the language buffer on to
        // the SQL Server.
        //
        status := dbfcmd(rmtproc, query, query_len);

        rmt_dbms^.bulk_mode := FALSE;
    end
    else begin
        // Let's check for 'insert bulk' request
        //
        if (srv_langlen(srvproc) > (sizeof(BULK_CMD) - 1)) then
            if (StrLIComp(query, BULK_CMD, (sizeof(BULK_CMD) - 1)) = 0) then
                rmt_dbms^.bulk_mode := TRUE;

            // Place buffer into target SQL server's buffer.
            //
            status := dbcmd(rmtproc, query);
    end;

    // If previous DBLIB call successful, send command buffer to SQL Server.
    //
    if (status = SUCCEED) then
    begin    // if previous DBLIB call successful
        status := dbsqlexec(rmtproc);
    end;
    if (not SRV_GOT_ATTENTION(srvproc) and  (status = SUCCEED)) then
    begin
        //
        // Get the remote dbms results and pass them back to
        // client.
        //
        handle_results(rmtproc, srvproc);
    end
    else begin
        //
        // If an attention event was issued or the dbsqlexec failed,
        // acknowledge with senddone.
        //
        if (DBDEAD(rmtproc)) then
        begin
            writeln('thread shutting down');
            srv_sendmsg(srvproc, SRV_MSG_ERROR, REMOTE_FAIL,
                        23, 17, nil, 0, 0,
                        'Remote Server connection no longer active: thread shutting down'
                        , SRV_NULLTERM);
            srv_senddone(srvproc, SRV_DONE_FINAL or SRV_DONE_ERROR,
                         0, 0);
            srv_event(srvproc, SRV_DISCONNECT, nil);
        end
        else begin
            srv_senddone(srvproc, SRV_DONE_FINAL, 0, 0);
        end;
    end;
    result := SRV_CONTINUE;
end;

function handle_results(rmtproc : PDBPROCESS ; srvproc : PSRV_PROC):integer; cdecl;
var
    cols : shortint ;             // data columns returned
    i : integer ;                  // index variable
    results_sent : BOOL ;      // number of result sets sent
    gotcompute : BOOL ;        // COMPUTE row indicator
    paramarray : PRetParams;
    returnvalue : RETCODE ;    // value returned from dblib call
	  dbcol : TDBCOL	;			// column metadata structure
	  typeinfo : TTYPEINFO;	// used to send metadata in usertype
	  dbcolsize : integer ;			// size of DBCOL struct
	  bRowsAffected : BOOL ;		// was command one that affects or returns rows
	  nRowsAffected : DBINT ;	// result of DBCOUNT
	  numeric : DBNUMERIC ;		// structure to hold precision and scale for numeric cols
	  collen : shortint;		// holder for col data length
	  retlen : DBINT	;			// for sending output params
	  rpc_paramtype : DBINT	;	// for sending output params
    needFilter : Bool;
    Filtered : boolean;
    REMOTE_DBMS : PREMOTE_DBMS;
begin
    collen :=0;

    results_sent := FALSE;
    gotcompute := FALSE;
	  bRowsAffected := FALSE;
	  nRowsAffected := 0;
    Filtered := false;
    REMOTE_DBMS :=PREMOTE_DBMS(srv_getuserdata(srvproc));
    paramarray := @REMOTE_DBMS^.retparams;

	// initialize the DBCOL structure
	  dbcolsize := sizeof(DBCOL);
	  fillchar(dbcol, dbcolsize,0);
	  dbcol.SizeOfStruct := dbcolsize;

	  // initialize numeric structure
	  fillchar(numeric, sizeof(DBNUMERIC),0);

    // Process the results from the remote DBMS.
    // Since a command may consist of multiple commands or a single
    // command that has multiple sets of results, we'll loop through
    // each results set.
    //
    while (TRUE) do
    begin
        returnvalue := dbresults(rmtproc);
        if (returnvalue = NO_MORE_RESULTS) then
        begin
            break;
        end;

        // Check to see if the client has sent an attention event.  If
        // so, simply discard data from remote server
        //
        if (SRV_GOT_ATTENTION(srvproc)) then
        begin
    		  dbcancel(rmtproc);	// See attn_handler comments
        	continue;
        end;

        //
        // If this is the second time through the loop,
        // send a completion message to the client
        // for the previous results sent.
        //
        if (results_sent = TRUE) then
        begin

            // If there are some COMPUTE rows, send a message
            // to the client that Data Services Library doesn't yet handle them.
            //
            if (gotcompute = TRUE) then
            begin
                gotcompute := FALSE;
                srv_sendmsg(srvproc, SRV_MSG_ERROR, COMPUTE_ROW,
                            0, 0, nil, 0, 0,
                          'Data Services library can''t handle COMPUTE rows.',
                            SRV_NULLTERM);
            end;

            // If the previous batch was one that may
            // have affected rows, set the DONE status
            // accordingly.
            //
            if (bRowsAffected) then
            begin
                srv_senddone(srvproc, SRV_DONE_MORE  or  SRV_DONE_COUNT,
                             0, nRowsAffected);
            end else
                srv_senddone(srvproc, SRV_DONE_MORE, 0,
                            nRowsAffected);

        end;

        needFilter := checkFilter(PREMOTE_DBMS(srv_getuserdata(srvproc)));

        // How many data columns are in the row?
        // Non-'select' statements will have 0 columns.
        //
        cols := dbnumcols(rmtproc);

        // Build the row description for the client return.
        //
        for i := 1 to cols do
        begin
            //  Call 'srv_describe()' for each column in the row.
			//  dbcolntype is used to preserve the nilability information
			//	that is lost by dbcoltype.
            //
            srv_describe(srvproc, i, dbcolname(rmtproc, i), SRV_NULLTERM,
                         dbcolntype(rmtproc, i), dbcollen(rmtproc, i),
                         dbcolntype(rmtproc, i), dbcollen(rmtproc, i),
                         nil);

			// Now pack additional col metadata into the usertype
			// Note this code below does 'SQL 6.0' style packing used by DB-Lib,
			// and the ODS gateway ODBC driver if the resources DLL is set to use it
			// 'ODBC-style' metadata encoding uses a different structure, not shown here.
			// See ODS Programmer's Reference for more details.
			// get column metadata
			dbcolinfo(rmtproc, CI_REGULAR, i, 0, @dbcol);

			// reset to 0
      Integer(typeinfo):=0;

			// Set user type
			if (dbcol.UserType < 0) then
				typeinfo.typeid := 0 else
				typeinfo.typeid := word(dbcol.UserType);

			if (dbcol.Identity = true) then
			   	typeinfo.flags := typeinfo.flags or 16;

			if (dbcol._Null = 1) then
			   	typeinfo.flags := typeinfo.flags or 1
			else if (dbcol._Null = DBUNKNOWN) then
			   	typeinfo.flags := typeinfo.flags or 1;

			if (dbcol.CaseSensitive = 1) then
			   	typeinfo.flags:= typeinfo.flags or 2
			else if (dbcol.CaseSensitive = DBUNKNOWN) then
			   	typeinfo.flags:= typeinfo.flags or 2;

			if (dbcol.Updatable = 1) then
				typeinfo.flags:= typeinfo.flags or 4
			else if (dbcol.Updatable = 1) then
				typeinfo.flags:= typeinfo.flags or 8;

			srv_setutype(srvproc, i, Integer(typeinfo));

			// If column is a decimal or numeric, need to setup a valid precision and
			// scale.  Normally this would be provided by dbdata() prior to srv_sendrow().
			// But if there are no rows in the result set, srv_sendrow() will not
			// be called, and ODS will send the header when srv_senddone() is called.
			if ((dbcol._Type = SQLNUMERIC)  or  (dbcol._Type = SQLDECIMAL)) then
				begin
				  numeric.precision := dbcol.Precision;
				  numeric.scale := dbcol.Scale;
          srv_setcoldata(srvproc, i, @numeric);
				end;
      end;

        // Send each row from the remote DBMS to the client.
        //
        while (TRUE) do
        begin
            returnvalue := dbnextrow(rmtproc);
            if (returnvalue = NO_MORE_ROWS) then
            begin
                break;
            end;

            // If it's not a regular row, it's a COMPUTE row.
            // This SQL extension is particular to Sybase
            // TRANSACT-SQL and is not yet supported.
            //
            if (DBROWTYPE(rmtproc) <> REG_ROW) then
            begin
                gotcompute := TRUE;
                continue;
            end else
                gotcompute := FALSE;

            if needFilter then
              if filterThis(rmtproc,REMOTE_DBMS) then
              begin
                Filtered:=true;
                continue;
              end;
            // The row description is built.  Move the
            // rows from the remote server to the client.
            //
            for i := 1 to cols do
            begin
              collen := dbdatlen(rmtproc, i);
              srv_setcollen(srvproc, i, collen);
				// special handling for the srv_setcoldata pointer if the value is nil numeric
				// dbdata does not point to a valid numeric structure in this case
				// so point instead to the numeric structure set up at srv_describe time
		 		      if ((dbcoltype(rmtproc, i) = SQLDECIMAL)  or  (dbcoltype(rmtproc, i) = SQLNUMERIC))
		 			      and (collen = 0) then
					    begin
					      srv_setcoldata(srvproc, i, @numeric);
					    end
				      else
                	srv_setcoldata(srvproc, i, dbdata(rmtproc, i));
            end;

            // Check to see if the client has issued an attention event.
            // If so, discard data from the remote server.
            //
            if (SRV_GOT_ATTENTION(srvproc)) then
            begin
    			    dbcancel(rmtproc);	// See attn_handler comments
              continue;
            end;

	      		// Now put the row in the ODS output buffer
			      srv_sendrow(srvproc);
        end;
        // Check to see if any parameter were returned from
        // the remote DBMS.  If so, pass them through to the
        // client.
        for i := 1 to dbnumrets(rmtproc) do
        begin
            //
            // If the return parameters are a result of
            // an rpc, we used srv_paramset() to set the return
            // value.  If the return parameters are not the
            // result of an rpc, we use srv_returnval().
            //
			    retlen := dbretlen(rmtproc, i);
			    rpc_paramtype := dbrettype(rmtproc, i);

			  // special handling for decimal types.  need to add 2 bytes for precision & scale
		  	// from what is returned by dbretlen
   			  if ((rpc_paramtype = SQLNUMERIC)	 or  (rpc_paramtype = SQLDECIMAL)) then
					  retlen := retlen + 2;
          if (srv_rpcname(srvproc, nil) <> nil) then
          begin
                //
                // The current rpc may have three parameters, but
                // only the first and third are return parameters.
                // This means that dbnumrets() returns two parameters,
                // not three.  The first call to dbretdata() refers to
                // the rpc's first parameter, and the second call to
                // dbretdata() refers to the rpc's third parameter.
                // To handle this, we map each return parameter to
                // its original parameter so we can later reset the
                // return value of the correct return parameters in
                // handle_results().
                //
                srv_paramset(srvproc, paramarray^[i], dbretdata(rmtproc, i), retlen);
            end
            else begin
                srv_returnval(srvproc, dbretname(rmtproc, i), SRV_NULLTERM,
                              SRV_PARAMRETURN, rpc_paramtype,
                              retlen, retlen,dbretdata(rmtproc, i));
            end;
        end;
        // Check to see if we got a return status code from the
        // remote DBMS.  Pass it through to the client.
        //
        if (dbhasretstat(rmtproc)) then
           srv_sendstatus(srvproc, dbretstatus(rmtproc));

        // If the command was one where count is meaningful
        // send the srv_senddone message accordingly.
        //
		    bRowsAffected := dbiscount(rmtproc);
		    nRowsAffected := DBCOUNT(rmtproc);

        // Set flag so that we will send a completion
        // message for the current set of results.
        //
        results_sent := TRUE;

    end;

    // If there are some COMPUTE rows, send a message
    // to the client that Open Services Library doesn't handle them yet.
    //
    if (gotcompute = TRUE) then
    begin
        gotcompute := FALSE;
        srv_sendmsg(srvproc, SRV_MSG_ERROR, COMPUTE_ROW, 0,
                    0, nil, 0, 0,
                    'Data Services Library can''t handle COMPUTE rows.',
                    SRV_NULLTERM);
    end;

    if Filtered then
    begin
      Filtered := false;
      srv_sendmsg(srvproc, SRV_MSG_ERROR, FILTER_ROW, 0,
                    0, nil, 0, 0,
                    'Some rows have been filtered.',
                    SRV_NULLTERM);
    end;
    // Send the final done packet for the execution of the command batch.
    //
    // If the previous batch was one that may
    // have affected rows, set the DONE status
    // accordingly.
    //
	  if (bRowsAffected) then
    begin
    	srv_senddone(srvproc, SRV_DONE_FINAL  or  SRV_DONE_COUNT,
                    0, nRowsAffected);
   	end
    else
       	srv_senddone(srvproc, SRV_DONE_FINAL, 0,
                	nRowsAffected);

    result := SUCCEED;
    writeln('done handle results!');
end;

function remotemsgs(dbproc : PDBPROCESS ; msgno :integer; msgstate :integer ;
               severity : integer ; msgtext,srvname,procname : pchar;
					     line : word):integer; cdecl;
var
  srvproc : PSRV_PROC;
begin
    // If a remote DBMS error was received during the remote
    // open, the dbproc is nil and a message is sent back on the
    // most recent srvproc.
    //
    if (dbproc = nil) then
    begin
        srvproc := Newsrvproc;
    end
    else
    begin
        srvproc := PSRV_PROC(dbgetuserdata(dbproc));
        if (srvproc=nil) then
        begin
            //
            // An error was received after the dbproc was assigned, but
            // before we were able to associate our srvproc.
            //
            srvproc := Newsrvproc;
        end;
    end;
    if (severity < 10) then
    begin    // if informational message
        srv_sendmsg(srvproc, SRV_MSG_INFO, msgno, severity,
                    msgstate, nil, 0, 0, msgtext, SRV_NULLTERM);
    	  result := 0;
        exit;
    end;

	  // Trap login fail message
	  if (msgno = REMOTE_FAIL) then
    begin
        // Send a message to the client that
        // the remote connection failed.
        //
        srv_sendmsg(srvproc, SRV_MSG_ERROR, msgno, severity,
                    msgstate, nil, 0, 0,
                    'Login to remote DBMS failed (dbopen).', SRV_NULLTERM);
	  end;

	  // must be an error message
    srv_sendmsg(srvproc, SRV_MSG_ERROR, msgno, severity,
    	msgstate, nil, 0, 0, msgtext, SRV_NULLTERM);

    result := 0;
end;

function remoteerr(dbproc : PDBPROCESS ;  severity, dberr, oserr : integer;
              dberrstr, oserrstr : pchar):integer; cdecl;
var
  srvproc : PSRV_PROC;
begin
    srvproc := nil;
    // If the DBLIB process is dead or we get a DBLIB error SQLESMSG
	  // ('General SQL Server Error:...') then simply ignore it.  The error
    // message has already been sent to the client.
    //
    if (dberr = SQLESMSG) then
    begin
      result := INT_CANCEL;
      exit;
    end;

    //
    // A remote DBMS error may have been issued during the remote
    // open. In this case, the dbproc will be nil and a message
    // will be sent on the most recent srvproc.
    //
    if (dbproc = nil) then
    begin
        srvproc := Newsrvproc;
    end
    else
    begin
        srvproc := PSRV_PROC (dbgetuserdata(dbproc));
        if (srvproc= nil) then
        begin
            // An error was issued after the dbproc was assigned but before
            // we were able to associate our srvproc.
            //
            srvproc := Newsrvproc;
        end;
    end;

	  // Trap connection failure error
	  if (dberr = SQLECONN) then
    begin
        // Send a message to the client that
        // the remote connection failed.
        //
        srv_sendmsg(srvproc, SRV_MSG_ERROR, REMOTE_FAIL, severity,
                    0, nil, 0, 0,
                    'Unable to establish connection to remote DBMS (dbopen).', SRV_NULLTERM);

        result := INT_CANCEL;
        exit;
	  end;

    //
    // Send error message to client.
    //
    srv_sendmsg(srvproc, SRV_MSG_ERROR, REMOTE_MSG,
                severity, 0, nil, 0, 0,
					 dberrstr, SRV_NULLTERM);

    if (oserr <> DBNOERR) then
    begin
        srv_sendmsg(srvproc, SRV_MSG_ERROR, REMOTE_MSG,
                    severity, 0, nil, 0, 0,
						        oserrstr, SRV_NULLTERM);
    end;
    result := INT_CANCEL;
end;

function  checkFilter(REMOTE_DBMS : PREMOTE_DBMS):boolean;
var
  i,cols : integer;
  rmtproc: PDBPROCESS;
begin
  REMOTE_DBMS^.need_filter:=false;
  rmtproc:= REMOTE_DBMS^.dbproc;
  cols := dbnumcols(rmtproc);
  REMOTE_DBMS^.filterColIndex:=0;
  for i := 1 to cols do
  begin
    if StrIComp(dbcolname(rmtproc, i),'khlb')=0 then
    begin
      REMOTE_DBMS^.need_filter:=true;
      REMOTE_DBMS^.filterColIndex:=i;
      break;
    end;
  end;
  result := REMOTE_DBMS^.need_filter;
end;

function  filterThis(rmtproc: PDBPROCESS; REMOTE_DBMS : PREMOTE_DBMS):boolean;
var
  col : integer;
  data : Pchar;
begin
  col := REMOTE_DBMS^.filterColIndex;
  data := Pchar(dbdata(rmtproc, col));
  if data<>nil then
  begin
    result := data^='3'; 
  end else
    result := false;
end;

end.
