unit ImportMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Scanner, Menus, StdCtrls, ExtCtrls,contnrs, ComCtrls, LXScanner;

type
  TDataField = class
  private
    FdataType: string;
    Fcaption: string;
    FName: string;
  public
    property name : string  read FName;
    property caption : string read Fcaption;
    property dataType : string read FdataType;
  end;

  TDataFields = class(TObjectList)
  private
    function getItems(index: integer): TDataField;
  public
    property items[index:integer] : TDataField read getItems;default;
    function add: TDataField;
  end;

  TDataTable = class
  private
    Fcaption: string;
    Fname: string;
    FFields: TDataFields;
  public
    property    fields : TDataFields read FFields;
    property    name : string read Fname;
    property    caption : string read Fcaption;
    constructor Create;
    Destructor  Destroy;override;
  end;

  TDataTables = class(TObjectList)
  private
    function getItems(index: integer): TDataTable;
  public
    property items[index:integer] : TDataTable read getItems;default;
    function add: TDataTable;
  end;

  //TTableInfo
  TfmMain = class(TForm)
    MainMenu1: TMainMenu;
    Scanner: TLXScanner;
    File1: TMenuItem;
    mnOpen: TMenuItem;
    N1: TMenuItem;
    mnExit: TMenuItem;
    OpenDialog: TOpenDialog;
    Splitter1: TSplitter;
    mmText: TRichEdit;
    mmSumary: TRichEdit;
    StatusBar1: TStatusBar;
    procedure mnExitClick(Sender: TObject);
    procedure mnOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ScannerTokenRead(Sender: TObject; Token: TLXToken;
      var AddToList, Stop: Boolean);
  private
    { Private declarations }
    Tables : TDataTables;
    procedure GetReferences(Scanner:TLXScanner; aTables : TDataTables);
    procedure ViewReferences;
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

const
  feedBackCount = 50;

implementation

uses ProgDlg;

{$R *.DFM}

{ help procedures/functions }

function inList(const s: string;
  const list: array of string): integer;
var
  i : integer;
begin
  result := -1;
  for i:=low(list) to high(list) do
    if CompareText(list[i],s)=0 then
    begin
      result := i;
      break;
    end;
end;

function isKeyword(token:TLXToken; const keyword:string):boolean;
begin
  result := (token<>nil) and (token.Token=ttKeyword)
    and (compareText(token.text,keyword)=0);
end;

function  getIdentifier(token:TLXToken):string;
begin
  if (token<>nil) and (token.Token=ttIdentifier) then
    result := token.text else
    result := '';
end;

function  isSymbol(token:TLXToken; symbol:char):boolean;
begin
  result := (token<>nil) and (token.Token=ttSpecialChar)
    and (token.text=symbol);
end;

function  getString(token:TLXToken; var s:string):boolean;
begin
  result := (token<>nil) and (token.Token=ttString);
  if result then s:=token.text;
end;

{ TfmMain }

procedure TfmMain.FormCreate(Sender: TObject);
begin
  Tables := TDataTables.create;
  OpenDialog.InitialDir:=ExtractFileDir(Application.ExeName);
end;

procedure TfmMain.mnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.mnOpenClick(Sender: TObject);
var
  fs : TFileStream;
begin
  if OpenDialog.Execute then
  begin
    fs := TFileStream.Create(OpenDialog.fileName,fmOpenRead	);
    try
      Caption:=Application.Title+' - '+OpenDialog.fileName;
      dlgProgress.execute;
      Scanner.Analyze(fs);
      if not dlgProgress.canceled then
      begin
        Tables.Clear;
        GetReferences(Scanner,Tables);
      end;
      if not dlgProgress.canceled then
        ViewReferences;
      fs.Position:=0;
      mmText.Lines.LoadFromStream(fs);
    finally
      fs.free;
      dlgProgress.close;
    end;
  end;
end;

procedure TfmMain.GetReferences(Scanner:TLXScanner; aTables : TDataTables);
var
  i: integer;
  token : TLXToken;
  aname,acaption,adatatype,aformat:string;
  curTable : TDataTable;
  curTableName : string;
  curField : TDataField;

  function nextToken: TLXToken;
  begin
    if (i mod feedBackCount)=0 then
    begin
      dlgProgress.ProgressBar.Position:=i;
      Application.ProcessMessages;
      if dlgProgress.canceled then abort;
    end;
    // filter out comments
    while i<Scanner.count do
    begin
      result := Scanner.Token[i];
      inc(i);
      //outputDebugString(pchar(result.text));
      if result.Token<>ttComment then exit;
    end;
    result := nil;
  end;

  procedure goBackAToken;
  begin
    if (i>0) and (token<>nil) then
    begin
      dec(i);
      //outputDebugString(':back');
    end;
  end;

