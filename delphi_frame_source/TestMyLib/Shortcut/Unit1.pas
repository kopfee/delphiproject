unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ShortcutEx, StdCtrls;

type
  TForm1 = class(TForm)
    ShortcutHandler1: TShortcutHandler;
    Label1: TLabel;
    ListBox1: TListBox;
    procedure HandleShortcuts(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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

uses Menus;

procedure TForm1.HandleShortcuts(Sender: TObject);
begin
  label1.caption :=  ShortCutToText((Sender As TShortcutItem).Shortcut);
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ShortcutHandler1.KeyDown(sender,Key,Shift);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i : integer;
begin
  for i:=0 to ShortcutHandler1.Shortcuts.count-1 do
  begin
    ListBox1.Items.Add(ShortCutToText(TShortcutItem(ShortcutHandler1.Shortcuts.Items[i]).Shortcut));
  end;
end;

end.
