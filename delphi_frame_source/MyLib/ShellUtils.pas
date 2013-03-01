unit ShellUtils;

// %ShellUtils : 包装Win32的Shell接口
(*****   Code Written By Huang YanLai   *****)

interface

uses Messages,Windows,sysutils,classes,ShellAPI,ShlObj,
			Forms,WinUtils,LibMessages,Graphics,Controls,ExtCtrls,
      Menus,ActiveX, ComObj,ComCtrls;

type
  { Taskbar Icon Utilities
  }
  TTrayNotify= class;

  TTrayMouseEvent = procedure (Sender : TTrayNotify;MouseMsg : LPARAM;
  	var Handled : boolean ) of object;
  //TTrayMouseEvent = procedure (Sender : TTrayNotify;MouseMsg : LPARAM) of object;

  TTipString = String[63];

  // %TTrayNotify : 任务栏图标
  TTrayNotify= class(TMessageComponent)
  private
    FActive: boolean;
    FOnMouseEvent: TTrayMouseEvent;
    Data : TNotifyIconData;
    FShowButton: boolean;
    FICon: TIcon;
    FOnDblClick: TNotifyEvent;
    FRightPopup: TPopupMenu;
    FLeftPopup: TPopupMenu;
    FOnRightClick: TTrayMouseEvent;
    FOnLeftClick: TTrayMouseEvent;
    procedure LMTrayNotify(var msg : TMessage);message LM_TrayNotify;
    procedure SetActive(const Value: boolean);
    function 	GetID: UINT;
    function 	GetTip: TTipString;
    procedure SetTip(const Value: TTipString);
    procedure CheckInactive;
    procedure SetShowButton(const Value: boolean);
    procedure DataChanged;
    procedure SetIcon(const Value: TIcon);
    procedure IconChanged(sender : TObject);
    function	IsIconStored:boolean;
    procedure SetLeftPopup(const Value: TPopupMenu);
    procedure SetRightPopup(const Value: TPopupMenu);
  protected

  public
    constructor Create(AOwner : TComponent); override;
    destructor 	destroy; override;
    property  	ID : UINT Read GetID;
    procedure 	Add;
    procedure 	Delete;
    procedure 	Modify;
  published
    property 		OnMouseEvent : TTrayMouseEvent Read FOnMouseEvent Write FOnMouseEvent;
    property 		Tip:TTipString  Read GetTip Write SetTip;
    // %ShowButton : 是否在任务栏显示应用程序的图标
    property 		ShowButton : boolean Read FShowButton Write SetShowButton;
    property 		Active: boolean Read FActive Write SetActive;
    property 		Icon : TIcon Read FIcon Write SetIcon stored IsIconStored;

    property 		LeftPopup : TPopupMenu Read FLeftPopup Write SetLeftPopup;
    property 		RightPopup : TPopupMenu Read FRightPopup Write SetRightPopup;
    property 		OnLeftClick: TTrayMouseEvent Read FOnLeftClick Write FOnLeftClick;
    property 		OnRightClick: TTrayMouseEvent Read FOnRightClick Write FOnRightClick;
    property		OnDblClick : TNotifyEvent read FOnDblClick write FOnDblClick;
  end;

  // %TMultiIcon : 任务栏动画图标
  TMultiIcon = class(TTrayNotify)
  private
    FTimer : TTimer;
    FAnimate: boolean;
    FCurIndex: integer;
    FEndIndex: integer;
    FStartIndex: integer;
    FImageList: TImageList;
    procedure SetAnimate(const Value: boolean);
    procedure SetCurIndex(const Value: integer);
    procedure SetImageList(const Value: TImageList);
    procedure OnTimer(sender : TObject);
    function	ValidIndex(value:integer):boolean;
    procedure SetEndIndex(const Value: integer);
    procedure SetStartIndex(const Value: integer);
    function GetInterval: Cardinal;
    procedure SetInterval(const Value: Cardinal);
  protected

  public
    constructor Create(AOwner : TComponent); override;
    destructor 	destroy; override;
  published
    property	ImageList : TImageList read FImageList write SetImageList;
    property	CurIndex : integer read FCurIndex write SetCurIndex default -1;
    property	Animate : boolean read FAnimate write SetAnimate default false;
    property 	StartIndex : integer Read FStartIndex Write SetStartIndex default -1;
    property 	EndIndex : integer Read FEndIndex Write SetEndIndex default -1;
    property	Interval : Cardinal read GetInterval write SetInterval default 1000;
  end;

  { Shell NameSpace Utilities
  }

