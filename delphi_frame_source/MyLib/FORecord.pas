unit FORecord;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,ActnList;

const
  DefaultCaptionFormat = '%s - %s';

type
  TFileOpenRecord = class;

  TKSFileAction = class(TAction)
  private
    function  getFileOpenRecord(Target : TComponent): TFileOpenRecord;
  public
    function  HandlesTarget(Target: TObject): Boolean; override;
    procedure UpdateTarget(Target: TObject); override;
  end;

  TKSFileNew = class(TKSFileAction)
  public
    procedure ExecuteTarget(Target: TObject); override;
  end;

  TKSFileOpen = class(TKSFileAction)
  public
    procedure ExecuteTarget(Target: TObject); override;
  end;

  TKSFileSave = class(TKSFileAction)
  public
    procedure ExecuteTarget(Target: TObject); override;
  end;

  TKSFileSaveAs = class(TKSFileAction)
  public
    procedure ExecuteTarget(Target: TObject); override;
  end;

  TKSFileClose = class(TKSFileAction)
  public
    procedure ExecuteTarget(Target: TObject); override;
  end;

  TFileProcMethod = procedure (FORecord : TFileOpenRecord;
  		const FileName : string) of object;

  TFileOpenRecord = class(TComponent)
  private
    FFileNamed: boolean;
    FModified: boolean;
    FDefaultFileName: string;
    FFileName: string;
    FOnFileOpen: TFileProcMethod;
    FOnFileSave: TFileProcMethod;
    FOnFileNew: TNotifyEvent;
    FOpenDialog: TOpenDialog;
    FSaveDialog: TSaveDialog;
    FQuerySaveStr: string;
    FOnFileClose: TNotifyEvent;
    FBeforeFileOperate: TNotifyEvent;
    FAfterFileOperate: TNotifyEvent;
    FAutoChangeFormCaption: Boolean;
    FOnFileNameChanged: TNotifyEvent;
    FCaptionFormat: string;
    FOnStatusChanged: TNotifyEvent;
    FClosing : Boolean;
    { Private declarations }
    procedure   SetFileName(const Value: string);
    // when user click "yes" or "no" return true, click "cancel" is false
    procedure   SetOpenDialog(const Value: TOpenDialog);
    procedure   SetSaveDialog(const Value: TSaveDialog);
    procedure   DoBeforeFileOpt;
    procedure   DoAfterFileOpt;
    procedure   SetCaptionFormat(const Value: string);
    procedure   SetModified(const Value: boolean);
    procedure   SetDefaultFileName(const Value: string);
  protected
    { Protected declarations }
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure   Loaded; override;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    // in menu item-click handlers , call these procedures
    procedure   OnNewClick(sender : TObject);
    procedure   OnOpenClick(sender : TObject);
    procedure   OnSaveClick(sender : TObject);
    procedure	  OnSaveAsClick(sender : TObject);
    procedure   OnCloseClick(sender : TObject);
    procedure   FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    function	  QuerySave:boolean;
    procedure   UpdateFormCaption;
    // the property
    property 	  FileName : string Read FFileName Write SetFileName;
    property	  Modified : boolean	read FModified write SetModified;
    procedure   FileModified; // simple set Modified:=true
    property	  FileNamed : boolean read FFileNamed;
  published
    { Published declarations }
    property    OpenDialog : TOpenDialog read FOpenDialog write SetOpenDialog;
    property	  SaveDialog : TSaveDialog read FSaveDialog write SetSaveDialog;
    property	  DefaultFileName : string read FDefaultFileName write SetDefaultFileName;
    property	  QuerySaveStr : string read FQuerySaveStr write FQuerySaveStr;
    property    AutoChangeFormCaption : Boolean read FAutoChangeFormCaption write FAutoChangeFormCaption default True;
    property    CaptionFormat : string read FCaptionFormat write SetCaptionFormat;

    property	  OnFileNew : TNotifyEvent read FOnFileNew write FOnFileNew;
    property	  OnFileOpen : TFileProcMethod read FOnFileOpen	write FOnFileOpen;
    property	  OnFileSave : TFileProcMethod read FOnFileSave	write FOnFileSave;
    property    OnFileClose : TNotifyEvent read FOnFileClose write FOnFileClose;
    property    BeforeFileOperate : TNotifyEvent read FBeforeFileOperate write FBeforeFileOperate;
    property    AfterFileOperate : TNotifyEvent read FAfterFileOperate write FAfterFileOperate;
    property    OnFileNameChanged : TNotifyEvent read FOnFileNameChanged write FOnFileNameChanged;
    property    OnStatusChanged : TNotifyEvent read FOnStatusChanged write FOnStatusChanged;
  end;

