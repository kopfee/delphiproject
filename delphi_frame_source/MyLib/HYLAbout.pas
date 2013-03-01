unit HYLAbout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, ExtUtils;

type
  TdlgAbout = class(TForm)
    dlgAbout: TPanel;
    Animate1: TAnimate;
    Label1: TLabel;
    lbProductName: TLabel;
    Timer1: TTimer;
    lbVersion: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lbHomePage: TLabel;
    Label5: TLabel;
    imIcon: TImage;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    procedure dlgAboutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure lbHomePageClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  dlgAbout: TdlgAbout;
  MyProductName, MyProductVersion : string;

procedure ShowAbout;

procedure StartAbout(const Interval:integer=2000);

procedure EndAbout;

implementation

uses ShellAPI;

var
  StartAboutDlg : TdlgAbout;

procedure ShowAbout;
begin
  StartAbout(0);
end;

procedure StartAbout(const Interval:integer=2000);
begin
  StartAboutDlg := TdlgAbout.create(nil);
  if Interval=0 then
  begin
    StartAboutDlg.Timer1.Interval := Interval;
    StartAboutDlg.BorderStyle := bsDialog;
    StartAboutDlg.ShowModal;
  end else
  begin
    StartAboutDlg.Timer1.Interval := Interval;
    StartAboutDlg.Show;
    StartAboutDlg.Refresh;
  end;
end;

procedure EndAbout;
begin
  FreeAndNil(StartAboutDlg);
end;

{$R *.DFM}

procedure TdlgAbout.dlgAboutClick(Sender: TObject);
begin
  Close;
end;

procedure TdlgAbout.FormCreate(Sender: TObject);
var
  FileName : string;
  VersionInfo : TKSFileVersionInfo;
  Language : LongWord;
  ModuleFileName : string;
  ModuleFileNameBuffer : array[0..MAX_PATH-1] of Char;
  Icon : THandle;
begin
  FileName := ChangeFileExt(Application.ExeName,'.avi');
  if not FileExists(FileName) then
    FileName := ExtractFilePath(Application.ExeName)+'cool.avi';
  if FileExists(FileName) then
    Animate1.FileName := FileName else
    Animate1.CommonAVI := aviFindComputer;
  Animate1.Active := true;

  lbProductName.Caption := MyProductName;
  lbVersion.Caption := MyProductVersion;
  // 保证如果是动态连接库也可以正确获得模块文件名和对应的版本信息
  FillChar(ModuleFileNameBuffer,SizeOf(ModuleFileNameBuffer),0);
  GetModuleFileName(HInstance,ModuleFileNameBuffer,SizeOf(ModuleFileNameBuffer)-1);
  ModuleFileName := string(PChar(@ModuleFileNameBuffer));
  VersionInfo := TKSFileVersionInfo.Create(ModuleFileName);
  try
    if VersionInfo.Available then
    begin
      Language := VersionInfo.GetLanguageCharset;
      if Language>0 then
      begin
        lbProductName.Caption := VersionInfo.GetInfo(Language,'ProductName');
        lbVersion.Caption := VersionInfo.GetInfo(Language,'FileVersion');
      end;
    end;
  finally
    VersionInfo.Free;
  end;
  if not IsLibrary then
  begin
    imIcon.Picture.Icon:=Application.Icon;
  end else
  begin
    // 如果是动态连接库，从动态连接库获得图标
    Icon := ExtractIcon(HInstance,@ModuleFileNameBuffer,0);
    if Icon>1 then
      imIcon.Picture.Icon.Handle := Icon;
  end;
end;

procedure TdlgAbout.Timer1Timer(Sender: TObject);
begin
  Close;
end;

procedure TdlgAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TdlgAbout.FormKeyPress(Sender: TObject; var Key: Char);
begin
  close;
end;

procedure TdlgAbout.CreateParams(var Params: TCreateParams);
begin
  inherited;
  {with Params do
  begin
    ExStyle := ExStyle and not WS_EX_APPWINDOW;
    ExStyle := ExStyle or WS_EX_TOOLWINDOW;
  end;}
end;

procedure TdlgAbout.lbHomePageClick(Sender: TObject);
begin
  ShellOpenFile(TLabel(Sender).Caption);
end;

end.
