unit IDEDlgs;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExptIntf,TypUtils,ExtDialogs,ToolIntf;

procedure InstallDlgs;
procedure UnInstallDlgs;

function  isInstalled : boolean;

procedure TestDlg;

//procedure InstallEditorDlg(Editor : TCustomForm);

implementation

const
  MainFormClassName = 'TAppBuilder';
  OpenDialogName = 'OpenFileDialog';
  SaveDialogName = 'SaveFileDialog';

  EditorOpenDialogName = 'OpenFileDlg';
  EditorSaveDialogName = 'SaveFileDlg';
  EditorClassName = 'TEditWindow';

var
  MainForm : TCustomForm;
  OldOpenDialog : TOpenDialog;
  OldSaveDialog : TSaveDialog;
  NewOpenDialog : TOpenDialogEx;
  NewSaveDialog : TOpenDialogEx;
  (*OldEditorOpenDialog : TOpenDialog;
  OldEditorSaveDialog : TSaveDialog;*)

type
  TObjectPointer = ^TObject;
  (*TDebugDialog = class
  public
    class procedure DoShow(sender : TObject);
  end; *)

function FindMainForm : TCustomForm;
var
  i : integer;
begin
  // Find Main Form
  result := nil;
  for i:=0 to Screen.FormCount-1 do
    if Screen.Forms[i].ClassNameIs(MainFormClassName) then
    begin
      result := Screen.Forms[i];
      break;
    end;
end;
(*
procedure CheckEditorDlg;
var
  i : integer;
  Editor : TCustomForm;
begin
    showMessage('Check');
    for i:=0 to Screen.FormCount-1 do
    if Screen.Forms[i].ClassNameIs(EditorClassName) then
    begin
      Editor := Screen.Forms[i];
      showMessage('Find Editor!');
      InstallEditorDlg(Editor);
    end;
end;
*)
procedure InstallDlgs;
var
  Address1,Address2 : TObjectPointer;
begin
  UninstallDlgs;
  OldOpenDialog:=nil;
  OldSaveDialog:=nil;
  MainForm := nil;

  MainForm := FindMainForm;
  if MainForm<>nil then
  begin
    {OldOpenDialog:=TOpenDialog(GetClassProperty(MainForm,OpenDialogName));
    OldSaveDialog:=TSaveDialog(GetClassProperty(MainForm,SaveDialogName));}
    Address1 := TObjectPointer(MainForm.FieldAddress(OpenDialogName));
    Address2 := TObjectPointer(MainForm.FieldAddress(SaveDialogName));
    //if (OldOpenDialog<>nil) and (OldSaveDialog<>nil) then
    if (Address1<>nil) and (Address2<>nil) then
    begin
      OldOpenDialog:=TOpenDialog(Address1^);
      OldSaveDialog:=TSaveDialog(Address2^);
      NewOpenDialog := TOpenDialogEx.Create(nil);
      NewSaveDialog := TOpenDialogEx.Create(nil);
      with NewOpenDialog do
      begin
        NewStyle := true;
        IsSaveDialog := false;
        Name := OpenDialogName;
        Options := OldOpenDialog.Options;
        DefaultExt:=OldOpenDialog.DefaultExt;
        Title := OldOpenDialog.Title;
        FileName := OldOpenDialog.FileName;
        FileEditStyle := OldOpenDialog.FileEditStyle;
        Filter  := OldOpenDialog.Filter;
        FilterIndex := OldOpenDialog.FilterIndex;
      end;
      with NewSaveDialog do
      begin
        NewStyle := true;
        IsSaveDialog := true;
        Name := SaveDialogName;
        Options := OldSaveDialog.Options;
        DefaultExt:=OldSaveDialog.DefaultExt;
        Title := OldSaveDialog.Title;
        FileName := OldSaveDialog.FileName;
        FileEditStyle := OldSaveDialog.FileEditStyle;
        Filter  := OldSaveDialog.Filter;
        FilterIndex := OldSaveDialog.FilterIndex;
      end;
      //SetClassProperty(MainForm,OpenDialogName,NewOpenDialog);
      //SetClassProperty(MainForm,SaveDialogName,NewSaveDialog);
      Address1^ := NewOpenDialog;
      Address2^ := NewSaveDialog;
      //ShowMessage('Installed!');
      //OldOpenDialog.Options := OldOpenDialog.Options-[ofShowHelp];
      //OldSaveDialog.Options := OldSaveDialog.Options-[ofShowHelp];
      (*CheckEditorDlg;*)
    end;
  end;
end;

procedure UnInstallDlgs;
var
  Address1,Address2 : TObjectPointer;
begin
  if isInstalled then
    if MainForm=FindMainForm then
    begin
      Address1 := TObjectPointer(MainForm.FieldAddress(OpenDialogName));
      Address2 := TObjectPointer(MainForm.FieldAddress(SaveDialogName));
      if (Address1<>nil) and (Address2<>nil) then
      begin
        Address1^ := OldOpenDialog;
        Address2^ := OldSaveDialog;
        NewOpenDialog.free;
        NewSaveDialog.free;
        //ShowMessage('UnInstalled!');
      end;
    end;
  MainForm:=nil;
  OldOpenDialog:=nil;
  OldSaveDialog:=nil;
