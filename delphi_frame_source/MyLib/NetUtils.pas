unit NetUtils;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> NetUtils
   <What> 有关网络的工具
   <Written By> Huang YanLai
   <History>
**********************************************}


interface

uses Windows, SysUtils, WinSock, Nb30;

type
  TAdapter = packed record
     adapt : TADAPTERSTATUS;
     NameBuff : array[0..30-1] of Char;
  end;

{
  <Function>GetMACAddr
  <What>获得网卡地址
  <Params>
    -
  <Return>
  <Exception>
}
function GetMACAddr : string;

procedure SocketError(ErrorCode : Integer; const Msg : string);

procedure CheckSocketCall(ReturnCode : Integer; const Msg : string);

const
  DefaultMaxLength = 8*1024;

type
  EKSSocketError = class(Exception);

  TKSUDPMessage = class(TObject)
  private
    FAddr    :  TSockAddr;
    FMessage: string;
    function    GetIP: string;
    function    GetPort: Word;
    procedure   SetIP(const Value: string);
    procedure   SetPort(const Value: Word);
  public
    constructor Create;
    property    Message : string read FMessage write FMessage;
    property    IP : string read GetIP write SetIP;
    property    Port : Word read GetPort write SetPort;
  end;

  TKSUDPSocket = class
  private
    FPort: Word;
    FSocket : TSOCKET;
    FAddr : TSockAddr;
    FPeerPort: Integer;
    FPeerIP: string;
    FMaxMessageLength: LongWord;
  public
    // 创建套接字，绑定到指定的端口
    constructor Create(APort : Word=0);
    destructor  Destroy; override;
    // 设置需要通讯的目的地址，方便使用Send
    procedure   SetPeer(const ToIP : string; ToPort : Word);
    // 向SetPeer设定的目的地址发送消息，返回实际发送的字节数。
    function    Send(Buffer : Pointer; Count : Longword) : Integer; overload;
    // 向指定的目的地址发送消息，地址由ToIP,ToPort指定，返回实际发送的字节数。
    function    SendTo(const ToIP : string; ToPort : Word; Buffer : Pointer; Count : Longword) : Integer; overload;
    // 向指定的目的地址发送消息，地址由ToAddr指定，返回实际发送的字节数。
    function    SendTo(var ToAddr : TSockAddr; Buffer : Pointer; Count : Longword) : Integer; overload;
    // 检查是否有数据到达,TimeOut的单位是毫秒
    function    IsDataArrived(TimeOut : LongWord) : Boolean;
    // 阻塞方式接收数据，返回接收到的字节数
    function    Receive(Buffer : Pointer; MaxCount : Longword) : Integer; overload;
    // 阻塞方式接收数据，返回接收到的字节数。FromAddr返回消息的来源地址
    function    Receive(Buffer : Pointer; MaxCount : Longword; var FromAddr : TSockAddr) : Integer; overload;
    // 发送字符串消息，目的地址已经由SetPeer设置好了
    function    SendMessage(const Msg : string) : Integer;
    // 接收字符串消息，MaxLength代表最大的字符串长度
    function    ReceiveMessage(MaxLength : Integer=DefaultMaxLength) : string;
    // 发送一个字符串消息，目的地址和消息由MsgObj对象指定
    procedure   Send(MsgObj : TKSUDPMessage); overload;
    // 返回接收到的消息，消息和来源地址保存到MsgObj对象里面。
    procedure   Receive(MsgObj : TKSUDPMessage); overload;
    // 使得可以广播消息
    procedure   EnableBroadcast;
    // 获得最大的消息大小
    function    GetMaxPackageSize : Integer;
    // 广播消息
    function    Broadcast(ToPort : Word; Buffer : Pointer; Count : Longword) : Integer;
    property    Port : Word read FPort;
    property    Socket : TSOCKET read FSocket;
    property    PeerIP : string read FPeerIP;
    property    PeerPort : Integer read FPeerPort;
    property    MaxMessageLength : LongWord read FMaxMessageLength write FMaxMessageLength;
  end;

