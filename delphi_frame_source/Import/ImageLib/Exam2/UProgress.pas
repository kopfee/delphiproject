unit UProgress;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls;

type
  TdlgProgress = class(TForm)
    ProgressBar1: TProgressBar;
    btnCancel: TBitBtn;
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    isCancel : boolean;
    procedure   Start;
    procedure   Done;
    procedure   Progress(value : integer);
  end;

var
  dlgProgress: TdlgProgress;

implementation

{$R *.DFM}

procedure TdlgProgress.btnCancelClick(Sender: TObject);
begin
  isCancel := true;
  Done;
end;

procedure TdlgProgress.Done;
begin
  Close;
end;

procedure TdlgProgress.Progress(value: integer);
begin
  ProgressBar1.Position:=value;
  Application.ProcessMessages;
  //Update;
end;

procedure TdlgProgress.Start;
begin
  btnCancel.Enabled := true;
  ProgressBar1.Position:=0;
  isCancel := false;
  Show;
end;

end.
