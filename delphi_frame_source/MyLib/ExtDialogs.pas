unit ExtDialogs;
{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>ExtDialogs
   <What>包含扩充的对话框
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

interface

uses
  Windows, Messages, SysUtils, Classes,
  Graphics, Controls, Forms, CommDlg,Dialogs,
  Buttons,StdCtrls,ExtCtrls;

type
  // %TPenDialog : 设置Pen属性的对话框
  TPenDialog = class(TComponent)
  private
    { Private declarations }
    FTitle: string;
    FPen: TPen;
    procedure SetPen(const Value: TPen);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor  destroy; override;
    function    Execute : boolean;
  published
    { Published declarations }
    property    Title : string read FTitle write FTitle;
    property    Pen : TPen read FPen write SetPen;
  end;

type
  // %TCustomOpenDialogEx : 扩充OpenDialog,具有收藏夹功能
  TCustomOpenDialogEx = class(TSaveDialog)
  private
    btnGoFavorites : TBitBtn;
    btnAddFavorites : TBitBtn;
    btnAddFavorites2 : TBitBtn;
    Panel : TPanel;
    FirstExecute : boolean;
    FStartInFavorites: boolean;
    FNewStyle: boolean;
    FIsSaveDialog: boolean;
    FTextCtrl: TControl;
    procedure   btnGoFavoritesClick(Sender : TObject);
    procedure   btnAddFavoritesClick(Sender : TObject);
    procedure   btnAddFavorites2Click(Sender : TObject);
    procedure   AddFavorite(InputName : boolean);
    procedure   SetTextCtrl(const Value: TControl);
    function    IsValidFileName(const AFileName:string): boolean;
  protected
    FButtonCount : integer;
    FTopDelta : integer;
    FLastFileName : string;
    procedure   DoClose; override;
    procedure   DoShow; override;
    // cannot OK when file is *.lnk
    function    DoCanClose: Boolean; Override;
    property    StartInFavorites : boolean
                  read FStartInFavorites write FStartInFavorites default false;
    property    NewStyle : boolean read FNewStyle write FNewStyle default true;
    property    IsSaveDialog : boolean read FIsSaveDialog write FIsSaveDialog default false;
    procedure   DoSelectionChange; override;
    // %TextCtrl : 显示/保存文件名的EditBox
    property    TextCtrl : TControl read FTextCtrl write SetTextCtrl;
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;

    function    TaskModalDialog(DialogFunc: Pointer; var DialogData): Bool; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    function    Execute: Boolean; override;
    function    FolderPath : string;
  published

  end;

  TOpenDialogEx = class(TCustomOpenDialogEx)
  public
    function    Execute: Boolean; override;
  published
    property    StartInFavorites;
    property    NewStyle;
    property    IsSaveDialog;
    property    TextCtrl;
  end;

var
  // %FavoritesDir : 收藏夹目录
  FavoritesDir : string;

type
  // %TFolderDialog : 选择目录的对话框
  TFolderDialog = class(TCustomOpenDialogEx)
  private
    FFolder:  string;
    btnOK,btnCancel : TBitBtn;
    FConfirm : boolean;
    procedure   SetFolder(const Value: string);
    procedure   btnOKClick(sender : TObject);
    procedure   btnCancelClick(sender : TObject);
    procedure   Close;
  protected
    procedure   DoFolderChange; override;
    procedure   DoShow; override;
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    function    Execute: Boolean; override;
  published
    property    Folder : string read FFolder Write SetFolder;
    property    TextCtrl;
  end;

resourcestring

{$define china}

{$ifdef china}
  SGoFavorites = '转到收藏夹';
  SAddFavorites = '将当前路径增加到收藏夹';
  SAddFavorites2 = '将当前路径以输入的名字增加到收藏夹';
  SInputCaption = '输入新建链接的名称';
  SInputPrompt = '链接';
  SOK = '确认';
  SCancel = '取消';
{$else}
  SGoFavorites = 'Go Favorites';
  SAddFavorites = 'Add This Folder To Favorites';
  SAddFavorites2 = 'Add This Folder To Favorites With Input Name';
  SInputCaption = 'Input New Shortcut Name';
  SInputPrompt = 'Shortcut';
  SOK = 'OK';
  SCancel = 'Cancel';
{$endif}

implementation

uses PenCfgDlg,KSStrUtils,ExtUtils, FileCtrl,ShellUtils,ComWriUtils;

{$R *.res }

{$R DLGTemplate.res }

{ TPenDialog }

constructor TPenDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPen := Tpen.create;
end;

destructor TPenDialog.destroy;
begin
  FPen.free;
  inherited destroy;
end;

function TPenDialog.Execute: boolean;
var
  Dialog : TdlgPenCfg;
begin
  Dialog := TdlgPenCfg.Create(Application);
  try
    Dialog.Caption := Title;
    result := Dialog.Execute(FPen);
  finally
    Dialog.free;
  end;
end;

procedure TPenDialog.SetPen(const Value: TPen);
begin
  FPen.Assign(Value);
end;

const
  BtnCount = 3;
  BtnSize = 36;
  PanelWidth = 44;
  BtnSpace = (PanelWidth-BtnSize) div 2;
  PanelHeight = BtnSpace*(1+BtnCount) + BtnSize*BtnCount;

{ TCustomOpenDialogEx }

constructor TCustomOpenDialogEx.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIsSaveDialog := false;
  FNewStyle := true;
  FirstExecute := true;
  FButtonCount := 3;
  FTopDelta := 38;
  Panel := TPanel.Create(self);
  with Panel do
  begin
    BevelInner := bvLowered;
    BevelOuter := bvNone;
    //BorderWidth := 2;
  end;
  btnGoFavorites := TBitBtn.Create(self);
  with btnGoFavorites do
  begin
    SetBounds(BtnSpace,BtnSpace,BtnSize,BtnSize);
    //Caption := 'G';
    Parent:=Panel;
    Hint := SGoFavorites;
    ShowHint := true;
    Glyph.LoadFromResourceName(hinstance,'GOTOFAVORITES');
    OnClick := btnGoFavoritesClick;
  end;
  btnAddFavorites := TBitBtn.Create(self);
  with btnAddFavorites do
  begin
    SetBounds(BtnSpace,BtnSpace*2+BtnSize,BtnSize,BtnSize);
    //Caption := 'A';
    Parent:=Panel;
    Hint := SAddFavorites;
    ShowHint := true;
    Glyph.LoadFromResourceName(hinstance,'ADDFOLDERTOFAVORITES');
    OnClick := btnAddFavoritesClick;
  end;
  btnAddFavorites2 := TBitBtn.Create(self);
  with btnAddFavorites2 do
  begin
    SetBounds(BtnSpace,BtnSpace*3+BtnSize*2,BtnSize,BtnSize);
    //Caption := 'A';
    Parent:=Panel;
    Hint := SAddFavorites2;
    ShowHint := true;
    Glyph.LoadFromResourceName(hinstance,'ADDFOLDERTOFAVORITES2');
    OnClick := btnAddFavorites2Click;
  end;
end;

destructor TCustomOpenDialogEx.Destroy;
begin
  btnGoFavorites.free;
  Panel.free;
  inherited Destroy;
end;

procedure TCustomOpenDialogEx.DoClose;
begin
  inherited DoClose;
  { Hide any hint windows left behind }
  Application.HideHint;
end;


procedure TCustomOpenDialogEx.DoShow;
var
  PreviewRect, StaticRect: TRect;
  DialogHandle : THandle;
  DialogRect : TRect;
  DeltaWidth : integer;
begin
  if NewStyle then
  begin
    { Set preview area to entire dialog }
    GetClientRect(Handle, PreviewRect);
    StaticRect := GetStaticRect;
    { Move preview area to right of static area }
    PreviewRect.Left := StaticRect.Left + (StaticRect.Right - StaticRect.Left);
    Inc(PreviewRect.Top, FTopDelta);

    // adjust the size of PreviewRect

    DeltaWidth := PreviewRect.right - PreviewRect.left - PanelWidth - BtnSpace;
    PreviewRect.right := PreviewRect.left + PanelWidth;
    //PreviewRect.bottom := PreviewRect.Top + PanelHeight;
    PreviewRect.bottom := PreviewRect.Top +
      BtnSpace*(1+FButtonCount) + BtnSize*FButtonCount;

    Panel.BoundsRect := PreviewRect;
    Panel.ParentWindow := Handle;

    DialogHandle := GetParent(Handle);
    GetWindowRect(DialogHandle,DialogRect);
    MoveWindow(DialogHandle,
      DialogRect.left,
      DialogRect.Top,
      DialogRect.Right-DialogRect.left-DeltaWidth,
      DialogRect.Bottom-DialogRect.Top,false);
  end;
  inherited DoShow;
end;

function TCustomOpenDialogEx.Execute: Boolean;
begin
  FLastFileName := ExtractFileName(FileName);
  if not IsValidFileName(FileName) then
    FileName:='';
  if NewStyle then
  begin
    {if StartInFavorites or (FirstExecute and (InitialDir='') and (FileName='')) then
      InitialDir := FavoritesDir;}
    if StartInFavorites then
      InitialDir := FavoritesDir
    else
      if FirstExecute and (InitialDir='') and (FileName='')
            and not (ofNoChangeDir in Options) then
         SetCurrentDir(FavoritesDir);
    FirstExecute := false;
    if NewStyleControls and not (ofOldStyleDialog in Options) then
      Template := 'DLGTEMPLATEEX' else
      Template := nil;
  end
  else Template := nil;

  if Template<>nil then
  begin
    if FindResource(HInstance,Template,RT_DIALOG)=0 then
    begin
      Template:=nil;
      assert(false);
    end;
  end;

  (*
  {$ifdef debugDlg }
  if Template=nil then ShowMessage('No Template')
  else ShowMessage('Has Template');
  {$endif}
  *)
  //result:=inherited Execute;

  {$ifdef debugDlg }
  if FIsSaveDialog then
    ShowMessage('Execute save Dialog')
  else
    ShowMessage('Execute open Dialog');
  {$endif}

  if FIsSaveDialog then
    Result := DoExecute(@GetSaveFileName)
  else
    Result := DoExecute(@GetOpenFileName);
end;

procedure TCustomOpenDialogEx.btnGoFavoritesClick(Sender: TObject);
var
  DialogHandle : THandle;
  OriginEditText : array[0..Max_Path] of char;
begin
  DialogHandle := getParent(Handle);
  // get origin text of editbox
  SendDlgItemMessage(DialogHandle,
    $480,
    WM_GetText,
    Max_Path,
    LParam(pchar(@OriginEditText)));
  // set "FileName" EditBox Text
  SendMessage(DialogHandle,
    CDM_SETCONTROLTEXT,
    $480,
    LParam(pchar(FavoritesDir))
  );
  // Click "Open" Button
  SendDlgItemMessage(DialogHandle,1,BM_Click,0,0);
  // set origin text of editbox
  SendMessage(DialogHandle,
    CDM_SETCONTROLTEXT,
    $480,
    LParam(pchar(@OriginEditText))
  );
end;

function TCustomOpenDialogEx.FolderPath: string;
var
  Path: array[0..MAX_PATH] of Char;
begin
  if NewStyleControls and (Handle <> 0) then
  begin
    SendMessage(GetParent(Handle), CDM_GETFOLDERPATH, SizeOf(Path), Integer(@Path));
    Result := StrPas(Path);
  end
  else Result := '';
end;

procedure TCustomOpenDialogEx.btnAddFavoritesClick(Sender: TObject);
begin
  AddFavorite(false);
end;

procedure TCustomOpenDialogEx.btnAddFavorites2Click(Sender: TObject);
begin
  AddFavorite(true);
end;

procedure TCustomOpenDialogEx.AddFavorite(InputName : boolean);
var
  TheFolder : string;
  StoreLinkFile : string;
  StoreName : string;
begin
  TheFolder:=FolderPath;
  if TheFolder<>'' then
  begin
    StoreName := ExtractOnlyFileName(TheFolder);
    if InputName then
      if InputQuery(SInputCaption,SInputPrompt,StoreName) then
      begin
        if StoreName='' then StoreName := ExtractOnlyFileName(TheFolder);
      end
      else
        // cancel by user
        exit;
    StoreLinkFile:=AddPathAndName(FavoritesDir,StoreName+'.LNK');
    StoreLinkFile:=GetNewName(StoreLinkFile);
    CreateLink(StoreLinkFile,TheFolder,'');
  end;
end;

procedure TCustomOpenDialogEx.DoSelectionChange;
var
  F : string;
begin
  inherited DoSelectionChange;
  if (ofNoDereferenceLinks in Options) then exit;
  F := FileName;
  if CompareText(ExtractFileExt(F),'.LNK')=0 then
  begin
    SendMessage(GetParent(Handle),
      CDM_SETCONTROLTEXT,
      $480,
      LParam(pchar(FLastFileName))
    );
  end
  else
    FLastFileName := ExtractFileName(F);
end;

function TCustomOpenDialogEx.DoCanClose: Boolean;
begin
  result := inherited DoCanClose;
  if result then
    result:=(ofNoDereferenceLinks in Options)
      or (CompareText(ExtractFileExt(FileName),'.LNK')<>0);
end;

procedure TCustomOpenDialogEx.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (AComponent=FTextCtrl) and (Operation=opRemove) then
    FTextCtrl:=nil;
  Inherited Notification(AComponent,Operation);
end;

procedure TCustomOpenDialogEx.SetTextCtrl(const Value: TControl);
begin
  if FTextCtrl <> Value then
  begin
    FTextCtrl := Value;
    if FTextCtrl<>nil then
      FTextCtrl.FreeNotification(self);
  end;
end;

function TCustomOpenDialogEx.IsValidFileName(
  const AFileName: string): boolean;
begin
  if AFileName='' then result:=true
  else result:=not (AFileName[length(AFileName)] in [':','\','/']);
end;

function TCustomOpenDialogEx.TaskModalDialog(DialogFunc: Pointer;
  var DialogData): Bool;
begin
  TOpenFilename(DialogData).hInstance := SysInit.HInstance;
  result := inherited TaskModalDialog(DialogFunc,DialogData);
end;

{ TOpenDialogEx }

function TOpenDialogEx.Execute: Boolean;
begin
  {$ifdef debugDlg }
  ShowMessage('TOpenDialogEx.Execute');
  {$endif}

  if TextCtrl<>nil then
    FileName := GetCtrlText(TextCtrl);
  result := inherited Execute;
  if result and (TextCtrl<>nil) then SetCtrlText(TextCtrl,FileName);
end;

{ TFolderDialog }

constructor TFolderDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inc(FButtonCount,2);
  FTopDelta := 4;
  btnOK:= TBitBtn.Create(self);
  with btnOK do
  begin
    SetBounds(BtnSpace,BtnSpace*4+BtnSize*3,BtnSize,BtnSize);
    Parent:=Panel;
    Hint := SOK;
    ShowHint := true;
    Glyph.LoadFromResourceName(hinstance,'DLGOK');
    //NumGlyphs:=2;
    OnClick := btnOKClick;
  end;

  btnCancel:= TBitBtn.Create(self);
  with btnCancel do
  begin
    SetBounds(BtnSpace,BtnSpace*5+BtnSize*4,BtnSize,BtnSize);
    Parent:=Panel;
    Hint := SCancel;
    ShowHint := true;
    Glyph.LoadFromResourceName(hinstance,'DLGCancel');
    //NumGlyphs:=2;
    OnClick := btnCancelClick;
  end;
end;

procedure TFolderDialog.btnCancelClick(sender: TObject);
begin
  FConfirm := false;
  Close;
end;

procedure TFolderDialog.btnOKClick(sender: TObject);
begin
  FConfirm := true;
  FFolder := FolderPath;
  Close;
end;

function TFolderDialog.Execute: Boolean;
begin
  if TextCtrl<>nil then
    FFolder := GetCtrlText(TextCtrl);

  InitialDir := FFolder;
  FConfirm := false;
  inherited Execute;
  result := FConfirm;

  if result and (TextCtrl<>nil) then SetCtrlText(TextCtrl,FFolder);
end;

procedure TFolderDialog.SetFolder(const Value: string);
begin
  FFolder := Value;
end;

destructor TFolderDialog.Destroy;
begin
  btnOK.free;
  btnCancel.free;
  inherited Destroy;
end;

procedure TFolderDialog.Close;
var
  DialogHandle : THandle;
begin
  DialogHandle := getParent(Handle);
  // Click "Cancel" Button
  SendDlgItemMessage(DialogHandle,2,BM_Click,0,0);
end;

procedure TFolderDialog.DoFolderChange;
begin
  inherited DoFolderChange;
end;

procedure TFolderDialog.DoShow;
var
  DialogHandle : THandle;
begin
  DialogHandle := getParent(Handle);
  SendMessage(DialogHandle,CDM_HIDECONTROL,1,0);
  SendMessage(DialogHandle,CDM_HIDECONTROL,2,0);
  {// help Button
  SendMessage(DialogHandle,CDM_HIDECONTROL,$40e,0);}
  inherited DoShow;
end;

initialization
  setLength(FavoritesDir,MAX_PATH);
  GetWindowsDirectory(pchar(FavoritesDir),MAX_PATH-1);
  setLength(FavoritesDir,length(pchar(FavoritesDir)));
  FavoritesDir := AddPathAndName(FavoritesDir,'Favorites');
  ForceDirectories(FavoritesDir);

end.