type
  PShellItem = ^TShellItem;
  TShellItem = record
    ID: PItemIDList;
    Empty: Boolean;
    DisplayName,
    TypeName: string;
    SmallImageIndex,
    NormalImageIndex,
    Size,
    Attributes: Integer;
    ModDate: TDateTime;
  end;

  TShellFolderOption = (soFolders,soNonFolders,soHiddens);
  TShellFolderOptions = set of TShellFolderOption;
  TShellFolder = class;
  TShellItemFilterEvent = procedure (ShellFolder : TShellFolder;
  	ShellItem : PShellItem;
    var matched : boolean) of object;

  { You can only use sorted  TShellFolder
  in the main thread.
    TShellFolder will change ListView's properties and events:
      FListView.OnData      := ListViewData;
      FListView.OnDataHint  := ListViewDataHint;
      FListView.OnDataFind  := ListViewDataFind;
      FListView.OnDblClick  := ListViewDblClick;
      FListView.OnKeyDown   := ListViewKeyDown;
      FListView.OwnerData   := true;
  }
  // %TShellFolder : 包装IShellFolder接口，可以在ListView中显示包含的文件
  TShellFolder = class(TComponent)
  private
    FPIDL: PItemIDList; // current folder's ID list from desktop
    FIDList: TList;     // all items of current folder
    FICurShellFolder : IShellFolder; // current folder interface
    FPath: string;      // current folder path
    FListView: 	TListView;
    FOnPathChanged: TNotifyEvent;
    FSorted: boolean;
    FOptions: TShellFolderOptions;
    FOnItemsChanged: TNotifyEvent;
    FMask: string;
    FFiltered: boolean;
    FOnFilter: TShellItemFilterEvent;
    FCanEnterSub: boolean;
    procedure 	FreeCurPIDL;

    function 		GetCount: integer; // items count
    procedure 	ClearIDList;
    // clear IDList and fill it with items of current folder.
    procedure 	PopulateIDList;
    procedure 	UpdateInfo;

    procedure 	SetPath(const Value: string);
    procedure 	SetPathByID(ID: PItemIDList);

    // handle the Listview event
    procedure 	SetListView(const Value: TListView);
    procedure 	ListViewData(Sender: TObject; Item: TListItem);
    procedure 	ListViewDataHint(Sender: TObject; StartIndex,
      EndIndex: Integer);
    procedure 	ListViewDataFind(Sender: TObject; Find: TItemFind;
      const FindString: String; const FindPosition: TPoint;
      FindData: Pointer; StartIndex: Integer; Direction: TSearchDirection;
      Wrap: Boolean; var Index: Integer);
    procedure   ListViewDblClick(Sender: TObject);
    procedure   ListViewKeyDown(Sender: TObject; var Key: Word;
                    Shift: TShiftState);
    procedure 	UpdateListView;

    function  	GetShellItems(Index: Integer): PShellItem;
    function 		GetShellImage(PIDL: PItemIDList; Large, Open: Boolean): Integer;

    function 		GetPathID: PItemIDList;
    procedure 	SetPathID(const Value: PItemIDList);

    procedure 	SetSorted(const Value: boolean);
    procedure		SortList;
    procedure 	SetOptions(const Value: TShellFolderOptions);
    procedure 	SetMask(const Value: string);
    procedure 	SetFiltered(const Value: boolean);
    function		Matched(ShellItem:PShellItem):boolean;
    procedure 	FillData(ShellItem:PShellItem);

    procedure   InitListView;
  protected
    procedure   Loaded; override;
    function    IsFolder(ShellFolder: IShellFolder; ID: PItemIDList): Boolean;
  public
    constructor Create(AOwner : TComponent); override;
    destructor 	destroy; override;
    property		ICurShellFolder  : IShellFolder read FICurShellFolder;

    property		Count : integer read GetCount;
    property 		ShellItems[Index: Integer]: PShellItem Read GetShellItems;
    function    ItemFullName(index : integer):string;
    function 		EnterFolder(Index : integer): boolean;
    procedure 	CheckShellItems(StartIndex, EndIndex: Integer);
    property		PathID	: PItemIDList read GetPathID write SetPathID;
    procedure 	GoDeskTop;
    function		GoUp:boolean;
    procedure   Refresh;
  published
    property		Path : String Read FPath write SetPath;
    property 		ListView : TListView Read FListView Write SetListView;
    property 		OnPathChanged: TNotifyEvent Read FOnPathChanged Write FOnPathChanged;
    property		Sorted : boolean read FSorted write SetSorted;
    property		Options : TShellFolderOptions read FOptions write SetOptions;
    property		OnItemsChanged : TNotifyEvent Read FOnItemsChanged write FOnItemsChanged;
    { when Filtered is true ,
        if assigned(OnFilter) then use OnFilter
      otherwise use Mask
    }
    property 		Filtered : boolean Read FFiltered Write SetFiltered;
    property		OnFilter : TShellItemFilterEvent read FOnFilter write FOnFilter;
  	property		Mask : string read FMask write SetMask;
    property    CanEnterSub : boolean read FCanEnterSub write FCanEnterSub;
  end;


  function  GetDesktopID : PItemIDList;

  function  GetDesktopShellFolder: IShellFolder;

  function  GetSystemMalloc : IMalloc;

  procedure DisposePIDL(ID: PItemIDList);

  function  ConcatPIDLs(IDList1, IDList2: PItemIDList): PItemIDList;

{ Shell File Operation
}
type
  TFileOptType 		= (fotCopy,fotDelete,fotMove,fotRename);

  TFileOptOption 	= (foAllowUndo,foFilesOnly,
  	foMultiDestFiles,foNoConfirmation,
    foNoConfirmMKDIR,foRenameOnCollision,
    foSilent,foSimpleProgress);

  TFileOptOptions = set of TFileOptOption;

  // %TFileOperation : 包装SHFileOperation，完成文件操作
  TFileOperation 	= class(TComponent)
  private
    FOptions		: TFileOptOptions;
    FOperation	: TFileOptType;
    FSources 		: TStringList;
    FDests				: TStringList;
    FTitle: string;
    FSimple: boolean;
    FDest: string;
    FSource: string;
    function 		GetDests: TStrings;
    function 		GetSources: TStrings;
    procedure 	SetDests(const Value: TStrings);
    procedure 	SetSources(const Value: TStrings);
  protected
    function 		FileOperate(Opt : TFileOptType):boolean;
    function 		GetFlags : LongWord;
  public
    constructor Create(AOwner : TComponent); override;
    destructor 	Destroy; override;
    // ues property 	Operation
    function 		DoFileOperate:boolean;

    function		SimpleFileOpt(Opt : TFileOptType;
    							const S,D : string):boolean;
    function 		Copy(const S,D : string):boolean;
    function 		Delete(const S : string):boolean;
    function 		Rename(const S,D : string):boolean;
    function 		Move(const S,D : string)	:boolean;
  published
    property		Sources 	: TStrings read GetSources write SetSources;
    property		Dests 		: TStrings read GetDests		write SetDests;
    property 		Operation : TFileOptType 	Read FOperation Write FOperation;
    property 		Options : TFileOptOptions Read FOptions 	Write FOptions;
    property 		Title: string Read FTitle Write FTitle;
    // when Simple is true, use source and Dest,
    // otherwise use Sources and Dests.
    property 		Simple: boolean Read FSimple Write FSimple;
    property 		Source: string Read FSource	 Write FSource;
    property 		Dest	: string Read FDest		 Write FDest;
  end;

  EFileOptError = class(exception);

  procedure RaiseFileOptError;

  procedure ConcatFiles(FileList : TStrings; var SFiles : string);

{ Images
}
  function  GetNormalSysImages : THandle;

  function  GetSmallSysImages : THandle;

type
  TIconState = (icsSmall,icsLarge,icsOpened,icsSelected,icsLinked);

  TIconStates = set of TIconState;

  function  GetIconByFileName(Filename : pchar;
              IconStates : TIconStates;
              var hIcon : THandle;
              var ImageIndex : integer):boolean;

  function  GetIconByPID(PID : PItemIDList;
              IconStates : TIconStates;
              var hIcon : THandle;
              var ImageIndex : integer):boolean;

// %CreateLink : 返回是否成功
// #StoreToFile: 保存的文件
// #LinkToFile: 链接的文件
// #Description: 描述
function CreateLink(const StoreToFile,LinkToFile,Description : string; const WorkDir : string=''; SetWorkDir : Boolean=True): boolean;

type
  TShellLinkResovle = (slrANYMATCH,slrNoDialog,slrUpdate);
  TShellLinkResovles = set of TShellLinkResovle;

  // %TShellLink 包装IShellLink
  TShellLink = class
  private
    FShellLink: IShellLink;
    function    GetLinkFile: string;
    procedure   SetLinkFile(const Value: string);
    function GetArguments: string;
    function GetWorkDir: string;
    procedure SetArguments(const Value: string);
    procedure SetWorkDir(const Value: string);
  public
    property    ShellLink : IShellLink read FShellLink;
    property    LinkFile : string read GetLinkFile write SetLinkFile;
    property    Arguments : string read GetArguments Write SetArguments;
    property    WorkDir : string read GetWorkDir Write SetWorkDir;

    constructor Create;
    Destructor  Destroy;override;
    procedure   LoadFromFile(const FileName:string);
    procedure   SaveToFile(const FileName:string);
    procedure   Resovle(Options : TShellLinkResovles);
  end;

