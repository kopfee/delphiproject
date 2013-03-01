unit ProgDlg2;

(*****   Code Written By Huang YanLai   *****)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls;

type
  TdlgProgress = class(TForm)
    lbInfo: TLabel;
    ProgressBar: TProgressBar;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    canceled : boolean;
    procedure execute;
    procedure setInfo(const s:string);
    procedure setRange(min,max:integer);
    procedure setPos(p:integer);
    procedure checkCanceled;
  end;

var
  dlgProgress: TdlgProgress;

implementation

{$R *.DFM}

procedure TdlgProgress.BitBtn1Click(Sender: TObject);
begin
  canceled:=true;
  close;
end;

procedure TdlgProgress.execute;
begin
  canceled:=false;
  Application.MainForm.Enabled:=false;
  ProgressBar.Position:=0;
  show;
end;

procedure TdlgProgress.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Application.MainForm.Enabled:=true;
end;

procedure TdlgProgress.checkCanceled;
begin
  Application.ProcessMessages;
  if canceled then abort;
end;

procedure TdlgProgress.setInfo(const s: string);
begin
  lbInfo.Caption:=s;
end;

procedure TdlgProgress.setPos(p: integer);
begin
  ProgressBar.Position:=p;
end;

procedure TdlgProgress.setRange(min, max: integer);
begin
  ProgressBar.Min:=min;
  ProgressBar.Max:=max;
end;

initialization
  dlgProgress := nil;
  
end.