resourcestring
  SSendOutOfLength = '发送数据的长度超过允许的范围';
  sWindowsSocketError = 'Windows socket error: %s (%d), on API ''%s''';

implementation

uses Registry, Classes;

{
function GetMACAddr : string;
const
  MaxLength = 6;
var
  reg : TRegistry;
  Buffer : array[0..MaxLength-1] of char;
  TextBuffer : array[0..MaxLength*2] of char;
  count : integer;
begin
  reg := TRegistry.Create(KEY_READ);
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKeyReadOnly('\Software\Description\Microsoft\Rpc\UuidTemporaryData');
    fillChar(Buffer,MaxLength,0);
    fillChar(TextBuffer,MaxLength*2+1,0);
    count := reg.ReadBinaryData('NetworkAddress',Buffer,MaxLength);
    assert(count=MaxLength);
    BinToHex(Buffer,TextBuffer,count);
    Result := TextBuffer;
  finally
    reg.free;
  end;
end;
}

(*
function GetMACAddr : string;
var
  Ncb : TNCB ;
  uRetCode : Char;
  lenum : TLANAENUM;
  I, Len : Integer;
  Adapter : TAdapter;
begin
  Result := '';

  FillChar(Ncb, sizeof(Ncb), 0);
  Ncb.ncb_command := Char(NCBENUM);
  Ncb.ncb_buffer := @lenum;
  Ncb.ncb_length := SizeOf(lenum);
  {uRetCode := }Netbios(@Ncb);
  Len := Byte(lenum.length);

  for I:=0 to Len do
  begin
    FillChar(Ncb, sizeof(Ncb), 0);
    Ncb.ncb_command := Char(NCBRESET);
    Ncb.ncb_lana_num := lenum.lana[i];

    {uRetCode := }Netbios(@Ncb);

    FillChar(Ncb, sizeof(Ncb), 0);
    Ncb.ncb_command := Char(NCBASTAT);
    Ncb.ncb_lana_num := lenum.lana[i];

    strcopy(PChar(@Ncb.ncb_callname),'*               ' );
    Ncb.ncb_buffer := @Adapter;
    Ncb.ncb_length := sizeof(Adapter);

    uRetCode := Netbios(@Ncb);

    if (Byte(uRetCode)= 0) then
    begin
      Result := Format('%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x',
          [
            Byte(Adapter.adapt.adapter_address[0]),
            Byte(Adapter.adapt.adapter_address[1]),
            Byte(Adapter.adapt.adapter_address[2]),
            Byte(Adapter.adapt.adapter_address[3]),
            Byte(Adapter.adapt.adapter_address[4]),
            Byte(Adapter.adapt.adapter_address[5])
          ]);
      Break;
    end;
  end;
end;
*)

function GetMACAddr : string;
var
  Ncb : TNCB ;
  uRetCode : Char;
  I : Integer;
  Adapter : TAdapter;
begin
  Result := '';

  for I:=0 to 255 do
  begin
    FillChar(Ncb, sizeof(Ncb), 0);
    Ncb.ncb_command := Char(NCBRESET);
    Ncb.ncb_lana_num := Char(I);

    Netbios(@Ncb);

    FillChar(Ncb, sizeof(Ncb), 0);
    Ncb.ncb_command := Char(NCBASTAT);
    Ncb.ncb_lana_num := Char(I);

    strcopy(PChar(@Ncb.ncb_callname),'*               ' );
    Ncb.ncb_buffer := @Adapter;
    Ncb.ncb_length := sizeof(Adapter);

    uRetCode := Netbios(@Ncb);

    if (Byte(uRetCode)= 0) then
    begin
      Result := Format('%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x',
          [
            Byte(Adapter.adapt.adapter_address[0]),
            Byte(Adapter.adapt.adapter_address[1]),
            Byte(Adapter.adapt.adapter_address[2]),
            Byte(Adapter.adapt.adapter_address[3]),
            Byte(Adapter.adapt.adapter_address[4]),
            Byte(Adapter.adapt.adapter_address[5])
          ]);
      Break;
    end;
  end;
