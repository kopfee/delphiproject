unit FontStyles;

// FontStyles : 字体风格的展示
(*****   Code Written By Huang YanLai   *****)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs,Menus,StdCtrls,IniFiles;

type
  TFontStyles = class;

  TFontStyleItem = class(TCollectionItem)
  private
    FFont: TFont;
    FStylename: string;
    procedure 	SetFont(const Value: TFont);
    function 		GetBackGroundColor: TColor;
    procedure 	SetStylename(const Value: string);
  protected
    function 		GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor 	destroy; override;
    procedure 	Assign(Source: TPersistent); override;
    procedure 	Draw(ACanvas: TCanvas;
					  ARect: TRect; Selected: Boolean);
    procedure   Measure(ACanvas: TCanvas;
						var Width, Height: Integer);

    procedure 	SaveToIniFile(IniFile : TIniFile);
    procedure 	LoadFromIniFile(IniFile : TIniFile);
  published
    property		Font : TFont read FFont write SetFont;
    property		Stylename : string read FStylename write SetStylename;
    // used when Draw method called
    property		BackGroundColor : TColor read GetBackGroundColor ;
  end;

  TFontStyleCollection = class(TCollection)
  private
    FOwner: 		TFontStyles;
    FOnAddFont : boolean;
    function 		GetItems(index: integer): TFontStyleItem;
  protected
		function 		GetOwner: TPersistent; override;
    procedure 	Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TFontStyles);
    function 		AddFont(Font : TFont): TFontStyleItem;
  	property 		Owner : TFontStyles read FOwner;
    property 		Items[index : integer] : TFontStyleItem
    		Read GetItems; default;
    // if not found return -1
    function 		IndexOfName(const StyleName:string): integer;
    procedure 	Delete(index : integer);
    // if not found return nil
    function 		FontByName(const StyleName:string): TFont;
  end;

  { 	when TFontStyles link to a Listbox,
   it clears listbox' all items, then adds styles' items.
   the index of listbox item is the index of styles.
      when TFontStyles link to a PopupMenu or MenuItem,
   it clears all PopupMenu's or MenuItem's children menuitem,
   then adds styles' items as MenuItems
   that tags are the indexes of styles.
  }
  TSelectFontEvent = procedure (Sender : TObject;
  	index : integer; SelectFont : TFont) of object;

  // %TFontStyles : 包含多种字体，可以在PopupMenu,MenuItem,ListBox中显示这些字体
  TFontStyles = class(TComponent)
  private
    { Private declarations }
    FStyles: TFontStyleCollection;
    FBackGroundColor: TColor;
    FMenuItem: TMenuItem;
    FListBox: TListBox;
    FPopupMenu: TPopUpMenu;
    FOnSelectFont: TSelectFontEvent;
    FDefaultStyle: String;
    FOnDefaultStyleChanged: TNotifyEvent;
    procedure 	SetStyles(const Value: TFontStyleCollection);
    procedure 	SetListBox(const Value: TListBox);
    procedure 	setMenuItem(const Value: TMenuItem);
    procedure 	SetPopupMenu(const Value: TPopUpMenu);
    procedure 	ClearMenuItems(MenuItem : TMenuItem);
    procedure 	InternalUpdateMenu(MenuItem : TMenuItem);

    function		AddMenuItem(AMenuItem : TMenuItem;
    							index:integer):TMenuItem;
    procedure 	UpdateOneMenuItem(AMenuItem : TMenuItem;
    							index:integer);
    // FPopupMenu<>nil and not Designing
    function		CanUpdatePopupMenu:boolean;
    function		CanUpdateMenuIem:boolean;
    function 		GetDefaultFont: TFont;
    procedure 	SetDefaultStyle(const Value: String);
    procedure		DefaultStyleChanged;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor 	destroy; override;
    procedure 	UpdateAll;
    procedure 	UpdateItem(index:integer);
    procedure 	UpdateNew;
    procedure 	UpdateListBox;
    procedure 	UpdatePopupMenu;
    procedure 	UpdateMenuItem;

    // for use to set some components' event
    procedure		OnListBoxDraw(Control: TWinControl;
    							Index: Integer; Rect: TRect;
				        	State: TOwnerDrawState);
    procedure		OnListBoxMeasure(Control: TWinControl;
    							Index: Integer;var Height: Integer);
    procedure 	OnMenuItemDraw(Sender: TObject;
    							 ACanvas: TCanvas;
									 ARect: TRect; Selected: Boolean);
    procedure   OnMenuItemMeasure(Sender: TObject; ACanvas: TCanvas;
									  var Width, Height: Integer);
    procedure 	OnClick(Sender : TObject);

    property		DefaultFont : TFont read GetDefaultFont;
  published
    { Published declarations }
    property		BackGroundColor :  TColor read FBackGroundColor write FBackGroundColor default clWhite;
    property		Styles : TFontStyleCollection read FStyles write SetStyles;
    property 		PopupMenu : TPopUpMenu Read FPopupMenu Write SetPopupMenu;
    property		MenuItem : TMenuItem read FMenuItem write setMenuItem;
    property		ListBox : TListBox read FListBox write SetListBox;
    property		OnSelectFont : TSelectFontEvent read FOnSelectFont write FOnSelectFont;

    property		DefaultStyle : String read FDefaultStyle write SetDefaultStyle;
    property 		OnDefaultStyleChanged : TNotifyEvent
	    	Read FOnDefaultStyleChanged Write FOnDefaultStyleChanged;
  end;


