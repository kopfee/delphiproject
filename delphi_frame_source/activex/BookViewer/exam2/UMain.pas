unit UMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, ExtDialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls,
  Menus, PDG2Lib_TLB, ImgList, ToolWin,IniFiles,WinObjs;

type
  TBookDefine = class
  private
    FBookmarks : TStringList;
  public
    isValid   : boolean;
    BookName  : string;
    URL       : string;
    PageNo    : integer;
    Zoom      : single;
    formX,formY,formW,formH : integer;
    viewX,viewY : integer;
    isFullScreen : boolean;
    // Bookmarks contain bookmark Names and page numbers(in objects)
    property  Bookmarks : TStringList  read FBookmarks;
    constructor Create;
    Destructor Destroy;override;
    procedure readConfig(ini : TCustomIniFile);
    procedure writeConfig(ini : TCustomIniFile);
    procedure viewBook;
    procedure saveBook;
    function  isURLValid(const URL:string):boolean;
    function  addBookmark(const bookmarkName:string;bookmarkPage:integer):boolean;
  end;

  TfmViewer = class(TForm)
    pnBottom: TPanel;
    pnStatus: TPanel;
    pnCurSize: TPanel;
    pnPageNo: TPanel;
    pmZoom: TPopupMenu;
    N111: TMenuItem;
    N121: TMenuItem;
    N131: TMenuItem;
    N141: TMenuItem;
    N151: TMenuItem;
    N161: TMenuItem;
    N171: TMenuItem;
    N181: TMenuItem;
    Viewer: TT_Pdg01;
    pnOriginSize: TPanel;
    pnZoom: TPanel;
    pnXY: TPanel;
    pmFunc: TPopupMenu;
    mnPrev: TMenuItem;
    mnNext: TMenuItem;
    mnGotoPage: TMenuItem;
    mnZoom: TMenuItem;
    N1: TMenuItem;
    mnFullScreen: TMenuItem;
    mnRefresh: TMenuItem;
    OpenDialog1: TOpenDialog;
    mnFitWidth: TMenuItem;
    mnFitHeight: TMenuItem;
    mnSpecify: TMenuItem;
    mnFitWidth1: TMenuItem;
    mnFitHeight1: TMenuItem;
    N2: TMenuItem;
    pnTools: TToolBar;
    btnOpen: TToolButton;
    btnNewBook: TToolButton;
    ToolButton3: TToolButton;
    btnPrev: TToolButton;
    ToolButton5: TToolButton;
    btnNext: TToolButton;
    ToolButton7: TToolButton;
    btnFullScreen: TToolButton;
    btnRefresh: TToolButton;
    ImageList1: TImageList;
    pmBooks: TPopupMenu;
    btnBookMan: TToolButton;
    ToolButton1: TToolButton;
    btnAbout: TToolButton;
    btnNewBookmark: TToolButton;
    btnGotoBookmark: TToolButton;
    ToolButton6: TToolButton;
    btnBookmarkMan: TToolButton;
    pmBookmarks: TPopupMenu;
    N3: TMenuItem;
    muNewBookmark: TMenuItem;
    muBookmarks: TMenuItem;
    procedure btnOpenClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure pnPageNoClick(Sender: TObject);
    procedure pnZoomClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure btnFullScreenClick(Sender: TObject);
    procedure SetTheZoom(Sender: TObject);
    procedure pnZoomDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ViewerScroll(Sender: TObject; x, y: Integer);
    procedure mnFullScreenClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure pmFuncPopup(Sender: TObject);
    procedure mnFitWidthClick(Sender: TObject);
    procedure mnFitHeightClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnNewBookClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBookManClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure CMDIALOGKEY(var Message:TMessage); message CM_DIALOGKEY;
    procedure btnNewBookmarkClick(Sender: TObject);
    procedure btnBookmarkManClick(Sender: TObject);
    procedure ViewerMouseAction(Sender: TObject; flag: Integer; Button,
      Shift: Smallint; x, y: Integer);
    procedure ViewerProgress(Sender: TObject; filelength, curpos: Integer);
    procedure ViewerInitDrawing(Sender: TObject; URL: Integer);
  private
    { Private declarations }
    FisFullScreen: boolean;
    oldLeft,oldTop,oldWidth,oldHeight : integer;
    fullscreenX,fullscreenY,fullscreenW,fullscreenH : integer;
    iniFile : TIniFile;
    bookNames : TStrings;
    curBook : TBookDefine;
    viewWin : WWindow;
    procedure SetIsFullScreen(const Value: boolean);
    procedure WMGETMINMAXINFO(var message : TWMGETMINMAXINFO);message WM_GETMINMAXINFO;
    procedure decZoom;
    procedure incZoom;
    procedure zoomTo(rate:single);
    procedure updateViewPoint;
    procedure goUp;
    procedure goDown;
    function  handleKey(keycode:word;shift :TShiftState =[]):word;
    procedure fitWidth;
    procedure fitHeight;
    procedure switchScreen;
    procedure getAllBooks;
    procedure RestructBooks;
    procedure openBook(sender : TObject);
    procedure saveBook;
    procedure openBookmark(sender : TObject);
    procedure addBookMenu(const bookName:string);
    procedure addBookmarkMenu(const bookmarkName:string;bookmarkPage:integer);
    procedure refreshView;
    procedure clearBookmarks;
    procedure RestructBookmarks;
    function  getcurPageNo: integer;
    procedure AfterLoadANewPage;
  public
    { Public declarations }
    procedure gotoPage(pageNo:integer);
    property  curPageNo : integer read getcurPageNo write gotoPage;
    property  isFullScreen : boolean read FisFullScreen write SetIsFullScreen;
    procedure gotoBookmark(bookmarkIndex : integer);
  end;

