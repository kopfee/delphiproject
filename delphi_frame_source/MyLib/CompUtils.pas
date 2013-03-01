unit CompUtils;
{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> CompUtils
   <What> 扩充标准组件(与数据库无关)的使用方法的工具
   <Written By> Huang YanLai
   <History>Move DB to DBCompUtils
**********************************************}

interface

uses Windows,Messages,Sysutils,Classes,Controls,
      graphics,ComCtrls,forms,Buttons, ExtCtrls,
      Menus, StdCtrls, checklst;

type
  // Images的类型
  TImageSizeType = (istNormal,istSmall,istState);

{
  <Procedure>SetListViewImages
  <What>设置ListView的Images
  <Params>
    -
  <Exception>
}
procedure SetListViewImages(AListView : TCustomListView;
	SizeType : TImageSizeType;AImagesHandle : THandle);

{
  <Procedure>SetTreeViewImages
  <What>设置TreeView的Images
  <Params>
    -
  <Exception>
}
procedure SetTreeViewImages(ATreeView : TCustomTreeView;
	SizeType : TImageSizeType;AImagesHandle : THandle);

{
  <Function>CtrlVisible
  <What>返回控件是否可见。根据控件本身和控件的父控件链表的Visible属性判断
  <Params>
    -
  <Return>控件是否可见
  <Exception>
}
function  CtrlVisible(Control : TControl):boolean;

{
  <Procedure>CalcLayout
  <What>对包含文字和图像的按键计算文字和图像的位置
  <Params>
    Canvas - 画布，用于确定显示环境，计算大小
    Client - 画图区域
    Offset - 位移
    Caption - 输出文字
    GlyphSize - 图像大小
    Layout - 图像和文字的排列关系blGlyphLeft, blGlyphRight, blGlyphTop, blGlyphBottom
    Margin - 周围留下的空白，-1表示自动调整
    Spacing - 图像和文字之间的空白，-1表示自动调整
    GlyphPos - 返回的图像的位置（左上角）
    TextBounds - 文字区域
    BiDiFlags - 文字属性
  <Exception>
}
procedure CalcLayout(Canvas: TCanvas;
  const Client: TRect; const Offset: TPoint;
  const Caption: string;
  const GlyphSize : TPoint;
  Layout: TButtonLayout;
  Margin, Spacing: Integer;
  var GlyphPos: TPoint; var TextBounds: TRect;
  BiDiFlags: Longint);

{
  <Procedure>PopupAMenu
  <What>在指定控件的位置弹出菜单
  <Params>
    -
  <Exception>
}
procedure PopupAMenu(PopupMenu : TPopupMenu; Control : TControl);

{
  <Procedure>Popup
  <What>在当前鼠标位置弹出菜单
  <Params>
    -
  <Exception>
}
procedure Popup(APopupMenu : TPopupMenu);

{
  <Procedure>CopyTextToClipboard
  <What>将文字复制到剪贴板
  <Params>
    -
  <Exception>
}
procedure CopyTextToClipboard(const AText : string);

{
  <Function>GetClipboardText
  <What>从剪贴板获得文字
  <Params>
    -
  <Return>
  <Exception>
}
function  GetClipboardText:string;

{
  <Procedure>ClearChildren
  <What>释放WinCtrl的使用子控件
  <Params>
    -
  <Exception>
}
procedure ClearChildren(WinCtrl : TWincontrol);

{
procedure popHint(const HintString:string);

function GetHintControl(Control: TControl): TControl;
}

{
  <Function>ComponentsToText
  <What>将一组组件保存到文本中
  <Params>
    AOwner - 组件的所有者
    Components - 一组组件
  <Return>
  <Exception>
}
function  ComponentsToText(AOwner : TComponent; Components : TList): string;

{
  <Procedure>CopyComponents
  <What>将一组组件保存到剪贴板
  <Params>
    -
  <Exception>
}
procedure CopyComponents(AOwner : TComponent; Components : TList);

