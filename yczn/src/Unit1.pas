unit Unit1;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, OleServer, COMOBJ, IniFiles, StrUtils, DateUtils, ShellAPI,
    Menus, RzTray, IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient, DB,
    uDoorController, ExtCtrls, DBAccess, Ora, MemDS, OraSmart, Buttons;


type
    TForm1 = class(TForm)
        btnConfigOne: TButton;
        Text1: TMemo;
        btnExit: TButton;
        EditSN: TEdit;
        Label1: TLabel;
        Label2: TLabel;
        Label3: TLabel;
        Label4: TLabel;
        Label5: TLabel;
        EditIP1: TEdit;
        EditIP2: TEdit;
        EditIP3: TEdit;
        EditIP4: TEdit;
        Label6: TLabel;
        EditMask1: TEdit;
        EditMask2: TEdit;
        EditMask3: TEdit;
        EditMask4: TEdit;
        Label7: TLabel;
        EditGateway1: TEdit;
        EditGateway2: TEdit;
        EditGateway3: TEdit;
        EditGateway4: TEdit;
        btnManualRecord: TButton;
        btnConfigDev: TButton;
        btnInitPrivilege: TButton;
        btnMonitorDevice: TButton;
        btnDownload: TButton;
        btnDeletePrivilege: TButton;
        Edit2: TEdit;
        Label9: TLabel;
        Label10: TLabel;
        Edit3: TEdit;
        btnGetPrivilege: TButton;
        btnSyncTIme: TButton;
        btnCleanPrivilege: TButton;
        btnAddPriv: TButton;
        Timer1: TTimer;
        btnAutoGet: TButton;
        OraSession1: TOraSession;
        btnSyncData: TButton;
        OraQuery1: TOraQuery;
        btnAutoSync: TButton;
        btnStopTask: TButton;
        btnUploadData: TButton;
        Timer2: TTimer;
        btnAutoUpload: TButton;
        Timer3: TTimer;
        Timer4: TTimer;
        Label8: TLabel;
        TimerLabel8: TTimer;
        Label11: TLabel;
        IdUDPClient1: TIdUDPClient;
        BitBtn1: TBitBtn;
        Label12: TLabel;
        edtStuempno: TEdit;
        RzTrayIcon1: TRzTrayIcon;
        PopupMenu1: TPopupMenu;
        N1: TMenuItem;
        N2: TMenuItem;
        N3: TMenuItem;
        N4: TMenuItem;
        Button1: TButton;
        cbDevice: TComboBox;
        N5: TMenuItem;
        btnAlwaysOpen: TButton;
        Button2: TButton;
        edtDelay: TEdit;
        Label13: TLabel;
        Label14: TLabel;
        Button3: TButton;
        btnConnectDevice: TButton;
        procedure btnConfigOneClick(Sender: TObject);
        procedure btnExitClick(Sender: TObject);
        procedure btnConfigDevClick(Sender: TObject);
        procedure btnInitPrivilegeClick(Sender: TObject);
        procedure btnMonitorDeviceClick(Sender: TObject);
        procedure btnDownloadClick(Sender: TObject);
        procedure btnSyncTImeClick(Sender: TObject);
        procedure btnGetPrivilegeClick(Sender: TObject);
        procedure btnDeletePrivilegeClick(Sender: TObject);
        procedure btnCleanPrivilegeClick(Sender: TObject);
        procedure btnAddPrivClick(Sender: TObject);
        procedure btnManualRecordClick(Sender: TObject);
        procedure Timer1Timer(Sender: TObject);
        procedure btnAutoGetClick(Sender: TObject);
        procedure btnSyncDataClick(Sender: TObject);
        procedure btnAutoSyncClick(Sender: TObject);
        procedure btnStopTaskClick(Sender: TObject);
        procedure btnAutoUploadClick(Sender: TObject);
        procedure Timer2Timer(Sender: TObject);
        procedure btnUploadDataClick(Sender: TObject);
        procedure Timer3Timer(Sender: TObject);
        procedure Timer4Timer(Sender: TObject);
        procedure TimerLabel8Timer(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure BitBtn1Click(Sender: TObject);
        procedure Button1Click(Sender: TObject);
        procedure N5Click(Sender: TObject);
        procedure btnAlwaysOpenClick(Sender: TObject);
        procedure Button2Click(Sender: TObject);
        procedure btnConnectDeviceClick(Sender: TObject);
    private
        { Private declarations }
        procedure getData(dataType: integer);
        procedure syncData(syncType: integer);
        procedure insertDataToYKT(recordFilename: string);
        procedure uploadDataToYKT();
        procedure buttonConfig(opType: integer);
    public
        { Public declarations }
    end;

    TDownCardThread = class(TThread)
    private
        AMemo: TMemo;
        ACardPhyID: array[0..32] of char;
    protected
        procedure Execute; override;
        procedure downCardPhyID;
    public
        constructor Create(memo: Tmemo);
    end;

var
    Form1: TForm1;
    syncfilename: string;
    datafilename: string;


procedure configDevice();
procedure connectDevice();
procedure initPrivilege();
function verifyUser(iType: integer; sParam: string): boolean;
procedure syncGetData();


implementation

uses FormWait, AES;
{$R *.dfm}

constructor TDownCardThread.Create(memo: Tmemo);
begin
    inherited Create(false);
    AMemo := memo;
    FreeOnTerminate := true;
end;

procedure TDownCardThread.downCardPhyID();
begin
    AMemo.Lines.Add(ACardPhyID);
end;

procedure TDownCardThread.Execute();
var
    devList, cardList, downList: TStringList;
    ip: string;
    i, devSN: integer;
    time1: tdatetime;
begin
    time1 := Now();
    Synchronize(downCardPhyID);
    sleep(downinternal);

    cardList := TStringList.Create;
    cardList.LoadFromFile(ExtractFilePath(paramstr(0)) + CARDLISTFILE);

    downList := TStringList.Create;
    for i := 0 to cardList.Count - 1 do begin
        if (Pos(',1', cardList[i]) > 0) then begin
            downList.Add(cardHexToNo(copy(cardList[i], 3, (Pos(',1', cardList[i]) - 3))));
        end;
    end;
    //由小到大排序卡号
    downList.CustomSort(NumBerSort);

    for i := 0 to WorkingDeviceArray.Count - 1 do begin
        devList := TStringList.Create;
        devList.Delimiter := ',';
        devList.DelimitedText := WorkingDeviceArray[i];
        devSN := StrToInt64(devList[0]);
        ip := devList[1];
        devList.Free;
        downloadAllCardByOne(devSN, ip, 1, downList);
    end;

    downList.Free;
    cardList.Free;

    AMemo.lines.Add(format('所有设备权限初始化完成--耗费时间：%d 秒', [SecondsBetween(time1, now)]));
end;

procedure TForm1.btnConfigOneClick(Sender: TObject);
var
    strCmd: WideString; //要发送的指令帧
    strFuncData: WideString; //要发送的功能及数据
    strFrame: WideString; //返回的数据
    ret: Integer; //函数的返回值
    controllerSN: Integer; //控制器序列号

    //刷卡记录变量
    cardId: Integer; //卡号
    status: Integer; //状态
    swipeDate: WideString; //日期时间

    strRunDetail: WideString; //运行信息

    recIndex: Integer; //记录索引号
    errorNo: Integer; //故障号

    //用于权限上送
    doorIndex: Integer; //门号
    cardno: array[0..2] of integer; //3个卡号
    privilege: WideString; //权限
    privilegeIndex: Integer; //权限索引号
    cardIndex: Integer; //卡索引号

    timeseg: WideString; //时段

    //用于实时监控
    watchIndex: Integer; //监控索引号
    recCnt: Integer; //刷卡记录计数

    wudp: Variant; //WComm_Operate对象
    ipAddr: WideString;
    strMac: WideString;
    strHexNewIP: WideString; //New IP (十六进制)
    strHexMask: WideString; //掩码(十六进制)
    strHexGateway: WideString; //网关(十六进制)

    startLoc: Integer;

begin
    //.NET控制器通信操作 (案例针对controllerSN操作)
    controllerSN := StrToInt64(EditSN.Text); //测试使用的.NET 控制器
    ipAddr := ''; //为空, 表示广播包方式

    Text1.Text := '控制器通信' + '-' + IntToStr(controllerSN) + '-.NET';

    //创建对象
    wudp := CreateOleObject('WComm_UDP.WComm_Operate');

    //读取运行状态信息
    strFuncData := '8110' + wudp.NumToStrHex(0, 3); // wudp.NumToStrHex(0,3) 表示第0个记录, 也就最新记录
    strCmd := wudp.CreateBstrCommand(controllerSN, strFuncData); //生成指令帧
    strFrame := wudp.udp_comm(strCmd, ipAddr, 60000); //发送指令, 并获取返回信息
    if ((wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //没有收到数据,
        //失败处理代码... (查ErrCode针对性分析处理)
        Text1.Text := Text1.Text + Chr(13) + Chr(10) + '读取运行信息失败';
        Exit;
    end
    else begin
        Text1.Text := Text1.Text + Chr(13) + Chr(10) + '读取运行信息成功';
        //对运行信息的详细分析
        //控制器的当前时间
        strRunDetail := '';
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + '设备序列号S/N: ' + Chr(9) + IntToStr(wudp.GetSNFromRunInfo(strFrame));
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + '设备时钟:      ' + Chr(9) + wudp.GetClockTimeFromRunInfo(strFrame);
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + '刷卡记录数:    ' + Chr(9) + IntToStr(wudp.GetCardRecordCountFromRunInfo(strFrame));
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + '权限数:        ' + Chr(9) + IntToStr(wudp.GetPrivilegeNumFromRunInfo(strFrame));
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + Chr(13) + Chr(10) + '最近的一条刷卡记录: ' + Chr(9);
        swipeDate := wudp.GetSwipeDateFromRunInfo(strFrame, cardId, status);
        if swipeDate <> '' then begin
            strRunDetail := strRunDetail + Chr(13) + Chr(10) + '卡号: ' + IntToStr(cardId) + Chr(9) + ' 状态:' + Chr(9) + IntToStr(status) + '(' + wudp.NumToStrHex(status, 1) + ')' + Chr(9) + '时间:' + Chr(9) + swipeDate;
        end;
        strRunDetail := strRunDetail + Chr(13) + Chr(10);

        //门磁按钮状态
        //Bit位  7   6   5   4   3   2   1   0
        //说明   门磁4   门磁3   门磁2   门磁1   按钮4   按钮3   按钮2   按钮1
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + '门磁状态  1号门磁 2号门磁 3号门磁 4号门磁';
        strRunDetail := strRunDetail + Chr(13) + Chr(10);
        strRunDetail := strRunDetail + '          ';
        if wudp.GetDoorStatusFromRunInfo(strFrame, 1) = 1 then
            strRunDetail := strRunDetail + '   开   '
        else
            strRunDetail := strRunDetail + '   关   ';
        if wudp.GetDoorStatusFromRunInfo(strFrame, 2) = 1 then
            strRunDetail := strRunDetail + '   开   '
        else
            strRunDetail := strRunDetail + '   关   ';
        if wudp.GetDoorStatusFromRunInfo(strFrame, 3) = 1 then
            strRunDetail := strRunDetail + '   开   '
        else
            strRunDetail := strRunDetail + '   关   ';
        if wudp.GetDoorStatusFromRunInfo(strFrame, 4) = 1 then
            strRunDetail := strRunDetail + '   开   '
        else
            strRunDetail := strRunDetail + '   关   ';

        strRunDetail := strRunDetail + Chr(13) + Chr(10);
        //按钮状态
        //Bit位  7   6   5   4   3   2   1   0
        //说明   门磁4   门磁3   门磁2   门磁1   按钮4   按钮3   按钮2   按钮1
        strRunDetail := strRunDetail + '按钮状态  1号按钮 2号按钮 3号按钮 4号按钮';
        strRunDetail := strRunDetail + Chr(13) + Chr(10);
        strRunDetail := strRunDetail + '          ';
        if wudp.GetButtonStatusFromRunInfo(strFrame, 1) = 1 then
            strRunDetail := strRunDetail + ' 松开   '
        else
            strRunDetail := strRunDetail + ' 按下   ';
        if wudp.GetButtonStatusFromRunInfo(strFrame, 2) = 1 then
            strRunDetail := strRunDetail + ' 松开   '
        else
            strRunDetail := strRunDetail + ' 按下   ';
        if wudp.GetButtonStatusFromRunInfo(strFrame, 3) = 1 then
            strRunDetail := strRunDetail + ' 松开   '
        else
            strRunDetail := strRunDetail + ' 按下   ';
        if wudp.GetButtonStatusFromRunInfo(strFrame, 4) = 1 then
            strRunDetail := strRunDetail + ' 松开   '
        else
            strRunDetail := strRunDetail + ' 按下   ';

        strRunDetail := strRunDetail + Chr(13) + Chr(10) + '故障状态:' + Chr(9);
        errorNo := wudp.GetErrorNoFromRunInfo(strFrame);
        if errorNo = 0 then
            strRunDetail := strRunDetail + ' 无故障  '
        else begin
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
        Text1.Text := Text1.Text + strRunDetail;
    end;

    //查询控制器的IP设置
    //读取网络配置信息指令
    strCmd := wudp.CreateBstrCommand(controllerSN, '0111'); //生成指令帧 读取网络配置信息指令
    strFrame := wudp.udp_comm(strCmd, ipAddr, 60000); //发送指令, 并获取返回信息
    if ((wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //没有收到数据,
        //失败处理代码... (查ErrCode针对性分析处理)
        Exit;
    end
    else begin
        strRunDetail := '';

        //'MAC
        startLoc := 11;

        strRunDetail := strRunDetail + Chr(13) + Chr(10) + 'MAC:' + chr(9) + chr(9) + (copy(strFrame, startLoc, 2));
        strRunDetail := strRunDetail + '-' + (copy(strFrame, startLoc + 2, 2));
        strRunDetail := strRunDetail + '-' + (copy(strFrame, startLoc + 4, 2));
        strRunDetail := strRunDetail + '-' + (copy(strFrame, startLoc + 6, 2));
        strRunDetail := strRunDetail + '-' + (copy(strFrame, startLoc + 8, 2));
        strRunDetail := strRunDetail + '-' + (copy(strFrame, startLoc + 10, 2));

        strMac := copy(strFrame, startLoc, 12);

        //IP
        startLoc := 23;
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + 'IP:' + chr(9) + chr(9) + IntToStr(StrToInt('$' + (copy(strFrame, startLoc, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLoc + 2, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLoc + 4, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLoc + 6, 2))));

        //Subnet Mask
        startLoc := 31;
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + '子网掩码:' + chr(9) + IntToStr(StrToInt('$' + (copy(strFrame, startLoc, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLoc + 2, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLoc + 4, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLoc + 6, 2))));


        //Default Gateway
        startLoc := 39;
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + '网关:' + chr(9) + chr(9) + IntToStr(StrToInt('$' + (copy(strFrame, startLoc, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLoc + 2, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLoc + 4, 2))));
        strRunDetail := strRunDetail + '.' + IntToStr(StrToInt('$' + (copy(strFrame, startLoc + 6, 2))));

        //TCP Port
        startLoc := 47;
        strRunDetail := strRunDetail + Chr(13) + Chr(10) + 'PORT:' + chr(9) + chr(9) + IntToStr(StrToInt('$' + (copy(strFrame, startLoc + 2, 2)) + (copy(strFrame, startLoc, 2))));
        Text1.Text := Text1.Text + Chr(13) + Chr(10) + strRunDetail + Chr(13) + Chr(10);
    end;

    if (Application.MessageBox('是否重新设置IP？ ', '设置IP', MB_YESNO) = IDYES) then begin
        Text1.Text := Text1.Text + Chr(13) + Chr(10) + '开始IP地址设置: ' + Chr(13) + Chr(10); // + 'IP 192.168.168.90/Mask 255.255.255.0/Gateway 192.168.168.254: Port 60000';

        application.ProcessMessages;

        //新的IP设置: (MAC不变) IP地址: 192.168.168.90; 掩码: 255.255.255.0; 网关: 192.168.168.254; 端口: 60000
        strHexNewIP := wudp.NumToStrHex(EditIP1.Text, 1) + wudp.NumToStrHex(EditIP2.Text, 1) + wudp.NumToStrHex(EditIP3.Text, 1) + wudp.NumToStrHex(EditIP4.Text, 1);
        strHexMask := wudp.NumToStrHex(EditMask1.Text, 1) + wudp.NumToStrHex(EditMask2.Text, 1) + wudp.NumToStrHex(EditMask3.Text, 1) + wudp.NumToStrHex(EditMask4.Text, 1);
        strHexGateway := wudp.NumToStrHex(EditGateway1.Text, 1) + wudp.NumToStrHex(EditGateway2.Text, 1) + wudp.NumToStrHex(EditGateway3.Text, 1) + wudp.NumToStrHex(EditGateway4.Text, 1);

        strCmd := wudp.CreateBstrCommand(controllerSN, 'F211' + strMac + strhexnewip + strhexmask + strhexgateway + '60EA'); // 生成指令帧 读取网络配置信息指令
        ShowMessage('aaaaa=' + strCmd);
        strFrame := wudp.udp_comm(strCmd, ipAddr, 60000); //发送指令, 并获取返回信息
        if ((wudp.ErrCode <> 0) or (strFrame = '')) then begin
            //没有收到数据,
            //失败处理代码... (查ErrCode针对性分析处理)
            Exit;
        end
        else begin
            Text1.Text := Text1.Text + Chr(13) + Chr(10) + 'IP地址设置完成...要等待3秒钟, 请稍候';
            application.ProcessMessages;
            Sleep(DEVICE_INTERNAL); //引入3秒延时
            ret := Application.MessageBox('IP地址设置完成', '', MB_OK)
        end;
    end;



    //采用新的IP地址进行通信
    ipAddr := EditIP1.Text + '.' + EditIP2.Text + '.' + EditIP3.Text + '.' + EditIP4.Text;
    Text1.Text := Text1.Text + Chr(13) + Chr(10) + '采用新的IP地址进行通信' + ipAddr;

    //校准控制器时间
    strCmd := wudp.CreateBstrCommandOfAdjustClockByPCTime(controllerSN); //生成指令帧
    strFrame := wudp.udp_comm(strCmd, ipAddr, 60000); //发送指令, 并获取返回信息
    if ((wudp.ErrCode <> 0) or (strFrame = '')) then
        //没有收到数据,
        //失败处理代码... (查ErrCode针对性分析处理)
        Exit
    else
        Text1.Text := Text1.Text + Chr(13) + Chr(10) + '校准控制器时间成功';


    //远程开1号门
    strCmd := wudp.CreateBstrCommand(controllerSN, '9D10' + '01'); //生成指令帧
    strFrame := wudp.udp_comm(strCmd, ipAddr, 60000); //发送指令, 并获取返回信息
    if ((wudp.ErrCode <> 0) or (strFrame = '')) then
        //没有收到数据,
        //失败处理代码... (查ErrCode针对性分析处理)
        Exit
    else
        Text1.Text := Text1.Text + Chr(13) + Chr(10) + '远程开门成功';


    //提取记录
    recIndex := 1;
    while true do begin
        strFuncData := '8D10' + wudp.NumToStrHex(recIndex, 4); // wudp.NumToStrHex(recIndex,4) 表示第recIndex个记录
        strCmd := wudp.CreateBstrCommand(controllerSN, strFuncData); //生成指令帧 8D10为提取记录指令
        strFrame := wudp.udp_comm(strCmd, ipAddr, 60000); //发送指令, 并获取返回信息
        if ((wudp.ErrCode <> 0) or (strFrame = '')) then begin
            //没有收到数据,
            //失败处理代码... (查ErrCode针对性分析处理)
            //用户可考虑重试
            Text1.Text := Text1.Text + Chr(13) + Chr(10) + '提取记录出错';
            Exit;
        end
        else begin
            swipeDate := wudp.GetSwipeDateFromRunInfo(strFrame, cardId, status);
            if swipeDate <> '' then begin
                strRunDetail := '卡号: ' + IntToStr(cardId) + Chr(9) + ' 状态:' + Chr(9) + IntToStr(status) + '(' + wudp.NumToStrHex(status, 1) + ')' + Chr(9) + '时间:' + Chr(9) + swipeDate;
                Text1.Text := Text1.Text + Chr(13) + Chr(10) + strRunDetail;
                recIndex := recIndex + 1; //下一条记录
            end
            else begin
                Text1.Text := Text1.Text + Chr(13) + Chr(10) + '提取记录完成. 总共提取记录数 =' + IntToStr(recIndex - 1);
                break;
            end;
        end;
        application.ProcessMessages
    end;


    //删除已提取的记录
    if (recIndex > 1) then {//只有提取了记录才进行删除} begin
        strFuncData := '8E10' + wudp.NumToStrHex(recIndex - 1, 4);
        strCmd := wudp.CreateBstrCommand(controllerSN, strFuncData); //生成指令帧
        strFrame := wudp.udp_comm(strCmd, ipAddr, 60000); //发送指令, 并获取返回信息
        if ((wudp.ErrCode <> 0) or (strFrame = '')) then begin
            //没有收到数据,
            //失败处理代码... (查ErrCode针对性分析处理)
            //用户可考虑重试

            Text1.Text := Text1.Text + Chr(13) + Chr(10) + '删除记录失败';
            Exit;
        end
        else
            Text1.Text := Text1.Text + Chr(13) + Chr(10) + '删除记录成功';
    end;

    //发送权限操作(1.先清空权限)
    strCmd := wudp.CreateBstrCommand(controllerSN, '9310'); //生成指令帧
    strFrame := wudp.udp_comm(strCmd, ipAddr, 60000); //发送指令, 并获取返回信息
    if ((wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //没有收到数据,
        //失败处理代码... (查ErrCode针对性分析处理)
        //用户可考虑重试
        Text1.Text := Text1.Text + Chr(13) + Chr(10) + '清空权限失败';
        Exit;
    end
    else
        Text1.Text := Text1.Text + Chr(13) + Chr(10) + '清空权限成功';


    //发送权限操作(2.再添加权限)
    //权限格式: 卡号（2）+区号（1）+门号（1）+卡起始年月日（2）+卡截止年月日（2）+ 控制时段索引号（1）+密码（3）+备用（4，用0填充）
    //发送权限按: 先发1号门(卡号小的先发), 再发2号门(卡号小的先发)
    //此案例中权限设为: 卡有效期从(2007-8-14 到2020-12-31), 采用默认时段1(任意时间有效), 缺省密码(1234), 备用值以00填充
    //以三个卡： 07217564 [9C4448]，342681[B9A603]，25409969[F126FE]为例，分别可以通过控制器的2个门。
    //实际使用按需修改

    //!!!!!!!注意:  此处卡号已直接按从小到大排列赋值了. 实际使用中要用算法实现排序
    cardno[0] := 6848134;
    cardno[1] := 7217564;
    cardno[2] := 25409969;
    privilegeIndex := 1;
    for doorIndex := 0 to 1 do
        for cardIndex := 0 to 2 do begin
            privilege := '';
            privilege := wudp.CardToStrHex(cardno[cardIndex]); //卡号
            privilege := privilege + wudp.NumToStrHex(doorIndex + 1, 1); //门号
            privilege := privilege + wudp.MSDateYmdToWCDateYmd('2007-8-14'); //有效起始日期
            privilege := privilege + wudp.MSDateYmdToWCDateYmd('2020-12-31'); //有效截止日期
            privilege := privilege + wudp.NumToStrHex(1, 1); //时段索引号
            privilege := privilege + wudp.NumToStrHex(123456, 3); //用户密码
            privilege := privilege + wudp.NumToStrHex(0, 4); //备用4字节(用0填充)
            if (Length(privilege) <> (16 * 2)) then
                //生成的权限不符合要求, 请查一下上一指令中写入的每个参数是否正确
                Exit;
            strFuncData := '9B10' + wudp.NumToStrHex(privilegeIndex, 2) + privilege;
            strCmd := wudp.CreateBstrCommand(controllerSN, strFuncData); //生成指令帧
            strFrame := wudp.udp_comm(strCmd, ipAddr, 60000); //发送指令, 并获取返回信息

            if ((wudp.ErrCode <> 0) or (strFrame = '')) then begin
                //没有收到数据,
                //失败处理代码... (查ErrCode针对性分析处理)
                //用户可考虑重试
                Text1.Text := Text1.Text + Chr(13) + Chr(10) + '添加权限失败';
                Exit;
            end
            else
                privilegeIndex := privilegeIndex + 1;
        end;
    Text1.Text := Text1.Text + Chr(13) + Chr(10) + '添加权限数 := ' + IntToStr(privilegeIndex - 1);


    //发送控制时段
    //发送要设定的时段 [注意0,1时段为系统固定化,更改是无效的, 所以设定的时段一般从2开始]
    //此案例设定时段2: 从2007-8-1到2007-12-31日
    // 星期1到5允许在7:30-12:30, 13:30-17:30, 19:00-21:00通过, 其他时间不允许
    timeseg := '';
    timeseg := timeseg + wudp.NumToStrHex($1F, 1); //星期控制
    timeseg := timeseg + wudp.NumToStrHex(0, 1); // 下一链接时段(0--表示无)
    timeseg := timeseg + wudp.NumToStrHex(0, 2); // 保留2字节(0填充)
    timeseg := timeseg + wudp.MSDateHmsToWCDateHms('07:30:00'); // 起始时分秒1
    timeseg := timeseg + wudp.MSDateHmsToWCDateHms('12:30:00'); // 终止时分秒1
    timeseg := timeseg + wudp.MSDateHmsToWCDateHms('13:30:00'); // 起始时分秒2
    timeseg := timeseg + wudp.MSDateHmsToWCDateHms('17:30:00'); // 终止时分秒2
    timeseg := timeseg + wudp.MSDateHmsToWCDateHms('19:00:00'); // 起始时分秒3
    timeseg := timeseg + wudp.MSDateHmsToWCDateHms('21:00:00'); // 终止时分秒3
    timeseg := timeseg + wudp.MSDateYmdToWCDateYmd('2007-8-1'); // 起始日期
    timeseg := timeseg + wudp.MSDateYmdToWCDateYmd('2007-12-31'); // 终止日期
    timeseg := timeseg + wudp.NumToStrHex(0, 4); // 保留4字节(0填充)
    if (Length(timeseg) <> (24 * 2)) then
        //生成的时段不符合要求, 请查一下上一指令中写入的每个参数是否正确
        Exit;

    strFuncData := '9710' + wudp.NumToStrHex(2, 2) + timeseg;
    strCmd := wudp.CreateBstrCommand(controllerSN, strFuncData); //生成指令帧
    strFrame := wudp.udp_comm(strCmd, ipAddr, 60000); //发送指令, 并获取返回信息
    if ((wudp.ErrCode <> 0) or (strFrame = '')) then begin
        //没有收到数据,
        //失败处理代码... (查ErrCode针对性分析处理)
        //用户可考虑重试
        Text1.Text := Text1.Text + Chr(13) + Chr(10) + '添加时段失败';
        Exit;
    end
    else
        Text1.Text := Text1.Text + Chr(13) + Chr(10) + '添加时段成功';


    // 实时监控
    // 读取运行状态是实现监控的关键指令。 在进行监控时, 先读取最新记录索引位的记录. 读取到最新的记录， 同时可以获取到刷卡记录数。
    // 这时就可以用读取到刷卡记录数加1填充到要读取的最新记录索引位上，去读取运行状态， 以便获取下一个记录。
    // 如果读取到了新的刷卡记录， 就可以将索引位增1， 否则保持索引位不变。 这样就可以实现数据的实时监控。
    // 遇到通信不上的处理，这时可对串口通信采取超时400-500毫秒作为出错，可重试一次，再接收不到数据， 可认为设备与PC机间的不能通信。
    watchIndex := 0; //缺省从0, 表示先提取最近一个记录
    recCnt := 0; //监控记录计数
    Text1.Text := Text1.Text + Chr(13) + Chr(10) + '开始实时监控......(请刷卡3次)';
    Text1.SelStart := Length(Text1.Text); //显示新加入的数据
    application.ProcessMessages;
    while (recCnt < 3) do {//测试中 读到3个就停止} begin
        strFuncData := '8110' + wudp.NumToStrHex(watchIndex, 3); //wudp.NumToStrHex(watchIndex,3) 表示第watchIndex个记录, 如果是0则取最新一条记录
        strCmd := wudp.CreateBstrCommand(controllerSN, strFuncData); //生成指令帧
        strFrame := wudp.udp_comm(strCmd, ipAddr, 60000); //发送指令, 并获取返回信息
        if ((wudp.ErrCode <> 0) or (strFrame = '')) then
            //没有收到数据,
            //失败处理代码... (查ErrCode针对性分析处理)
            Exit
        else begin
            swipeDate := wudp.GetSwipeDateFromRunInfo(strFrame, cardId, status);
            if swipeDate <> '' then {//有记录时} begin
                strRunDetail := '卡号: ' + wudp.CardToStrHex(cardId) + Chr(9) + ' 状态:' + Chr(9) + IntToStr(status) + '(' + wudp.NumToStrHex(status, 1) + ')' + Chr(9) + '时间:' + Chr(9) + swipeDate + ',strFrame=[' + strFrame + ']';
                Text1.Text := Text1.Text + Chr(13) + Chr(10) + strRunDetail;
                Text1.SelStart := Length(Text1.Text); //显示新加入的数据
                if watchIndex = 0 then //如果收到第一条记录
                    watchIndex := wudp.GetCardRecordCountFromRunInfo(strFrame) + 1 //指向(总记录数+1), 也就是下次刷卡的存储索引位
                else
                    watchIndex := watchIndex + 1; //指向下一个记录位
                recCnt := recCnt + 1; //记录计数
            end;
        end;
        application.ProcessMessages;
    end;
    Text1.Text := Text1.Text + Chr(13) + Chr(10) + '已停止实时监控';
    Text1.SelStart := Length(Text1.Text); //显示新加入的数据
end;

procedure TForm1.btnExitClick(Sender: TObject);
begin
    halt(1);
end;

procedure configDevice();
var
    time1: tdatetime;
    fileHandle: integer;
begin
    if (fileExists(INITDEVSID)) then begin
        DeleteFile(INITDEVSID);
    end;
    fileHandle := FileCreate(INITDEVSID);
    fileclose(fileHandle);

    time1 := Now();
    initDevices();
    Form1.Text1.lines.AddStrings(WorkingDeviceArray);

    Form1.Text1.lines.Add(format('初始化控制器结束--耗费时间：%d 秒', [SecondsBetween(time1, now)]));
    DeleteFile(INITDEVSID);
    Form1.cbDevice.Items.Clear;
    Form1.cbDevice.Items.Add('-');
    if (WorkingDeviceArray.Count > 0) then begin
        Form1.buttonConfig(2);
        Form1.cbDevice.Items.AddStrings(WorkingDeviceArray);
    end
    else begin
        Form1.Text1.lines.Add('未连接到任何设备，请检查网络或用[单一设备测试]功能来逐一设置');
    end;
end;

procedure TForm1.btnConfigDevClick(Sender: TObject);
begin
    with TFromWaitThread.Create(configDevice, '正在连接控制器，请稍后...') do begin
        FreeOnTerminate := True;
        Resume;
    end;
end;



procedure TForm1.btnInitPrivilegeClick(Sender: TObject);
begin
    with TFromWaitThread.Create(initPrivilege, '正在重新下发权限，请稍后...') do begin
        FreeOnTerminate := True;
        Resume;
    end;
end;

procedure TForm1.btnMonitorDeviceClick(Sender: TObject);
begin
    text1.Lines.Add(monitorDevice(StrToInt64(EditSN.Text)));
end;

procedure TForm1.btnDownloadClick(Sender: TObject);
var
    devList, cardList, doorList: TStringList;
    ip, cardphyid: string;
    i, j, devSN, doorIndex: integer;
    time1: TDateTime;
    fileHandle: integer;
begin
    if (fileExists(DOWNPRIVSID)) then begin
        DeleteFile(DOWNPRIVSID);
    end;
    fileHandle := FileCreate(DOWNPRIVSID);
    FileClose(fileHandle);

    time1 := Now();
    syncData(2);
    cardList := TStringList.Create;
    //cardList.LoadFromFile(ExtractFilePath(paramstr(0)) + syncfilename);
    if (syncfilename <> '') then
        cardList.LoadFromFile(syncfilename);

    doorList := TStringList.Create;
    doorList.Delimiter := ',';
    doorList.DelimitedText := c10doorno;

    for i := 0 to WorkingDeviceArray.Count - 1 do begin
        devList := TStringList.Create;
        devList.Delimiter := ',';
        devList.DelimitedText := WorkingDeviceArray[i];
        devSN := StrToInt64(devList[0]);
        ip := devList[1];
        devList.Free;

        for doorIndex := 0 to doorList.Count - 1 do begin
            for j := 0 to cardList.Count - 1 do begin
                cardphyid := copy(cardList[j], 3, (Pos(',1', cardList[j]) - 3));
                iTryAgain := 0;
                if (Pos(',1', cardList[j]) > 0) then begin
                    addOrModifyPrivilege(devSN, ip, cardphyid, StrToInt(doorList[doorIndex]));
                end
                else begin
                    deletePrivilege(devSN, ip, cardphyid, StrToInt(doorList[doorIndex]));
                end;
                sleep(downinternal);
            end;
        end;
    end;
    doorList.Free;
    cardList.Free;
    DeleteFile(DOWNPRIVSID);

    text1.Lines.Add('所有设备权限增量下发完成，等待下一次增量下发');
    Text1.lines.Add(format('权限增量下发完成--耗费时间：%d 秒', [SecondsBetween(time1, now)]));

end;

procedure TForm1.btnSyncTImeClick(Sender: TObject);
var
    i, devSN: integer;
    ip: string;
    devList: TStrings;
    time1: tdatetime;
begin
    time1 := Now();
    for i := 0 to WorkingDeviceArray.Count - 1 do begin
        devList := TStringList.Create;
        devList.Delimiter := ',';
        devList.DelimitedText := WorkingDeviceArray[i];
        devSN := StrToInt64(devList[0]);
        ip := devList[1];
        devList.Free;
        //getDeviceStatus(devSN);
        if (verifyDevClock(devSN, ip)) then begin
            text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',时间校准成功');
        end
        else begin
            text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',时间校准失败');
        end;
    end;
    Text1.lines.Add(format('设备时间校准完成--耗费时间：%d 秒', [SecondsBetween(time1, now)]));

end;

procedure TForm1.btnGetPrivilegeClick(Sender: TObject);
var
    i, devSN: integer;
    ip: WideString;
    devList: TStrings;
begin
    for i := 0 to WorkingDeviceArray.Count - 1 do begin
        devList := TStringList.Create;
        devList.Delimiter := ',';
        devList.DelimitedText := WorkingDeviceArray[i];
        devSN := StrToInt64(devList[0]);
        ip := devList[1];
        devList.Free;
        //devPrivilegeCount := getPrivilegeCount(devSN, ip);
        if (getDeviceStatus(devSN)) then begin
            text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',权限个数=' + devPrivilegeCount);
        end
        else begin
            text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',权限读取失败');
        end;
        text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',记录个数=' + devRecordCount);
        text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',设备时间=' + devClock);

    end;
    text1.Lines.Add('所有设备权限读取完成');
end;

procedure TForm1.btnDeletePrivilegeClick(Sender: TObject);
var
    i, devSN, doorNo, iPos: integer;
    ip: WideString;
    devList: TStrings;
    cardphyid: string;
    //    tempSQL: string;
begin
    if (edtStuempno.Text <> '') then begin
        verifyUser(1, edtStuempno.Text);
    end
    else if ((trim(edit2.Text) <> '') and (Length(edit2.Text) = 8)) then begin
        if (verifyUser(2, UpperCase(trim(edit2.Text)))) then begin
            if (cbDevice.Text = '-') or (cbDevice.Text = '') then begin
                for i := 0 to WorkingDeviceArray.Count - 1 do begin
                    devList := TStringList.Create;
                    devList.Delimiter := ',';
                    devList.DelimitedText := WorkingDeviceArray[i];
                    devSN := StrToInt64(devList[0]);
                    ip := devList[1];
                    devList.Free;

                    cardphyid := copy(Edit2.text, 3, 6);
                    doorNo := StrToInt(Edit3.Text);
                    iTryAgain := 0;
                    if (deletePrivilege(devSN, ip, cardphyid, doorNo)) then begin
                        text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',卡号=[' + cardphyid + '],权限删除成功');
                    end
                    else begin
                        text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',卡号=[' + cardphyid + '],权限读取失败');
                    end;
                end;
            end
            else begin
                iPos := Pos(',', cbDevice.Text);
                devSN := StrToInt64(copy(cbDevice.Text, 1, iPos - 1));
                ip := copy(cbDevice.Text, iPos + 1, length(cbDevice.Text) - iPos);
                cardphyid := copy(Edit2.text, 3, 6);
                doorNo := StrToInt(Edit3.Text);
                if (deletePrivilege(devSN, ip, cardphyid, doorNo)) then begin
                    text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',卡号=[' + cardphyid + '],权限删除成功');
                end
                else begin
                    text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',卡号=[' + cardphyid + '],权限删除失败');
                end;
            end;
        end
        else begin
            text1.Lines.Add('【卡号】不正确！');
            text1.Lines.Add(format('未找到卡信息，请检查【卡号=%s】【学工号=%s】是否正确！', [edit2.Text, trim(edtStuempno.Text)]));
        end;
    end
    else begin
        text1.Lines.Add('【学工号】不正确！');
        text1.Lines.Add(format('未找到卡信息，请检查【卡号=%s】【学工号=%s】是否正确！', [edit2.Text, trim(edtStuempno.Text)]));
    end;

    text1.Lines.Add('权限删除完成');
