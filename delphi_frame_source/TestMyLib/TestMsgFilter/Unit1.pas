unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs,ComWriUtils, StdCtrls, Buttons;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button1: TBitBtn;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

type
  TButtonFilter1 = Class(TMsgFilter)
  private
    procedure WMLButtonDown(var msg : TWMMOuse);message WM_LButtonDown;
  end;

  TButtonFilter2 = Class(TMsgFilter)
  private
    FCount : integer;
    procedure WMLButtonDown(var msg : TWMMOuse);message WM_LButtonDown;
  public
    constructor Create(AControl : TControl);
  end;

implementation

{$R *.DFM}

{ TButtonFilter1 }

procedure TButtonFilter1.WMLButtonDown(var msg: TWMMOuse);
begin
  with TButton(Control) do
  begin
    tag := 1-tag;
  	if tag=0 then font.color := clRed
    else font.color := clBlue;
  end;
end;


{ TButtonFilter2 }

constructor TButtonFilter2.Create(AControl: TControl);
begin
  inherited Create(AControl);
  FCount := 0;
end;

procedure TButtonFilter2.WMLButtonDown(var msg: TWMMOuse);
begin
  INC(FCount);
  TButton(Control).caption := IntToStr(FCount);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  HookMsgFilter(Button1,TButtonFilter1);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  HookMsgFilter(Button1,TButtonFilter2);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  ReleaseMsgFilter(Button1,TButtonFilter1);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  ReleaseMsgFilter(Button1,TButtonFilter2);
end;

end.
