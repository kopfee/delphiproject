unit KSBaseXReg;

{$I KSConditions.INC }

interface

procedure Register;

implementation

uses Classes, ActnList,
  ComWriUtils, CompUtils, compGroup, ShellUtils, FORecord,
  ClipbrdMon, KSNoteBooks, HotKeyMons, EditExts, KSHints, FilterCombos,
  KSActions
  {$ifdef VCL60_UP }
  ,VCLEditors, DesignIntf
  {$else}

  {$endif}
  ;

const
  UserEntry = 'Users';
  UserCtrlEntry = 'UserCtrls';

procedure Register;
begin
  RegisterComponents(UserEntry,[TSafeProcCaller]);
  registerComponents(UserEntry,[TComponentGroup]);
  registerComponents(UserEntry,[TAppearanceGroup]);
  registerComponents(UserCtrlEntry,[TAppearanceProxy]);
  RegisterComponents(UserEntry, [TTrayNotify,TMultiIcon]);
  RegisterComponents(UserEntry, [TShellFolder,TFileOperation]);
  RegisterComponents(UserEntry, [TFileOpenRecord]);
  RegisterActions('File',[TKSFileNew,TKSFileOpen,TKSFileSave,TKSFileSaveAs,TKSFileClose],nil);
  RegisterComponents(UserEntry,[TClipboardMonitor]);
  RegisterComponents(UserEntry,[THotKeyMonitor]);
  RegisterComponents(UserCtrlEntry, [TKSNoteBook]);
  RegisterComponents(UserCtrlEntry, [TKSDigitalEdit]);
  RegisterComponents(UserEntry,[THintMan]);
  RegisterComponents(UserCtrlEntry, [TKSFilterComboBox]);
  RegisterActions('ListBox',[TKSListMoveUp,TKSListMoveDown,TKSListDelete],nil);
  {$ifdef VCL60_UP }
  RegisterPropertyEditor(TypeInfo(TShortcut),THotKeyMonitor,'Shortcut',TShortCutProperty);
  {$else}

  {$endif}
end;

end.
