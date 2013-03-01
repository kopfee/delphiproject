unit UFileCopy;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ShellUtils, StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    edFrom: TEdit;
    Label2: TLabel;
    edTo: TEdit;
    btnBrowse: TButton;
    btnCopy: TButton;
    OpenDialog1: TOpenDialog;
    FileOperation1: TFileOperation;
    procedure btnBrowseClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnBrowseClick(Sender: TObject);
begin
  if OpenDialog1.execute then
    edFrom.text := OpenDialog1.filename;
end;

procedure TForm1.btnCopyClick(Sender: TObject);
begin
  if FileOperation1.SimpleFileOpt(fotCopy,
    edFrom.text,
    edTo.text) then
   MessageDlg('OK',mtInformation,[mbOK],0)
 else
   MessageDlg('Error',mtInformation,[mbOK],0);
end;

end.
 