unit UBatchMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtDialogs, StdCtrls;

type
  TfmBatchMain = class(TForm)
    btnStart: TButton;
    OpenDialog: TOpenDialogEx;
    ckShowForm: TCheckBox;
    procedure btnStartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmBatchMain: TfmBatchMain;

implementation

uses ProgDlg2, UFormParser;

{$R *.DFM}

procedure TfmBatchMain.btnStartClick(Sender: TObject);
var
  i : integer;
  fn : string;
  fs : TFileStream;
begin
  if OpenDialog.Execute then
  begin
    for i:=0 to OpenDialog.files.Count-1 do
    begin
      fn := OpenDialog.files[i];
      dlgProgress.Caption:='Convert '+ExtractFileName(fn);
      fs := TFileStream.create(fn,fmOpenRead);
      try
        dmFormParser.Execute(fs,nil);
        dmFormParser.generateForm(ChangeFileExt(fn,'.pas'),true,ckShowForm.Checked);
      finally
        fs.free;
      end;
    end;
  end;
end;

end.
