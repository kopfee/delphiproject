unit UAniIcon;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, WinUtils, ShellUtils, StdCtrls, FontStyles, ExtCtrls, ImgList;

type
  TForm1 = class(TForm)
    LeftPopup: TPopupMenu;
    Button1: TButton;
    Button2: TButton;
    FontStyles1: TFontStyles;
    Label1: TLabel;
    Edit1: TEdit;
    Button3: TButton;
    Images: TImageList;
    MultiIcon1: TMultiIcon;
    RightPopup: TPopupMenu;
    imEnabled: TMenuItem;
    imAnimate: TMenuItem;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FontStyles1SelectFont(Sender: TObject; index: Integer;
      SelectFont: TFont);
    procedure Button3Click(Sender: TObject);
    procedure imEnabledClick(Sender: TObject);
    procedure imAnimateClick(Sender: TObject);
  private
    { Private declarations }
    ToHide : boolean;
    First : boolean;
    procedure CheckAnimate;
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
  //MultiIcon1.active := true;
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
  MultiIcon1.Tip:=edit1.text;
end;


procedure TForm1.imEnabledClick(Sender: TObject);
begin
  with Sender as TMenuItem do
  begin
    checked := not checked;
    if not checked then
    begin
      MultiIcon1.Animate := false;
      MultiIcon1.CurIndex := images.count-1;
    end
    else CheckAnimate;
  end;
end;

procedure TForm1.CheckAnimate;
begin
  if imAnimate.checked then
  	MultiIcon1.Animate := true
  else
  begin
    MultiIcon1.Animate := false;
    MultiIcon1.CurIndex := 0;
  end;
end;

procedure TForm1.imAnimateClick(Sender: TObject);
begin
  with Sender as TMenuItem do
  begin
    checked := not checked;
    CheckAnimate;
  end;
end;

end.
