unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtDlgs, ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    Button3: TButton;
    Panel1: TPanel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses NewDlgs;

procedure TForm1.Button1Click(Sender: TObject);
var
  Dlg : TOpenDialogEx;
begin
  Dlg := TOpenDialogEx.Create(self);
  try
    Dlg.Execute;
  finally
    Dlg.free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  OpenPictureDialog1.Execute;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  OpenDialog1.Execute;
end;

end.
