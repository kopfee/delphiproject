unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, FontStyles, StdCtrls;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    FontStyles1: TFontStyles;
    MainMenu1: TMainMenu;
    PopupMenu1: TPopupMenu;
    imStyle: TMenuItem;
    Exit1: TMenuItem;
    Button1: TButton;
    Label1: TLabel;
    lbFont: TLabel;
    btnAdd: TButton;
    btnDelete: TButton;
    FontDialog1: TFontDialog;
    btnModify: TButton;
    edStyleName: TEdit;
    Label2: TLabel;
    ChangeName: TButton;
    procedure Exit1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure imStyleClick(Sender: TObject);
    procedure FontStyles1SelectFont(Sender: TObject; index: Integer;
      SelectFont: TFont);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
    procedure ChangeNameClick(Sender: TObject);
  private
    { Private declarations }
    function 	CheckListBoxIndex:boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Exit1Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  p : TPoint;
begin
  P := Button1.ClientToScreen(Point(0,Button1.height));
  PopupMenu1.Popup(p.x,p.y);
end;

procedure TForm1.imStyleClick(Sender: TObject);
begin
  if MainMenu1.ownerDraw then
  	label1.caption := 'true'
  else
    label1.caption := 'false'
end;

procedure TForm1.FontStyles1SelectFont(Sender: TObject; index: Integer;
  SelectFont: TFont);
begin
  if SelectFont<>nil then
  begin
    lbFont.font := SelectFont;
    edStyleName.text := FontStyles1.Styles[index].StyleName;
  end
  else edStyleName.text := '';
end;

procedure TForm1.btnAddClick(Sender: TObject);
begin
  if FontDialog1.execute then
    FontStyles1.Styles.AddFont(FontDialog1.Font);
end;

procedure TForm1.btnDeleteClick(Sender: TObject);
begin
  if CheckListBoxIndex then
  FontStyles1.Styles.delete(ListBox1.ItemIndex);
end;

procedure TForm1.btnModifyClick(Sender: TObject);
begin
  if CheckListBoxIndex then
  begin
    FontDialog1.font :=
    	FontStyles1.Styles[ListBox1.ItemIndex].font;
    if FontDialog1.execute then
      FontStyles1.Styles[ListBox1.ItemIndex].font
	      := FontDialog1.font;
  end;
end;

procedure TForm1.ChangeNameClick(Sender: TObject);
begin
  if CheckListBoxIndex then
  FontStyles1.Styles[ListBox1.ItemIndex].StyleName
    := edStyleName.text;
end;

function TForm1.CheckListBoxIndex: boolean;
begin
  result := (ListBox1.ItemIndex>=0) and
    (ListBox1.ItemIndex<FontStyles1.Styles.count);
end;

end.
