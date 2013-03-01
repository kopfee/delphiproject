unit WVCtrls;
{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>
   <What>
   <Written By> Huang YanLai (黄燕来)
   <History>
   1.1 修改了从字段到控件的同步方式。如果控件是退出时候同步，并且控件的值已经修改，那么强制更新
   1.0
   <Guide>
   如果控件是只读的，那么修改控件的值无法同步到工作字段!
**********************************************}


interface

uses Windows, Messages, SysUtils, Classes, Controls, Forms, WorkViews, StdCtrls,
  Mask, checklst, EditExts, WinUtils;

{
  当通过程序改变TWVEdit和TWVComboBox的ReadOnly或者Enabled状态的时候，应该调用他们的UpdateColor函数.
}

type
  {
    <Interface>IWVControl
    <What>使用TWVControlHelper和WorkView关联的控件必须支持的接口
    <Properties>

    <Methods>
      UpdateText      - 根据工作字段更新控件的数据
      UpdateColor     - 根据工作字段有效性更新控件的颜色
      UpdateProperty  - 更新控件的其他属性
      SendDataToField - 将控件的数据发送的工作字段
      GetReadOnly     - 控件是否只读
  }
  IWVControl = interface
    procedure   UpdateText;
    procedure   UpdateColor;
    procedure   UpdateProperty;
    procedure   SendDataToField;
    function    GetReadOnly : Boolean;
    function    AutoUpdateColor : Boolean;
  end;

  {
    <Class>TWVControlHelper
    <What>一个辅助组件，用于和WorkView关联
    <Properties>
      DataUpdating-正在更新数据
      Changed     -控件的数据发生改变，需要同步到工作字段

      Control     -对应的控件
      WVControl   -控件实现的IWVControl接口
      WorkView    -工作视图
      FieldName   -工作字段名
      Field       -工作字段
      SynchronizeWhenExit - 退出的时候同步
      DataPresentType   - 数据表达形式
      DataPresentParam  - 数据表达形式的参数
      ClearWhenError    - 当同步数据发生意外的时候，清空工作字段
    <Methods>
      LMWorkViewNotify  - 处理WorkView的消息
      Notification      - 释放对WorkView的引用
      DoLoaded          -
      DoExit
      UpdateAll
      UpdateColor
      UpdateProperty
      UpdateText
      Change
      KeyDown
      KeyPress
      KeyUp
      SendDataToField
      SynchronizeCtrlToField
    <Event>
      -
  }
  TWVControlHelper = class(TComponent)
  private
    FWVControl: IWVControl;
    FFieldName: string;
    FWorkView: TWorkView;
    FUpdating : Boolean;
    FChanged  : Boolean;
    FSynchronizeWhenExit: Boolean;
    FDataPresentParam: string;
    FControl: TControl;
    FDataPresentType: TDataPresentType;
    FField: TWVField;
    FClearWhenError: Boolean;
    FLastMagic : Integer;
    procedure   SetFieldName(const Value: string);
    procedure   SetWorkView(const Value: TWorkView);
    procedure   FindField;
    procedure   LMWorkViewNotify(var Message:TWVMessage); message LM_WorkViewNotify;
  protected
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
    property    DataUpdating : Boolean read FUpdating write FUpdating;
    property    Changed : Boolean read FChanged write FChanged;
  public
    constructor Create(AOwner : TComponent); override;

    procedure   DoLoaded;
    procedure   DoExit(Handle : THandle);
    procedure   UpdateAll;
    procedure   UpdateColor;
    procedure   UpdateProperty;
    procedure   UpdateText(ForceUpdate : Boolean=False);
    procedure   Change;
    procedure   KeyDown(var Key: Word; Shift: TShiftState);
    procedure   KeyPress(var Key: Char);
    procedure   KeyUp(var Key: Word; Shift: TShiftState);
    procedure   SendDataToField;
    procedure   SynchronizeCtrlToField;

    property    Control : TControl read FControl;
    property    WVControl : IWVControl read FWVControl write FWVControl;
    property    WorkView : TWorkView read FWorkView write SetWorkView;
    property    FieldName : string read FFieldName write SetFieldName;
    property    Field : TWVField read FField;
    property    SynchronizeWhenExit : Boolean read FSynchronizeWhenExit write FSynchronizeWhenExit;
    property    DataPresentType : TDataPresentType read FDataPresentType write FDataPresentType;
    property    DataPresentParam : string read FDataPresentParam write FDataPresentParam;
    property    ClearWhenError : Boolean read FClearWhenError write FClearWhenError default False;
  end;

  TWVEdit = class({TCustomMaskEdit}TMaskEdit, IWVControl)
  private
    FHelper: TWVControlHelper;
    // Implemnets IWVControl
    procedure   UpdateProperty;
    procedure   UpdateText;
    procedure   UpdateColor;
    procedure   SendDataToField;
    function    GetReadOnly: Boolean;
    function    AutoUpdateColor : Boolean;
    // Map Properties to Helper's Properties
    function    GetDataPresentParam: string;
    function    GetDataPresentType: TDataPresentType;
    function    GetFieldName: string;
    function    GetSynchronizeWhenExit: Boolean;
    function    GetWorkView: TWorkView;
    procedure   SetDataPresentParam(const Value: string);
    procedure   SetDataPresentType(const Value: TDataPresentType);
    procedure   SetFieldName(const Value: string);
    procedure   SetSynchronizeWhenExit(const Value: Boolean);
    procedure   SetWorkView(const Value: TWorkView);
    function    GetClearWhenError: Boolean;
    procedure   SetClearWhenError(const Value: Boolean);
    // Map Message to Helper's Handler
    procedure   LMWorkViewNotify(var Message:TWVMessage); message LM_WorkViewNotify;

    procedure   SetReadOnly(const Value: Boolean);
    procedure   CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    function    GetReadOnly2: Boolean;
  protected
    // Map Methods to Helper's Methods
    procedure   Loaded; override;
    procedure   Change; override;
    procedure   DoExit; override;
    procedure   KeyPress(var Key: Char); override;
    procedure   KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure   KeyUp(var Key: Word; Shift: TShiftState); override;
    property    Helper : TWVControlHelper read FHelper;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
    procedure   InputDataChanged(Synchronize : Boolean=True);
    procedure   ForceUpdateText;
  published
    // Publish Helper's Property
    property    WorkView : TWorkView read GetWorkView write SetWorkView;
    property    FieldName : string read GetFieldName write SetFieldName;
    property    DataPresentType : TDataPresentType read GetDataPresentType write SetDataPresentType;
    property    DataPresentParam : string read GetDataPresentParam write SetDataPresentParam;
    property    SynchronizeWhenExit : Boolean read GetSynchronizeWhenExit write SetSynchronizeWhenExit default False;
    property    ClearWhenError : Boolean read GetClearWhenError write SetClearWhenError default False;

    property    ReadOnly : Boolean read GetReadOnly2 write SetReadOnly;
    {
    // inherited properties
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EditMask;
    property Font;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
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
    property OnStartDock;
    property OnStartDrag;
    }
  end;

  TWVComboBox = class(TComboBox, IWVControl)
  private
    FIndexedValue: Boolean;
    FSeperatedStr: string;
    FAutoDropDown: Boolean;
    FItemsDataEntry: string;
    FHelper: TWVControlHelper;
    // Implemnets IWVControl
    procedure   UpdateText;
    procedure   UpdateColor;
    procedure   UpdateProperty;
    procedure   SendDataToField;
    function    GetReadOnly : Boolean;
    function    AutoUpdateColor : Boolean;
    // Map Properties to Helper's Properties
    function    GetDataPresentParam: string;
    function    GetDataPresentType: TDataPresentType;
    function    GetFieldName: string;
    function    GetSynchronizeWhenExit: Boolean;
    function    GetWorkView: TWorkView;
    procedure   SetDataPresentParam(const Value: string);
    procedure   SetDataPresentType(const Value: TDataPresentType);
    procedure   SetFieldName(const Value: string);
    procedure   SetSynchronizeWhenExit(const Value: Boolean);
    procedure   SetWorkView(const Value: TWorkView);
    function    GetClearWhenError: Boolean;
    procedure   SetClearWhenError(const Value: Boolean);
    // Map Message to Helper's Handler
    procedure   LMWorkViewNotify(var Message:TWVMessage); message LM_WorkViewNotify;

    procedure   SetItemsDataEntry(const Value: string);
    procedure   CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
  protected
    // Map Methods to Helper's Methods
    procedure   Loaded; override;
    procedure   Change; override;
    procedure   DoExit; override;
    procedure   KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure   KeyPress(var Key: Char); override;
    procedure   KeyUp(var Key: Word; Shift: TShiftState); override;
    property    Helper : TWVControlHelper read FHelper;

    procedure   DoEnter; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
    procedure   UpdateItems;
    procedure   InputDataChanged(Synchronize : Boolean=True);
    procedure   ForceUpdateText;
  published
    // Publish Helper's Property
    property    WorkView : TWorkView read GetWorkView write SetWorkView;
    property    FieldName : string read GetFieldName write SetFieldName;
    property    DataPresentType : TDataPresentType read GetDataPresentType write SetDataPresentType;
    property    DataPresentParam : string read GetDataPresentParam write SetDataPresentParam;
    property    SynchronizeWhenExit : Boolean read GetSynchronizeWhenExit write SetSynchronizeWhenExit default False;
    property    ClearWhenError : Boolean read GetClearWhenError write SetClearWhenError default False;

    property    SeperatedStr : string read FSeperatedStr write FSeperatedStr;
    property    IndexedValue : Boolean read FIndexedValue write FIndexedValue default False;
    property    AutoDropDown : Boolean read FAutoDropDown write FAutoDropDown;
    property    ItemsDataEntry : string read FItemsDataEntry write SetItemsDataEntry;
  end;

  TWVLabel = class(TLabel, IWVControl)
  private
    FHelper: TWVControlHelper;
    // Implemnets IWVControl
    procedure   UpdateText;
    procedure   UpdateColor;
    procedure   UpdateProperty;
    procedure   SendDataToField;
    function    GetReadOnly : Boolean;
    function    AutoUpdateColor : Boolean;
    // Map Properties to Helper's Properties
    function    GetDataPresentParam: string;
    function    GetDataPresentType: TDataPresentType;
    function    GetFieldName: string;
    function    GetWorkView: TWorkView;
    procedure   SetDataPresentParam(const Value: string);
    procedure   SetDataPresentType(const Value: TDataPresentType);
    procedure   SetFieldName(const Value: string);
    procedure   SetWorkView(const Value: TWorkView);
    // Map Message to Helper's Handler
    procedure   LMWorkViewNotify(var Message:TWVMessage); message LM_WorkViewNotify;
  protected
    // Map Methods to Helper's Methods
    procedure   Loaded; override;
    property    Helper : TWVControlHelper read FHelper;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
    procedure   ForceUpdateText;
  published
    // Publish Helper's Property
    property    WorkView : TWorkView read GetWorkView write SetWorkView;
    property    FieldName : string read GetFieldName write SetFieldName;
    property    DataPresentType : TDataPresentType read GetDataPresentType write SetDataPresentType;
    property    DataPresentParam : string read GetDataPresentParam write SetDataPresentParam;
  end;

  TWVCheckBoxDataPresent = (cdpEqual,cdpContain,cdpIndexedChar);
  TWVCheckBoxListDataPresent = cdpContain..cdpIndexedChar;

  {
    <Class>TWVCheckBox
    <What>和WorkView关联的CheckBox
    <Properties>
      WorkView-工作视图
      FieldName-工作字段名称
      DataPresentType-数据表现形式
      DataPresentParam－数据表现形式的参数
      CheckedValue-选中的时候的值
      UnCheckedValue-未选中的时候的值
      DefaultChecked-缺省是否选中
      PresentType-判断是否选中的方式。
        cdpEqual：是否和CheckedValue相等。
        cdpContain：是否包含CheckedValue。
        cdpIndexedChar：指定位置的子字符串是否等于CheckedValue。
      SeperateChar-用于cdpContain方式的分割字符，例如“,”。等于#0时表示没有分割的字符。
      CharIndex-用于cdpIndexedChar方式指定位置。实际对应字符串的下标为 (CharIndex-1)*Length(CheckedValue)+1
    <Methods>
      -
    <Event>
      -
  }
  TWVCheckBox = class(TCheckBox, IWVControl)
  private
    FUnCheckedValue: string;
    FCheckedValue: string;
    FDefaultChecked: Boolean;
    FPresentType: TWVCheckBoxDataPresent;
    FSeperateChar: Char;
    FCharIndex: Integer;
    FHelper: TWVControlHelper;
    // Implemnets IWVControl
    procedure   UpdateText;
    procedure   UpdateColor;
    procedure   UpdateProperty;
    procedure   SendDataToField;
    function    GetReadOnly : Boolean;
    function    AutoUpdateColor : Boolean;
    // Map Properties to Helper's Properties
    function    GetDataPresentParam: string;
    function    GetDataPresentType: TDataPresentType;
    function    GetFieldName: string;
    function    GetSynchronizeWhenExit: Boolean;
    function    GetWorkView: TWorkView;
    procedure   SetDataPresentParam(const Value: string);
    procedure   SetDataPresentType(const Value: TDataPresentType);
    procedure   SetFieldName(const Value: string);
    procedure   SetSynchronizeWhenExit(const Value: Boolean);
    procedure   SetWorkView(const Value: TWorkView);
    function    GetClearWhenError: Boolean;
    procedure   SetClearWhenError(const Value: Boolean);
    // Map Message to Helper's Handler
    procedure   LMWorkViewNotify(var Message:TWVMessage); message LM_WorkViewNotify;

    procedure   CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
  protected
    // Map Methods to Helper's Methods
    procedure   Loaded; override;
    procedure   DoExit; override;
    procedure   KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure   KeyPress(var Key: Char); override;
    procedure   KeyUp(var Key: Word; Shift: TShiftState); override;
    property    Helper : TWVControlHelper read FHelper;
    procedure   Click; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
    procedure   InputDataChanged(Synchronize : Boolean=True);
    procedure   ForceUpdateText;
  published
    // Publish Helper's Property
    property    WorkView : TWorkView read GetWorkView write SetWorkView;
    property    FieldName : string read GetFieldName write SetFieldName;
    property    DataPresentType : TDataPresentType read GetDataPresentType write SetDataPresentType;
    property    DataPresentParam : string read GetDataPresentParam write SetDataPresentParam;
    property    SynchronizeWhenExit : Boolean read GetSynchronizeWhenExit write SetSynchronizeWhenExit default False;
    property    ClearWhenError : Boolean read GetClearWhenError write SetClearWhenError default False;

    property    CheckedValue : string read FCheckedValue write FCheckedValue;
    property    UnCheckedValue : string read FUnCheckedValue write FUnCheckedValue;
    property    DefaultChecked : Boolean read FDefaultChecked write FDefaultChecked;
    property    PresentType : TWVCheckBoxDataPresent read FPresentType write FPresentType;
    property    SeperateChar : Char read FSeperateChar write FSeperateChar default #0;
    property    CharIndex : Integer read FCharIndex write FCharIndex default 0;
  end;

  {
    <Class>TWVCheckListBox
    <What>和WorkView关联的CheckListBox
    <Properties>
      WorkView-工作视图
      FieldName-工作字段名称
      DataPresentType-数据表现形式
      DataPresentParam－数据表现形式的参数
      CheckedValue-选中的时候的值
      UnCheckedValue-未选中的时候的值
      DefaultChecked-缺省是否选中
      PresentType-判断是否选中的方式。
        cdpContain：是否包含Items{I]文字的位于SeperatedStr前面的部分。
        cdpIndexedChar：指定位置(Items的下标)的子字符串是否等于CheckedValue。
      SeperateChar-用于cdpContain方式的分割字符，例如“,”。等于#0时表示没有分割的字符。
      ItemsDataEntry-用于初始化Items
      SeperatedStr-用于cdpContain方式，分割Items里面每个文本的字符串。位于SeperatedStr前面的部分被作为每个项目的比较基准。
      SynchronizeWhenExit-焦点失去的时候同步。
    <Methods>
      -
    <Event>
      -
  }
  TWVCheckListBox = class(TCheckListBox, IWVControl)
  private
    FDefaultChecked: Boolean;
    FSeperateChar: Char;
    FUnCheckedValue: string;
    FCheckedValue: string;
    FItemsDataEntry: string;
    FPresentType: TWVCheckBoxListDataPresent;
    FSeperatedStr: string;
    FHelper: TWVControlHelper;
    // Implemnets IWVControl
    procedure   UpdateProperty;
    procedure   UpdateText;
    procedure   UpdateColor;
    procedure   SendDataToField;
    function    GetReadOnly: Boolean;
    function    AutoUpdateColor : Boolean;
    // Map Properties to Helper's Properties
    function    GetDataPresentParam: string;
    function    GetDataPresentType: TDataPresentType;
    function    GetFieldName: string;
    function    GetSynchronizeWhenExit: Boolean;
    function    GetWorkView: TWorkView;
    procedure   SetDataPresentParam(const Value: string);
    procedure   SetDataPresentType(const Value: TDataPresentType);
    procedure   SetFieldName(const Value: string);
    procedure   SetSynchronizeWhenExit(const Value: Boolean);
    procedure   SetWorkView(const Value: TWorkView);
    function    GetClearWhenError: Boolean;
    procedure   SetClearWhenError(const Value: Boolean);
    // Map Message to Helper's Handler
    procedure   LMWorkViewNotify(var Message:TWVMessage); message LM_WorkViewNotify;

    procedure   CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure   SetItemsDataEntry(const Value: string);
  protected
    // Map Methods to Helper's Methods
    procedure   Loaded; override;
    procedure   DoExit; override;
    procedure   KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure   KeyPress(var Key: Char); override;
    procedure   KeyUp(var Key: Word; Shift: TShiftState); override;
    property    Helper : TWVControlHelper read FHelper;

    procedure   ClickCheck; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
    procedure   UpdateItems;
    procedure   InputDataChanged(Synchronize : Boolean=True);
    procedure   ForceUpdateText;
  published
    // Publish Helper's Property
    property    WorkView : TWorkView read GetWorkView write SetWorkView;
    property    FieldName : string read GetFieldName write SetFieldName;
    property    DataPresentType : TDataPresentType read GetDataPresentType write SetDataPresentType;
    property    DataPresentParam : string read GetDataPresentParam write SetDataPresentParam;
    property    SynchronizeWhenExit : Boolean read GetSynchronizeWhenExit write SetSynchronizeWhenExit default False;
    property    ClearWhenError : Boolean read GetClearWhenError write SetClearWhenError default False;

    property    CheckedValue : string read FCheckedValue write FCheckedValue;
    property    UnCheckedValue : string read FUnCheckedValue write FUnCheckedValue;
    property    DefaultChecked : Boolean read FDefaultChecked write FDefaultChecked;
    property    PresentType : TWVCheckBoxListDataPresent read FPresentType write FPresentType default cdpContain;
    property    SeperateChar : Char read FSeperateChar write FSeperateChar default #0;
    property    ItemsDataEntry : string read FItemsDataEntry write SetItemsDataEntry;
    property    SeperatedStr : string read FSeperatedStr write FSeperatedStr;
  end;

  TWVDigitalEdit = class(TKSDigitalEdit, IWVControl)
  private
    FHelper: TWVControlHelper;
    FSynchronizeByValue: Boolean;
    // Implemnets IWVControl
    procedure   UpdateProperty;
    procedure   UpdateText;
    procedure   UpdateColor;
    procedure   SendDataToField;
    function    GetReadOnly: Boolean;
    function    AutoUpdateColor : Boolean;
    // Map Properties to Helper's Properties
    function    GetDataPresentParam: string;
    function    GetDataPresentType: TDataPresentType;
    function    GetFieldName: string;
    function    GetSynchronizeWhenExit: Boolean;
    function    GetWorkView: TWorkView;
    procedure   SetDataPresentParam(const Value: string);
    procedure   SetDataPresentType(const Value: TDataPresentType);
    procedure   SetFieldName(const Value: string);
    procedure   SetSynchronizeWhenExit(const Value: Boolean);
    procedure   SetWorkView(const Value: TWorkView);
    function    GetClearWhenError: Boolean;
    procedure   SetClearWhenError(const Value: Boolean);
    // Map Message to Helper's Handler
    procedure   LMWorkViewNotify(var Message:TWVMessage); message LM_WorkViewNotify;

    procedure   CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
  protected
    // Map Methods to Helper's Methods
    procedure   Loaded; override;
    procedure   Change; override;
    procedure   DoExit; override;
    procedure   KeyPress(var Key: Char); override;
    procedure   KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure   KeyUp(var Key: Word; Shift: TShiftState); override;
    property    Helper : TWVControlHelper read FHelper;

    procedure   ReadOnlyChanged; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
    procedure   InputDataChanged(Synchronize : Boolean=True);
    procedure   ForceUpdateText;
  published
    // Publish Helper's Property
    property    WorkView : TWorkView read GetWorkView write SetWorkView;
    property    FieldName : string read GetFieldName write SetFieldName;
    property    DataPresentType : TDataPresentType read GetDataPresentType write SetDataPresentType;
    property    DataPresentParam : string read GetDataPresentParam write SetDataPresentParam;
    property    SynchronizeWhenExit : Boolean read GetSynchronizeWhenExit write SetSynchronizeWhenExit default True;
    property    ClearWhenError : Boolean read GetClearWhenError write SetClearWhenError default False;

    property    SynchronizeByValue : Boolean read FSynchronizeByValue write FSynchronizeByValue default False;
  end;


