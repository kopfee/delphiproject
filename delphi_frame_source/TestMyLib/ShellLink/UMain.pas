unit UMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

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
    Label3: TLabel;
    edDescription: TEdit;
    procedure BrowseStoreClick(Sender: TObject);
    procedure btnBrowseLinkClick(Sender: TObject);
    procedure btnCreateLinkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses ShellUtils;

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
  if CreateLink(edStoreFile.Text,edLinkFile.Text,edDescription.text) then
    ShowMessage('OK')
  else
    ShowMessage('Error');
end;

end.