implementation

uses ComWriUtils;


const
  Margin = 2;

{ TFontStyleItem }

procedure TFontStyleItem.Assign(Source: TPersistent);
begin
  FFont.Assign((Source As TFontStyleItem).Font);
  FStyleName := (Source As TFontStyleItem).StyleName;
  Changed(false);
end;

constructor TFontStyleItem.Create(Collection: TCollection);
begin
  FFont := TFont.Create;
  inherited Create(Collection);
  FStylename := 'Style'+IntToStr(ID);
end;

destructor TFontStyleItem.destroy;
begin
  FFont.free;
  inherited destroy;
end;

procedure TFontStyleItem.Draw(ACanvas: TCanvas; ARect: TRect;
  Selected: Boolean);
begin
  ACanvas.Font := Font;
  ACanvas.Brush.Color := BackGroundColor;
  //ACanvas.FillRect(ARect);
  ACanvas.TextRect(ARect,ARect.left + margin,ARect.top + margin,StyleName);
  if selected then ACanvas.DrawFocusRect(ARect);
end;

function TFontStyleItem.GetBackGroundColor: TColor;
begin
  result := TFontStyleCollection(Collection).Owner.BackGroundColor;
end;

function TFontStyleItem.GetDisplayName: string;
begin
  result := FStylename;
end;

procedure TFontStyleItem.LoadFromIniFile(IniFile: TIniFile);
begin
  //
end;

procedure TFontStyleItem.Measure(ACanvas: TCanvas; var Width,
  Height: Integer);
var
  TheSize : TSize;
begin
  ACanvas.Font := Font;
  TheSize:=ACanvas.TextExtent(StyleName);
  Width := theSize.cx+Margin*2;
  Height := theSize.cy+Margin*2;
end;

procedure TFontStyleItem.SaveToIniFile(IniFile: TIniFile);
begin
  //
end;

procedure TFontStyleItem.SetFont(const Value: TFont);
begin
  if FFont<>Value then
  begin
    FFont.assign(Value);
    Changed(false);
  end;
end;


procedure TFontStyleItem.SetStylename(const Value: string);
begin
  if FStylename <> Value then
  begin
    FStylename := Value;
	  Changed(false);
  end;
end;

{ TFontStyleCollection }

constructor TFontStyleCollection.Create(AOwner: TFontStyles);
begin
  inherited Create(TFontStyleItem);
  FOwner := AOwner;
  FOnAddFont := false;
end;

function TFontStyleCollection.AddFont(Font: TFont): TFontStyleItem;
begin
  FOnAddFont := true;
  result := TFontStyleItem(inherited Add);
  result.font := font;
  FOnAddFont := false;
  Owner.UpdateNew;
end;

function TFontStyleCollection.GetItems(index: integer): TFontStyleItem;
begin
  result := TFontStyleItem(inherited Items[index]);
end;

function TFontStyleCollection.GetOwner: TPersistent;
begin
  result := FOwner;
end;

procedure TFontStyleCollection.Update(Item: TCollectionItem);
begin
  if not FOnAddFont then
    if Item=nil then
    	Owner.UpdateAll
    else Owner.UpdateItem(Item.index);
