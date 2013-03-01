unit ExtUtils;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> ExtUtils
   <What> 包含常用函数(文件处理，字符串处理等等)
   <Written By> Huang YanLai
   <History>
**********************************************}

interface

uses windows,messages,SysUtils,Classes,controls,FileCtrl,IniFiles,ComWriUtils;

(******************************
  文件处理
*******************************)
type
  EFileNotExist = class(Exception);

const
  fmtFileNotExist ='File(%s) does not Exists';
// if File do not Exist, raise
procedure CheckFileExist(const FileName:string);

// return True if file find.
// Node : do not use wildcard characters
function  GetFileInfo(const FileName:string;
  var FindData: TWin32FindData) : boolean;

//if file does not exist, return 0
function GetFileSize(const FileName:string): DWord;

// get a new file name that is unique.
// if FileName exists, it will add number
// example : HYL.txt ->HYL%1.txt
function GetNewName(const FileName:string): string;

type
// Compare File Info Result
  TCFIResult = (
    cfirSourceNotExists,
    cfirDestNotExists,
    cfirSourceNewer,
    cfirSourceOlder,
    cfirSizeDif, // write-time equal, but size differ
    cfirEqual);  // write-time and size equal.

// Compare file
function  CompareFileInfo(
  const SourceFile,DestFile:string): TCFIResult;

const
  CompFileMsgFomat :
   array[TCFIResult] of shortString
   = ('源文件(%s)不存在',
      '目的文件(%s)不存在',
      '源文件(%s)比目的文件(%s)新',
      '源文件(%s)比目的文件(%s)旧',
      '源文件(%s)与目的文件(%s)修改时间相同,但是文件大小不同',
      '源文件(%s)与目的文件(%s)修改时间和文件大小相同');

// simple copy
function	CopyFile(const SourceFile,DestFile:string):boolean;

// %CopyFile2 : 复制SourceFile到DestFile,并设置DestFile的属性为NewAttr
// 如果DestFile存在(甚至ReadOnly)，则DestFile被覆盖
function  CopyFile2(const SourceFile,DestFile:string; NewAttr : integer=0): boolean;

type
  TCopyAgentAction = (caaReplace, // replace exist file
    caaNotCopy,  // not copy
    caaCustom);  // show dialog to user

  TCopyAgentOptions = record
    // when dest file exists, always replace dest
    AlwaysReplace : boolean;
    // when Dest dir does not exist
    // caaReplace : force dest dir
    // caaNotCopy : not create dest dir, and not copy file
    NoDestDir : TCopyAgentAction;
    // when Modified time and size equal
    SameAttr : TCopyAgentAction;
    // when Modified time equal but size differ.
    // this is rare.
    SizeDif  : TCopyAgentAction;
    // when Source Modified time is later
    TimeNewer : TCopyAgentAction;
    // when Destination Modified time is later
    TimeOlder : TCopyAgentAction;
    // what to do when raise an error during copy file.
    // If retry is True, show a dialog to user
    // to confirm retry or canceled. User retry this
    // after fixing some disk errors.
    // If retry is False, procedure simple return.
    Retry : boolean;
  end;

  // note : when network driver cannot be write,
  // code is carcCantMakeDestDir not carcError.
  TCopyAgentReturnCode =
    (carcCopied,      // successful copied
    carcCancelByUser, // canceled by user
    carcNotByUser,    // not copy by user
    carcNotForSame,   // not copy because of having same size and time
    carcNotForOlder,  // not copy because source is older
    carcNotForNewer,  // not copy because source is newer
    carcNotForSizeDif, // not copy because tiem equal but size differ
    carcSourceNotExists,     // Source not exists
    carcError,         // system copy file error
    carcNoDestDir,    // not copy because dest dir does not exist
    carcCantMakeDestDir // cannot create Dest Dir when Dest dir does not exist
    );

function  CopyFileEx(
  const SourceFile,
    DestFile:string;
  const options : TCopyAgentOptions;
  // CompResult contains the compare Result
  // between SourceFile and DestFile.
  var CompResult : TCFIResult)
    :TCopyAgentReturnCode;

const
  caoDefault : TCopyAgentOptions
  = (AlwaysReplace : False;
    NoDestDir : caaCustom;
    SameAttr : caaNotCopy;
    SizeDif  : caaCustom;
    TimeNewer : caaCustom;
    TimeOlder : caaCustom;
    Retry : True;
  );

  caoSafe : TCopyAgentOptions
  = (AlwaysReplace : True;
    NoDestDir : caaReplace;
    SameAttr : caaReplace;
    SizeDif  : caaReplace;
    TimeNewer : caaReplace;
    TimeOlder : caaReplace;
    Retry : True;
  );

  caoCopyWhenNeed : TCopyAgentOptions
  = (AlwaysReplace : False;
    NoDestDir : caaReplace;
    SameAttr : caaNotCopy;
    SizeDif  : caaReplace;
    TimeNewer : caaReplace;
    TimeOlder : caaNotCopy;
    Retry : True;
  );