procedure LinkCtrl2WorkView(WorkView : TWorkView; AParent : TWinControl; Recur : Boolean);

procedure SetControlColor(Control : TControl; WorkView : TWorkView; Valid,ReadOnly : Boolean);

function  WVGetChecked(PresentType : TWVCheckBoxDataPresent; const Value, CheckedValue, UnCheckedValue : string;
  DefaultChecked : Boolean; SeperateChar : Char; CharIndex : Integer) : Boolean;

function  WVGetCheckedText(PresentType : TWVCheckBoxDataPresent; Checked : Boolean; const OldValue, CheckedValue, UnCheckedValue : string;
  SeperateChar : Char; CharIndex : Integer) : string;

function  GetCtrlWorkField(Ctrl : TControl) : TWVField;

implementation

uses KSStrUtils, Graphics;

procedure LinkCtrl2WorkView(WorkView : TWorkView; AParent : TWinControl; Recur : Boolean);
var
  I : Integer;
  Ctrl : TControl;
  Msg : TWVMessage;
begin
  Msg.Msg := LM_WorkViewNotify;
  Msg.NotifyCode:= WV_SetWorkView;
  Msg.Field := nil;
  Msg.WorkView := WorkView;
  for I:=0 to AParent.ControlCount-1 do
  begin
    Ctrl := AParent.Controls[I];
    Ctrl.Dispatch(Msg);
    {
    if Ctrl is TWVEdit then
    begin
      if TWVEdit(Ctrl).WorkView=nil then
        TWVEdit(Ctrl).WorkView := WorkView;
    end
    else if Ctrl is TWVComboBox then
    begin
      if TWVComboBox(Ctrl).WorkView=nil then
        TWVComboBox(Ctrl).WorkView := WorkView;
    end
    else if Ctrl is TWVLabel then
    begin
      if TWVLabel(Ctrl).WorkView=nil then
        TWVLabel(Ctrl).WorkView := WorkView;
    end
    else if Ctrl is TWVCheckBox then
    begin
      if TWVCheckBox(Ctrl).WorkView=nil then
        TWVCheckBox(Ctrl).WorkView := WorkView;
    end
    else if Ctrl is TWVCheckListBox then
    begin
      if TWVCheckListBox(Ctrl).WorkView=nil then
        TWVCheckListBox(Ctrl).WorkView := WorkView;
    end
    else if Ctrl is TWVDigitalEdit then
    begin
      if TWVDigitalEdit(Ctrl).WorkView=nil then
        TWVDigitalEdit(Ctrl).WorkView := WorkView;
    end
    else}
    if Recur and (Ctrl is TWinControl) then
      LinkCtrl2WorkView(WorkView,TWinControl(Ctrl),Recur);

  end;
