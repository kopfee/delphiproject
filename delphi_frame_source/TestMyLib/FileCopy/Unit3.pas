unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Container,ExtUtils,ProgressDlgs, ComCtrls;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    tsFiles: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    edSource: TEdit;
    btnBrowseSource1: TButton;
    btnCopy: TButton;
    edDest: TEdit;
    btnBrowseDest1: TButton;
    cbIncludeSubDir: TCheckBox;
    gbSubDir: TGroupBox;
    edDirMasks: TEdit;
    rbIncludeDir: TRadioButton;
    rbExcludeDir: TRadioButton;
    tsCopyAction: TTabSheet;
    cpOptions: TContainerProxy;
    tsReport: TTabSheet;
    ckCopyed: TCheckBox;
    ckNotByUser: TCheckBox;
    ckNotNew: TCheckBox;
    ckNotOld: TCheckBox;
    ckNotSize: TCheckBox;
    ckNotSame: TCheckBox;
    ckSourceFull: TCheckBox;
    ckDestFull: TCheckBox;
    GroupBox1: TGroupBox;
    edMasks: TEdit;
    rbInclude: TRadioButton;
    rbExclude: TRadioButton;
    btnBrowseSource2: TButton;
    btnBrowseDest2: TButton;
    btnExploreSource: TButton;
    btnExploreDest: TButton;
    OpenDialog1: TOpenDialog;
    btnOpenOptions: TButton;
    btnSaveOptions: TButton;
    procedure btnCopyClick(Sender: TObject);
    procedure btnBrowseSource1Click(Sender: TObject);
    procedure btnBrowseDest1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbIncludeSubDirClick(Sender: TObject);
    procedure btnBrowseSource2Click(Sender: TObject);
    procedure btnBrowseDest2Click(Sender: TObject);
    procedure btnExploreSourceClick(Sender: TObject);
    procedure btnExploreDestClick(Sender: TObject);
    procedure btnOpenOptionsClick(Sender: TObject);
    procedure btnSaveOptionsClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    progress : TProgrssWithReport;
    isFirst : boolean;
    procedure Run(sender : TObject);
    procedure AfterCopy(const Source,Dest: string;
                    CopyResult : TCopyAgentReturnCode;
              var cont : boolean);
    procedure FileFilter(const FileInfo : TWin32FindData;
                        const Source : string;
                        var   Dest   : string;
                        var   CopyIt : boolean);
    function  FileInMask(const FileName:string;
                Masks : TStrings):boolean;
    procedure SetupMasks;
    procedure SetupMasksByString(Masks : TStrings;
                const MaskStr : string);
    procedure ReadOptions(const FileName:string);
    procedure WriteOptions(const FileName:string);
  public
    { Public declarations }
    options : TCopyAgentOptions;
    FileMasks : TStringList;
    include : boolean;
    DirMasks : TStringList;
    includeDir : boolean;
    function RunCmdParam:boolean;
  end;

var
  Form1: TForm1;

implementation

uses FileCtrl,FileCopyOptCnt,Masks,IniFiles, StrUtils;

{$R *.DFM}

procedure TForm1.btnCopyClick(Sender: TObject);
begin
  progress.Start;
end;

procedure TForm1.btnBrowseSource1Click(Sender: TObject);
var
  dir :string;
