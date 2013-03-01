unit FontStyleDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, FontStyles, StdCtrls, Buttons, ExtCtrls;

type
  TdlgFontStyles = class(TForm)
    ListBox1: TListBox;
    FontDialog1: TFontDialog;
    edStyleName: TEdit;
    Label2: TLabel;
    Label1: TLabel;
    pnFont: TPanel;
    btnAdd: TSpeedButton;
    btnDelete: TSpeedButton;
    btnModify: TSpeedButton;
    ChangeName: TSpeedButton;
    btnClose: TSpeedButton;
    FontStyles: TFontStyles;
    btnDefault: TSpeedButton;
    Label3: TLabel;
    lbDefault: TLabel;
    procedure FontStylesSelectFont(Sender: TObject; index: Integer;
      SelectFont: TFont);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
    procedure ChangeNameClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnDefaultClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function 	CheckListBoxIndex:boolean;
  public
    { Public declarations }
    procedure Execute;
  end;

var
  dlgFontStyles: TdlgFontStyles;

implementation

{$R *.DFM}

procedure TdlgFontStyles.FontStylesSelectFont(Sender: TObject; index: Integer;
  SelectFont: TFont);
begin
  if SelectFont<>nil then
  begin
    pnFont.font := SelectFont;
    edStyleName.text := FontStyles.Styles[index].StyleName;
  end
  else edStyleName.text := '';
end;

procedure TdlgFontStyles.btnAddClick(Sender: TObject);
begin
  if FontDialog1.execute then
    FontStyles.Styles.AddFont(FontDialog1.Font);
end;

procedure TdlgFontStyles.btnDeleteClick(Sender: TObject);
begin
  if CheckListBoxIndex then
  FontStyles.Styles.delete(ListBox1.ItemIndex);
end;

procedure TdlgFontStyles.btnModifyClick(Sender: TObject);
begin
  if CheckListBoxIndex then
  begin
    FontDialog1.font :=
    	FontStyles.Styles[ListBox1.ItemIndex].font;
    if FontDialog1.execute then
      FontStyles.Styles[ListBox1.ItemIndex].font
	      := FontDialog1.font;
  end;
end;

procedure TdlgFontStyles.ChangeNameClick(Sender: TObject);
begin
  if CheckListBoxIndex then
  FontStyles.Styles[ListBox1.ItemIndex].StyleName
    := edStyleName.text;
end;

function TdlgFontStyles.CheckListBoxIndex: boolean;
begin
  result := (ListBox1.ItemIndex>=0) and
    (ListBox1.ItemIndex<FontStyles.Styles.count);
end;

procedure TdlgFontStyles.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TdlgFontStyles.Execute;
begin
  showmodal;
end;

procedure TdlgFontStyles.btnDefaultClick(Sender: TObject);
begin
  if CheckListBoxIndex then
  begin
    FontStyles.DefaultStyle :=
    	ListBox1.items[ListBox1.itemIndex];
    lbDefault.caption := FontStyles.DefaultStyle;
  end;
end;

procedure TdlgFontStyles.FormCreate(Sender: TObject);
begin
  lbDefault.caption := FontStyles.DefaultStyle;
end;

end.
