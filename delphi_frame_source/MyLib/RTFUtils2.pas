unit RTFUtils2;
{ This version makes some change:
  1. Name saved into /load from [secname].name,
  2. THotLinkItem2.SaveToIniFile(IniFile: TIniFile; const SecName : string);
  Add param SecName.
  3. Add [root] section
}
interface

uses Windows,messages,sysutils,classes,controls,
	richEdit,NewComCtrls,Graphics,StdCtrls,IniFiles,
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
 //	THotLinkItem2 = class;
 //	THotLinkItems2 = class;

  THotLinkClickEvent = procedure(Sender:TCustomRichEdit2;CharIndex : integer) of object;
  TDecideHotLinkEvent = procedure(Sender:TCustomRichEdit2; TextAttr : TTextAttributes2;
  												var HotLink:boolean)of object;
  THotLinkOverEvent = procedure(Sender:TCustomRichEdit2; isover : boolean)of object;
  THotLinkEvent = procedure(Sender:TCustomRichEdit2; const Link : string)of object;

  TCustomRichEditEx2 = class(TCustomRichEdit2)
  public
    function 	CanPaste:boolean;
    function 	CanUndo:boolean;
    procedure	Undo;
    procedure ScrollToCaret;
  end;

	TCustomRichView2 = class(TCustomRichEditEx2)
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

  TRichView2=class(TCustomRichView2)
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
	THotLinkItem2 = class
  public
    Start , Length : integer;
    LinkTo : string;
    Name 	: string;
    Description	: string;
    constructor Create;
    Constructor CreateFromRichEdit(RichEdit : TCustomRichEdit2);
    Constructor CreateFromIniFile(IniFile : TIniFile; const SecName:string);
    procedure 	LoadFromRichEdit(RichEdit : TCustomRichEdit2);
    procedure 	SaveToIniFile(IniFile : TIniFile;const SecName : string);
    //procedure 	SaveToFile();
    function    InRange(pos : integer):boolean;
    procedure 	Selected(RichEdit : TCustomRichEdit2);
    function 		IsValid(RichEdit : TCustomRichEdit2): boolean;
  end;

  THotLinkItems2 = class(TObjectList)
  private
    function GetItems(index: integer): THotLinkItem2;
  protected

  public
    constructor Create;
    destructor  destroy; override;
    // Treate the file as a Ini File
    procedure   SaveToFile(const filename:string);
    procedure   LoadFromFile(const filename:string);
    property  	Items[index : integer] : THotLinkItem2 read GetItems; default;
    // get a HotLinkItem by Item's name
    // If not found , return nil
    function		ItemByName(const ItemName:string):THotLinkItem2;
    // get a HotLinkItem by pos
    // If not found , return nil
    function		ItembyPos(Pos : integer):THotLinkItem2;
    // When Add a item, Check the item name is a Unique Name
    // Call AddItem, you do not free the Item
    function		AddItem(Item : THotLinkItem2):integer;
    function		AddItemname(const ItemName:string):THotLinkItem2;
    procedure 	Remove(const ItemName:string);
    function		IndexOfItem(Item:THotLinkItem2):integer;
    function		IndexOfItemName(const ItemName:string):integer;
    function		IndexOfPos(Pos : integer):integer;
  published

  end;

	THyperTextView2 = class(TCustomRichView2)
  private
    FOnHotLink: THotLinkEvent;
    function GetHotItem: THotLinkItem2;
  protected
    FHotItems : THotLinkItems2;
    //FHotItem : THotLinkItem2;
    FItemIndex : Integer;
    function  IsHotLink : boolean; override;
    procedure HotClick; override;
    procedure DoHotOver(HotState : boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    Destructor 	destroy; override;
    // You should use these procedures in replace of lines' methods
    procedure 	LoadFromFile(const Filename:string);
    procedure 	SaveToFile(const Filename:string);
    procedure 	New;
    //property 	HotItem : THotLinkItem2 read FHotItem;
    property 		HotItem : THotLinkItem2 read GetHotItem;
    property  	HotItems : THotLinkItems2 read FHotItems;
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

procedure CopyFontToTextAttr(AFont : TFont; ATextAttr : TTextAttributes2);

procedure CopyTextAttrToFont(ATextAttr : TTextAttributes2; AFont : TFont);

function 	IsRTFFile(const FileName:string):boolean;

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
{ TRichView2 }

constructor TCustomRichView2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHotCursor := crHandPoint;
  FNormalCursor := crArrow;
  Cursor := FNormalCursor;
  FViewMode := true;
  ReadOnly := true;
end;

function TCustomRichView2.CurrentUnderLine: Boolean;
begin
  result :=  fsUnderLine in SelAttributes.Style;
end;

procedure TCustomRichView2.DoHotOver(HotState: boolean);
begin
  if Assigned(FOnHotOver) then FOnHotOver(self,HotState);
end;

function TCustomRichView2.GetCurrentLine: integer;
begin
  result:=SendMessage(Handle, EM_EXLINEFROMCHAR, 0, SelStart);
end;

{
function TCustomRichView2.GetCurrentWord: string;
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
procedure TCustomRichView2.HotClick;
begin
  if Assigned(FOnHotClick) then FOnHotClick(self,SelStart);
end;

function TCustomRichView2.IsHotLink: boolean;
begin
  if Assigned(FOnDecideHotLink) then
    FOnDecideHotLink(self,SelAttributes,result)
  else result:=CurrentUnderLine;
end;

procedure TCustomRichView2.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseDown(Button,shift,X,Y);
  if ViewMode and (Button=mbLeft) and isHotLink then
  begin
    HotClick;
  end;
end;

procedure TCustomRichView2.MouseMove(Shift: TShiftState; X, Y: Integer);
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

{ THotLinkItems2 }

constructor THotLinkItems2.Create;
begin
  inherited Create(true);
end;

destructor THotLinkItems2.destroy;
begin
  clear;
  inherited destroy;
end;


procedure THotLinkItems2.Remove(const ItemName: string);
var
  i : integer;
begin
  i:=IndexOfItemName(ItemName);
  if i>=0 then delete(i);
end;

function	THotLinkItems2.AddItem(Item: THotLinkItem2):integer;
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

function THotLinkItems2.AddItemname(const ItemName: string): THotLinkItem2;
begin
  {if UniqueName(ItemName) then
  begin
    result := THotLinkItem2.Create;
	  result.name := ItemName;
  	FStrings.AddObject(ItemName,result);
  end
  else result:=nil;}
  result := THotLinkItem2.Create;
  result.name := ItemName;
  AddItem(result);
end;

function THotLinkItems2.GetItems(index: integer): THotLinkItem2;
begin
  result := THotLinkItem2(inherited Items[index]);
end;

function THotLinkItems2.ItemByName(const ItemName: string): THotLinkItem2;
var
  i : integer;
begin
  i := IndexOfItemName(ItemName);
  if i<0 then result:=nil
  else  result := Items[i];
end;

function THotLinkItems2.ItembyPos(Pos: integer): THotLinkItem2;
var
  i : integer;
begin
  I:= IndexOfPos(pos);
  if i<0 then result:=nil
  else result:=Items[i];
end;

procedure THotLinkItems2.LoadFromFile(const filename: string);
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
      	 	THotLinkItem2.CreateFromIniFile(
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
      	 	THotLinkItem2.CreateFromIniFile(
        		IniFile,Names[i]));
      finally
        Names.free;
      end;
    end;
  finally
    IniFile.free;
  end;
end;


procedure THotLinkItems2.SaveToFile(const filename: string);
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

function THotLinkItems2.IndexOfItem(Item: THotLinkItem2): integer;
begin
  result := inherited IndexOf(Item);
end;

function THotLinkItems2.IndexOfItemName(const ItemName: string): integer;
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

function THotLinkItems2.IndexOfPos(Pos: integer): integer;
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

{ THotLinkItem2 }

constructor THotLinkItem2.CreateFromRichEdit(RichEdit: TCustomRichEdit2);
begin
	CheckObject(RichEdit,'Error : RichEdit is nil.');
  inherited Create;
  CheckNotZero(RichEdit.SelLength);
  LoadFromRichEdit(RichEdit);
  Description := '';
  LinkTo:='';
end;

constructor THotLinkItem2.CreateFromIniFile(IniFile: TIniFile;
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

procedure THotLinkItem2.SaveToIniFile(IniFile: TIniFile; const SecName : string);
begin
  CheckObject(IniFile,'Error : IniFile is nil');
  IniFile.WriteString(SecName,'Name',Name);
  IniFile.WriteInteger(SecName,'Start',start);
  IniFile.WriteInteger(SecName,'Length',Length);
  IniFile.WriteString(SecName,'Description',Description);
  IniFile.WriteString(SecName,'LinkTo',LinkTo);
end;

function THotLinkItem2.InRange(pos: integer): boolean;
begin
  result := ( (pos>=Start) and (pos<start+length) );
end;

procedure THotLinkItem2.Selected(RichEdit: TCustomRichEdit2);
begin
  CheckObject(RichEdit,'Error : RichEdit is nil.');
  with RichEdit do
  begin
    SelStart := Start;
    SelLength := length;
  end;
end;

function THotLinkItem2.IsValid(RichEdit: TCustomRichEdit2): boolean;
begin
  CheckObject(RichEdit,'Error : RichEdit is nil.');
  with RichEdit do
  begin
    SelStart := Start;
    SelLength := length;
    result:=SelText=self.name;
  end;
end;

procedure THotLinkItem2.LoadFromRichEdit(RichEdit: TCustomRichEdit2);
begin
  Start := RichEdit.SelStart;
  Length := RichEdit.SelLength;
  Name :=	RichEdit.SelText;
end;

constructor THotLinkItem2.Create;
begin
  inherited Create;
  Start := 0;
  Length := 0;
  Name := '';
  LinkTo := '';
  Description := '';
end;

{ THyperTextView2 }

constructor THyperTextView2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FViewMode := true;
  FHotItems := THotLinkItems2.Create;
  //FHotItem := nil;
  FItemIndex:=-1;
end;

destructor THyperTextView2.destroy;
begin
  FHotItems.free;
  inherited destroy;
end;

procedure THyperTextView2.DoHotOver(HotState: boolean);
begin
  if HotState then
    Hint := HotItem.Description
  else
    Hint := '';
  inherited DoHotOver(HotState);
end;

function THyperTextView2.GetHotItem: THotLinkItem2;
begin
  if ItemIndex<0 then result:=nil
  else result:=HotItems[ItemIndex];
end;

procedure THyperTextView2.HotClick;
begin
  if Assigned(OnHotLink) then OnHotLink(self,HotItem.LinkTo);
end;

function THyperTextView2.IsHotLink: boolean;
begin
	FItemIndex:=FHotItems.IndexOfPos(SelStart);
  //FHotItem := ItembyPos(SelStart);
  result:= (FItemIndex>=0);
end;

procedure THyperTextView2.LoadFromFile(const Filename: string);
var
  LinkFile : string;
begin
  Lines.LoadFromFile(Filename);
  LinkFile:=ChangeFileExt(Filename,LinkFileExt);
  FHotItems.LoadFromFile(LinkFile);
  //FHotItem := nil;
  FItemIndex := -1;
end;


procedure THyperTextView2.New;
begin
  FHotItems.Clear;
  Lines.Clear;
end;

procedure THyperTextView2.SaveToFile(const Filename: string);
var
  LinkFile : string;
begin
  Lines.SaveToFile(FileName);
  LinkFile:=ChangeFileExt(Filename,LinkFileExt);
  FHotItems.SaveToFile(LinkFile);
end;

procedure TCustomRichView2.SetViewMode(const Value: boolean);
begin
  FViewMode := Value;
  ReadOnly := FViewMode;
  Cursor:= NormalCursor;
end;

procedure CopyFontToTextAttr(AFont : TFont; ATextAttr : TTextAttributes2);
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

procedure CopyTextAttrToFont(ATextAttr : TTextAttributes2; AFont : TFont);
begin
  with ATextAttr do
  begin
    AFont.CharSet := CharSet;
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

{ TCustomRichEditEx2 }

function TCustomRichEditEx2.CanPaste: boolean;
begin
  result := Perform(EM_CANPASTE, 0, 0) <> 0;
end;

function TCustomRichEditEx2.CanUndo: boolean;
begin
  result := Perform(EM_CANUNDO, 0, 0) <> 0;
end;

procedure TCustomRichEditEx2.ScrollToCaret;
begin
  Perform(EM_SCROLLCARET,0,0);
end;

procedure TCustomRichEditEx2.Undo;
begin
  if HandleAllocated then
  	SendMessage(Handle, EM_UNDO, 0, 0);
end;

end.
