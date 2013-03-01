unit UProjectReport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, PrjRepScripts,
  StdCtrls, ComCtrls;

type
  TfmProjectReport = class(TForm)
    pcPages: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    btnSelectScript: TButton;
    mmScripts: TMemo;
    btnSelectOutput: TButton;
    mmOutput: TMemo;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    btnOpenResult: TButton;
    lbSubDir: TLabel;
    edSubDir: TEdit;
    procedure btnSelectScriptClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSelectOutputClick(Sender: TObject);
    procedure btnOpenResultClick(Sender: TObject);
  private
    { Private declarations }
    FContext : TPRContext;
    FFilter : string;
    procedure DoProgress(Sender : TObject);
  public
    { Public declarations }
  end;

var
  fmProjectReport: TfmProjectReport;

procedure ShowProjectReport;

implementation

uses ExtUtils;

{$R *.DFM}

procedure ShowProjectReport;
var
  Dialog : TfmProjectReport;
begin
  Dialog := TfmProjectReport.Create(Application);
  try
    Dialog.ShowModal;
  finally
    Dialog.Free;
  end;
end;

procedure TfmProjectReport.btnSelectScriptClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    mmScripts.Lines.LoadFromFile(OpenDialog.FileName);
    FContext.LoadScripts(OpenDialog.FileName);
  end;
end;

procedure TfmProjectReport.FormCreate(Sender: TObject);
begin
  FContext := TPRContext.Create;
  FContext.OnProgress := DoProgress;
  FFilter := SaveDialog.Filter;
  pcPages.ActivePageIndex := 0;
end;

procedure TfmProjectReport.FormDestroy(Sender: TObject);
begin
  FContext.Free;
end;

procedure TfmProjectReport.btnSelectOutputClick(Sender: TObject);
var
  S : string;
begin
  btnOpenResult.Enabled := False;
  if FContext.Postfix='' then
    SaveDialog.Filter := FFilter else
    SaveDialog.Filter := FContext.PostfixDescription + '|' + FContext.Postfix + '|' + FFilter;
  SaveDialog.DefaultExt := FContext.DefaultPostfix;
  SaveDialog.FileName := FContext.DefaultOutputFile;
  if SaveDialog.Execute then
  begin
    mmOutput.Lines.Clear;

    S := edSubDir.Text;
    if (S<>'') and (S[Length(S)]<>'\') then
      S := S+'\';
    FContext.NewFileSubdir := S;

    FContext.Output(SaveDialog.FileName);

    mmOutput.Lines.LoadFromFile(SaveDialog.FileName);
    btnOpenResult.Enabled := True;
  end;
end;

procedure TfmProjectReport.btnOpenResultClick(Sender: TObject);
begin
  ShellOpenFile(SaveDialog.FileName);
end;

procedure TfmProjectReport.DoProgress(Sender: TObject);
begin
  Application.ProcessMessages;
end;

end.