end;

procedure TFontStyleCollection.Delete(index: integer);
begin
  Items[index].free;
end;

function TFontStyleCollection.FontByName(const StyleName: string): TFont;
var
  i : integer;
begin
  i:=IndexOfName(StyleName);
  if i<0 then
  	result:=nil
  else
  	result:=Items[i].Font;
end;

function TFontStyleCollection.IndexOfName(
  const StyleName: string): integer;
var
  i : integer;
begin
  for i:=0 to count-1 do
    if Items[i].Stylename=StyleName then
    begin
      result:=i;
      exit;
    end;
  result:=-1;
end;

{ TFontStyles }

constructor TFontStyles.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStyles := TFontStyleCollection.Create(self);
  FBackGroundColor := clWhite;
  RegisterRefProp(self,'PopupMenu');
  RegisterRefProp(self,'MenuItem');
  RegisterRefProp(self,'Listbox');
  FPopupMenu := nil;
  FMenuItem := nil;
  FListbox := nil;
end;

destructor TFontStyles.destroy;
begin
  FStyles.free;
  inherited destroy;
end;

procedure TFontStyles.ClearMenuItems(MenuItem: TMenuItem);
var
  TheItem : TMenuItem;
begin
  if not (csDesigning in ComponentState) then
  while MenuItem.count>0 do
  begin
    TheItem :=MenuItem[0];
    MenuItem.delete(0);
    TheItem.free;
  end;
end;

