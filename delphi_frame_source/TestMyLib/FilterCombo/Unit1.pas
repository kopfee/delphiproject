unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, KSChineseSpell, FilterCombos;

type
  TForm1 = class(TForm)
    lsData: TListBox;
    KSFilterComboBox1: TKSFilterComboBox;
    procedure FormCreate(Sender: TObject);
    procedure KSFilterComboBox1FilterItems(Sender: TObject);
    procedure KSFilterComboBox1GetSelectedText(
      Sender: TKSCustomFilterComboBox; var AText: String);
    procedure KSFilterComboBox1Selected(Sender: TObject);
  private
    { Private declarations }
    FSpells : TStringList;
    FDisplayItems : TStringList;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var
  I : Integer;
  S : string;
begin
  FSpells := TStringList.Create;
  FDisplayItems := TStringList.Create;
  for I:=0 to lsData.Items.Count-1 do
  begin
    S := Uppercase(GetChineseFirstSpell(lsData.Items[I]));
    FSpells.AddObject(S,Pointer(I));
    S := S + StringOfChar(' ',10);
    S := Copy(S,1,10);
    FDisplayItems.AddObject(Format('%s %s',[lsData.Items[I],S]),Pointer(I));
  end;
end;

procedure TForm1.KSFilterComboBox1FilterItems(Sender: TObject);
var
  FilterComboBox : TKSFilterComboBox;
  I : Integer;
  S : string;
begin
  if FSpells=nil then
    Exit;
    
  FilterComboBox := TKSFilterComboBox(Sender);
  if FilterComboBox.Text='' then
  begin
    FilterComboBox.Items := FDisplayItems;
    FilterComboBox.ItemIndex := 0;
  end else
  begin
    S := Uppercase(FilterComboBox.Text);
    FilterComboBox.Items.BeginUpdate;
    FilterComboBox.Items.Clear;
    for I:=0 to FSpells.Count-1 do
    begin
      if Pos(S,FSpells[I])>0 then
        FilterComboBox.Items.AddObject(FDisplayItems[I],Pointer(I));
    end;
    FilterComboBox.Items.EndUpdate;
    FilterComboBox.ItemIndex := 0;
  end;
end;

procedure TForm1.KSFilterComboBox1GetSelectedText(
  Sender: TKSCustomFilterComboBox; var AText: String);
begin
  AText := '';
end;

procedure TForm1.KSFilterComboBox1Selected(Sender: TObject);
begin
  with TKSCustomFilterComboBox(Sender) do
    if ItemIndex>=0 then
      lsData.ItemIndex := Integer(Items.Objects[ItemIndex]);
end;

end.
