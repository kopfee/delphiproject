unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Container,ExtUtils,ProgressDlgs;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edSource: TEdit;
    btnBrowse: TButton;
    btnCopy: TButton;
    Label2: TLabel;
    edDest: TEdit;
    Button1: TButton;
    cpOptions: TContainerProxy;
    lbResult: TLabel;
    Label4: TLabel;
    edMasks: TEdit;
    cbIncludeSubDir: TCheckBox;
    rbInclude: TRadioButton;
    rbExclude: TRadioButton;
    gbSubDir: TGroupBox;
    edDirMasks: TEdit;
    rbIncludeDir: TRadioButton;
    rbExcludeDir: TRadioButton;
    procedure btnCopyClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbIncludeSubDirClick(Sender: TObject);
  private
    { Private declarations }
    progress : TProgrssWithReport;
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
  public
    { Public declarations }
    FileMasks : TStringList;
    include : boolean;
    DirMasks : TStringList;
    includeDir : boolean;
  end;

var
  Form1: TForm1;

implementation

uses FileCtrl,FileCopyOptCnt,Masks;

{$R *.DFM}

procedure TForm1.btnCopyClick(Sender: TObject);
begin
  progress.Start;
end;

procedure TForm1.btnBrowseClick(Sender: TObject);
var
  dir :string;
begin
  dir := edSource.Text;
  if SelectDirectory(dir,[],0) then
    edSource.Text := dir;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  dir :string;
begin
  dir := edDest.Text;
  if SelectDirectory(dir,[],0) then
    edDest.Text := dir;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  (cpOptions.Container as TctFileCopyOptions)
    .SetCopyOptions(caoCopyWhenNeed);
  progress := TProgrssWithReport.Create(self);
  progress.OnRun := Run;
  progress.ConfirmCaption := 'Í£Ö¹¿½±´?';
  progress.CancelConfirm := true;
  FileMasks := TStringList.Create;
  DirMasks := TStringList.Create;
end;

procedure TForm1.Run(sender: TObject);
var
  options : TCopyAgentOptions;
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
begin
  progress.AddInfo(Source+'->'+Dest+':'
    +CopyResultMsg[CopyResult]);
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

end.
