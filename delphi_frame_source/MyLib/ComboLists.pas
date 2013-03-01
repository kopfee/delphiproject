unit ComboLists;

{
  %ComboLists : 包含几个下拉框
}
(*****   Code Written By Huang YanLai   *****)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,LibMessages,ComWriUtils;

type
  // %TCustomCodeValues : 包含一系列的Code-Value组(代码表)
  TCustomCodeValues = class(TCompCommonAttrs)
  private
    FIsCodeSorted: boolean;
    function    GetCount: integer;
    function    GetCodes(index: integer): string;
    function    GetValues(index: integer): string;
    procedure   SetCodes(index: integer; const Value: string);
    procedure   SetValues(index: integer; const Value: string);
    function    GetNameCaseSen: boolean;
    function    GetValueCaseSen: boolean;
    procedure   SetNameCaseSen(const Value: boolean);
    procedure   SetValueCaseSen(const Value: boolean);
  protected
    FMap     :  TStringMap;
    property    NameCaseSen: boolean read GetNameCaseSen write SetNameCaseSen;
    property    ValueCaseSen:boolean read GetValueCaseSen write SetValueCaseSen;
    property    IsCodeSorted : boolean read FIsCodeSorted write FIsCodeSorted;
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    property    Codes[index : integer] : string read GetCodes write SetCodes;
    property    Values[index : integer] : string read GetValues write SetValues;
    property    Count : integer read GetCount;
    function    getValueByCode(const Code:string) : string;
    function    getCodeByValue(const value:string) : string;
    function    IndexOfCode(const Code:string) : integer;
    function    IndexOfValue(const value:string) : integer;
    function    FindNearestCode(const name:string) : integer;
    function    FindNearestValue(const Value:string) : integer;
  end;

  TCodeValues = class(TCustomCodeValues)
  private
    FItems: TStrings;
    procedure   SetItems(const Value: TStrings);
    procedure   ItemChanged(Sender : TObject);
    procedure   UpdateMap;
  protected
    procedure   Loaded; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
    property    Map : TStringMap read FMap;
  published
    property    Items : TStrings read FItems write SetItems;
  end;

  // %TCustomComboList : 下拉框显示TCustomCodeValues的Value值，返回实际Code
  // #功能：直接输入代码；输入Value在下拉框中定位；过滤
  TCustomComboList = class(TCustomComboBox)
  private
    { Private declarations }
    FValues   : TCustomCodeValues;
    FCanEdit:   boolean;
    FFiltered : boolean;
    FTempList : TStringList;
    procedure   SetValues(const Value: TCustomCodeValues);
    procedure   UpdateItems;
    procedure   LMComAttrsChanged(var message : TMessage);message LM_ComAttrsChanged;
    function    getCode: string;
    function    getValue: string;
    procedure   SetCode(const Value: string);
    procedure   SetValue(const Value: string);
    procedure   SetCanEdit(const Value: boolean);
    procedure   FilterItems;
  protected
    { Protected declarations }
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure   KeyPress(var Key: Char); override;
    procedure   KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure   FindThis;
    function    isCode(const s:string): boolean; virtual;
    procedure   DropDown; override;
    procedure   Change; override;

    property    Values : TCustomCodeValues read FValues write SetValues;
    property    CanEdit : boolean read FCanEdit write SetCanEdit default false;
    property    Filtered : boolean read FFiltered write FFiltered;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    procedure   Clear;
    property    Code    : string read getCode write SetCode;
    property    Value   : string read getValue write SetValue;
    procedure   GoNearestCode(const ACode:string);
    procedure   GoNearestValue(const AValue:string);
    procedure   RestoreItems;
  published
    { Published declarations }
  end;

  // %TComboList : 下拉框显示TCustomCodeValues的Value值，返回实际Code
  TComboList = class(TCustomComboList)
  published
    property    Filtered;
    property    Values;
    property    Code;
    property    Value;
    property    CanEdit;
    //property Style; {Must be published before Items}
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property ItemHeight;
    //property Items;
    //property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    //property Sorted;
    property TabOrder;
    property TabStop;
    //property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation


{ TCustomCodeValues }

constructor TCustomCodeValues.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMap     := TStringMap.Create(false,false);
end;

