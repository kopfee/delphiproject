unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls,BasicDataAccess_TLB,DataServer_TLB,
  Spin;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edHost: TEdit;
    Label2: TLabel;
    edServer: TEdit;
    Label3: TLabel;
    edUser: TEdit;
    Label4: TLabel;
    edPassword: TEdit;
    btnConnect: TButton;
    PageControl1: TPageControl;
    tsSQL: TTabSheet;
    tsResult: TTabSheet;
    mmSQL: TMemo;
    btnExec: TButton;
    rdBrowse: TRadioButton;
    rbPrint: TRadioButton;
    sePerReading: TSpinEdit;
    Label5: TLabel;
    btnNext: TButton;
    btnClear: TButton;
    mmResult: TRichEdit;
    edBinding: TEdit;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnExecClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  private
    { Private declarations }
    DataServer : ITestData;
    Dataset : IHDataset;
    Render : IHResultRender;
    procedure readData;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  DataServer := CoTestData.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Render := nil;
  Dataset := nil;
  DataServer := nil;
end;

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  DataServer.connect(edHost.text,edServer.text,edUser.text,edPassword.text);
  if DataServer.Connected then
  begin
    btnConnect.Enabled := false;
    btnExec.Enabled := true;
  end;
end;

procedure TForm1.btnExecClick(Sender: TObject);
begin
  mmResult.Lines.Clear;
  Dataset := DataServer.exec(mmSQL.lines.text);
  if rbPrint.Checked then
  begin
    Render := Dataset.getRender(rtPrint);
    Render.prepare(0,edBinding.text);
  end else
  begin
    Render := Dataset.getRender(rtBrowse);
    Render.prepare('grid',edBinding.text);
  end;
  readData;
end;

procedure TForm1.readData;
begin
  if Render<>nil then
  begin
    mmResult.Lines.add(Render.getData(sePerReading.value));
    btnNext.enabled := not Render.eof;
  end;
end;

procedure TForm1.btnNextClick(Sender: TObject);
begin
  readData;
end;

procedure TForm1.btnClearClick(Sender: TObject);
begin
  mmResult.Lines.Clear;
end;

end.
