unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, VTXAuto;

type
  TForm1 = class(TForm)
    edSentence: TEdit;
    Label1: TLabel;
    btnSpeech: TButton;
    procedure edSentenceKeyPress(Sender: TObject; var Key: Char);
    procedure btnSpeechClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    VTxtAuto : IVTxtAuto;
    procedure SpeechText(const Text:string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.edSentenceKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
    SpeechText(edSentence.Text);
end;

procedure TForm1.btnSpeechClick(Sender: TObject);
begin
  SpeechText(edSentence.Text);
end;

procedure TForm1.SpeechText(const Text: string);
begin
  VTxtAuto.Speak(Pchar(Text),vtxtst_STATEMENT or vtxtsp_VERYHIGH);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  VTxtAuto := CoVTxtAuto_.Create;
  VTxtAuto.Register('',Caption);
end;

end.