destructor TCustomCodeValues.Destroy;
begin
  FMap.free;
  inherited Destroy;
end;

function TCustomCodeValues.GetCount: integer;
begin
  result := FMap.Count;
end;

function TCustomCodeValues.GetCodes(index: integer): string;
begin
  result := FMap.Names[index];
end;

function TCustomCodeValues.GetValues(index: integer): string;
begin
  result := FMap.Values[index];
end;

procedure TCustomCodeValues.SetCodes(index: integer; const Value: string);
begin
  FMap.Names[index]:=value;
end;

procedure TCustomCodeValues.SetValues(index: integer; const Value: string);
begin
  FMap.Values[index]:=value;
end;

function TCustomCodeValues.getCodeByValue(const Value:string): string;
var
  i : integer;
begin
  i:=Fmap.IndexOfValue(Value);
  if i<0 then result:=''
  else result:=Fmap.names[i];
end;

function TCustomCodeValues.getValueByCode(const Code:string): string;
var
  i : integer;
begin
  i := IndexOfCode(code);
  if i<0 then result:=''
  else result:=Fmap.Values[i];
end;

function TCustomCodeValues.IndexOfCode(const Code: string): integer;
begin
  if FIsCodeSorted then
    result:=Fmap.FindName(Code)
  else result:=Fmap.IndexOfName(code);
end;

function TCustomCodeValues.IndexOfValue(const value: string): integer;
begin
  result := Fmap.IndexOfValue(Value);
end;

function TCustomCodeValues.GetNameCaseSen: boolean;
begin
  result := FMap.NameCaseSen;
end;

function TCustomCodeValues.GetValueCaseSen: boolean;
begin
  result := FMap.ValueCaseSen;
end;

procedure TCustomCodeValues.SetNameCaseSen(const Value: boolean);
begin
  FMap.NameCaseSen:=value;
end;

procedure TCustomCodeValues.SetValueCaseSen(const Value: boolean);
begin
  FMap.ValueCaseSen:=value;
end;

function TCustomCodeValues.FindNearestCode(const name: string): integer;
begin
  result := Fmap.FindNearestName(name);
end;

function TCustomCodeValues.FindNearestValue(const Value: string): integer;
begin
  result := Fmap.FindNearestValue(Value);
end;

{ TCustomComboList }

constructor TCustomComboList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Style := csDropDownList;
  FCanEdit := false;
  FTempList := TStringList.Create;
end;

destructor TCustomComboList.Destroy;
begin
  FTempList.free;
  inherited Destroy;
end;

procedure TCustomComboList.Clear;
begin
  ItemIndex:=-1;
  Change;
end;

function TCustomComboList.getCode: string;
begin
  if ItemIndex=-1 then
    result:=''
  else
  begin
    assert(FValues<>nil);
    //result := FValues.Codes[ItemIndex];
    result := FValues.Codes[integer(items.objects[ItemIndex])];
  end;
end;

function TCustomComboList.getValue: string;
begin
  if ItemIndex=-1 then
    result:=''
  else result := Items[ItemIndex];
end;

procedure TCustomComboList.GoNearestCode(const ACode: string);
var
  i : integer;
begin
  RestoreItems;
  if FValues<>nil then
  begin
    i := FValues.FindNearestCode(ACode);
    ItemIndex:=i;
  end
  else ItemIndex:=-1;
  Change;
end;


procedure TCustomComboList.GoNearestValue(const AValue: string);
var
  i : integer;
begin
  RestoreItems;
  if FValues<>nil then
  begin
    i := FValues.FindNearestValue(AValue);
    ItemIndex:=i;
  end
  else ItemIndex:=-1;
  Change;
end;


