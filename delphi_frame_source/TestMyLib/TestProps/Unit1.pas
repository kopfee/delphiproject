unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,TypUtils;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    lbType: TLabel;
    Label4: TLabel;
    lbValue: TLabel;
    Label5: TLabel;
    edNew: TEdit;
    btnNew: TButton;
    lbTest: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    btnTest: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
  private
    { Private declarations }
    procedure ViewProperties(obj : TObject);
  public
    { Public declarations }
    PropAnalyse : TPropertyAnalyse;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  ViewProperties(lbTest);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PropAnalyse := TPropertyAnalyse.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  PropAnalyse.free;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
  if Listbox1.ItemIndex>=0 then
  with PropAnalyse.Properties[Listbox1.ItemIndex] do
  begin
    lbType.caption := IntToStr(integer(PropType));
    lbValue.caption := AsString;
    edNew.text := lbValue.caption;
    btnNew.Enabled := PropType in [ptOrd,ptString,ptFloat];
  end
  else btnNew.Enabled :=false;
  edNew.ReadOnly := not btnNew.Enabled;
end;

procedure TForm1.ViewProperties(obj: TObject);
var
  i : integer;
begin
  Listbox1.Items.clear;
  PropAnalyse.AnalysedObject := obj;
  label2.caption := IntToStr(PropAnalyse.PropCount);
  for i:=0 to PropAnalyse.PropCount-1 do
    Listbox1.Items.Add(PropAnalyse.PropNames[i]);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ViewProperties(btnTest);
end;

procedure TForm1.btnNewClick(Sender: TObject);
begin
  if Listbox1.ItemIndex>=0 then
  with PropAnalyse.Properties[Listbox1.ItemIndex] do
    AsString := edNew.text;
end;

end.