end;

procedure TForm1.btnCleanPrivilegeClick(Sender: TObject);
var
    i, devSN: integer;
    ip: WideString;
    devList: TStrings;
begin
    if (Application.MessageBox('是否清空所有通道机权限名单？ ', '清空权限', MB_YESNO) = IDYES) then begin
        for i := 0 to WorkingDeviceArray.Count - 1 do begin
            devList := TStringList.Create;
            devList.Delimiter := ',';
            devList.DelimitedText := WorkingDeviceArray[i];
            devSN := StrToInt64(devList[0]);
            ip := devList[1];
            devList.Free;

            if (cleanPrivilege(devSN, ip)) then begin
                text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',权限清空成功');
            end
            else begin
                text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',权限清空失败');
            end;
        end;

        text1.Lines.Add('权限清空完成');
    end;

end;

procedure TForm1.btnAddPrivClick(Sender: TObject);
var
    i, devSN, doorNo, iPos: integer;
    ip: WideString;
    devList: TStrings;
    cardphyid: string;
    //    tempSQL: string;
begin
    if (edtStuempno.Text <> '') then begin
        verifyUser(1, edtStuempno.Text);
    end
    else if ((trim(edit2.Text) <> '') and (Length(edit2.Text) = 8)) then begin
        verifyUser(2, UpperCase(trim(edit2.Text)));
        if (cbDevice.Text = '-') or (cbDevice.Text = '') then begin
            for i := 0 to WorkingDeviceArray.Count - 1 do begin
                devList := TStringList.Create;
                devList.Delimiter := ',';
                devList.DelimitedText := WorkingDeviceArray[i];
                devSN := StrToInt64(devList[0]);
                ip := devList[1];
                devList.Free;

                cardphyid := copy(Edit2.text, 3, 6);
                doorNo := StrToInt(Edit3.Text);
                iTryAgain := 0;
                if (addOrModifyPrivilege(devSN, ip, cardphyid, doorNo)) then begin
                    text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',卡号=[' + cardphyid + '],权限添加成功');
                end
                else begin
                    text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',卡号=[' + cardphyid + '],权限添加失败');
                end;
            end;
        end
        else begin
            iPos := Pos(',', cbDevice.Text);
            devSN := StrToInt64(copy(cbDevice.Text, 1, iPos - 1));
            ip := copy(cbDevice.Text, iPos + 1, length(cbDevice.Text) - iPos);
            cardphyid := copy(Edit2.text, 3, 6);
            doorNo := StrToInt(Edit3.Text);
            if (addOrModifyPrivilege(devSN, ip, cardphyid, doorNo)) then begin
                text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',卡号=[' + cardphyid + '],权限添加成功');
            end
            else begin
                text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',卡号=[' + cardphyid + '],权限添加失败');
            end;
        end;
    end
    else begin
        text1.Lines.Add('【卡号】或【学工号】不正确！');
        text1.Lines.Add(format('未找到卡信息，请检查【卡号=%s】【学工号=%s】是否正确！', [edit2.Text, trim(edtStuempno.Text)]));
    end;

    text1.Lines.Add('权限添加完成');

