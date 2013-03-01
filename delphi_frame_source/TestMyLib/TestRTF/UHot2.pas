unit UHot2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, RTFUtils, BkGround;

type
  TForm1 = class(TForm)
    BackGround1: TBackGround;
    HyperTextView1: THyperTextView;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  HyperTextView1.loadFromFile('c:\test.rtf');
end;

end.