function  GetSpecialFolder(Folder : Integer; DoCreate : Boolean) : string;

implementation

{$ifdef DEBUG}

uses ComWriUtils,WinObjs,SafeCode,
	CompUtils,Masks,ConvertUtils,DebugMemory;

{$else}

uses ComWriUtils,WinObjs,SafeCode,
	CompUtils,Masks,ConvertUtils;

{$endif}

{$ifdef DEBUG}
(*
type
  TPIDLs = class(TList)
  public
    function Add(PIDL : PItemIDList): integer;
    function Remove(PIDL : PItemIDList): integer;
  end;
*)
var
  //DebugPIDLs : TPIDLs;
  DebugPIDLs : TPointerRecord;
(*
{ TPIDLs }

function TPIDLs.Add(PIDL: PItemIDList): integer;
var
  i : integer;
begin
  i := IndexOf(PIDL);
  assert(i<0);
  result := inherited Add(PIDL);
end;

function TPIDLs.Remove(PIDL: PItemIDList): integer;
begin
  result := inherited Remove(PIDL);
  assert(result>=0);
end;
*)
{$endif}

{ TTrayNotify }

constructor TTrayNotify.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FActive := false;
  FShowButton := true;
  FIcon := TIcon.Create;
  //FIcon.Assign(Application.Icon);
  FIcon.OnChange :=IconChanged;
  Data.cbSize := sizeof(Data);
  //Data.hIcon := FIcon.handle;
  Data.hIcon := Application.Icon.handle;
  Data.Wnd :=FUtilWindow.Handle;
  Data.uID := UINT(self);
  Data.uCallbackMessage := LM_TrayNotify;
  Data.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
  RegisterRefProp(self,'LeftPopup');
  RegisterRefProp(self,'RightPopup');
end;

destructor TTrayNotify.destroy;
begin
  FIcon.free;
  active := false;
  inherited destroy;
end;

function TTrayNotify.GetID: UINT;
begin
  result := data.uID;
end;

procedure TTrayNotify.LMTrayNotify(var msg: TMessage);
var
  handled : boolean;
begin
  handled := false;
  if assigned(FOnMouseEvent) then
    FOnMouseEvent(self,msg.LParam,handled);
  if not handled then
    case msg.LParam of
      WM_LButtonDown :
        begin
          if assigned(OnLeftClick)then
      			OnLeftClick(self,msg.LParam,handled);
          if not Handled and assigned(LeftPopup)then
            Popup(LeftPopup);
        end;

      WM_RButtonDown :
        begin
          if assigned(OnRightClick)then
      			OnRightClick(self,msg.LParam,handled);
          if not Handled and assigned(RightPopup)then
            Popup(RightPopup);
        end;

      WM_LBUTTONDBLCLK :
      	 if assigned(OnDBLClick)then
           OnDBLClick(self);
    end;
end;

procedure TTrayNotify.SetActive(const Value: boolean);
begin
  if (FActive <> Value) then
    if (csDesigning in ComponentState) then
      FActive := Value
    else
    if value then
    	Add
    else
    	delete;
end;

procedure TTrayNotify.SetTip(const Value: TTipString);
begin
  if Value<>GetTip then
  begin
    StrPCopy(Data.szTip,value);
    DataChanged;
  end;
end;

function TTrayNotify.GetTip: TTipString;
begin
  result := string(Data.szTip);
end;

procedure TTrayNotify.CheckInactive;
begin
  if FActive then RaiseCannotDo('Cannot do this when active.');
end;

procedure TTrayNotify.Add;
begin
  CheckInactive;
  if Shell_NotifyIcon(NIM_ADD,@data) then
    FActive := true;
end;

procedure TTrayNotify.Delete;
begin
  CheckTrue(FActive,'Error : TTrayNotify not Active');
  //Shell_NotifyIcon(NIM_Delete,@data);
  Shell_NotifyIcon(NIM_Delete,@data); // 不检查返回值，因为可能Explorer进程已经死掉。
  FActive := false;
end;

procedure TTrayNotify.SetShowButton(const Value: boolean);
var
  AppWin : WWindow;
  ExStyle : longint;
begin
  if FShowButton <> Value then
  begin
    FShowButton := Value;
    if csDesigning in ComponentState then exit;
    AppWin := WWindow.Create(Application.Handle);
    try
    	ExStyle := AppWin.ExStyle;
	    if FShowButton then
      begin
        ExStyle := ExStyle and not WS_EX_TOOLWINDOW;
			  ExStyle := ExStyle or WS_EX_APPWINDOW;
      end
      else
      begin
        ExStyle := ExStyle and not WS_EX_APPWINDOW;
			  ExStyle := ExStyle or WS_EX_TOOLWINDOW;
      end;
      AppWin.ExStyle := ExStyle;
      {
      if (Owner is TForm) then
      begin
        AppWin.Handle:=TForm(Owner).Handle;

      if FShowButton then
      begin
        ExStyle := ExStyle and not WS_EX_TOOLWINDOW;
			  ExStyle := ExStyle or WS_EX_APPWINDOW;
      end
      else
      begin
        ExStyle := ExStyle and not WS_EX_APPWINDOW;
			  ExStyle := ExStyle or WS_EX_TOOLWINDOW;
      end;
      AppWin.ExStyle := ExStyle;

      end; }
    finally
      AppWin.free;
    end;
  end;
end;

procedure TTrayNotify.DataChanged;
begin
  if FActive then
  	Modify;
end;

procedure TTrayNotify.Modify;
begin
  CheckTrue(FActive,'Error : TTrayNotify not Active');
  if not (csDesigning in componentState) then
  begin
    // 如果不成功，重新创建
    if not Shell_NotifyIcon(NIM_MODIFY,@data) then
    begin
      Delete;
      Add;
    end;
  end;
end;

procedure TTrayNotify.SetIcon(const Value: TIcon);
begin
  FICon.Assign(Value);
end;

procedure TTrayNotify.IconChanged(sender: TObject);
begin
  if FICon.Handle<>0 then
	  Data.hIcon := FICon.Handle
  else
    Data.hIcon := Application.Icon.handle;
  DataChanged;
end;

function TTrayNotify.IsIconStored: boolean;
begin
  result := FIcon.handle<>0;
end;

procedure TTrayNotify.SetLeftPopup(const Value: TPopupMenu);
begin
  if FLeftPopup <> Value then
  begin
    FLeftPopup := Value;
    ReferTo(value);
  end;
end;

procedure TTrayNotify.SetRightPopup(const Value: TPopupMenu);
begin
  if FRightPopup<> Value then
  begin
    FRightPopup := Value;
    ReferTo(value);
  end;
end;

{ TMultiIcon }

constructor TMultiIcon.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTimer := TTimer.Create(self);
  FTimer.enabled := false;
  FTimer.OnTimer := OnTimer;
  RegisterRefProp(self,'ImageList');
  FStartIndex:=-1;
  FEndIndex := -1;
  FCurIndex := -1;
  FAnimate := false;
