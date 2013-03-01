program Simple;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  DRTPAPI in '..\DRTPAPI.pas',
  KCDataPack in '..\KCDataPack.PAS';

const
  BufferSize = 4096;

var
  Handle : Integer;
  Recvbuffer : Array[0..BufferSize-1] of Byte;
  I : Integer;
  IP : string;
  Port : Integer;
  Encode : Integer;
begin
  KCCheckDefine;

  if not DRTPAPI.DLLLoaded then
  begin
    Writeln('Cannot Load DRTPAPI.DLL');
    Exit;
  end;

  StrCopy(Pchar(@Recvbuffer),'12345');

  if ParamCount<>3 then
  begin
    Writeln('usage:Simple [remoteIP] [remotePORT] [EncryptMethod]');
    Writeln('Press Enter...');
    Readln;
    Exit;
  end;

  if not DRTPInitialize() then           //初始化（每个进程作一次即可）
  begin
    Writeln('DRTPInitialize Failed.');
    Exit;
  end;

  //可以用DRTPGetHost得到相应ip的路由通讯服务器的编码

  //联接路由通讯服务器
  IP := ParamStr(1);
  Port := StrToInt(ParamStr(2));
  Encode := StrToInt(ParamStr(3));
  Handle:=DRTPConnect(Pchar(IP),Port,Encode);
  if  Handle=0 then
  begin
    Writeln('drtpconnect error!');
    DRTPUninitialize();
    Exit;
  end;

  if not DRTPCheckNetState(Handle,2000) then       //检测网络状态（可以省略）
  begin
    Writeln('network instability');
    DRTPClose(Handle);      //关闭联接
    DRTPUninitialize(); //释放资源
    Exit;
  end;


  //发送数据到目的网关（编号为0），主功能号800，优先级为2，不指定路由
  if not DRTPSend(Handle,0,800,PChar(@Recvbuffer),strlen(PChar(@Recvbuffer))+1,2,false) then
  begin
    Writeln('drtpsend error!');
    DRTPClose(Handle);  //关闭联接
    DRTPUninitialize();           //释放资源
    Exit;
  end;

  Writeln('waiting for data arriving.....');
  while not DRTPCheckDataArrived(Handle,1000) do ;   //检测是否有数据到达（可以省略）

  Writeln('receve data...................');
  StrCopy(PChar(@Recvbuffer),'');
  I:=DRTPReceive(Handle,PChar(@Recvbuffer),4096,0);        //接收数据

  if I<=0 then
  begin
    DRTPGetLastError(Handle,PChar(@Recvbuffer),4096);              //取得出错信息
    Writeln('error:%s',PChar(@Recvbuffer));
  end
  else
    Writeln(Format('recvdata(%d bytes):%s',[I,Pchar(@Recvbuffer)]));
  DRTPClose(Handle);      //关闭联接
  DRTPUninitialize();        //释放资源

  Writeln('Press Enter...');
  Readln;
end.
