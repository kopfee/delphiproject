unit CommParser;

(*****   Code Written By Huang YanLai   *****)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Scanner,RepInfoIntf, LXScanner;

type
  TCommonParser = class(TDataModule)
    Scanner: TLXScanner;
  private

  protected
    { Private declarations }
    FReporter : IReport;
    FTokenSeq : integer;
    token : TLXToken;
    procedure doParse;  virtual;
    procedure goBackAToken;
    function  nextToken: TLXToken;
    procedure reportInfo; virtual;
    procedure beforeAnalyse; virtual;
    procedure afterAnalyse; virtual;
    procedure analyseToken; virtual;
    procedure beforeExecute; virtual;
  public
    { Public declarations }
    function  Execute(s : TStream; Reporter : IReport):boolean;
  end;

var
  CommonParser: TCommonParser;

const
  feedBackCount = 50;

function inList(const s: string;const list: array of string): integer;

function isKeyword(token:TLXToken; const keyword:string):boolean;

function  getIdentifier(token:TLXToken):string;

function  isSymbol(token:TLXToken; symbol:char):boolean;

function  getString(token:TLXToken; var s:string):boolean;

implementation

uses ProgDlg2;

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

{ TCommonParser }

procedure TCommonParser.afterAnalyse;
begin

end;

procedure TCommonParser.analyseToken;
begin

end;

procedure TCommonParser.beforeAnalyse;
begin

end;

procedure TCommonParser.beforeExecute;
begin

end;

procedure TCommonParser.doParse;
begin
  dlgProgress.lbInfo.Caption:='Analyse Tokens...';
  dlgProgress.ProgressBar.Min:=0;
  dlgProgress.ProgressBar.max:=Scanner.Count;
  FTokenSeq:=0;
  beforeAnalyse;
  token := nextToken;
  while token<>nil do
  begin
    analyseToken;
    token := nextToken;
  end;
  afterAnalyse;
end;

function  TCommonParser.Execute(s : TStream; Reporter : IReport):boolean;
begin
  FReporter := Reporter;
  beforeExecute;
  dlgProgress.execute;
  try
    dlgProgress.setInfo('Read Tokens...');
    dlgProgress.checkCanceled;
    Scanner.Analyze(s);
    doParse;
    if not dlgProgress.canceled then
      reportInfo;
  finally
    result := not dlgProgress.canceled;
    FReporter := nil;
    dlgProgress.close;
  end;
end;

procedure TCommonParser.goBackAToken;
begin
  if (FTokenSeq>0) and (token<>nil) then
  begin
    dec(FTokenSeq);
    //outputDebugString(':back');
  end;
end;

function TCommonParser.nextToken: TLXToken;
begin
  if (FTokenSeq mod feedBackCount)=0 then
  begin
    dlgProgress.ProgressBar.Position:=FTokenSeq;
    Application.ProcessMessages;
    if dlgProgress.canceled then abort;
  end;
  // filter out comments
  while FTokenSeq<Scanner.count do
  begin
    result := Scanner.Token[FTokenSeq];
    inc(FTokenSeq);
    //outputDebugString(pchar(result.text));
    if result.Token<>ttComment then exit;
  end;
  result := nil;
end;

procedure TCommonParser.reportInfo;
begin

end;

end.
