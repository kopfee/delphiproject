unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses MsgFilters,ComWriUtils;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //InstallMouseDrag(Button1,true,HTBOTTOM);
  with TMousePass(HookMsgFilter(Button2,TMousePass)) do
  begin
    HitResult := HTBOTTOM;
    DestWin := Button1;
  end;
  //Button1.HandleNeeded;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  Button1.visible := CheckBox1.checked;
end;

end.
