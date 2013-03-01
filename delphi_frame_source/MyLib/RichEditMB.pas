unit RichEditMB;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs,
  StdCtrls,NewComCtrls,RichEdit;

type
  TRichEditMB = class(TRichEdit2)
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure CreateWnd; override;
    //procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TRichEditMB]);
end;

{
type
  TWordBreakExProc =function (pchText : pchar;
  cchText : longint;
  bCharSet : byte;
  code:integer) : longint; stdcall;

var
  OldWordBreak : TWordBreakExProc;
}
{
EditWordBreakProcEx(

    char *pchText,
    LONG cchText,
    BYTE bCharSet,
    INT code
   );
}
{
function WordBreakEx(pchText : pchar;
  cchText : longint;
  bCharSet : byte;
  code:integer) : longint; stdcall;
}
type
  TWordBreakProc = function (lpch : pchar;
  ichCurrent,cch,code:integer) : integer; stdcall;

var
  OldWordBreak : TWordBreakProc;

function WordBreak(lpch : pchar;
  ichCurrent,cch,code:integer) : integer; stdcall;

var
  s : string;
  Test1 : boolean;
  Test2 : boolean;
begin
  SetString(s,lpch,cch);
  if Assigned(OldWordBreak) then
    result := OldWordBreak(lpch,ichCurrent,cch,code)
  else
    result := 0;
  (*if (code = WB_ISDELIMITER) {and (ichCurrent>0)} then
  begin
    if ByteToCharIndex(s,ichCurrent)=ByteToCharIndex(s,ichCurrent+1)
      then result:=integer(true)//integer(false)
      else result:=integer(false)//integer(true);
  end;*)
  Test1 := ByteToCharIndex(s,ichCurrent)=ByteToCharIndex(s,ichCurrent+1);
  Test2 := ByteToCharIndex(s,ichCurrent-1)=ByteToCharIndex(s,ichCurrent-2);
  case code of
    WB_right : if Test1 then
                 result := ichCurrent+2
               else
                 result := ichCurrent+1;
    WB_left :  if test1 then
                 if test2 then
                    result := ichCurrent-2
                 else
                    result := ichCurrent-1
               else result := ichCurrent-1;
    WB_CLASSIFY :
               if not test1 then
               begin
                 result := WBF_BREAKAFTER;	
               end;
  end;
end;

{ TRichEditMB }
(*
procedure TRichEditMB.CreateParams(var Params: TCreateParams);
const
  RichEditModuleName = 'RICHED20.DLL';
  HideScrollBars: array[Boolean] of DWORD = (ES_DISABLENOSCROLL, 0);
  HideSelections: array[Boolean] of DWORD = (ES_NOHIDESEL, 0);
var
  OldError: Longint;
begin
  OldError := SetErrorMode(SEM_NOOPENFILEERRORBOX);
  FLibHandle := LoadLibrary(RichEditModuleName);
  if (FLibHandle > 0) and (FLibHandle < HINSTANCE_ERROR) then FLibHandle := 0;
  SetErrorMode(OldError);
  TCustomMemo.CreateParams(Params);
  CreateSubClass(Params, 'RICHEDIT32A');
  with Params do
  begin
    Style := Style or HideScrollBars[FHideScrollBars] or
      HideSelections[HideSelection];
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
  end;
end;
*)
procedure TRichEditMB.CreateWnd;
var
  Proc : TWordBreakProc;
begin
  inherited CreateWnd;
  {Proc := TWordBreakProc(Perform(EM_GETWORDBREAKPROC,0,0));
  if @Proc<>@WordBreak then
  begin
    OldWordBreak:=Proc;
    Perform(EM_SETWORDBREAKPROC,0,integer(@WordBreak));
  end;}
end;

initialization
  OldWordBreak := nil;
end.