end;

procedure SocketError(ErrorCode : Integer; const Msg : string);
begin
  if ErrorCode=0 then
    ErrorCode:=WSAGetLastError;
  raise EKSSocketError.CreateResFmt(@sWindowsSocketError,
      [SysErrorMessage(ErrorCode), ErrorCode, Msg]);
end;

procedure CheckSocketCall(ReturnCode : Integer; const Msg : string);
begin
  if ReturnCode=SOCKET_ERROR then
    SocketError(0,Msg);
end;

procedure Startup;
var
  ErrorCode: Integer;
  WSAData : TWSAData;
begin
  ErrorCode := WSAStartup($0101, WSAData);
  if ErrorCode <> 0 then
    SocketError(ErrorCode, 'WSAStartup');
end;

procedure Cleanup;
var
  ErrorCode: Integer;
begin
  ErrorCode := WSACleanup;
  if ErrorCode <> 0 then
    SocketError(ErrorCode, 'WSACleanup');
end;

{ TKSUDPSocket }

constructor TKSUDPSocket.Create(APort: Word);
var
  Addr : TSockAddr;
begin
  FPort := APort;
  FSocket := WinSock.socket(AF_INET, SOCK_DGRAM	, IPPROTO_IP);
  if FSocket=INVALID_SOCKET then
    SocketError(0, 'socket');
  with Addr do
  begin
    sin_family := AF_INET;
    sin_port := htons(FPort);
    sin_addr.S_addr  := INADDR_ANY;
    fillchar(sin_zero,sizeof(sin_zero),0);
  end;
  CheckSocketCall(
    WinSock.bind(FSocket,Addr,Sizeof(Addr)),
    'bind');
  FMaxMessageLength := GetMaxPackageSize;
  if FMaxMessageLength>DefaultMaxLength then
    FMaxMessageLength:=DefaultMaxLength;
end;

destructor TKSUDPSocket.Destroy;
begin
  WinSock.closesocket(FSocket);
  inherited;
end;

function TKSUDPSocket.IsDataArrived(TimeOut : LongWord): Boolean;
var
  FDSet: TFDSet;
  TimeVal: TTimeVal;
  I : Integer;
begin
  FD_ZERO(FDSet);
  FD_SET(FSocket, FDSet);
  TimeVal.tv_sec := TimeOut div 1000;
  TimeVal.tv_usec := TimeOut mod 1000;
  I := WinSock.select(0, @FDSet, nil, nil, @TimeVal);
  Result := I>0;
  CheckSocketCall(I,'select');
end;

function TKSUDPSocket.Receive(Buffer: Pointer;
  MaxCount: Longword): Integer;
var
  Addr : TSockAddr;
begin
  Result := Receive(Buffer,MaxCount, Addr);
end;

function TKSUDPSocket.Receive(Buffer: Pointer; MaxCount: Longword;
  var FromAddr: TSockAddr): Integer;
var
  FromSize : Integer;
begin
  FromSize := SizeOf(FromAddr);
  Result := WinSock.recvfrom(FSocket,Buffer^,MaxCount, 0, FromAddr,FromSize);
  CheckSocketCall(Result,'recvfrom');
end;

function TKSUDPSocket.ReceiveMessage(MaxLength: Integer): string;
var
  Len : Integer;
begin
  SetLength(Result,MaxLength);
  Len := Receive(PChar(Result),MaxLength);
  SetLength(Result,Len);
end;

function TKSUDPSocket.Send(Buffer: Pointer; Count: Longword): Integer;
begin
  Result := SendTo(FAddr, Buffer, Count);
end;

function TKSUDPSocket.SendTo(const ToIP: string; ToPort: Word;
  Buffer: Pointer; Count: Longword): Integer;
var
  ToAddr: TSockAddr;
begin
  with ToAddr do
  begin
    sin_family := AF_INET;
    sin_port := htons(ToPort);
    sin_addr.S_addr  := inet_addr(PChar(ToIP));
    Fillchar(sin_zero,sizeof(sin_zero),0);
  end;
  Result := SendTo(ToAddr, Buffer, Count);
