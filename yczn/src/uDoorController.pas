unit uDoorController;

interface

uses Dialogs, Variants, SysUtils, OleServer, COMOBJ, ActiveX,
    Windows, Messages, Classes, Graphics, Controls, Forms,
    StdCtrls, DateUtils,
    IniFiles;
type
    DeviceArray = array of array of string;

const
    CryptKey = 'YKT54321'; //加密种子密钥
    Tag_Error = '[ERROR]';
    CONFIGFILE = 'device.ini';
    CARDLISTFILE = 'cardlist.txt';
    C10PORT = 60000;
    SYNCDATASID = 'syncdata.sid';
    GETDATASID = 'getdata.sid';
    DOWNPRIVSID = 'downpriv.sid';
    INITDEVSID = 'initdev.sid';
    UPLOADDATASID = 'uploaddata.sid';
    DEVICE_INTERNAL = 3000;
    RETRYTIMES = 5;
var
    v_wudp: Variant; //WComm_Operate对象
    strFuncData: WideString; //要发送的功能及数据
    strCmd: WideString; //要发送的指令帧
    strFrame: WideString; //返回的数据
    strRunDetail: WideString; //运行信息
    swipeDate: WideString; //日期时间
    errorNo: Integer; //故障号
    devIpAddr: WideString; // 设备ip地址
    devIpAddrHex: WideString; // 设备ip地址16进制
    devMacAddr: WideString; // 设备MAC地址
    devClock: WideString; //设备当前时钟
    devRecordCount: WideString; //设备当前记录数
    devPrivilegeCount: WideString; // 设备当前权限个数
    iniConfig: TInifile;
    IpRange: string;
    WorkingDeviceArray: TStringList;
    c10sn: string;
    c10ip: string;
    c10mask: string;
    c10gateway: string;
    c10interval: integer;
    c10doorno: string;
    datapackage: integer;
    DeviceRecords: TStringList;
    downinternal: integer;
    iTryAgain: integer;
    APP_DEBUGMODE : boolean;

procedure getWUDP();
function connectDev(devSN: WideString): WideString;
function connectDevByIP(devSN: WideString; devIP: WideString; devMask: WideString; devGateWay: WideString): boolean;
procedure connectDevices();
function getIPbySN(devSN: WideString): WideString;
procedure getRecord(devSN: integer; devIP: WideString);
function deleteRecord(devSN: WideString; recno: Integer): boolean;
procedure initDevices();
function setDeviceIP(devSN: WideString; devIP: WideString; devMask: WideString; devGateWay: WideString): boolean;
procedure writeLog(content: string);
procedure writeCardList(content: string);
procedure makeDir(dirString: string);
function getDeviceStatus(devSN: Integer): boolean;
function monitorDevice(controllerSN: Integer): string;
procedure downloadAllCard(devSN: Integer; devIP: WideString; doorNo: integer; cardList: TStringList);
procedure downloadAllCardByOne(devSN: Integer; devIP: WideString; doorNo: integer; cardList: TStringList);
function cardHexToNo(cardphyid: string): string;
function cardNoToHex(cardno: integer): string;
function cardYktToDev(cardphyid: string): string;
function NumberSort(List: TStringList; Index1, Index2: Integer): Integer;
function verifyDevClock(devSN: integer; devIP: WideString): boolean;
function getPrivilegeCount(devSN: Integer; devIP: WideString): Integer;
function getRecordCount(devSN: integer; devIP: WideString): integer;
function deletePrivilege(devSN: integer; devIP: WideString; cardphyid: string; doorNo: integer): boolean;
function cleanPrivilege(devSN: integer; devIP: WideString): boolean;
function addPrivilegeToLast(devSN: integer; devIP: WideString; cardphyid: string; doorNo: integer): boolean;
function addOrModifyPrivilege(devSN: integer; devIP: WideString; cardphyid: string; doorNo: integer): boolean;
function devAlwaysOpen(devSN: integer; devIP: WideString; devMode, devDelay: integer): boolean;


implementation

uses unit1;


function cleanPrivilege(devSN: integer; devIP: WideString): boolean;
begin
    strFuncData := '9310';
    strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //生成指令帧
    strFrame := v_wudp.udp_comm(strCmd, devIP, C10PORT); //发送指令, 并获取返回信息
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        writelog('devSN=' + IntToStr(devSN) + ',' + devIP + ',清空权限失败,ret=' + strFrame);
        result := false;
        exit;
    end;
    result := true;
end;

function addOrModifyPrivilege(devSN: integer; devIP: WideString; cardphyid: string; doorNo: integer): boolean;
begin
    strFuncData := '0711' + v_wudp.NumToStrHex(0, 2) //权限位置
    + cardYktToDev(cardphyid) //卡号
    + v_wudp.NumToStrHex(doorNo, 1) //门号
    + v_wudp.MSDateYmdToWCDateYmd('2007-8-14') //有效起始日期
    + v_wudp.MSDateYmdToWCDateYmd('2020-12-31') //有效截止日期
    + v_wudp.NumToStrHex(1, 1) //时段索引号
    + v_wudp.NumToStrHex(123456, 3) //用户密码
    + v_wudp.NumToStrHex(0, 4) //备用4字节(用0填充)
    ;

    strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //生成指令帧
    strFrame := v_wudp.udp_comm(strCmd, devIP, C10PORT); //发送指令, 并获取返回信息
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        writelog('devSN=' + IntToStr(devSN) + ',' + devIP + ',卡号=[' + cardphyid + '],添加权限失败,ret=' + strFrame);
        iTryAgain := iTryAgain + 1;
        if (iTryAgain > RETRYTIMES) then begin
            result := false;
            exit;
        end
        else begin
            addOrModifyPrivilege(devSN, devIP, cardphyid, doorNo);
        end;
    end;
    result := true;