procedure TFontStyles.OnListBoxDraw(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  Styles.items[index].draw((Control as TListBox).canvas,
  	rect,{(odSelected	in State) or }{(odFocused	in State)}false);
end;

procedure TFontStyles.OnListBoxMeasure(Control: TWinControl;
  Index: Integer; var Height: Integer);
var
  AWidth : integer;
begin
  Styles.items[index].Measure((Control as TListBox).canvas,
  	AWidth,Height);
end;

procedure TFontStyles.OnMenuItemDraw(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; Selected: Boolean);
begin
  Styles.items[TMenuItem(Sender).tag].Draw
  	(ACanvas,ARect,Selected);
end;

procedure TFontStyles.OnMenuItemMeasure(Sender: TObject; ACanvas: TCanvas;
  var Width, Height: Integer);
begin
  Styles.items[TMenuItem(Sender).tag].Measure
  	(ACanvas,Width, Height);
end;

procedure TFontStyles.SetListBox(const Value: TListBox);
begin
  if FListBox <>Value then
  begin
    if FListBox<>nil then
    begin
      FListBox.style := lbStandard;
      FListBox.OnMeasureItem := nil;
      FListBox.OnDrawItem := nil;
      FListBox.OnClick := nil;
    end;
    FListBox := Value;
    if FListBox<>nil then
    begin
      FListBox.style := lbOwnerDrawVariable;
      FListBox.OnMeasureItem := OnListBoxMeasure;
      FListBox.OnDrawItem := OnListBoxDraw;
      FListBox.OnClick := OnClick;
      UpdateListBox;
    end;
    ReferTo(value);
  end;
end;

procedure TFontStyles.setMenuItem(const Value: TMenuItem);
begin
  if FMenuItem <> Value then
  begin
    if (FMenuItem<>nil) then ClearMenuItems(FMenuItem);
    FMenuItem := Value;
    if (FMenuItem<>nil) then
    	FMenuItem.GetParentMenu.OwnerDraw:=true;
    UpdateMenuItem;
    ReferTo(value);
  end;
end;

procedure TFontStyles.SetPopupMenu(const Value: TPopUpMenu);
begin
  if FPopupMenu<> Value then
  begin
    if FPopupMenu<>nil then ClearMenuItems(FPopupMenu.Items);
    FPopupMenu := Value;
    if FPopupMenu<>nil then
    	FPopupMenu.OwnerDraw := true;
    UpdatePopupMenu;
    ReferTo(value);
  end;
end;

procedure TFontStyles.SetStyles(const Value: TFontStyleCollection);
begin
  if FStyles<>Value then
    FStyles.Assign(value);
end;

procedure TFontStyles.UpdateListBox;
var
  i : integer;
begin
  if FListbox<>nil then
  begin
    FListbox.items.clear;
    for i:=0 to styles.count-1 do
      FListbox.items.add(styles[i].stylename);
  end;
end;

procedure TFontStyles.UpdateMenuItem;
begin
  if CanUpdateMenuIem then
  	InternalUpdateMenu(FMenuItem);
end;

procedure TFontStyles.UpdatePopupMenu;
begin
  if CanUpdatePopupMenu then
  	InternalUpdateMenu(FPopupMenu.Items);
end;

procedure TFontStyles.InternalUpdateMenu(MenuItem: TMenuItem);
var
  i : integer;
  //AMenuItem : TMenuItem;
begin
  ClearMenuItems(MenuItem);
  for i:=0 to Styles.count-1 do
  begin
    {AMenuItem := TMenuItem.Create(self);
    AMenuItem.Caption := Styles[i].Stylename;
    AMenuItem.tag := i;
    AMenuItem.OnDrawItem := OnMenuItemDraw;
    AMenuItem.OnMeasureItem := OnMenuItemMeasure;
    AMenuItem.OnClick := OnClick;
    MenuItem.Add(AMenuItem);}
    AddMenuItem(MenuItem,i);
  end;
end;

procedure TFontStyles.UpdateAll;
begin
  UpdateListBox;
  UpdatePopupMenu;
  UpdateMenuItem;
  DefaultStyleChanged;
end;

procedure TFontStyles.OnClick(Sender: TObject);
var
  i : integer;
  Font : TFont;
begin
  if Assigned(FOnSelectFont) then
  begin
    if Sender is TListBox then
      i := (Sender as TListBox).ItemIndex
    else
    	i := (Sender as TComponent).tag;
    if (i>=0) and (i<styles.count) then
      Font := Styles[i].font
    else
      Font := nil;
    FOnSelectFont(sender,i,font);
  end;
end;

procedure TFontStyles.UpdateItem(index: integer);
begin
  assert((index>=0)and (index<styles.count));
  if assigned(FListbox) then
  begin
    FListbox.items[index]:=styles[index].stylename;
    FListbox.repaint;
  end;
  if CanUpdatePopupMenu then
  	UpdateOneMenuItem(FPopupMenu.Items,index);
  if CanUpdateMenuIem then
  	UpdateOneMenuItem(FMenuItem,index);
  if Styles[index].Stylename=FDefaultStyle then
    DefaultStyleChanged;
end;

procedure TFontStyles.UpdateNew;
var
  Stylename : string;
begin
  Stylename := styles[styles.count-1].stylename;
  if assigned(FListbox) then
    FListbox.items.Add(Stylename);
  if CanUpdatePopupMenu then
  	AddMenuItem(FPopupMenu.Items,styles.count-1);
  if CanUpdateMenuIem then
  	AddMenuItem(FMenuItem,styles.count-1);
end;

function TFontStyles.AddMenuItem(AMenuItem: TMenuItem;
  index:integer): TMenuItem;
begin
  result := TMenuItem.Create(self);
  result.Caption := Styles[index].Stylename;
  result.tag := index;
  result.OnDrawItem := OnMenuItemDraw;
  result.OnMeasureItem := OnMenuItemMeasure;
  result.OnClick := OnClick;
  AMenuItem.Add(result);
end;

procedure TFontStyles.UpdateOneMenuItem(AMenuItem: TMenuItem;
  index: integer);
begin
  assert(AMenuItem[index].tag=index);
  AMenuItem[index].caption := Styles[index].Stylename;
end;

function TFontStyles.CanUpdateMenuIem: boolean;
begin
  result := not (csDesigning in ComponentState)
  		and (FMenuItem<>nil);
end;

function TFontStyles.CanUpdatePopupMenu: boolean;
begin
  result := not (csDesigning in ComponentState)
	  and (FPopupMenu<>nil);
end;

function TFontStyles.GetDefaultFont: TFont;
var
  i : integer;
begin
  i := Styles.IndexOfName(FDefaultStyle);
  if i>=0 then
  	result := Styles[i].font
  else
    result := nil;
end;

procedure TFontStyles.SetDefaultStyle(const Value: String);
begin
  if FDefaultStyle <> Value then
  begin
    FDefaultStyle := Value;
    DefaultStyleChanged;
  end;
end;

procedure TFontStyles.DefaultStyleChanged;
begin
  if assigned(FOnDefaultStyleChanged) then
    FOnDefaultStyleChanged(self);
end;

end.
