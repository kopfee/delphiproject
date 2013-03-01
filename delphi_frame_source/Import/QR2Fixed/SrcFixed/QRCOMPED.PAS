{ :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: QuickReport 2.0 for Delphi 1.0/2.0/3.0                  ::
  ::                                                         ::
  :: QRCOMPED - QuickReport component editor                 ::
  ::                                                         ::
  :: Copyright (c) 1997 QuSoft AS                            ::
  :: All Rights Reserved                                     ::
  ::                                                         ::
  :: web: http://www.qusoft.no  mail: support@qusoft.no      ::
  ::                            fax: +47 22 41 74 91         ::
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: }

unit Qrcomped;

interface

uses
{$ifdef win32}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, printers, dsgnintf, qrprntr, quickrpt, qrabout, qralias,
  ExtCtrls, db, dbtables, Buttons;
{$else}
  Wintypes, Winprocs, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, printers, dsgnintf, qrprntr, quickrpt, qrabout, qralias,
  ExtCtrls, db, dbtables, Buttons;
{$endif}
type
  TQRCompEd = class(TForm)
    About: TButton;
    Preview: TButton;
    Apply1: TButton;
    OK1: TButton;
    Cancel1: TButton;
    PaperSizeGB: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    PaperSize: TComboBox;
    PageWidth: TEdit;
    PageLength: TEdit;
    OrientationCB: TComboBox;
    MarginsGB: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Topmargin: TEdit;
    BottomMargin: TEdit;
    LeftMargin: TEdit;
    RightMargin: TEdit;
    ColumnMargin: TEdit;
    OtherGB: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Units: TComboBox;
    FontName: TComboBox;
    FontSize: TComboBox;
    Label8: TLabel;
    Columns: TEdit;
    PageFrameGB: TGroupBox;
    Label12: TLabel;
    FrameColor: TShape;
    Label13: TLabel;
    PageFrameTop: TCheckBox;
    PageFrameBottom: TCheckBox;
    PageFrameLeft: TCheckBox;
    PageFrameRight: TCheckBox;
    ColorButton: TButton;
    PageFramePenWidth: TEdit;
    BandsGB: TGroupBox;
    Label14: TLabel;
    Label15: TLabel;
    Title: TCheckBox;
    PageHeader: TCheckBox;
    ColumnHeader: TCheckBox;
    Detail: TCheckBox;
    PageHeaderLength: TEdit;
    TitleLength: TEdit;
    ColumnHeaderLength: TEdit;
    DetailLength: TEdit;
    SummaryLength: TEdit;
    PageFooter: TCheckBox;
    Summary: TCheckBox;
    PageFooterLength: TEdit;
    FirstPageHeader: TCheckBox;
    LastPageFooter: TCheckBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure Cancel1Click(Sender: TObject);
    procedure OK1Click(Sender: TObject);
    procedure Apply1Click(Sender: TObject);
    procedure FloatKeyPress(Sender: TObject; var Key: Char);
    procedure PageWidthExit(Sender: TObject);
    procedure AboutClick(Sender: TObject);
    procedure PreviewClick(Sender: TObject);
    procedure ColorButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    FQuickRep : TQuickRep;
    FAvailableDataSets : TStrings;
    procedure GetValues;
    procedure SetValues;
    procedure SetQuickRep(Value : TQuickRep);
    procedure SetAvailableDataSets(Value : TStrings);
    procedure ChangeValue(Edit : TEdit; Value, MinValue : integer);
  public
    property QuickRep : TQuickRep read FQuickRep write SetQuickRep;
    property AvailableDataSets : TStrings read FAvailableDataSets write SetAvailableDataSets;
  end;

implementation

uses qrextra;
{$R *.DFM}

const
  FST = '##0.00';

