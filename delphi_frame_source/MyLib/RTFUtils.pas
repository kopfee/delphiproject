unit RTFUtils;

// %RTFUtils : RichEdit扩充
(*****   Code Written By Huang YanLai   *****)

{ This version makes some change:
  1. Name saved into /load from [secname].name,
  2. THotLinkItem.SaveToIniFile(IniFile: TIniFile; const SecName : string);
  Add param SecName.
  3. Add [root] section
}
interface

uses Windows,messages,sysutils,classes,controls,
	richEdit,ComCtrls,Graphics,StdCtrls,IniFiles,
  ComWriUtils;

{
// if succeed, return true
// Note: This function does not work!

function CharIndexFromPos(TheHandle : HWnd;x,y:integer;
	var CharIndex,LineIndex : word):boolean;

const
  EM_POSFROMCHAR                      = WM_USER + 38;
  EM_CHARFROMPOS                      = WM_USER + 39;
}

{ The follows do not work!

  1. setCaretPos do not change SelStart
  2. EM_POSFROMCHAR EM_CHARFROMPOS
}

const
  MinDEL = 5;
type
 //	THotLinkItem = class;
 //	THotLinkItems = class;

  THotLinkClickEvent = procedure(Sender:TCustomRichEdit;CharIndex : integer) of object;
  TDecideHotLinkEvent = procedure(Sender:TCustomRichEdit; TextAttr : TTextAttributes;
  												var HotLink:boolean)of object;
  THotLinkOverEvent = procedure(Sender:TCustomRichEdit; isover : boolean)of object;
  THotLinkEvent = procedure(Sender:TCustomRichEdit; const Link : string)of object;

  TCustomRichEditEx = class(TCustomRichEdit)
  private
    FFitSize : boolean;
  	//procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    //procedure SetParent(AParent : TWincontrol);override;
    procedure RequestSize(const Rect: TRect); override;
  public
    function 	CanPaste:boolean;
    function 	CanUndo:boolean;
    procedure	Undo;
    procedure ScrollToCaret;
    procedure PageDown;
    procedure PageUp;
    procedure LineDown;
    procedure LineUp;
    procedure GoTop;
    procedure GoBottom; // not implement
    procedure LINESCROLL(dx,dy : integer);
    procedure FitContentSize;
  end;

  // %TCustomRichView : 支持文本中的热点
	TCustomRichView = class(TCustomRichEditEx)
  private
    lastX,lastY : integer;
    FOnHotClick: THotLinkClickEvent;
    FHotCursor: TCursor;
    FOnDecideHotLink: TDecideHotLinkEvent;
    FNormalCursor: TCursor;
    FOnHotOver: THotLinkOverEvent;
    FViewMode: boolean;
    procedure SetViewMode(const Value: boolean);
  protected
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton;
    	Shift: TShiftState; X, Y: Integer); override;

    function  IsHotLink : boolean;virtual;
    procedure HotClick; virtual;

    property OnHotClick : THotLinkClickEvent read FOnHotClick write FOnHotClick;
    property OnDecideHotLink : TDecideHotLinkEvent read FOnDecideHotLink write FOnDecideHotLink;
    property OnHotOver:THotLinkOverEvent read FOnHotOver write FOnHotOver;
    property HotCursor:TCursor read FHotCursor write FHotCursor;
    property NormalCursor:TCursor read FNormalCursor write FNormalCursor;
    // only when ViewMode is true, we can view hot link
    property ViewMode:boolean read FViewMode write SetViewMode default true;

    procedure DoHotOver(HotState : boolean); dynamic;
  public
  	{// for test
    lbSelStart : TLabel;
    lbX: TLabel;
    // end test}
  	constructor Create(AOwner: TComponent); override;
    //function 	GetCurrentWord:string;
    function  GetCurrentLine:integer;
    function  CurrentUnderLine:Boolean;
  published

  end;

  TRichView=class(TCustomRichView)
  published
    property OnHotClick;
    property OnDecideHotLink;
    property OnHotOver;
    property HotCursor;
    property NormalCursor;
    property ViewMode;

    property Align;
    property Alignment;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property BorderWidth;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property HideScrollBars;
    property ImeMode;
    property ImeName;
    property Constraints;
    property Lines;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PlainText;
    property PopupMenu;
    property ReadOnly;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property WantTabs;
    property WantReturns;
    property WordWrap;
    property OnChange;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnProtectChange;
    property OnResizeRequest;
    property OnSaveClipboard;
    property OnSelectionChange;
    property OnStartDock;
    property OnStartDrag;

  end;

type
	THotLinkItem = class
  public
    Start , Length : integer;
    LinkTo : string;
    Name 	: string;
    Description	: string;
    constructor Create;
    Constructor CreateFromRichEdit(RichEdit : TCustomRichEdit);
    Constructor CreateFromIniFile(IniFile : TIniFile; const SecName:string);
    procedure 	LoadFromRichEdit(RichEdit : TCustomRichEdit);
    procedure 	SaveToIniFile(IniFile : TIniFile;const SecName : string);
    //procedure 	SaveToFile();
    function    InRange(pos : integer):boolean;
    procedure 	Selected(RichEdit : TCustomRichEdit);
    function 		IsValid(RichEdit : TCustomRichEdit): boolean;
  end;

  THotLinkItems = class(TObjectList)
  private
    function GetItems(index: integer): THotLinkItem;
  protected

  public
    constructor Create;
    destructor  destroy; override;
    // Treate the file as a Ini File
    procedure   SaveToFile(const filename:string);
    procedure   LoadFromFile(const filename:string);
    property  	Items[index : integer] : THotLinkItem read GetItems; default;
    // get a HotLinkItem by Item's name
    // If not found , return nil
    function		ItemByName(const ItemName:string):THotLinkItem;
    // get a HotLinkItem by pos
    // If not found , return nil
    function		ItembyPos(Pos : integer):THotLinkItem;
    // When Add a item, Check the item name is a Unique Name
    // Call AddItem, you do not free the Item
    function		AddItem(Item : THotLinkItem):integer;
    function		AddItemname(const ItemName:string):THotLinkItem;
    procedure 	Remove(const ItemName:string);
    function		IndexOfItem(Item:THotLinkItem):integer;
    function		IndexOfItemName(const ItemName:string):integer;
    function		IndexOfPos(Pos : integer):integer;
  published

  end;

  // %THyperTextView: 将热点信息保存在附属文件中
	THyperTextView = class(TCustomRichView)
  private
    FOnHotLink: THotLinkEvent;
    function GetHotItem: THotLinkItem;
  protected
    FHotItems : THotLinkItems;
    //FHotItem : THotLinkItem;
    FItemIndex : Integer;
    function  IsHotLink : boolean; override;
    procedure HotClick; override;
    procedure DoHotOver(HotState : boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    Destructor 	destroy; override;
    // You should use these procedures in replace of lines' methods
    procedure 	LoadFromFile(const Filename:string); virtual;
    procedure 	SaveToFile(const Filename:string); virtual;
    procedure 	New;
    //property 	HotItem : THotLinkItem read FHotItem;
    property 		HotItem : THotLinkItem read GetHotItem;
    property  	HotItems : THotLinkItems read FHotItems;
    property  	ItemIndex : Integer Read FItemIndex;
  published
    property		OnHotLink : THotLinkEvent read FOnHotLink write FOnHotLink;
    property 		OnHotOver;
    //property OnHotClick;
    //property OnDecideHotLink;
    property 		HotCursor;
    property 		NormalCursor;
    property 		ViewMode;

    property Align;
    property Alignment;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property BorderWidth;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property HideScrollBars;
    property ImeMode;
    property ImeName;
    property Constraints;
    property Lines;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PlainText;
    property PopupMenu;
    property ReadOnly;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property WantTabs;
    property WantReturns;
    property WordWrap;
    property OnChange;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnProtectChange;
    property OnResizeRequest;
    property OnSaveClipboard;
    property OnSelectionChange;
    property OnStartDock;
    property OnStartDrag;
  end;

const
  LinkFileExt = '.HLK';
  RootName = 'Root';
  CountName = 'Count';

procedure CopyFontToTextAttr(AFont : TFont; ATextAttr : TTextAttributes);

procedure CopyTextAttrToFont(ATextAttr : TTextAttributes; AFont : TFont);

function 	IsRTFFile(const FileName:string):boolean;

type
  // %THyperTextViewEx : 通过增加空行的方式设定行间距
  THyperTextViewEx = class(THyperTextView)
  private
    FAutoFormat: boolean;
    FLineSpace: integer;
    FFileName: 	string;
    procedure   WMSize(var message : TWMSize);message WM_Size;
    procedure   SetLineSpace(const Value: integer);
  protected
    FUpdating : boolean;
  public
    constructor Create(AOwner : TComponent); override;
    property    FileName : string
                  read FFileName write FFileName;
    //property    LastLineCount : integer read FLastLineCount;
    procedure   LoadFromFile(const AFileName : string); override;
    procedure   ReFormat;
    procedure   UpdateHotItems(Start : integer; Increament : integer);
    procedure   SetEditRect(Exclude : boolean);
  published
    property    AutoFormat : boolean
                  read FAutoFormat write FAutoFormat default true;
    property    LineSpace : integer
                  read FLineSpace write SetLineSpace default 5;
  end;

implementation

uses SafeCode;

// if succeed, return true
// Note: This function does not work!
{
function CharIndexFromPos(TheHandle : HWnd;x,y:integer;
	var CharIndex,LineIndex : word):boolean;
var
  WinReturn : integer;
  wx,wy : word;
  lValue : longword;
begin
  if (x<0) or (y<0) then
  begin
    result:=false;
    exit;
  end;
  // for test
  //y:=4;
  //

  //
  lValue := makelong(x,y);
  //

  wx := loWord(lValue);
  wy := hiWord(lValue);

  WinReturn:=sendMessage(TheHandle,EM_CHARFROMPOS,0,lValue);
  if WinReturn=-1 then result:=false
  else
  begin
    result:=true;
    charIndex := loword(WinReturn);
    lineIndex := HiWord(WinReturn);
  end;
end;
}
{ TRichView }

constructor TCustomRichView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHotCursor := crHandPoint;
  FNormalCursor := crArrow;
  Cursor := FNormalCursor;
  FViewMode := true;
  ReadOnly := true;
end;

function TCustomRichView.CurrentUnderLine: Boolean;
begin
  result :=  fsUnderLine in SelAttributes.Style;
end;

procedure TCustomRichView.DoHotOver(HotState: boolean);
begin
  if Assigned(FOnHotOver) then FOnHotOver(self,HotState);
end;

function TCustomRichView.GetCurrentLine: integer;
begin
  result:=SendMessage(Handle, EM_EXLINEFROMCHAR, 0, SelStart);
end;

{
function TCustomRichView.GetCurrentWord: string;
var
  CurLine : string;
  MyPos : TPoint;
  Index : integer;
begin
  if SelLength>0 then result:=selText
  else
  begin
    MyPos := GetCaretPos;
    if (MyPos.x>=0) and (MyPos.y>=0) then
    begin
      CurLine := Lines[MyPos.y];
      Index := MyPos.x;
      // simple way
      result := CurLine[index];
      // end simple way
    end
    else result:='';
  end;
end;
}
procedure TCustomRichView.HotClick;
begin
  if Assigned(FOnHotClick) then FOnHotClick(self,SelStart);
end;

function TCustomRichView.IsHotLink: boolean;
begin
  if Assigned(FOnDecideHotLink) then
    FOnDecideHotLink(self,SelAttributes,result)
  else result:=CurrentUnderLine;
end;

procedure TCustomRichView.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseDown(Button,shift,X,Y);
  if ViewMode and (Button=mbLeft) and isHotLink then
  begin
    HotClick;
  end;
end;

procedure TCustomRichView.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Msg : TWMMouse;
  HotState : boolean;
  //SaveSelStart : integer;
begin
// must use MinDEL to control the rate of MouseMove otherwise you'll lose.
// Add viewmode to act as normal
// Add condition : (SelLength=0) to Resolve Text select
  if ViewMode and
  ((abs(lastx-x)>MinDEL) or (abs(lasty-y)>MinDEL))
   and (SelLength=0)
  then
  begin
    // simulate a mouse click to Set SelStart to current position of the mouse.
    Msg.Msg:=WM_LButtonDown;
    Msg.Keys:= MK_LBUTTON;
    msg.XPos:=x;
    msg.YPos:=y;
    // It does not affect delphi's message-handling
    // to use defaultHandler to replace SendMessage or Perform
    defaultHandler(msg);
    Msg.Msg:=WM_LButtonUP;
    Msg.Keys:= 0;
    defaultHandler(msg);
    HideCaret(handle);

    {// for test
    lbSelStart.caption := IntToStr(SelStart);
    lbX.caption := IntToStr(x);
    // end test}
    HotState := isHotLink;
    if HotState then
      Cursor := HotCursor
    else Cursor := NormalCursor;

    //if Assigned(FOnHotOver) then FOnHotOver(self,isHotLink);
    DoHotOver(HotState);

    lastX := x;
	  lastY := y;
  end;
  inherited MouseMove(Shift,x,y);
end;

{ THotLinkItems }

constructor THotLinkItems.Create;
begin
  inherited Create(true);
end;

destructor THotLinkItems.destroy;
begin
  clear;
  inherited destroy;
end;


procedure THotLinkItems.Remove(const ItemName: string);
var
  i : integer;
begin
  i:=IndexOfItemName(ItemName);
  if i>=0 then delete(i);
end;

function	THotLinkItems.AddItem(Item: THotLinkItem):integer;
begin
  if Item<>nil then
  begin
  	{if UniqueName(Item.name) then
	  	result:=FStrings.AddObject(Item.name,item)
    else result:=-1;}
    result := Add(Item);
  end
  else result:=-1;
end;

function THotLinkItems.AddItemname(const ItemName: string): THotLinkItem;
begin
  {if UniqueName(ItemName) then
  begin
    result := THotLinkItem.Create;
	  result.name := ItemName;
  	FStrings.AddObject(ItemName,result);
  end
  else result:=nil;}
  result := THotLinkItem.Create;
  result.name := ItemName;
  AddItem(result);
end;

function THotLinkItems.GetItems(index: integer): THotLinkItem;
begin
  result := THotLinkItem(inherited Items[index]);
end;

function THotLinkItems.ItemByName(const ItemName: string): THotLinkItem;
var
  i : integer;
begin
  i := IndexOfItemName(ItemName);
  if i<0 then result:=nil
  else  result := Items[i];
end;

function THotLinkItems.ItembyPos(Pos: integer): THotLinkItem;
var
  i : integer;
begin
  I:= IndexOfPos(pos);
  if i<0 then result:=nil
  else result:=Items[i];
end;

procedure THotLinkItems.LoadFromFile(const filename: string);
var
  IniFile : TIniFile;
  i : integer;
  ACount : integer;
  AFileName : string;
  Names : TStringList;
begin
  // avoid finding file in windows directory
  AFileName := expandFilename(filename);
  IniFile := TIniFile.Create(AFileName);
  try
  	Clear;
    if IniFile.SectionExists(RootName) then
    begin
    // for new version
	    ACount := IniFile.ReadInteger(RootName,countName,0);
  	  for i:=0 to Acount-1 do
    	   AddItem(
      	 	THotLinkItem.CreateFromIniFile(
        		IniFile,IntToStr(i)));
    end
    else
    begin
    // for old version
      Names := TStringList.Create;
      try
        IniFile.ReadSections(Names);
        for i:=0 to Names.count-1 do
          AddItem(
      	 	THotLinkItem.CreateFromIniFile(
        		IniFile,Names[i]));
      finally
        Names.free;
      end;
    end;
  finally
    IniFile.free;
  end;
end;


procedure THotLinkItems.SaveToFile(const filename: string);
var
  IniFile : TIniFile;
  i : integer;
  AFileName : string;
begin
  AFileName := expandFileName(Filename);
  DeleteFile(Afilename);
  IniFile := TIniFile.Create(Afilename);
  try
    IniFile.WriteInteger(RootName,CountName,Count);
	  for i:=0 to count-1 do
  		Items[i].SaveToIniFile(IniFile,IntToStr(i));
    IniFile.UpdateFile;
  finally
    IniFile.free;
  end;
end;

function THotLinkItems.IndexOfItem(Item: THotLinkItem): integer;
begin
  result := inherited IndexOf(Item);
end;

function THotLinkItems.IndexOfItemName(const ItemName: string): integer;
var
  i : integer;
begin
  for i:=0 to Count-1 do
    if ItemName=Items[i].name then
    begin
      result := i;
      exit;
    end;
  result := -1;
end;

function THotLinkItems.IndexOfPos(Pos: integer): integer;
var
  i : integer;
begin
  for i:=0  to count-1 do
    if items[i].InRange(pos) then
    begin
      result := i;
      exit;
    end;
  result := -1;
end;

{ THotLinkItem }

constructor THotLinkItem.CreateFromRichEdit(RichEdit: TCustomRichEdit);
begin
	CheckObject(RichEdit,'Error : RichEdit is nil.');
  inherited Create;
  CheckNotZero(RichEdit.SelLength);
  LoadFromRichEdit(RichEdit);
  Description := '';
  LinkTo:='';
end;

constructor THotLinkItem.CreateFromIniFile(IniFile: TIniFile;
  const SecName: string);
begin
	CheckObject(IniFile,'Error : IniFile is nil');
  inherited Create;
  //Name := SecName;
  Name :=  IniFile.ReadString(SecName,'Name','');
  // for old version
  if name='' then name:=SecName;

  Start := IniFile.ReadInteger(SecName,'Start',0);
  Length:= IniFile.ReadInteger(SecName,'Length',0);
  Description:=IniFile.ReadString(Secname,'Description','');
	LinkTo:=IniFile.ReadString(Secname,'LinkTo','');
end;

procedure THotLinkItem.SaveToIniFile(IniFile: TIniFile; const SecName : string);
begin
  CheckObject(IniFile,'Error : IniFile is nil');
  IniFile.WriteString(SecName,'Name',Name);
  IniFile.WriteInteger(SecName,'Start',start);
  IniFile.WriteInteger(SecName,'Length',Length);
  IniFile.WriteString(SecName,'Description',Description);
  IniFile.WriteString(SecName,'LinkTo',LinkTo);
end;

function THotLinkItem.InRange(pos: integer): boolean;
begin
  result := ( (pos>=Start) and (pos<start+length) );
end;

procedure THotLinkItem.Selected(RichEdit: TCustomRichEdit);
begin
  CheckObject(RichEdit,'Error : RichEdit is nil.');
  with RichEdit do
  begin
    SelStart := Start;
    SelLength := length;
  end;
end;

function THotLinkItem.IsValid(RichEdit: TCustomRichEdit): boolean;
begin
  CheckObject(RichEdit,'Error : RichEdit is nil.');
  with RichEdit do
  begin
    SelStart := Start;
    SelLength := length;
    result:=SelText=self.name;
  end;
end;

procedure THotLinkItem.LoadFromRichEdit(RichEdit: TCustomRichEdit);
begin
  Start := RichEdit.SelStart;
  Length := RichEdit.SelLength;
  Name :=	RichEdit.SelText;
end;

constructor THotLinkItem.Create;
begin
  inherited Create;
  Start := 0;
  Length := 0;
  Name := '';
  LinkTo := '';
  Description := '';
end;

{ THyperTextView }

constructor THyperTextView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FViewMode := true;
  FHotItems := THotLinkItems.Create;
  //FHotItem := nil;
  FItemIndex:=-1;
end;

destructor THyperTextView.destroy;
begin
  FHotItems.free;
  inherited destroy;
end;

procedure THyperTextView.DoHotOver(HotState: boolean);
begin
  if HotState then
    Hint := HotItem.Description
  else
    Hint := '';
  inherited DoHotOver(HotState);
end;

function THyperTextView.GetHotItem: THotLinkItem;
begin
  if ItemIndex<0 then result:=nil
  else result:=HotItems[ItemIndex];
end;

procedure THyperTextView.HotClick;
begin
  if Assigned(OnHotLink) then OnHotLink(self,HotItem.LinkTo);
end;

function THyperTextView.IsHotLink: boolean;
begin
	FItemIndex:=FHotItems.IndexOfPos(SelStart);
  //FHotItem := ItembyPos(SelStart);
  result:= (FItemIndex>=0);
end;

procedure THyperTextView.LoadFromFile(const Filename: string);
var
  LinkFile : string;
begin
  Lines.LoadFromFile(Filename);
  LinkFile:=ChangeFileExt(Filename,LinkFileExt);
  FHotItems.LoadFromFile(LinkFile);
  //FHotItem := nil;
  FItemIndex := -1;
  // new add
  HideCaret(handle);
end;


procedure THyperTextView.New;
begin
  FHotItems.Clear;
  Lines.Clear;
end;

procedure THyperTextView.SaveToFile(const Filename: string);
var
  LinkFile : string;
begin
  Lines.SaveToFile(FileName);
  LinkFile:=ChangeFileExt(Filename,LinkFileExt);
  FHotItems.SaveToFile(LinkFile);
end;

procedure TCustomRichView.SetViewMode(const Value: boolean);
begin
  FViewMode := Value;
  ReadOnly := FViewMode;
  Cursor:= NormalCursor;
end;

procedure CopyFontToTextAttr(AFont : TFont; ATextAttr : TTextAttributes);
begin
  with ATextAttr do
  begin
    //CharSet := AFont.CharSet;
    Name := AFont.name;
    Style := AFont.Style;
    Size := AFont.Size;
    Color := AFont.Color;
    Pitch := AFont.Pitch;
  end;
end;

procedure CopyTextAttrToFont(ATextAttr : TTextAttributes; AFont : TFont);
begin
  with ATextAttr do
  begin
    //AFont.CharSet := CharSet;
    AFont.name := Name;
    AFont.Style := Style;
    AFont.Size := Size;
    AFont.Color := Color;
    AFont.Pitch := Pitch;
  end;
end;

function 	IsRTFFile(const FileName:string):boolean;
begin
  result := CompareText(ExtractFileExt(Filename),'.RTF')=0;
end;

{ TCustomRichEditEx }

function TCustomRichEditEx.CanPaste: boolean;
begin
  result := Perform(EM_CANPASTE, 0, 0) <> 0;
end;

function TCustomRichEditEx.CanUndo: boolean;
begin
  result := Perform(EM_CANUNDO, 0, 0) <> 0;
end;
(*
procedure TCustomRichEditEx.CMColorChanged(var Message: TMessage);
begin
  //inherited;
  if (parent<>nil) {and (HandleAllocated)} then
	  SendMessage(handle,EM_SETBKGNDCOLOR,0,LParam(Color));
end;
*)
procedure TCustomRichEditEx.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  params.WindowClass.style :=
  	params.WindowClass.style or CS_PARENTDC;
end;

procedure TCustomRichEditEx.GoBottom;
begin
  //SelStart:=
end;

procedure TCustomRichEditEx.GoTop;
begin
  SelStart:=0;
  SelLength:=0;
	ScrollToCaret;
end;

procedure TCustomRichEditEx.LineDown;
begin
  Perform(EM_Scroll,SB_LINEDOWN,0);
end;

procedure TCustomRichEditEx.LineUp;
begin
  Perform(EM_Scroll,SB_LINEUP,0);
end;

procedure TCustomRichEditEx.PageDown;
begin
  Perform(EM_Scroll,SB_PAGEDOWN,0);
end;

procedure TCustomRichEditEx.PageUp;
begin
  Perform(EM_Scroll,SB_PAGEUP,0);
end;

procedure TCustomRichEditEx.LINESCROLL(dx, dy: integer);
begin
  perform(EM_LINESCROLL,dx,dy);
end;

procedure TCustomRichEditEx.ScrollToCaret;
begin
  Perform(EM_SCROLLCARET,0,0);
end;

(*
procedure TCustomRichEditEx.SetParent(AParent: TWincontrol);
begin
  inherited SetParent(AParent);
  if (parent<>nil) {and (HandleAllocated)} then
	  SendMessage(handle,EM_SETBKGNDCOLOR,0,LParam(Color));
end;
*)
procedure TCustomRichEditEx.Undo;
begin
  if HandleAllocated then
  	SendMessage(Handle, EM_UNDO, 0, 0);
end;

procedure TCustomRichEditEx.RequestSize(const Rect: TRect);
begin
  inherited RequestSize(Rect);
  if FFitSize then
  begin
    width := Rect.right-Rect.left;
    Height := Rect.bottom-Rect.top;
  end;
end;

procedure TCustomRichEditEx.FitContentSize;
begin
  FFitSize:=true;
  Perform(EM_REQUESTRESIZE,0,0);
	FFitSize:=false;
end;

{ THyperTextViewEx }

constructor THyperTextViewEx.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLineSpace := 5;
  FAutoFormat := true;
end;

procedure THyperTextViewEx.LoadFromFile(const AFileName: string);
begin
  //SetEditRect;
  FFileName := AFileName;
  if AutoFormat then
    ReFormat
  else
    inherited LoadFromFile(AFileName);
end;

procedure THyperTextViewEx.ReFormat;
var
  i : integer;
  j : integer;
  count : integer;
  Sel : integer;
  InsertPoint : integer;
  incr : integer;
begin
  if not FileExists(FFileName) then exit;
  if ScrollBars = ssVertical then
    SetEditRect(true)
  else
    SetEditRect(false);
  FUpdating := true;
  inherited LoadFromFile(FFileName);
  count := lines.count;
  lines.BeginUpdate;
  for i := 0 to count-1-1 do
  begin
    j := 2*i+1; //RichEdit1.lines.count-2*i-1;
    InsertPoint := SendMessage(Handle, EM_LINEINDEX, j, 0);
    Sel := InsertPoint - 1;
    //Sel := InsertPoint - 2;
    SelStart:=Sel;
    SelLength := 2;
    if (SelText=#13#10) then
    begin
      // previous line has a return char
      lines.Insert(j,' ');
      incr := 3;
    end
    else
    begin
      // previous line has no return char
      lines.Insert(j,#13#10' ');
      incr := 5;
    end;

    Sel := SendMessage(Handle, EM_LINEINDEX, j, 0);
    SelStart:=Sel;
    SelLength := 1;
    SelAttributes.Size:= LineSpace;
    SelLength := 0;
    UpdateHotItems(InsertPoint,incr);
  end;
  lines.endUpdate;
  SelStart:=0; // force cursor to first line
  FUpdating := false;
end;

procedure THyperTextViewEx.SetLineSpace(const Value: integer);
begin
  if (value>0) and (Value<>FLineSpace) then
  begin
    FLineSpace := Value;
    if AutoFormat then ReFormat;
  end;
end;

procedure THyperTextViewEx.UpdateHotItems(Start, Increament: integer);
var
  i : integer;
begin
  for i:=0 to FHotItems.count-1 do
    if FHotItems.Items[i].Start>=Start then
      inc(FHotItems.Items[i].Start,Increament)
    else
      // FHotItems.Items[i].Start<Start
      if (FHotItems.Items[i].Start
        +FHotItems.Items[i].length>=Start) then
      inc(FHotItems.Items[i].length,Increament)
end;

procedure THyperTextViewEx.WMSize(var message: TWMSize);
begin
  inherited;
  //if not FUpdating then
  //SetEditRect;
  if AutoFormat and not FUpdating then
    ReFormat;
end;

procedure THyperTextViewEx.SetEditRect(Exclude : boolean);
var
  R : TRect;
  Del : integer;
begin
  if Exclude then
    del := GetSystemMetrics(SM_CYVSCROLL)
  else
    del := 0;
  R := Rect(0, 0,
      Width-del-2,
      ClientHeight);
  SendMessage(Handle, EM_SETRECT, 0, Longint(@R));
end;

end.
