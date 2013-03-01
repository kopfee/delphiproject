unit ProgDlg;

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
  show;
end;

procedure TdlgProgress.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Application.MainForm.Enabled:=true;
end;

end.