const
  CopyResultMsg : array[TCopyAgentReturnCode] of shortstring
  = ('成功拷贝',
    '用户取消',
    '用户选择不拷贝',
    '不拷贝,因为文件时间大小相同',
    '不拷贝,因为源文件比目标文件旧',
    '不拷贝,因为源文件比目标文件新',
    '不拷贝,因为源文件与目标文件时间相同,大小不同',
    '源文件不存在',
    '拷贝文件时操作系统出错',
    '不拷贝,因为目标文件的目录不存在',
    '无法建立目标文件的目录'
  );

const
  ConfirmReplaceStr = ',是否覆盖目标文件?';
  ConfirmCreateDestDirFmt = '目标目录(%s)不存在,是否创建?';
  ConfirmRetry = '拷贝文件(%s)到(%s)时出现错误,是否重试?';
type
  { notes :
      Source contains path,
    use
      FileName := StrPas(pchar(@FileInfo.cFileName));
     or
      FileName := ExtractFileName(Source);
    to get only name of source

  }
  TFileFilterMethod = procedure(const FileInfo : TWin32FindData;
                        const Source : string;
                        var   Dest   : string;
                        var   CopyIt : boolean ) of object;

  TAfterCopyMethod =  procedure(const Source,Dest: string;
                        CopyResult : TCopyAgentReturnCode;
                        var cont : boolean) of object;
// not include '\'
// Result is False, when user canceled
function  CopyDir(
  const SourceDir,
        DestDir:string;
  const Options : TCopyAgentOptions;
  IncludeSubDir : boolean;
  FileFilter : TFileFilterMethod;
  AfterCopy  : TAfterCopyMethod
  ) : boolean;


procedure ReadCopyAgentOptions(Var Options : TCopyAgentOptions; Ini : TIniFile;const Section : String);

procedure WriteCopyAgentOptions(Var Options : TCopyAgentOptions; Ini : TIniFile;const Section : String);

(******************************
  Shell Utilities
*******************************)
// return True if successful
function  ModalRun(const Command : string):boolean;
// return True if successful
function  ModalOpenFile(const CmdFormat,FileName:string;
  var FileChanged : boolean):boolean;

{ SelectDirectory2 : resolve SelectDirectory bugs.
If CurDir is like '\\network\abc', an I/O error occur.
}
function	SelectDirectory2(var Directory: string;
	Options: TSelectDirOpts): Boolean;

function	SelectDirectory3(var Directory: string): Boolean;

{
  Shell Execute
}
function ExploreFolder(const Folder:string): boolean;

function OpenFolder(const Folder:string): boolean;

function ShellOpenFile(const FileName:string):boolean;

function ShellOpenFileEx(const ExeFile,FileName:string):boolean;

// %GetAssociatedExeFile : return the associated Executable File Name
// for the file extention specified by Ext
// Notes : Ext includes '.'
function GetAssociatedExeFile(const Ext:string): string;

(******************************
  获取驱动器信息
*******************************)

type
  TDriverType = (dtUnknown,dtNone,dtREMOVABLE,dtFIXED,dtREMOTE,dtCDROM	,dtRAMDISK);
  TDriverTypes = set of TDriverType;

// DriverTypes = [] is for all
function  getDrivers(DriverTypes:TDriverTypes
  =[]):TSysCharset;

function  getFixedDrivers:TSysCharset;

function  getRemovableDrivers:TSysCharset;

function  getRemoteDrivers:TSysCharset;

function  getCDROMDrivers:TSysCharset;

function  getDriverType(Driver : char): TDriverType;

function  getDriverInfo(Driver : char; var driverType : TDriverType;
    var freeSpace,totalSpace:Int64):boolean;

(******************************
  其他
*******************************)
{ AdjustWH return
    DesWidth : DesHeight = refWidth : refHeight,
   1. stretch = True
     DesWidth = MaxWidth , DesHeight <= maxHeight
     or DesWidth <= MaxWidth , DesHeight = maxHeight
   2. stretch = False
     if (RefWidth <= MaxWidth) and (refHeight <= maxHeight)
       (DesWidth = RefWidth) And (desHeight = refHeight)
     else DesWidth = MaxWidth , DesHeight <= maxHeight
        or DesWidth <= MaxWidth , DesHeight = maxHeight
  如果 DesWidth>MaxWidth or DestHeight>MaxHeight, stretch无效(一定要放缩)
}

procedure AdjustWH(var DesWidth,DesHeight : integer;
  refWidth,refHeight,maxWidth,maxHeight : integer;
  stretch : boolean);

function ClassIs(AClass : TClass; const ClassName : string) : Boolean;

