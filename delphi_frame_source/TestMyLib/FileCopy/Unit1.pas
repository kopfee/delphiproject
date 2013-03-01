unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Container;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edSource: TEdit;
    btnBrowse: TButton;
    btnCopy: TButton;
    OpenDialog1: TOpenDialog;
    Label2: TLabel;
    edDest: TEdit;
    Button1: TButton;
    cpOptions: TContainerProxy;
    lbResult: TLabel;
    procedure btnCopyClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FileHandle : THandle;
  end;

var
  Form1: TForm1;

implementation

uses ExtUtils,FileCopyOptCnt;

{$R *.DFM}

procedure TForm1.btnCopyClick(Sender: TObject);
var
  options : TCopyAgentOptions;
  r : TCopyAgentReturnCode;
  CompResult : TCFIResult;
begin
  (cpOptions.Container as TctFileCopyOptions)
    .GetCopyOptions(options);
  r := CopyFileEx(edSource.Text,edDest.text,options,CompResult);
  lbResult.caption := CopyResultMsg[r];
end;

procedure TForm1.btnBrowseClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    edSource.Text := OpenDialog1.FileName;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    edDest.Text := OpenDialog1.FileName;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  {(cpOptions.Container as TctFileCopyOptions)
    .SetCopyOptions(caoCopyWhenNeed);}
end;

end.
