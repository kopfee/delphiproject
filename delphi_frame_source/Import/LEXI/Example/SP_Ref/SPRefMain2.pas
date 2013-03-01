unit SPRefMain2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Scanner, Menus, StdCtrls, ExtCtrls,contnrs, LXScanner;

type
  TSPParam = class(TObject)
  public
    name : string;
    dataType : string;
    passType : string;
  end;

  TSPParams = class(TObjectList)
  private
    function GetItems(index: integer): TSPParam;
  public
    constructor Create;
    function    add : TSPParam;
    property    items[index : integer] : TSPParam read GetItems; default;
  end;

  TTableOperKind = (soSelect,soInsert,soUpdate,soDelete);

  TTableOperation = class
  private
    FisAllFields: boolean;
    FtableName: string;
    FmodifiedFields: TStrings;
    Fkind: TTableOperKind;
  public
    property  kind : TTableOperKind read Fkind;
    property  tableName : string read FtableName;
    property  modifiedFields : TStrings read FmodifiedFields;
    property  isAllFields : boolean read FisAllFields; // for select,insert,update
    constructor Create;
    Destructor  Destroy;override;
  end;

  TTableOperations = class(TObjectList)
  private
    function getItems(index: integer): TTableOperation;
  public
    function  add: TTableOperation;
    property  items[index:integer]: TTableOperation read getItems; default;
  end;

  TSPReferences = class
  private
    FSPName: string;
    FSPParams: TSPParams;
    FCallProcedures: TStrings;
    FTableOperations: TTableOperations;
  public
    property  SPName : string read FSPName;
    property  SPParams : TSPParams read FSPParams;
    property  TableOperations : TTableOperations read FTableOperations;
    property  CallProcedures : TStrings read FCallProcedures ;
    constructor Create;
    Destructor  Destroy;override;
  end;

  TSPReferencesList = class(TObjectList)
  private
    function getItems(index: integer): TSPReferences;
  public
    function  add: TSPReferences;
    property  items[index:integer] : TSPReferences read getItems;default;
  end;

  TfmMain = class(TForm)
    MainMenu1: TMainMenu;
    Scanner: TLXScanner;
    File1: TMenuItem;
    mnOpen: TMenuItem;
    N1: TMenuItem;
    mnExit: TMenuItem;
    OpenDialog: TOpenDialog;
    mmSQL: TMemo;
    Splitter1: TSplitter;
    mmRef: TMemo;
    procedure mnExitClick(Sender: TObject);
    procedure mnOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    SPRefList : TSPReferencesList;
    procedure GetReferences(Scanner:TLXScanner; RefList:TSPReferencesList);
    procedure ViewReferences;
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.DFM}

{ TSPParams }

constructor TSPParams.Create;
begin
  inherited create(true);
end;

function TSPParams.add: TSPParam;
begin
  result := TSPParam.create;
  inherited add(result);
end;

function TSPParams.GetItems(index: integer): TSPParam;
begin
  result := TSPParam(inherited Items[index]);
end;

{ TTableOperation }

constructor TTableOperation.Create;
begin
  FmodifiedFields := TStringList.create;
end;

destructor TTableOperation.Destroy;
begin
  FreeAndNil(FmodifiedFields);
  inherited;
end;

{ TTableOperations }

function TTableOperations.add: TTableOperation;
begin
  result := TTableOperation.create;
  inherited add(result);
end;

function TTableOperations.getItems(index: integer): TTableOperation;
begin
  result := TTableOperation(inherited items[index]);
end;

{ TSPReferences }

constructor TSPReferences.Create;
begin
  FSPParams := TSPParams.create;
  FCallProcedures := TStringList.create;
  FTableOperations:= TTableOperations.create;
end;


destructor TSPReferences.Destroy;
begin
  FreeAndNil(FTableOperations);
  FreeAndNil(FCallProcedures);
  FreeAndNil(FSPParams);
  inherited;
end;

{ TSPReferencesList }

function TSPReferencesList.add: TSPReferences;
begin
  result := TSPReferences.create;
  inherited add(result);
end;

function TSPReferencesList.getItems(index: integer): TSPReferences;
begin
  result := TSPReferences(inherited items[index]);
end;

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

const
  StatementStartKeywordCount = 8;
  StatementStartKeywords : array[0..StatementStartKeywordCount-1] of string
    = ('create','exec','execute','select','insert','update','delete','go');
  sskCreate     = 0;
  sskExec       = 1;
  sskExecute    = 2;
  sskSelect     = 3;
  sskInsert     = 4;
  sskUpdate     = 5;
  sskDelete     = 6;
  sskGo         = 7;
  TableOperDesc : array[TTableOperKind] of string
   = ('Select','Insert','Update','Delete');

procedure TfmMain.FormCreate(Sender: TObject);
begin
  SPRefList := TSPReferencesList.create;
  //OpenDialog.InitialDir:=ExtractFileDir(Application.ExeName);
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
      Scanner.Analyze(fs);
      SPRefList.Clear;
      GetReferences(Scanner,SPRefList);
      ViewReferences;
      fs.Position:=0;
      mmSQL.Lines.LoadFromStream(fs);
    finally
      fs.free;
    end;
  end;
end;