type
  EKSFileVersionInfoError = class(Exception);

  TKSFileVersionInfo = class(TObject)
  private
    FVersionInfo : Pointer;
    FVersionInfoSize : Integer;
    FFileName: string;
    function    GetAvailable: Boolean;
    procedure   CheckAvailable;
  protected

  public
    constructor Create; overload;
    constructor Create(const AFileName : string); overload;
    destructor  Destroy;override;
    procedure   OpenFile(const AFileName : string);
    property    FileName : string read FFileName;
    property    Available : Boolean read GetAvailable;
    procedure   GetFixedInfo(var FixedInfo : TVSFixedFileInfo);
    // low word is Language, hi word is charset
    function    GetInfo(LanguageCharset : LongWord; const InfoName : string) : string; overload;
    function    GetInfo(const InfoName : string) : string; overload;
    // low word is Language, hi word is charset
    function    GetLanguageCharset : Longword;
  end;


type
  TKSModuleInfo = class
  private
    FModuleName: string;
    FModulePath: string;
    FModuleHandle: THandle;
  public
    property  ModuleHandle : THandle read FModuleHandle write FModuleHandle;
    property  ModuleName : string read FModuleName write FModuleName;
    property  ModulePath : string read FModulePath write FModulePath;
  end;

  TKSProcessModules = class
  private
    FModules : TObjectList;
    function    GetCount: Integer;
    function    GetModules(Index: Integer): TKSModuleInfo;
  public
    constructor Create;
    destructor  Destroy;override;
    procedure   Refresh(ProcessID : LongWord = 0);
    property    Count : Integer read GetCount;
    property    Modules[Index : Integer] : TKSModuleInfo read GetModules; default;
  end;

  TKSProcessInfo = class
  private
    FModulePath: string;
    FProcessID: THandle;
  public
    property  ProcessID : THandle read FProcessID write FProcessID;
    property  ModulePath : string read FModulePath write FModulePath;
  end;

  TKSProcesses = class
  private
    FProcesses : TObjectList;
    function    GetCount: Integer;
    function    GetProcesses(Index: Integer): TKSProcessInfo;
  public
    constructor Create;
    destructor  Destroy;override;
    procedure   Refresh;
    property    Count : Integer read GetCount;
    property    Processes[Index : Integer] : TKSProcessInfo read GetProcesses; default;
  end;

resourcestring
  SNoFileVersionInfo = 'No File Version Info For %s';

function  AlreadyRunning(const AppID : string) : Boolean;

function  CheckAndNotifyAlreadyRunning(const FormClassName : string) : Boolean;

implementation

uses dialogs,Forms,ShellAPI,Registry, KSStrUtils, LibMessages, TLHelp32;

function	CopyFile(const SourceFile,DestFile:string):boolean;
var
  SHFILEOPSTRUCT : TSHFILEOPSTRUCT;
  SF,DF : string;
  i,j : integer;
begin
  i := length(SourceFile);
  SF := SourceFile + #0#0;
  j := length(SF);
  assert(j=i+2);
  DF := DestFile + #0#0;
  with SHFILEOPSTRUCT do
  begin
    Wnd := Application.handle;
    wFunc := FO_COPY;
    fFlags := FOF_NOCONFIRMATION or	FOF_SILENT;
    pFrom := pchar(SF);
    pTo := pchar(DF);
  end;
  Result := SHFileOperation(SHFILEOPSTRUCT)=0;
  if Result then Result := not SHFILEOPSTRUCT.fAnyOperationsAborted;
end;

procedure CheckFileExist(const FileName:string);
begin
  if not FileExists(FileName) then
    raise EFileNotExist.Create(
      Format(fmtFileNotExist,
      [Filename]));
end;

// return True if successful
function  ModalRun(const Command : string):boolean;
var
  //hProc : THandle;
  ProcInfo : TPROCESSINFORMATION;
  startinfo : TStartupInfo;
begin
  try
    FillMemory(@startinfo,sizeof(startinfo),0);
    with startinfo do
    begin
      cb := sizeof(startinfo);
    end;

    if CreateProcess(
      nil,
      pchar(Command),
      nil,
      nil,
      False,
      0,
      nil,
      nil,
      startinfo,
      ProcInfo) then
      Result := waitForSingleObject(
        ProcInfo.hProcess,INFINITE)=WAIT_OBJECT_0
    else
      Result := False;
  except
    Result := False;
  end;
end;

// return True if successful
function  ModalOpenFile(const CmdFormat,FileName:string;
  var FileChanged : boolean):boolean;
var
  Age : integer;
  Cmd : string;
begin
  FileChanged := False;
  Result := FileExists(FileName);
  if Result then
  begin
    Age := FileAge(FileName);
    cmd := format(CmdFormat,[FileName]);
    Result := ModalRun(cmd);
    if Result then
      FileChanged := FileAge(FileName)<>Age;
  end;
end;

// return True if file find.
// Node : do not use wildcard characters
function  GetFileInfo(const FileName:string;
  var FindData: TWin32FindData) : boolean;
var
  Handle: THandle;
begin
  Handle := FindFirstFile(PChar(FileName), FindData);
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(Handle);
    // is dir?
    Result :=
      (FindData.dwFileAttributes
      and FILE_ATTRIBUTE_DIRECTORY)
       = 0;
  end
  else
    Result := False;