implementation

{ TFileOpenRecord }

constructor TFileOpenRecord.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FModified := false;
  FFileNamed := false;
  FDefaultFileName := 'Nonamed';
  FQuerySaveStr := 'Do you want to save file ';
  FFileName := DefaultFileName;
  FAutoChangeFormCaption := True;
  FCaptionFormat := DefaultCaptionFormat;
  FClosing := false;
end;

procedure TFileOpenRecord.DoAfterFileOpt;
begin
  Modified := false;
  if assigned(FAfterFileOperate) then
    FAfterFileOperate(self);
end;

procedure TFileOpenRecord.DoBeforeFileOpt;
begin
  if assigned(FBeforeFileOperate) then
    FBeforeFileOperate(self);
end;

procedure TFileOpenRecord.FileModified;
begin
  Modified := true;
end;

procedure TFileOpenRecord.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if not FClosing then
  begin
    CanClose := QuerySave;
  end;
end;

procedure TFileOpenRecord.Loaded;
begin
  UpdateFormCaption;
end;

procedure TFileOpenRecord.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation=opRemove) then
    if AComponent=FOpenDialog then FOpenDialog:=nil else
      if AComponent=FSaveDialog then FSaveDialog:=nil;
end;

procedure TFileOpenRecord.OnCloseClick(sender: TObject);
begin
  try
    FClosing := True;
    DoBeforeFileOpt;
    if not QuerySave then
      abort else
      if Assigned(FOnFileClose) then FOnFileClose(self);
    DoAfterFileOpt;
  finally
    FClosing := False;
  end;
end;

procedure TFileOpenRecord.OnNewClick(sender: TObject);
begin
  DoBeforeFileOpt;
  if QuerySave then
  begin
    //Modified := false;
	  FileName := DefaultFileName;
    FFileNamed := false;
    if Assigned(FOnFileNew) then FOnFileNew(self);
    DoAfterFileOpt;
  end;
end;

procedure TFileOpenRecord.OnOpenClick(sender: TObject);
begin
  DoBeforeFileOpt;
  if Assigned(FOpenDialog)
  	and Assigned(FOnFileOpen) then
  if FOpenDialog.execute and QuerySave then
  begin
    //Modified := false;
	  //FFileNamed := true;
  	FileName := FOpenDialog.filename;
    FOnFileOpen(self,Filename);
    DoAfterFileOpt;
  end;
end;

procedure TFileOpenRecord.OnSaveAsClick(sender: TObject);
begin
  DoBeforeFileOpt;
  if Assigned(FSaveDialog)
  	and Assigned(FOnFileSave) then
  begin
    FSaveDialog.Filename := filename;
    if FSaveDialog.execute then
    begin
      //Modified := false;
		  FFileNamed := true;
  		FileName := FSaveDialog.filename;
      OnFileSave(self,FileName);
      DoAfterFileOpt;
    end;
  end;
end;

procedure TFileOpenRecord.OnSaveClick(sender: TObject);
begin
  DoBeforeFileOpt;
  if not FFileNamed then
  	OnSaveAsClick(sender)
  else
  begin
    if Assigned(FOnFileSave) then FOnFileSave(self,Filename);
    DoAfterFileOpt;
  end;
end;

function TFileOpenRecord.QuerySave: boolean;
var
  Choice : word;
begin
  if Modified then
  begin
    choice:=MessageDlg(FQuerySaveStr+filename+' ?',mtInformation,
  		[mbYes,mbNo,mbCancel],0);
	  if choice=mrYes then OnSaveClick(self);
  	result := choice<>mrCancel;
  end else
    result := true;