end;

function addPrivilegeToLast(devSN: integer; devIP: WideString; cardphyid: string; doorNo: integer): boolean;
begin
    strFuncData := '9B10' + v_wudp.NumToStrHex(getPrivilegeCount(devSN, devIP) + 1, 2) //权限位置
    + cardYktToDev(cardphyid) //卡号
    + v_wudp.NumToStrHex(doorNo, 1) //门号
    + v_wudp.MSDateYmdToWCDateYmd('2007-8-14') //有效起始日期
    + v_wudp.MSDateYmdToWCDateYmd('2020-12-31') //有效截止日期
    + v_wudp.NumToStrHex(1, 1) //时段索引号
    + v_wudp.NumToStrHex(123456, 3) //用户密码
    + v_wudp.NumToStrHex(0, 4) //备用4字节(用0填充)
    ;

    strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //生成指令帧
    strFrame := v_wudp.udp_comm(strCmd, devIP, C10PORT); //发送指令, 并获取返回信息
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        writelog('devSN=' + IntToStr(devSN) + ',' + devIP + ',卡号=[' + cardphyid + '],添加权限失败,ret=' + strFrame);
        result := false;
        exit;
    end;

    result := true;

end;



//删除一个卡权限

function deletePrivilege(devSN: integer; devIP: WideString; cardphyid: string; doorNo: integer): boolean;
begin
    strFuncData := '0811' + v_wudp.NumToStrHex(0, 2) //空2个字节
    + cardYktToDev(cardphyid)
        + v_wudp.NumToStrHex(doorno, 1)
        + v_wudp.NumToStrHex(0, 2) //起始年月日  2字节
    + v_wudp.NumToStrHex(0, 2) //终止年月日  2字节
    + v_wudp.NumToStrHex(1, 1) //时段  1字节
    + v_wudp.NumToStrHex(0, 3) //密码  3字节
    + v_wudp.NumToStrHex(0, 4) //备用  4字节
    ;
    strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //生成指令帧
    strFrame := v_wudp.udp_comm(strCmd, devIP, C10PORT); //发送指令, 并获取返回信息
    writelog('devSN=' + IntToStr(devSN) + ',卡号=[' + cardphyid + '],ret=' + strFrame);
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //没有收到数据,
        //失败处理代码... (查ErrCode针对性分析处理)
        writelog('devSN=' + IntToStr(devSN) + ',卡号=[' + cardphyid + '],删除权限失败');
        iTryAgain := iTryAgain + 1;
        if (iTryAgain > RETRYTIMES) then begin
            result := false;
            exit;
        end
        else begin
            deletePrivilege(devSN, devIP, cardphyid, doorNo);
        end;

    end;
    result := true;
end;

function verifyDevClock(devSN: integer; devIP: WideString): boolean;
begin
    //校准控制器时间
    strCmd := v_wudp.CreateBstrCommandOfAdjustClockByPCTime(devSN); //生成指令帧
    strFrame := v_wudp.udp_comm(strCmd, devIP, C10PORT); //发送指令, 并获取返回信息
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //没有收到数据,
        //失败处理代码... (查ErrCode针对性分析处理)
        writelog(IntToStr(devSN) + ',校准时间失败');
        result := false;
        exit;
    end;
    result := true;
end;

function getPrivilegeCount(devSN: Integer; devIP: WideString): Integer;
var
    iCount: integer;
begin
    //getWUDP();
    //读取运行状态信息
    strFuncData := '8110' + v_wudp.NumToStrHex(0, 3); // wudp.NumToStrHex(0,3) 表示第0个记录, 也就最新记录
    strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //生成指令帧
    strFrame := v_wudp.udp_comm(strCmd, devIP, C10PORT); //发送指令, 并获取返回信息
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //没有收到数据,
        //失败处理代码... (查ErrCode针对性分析处理)
        iCount := -1;
        writelog(IntToStr(devSN) + ',读取权限数失败');
    end
    else begin
        iCount := v_wudp.GetPrivilegeNumFromRunInfo(strFrame);
    end;
    result := iCount;
end;


procedure writeLog(content: string);
var
    logFilename: string;
    F: Textfile;