end;

//if file does not exist, return 0
function GetFileSize(const FileName:string): DWord;
var
  FindData: TWin32FindData;
begin
  if GetFileInfo(FileName,FindData) then
    Result := FindData.nFileSizeLow
  else
    Result:=0;
end;

function  CompareFileInfo(
  const SourceFile,DestFile:string): TCFIResult;
var
  SourceInfo,DestInfo : TWin32FindData;
begin
  if GetFileInfo(SourceFile,SourceInfo) then
    if GetFileInfo(DestFile,DestInfo) then
      case CompareFileTime(
        SourceInfo.ftLastWriteTime,
        DestInfo.ftLastWriteTime) of
        -1 : Result := cfirSourceOlder;
        0  : if (SourceInfo.nFileSizeHigh
              =DestInfo.nFileSizeHigh) and
                (SourceInfo.nFileSizeLow
              =DestInfo.nFileSizeLow)
             then Result := cfirEqual
             else Result := cfirSizeDif;
        1  : Result := cfirSourceNewer;
        else Result := cfirSourceOlder;
      end
    else // no dest
      Result := cfirDestNotExists
  else // no source
    Result := cfirSourceNotExists;
end;

function  CopyFileEx(
  const SourceFile,
    DestFile:string;
  const options : TCopyAgentOptions;
  var CompResult : TCFIResult)
    :TCopyAgentReturnCode;

var
  destDir : string;
  SFile,DFile : string;

  // return whethere copy/ create dest dir
  function UserConfirm(const caption : string): boolean;
  begin
    case MessageDlg(
              Caption,
              mtConfirmation,
              [mbYes,mbNo,mbCancel],0)
    of
      mrYes : Result := True;
      mrNo  :
        begin
          CopyFileEx := carcNotByUser;
          Result := False;
        end;
      mrCancel :
        begin
          CopyFileEx := carcCancelByUser;
          Result := False;
        end;
      else Result := False;
    end; // end case for dlg
  end;

  // return whethere replace exist dest file.
  function WillReplaceExistFile: boolean;
  var
    AgentAction : TCopyAgentAction;
  begin
        case CompResult of
          cfirSourceNewer :
            begin
              AgentAction:=options.TimeNewer;
              CopyFileEx := carcNotForNewer;
            end;
          cfirSourceOlder :
            begin
              AgentAction:=options.TimeOlder;
              CopyFileEx := carcNotForOlder;
            end;
          cfirSizeDif :
            begin
              AgentAction:=options.SizeDif;
              CopyFileEx := carcNotForSizeDif;
            end;
          cfirEqual :
            begin
              AgentAction:=options.SameAttr;
              CopyFileEx := carcNotForSame;
            end;
          else
            AgentAction:= caaCustom;
        end;
        case AgentAction of
          caaNotCopy : Result := False;
          caaCustom : Result := UserConfirm(
                format(CompFileMsgFomat[CompResult],
                [SFile,DFile])
                + ConfirmReplaceStr);
          caaReplace : Result := True; // go copy.
          else Result := False;
        end;
  end;

  function willCreateDestDir: boolean;
  begin
    case options.NoDestDir of
      caaReplace : Result := True;
      caaNotCopy :
        begin
          Result := False;
          CopyFileEx := carcNoDestDir;
        end;
      caaCustom : Result :=
            UserConfirm(format(ConfirmCreateDestDirFmt,
              [destDir]));
    else Result := False;
    end;
  end;

begin
  SFile := ExpandFileName(SourceFile);
  DFile := ExpandFileName(DestFile);
  repeat
  try
    CompResult := CompareFileInfo(SFile,DFile);
    if CompResult=cfirSourceNotExists then
      Result := carcSourceNotExists
    else
    begin
      if not (options.AlwaysReplace
        or (CompResult=cfirDestNotExists)) then
      begin
        if not WillReplaceExistFile then
          exit; // Result set by WillReplaceExistFile
      end
      else // no dest or always replace
        if CompResult=cfirDestNotExists then
        begin
          destDir :=ExtractFileDir(DFile);
          if (destDir<>'') and
            not DirectoryExists(destDir) then
              if willCreateDestDir then
              begin
                ForceDirectories(destDir);
                if not DirectoryExists(destDir) then
                begin
                // create dest dir error
                  Result := carcCantMakeDestDir;
                  //exit;
                  raise Exception.Create('');
                end;
              end
              else // not create dest dir
                exit; // Result set by willCreateDestDir
        end;

      if windows.copyFile(
        pchar(SFile),
        pchar(DFile),
        False)
      then
        Result := carcCopied
      else
        Result := carcError;
    end;
  except
    if Result<>carcCantMakeDestDir then
      Result := carcError;
  end;

  if Result in [carcError,carcCantMakeDestDir] then
  begin
    // when copy error
    if options.Retry then
      if not UserConfirm(
            format(ConfirmRetry,[SFile,DFile])) then
      break;
  end
  else break;
  until False;