var
  fmViewer: TfmViewer;

resourcestring
  SNewBookMark = 'New Bookmark';
  SBookmarkName = 'Bookmark Name';

implementation

{$R *.DFM}

uses CompUtils,InpIntDlg, UBookMan,HYLAbout, UBookmarkMan;

{ TBookDefine }

procedure TBookDefine.readConfig(ini: TCustomIniFile);
var
  bookmarkName,bookmarkEntry : string;
  bookmarkCount,i : integer;
  bookmarkPage : integer;
begin
  assert(fmViewer<>nil);
  assert(ini<>nil);
  URL := ini.ReadString(BookName,'URL','');
  PageNo := ini.ReadInteger(BookName,'PageNo',1);
  formX := ini.ReadInteger(BookName,'X',fmViewer.left);
  formY := ini.ReadInteger(BookName,'Y',fmViewer.top);
  formW := ini.ReadInteger(BookName,'W',fmViewer.Width);
  formH := ini.ReadInteger(BookName,'H',fmViewer.Height);
  viewX := ini.ReadInteger(BookName,'VX',fmViewer.Viewer.ViewPoint_x);
  viewY := ini.ReadInteger(BookName,'VY',fmViewer.Viewer.ViewPoint_y);
  Zoom  := ini.ReadFloat(BookName,'Zoom',1);
  isFullScreen := ini.ReadBool(BookName,'Full',false);
  if not (isFullScreen) and ( (formW>Screen.Width) or (formH>Screen.Height)) then
    isFullScreen := true;
  // read bookmarks
  FBookmarks.Clear;
  bookmarkCount:=ini.ReadInteger(BookName,'Bookmarks',0);
  for i:=1 to bookmarkCount do
  begin
    bookmarkEntry:=IntToStr(i);
    bookmarkName:=ini.ReadString(BookName,bookmarkEntry+'.desc','');
    bookmarkPage:=ini.ReadInteger(BookName,bookmarkEntry+'.page',-1);
    if (bookmarkName<>'') {and (bookmarkPage>=0)} then
      FBookmarks.AddObject(bookmarkName,TObject(bookmarkPage));
  end;
end;

procedure TBookDefine.viewBook;
begin
  assert(fmViewer<>nil);

  fmViewer.clearBookmarks;

  //if isURLValid(URL) then
  begin
    fmViewer.Caption := Application.Title + ' ' + BookName;
    if isFullScreen then
      fmViewer.isFullScreen:=true else
      fmViewer.SetBounds(formX,formY,formW,formH);
    fmViewer.Viewer.URL := URL;
    //fmViewer.Viewer.GotoPageNum(PageNo);
    fmViewer.gotoPage(PageNo);
    fmViewer.zoomTo(Zoom);
    fmViewer.Viewer.MoveTo(viewX,viewY);
    isValid := true;

    fmViewer.RestructBookmarks;
  end;
end;