begin
  dlgProgress.lbInfo.Caption:='Read Tokens...';
  dlgProgress.ProgressBar.Min:=0;
  dlgProgress.ProgressBar.max:=Scanner.Count;

  i:=0;
  token := nextToken;
  curTable:=nil;
  curField:=nil;
  while token<>nil do
  begin
    if isKeyword(token,'add')  then
    begin
      token := nextToken;
      if isKeyword(token,'file') then
      begin
        token := nextToken;
        if getString(token,aName) then
        begin
          curTable:=aTables.add;
          curTable.fname:=aName;
          curField:=nil;
        end;
      end
      else if isKeyword(token,'field') and (curTable<>nil) then
      begin
        token := nextToken;
        if getString(token,aName) then
        begin
          token := nextToken;
          if isKeyword(token,'of') then
          begin
            token := nextToken;
            if getString(token,curTableName) and (CompareText(curTableName,curTable.Name)=0) then
            begin
              curField := curTable.fields.add;
              curField.fname := aName;
            end;
          end;
        end;
      end;
    end
    else if (curField<>nil) then
    begin
      if isKeyword(token,'as') then
      begin
        token := nextToken;
        adatatype:=getIdentifier(token);
        if adatatype<>'' then
          curField.fdataType:=aDatatype;
      end
      else if isKeyword(token,'help') then
      begin
        token := nextToken;
        if getString(token,acaption) then
          curField.fcaption:=acaption;
      end
      else if isKeyword(token,'format') then
      begin
        token := nextToken;
        if getString(token,aformat) and (aformat<>'') then
        begin
          aformat:=StringReplace(aformat,'x','%s',[rfIgnoreCase]);
          curField.FdataType:=format(aformat,[curField.fdataType]);
        end;
      end
    end;
    token := nextToken;
  end;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  Tables.free;
end;

procedure TfmMain.ViewReferences;
var
  i,j : integer;
  curTable : TDataTable;
  curField : TDataField;
begin
  StatusBar1.SimpleText:='Tables:'+IntToStr(tables.Count);
  dlgProgress.lbInfo.Caption:='Generate Report...';
  dlgProgress.ProgressBar.Min:=0;
  dlgProgress.ProgressBar.max:=tables.Count;
  mmSumary.Lines.Clear;
  for i:=0 to tables.Count-1 do
  begin
    dlgProgress.ProgressBar.Position:=i;
    Application.ProcessMessages;
    if dlgProgress.canceled then abort;
    curTable:=tables[i];
    mmSumary.Lines.add('========'+ curTable.Name +'========');
    mmSumary.Lines.add('+ Fields');
    for j:=0 to curTable.fields.Count-1 do
    begin
      curField:=curTable.fields[j];
      mmSumary.Lines.add('|- '+ curField.caption + ' - ' + curField.Name + ' : '+curField.dataType);
    end;
  end;
end;

{ TDataFields }

function TDataFields.add: TDataField;
begin
  result := TDataField.Create;
  inherited add(result);
end;

function TDataFields.getItems(index: integer): TDataField;
begin
  result := TDataField(inherited items[index]);
end;

{ TDataTable }

constructor TDataTable.Create;
begin
  FFields:= TDataFields.create;
end;

destructor TDataTable.Destroy;
begin
  FreeAndNil(FFields);
  inherited;
end;

{ TDataTables }

function TDataTables.add: TDataTable;
begin
  result := TDataTable.Create;
  inherited add(result);
end;

function TDataTables.getItems(index: integer): TDataTable;
begin
  result := TDataTable(inherited items[index]);
end;

procedure TfmMain.ScannerTokenRead(Sender: TObject; Token: TLXToken;
  var AddToList, Stop: Boolean);
begin
  if dlgProgress.canceled then
    stop:=true else
    begin
      if ((Scanner.Count mod feedBackCount)=0) and (Token<>nil) then
      begin
        dlgProgress.lbInfo.caption := 'Read Line:'+IntToStr(Token.row);
        Application.ProcessMessages;
      end;
    end;
end;

end.