procedure TfmMain.GetReferences(Scanner:TLXScanner; RefList:TSPReferencesList);
var
  i: integer;
  token : TLXToken;
  curRef : TSPReferences;
  keyWordIndex : integer;
  TabOp : TTableOperation;
  TableName : string;

  function nextToken: TLXToken;
  begin
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

  procedure handleCreate;
  var
    procName : string;
  begin
    token := nextToken;
    if isKeyword(token,'proc') or isKeyword(token,'procedure') then
    begin
      token := nextToken;
      procName := getIdentifier(token);
      if procName<>'' then
      begin
        token := nextToken;
        { TODO -cfunction : to process params }
        while (token<>nil) and isKeyword(token,'as') do
          token := nextToken;
        if token<>nil then
        begin
          curRef := RefList.add;
          curRef.FSPName := procName;
        end;
      end;
    end;
  end;

  procedure handleExec;
  var
    procName : string;
  begin
    token := nextToken;
    if isSymbol(token,'@') then
    begin
      token := nextToken; // skip var
      token := nextToken; // skip '='
      token := nextToken; // get spname
    end;
    procName := getIdentifier(token);
    if procName<>'' then
    begin
      curRef.FCallProcedures.add(procName);
    end;
  end;

  procedure handleSelect;
  begin
    { TODO -cfunction : to process columns }
    token := nextToken;
    while (token<>nil) and (token.token<>ttKeyword) do
      token := nextToken;
    if isKeyword(token,'from') then
    begin
      repeat
        TabOp:=curRef.TableOperations.add;
        TabOp.Fkind := soSelect;
        // read table names
        token := nextToken;
        TabOp.FtableName:= getIdentifier(token);
        token := nextToken;
        // skip alias
        if (token<>nil) and (token.Token=ttIdentifier) then
          token := nextToken;
      until (token=nil) or not(isSymbol(token,','));
      goBackAToken;
    end else
      goBackAToken;
  end;

  procedure handleInsert;
  begin
    token := nextToken;
    // skip 'into'
    if isKeyword(token,'into') then
      token := nextToken;
    TableName:=getIdentifier(token);
    if TableName<>'' then
    begin
      TabOp:=curRef.TableOperations.add;
      TabOp.Fkind := soInsert;
      // read table names
      TabOp.FtableName:=tableName;
      token := nextToken;
      if isSymbol(token,'(') then
      begin
        repeat
          // get columns
          token := nextToken;
          TabOp.FmodifiedFields.add(getIdentifier(token));
          token := nextToken;
        until (token=nil) or not(isSymbol(token,','));
        // no need for goBackAToken because here is a ')'
      end else
      begin
        TabOp.FisAllFields:=true;
        goBackAToken;
      end;
    end;
  end;

  procedure handleUpdate;
  var
    t1,t2 : TLXToken;
  begin
    token := nextToken;
    TableName:=getIdentifier(token);
    if TableName<>'' then
    begin
      TabOp:=curRef.TableOperations.add;
      TabOp.Fkind := soUpdate;
      TabOp.FtableName:=tableName;
      token := nextToken;
      if isKeyword(token,'set') then
      begin
        repeat
          t1:=nil;
          t2:=nextToken;
          while (t2<>nil) and not isSymbol(t2,'=') and (t2.token<>ttKeyword) do
          begin
            t1:=t2;
            t2:=nextToken;
          end;
          if isSymbol(t2,'=') and (t1<>nil) and (t1.Token=ttIdentifier) then
            TabOp.FmodifiedFields.add(getIdentifier(t1)) else
            begin
              goBackAToken;
              break;
            end;
        until false;
      end;
    end;
  end;

  procedure handleDelete;
  begin
    token := nextToken;
    TableName:=getIdentifier(token);
    if TableName<>'' then
    begin
      TabOp:=curRef.TableOperations.add;
      TabOp.Fkind := soDelete;
      TabOp.FtableName:=tableName;
    end;
  end;

begin
  i:=0;
  curRef := nil;
  token := nextToken;
  while token<>nil do
  begin
    if token.Token = ttKeyword then
    begin
      keyWordIndex:=inList(token.Text,StatementStartKeywords);
      if curRef=nil then
      begin
        if keyWordIndex=sskCreate then
          handleCreate;
      end else
      begin
        case keyWordIndex of
          sskExec,sskExecute : handleExec;
          sskSelect : handleSelect;
          sskInsert : handleInsert;
          sskUpdate : handleUpdate;
          sskDelete : handleDelete;
          sskGo     : curRef:=nil;
        end;
      end;
    end;
    token := nextToken;
  end;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  SPRefList.free;
end;

procedure TfmMain.ViewReferences;
var
  i,j,k : integer;
  curRef : TSPReferences;
  tabOp : TTableOperation;
  fields : string;
begin
  mmRef.Lines.Clear;
  for i:=0 to SPRefList.Count-1 do
  begin
    curRef:=SPRefList[i];
    mmRef.Lines.add('========'+ curRef.SPName +'========');
    mmRef.Lines.add('+ Tables');
    for j:=0 to curRef.TableOperations.Count-1 do
    begin
      tabOp:=curRef.TableOperations[j];
      mmRef.Lines.add(' * '+ TableOperDesc[tabOp.kind]+' '+tabOp.tableName);
      fields:='fields:';
      if tabOp.isAllFields then
        fields := fields+' *'
      else for k:=0 to tabOp.modifiedFields.Count-1 do
      begin
        fields := fields+' '+tabOp.modifiedFields[k];
      end;
      mmRef.Lines.add('   -'+fields);
    end;
    mmRef.Lines.add('+ Procedures');
    for j:=0 to curRef.CallProcedures.count-1 do
    begin
      mmRef.Lines.add(' * '+curRef.CallProcedures[j]);
    end;
  end;
end;

end.
