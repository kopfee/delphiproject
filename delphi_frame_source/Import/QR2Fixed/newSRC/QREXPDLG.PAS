{ :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: QuickReport 2.0 for Delphi 1.0/2.0/3.0                  ::
  ::                                                         ::
  :: QREXPDLG.PAS -  Expert dialog                           ::
  ::                                                         ::
  :: Copyright (c) 1996 QuSoft AS                            ::
  :: All Rights Reserved                                     ::
  ::                                                         ::
  :: web: http://www.qusoft.no    mail: support@qusoft.no    ::
  ::                              fax: +47 22 41 74 91       ::
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: }

unit qrexpdlg;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, Buttons, ToolIntf, ComCtrls,
  DB, FileCtrl, qr2const, qrprntr, quickrpt, qrextra, ExptIntf, DBTables;

type
  TQRExpert = class(TForm)
    CancelBtn: TButton;
    Next: TButton;
    Pages: TNotebook;
    GroupBox1: TGroupBox;
    ListStyle: TRadioButton;
    FormStyle: TRadioButton;
    MasterDetailStyle: TRadioButton;
    LabelsStyle: TRadioButton;
    CrosstabStyle: TRadioButton;
    Style: TNotebook;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Previous: TButton;
    GroupBox2: TGroupBox;
    AliasName: TComboBox;
    GroupBox3: TGroupBox;
    SelectDir: TButton;
    Label6: TLabel;
    TableName: TComboBox;
    GroupBox4: TGroupBox;
    AvailableFields: TListBox;
    AddOne: TButton;
    AddAll: TButton;
    RemoveOne: TButton;
    RemoveAll: TButton;
    SelectedFields: TListBox;
    Label7: TLabel;
    Label8: TLabel;
    ATable: TTable;
    GroupBox6: TGroupBox;
    ReportTitle: TEdit;
    GroupBox7: TGroupBox;
    BaseFont: TComboBox;
    Preview: TButton;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    procedure SelectDirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AliasCBClick(Sender: TObject);
    procedure NextClick(Sender: TObject);
    procedure PreviousClick(Sender: TObject);
    procedure AliasNameChange(Sender: TObject);
    procedure TableNameChange(Sender: TObject);
    procedure AvailableFieldsClick(Sender: TObject);
    procedure SelectedFieldsClick(Sender: TObject);
    procedure AvailableFieldsDblClick(Sender: TObject);
    procedure SelectedFieldsDblClick(Sender: TObject);
    procedure AddAllClick(Sender: TObject);
    procedure RemoveAllClick(Sender: TObject);
    procedure AddOneClick(Sender: TObject);
    procedure RemoveOneClick(Sender: TObject);
    procedure PreviewClick(Sender: TObject);
    procedure TableNameEnter(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    SourceBuffer: PChar;
    VarList : TStrings;
    Hiddenform : TForm;
    procedure FmtWrite(Stream: TStream; Fmt: PChar; const Args: array of const);
    function DoFormCreation(const FormIdent: string): TForm;
    function CreateSource(const UnitIdent, FormIdent: string): TMemoryStream;
    function CreateForm(const FormIdent: string): TMemoryStream;
    function TablePath : string;
    procedure DoReportCreation(AForm : TForm);
    procedure MoveList(Source, Dest : TListBox);
    procedure MoveListAll(Source, Dest : TListBox);
    procedure FixButtons;
    procedure PickFields;
  public
    destructor Destroy; override;
  end;

{$ifdef ver100}
type
  TQuickReportExpert = class(TIExpert)
    function GetName: string; override;
    function GetComment: string; override;
    function GetGlyph: HICON; override;
    function GetStyle: TExpertStyle; override;
    function GetState: TExpertState; override;
    function GetIDString: string; override;
    function GetAuthor: string; override;
    function GetPage: string; override;
    procedure Execute; override;
  end;
{$endif}

procedure QuickReportExpert(ToolServices: TIToolServices);

implementation

uses Proxies, VirtIntf, IStreams;

{$R *.DFM}

const
  SourceBufferSize = 1024;

  cReportStyle = 0;
  cTable = 1;
  cFields = 2;
  cReportOptions = 3;

{ TQRExpert }

procedure TQRExpert.FormCreate(Sender: TObject);
var
  aDir : string;
begin
  Session.GetDatabaseNames(AliasName.Items);
  GetDir(0, aDir);
  AliasName.Text := aDir;
  Pages.PageIndex := 1; { Temporarily }
  AliasNameChange(Self);
  BaseFont.Items := GetFonts;
  BaseFont.ItemIndex := BaseFont.Items.IndexOf('Arial');
  FixButtons;
  VarList := TStringList.Create;
  HiddenForm := TForm.Create(Application);
end;

destructor TQRExpert.Destroy;
begin
  VarList.Free;
  HiddenForm.Free;
  inherited Destroy;
end;

procedure TQRExpert.MoveList(Source, Dest : TListBox);
var
  I : integer;
begin
  with Source do
  begin
    for I := 0 to Items.Count - 1 do
      if Selected[I] then Dest.Items.AddObject(Items[I], Items.Objects[I]);
    I := 0;
    while I<Items.Count do
    begin
      if Selected[I] then
        Items.Delete(I)
      else
        inc(I);
    end
  end
end;

procedure TQRExpert.MoveListAll(Source, Dest : TListBox);
var
  I : integer;
begin
  for I:=0 to Source.Items.Count - 1 do
    Dest.Items.AddObject(Source.Items[I], Source.Items.Objects[I]);
  Source.Clear;
end;

procedure TQRExpert.DoReportCreation(AForm : TForm);
var
  Table1 : TTable;
  Report1 : TQuickRep;
begin
  if ListStyle.Checked then
  begin
    Table1 := TTable.Create(AForm);
    with Table1 do
    begin
      DataBaseName := TablePath;
      TableName := Self.TableName.Text;
      Active := true;
      Name := 'Table1';
    end;
    Report1 := nil;
    QRCreateList(Report1, AForm, Table1, ReportTitle.Text, SelectedFields.Items);
    Report1.Name := 'QuickRep1';
    Report1.Parent := AForm;
    Report1.Font.Name := BaseFont.Text;
  end;
end;

function TQRExpert.DoFormCreation(const FormIdent: string): TForm;
var
  I : integer;
begin
  Result := TForm.Create(nil);
  Proxies.CreateSubClass(Result, 'T' + FormIdent, TForm);
  with Result do
  begin
    Width := 400;
    Height := 250;
    Top := 200;
    Left := 200;
    Position := poScreenCenter;
    Name := FormIdent;
    Caption := FormIdent;
  end;
  DoReportCreation(Result);
  with Result do
    for I := 0 to ComponentCount - 1 do
      {if Components[I] is TTable then
        TTable(Components[I]).Active := false;}
       if Components[I] is TDataset then
        TDataset(Components[I]).Active := false;

end;

procedure TQRExpert.FmtWrite(Stream: TStream; Fmt: PChar; const Args: array of const);
begin
  if (Stream <> nil) and (SourceBuffer <> nil) then
  begin
    StrLFmt(SourceBuffer, SourceBufferSize, Fmt, Args);
    Stream.Write(SourceBuffer[0], StrLen(SourceBuffer));
  end;
end;

function TQRExpert.CreateSource(const UnitIdent, FormIdent: string): TMemoryStream;
const
  CRLF = #13#10;
var
  I: Integer;
  ALine : string;
begin
  SourceBuffer := StrAlloc(SourceBufferSize);
  try
    Result := TMemoryStream.Create;
    try
      FmtWrite(Result,
        'unit %s;' + CRLF + CRLF +
        'interface' + CRLF + CRLF +
        'uses'+CRLF +
        '  SysUtils, Windows, Messages, Classes, Graphics, Controls,'#13#10 +
        '  StdCtrls, ExtCtrls, Forms, Quickrpt, QRCtrls;'+CRLF+CRLF, [UnitIdent]);
      FmtWrite(Result,
        'type' + CRLF +
        '  T%s = class(TForm)' + CRLF, [FormIdent]);
      for I:=0 to VarList.Count - 1 do
      begin
        ALine:=VarList[I]+CRLF;
        FmtWrite(Result,PChar(ALine),[nil]);
      end;
      FmtWrite(Result,'  private'+CRLF,[nil]);
      FmtWrite(Result,
        '  end;' + CRLF + CRLF +
        'var' + CRLF +
        '  %s: T%s;' + CRLF + CRLF +
        'implementation' + CRLF + CRLF +
        '{$R *.DFM}' + CRLF + CRLF, [FormIdent, FormIdent]);
      FmtWrite(Result, 'end.' + CRLF, [nil]);
      Result.Position := 0;
    except
      Result.Free;
      raise;
    end;
  finally
    StrDispose(SourceBuffer);
  end;
end;

function TQRExpert.CreateForm(const FormIdent: string): TMemoryStream;
var
  QRForm: TForm;
  I : integer;
begin
  QRForm := DoFormCreation(FormIdent);
  try
    Result := TMemoryStream.Create;
    Result.WriteComponentRes(FormIdent, QRForm);
    Result.Position := 0;
    VarList.Clear;
    for I:=0 to QRForm.ComponentCount - 1 do
      VarList.Add('    '+QRForm.Components[I].Name+ ' : '+
                  QRForm.Components[I].ClassName+';');
  finally
    QRForm.Free;
  end;
end;

procedure TQRExpert.SelectDirClick(Sender: TObject);
var
  aDirectory : string;
begin
  ADirectory := AliasName.Text;
  if not DirectoryExists(ADirectory) then ADirectory := '';
  if SelectDirectory(ADirectory, [], 0) then
    AliasName.Text:=ADirectory;
  AliasNameChange(Self);
end;

procedure TQRExpert.AliasCBClick(Sender: TObject);
begin
  AliasName.Enabled:=true;
end;

function TQRExpert.TablePath : String;
begin
  Result := AliasName.Text
end;

procedure TQRExpert.NextClick(Sender: TObject);
begin
  case Pages.PageIndex of
    cReportStyle : Pages.PageIndex := cTable;
    CTable : begin
               Pages.PageIndex := cFields;
               PickFields;
             end;
    cFields : begin
                Pages.PageIndex := cReportOptions;
                Next.Caption := 'Finish';
              end;
    cReportOptions : ModalResult:=mrOK;
  end;
  FixButtons;
end;

procedure TQRExpert.PickFields;
var
  I : integer;
begin
  if (ATable.DatabaseName <> TablePath) or (ATable.TableName <> TableName.Text) then
  begin
    ATable.Close;
    ATable.DatabaseName := TablePath;
    ATable.TableName := TableName.Text;
    ATable.FieldDefs.Update;
    AvailableFields.Clear;
    SelectedFields.Clear;
    ATable.Open;
    for I := 0 to ATable.FieldCount - 1 do
      AvailableFields.Items.Add(ATable.Fields[I].FieldName);
  end
end;

procedure TQRExpert.PreviousClick(Sender: TObject);
begin
  case Pages.PageIndex of
    cTable : Pages.PageIndex:=cReportStyle;
    cFields: Pages.PageIndex:=cTable;
    cReportOptions : begin
                       Pages.PageIndex:=cFields;
                       Next.Caption:='Next';
                     end;
  end;
  FixButtons;
end;

procedure TQRExpert.FixButtons;
begin
  case Pages.PageIndex of
    cReportStyle : begin
                     Previous.Enabled:=false;
                     Next.Enabled:=true;
                   end;
    cTable : begin
               Previous.Enabled:=false;
               Next.Enabled:=TableName.Text<>'';
             end;
    cFields : begin
                Previous.Enabled:=true;
                Next.Enabled:=SelectedFields.Items.Count>0;
              end;
  end;
end;

procedure TQRExpert.AliasNameChange(Sender: TObject);
begin
  try
    Session.GetTableNames(AliasName.Text, '', True, False, TableName.Items);
  except
    AliasName.Text := '';
    TableName.Clear;
  end;
end;

procedure TQRExpert.TableNameChange(Sender: TObject);
begin
  FixButtons;
end;

procedure TQRExpert.AvailableFieldsClick(Sender: TObject);
begin
  AddOne.Enabled:=AvailableFields.SelCount>0;
  SelectedFields.ItemIndex:=-1;
end;

procedure TQRExpert.SelectedFieldsClick(Sender: TObject);
begin
  RemoveOne.Enabled:=SelectedFields.SelCount>0;
  AvailableFields.ItemIndex:=-1;
end;

procedure TQRExpert.AvailableFieldsDblClick(Sender: TObject);
begin
  SelectedFields.Items.Add(AvailableFields.Items[AvailableFields.ItemIndex]);
  AvailableFields.Items.Delete(AvailableFields.ItemIndex);
  FixButtons;
end;

procedure TQRExpert.SelectedFieldsDblClick(Sender: TObject);
begin
  AvailableFields.Items.Add(SelectedFields.items[SelectedFields.ItemIndex]);
  SelectedFields.Items.Delete(SelectedFields.ItemIndex);
  FixButtons;
end;

procedure TQRExpert.AddAllClick(Sender: TObject);
begin
  MoveListAll(AvailableFields, SelectedFields);
  FixButtons;
end;

procedure TQRExpert.RemoveAllClick(Sender: TObject);
begin
  MoveListAll(SelectedFields, AvailableFields);
  FixButtons;
end;

procedure TQRExpert.AddOneClick(Sender: TObject);
begin
  MoveList(AvailableFields, SelectedFields);
  FixButtons;
end;

procedure TQRExpert.RemoveOneClick(Sender: TObject);
begin
  MoveList(SelectedFields, AvailableFields);
  FixButtons;
end;

procedure TQRExpert.PreviewClick(Sender: TObject);
var
  AReport : TQuickRep;
  I : integer;
begin
  aReport := nil;
  with HiddenForm do
  try
    while HiddenForm.ComponentCount > 0 do
      HiddenForm.Components[0].Free;
    DoReportCreation(HiddenForm);;
    AReport:=nil;
    for I:=0 to ComponentCount-1 do
    begin
      if Components[I] is TQuickRep then
        AReport:=TQuickRep(Components[I]);
    end;
  finally
    if AReport <> nil then
    try
      AReport.Preview;
    finally
      AReport.Free;
    end;
  end
end;

procedure QuickReportExpert(ToolServices: TIToolServices);
var
  D: TQRExpert;
  ISourceStream, IFormStream: TIMemoryStream;
  UnitIdent, FormIdent: string;
  FileName: TFileName;
begin
  if ToolServices.GetNewModuleName(UnitIdent, FileName) then
  begin
    D := TQRExpert.Create(Application);
    try
      if D.ShowModal = mrOK then
      begin
        UnitIdent := LowerCase(UnitIdent);
        UnitIdent[1] := Upcase(UnitIdent[1]);
        FormIdent := 'Form' + Copy(UnitIdent, 5, 255);
        IFormStream := TIMemoryStream.Create(D.CreateForm(FormIdent));
        try
          IFormStream.AddRef;
          ISourceStream := TIMemoryStream.Create(D.CreateSource(UnitIdent,
            FormIdent));
          try
            ISourceStream.AddRef;
            ToolServices.CreateModule(FileName, ISourceStream, IFormStream,
              [cmAddToProject, cmShowSource, cmShowForm, cmUnNamed,
              cmMarkModified]);
          finally
            ISourceStream.OwnStream := True;
            ISourceStream.Free;
          end;
        finally
          IFormStream.OwnStream := True;
          IFormStream.Free;
        end
      end;
    finally
      D.Free;
    end
  end
end;

{$ifdef ver100}
procedure HandleException;
begin
  ToolServices.RaiseException(ReleaseException);
end;

{ TQuickReportExpert }

function TQuickReportExpert.GetName: string;
begin
  try
    Result := 'QuickReport Wizard';
  except
    HandleException;
  end;
end;

function TQuickReportExpert.GetComment: string;
begin
  try
    Result := 'Wizard to creating QuickReports';
  except
    HandleException;
  end;
end;

function TQuickReportExpert.GetGlyph: HICON;
begin
  try
    Result := LoadIcon(HInstance, 'QREXPERTBITMAP');
  except
    HandleException;
  end;
end;

function TQuickReportExpert.GetStyle: TExpertStyle;
begin
  try
    Result := esForm;
  except
    HandleException;
  end;
end;

function TQuickReportExpert.GetState: TExpertState;
begin
  try
    Result := [esEnabled];
  except
    HandleException;
  end;
end;

function TQuickReportExpert.GetIDString: string;
begin
  try
    Result := 'QuSoft.QuickReportWizard';
  except
    HandleException;
  end;
end;

function TQuickReportExpert.GetAuthor: string;
begin
  try
    Result := 'QuSoft AS';
  except
    HandleException;
  end;
end;

function TQuickReportExpert.GetPage: string;
begin
  try
    Result := LoadStr(SqrBusiness);
  except
    HandleException;
  end;
end;

procedure TQuickReportExpert.Execute;
begin
  try
    QuickReportExpert(ToolServices);
  except
    HandleException;
  end;
end;

procedure DoneExpert; export;
begin
end;
{$endif}

procedure TQRExpert.TableNameEnter(Sender: TObject);
begin
{  if Tablename.Items.Count = 0 then
    Session.GetTableNames(AliasName.Text, '', True, False, TableName.Items);}
end;

procedure TQRExpert.CancelBtnClick(Sender: TObject);
begin
  if MessageDlg('Cancel QuickReport Wizard?',
    mtInformation, [mbYes, mbNo], 0) = mrYes then
    ModalResult := mrCancel;
end;

end.