type
  {
    <Class>TReadEventHandler
    <What>处理TReader对象的事件，处理从流里面读取控件时候遇到的各种可能的问题
    在读取错误的时候继续处理（即忽略一些错误，例如属性不存在等等）
    <Properties>
      Owner-对象所有者
      Parent-可视控件的父对象
    <Methods>
      -
    <Event>
      -
  }
  TReadEventHandler = class
  private
    FOnAncestorNotFound: TAncestorNotFoundEvent;
    FOwner: TComponent;
    FParent: TComponent;
    FOnCreateComponent: TCreateComponentEvent;
    FOnFindComponentClass: TFindComponentClassEvent;
    FOnFindMethod: TFindMethodEvent;
    FOnError: TReaderError;
    FOnReferenceName: TReferenceNameEvent;
    FOnSetName: TSetNameEvent;
  protected
    procedure FindMethod(Reader: TReader; const MethodName: string;
      var Address: Pointer; var Error: Boolean); virtual;
    procedure SetName(Reader: TReader; Component: TComponent;
      var Name: string); virtual;
    procedure ReferenceName(Reader: TReader; var Name: string); virtual;
    procedure AncestorNotFound(Reader: TReader; const ComponentName: string;
      ComponentClass: TPersistentClass; var Component: TComponent); virtual;
    procedure ReaderError(Reader: TReader; const Message: string; var Handled: Boolean); virtual;
    procedure FindComponentClass(Reader: TReader; const ClassName: string;
      var ComponentClass: TComponentClass); virtual;
    procedure CreateComponent(Reader: TReader;
      ComponentClass: TComponentClass; var Component: TComponent);virtual;
  public
    property Owner: TComponent read FOwner write FOwner;
    property Parent: TComponent read FParent write FParent;
    property OnError: TReaderError read FOnError write FOnError;
    property OnFindMethod: TFindMethodEvent read FOnFindMethod write FOnFindMethod;
    property OnSetName: TSetNameEvent read FOnSetName write FOnSetName;
    property OnReferenceName: TReferenceNameEvent read FOnReferenceName write FOnReferenceName;
    property OnAncestorNotFound: TAncestorNotFoundEvent read FOnAncestorNotFound write FOnAncestorNotFound;
    property OnCreateComponent: TCreateComponentEvent read FOnCreateComponent write FOnCreateComponent;
    property OnFindComponentClass: TFindComponentClassEvent read FOnFindComponentClass write FOnFindComponentClass;
  end;

{
  <Procedure>BindReadHanlder
  <What>将一个TReader的事件绑定到TReadEventHandler对象上面
  <Params>
    -
  <Exception>
}
procedure BindReadHanlder(RD : TReader; Handler : TReadEventHandler);

{
  <Procedure>TextToComponents
  <What>从文本里面读取一组组件
  <Params>
    AText-包含对象信息的文本(格式和文本形式的dfm相同)
    Handler-注意设置Handlerf的owner和parent属性
    Proc-每读一个对象需要用到的回调过程
  <Exception>
}
procedure TextToComponents(const AText : string; Handler : TReadEventHandler; Proc: TReadComponentsProc);

{
  <Procedure>PasteComponents
  <What>从剪贴板粘贴一组组件
  <Params>
    -
  <Exception>
}
procedure PasteComponents(Handler : TReadEventHandler;
      Proc: TReadComponentsProc);

{
  <Function>ReadComponentResFile2
  <What>从文件读取组件
  <Params>
    -
  <Return>
  <Exception>
}
function  ReadComponentResFile2(const FileName: string; Instance: TComponent; Handler : TReadEventHandler): TComponent;

{
  <Procedure>TryReadComponentResFile
  <What>从文件读取组件，使用缺省的TReadEventHandler
  <Params>
    -
  <Exception>
}
function  TryReadComponentResFile(const FileName: string; Instance: TComponent): TComponent;

type
  TProcMethod = procedure of object;

  // %TSafeProcCaller : 安全调用器
  {SafeProc : From Unit ComWriUtils
 		Sometime, it will bring about a error
 when we take a process in a Event-Handler.
 Normally, that is to free some objects.
 		for the safe process, use a TSafeProcCaller.
 		In a Event-Handler, call SafeProcEx
 with the procedure where you really process something.
 when timer triger, after your Event-Handler,
 TSafeProcCaller will call the the procedure.
  }
  TSafeProcCaller = class(TComponent)
  private
    FOnProc: TProcMethod;
    FTimer : TTimer;
    procedure   OnTimer(sender : TObject);
  public
    constructor Create(AOwner : TComponent); override;
    procedure SafeProc;
    procedure Execute;
    // set OnProc , then call SafeProc
    procedure SafeProcEx(AProc : TProcMethod);
  published
    property	OnProc : TProcMethod read FOnProc write FOnProc;
  end;

