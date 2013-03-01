unit UMovie3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, AMovie_TLB, StdCtrls;

type
  TForm1 = class(TForm)
    ActiveMovie1: TActiveMovie;
    cbAutoStart: TCheckBox;
    cbExitWhenDone: TCheckBox;
    cbRepeat: TCheckBox;
    procedure ActiveMovie1Click(Sender: TObject);
    procedure ActiveMovie1StateChange(Sender: TObject; oldState,
      newState: Integer);
    procedure cbAutoStartClick(Sender: TObject);
    procedure ActiveMovie1OpenComplete(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.ActiveMovie1Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.ActiveMovie1StateChange(Sender: TObject; oldState,
  newState: Integer);
begin
  //if ActiveMovie1.CurrentPosition=ActiveMovie1.SelectionEnd then
  if (OldState=amvRunning) and (newState=amvStopped)
    and (ActiveMovie1.CurrentPosition=0) then
  begin
    if cbRepeat.checked then
      begin
        ActiveMovie1.CurrentPosition:=0;
        ActiveMovie1.Run;
      end
    else if cbExitWhenDone.checked then
            close;
  end;
end;

procedure TForm1.cbAutoStartClick(Sender: TObject);
var
  saveName : string;
begin
  saveName := ActiveMovie1.FileName;
  ActiveMovie1.FileName := '';
  ActiveMovie1.AutoStart := cbAutoStart.checked;
  ActiveMovie1.FileName := saveName;
end;

procedure TForm1.ActiveMovie1OpenComplete(Sender: TObject);
begin
  ActiveMovie1.run;
end;

end.