begin
  dir := edSource.Text;
  if SelectDirectory('选择源目录','\',dir) then
    edSource.Text := dir;
end;

procedure TForm1.btnBrowseDest1Click(Sender: TObject);
var
  dir :string;
begin
  dir := edDest.Text;
  if SelectDirectory('选择目的目录','\',dir) then
    edDest.Text := dir;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  (cpOptions.Container as TctFileCopyOptions)
    .SetCopyOptions(caoCopyWhenNeed);
  progress := TProgrssWithReport.Create(self);
  progress.OnRun := Run;
  progress.ConfirmCaption := '停止拷贝?';
  progress.CancelConfirm := true;
  FileMasks := TStringList.Create;
  DirMasks := TStringList.Create;
  isFirst := true;
end;

procedure TForm1.Run(sender: TObject);
begin
  SetupMasks;
  include := rbInclude.Checked;
  includeDir := rbIncludeDir.Checked;
  progress.ClearInfo;
  (cpOptions.Container as TctFileCopyOptions)
    .GetCopyOptions(options);
  CopyDir(edSource.Text,edDest.text,
    options,cbIncludeSubDir.checked,
    FileFilter,AfterCopy);
  if progress.Canceled then
    progress.AddInfo('Canceled.')
  else
    progress.AddInfo('Complete.');
  progress.Done;
end;

procedure TForm1.AfterCopy(const Source, Dest: string;
  CopyResult: TCopyAgentReturnCode; var cont: boolean);
var
  LogThis : boolean;
  //S,D : string;
  Files : string;
begin
  LogThis := ((CopyResult=carcCopied) and ckCopyed.Checked)
   or ((CopyResult=carcNotByUser) and ckNotByUser.Checked)
   or ((CopyResult=carcNotForSame) and ckNotSame.Checked)
   or ((CopyResult=carcNotForOlder) and ckNotOld.Checked)
   or ((CopyResult=carcNotForNewer) and ckNotNew.Checked)
   or ((CopyResult=carcNotForSizeDif) and ckNotSize.Checked)
   or (CopyResult in [carcCancelByUser,
   				carcSourceNotExists,
			    carcError,
			    carcNoDestDir,
			    carcCantMakeDestDir]
      );

  if LogThis then
  begin
    Files := '';
	  if not ckSourceFull.Checked and not ckDestFull.Checked then
  	  Files := ExtractFilename(Source)
	  else
    begin
      if ckSourceFull.Checked and ckDestFull.Checked then
        Files := Source+'->'+Dest;
      if ckSourceFull.Checked then
      	Files :=Source
      else if ckDestFull.Checked then
  	    Files:=dest;
    end;
	  progress.AddInfo( Files + ':'
  	  +CopyResultMsg[CopyResult]);
  end;

	if CopyResult=carcCancelByUser then
  	progress.ConfirmUserToCancel;

  cont := progress.ProcessMessages;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FileMasks.free;
  DirMasks.free;
end;

procedure TForm1.FileFilter(const FileInfo: TWin32FindData;
  const Source: string; var Dest: string; var CopyIt: boolean);
var
  InMask : boolean;
  FileName : string;
begin
  FileName := StrPas(pchar(@FileInfo.cFileName));
  if pos('.',FileName)<=0 then
    FileName := FileName + '.';
  if (FileInfo.dwFileAttributes
    and FILE_ATTRIBUTE_DIRECTORY)<>0 then
  begin
    InMask := FileInMask(FileName,DirMasks);
    CopyIt := (includeDir and Inmask)
             or (not includeDir and not Inmask);
  end
  else
  begin
    InMask := FileInMask(FileName,FileMasks);
    CopyIt := (include and Inmask)
             or (not include and not Inmask);
  end;
end;

function TForm1.FileInMask(const FileName:string;
                Masks : TStrings): boolean;
var
  i : integer;
  UpperFileName : string;
begin
  result := false;
  UpperFileName := uppercase(FileName);
  for i:=0 to Masks.count-1 do
    if MatchesMask(UpperFileName,Masks[i]) then
      begin
        result := true;
        break;
      end;
end;

procedure TForm1.SetupMasks;
begin
  SetupMasksByString(FileMasks,edMasks.text);
  SetupMasksByString(DirMasks,edDirMasks.text);
end;

procedure TForm1.cbIncludeSubDirClick(Sender: TObject);
begin
  gbSubDir.enabled := cbIncludeSubDir.Checked;
end;

procedure TForm1.SetupMasksByString(Masks: TStrings;
  const MaskStr: string);
var
  mask,s : string;
  n : integer;
begin
  Masks.Clear;
  s := Uppercase(maskStr);
  n := pos(';',s);
  while n>0 do
  begin
    mask := Copy(s,1,n-1);
    if pos('.',mask)<=0 then
	    mask:= mask+ '.';
    Masks.Add(mask);
    Delete(s,1,n);
    n := pos(';',s);
  end;
  if pos('.',s)<=0 then
	    s:= s+ '.';
  Masks.Add(s);
end;

procedure TForm1.btnBrowseSource2Click(Sender: TObject);
var
  dir :string;
begin
  dir := edSource.Text;
  if SelectDirectory3(dir) then
    edSource.Text := dir;
end;

procedure TForm1.btnBrowseDest2Click(Sender: TObject);
var
	dir : string;
begin
  dir := edDest.Text;
  if SelectDirectory3(dir) then
    edDest.Text := dir;
end;

procedure TForm1.btnExploreSourceClick(Sender: TObject);
begin
  OpenFolder(edSource.Text);
end;

procedure TForm1.btnExploreDestClick(Sender: TObject);
begin
  OpenFolder(edDest.Text);
end;

procedure TForm1.btnOpenOptionsClick(Sender: TObject);
begin
  OpenDialog1.Title := '打开设置文件';
  if OpenDialog1.Execute then
    ReadOptions(OpenDialog1.FileName);
end;

procedure TForm1.btnSaveOptionsClick(Sender: TObject);
begin
  OpenDialog1.Title := '保存设置文件';
  if OpenDialog1.Execute then
    WriteOptions(OpenDialog1.FileName);
end;

const
  FilesSection =    'Files';
  SourceEntry =     'Source';
  DestEntry =       'Dest';
  FileFilterEntry = 'FileFilter';
  DirFilterEntry =  'DirFilter';
  IncludeDirEntry = 'IncludeDir';
  IncludeFileFilterEntry='IncludeFileFilter';
  IncludeDirFilterEntry= 'IncludeDirFilter';
  OptionsSection = 'Options';
  ReportSection = 'Report';

procedure TForm1.ReadOptions(const FileName: string);
var
  ini : TIniFile;
  i : integer;
  AFileName : string;
begin
  if ExtractFilePath(FileName)='' then
    AFileName := AddPathAndName(GetCurrentDir,FileName)   else
    AFileName:=FileName;
  ini := TIniFile.Create(AFileName);
  try
    with ini do
    begin
      edSource.text := ReadString(FilesSection,SourceEntry,'');
      edDest.text := ReadString(FilesSection,DestEntry,'');
      edMasks.text := ReadString(FilesSection,FileFilterEntry,'*.*');
      edDirMasks.text := ReadString(FilesSection,DirFilterEntry,'*.*');
      cbIncludeSubDir.Checked := ReadBool(FilesSection,IncludeDirEntry,true);
      if ReadBool(FilesSection,IncludeFileFilterEntry,true) then
        rbInclude.checked:=true
      else
        rbExclude.checked:=true;
      if ReadBool(FilesSection,IncludeDirFilterEntry,true) then
        rbIncludeDir.checked:=true
      else
        rbExcludeDir.checked:=true;
      for i:=0 to tsReport.ControlCount-1 do
        if tsReport.Controls[i] is TCheckBox then
        with TCheckBox(tsReport.Controls[i]) do
          Checked := ReadBool(ReportSection,Name,Checked);
    end;
    ReadCopyAgentOptions(options,ini,OptionsSection);
    (cpOptions.Container as TctFileCopyOptions)
      .SetCopyOptions(options);
  finally
    ini.free;
  end;
end;

procedure TForm1.WriteOptions(const FileName: string);
var
  ini : TIniFile;
  i : integer;
begin
  ini := TIniFile.Create(FileName);
  try
    with ini do
    begin
      WriteString(FilesSection,SourceEntry,edSource.text);
      WriteString(FilesSection,DestEntry,edDest.text);
      WriteString(FilesSection,FileFilterEntry,edMasks.text);
      WriteString(FilesSection,DirFilterEntry,edDirMasks.text);
      WriteBool(FilesSection,IncludeDirEntry,cbIncludeSubDir.Checked);
      WriteBool(FilesSection,IncludeFileFilterEntry,rbInclude.checked);
      WriteBool(FilesSection,IncludeDirFilterEntry,rbIncludeDir.checked);
      for i:=0 to tsReport.ControlCount-1 do
        if tsReport.Controls[i] is TCheckBox then
        with TCheckBox(tsReport.Controls[i]) do
          WriteBool(ReportSection,Name,Checked);
    end;
    (cpOptions.Container as TctFileCopyOptions)
      .GetCopyOptions(options);
    WriteCopyAgentOptions(options,ini,OptionsSection);
  finally
    ini.free;
  end;
end;

function TForm1.RunCmdParam: boolean;
var
  CfgFile : string;
begin
  result:=false;
  if ParamCount>0 then
  begin
    CfgFile := ParamStr(1);
    if not FileExists(CfgFile) then
      if (ExtractFilePath(CfgFile)='') then
      begin
        CfgFile := AddPathAndName(ExtractFilePath(ParamStr(0)),CfgFile);
        if not FileExists(CfgFile) then exit;
      end
      else exit;
    result := true;
    ReadOptions(CfgFile);
    progress.Start;
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  if isFirst then
  begin
    isFirst:=false;
    if RunCmdParam then Close;
  end;
end;

end.
