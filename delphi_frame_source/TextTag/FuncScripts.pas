unit FuncScripts;
{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>FuncScripts
   <What>基于函数的脚本分析
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}


interface

uses SysUtils,Classes;

type
  TScriptFunc = class
  private
    FFunctionName: string;
    FParams: TStrings;
  public
    constructor Create;
    destructor  Destroy;override;
    property    FunctionName : string read FFunctionName write FFunctionName;
    property    Params : TStrings read FParams;
  end;

{
  <Function>ParseFunctions
  <What>分析脚本文本，生成TScriptFunc加入到Funcs。
  脚本语言由句子组成。句子的格式如下：
    函数名(参数1,参数2,...)；
  参数都是字符串，用""包含。
  <Params>
    -
  <Return>
  <Exception>
}

procedure ParseFunctions(const AText:string; Funcs : TList);

function  DecodeString(const s:string):string;

function  GetParam(Params : TStrings; Index:Integer; const DefaultValue : string):string;

resourcestring
  EExpect = 'Expect ';

implementation

uses SafeCode;

function  DecodeString(const s:string):string;
begin
  { TODO : decode string }
  result := s;
end;

function  GetParam(Params : TStrings; Index:Integer; const DefaultValue : string):string;
begin
  if (Index>=0) and (Index<Params.Count) then
    Result := Params[Index] else
    Result := DefaultValue;
end;

procedure ParseFunctions(const AText:string; Funcs : TList);
var
  P,SavedP : PChar;
  Func : TScriptFunc;
  S : string;
begin
  { TODO : skip more blanks between parts }
  P := PChar(AText);
  while p^<>#0 do
  begin
    // 1)skip blank
    while (p^<>#0) and (P^<=#32) do
      inc(p);
    if p^=#0 then Break;
    // 2)get function name
    SavedP := P;
    P := AnsiStrScan(P,'(');
    CheckPtr(P,EExpect+'(');
    Func := TScriptFunc.Create;
    Funcs.Add(Func);
    {SetLength(Func.FFunctionName,P-SavedP);
    Move(Pchar(Func.FunctionName)^,SavedP^,P-SavedP);}
    SetString(Func.FFunctionName,SavedP,P-SavedP);
    Inc(P); // skip (
    // 3) get params
    while (P^<>')') and (P^<>#0) do
    begin
      CheckTrue(P^='"',EExpect+'"');
      Inc(P);
      SavedP := P;
      repeat
        P := AnsiStrScan(P,'"');
        CheckPtr(P,EExpect+'"');
        if (P-1)^='\' then
          Inc(P); // skip this escaped char
      until P^='"';  // for escape
      SetString(S,SavedP,P-SavedP);
      Func.Params.Add(DecodeString(S));
      Inc(P); // skip "
      // skip ,
      if (P^=',') then
        Inc(P);
    end;
    // 4) skip ;
    if p^<>#0 then
    begin
      Inc(P);
      if P^=';' then
        Inc(P);
    end;
  end;
end;

{ TScriptFunc }

constructor TScriptFunc.Create;
begin
  FParams := TStringList.Create;
end;

destructor TScriptFunc.Destroy;
begin
  FParams.Free;
  inherited;

end;

end.
