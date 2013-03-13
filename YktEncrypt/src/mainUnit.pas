unit mainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, RzPanel, RzButton;

type
  TMainForm = class(TForm)
    rzpnl1: TRzPanel;
    btnExit: TRzButton;
    btnEncrypt: TRzButton;
    procedure btnExitClick(Sender: TObject);
    procedure btnEncryptClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses Uencrypt;

{$R *.DFM}

procedure TMainForm.btnExitClick(Sender: TObject);
begin
  application.Terminate;
end;

procedure TMainForm.btnEncryptClick(Sender: TObject);
begin
  frmencrypt:=Tfrmencrypt.Create(nil);
  frmencrypt.ShowModal;
  frmencrypt.Free;
end;

end.