procedure TQRCompEd.GetValues;
begin
  PaperSize.ItemIndex := PaperSize.Items.IndexOf(QRPaperName(QuickRep.Page.PaperSize));
  PageWidth.Text := FormatFloat(FST,QuickRep.Page.Width);
  PageLength.Text := FormatFloat(FST,QuickRep.Page.Length);
  if QuickRep.Page.Orientation = poPortrait then
    OrientationCB.ItemIndex := 0
  else
    OrientationCB.ItemIndex := 1;
  TopMargin.Text := FormatFloat(FST,QuickRep.Page.TopMargin);
  BottomMargin.Text := FormatFloat(FST,QuickRep.Page.BottomMargin);
  LeftMargin.Text := FormatFloat(FST,QuickRep.Page.LeftMargin);
  RightMargin.Text := FormatFloat(FST,QuickRep.Page.RightMargin);
  ColumnMargin.Text := FormatFloat(FST,QuickRep.Page.ColumnSpace);
  Columns.Text := IntToStr(QuickRep.Page.Columns);
  FontName.ItemIndex := FontName.Items.IndexOf(QuickRep.Font.Name);
  PopulateFontSizeCombo(FontSize);
  FontSize.Text := IntToStr(QuickRep.Font.Size);
  { Page 2 }
  PageFrameTop.Checked := QuickRep.Frame.DrawTop;
  PageFrameBottom.Checked := QuickRep.Frame.DrawBottom;
  PageFrameLeft.Checked := QuickRep.Frame.DrawLeft;
  PageFrameRight.Checked := QuickRep.Frame.DrawRight;
  FrameColor.Brush.Color := QuickRep.Frame.Color;
  Units.ItemIndex := ord(QuickRep.Units);

  PageHeader.Checked := QuickRep.Bands.HasPageHeader;
  Title.Checked := QuickRep.Bands.HasTitle;
  ColumnHeader.Checked := QuickRep.Bands.HasColumnHeader;
  Detail.Checked := QuickRep.Bands.HasDetail;
  Summary.Checked := QuickRep.Bands.HasSummary;
  PageFooter.Checked := QuickRep.Bands.HasPageFooter;
  PageFramePenWidth.Text := IntToStr(QuickRep.Frame.Width);
  if QuickRep.Bands.HasPageHeader then
    PageHeaderLength.Text := FormatFloat(FST, QuickRep.Bands.PageHeaderBand.Size.Length);
  if QuickRep.Bands.HasTitle then
    TitleLength.Text := FormatFloat(FST, QuickRep.Bands.TitleBand.Size.Length);
  if QuickRep.Bands.HasColumnHeader then
    ColumnHeaderLength.Text := FormatFloat(FST, QuickRep.Bands.ColumnHeaderBand.Size.Length);
  if QuickRep.Bands.HasDetail then
    DetailLength.Text := FormatFloat(FST, QuickRep.Bands.DetailBand.Size.Length);
  if QuickRep.Bands.HasSummary then
    SummaryLength.Text := FormatFloat(FST, QuickRep.Bands.SummaryBand.Size.Length);
  if QuickRep.Bands.HasPageFooter then
    PageFooterLength.Text := FormatFloat(FST, QuickRep.Bands.PageFooterBand.Size.Length);
  FirstPageHeader.Checked := (Quickrpt.FirstPageHeader in QuickRep.Options);
  LastPageFooter.Checked := (Quickrpt.LastPageFooter in QuickRep.Options);
end;

procedure TQRCompEd.SetValues;
var
  I : TQRPaperSize;
begin
  for I:=Default to Custom do
    if QRPaperName(I)=PaperSize.Text then
    begin
      QuickRep.Page.PaperSize:=I;
      break;
    end;
  if QuickRep.Page.PaperSize=Custom then
  begin
    QuickRep.Page.Width:=StrToFloat(PageWidth.Text);
    QuickRep.Page.Length:=StrToFloat(PageLength.Text);
  end;
  if OrientationCB.ItemIndex = 0 then
    QuickRep.Page.Orientation := poPortrait
  else
    QuickRep.Page.Orientation := poLandScape;
  QuickRep.Page.TopMargin := StrToFloat(TopMargin.Text);
  QuickRep.Page.BottomMargin := StrToFloat(BottomMargin.Text);
  QuickRep.Page.LeftMargin := StrToFloat(LeftMargin.Text);
  QuickRep.Page.RightMargin := StrToFloat(RightMargin.Text);
  QuickRep.Page.ColumnSpace := StrToFloat(ColumnMargin.Text);
  QuickRep.Page.Columns := StrToInt(Columns.Text);
  QuickRep.Font.Name := FontName.Text;
  QuickRep.Font.Size := StrToInt(FontSize.Text);
  { Page 2 }
  QuickRep.Frame.DrawLeft := PageFrameLeft.Checked;
  QuickRep.Frame.DrawRight := PageFrameRight.Checked;
  QuickRep.Frame.DrawTop := PageFrameTop.Checked;
  QuickRep.Frame.DrawBottom := PageFrameBottom.Checked;
  QuickRep.Frame.Color := FrameColor.Brush.Color;
  QuickRep.Frame.Width := StrToInt(PageFramePenWidth.Text);
  QuickRep.Bands.HasPageHeader := PageHeader.Checked;
  if PageHeader.Checked and (PageHeaderLength.Text <> '') then
    QuickRep.Bands.PageHeaderBand.Size.Length := StrToFloat(PageHeaderLength.Text);
  QuickRep.Bands.HasTitle := Title.Checked;
  if Title.Checked and (TitleLength.Text <> '') then
    QuickRep.Bands.TitleBand.Size.Length := StrToFloat(TitleLength.Text);
  QuickRep.Bands.HasColumnHeader := ColumnHeader.Checked;
  if ColumnHeader.Checked and (ColumnHeaderLength.Text <> '') then
    QuickRep.Bands.ColumnHeaderBand.Size.Length := StrToFloat(ColumnHeaderLength.Text);
  QuickRep.Bands.HasDetail := Detail.Checked;
  if Detail.Checked and (DetailLength.Text <> '') then
    QuickRep.Bands.DetailBand.Size.Length := StrToFloat(DetailLength.Text);
  QuickRep.Bands.HasSummary := Summary.Checked;
  if Summary.Checked and (SummaryLength.Text <> '') then
    QuickRep.Bands.SummaryBand.Size.Length := StrToFloat(SummaryLength.Text);
  QuickRep.Bands.HasPageFooter := PageFooter.Checked;
  if PageFooter.Checked and (PageFooterLength.Text <> '') then
    QuickRep.Bands.PageFooterBand.Size.Length := StrToFloat(PageFooterLength.Text);
  QuickRep.Units := TQRUnit(Units.ItemIndex);
  QuickRep.Options := [];
  if FirstPageHeader.Checked then QuickRep.Options := QuickRep.Options + [Quickrpt.FirstPageHeader];
  if LastPageFooter.Checked then QuickRep.Options := QuickRep.Options + [Quickrpt.LastPageFooter];
