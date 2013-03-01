program Gateway;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  openServer,
  GateCBS in 'GateCBS.pas';

const
  EXIT_OK =0;
  EXIT_ERROR =1;
  RegistryName = 'HYLGateway';
  SrvrName = 'TestServer';

var
  config : PSRV_CONFIG ; // The configuration structure
  server : PSRV_SERVER ; // The service process
  exitcode : integer;
begin
  exitcode := EXIT_ERROR;
  (*
  // Read any command line arguments.
  //
  getargs(argc, argv);
  *)
  // Send the name retrieved to the gateway's DLL module
  //
  remote_server := SrvrName;

  // Allocate a configuration structure that is used to initialize
  // the Open Data Services application
  //
  config := srv_config_alloc();

  // Allow 20 connections at a time.
  //
  srv_config(config, SRV_CONNECTIONS, '20', SRV_NULLTERM);

  // Set the log file.
  //
  srv_config(config, SRV_LOGFILE, 'gateway.log', SRV_NULLTERM);

  // The gateway will not convert data source strings in order to allow
  // SQL Server and DB-libraray to coordinate on the codepage as usual.
  //
  srv_config(config, SRV_ANSI_CODEPAGE, 'TRUE', SRV_NULLTERM);

  // Install the Open Data Services error handler.
  //
  srv_errhandle(chk_err);

  // Initialize the gateway and save the server handle
  // so it can be used in later functions.
  //
  server := srv_init(config, RegistryName, SRV_NULLTERM);
  if (server = nil) then
  begin
      writeln('Unable to initialize Gateway.');
      readln;
      //ExitProcess(exitcode);
      exit;
  end;

  // When starting the gateway, initialize the remote server structure.
  // This is done in the init_server() function.
  // All the other event handlers are also defined in the init_server()
  // function.
  //
  srv_handle(server, SRV_START, svr_handlerProc(@init_server));

  // Now everything's ready to go with our gateway, so we
  // start it and keep it going until we get a stop request.
  //
  srv_log(server, FALSE, ' ', SRV_NULLTERM);  // insert blank line
  srv_log(server, TRUE, 'Gateway Starting', SRV_NULLTERM);

  writeln('Gateway Starting');

  srv_run(server);
  readln;
end.