procedure TBookDefine.saveBook;
begin
  assert(fmViewer<>nil);
  if fmViewer.Viewer.IsPageValid>0 then
  begin
    URL := fmViewer.Viewer.URL;
    PageNo := fmViewer.curPageNo;
  end;
  zoom := fmViewer.Viewer.zoom;
  formX := fmViewer.Left;
  formY := fmViewer.Top;
  formW := fmViewer.Width;
  formH := fmViewer.Height;
  viewX := fmViewer.Viewer.ViewPoint_x;
  viewY := fmViewer.Viewer.ViewPoint_y;
  isFullScreen := fmViewer.isFullScreen;
end;


procedure TBookDefine.writeConfig(ini: TCustomIniFile);
var
  bookmarkName,bookmarkEntry : string;
  bookmarkCount,i : integer;
  bookmarkPage : integer;
begin
  assert(fmViewer<>nil);
  assert(ini<>nil);
  ini.writeString(BookName,'URL',URL);
  ini.writeInteger(BookName,'PageNo',PageNo);
  ini.writeInteger(BookName,'X',formX);
  ini.writeInteger(BookName,'Y',formY);
  ini.writeInteger(BookName,'W',formW);
  ini.writeInteger(BookName,'H',formH);
  ini.writeFloat(BookName,'Zoom',Zoom);
  ini.WriteInteger(BookName,'VX',viewX);
  ini.WriteInteger(BookName,'VY',viewY);
  ini.WriteBool(BookName,'Full',isFullScreen);

  // write bookmarks
  bookmarkCount:=FBookmarks.Count;
  ini.WriteInteger(BookName,'Bookmarks',bookmarkCount);
  for i:=1 to bookmarkCount do
  begin
    bookmarkEntry:=IntToStr(i);
    bookmarkName:=FBookmarks[i-1];
    bookmarkPage:=integer(FBookmarks.Objects[i-1]);
    ini.WriteString(BookName,bookmarkEntry+'.desc',bookmarkName);
    ini.WriteInteger(BookName,bookmarkEntry+'.page',bookmarkPage);
  end;
end;

function  TBookDefine.isURLValid(const URL:string):boolean;
begin
  result := URL<>'';
  if result then
    result := FileExists(URL);
end;

const
  moveSteps = 32;

constructor TBookDefine.Create;
begin
  inherited;
  FBookmarks := TStringList.create;
end;

destructor TBookDefine.Destroy;
begin
  FBookmarks.free;
  inherited;

end;

function  TBookDefine.addBookmark(const bookmarkName:string;
  bookmarkPage:integer):boolean;
begin
  if (bookmarkName<>'') {and (bookmarkPage>=0)} then
  begin
    FBookmarks.AddObject(bookmarkName,TObject(bookmarkPage));
    result := true;
  end else
    result := false;
end;

{ TfmViewer }

procedure TfmViewer.btnOpenClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    saveBook;
    curBook.isValid := false;
    Viewer.URL := OpenDialog1.FileName;
    Caption := Application.Title + ' '+ OpenDialog1.FileName;
    clearBookmarks;
  end;
end;

procedure TfmViewer.btnPrevClick(Sender: TObject);
begin
  Viewer.GotoPreviousPage;
end;

procedure TfmViewer.btnNextClick(Sender: TObject);
begin
  Viewer.GotoNextPage;
end;

procedure TfmViewer.pnPageNoClick(Sender: TObject);
var
  newPage : Integer;
begin
  newPage := curPageNo;
  if InputInteger('Goto Page','Page No(<0 is cont):',newPage) then
    //Viewer.GotoPageNum(newPage);
    gotoPage(newPage);
end;

procedure TfmViewer.pnZoomClick(Sender: TObject);
begin
  Popup(pmZoom);
end;

procedure TfmViewer.WMGETMINMAXINFO(var message: TWMGETMINMAXINFO);
begin
  inherited ;
  with message.MinMaxInfo^.ptMaxTrackSize do
  begin
    x:=2 * screen.width;
    y:=2 * screen.height;
  end;
end;

procedure TfmViewer.FormActivate(Sender: TObject);
begin
  viewWin.Handle := Viewer.Handle;
end;

procedure TfmViewer.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case key of
      #27 : isFullScreen := false; // ESC
      #9  : isFullScreen := not isFullScreen; // TAB
      '-','_' : decZoom;
      '=','+' : incZoom;
    end;
end;

