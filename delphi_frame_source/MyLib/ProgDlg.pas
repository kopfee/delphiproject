unit ProgDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls;

type
  TdlgProgress = class(TForm)
    ProgressBar: TProgressBar;
    lbCaption: TLabel;
    btnCancel: TBitBtn;
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    Canceled : boolean;
    procedure Execute;
  end;

var
  dlgProgress: TdlgProgress;

implementation

{$R *.DFM}

{ TdlgProgress }

procedure TdlgProgress.Execute;
begin
  canceled := false;
  ShowModal;
end;

procedure TdlgProgress.btnCancelClick(Sender: TObject);
begin
  Canceled := true;
end;

end.