{
  <Procedure>CenterChildren
  <What>将包含的子控件居中布置
  <Params>
    -
  <Exception>
}
procedure   CenterChildren(WinControl : TWinControl);

{
  <Function>ConfirmDialog
  <What>显示确认对话框。一般具有"是"、"否"两个按键，如果CanCancel=True，还包括"取消"
  <Params>
    -
  <Return>
    IDYES，IDNO	，IDCANCEL
  <Exception>
}
function ConfirmDialog(const Title, Message : string; CanCancel : Boolean=False) : Integer;

{
  <Procedure>AutoHScrollListBox
  <What>如果LixtBox的条目宽度超过显示宽度，那么自动出现水平滚动条。
  <Params>
    -
  <Exception>
}
procedure AutoHScrollListBox(ListBox : TCustomListBox);

procedure HideApplication;

implementation

uses CommCtrl,SafeCode,clipbrd,LogFile,ConvertUtils;

{ The ListView and TreeView ImageList Utilities
}
procedure SetListViewImages(AListView : TCustomListView;
	SizeType : TImageSizeType;AImagesHandle : THandle);
var
  Size : integer;
begin
  assert(AListView<>nil);
  case SizeType of
    istNormal:	Size := LVSIL_NORMAL;
    istSmall:	size := LVSIL_Small;
    istState:  size := LVSIL_State;
  else exit;
  end;
  SendMessage(AListView.handle,LVM_SETIMAGELIST,size,AImagesHandle);
end;

procedure SetTreeViewImages(ATreeView : TCustomTreeView;
	SizeType : TImageSizeType;AImagesHandle : THandle);
var
  Size : integer;
begin
  assert(ATreeView<>nil);
  case SizeType of
    istNormal:	Size := TVSIL_NORMAL;
    istState:  size := TVSIL_State;
  else exit;
  end;
  SendMessage(ATreeView.handle,TVM_SETIMAGELIST,size,AImagesHandle);
end;

{*******************************}
function  CtrlVisible(Control : TControl):boolean;
begin
  assert(control<>nil);
  result := true;
  while (control<>nil) and result do
  begin
    result := control.visible;
    if control is TCustomForm
      then break;
    control := control.parent;
  end;
end;

procedure CalcLayout(Canvas: TCanvas;
  const Client: TRect; const Offset: TPoint;
  const Caption: string;
  const GlyphSize : TPoint;
  Layout: TButtonLayout;
  Margin, Spacing: Integer;
  var GlyphPos: TPoint; var TextBounds: TRect;
  BiDiFlags: Longint);
var
  TextPos: TPoint;
  ClientSize, TextSize: TPoint;
  TotalSize: TPoint;
