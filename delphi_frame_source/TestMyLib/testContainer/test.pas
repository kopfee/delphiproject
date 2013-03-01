unit test;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons,Container, AbilityManager;

type
  TMyContainer = class(TContainer)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MyContainer : TMyContainer;

implementation

{$R *.DFM}

procedure TMyContainer.BitBtn1Click(Sender: TObject);
begin
  label2.caption := '1';
end;

procedure TMyContainer.BitBtn2Click(Sender: TObject);
begin
  label2.caption := '2';
end;

end.