procedure TfmViewer.SetIsFullScreen(const Value: boolean);
begin
  if (FisFullScreen <> Value) then
  begin
    FisFullScreen := value;
    if (FisFullScreen) then
    begin
      oldLeft:=left;
      oldTop:=top;
      oldWidth:=width;
      oldHeight:=height;
      setBounds(fullscreenX,fullscreenY,fullscreenW,fullscreenH);
    end else
    setBounds(oldLeft,oldTop,oldWidth,oldHeight);
  end;
end;

procedure TfmViewer.FormCreate(Sender: TObject);
begin
  FisFullScreen := false;
  // prepare form size
  oldLeft:=left;
  oldTop:=top;
  oldWidth:=width;
  oldHeight:=height;
  fullscreenX:=-(width-clientWidth) div 2;
  fullscreenY:=-(height-clientHeight)-pnTools.Height;
  fullscreenW:=Screen.width+(width-clientWidth);
  fullscreenH:= (height-clientHeight) // caption height
    + pnTools.Height + Screen.Height + pnBottom.Height;

  bookNames := TStringList.create;
  iniFile := TIniFile.create(ChangeFileExt(Application.ExeName,'.ini'));
  curBook := TBookDefine.create;
  curBook.isValid := false;
  getAllBooks;
  viewWin := WWindow.Create(0);
end;

procedure TfmViewer.btnFullScreenClick(Sender: TObject);
begin
  isFullScreen := true;
end;

procedure TfmViewer.SetTheZoom(Sender: TObject);
begin
  zoomTo(1/TComponent(Sender).tag);
end;

procedure TfmViewer.decZoom;
begin
  if Viewer.Zoom>0.01 then
    zoomTo(Viewer.Zoom*0.8);
end;

procedure TfmViewer.incZoom;
begin
  if Viewer.Zoom<8 then
    zoomTo(Viewer.Zoom/0.8);
end;

procedure TfmViewer.zoomTo(rate: single);
begin
  Viewer.SetZoom2(rate);
  Viewer.Refresh;
end;

procedure TfmViewer.pnZoomDblClick(Sender: TObject);
var
  zoom : integer;
begin
  zoom := round(100 * Viewer.Zoom);
  if InputInteger('Input Zoom Rate','Zoom Rate(%)',zoom,1,800) then
    zoomTo(zoom/100);
end;

procedure TfmViewer.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  handleKey(key,shift);
end;

procedure TfmViewer.ViewerScroll(Sender: TObject; x, y: Integer);
begin
  updateViewPoint;
end;

procedure TfmViewer.updateViewPoint;
begin
  pnXY.Caption := format('x:%d,y:%d',[Viewer.ViewPoint_X,Viewer.ViewPoint_Y]);
end;

procedure TfmViewer.goDown;
var
  X,Y,Y1: integer;
  DC : WDC;
begin
  X := Viewer.ViewPoint_X;
  Y := Viewer.ViewPoint_Y;
  if (Y+Viewer.Height+10)<Viewer.PageHeight then
  begin
    Viewer.MoveTo(X,Y+Viewer.Height-10);
    Y1 := Y+Viewer.Height - Viewer.ViewPoint_Y;
    DC := viewWin.GetDCObj(false);
    try
      DC.Canvas.Pen.Color := clRed;
      DC.Canvas.MoveTo(0,Y1+10);
      DC.Canvas.LineTo(Viewer.Width,Y1+10);
    finally
      DC.free;
    end;
  end else
  begin
    Viewer.GotoNextPage;
    Viewer.MoveTo(X,0);
  end;
end;

procedure TfmViewer.goUp;
var
  X,Y : integer;
begin
  X := Viewer.ViewPoint_X;
  Y := Viewer.ViewPoint_Y;
  if Y>=Viewer.Height then
  begin
    Viewer.MoveTo(X,Y - Viewer.Height);
  end else
  if Y>=10 then
    Viewer.MoveTo(X,0) else
  if Viewer.PageNum>1 then
  begin
    Viewer.GotoPreviousPage;
    Viewer.MoveTo(X,Viewer.PageHeight - Viewer.Height);
  end else
    Viewer.MoveTo(X,0);
end;

