unit CardDll;

interface

uses
    Windows, Messages, SysUtils, Classes, Db;

const
    //****************************************************************************
    //动态库定义
    DllCardEngine = 'CardEngine.dll';
    DllDecard = 'dcrf32.dll';
var
    icdev: longint; //COM1,COM2,ParallelPort 公用设备句柄
    st: smallint;

function Wis_Init: Integer; cdecl; far; external DllCardEngine name 'Wis_Init';
function Wis_GetVersion: string; cdecl; far; external DllCardEngine name 'Wis_GetVersion';
function Wis_OpenPort(port, baud: integer): Integer; cdecl; far; external DllCardEngine name 'Wis_OpenPort';
function Wis_Beep: Integer; cdecl; far; external DllCardEngine name 'Wis_Beep';

function Wis_RequestCard(cardphyid: PChar; cardtype: integer): Integer; cdecl; far; external DllCardEngine name 'Wis_RequestCard';



function Wis_ClosePort: Integer; cdecl; far; external DllCardEngine name 'Wis_ClosePort';

//**************decard driver test begin ******************************************
function dc_init(prot: integer; baud: longint): longint; stdcall; far; external DllDecard name 'dc_init';
function dc_card(icdev: longint; mode: smallint; var snr: longword): smallint; stdcall; far; external DllDecard name 'dc_card';
function dc_card_hex(icdev: longint; mode: smallint; snr: pchar): smallint; stdcall; far; external DllDecard name 'dc_card_hex';
function dc_card_double(icdev: longint; mode: smallint; var snr: longword): smallint; stdcall; far; external DllDecard name 'dc_card_double';
function dc_load_key_hex(icdev: longint; mode, secor: smallint; skey: pchar): smallint; stdcall; far; external DllDecard name 'dc_load_key_hex';
function dc_authentication(icdev: longint; mode, secor: smallint): smallint; stdcall; far; external DllDecard name 'dc_authentication';
function dc_read_hex(icdev: longint; adr: smallint; sdata: pchar): smallint; stdcall; far; external DllDecard name 'dc_read_hex';
function dc_write_hex(icdev: longint; adr: smallint; sdata: pchar): smallint; stdcall; far; external DllDecard name 'dc_write_hex';
function dc_halt(icdev: longint): smallint; stdcall; far; external DllDecard name 'dc_halt';
function dc_reset(icdev: longint; msc: smallint): smallint; stdcall; far; external DllDecard name 'dc_reset';
function dc_beep(icdev: longint; stime: smallint): smallint; stdcall; far; external DllDecard name 'dc_beep';
function dc_disp_str(icdev: longint; sdata: pchar): smallint; stdcall; far; external DllDecard name 'dc_disp_str';
function dc_getver(icdev: longint; sdata: pchar): smallint; stdcall; far; external DllDecard name 'dc_getver';
function dc_exit(icdev: longint): smallint; stdcall; far; external DllDecard name 'dc_exit';
procedure dc_quit;

//*************decard driver test end  ************************************


implementation

procedure dc_quit;
begin
    if icdev > 0 then begin
        st := dc_reset(icdev, 10);
        st := dc_exit(icdev);
        icdev := -1;
    end;
end;


end.