end;


function  isInstalled : boolean;
begin
  result :=  (MainForm<>nil) and (OldOpenDialog<>nil) and (OldSaveDialog<>nil);
end;

procedure TestDlg;
begin
  if isInstalled then
  begin
    OldOpenDialog.Execute;
    OldSaveDialog.Execute;
    (*if OldEditorOpenDialog<>nil then
    begin
      OldEditorOpenDialog.Execute;
      OldEditorSaveDialog.Execute;
    end;*)
  end;

end;
(*
type
  TFileOperationNotifier = class(TIAddInNotifier)
  public
    procedure FileNotification(NotifyCode: TFileNotification;
      const FileName: string; var Cancel: Boolean); override; stdcall;
    procedure EventNotification(NotifyCode: TEventNotification;
      var Cancel: Boolean); override; stdcall;
  end;

var
  FileOperationNotifier : TFileOperationNotifier=nil;
*)
(*
procedure InstallEditorDlg(Editor : TCustomForm);
var
  Address1,Address2 : TObjectPointer;
  NewEditorSaveDialog : TOpenDialogEx;
  NewEditorOpenDialog : TOpenDialogEx;
begin
    Address2 := TObjectPointer(Editor.FieldAddress(EditorSaveDialogName));
    Address1 := TObjectPointer(Editor.FieldAddress(EditorOpenDialogName));
    if (Address1<>nil) and (Address2<>nil) then
    begin
      //ShowMessage('Find Addr');
      OldEditorOpenDialog:=TOpenDialog(Address1^);
      OldEditorSaveDialog:=TSaveDialog(Address2^);
      //if OldEditorSaveDialog is TOpenDialogEx then exit;
      if OldEditorSaveDialog.ClassNameIs('TOpenDialogEx') then
      begin
        ShowMessage('Has Installed');
        exit;
      end;
      NewEditorOpenDialog := TOpenDialogEx.Create(nil);
      NewEditorSaveDialog := TOpenDialogEx.Create(nil);
      with NewEditorOpenDialog do
      begin
        NewStyle := true;
        IsSaveDialog := true;
        Name := EditorOpenDialogName;
        Options := OldEditorOpenDialog.Options;
        DefaultExt:=OldEditorOpenDialog.DefaultExt;
        Title := OldEditorOpenDialog.Title;
        FileName := OldEditorOpenDialog.FileName;
        FileEditStyle := OldEditorOpenDialog.FileEditStyle;
        Filter  := OldEditorOpenDialog.Filter;
        FilterIndex := OldEditorOpenDialog.FilterIndex;
      end;
      with NewEditorSaveDialog do
      begin
        NewStyle := true;
        IsSaveDialog := true;
        Name := EditorSaveDialogName;
        Options := OldEditorSaveDialog.Options;
        DefaultExt:=OldEditorSaveDialog.DefaultExt;
        Title := OldEditorSaveDialog.Title;
        FileName := OldEditorSaveDialog.FileName;
        FileEditStyle := OldEditorSaveDialog.FileEditStyle;
        Filter  := OldEditorSaveDialog.Filter;
        FilterIndex := OldEditorSaveDialog.FilterIndex;
      end;
      //ShowMessage('Create');
      //OldEditorSaveDialog.FileEditStyle := fsComboBox;
      OldEditorOpenDialog.Options := OldEditorOpenDialog.Options-[ofShowHelp];
      OldEditorSaveDialog.Options := OldEditorSaveDialog.Options-[ofShowHelp];
      //OldEditorSaveDialog.free;
      //Address1^ := NewEditorSaveDialog;
      //NewEditorSaveDialog.Name := EditorSaveDialogName;
      //NewEditorSaveDialog.Name := EditorOpenDialogName;
      ShowMessage('Editor Dialog Installed!');
    end;
end;
*)
{ TFileOperationNotifier }
(*
procedure TFileOperationNotifier.EventNotification(
  NotifyCode: TEventNotification; var Cancel: Boolean);
begin
  //
end;

procedure TFileOperationNotifier.FileNotification(
  NotifyCode: TFileNotification; const FileName: string;
  var Cancel: Boolean);
begin
  if (NotifyCode=fnFileOpened) and isInstalled then
    CheckEditorDlg;
end;

{ TDebugDialog }

class procedure TDebugDialog.DoShow(sender: TObject);
begin
  ShowMessage('OK');
end;
*)
initialization
  InstallDlgs;
  (*if ToolServices<>nil then
  begin
    FileOperationNotifier := TFileOperationNotifier.Create;
    ToolServices.AddNotifier(FileOperationNotifier);
  end;*)

finalization
  (*if (ToolServices<>nil) and (FileOperationNotifier<>nil) then
  begin
    ToolServices.RemoveNotifier(FileOperationNotifier);
    FileOperationNotifier.free;
  end;*)

  UNInstallDlgs;
end.
