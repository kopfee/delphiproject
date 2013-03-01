unit AboutDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons;

type
  TAboutForm = class(TForm)
    Panel1: TPanel;
    Copyright: TLabel;
    ProductName: TLabel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    OKButton: TBitBtn;
    Memo1: TMemo;
    lbVersion: TLabel;
    procedure OKButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    function ShowModal( VersionStr: string ): Integer;
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.DFM}

function TAboutForm.ShowModal( VersionStr: string ) : Integer;
begin
  lbVersion.Caption := VersionStr;
  Result := inherited ShowModal;
end;


procedure TAboutForm.OKButtonClick(Sender: TObject);
begin
  Close;
end;

end.