begin
    makeDir(ExtractFilePath(paramstr(0)) + '..\log\');
    logFilename := ExtractFilePath(paramstr(0)) + '..\log\'
        + FormatDateTime('yyyymmdd', Now()) + '.txt';
    if fileExists(logFilename) then begin
        AssignFile(F, logFilename);
        Append(F);
    end
    else begin
        AssignFile(F, logFilename);
        ReWrite(F);
    end;
    Writeln(F, content);
    Flush(F);
    Closefile(F);

end;


procedure writeCardList(content: string);
var
    logFilename: string;
    F: Textfile;
begin
    makeDir(ExtractFilePath(paramstr(0)) + '..\log\');
    logFilename := ExtractFilePath(paramstr(0)) + '..\log\'
        + FormatDateTime('yyyymmdd', Now()) + '.err';
    if fileExists(logFilename) then begin
        AssignFile(F, logFilename);
        Append(F);
    end
    else begin
        AssignFile(F, logFilename);
        ReWrite(F);
    end;
    Writeln(F, content);
    Flush(F);
    Closefile(F);

end;

procedure makeDir(dirString: string);
begin
    if not DirectoryExists(dirString) then begin
        if not CreateDir(dirString) then
            raise Exception.Create('Cannot create ' + dirString);
    end;
end;

procedure getWUDP();
begin
    //创建对象
    if VarIsEmpty(v_wudp) then begin
        v_wudp := CreateOleObject('WComm_UDP.WComm_Operate');
    end;
end;

function connectDev(devSN: WideString): WideString;
var
    controllerSN: Integer; //控制器序列号
    startLocation: Integer; //起始偏移位置
begin
    getWUDP();
    strRunDetail := '';
    controllerSN := StrToInt64(devSN);

    //读取运行状态信息
    strFuncData := '8110' + v_wudp.NumToStrHex(0, 3); // wudp.NumToStrHex(0,3) 表示第0个记录, 也就最新记录
    strCmd := v_wudp.CreateBstrCommand(controllerSN, strFuncData); //生成指令帧
    strFrame := v_wudp.udp_comm(strCmd, devIpAddr, C10PORT); //发送指令, 并获取返回信息
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //没有收到数据,
        //失败处理代码... (查ErrCode针对性分析处理)
        strRunDetail := '设备SN[' + devSN + ']读取运行信息失败';
    end
    else begin
        //对运行信息的详细分析
        //控制器的当前时间
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + '设备序列号S/N: ' + Chr(9) + IntToStr(v_wudp.GetSNFromRunInfo(strFrame));
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + '设备时钟:      ' + Chr(9) + v_wudp.GetClockTimeFromRunInfo(strFrame);
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + '刷卡记录数:    ' + Chr(9) + IntToStr(v_wudp.GetCardRecordCountFromRunInfo(strFrame));
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + '权限数:        ' + Chr(9) + IntToStr(v_wudp.GetPrivilegeNumFromRunInfo(strFrame));
        //strRunDetail := strRunDetail + Chr(13) + Chr(10) + Chr(13) + Chr(10) + '最近的一条刷卡记录: ' + Chr(9);
        //swipeDate := v_wudp.GetSwipeDateFromRunInfo(strFrame, cardId, status);

        strRunDetail := strRunDetail + Chr(13) + Chr(10) + '故障状态:' + Chr(9);
        errorNo := v_wudp.GetErrorNoFromRunInfo(strFrame);
        if errorNo <> 0 then begin
            strRunDetail := strRunDetail + ' 有故障  ';
            if (errorNo and 1) > 0 then
                strRunDetail := strRunDetail + Chr(13) + Chr(10) + '        ' + Chr(9) + '系统故障1';
            if (errorNo and 2) > 0 then
                strRunDetail := strRunDetail + Chr(13) + Chr(10) + '        ' + Chr(9) + '系统故障2';
            if (errorNo and 4) > 0 then
                strRunDetail := strRunDetail + Chr(13) + Chr(10) + '        ' + Chr(9) + '系统故障3[设备时钟有故障], 请校正时钟处理';
            if (errorNo and 8) > 0 then
                strRunDetail := strRunDetail + Chr(13) + Chr(10) + '        ' + Chr(9) + '系统故障4';
        end;
    end;
    //查询控制器的IP设置
    //读取网络配置信息指令
    strCmd := v_wudp.CreateBstrCommand(controllerSN, '0111'); //生成指令帧 读取网络配置信息指令
    strFrame := v_wudp.udp_comm(strCmd, devIpAddr, C10PORT); //发送指令, 并获取返回信息
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //没有收到数据,
        //失败处理代码... (查ErrCode针对性分析处理)
        strRunDetail := Tag_Error + '读取控制器[' + devSN + ']信息失败';
    end
    else begin
        //IP
        startLocation := 23;
        strRunDetail := strRunDetail + IntToStr(StrToInt('$' + (copy(strFrame, startLocation, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 2, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 4, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 6, 2))));
        devIpAddr := IntToStr(StrToInt('$' + (copy(strFrame, startLocation, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 2, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 4, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 6, 2))));
    end;
    result := strRunDetail;
end;

function connectDevByIP(devSN: WideString; devIP: WideString; devMask: WideString; devGateWay: WideString): boolean;
var
    ip: TStrings;
    sConfigIP, strHexNewIP: WideString; //New IP (十六进制) ,设备的MAC地址
    controllerSN: Integer; //控制器序列号
    startLocation: Integer;
begin
    getWUDP();
    controllerSN := StrToInt64(devSN);
    //变换ip
    ip := TStringList.Create;
    ip.Delimiter := '.';
    ip.DelimitedText := devIP;

    sConfigIP := ip[0] + ip[1] + ip[2] + ip[3];
    strHexNewIP := v_wudp.NumToStrHex(ip[0], 1)
        + v_wudp.NumToStrHex(ip[1], 1)
        + v_wudp.NumToStrHex(ip[2], 1)
        + v_wudp.NumToStrHex(ip[3], 1);

    ip.Free;

    devIpAddrHex := '';
    devIpAddr := '';
    //读取运行状态信息
    strFuncData := '8110' + v_wudp.NumToStrHex(0, 3); // wudp.NumToStrHex(0,3) 表示第0个记录, 也就最新记录
    strCmd := v_wudp.CreateBstrCommand(controllerSN, strFuncData); //生成指令帧

    strFrame := v_wudp.udp_comm(strCmd, devIpAddrHex, C10PORT); //发送指令, 并获取返回信息
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //没有收到数据,
        //失败处理代码... (查ErrCode针对性分析处理)
        writelog('[' + devSN + ']读取运行信息失败,' + 'retcode=' + IntToStr(v_wudp.ErrCode));
        result := false;
        Exit;
    end
    else begin
        devClock := v_wudp.GetClockTimeFromRunInfo(strFrame);
        devRecordCount := IntToStr(v_wudp.GetCardRecordCountFromRunInfo(strFrame));
    end;
    //查询控制器的IP设置
    //读取网络配置信息指令
    strCmd := v_wudp.CreateBstrCommand(controllerSN, '0111'); //生成指令帧 读取网络配置信息指令
    strFrame := v_wudp.udp_comm(strCmd, devIpAddr, C10PORT); //发送指令, 并获取返回信息
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //没有收到数据,
        //失败处理代码... (查ErrCode针对性分析处理)
        writelog('[' + devSN + ']读取网络配置信息失败,' + 'retcode=' + IntToStr(v_wudp.ErrCode));
        result := false;
        Exit;
    end
    else begin
        //'MAC
        startLocation := 11;
        devMacAddr := copy(strFrame, startLocation, 12);
        //IP
        startLocation := 23;
        devIpAddr := IntToStr(StrToInt('$' + (copy(strFrame, startLocation, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 2, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 4, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 6, 2))));
    end;

    //设置IP地址
    application.ProcessMessages;

    result := true;
end;

function getIPbySN(devSN: WideString): WideString;
begin
    getWUDP();
    if getDeviceStatus(StrToInt64(devSN)) then begin
        result := devIpAddr;
    end;
end;

procedure getRecord(devSN: integer; devIP: WideString);
var
    recIndex: Integer;
    recCount: Integer;
    //    cardphyid: string;
    cardno: integer;
    recStatus: integer;
begin
    getWUDP();
    recCount := getRecordCount(devSN, devIP);

    DeviceRecords.Clear;

    if recCount > datapackage then recCount := datapackage;

    for recIndex := 1 to recCount do begin
        strFuncData := '8D10' + v_wudp.NumToStrHex(recIndex, 4); // wudp.NumToStrHex(recIndex,4) 表示第recIndex个记录
        strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //生成指令帧 8D10为提取记录指令
        strFrame := v_wudp.udp_comm(strCmd, devIP, C10PORT); //发送指令, 并获取返回信息
        if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
            //没有收到数据,
            //失败处理代码... (查ErrCode针对性分析处理)
            //用户可考虑重试
            writelog(IntToStr(devSN) + ',' + devIP + ',提取记录出错');
            Exit;
        end
        else begin
            swipeDate := v_wudp.GetSwipeDateFromRunInfo(strFrame, cardno, recStatus);
            if swipeDate <> '' then begin
                DeviceRecords.Add(IntToStr(devSN) + ',' + cardNoToHex(cardno) + ',' + swipeDate + ',' + IntToStr(recStatus));
            end;
        end;
        application.ProcessMessages;
    end;

    //删除已提取的记录 ,只有提取了记录才进行删除
    if (recCount > 0) then begin
        strFuncData := '8E10' + v_wudp.NumToStrHex(recCount, 4);
        strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //生成指令帧
        strFrame := v_wudp.udp_comm(strCmd, devIP, C10PORT); //发送指令, 并获取返回信息
        if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
            //没有收到数据,
            //失败处理代码... (查ErrCode针对性分析处理)
            //用户可考虑重试
            writelog(IntToStr(devSN) + ',' + devIP + ',删除记录失败');
        end;
    end;
end;


function deleteRecord(devSN: WideString; recno: Integer): boolean;
begin
    getWUDP();
    //删除已提取的记录 ,只有提取了记录才进行删除
    strFuncData := '8E10' + v_wudp.NumToStrHex(recno, 4);
    strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //生成指令帧
    strFrame := v_wudp.udp_comm(strCmd, devIpAddr, C10PORT); //发送指令, 并获取返回信息
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //没有收到数据,
        //失败处理代码... (查ErrCode针对性分析处理)
        //用户可考虑重试
        result := false;
    end
    else begin
        result := true;
    end;
end;

procedure initDevices();
var
    //filename: string;
    //devicesString: string;
    deviceSnList, deviceIpList, tmpList: TStrings;
    //arrayDevice: DeviceArray;
    i: Integer;
    strHexMask: WideString; //掩码(十六进制)
    strHexGateway: WideString; //网关(十六进制)
    //    strMac: WideString;
begin
    getWUDP();
    if iniConfig = nil then
        iniConfig := TInifile.Create(ExtractFilePath(paramstr(0)) + '..\config\' + CONFIGFILE);


    c10sn := iniConfig.readstring('yczn', 'c10sn', '');
    c10ip := iniConfig.readstring('yczn', 'c10ip', '');
    c10mask := iniConfig.readstring('yczn', 'c10mask', '255.255.255.0');
    c10gateway := iniConfig.readstring('yczn', 'c10gateway', '');
    c10interval := iniConfig.ReadInteger('yczn', 'c10interval', 5);
    c10doorno := iniConfig.readstring('yczn', 'c10doorno', '1');
    datapackage := iniConfig.ReadInteger('yczn', 'datapackage', 500);
    downinternal := iniConfig.ReadInteger('yczn', 'downinternal', 300);


    //IpRange := iniConfig.readstring('yczn', 'iprange', '192.168.168.');
    //iniConfig.Free;

    //变换mask
    tmpList := TStringList.Create;
    tmpList.Delimiter := '.';
    tmpList.DelimitedText := c10mask;
    strHexMask := v_wudp.NumToStrHex(tmpList[0], 1)
        + v_wudp.NumToStrHex(tmpList[1], 1)
        + v_wudp.NumToStrHex(tmpList[2], 1)
        + v_wudp.NumToStrHex(tmpList[3], 1);
    tmpList.Free;
    //变换gateway
    tmpList := TStringList.Create;
    tmpList.Delimiter := '.';
    tmpList.DelimitedText := c10gateway;

    strHexGateway := v_wudp.NumToStrHex(tmpList[0], 1)
        + v_wudp.NumToStrHex(tmpList[1], 1)
        + v_wudp.NumToStrHex(tmpList[2], 1)
        + v_wudp.NumToStrHex(tmpList[3], 1);

    tmpList.Free;


    deviceSnList := TStringList.Create;
    deviceSnList.Delimiter := ',';
    deviceSnList.DelimitedText := c10sn;

    deviceIpList := TStringList.Create;
    deviceIpList.Delimiter := ',';
    deviceIpList.DelimitedText := c10ip;

    if (WorkingDeviceArray = nil) then
        WorkingDeviceArray := TStringList.Create;


    for i := 0 to deviceSnList.Count - 1 do begin
        writeLog(deviceSnList[i] + ',' + deviceIpList[i]);
        if (setDeviceIP(deviceSnList[i], deviceIpList[i], strHexMask, strHexGateway)) then begin
            WorkingDeviceArray.Add(deviceSnList[i] + ',' + deviceIpList[i]);
        end;
        if APP_DEBUGMODE then begin
            WorkingDeviceArray.Add(deviceSnList[i] + ',' + deviceIpList[i]);
        end;

    end;

    deviceSnList.Free;
    deviceIpList.Free;

    if DeviceRecords = nil then
        DeviceRecords := TStringList.Create;

    makeDir(ExtractFilePath(paramstr(0)) + '..\data');
    makeDir(ExtractFilePath(paramstr(0)) + '..\data\bak');
    makeDir(ExtractFilePath(paramstr(0)) + '..\datadown');
    makeDir(ExtractFilePath(paramstr(0)) + '..\datadown\bak');


end;

procedure connectDevices();
var
    //filename: string;
    deviceSnList, deviceIpList, tmpList: TStrings;
    i: Integer;
    strHexMask: WideString; //掩码(十六进制)
    strHexGateway: WideString; //网关(十六进制)
    //    strMac: WideString;
begin
    getWUDP();
    if iniConfig = nil then
        iniConfig := TInifile.Create(ExtractFilePath(paramstr(0)) + '..\config\' + CONFIGFILE);
    c10sn := iniConfig.readstring('yczn', 'c10sn', '');
    c10ip := iniConfig.readstring('yczn', 'c10ip', '');
    c10mask := iniConfig.readstring('yczn', 'c10mask', '255.255.255.0');
    c10gateway := iniConfig.readstring('yczn', 'c10gateway', '');
    c10interval := iniConfig.ReadInteger('yczn', 'c10interval', 5);
    c10doorno := iniConfig.readstring('yczn', 'c10doorno', '1');
    datapackage := iniConfig.ReadInteger('yczn', 'datapackage', 500);
    downinternal := iniConfig.ReadInteger('yczn', 'downinternal', 300);

    //变换mask
    tmpList := TStringList.Create;
    tmpList.Delimiter := '.';
    tmpList.DelimitedText := c10mask;
    strHexMask := v_wudp.NumToStrHex(tmpList[0], 1)
        + v_wudp.NumToStrHex(tmpList[1], 1)
        + v_wudp.NumToStrHex(tmpList[2], 1)
        + v_wudp.NumToStrHex(tmpList[3], 1);
    tmpList.Free;
    //变换gateway
    tmpList := TStringList.Create;
    tmpList.Delimiter := '.';
    tmpList.DelimitedText := c10gateway;

    strHexGateway := v_wudp.NumToStrHex(tmpList[0], 1)
        + v_wudp.NumToStrHex(tmpList[1], 1)
        + v_wudp.NumToStrHex(tmpList[2], 1)
        + v_wudp.NumToStrHex(tmpList[3], 1);

    tmpList.Free;


    deviceSnList := TStringList.Create;
    deviceSnList.Delimiter := ',';
    deviceSnList.DelimitedText := c10sn;

    deviceIpList := TStringList.Create;
    deviceIpList.Delimiter := ',';
    deviceIpList.DelimitedText := c10ip;

    if (WorkingDeviceArray = nil) then
        WorkingDeviceArray := TStringList.Create;


    for i := 0 to deviceSnList.Count - 1 do begin
        writeLog(deviceSnList[i] + ',' + deviceIpList[i]);
        if (connectDevByIP(deviceSnList[i], deviceIpList[i], strHexMask, strHexGateway)) then begin
            WorkingDeviceArray.Add(deviceSnList[i] + ',' + deviceIpList[i]);
        end;
        if APP_DEBUGMODE then begin
            WorkingDeviceArray.Add(deviceSnList[i] + ',' + deviceIpList[i]);
        end;

    end;

    deviceSnList.Free;
    deviceIpList.Free;

    if DeviceRecords = nil then
        DeviceRecords := TStringList.Create;

    makeDir(ExtractFilePath(paramstr(0)) + '..\data');
    makeDir(ExtractFilePath(paramstr(0)) + '..\data\bak');
    makeDir(ExtractFilePath(paramstr(0)) + '..\datadown');
    makeDir(ExtractFilePath(paramstr(0)) + '..\datadown\bak');
end;

//初始化设备连接，并获得设备当前的时间、记录数、IP地址、MAC地址
function getDeviceStatus(devSN: integer): boolean;
var
    //controllerSN: Integer; //控制器序列号
    startLocation: Integer; //起始偏移位置
begin
    getWUDP();
    //controllerSN := StrToInt64(devSN);
    devIpAddrHex := '';
    devIpAddr := '';
    //读取运行状态信息
    strFuncData := '8110' + v_wudp.NumToStrHex(0, 3); // wudp.NumToStrHex(0,3) 表示第0个记录, 也就最新记录
    strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //生成指令帧

    strFrame := v_wudp.udp_comm(strCmd, devIpAddrHex, C10PORT); //发送指令, 并获取返回信息
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //没有收到数据,
        //失败处理代码... (查ErrCode针对性分析处理)
        writelog('[' + IntToStr(devSN) + ']读取运行信息失败,' + 'retcode=' + IntToStr(v_wudp.ErrCode));
        result := false;
        Exit;
    end
    else begin
        devClock := v_wudp.GetClockTimeFromRunInfo(strFrame);
        devRecordCount := IntToStr(v_wudp.GetCardRecordCountFromRunInfo(strFrame));
        devPrivilegeCount := IntToStr(v_wudp.GetPrivilegeNumFromRunInfo(strFrame));
    end;
    //查询控制器的IP设置
    //读取网络配置信息指令
    strCmd := v_wudp.CreateBstrCommand(devSN, '0111'); //生成指令帧 读取网络配置信息指令
    strFrame := v_wudp.udp_comm(strCmd, devIpAddr, C10PORT); //发送指令, 并获取返回信息
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //没有收到数据,
        //失败处理代码... (查ErrCode针对性分析处理)
        writelog('[' + IntToStr(devSN) + ']读取网络配置信息失败,' + 'retcode=' + IntToStr(v_wudp.ErrCode));
        result := false;
        Exit;
    end
    else begin
        //'MAC
        startLocation := 11;
        devMacAddr := copy(strFrame, startLocation, 12);
        //IP
        startLocation := 23;
        devIpAddr := IntToStr(StrToInt('$' + (copy(strFrame, startLocation, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 2, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 4, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 6, 2))));
    end;
    result := true;
end;

function getRecordCount(devSN: integer; devIP: WideString): integer;
var
    recCount: integer;
begin
    getWUDP();
    recCount := 0;
    //读取运行状态信息
    strFuncData := '8110' + v_wudp.NumToStrHex(0, 3); // wudp.NumToStrHex(0,3) 表示第0个记录, 也就最新记录
    strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //生成指令帧
    strFrame := v_wudp.udp_comm(strCmd, devIP, C10PORT); //发送指令, 并获取返回信息
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //没有收到数据,
        //失败处理代码... (查ErrCode针对性分析处理)
        writelog('[' + IntToStr(devSN) + ']读取运行信息失败,' + 'retcode=' + IntToStr(v_wudp.ErrCode));
    end
    else begin
        recCount := v_wudp.GetCardRecordCountFromRunInfo(strFrame);
    end;
    result := recCount;
end;

function setDeviceIP(devSN: WideString; devIP: WideString; devMask: WideString; devGateWay: WideString): boolean;
var
    ip: TStrings;
    sConfigIP, strHexNewIP: WideString; //New IP (十六进制) ,设备的MAC地址
    controllerSN: Integer; //控制器序列号
    startLocation: Integer;
begin
    getWUDP();
    controllerSN := StrToInt64(devSN);
    //变换ip
    ip := TStringList.Create;
    ip.Delimiter := '.';
    ip.DelimitedText := devIP;

    sConfigIP := ip[0] + ip[1] + ip[2] + ip[3];
    strHexNewIP := v_wudp.NumToStrHex(ip[0], 1)
        + v_wudp.NumToStrHex(ip[1], 1)
        + v_wudp.NumToStrHex(ip[2], 1)
        + v_wudp.NumToStrHex(ip[3], 1);

    ip.Free;

    devIpAddrHex := '';
    devIpAddr := '';
    //读取运行状态信息
    strFuncData := '8110' + v_wudp.NumToStrHex(0, 3); // wudp.NumToStrHex(0,3) 表示第0个记录, 也就最新记录
    strCmd := v_wudp.CreateBstrCommand(controllerSN, strFuncData); //生成指令帧

    strFrame := v_wudp.udp_comm(strCmd, devIpAddrHex, C10PORT); //发送指令, 并获取返回信息
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //没有收到数据,
        //失败处理代码... (查ErrCode针对性分析处理)
        writelog('[' + devSN + ']读取运行信息失败,' + 'retcode=' + IntToStr(v_wudp.ErrCode));
        result := false;
        Exit;
    end
    else begin
        devClock := v_wudp.GetClockTimeFromRunInfo(strFrame);
        devRecordCount := IntToStr(v_wudp.GetCardRecordCountFromRunInfo(strFrame));
    end;
    //查询控制器的IP设置
    //读取网络配置信息指令
    strCmd := v_wudp.CreateBstrCommand(controllerSN, '0111'); //生成指令帧 读取网络配置信息指令
    strFrame := v_wudp.udp_comm(strCmd, devIpAddr, C10PORT); //发送指令, 并获取返回信息
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //没有收到数据,
        //失败处理代码... (查ErrCode针对性分析处理)
        writelog('[' + devSN + ']读取网络配置信息失败,' + 'retcode=' + IntToStr(v_wudp.ErrCode));
        result := false;
        Exit;
    end
    else begin
        //'MAC
        startLocation := 11;
        devMacAddr := copy(strFrame, startLocation, 12);
        //IP
        startLocation := 23;
        devIpAddr := IntToStr(StrToInt('$' + (copy(strFrame, startLocation, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 2, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 4, 2))))
            + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLocation + 6, 2))));
    end;

    //设置IP地址
    application.ProcessMessages;

    if (sConfigIP <> devIpAddr) then begin
        strCmd := v_wudp.CreateBstrCommand(controllerSN, 'F211' + devMacAddr + strHexNewIP + devMask + devGateWay + '60EA'); // 生成指令帧 读取网络配置信息指令
        strFrame := v_wudp.udp_comm(strCmd, '', C10PORT); //发送指令, 并获取返回信息
        if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
            //没有收到数据,
            //失败处理代码... (查ErrCode针对性分析处理)
            result := false;
            writeLog(Tag_Error + '[' + devSN + ']' + '[' + strHexNewIP + ']IP地址设置失败,retcode=' + IntToStr(v_wudp.ErrCode));
            Exit;
        end
        else begin
            application.ProcessMessages;
            writeLog('[' + devSN + ']' + '[' + strHexNewIP + ']IP地址设置完成');
            Sleep(DEVICE_INTERNAL); //引入3秒延时
        end;
    end
    else begin
        writeLog('[' + devSN + ']' + '[' + sConfigIP + ']IP已设置，不需要再设置');
    end;
    result := true;