end;

function GetCtrlWorkField(Ctrl : TControl) : TWVField;
begin
  {
  if Ctrl is TWVEdit then
    Result := TWVEdit(Ctrl).Field
  else if Ctrl is TWVComboBox then
    Result := TWVComboBox(Ctrl).Field
  else if Ctrl is TWVLabel then
    Result := TWVLabel(Ctrl).Field
  else if Ctrl is TWVCheckBox then
    Result := TWVCheckBox(Ctrl).Field
  else if Ctrl is TWVCheckListBox then
    Result := TWVCheckListBox(Ctrl).Field
  else if Ctrl is TWVDigitalEdit then
    Result := TWVDigitalEdit(Ctrl).Field
  else
    Result := nil;
  }
  Result := WVGetField(Ctrl);  
end;

type
  TControlAccess = class(TControl);
  TWinControlAccess = class(TWinControl);

procedure SetControlColor(Control : TControl; WorkView : TWorkView; Valid,ReadOnly : Boolean);
begin
  Assert((Control<>nil) and (WorkView<>nil));
  if ReadOnly then
  begin
    if WorkView.ReadOnlyColor=clNone then
      TControlAccess(Control).ParentColor := True else
      TControlAccess(Control).Color :=WorkView.ReadOnlyColor;
  end
  else if Valid then
  begin
    if WorkView.ValidColor=clNone then
      TControlAccess(Control).ParentColor := True else
      TControlAccess(Control).Color :=WorkView.ValidColor;
  end else
  begin
    if WorkView.InvalidColor=clNone then
      TControlAccess(Control).ParentColor := True else
      TControlAccess(Control).Color :=WorkView.InvalidColor;
  end;
