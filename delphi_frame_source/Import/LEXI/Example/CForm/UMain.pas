unit UMain;

(*****   Code Written By Huang YanLai   *****)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtDialogs, ExtCtrls,RepInfoIntf;

type
  TfmMain = class(TForm,IReport)
    OpenDialogEx1: TOpenDialogEx;
    mmInfo: TMemo;
    Panel1: TPanel;
    Label1: TLabel;
    edFile: TEdit;
    btnBrowse: TButton;
    btnParse: TButton;
    btnGen: TButton;
    ckAutoName: TCheckBox;
    procedure btnBrowseClick(Sender: TObject);
    procedure btnParseClick(Sender: TObject);
    procedure btnGenClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure addInfo(const s:string;catalog:TReportCatalog=rcNormal);
    procedure addInfos(const s:TStrings;catalog:TReportCatalog=rcNormal);
    procedure clearInfo;
  end;

var
  fmMain: TfmMain;

implementation

uses UFormParser;

{$R *.DFM}

procedure TfmMain.addInfo(const s: string; catalog: TReportCatalog);
begin
  mmInfo.Lines.add(s);
end;

procedure TfmMain.addInfos(const s: TStrings; catalog: TReportCatalog);
begin
  mmInfo.Lines.AddStrings(s);
end;

procedure TfmMain.clearInfo;
begin
  mmInfo.Lines.Clear;
end;

procedure TfmMain.btnBrowseClick(Sender: TObject);
begin
  OpenDialogEx1.Execute;
end;

procedure TfmMain.btnParseClick(Sender: TObject);
var
  fs : TFileStream;
begin
  mmInfo.Lines.Clear;
  fs := TFileStream.create(edFile.text,fmOpenRead);
  try
    dmFormParser.Execute(fs,self);
  finally
    fs.free;
  end;
end;


procedure TfmMain.btnGenClick(Sender: TObject);
begin
  dmFormParser.generateForm(ChangeFileExt(edFile.text,'.pas'),ckAutoName.Checked);
end;

end.
