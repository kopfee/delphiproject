unit UPageCtrl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, PPageControl, PBevel, StdCtrls, Buttons, PBitBtn;

type
  TForm1 = class(TForm)
    PPageControl1: TPPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    PBevel1: TPBevel;
    PBevel2: TPBevel;
    Button1: TButton;
    Button2: TButton;
    PBitBtn1: TPBitBtn;
    PBitBtn2: TPBitBtn;
    PBitBtn3: TPBitBtn;
    PBitBtn4: TPBitBtn;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure PPageControl1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
{$R test.res}

procedure TForm1.Button1Click(Sender: TObject);
begin
  //PPageControl1.ActivePage := TabSheet2;
  PPageControl1.SelectPage(TabSheet2);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  //PPageControl1.ActivePage := TabSheet1;
  PPageControl1.SelectPage(TabSheet1);
end;

procedure TForm1.PPageControl1Change(Sender: TObject);
begin
  showmessage('hh');
end;

end.
