unit test2;

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms,container;

type
  TMyContainer = class(TContainer)
    Label1: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    count : integer;
  public

  end;

var
  MyContainer: TMyContainer;

implementation

{$R *.DFM}

procedure TMyContainer.Button1Click(Sender: TObject);
begin
  inc(count);
  label1.Caption := IntToStr(count);
end;

initialization

registerClass(TMyContainer)

end.