end;

procedure TQRCompEd.SetQuickRep(Value : TQuickRep);
begin
  FQuickRep := Value;
  if Value<>nil then GetValues;
end;

procedure TQRCompEd.FormCreate(Sender: TObject);
var
  PS : TQRPaperSize;
begin
  for PS:=Default to Custom do
    PaperSize.Items.Add(QRPaperName(PS));
  FAvailableDataSets:=TStringList.Create;
  PaperSize.Sorted:=true;
  FontName.Items:=GetFonts;
  FontName.Sorted:=true;
{  if not (csDesigning in QuickRep.ComponentState) then
    About.Visible := false;}
end;

procedure TQRCompEd.SetAvailableDataSets(Value : TStrings);
begin
  FAvailableDataSets.Free;
  FAvailableDataSets:=Value;
end;

procedure TQRCompEd.Cancel1Click(Sender: TObject);
begin
  Close;
end;

procedure TQRCompEd.OK1Click(Sender: TObject);
begin
  SetValues;
  Close;
end;

procedure TQRCompEd.Apply1Click(Sender: TObject);
begin
  SetValues;
  GetValues;
end;

procedure FloatEdKeyPress(Sender: TObject; var Key: Char);
begin
end;

procedure TQRCompEd.FloatKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
    PageWidthExit(Sender)
  else
    if not (Key in [#8, '0'..'9',DecimalSeparator]) then
      Key:=#0;
end;

procedure TQRCompEd.PageWidthExit(Sender: TObject);
begin
  if TEdit(Sender).Text <> '' then
    TEdit(Sender).Text:=FormatFloat(FST,StrToFloat(TEdit(Sender).Text));
end;

procedure TQRCompEd.AboutClick(Sender: TObject);
begin
  Hide;
  with TQRAboutBox.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
  Show;
end;

procedure TQRCompEd.PreviewClick(Sender: TObject);
begin
  QuickRep.Preview;
end;

procedure TQRCompEd.ColorButtonClick(Sender: TObject);
begin
  with TColorDialog.Create(Self) do
  try
    Color:=FrameColor.Brush.Color;
    if Execute then
      FrameColor.Brush.Color:=Color;
  finally
    Free;
  end;
end;

procedure TQRCompEd.FormDestroy(Sender: TObject);
begin
  FAvailableDataSets.Free;
end;

procedure TQRCompEd.SpeedButton1Click(Sender: TObject);
begin
  ChangeValue(Columns, 1, 1);
end;

procedure TQRCompEd.ChangeValue(Edit : TEdit; Value, MinValue : integer);
begin
  if (StrToInt(Edit.Text) + Value) >= MinValue then
    Edit.Text := IntToStr(StrToInt(Edit.Text) + Value);
end;

procedure TQRCompEd.SpeedButton2Click(Sender: TObject);
begin
  ChangeValue(Columns, -1, 1);
end;

procedure TQRCompEd.SpeedButton3Click(Sender: TObject);
begin
  ChangeValue(PageFramePenWidth, 1, 0);
end;

procedure TQRCompEd.SpeedButton4Click(Sender: TObject);
begin
  ChangeValue(PageFramePenWidth, -1, 0);
end;

end.