end;

procedure TForm1.btnManualRecordClick(Sender: TObject);
begin
    with TFromWaitThread.Create(syncGetData, '正在手工提取机器，请稍后...') do begin
        FreeOnTerminate := True;
        Resume;
    end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
    getData(2);
    Text1.Lines.Add(format('下次提取记录的时间为：%s，请等待...',
        [FormatDateTime('yyyy-mm-dd HH:mm:ss', IncMinute(Now(), c10interval))]));
end;

procedure TForm1.btnAutoGetClick(Sender: TObject);
begin
    timer1.Interval := c10interval * 60 * 1000;
    timer1.Enabled := true;
    btnAutoGet.Enabled := false;
    N2.Enabled := false;
    Text1.Lines.Add(format('下次提取记录的时间为：%s，请等待...',
        [FormatDateTime('yyyy-mm-dd HH:mm:ss', IncMinute(Now(), c10interval))]));
end;

procedure TForm1.btnSyncDataClick(Sender: TObject);
begin
    syncData(1);
end;

procedure tform1.getData(dataType: integer);
var
    i, devSN: integer;
    ip: WideString;
    devList: TStrings;
    time1: tdatetime;
    fileHandle: integer;
begin
    datafilename := FormatDateTime('yyyymmddHHmmss', Now());
    if (fileExists(GETDATASID)) then begin
        DeleteFile(GETDATASID);
    end;
    filehandle := FileCreate(GETDATASID);
    FileClose(fileHandle);

    time1 := Now();

    for i := 0 to WorkingDeviceArray.Count - 1 do begin
        devList := TStringList.Create;
        devList.Delimiter := ',';
        devList.DelimitedText := WorkingDeviceArray[i];
        devSN := StrToInt64(devList[0]);
        ip := devList[1];
        devList.Free;

        text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',待提取记录数=[' + IntToStr(getRecordCount(devSN, ip)) + '],开始提取...');
        getRecord(devSN, ip);

        //text1.Lines.AddStrings(DeviceRecords);
        if (DeviceRecords.Count > 0) then begin
            DeviceRecords.SaveToFile(ExtractFilePath(paramstr(0)) + '..\data\'
                + IntToStr(devSN) + '-' + datafilename + '.txt');
        end;

        text1.Lines.Add(IntToStr(devSN) + ',' + ip + ',交易记录数=[' + IntToStr(DeviceRecords.Count) + '],记录提取完成');
        DeviceRecords.Clear;
    end;
    if dataType = 1 then begin
        text1.Lines.Add('记录手工提取完成');
    end
    else if dataType = 2 then begin
        text1.Lines.Add('记录自动提取完成');
    end;
    DeleteFile(GETDATASID);
    datafilename := '';

    Text1.lines.Add(format('刷卡记录提取--耗费时间：%d 秒', [SecondsBetween(time1, now)]));