begin
  if (BiDiFlags and DT_RIGHT) = DT_RIGHT then
    if Layout = blGlyphLeft then Layout := blGlyphRight
    else
      if Layout = blGlyphRight then Layout := blGlyphLeft;
  { calculate the item sizes }
  ClientSize := Point(Client.Right - Client.Left, Client.Bottom -
    Client.Top);

  { calculate the Text sizes }
  if Length(Caption) > 0 then
  begin
    TextBounds := Rect(0, 0, Client.Right - Client.Left, 0);
    windows.DrawText(Canvas.Handle, PChar(Caption), Length(Caption), TextBounds,
      DT_CALCRECT or BiDiFlags);
    TextSize := Point(TextBounds.Right - TextBounds.Left, TextBounds.Bottom -
      TextBounds.Top);
  end
  else
  begin
    TextBounds := Rect(0, 0, 0, 0);
    TextSize := Point(0,0);
  end;

  { If the layout has the glyph on the right or the left, then both the
    text and the glyph are centered vertically.  If the glyph is on the top
    or the bottom, then both the text and the glyph are centered horizontally.}
  if Layout in [blGlyphLeft, blGlyphRight] then
  begin
    GlyphPos.Y := (ClientSize.Y - GlyphSize.Y + 1) div 2;
    TextPos.Y := (ClientSize.Y - TextSize.Y + 1) div 2;
  end
  else
  begin
    GlyphPos.X := (ClientSize.X - GlyphSize.X + 1) div 2;
    TextPos.X := (ClientSize.X - TextSize.X + 1) div 2;
  end;

  { if there is no text or no bitmap, then Spacing is irrelevant }
  if (TextSize.X = 0) or (GlyphSize.X = 0) then
    Spacing := 0;

  { adjust Margin and Spacing }
  if Margin = -1 then
  begin
    if Spacing = -1 then
    begin
      TotalSize := Point(GlyphSize.X + TextSize.X, GlyphSize.Y + TextSize.Y);
      if Layout in [blGlyphLeft, blGlyphRight] then
        Margin := (ClientSize.X - TotalSize.X) div 3
      else
        Margin := (ClientSize.Y - TotalSize.Y) div 3;
      Spacing := Margin;
    end
    else
    begin
      TotalSize := Point(GlyphSize.X + Spacing + TextSize.X, GlyphSize.Y +
        Spacing + TextSize.Y);
      if Layout in [blGlyphLeft, blGlyphRight] then
        Margin := (ClientSize.X - TotalSize.X + 1) div 2
      else
        Margin := (ClientSize.Y - TotalSize.Y + 1) div 2;
    end;
  end
  else
  begin
    if Spacing = -1 then
    begin
      TotalSize := Point(ClientSize.X - (Margin + GlyphSize.X), ClientSize.Y -
        (Margin + GlyphSize.Y));
      if Layout in [blGlyphLeft, blGlyphRight] then
        Spacing := (TotalSize.X - TextSize.X) div 2
      else
        Spacing := (TotalSize.Y - TextSize.Y) div 2;
    end;
  end;

  case Layout of
    blGlyphLeft:
      begin
        GlyphPos.X := Margin;
        TextPos.X := GlyphPos.X + GlyphSize.X + Spacing;
      end;
    blGlyphRight:
      begin
        GlyphPos.X := ClientSize.X - Margin - GlyphSize.X;
        TextPos.X := GlyphPos.X - Spacing - TextSize.X;
      end;
    blGlyphTop:
      begin
        GlyphPos.Y := Margin;
        TextPos.Y := GlyphPos.Y + GlyphSize.Y + Spacing;
      end;
    blGlyphBottom:
      begin
        GlyphPos.Y := ClientSize.Y - Margin - GlyphSize.Y;
        TextPos.Y := GlyphPos.Y - Spacing - TextSize.Y;
      end;
  end;

  { fixup the result variables }
  { add Client.Left , Top and offset
  }
  with GlyphPos do
  begin
    Inc(X, Client.Left + Offset.X);
    Inc(Y, Client.Top + Offset.Y);
  end;
  OffsetRect(TextBounds, TextPos.X + Client.Left + Offset.X,
    TextPos.Y + Client.Top + Offset.X);
end;

procedure PopupAMenu(PopupMenu : TPopupMenu; Control : TControl);
var
  p : TPoint;
begin
  assert(PopupMenu<>nil);
  assert(Control<>nil);
  p := Control.ClientToScreen(Point(0,0));
  PopupMenu.Popup(p.x,p.y+control.Height);
end;

procedure Popup(APopupMenu : TPopupMenu);
var
  pos : TPoint;
begin
  GetCursorPos(pos);
  APopupMenu.Popup(pos.x,pos.y);
end;

procedure CopyTextToClipboard(const AText : string);
begin
  Clipboard.AsText := AText;
end;

function  GetClipboardText:string;
begin
  result := Clipboard.AsText;
end;

procedure ClearChildren(WinCtrl : TWincontrol);
begin
  assert(WinCtrl<>nil);
  while WinCtrl.ControlCount>0 do
  begin
    WinCtrl.Controls[WinCtrl.ControlCount-1].free;
  end;
end;
{
function GetHintControl(Control: TControl): TControl;
begin
  Result := Control;
  while (Result <> nil) and not Result.ShowHint do Result := Result.Parent;
  if (Result <> nil) and (csDesigning in Result.ComponentState) then Result := nil;
end;

procedure popHint(const HintString:string);
var
  P: TPoint;
begin
  GetCursorPos(P);
  Application.Hint := HintString;
  Application.Hint
  Application.ActivateHint(P);
end; }

