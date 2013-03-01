unit MemoEx;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs,
  StdCtrls;

type
  TMemoEx = class(TMemo)
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure CreateWnd; override;
  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TMemoEx]);
end;

{
int CALLBACK EditWordBreakProc(

    LPTSTR lpch,	// pointer to edit text
    int ichCurrent,	// index of starting point
    int cch,	// length in characters of edit text
    int code 	// action to take
   );
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
begin
  SetString(s,lpch,cch);
  if Assigned(OldWordBreak) then
    result := OldWordBreak(lpch,ichCurrent,cch,code);
  if (code = WB_ISDELIMITER) and (ichCurrent>0) then
  begin
    if ByteToCharIndex(s,ichCurrent-1)=ByteToCharIndex(s,ichCurrent)
      then result:=integer(false)
      else result:=integer(true);
  end;
end;

{ TMemoEx }

procedure TMemoEx.CreateWnd;
var
  Proc : TWordBreakProc;
begin
  inherited CreateWnd;
  Proc := TWordBreakProc(Perform(EM_GETWORDBREAKPROC,0,0));
  if @Proc<>@WordBreak then
  begin
    OldWordBreak:=Proc;
    Perform(EM_SETWORDBREAKPROC,0,integer(@WordBreak));
  end;
end;

initialization
  OldWordBreak := nil;
end.
