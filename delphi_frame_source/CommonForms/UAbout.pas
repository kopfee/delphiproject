unit UAbout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TdlgAbout = class(TForm)
    imgApplication: TImage;
    Image2: TImage;
    lbCaption: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    Label3: TLabel;
    Image1: TImage;
    Image3: TImage;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgAbout: TdlgAbout;

procedure ShowAbout;

implementation

{$R *.DFM}

procedure ShowAbout;
begin
  dlgAbout := TdlgAbout.Create(Application);
  try
    dlgAbout.ShowModal;
  finally
    dlgAbout.free;
  end;

end;

procedure TdlgAbout.FormCreate(Sender: TObject);
begin
  imgApplication.Picture.Icon := Application.Icon;
  lbCaption.Caption := Application.Title;
end;

end.
