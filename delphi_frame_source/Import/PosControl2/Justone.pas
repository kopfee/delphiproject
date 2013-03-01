{
  JustOne v2.0
  Modified by: Eric Pankoke
  email: epankoke@cencom.net

  Changes
           - Written for Delphi 2.0
           - PerformAction was added
           - Previous version info moved to readme.txt

  This component is designed to prevent users from being able to open
  multiple instances of your applications designed with Delphi 2.0.
  Just drop the component into your form, tell it whether to reactivate
  the original instance or just send it a message, and you're ready
  to go.
}
unit Justone;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DsgnIntf;

type
  TJustOne = class(TComponent)
    private
      FAbout: string;
      FSendMsg: string;
    public
      FMessageID: DWORD;

      constructor Create(AOwner:TComponent); override;
      procedure Loaded; override;
      destructor Destroy; override;
      procedure GoToPreviousInstance;
      procedure ShowAbout;
    published
      property About: string read FAbout write FAbout stored False;
      property SendMsg: string read FSendMsg write FSendMsg;
  end;

procedure Register;

type
  PHWND = ^HWND;

implementation

{########################################################################}
type
  TAboutProperty = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue:string; override;
  end;

{########################################################################}
procedure TAboutProperty.Edit;
{Invoke the about dialog when clicking on ... in the Object Inspector}
begin
  TJustOne(GetComponent(0)).ShowAbout;
end;

{########################################################################}
function TAboutProperty.GetAttributes: TPropertyAttributes;
{Make settings for just displaying a string in the ABOUT property in the
Object Inspector}
begin
  GetAttributes := [paDialog, paReadOnly];
end;

{########################################################################}
function TAboutProperty.GetValue: String;
{Text in the Object Inspector for the ABOUT property}
begin
  GetValue := '(About)';
end;

{########################################################################}
procedure TJustOne.ShowAbout;
var
  msg: string;
const
  carriage_return = chr(13);
  copyright_symbol = chr(169);
begin
  msg := 'JustOne  v2.0';
  AppendStr(msg, carriage_return);
  AppendStr(msg, 'A Freeware component');
  AppendStr(msg, carriage_return);
  AppendStr(msg, carriage_return);
  AppendStr(msg, 'Copyright ');
  AppendStr(msg, copyright_symbol);
  AppendStr(msg, ' 1995, 1996 by Steven L. Keyser');
  AppendStr(msg, carriage_return);
  AppendStr(msg, 'e-mail 71214.3117@compuserve.com');
  AppendStr(msg, carriage_return);
  AppendStr(msg, 'and Eric Pankoke (for v2.0 upgrade)');
  AppendStr(msg, carriage_return);
  AppendStr(msg, 'e-mail epankoke@cencom.net');
  AppendStr(msg, carriage_return);
  ShowMessage(msg);
end;

{########################################################################}
procedure Register;
{If you want, replace 'SLicK' with whichever component page you want
JustOne to show up on.}
begin
  RegisterComponents('PosControl2', [TJustOne]);
  RegisterPropertyEditor(TypeInfo(String), TJustOne, 'About',
  	TAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TJustOne, 'SendMsg',
                         TStringProperty);
end;

{########################################################################}
procedure TJustOne.GotoPreviousInstance;
begin
  PostMessage(hwnd_Broadcast, FMessageID, 0, 0);
end;

{########################################################################}
constructor TJustOne.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
end;

{########################################################################}
procedure TJustOne.Loaded;
var
  hMapping: HWND;
  tmp: PChar;
begin
  inherited Loaded;
  GetMem(tmp, Length(FSendMsg) + 1);
  StrPCopy(tmp, FSendMsg);
  FMessageID := RegisterWindowMessage(tmp);
  FreeMem(tmp);
  hMapping := CreateFileMapping(HWND($FFFFFFFF), nil,
                                PAGE_READONLY, 0, 32, 'JustOne Map');
  if (hMapping <> NULL) and (GetLastError <> 0) then
  begin
    if not (csDesigning in ComponentState) then
    begin
      GotoPreviousInstance;
      halt;
    end;
  end;
end;

{########################################################################}
destructor TJustOne.Destroy;
begin
  inherited Destroy;
end;

{########################################################################}
end.