end;

function  CopyDir(
  const SourceDir,
        DestDir:string;
  const Options : TCopyAgentOptions;
  IncludeSubDir : boolean;
  FileFilter : TFileFilterMethod;
  AfterCopy  : TAfterCopyMethod
  ):boolean;
var
	SDir,DDir : string;
  sourceFile,DestFile : string;
  Handle: THandle;
  FileData : TWin32FindData;
  IsDir : boolean;
  HasFilter,HasCallback : boolean;
  FileName : string;
  CopyResult : TCopyAgentReturnCode;
  Cont : boolean;
  CompResult : TCFIResult;

  function AcceptFile : boolean;
  begin
    Result := True;
    if HasFilter then
      FileFilter(FileData,
          sourceFile,DestFile,
          Result);
  end;

begin
  SDir:=SourceDir;
  DDir:=DestDir;
  if (SDir='') or (DDir='') then
  begin
    Result := False;
    exit;
  end;
  if SDir[length(SDir)]<>'\' then SDir:=SDir+'\';
  if DDir[length(DDir)]<>'\' then DDir:=DDir+'\';
  Handle := FindFirstFile(PChar(SDir+'*.*'), FileData);
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    try
      Result := True;
      HasFilter := Assigned(FileFilter);
      HasCallback := Assigned(AfterCopy);

      repeat
        Cont := True;
        IsDir := (FileData.dwFileAttributes
              and FILE_ATTRIBUTE_DIRECTORY)
                <>0;
        if FileData.cFileName[0]<>'.' then
        begin
        // not is '.' or '..'
          FileName := StrPas(pchar(@FileData.cFileName));
          SourceFile := SDir + FileName;
          DestFile :=  DDir + FileName;

          if IsDir then
          begin
            if IncludeSubDir and AcceptFile then
            // copy subDir
              cont:=CopyDir(SourceFile,DestFile,
                Options,IncludeSubDir,
                FileFilter,AfterCopy);
          end
          else
          // not is dir
          if acceptFile then
          begin
            CopyResult := CopyFileEx(
              sourceFile,DestFile,
              Options,CompResult);
            cont := CopyResult<>carcCancelByUser;
            if HasCallback then
              AfterCopy(sourceFile,DestFile,
                CopyResult,cont)
          end;
        end;

        if cont then
          cont := FindNextFile(handle,FileData)
        else
        	Result:=False;
      until not cont;
    finally
      Windows.FindClose(Handle);
    end;
  end
  else
    Result := False;
end;

function	SelectDirectory2(var Directory: string;
	Options: TSelectDirOpts): Boolean;
var
	CurDir : string;
begin
  CurDir := GetCurrentDir;
  SetCurrentDir('c:\');
  try
    Result := SelectDirectory(Directory,Options,0);
  finally
    SetCurrentDir(CurDir);
  end;
end;

function	SelectDirectory3(var Directory: string): Boolean;
begin
  Result := SelectDirectory2(Directory,
  	[sdAllowCreate,sdPerformCreate,sdPrompt]);
end;

function ExploreFolder(const Folder:string): boolean;
begin
  Result := ShellExecute(Application.handle,
              'explore',
              pchar(Folder),
              nil,
              nil,
              SW_SHOW)>32;
end;

function OpenFolder(const Folder:string): boolean;
begin
  Result := ShellExecute(Application.handle,
              'open',
              pchar(Folder),
              nil,
              nil,
              SW_SHOW)>32;
end;

function ShellOpenFile(const FileName:string):boolean;
begin
  Result := ShellExecute(Application.handle,
              'open',
              pchar(FileName),
              nil,
              nil,
              SW_SHOW)>32;
end;

function ShellOpenFileEx(const ExeFile,FileName:string):boolean;
var
  Param : pchar;
  PFile : pchar;
begin
  if ExeFile<>'' then
  begin
    Param := pchar(FileName);
    pFile := pchar(ExeFile);
  end
  else
  begin
    Param := nil;
    pFile := pchar(FileName);
  end;
  Result := ShellExecute(Application.handle,
              'open',
              pFile,
              Param,
              nil,
              SW_SHOW)>32;
end;

procedure AdjustWH(var DesWidth,DesHeight : integer;
  refWidth,refHeight,maxWidth,maxHeight : integer; stretch : boolean);
const
  Small = 0.01;
var
  rw,rh : real;
begin
  if not stretch and (RefWidth <= MaxWidth) and (refHeight <= maxHeight)
    then begin
      DesWidth := RefWidth;
      DesHeight := RefHeight;
    end
    else begin
      rw := MaxWidth / refWidth;
      rh := MaxHeight / refHeight;
      if rw > rh
     { MaxWidth is more than maxHeight by rate refWidth to refHeight
       rw > rh
       =] MaxWidth / refWidth >  MaxHeight / refHeight
       =] MaxWidth > MaxHeight / refHeight * refWidth
     }
      then begin
        DesHeight := MaxHeight;
        Deswidth := round(rh * refWidth + small);
      end
      else begin
        desHeight := round(rw * refHeight + small);
        desWidth := MaxWidth;
      end;
    end;