function  TfmViewer.handleKey(keycode:word;shift :TShiftState =[]):word;
begin
  case keycode of
      VK_PRIOR : goUp;
      VK_NEXT	 : goDown;

      VK_left  : viewer.MoveStep(-moveSteps,0);
      VK_right : viewer.MoveStep(moveSteps,0);
      VK_up    : if ssCtrl in shift then
                    btnPrevClick(self) else
                    viewer.MoveStep(0,-moveSteps);
      VK_down  : if ssCtrl in shift then
                    btnNextClick(self) else
                    viewer.MoveStep(0,moveSteps);

      VK_Return : refreshView;
      VK_F1    : btnAboutClick(nil);
      VK_F2    : btnOpenClick(nil);
      VK_F3    : btnNewBookClick(nil);
      VK_F4    : if shift=[] then
                    switchScreen;
      VK_F5    : fitWidth;
      VK_F6    : fitHeight;
      VK_F7    : btnNewBookmarkClick(nil);
  else
    begin
      result := keycode;
      exit;
    end;
  end;
  result:= 0;
end;

procedure TfmViewer.mnFullScreenClick(Sender: TObject);
begin
  switchScreen;
end;

procedure TfmViewer.btnRefreshClick(Sender: TObject);
begin
  //Viewer.Refresh;
  refreshView;
end;

procedure TfmViewer.pmFuncPopup(Sender: TObject);
begin
  mnFullScreen.Checked := isFullScreen;
end;

procedure TfmViewer.mnFitWidthClick(Sender: TObject);
begin
  FitWidth;
end;

procedure TfmViewer.mnFitHeightClick(Sender: TObject);
begin
  FitHeight;
end;

procedure TfmViewer.fitHeight;
var
  oriH : integer;
begin
  if Viewer.IsPageValid>0 then
  begin
    oriH := Viewer.OrgPageHeight;
    if (oriH>0) and (Viewer.Height>0) then
    begin
      ZoomTo(Viewer.Height/oriH);
    end;
  end;
end;

procedure TfmViewer.fitWidth;
var
  oriW : integer;
begin
  if Viewer.IsPageValid>0 then
  begin
    oriW := Viewer.OrgPageWidth;
    if (oriW>0) and (Viewer.Width>0) then
    begin
      ZoomTo(Viewer.Width/oriW);
    end;
  end;
end;

procedure TfmViewer.switchScreen;
begin
  isFullScreen := not isFullScreen;
end;

procedure TfmViewer.getAllBooks;
begin
  iniFile.ReadSections(bookNames);
  RestructBooks;
end;

procedure TfmViewer.FormDestroy(Sender: TObject);
begin
  //saveBook;
  curBook.free;
  iniFile.free;
  bookNames.free;
  viewWin.free;
end;

procedure TfmViewer.openBook(sender: TObject);
begin
  saveBook;
  curBook.BookName := TMenuItem(sender).caption;
  curBook.readConfig(iniFile);
  curBook.viewBook;
end;

procedure TfmViewer.saveBook;
begin
  assert(curBook<>nil);
  assert(iniFile<>nil);
  if curBook.isValid then
  begin
    curBook.saveBook;
    curBook.writeConfig(IniFile);
    IniFile.UpdateFile;
  end;
end;

procedure TfmViewer.btnNewBookClick(Sender: TObject);
var
  bookName : string;
begin
  bookName := '';
  if (Viewer.IsPageValid>0) and InputQuery('New Book','Book Name',bookName) then
  begin
    if BookName<>'' then
    begin
      saveBook;
      curBook.BookName := BookName;
      curBook.isValid := true;
      bookNames.Add(bookName);
      addBookMenu(bookName);
    end;
  end;
end;

procedure TfmViewer.addBookMenu(const bookName:string);
var
  newItem : TMenuItem;
begin
  newItem := TMenuItem.Create(pmBooks);
  newItem.Caption := bookName;
  newItem.OnClick := openBook;
  pmBooks.Items.add(newItem);
end;


procedure TfmViewer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  saveBook;
end;

procedure TfmViewer.refreshView;
var
  x,y : integer;
begin
  x := Viewer.ViewPoint_x;
  y := Viewer.ViewPoint_y;
  Viewer.Refresh;
  Viewer.MoveTo(x,y);
end;

procedure TfmViewer.btnBookManClick(Sender: TObject);
begin
  dlgBookMan.execute(bookNames,iniFile);
  RestructBooks;
end;

procedure TfmViewer.btnAboutClick(Sender: TObject);
begin
  StartAbout(0);
end;

procedure TfmViewer.CMDIALOGKEY(var Message: TMessage);
begin
  handleKey(Message.WParam,KeyDataToShiftState(Message.LParam));
  inherited;
end;

procedure TfmViewer.clearBookmarks;
begin
  pmBookmarks.Items.Clear;
