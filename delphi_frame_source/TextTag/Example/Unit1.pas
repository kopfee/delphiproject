unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TextTags;

type
  TForm1 = class(TForm)
    btnTest: TButton;
    lsNodes: TListBox;
    mmText: TMemo;
    OpenDialog: TOpenDialog;
    mmSource: TMemo;
    procedure btnTestClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lsNodesClick(Sender: TObject);
  private
    { Private declarations }
    FParser : TTextTagParser;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FParser := TTextTagParser.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FParser.Free;
end;

procedure TForm1.btnTestClick(Sender: TObject);
var
  i : integer;
  Node : TTATextNode;
  S : string;
begin
  if OpenDialog.Execute then
  begin
    mmSource.Lines.LoadFromFile(OpenDialog.FileName);
    lsNodes.Items.Clear;
    FParser.ParseFile(OpenDialog.FileName);
    for i:=0 to FParser.Nodes.count-1 do
    begin
      Node := TTATextNode(FParser.Nodes[i]);
      case Node.NodeType of
        stText : S := 'Text';
        stTag  : S := 'Tag';
      else       S := 'Any';
      end;
      lsNodes.Items.AddObject(S,Node);
    end;
    mmText.Text := '';
  end;
end;

procedure TForm1.lsNodesClick(Sender: TObject);
var
  Node : TTATextNode;
begin
  if lsNodes.ItemIndex>=0 then
  begin
    Node := TTATextNode(lsNodes.Items.Objects[lsNodes.ItemIndex]);
    mmText.Text := Node.Text;
  end;
end;

end.
