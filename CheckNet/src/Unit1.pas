unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,WinInet,inifiles, ComCtrls, StdCtrls, Menus, RzTray;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    StatusBar1: TStatusBar;
    Button1: TButton;
    RzTrayIcon1: TRzTrayIcon;
    PopupMenu1: TPopupMenu;
    Exit1: TMenuItem;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure makeInitConfigFile();
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  timeSeparator : integer;
  urlString : String;
  errContent : String;
  _debug : String;
  _logged : boolean;

implementation

uses
    Unit2,uIO;
{$R *.DFM}

function CheckUrl(url:string):boolean;
var
     hSession, hfile: hInternet;
     dwindex,dwcodelen :dword;
     dwcode:array[1..20] of char;
     res : pchar;
begin
     //检查URL是否包含http://，如果不包含则加上
     if pos('http://',lowercase(url))=0 then
         url := 'http://'+url;

     Result := false;

     hSession := InternetOpen('InetURL:/1.0',
         INTERNET_OPEN_TYPE_PRECONFIG,nil, nil, 0); //建立会话句柄
     if assigned(hsession) then
     begin
         hfile := InternetOpenUrl(hsession, pchar(url), nil, 0,
             INTERNET_FLAG_RELOAD, 0);        //打开URL所指资源

         dwIndex := 0;
         dwCodeLen := 10;
         HttpQueryInfo(hfile, HTTP_QUERY_STATUS_CODE,
             @dwcode, dwcodeLen, dwIndex); //获取返回的HTTP头信息

         res := pchar(@dwcode);
         result:= (res ='200') or (res ='302');

         if assigned(hfile) then
             InternetCloseHandle(hfile);     //关闭URL资源句柄
         InternetCloseHandle(hsession);     //关闭Internet会话句柄
     end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
    if(CheckUrl(urlString)) then begin
        if (_logged) then
            writeLog(FormatDateTime('yyyy-mm-dd hh:nn:ss',Now()) + '    ' + 'Server is ok.');
        StatusBar1.SimpleText := 'url is : ' + urlString + ', success...';
        form2.Panel1.Caption := '';
        form2.Hide;
    end
    else begin
        if (_logged) then
            writeLog(FormatDateTime('yyyy-mm-dd hh:nn:ss',Now()) + '    ' + 'Server is error.');
        StatusBar1.SimpleText := 'url is : ' + urlString + ', connect fail...';
        form2.WindowState := wsMaximized;
        form2.BorderStyle := bsNone;
        form2.Panel1.Caption := errContent;
        form2.FormStyle := fsStayOnTop;
        form2.Show;
    end;
end;

procedure TForm1.FormShow(Sender: TObject);
var
    iniFile : TIniFile;
begin
    iniFile := TIniFile.Create(ExtractFilePath(Application.EXEName) + '..\configs\config.ini');
    timeSeparator:=iniFile.ReadInteger('CheckNet','timeSeparator',60);
    urlString := iniFile.ReadString('CheckNet','urlString','http://www.google.com');
    errContent := iniFile.ReadString('CheckNet','errContent','服务器连接不上,请以后再试!');
    _debug := iniFile.ReadString('System','debug','true');

    if (UpperCase(iniFile.ReadString('System','logged','true'))='TRUE') then begin
        _logged := true;
    end
    else begin
        _logged := false;
    end;

    Timer1.Interval := timeSeparator * 1000;
    if(UpperCase(_debug)='TRUE') then begin
        ShowMessage('Time Separator is:' + IntToStr(timeSeparator));
        ShowMessage('Server URL String is:' + urlString);
        ShowMessage('Error String is:' + errContent);
        Timer1.Enabled:= false;
    end
    else begin
        Timer1.Enabled:= true;
    end;

    iniFile.Free;
    makeInitConfigFile();
end;


procedure TForm1.makeInitConfigFile();
var
    configFilename : String;
    F : Textfile;
begin
    makeDir(ExtractFilePath(Application.EXEName) + '..\configs\');
    configFilename := ExtractFilePath(Application.EXEName) + '..\configs\config.ini';
    if not fileExists(configFilename) then begin
        AssignFile(F, configFilename);
        ReWrite(F);
        Writeln(F, '[System]');
        Writeln(F, 'debug=false');
        Writeln(F, 'logged=true');
        Writeln(F, '[CheckNet]');
        Writeln(F, 'timeSeparator=10');
        Writeln(F, 'urlString=http://www.sina1.com.cn');
        Writeln(F, 'errContent=服务器连接失败，请以后再尝试！');
        Flush(F);
        Closefile(F);
        raise Exception.Create('../configs/config.ini is not found,now use default config and create a new config.ini. please define your params in "../configs/config.ini" ' );
    end;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    if(CheckUrl(urlString)) then begin
        if (_logged) then
            writeLog(FormatDateTime('yyyy-mm-dd hh:nn:ss',Now()) + '    ' + 'Server is ok.');
        StatusBar1.SimpleText := 'url is : ' + urlString + ', success...';
        form2.Panel1.Caption := '';
        form2.Hide;
        Application.Minimize;
    end
    else begin
        if (_logged) then
            writeLog(FormatDateTime('yyyy-mm-dd hh:nn:ss',Now()) + '    ' + 'Server is error.');
        RzTrayIcon1.RestoreApp;
        Application.BringToFront;
        StatusBar1.SimpleText := 'url is : ' + urlString + ', connect fail...';
        form2.WindowState := wsMaximized;
        form2.BorderStyle := bsNone;
        form2.Panel1.Caption := errContent;
        form2.FormStyle := fsStayOnTop;
        form2.Show;
    end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
    Application.Terminate;
end;

end.
