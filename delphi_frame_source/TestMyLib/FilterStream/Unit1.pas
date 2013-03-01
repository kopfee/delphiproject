unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

const
  Key = 'Just A Test';

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    mmText: TMemo;
    btnLoadTextFile: TButton;
    btnSaveToBinFile: TButton;
    btnLoadBinFile: TButton;
    OpenDialog1: TOpenDialog;
    OpenDialog2: TOpenDialog;
    SaveDialog2: TSaveDialog;
    btnClear: TButton;
    procedure btnLoadTextFileClick(Sender: TObject);
    procedure btnSaveToBinFileClick(Sender: TObject);
    procedure btnLoadBinFileClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses FilterStreams;

{$R *.DFM}

procedure TForm1.btnLoadTextFileClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    mmText.Lines.LoadFromFile(OpenDialog1.FileName);
end;

procedure TForm1.btnSaveToBinFileClick(Sender: TObject);
var
  FilterStream  : TFilterStream;
  FileStream    : TFileStream;
  Filter : TXorFilter;
begin
  if SaveDialog2.Execute then
  begin
    FilterStream  := nil;
    FileStream    := nil;
    try
      Filter := TXorFilter.Create(Key);

      FileStream    := TFileStream.Create(SaveDialog2.FileName,fmCreate);
      FilterStream  := TFilterStream.Create(FileStream, Filter);

      mmText.Lines.SaveToStream(FilterStream);
    finally
      FilterStream.Free;
      FileStream.Free;
    end;
  end;

end;

procedure TForm1.btnLoadBinFileClick(Sender: TObject);
var
  FilterStream  : TFilterStream;
  FileStream    : TFileStream;
  Filter : TXorFilter;
begin
  if OpenDialog2.Execute then
  begin
    FilterStream  := nil;
    FileStream    := nil;
    try
      Filter := TXorFilter.Create(Key);

      FileStream    := TFileStream.Create(OpenDialog2.FileName,fmOpenRead);
      FilterStream  := TFilterStream.Create(FileStream, Filter);

      mmText.Lines.LoadFromStream(FilterStream);
    finally
      FilterStream.Free;
      FileStream.Free;
    end;
  end;
end;

procedure TForm1.btnClearClick(Sender: TObject);
begin
  mmText.Lines.Clear;
end;

end.
