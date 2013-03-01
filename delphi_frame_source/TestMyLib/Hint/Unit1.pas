unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  KSHints, StdCtrls, ExtCtrls, CompGroup;

type
  TForm1 = class(TForm)
    HintMan: THintMan;
    edText: TEdit;
    btnShowHint: TButton;
    AppearanceProxy: TAppearanceProxy;
    FontDialog1: TFontDialog;
    ColorDialog1: TColorDialog;
    procedure btnShowHintClick(Sender: TObject);
    procedure AppearanceProxyColorChanged(Sender: TObject);
    procedure AppearanceProxyFontChanged(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnShowHintClick(Sender: TObject);
begin
  HintMan.ShowHintFor(edText,edText.Text);
end;

procedure TForm1.AppearanceProxyColorChanged(Sender: TObject);
begin
  HintMan.Color := AppearanceProxy.Color;
end;

procedure TForm1.AppearanceProxyFontChanged(Sender: TObject);
begin
  HintMan.Font := AppearanceProxy.Font;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.OnMessage := HintMan.DoApplicationMessage;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Application.OnMessage := nil;
end;

end.
