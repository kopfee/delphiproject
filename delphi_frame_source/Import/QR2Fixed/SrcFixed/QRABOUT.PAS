{ :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: QuickReport 2.0 for Delphi 1.0/2.0/3.0                  ::
  ::                                                         ::
  :: QRABOUT.PAS - QuickReport About box with registration   ::
  ::                                                         ::
  :: Copyright (c) 1997 QuSoft AS                            ::
  :: All Rights Reserved                                     ::
  ::                                                         ::
  :: web: http://www.qusoft.no   mail: support@qusoft.no     ::
  ::                             fax: +47 22 41 74 91        ::
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: }

(*{$define proversion}*)

unit qrabout;

interface

uses
{$ifdef win32}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, OleCtrls, ShellAPI;
{$else}
  Wintypes, winprocs, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;
{$endif}

type
  { TQRAboutbox, About box with registration form and services }
  TQRAboutBox = class(TForm)
    Image1: TImage;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    VisitLabel: TLabel;
    Label3: TLabel;
    OrderLabel: TLabel;
    Bevel1: TBevel;
    Label5: TLabel;
    Image2: TImage;
    Label4: TLabel;
    CredPanel: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Label3Click(Sender: TObject);
  private
    EggOK : boolean;
  end;

implementation

{$R *.DFM}

{ TQRAboutBox }

procedure TQRAboutBox.Button3Click(Sender: TObject);
begin
  Close;
end;

procedure TQRAboutBox.FormCreate(Sender: TObject);
begin
{$ifdef proversion}
  VisitLabel.Caption := 'For updates, QuickReport add-ons and other components visit us at our web site at';
  OrderLabel.Caption := '';
{$endif}
  EggOK := false;
{$ifdef ver100}
  Label3.Cursor := crHandPoint;
{$endif}
end;

procedure TQRAboutBox.Label4MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbRight) and EggOK then
  begin
    CredPanel.Top := 92;
    CredPanel.Left := 92;
    CredPanel.Visible := true;
  end;
end;

procedure TQRAboutBox.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  EggOK := (ssShift in Shift) and (ssAlt in Shift);
end;

procedure TQRAboutBox.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  EggOK := (ssShift in Shift) and (ssAlt in Shift);
end;

procedure TQRAboutBox.Label3Click(Sender: TObject);
const
  QuSoftPage = 'www.qusoft.com';
begin
{$ifdef win32}
  ShellExecute(Handle, 'open', QuSoftPage, nil, nil, SW_SHOW);
{$endif}
end;

end.
