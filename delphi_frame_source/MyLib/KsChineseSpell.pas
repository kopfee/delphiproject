{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>KsChineseSpell
   <What>获取汉字首字母
   <Written By> 曾创能，Huang YanLai (黄燕来)
   <History>
   0.2 黄燕来 [2001.9.4]
   0.1 曾创能 [2001.3.29]
   注释:
                 汉字分为一级汉字和二级汉字，一级汉字（常用）是按拼音来编排的，
                 因此提取首字母较容易；二级汉字（不常用）按笔画结构来编排的，这里
                 将二级汉字按首字母顺序放置于资源文件中。找不到该汉字用"!"代替首
                 字母。
**********************************************}

unit KsChineseSpell;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

(*
type
  TKsChineseSpell = class(TCustomLabel)
  private
    { Private declarations }
    FUpperCaseSpell:Boolean;
    FIsSkip:boolean;
    FChineseWords:string;
    procedure SetUpperCaseSpell(Value:Boolean);
    procedure SetChineseWords(Value:string);
    procedure SetIsSkip(value:boolean);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner:TComponent);override;
    function GetFirstSpell(s:string):string;
    property Caption;
  published
    { Published declarations }
    property UpperCaseSpell:Boolean read FUpperCaseSpell write SetUpperCaseSpell;
    property IsSkip:boolean read FIsSkip write setIsSkip;//isSkip属性是标志是否略过非汉字（如字母，数字等）
    property ChineseWords:string read FChineseWords write SetChineseWords;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FocusControl;
    property Font;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowAccelChar;
    property ShowHint;
    property Transparent;
    property Layout;
    property Visible;
    property WordWrap;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;
*)

function GetChineseFirstSpell(const S : string; SkipOther : Boolean=True) : string;

implementation

{$R KsChineseSpell.res}

uses SafeCode;

resourcestring
  SResourceError = '没有找到汉字拼音资源文件';

const
  FirstAlphabetCount = 23; // 汉语拼音首字母数量（注意不足26，因为少数字母不作为首字母）
  FirstAlphabets = 'abcdefghjklmnopqrstwxyz';

var
  SecondaryCharset : string = '';
  FirstAlphabetPos : array[1..FirstAlphabetCount] of Integer;
  
procedure LoadSecondaryCharLib;
var
  hRes : THandle;
  pRes : HGLOBAL;
  ResSize : Integer;
  ResourceMem : PChar;
  P : PChar;
  CharIndex, AlphabetIndex : Integer;
