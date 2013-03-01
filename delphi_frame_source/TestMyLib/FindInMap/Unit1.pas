unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,ComWriUtils;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    Edit1: TEdit;
    Button1: TButton;
    Edit2: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Map : TStringMap;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

const
  Total = 26;

procedure TForm1.FormCreate(Sender: TObject);
var
  c : char;
  s1,s2 : string;
begin
  ListBox1.items.Clear;
  Map := TStringMap.Create(false,false);
  for c:='a' to 'z' do
  begin
    s1 := c;
    s2 := uppercase(s1);
    Map.add(s1,s2);
    ListBox1.items.add(s1+':'+s2);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i : integer;
  s : string;
begin
  s := edit1.text;
  i := Map.FindName(s);
  if i>=0 then
    edit2.text := Map.Values[i]
  else edit2.text := '<none>';
end;

end.