end;

destructor TMultiIcon.destroy;
begin
  inherited destroy;
end;

procedure TMultiIcon.OnTimer(sender: TObject);
var
  NewIndex : integer;
begin
  if FImageList<>nil then
  begin
    NewIndex := FCurIndex+1;
    if NewIndex>EndIndex then NewIndex := StartIndex;
    CurIndex := NewIndex;
  end;
end;

procedure TMultiIcon.SetAnimate(const Value: boolean);
begin
  if FAnimate <> Value then
  begin
	  FAnimate := Value;
  	if not (csDesigning in componentState) then
	  begin
  	  if FAnimate then
      begin
        FTimer.Enabled := true;
        CurIndex := StartIndex;
      end
      else FTimer.Enabled := false;
	  end;
  end;
end;

procedure TMultiIcon.SetCurIndex(const Value: integer);
begin
  if FCurIndex <> Value then
  begin
    if ValidIndex(value) then
    begin
	    FCurIndex := Value;
  	  if not (csDesigning in componentState)
    	  and (ImageList<>nil) then
	    begin
        ImageList.GetIcon(FCurIndex,FIcon);
    	end;
    end;
  end;
end;

procedure TMultiIcon.SetEndIndex(const Value: integer);
begin
  FEndIndex := Value;
end;

procedure TMultiIcon.SetImageList(const Value: TImageList);
begin
  if FImageList <> Value then
  begin
    FImageList := Value;
    if FImageList<>nil then
    begin
      Referto(FImageList);
      if FImageList.count>0 then
      begin
        if not ValidIndex(CurIndex) then CurIndex:=0;
        if not ValidIndex(StartIndex) then StartIndex:=0;
        if not ValidIndex(EndIndex) then EndIndex:=FImageList.count-1;
      end
      else
      begin
        CurIndex:=-1;
        StartIndex:=-1;
        EndIndex:=-1;
      end;
    end
  end;
end;

function TMultiIcon.GetInterval: Cardinal;
begin
  result := FTimer.Interval;
end;

procedure TMultiIcon.SetInterval(const Value: Cardinal);
begin
  FTimer.Interval := value;
end;

procedure TMultiIcon.SetStartIndex(const Value: integer);
begin
  FStartIndex := Value;
end;

function TMultiIcon.ValidIndex(value: integer): boolean;
begin
  if ImageList=nil then
    result:=false
  else
  	result:=(value>=0) and (value<ImageList.count);
end;

{
  Shell Name Space Utilities
}
{ ShellFolder procedures
}

var
  IDesktopFolder: IShellFolder;
  DeskTopID : PItemIDList;
  SmallImageListHandle : THandle ;
  NormalImageListHandle : THandle ;
  Malloc: IMalloc;

var
  FileInfo: TSHFileInfo;

function GetDesktopID : PItemIDList;
begin
  result := DeskTopID;
end;

function GetDesktopShellFolder: IShellFolder;
begin
  result := IDesktopFolder;
end;

function GetNormalSysImages : THandle;
begin
  result := NormalImageListHandle;
end;

function GetSmallSysImages : THandle;
begin
  result := SmallImageListHandle;
end;

function GetSystemMalloc : IMalloc;
begin
  result := Malloc;
end;

procedure DisposeShellItem(ShellItem : PShellItem);
begin
  if ShellItem<>nil then
  begin
  	DisposePIDL(ShellItem^.ID);
    Dispose(ShellItem);
  end;
end;

//PIDL MANIPULATION

procedure DisposePIDL(ID: PItemIDList);
begin
  if ID = nil then Exit;
  begin
    {$ifdef DEBUG}
	  DebugPIDLs.remove(ID);
		{$endif}
	  Malloc.Free(ID);
  end;
end;

(*
// copy only one Item
function CopyITEMID({Malloc: IMalloc;} ID: PItemIDList): PItemIDList;
var
  p : PItemIDList;
begin
  Result := Malloc.Alloc(ID^.mkid.cb + SizeOf(ID^.mkid.cb));
  CopyMemory(Result, ID, ID^.mkid.cb + SizeOf(ID^.mkid.cb));
  // new add
  p := result;
  Inc(PChar(p), ID^.mkid.cb);
  p^.mkid.cb := 0;
  {$ifdef DEBUG}
  DebugPIDLs.Add(result);
	{$endif}
end;
*)

function NextPIDL(IDList: PItemIDList): PItemIDList;
begin
  Result := IDList;
  Inc(PChar(Result), IDList^.mkid.cb);
end;

function GetPIDLSize(IDList: PItemIDList): Integer;
begin
  Result := 0;
  if Assigned(IDList) then
  begin
    Result := SizeOf(IDList^.mkid.cb);
    while IDList^.mkid.cb <> 0 do
    begin
      Result := Result + IDList^.mkid.cb;
      IDList := NextPIDL(IDList);
    end;
  end;
end;

function CreatePIDL(Size: Integer): PItemIDList;
begin
  try
    Result := Malloc.Alloc(Size);
    if Assigned(Result) then
    begin
      FillChar(Result^, Size, 0);
      {$ifdef DEBUG}
		  DebugPIDLs.Add(result);
			{$endif}
    end;
  finally
  end;
end;

// append IDlist2 after IDList1
function ConcatPIDLs(IDList1, IDList2: PItemIDList): PItemIDList;
var
  cb1, cb2: Integer;
begin
  if Assigned(IDList1) then
    cb1 := GetPIDLSize(IDList1) - SizeOf(IDList1^.mkid.cb)
  else
    cb1 := 0;

  cb2 := GetPIDLSize(IDList2);

  Result := CreatePIDL(cb1 + cb2);
  if Assigned(Result) then
  begin
    if Assigned(IDList1) then
      CopyMemory(Result, IDList1, cb1);
    CopyMemory(PChar(Result) + cb1, IDList2, cb2);
  end;
end;

function CopyITEMList(IDList: PItemIDList): PItemIDList;
var
  size : integer;
begin
  if IDList=nil then result := nil
  else
  begin
	  size := GetPIDLSize(IDList);
  	result := Malloc.Alloc(size);
	  if result<>nil then
    begin
  	  CopyMemory(result,IDList,size);
      {$ifdef DEBUG}
		  DebugPIDLs.Add(result);
			{$endif}
    end;
  end;
end;


//SHELL FOLDER ITEM INFO

function GetDisplayName(ShellFolder: IShellFolder; PIDL: PItemIDList;
                        ForParsing: Boolean): string;
var
  StrRet: TStrRet;
  P: PChar;
  Flags: Integer;
