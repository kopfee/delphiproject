unit RegUser;

interface

procedure Register;

implementation

uses Classes, AbilityManager, container, 
     CMUtils,dCMUtils, ComboLists, DBComboLists, BKGround,RTFUtils,Design,
			KeyCap, FontStyles, TreeItems,DBListOne,ExtDialogs,MovieViewer,
      SimpCtrls,GridEx,AMovieUtils, Datares,ProgressDlgs,
      Design2;

const
  UserEntry = 'Users';
  UserCtrlEntry = 'UserCtrls';

procedure Register;
begin
  RegisterComponents(UserEntry,
     [TAbilityManager,
     TSimpleAbilityManager,
     TGroupAbilityManager,
     TAbilityProvider,
     TSimpleAuthorityProvider,
     TDBAuthorityProvider]);
  RegisterComponents(UserCtrlEntry,[TContainerProxy]);
  RegisterSimpleModule(TContainer);
  RegisterComponents(UserCtrlEntry, [TCodeValues,TDBCodeValues,TComboList,TDBComboBoxList]);
  RegisterComponents(UserCtrlEntry, [TBackGround]);
  RegisterComponents(UserCtrlEntry,[TRichView,ThyperTextView]);
  RegisterComponents(UserCtrlEntry,[TDesigner,TDesigner2]);
  RegisterComponents(UserEntry, [TEnterKeyCapture]);
  RegisterComponents(UserEntry, [TFontStyles]);
  {RegisterComponents(UserEntry, [TRichEdit2]);
  RegisterComponents(UserEntry,[TRichView2,ThyperTextView2]);}
  RegisterComponents(UserEntry, [TFolderView]);
  RegisterComponents(UserCtrlEntry, [TDBListOne,TDBComboList]);
  RegisterComponents('Dialogs', [TPenDialog,TOpenDialogEx,TFolderDialog]);
  RegisterComponents(UserCtrlEntry,[TMovieWnd]);
  RegisterComponents(UserCtrlEntry,[TMovieView]);
  RegisterComponents('Standard', [TLabelX]);
  RegisterComponents('Additional', [TSpeedButtonX]);
  RegisterComponents(UserCtrlEntry, [TStringGridEx]);
  RegisterComponents(UserEntry, [TDatares]);
  RegisterComponents('Dialogs', [TProgrssWithReport]);
end;

end.
