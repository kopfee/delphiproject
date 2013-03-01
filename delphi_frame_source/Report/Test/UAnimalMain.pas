unit UAnimalMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfmMain = class(TForm)
    btnPreview: TButton;
    Memo1: TMemo;
    procedure btnPreviewClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

uses UAnimalsRep;

{$R *.DFM}

procedure TfmMain.btnPreviewClick(Sender: TObject);
begin
  fmReport.RPEasyReport1.Preview;
end;

end.
