{ :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: QuickReport 2.0 Delphi 1.0/2.0/3.0                      ::
  ::                                                         ::
  :: QRPREV - QuickReport standard preview form              ::
  ::                                                         ::
  :: Copyright (c) 1997 QuSoft AS                            ::
  :: All Rights Reserved                                     ::
  ::                                                         ::
  :: web: http://www.qusoft.no   mail: support@qusoft.no     ::
  ::                             fax: +47 22 41 74 91        ::
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: }

unit QRPrev;

interface

uses
{$ifdef win32}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, QRPrntr, QR2const;
{$else}
  Wintypes, WinProcs, Sysutils, Messages, Classes, Controls, StdCtrls, ExtCtrls,
  Buttons, QRPrntr, Graphics, Forms, Dialogs, QR2const;
{$endif}

type
  TQRStandardPreview = class(TForm)
    Toolbar: TPanel;
    StatusPanel: TPanel;
    ZoomToFit: TSpeedButton;
    ZoomTo100: TSpeedButton;
    ZoomToWidth: TSpeedButton;
    FirstPage: TSpeedButton;
    PrevPage: TSpeedButton;
    NextPage: TSpeedButton;
    LastPage: TSpeedButton;
    PrintSetup: TSpeedButton;
    Print: TSpeedButton;
    Save: TSpeedButton;
    Load: TSpeedButton;
    Exit: TBitBtn;
    Panel1: TPanel;
    Status: TLabel;
    QRPreview: TQRPreview;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ZoomToFitClick(Sender: TObject);
    procedure ZoomTo100Click(Sender: TObject);
    procedure ZoomToWidthClick(Sender: TObject);
    procedure FirstPageClick(Sender: TObject);
    procedure PrevPageClick(Sender: TObject);
    procedure NextPageClick(Sender: TObject);
    procedure LastPageClick(Sender: TObject);
    procedure PrintClick(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SaveClick(Sender: TObject);
    procedure PrintSetupClick(Sender: TObject);
    procedure LoadClick(Sender: TObject);
    procedure QRPreviewPageAvailable(Sender: TObject; PageNum: Integer);
    procedure QRPreviewProgressUpdate(Sender: TObject; Progress: Integer);
    procedure FormCreate(Sender: TObject);
  private
    FQRPrinter : TQRPrinter;
    Gauge : TQRGauge;
  public
    constructor CreatePreview(AOwner : TComponent; aQRPrinter : TQRPrinter); virtual;
    procedure Show;
    procedure UpdateInfo;
    property QRPrinter : TQRPrinter read FQRPrinter write FQRPrinter;
  end;

implementation

{$R *.DFM}

constructor TQRStandardPreview.CreatePreview(AOwner : TComponent; aQRPrinter : TQRPrinter);
begin
  inherited Create(AOwner);
  QRPrinter := aQRPrinter;
  WindowState := wsMaximized;
  QRPreview.QRPrinter := aQRPrinter;
  if QRPrinter <> nil then Caption := QRPrinter.Title;
  Gauge := TQRGauge.Create(Self);
  Gauge.Parent := StatusPanel;
  Gauge.Top := 2;
  Gauge.Left := 2;
  Gauge.Height := StatusPanel.Height - 3;
  Gauge.Width := 100;

  { Load bitmaps for buttons }
  ZoomToFit.Glyph.Handle := LoadBitmap(hinstance, 'QRZOOMTOFITBITMAP');
  ZoomTo100.Glyph.Handle := LoadBitmap(hinstance, 'QRZOOMTO100BITMAP');
  ZoomToWidth.Glyph.Handle := LoadBitmap(hinstance, 'QRZOOMTOWIDTHBITMAP');
  FirstPage.Glyph.Handle := LoadBitmap(hinstance, 'QRFIRSTPAGEBITMAP');
  PrevPage.Glyph.Handle := LoadBitmap(hinstance, 'QRPREVPAGEBITMAP');
  NextPage.Glyph.Handle := LoadBitmap(hinstance, 'QRNEXTPAGEBITMAP');
  LastPage.Glyph.Handle := LoadBitmap(hinstance, 'QRLASTPAGEBITMAP');
  PrintSetup.Glyph.Handle := LoadBitmap(hinstance, 'QRPRINTSETUPBITMAP');
  Print.Glyph.Handle := LoadBitmap(hinstance, 'QRPRINTBITMAP');
  Save.Glyph.Handle := LoadBitmap(hinstance, 'QRSAVEBITMAP');
  Load.Glyph.Handle := LoadBitmap(hinstance, 'QROPENBITMAP');
  ZoomToWidth.Down := true;
end;

procedure TQRStandardPreview.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
{  QRPreview.QRPrinter.ShowingPreview:=false;
  QRPreview.QRPrinter.Free;}
  Action := caFree;
end;

procedure TQRStandardPreview.UpdateInfo;
begin
  Status.Caption := LoadStr(SqrPage) + ' ' + IntToStr(QRPreview.PageNumber) + ' ' +
    LoadStr(SqrOf) + ' ' + IntToStr(QRPreview.QRPrinter.PageCount);
end;

procedure TQRStandardPreview.ZoomToFitClick(Sender: TObject);
begin
  Application.ProcessMessages;
  QRPreview.ZoomToFit;
end;

procedure TQRStandardPreview.ZoomTo100Click(Sender: TObject);
begin
  Application.ProcessMessages;
  QRPreview.Zoom := 100;
end;

procedure TQRStandardPreview.ZoomToWidthClick(Sender: TObject);
begin
  Application.ProcessMessages;
  QRPreview.ZoomToWidth;
end;

procedure TQRStandardPreview.FirstPageClick(Sender: TObject);
begin
  QRPreview.PageNumber := 1;
  UpdateInfo;
end;

procedure TQRStandardPreview.PrevPageClick(Sender: TObject);
begin
  QRPreview.PageNumber := QRPreview.PageNumber - 1;
  UpdateInfo;
end;

procedure TQRStandardPreview.NextPageClick(Sender: TObject);
begin
  QRPreview.PageNumber := QRPreview.PageNumber + 1;
  UpdateInfo;
end;

procedure TQRStandardPreview.LastPageClick(Sender: TObject);
begin
  QRPreview.PageNumber := QRPrinter.PageCount;
  UpdateInfo;
end;

procedure TQRStandardPreview.PrintClick(Sender: TObject);
begin
  QRPrinter.Print;
end;

procedure TQRStandardPreview.ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TQRStandardPreview.FormResize(Sender: TObject);
begin
  QRPreview.UpdateZoom;
end;

procedure TQRStandardPreview.Show;
begin
{  QRPreview.QRPrinter.ShowingPreview:=true;}
  inherited Show;
end;

procedure TQRStandardPreview.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_Next : if Shift=[ssCtrl] then
                LastPageClick(Self)
              else
                NextPageClick(Self);
    VK_Prior : if Shift=[ssCtrl] then
                 FirstPageClick(Self)
               else
                 PrevPageClick(Self);
    VK_Home : FirstPageClick(Self);
    VK_End : LastPageClick(Self);
  end;
end;

procedure TQRStandardPreview.SaveClick(Sender: TObject);
var
  aExportFilter : TQRExportFilter;
{$ifndef win32}
  FileExt : string;
  I : integer;
{$endif}
begin
  aExportFilter := nil;
  with TSaveDialog.Create(Application) do
  try
    Filter := QRExportFilterLibrary.SaveDialogFilterString;
{    DefaultExt := cQRPDefaultExt;}
    if Execute then
    begin
    {$ifdef win32}
      if FilterIndex = 1 then
        QRPrinter.Save(Filename)
      else
      begin
        try
          aExportFilter := TQRExportFilterLibraryEntry(
            QRExportFilterLibrary.Filters[FilterIndex - 2]).ExportFilterClass.Create(Filename);
          QRPrinter.ExportToFilter(aExportFilter);
        finally
          aExportFilter.Free
        end
      end
    {$else}
      FileExt := ExtractFileExt(Filename);
      if copy(FileExt, 1, 1) = '.' then delete(FileExt, 1, 1);
      if (FileExt = '') or (FileExt = cQRPDefaultExt) then
        QRPrinter.Save(Filename)
      else
      begin
        for I := 0 to QRExportFilterLibrary.Filters.Count - 1 do
        begin
          if TQRExportFilterLibraryEntry(QRExportFilterLibrary.Filters[I]).Extension = FileExt then
          try
            aExportFilter := TQRExportFilterLibraryEntry(
            QRExportFilterLibrary.Filters[I]).ExportFilterClass.Create(Filename);
            QRPrinter.ExportToFilter(aExportFilter);
          finally
            aExportFilter.Free;
          end;
        end;
      end;
    {$endif}
    end;
  finally
    Free;
  end;
end;

procedure TQRStandardPreview.PrintSetupClick(Sender: TObject);
begin
  QRPrinter.PrintSetup;
end;

procedure TQRStandardPreview.LoadClick(Sender: TObject);
begin
  with TOpenDialog.Create(Application) do
  try
    Filter := LoadStr(SqrQRFile) + '(*.' +cQRPDefaultExt + ')|*.' + cqrDefaultExt;
    if Execute then
      if FileExists(FileName) then
      begin
        QRPrinter.Load(Filename);
        QRPreview.PageNumber := 1;
        QRPreview.PreviewImage.PageNumber := 1;
        UpdateInfo;
      end
      else
        ShowMessage(LoadStr(SqrFileNotExist));
  finally
    free;
  end;
end;

procedure TQRStandardPreview.QRPreviewPageAvailable(Sender: TObject;
  PageNum: Integer);
begin
  UpdateInfo;
end;

procedure TQRStandardPreview.QRPreviewProgressUpdate(Sender: TObject;
  Progress: Integer);
begin
  Gauge.Position := Progress;
  Gauge.Visible := (Gauge.Position > 0) and (Gauge.Position < 100);
end;

procedure TQRStandardPreview.FormCreate(Sender: TObject);
begin
{$ifdef win32}
   HorzScrollbar.Tracking := true;
   VertScrollbar.Tracking := true;
{$endif}
end;

end.