(*
procedure SimulateKey(VirKey : byte; shift: TShiftState);
var
  ctrlPressed,altPressed,shiftPressed : boolean;

  procedure check(keyPressed : boolean; ashift : TShiftState; VKCode : byte; Undo:boolean);
  begin
    if not Undo then
    begin
      if keyPressed and not (ashift <= shift) then
      begin
        keybd_event(VKCode,0,KEYEVENTF_KEYUP,0);
        writeLog(IntToStr(VKCode)+' up');
      end
      else if not keyPressed and (ashift <= shift) then
      begin
        keybd_event(VKCode,0,0,0);
        writeLog(IntToStr(VKCode)+' down');
      end;
    end else
    begin
      if keyPressed and not (ashift <= shift) then
      begin
        keybd_event(VKCode,0,0,0);
        writeLog(IntToStr(VKCode)+' down');
      end
      else if not keyPressed and (ashift <= shift) then
      begin
        keybd_event(VKCode,0,KEYEVENTF_KEYUP,0);
        writeLog(IntToStr(VKCode)+' up');
      end;
    end;
  end;

begin
  {
  // has a bug
  // after call AttachThreadInput, GetKeyState will be reset !!!
  ctrlPressed := GetKeyState(VK_CONTROL)<0;
  altPressed := GetKeyState(VK_Menu)<0;
  shiftPressed := GetKeyState(VK_Shift)<0;}
  ctrlPressed := GetAsyncKeyState(VK_CONTROL)<0;
  altPressed := GetAsyncKeyState(VK_Menu)<0;
  shiftPressed := GetAsyncKeyState(VK_Shift)<0;
  writeLog('Alt:'+BoolStrs[altPressed]+' Ctrl:'+BoolStrs[CtrlPressed]+' Shift:'+BoolStrs[ShiftPressed]);

  check(shiftPressed,[ssShift],VK_Shift,false);
  check(ctrlPressed,[ssCtrl],VK_Control,false);
  check(altPressed,[ssAlt],VK_Menu,false);

  keybd_event(VirKey,0,0,0);

  check(shiftPressed,[ssShift],VK_Shift,true);
  check(ctrlPressed,[ssCtrl],VK_Control,true);
  check(altPressed,[ssAlt],VK_Menu,true);
end;
*)

function  ComponentsToText(AOwner : TComponent; Components : TList): string;
var
  i : integer;
  MS : TMemoryStream;
  SS : TStringStream;
  WR : TWriter;
begin
  Result := '';
  if Components.Count=0 then Exit;
  MS := TMemoryStream.Create;
  SS := TStringStream.Create('');
  try
    WR:=TWriter.Create(MS,4096);
    try
      // write to stream
      WR.RootAncestor := nil;
      WR.Ancestor := nil;
      WR.Root := AOwner;
      for i:= 0 to Components.Count -1 do
      begin
        WR.WriteSignature;
        WR.WriteComponent(TComponent(Components[i]));
      end;
    finally
      WR.Free;
    end;
    // stream to text
    MS.Position := 0;
    while MS.Position<MS.Size do
      ObjectBinaryToText(MS,SS);
    Result := SS.DataString;
  finally
    SS.Free;
    MS.Free;
  end;
end;

procedure CopyComponents(AOwner : TComponent; Components : TList);
begin
  CopyTextToClipboard(ComponentsToText(AOwner,Components));
end;

procedure SkipBlanks(S : TStream);
var
  C : Char;
begin
  while S.Position<S.Size do
  begin
    S.ReadBuffer(C,SizeOf(C));
    if C>#32 then
    begin
      S.Seek(-1,soFromCurrent);
      Break;
    end;
  end;
end;

procedure TextToComponents(const AText : string; Handler : TReadEventHandler; Proc: TReadComponentsProc);
var
  MS : TMemoryStream;
  SS : TStringStream;
  WR : TWriter;
  RD : TReader;
begin
  CheckObject(Handler,'Handler is nil');
  SS := TStringStream.Create(AText);
  MS := TMemoryStream.Create;
  try
    // text to binary
    while SS.Position<SS.Size do
    begin
      SkipBlanks(SS);
      if SS.Position<SS.Size then
        ObjectTextToBinary(SS,MS);
    end;
    WR:=TWriter.Create(MS,4096);
    try
      WR.WriteListEnd;
    finally
      WR.Free;
    end;
    // binary to components
    MS.Position := 0;
    RD:=TReader.Create(MS,4096);
    try
      BindReadHanlder(RD,Handler);
      RD.Position:=0;
      RD.ReadComponents(Handler.Owner,Handler.Parent,Proc);
    finally
      RD.Free;
    end;
  finally
    SS.Free;
    MS.Free;
  end;
end;

procedure PasteComponents(Handler : TReadEventHandler;
  Proc: TReadComponentsProc);