begin
  Result := '';
  if ForParsing then
    Flags := SHGDN_FORPARSING
  else
    Flags := SHGDN_NORMAL;

  ShellFolder.GetDisplayNameOf(PIDL, Flags, StrRet);
  case StrRet.uType of
    STRRET_CSTR:
      SetString(Result, StrRet.cStr, lStrLen(StrRet.cStr));
    STRRET_OFFSET:
      begin
        P := @PIDL.mkid.abID[StrRet.uOffset - SizeOf(PIDL.mkid.cb)];
        SetString(Result, P, PIDL.mkid.cb - StrRet.uOffset);
      end;
    STRRET_WSTR:
      Result := StrRet.pOleStr;
  end;
end;

var
  TheFolder : IShellFolder;

function ListSortFunc(Item1, Item2: Pointer): Integer;
begin
  // some times , CompareIDs return none zero when Item1=Item2.
  // This may bring a error.
  // Resovle the problem with this
  if Item1=Item2 then result:=0
  else
  Result := SmallInt(TheFolder.CompareIDs(
                  0,
                  PShellItem(Item1)^.ID,
                  PShellItem(Item2)^.ID
            ));
end;

// when IDList is 0 or
function GetParentIDList(IDList: PItemIDList): PItemIDList;
var
  BrowseIDList : PItemIDList;
  TotalSize,ItemSize : integer;
begin
  if IDList=nil then result := nil
  else
  begin
    TotalSize:= 0;
    ItemSize := 0;
	  BrowseIDList := IDList;
  	while (BrowseIDList^.mkid.cb<>0) do
	  begin
  	  inc(Totalsize,ItemSize);
      ItemSize := BrowseIDList^.mkid.cb;
	    BrowseIDList:=NextPIDL(BrowseIDList);
	  end;
  	if totalsize=0 then result:=nil
    else
    begin
      result := CreatePIDL(totalsize+Sizeof(BrowseIDList^.mkid.cb));
      CopyMemory(result,IDList,totalsize);
      BrowseIDList := result;
      inc(pchar(BrowseIDList),totalsize);
      BrowseIDList^.mkid.cb:=0;
    end;
  end;
end;


constructor TShellFolder.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RegisterRefProp(self,'ListView');
  FIDList := TList.Create;
  FPIDL := nil;
  FOptions := [soFolders,soNonFolders,soHiddens];
  FFiltered := false;
  FMask := '*';
  GoDeskTop;
end;

destructor TShellFolder.destroy;
begin
  ClearIDList;
  FIDList.free;
  FICurShellFolder := nil;
  FreeCurPIDL;
	inherited destroy;
end;

function TShellFolder.GetCount: integer;
begin
  result := FIDList.Count;
end;

procedure TShellFolder.ClearIDList;
var
  I: Integer;
begin
  for I := 0 to FIDList.Count-1 do
  begin
    DisposeShellItem(ShellItems[I]);
  end;
  FIDList.Clear;
end;

function TShellFolder.GetShellItems(Index: Integer): PShellItem;
begin
  Result := PShellItem(FIDList[Index]);
end;

procedure TShellFolder.PopulateIDList;
var
  ID: PItemIDList;
  EnumList: IEnumIDList;
  NumIDs: LongWord;
  SaveCursor: TCursor;
  ShellItem: PShellItem;
  Flags : integer;
begin
  //if csDesigning in ComponentState then exit;
  ClearIDList;
  SaveCursor := Screen.Cursor;
  try
    Flags := 0;
    if soFolders in FOptions then
    	Flags := Flags or SHCONTF_FOLDERS;
    if soNonFolders in FOptions then
    	Flags := Flags or SHCONTF_NONFOLDERS;
    if soHiddens in FOptions then
    	Flags := Flags or SHCONTF_INCLUDEHIDDEN;
    Screen.Cursor := crHourglass;
    OleCheck(
      FICurShellFolder.EnumObjects(
        Application.Handle,
        Flags,
        EnumList)
    );

    while EnumList.Next(1, ID, NumIDs) = S_OK do
    begin
      ShellItem := New(PShellItem);
      ShellItem.ID := ID;
      {$ifdef DEBUG}
		  DebugPIDLs.Add(ID);
			{$endif}
      ShellItem.Empty := True;
      ShellItem.DisplayName := GetDisplayName(FICurShellFolder, ID, False);
      if not filtered or Matched(ShellItem) then
	      FIDList.Add(ShellItem)
      else DisposeShellItem(ShellItem);
    end;

    if FSorted then SortList;

    UpdateListView;

    if Assigned(FOnItemsChanged) then FOnItemsChanged(self);
  finally
    Screen.Cursor := SaveCursor;
  end;
end;

procedure TShellFolder.SetPath(const Value: string);
var
  P: PWideChar;
  NewPIDL: PItemIDList;
  Flags,
  NumChars: LongWord;
begin
  NumChars := Length(Value); //?
  Flags := 0;
  P := StringToOleStr(Value);

  OLECheck(
    IDesktopFolder.ParseDisplayName(
      Application.Handle,
      nil,
      P,
      NumChars,
      NewPIDL,
      Flags)
   );
  {$ifdef debug}
  DebugPIDLs.Add(NewPIDL);
  {$endif}

  SetPathByID(NewPIDL);
end;

procedure TShellFolder.SetPathbyID(ID: PItemIDList);
begin
  FreeCurPIDL;
  FPIDL := ID;
  //if ID = DeskTopID then
  if ID = nil then
  begin
     FICurShellFolder := IDesktopFolder;
     FPIDL := copyItemList(DeskTopID);
  end
  else
	   OLECheck(
    	 IDesktopFolder.BindToObject(
            ID,
            nil,
            IID_IShellFolder,
            Pointer(FICurShellFolder))
  	 );
  // copy this.
  UpdateInfo;
end;

//ROUTINES FOR MANAGING VIRTUAL DATA
procedure TShellFolder.FillData(ShellItem: PShellItem);
var
  FileData: TWin32FindData;
  FileInfo: TSHFileInfo;
  SysTime: TSystemTime;
  IDList :  PItemIDList;