end;

procedure ReadCopyAgentOptions(Var Options : TCopyAgentOptions; Ini : TIniFile;const Section : String);
begin
  with Ini,Options do
  begin
    AlwaysReplace := ReadBool(Section,'AlwaysReplace',False);
    NoDestDir := TCopyAgentAction(ReadInteger(Section,'NoDestDir',ord(caaReplace)));
    SameAttr := TCopyAgentAction(ReadInteger(Section,'SameAttr',ord(caaNotCopy)));
    SizeDif  := TCopyAgentAction(ReadInteger(Section,'SizeDif',ord(caaReplace)));
    TimeNewer := TCopyAgentAction(ReadInteger(Section,'TimeNewer',ord(caaReplace)));
    TimeOlder := TCopyAgentAction(ReadInteger(Section,'TimeOlder',ord(caaNotCopy)));
    Retry := ReadBool(Section,'Retry',True);
  end;
end;

procedure WriteCopyAgentOptions(Var Options : TCopyAgentOptions; Ini : TIniFile;const Section : String);
begin
  with Ini,Options do
  begin
    WriteBool(Section,'AlwaysReplace',AlwaysReplace);
    WriteInteger(Section,'NoDestDir',ord(NoDestDir));
    WriteInteger(Section,'SameAttr',ord(SameAttr));
    WriteInteger(Section,'SizeDif',ord(SizeDif));
    WriteInteger(Section,'TimeNewer',ord(TimeNewer));
    WriteInteger(Section,'TimeOlder',ord(TimeOlder));
    WriteBool(Section,'Retry',Retry);
  end;
end;

// get a new file name that is unique.
// if FileName exists, it will add number
// example : HYL.txt ->HYL%1.txt
function GetNewName(const FileName:string): string;
var
  NamePart,ExtPart : string;
  i : integer;
begin
  Result := FileName;
  if FileExists(FileName) then
  begin
    i := 1;
    ParseFileName(FileName,NamePart,ExtPart);
    repeat
      Result := NamePart+IntToStr(i)+ExtPart;
      inc(i);
    until not FileExists(Result);
  end;
end;

function GetAssociatedExeFile(const Ext:string): string;
var
  Reg : TRegistry;
  AExt : string;
  ExeEntry : string;
  i : integer;
