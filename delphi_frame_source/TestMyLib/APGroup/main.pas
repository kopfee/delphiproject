unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CompGroup, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    agLabel: TAppearanceGroup;
    agEdit: TAppearanceGroup;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    apLabel: TAppearanceProxy;
    apEdit: TAppearanceProxy;
    FontDialog1: TFontDialog;
    ColorDialog1: TColorDialog;
    Label5: TLabel;
    Label6: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button2Click(Sender: TObject);
begin
  apLabel.configfont;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  apEdit.configColor;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  apEdit.configFont;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  apLabel.configColor;
end;

end.
 