begin
  TextToComponents(GetClipboardText,Handler,Proc);
end;

{ TReadEventHandler }

procedure TReadEventHandler.AncestorNotFound(Reader: TReader;
  const ComponentName: string; ComponentClass: TPersistentClass;
  var Component: TComponent);
begin
  if Assigned(FOnAncestorNotFound) then
    FOnAncestorNotFound(Reader,ComponentName,ComponentClass,Component);
end;

procedure TReadEventHandler.CreateComponent(Reader: TReader;
  ComponentClass: TComponentClass; var Component: TComponent);
begin
  if Assigned(FOnCreateComponent) then
    FOnCreateComponent(Reader,ComponentClass,Component);
end;

procedure TReadEventHandler.FindComponentClass(Reader: TReader;
  const ClassName: string; var ComponentClass: TComponentClass);
begin
  if Assigned(FOnFindComponentClass) then
    FOnFindComponentClass(Reader,ClassName,ComponentClass);
end;

procedure TReadEventHandler.FindMethod(Reader: TReader;
  const MethodName: string; var Address: Pointer; var Error: Boolean);
begin
  if Assigned(FOnFindMethod) then
    FOnFindMethod(Reader,MethodName,Address,Error);
end;

procedure TReadEventHandler.ReaderError(Reader: TReader;
  const Message: string; var Handled: Boolean);
begin
  if Assigned(FOnError) then
    FOnError(Reader,Message,Handled) else
    Handled := True;
end;

procedure TReadEventHandler.ReferenceName(Reader: TReader;
  var Name: string);
begin
  if Assigned(FOnReferenceName) then
    FOnReferenceName(Reader,Name);
end;

procedure TReadEventHandler.SetName(Reader: TReader; Component: TComponent;
  var Name: string);
var
  SameNamedComp : TComponent;
begin
  if Assigned(FOnSetName) then
    FOnSetName(Reader,Component,Name)
  else if Component.Owner<>nil then
  begin
      SameNamedComp := Component.Owner.FindComponent(Name);
      if (SameNamedComp<>nil) and (SameNamedComp<>Component) then
        Name := '';
  end;
end;

procedure BindReadHanlder(RD : TReader; Handler : TReadEventHandler);
begin
  if Handler<>nil then
  begin
    RD.OnError:=Handler.ReaderError;
    RD.OnSetName:=Handler.SetName;
    RD.OnFindMethod:=Handler.FindMethod;
    RD.OnReferenceName := Handler.ReferenceName;
    RD.OnAncestorNotFound := Handler.AncestorNotFound;
    RD.OnCreateComponent := Handler.CreateComponent;
    RD.OnFindComponentClass := Handler.FindComponentClass;
  end;
end;

function  ReadComponentResFile2(const FileName: string; Instance: TComponent; Handler : TReadEventHandler): TComponent;
var
  Stream: TStream;
  Reader: TReader;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    Stream.ReadResHeader;
    Reader := TReader.Create(Stream, 4096);
    try
      BindReadHanlder(Reader,Handler);
      Result := Reader.ReadRootComponent(Instance);
    finally
      Reader.Free;
    end;
  finally
    Stream.Free;
  end;
end;

function  TryReadComponentResFile(const FileName: string; Instance: TComponent): TComponent;
var
  Handler : TReadEventHandler;
begin
  Handler := TReadEventHandler.Create;
  try
    //Result := ReadComponentResFile2(FileName,Instance,nil);
    Result := ReadComponentResFile2(FileName,Instance,Handler);
  finally
    Handler.Free;
  end;
end;

{ TSafeProcCaller }

constructor TSafeProcCaller.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTimer := TTimer.Create(self);
  FTimer.enabled := false;
  FTimer.Interval := 50;
  FTimer.OnTimer := OnTimer;
end;

procedure TSafeProcCaller.Execute;
begin
  SafeProc;
end;

procedure TSafeProcCaller.OnTimer(sender: TObject);
begin
  if FTimer.enabled  and assigned(FOnProc) then
  begin
    FTimer.enabled := false;
    FOnProc;
  end
  else FTimer.enabled := false;
end;

procedure TSafeProcCaller.SafeProc;
begin
  if assigned(FOnProc) then
	  FTimer.enabled := true;
end;

procedure TSafeProcCaller.SafeProcEx(AProc: TProcMethod);
begin
  FOnProc := AProc;
  SafeProc;
