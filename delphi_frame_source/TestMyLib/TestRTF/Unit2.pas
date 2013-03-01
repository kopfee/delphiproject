unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Spin, RTFUtils;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    lbSelStart: TLabel;
    lbTest: TLabel;
    RichView1: TRichView;
    Label3: TLabel;
    lbX: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure RichView1HotClick(Sender: TCustomRichEdit;
      CharIndex: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses ExtUtils;

procedure TForm1.FormCreate(Sender: TObject);
begin
  RichView1.Lines.LoadFromFile('c:\test.rtf');
  RichView1.lbSelStart:=lbSelStart;
  RichView1.lbX := lbX;
end;

procedure TForm1.RichView1HotClick(Sender: TCustomRichEdit;
  CharIndex: Integer);
begin
  Sender.SelLength:=1;
  lbTest.caption := Sender.SelText;
end;

end.