end;

procedure TfmViewer.RestructBookmarks;
var
  bookmarkName,bookmarkEntry : string;
  bookmarkCount,i : integer;
  bookmarkPage : integer;
begin
  bookmarkCount:=curBook.Bookmarks.Count;
  for i:=1 to bookmarkCount do
  begin
    bookmarkEntry:=IntToStr(i);
    bookmarkName:=curBook.Bookmarks[i-1];
    bookmarkPage:=integer(curBook.Bookmarks.Objects[i-1]);
    addBookmarkMenu(bookmarkName,bookmarkPage);
  end;
end;

procedure TfmViewer.addBookmarkMenu(const bookmarkName: string;
  bookmarkPage: integer);
var
  newItem : TMenuItem;
begin
  newItem := TMenuItem.Create(pmBookmarks);
  newItem.Caption := bookmarkName;
  newItem.tag := bookmarkPage;
  newItem.OnClick := openBookmark;
  pmBookmarks.Items.add(newItem);
end;

procedure TfmViewer.openBookmark(sender: TObject);
var
  page : integer;
begin
  page := TMenuItem(sender).tag;
  //Viewer.GotoPageNum(page);
  gotoPage(page);
end;

procedure TfmViewer.btnNewBookmarkClick(Sender: TObject);
var
  bookmarkName : string;
  bookmarkPage : integer;
begin
  if curBook.isValid and (Viewer.IsPageValid>0)
    and InputQuery(SNewBookMark,SBookmarkName,bookmarkName) then
  begin
    bookmarkPage:=curPageNo;
    if curBook.addBookmark(bookmarkName,bookmarkPage) then
      addBookmarkMenu(bookmarkName,bookmarkPage);
  end;
end;

procedure TfmViewer.btnBookmarkManClick(Sender: TObject);
begin
  if curBook.isValid then
  begin
    if dlgBookmarkMan.execute(curBook.Bookmarks) then
    begin
      clearBookmarks;
      RestructBookmarks;
    end;
  end;
end;

procedure TfmViewer.RestructBooks;
var
  i : integer;
begin
  pmBooks.Items.clear;
  for i:=0 to bookNames.count-1 do
  begin
    addBookMenu(bookNames[i]);
  end;
end;

procedure TfmViewer.gotoBookmark(bookmarkIndex: integer);
begin
  if (bookmarkIndex>=0) and (bookmarkIndex<curBook.Bookmarks.count) then
    GotoPage(Integer(curBook.Bookmarks.objects[bookmarkIndex]));
end;

procedure TfmViewer.gotoPage(pageNo: integer);
begin
  if pageNo>=0 then
    Viewer.GotoContentNum(pageNo) else
    Viewer.GotoDirNum(-pageNo);
end;

function TfmViewer.getcurPageNo: integer;
begin
  if Viewer.isDir>0 then
    result := -Viewer.PageNum else
    result := Viewer.PageNum;
end;

procedure TfmViewer.ViewerMouseAction(Sender: TObject; flag: Integer;
  Button, Shift: Smallint; x, y: Integer);
begin
  if Button=Ord(VK_RBUTTON) then
  begin
    Popup(pmFunc);
  end;
end;

procedure TfmViewer.ViewerProgress(Sender: TObject; filelength,
  curpos: Integer);
begin
  {
  if Viewer.isDir>0 then
    pnPageNo.caption := 'cont:'+IntToStr(Viewer.pagenum) else
    pnPageNo.caption := IntToStr(Viewer.pagenum);
  pnStatus.caption := 'Transfering...';
  }
  if filelength<>0 then
    pnStatus.caption := Format('%d%%',[CurPos*100 div filelength]) else
    pnStatus.caption := '';
end;

procedure TfmViewer.ViewerInitDrawing(Sender: TObject; URL: Integer);
begin
  AfterLoadANewPage;
end;

procedure TfmViewer.AfterLoadANewPage;
begin
  if Viewer.IsPageValid>0 then
    pnStatus.caption := 'Complete' else
    pnStatus.caption := 'Bad page';
  pnZoom.Caption := format('%.1f%%',[Viewer.Zoom*100]);
  pnOriginSize.caption := format('%d * %d',
    [Viewer.OrgPageWidth,Viewer.OrgPageHeight]);
  pnCurSize.Caption := format('%d * %d',
    [Viewer.PageWidth,Viewer.PageHeight]);
  updateViewPoint;
end;

end.