end;

function TKSUDPSocket.SendMessage(const Msg: string): Integer;
begin
  Result := Send(PChar(Msg),Length(Msg));
end;

function TKSUDPSocket.SendTo(var ToAddr: TSockAddr; Buffer: Pointer;
  Count: Longword): Integer;
begin
  Result := WinSock.sendto(FSocket,
          Buffer^,
          Count,
          0,
          ToAddr,
          Sizeof(ToAddr));
  CheckSocketCall(Result, 'sendto');
end;

procedure TKSUDPSocket.SetPeer(const ToIP: string; ToPort: Word);
begin
  FPeerIP := ToIP;
  FPeerPort := ToPort;
  with FAddr do
  begin
    sin_family := AF_INET;
    sin_port := htons(ToPort);
    sin_addr.S_addr  := inet_addr(PChar(ToIP));
    Fillchar(sin_zero,sizeof(sin_zero),0);
  end;
end;

procedure TKSUDPSocket.Receive(MsgObj: TKSUDPMessage);
var
  Len : Integer;
begin
  SetLength(MsgObj.FMessage,MaxMessageLength);
  Len := Receive(PChar(MsgObj.FMessage),MaxMessageLength,MsgObj.FAddr);
  SetLength(MsgObj.FMessage,Len);
end;

procedure TKSUDPSocket.Send(MsgObj: TKSUDPMessage);
var
  Len1,Len2 : Integer;
begin
  Len1 := Length(MsgObj.FMessage);
  Len2 := SendTo(MsgObj.FAddr,PChar(MsgObj.FMessage),Len1);
  if Len2<Len1 then
    raise EKSSocketError.Create(SSendOutOfLength);
end;

procedure TKSUDPSocket.EnableBroadcast;
var
  EnableFlag : integer;
begin
  EnableFlag := 1;
  CheckSocketCall(
    WinSock.setsockopt(FSocket,SOL_SOCKET,SO_BROADCAST,@EnableFlag,sizeof(EnableFlag)),
    'setsockopt');
end;

const
  SO_MAX_MSG_SIZE =  $2003;

function TKSUDPSocket.GetMaxPackageSize: Integer;
var
  ASize : Integer;
begin
  ASize := SizeOf(Result);
  CheckSocketCall(
    WinSock.getsockopt(FSocket,SOL_SOCKET,SO_MAX_MSG_SIZE,PChar(@Result), ASize),
    'getsockopt'
    );
end;

function TKSUDPSocket.Broadcast(ToPort: Word; Buffer: Pointer;
  Count: Longword): Integer;
var
  ToAddr: TSockAddr;
begin
  with ToAddr do
  begin
    sin_family := AF_INET;
    sin_port := htons(ToPort);
    //LongWord(sin_addr.S_addr) := INADDR_BROADCAST;
    sin_addr.S_addr := LongInt(INADDR_BROADCAST);
    Fillchar(sin_zero,sizeof(sin_zero),0);
  end;
  Result := SendTo(ToAddr, Buffer, Count);
end;

{ TKSUDPMessage }

constructor TKSUDPMessage.Create;
begin
  with FAddr do
  begin
    sin_family := AF_INET;
    sin_port := WinSock.htons(0);
    sin_addr.S_addr := INADDR_ANY;
    fillchar(sin_zero,sizeof(sin_zero),0);
  end;
end;

function TKSUDPMessage.GetIP: string;
begin
  Result := WinSock.inet_ntoa(FAddr.sin_addr);
end;

function TKSUDPMessage.GetPort: Word;
begin
  Result := WinSock.ntohs(FAddr.sin_Port);
end;

procedure TKSUDPMessage.SetIP(const Value: string);
begin
  FAddr.sin_addr.S_addr := WinSock.inet_addr(PChar(Value));
end;

procedure TKSUDPMessage.SetPort(const Value: Word);
begin
  FAddr.sin_Port := WinSock.htons(Value);
end;

initialization
  Startup;

finalization
  Cleanup;

end.
