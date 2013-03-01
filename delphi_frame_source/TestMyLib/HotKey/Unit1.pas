unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, WinUtils, HotKeyMons, ComCtrls,Menus;

type
  TForm1 = class(TForm)
    HotKeyMonitor1: THotKeyMonitor;
    Label1: TLabel;
    lbCount: TLabel;
    HotKey1: THotKey;
    Button1: TButton;
    Label2: TLabel;
    Label3: TLabel;
    lbShortCut: TLabel;
    procedure HotKeyMonitor1HotKey(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateShortcut;
  public
    { Public declarations }
    Count : integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.HotKeyMonitor1HotKey(Sender: TObject);
begin
  inc(Count);
  lbCount.Caption := IntToStr(Count);
  WindowState := wsNormal;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  HotKeyMonitor1.ShortCut := HotKey1.HotKey;
  UpdateShortcut;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  UpdateShortcut;
end;

procedure TForm1.UpdateShortcut;
begin
  lbShortCut.caption :=  ShortCutToText(HotKeyMonitor1.ShortCut);
end;

end.