end;

{ TWVEdit }

constructor TWVEdit.Create(AOwner: TComponent);
begin
  inherited;
  FHelper := TWVControlHelper.Create(Self);
  FHelper.WVControl := Self;
end;

destructor TWVEdit.Destroy;
begin
  FHelper.WVControl := nil;
  FreeAndNil(FHelper);
  inherited;
end;

procedure TWVEdit.Change;
begin
  inherited;
  if Helper<>nil then
    Helper.Change;
end;

procedure TWVEdit.DoExit;
begin
  inherited;
  Helper.DoExit(Handle);
end;

procedure TWVEdit.Loaded;
begin
  inherited;
  Helper.DoLoaded;
end;

procedure TWVEdit.UpdateColor;
begin

end;

procedure TWVEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  Helper.KeyDown(Key,Shift);
end;

procedure TWVEdit.KeyPress(var Key: Char);
var
  SavedKey : Char;
begin
  SavedKey := Key;
  inherited;
  // 将Enter键和其他特殊键恢复，避免因为EditMask修改它
  if (SavedKey=#13) then
    Key := SavedKey;
  if (Helper.Field<>nil) and (Helper.Field.GetPrevChar=SavedKey) then
    Key := SavedKey;

  Helper.KeyPress(Key);
  if (SavedKey=#13) and (Helper.Field<>nil) and not Helper.Field.Valid then
    SelectAll;
end;

procedure TWVEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
  Helper.KeyUp(Key,Shift);
end;

procedure TWVEdit.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Helper.UpdateColor;
end;

procedure TWVEdit.InputDataChanged(Synchronize : Boolean);
begin
  Helper.Change;
  if Synchronize then
    Helper.SynchronizeCtrlToField;
end;

function TWVEdit.GetDataPresentParam: string;
begin
  Result := Helper.DataPresentParam;
end;

function TWVEdit.GetDataPresentType: TDataPresentType;
begin
  Result := Helper.DataPresentType;
end;

function TWVEdit.GetFieldName: string;
begin
  Result := Helper.FieldName;
end;

function TWVEdit.GetSynchronizeWhenExit: Boolean;
begin
  Result := Helper.SynchronizeWhenExit;
end;

function TWVEdit.GetWorkView: TWorkView;
begin
  Result := Helper.WorkView;
end;

procedure TWVEdit.SetDataPresentParam(const Value: string);
begin
  Helper.DataPresentParam := Value;
end;

procedure TWVEdit.SetDataPresentType(const Value: TDataPresentType);
begin
  Helper.DataPresentType := Value;
end;

procedure TWVEdit.SetFieldName(const Value: string);
begin
  Helper.FieldName := Value;
end;

procedure TWVEdit.SetSynchronizeWhenExit(const Value: Boolean);
begin
  Helper.SynchronizeWhenExit := Value;
end;

procedure TWVEdit.SetWorkView(const Value: TWorkView);
begin
  Helper.WorkView := Value;
end;

function TWVEdit.GetReadOnly: Boolean;
begin
  Result := not Enabled or ReadOnly;
end;

function TWVEdit.GetClearWhenError: Boolean;
begin
  Result := Helper.ClearWhenError;
end;

procedure TWVEdit.SetClearWhenError(const Value: Boolean);
begin
  Helper.ClearWhenError := Value;
end;

procedure TWVEdit.LMWorkViewNotify(var Message: TWVMessage);
begin
  Helper.Dispatch(Message);
end;

procedure TWVEdit.SendDataToField;
begin
  if Helper.Field<>nil then
    Helper.Field.Data.AsString := Text;
end;

procedure TWVEdit.SetReadOnly(const Value: Boolean);
begin
  inherited ReadOnly := Value;
  Helper.UpdateColor;
end;

procedure TWVEdit.UpdateProperty;
begin
  if Helper.Field<>nil then
  begin
    MaxLength := Helper.Field.GetMaxLength;
  end;
end;

procedure TWVEdit.UpdateText;
begin
  if csDesigning in ComponentState then
  begin
    if EditMask='' then
      Text := '<'+FieldName+'>';
  end
  else if Helper.Field<>nil then
  begin
    Text := Helper.Field.Data.AsString;
  end;
end;

function TWVEdit.GetReadOnly2: Boolean;
begin
  Result := inherited ReadOnly;
end;

function TWVEdit.AutoUpdateColor: Boolean;
begin
  Result := True;
end;

procedure TWVEdit.ForceUpdateText;
begin
  Helper.UpdateText(True);
end;

{ TWVComboBox }

constructor TWVComboBox.Create(AOwner: TComponent);
begin
  inherited;
  FHelper := TWVControlHelper.Create(Self);
  FHelper.WVControl := Self;
end;

destructor TWVComboBox.Destroy;
begin
  FHelper.WVControl := nil;
  FreeAndNil(FHelper);
  inherited;
end;

procedure TWVComboBox.Change;
begin
  inherited;
  if Helper<>nil then
    Helper.Change;
end;

procedure TWVComboBox.DoExit;
begin
  inherited;
  Helper.DoExit(Handle);
end;

procedure TWVComboBox.Loaded;
begin
  inherited;
  Helper.DoLoaded;
  UpdateItems;
end;

procedure TWVComboBox.SendDataToField;
var
  I : Integer;
begin
  if Style=csDropDownList then
  begin
    if ItemIndex<0 then
      Helper.Field.Data.Clear
    else if IndexedValue then
      Helper.Field.Data.SetInteger(ItemIndex)
    else if SeperatedStr='' then
      Helper.Field.Data.AsString := Text
    else
    begin
      I := Pos(SeperatedStr,Text);
      if I>0 then
        Helper.Field.Data.AsString := Copy(Text,1,I-1) else
        Helper.Field.Data.AsString := Text;
    end;
  end else
    Helper.Field.Data.AsString := Text;
end;

procedure TWVComboBox.UpdateColor;
begin

end;

procedure TWVComboBox.UpdateText;
var
  Part : string;
  I : Integer;
begin
  if csDesigning in ComponentState then
    Text := '<'+FieldName+'>'
  else if Helper.Field<>nil then
  begin
    if Style=csDropDownList then
    begin
      if Helper.Field.Data.IsEmpty then
        ItemIndex := -1
      else if IndexedValue then
        ItemIndex := Helper.Field.Data.AsInteger
      else
        begin
          Part := Helper.Field.Data.AsString + SeperatedStr;
          for I:=0 to Items.Count-1 do
          begin
            if StartWith(Items[I],Part) then
            begin
              ItemIndex := I;
              Break;
            end;
          end;
        end;
    end else
      Text := Helper.Field.Data.AsString;
  end;
end;

procedure TWVComboBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  Helper.KeyDown(Key,Shift);
end;

procedure TWVComboBox.KeyPress(var Key: Char);
begin
  inherited;
  Helper.KeyPress(Key);
end;

procedure TWVComboBox.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
  Helper.KeyUp(Key,Shift);
end;

procedure TWVComboBox.DoEnter;
begin
  inherited;
  if AutoDropDown then
    DroppedDown:=True;
end;

procedure TWVComboBox.UpdateProperty;
begin

end;

procedure TWVComboBox.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Helper.UpdateColor;
end;

procedure TWVComboBox.SetItemsDataEntry(const Value: string);
begin
  if FItemsDataEntry<>Value then
  begin
    FItemsDataEntry := Value;
    UpdateItems;
  end;
end;

procedure TWVComboBox.UpdateItems;
begin
  if not (csLoading in ComponentState) then
  begin
    WVGetStrings(ItemsDataEntry,Self.Items);
    ForceUpdateText;
  end;
end;

procedure TWVComboBox.InputDataChanged(Synchronize : Boolean);
begin
  Helper.Change;
  if Synchronize then
    Helper.SynchronizeCtrlToField;
end;

function TWVComboBox.GetDataPresentParam: string;
begin
  Result := Helper.DataPresentParam;
end;

function TWVComboBox.GetDataPresentType: TDataPresentType;
begin
  Result := Helper.DataPresentType;
end;

function TWVComboBox.GetFieldName: string;
begin
  Result := Helper.FieldName;
end;

function TWVComboBox.GetSynchronizeWhenExit: Boolean;
begin
  Result := Helper.SynchronizeWhenExit;
end;

function TWVComboBox.GetWorkView: TWorkView;
begin
  Result := Helper.WorkView;
end;

procedure TWVComboBox.SetDataPresentParam(const Value: string);
begin
  Helper.DataPresentParam := Value;
end;

procedure TWVComboBox.SetDataPresentType(const Value: TDataPresentType);
begin
  Helper.DataPresentType := Value;
end;

procedure TWVComboBox.SetFieldName(const Value: string);
begin
  Helper.FieldName := Value;
end;

procedure TWVComboBox.SetSynchronizeWhenExit(const Value: Boolean);
begin
  Helper.SynchronizeWhenExit := Value;
end;

procedure TWVComboBox.SetWorkView(const Value: TWorkView);
begin
  Helper.WorkView := Value;
end;

function TWVComboBox.GetReadOnly: Boolean;
begin
  Result := not Enabled;
end;

function TWVComboBox.GetClearWhenError: Boolean;
begin
  Result := Helper.ClearWhenError;
end;

procedure TWVComboBox.SetClearWhenError(const Value: Boolean);
begin
  Helper.ClearWhenError := Value;
end;

procedure TWVComboBox.LMWorkViewNotify(var Message: TWVMessage);
begin
  Helper.Dispatch(Message);
end;

function TWVComboBox.AutoUpdateColor: Boolean;
begin
  Result := True;
end;

procedure TWVComboBox.ForceUpdateText;
begin
  Helper.UpdateText(True);
end;

{ TWVLabel }

constructor TWVLabel.Create(AOwner: TComponent);
begin
  inherited;
  FHelper := TWVControlHelper.Create(Self);
  FHelper.WVControl := Self;
end;

destructor TWVLabel.Destroy;
begin
  FHelper.WVControl := nil;
  FreeAndNil(FHelper);
  inherited;
end;

procedure TWVLabel.Loaded;
begin
  inherited;
  Helper.DoLoaded;
end;

procedure TWVLabel.SendDataToField;
begin

end;

procedure TWVLabel.UpdateColor;
begin

end;

procedure TWVLabel.UpdateProperty;
begin

end;

function TWVLabel.GetDataPresentParam: string;
begin
  Result := Helper.DataPresentParam;
end;

function TWVLabel.GetDataPresentType: TDataPresentType;
begin
  Result := Helper.DataPresentType;
end;

function TWVLabel.GetFieldName: string;
begin
  Result := Helper.FieldName;
end;

function TWVLabel.GetWorkView: TWorkView;
begin
  Result := Helper.WorkView;
end;

procedure TWVLabel.SetDataPresentParam(const Value: string);
begin
  Helper.DataPresentParam := Value;
end;

procedure TWVLabel.SetDataPresentType(const Value: TDataPresentType);
begin
  Helper.DataPresentType := Value;
end;

procedure TWVLabel.SetFieldName(const Value: string);
begin
  Helper.FieldName := Value;
end;

procedure TWVLabel.SetWorkView(const Value: TWorkView);
begin
  Helper.WorkView := Value;
end;

function TWVLabel.GetReadOnly: Boolean;
begin
  Result := True;
end;

procedure TWVLabel.UpdateText;
begin
  if csDesigning in ComponentState then
    Text := '<'+FieldName+'>'
  else if Helper.Field<>nil then
    Caption := Helper.Field.Data.AsString;
end;

function TWVLabel.AutoUpdateColor: Boolean;
begin
  Result := False;
end;

procedure TWVLabel.LMWorkViewNotify(var Message: TWVMessage);
begin
  Helper.Dispatch(Message);
end;

procedure TWVLabel.ForceUpdateText;
begin
  Helper.UpdateText(True);
end;

{ TWVCheckBox }

constructor TWVCheckBox.Create(AOwner: TComponent);
begin
  inherited;
  FHelper := TWVControlHelper.Create(Self);
  FHelper.WVControl := Self;

  FSeperateChar := #0;
  FCharIndex := 0;
end;

destructor TWVCheckBox.Destroy;
begin
  FHelper.WVControl := nil;
  FreeAndNil(FHelper);
  inherited;
end;

procedure TWVCheckBox.DoExit;
begin
  inherited;
  Helper.DoExit(Handle);
end;

procedure TWVCheckBox.Loaded;
begin
  inherited;
  Helper.DoLoaded;
end;

procedure TWVCheckBox.UpdateColor;
begin

end;

procedure TWVCheckBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  Helper.KeyDown(Key,Shift);
end;

procedure TWVCheckBox.KeyPress(var Key: Char);
begin
  inherited;
  Helper.KeyPress(Key);
end;

procedure TWVCheckBox.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
  Helper.KeyUp(Key,Shift);
end;

procedure TWVCheckBox.UpdateProperty;
begin

end;

procedure TWVCheckBox.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Helper.UpdateColor;
end;

procedure TWVCheckBox.InputDataChanged(Synchronize : Boolean);
begin
  Helper.Change;
  if Synchronize then
    Helper.SynchronizeCtrlToField;
end;

function TWVCheckBox.GetDataPresentParam: string;
begin
  Result := Helper.DataPresentParam;
end;

function TWVCheckBox.GetDataPresentType: TDataPresentType;
begin
  Result := Helper.DataPresentType;
end;

function TWVCheckBox.GetFieldName: string;
begin
  Result := Helper.FieldName;
end;

function TWVCheckBox.GetSynchronizeWhenExit: Boolean;
begin
  Result := Helper.SynchronizeWhenExit;
end;

function TWVCheckBox.GetWorkView: TWorkView;
begin
  Result := Helper.WorkView;
end;

procedure TWVCheckBox.SetDataPresentParam(const Value: string);
begin
  Helper.DataPresentParam := Value;
end;

procedure TWVCheckBox.SetDataPresentType(const Value: TDataPresentType);
begin
  Helper.DataPresentType := Value;
end;

procedure TWVCheckBox.SetFieldName(const Value: string);
begin
  Helper.FieldName := Value;
end;

procedure TWVCheckBox.SetSynchronizeWhenExit(const Value: Boolean);
begin
  Helper.SynchronizeWhenExit := Value;
end;

procedure TWVCheckBox.SetWorkView(const Value: TWorkView);
begin
  Helper.WorkView := Value;
end;

function TWVCheckBox.GetReadOnly: Boolean;
begin
  Result := not Enabled;
end;

function TWVCheckBox.GetClearWhenError: Boolean;
begin
  Result := Helper.ClearWhenError;
end;

procedure TWVCheckBox.SetClearWhenError(const Value: Boolean);
begin
  Helper.ClearWhenError := Value;
end;

procedure TWVCheckBox.LMWorkViewNotify(var Message: TWVMessage);
begin
  Helper.Dispatch(Message);
end;

procedure TWVCheckBox.Click;
begin
  inherited;
  if Helper<>nil then
    Helper.Change;
end;

function  WVGetCheckedText(PresentType : TWVCheckBoxDataPresent; Checked : Boolean; const OldValue, CheckedValue, UnCheckedValue : string;
  SeperateChar : Char; CharIndex : Integer) : string;
var
  Left, Right : string;
  Len : Integer;
begin
    case PresentType of
      cdpEqual:       if Checked then
                        Result := CheckedValue else
                        Result := UnCheckedValue;
      cdpContain:     begin
                        if Checked then
                        begin
                          if Pos(CheckedValue,OldValue)<=0 then
                          begin
                            // 需要增加字符串
                            if SeperateChar=#0 then
                            begin
                              Result := OldValue + CheckedValue;
                            end else
                            begin
                              if (OldValue<>'') and (OldValue[Length(OldValue)]<>SeperateChar) then
                                Result := OldValue + SeperateChar + CheckedValue else
                                Result := OldValue + CheckedValue;
                            end;
                          end;
                        end else
                        begin
                          // 删除字符串
                          if SeperateChar=#0 then
                            Result := StringReplace(OldValue,CheckedValue,'',[rfReplaceAll])
                          else
                          begin
                            Result := StringReplace(OldValue,CheckedValue,'',[rfReplaceAll]);
                            // 去掉重复的分割符号
                            Result := StringReplace(Result,SeperateChar+SeperateChar,SeperateChar,[rfReplaceAll]);
                            //  去掉第一个分割符号
                            if (Result<>'') and (Result[1]=SeperateChar) then
                              Delete(Result,1,1);
                          end;
                        end;
                      end;
      cdpIndexedChar: begin
                        Len := Length(CheckedValue);
                        Left := Copy(OldValue,1,CharIndex-1);
                        Right := Copy(OldValue,CharIndex+Len,Length(OldValue));
                        // 保证左边有足够的字符
                        if Length(Left)<CharIndex-1 then
                        begin
                          Left := Left + StringOfChar(' ',CharIndex-1-Length(Left));
                        end;
                        if Checked then
                          Result := Left + CheckedValue + Right else
                          Result := Left + UnCheckedValue + Right;
                      end;
    end;
end;

procedure TWVCheckBox.SendDataToField;
begin
  if Helper.Field<>nil then
    Helper.Field.Data.AsString := WVGetCheckedText(
      PresentType,Checked,
      Helper.Field.Data.AsString,CheckedValue,UnCheckedValue,SeperateChar,CharIndex);
end;

function  WVGetChecked(PresentType : TWVCheckBoxDataPresent; const Value, CheckedValue, UnCheckedValue : string;
  DefaultChecked : Boolean; SeperateChar : Char; CharIndex : Integer) : Boolean;
var
  TestValue : string;
begin
  if PresentType=cdpIndexedChar then
    TestValue := Copy(Value,(CharIndex-1)*Length(CheckedValue)+1,Length(CheckedValue)) else
    TestValue := Value;
  case PresentType of
    cdpEqual,
    cdpIndexedChar: if TestValue=CheckedValue then
                      Result := True
                    else if TestValue=UnCheckedValue then
                      Result := False
                    else
                      Result := DefaultChecked;
    cdpContain  :   Result := Pos(CheckedValue,TestValue)>0;
  else
    Result := False;
  end;
end;

procedure TWVCheckBox.UpdateText;
var
  Value : string;
begin
  if Helper.Field<>nil then
  begin
    Value := Helper.Field.Data.AsString;
    Checked := WVGetChecked(PresentType,Value,CheckedValue,UnCheckedValue,DefaultChecked,SeperateChar,CharIndex);
  end;
end;

function TWVCheckBox.AutoUpdateColor: Boolean;
begin
  Result := False;
end;

procedure TWVCheckBox.ForceUpdateText;
begin
  Helper.UpdateText(True);
end;

{ TWVCheckListBox }

constructor TWVCheckListBox.Create(AOwner: TComponent);
begin
  inherited;
  FHelper := TWVControlHelper.Create(Self);
  FHelper.WVControl := Self;

  PresentType := cdpContain;
  SeperateChar := #0;
end;

destructor TWVCheckListBox.Destroy;
begin
  FHelper.WVControl := nil;
  FreeAndNil(FHelper);
  inherited;
end;

procedure TWVCheckListBox.DoExit;
begin
  inherited;
  Helper.DoExit(Handle);
end;

procedure TWVCheckListBox.Loaded;
begin
  inherited;
  Helper.DoLoaded;
  UpdateItems;
end;

procedure TWVCheckListBox.UpdateColor;
begin

end;

procedure TWVCheckListBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  Helper.KeyDown(Key,Shift);
end;

procedure TWVCheckListBox.KeyPress(var Key: Char);
begin
  inherited;
  Helper.KeyPress(Key);
end;

procedure TWVCheckListBox.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
  Helper.KeyUp(Key,Shift);
end;

procedure TWVCheckListBox.UpdateProperty;
begin

end;

procedure TWVCheckListBox.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Helper.UpdateColor;
end;

procedure TWVCheckListBox.SetItemsDataEntry(const Value: string);
begin
  if FItemsDataEntry<>Value then
  begin
    FItemsDataEntry := Value;
    UpdateItems;
  end;
end;

procedure TWVCheckListBox.UpdateItems;
begin
  if not (csLoading in ComponentState) then
  begin
    WVGetStrings(ItemsDataEntry,Self.Items);
    ForceUpdateText;
  end;
end;

procedure TWVCheckListBox.InputDataChanged(Synchronize : Boolean);
begin
  Helper.Change;
  if Synchronize then
    Helper.SynchronizeCtrlToField;
end;

function TWVCheckListBox.GetDataPresentParam: string;
begin
  Result := Helper.DataPresentParam;
end;

function TWVCheckListBox.GetDataPresentType: TDataPresentType;
begin
  Result := Helper.DataPresentType;
end;

function TWVCheckListBox.GetFieldName: string;
begin
  Result := Helper.FieldName;
end;

function TWVCheckListBox.GetSynchronizeWhenExit: Boolean;
begin
  Result := Helper.SynchronizeWhenExit;
end;

function TWVCheckListBox.GetWorkView: TWorkView;
begin
  Result := Helper.WorkView;
end;

procedure TWVCheckListBox.SetDataPresentParam(const Value: string);
begin
  Helper.DataPresentParam := Value;
end;

procedure TWVCheckListBox.SetDataPresentType(const Value: TDataPresentType);
begin
  Helper.DataPresentType := Value;
end;

procedure TWVCheckListBox.SetFieldName(const Value: string);
begin
  Helper.FieldName := Value;
end;

procedure TWVCheckListBox.SetSynchronizeWhenExit(const Value: Boolean);
begin
  Helper.SynchronizeWhenExit := Value;
end;

procedure TWVCheckListBox.SetWorkView(const Value: TWorkView);
begin
  Helper.WorkView := Value;
end;

function TWVCheckListBox.GetReadOnly: Boolean;
begin
  Result := not Enabled;
end;

function TWVCheckListBox.GetClearWhenError: Boolean;
begin
  Result := Helper.ClearWhenError;
end;

procedure TWVCheckListBox.SetClearWhenError(const Value: Boolean);
begin
  Helper.ClearWhenError := Value;
end;

procedure TWVCheckListBox.LMWorkViewNotify(var Message: TWVMessage);
begin
  Helper.Dispatch(Message);
end;

procedure TWVCheckListBox.SendDataToField;
var
  I,K : Integer;
  All, Part : string;
begin
  if Helper.Field<>nil  then
  begin
    All:='';
    Part:='';
    for I:=0 to Items.Count-1 do
    begin
      case PresentType of
        cdpContain    : if Checked[I] then
                        begin
                          if SeperatedStr<>'' then
                          begin
                            K := pos(SeperatedStr,Items[I]);
                            if K>0 then
                              Part := Copy(Items[I],1,K-1) else
                              Part := Items[I];
                          end else
                            Part := Items[I];
                          All := All + Part;
                          if SeperateChar<>#0 then
                            All := All + SeperateChar;
                        end;
        cdpIndexedChar: begin
                          if Checked[I] then
                            Part := CheckedValue else
                            Part := UnCheckedValue;
                          All := All + Part;
                        end;
      end;
    end;
    Helper.Field.Data.AsString := All;
  end;
end;

procedure TWVCheckListBox.UpdateText;
var
  I,K : Integer;
  Part, Value : string;
begin
  if not (csDesigning in ComponentState) and (Helper.Field<>nil) then
  begin
    Value := Helper.Field.Data.AsString;
    for I:=0 to Items.Count-1 do
    begin
      case PresentType of
        cdpContain    : begin
                          if SeperatedStr<>'' then
                          begin
                            K := pos(SeperatedStr,Items[I]);
                            if K>0 then
                              Part := Copy(Items[I],1,K-1) else
                              Part := Items[I];
                          end else
                            Part := Items[I];
                          Checked[I] := Pos(Part,Value)>0;
                        end;
        cdpIndexedChar: Checked[I] := WVGetChecked(PresentType,Value,CheckedValue,UnCheckedValue,DefaultChecked,SeperateChar,I+1);
      end;
    end;
  end;
end;

procedure TWVCheckListBox.ClickCheck;
begin
  inherited;
  if Helper<>nil then
    Helper.Change;
end;

function TWVCheckListBox.AutoUpdateColor: Boolean;
begin
  Result := True;
end;

procedure TWVCheckListBox.ForceUpdateText;
begin
  Helper.UpdateText(True);
end;

{ TWVDigitalEdit }

constructor TWVDigitalEdit.Create(AOwner: TComponent);
begin
  inherited;
  FHelper := TWVControlHelper.Create(Self);
  FHelper.WVControl := Self;
  FHelper.SynchronizeWhenExit := True;

  SynchronizeByValue := False;
end;

destructor TWVDigitalEdit.Destroy;
begin
  FHelper.WVControl := nil;
  FreeAndNil(FHelper);
  inherited;
end;

procedure TWVDigitalEdit.Change;
begin
  inherited;
  // 必须判断FHelper，因为缺省的Create事件会触发Change;
  if Helper<>nil then
    Helper.Change;
end;

procedure TWVDigitalEdit.DoExit;
begin
  inherited;
  Helper.DoExit(Handle);
end;

procedure TWVDigitalEdit.Loaded;
begin
  inherited;
  Helper.DoLoaded;
end;

procedure TWVDigitalEdit.UpdateColor;
begin

end;

procedure TWVDigitalEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  Helper.KeyDown(Key,Shift);
end;

procedure TWVDigitalEdit.KeyPress(var Key: Char);
var
  SavedKey : Char;
begin
  // 特别地先让字段处理该事件，然后才是父类处理。这样字段可以获得Enter等消息。
  SavedKey := Key;
  if (Key=DeleteChar) or (Key=ClearChar) then
  begin
    // 保护删除键和清空键
    Helper.KeyPress(Key);
    Key := SavedKey;
  end else
  begin
    Helper.KeyPress(Key);
  end;
  inherited;
  if (SavedKey=#13) and (Helper.Field<>nil) and not Helper.Field.Valid then
    Selected := True;
end;

procedure TWVDigitalEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
  Helper.KeyUp(Key,Shift);
end;

procedure TWVDigitalEdit.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Helper.UpdateColor;
end;

procedure TWVDigitalEdit.InputDataChanged(Synchronize : Boolean);
begin
  Helper.Change;
  if Synchronize then
    Helper.SynchronizeCtrlToField;
end;

function TWVDigitalEdit.GetDataPresentParam: string;
begin
  Result := Helper.DataPresentParam;
end;

function TWVDigitalEdit.GetDataPresentType: TDataPresentType;
begin
  Result := Helper.DataPresentType;
end;

function TWVDigitalEdit.GetFieldName: string;
begin
  Result := Helper.FieldName;
end;

function TWVDigitalEdit.GetSynchronizeWhenExit: Boolean;
begin
  Result := Helper.SynchronizeWhenExit;
end;

function TWVDigitalEdit.GetWorkView: TWorkView;
begin
  Result := Helper.WorkView;
end;

procedure TWVDigitalEdit.SetDataPresentParam(const Value: string);
begin
  Helper.DataPresentParam := Value;
end;

procedure TWVDigitalEdit.SetDataPresentType(const Value: TDataPresentType);
begin
  Helper.DataPresentType := Value;
end;

procedure TWVDigitalEdit.SetFieldName(const Value: string);
begin
  Helper.FieldName := Value;
end;

procedure TWVDigitalEdit.SetSynchronizeWhenExit(const Value: Boolean);
begin
  Helper.SynchronizeWhenExit := Value;
end;

procedure TWVDigitalEdit.SetWorkView(const Value: TWorkView);
begin
  Helper.WorkView := Value;
end;

function TWVDigitalEdit.GetReadOnly: Boolean;
begin
  Result := not Enabled or ReadOnly;
end;

function TWVDigitalEdit.GetClearWhenError: Boolean;
begin
  Result := Helper.ClearWhenError;
end;

procedure TWVDigitalEdit.SetClearWhenError(const Value: Boolean);
begin
  Helper.ClearWhenError := Value;
end;

procedure TWVDigitalEdit.LMWorkViewNotify(var Message: TWVMessage);
begin
  Helper.Dispatch(Message);
end;

procedure TWVDigitalEdit.UpdateProperty;
begin

end;

procedure TWVDigitalEdit.SendDataToField;
begin
  if Helper.Field<>nil then
  begin
    Helper.Field.Data.AsString := Text;
  end;
end;

procedure TWVDigitalEdit.UpdateText;
var
  APrecision, ADigits: Integer;
begin
  if Helper.Field<>nil then
  begin
    if SynchronizeByValue then
    begin
      if Helper.Field.Data.IsEmpty then
        Clear else
      begin
        if Precision<=0 then
          ADigits := 0 else
          ADigits := Precision;
        APrecision := 15;
        Text := FloatToStrF(Helper.Field.Data.AsFloat,ffFixed,APrecision,ADigits);
      end;
    end
    else
      Text := Helper.Field.Data.AsString;
  end;
  if Text='' then
    Clear;
end;

procedure TWVDigitalEdit.ReadOnlyChanged;
begin
  inherited;
  Helper.UpdateColor;
end;

function TWVDigitalEdit.AutoUpdateColor: Boolean;
begin
  Result := True;
end;

procedure TWVDigitalEdit.ForceUpdateText;
begin
  Helper.UpdateText(True);
end;

{ TWVControlHelper }

constructor TWVControlHelper.Create(AOwner: TComponent);
begin
  Assert(AOwner is TControl);
  inherited;
  FControl := TControl(AOwner);
  FChanged := False;
  FUpdating := False;
end;

procedure TWVControlHelper.Change;
begin
  if not FUpdating and (Field<>nil) and not(csDesigning in ComponentState) then
  begin
    FChanged := True;
    if not SynchronizeWhenExit then
      SendDataToField;
  end;
end;

procedure TWVControlHelper.FindField;
begin
  if not (csLoading in ComponentState) and (FWorkView<>nil) then
    FField:=FWorkView.FindField(FieldName) else
    FField:=nil;
  FLastMagic := -1;
  if FField<>nil then
    UpdateAll;
end;


procedure TWVControlHelper.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Field<>nil then
    Field.KeyDown(Control,Key,Shift);
end;

procedure TWVControlHelper.KeyPress(var Key: Char);
begin
  if Field<>nil then
    Field.KeyPress(Control,Key);
end;

procedure TWVControlHelper.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if Field<>nil then
    Field.KeyUp(Control,Key,Shift);
end;

procedure TWVControlHelper.LMWorkViewNotify(var Message: TWVMessage);
begin
  // field messages
  if ((Message.Field=Field) or (Message.Field=nil)) and (Field<>nil) then
  begin
    case Message.NotifyCode of
      WV_FieldValueChanged :
        UpdateText(FChanged and FSynchronizeWhenExit);
      WV_FieldValidChanged :
        UpdateColor;
      WV_SendDataToField :
        if Message.Field<>nil then
          SendDataToField;
      WV_FieldPropertyChanged :
        UpdateProperty;
      WV_SynchronizeCtrlToField :
        SynchronizeCtrlToField;
    end;
  end;
  // other messages
  case Message.NotifyCode of
    WV_PropertyChanged :
      UpdateColor;
    WV_GetField :
      Message.Field := Field;
    WV_GetWorkView :
      Message.WorkView:= WorkView;
    WV_SetWorkView :
      if WorkView=nil then
        WorkView := Message.WorkView;
    WV_FieldDestroy:
      if Message.Field=Field then
        FField := nil;
    WV_FieldNameChanged :
      if Field=nil then
        FindField
      else if Message.Field=Field then
        FFieldName := Message.Field.Name;
  end;
end;

procedure TWVControlHelper.DoLoaded;
begin
  inherited;
  FindField;
end;

procedure TWVControlHelper.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation=opRemove) and (AComponent=WorkView) then
  begin
    WorkView := nil;
  end;
end;

procedure TWVControlHelper.SendDataToField;
begin
  FChanged := False;
  if (Field<>nil) and not WVControl.GetReadOnly then
  begin
    try
      if DataPresentType<>'' then
        WVCtrlToField(Control,Field,DataPresentType,DataPresentParam) else
        WVControl.SendDataToField;
    except
      on E : Exception do
      begin
        if WorkView<>nil then
          WorkView.HandleException(Control, E) else
          Application.HandleException(Control);
        if ClearWhenError then
          Field.Data.Clear else
          UpdateAll;
      end;
    end;
  end;
end;

procedure TWVControlHelper.SetFieldName(const Value: string);
begin
  if FFieldName <> Value then
  begin
    FFieldName := Value;
    FindField;
  end;
end;

procedure TWVControlHelper.SetWorkView(const Value: TWorkView);
begin
  if FWorkView<>Value then
  begin
    if FWorkView<>nil then
      FWorkView.RemoveClient(Self);
    FWorkView := Value;
    if FWorkView<>nil then
      FWorkView.AddClient(Self);
    FindField;
  end;
end;

procedure TWVControlHelper.SynchronizeCtrlToField;
begin
  if Changed and (Field<>nil) then
    SendDataToField;
end;

procedure TWVControlHelper.UpdateAll;
begin
  UpdateText;
  UpdateColor;
  UpdateProperty;
end;

procedure TWVControlHelper.UpdateColor;
begin
  if (Field<>nil) and (WorkView<>nil) then
  begin
    if WVControl.AutoUpdateColor then
      SetControlColor(Control,WorkView,Field.Valid,WVControl.GetReadOnly);
  end;
  WVControl.UpdateColor;
end;

procedure TWVControlHelper.UpdateProperty;
begin
  if Field<>nil then
  begin
    if Control is TWinControl then
      TWinControlAccess(Control).ImeMode := Field.ImeMode;
    //if Hint='' then
    TControlAccess(Control).Hint := Field.GetHint;
  end;
  WVControl.UpdateProperty;
end;

procedure TWVControlHelper.UpdateText(ForceUpdate : Boolean=False);
begin
  if csDesigning in ComponentState then
  begin
    FChanged := False;
    WVControl.UpdateText;
  end
  else if Field<>nil then
  begin
    if ForceUpdate or (FLastMagic<>Field.Magic) then
    begin
      FChanged := False;
      FLastMagic := Field.Magic;
      FUpdating := True;
      try
        if DataPresentType<>'' then
          WVFieldToCtrl(Field,Control,DataPresentType,DataPresentParam) else
          WVControl.UpdateText;
      finally
        FUpdating := False;
      end;
    end;
  end;
end;

procedure TWVControlHelper.DoExit(Handle: THandle);
begin
  if SynchronizeWhenExit and Changed and (Field<>nil) then
    PostMessage(Handle,LM_WorkViewNotify,WV_SendDataToField,Integer(Field));
end;

end.