procedure TCustomComboList.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if CanEdit then
    if Filtered and DroppedDown then FilterItems
    else if not Filtered and (key=#13) then FindThis;
end;

procedure TCustomComboList.LMComAttrsChanged(var message: TMessage);
begin
  if message.WParam=WParam(FValues) then
    UpdateItems;
end;

procedure TCustomComboList.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (AComponent=FValues) and (Operation=opRemove) then
    FValues:=nil;
end;

procedure TCustomComboList.SetCanEdit(const Value: boolean);
begin
  if FCanEdit <> Value then
  begin
    FCanEdit := Value;
    if FCanEdit then
      Style := csDropDown
    else Style := csDropDownList;
  end;
end;

procedure TCustomComboList.SetCode(const Value: string);
var
  i : integer;
begin
  RestoreItems;
  if FValues<>nil then
  begin
    i := FValues.IndexOfCode(Value);
    ItemIndex:=i;
  end
  else ItemIndex:=-1;
  Change;
end;

procedure TCustomComboList.SetValue(const Value: string);
var
  i : integer;
begin
  RestoreItems;
  if FValues<>nil then
  begin
    i := FValues.IndexOfValue(Value);
    ItemIndex:=i;
  end
  else ItemIndex:=-1;
  Change;
end;


procedure TCustomComboList.SetValues(const Value: TCustomCodeValues);
begin
  if SetCommonAttrsProp(self,TCompCommonAttrs(FValues),value) then
    UpdateItems;
end;

procedure TCustomComboList.UpdateItems;
var
  i : integer;
begin
  Items.Clear;
  if FValues<>nil then
    for i:=0 to FValues.count-1 do
      Items.AddObject(FValues.values[i],TObject(i));
end;

procedure TCustomComboList.FindThis;
begin
  RestoreItems;
  if items.count=0 then exit
  else if text='' then
  begin
    itemIndex:=0;
    Change;
  end
  else begin
    if isCode(text) then GoNearestCode(text)
    else GoNearestValue(text);
  end;
end;

function TCustomComboList.isCode(const s: string): boolean;
begin
  result := (s<>'') and (s[1] in ['0'..'9']);
end;

procedure TCustomComboList.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key,Shift);
  if (key=VK_Delete) and (ssShift in Shift) then Clear
  else if CanEdit and Filtered and DroppedDown and ((key=VK_Delete) or (key=VK_BACK)) then
    FilterItems;
end;


procedure TCustomComboList.FilterItems;
var
  s : string;
  i : integer;
  Save : integer;
begin
    //ItemIndex:=-1;
    if Values=nil then exit;
    // save the SelStart
    Save := SelStart;
    s := text;
    if s='' then RestoreItems //UpdateItems
    else
    begin
      FtempList.BeginUpdate;
      FtempList.Clear;
      for i:=0 to values.count-1 do
      begin
        if pos(s,values.values[i])>0 then
          FtempList.AddObject(values.values[i],TObject(i));
      end;
      FtempList.EndUpdate;
      // 当用户选择一条记录时，不改变列表值
      if not ((FtempList.count=1) and  (FtempList[0]=s) and (Items.count>0)) then
        Items.Assign(FtempList);
    end;
    // restore the SelStart
    // 否则，Selstart=0，输入顺序反向
    SelStart := save;
end;

procedure TCustomComboList.RestoreItems;
begin
  if {Filtered and }(Values<>nil) and (Items.count<>Values.Count) then
    UpdateItems;
end;

procedure TCustomComboList.DropDown;
begin
  inherited DropDown;
  if canEdit and Filtered then FilterItems
  else RestoreItems;
end;

procedure TCustomComboList.Change;
begin
  inherited Change;
  //if DroppedDown and Filtered then FilterItems;
end;

{ TCodeValues }

constructor TCodeValues.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TStringList.Create;
  TStringList(FItems).OnChange := ItemChanged;
end;

destructor TCodeValues.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;


procedure TCodeValues.ItemChanged(Sender: TObject);
begin
  if not (csLoading in ComponentState) then
  begin
    UpdateMap;
  end;
end;

procedure TCodeValues.Loaded;
begin
  inherited;
  UpdateMap;
end;

procedure TCodeValues.SetItems(const Value: TStrings);
begin
  FItems.Assign(Value);
end;

procedure TCodeValues.UpdateMap;
var
  I : Integer;
  S : string;
  Code, Value : string;
  Index : Integer;
begin
  Map.Clear;
  for I:=0 to Items.Count-1 do
  begin
    S := Items[I];
    Index := Pos('=',S);
    if Index>0 then
    begin
      Value := Copy(S,1,Index-1);
      Code:= Copy(S,Index+1,Length(S));
      Map.Add(Code,Value);
    end;
  end;
end;

end.