end;

procedure TFileOpenRecord.SetCaptionFormat(const Value: string);
begin
  FCaptionFormat := Value;
  UpdateFormCaption;
end;

procedure TFileOpenRecord.SetDefaultFileName(const Value: string);
begin
  if DefaultFileName <> Value then
  begin
    FDefaultFileName := Value;
    if not FFileNamed then
      FFileName := Value; // ±£³ÖÎ´ÃüÃû×´Ì¬
  end;
end;

procedure TFileOpenRecord.SetFileName(const Value: string);
begin
  if FileName <> Value then
  begin
    FFileName := Value;
    if Assigned(FOnFileNameChanged) then
      FOnFileNameChanged(Self);
    UpdateFormCaption; 
  end;
  FFileNamed := True;
end;

procedure TFileOpenRecord.SetModified(const Value: boolean);
begin
  if Modified <> Value then
  begin
    FModified := Value;
    if Assigned(FOnStatusChanged) then
      FOnStatusChanged(Self);
  end;
end;

procedure TFileOpenRecord.SetOpenDialog(const Value: TOpenDialog);
begin
  if FOpenDialog <> Value then
  begin
    FOpenDialog := Value;
    if FOpenDialog <>nil then
      FOpenDialog.FreeNotification(self);
  end;
end;

procedure TFileOpenRecord.SetSaveDialog(const Value: TSaveDialog);
begin
  if FSaveDialog <> Value then
  begin
    FSaveDialog := Value;
    if FSaveDialog<>nil then
      FSaveDialog.FreeNotification(self);
  end;
end;

procedure TFileOpenRecord.UpdateFormCaption;
begin
  if (Owner is TCustomForm) and not (csDesigning in ComponentState) then
    TCustomForm(Owner).Caption := Format(CaptionFormat,[Application.Title,FileName]);
end;

{ TKSFileAction }

function TKSFileAction.getFileOpenRecord(
  Target: TComponent): TFileOpenRecord;
var
  i : integer;
begin
  result := nil;
  for i:=0 to Target.ComponentCount-1 do
    if Target.Components[i] is TFileOpenRecord then
    begin
      result := TFileOpenRecord(Target.Components[i]);
      break;
    end;
end;

function TKSFileAction.HandlesTarget(Target: TObject): Boolean;
begin
  if (Target is TCustomForm) or (Target is TDataModule) then
    result := getFileOpenRecord(TComponent(Target))<>nil else
    result := false;
end;

procedure TKSFileAction.UpdateTarget(Target: TObject);
begin

end;

{ TKSFileNew }

procedure TKSFileNew.ExecuteTarget(Target: TObject);
var
  fo : TFileOpenRecord;
begin
  fo := getFileOpenRecord(TComponent(Target));
  if fo<>nil then fo.OnNewClick(nil);
end;

{ TKSFileOpen }

procedure TKSFileOpen.ExecuteTarget(Target: TObject);
var
  fo : TFileOpenRecord;
begin
  fo := getFileOpenRecord(TComponent(Target));
  if fo<>nil then fo.OnOpenClick(nil);
end;

{ TKSFileSave }

procedure TKSFileSave.ExecuteTarget(Target: TObject);
var
  fo : TFileOpenRecord;
begin
  fo := getFileOpenRecord(TComponent(Target));
  if fo<>nil then fo.OnSaveClick(nil);
end;

{ TKSFileSaveAs }

procedure TKSFileSaveAs.ExecuteTarget(Target: TObject);
var
  fo : TFileOpenRecord;
begin
  fo := getFileOpenRecord(TComponent(Target));
  if fo<>nil then fo.OnSaveAsClick(nil);
end;

{ TKSFileClose }

procedure TKSFileClose.ExecuteTarget(Target: TObject);
var
  fo : TFileOpenRecord;
begin
  fo := getFileOpenRecord(TComponent(Target));
  if fo<>nil then fo.OnCloseClick(nil);
end;

end.