end;

function monitorDevice(controllerSN: Integer): string;
var
    ip: string;
    //strs: TStrings;
    watchIndex, cardId, recCnt: Integer;
    status: Integer; //状态
begin
    recCnt := 0;
    watchIndex := 0;
    application.ProcessMessages;
    while true do begin
        strFuncData := '8110' + v_wudp.NumToStrHex(watchIndex, 3); //wudp.NumToStrHex(watchIndex,3) 表示第watchIndex个记录, 如果是0则取最新一条记录
        strCmd := v_wudp.CreateBstrCommand(controllerSN, strFuncData); //生成指令帧
        strFrame := v_wudp.udp_comm(strCmd, ip, C10PORT); //发送指令, 并获取返回信息
        if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then
            //没有收到数据,
            //失败处理代码... (查ErrCode针对性分析处理)
            Exit
        else begin
            swipeDate := v_wudp.GetSwipeDateFromRunInfo(strFrame, cardId, status);
            {//有记录时}
            if swipeDate <> '' then begin
                form1.Text1.Lines.Add('卡号: ' + cardNoToHex(cardId) + Chr(13) + Chr(10)
                    + '状态:' + IntToStr(status) + '(' + v_wudp.NumToStrHex(status, 1)
                    + ')' + Chr(13) + Chr(10) + '时间:' + swipeDate + Chr(13) + Chr(10)
                    + 'strFrame=[' + strFrame + ']');

                if watchIndex = 0 then //如果收到第一条记录
                    watchIndex := v_wudp.GetCardRecordCountFromRunInfo(strFrame) + 1 //指向(总记录数+1), 也就是下次刷卡的存储索引位
                else
                    watchIndex := watchIndex + 1; //指向下一个记录位
                recCnt := recCnt + 1; //记录计数
            end;
        end;
        application.ProcessMessages;
        if recCnt > 3 then break;
    end;
    result := '已停止实时监控';

end;



procedure downloadAllCardByOne(devSN: Integer; devIP: WideString; doorNo: integer; cardList: TStringList);
var
    j: integer;
    //time1: TDateTime;
begin
    //time1 := Now;
    //cleanPrivilege(devSN, devIP);
    for j := 0 to cardList.Count - 1 do begin
        if (addOrModifyPrivilege(devSN, devIP, cardList[j], doorNo) = true) then begin
            form1.Text1.lines.Add('[' + IntToStr(j) + ']' + '控制器[' + devIP + '],卡号=[' + cardList[j] + ']添加权限成功');
            Sleep(downinternal);
            if (form1.Text1.Lines.Count = 200) then begin
                form1.Text1.Lines.Clear;
            end;
        end
        else begin
            writelog('控制器[' + devIP + '],卡号=[' + cardList[j] + ']添加权限失败');
            writeCardList('45' + cardNoToHex(StrToInt(cardList[j])) + ',1');
        end;
    end;
end;

procedure downloadAllCard(devSN: Integer; devIP: WideString; doorNo: integer; cardList: TStringList);
var
    j, privilegeIndex: integer;
    //    cardno: string;
    //    status: Integer; //状态
    privilege: WideString; //权限
    time1: TDateTime;
begin
    time1 := Now;

    //cleanPrivilege(devSN, devIP);
    privilegeIndex := 1;
    for j := 0 to cardList.Count - 1 do begin
        privilege := '';
        privilege := v_wudp.CardToStrHex(cardList[j]); //卡号
        privilege := privilege + v_wudp.NumToStrHex(doorNo, 1); //门号
        privilege := privilege + v_wudp.MSDateYmdToWCDateYmd('2007-8-14'); //有效起始日期
        privilege := privilege + v_wudp.MSDateYmdToWCDateYmd('2020-12-31'); //有效截止日期
        privilege := privilege + v_wudp.NumToStrHex(1, 1); //时段索引号
        privilege := privilege + v_wudp.NumToStrHex(123456, 3); //用户密码
        privilege := privilege + v_wudp.NumToStrHex(0, 4); //备用4字节(用0填充)

        //生成的权限不符合要求, 请查一下上一指令中写入的每个参数是否正确
        if (Length(privilege) <> (16 * 2)) then begin
            writelog('控制器[' + devIP + '],卡号=[' + cardList[j] + ']生成的权限不符合要求');
            Exit;
        end;
        strFuncData := '9B10' + v_wudp.NumToStrHex(privilegeIndex, 2) + privilege;
        strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //生成指令帧
        strFrame := v_wudp.udp_comm(strCmd, devIP, C10PORT); //发送指令, 并获取返回信息

        if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
            //没有收到数据,
            //失败处理代码... (查ErrCode针对性分析处理)
            //用户可考虑重试
            form1.Text1.lines.Add('控制器[' + devIP + '],卡号=[' + cardList[j] + ']添加权限失败');
            writelog('控制器[' + devIP + '],卡号=[' + cardList[j] + ']添加权限失败');
            Exit;
        end
        else begin
            privilegeIndex := privilegeIndex + 1;

            form1.Text1.lines.Add('[' + IntToStr(privilegeIndex) + ']' + '控制器[' + devIP + '],卡号=[' + cardList[j] + ']添加权限成功');
            Sleep(downinternal);
            if (form1.Text1.Lines.Count = 200) then begin
                form1.Text1.Lines.Clear;
            end;
        end;
    end;
    writelog('控制器sn[' + IntToStr(devSN) + '],ip=[' + devIP + '],名单下发个数=' + IntToStr(cardList.Count) + ',话费时间（秒）=' + IntToStr(SecondsBetween(time1, now)));

end;

function cardHexToNo(cardphyid: string): string;
begin
    result := IntToStr(StrToInt64('$' + copy(cardphyid, 1, 2)))
        + IntToStr(StrToInt64('$' + copy(cardphyid, 3, 4)));
end;

function cardNoToHex(cardno: integer): string;
var
    cardhex: string;
begin
    cardhex := v_wudp.CardToStrHex(cardno);
    result := copy(cardhex, 5, 2) + copy(cardhex, 3, 2) + copy(cardhex, 1, 2);
end;

function cardYktToDev(cardphyid: string): string;
begin
    result := copy(cardphyid, 5, 2) + copy(cardphyid, 3, 2) + copy(cardphyid, 1, 2);
end;


function NumberSort(List: TStringList; Index1, Index2: Integer): Integer;
var
    Value1, Value2: Integer;
begin
    Value1 := StrToInt(List[Index1]);
    Value2 := StrToInt(List[Index2]);
    if Value1 > Value2 then
        Result := 1
    else if Value1 < Value2 then
        Result := -1
    else
        Result := 0;
end;

function devAlwaysOpen(devSN: integer; devIP: WideString; devMode, devDelay: integer): boolean;
begin
    strFuncData := '8F10' + v_wudp.NumToStrHex(1, 1) //doorNo=1
    + v_wudp.NumToStrHex(devMode, 1) //control mode=1
    + v_wudp.NumToStrHex(devDelay*10, 1) //delay 3s
    ;

    strCmd := v_wudp.CreateBstrCommand(devSN, strFuncData); //生成指令帧
    strFrame := v_wudp.udp_comm(strCmd, devIP, C10PORT); //发送指令, 并获取返回信息
    if ((v_wudp.ErrCode <> 0) or (strFrame = '')) then begin
        writelog('devSN=' + IntToStr(devSN) + ',' + devIP + '],open失败,ret=' + strFrame);
        result := false;
        exit;
    end;
    result := true;

end;


end.

