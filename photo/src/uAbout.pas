unit uAbout;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, Buttons, ExtCtrls;

type
    TfrmAbout = class(TForm)
        pnl1: TPanel;
        Label1: TLabel;
        Label2: TLabel;
        mmo1: TMemo;
        img1: TImage;
        Panel1: TPanel;
        btnExit: TBitBtn;
        procedure btnExitClick(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    frmAbout: TfrmAbout;

implementation

{$R *.dfm}

procedure TfrmAbout.btnExitClick(Sender: TObject);
begin
    close();
end;

end.
