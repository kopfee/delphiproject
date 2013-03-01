unit UBookMan;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons,iniFiles;

type
  TdlgBookMan = class(TForm)
    lbBooks: TListBox;
    BitBtn1: TBitBtn;
    btnDelete: TBitBtn;
    btnRename: TBitBtn;
    procedure btnDeleteClick(Sender: TObject);
    procedure btnRenameClick(Sender: TObject);
  private
    { Private declarations }
    FBooks : TStrings;
    FIniFile : TIniFile;
  public
    { Public declarations }
    procedure execute(Books : TStrings; IniFile:TIniFile);
  end;

var
  dlgBookMan: TdlgBookMan;

implementation

{$R *.DFM}

{ TdlgBookMan }

procedure TdlgBookMan.execute(Books: TStrings; IniFile:TIniFile);
begin
  assert(Books<>nil);
  assert(IniFile<>nil);
  lbBooks.Items.Assign(Books);
  FBooks := Books;
  FIniFile := IniFile;
  ShowModal;
end;

procedure TdlgBookMan.btnDeleteClick(Sender: TObject);
var
  SectionName : string;
begin
  if lbBooks.ItemIndex>=0 then
  begin
    SectionName := FBooks[lbBooks.ItemIndex];
    FBooks.Delete(lbBooks.ItemIndex);
    lbBooks.Items.Delete(lbBooks.ItemIndex);
    FIniFile.EraseSection(SectionName);
  end;
end;

procedure TdlgBookMan.btnRenameClick(Sender: TObject);
begin
  //
end;

end.
