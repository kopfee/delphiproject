unit Unit1;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, CheckLst, Menus, OleCtnrs, ExtCtrls, MPlayer,
    OleServer, PowerPointXP, OleCtrls, WMPLib_TLB, RzPanel, RzTabs, RzSplit;

type
    TForm1 = class(TForm)
        OpenDialog1: TOpenDialog;
        PopupMenu1: TPopupMenu;
        N1: TMenuItem;
        Panel1: TPanel;
        Panel2: TPanel;
        Timer1: TTimer;
        PowerPointApplication1: TPowerPointApplication;
        WindowsMediaPlayer1: TWindowsMediaPlayer;
        RzPageControl1: TRzPageControl;
        TabSheet1: TRzTabSheet;
        TabSheet2: TRzTabSheet;
        TabSheet3: TRzTabSheet;
        TabSheet4: TRzTabSheet;
        TabSheet5: TRzTabSheet;
        RzPanel1: TRzPanel;
        Label1: TLabel;
        lblHint: TLabel;
        btnPlay: TButton;
        btnPause: TButton;
        btnStop: TButton;
        MediaPlayer1: TMediaPlayer;
        RzGroupBox1: TRzGroupBox;
        btnSelect: TButton;
        CheckListBox1: TCheckListBox;
        Splitter1: TSplitter;
        Image1: TImage;
        procedure btnSelectClick(Sender: TObject);
        procedure btnPlayClick(Sender: TObject);
        procedure N1Click(Sender: TObject);
        procedure CheckListBox1DblClick(Sender: TObject);
        procedure Timer1Timer(Sender: TObject);
        procedure btnPauseClick(Sender: TObject);
        procedure btnStopClick(Sender: TObject);
        procedure FormShow(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
        procedure playFile();
    end;

    TTaskThread = class(TThread)
    private
        FFinished: boolean;
        FFilename: string;
        FExecuteTime: TLabel;
        procedure DoOpenFile;
    public
        procedure Execute; override;
        constructor Create(filename: string; executeTime: TLabel);
    end;

procedure SearchFile(path: string);
procedure EnumFileInQueue(path: PChar; sFileExt: string; fileList: TStringList);


var
    Form1: TForm1;
    task: TTaskThread;
    taskPos: integer;
    fileExt: string;
implementation

uses filectrl, Contnrs, StrUtils, UtilOffice;
{$R *.dfm}

constructor TTaskThread.create(filename: string; executeTime: TLabel);
begin
    inherited create(true);
    FFinished := false;
    FFilename := filename;
    FExecuteTime := executeTime;
end;

procedure TTaskThread.execute;
begin
    Synchronize(DoOpenFile);
end;

procedure TTaskThread.DoOpenFile;
begin
    if (fileExt = '.xls') then begin
        OpenExcel(FFilename);
    end else if (fileExt = '.doc') then begin
        OpenWord(FFilename);
    end else if (fileExt = '.ppt') then begin
        OpenPowerPoint(FFilename);
    end else if (fileExt = '.wmv') then begin
        //
    end
    else begin
        //returnValue := false;
    end;

end;

procedure TForm1.btnSelectClick(Sender: TObject);
var
    FileAttrs, i: Integer;
    strPath: string;
    dir: string;
    FileNameList: TStringList;
begin
    OpenDialog1.Title := 'Open目录';
    FileNameList := TStringList.Create;

    CheckListBox1.Items.clear;
    if (SelectDirectory('请选择文件保存的路径', '', strPath)) then begin
        EnumFileInQueue(PChar(strPath), '.*', FileNameList);
    end;

    CheckListBox1.Items.AddStrings(FileNameList);
    FileNameList.Free;
end;

procedure SearchFile(path: string);
var
    SearchRec: TSearchRec;
    found: integer;

begin

    found := FindFirst(path + '\*.* ', faAnyFile, SearchRec);
    while found = 0 do begin
        if (SearchRec.Name <> '.') and (SearchRec.name <> '..') and
            (SearchRec.Attr = faDirectory) then
            SearchFile(SearchRec.Name + '\*.*')
        else
            Form1.CheckListBox1.Items.Add(SearchRec.Name);
        found := FindNext(SearchRec);
    end;
    FindClose(SearchRec);

end;


procedure EnumFileInQueue(path: PChar; sFileExt: string; fileList: TStringList);
var
    searchRec: TSearchRec;
    found: Integer;
    tmpStr: string;
    curDir: string;
    dirs: TQueue;
    pszDir: PChar;
begin
    dirs := TQueue.Create; //创建目录队列
    dirs.Push(path); //将起始搜索路径入队
    pszDir := dirs.Pop;
    curDir := StrPas(pszDir); //出队
    {开始遍历,直至队列为空(即没有目录需要遍历)}
    while (True) do begin
        //加上搜索后缀,得到类似'c:\*.*' 、'c:\windows\*.*'的搜索路径
        tmpStr := curDir + '\*.*';
        //在当前目录查找第一个文件、子目录
        found := FindFirst(tmpStr, faAnyFile, searchRec);
        while found = 0 do {//找到了一个文件或目录后 } begin
            //如果找到的是个目录
            if (searchRec.Attr and faDirectory) <> 0 then begin
                {在搜索非根目录(C:\、D:\)下的子目录时会出现'.','..'的"虚拟目录"
                大概是表示上层目录和下层目录吧。。。要过滤掉才可以}
                if (searchRec.Name <> '.') and (searchRec.Name <> '..') then begin
                    {由于查找到的子目录只有个目录名，所以要添上上层目录的路径
                     searchRec.Name = 'Windows';
                     tmpStr:='c:\Windows';
                     加个断点就一清二楚了
                    }
                    tmpStr := curDir + '\' + searchRec.Name;
                    {将搜索到的目录入队。让它先晾着。
                     因为TQueue里面的数据只能是指针,所以要把string转换为PChar
                     同时使用StrNew函数重新申请一个空间存入数据，否则会使已经进
                     入队列的指针指向不存在或不正确的数据(tmpStr是局部变量)。}
                    dirs.Push(StrNew(PChar(tmpStr)));
                end;
            end
            else {//如果找到的是个文件 } begin
                {Result记录着搜索到的文件数。可是我是用CreateThread创建线程
                 来调用函数的，不知道怎么得到这个返回值。。。我不想用全局变量}
               //把找到的文件加到Memo控件
                if sFileExt = '.*' then
                    fileList.Add(curDir + '\' + searchRec.Name)
                else begin
                    if SameText(RightStr(curDir + '\' + searchRec.Name, Length(sFileExt)), sFileExt) then
                        fileList.Add(curDir + '\' + searchRec.Name);
                end;
            end;
            //查找下一个文件或目录
            found := FindNext(searchRec);
        end;
        {当前目录找到后，如果队列中没有数据，则表示全部找到了；
          否则就是还有子目录未查找，取一个出来继续查找。}
        if dirs.Count > 0 then begin
            pszDir := dirs.Pop;
            curDir := StrPas(pszDir);
            StrDispose(pszDir);
        end
        else
            break;
    end;
    //释放资源
    dirs.Free;
    FindClose(searchRec);
end;


procedure TForm1.btnPlayClick(Sender: TObject);
begin
    btnPlay.Enabled := false;
    btnPause.Enabled := true;
    btnStop.Enabled := true;
    taskPos := CheckListBox1.Count - 1;
    playFile();
end;

procedure TForm1.playFile();
var
    i, k: integer;
    fileName: string;
    returnValue: boolean;
begin
    for I := taskPos downto 0 do begin
        lblHint.Caption := '10';
        if CheckListBox1.Checked[I] then begin
            taskPos := i - 1;
            fileName := CheckListBox1.Items.Strings[i];
            fileExt := ExtractFileExt(fileName);
            if (fileExt = '.xls') then begin
                task := TTaskThread.Create(fileName, lblHint);
                timer1.Enabled := true;
            end else if (fileExt = '.doc') then begin
                task := TTaskThread.Create(fileName, lblHint);
                task.Execute;
                timer1.Enabled := true;
            end else if (fileExt = '.ppt') then begin
                task := TTaskThread.Create(fileName, lblHint);
                task.Execute;
                timer1.Enabled := true;
            end else if (fileExt = '.wmv') then begin
                WindowsMediaPlayer1.Visible := true;
                WindowsMediaPlayer1.URL := fileName;
                WindowsMediaPlayer1.controls.play;
                WindowsMediaPlayer1.ControlInterface.stretchToFit := True;
                WindowsMediaPlayer1.ControlInterface.fullScreen := false;
                WindowsMediaPlayer1.Align := alClient;
                WindowsMediaPlayer1.Repaint;
                WindowsMediaPlayer1.Width := 100;
                WindowsMediaPlayer1.Height := 100;
                timer1.Enabled := true;
            end
            else begin
                returnValue := false;
            end;
            break;
        end;
        k := i;
    end;
    if k = 0 then begin
        btnStop.Enabled := false;
        btnPause.Enabled := false;
        btnPlay.Enabled := true;
    end;
end;


procedure TForm1.N1Click(Sender: TObject);
var
    sExt :string;
begin
    sExt := ExtractFileExt(CheckListBox1.Items.Strings[CheckListBox1.ItemIndex]);
    if (sExt = '.xls') then begin
        OpenExcel(CheckListBox1.Items.Strings[CheckListBox1.ItemIndex]);
    end else if (sExt = '.doc') then begin
        EditWord(CheckListBox1.Items.Strings[CheckListBox1.ItemIndex]);
    end else if (sExt = '.ppt') then begin
        OpenPowerPoint(CheckListBox1.Items.Strings[CheckListBox1.ItemIndex]);
    end else if (sExt = '.wmv') then begin
        ShowMessage('不支持的文件类型');
    end
    else begin
        ShowMessage(fileExt + ',格式不支持');
    end;

end;

procedure TForm1.CheckListBox1DblClick(Sender: TObject);
begin
    ShowMessage(CheckListBox1.Items.Strings[CheckListBox1.ItemIndex])
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
    remains: integer;
begin
    remains := StrToInt(lblHint.Caption) - 1;
    if remains <= 0 then begin
        lblHint.Caption := '0';
        timer1.Enabled := false;

        if (fileExt = '.xls') then begin
            v_office.quit;
            task.Terminate;
        end else if (fileExt = '.doc') then begin
            v_office.quit;
            task.Terminate;
        end else if (fileExt = '.ppt') then begin
            PowerPointApplication1.Quit;
            PowerPointApplication1.Disconnect;
            task.Terminate;
        end else if (fileExt = '.wmv') then begin
            //mediaplayer1.stop;
            WindowsMediaPlayer1.controls.stop;
        end else begin
            ShowMessage(fileExt + '格式不支持');
        end;

        if taskPos >= 0 then begin
            playFile;
        end else begin
            btnStop.Enabled := false;
            btnPause.Enabled := false;
            btnPlay.Enabled := true;
        end;
    end else begin
        lblHint.Caption := IntToStr(remains);
    end;
end;

procedure TForm1.btnPauseClick(Sender: TObject);
begin
    if (btnPause.Caption = '暂停') then begin
        btnPause.Caption := '继续';
        timer1.Enabled := false;
        if (fileExt = '.wmv') then begin
            WindowsMediaPlayer1.controls.pause;
        end;
    end else begin
        btnPause.Caption := '暂停';
        WindowsMediaPlayer1.controls.play;
        timer1.Enabled := true;
    end;
    btnPlay.Enabled := false;
    btnStop.Enabled := true;
    btnPause.Enabled := true;
end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
    btnPlay.Enabled := true;
    btnPause.Enabled := false;
    btnStop.Enabled := false;

    if (fileExt = '.xls') then begin
        v_office.quit;
    end else if (fileExt = '.doc') then begin
        v_office.quit;
    end else if (fileExt = '.ppt') then begin
        PowerPointApplication1.Quit;
        PowerPointApplication1.Disconnect;
    end else if (fileExt = '.wmv') then begin
        //mediaplayer1.stop;
        WindowsMediaPlayer1.controls.stop;
    end else begin
        //ShowMessage(fileExt + '格式不支持');
    end;
    timer1.Enabled := false;
    lblHint.Caption := '0';
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    btnPlay.Enabled := true;
    btnStop.Enabled := false;
    btnPause.Enabled := false;
    try
        //Image1.Picture.RegisterFileFormat('jpg', 'Just a normal BMP File!', TBitmap);
        Image1.Picture.LoadFromFile(ExtractFilePath(paramstr(0)) + 'back.bmp');
        //Image1.Align := alClient;
        //WindowsMediaPlayer1.SendToBack;
        WindowsMediaPlayer1.Visible := false;
        Image1.BringToFront;
        //Image1.Refresh;
        //Panel2.Repaint;
    except
        ShowMessage('背景图片未找到！文件名为：' + ExtractFilePath(paramstr(0)) + '\back.bmp');
        WindowsMediaPlayer1.Align := alClient;
        WindowsMediaPlayer1.BringToFront;
        WindowsMediaPlayer1.Realign;
        WindowsMediaPlayer1.Repaint;
        WindowsMediaPlayer1.Visible := true;
        Image1.SendToBack;
        Image1.Visible := false;
        //Panel2.Repaint;
        //Panel2.Realign;
    end;
end;

end.

