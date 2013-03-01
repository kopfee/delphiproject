unit NewReg1;

interface

procedure Register;

implementation

uses Classes,sysutils,BKGround,RTFUtils,Design,
			KeyCap,FontStyles,ShellUtils,NewComCtrls,RTFUtils2,
      TreeItems;

procedure Register;
begin
  RegisterComponents('users', [TBackGround]);
  RegisterComponents('users',[TRichView,ThyperTextView]);
  RegisterComponents('users',[TDesigner]);
  RegisterComponents('users', [TEnterKeyCapture]);
  RegisterComponents('users', [TFontStyles]);
  RegisterComponents('users', [TTrayNotify,TMultiIcon]);
  RegisterComponents('users', [TShellFolder,TFileOperation]);
  {RegisterComponents('users', [TRichEdit2]);
  RegisterComponents('users',[TRichView2,ThyperTextView2]);}
  RegisterComponents('users', [TFolderView]);
end;


end.
