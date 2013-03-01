unit UMain2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,ShellUtils, ExtDlgs;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Label1: TLabel;
    edStoreFile: TEdit;
    BrowseStore: TButton;
    Label2: TLabel;
    edLinkFile: TEdit;
    btnBrowseLink: TButton;
    btnCreateLink: TButton;
    btnLoadLink: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    procedure BrowseStoreClick(Sender: TObject);
    procedure btnBrowseLinkClick(Sender: TObject);
    procedure btnCreateLinkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnLoadLinkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ShellLink : TShellLink;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


procedure TForm1.BrowseStoreClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
    edStoreFile.Text := SaveDialog1.FileName;
end;

procedure TForm1.btnBrowseLinkClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    edLinkFile.Text := OpenDialog1.FileName;
end;

procedure TForm1.btnCreateLinkClick(Sender: TObject);
begin
  ShellLink.LinkFile:=edLinkFile.Text;
  ShellLink.SaveToFile(edStoreFile.text);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ShellLink := TShellLink.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ShellLink.free;
end;

procedure TForm1.btnLoadLinkClick(Sender: TObject);
begin
  ShellLink.LoadFromFile(edStoreFile.text);
  edLinkFile.Text := ShellLink.LinkFile;
end;

end.