end;

procedure tform1.syncData(syncType: integer);
var
    lastdealtime, newdealtime: string;
    yktServer: string;
    yktUser: string;
    yktPass: string;
    yktCardSQL: string;
    time1: TDatetime;
    syncdataList: TStringList;
    fileHandle: integer;
begin
    if (fileExists(SYNCDATASID)) then begin
        DeleteFile(SYNCDATASID);
    end;
    fileHandle := FileCreate(SYNCDATASID);
    FileClose(fileHandle);

    time1 := Now();
    if iniConfig = nil then
        iniConfig := TInifile.Create(ExtractFilePath(paramstr(0)) + '..\config\' + CONFIGFILE);

    lastdealtime := iniConfig.readstring('yczn', 'lastdeal', '0');

    APP_DEBUGMODE := iniConfig.ReadBool('yczn', 'debug', false);
    if APP_DEBUGMODE then begin
        yktServer := iniConfig.readstring('ykt', 'serverurl', '127.0.0.1:1521:yktdb');
        yktUser := iniConfig.readstring('ykt', 'user', 'ykt_cur');
        yktPass := iniConfig.readstring('ykt', 'pass', 'kingstar');
        iniConfig.WriteString('ykt', 'serverurl', EncryptString(Trim(yktServer), CryptKey));
        iniConfig.WriteString('ykt', 'user', EncryptString(Trim(yktUser), CryptKey));
        iniConfig.WriteString('ykt', 'pass', EncryptString(Trim(yktPass), CryptKey));
        iniConfig.WriteBool('yczn', 'debug', false);
    end
    else begin
        yktServer := trim(DecryptString(iniConfig.readstring('ykt', 'serverurl', '127.0.0.1:1521:yktdb'), CryptKey));
        yktUser := trim(DecryptString(iniConfig.readstring('ykt', 'user', 'ykt_cur'), CryptKey));
        yktPass := trim(DecryptString(iniConfig.readstring('ykt', 'pass', 'kingstar'), CryptKey));
    end;

    yktCardSQL := Format(iniConfig.readstring('ykt', 'cardsql', 'select * from ykt_cur.V_CUSTCARDINFO where cardupdtime>%s order by cardupdtime desc'), [lastdealtime]);

    if (syncType = 1) then begin
        syncfilename := ExtractFilePath(paramstr(0)) + CARDLISTFILE;
    end
    else if (syncType = 2) then begin
        syncfilename := ExtractFilePath(paramstr(0)) + FormatDateTime('yyyymmddHHmmss', Now()) + '.txt';
    end
    else begin
        syncfilename := ExtractFilePath(paramstr(0)) + CARDLISTFILE;
    end;

    syncdataList := TStringList.Create;

    OraSession1.Server := yktServer;
    OraSession1.Username := yktUser;
    OraSession1.Password := yktPass;

    if OraSession1.Connected = false then
        OraSession1.Connect;
    OraQuery1.close;
    OraQuery1.SQL.Clear;
    OraQuery1.SQL.Add('select max(cardupdtime) as cardupdtime  from ykt_cur.V_CUSTCARDINFO');
    OraQuery1.ExecSQL;
    OraQuery1.First;
    newdealtime := OraQuery1.FieldByName('cardupdtime').AsString;
    OraQuery1.close;


    OraQuery1.SQL.Clear;
    OraQuery1.SQL.Add(yktCardSQL);
    OraQuery1.ExecSQL;
    //ShowMessage(IntToStr(OraQuery1.RecordCount));
    while not OraQuery1.Eof do begin
        syncdataList.Add(OraQuery1.FieldByName('cardid').AsString + ',' + OraQuery1.FieldByName('cardstatus').AsString);
        //Text1.lines.Add('卡号=[' + OraQuery1.FieldByName('cardid').AsString + '],抽取完毕');
        OraQuery1.Next;
    end;
    OraQuery1.Close;

    if (syncdataList.Count > 0) then begin
        syncdataList.SaveToFile(syncfilename);
    end
    else begin
        syncfilename := '';
    end;
    syncdataList.Free;

    Text1.lines.Add('ykt数据抽取完毕,最后同步时间：' + newdealtime);
    iniConfig.WriteString('yczn', 'lastdeal', newdealtime);
    //iniConfig.Free;
    DeleteFile(SYNCDATASID);
    Text1.lines.Add(format('ykt数据抽取--耗费时间：%d 秒', [SecondsBetween(time1, now)]));

end;

procedure tform1.insertDataToYKT(recordFilename: string);
var
    recFile, recInfo: TStringList;
    yktServer: string;
    yktUser: string;
    yktPass: string;
    tempSQL: string;
    i: integer;
    eventInfo: string;
begin
    if iniConfig = nil then
        iniConfig := TInifile.Create(ExtractFilePath(paramstr(0)) + '..\config\' + CONFIGFILE);
    APP_DEBUGMODE := iniConfig.ReadBool('yczn', 'debug', false);
    if APP_DEBUGMODE then begin
        yktServer := iniConfig.readstring('ykt', 'serverurl', '127.0.0.1:1521:yktdb');
        yktUser := iniConfig.readstring('ykt', 'user', 'ykt_cur');
        yktPass := iniConfig.readstring('ykt', 'pass', 'kingstar');
        iniConfig.WriteString('ykt', 'serverurl', EncryptString(Trim(yktServer), CryptKey));
        iniConfig.WriteString('ykt', 'user', EncryptString(Trim(yktUser), CryptKey));
        iniConfig.WriteString('ykt', 'pass', EncryptString(Trim(yktPass), CryptKey));
        iniConfig.WriteBool('yczn', 'debug', false);
    end
    else begin
        yktServer := trim(DecryptString(iniConfig.readstring('ykt', 'serverurl', '127.0.0.1:1521:yktdb'), CryptKey));
        yktUser := trim(DecryptString(iniConfig.readstring('ykt', 'user', 'ykt_cur'), CryptKey));
        yktPass := trim(DecryptString(iniConfig.readstring('ykt', 'pass', 'kingstar'), CryptKey));
    end;

    //iniConfig.Free;

    recFile := TStringList.create;
    recFile.LoadFromFile(ExtractFilePath(paramstr(0)) + '..\data\' + recordFilename);

    OraSession1.Server := yktServer;
    OraSession1.Username := yktUser;
    OraSession1.Password := yktPass;
    if OraSession1.Connected = false then
        OraSession1.Connect;

    recInfo := TStringList.create;
    recInfo.Delimiter := ',';

    for i := 0 to recFile.Count - 1 do begin
        tempSQL := 'insert into ykt_cur.t_doordtl (TRANSDATE, TRANSTIME, DEVICEID,DEVPHYID, DEVSEQNO,'
            + ' COLDATE, COLTIME, CARDNO, CARDPHYID,SHOWCARDNO, STUEMPNO, CUSTID, CUSTNAME, TRANSMARK,SYSID) values'
            + ' (%s,%s,%s,''%s'',%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)';
        recInfo.DelimitedText := recFile[i];

        eventInfo := '-9999';
        if (recInfo[4] = '0') then begin
            eventInfo := '8800';
        end
        else if (recInfo[4] = '144') then begin
            eventInfo := '8801';
            //edit2.Text := '45' + recInfo[1];
            if (Pos('[' + recInfo[1] + ']', text1.text) <= 0) then begin
                if (verifyUser(2, recInfo[1])) then begin
                    btnDeletePrivilegeClick(btnDeletePrivilege);
                    btnAddPrivClick(btnAddPriv);
                end;
            end;
        end
        else begin
            eventInfo := recInfo[4];
        end;
        tempSQL := Format(tempSQL, [
            'to_char(to_date(''' + recInfo[2] + ''',''yyyy-mm-dd''),''yyyymmdd'')',
                'to_char(to_date(''' + recInfo[3] + ''',''hh24:mi:ss''),''hh24miss'')',
                'nvl((select deviceid from ykt_cur.t_device where devphyid=''' + recInfo[0] + ''' and status=''1''),0)',
                recInfo[0],
                'to_number(to_char(sysdate,''yyyymmddhh24miss'')||''' + IntToStr(i) + ''')',
                'to_char(sysdate,''yyyymmdd'')',
                'to_char(sysdate,''hh24miss'')',
                'nvl((select cardno from ykt_cur.t_card where cardphyid like ''%' + recInfo[1] + ''' and status=''1'' and rownum<2),0)',
                'nvl((select cardphyid from ykt_cur.t_card where cardphyid like ''%' + recInfo[1] + ''' and status=''1'' and rownum<2),0)',
                'nvl((select showcardno from ykt_cur.t_card where cardphyid like ''%' + recInfo[1] + ''' and status=''1'' and rownum<2),0)',
                'nvl((select b.stuempno from ykt_cur.t_card a, ykt_cur.t_customer b where a.custid=b.custid and a.cardphyid like ''%' + recInfo[1] + ''' and a.status=''1'' and rownum<2),0)',
                'nvl((select b.CUSTID from ykt_cur.t_card a, ykt_cur.t_customer b where a.custid=b.custid and a.cardphyid like ''%' + recInfo[1] + ''' and a.status=''1'' and rownum<2),0)',
                'nvl((select b.CUSTNAME from ykt_cur.t_card a, ykt_cur.t_customer b where a.custid=b.custid and a.cardphyid like ''%' + recInfo[1] + ''' and a.status=''1'' and rownum<2),0)',
                eventInfo,
                'nvl((select sysid from ykt_cur.t_device where devphyid=''' + recInfo[0] + ''' and status=''1''),0)'
                ]);
        Text1.Lines.Add(tempSQL);

        try
            OraQuery1.close;
            OraQuery1.SQL.Clear;
            OraQuery1.SQL.Add(tempSQL);
            OraQuery1.ExecSQL;
        except
            writeLog('Error:' + tempSQL);
        end;
    end;
    recInfo.Free;
    recFile.free;

    MoveFile(PAnsiChar(ExtractFilePath(paramstr(0)) + '..\data\' + recordFilename), PChar(ExtractFilePath(paramstr(0)) + '..\data\bak\' + recordFilename));
end;

procedure TForm1.btnAutoSyncClick(Sender: TObject);
begin
    timer3.Interval := c10interval * 60 * 1000;
    if APP_DEBUGMODE = true then
        timer3.Interval := 5000;
    timer3.Enabled := true;
    btnAutoSync.Enabled := false;
    N1.Enabled := false;
    TimerLabel8.Enabled := true;
    Label8.Caption := IntToStr(c10interval * 60);
    Text1.Lines.Add(format('下次同步名单的时间为：%s，请等待...',
        [FormatDateTime('yyyy-mm-dd HH:mm:ss', IncMinute(Now(), c10interval))]));
end;

procedure TForm1.btnStopTaskClick(Sender: TObject);
begin
    timer1.enabled := false;
    timer2.enabled := false;
    timer3.enabled := false;
    btnAutoSync.Enabled := true;
    btnAutoGet.Enabled := true;
    btnAutoUpload.Enabled := true;
    N1.Enabled := true;
    N2.Enabled := true;
    N3.Enabled := true;
end;

procedure TForm1.uploadDataToYKT();
var
    FileAttrs, i: Integer;
    sr: TSearchRec;
    uploadList: TStringList;
    time1: TDatetime;
    fileHandle: integer;
begin
    if (fileExists(UPLOADDATASID)) then begin
        DeleteFile(UPLOADDATASID);
    end;
    fileHandle := FileCreate(UPLOADDATASID);
    FileClose(fileHandle);
    time1 := Now();

    uploadList := TStringList.Create;

    FileAttrs := 0;
    FileAttrs := FileAttrs + faAnyFile;
    if FindFirst(ExtractFilePath(paramstr(0)) + '..\data\*', FileAttrs, sr) = 0 then begin
        repeat
            if (sr.Attr and FileAttrs) = sr.Attr then begin
                if ((sr.Name = '.') or (sr.Name = '..') or ((Sr.Attr and faDirectory) <> 0)) then Continue;
                if (fileExists(GETDATASID)) then begin
                    if (Pos(datafilename, sr.Name) > 0) then begin
                        Continue;
                    end;
                end;

                uploadList.Add(sr.Name);
            end;
        until FindNext(sr) <> 0;
        FindClose(sr);
    end;
    //Text1.Lines.AddStrings(uploadList);

    for i := 0 to uploadList.Count - 1 do begin
        insertDataToYKT(uploadList[i]);
    end;

    uploadList.Free;
    DeleteFile(UPLOADDATASID);
    Text1.lines.Add(format('ykt数据上传结束--耗费时间：%d 秒', [SecondsBetween(time1, now)]));
end;

procedure TForm1.btnAutoUploadClick(Sender: TObject);
begin
    timer2.Interval := c10interval * 60 * 1000;
    timer2.Enabled := true;
    btnAutoUpload.Enabled := false;
    N3.Enabled := false;
    Text1.Lines.Add(format('下次自动上传的时间为：%s，请等待...',
        [FormatDateTime('yyyy-mm-dd HH:mm:ss', IncMinute(Now(), c10interval))]));
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
    uploadDataToYKT();
    Text1.Lines.Add(format('下次自动上传的时间为：%s，请等待...',
        [FormatDateTime('yyyy-mm-dd HH:mm:ss', IncMinute(Now(), c10interval))]));
end;

procedure TForm1.btnUploadDataClick(Sender: TObject);
begin
    uploadDataToYKT();
end;

procedure TForm1.Timer3Timer(Sender: TObject);
begin
    btnDownloadClick(btnDownload);
    //syncData(2);
    Text1.Lines.Add(format('下次下发权限的时间为：%s，请等待...',
        [FormatDateTime('yyyy-mm-dd HH:mm:ss', IncMinute(Now(), c10interval))]));
end;

procedure TForm1.Timer4Timer(Sender: TObject);
begin
    btnSyncTImeClick(btnSyncTIme);
    Text1.Lines.Add(format('下次校准设备时钟的时间为：%s，请等待...',
        [FormatDateTime('yyyy-mm-dd HH:mm:ss', IncMinute(Now(), 60))]));
end;

procedure TForm1.TimerLabel8Timer(Sender: TObject);
begin
    if (StrToInt(Label8.Caption) > 0) then
        Label8.Caption := IntToStr(StrToInt(Label8.Caption) - 1);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
    temp: string;
begin
    buttonConfig(1);
    Label8.Caption := '';

    try
        if iniConfig = nil then
            iniConfig := TInifile.Create(ExtractFilePath(paramstr(0)) + '..\config\' + CONFIGFILE);
        APP_DEBUGMODE := iniConfig.ReadBool('yczn', 'debug', false);
        if APP_DEBUGMODE then begin
            iniConfig.WriteString('ykt', 'serverurl', EncryptString(Trim(iniConfig.readstring('ykt', 'serverurl', '127.0.0.1:1521:yktdb')), CryptKey));
            iniConfig.WriteString('ykt', 'user', EncryptString(Trim(iniConfig.readstring('ykt', 'user', 'ykt_cur')), CryptKey));
            iniConfig.WriteString('ykt', 'pass', EncryptString(Trim(iniConfig.readstring('ykt', 'pass', 'kingstar')), CryptKey));
            iniConfig.WriteBool('yczn', 'debug', false);
        end
        else begin
            temp := trim(DecryptString(iniConfig.readstring('ykt', 'serverurl', '127.0.0.1:1521:yktdb'), CryptKey));
            temp := DecryptString(iniConfig.readstring('ykt', 'user', 'ykt_cur1'), CryptKey);
            temp := DecryptString(iniConfig.readstring('ykt', 'pass', 'kingstar1'), CryptKey);
        end;
        iniConfig.Free;
        iniConfig := nil;
    except
        ShowMessage('数据库配置有问题，请联系管理员！');
    end;
end;

procedure TForm1.buttonConfig(opType: integer);
var
    i: integer;
begin
    case opType of
        1: begin
                for i := 0 to form1.ControlCount - 1 do begin
                    if (form1.Controls[i] is TButton) and (form1.Controls[i].Name <> 'btnConfigDev')
                        and (form1.Controls[i].Name <> 'btnConfigOne')
                        and (form1.Controls[i].Name <> 'btnConnectDevice')
                        and (form1.Controls[i].Name <> 'btnExit') then begin
                        form1.Controls[i].Enabled := false;
                    end;
                end;
            end;
        2: begin
                for i := 0 to form1.ControlCount - 1 do begin
                    if (form1.Controls[i] is TButton) then begin
                        form1.Controls[i].Enabled := true;
                    end;
                end;
                btnConfigDev.Enabled := false;
            end;

        3: Caption := 'Out of range';
    end;
end;


procedure TForm1.BitBtn1Click(Sender: TObject);
begin
    IdUDPClient1.Broadcast('7E39C70111000000000000000000000000000000000000000000000000000012010D', 60000);
    Text1.Lines.Add(IdUDPClient1.ReceiveString(-1));
end;

procedure TForm1.Button1Click(Sender: TObject);
var
    i: integer;
    tmp: string;
begin
    tmp := 'aaa1dd,bbbbc';
    i := Pos(',', tmp);
    text1.Lines.Add(tmp + '---------' + copy(tmp, 1, i - 1));
    text1.Lines.Add(tmp + '---------' + copy(tmp, i + 1, length(tmp) - i));
    text1.Lines.Add('123456[aaa]');
    text1.Lines.Add(tmp + '---------' + copy(tmp, i + 1, length(tmp) - i));
    text1.Lines.Add(tmp + '---------' + copy(tmp, i + 1, length(tmp) - i));
    if (Pos('[aaa1]', text1.text) > 0) then begin
        ShowMessage('yes.');
    end else begin
        ShowMessage('no.');

    end;

end;

procedure TForm1.N5Click(Sender: TObject);
begin
    ShellExecute(Handle,
        nil,
        'Explorer.exe',
        PChar(Format('/e,/select,%s', [ExtractFilePath(Application.ExeName)])),
        nil,
        SW_NORMAL);
end;

procedure TForm1.btnAlwaysOpenClick(Sender: TObject);
var
    i, devSN: integer;
    ip: WideString;
    devList: TStrings;
begin
    //devAlwaysOpen
    for i := 0 to WorkingDeviceArray.Count - 1 do begin
        devList := TStringList.Create;
        devList.Delimiter := ',';
        devList.DelimitedText := WorkingDeviceArray[i];
        devSN := StrToInt64(devList[0]);
        ip := devList[1];
        devList.Free;
        //doorNo := StrToInt(Edit3.Text);
        if (devAlwaysOpen(devSN, ip, 1, StrToInt(edtDelay.Text))) then begin
            text1.Lines.Add(IntToStr(devSN) + ',' + ip + '],always open成功');
        end
        else begin
            text1.Lines.Add(IntToStr(devSN) + ',' + ip + '],always open失败');
        end;
    end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
    i, devSN: integer;
    ip: WideString;
    devList: TStrings;
begin
    //devAlwaysOpen
    for i := 0 to WorkingDeviceArray.Count - 1 do begin
        devList := TStringList.Create;
        devList.Delimiter := ',';
        devList.DelimitedText := WorkingDeviceArray[i];
        devSN := StrToInt64(devList[0]);
        ip := devList[1];
        devList.Free;
        //doorNo := StrToInt(Edit3.Text);
        if (devAlwaysOpen(devSN, ip, 3, StrToInt(edtDelay.Text))) then begin
            text1.Lines.Add(IntToStr(devSN) + ',' + ip + '],readcard open成功');
        end
        else begin
            text1.Lines.Add(IntToStr(devSN) + ',' + ip + '],readcard open失败');
        end;
    end;

end;

procedure TForm1.btnConnectDeviceClick(Sender: TObject);
begin
    with TFromWaitThread.Create(connectDevice, '正在连接控制器，请稍后...') do begin
        FreeOnTerminate := True;
        Resume;
    end;

end;

procedure connectDevice();
var
    time1: tdatetime;
    fileHandle: integer;
begin
    if (fileExists(INITDEVSID)) then begin
        DeleteFile(INITDEVSID);
    end;
    fileHandle := FileCreate(INITDEVSID);
    fileclose(fileHandle);

    time1 := Now();
    connectDevices();
    Form1.Text1.lines.AddStrings(WorkingDeviceArray);

    Form1.Text1.lines.Add(format('初始化控制器结束--耗费时间：%d 秒', [SecondsBetween(time1, now)]));
    DeleteFile(INITDEVSID);
    Form1.cbDevice.Items.Clear;
    Form1.cbDevice.Items.Add('-');
    if (WorkingDeviceArray.Count > 0) then begin
        Form1.buttonConfig(2);
        Form1.cbDevice.Items.AddStrings(WorkingDeviceArray);
    end
    else begin
        Form1.Text1.lines.Add('未连接到任何设备，请检查网络或用[单一设备测试]功能来逐一设置');
    end;
end;


procedure initPrivilege();
var
    //devList: TStringList;
    cardList, downList: TStringList;
    ip: string;
    i, devSN: integer;
    time1: tdatetime;
    iPos: integer;
begin
    time1 := Now();
    cardList := TStringList.Create;
    cardList.LoadFromFile(ExtractFilePath(paramstr(0)) + CARDLISTFILE);

    downList := TStringList.Create;
    for i := 0 to cardList.Count - 1 do begin
        if (Pos(',1', cardList[i]) > 0) then begin
            downList.Add(cardHexToNo(copy(cardList[i], 3, (Pos(',1', cardList[i]) - 3))));
        end;
    end;
    //由小到大排序卡号
    downList.CustomSort(NumBerSort);

    for i := 0 to WorkingDeviceArray.Count - 1 do begin
        iPos := Pos(',', WorkingDeviceArray[i]);
        devSN := StrToInt64(copy(WorkingDeviceArray[i], 1, iPos - 1));
        ip := copy(WorkingDeviceArray[i], iPos + 1, length(WorkingDeviceArray[i]) - iPos);
        //downloadAllCardByOne(devSN, ip, 1, downList);
        downloadAllCard(devSN, ip, 1, downList);
    end;

    {
    for i := 0 to downList.Count - 1 do begin
        for j := 0 to WorkingDeviceArray.Count - 1 do begin
            devList := TStringList.Create;
            devList.Delimiter := ',';
            devList.DelimitedText := WorkingDeviceArray[j];
            devSN := StrToInt64(devList[0]);
            ip := devList[1];
            devList.Free;
            //downloadAllCardByOneCard(devSN, ip, 1, downList[i]);
            deletePrivilege(devSN,ip,cardnoToHex(StrToInt64(downList[i])),1);

            if (addOrModifyPrivilege(devSN, ip, downList[i], 1) = true) then begin
                Text1.lines.Add('控制器[' + IntToStr(devSN) + '],卡号=[' + cardNoToHex(StrToInt64(downList[j])) + ']添加权限成功');
                //Sleep(downinternal);
                if (form1.Text1.Lines.Count = 200) then begin
                    form1.Text1.Lines.Clear;
                end;
            end
            else begin
                Text1.lines.Add('控制器[' + IntToStr(devSN) + '],卡号=[' + cardNoToHex(StrToInt(downList[j])) + ']添加权限失败');
                writelog('控制器[' + IntToStr(devSN) + '],卡号=[' + cardNoToHex(StrToInt(downList[j])) + ']添加权限失败');
                writeCardList('45' + cardNoToHex(StrToInt(downList[j])) + ',1');
            end;
        end;
    end;
    }

    downList.Free;
    cardList.Free;

    Form1.Text1.lines.Add(format('所有设备权限初始化完成--耗费时间：%d 秒', [SecondsBetween(time1, now)]));
end;

{
iType: 检验方法，1表示用学工号，2表示用物理卡号的后6位或后8位
sParam ：参数值
}

function verifyUser(iType: integer; sParam: string): boolean;
var
    yktServer, yktUser, yktPass: string;
    tempSQL: string;
begin
    result := false;
    //
    if iniConfig = nil then
        iniConfig := TInifile.Create(ExtractFilePath(paramstr(0)) + '..\config\' + CONFIGFILE);
    APP_DEBUGMODE := iniConfig.ReadBool('yczn', 'debug', false);
    if APP_DEBUGMODE then begin
        yktServer := iniConfig.readstring('ykt', 'serverurl', '127.0.0.1:1521:yktdb');
        yktUser := iniConfig.readstring('ykt', 'user', 'ykt_cur');
        yktPass := iniConfig.readstring('ykt', 'pass', 'kingstar');
        iniConfig.WriteString('ykt', 'serverurl', EncryptString(Trim(yktServer), CryptKey));
        iniConfig.WriteString('ykt', 'user', EncryptString(Trim(yktUser), CryptKey));
        iniConfig.WriteString('ykt', 'pass', EncryptString(Trim(yktPass), CryptKey));
        iniConfig.WriteBool('yczn', 'debug', false);
    end
    else begin
        yktServer := trim(DecryptString(iniConfig.readstring('ykt', 'serverurl', '127.0.0.1:1521:yktdb'), CryptKey));
        yktUser := trim(DecryptString(iniConfig.readstring('ykt', 'user', 'ykt_cur'), CryptKey));
        yktPass := trim(DecryptString(iniConfig.readstring('ykt', 'pass', 'kingstar'), CryptKey));
    end;

    //iniConfig.Free;

    Form1.OraSession1.Server := yktServer;
    Form1.OraSession1.Username := yktUser;
    Form1.OraSession1.Password := yktPass;
    if Form1.OraSession1.Connected = false then
        Form1.OraSession1.Connect;

    try
        Form1.OraQuery1.close;
        Form1.OraQuery1.SQL.Clear;
        if (iType = 1) then begin
            tempSQL := 'select cardphyid from ykt_cur.v_custcardinfo where cardstatus=1 and stuempno='''
                + trim(sParam) + '''  ';
        end
        else if (iType = 2) then begin
            tempSQL := 'select cardphyid from ykt_cur.v_custcardinfo where cardstatus=1 and cardphyid like ''%'
                + UpperCase(trim(sParam)) + '''  ';
        end
        else begin
            tempSQL := 'select cardphyid from ykt_cur.v_custcardinfo where cardstatus=1 and stuempno='''
                + trim(sParam) + '''  ';
        end;

        Form1.OraQuery1.SQL.Add(tempSQL);
        Form1.OraQuery1.ExecSQL;
        if (Form1.OraQuery1.RecordCount > 0) then begin
            Form1.OraQuery1.First;
            Form1.edit2.Text := Form1.OraQuery1.FieldByName('cardphyid').AsString;
            result := true;
        end
        else begin
            Form1.text1.Lines.Add('学生[' + trim(sParam) + ']' + '的校园卡不存在或已挂失！');
            Form1.edit2.Text := '';
        end;
        Form1.OraQuery1.Close;
    except
        writeLog('Error:' + tempSQL);
        Form1.text1.Lines.Add('数据库查询失败，请联系系统管理员！');
        Form1.edit2.Text := '';
    end;

end;

procedure syncGetData;
begin
    form1.getData(1);
end;

end.