begin
  Reg :=TRegistry.Create;
  Result := '';
  try
    Reg.RootKey := HKEY_CLASSES_ROOT;
    if Ext='' then exit;
    if Ext[1]<>'.' then
      AExt := '.'+Ext
    else AExt := Ext;
    if Reg.OpenKeyReadOnly('\'+AExt) then
    begin
      ExeEntry := Reg.ReadString('');
      if Reg.OpenKeyReadOnly('\'+ExeEntry+'\shell\open\command') then
      begin
        Result := Reg.ReadString('');
        if Result<>'' then
        begin
          // extract filename from "filename" "%1"
          if Result[1]='"' then
          begin
            Result := Copy(Result,2,length(Result)-1);
            i :=  pos('"',Result);
            if i>0 then Result := copy(Result,1,i-1);
          end;
        end;
      end;
    end;
  except

  end;
  Reg.free;
end;

// %CopyFile2 : 复制SourceFile到DestFile,并设置DestFile的属性为NewAttr
// 如果DestFile存在(甚至ReadOnly)，则DestFile被覆盖
function  CopyFile2(const SourceFile,DestFile:string; NewAttr : integer=0): boolean;
begin
  Result := False;
  if FileExists(DestFile) then
    if FileSetAttr(DestFile,0)<>0 then exit;
  Result := windows.CopyFile(pchar(SourceFile),pchar(DestFile),False);
  if Result then
    Result:=FileSetAttr(DestFile,NewAttr)=0;
end;

function  getDrivers(DriverTypes:TDriverTypes
  =[]):TSysCharset;
var
  bitmasks : longword;
  i : char;
  j,k : integer;
  driverStr : array[0..3] of char;
  driverType : TDriverType;
begin
  bitmasks := GetLogicalDrives();
  Result := [];
  j:=1;
  driverStr[1]:=':';
  driverStr[2]:='\';
  driverStr[3]:=#0;
  for i:='A' to 'Z' do
  begin
    if (j and bitmasks)<>0 then
    begin
      if driverTypes<>[] then
      begin
        // check driver type
        driverStr[0]:=i;
        k := GetDriveType(driverStr);
        case k of
          0               : driverType:=dtUnknown;
          1               : driverType:=dtNone;
          DRIVE_REMOVABLE : driverType:=dtREMOVABLE;
          DRIVE_FIXED     : driverType:=dtFIXED;
          DRIVE_REMOTE    : driverType:=dtREMOTE;
          DRIVE_CDROM     : driverType:=dtCDROM;
          DRIVE_RAMDISK   : driverType:=dtRAMDISK;
        else driverType:=dtUnknown;
        end;
        if (driverType in driverTypes) then
          include(Result,i);
      end
      else include(Result,i);
    end;
    j:=j shl 1;
  end;
end;

function  getFixedDrivers:TSysCharset;
begin
  Result := getDrivers([dtFixed]);
end;

function  getRemovableDrivers:TSysCharset;
begin
  Result := getDrivers([dtRemovable]);
end;

function  getRemoteDrivers:TSysCharset;
begin
  Result := getDrivers([dtRemote]);
end;

function  getCDROMDrivers:TSysCharset;
begin
  Result := getDrivers([dtCDROM]);
end;

function  getDriverType(Driver : char): TDriverType;
var
  driverStr : array[0..3] of char;
  k : integer;
begin
  driverStr[0]:=Driver;
  driverStr[1]:=':';
  driverStr[2]:='\';
  driverStr[3]:=#0;
  k := GetDriveType(driverStr);
  case k of
    0               : Result:=dtUnknown;
    1               : Result:=dtNone;
    DRIVE_REMOVABLE : Result:=dtREMOVABLE;
    DRIVE_FIXED     : Result:=dtFIXED;
    DRIVE_REMOTE    : Result:=dtREMOTE;
    DRIVE_CDROM     : Result:=dtCDROM;
    DRIVE_RAMDISK   : Result:=dtRAMDISK;
  else Result:=dtUnknown;
  end;
end;

function  getDriverInfo(Driver : char; var driverType : TDriverType;
    var freeSpace,totalSpace:Int64):boolean;
var
  driverStr : array[0..3] of char;
  k : integer;
begin
  driverStr[0]:=Driver;
  driverStr[1]:=':';
  driverStr[2]:='\';
  driverStr[3]:=#0;
  k := GetDriveType(driverStr);
  case k of
    0               : driverType:=dtUnknown;
    1               : driverType:=dtNone;
    DRIVE_REMOVABLE : driverType:=dtREMOVABLE;
    DRIVE_FIXED     : driverType:=dtFIXED;
    DRIVE_REMOTE    : driverType:=dtREMOTE;
    DRIVE_CDROM     : driverType:=dtCDROM;
    DRIVE_RAMDISK   : driverType:=dtRAMDISK;
  else driverType:=dtUnknown;
  end;
  Result := not (driverType in [dtUnknown,dtNone]);
  if Result then
  begin
    Result := GetDiskFreeSpaceEx(driverStr,freeSpace,totalSpace,nil);
  end;
end;

function ClassIs(AClass : TClass; const ClassName : string) : Boolean;
var
  ParentClass : TClass;
begin
  ParentClass := AClass;
  Result := False;
  while ParentClass<>nil do
  begin
    if ParentClass.ClassNameIs(ClassName) then
    begin
      Result := True;
      Break;
    end;
    ParentClass := ParentClass.ClassParent;
  end;
end;

{ TKSFileVersionInfo }

constructor TKSFileVersionInfo.Create;
begin
  FVersionInfo := nil;
end;

constructor TKSFileVersionInfo.Create(const AFileName: string);
begin
  Create;
  OpenFile(AFileName);
end;

procedure TKSFileVersionInfo.OpenFile(const AFileName: string);
var
  Temp : Cardinal;
begin
  FFileName := AFileName;
  FVersionInfoSize := GetFileVersionInfoSize(PChar(AFileName),Temp);
  if FVersionInfoSize>0 then
  begin
    FVersionInfo := GetMemory(FVersionInfoSize);
    if not GetFileVersionInfo(PChar(AFileName),0,FVersionInfoSize,FVersionInfo) then
    begin
      FreeMemory(FVersionInfo);
      FVersionInfo := nil;
    end;
  end else
    FVersionInfo := nil;
end;

destructor TKSFileVersionInfo.Destroy;
begin
  if FVersionInfo<>nil then
    FreeMemory(FVersionInfo);
  inherited;
end;

function TKSFileVersionInfo.GetAvailable: Boolean;
begin
  Result := FVersionInfo<>nil;
end;

procedure TKSFileVersionInfo.CheckAvailable;
begin
  if FVersionInfo=nil then
    raise EKSFileVersionInfoError.CreateFmt(SNoFileVersionInfo,[FFileName]);
end;

procedure TKSFileVersionInfo.GetFixedInfo(
  var FixedInfo: TVSFixedFileInfo);
var
  P : Pointer;
  Len : Cardinal;
begin
  CheckAvailable;
  FillChar(FVersionInfo,SizeOf(FVersionInfo),0);
  if VerQueryValue(FVersionInfo,'\',P,Len) then
    Move(P^,FixedInfo,Len);
end;

function TKSFileVersionInfo.GetInfo(LanguageCharset: LongWord;
  const InfoName: string): string;
var
  Name : string;
  P : Pointer;
  Len : Cardinal;
begin
  CheckAvailable;
  Name := Format('\StringFileInfo\%4.4x%4.4x\%s',
    [ LongRec(LanguageCharset).Lo,
      LongRec(LanguageCharset).Hi,
      InfoName]);
  Result := '';
  if VerQueryValue(FVersionInfo,PChar(Name),P,Len) then
  begin
    if Len>0 then
    begin
      SetLength(Result,Len);
      Move(P^,PChar(Result)^,Len);
      SetLength(Result,StrLen(PChar(Result)));
    end;
  end;
end;

function TKSFileVersionInfo.GetLanguageCharset: Longword;
var
  P : Pointer;
  Len : Cardinal;
begin
  CheckAvailable;
  Result := 0;
  if VerQueryValue(FVersionInfo,'\VarFileInfo\Translation',P,Len) then
  begin
    if Len>=4 then
    begin
      Move(P^,Result,SizeOf(Result));
    end;
  end;
end;

function TKSFileVersionInfo.GetInfo(const InfoName: string): string;
begin
  Result := GetInfo(GetLanguageCharset,InfoName);
end;


function  AlreadyRunning(const AppID : string) : Boolean;
{var
  Handle : THandle;}
begin
  {Handle := }CreateEvent(nil,True,True,PChar(AppID));
  Result := GetLastError=ERROR_ALREADY_EXISTS;
end;

function  CheckAndNotifyAlreadyRunning(const FormClassName : string) : Boolean;
var
  Handle : THandle;
begin
  Handle := FindWindow(PChar(FormClassName),nil);
  if Handle<>0 then
  begin
    PostMessage(Handle,LM_AnotherAppInstanceStart,0,0);
    Result := True;
  end else
    Result := False;
end;

{ TKSProcessModules }

constructor TKSProcessModules.Create;
begin
  inherited;
  FModules := TObjectList.Create;
end;

destructor TKSProcessModules.Destroy;
begin
  FreeAndNil(FModules);
  inherited;
end;

function TKSProcessModules.GetCount: Integer;
begin
  Result := FModules.Count;
end;

function TKSProcessModules.GetModules(Index: Integer): TKSModuleInfo;
begin
  Result := TKSModuleInfo(FModules[Index]);
end;

procedure TKSProcessModules.Refresh(ProcessID : LongWord);
var
  hModuleSnap : Integer;
  ModuleEntry : TModuleEntry32;
  ModuleInfo : TKSModuleInfo;
begin
  FModules.Clear;

  // Take a snapshot of all processes currently in the system.
  hModuleSnap := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, ProcessID);
  if (hModuleSnap<>-1)  then
  begin
    // Walk the snapshot of processes and for each process, get information
    // to display.
    ModuleEntry.dwSize := sizeof(ModuleEntry);
    if (Module32First(hModuleSnap, ModuleEntry)) then
    begin
      repeat
        ModuleInfo := TKSModuleInfo.Create;
        ModuleInfo.ModuleHandle := ModuleEntry.hModule;
        ModuleInfo.ModuleName := ModuleEntry.szModule;
        ModuleInfo.ModulePath := ModuleEntry.szExePath;
        FModules.Add(ModuleInfo);
      until not Module32Next(hModuleSnap, ModuleEntry);
    end;
    // Don't forget to clean up the snapshot object...
    CloseHandle (hModuleSnap);
  end;
end;

{ TKSProcesses }

constructor TKSProcesses.Create;
begin
  inherited;
  FProcesses := TObjectList.Create;
end;

destructor TKSProcesses.Destroy;
begin
  FreeAndNil(FProcesses);
  inherited;
end;

function TKSProcesses.GetCount: Integer;
begin
  Result := FProcesses.Count;
end;

function TKSProcesses.GetProcesses(Index: Integer): TKSProcessInfo;
begin
  Result := TKSProcessInfo(FProcesses[Index]);
end;

procedure TKSProcesses.Refresh;
var
  hProcessSnap : Integer;
  ProcessEntry : TProcessEntry32;
  ProcessInfo : TKSProcessInfo;
begin
  FProcesses.Clear;

  // Take a snapshot of all processes currently in the system.
  hProcessSnap := CreateToolhelp32Snapshot(TH32CS_SNAPProcess, 0);
  if (hProcessSnap<>-1)  then
  begin
    // Walk the snapshot of processes and for each process, get information
    // to display.
    ProcessEntry.dwSize := sizeof(ProcessEntry);
    if (Process32First(hProcessSnap, ProcessEntry)) then
    begin
      repeat
        ProcessInfo := TKSProcessInfo.Create;
        ProcessInfo.ProcessID := ProcessEntry.th32ProcessID;
        ProcessInfo.ModulePath := ProcessEntry.szExeFile;
        FProcesses.Add(ProcessInfo);
      until not Process32Next(hProcessSnap, ProcessEntry);
    end;
    // Don't forget to clean up the snapshot object...
    CloseHandle(hProcessSnap);
  end;
end;

end.
