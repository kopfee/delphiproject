unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ExtCtrls, StdCtrls, Dialogs,  ExtDialogs;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    FolderDialog1: TFolderDialog;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  {FolderDialog1.Folder :=Edit1.Text;
  if FolderDialog1.Execute then
    Edit1.Text:=FolderDialog1.Folder;}
  FolderDialog1.Execute;  
end;

end.
