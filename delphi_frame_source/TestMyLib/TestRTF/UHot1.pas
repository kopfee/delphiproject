unit UHot1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
 	RTFUtils, StdCtrls, Spin;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    btnLoad: TButton;
    btnSave: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    Label1: TLabel;
    edName: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edDescription: TEdit;
    edStart: TSpinEdit;
    edLength: TSpinEdit;
    Label4: TLabel;
    btnAdd: TButton;
    ListBox1: TListBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edLinkTo: TEdit;
    procedure btnLoadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    HotItems : THotLinkItems;
    procedure UpdateDetail;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnLoadClick(Sender: TObject);
begin
  if FileExists(edit1.text)
  	then Memo1.Lines.LoadFromFile(edit1.text)
    else Memo1.Lines.clear;
  HotItems.LoadFromFile(edit1.text);
  UpdateDetail;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  HotItems := THotLinkItems.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  HotItems.free;
end;

procedure TForm1.btnSaveClick(Sender: TObject);
begin
  HotItems.SaveToFile(Edit2.text);
  Memo2.Lines.loadFromFile(Edit2.text);
end;

procedure TForm1.UpdateDetail;
var
  i : integer;
  s : string;
begin
  Listbox1.items.clear;
  for i:=0 to HotItems.count-1 do
  with HotItems[i] do
  begin
    s := name + ':' + IntToStr(Start)+':'+IntToStr(Length);
    Listbox1.items.Add(s);
  end;
end;

procedure TForm1.btnAddClick(Sender: TObject);
begin
  with HotItems.AddItemName(edName.text) do
  begin
    Start := edStart.value;
    Length := edLength.value;
    Description := edDescription.text;
    LinkTo := edLinkTo.Text;
  end;
  UpdateDetail;
end;

end.
