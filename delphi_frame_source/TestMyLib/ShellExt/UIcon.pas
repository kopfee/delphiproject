unit UIcon;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, WinUtils, ShellUtils, StdCtrls, FontStyles, ExtCtrls;

type
  TForm1 = class(TForm)
    TrayNotify1: TTrayNotify;
    PopupMenu1: TPopupMenu;
    Button1: TButton;
    Button2: TButton;
    FontStyles1: TFontStyles;
    Label1: TLabel;
    Edit1: TEdit;
    Button3: TButton;
    PaintBox1: TPaintBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FontStyles1SelectFont(Sender: TObject; index: Integer;
      SelectFont: TFont);
    procedure Button3Click(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure TrayNotify1MouseEvent(Sender: TTrayNotify; MouseMsg: Integer;
      var Handled: Boolean);
  private
    { Private declarations }
    ToHide : boolean;
    First : boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses WinObjs;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //TrayNotify1.active := true;
  ToHide := true;
  first := true;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ToHide := true;
  close;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ToHide := false;
  close;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ToHide then
  begin
  	Action:=caNone;
    Hide;
  end
  else
    Action:=caFree;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if first then
  begin
    first := false;
    PostMessage(Handle,WM_SHOWWINDOW,integer(FALSE),0);
  end;
end;

procedure TForm1.FontStyles1SelectFont(Sender: TObject; index: Integer;
  SelectFont: TFont);
begin
  if index=0 then show
  else Button2Click(Sender);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  TrayNotify1.Tip:=edit1.text;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
begin
  PaintBox1.Canvas.Draw(0,0,TrayNotify1.Icon);
end;

procedure TForm1.TrayNotify1MouseEvent(Sender: TTrayNotify;
  MouseMsg: Integer; var Handled: Boolean);
var
  pos : TPoint;
begin
  if MouseMsg=WM_RButtonDown then
  begin
    GetCursorPos(pos);
    PopupMenu1.Popup(pos.x,pos.y);
  end;
end;

end.