begin
  if shellItem^.empty then
  with shellItem^ do
    begin
      // IDList has the full name
      IDList := ConcatPIDLs(FPIDL,ID);
      try
	      SmallImageIndex := GetShellImage(IDList, false, False);
  	    NormalImageIndex :=GetShellImage(IDList, true, False);
      //File Type
    	  SHGetFileInfo(
      	  pchar(IDList),
        	0,
	        FileInfo,
  	      SizeOf(FileInfo),
    	    SHGFI_TYPENAME or SHGFI_PIDL
      	);
      	TypeName := FileInfo.szTypeName;
      finally
	      DisposePIDL(IDList);
      end;

      //Get File info from Windows
      FillChar(FileData, SizeOf(FileData), #0);
      SHGetDataFromIDList(
        FICurShellFolder,
        ID,
        SHGDFIL_FINDDATA,
        @FileData,
        SizeOf(FileData)
      );

      //File Size, in KB
      Size := FileData.nFileSizeLow div 1024;
      if Size = 0 then Size := 1;

      //Modified Date
      FileTimeToSystemTime(FileData.ftLastWriteTime, SysTime);
      try
        ModDate := SystemTimeToDateTime(SysTime);
      except// on E: Exception do ShowMessage(E.classname);
      end;

      //Attributes
      Attributes := FileData.dwFileAttributes;

      //Flag this record as complete.
      Empty := False;
  end;
end;

procedure TShellFolder.CheckShellItems(StartIndex, EndIndex: Integer);
var
  I: Integer;
begin
  //Here all the data that wasn't initialized in PopulateIDList is
  //filled in.
  for I := StartIndex to EndIndex do
    if ShellItems[I]^.Empty then
      FillData(ShellItems[I]);
end;

function TShellFolder.IsFolder(ShellFolder: IShellFolder;
  ID: PItemIDList): Boolean;
var
  Flags: UINT;
begin
  Flags := SFGAO_FOLDER;
  ShellFolder.GetAttributesOf(1, ID, Flags);
  Result := SFGAO_FOLDER and Flags <> 0;
end;

procedure TShellFolder.SetListView(const Value: TListView);
begin
  if FListView <> Value then
  begin
    //if FListView<>nil then
    if (FListView<>nil) and
      not (csDesigning in componentState)then
    begin
      FListView.OnData := nil;
      FListView.OnDataHint := nil;
      FListView.OnDataFind := nil;
      FListView.OnDblClick := nil;
      FListView.OnKeyDown  := nil;
    end;
    FListView := Value;
    if (FListView<>nil) then
    begin
      ReferTo(FListView);
      if not (csDesigning in componentState)
        //and not (csLoading in componentState)
      then
        InitListView;
    end;
  end;
end;

function TShellFolder.EnterFolder(Index: integer): boolean;
var
  ID,NewIDList: PItemIDList;
begin
  result :=(index>=0) and (index<count);
  if result then
  begin
	  ID := ShellItems[Index].ID;
	  result := IsFolder(ICurShellFolder, ID);
  	if result then
	  begin
  	  NewIDList := ConcatPIDLs(FPIDL, ID);
    	SetPathByID(NewIDList);
	  end;
  end;  
end;

procedure TShellFolder.ListViewDataFind(Sender: TObject; Find: TItemFind;
  const FindString: String; const FindPosition: TPoint; FindData: Pointer;
  StartIndex: Integer; Direction: TSearchDirection; Wrap: Boolean;
  var Index: Integer);
//OnDataFind gets called in response to calls to FindCaption, FindData,
//GetNearestItem, etc. It also gets called for each keystroke sent to the
//ListView (for incremental searching)
var
  I: Integer;
  Found: Boolean;
begin
  I := StartIndex;
  if (Find = ifExactString) or (Find = ifPartialString) then
  begin
    repeat
      if (I = Count-1) then
        if Wrap then I := 0 else Exit;
      Found := Pos(UpperCase(FindString), UpperCase(ShellItems[I]^.DisplayName)) = 1;
      Inc(I);
    until Found or (I = StartIndex);
    if Found then Index := I-1;
  end;
end;

procedure TShellFolder.ListViewDataHint(Sender: TObject; StartIndex,
  EndIndex: Integer);
begin
  //OnDataHint is called before OnData. This gives you a chance to
  //initialize only the data structures that need to be drawn.
  //You should keep track of which items have been initialized so no
  //extra work is done.
  //if (StartIndex > count) or (EndIndex > count) then Exit;
  if (StartIndex >= count) or (EndIndex >= count) then Exit;
  CheckShellItems(StartIndex, EndIndex);
end;

procedure TShellFolder.ListViewData(Sender: TObject; Item: TListItem);
var
  Attrs: string;
begin
  //OnData gets called once for each item for which the ListView needs
  //data. If the ListView is in Report View, be sure to add the subitems.
  //Item is a "dummy" item whose only valid data is it's index which
  //is used to index into the underlying data.

  //if (Item.Index > Count) then Exit;
  if (Item.Index >= Count) then Exit;
  with ShellItems[Item.Index]^ do
  begin
    Item.Caption := DisplayName;
    if ListView.ViewStyle = vsIcon then
    	Item.ImageIndex := NormalImageIndex
    else
	    Item.ImageIndex := SmallImageIndex;

    if ListView.ViewStyle <> vsReport then Exit;

    if not IsFolder(ICurShellFolder, ID) then
      Item.SubItems.Add(Format('%dKB', [Size]))
    else
      Item.SubItems.Add('');
    Item.SubItems.Add(TypeName);
    try
      Item.SubItems.Add(DateTimeToStr(ModDate));
    except
    end;

    if Bool(Attributes and FILE_ATTRIBUTE_READONLY) then Attrs := Attrs + 'R';
    if Bool(Attributes and FILE_ATTRIBUTE_HIDDEN) then Attrs := Attrs + 'H';
    if Bool(Attributes and FILE_ATTRIBUTE_SYSTEM) then Attrs := Attrs + 'S';
    if Bool(Attributes and FILE_ATTRIBUTE_ARCHIVE) then Attrs := Attrs + 'A';
  end;
  Item.SubItems.Add(Attrs);
end;

procedure TShellFolder.ListViewDblClick(Sender: TObject);
begin
  assert(sender=FListView);
  if FCanEnterSub and
    (FListView.Selected <> nil) then
    EnterFolder(FListView.Selected.index);
end;

procedure TShellFolder.ListViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  assert(sender=FListView);
  if Key = VK_RETURN then
    ListViewDblClick(Sender);
end;

function TShellFolder.GetShellImage(PIDL: PItemIDList; Large,
  Open: Boolean): Integer;
var
  FileInfo: TSHFileInfo;
  Flags: Integer;
begin
  Flags := SHGFI_PIDL or SHGFI_SYSICONINDEX;
  if Open then Flags := Flags or SHGFI_OPENICON;
  if Large then Flags := Flags or SHGFI_LARGEICON
  else Flags := Flags or SHGFI_SMALLICON;
  // note : PChar(PIDL)
  {OLECheck(SHGetFileInfo(
  							PChar(GetDisplayName(FICurShellFolder, PIDL, True)),
                0,
                FileInfo,
                SizeOf(FileInfo),
                Flags));}
  {OLECheck(}SHGetFileInfo(
  							PChar(PIDL),
                0,
                FileInfo,
                SizeOf(FileInfo),
                Flags){)};
  Result := FileInfo.iIcon;
end;


procedure TShellFolder.UpdateInfo;
begin
  PopulateIDList;
  FPath := GetDisplayName(IDesktopFolder, FPIDL, True);
  if assigned(FOnPathChanged) then FOnPathChanged(self);
end;

procedure TShellFolder.GoDeskTop;
begin
  //SetPathByID(CopyItemList(DeskTopID));
  SetPathByID(nil);
end;

procedure TShellFolder.FreeCurPIDL;
begin
  if (FPIDL<>nil){ and (FPIDL<>DesktopID) }then
    DisposePIDL(FPIDL);
end;

function TShellFolder.GetPathID: PItemIDList;
begin
  if FPIDL=nil then
  	result:=nil
  else
  if ICurShellFolder=IDesktopFolder then
  	result := nil
  else
    result := CopyItemList(FPIDL);
end;

procedure TShellFolder.SetPathID(const Value: PItemIDList);
begin
  SetPathByID(CopyItemList(value));
end;

procedure TShellFolder.SetSorted(const Value: boolean);
begin
  if FSorted <> Value then
  begin
    FSorted := Value;
    if FSorted then SortList;
    UpdateListView;
  end;
end;

procedure TShellFolder.SortList;
begin
  TheFolder := ICurShellFolder;
  FIDList.Sort(ListSortFunc);
end;

procedure TShellFolder.UpdateListView;
begin
  if csDesigning in ComponentState then exit;
  //We need to tell the ListView how many items it has.
    if ListView<>nil then
    begin
      ListView.Items.Count := Count;
	    ListView.Repaint;
    end;
end;

procedure TShellFolder.Refresh;
begin
  PopulateIDList;
end;

procedure TShellFolder.SetOptions(const Value: TShellFolderOptions);
begin
  if FOptions <> Value then
  begin
    FOptions := Value;
    PopulateIDList;
  end;
end;

function TShellFolder.GoUp: boolean;
begin
  result := not (ICurShellFolder = IDesktopFolder);
  if result then
  begin
    // this is a bad call.
    //SetPathByID(GetParentIDList(PathID));
    SetPathByID(GetParentIDList(FPIDL));
  end;
end;

procedure TShellFolder.SetMask(const Value: string);
begin
  if FMask <> Value then
  begin
    FMask := Value;
    if filtered then PopulateIDList;
  end;
end;

procedure TShellFolder.SetFiltered(const Value: boolean);
begin
  if FFiltered <> Value then
  begin
    FFiltered := Value;
    PopulateIDList;
  end;
end;

function TShellFolder.Matched(ShellItem: PShellItem): boolean;
begin
  if assigned(OnFilter) then
    OnFilter(self,ShellItem,result)
  else
    result := MatchesMask(ShellItem^.DisplayName,FMask);
end;

procedure TShellFolder.Loaded;
begin
  inherited Loaded;
  {if FListView<>nil then
  begin
    InitListView;
  end;}
end;

procedure TShellFolder.InitListView;
begin
  SetListViewImages(ListView,istNormal,NormalImageListHandle);
  SetListViewImages(ListView,istSmall,SmallImageListHandle);
  FListView.OnData      := ListViewData;
  FListView.OnDataHint  := ListViewDataHint;
  FListView.OnDataFind  := ListViewDataFind;
  FListView.OnDblClick  := ListViewDblClick;
  FListView.OnKeyDown   := ListViewKeyDown;
  FListView.OwnerData   := true;
  FListView.Items.Count := Count;
	if Count > 0 then
		FListView.Selected := FListView.Items[0];
  FListView.Repaint;
end;

function TShellFolder.ItemFullName(index: integer): string;
begin
  CheckRange(index,0,count-1);
  result := GetDisplayName(FICurShellFolder,
    ShellItems[index].ID,true);
end;

const
  FileOpts : array[TFileOptType] of UINT
  	=(fo_Copy,fo_Delete,fo_Move,fo_Rename);

  FileOptFlags : array[TFileOptOption] of LongWord
    =(fof_AllowUndo,fof_FilesOnly,
  	fof_MultiDestFiles,fof_NoConfirmation,
    fof_NoConfirmMKDIR,fof_RenameOnCollision,
    fof_Silent,fof_SimpleProgress);

{ TFileOperation }

constructor TFileOperation.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSources:= TStringList.Create;
  FDests:= TStringList.Create;
end;

destructor TFileOperation.Destroy;
begin
  FSources.free;
  FDests.free;
  inherited Destroy;
end;

function TFileOperation.GetDests: TStrings;
begin
  result := FDests;
end;

function TFileOperation.GetSources: TStrings;
begin
  result := FSources;
end;

procedure TFileOperation.SetDests(const Value: TStrings);
begin
  FDests.Assign(value);
end;

procedure TFileOperation.SetSources(const Value: TStrings);
begin
  FSources.Assign(value);
end;

function TFileOperation.DoFileOperate: boolean;
begin
  result := FileOperate(Operation);
end;

function TFileOperation.FileOperate(Opt: TFileOptType): boolean;
var
  SHFILEOPSTRUCT : TSHFILEOPSTRUCT;
  SFiles,DFiles : string;
begin
  if simple then
  begin
    SFiles := FSource + #0#0;
    DFiles := FDest + #0#0;
  end
  else
  begin
	  if (foMultiDestFiles in options) and
  	  (FSources.count<>FDests.count) then
      RaiseFileOptError;
	  if FSources.count=0 then
    begin
      result := false;
      exit;
    end;
  	ConcatFiles(FSources,SFiles);
  	//if foMultiDestFiles in options then
    ConcatFiles(FDests,DFiles);
  end;
  with SHFILEOPSTRUCT do
  begin
    Wnd := Application.handle;
    wFunc := FileOpts[opt];
    fFlags := GetFlags;
    pFrom := pchar(SFiles);
    pTo := pchar(DFiles);
    lpszProgressTitle := pchar(FTitle);
  end;
  result := SHFileOperation(SHFILEOPSTRUCT)=0;
  if result then
  	result := not SHFILEOPSTRUCT.fAnyOperationsAborted;
end;

function		TFileOperation.SimpleFileOpt(Opt : TFileOptType;
    							const S,D : string):boolean;
begin
  simple := true;
  Source := s;
  Dest   := d;
  result := FileOperate(opt);
end;

function TFileOperation.GetFlags: LongWord;
begin
  result := EnumsToFlags(FOptions,FileOptFlags);
end;

function TFileOperation.Copy(const S,D : string): boolean;
begin
  result := SimpleFileOpt(fotCopy,s,d);
end;

function TFileOperation.Move(const S,D : string): boolean;
begin
  result := SimpleFileOpt(fotMove,s,d);
end;

function TFileOperation.Rename(const S,D : string): boolean;
begin
  result := SimpleFileOpt(fotRename,s,d);
end;

function TFileOperation.Delete(const S : string): boolean;
begin
  result := SimpleFileOpt(fotDelete,s,'');
end;

procedure RaiseFileOptError;
begin
  raise EFileOptError.Create('File Operation Error!');
end;

procedure ConcatFiles(FileList : TStrings; var SFiles : string);
var
  i : integer;
begin
  if  FileList.count=0 then
  begin
    SFiles:=#0#0;
    exit;
  end;
  SFiles:=FileList[0];
  for i:=1 to FileList.count-1 do
  begin
    SFiles := SFiles + #0 + FileList[i];
  end;
  SFiles := SFiles + #0#0;
end;

function  GetIcon(NameOrID : pchar;
              flags : UINT;
              IconStates : TIconStates;
              var hIcon : THandle;
              var ImageIndex : integer):boolean;
var
  FileInfo: TSHFileInfo;
begin
  flags := flags or SHGFI_ICON;
  if icsSmall in IconStates then
    flags := flags or SHGFI_SMALLICON;
  if icsLarge in IconStates then
    flags := flags or SHGFI_LargeICON;
  if icsSelected in IconStates then
    flags := flags or SHGFI_SELECTED;
  if icsSelected in IconStates then
    flags := flags or SHGFI_SELECTED;
  if icsSelected in IconStates then
    flags := flags or SHGFI_SELECTED;
  result := SHGetFileInfo(NameOrID,
                0,
                FileInfo,
                SizeOf(FileInfo),
                Flags)<>0;
  hIcon := FileInfo.hIcon;
  ImageIndex := FileInfo.iIcon;
end;

function  GetIconByFileName(Filename : pchar;
              IconStates : TIconStates;
              var hIcon : THandle;
              var ImageIndex : integer):boolean;
begin
  result := GetIcon(FileName,
              0,
              IconStates,
              hIcon,
              ImageIndex);
end;

function  GetIconByPID(PID : PItemIDList;
              IconStates : TIconStates;
              var hIcon : THandle;
              var ImageIndex : integer):boolean;
begin
  result := GetIcon(pchar(PID),
              SHGFI_PIDL,
              IconStates,
              hIcon,
              ImageIndex);
end;

// %CreateLink : 返回是否成功
// #StoreToFile: 保存的文件
// #LinkToFile: 链接的文件
// #Description: 描述
function CreateLink(const StoreToFile,LinkToFile,Description : string;
  const WorkDir : string; SetWorkDir : Boolean): boolean;
var
  WStoreToFile : WideString;
  ShellLink : IShellLink;
  PersistFile : IPersistFile;
begin
  try
    try
      WStoreToFile := StoreToFile ;
      OleCheck(CoCreateInstance(CLSID_ShellLink, nil,
          CLSCTX_INPROC_SERVER, IID_IShellLinkA, ShellLink));
      ShellLink.SetPath(pchar(LinkToFile));
      ShellLink.SetDescription(pchar(Description));
      if SetWorkDir then
        if WorkDir<>'' then
          ShellLink.SetWorkingDirectory(pchar(WorkDir)) else
          ShellLink.SetWorkingDirectory(pchar(ExtractFilePath(LinkToFile)));
      OleCheck(ShellLink.QueryInterface(IPersistFile,PersistFile));
      OleCheck(PersistFile.Save(PWideChar(WStoreToFile),true));
      result := true;
    finally
      PersistFile:=nil;
      ShellLink:=nil;
    end;
  except
    result := false;
  end;
end;

{ TShellLink }

constructor TShellLink.Create;
begin
  inherited Create;
  OleCheck(CoCreateInstance(CLSID_ShellLink, nil,
    CLSCTX_INPROC_SERVER, IShellLink, FShellLink));
end;

destructor TShellLink.Destroy;
begin
  FShellLink:=nil;
  inherited Destroy;
end;

function TShellLink.GetLinkFile: string;
var
  FindData : TWin32FindData;
begin
  SetLength(result,MAX_PATH);
  OleCheck(FShellLink.GetPath(pchar(result),MAX_PATH-1,FindData,0));
  SetLength(result,length(pchar(result)));
end;

procedure TShellLink.SetLinkFile(const Value: string);
begin
  OleCheck(FShellLink.SetPath(pchar(Value)));
end;

function TShellLink.GetArguments: string;
begin
  SetLength(result,MAX_PATH);
  OleCheck(FShellLink.GetArguments(pchar(result),MAX_PATH-1));
  SetLength(result,length(pchar(result)));
end;

function TShellLink.GetWorkDir: string;
begin
  SetLength(result,MAX_PATH);
  OleCheck(FShellLink.GetWorkingDirectory(pchar(result),MAX_PATH-1));
  SetLength(result,length(pchar(result)));
end;


procedure TShellLink.SetArguments(const Value: string);
begin
  OleCheck(FShellLink.SetArguments(pchar(value)));
end;

procedure TShellLink.SetWorkDir(const Value: string);
begin
  OleCheck(FShellLink.SetWorkingDirectory(pchar(value)));
end;

procedure TShellLink.Resovle(Options: TShellLinkResovles);
var
  Flag : integer;
begin
  Flag := 0;
  if slrAnyMatch in Options then Flag:=Flag or SLR_ANY_MATCH;
  if slrNoDialog in Options then Flag:=Flag or SLR_NO_UI;
  if slrUpdate in Options then Flag:=Flag or SLR_Update;
  FShellLink.Resolve(GetDesktopWindow,Flag);
end;

procedure TShellLink.LoadFromFile(const FileName: string);
var
  WStoreToFile : WideString;
  PersistFile : IPersistFile;
begin
  WStoreToFile := FileName;
  OleCheck(FShellLink.QueryInterface(IPersistFile,PersistFile));
  OleCheck(PersistFile.Load(PWideChar(WStoreToFile),STGM_READ));
end;

procedure TShellLink.SaveToFile(const FileName: string);
var
  WStoreToFile : WideString;
  PersistFile : IPersistFile;
begin
  WStoreToFile := FileName;
  OleCheck(FShellLink.QueryInterface(IPersistFile,PersistFile));
  OleCheck(PersistFile.Save(PWideChar(WStoreToFile),true));
end;

function  GetSpecialFolder(Folder : Integer; DoCreate : Boolean) : string;
var
  Buffer : array[0..MAX_PATH] of Char;
begin
  FillChar(Buffer,SizeOf(Buffer),0);
  CheckTrue(SHGetSpecialFolderPath(0,@Buffer,Folder,DoCreate));
  Result := PChar(@Buffer);
end;

initialization
  {$ifdef DEBUG}
  //DebugPIDLs := TPIDLs.Create;
  DebugPIDLs := TPointerRecord.Create;
	{$endif}
  OLECheck(SHGetDesktopFolder(IDesktopFolder));
  OLECheck(
    SHGetSpecialFolderLocation(
      Application.Handle,
      CSIDL_DESKTOP	,
      DeskTopID)
  );
  {$ifdef DEBUG}
  DebugPIDLs.Add(DeskTopID);
	{$endif}
  OLECheck(SHGetMalloc(Malloc));

  SmallImageListHandle := SHGetFileInfo('C:\',
                           0,
                           FileInfo,
                           SizeOf(FileInfo),
                           SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
  NormalImageListHandle := SHGetFileInfo('C:\',
                           0,
                           FileInfo,
                           SizeOf(FileInfo),
                           SHGFI_SYSICONINDEX or SHGFI_LARGEICON);

finalization
  IDesktopFolder := nil;
  DisposePIDL(DeskTopID);
  Malloc := nil;
  {$ifdef DEBUG}
  //Assert(DebugPIDLs.count=0);
  DebugPIDLs.free;
	{$endif}
end.