end;

procedure   CenterChildren(WinControl : TWinControl);
var
  MinX, MaxX, MinY, MaxY : Integer;
  I : Integer;
  Ctrl : TControl;
  W,H,X,DelX,Y,DelY : Integer;
begin
  MinX := Screen.Width;
  MaxX := 0;
  MinY := Screen.Height;
  MaxY := 0;
  X := 0;
  Y := 0;
  W := WinControl.Width;
  H := WinControl.Height;
  if WinControl.ControlCount=0 then Exit;
  for I:=0 to WinControl.ControlCount-1 do
  begin
    Ctrl := WinControl.Controls[I];
    if not Ctrl.Visible then Continue;
    if (Ctrl.Align=alNone) {and ([akRight, akBottom]*Ctrl.Anchors=[])} then
    begin
      if MinX>Ctrl.Left then
        MinX := Ctrl.Left;
      if MaxX<Ctrl.Left+Ctrl.Width then
        MaxX:=Ctrl.Left+Ctrl.Width;
      if MinY>Ctrl.Top then
        MinY := Ctrl.Top;
      if MaxY<Ctrl.Top+Ctrl.Height then
        MaxY:=Ctrl.Top+Ctrl.Height;
    end
    else
      case Ctrl.Align of
        alTop:    begin
                    Y := Y + Ctrl.Height;
                    H := H - Ctrl.Height;
                  end;
        alBottom: begin
                    H := H - Ctrl.Height;
                  end;
        alLeft:   begin
                    X := X + Ctrl.Width;
                    W := W - Ctrl.Width;
                  end;
        alRight:  begin
                    W := W - Ctrl.Width;
                  end;
      end;

  end;
  X := X + (W - (MaxX-MinX)) div 2;
  DelX := MinX-X;
  Y := Y + (H - (MaxY-MinY)) *32 div 100;
  DelY := MinY-Y;
  if (MaxX-MinX>WinControl.ClientWidth) or (MaxY-MinY>WinControl.ClientHeight) then
    Exit;
  for I:=0 to WinControl.ControlCount-1 do
  begin
    Ctrl := WinControl.Controls[I];
    if (Ctrl.Align=alNone) and ([akRight, akBottom]*Ctrl.Anchors=[]) then
    begin
      Ctrl.SetBounds(Ctrl.Left-DelX,Ctrl.Top-DelY,Ctrl.Width,Ctrl.Height);
    end;
  end;
end;

function ConfirmDialog(const Title, Message : string; CanCancel : Boolean=False) : Integer;
var
  Flags : Longword;
begin
  Flags := MB_ICONQUESTION	or MB_TASKMODAL;
  if CanCancel then
    Flags := Flags or MB_YESNOCANCEL else
    Flags := Flags or MB_YESNO;	
  Result := Application.MessageBox(PChar(Message),PChar(Title),Flags);
end;

type
  TCustomListBoxAccess = class(TCustomListBox);

procedure AutoHScrollListBox(ListBox : TCustomListBox);
var
  MaxWidth : Integer;
  ItemWidth : Integer;
  Count : Integer;
  ItemText : string;
  I : Integer;
  DeltaWidth : Integer;
begin
  // 不需要考虑滚动条的宽度，在LB_SETHORIZONTALEXTENT设置实际的范围
  DeltaWidth := 4;{+GetSystemMetrics(SM_CXVSCROLL);}
  if ListBox is TCheckListBox then
    Inc(DeltaWidth,16);
  MaxWidth := ListBox.Width - DeltaWidth;
  ListBox.Canvas.Font:=TCustomListBoxAccess(ListBox).Font;
  Count := ListBox.Items.Count;
  for I:=0 to Count-1 do
  begin
    ItemText := ListBox.Items[I];
    ItemWidth := ListBox.Canvas.TextWidth(ItemText);
    if ItemWidth>MaxWidth then
      MaxWidth:=ItemWidth;
  end;
  MaxWidth := MaxWidth + DeltaWidth;
  SendMessage(ListBox.Handle,LB_SETHORIZONTALEXTENT,MaxWidth,0);
end;

procedure HideApplication;
var
  Style : LongWord;
begin
  Style := GetWindowLong(Application.Handle,GWL_EXSTYLE);
  Style := Style or WS_EX_TOOLWINDOW;
  SetWindowLong(Application.Handle,GWL_EXSTYLE,Style);
end;

end.
