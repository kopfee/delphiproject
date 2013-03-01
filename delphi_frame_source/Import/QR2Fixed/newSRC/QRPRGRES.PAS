{ :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: QuickReport 2.0 for Delphi 1.0/2.0/3.0                  ::
  ::                                                         ::
  :: QRPRGRESS.PAS - Foreground printing progress form       ::
  ::                                                         ::
  :: Copyright (c) 1997 QuSoft AS                            ::
  :: All Rights Reserved                                     ::
  ::                                                         ::
  :: web: http://www.qusoft.no   mail: support@qusoft.no     ::
  ::                             fax: +47 22 41 74 91        ::
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: }

unit QRPrgres;    

interface

uses
{$ifdef win32}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, QRPrntr, QR2Const;
{$else}
  Wintypes, WinProcs, Sysutils, Classes, Controls, StdCtrls, ExtCtrls,
  Graphics, Forms, QR2Const, QRPrntr;
{$endif}

type
  TQRProgressForm = class(TForm)
    Info: TLabel;
    CancelButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
  private
    FQRPrinter : TQRPrinter;
    Gauge : TQRGauge;
  protected
    procedure CMQRPROGRESSUPDATE(var Message); message CM_QRPROGRESSUPDATE;
  public
    property QRPrinter : TQRPrinter read FQRPrinter write FQRPrinter;
  end;

implementation

{$R *.DFM}

procedure TQRProgressForm.FormCreate(Sender: TObject);
begin
  Gauge := TQRGauge.Create(Self);
  with Gauge do
  begin
    Parent := Self;
    Top := 10;
    Left := 10;
    Width := Self.Width - 20;
    Height := 15;
  end;
end;

procedure TQRProgressForm.CMQRPROGRESSUPDATE(var Message);
begin
  if (FQRPrinter.Progress mod 5) = 0 then
  begin
    Gauge.Position := FQRPrinter.Progress;
    Info.Caption := IntToStr(FQRPrinter.Progress)+'% ' + LoadStr(SqrCompleted);
    Application.ProcessMessages;
  end;
end;

procedure TQRProgressForm.CancelButtonClick(Sender: TObject);
begin
  FQRPrinter.Cancel;
end;

end.
