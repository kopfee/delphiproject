unit UMovie4;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, AMovie_TLB, ComCtrls, StdCtrls, ExtCtrls, ActiveMovieEx;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    Panel1: TPanel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    OpenDialog1: TOpenDialog;
    cbChangeDisplayMode: TCheckBox;
    ActiveMovieEx1: TActiveMovieEx;
    ActiveMovieEx2: TActiveMovieEx;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure cbChangeDisplayModeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.execute then
  begin
    Edit1.text := OpenDialog1.FileName;
    Button2Click(Sender);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ActiveMovieEx1.FileName := Edit1.text;
  ActiveMovieEx2.FileName := Edit1.text;
end;

procedure TForm1.cbChangeDisplayModeClick(Sender: TObject);
begin
  with ActiveMovieEx1 do
  begin
    BeginSetproperty;
    AllowChangeDisplayMode := cbChangeDisplayMode.Checked;
    EndSetproperty;
  end;
  with ActiveMovieEx2 do
  begin
    BeginSetproperty;
    AllowChangeDisplayMode := cbChangeDisplayMode.Checked;
    EndSetproperty;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  {with ActiveMovieEx1 do
  begin
    BeginSetproperty;
    AllowChangeDisplayMode := false;
    EndSetproperty;
  end;
  with ActiveMovieEx2 do
  begin
    BeginSetproperty;
    AllowChangeDisplayMode := false;
    EndSetproperty;
  end;}
end;

end.
