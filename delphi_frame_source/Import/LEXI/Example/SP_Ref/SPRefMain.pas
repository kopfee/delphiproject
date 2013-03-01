unit SPRefMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Scanner, Menus, ExtDialogs, StdCtrls, ExtCtrls, LXScanner;

type
  TfmMain = class(TForm)
    MainMenu1: TMainMenu;
    Scanner: TLXScanner;
    File1: TMenuItem;
    mnOpen: TMenuItem;
    N1: TMenuItem;
    mnExit: TMenuItem;
    OpenDialog: TOpenDialogEx;
    mmSQL: TMemo;
    Splitter1: TSplitter;
    lsTables: TListBox;
    lsProcs: TListBox;
    procedure mnExitClick(Sender: TObject);
    procedure mnOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Tables,Procedures : TStringList;
    procedure GetReferences;
    function  isFollowTable(const keywordStr:string):boolean;
    function  isFollowProc(const keywordStr:string):boolean;
    function  inList(const s:string; const list:array of string): boolean;
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.DFM}

const
  needTableKeywordCount = 5;
  needTableKeywords : array[1..needTableKeywordCount] of string
    = ('from','insert','into','delete','update');
  needSPKeywordCount = 2;
  needSPKeywords : array[1..needSPKeywordCount] of string
    = ('exec','execute');

  sqlStateKeywordCount = 4;
  sqlStateKeywords : array[1..sqlStateKeywordCount] of string
    = ('select','insert','update','delete');

procedure TfmMain.FormCreate(Sender: TObject);
begin
  Tables  := TStringList.create;
  Procedures := TStringList.create;
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
      GetReferences;
      fs.Position:=0;
      mmSQL.Lines.LoadFromStream(fs);
      lsTables.Items.Assign(Tables);
      lsProcs.Items.Assign(Procedures);
    finally
      fs.free;
    end;
  end;
end;

procedure TfmMain.GetReferences;
var
  i : integer;
  token : TLXToken;
  needTableName : boolean;
  needVar : boolean;
  needProc : boolean;
begin
  Tables.clear;
  Procedures.clear;
  needTableName:=false;
  needProc := false;
  for i:=0 to Scanner.count-1 do
  begin
    token := Scanner.Token[i];
    case token.Token of
      ttKeyword   : begin
                      needTableName := isFollowTable(token.Text);
                      needProc := isFollowProc(token.Text);
                      needVar:=false;
                    end;
      ttIdentifier: begin
                      if needTableName then
                      begin
                        tables.Add(token.Text);
                      end else
                      begin
                        if needProc then
                          Procedures.Add(token.Text);
                      end;
                      needTableName := false;
                      needVar:=false;
                      needProc := false;
                    end;
      ttSpecialChar:begin
                      needVar:=token.text='@';
                      needProc := false;
                    end;
      ttComment:    begin
                      // do nothing
                    end;
    else            begin
                      needVar:=false;
                      needTableName := false;
                      needProc := false;
                    end;
    end;
  end;
end;

function TfmMain.inList(const s: string;
  const list: array of string): boolean;
var
  i : integer;
begin
  result := false;
  for i:=low(list) to high(list) do
    if CompareText(list[i],s)=0 then
    begin
      result := true;
      break;
    end;
end;

function TfmMain.isFollowTable(const keywordStr: string): boolean;
begin
  result:=inList(keywordStr,needTableKeywords);
end;

function TfmMain.isFollowProc(const keywordStr: string): boolean;
begin
  result:=inList(keywordStr,needSPKeywords);
end;

end.