begin
  try
    //装载资源文件
    hRes := FindResource(hInstance,'KSCHINESESPELL', 'MYDATATYPE');
    CheckTrue(hRes<>0,SResourceError);
    ResSize := SizeOfResource(hinstance,hRes);
    CheckTrue(ResSize>0,SResourceError);
    pRes := LoadResource(hInstance, hRes);
    CheckTrue(pRes>0,SResourceError);
    ResourceMem := LockResource(pRes);
    CheckTrue(ResourceMem<>nil,SResourceError);
    try
      //从资源文件中读取二级汉字库
      SetLength(SecondaryCharset,ResSize);
      P := PChar(SecondaryCharset);
      Move(ResourceMem^,P^,ResSize);
      P[ResSize] := #0;
      CharIndex := 1;
      AlphabetIndex := 0;
      while (AlphabetIndex<FirstAlphabetCount) and (P^<>#0) do
      begin
        if P^='#' then
        begin
          Inc(AlphabetIndex);
          FirstAlphabetPos[AlphabetIndex] := CharIndex-1;
          // skip another #
          Inc(P);
          Inc(CharIndex);
        end;
        Inc(P);
        Inc(CharIndex);
      end;
    finally
      FreeResource(pRes);
    end;
  except
    SecondaryCharset := '';
  end;
end;

function SearchInFirstCharset(CharWord : Word) : char;//获取一级汉字的首字母
begin
  case CharWord of
    $B0A1..$B0C4 : Result := 'a';
    $B0C5..$B2C0 : Result := 'b';
    $B2C1..$B4ED : Result := 'c';
    $B4EE..$B6E9 : Result := 'd';
    $B6EA..$B7A1 : Result := 'e';
    $B7A2..$B8C0 : Result := 'f';
    $B8C1..$B9FD : Result := 'g';
    $B9FE..$BBF6 : Result := 'h';
    $BBF7..$BFA5 : Result := 'j';
    $BFA6..$C0AB : Result := 'k';
    $C0AC..$C2E7 : Result := 'l';
    $C2E8..$C4C2 : Result := 'm';
    $C4C3..$C5B5 : Result := 'n';
    $C5B6..$C5BD : Result := 'o';
    $C5BE..$C6D9 : Result := 'p';
    $C6DA..$C8BA : Result := 'q';
    $C8BB..$C8F5 : Result := 'r';
    $C8F6..$CBF9 : Result := 's';
    $CBFA..$CDD9 : Result := 't';
    $CDDA..$CEF3 : Result := 'w';
    $CEF4..$D1B8 : Result := 'x';
    $D1B9..$D4D0 : Result := 'y';
    $D4D1..$D7F9 : Result := 'z';
  else
    Result := char(0);
  end;
end;

function SearchInSecondCharset(const ChineseChar : string) : Char; //获取二级汉字的首字母
var
  I : Integer;
  ChaIndex : Integer;
begin
  Result := #0;
  ChaIndex := Pos(ChineseChar,SecondaryCharset);
  if ChaIndex>0 then
  begin
    for I:=1 to FirstAlphabetCount do
    begin
      if ChaIndex<=FirstAlphabetPos[I] then
      begin
        Result := FirstAlphabets[I];
        Break;
      end;
    end;
  end;
end;

function GetChineseFirstSpell(const S : string; SkipOther : Boolean) : string;
var
  I : Integer;
  Len : Integer;
  AChar, SecondChar : Char;
  SpellChar : Char;
begin
  Result := '';
  Len := Length(S);
  I := 1;
  while I<=Len do
  begin
    AChar := S[I];
    if AChar<#128 then
    begin
      if (AChar>#31) and not SkipOther then
        Result := Result + AChar;
    end else
    begin
      // 汉字的第一个字节
      if I<Len then
      begin
        Inc(I);
        SecondChar := S[I];
        SpellChar := SearchInFirstCharset(Word(AChar) shl 8 or Word(SecondChar));
        if SpellChar=#0 then
          SpellChar := SearchInSecondCharset(AChar+SecondChar);
        if SpellChar<>#0 then
          Result := Result + SpellChar;
      end;
    end;
    Inc(I);
  end;
end;

(*
{ TKsChineseSpell }

constructor TKsChineseSpell.Create(AOwner: TComponent);
begin
  inherited;
  ChineseWords:='金仕达delphi开发组';
end;

function TKsChineseSpell.GetFirstSpell(s: string): string;
var
  cstr,hz,py,py1:string;
  hstr : array[1..23] of string;//记录以该字母打头的二级汉字串
  i,j,k : Integer;
  hRes : Thandle;
  pRes : Cardinal;
  ResSize : Integer;
  Fstr : string;
  Fpos : Integer;
const FirstSpells:array[1..23] of char='abcdefghjklmnopqrstwxyz';
begin
cstr:='0123456789abcdefghijklmnopqrstuvwxyz';
cstr:=cstr+'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
cstr:=cstr+'!.#$%()*+-,/[\|^~`@{}_';

//装载资源文件
hRes:=FindResource(hInstance,'MYUSERDATA','MYDATATYPE');
  if hRes=0 then
    begin
      application.Messagebox(pchar('没有找到资源文件！'),pchar('提示'),mb_ok);
      exit;
    end;
  ResSize:=SizeOfResource(hinstance,hRes);
  if ResSize=0 then
    begin
      application.Messagebox(pchar('没有装载任何资源！'),pchar('提示'),mb_ok);
      exit;
    end;
  pRes:=LoadResource(hInstance, hRes);
  if pRes=0 then
    begin
      application.Messagebox(pchar('资源装载失败！！'),pchar('提示'),mb_ok);
      FreeResource(pRes);
      exit;
    end;

  //从资源文件中读取二级汉字库
  Fstr:='';
  i:=0;
  while i<ResSize do
    begin
      Fstr:=Fstr+pChar(pRes)[i];
      inc(i);
    end;
  FreeResource(pRes);

  //给hstr赋初值
  for i:=1 to 23 do
    begin
      Fpos:=pos('##',Fstr);
      if Fpos>0 then
         begin
           hstr[i]:=copy(Fstr,1,Fpos-1);
           delete(Fstr,1,Fpos+1);
         end;
    end;

Result:=s;
py:='';
j:=1;
i:=Length(Result);
while (j<=i) Do
begin
if Pos(s[j],cstr)>0 then
   begin
      if not FisSkip then py:=py+s[j];
      j:=j+1;
   end
else
begin
  hz:=s[j]+s[j+1];
  py1:=getpy2(hz);
  if py1<>char(0) then
  begin
  py:=py+py1;
  end
  else
  for k:=1 to 23 do
  begin
      if Pos(hz,hstr[k])>0 then
      begin
       py:=py+FirstSpells[k];
       break;
      end;
      if k=23 then py:=py+'!';
  end;
  j:=j+2;
end;
end;
GetFirstSpell:=py;
end;

procedure TKsChineseSpell.SetChineseWords(Value: string);
begin
  if FChineseWords<>Value then
  begin
    FChineseWords:=Value;
    Caption:=GetFirstSpell(Value);
  end;
end;

procedure TKsChineseSpell.SetUpperCaseSpell(Value: Boolean);
begin
  if FUpperCaseSpell<>Value then
  begin
    FUpperCaseSpell:=Value;
    Caption:=GetFirstSpell(FChineseWords);
  end;
end;

procedure TKsChineseSpell.SetIsSkip(Value: Boolean);
begin
  if FIsSkip<>Value then
  begin
    FIsSkip:=Value;
    Caption:=GetFirstSpell(FChinesewords);
  end;
end;
*)

initialization
  LoadSecondaryCharLib;

end.
