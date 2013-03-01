unit WorkViews;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>WorkViews
   <What>支持工作视图的对象类
   工作视图是一种描述数据输入界面程序的模型。一个工作视图包含了在一个操作界面中需要处理的所有的数据
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

{
关于字段的值和有效性发生改变的时候，处理流程：
字段的值发生改变：
1、TKSDataObject调用TWVField.DataValueChanged。
  如果没有设置FProcessingFieldChanged，继续处理
2、然后TWVField调用TWorkView.FieldValueChanged(Self);
3、在 TWorkView.FieldValueChanged里面
  当设置了FReseting或者csLoading或者csDestroying的时候不处理
  否则：
  1) 调用每个字段的FieldValueChanged
  2) 调用每个监视器的FieldValueChanged
  3) 向侦听的客户（Clients）发送消息
  4) 改变时间戳

注意：
  TWorkView、TWVField、TWVFieldMonitor的FieldValueChanged方法里面，
  初始Field 表示发生改变的字段，如果 Field=nil，表示AGroupIndex里面所有的字段都变化了。

TWVField.FieldValueChanged的处理
 1)判断字段本身发生是否改变：当字段是自己或者nil，并且FLastMagic<>FMagic
 2)判断是否是监控的字段发生改变
 3)如果是监控的字段发生改变，触发OnUpdateValue，可以改变字段的值
 利用FProcessingFieldChanged标志，如果在OnUpdateValue里面修改字段的值，不再触发事件，优化处理
 4)当字段本身或者监控的字段发生了改变，调用CheckValid，可以改变字段的值，例如补齐
 利用FProcessingFieldChanged标志，如果在CheckValid里面修改字段的值，不再触发事件，优化处理
 5)重新判断字段本身发生是否改变：当字段是自己或者nil，并且FLastMagic<>FMagic
   NeedReCheck满足的条件是：IsMonitoredField或者SelfChanged
  重新计算的时候不再判断字段，因为使用FProcessingFieldChanged屏蔽了处理事件的再次触发，
  所以这里应该根据FLastMagic进行精确的判断
 6)如果字段本身发生改变，触发OnValueChanged时间

TWVFieldMonitor.FieldValueChanged的处理
当字段为nil并且AGroupIndex符合；或者字段名称被包括在MonitorValueChangedFields，触发处理

}

{$I KSConditions.INC }

interface

uses SysUtils, Classes, DataTypes, LibMessages, Graphics, Controls, ObjDir, DB;

const
  LM_WorkViewNotify = LM_BASE + 10;
  WV_FieldValueChanged      = 1;
  WV_FieldValidChanged      = 2;
  WV_FieldChanged           = 3;
  WV_SendDataToField        = 4;
  WV_FieldPropertyChanged   = 5;
  WV_SynchronizeCtrlToField = 6;
  WV_PropertyChanged        = 7;
  WV_GetField               = 8;
  WV_GetWorkView            = 9;
  WV_SetWorkView            = 10;
  WV_FieldDestroy           = 11;
  WV_FieldListChanged       = 12;
  WV_FieldNameChanged       = 13;

  SeperateFieldChar = '|';
  MaxNumberCharLength = 22;

type
  TWorkView = class;
  TWVDoProcess = class;
  TWVWorkProcess = class;
  TWVField = class;
  TWVFieldDomain = class;
  TWVFieldChecker = class;
  TWorkViewCenter = class;

  TDataPresentType = type string;

  TWVMessage = packed record
    Msg : Cardinal;
    NotifyCode : Integer;
    Field : TWVField;
    WorkView : TWorkView;
  end;

  TWVExceptionEvent = procedure (Sender : TObject; E : Exception) of object;
  TFieldEvent = procedure (WorkField : TWVField) of object;
  TFieldEvent2 = procedure (WorkField : TWVField; Target : TObject) of object;

  {
    <Class>TWorkView
    <What>工作视图
    工作视图是一种描述数据输入界面程序的模型。一个工作视图包含了在一个操作界面中需要处理的所有的数据
    <Properties>
      -
    <Methods>
      GetInvalidFieldCaptions - 获得无效的字段的标题
      DataChanged - 增加TimeStamp，表明数据已经发生改变。
    <Event>
      -
  }
  TWorkView = class(TComponent)
  private
    FDescription: string;
    FNotes: string;
    FWorkName: string;
    FWorkfields: TCollection;
    FWorkProcesses: TCollection;
    FSecurity: string;
    FExits: string;
    FEntries: string;
    FUsers: string;
    FClients : TList;
    FInvalidColor: TColor;
    FValidColor: TColor;
    FOnException: TWVExceptionEvent;
    FFieldsMonitors: TCollection;
    FContainer: TWinControl;
    FTimeStamp: Integer;
    FReadOnlyColor: TColor;
    FOnInvalidInput: TFieldEvent2;
    FWorkViewCenter: TWorkViewCenter;
    FReseting : Boolean;
    procedure   SetWorkfields(const Value: TCollection);
    procedure   SetWorkProcesses(const Value: TCollection);
    procedure   SetFieldsMonitors(const Value: TCollection);
    procedure   SetContainer(const Value: TWinControl);
    function    GetFieldCount: Integer;
    function    GetFields(Index: Integer): TWVField;
    procedure   SetInvalidColor(const Value: TColor);
    procedure   SetReadOnlyColor(const Value: TColor);
    procedure   SetValidColor(const Value: TColor);
    procedure   SetWorkViewCenter(const Value: TWorkViewCenter);
    procedure   UpdateWorkViewCenter;
    function    GetWorkViewCenter: TWorkViewCenter;
  protected
    // 当字段的值发生改变的时候被调用(Field=nil表示对所有的字段)
    procedure   FieldValueChanged(Field : TWVField; AGroupIndex : Integer=0);
    // 当字段的有效性发生改变的时候被调用(Field=nil表示对所有的字段)
    procedure   FieldValidChanged(Field : TWVField; AGroupIndex : Integer=0);
    // 当字段的重要属性发生改变的时候被调用(Field=nil表示对所有的字段)
    procedure   FieldPropertyChanged(Field : TWVField);
    // 当重要属性(颜色)发生改变的时候被调用
    procedure   PropertyChanged;
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure   Loaded; override;
    procedure   InvalidInput(Field : TWVField; Target : TObject);
    procedure   FieldDestroy(Field : TWVField);
    procedure   FieldNameChanged(Field : TWVField);
    procedure   BroadcaseWVMessage(NotifyCode : Integer; Field : TWVField);
  public
    constructor Create(AOwner : TComponent); override;
    Destructor  Destroy;override;
    procedure   Clear;
    function    FieldByName(const FieldName:string): TWVField;
    function    FindField(const FieldName:string): TWVField;
    procedure   Reset(AGroupIndex : Integer=0);
    procedure   SynchronizeCtrlsToFields;
    procedure   CheckValid(AGroupIndex : Integer=0);
    procedure   LoadFromDataset(Dataset : TDataset; AGroupIndex : Integer=0);
    procedure   SaveToDataset(Dataset : TDataset; AGroupIndex : Integer=0);
    // 增加/删除监测字段变化的客户
    procedure   AddClient(Client : TObject);
    procedure   RemoveClient(Client : TObject);
    procedure   HandleException(Sender : TObject; E : Exception);
    procedure   DataChanged; // 增加TimeStamp，表明数据已经发生改变。
    function    GetInvalidFieldCaptions(const SeperateStr: string=','): string;
    property    Container : TWinControl read FContainer write SetContainer;
    property    TimeStamp : Integer read FTimeStamp;
    property    Fields[Index : Integer] : TWVField read GetFields;
    property    FieldCount : Integer read GetFieldCount;
  published
    property    WorkName : string read FWorkName write FWorkName;
    property    Description : string read FDescription write FDescription;
    property    Notes : string read FNotes write FNotes;
    property    WorkFields : TCollection read FWorkfields write SetWorkfields;
    property    WorkProcesses : TCollection read FWorkProcesses write SetWorkProcesses;
    property    FieldsMonitors : TCollection read FFieldsMonitors write SetFieldsMonitors;
    property    Users : string read FUsers write FUsers;
    property    Security : string read FSecurity write FSecurity;
    property    Entries : string read FEntries write FEntries;
    property    Exits : string read FExits write FExits;
    property    ValidColor : TColor read FValidColor write SetValidColor default clWhite;
    property    InvalidColor : TColor read FInvalidColor write SetInvalidColor default clInfoBK;
    property    ReadOnlyColor : TColor read FReadOnlyColor write SetReadOnlyColor default clNone;
    property    WorkViewCenter : TWorkViewCenter read GetWorkViewCenter write SetWorkViewCenter;
    property    OnException : TWVExceptionEvent read FOnException write FOnException;
    property    OnInvalidInput : TFieldEvent2 read FOnInvalidInput write FOnInvalidInput;
  end;

  TWorkFieldType = (wftUndefined,wftInput,wftOutput,wftInOut,wftInternal,wftSystem);
  TWFDataType = TKSDataType;
  //TOnGetStrValueEvent = procedure (WorkField : TWVField; var StrValue : string) of object;
  {
    <Class>TWVField
    <What>工作字段
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TWVField = class(TCollectionItem)
  private
    FNotes: string;
    FCaption: string;
    FDescription: string;
    FDomainName: string;
    FDomain : TWVFieldDomain;
    FDomainMagic : Integer;
    FName: string;
    FFieldType: TWorkFieldType;
    FVisible: boolean;
    FValid: Boolean;
    FConstrained: Boolean;
    FDefaultValue: Variant;
    FOnValidChanged: TFieldEvent;
    FCheckingValid : Boolean;
    FWorkView: TWorkView;
    FErrorMessage: string;
    FMagic: Integer;
    FData: TKSDataObject;
    FMonitorValueChangedFields: string;
    FMonitorValidChangedFields: string;
    FOnUpdateValue: TFieldEvent;
    FChecker: TWVFieldChecker;
    FGoNextWhenPressEnter: Boolean;
    FGetPrevChar: Char;
    FImeMode: TImeMode;
    FOwnObject: Boolean;
    FGroupIndex: Integer;
    FDataField: string;
    FOnValueChanged: TFieldEvent;
    FHint: string;
    FValidChanged : Boolean;
    FOnInvalidInput: TFieldEvent2;
    FLastMagic : Integer;
    FProcessingFieldChanged : Boolean;
    FFeatures: TStrings;
    FScript: string;
    procedure   SetCaption(const Value: string);
    procedure   SetName(const Value: string);
    procedure   SetValid(const Value: Boolean);
    function    GetDomain: TWVFieldDomain;
    procedure   SetDomainName(const Value: string);
    function    GetValid: Boolean;
    function    GetDataType: TWFDataType;
    procedure   SetDataType(const Value: TWFDataType);
    procedure   DataValueChanged(Sender : TObject);
    procedure   SetConstrained(const Value: Boolean);
    procedure   ValidChanged;
    procedure   SetChecker(const Value: TWVFieldChecker);
    function    GetOnKeyDown: TKeyEvent;
    function    GetOnKeyPress: TKeyPressEvent;
    function    GetOnKeyUp: TKeyEvent;
    procedure   SetOnKeyDown(const Value: TKeyEvent);
    procedure   SetOnKeyPress(const Value: TKeyPressEvent);
    procedure   SetOnKeyUp(const Value: TKeyEvent);
    function    GetOnCheckValid: TFieldEvent;
    procedure   SetOnCheckValid(const Value: TFieldEvent);
    procedure   SetMonitorValidChangedFields(const Value: string);
    procedure   SetMonitorValueChangedFields(const Value: string);
    procedure   SetImeMode(const Value: TImeMode);
    procedure   PropertyChanged;
    procedure   SetOwnObject(const Value: Boolean);
    procedure   UpdateOwnObject;
    procedure   SetCheckingValid(const Value: Boolean);
    procedure   CheckValidChanged;
    procedure   SetDomain(const Value: TWVFieldDomain);
    procedure   SetHint(const Value: string);
    procedure   SetFeatures(const Value: TStrings);
  protected
    function    GetDisplayName: string; override;
    // 当字段的值发生改变的时候被调用 (Field=nil表示对所有的字段)
    procedure   FieldValueChanged(Field : TWVField; AGroupIndex : Integer=0);
    // 当字段的有效性发生改变的时候被调用(Field=nil表示对所有的字段)
    procedure   FieldValidChanged(Field : TWVField; AGroupIndex : Integer=0);
    // 当字段的重要属性发生改变的时候被调用(Field=nil表示对所有的字段)
    procedure   FieldPropertyChanged(Field : TWVField);
    procedure   InvalidInput(Target : TObject);
    property    CheckingValid : Boolean read FCheckingValid write SetCheckingValid;
  public
    constructor Create(Collection: TCollection); override;
    destructor  Destroy;override;
    procedure   Assign(Source: TPersistent); override;
    procedure   CheckValid;
    procedure   Reset;
    procedure   KeyPress(Sender : TObject; var Key: Char);
    procedure   KeyDown(Sender : TObject; var Key: Word; Shift: TShiftState);
    procedure   KeyUp(Sender : TObject; var Key: Word; Shift: TShiftState);
    function    GetMaxLength : Integer;
    function    GetHint : string;
    procedure   SetInvalidMessage(const Msg : string);
    property    Valid : Boolean read GetValid write SetValid;
    property    Domain : TWVFieldDomain read GetDomain write SetDomain;
    property    WorkView : TWorkView read FWorkView;
    property    ErrorMessage : string read FErrorMessage write FErrorMessage;
    property    Magic : Integer read FMagic; // it's a timestamp for its value
    property    Data : TKSDataObject read FData;
  published
    property    Name : string read FName write SetName;
    property    Caption : string read FCaption write SetCaption;
    property    FieldType : TWorkFieldType read FFieldType write FFieldType;
    property    DomainName : string read FDomainName write SetDomainName;
    property    Features : TStrings read FFeatures write SetFeatures;
    property    Description : string read FDescription write FDescription;
    property    Hint : string read FHint write SetHint;
    property    Notes : string read FNotes write FNotes;
    property    Script : string read FScript write FScript;
    property    DataType : TWFDataType read GetDataType write SetDataType;
    property    OwnObject : Boolean read FOwnObject write SetOwnObject;
    // MonitorValueChangedFields, MonitorValidChangedFields 的格式：|字段名|字段名|
    property    MonitorValueChangedFields : string read FMonitorValueChangedFields write SetMonitorValueChangedFields;
    property    MonitorValidChangedFields : string read FMonitorValidChangedFields write SetMonitorValidChangedFields;
    property    Visible : boolean read FVisible write FVisible;
    property    Constrained : Boolean read FConstrained write SetConstrained default false;
    property    Checker : TWVFieldChecker read FChecker write SetChecker;
    property    DefaultValue : Variant read FDefaultValue write FDefaultValue;
    property    GoNextWhenPressEnter : Boolean read FGoNextWhenPressEnter write FGoNextWhenPressEnter default True;
    property    GetPrevChar : Char read FGetPrevChar write FGetPrevChar default #0;
    property    ImeMode : TImeMode read FImeMode write SetImeMode default imDontCare;
    property    GroupIndex : Integer read FGroupIndex write FGroupIndex default 0;
    property    DataField : string read FDataField write FDataField;

    property    OnUpdateValue : TFieldEvent read FOnUpdateValue write FOnUpdateValue;
    property    OnCheckValid : TFieldEvent read GetOnCheckValid write SetOnCheckValid;
    property    OnValidChanged : TFieldEvent read FOnValidChanged write FOnValidChanged;
    property    OnValueChanged : TFieldEvent read FOnValueChanged write FOnValueChanged;
    //property    OnGetStrValue : TOnGetStrValueEvent read FOnGetStrValue write FOnGetStrValue;
    property    OnKeyDown: TKeyEvent read GetOnKeyDown write SetOnKeyDown;
    property    OnKeyPress: TKeyPressEvent read GetOnKeyPress write SetOnKeyPress;
    property    OnKeyUp: TKeyEvent read GetOnKeyUp write SetOnKeyUp;
    property    OnInvalidInput : TFieldEvent2 read FOnInvalidInput write FOnInvalidInput;
  end;

  {
    <Class>TWorkViewCenter
    <What>代表统一的WorkView的各种公共属性，例如各种颜色配置，错误处理方式等等。
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TWorkViewCenter = class(TComponent)
  private
    FOnInvalidInput: TFieldEvent2;
    FOnException: TWVExceptionEvent;
    FInvalidColor: TColor;
    FReadOnlyColor: TColor;
    FValidColor: TColor;
    procedure   SetInvalidColor(const Value: TColor);
    procedure   SetReadOnlyColor(const Value: TColor);
    procedure   SetValidColor(const Value: TColor);
  protected
    procedure   Loaded; override;
    procedure   PropertyChanged;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
    procedure   InvalidInput(Field : TWVField; Target : TObject);
    procedure   HandleException(Sender : TObject; E : Exception);
  published
    property    ValidColor : TColor read FValidColor write SetValidColor default clWhite;
    property    InvalidColor : TColor read FInvalidColor write SetInvalidColor default clInfoBK;
    property    ReadOnlyColor : TColor read FReadOnlyColor write SetReadOnlyColor default clNone;
    property    OnException : TWVExceptionEvent read FOnException write FOnException;
    property    OnInvalidInput : TFieldEvent2 read FOnInvalidInput write FOnInvalidInput;
  end;

  TWVMapping = class(TCollectionItem)
  private
    FParam: string;
    FWorkFieldName: string;
    FDoProcess: TWVDoProcess;
    function    GetWorkField: TWVField;
  protected

  public
    constructor Create(Collection: TCollection);override;
    property    WorkField : TWVField read GetWorkField;
    property    DoProcess : TWVDoProcess read FDoProcess;
  published
    property    WorkFieldName : string read FWorkFieldName Write FWorkFieldName;
    property    Param : string read FParam write FParam;
  end;


  TWVDoProcess = class(TPersistent)
  private
    FName: string;
    FMappings: TCollection;
    FWorkProcess: TWVWorkProcess;
    procedure   SetMappings(const Value: TCollection);
  protected

  public
    constructor Create(aWorkProcess : TWVWorkProcess);
    Destructor  Destroy;override;
    procedure   Assign(Source: TPersistent); override;
    property    WorkProcess : TWVWorkProcess read FWorkProcess;
  published
    property    Name : string read FName write FName;
    property    Mappings : TCollection read FMappings write SetMappings;
  end;

  TWVWorkProcess = class(TCollectionItem)
  private
    FTriger: string;
    FNotes: string;
    FDescription: string;
    FProcFields: TCollection;
    FDoProcess: TWVDoProcess;
    FPreprocess: string;
    FPostprocess: string;
    FCaption: string;
    FWorkView: TWorkView;
    procedure   SetDoProcess(const Value: TWVDoProcess);
    procedure   SetProcFields(const Value: TCollection);
  protected

  public
    constructor Create(Collection: TCollection);override;
    Destructor  Destroy;override;
    property    WorkView : TWorkView read FWorkView;
  published
    property    Caption : string read FCaption write FCaption;
    property    Description : string read FDescription write FDescription;
    property    Notes : string read FNotes write FNotes;
    property    ProcFields : TCollection read FProcFields write SetProcFields;
    property    Triger : string read FTriger write FTriger;
    property    Preprocess : string read FPreprocess write FPreprocess;
    property    Postprocess : string read FPostprocess write FPostprocess;
    property    DoProcess : TWVDoProcess read FDoProcess write SetDoProcess;
  end;

  TWVProcField = class(TCollectionItem)
  private
    FWorkFieldName: string;
    FProcType: TWorkFieldType;
    FWorkProcess: TWVWorkProcess;
    function    GetWorkField: TWVField;
  protected

  public
    constructor Create(Collection: TCollection);override;
    property    WorkProcess : TWVWorkProcess Read FWorkProcess;
    property    WorkField : TWVField read GetWorkField;

  published
    property    WorkFieldName : string read FWorkFieldName Write FWorkFieldName;
    property    ProcType : TWorkFieldType read FProcType write FProcType;
  end;

  TWVFieldDomain = class(TComponent)
  private
    FDomainName: string;
    FChecker: TWVFieldChecker;
    FHint: string;
    procedure   SetDomainName(const Value: string);
    function    GetOnCheckValid: TFieldEvent;
    function    GetOnKeyDown: TKeyEvent;
    function    GetOnKeyPress: TKeyPressEvent;
    function    GetOnKeyUp: TKeyEvent;
    procedure   SetOnCheckValid(const Value: TFieldEvent);
    procedure   SetOnKeyDown(const Value: TKeyEvent);
    procedure   SetOnKeyPress(const Value: TKeyPressEvent);
    procedure   SetOnKeyUp(const Value: TKeyEvent);
    procedure   SetChecker(const Value: TWVFieldChecker);
  protected

  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
  published
    property    DomainName : string read FDomainName write SetDomainName;
    property    Checker : TWVFieldChecker read FChecker write SetChecker;
    property    Hint : string read FHint write FHint;
    property    OnCheckValid : TFieldEvent read GetOnCheckValid write SetOnCheckValid;
    property    OnKeyDown: TKeyEvent read GetOnKeyDown write SetOnKeyDown;
    property    OnKeyPress: TKeyPressEvent read GetOnKeyPress write SetOnKeyPress;
    property    OnKeyUp: TKeyEvent read GetOnKeyUp write SetOnKeyUp;
  end;

  TWVFieldDomainManager = class
  private
    FDomains : TList;
    FMagic: Integer;
    procedure   AddDomain(Domain : TWVFieldDomain);
    procedure   RemoveDomain(Domain : TWVFieldDomain);
    procedure   NotifyChanges(Domain : TWVFieldDomain);
    function    GetDomains(Index: Integer): TWVFieldDomain;
  public
    constructor Create;
    destructor  Destroy;override;
    function    FindDomain(const Name : string): TWVFieldDomain;
    function    Count : Integer;
    property    Domains[Index : Integer] : TWVFieldDomain read GetDomains;
    property    Magic : Integer read FMagic;
  end;

  {
    <Class>TWVFieldChecker
    <What>服务类，用于：校验字段的有效性，过滤键盘输入等等。TWVField和TWVFieldDomain使用该类，并且将该对象的事件Publish出来。
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
    <Usage>
      如何校验字段有效性(字段的Constrained=True的时候)：
      1、如果设置了 OnCheckValid，那么调用事件处理器；
      2、否则，
        1)首先设置Valid=DefaultValid
        2)如果字段的值为空(Field.Data.IsEmpty)，Valid=not Required
        3)否则
          a)对于字符串，检查长度是否合适(如果MaxLength>0)；
          b)对于数字，检查数值范围(如果Max-Min>0)
  }
  TWVFieldChecker = class(TPersistent)
  private
    FDefaultValid: Boolean;
    FAcceptDigital: Boolean;
    FRequired: Boolean;
    FUpperCase: Boolean;
    FAcceptOther: Boolean;
    FLowerCase: Boolean;
    FAcceptAlphabet: Boolean;
    FMax: Double;
    FMin: Double;
    FMaxLength: Integer;
    FMinLength: Integer;
    FOnCheckValid: TFieldEvent;
    FOnKeyUp: TKeyEvent;
    FOnKeyDown: TKeyEvent;
    FOnKeyPress: TKeyPressEvent;
    FAcceptHigh: Boolean;
  protected

  public
    constructor Create;
    procedure   Assign(Source: TPersistent); override;
    procedure   CheckValid(Field : TWVField);
    procedure   KeyPress(Sender : TObject; var Key: Char);
    procedure   KeyDown(Sender : TObject; var Key: Word; Shift: TShiftState);
    procedure   KeyUp(Sender : TObject; var Key: Word; Shift: TShiftState);
  published
    property    MinLength : Integer read FMinLength write FMinLength;
    property    MaxLength : Integer read FMaxLength write FMaxLength;
    property    Min : Double read FMin write FMin;
    property    Max : Double read FMax write FMax;
    property    DefaultValid : Boolean read FDefaultValid write FDefaultValid default True;
    property    AcceptDigital : Boolean read FAcceptDigital write FAcceptDigital default True;
    property    AcceptAlphabet : Boolean read FAcceptAlphabet write FAcceptAlphabet default True;
    property    AcceptOther : Boolean read FAcceptOther write FAcceptOther default True;
    property    AcceptHigh : Boolean read FAcceptHigh write FAcceptHigh default True;
    property    LowerCase : Boolean read FLowerCase write FLowerCase;
    property    UpperCase : Boolean read FUpperCase write FUpperCase;
    property    Required : Boolean read FRequired write FRequired default True;
    property    OnCheckValid : TFieldEvent read FOnCheckValid write FOnCheckValid;
    property    OnKeyDown: TKeyEvent read FOnKeyDown write FOnKeyDown;
    property    OnKeyPress: TKeyPressEvent read FOnKeyPress write FOnKeyPress;
    property    OnKeyUp: TKeyEvent read FOnKeyUp write FOnKeyUp;
  end;

  TWVFieldMonitor = class;
  TWVFieldMonitorEvent = procedure (Sender : TWVFieldMonitor; Valid : Boolean) of object;

  TWVFieldMonitor = class(TCollectionItem)
  private
    FDescription: string;
    FMonitorValueChangedFields: string;
    FMonitorValidChangedFields: string;
    FOnValueChanged: TWVFieldMonitorEvent;
    FOnValidChanged: TWVFieldMonitorEvent;
    FWorkView: TWorkView;
    FValid: Boolean;
    FGroupIndex: Integer;
    procedure   SetMonitorValidChangedFields(const Value: string);
    procedure   SetMonitorValueChangedFields(const Value: string);
    // 当字段的值发生改变的时候被调用 (Field=nil表示对所有的字段)
    procedure   FieldValueChanged(Field : TWVField; AGroupIndex : Integer=0);
    // 当字段的有效性发生改变的时候被调用(Field=nil表示对所有的字段)
    procedure   FieldValidChanged(Field : TWVField; AGroupIndex : Integer=0);
    function    GetValid(const Names : string) : Boolean;
  protected

  public
    constructor Create(Collection: TCollection); override;
    procedure   Assign(Source: TPersistent); override;
    property    WorkView : TWorkView read FWorkView;
    property    Valid : Boolean read FValid;
  published
    property    Description : string read FDescription write FDescription;
    property    MonitorValueChangedFields : string read FMonitorValueChangedFields write SetMonitorValueChangedFields;
    property    MonitorValidChangedFields : string read FMonitorValidChangedFields write SetMonitorValidChangedFields;
    property    GroupIndex : Integer read FGroupIndex write FGroupIndex default 0;
    property    OnValueChanged : TWVFieldMonitorEvent read FOnValueChanged write FOnValueChanged;
    property    OnValidChanged : TWVFieldMonitorEvent read FOnValidChanged write FOnValidChanged;
  end;

  TWVGetStringsProc = procedure (const StringsName : string; Items : TStrings; var Handled : Boolean) of object;

  {
    <Class>TWVStringsMan
    <What>负责获取TStrings的值。StringsName是唯一标志
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TWVStringsMan = class(TComponent)
  private
    FOnGetStrings: TWVGetStringsProc;
  protected
    procedure   GetStrings(const StringsName : string; Items : TStrings; var Handled : Boolean); virtual;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
  published
    property    OnGetStrings : TWVGetStringsProc read FOnGetStrings write FOnGetStrings;
  end;

  TWVDataFromCtrlToFieldEvent = procedure (Ctrl : TObject; Field : TWVField; const DataPresentType : TDataPresentType; const Param : string; var Handled : Boolean) of object;

  TWVDataFromFieldToCtrlEvent = procedure (Field : TWVField; Ctrl : TObject; const DataPresentType : TDataPresentType; const Param : string; var Handled : Boolean) of object;

  TWVSetFieldHanlderEvent = procedure (Field : TField; const DataPresentType : TDataPresentType; const Param : string; var Handled : Boolean) of object;

  TWVCustomFieldPresent = class(TComponent)
  private

  protected
    procedure   CtrlToField(Ctrl : TObject; Field : TWVField; const ADataPresentType : TDataPresentType;
                  const Param : string; var Handled : Boolean); virtual; abstract;
    procedure   FieldToCtrl(Field : TWVField; Ctrl : TObject; const ADataPresentType : TDataPresentType;
                  const Param : string; var Handled : Boolean); virtual; abstract;
    procedure   SetFieldEventHanlder(Field : TField; const ADataPresentType : TDataPresentType;
                  const Param : string; var Handled : Boolean); virtual; abstract;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
  end;

  {
    <Class>TWVFieldPresent
    <What>负责在控件和字段之间双向同步数据，即数据怎么在控件里面表达出来。
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TWVFieldPresent = class(TWVCustomFieldPresent)
  private
    FOnCtrlToField: TWVDataFromCtrlToFieldEvent;
    FOnFieldToCtrl: TWVDataFromFieldToCtrlEvent;
    FDataPresentType: TDataPresentType;
    FOnSetFieldHandler: TWVSetFieldHanlderEvent;
  protected
    procedure   CtrlToField(Ctrl : TObject; Field : TWVField; const ADataPresentType : TDataPresentType;
                  const Param : string; var Handled : Boolean); override;
    procedure   FieldToCtrl(Field : TWVField; Ctrl : TObject; const ADataPresentType : TDataPresentType;
                  const Param : string; var Handled : Boolean); override;
    procedure   SetFieldEventHanlder(Field : TField; const ADataPresentType : TDataPresentType;
                  const Param : string; var Handled : Boolean); override;
  published
    property    DataPresentType : TDataPresentType read FDataPresentType write FDataPresentType;
    property    OnCtrlToField : TWVDataFromCtrlToFieldEvent read FOnCtrlToField write FOnCtrlToField;
    property    OnFieldToCtrl : TWVDataFromFieldToCtrlEvent read FOnFieldToCtrl write FOnFieldToCtrl;
    property    OnSetFieldHandler : TWVSetFieldHanlderEvent read FOnSetFieldHandler write FOnSetFieldHandler;
  end;

  TWVDataSource = class(TComponent)
  private
    FGroupIndex: Integer;
    FDataSource: TDataSource;
    FWorkView: TWorkView;
    FResetBeforeLoad: Boolean;
    procedure   SetDataSource(const Value: TDataSource);
    procedure   SetWorkView(const Value: TWorkView);

  protected
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner : TComponent); override;
    procedure   WorkViewToDataSource;
    procedure   DataSourceToWorkView;
  published
    property    DataSource : TDataSource read FDataSource write SetDataSource;
    property    WorkView : TWorkView read FWorkView write SetWorkView;
    property    GroupIndex : Integer read FGroupIndex write FGroupIndex;
    property    ResetBeforeLoad : Boolean read FResetBeforeLoad write FResetBeforeLoad default True;
  end;


// utilities

function  WVGetStrings(const StringsName : string; Items : TStrings): Boolean;

function  WVCtrlToField(Ctrl : TObject; Field : TWVField; const DataPresentType : TDataPresentType; const Param : string):Boolean;

function  WVFieldToCtrl(Field : TWVField; Ctrl : TObject; const DataPresentType : TDataPresentType; const Param : string):Boolean;

function  WVSetFieldEventHanlder(Field : TField; const DataPresentType : TDataPresentType; const Param : string): Boolean;

procedure WVSynchronizeCtrlToField(Ctrl : TObject; Field : TWVField);

function  WVGetField(Ctrl : TObject) : TWVField;

function  WVGetWorkView(Ctrl : TObject) : TWorkView;

procedure RemoveClientForAll(Client : TObject);

var
  FieldDomainManager : TWVFieldDomainManager;

const
  WVGetStringsCategory = 'WVGetStrings';
  WVFieldPresentCategory = 'WVFieldPresentCategory';

resourcestring
  EInvalidLength = '长度不符';
  EInvalidChars  = '包含无效的字符';
  EInvalidRange  = '数值超过允许的范围';
  EInvalidDataType = '不是合法的%s';

implementation

uses Forms, SafeCode, KSStrUtils, LogFile
  {$ifdef VCL60_UP }
  ,Variants
  {$else}

  {$endif}
;

type
  TOwnedCollectionAccess = class(TOwnedCollection);
  TWinControlAccess = class(TWinControl);

var
  GetStringsCategory : TObjectCategory=nil;
  FieldPresentCategory : TObjectCategory=nil;
  GlobalWorkViewCenter : TWorkViewCenter=nil;
  GlobalWorkViewList : TList=nil;

// utilities

function WVGetStrings(const StringsName : string; Items : TStrings): Boolean;
var
  I : Integer;
begin
  Result := False;
  if (StringsName<>'') and (GetStringsCategory<>nil) then
    for I:=0 to GetStringsCategory.Count-1 do
    begin
      TWVStringsMan(GetStringsCategory[I]).GetStrings(StringsName,Items,Result);
      if Result then
        Break;
    end;
end;

function  WVCtrlToField(Ctrl : TObject; Field : TWVField; const DataPresentType : TDataPresentType; const Param : string):Boolean;
var
  I : Integer;
begin
  Result := False;
  if (DataPresentType<>'') and (FieldPresentCategory<>nil) then
    for I:=0 to FieldPresentCategory.Count-1 do
    begin
      TWVCustomFieldPresent(FieldPresentCategory[I]).CtrlToField(Ctrl,Field,DataPresentType,Param,Result);
      if Result then
        Break;
    end;
end;

function  WVFieldToCtrl(Field : TWVField; Ctrl : TObject; const DataPresentType : TDataPresentType; const Param : string):Boolean;
var
  I : Integer;
begin
  Result := False;
  if (DataPresentType<>'') and (FieldPresentCategory<>nil) then
    for I:=0 to FieldPresentCategory.Count-1 do
    begin
      TWVCustomFieldPresent(FieldPresentCategory[I]).FieldToCtrl(Field,Ctrl,DataPresentType,Param,Result);
      if Result then
        Break;
    end;
end;

function  WVSetFieldEventHanlder(Field : TField; const DataPresentType : TDataPresentType; const Param : string): Boolean;
var
  I : Integer;
begin
  Result := False;
  if (DataPresentType<>'') and (FieldPresentCategory<>nil) then
    for I:=0 to FieldPresentCategory.Count-1 do
    begin
      TWVCustomFieldPresent(FieldPresentCategory[I]).SetFieldEventHanlder(Field,DataPresentType,Param,Result);
      if Result then
        Break;
    end;
end;

procedure WVSynchronizeCtrlToField(Ctrl : TObject; Field : TWVField);
var
  Msg : TWVMessage;
begin
  if (Field<>nil) and (Ctrl<>nil) then
  begin
    Msg.Msg := LM_WorkViewNotify;
    Msg.NotifyCode:= WV_SynchronizeCtrlToField;
    Msg.Field := Field;
    Msg.WorkView := Field.WorkView;
    Ctrl.Dispatch(Msg);
  end;
end;

function  WVGetField(Ctrl : TObject) : TWVField;
var
  Msg : TWVMessage;
begin
  if (Ctrl<>nil) then
  begin
    Msg.Msg := LM_WorkViewNotify;
    Msg.NotifyCode:= WV_GetField;
    Msg.Field := nil;
    Msg.WorkView := nil;
    Ctrl.Dispatch(Msg);
    Result := Msg.Field;
  end else
    Result := nil;
end;

function  WVGetWorkView(Ctrl : TObject) : TWorkView;
var
  Msg : TWVMessage;
begin
  if (Ctrl<>nil) then
  begin
    Msg.Msg := LM_WorkViewNotify;
    Msg.NotifyCode:= WV_GetWorkView;
    Msg.Field := nil;
    Msg.WorkView := nil;
    Ctrl.Dispatch(Msg);
    Result := Msg.WorkView;
  end else
    Result := nil;
end;

procedure AddWorkView(WorkView : TWorkView);
begin
  if GlobalWorkViewList=nil then
    GlobalWorkViewList := TList.Create;
  GlobalWorkViewList.Add(WorkView);
end;

procedure RemoveWorkView(WorkView : TWorkView);
begin
  if GlobalWorkViewList<>nil then
  begin
    GlobalWorkViewList.Remove(WorkView);
  end;
end;

procedure RemoveClientForAll(Client : TObject);
var
  I : Integer;
begin
  if GlobalWorkViewList<>nil then
  begin
    for I:=0 to GlobalWorkViewList.Count-1 do
    begin
      TWorkView(GlobalWorkViewList[I]).RemoveClient(Client);
    end;
  end;
end;

{ TWorkView }

constructor TWorkView.Create(AOwner : TComponent);
begin
  inherited;
  AddWorkView(Self);
  FWorkfields := TOwnedCollection.Create(self,TWVField);
  FWorkProcesses:= TOwnedCollection.Create(self,TWVWorkProcess);
  FFieldsMonitors := TOwnedCollection.Create(self,TWVFieldMonitor);
  FClients := TList.Create;
  FValidColor := clWhite;
  FInvalidColor := clInfoBK;
  FReadOnlyColor := clNone;
  FTimeStamp := 0;
  if AOwner is TWinControl then
    Container := TWinControl(AOwner);
end;

destructor TWorkView.Destroy;
begin
  RemoveWorkView(Self);
  FWorkProcesses.free;
  FWorkfields.free;
  inherited;
  FreeAndNil(FClients);
end;

procedure TWorkView.Clear;
begin
  FWorkName:='';
  FDescription:='';
  FNotes:='';
  FWorkfields.Clear;
  FWorkProcesses.Clear;
end;

procedure TWorkView.SetWorkfields(const Value: TCollection);
begin
  FWorkfields.Assign(Value);
end;

procedure TWorkView.SetWorkProcesses(const Value: TCollection);
begin
  FWorkProcesses.Assign(Value);
end;

function TWorkView.FieldByName(const FieldName: string): TWVField;
begin
  Result := FindField(FieldName);
  CheckObject(Result,'Error : No WorkView Field '+FieldName);
end;

procedure TWorkView.Reset(AGroupIndex : Integer=0);
var
  i : integer;
begin
  try
    FReseting := True;
    for i:=0 to FWorkfields.Count-1 do
      if (AGroupIndex=0) or (AGroupIndex=TWVField(FWorkFields.Items[i]).GroupIndex) then
        TWVField(FWorkFields.Items[i]).Reset;
  finally
    FReseting := False;
  end;
  FieldValueChanged(nil,AGroupIndex);
  FieldValidChanged(nil,AGroupIndex);
  Inc(FTimeStamp);
end;

procedure TWorkView.FieldValidChanged(Field: TWVField; AGroupIndex : Integer=0);
var
  I : Integer;
  //Msg : TWVMessage;
begin
  if ([csLoading, csDestroying] * ComponentState)<>[] then
    Exit;
  for I:=0 to WorkFields.Count-1 do
  begin
    TWVField(WorkFields.Items[I]).FieldValidChanged(Field,AGroupIndex);
  end;
  for I:=0 to FieldsMonitors.Count-1 do
  begin
    TWVFieldMonitor(FieldsMonitors.Items[I]).FieldValidChanged(Field,AGroupIndex);
  end;
  {
  Msg.Msg := LM_WorkViewNotify;
  Msg.NotifyCode:= WV_FieldValidChanged;
  Msg.Field := Field;
  Msg.WorkView := Self;
  for I:=0 to FClients.Count-1 do
  begin
    TObject(FClients[I]).Dispatch(Msg);
  end;
  }
  BroadcaseWVMessage(WV_FieldValidChanged,Field);
end;

procedure TWorkView.FieldValueChanged(Field: TWVField; AGroupIndex : Integer=0);
var
  I : Integer;
  //Msg : TWVMessage;
begin
  // 当csLoading或者csDestroying的时候不处理
  if FReseting or (([csLoading, csDestroying] * ComponentState)<>[]) then
    Exit;
  // 调用每个字段的FieldValueChanged
  for I:=0 to WorkFields.Count-1 do
  begin
    TWVField(WorkFields.Items[I]).FieldValueChanged(Field,AGroupIndex);
  end;
  // 调用每个监视器的FieldValueChanged
  for I:=0 to FieldsMonitors.Count-1 do
  begin
    TWVFieldMonitor(FieldsMonitors.Items[I]).FieldValueChanged(Field,AGroupIndex);
  end;
  {
  // 向侦听的客户（Clients）发送消息
  Msg.Msg := LM_WorkViewNotify;
  Msg.NotifyCode:= WV_FieldValueChanged;
  Msg.Field := Field;
  Msg.WorkView := Self;
  for I:=0 to FClients.Count-1 do
  begin
    TObject(FClients[I]).Dispatch(Msg);
  end;
  }
  BroadcaseWVMessage(WV_FieldValueChanged,Field);
  // 改变时间戳
  Inc(FTimeStamp);
end;

procedure TWorkView.AddClient(Client: TObject);
begin
  FClients.Add(Client);
  if Client is TComponent then
    TComponent(Client).FreeNotification(Self);
end;

procedure TWorkView.RemoveClient(Client: TObject);
begin
  if FClients<>nil then
    FClients.Remove(Client);
end;

procedure TWorkView.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if Operation=opRemove then
  begin
    RemoveClient(AComponent);
    if AComponent=FContainer then
      FContainer:=nil;
    if AComponent=FWorkViewCenter then
      WorkViewCenter:=nil;
  end;
end;

procedure TWorkView.Loaded;
begin
  inherited;
  if not (csDesigning in ComponentState) then
    Reset;
end;

procedure TWorkView.HandleException(Sender : TObject; E: Exception);
var
  Field : TWVField;
begin
  if E is EDataTypeError then
  begin
    Field := WVGetField(Sender);
    if Field<>nil then
    begin
      Field.ErrorMessage := Format(EInvalidDataType,[KSDataTypeNames[Field.DataType]]);
    end;
  end;
  if Assigned(FOnException) and not (csDesigning in ComponentState) then
    FOnException(Sender, E)
  else if GlobalWorkViewCenter<>nil then
    GlobalWorkViewCenter.HandleException(Sender,E)
  else
    Application.HandleException(E);
end;

procedure TWorkView.SetFieldsMonitors(const Value: TCollection);
begin
  FFieldsMonitors.Assign(Value);
end;

procedure TWorkView.SetContainer(const Value: TWinControl);
begin
  if FContainer <> Value then
  begin
    FContainer := Value;
    if FContainer<>nil then
      FContainer.FreeNotification(Self);
  end;
end;

procedure TWorkView.FieldPropertyChanged(Field: TWVField);
var
  I : Integer;
  //Msg : TWVMessage;
begin
  if ([csLoading, csDestroying] * ComponentState)<>[] then
    Exit;
  for I:=0 to WorkFields.Count-1 do
    TWVField(WorkFields.Items[I]).FieldPropertyChanged(Field);
  {
  Msg.Msg := LM_WorkViewNotify;
  Msg.Field := Field;
  Msg.NotifyCode:= WV_FieldPropertyChanged;
  Msg.WorkView := Self;
  for I:=0 to FClients.Count-1 do
    TObject(FClients[I]).Dispatch(Msg);
  }
  BroadcaseWVMessage(WV_FieldPropertyChanged,Field);
end;

procedure TWorkView.SynchronizeCtrlsToFields;
{var
  I : Integer;
  Msg : TWVMessage;}
begin
  {
  Msg.Msg := LM_WorkViewNotify;
  Msg.Field := nil;
  Msg.NotifyCode:= WV_SynchronizeCtrlToField;
  Msg.WorkView := Self;
  for I:=0 to FClients.Count-1 do
  begin
    TObject(FClients[I]).Dispatch(Msg);
  end;
  }
  BroadcaseWVMessage(WV_SynchronizeCtrlToField,nil);
end;

function TWorkView.GetFieldCount: Integer;
begin
  Result := WorkFields.Count;
end;

function TWorkView.GetFields(Index: Integer): TWVField;
begin
  Result := TWVField(WorkFields.Items[Index]);
end;

procedure TWorkView.SetInvalidColor(const Value: TColor);
begin
  if FInvalidColor <> Value then
  begin
    FInvalidColor := Value;
    PropertyChanged;
  end;
end;

procedure TWorkView.SetReadOnlyColor(const Value: TColor);
begin
  if FReadOnlyColor <> Value then
  begin
    FReadOnlyColor := Value;
    PropertyChanged;
  end;
end;

procedure TWorkView.SetValidColor(const Value: TColor);
begin
  if FValidColor<> Value then
  begin
    FValidColor := Value;
    PropertyChanged;
  end;
end;

procedure TWorkView.PropertyChanged;
{var
  I : Integer;
  Msg : TWVMessage;}
begin
  if ([csLoading, csDestroying] * ComponentState)<>[] then
    Exit;
  {
  Msg.Msg := LM_WorkViewNotify;
  Msg.Field := nil;
  Msg.NotifyCode:= WV_PropertyChanged;
  Msg.WorkView := Self;
  for I:=0 to FClients.Count-1 do
    TObject(FClients[I]).Dispatch(Msg);
  }
  BroadcaseWVMessage(WV_PropertyChanged,nil);
end;

procedure TWorkView.LoadFromDataset(Dataset: TDataset;
  AGroupIndex: Integer);
var
  I : Integer;
  Field : TWVField;
  DBField : TField;
begin
  for I:=0 to FieldCount-1 do
  begin
    Field := Fields[I];
    if ((AGroupIndex=0) or (AGroupIndex=Field.GroupIndex)) and (Field.DataField<>'') then
    begin
      DBField := Dataset.FindField(Field.DataField);
      if DBField<>nil then
        Field.Data.Value := DBField.Value;
    end;
  end;
end;

procedure TWorkView.SaveToDataset(Dataset: TDataset; AGroupIndex: Integer);
var
  I : Integer;
  Field : TWVField;
  DBField : TField;
begin
  for I:=0 to FieldCount-1 do
  begin
    Field := Fields[I];
    if ((AGroupIndex=0) or (AGroupIndex=Field.GroupIndex)) and (Field.DataField<>'') then
    begin
      DBField := Dataset.FindField(Field.DataField);
      if DBField<>nil then
        DBField.Value := Field.Data.Value;
    end;
  end;
end;

function TWorkView.FindField(const FieldName: string): TWVField;
var
  i : integer;
begin
  if FieldName<>'' then
    for i:=0 to WorkFields.count-1 do
    begin
      Result := TWVField(WorkFields.items[i]);
      if SameText(Result.Name,FieldName) then
        exit;
    end;
  Result := nil;
end;

procedure TWorkView.InvalidInput(Field: TWVField; Target : TObject);
begin
  if Assigned(OnInvalidInput) and not (csDesigning in ComponentState) then
    OnInvalidInput(Field, Target)
  else if GlobalWorkViewCenter<>nil then
    GlobalWorkViewCenter.InvalidInput(Field,Target)
  else
    Beep;
end;

procedure TWorkView.CheckValid(AGroupIndex: Integer);
var
  i : integer;
begin
  for i:=0 to FWorkfields.Count-1 do
    if (AGroupIndex=0) or (AGroupIndex=TWVField(FWorkFields.Items[i]).GroupIndex) then
      TWVField(FWorkFields.Items[i]).CheckValid;
end;

procedure TWorkView.DataChanged;
begin
  Inc(FTimeStamp);
end;

function  TWorkView.GetInvalidFieldCaptions(const SeperateStr : string=','): string;
var
  I : Integer;
  Field : TWVField;
begin
  Result := '';
  for I:=0 to FieldCount-1 do
  begin
    Field := Fields[I];
    if not Field.Valid then
    begin
      if Result<>'' then
        Result := Result+SeperateStr;
      Result := Result + Field.Caption;
    end;
  end;
end;

procedure TWorkView.SetWorkViewCenter(const Value: TWorkViewCenter);
begin
  if FWorkViewCenter <> Value then
  begin
    FWorkViewCenter := Value;
    if FWorkViewCenter<>nil then
    begin
      FWorkViewCenter.FreeNotification(Self);
      UpdateWorkViewCenter;
    end;
  end;
end;

procedure TWorkView.UpdateWorkViewCenter;
begin
  if WorkViewCenter<>nil then
  begin
    with WorkViewCenter do
    begin
      Self.FInvalidColor := InvalidColor;
      Self.FValidColor := ValidColor;
      Self.FReadOnlyColor := ReadOnlyColor;
    end;
    PropertyChanged;
  end;
end;

function TWorkView.GetWorkViewCenter: TWorkViewCenter;
begin
  Result := FWorkViewCenter;
  if not (csDesigning in ComponentState) and (FWorkViewCenter=nil) then
    Result := GlobalWorkViewCenter;
end;

procedure TWorkView.FieldDestroy(Field: TWVField);
begin
  BroadcaseWVMessage(WV_FieldDestroy,Field);
end;

procedure TWorkView.BroadcaseWVMessage(NotifyCode: Integer;
  Field: TWVField);
var
  I : Integer;
  Msg : TWVMessage;
begin
  Msg.Msg := LM_WorkViewNotify;
  Msg.NotifyCode:= NotifyCode;
  Msg.Field := Field;
  Msg.WorkView := Self;
  for I:=0 to FClients.Count-1 do
  begin
    TObject(FClients[I]).Dispatch(Msg);
  end;
end;

procedure TWorkView.FieldNameChanged(Field: TWVField);
begin
  BroadcaseWVMessage(WV_FieldNameChanged,Field);
end;

{ TWVDoProcess }

constructor TWVDoProcess.Create(aWorkProcess : TWVWorkProcess);
begin
  inherited Create;
  FWorkProcess:=aWorkProcess;
  //FMappings:=TOwnedCollection.Create(self,TWVMapping);
  FMappings:=TOwnedCollection.Create(FWorkProcess,TWVMapping);
end;

destructor TWVDoProcess.Destroy;
begin
  FMappings.free;
  inherited;
end;

procedure TWVDoProcess.Assign(Source: TPersistent);
begin
  if Source is TWVDoProcess then
    with TWVDoProcess(Source) do
    begin
      Self.FName := Name;
      Self.FMappings.Assign(Mappings);
    end
  else
    inherited;
end;

procedure TWVDoProcess.SetMappings(const Value: TCollection);
begin
  FMappings.Assign(Value);
end;

{ TWVWorkProcess }

constructor TWVWorkProcess.Create(Collection: TCollection);
begin
  inherited;
  FWorkView := TWorkView(TOwnedCollectionAccess(Collection).GetOwner);
  FProcFields := TOwnedCollection.Create(self,TWVProcField);
  FDoProcess := TWVDoProcess.Create(self);
end;

destructor TWVWorkProcess.Destroy;
begin
  FDoProcess.free;
  FProcFields.free;
  inherited;
end;

procedure TWVWorkProcess.SetDoProcess(const Value: TWVDoProcess);
begin
  FDoProcess.Assign(Value);
end;

procedure TWVWorkProcess.SetProcFields(const Value: TCollection);
begin
  FProcFields.Assign(Value);
end;

{ TWVMapping }

constructor TWVMapping.Create(Collection: TCollection);
begin
  inherited;
  FDoProcess := TWVDoProcess(TOwnedCollectionAccess(Collection).GetOwner);
end;

function TWVMapping.GetWorkField: TWVField;
begin
  Result := FDoProcess.WorkProcess.WorkView.FindField(FWorkFieldName);
end;
{ TWVProcField }

constructor TWVProcField.Create(Collection: TCollection);
begin
  inherited;
  FWorkProcess := TWVWorkProcess(TOwnedCollectionAccess(Collection).GetOwner);
end;

function TWVProcField.GetWorkField: TWVField;
begin
  Result := FWorkProcess.WorkView.FindField(FWorkFieldName);
end;

{ TWVField }

constructor TWVField.Create(Collection: TCollection);
begin
  inherited;
  FWorkView := TWorkView(TOwnedCollectionAccess(Collection).GetOwner);
  Assert(FWorkView is TWorkView);
  FData := TKSDataObject.Create;
  FData.OnChanged := DataValueChanged;
  FDefaultValue := '';
  FConstrained := false;
  FDomainName := '';
  FDomain := nil;
  FDomainMagic := 0;
  FDefaultValue := Unassigned;
  FChecker := TWVFieldChecker.Create;
  FGoNextWhenPressEnter := True;
  FGetPrevChar := #0;
  FImeMode := imDontCare;
  FCheckingValid := false;
  FMagic := 0;
  FLastMagic := FMagic;
  FValidChanged := False;
  FGroupIndex := 0;
  FFeatures := TStringList.Create;
end;

destructor TWVField.Destroy;
begin
  WorkView.FieldDestroy(Self);
  FData.OnChanged := nil;
  inherited;
  FreeAndNil(FFeatures);
  FreeAndNil(FData);
  FreeAndNil(FChecker);
end;

procedure TWVField.CheckValid;
begin
  if Constrained and not CheckingValid then
  begin
    try
      CheckingValid := True;
      ErrorMessage := '';
      if Domain<>nil then
      begin
        // 先用域检查
        Domain.Checker.CheckValid(Self);
        // 然后用事件检查
        if Assigned(Checker.FOnCheckValid) and not (csDesigning in WorkView.ComponentState) then
          Checker.FOnCheckValid(Self);
      end else
        Checker.CheckValid(Self);
    finally
      CheckingValid := false;
    end;
  end;
end;

procedure TWVField.FieldValidChanged(Field: TWVField; AGroupIndex : Integer=0);
var
  Part : string;
begin
  if (Field<>nil) then
  begin
    Part := UpperCase(SeperateFieldChar+Field.Name+SeperateFieldChar);
    if Pos(Part,MonitorValidChangedFields)>0 then
      CheckValid;
  end;
end;

procedure TWVField.FieldValueChanged(Field: TWVField; AGroupIndex : Integer=0);
var
  Part : string;
  IsMonitoredField : Boolean;
  SelfChanged : Boolean;
  NeedReCheck : Boolean;
begin
  (*
  // 当字段为nil并且AGroupIndex符合；或者字段是本身，触发CheckValid
  if ( (Field=nil) and ( (AGroupIndex=Self.GroupIndex) or (AGroupIndex=0) ) )
    or (Field = Self) then
    CheckValid;
  if Field=Self then
  begin
    // 当字段是本身的时候触发OnValueChanged事件
    if Assigned(FOnValueChanged) then
      FOnValueChanged(Self);
  end
  else if (Field<>nil) then
  begin
    // 否则，字段非空，并且名称在MonitorValueChangedFields里面，
    Part := UpperCase(SeperateFieldChar+Field.Name+SeperateFieldChar);
    if (Pos(Part,MonitorValueChangedFields)>0) then
      if Assigned(FOnUpdateValue) then
      // 如果存在OnUpdateValue，那么调用OnUpdateValue，可以根据发生改变的字段对该字段的值进行修改
        FOnUpdateValue(Self)
      else
      // 否则调用CheckValid
        CheckValid;
  end;
  *)

  {
  if Field<>nil then
    WriteLog(Format('%s[%d].FieldValueChanged(%s,%d)',
      [Name,GroupIndex,Field.Name,AGroupIndex]),lcDebug)
  else
    WriteLog(Format('%s[%d].FieldValueChanged(nil,%d)',
      [Name,GroupIndex,AGroupIndex]),lcDebug);
  }
  NeedReCheck := False;

  // 判断字段本身发生是否改变：当字段是自己或者nil，并且FLastMagic<>FMagic
  SelfChanged := ((Field=Self) or (Field=nil)) and (FLastMagic<>FMagic);

  // 判断是否是监控的字段发生改变
  IsMonitoredField := False;
  if Field<>Self then
  begin
    if (Field<>nil) then
    begin
      // 字段非空，并且名称在MonitorValueChangedFields里面，
      Part := UpperCase(SeperateFieldChar+Field.Name+SeperateFieldChar);
      IsMonitoredField := Pos(Part,MonitorValueChangedFields)>0;
    end else
      // 字段为空，检查AGroupIndex和MonitorValueChangedFields
      IsMonitoredField := (MonitorValueChangedFields<>'') and
        ((AGroupIndex=Self.GroupIndex) or (AGroupIndex=0));
  end;

  // 如果是监控的字段发生改变，触发OnUpdateValue，可以改变字段的值
  if IsMonitoredField and Assigned(FOnUpdateValue) and not (csDesigning in WorkView.ComponentState) then
  begin
    // 利用FProcessingFieldChanged标志，如果在OnUpdateValue里面修改字段的值，不再触发事件，优化处理
    FProcessingFieldChanged := True;
    try
      NeedReCheck := True;
      FOnUpdateValue(Self);
    finally
      FProcessingFieldChanged := False;
    end;
  end;

  // 当字段本身或者监控的字段发生了改变，调用CheckValid，可以改变字段的值，例如补齐
  if SelfChanged or IsMonitoredField then
  begin
    // 利用FProcessingFieldChanged标志，如果在CheckValid里面修改字段的值，不再触发事件，优化处理
    FProcessingFieldChanged := True;
    try
      NeedReCheck := True;
      CheckValid;
    finally
      FProcessingFieldChanged := False;
    end;
  end;

  // 重新判断字段本身发生是否改变：当字段是自己或者nil，并且FLastMagic<>FMagic
  // NeedReCheck满足的条件是：IsMonitoredField或者SelfChanged
  // 重新计算的时候不再判断字段，因为使用FProcessingFieldChanged屏蔽了处理事件的再次触发，
  // 所以这里应该根据FLastMagic进行精确的判断
  if NeedReCheck then
    SelfChanged := (FLastMagic<>FMagic);

  // 如果字段本身发生改变，触发OnValueChanged时间
  if SelfChanged then
  begin
    FLastMagic := FMagic;
    if Assigned(FOnValueChanged) and not (csDesigning in WorkView.ComponentState) then
      FOnValueChanged(Self);
  end;
end;

function TWVField.GetDataType: TWFDataType;
begin
  Result := FData.DataType;
end;

function TWVField.GetDisplayName: string;
begin
  Result := Name;
end;

function TWVField.GetDomain: TWVFieldDomain;
begin
  if FDomainMagic<>FieldDomainManager.Magic then
  begin
    Domain := FieldDomainManager.FindDomain(FDomainName);
    FDomainMagic := FieldDomainManager.Magic;
  end;
  Result := FDomain;
end;

function TWVField.GetValid: Boolean;
begin
  Result := not Constrained or FValid;
end;

procedure TWVField.Reset;
begin
  try
    if not VarIsEmpty(DefaultValue) then
      Data.Value := DefaultValue else
      Data.Clear;
  except
    DefaultValue := Unassigned;
    Data.Clear;
  end;
  CheckValid;
end;

procedure TWVField.SetCaption(const Value: string);
begin
  FCaption := Value;
  if (FCaption<>'') and (FName='') then
    FName := FCaption;
end;

procedure TWVField.SetDataType(const Value: TWFDataType);
begin
  FData.DataType := Value;
  UpdateOwnObject;
end;

procedure TWVField.SetDomainName(const Value: string);
begin
  if FDomainName <> Value then
  begin
    FDomainName := Value;
    {
    if not (csLoading in ComponentState) then
      FDomain := FieldDomainManager.FindDomain(FDomainName);
    }
    FDomainMagic := FieldDomainManager.Magic-1;
    CheckValid;
  end;
end;

procedure TWVField.SetName(const Value: string);
begin
  if FName <> Value then
  begin
    FName := Value;
    WorkView.FieldNameChanged(Self);
  end;
end;

procedure TWVField.SetValid(const Value: Boolean);
begin
  if Valid <> Value then
  begin
    FValid := Value;
    ValidChanged;
  end;
end;

procedure TWVField.DataValueChanged(Sender: TObject);
begin
  Inc(FMagic);
  //WriteLog(Name+'.DataValueChanged',lcDebug);
  if not FProcessingFieldChanged then
    WorkView.FieldValueChanged(Self);
end;

procedure TWVField.SetConstrained(const Value: Boolean);
var
  OldValid : Boolean;
begin
  if Value<>FConstrained then
  begin
    OldValid := Valid;
    FConstrained := Value;
    if Valid<>OldValid then
      ValidChanged;
  end;
end;

procedure TWVField.ValidChanged;
begin
  FValidChanged := True;
  CheckValidChanged;
end;

procedure TWVField.KeyDown(Sender : TObject; var Key: Word; Shift: TShiftState);
begin
  {
  if Assigned(FOnKeyDown) then
    FOnKeyDown(Self,Key,Shift)
  else if Domain<>nil then
    Domain.KeyDown(Key,Shift);
  }
  if Domain<>nil then
    Domain.Checker.KeyDown(Sender,Key,Shift);
  Checker.KeyDown(Sender,Key,Shift);
  {if (Key=13) and GoNextWhenPressEnter and (WorkView.Container<>nil) and (Sender is TWinControl) then
  begin
    Key := 0;
    // WHEN keyup go next
    //TWinControlAccess(WorkView.Container).SelectNext(TWinControl(Sender),True,True);
  end;}
end;

procedure TWVField.KeyPress(Sender : TObject; var Key: Char);
begin
  {
  if Assigned(FOnKeyPress) then
    FOnKeyPress(Self,Key)
  else if Domain<>nil then
    Domain.KeyPress(Key);
  }
  if (GetPrevChar<>#0) and (Key=GetPrevChar) and (WorkView.Container<>nil) and (Sender is TWinControl) then
  begin
    Key := #0;
    TWinControlAccess(WorkView.Container).SelectNext(TWinControl(Sender),False,True);
  end;
  if (Key=#13) and GoNextWhenPressEnter and (WorkView.Container<>nil) and (Sender is TWinControl) then
  begin
    // 先同步数据
    WVSynchronizeCtrlToField(Sender,Self);
    if Valid then
    begin
      // 数据有效自动切换到下一个输入焦点
      Key := #0;
      TWinControlAccess(WorkView.Container).SelectNext(TWinControl(Sender),True,True);
    end else
    begin
      InvalidInput(Sender);
    end;
  end;
  if Domain<>nil then
    Domain.Checker.KeyPress(Sender,Key);
  Checker.KeyPress(Sender,Key);
end;

procedure TWVField.KeyUp(Sender : TObject; var Key: Word; Shift: TShiftState);
begin
  {
  if Assigned(FOnKeyUp) then
    FOnKeyUp(Self,Key,Shift)
  else if Domain<>nil then
    Domain.KeyUp(Key,Shift);
  }
  if Domain<>nil then
    Domain.Checker.KeyUp(Sender,Key,Shift);
  Checker.KeyUp(Sender,Key,Shift);
end;

procedure TWVField.SetChecker(const Value: TWVFieldChecker);
begin
  FChecker.Assign(Value);
end;

function TWVField.GetOnKeyDown: TKeyEvent;
begin
  Result := Checker.OnKeyDown;
end;

function TWVField.GetOnKeyPress: TKeyPressEvent;
begin
  Result := Checker.OnKeyPress;
end;

function TWVField.GetOnKeyUp: TKeyEvent;
begin
  Result := Checker.OnKeyUp;
end;

function TWVField.GetOnCheckValid: TFieldEvent;
begin
  Result := Checker.OnCheckValid;
end;

procedure TWVField.SetOnCheckValid(const Value: TFieldEvent);
begin
  Checker.OnCheckValid := Value;
end;

procedure TWVField.SetOnKeyDown(const Value: TKeyEvent);
begin
  Checker.OnKeyDown := Value;
end;

procedure TWVField.SetOnKeyPress(const Value: TKeyPressEvent);
begin
  Checker.OnKeyPress := Value;
end;

procedure TWVField.SetOnKeyUp(const Value: TKeyEvent);
begin
  Checker.OnKeyUp := Value;
end;

procedure TWVField.SetMonitorValidChangedFields(const Value: string);
begin
  FMonitorValidChangedFields := UpperCase(Value);
end;

procedure TWVField.SetMonitorValueChangedFields(const Value: string);
begin
  FMonitorValueChangedFields := UpperCase(Value);
end;

procedure TWVField.SetImeMode(const Value: TImeMode);
begin
  if FImeMode <> Value then
  begin
    FImeMode := Value;
    PropertyChanged;
  end;
end;

procedure TWVField.PropertyChanged;
begin
  WorkView.FieldPropertyChanged(Self);
end;

procedure TWVField.FieldPropertyChanged(Field: TWVField);
begin

end;

procedure TWVField.SetOwnObject(const Value: Boolean);
begin
  if FOwnObject <> Value then
  begin
    FOwnObject := Value;
    UpdateOwnObject;
  end;
end;

procedure TWVField.UpdateOwnObject;
begin
  if Data.DataType=kdtObject then
    Data.OwnObject := FOwnObject;
end;

function TWVField.GetMaxLength: Integer;
begin
  if DataType in [kdtString,kdtWideString] then
  begin
    if Domain<>nil then
      Result := Domain.Checker.MaxLength else
      Result := 0;
    if (Checker.MaxLength>0) and ((Checker.MaxLength<Result) or (Result=0)) then
      Result := Checker.MaxLength;
  end
  else if DataType in [kdtChar,kdtWideChar] then
    Result := 1
  else if DataType in [kdtInteger,kdtInt64,kdtFloat, kdtCurrency] then
  begin
    if Domain<>nil then
      Result := Domain.Checker.MaxLength else
      Result := Checker.MaxLength;
    if (Result=0) or (Result>MaxNumberCharLength) then
      Result := MaxNumberCharLength;
  end
  else Result := 0;
end;

function TWVField.GetHint: string;
begin
  {
  if Domain<>nil then
    Result := Domain.Hint else
    Result := Hint;
  }
  if Hint<>'' then
    Result := Hint
  else if Domain<>nil then
    Result := Domain.Hint
  else
    Result := '';
end;

procedure TWVField.SetCheckingValid(const Value: Boolean);
begin
  if CheckingValid <> Value then
  begin
    FCheckingValid := Value;
    if not CheckingValid then
      CheckValidChanged;
  end;
end;

procedure TWVField.CheckValidChanged;
begin
  if FValidChanged and not CheckingValid then
  begin
    FValidChanged := False;
    if Assigned(FOnValidChanged) and not (csDesigning in WorkView.ComponentState) then
      FOnValidChanged(Self);
    if Valid then
      FErrorMessage := '';
    WorkView.FieldValidChanged(Self);
  end;
end;

procedure TWVField.InvalidInput(Target : TObject);
begin
  if Assigned(OnInvalidInput) and not (csDesigning in WorkView.ComponentState) then
    OnInvalidInput(Self, Target);
  WorkView.InvalidInput(Self, Target);
end;

procedure TWVField.SetDomain(const Value: TWVFieldDomain);
begin
  if Value<>FDomain then
  begin
    FDomain := Value;
    if FDomain<>nil then
      FDomainName := FDomain.DomainName;
    PropertyChanged;  
  end;
end;

procedure TWVField.SetHint(const Value: string);
begin
  if FHint <> Value then
  begin
    FHint := Value;
    PropertyChanged;
  end;
end;

procedure TWVField.Assign(Source: TPersistent);
begin
  if Source is TWVField then
    with TWVField(Source) do
    begin
      Self.FNotes := Notes;
      Self.FCaption := Caption;
      Self.FDescription := Description;
      Self.FDomainName := DomainName;
      Self.Domain := Domain;
      Self.FName := Name;
      Self.FFeatures.Assign(Features);
      Self.FFieldType := FieldType;
      Self.FVisible := Visible;
      Self.FValid := Valid;
      Self.FConstrained := Constrained;
      Self.FDefaultValue := DefaultValue;
      Self.FMonitorValueChangedFields := MonitorValueChangedFields;
      Self.FMonitorValidChangedFields := MonitorValidChangedFields;
      Self.FChecker.Assign(Checker);
      Self.FGoNextWhenPressEnter := GoNextWhenPressEnter;
      Self.FGetPrevChar := GetPrevChar;
      Self.FImeMode := ImeMode;
      Self.DataType := DataType;
      Self.OwnObject := OwnObject;
      Self.FGroupIndex := GroupIndex;
      Self.FHint := Hint;
    end
  else
    inherited;
end;
{
function TWVField.GetErrorMessage: string;
begin
  if Valid then
    Result := '' else
    Result := FErrorMessage;
end;
}
procedure TWVField.SetInvalidMessage(const Msg: string);
begin
  if not Valid then
    ErrorMessage := Msg;
end;

procedure TWVField.SetFeatures(const Value: TStrings);
begin
  FFeatures.Assign(Value);
end;

{ TWVFieldDomain }

constructor TWVFieldDomain.Create(AOwner: TComponent);
begin
  inherited;
  Assert(FieldDomainManager<>nil);
  FieldDomainManager.AddDomain(Self);
  FChecker := TWVFieldChecker.Create;
end;

destructor TWVFieldDomain.Destroy;
begin
  if FieldDomainManager<>nil then
    FieldDomainManager.RemoveDomain(Self);
  inherited;
end;

function TWVFieldDomain.GetOnCheckValid: TFieldEvent;
begin
  Result := Checker.OnCheckValid;
end;

function TWVFieldDomain.GetOnKeyDown: TKeyEvent;
begin
  Result := Checker.OnKeyDown;
end;

function TWVFieldDomain.GetOnKeyPress: TKeyPressEvent;
begin
  Result := Checker.OnKeyPress;
end;

function TWVFieldDomain.GetOnKeyUp: TKeyEvent;
begin
  Result := Checker.OnKeyUp;
end;

procedure TWVFieldDomain.SetChecker(const Value: TWVFieldChecker);
begin
  FChecker.Assign(Value);
end;

procedure TWVFieldDomain.SetDomainName(const Value: string);
begin
  if FDomainName <> Value then
  begin
    FDomainName := Value;
    FieldDomainManager.NotifyChanges(Self);
  end;
end;

procedure TWVFieldDomain.SetOnCheckValid(const Value: TFieldEvent);
begin
  Checker.OnCheckValid := Value;
end;

procedure TWVFieldDomain.SetOnKeyDown(const Value: TKeyEvent);
begin
  Checker.OnKeyDown := Value;
end;

procedure TWVFieldDomain.SetOnKeyPress(const Value: TKeyPressEvent);
begin
  Checker.OnKeyPress := Value;
end;

procedure TWVFieldDomain.SetOnKeyUp(const Value: TKeyEvent);
begin
  Checker.OnKeyUp := Value;
end;

{ TWVFieldDomainManager }

constructor TWVFieldDomainManager.Create;
begin
  FDomains := TList.Create;
  FMagic := 0;
end;

destructor TWVFieldDomainManager.Destroy;
begin
  FreeAndNil(FDomains);
  inherited;
end;

function TWVFieldDomainManager.FindDomain(const Name: string): TWVFieldDomain;
var
  i : integer;
begin
  for i:=0 to FDomains.count-1 do
  begin
    Result := TWVFieldDomain(FDomains[i]);
    if CompareText(Result.DomainName,Name)=0 then
      Exit;
  end;
  Result := nil;
end;

procedure TWVFieldDomainManager.NotifyChanges(Domain: TWVFieldDomain);
begin
  Inc(FMagic);
end;

procedure TWVFieldDomainManager.AddDomain(Domain: TWVFieldDomain);
begin
  FDomains.Add(Domain);
  NotifyChanges(Domain);
end;

procedure TWVFieldDomainManager.RemoveDomain(Domain: TWVFieldDomain);
begin
  FDomains.Remove(Domain);
  NotifyChanges(Domain);
end;

function TWVFieldDomainManager.Count: Integer;
begin
  Result := FDomains.Count;
end;

function TWVFieldDomainManager.GetDomains(Index: Integer): TWVFieldDomain;
begin
  Result := TWVFieldDomain(FDomains[Index]);
end;

{ TWVFieldChecker }

constructor TWVFieldChecker.Create;
begin
  inherited;
  FAcceptDigital  := True;
  FAcceptAlphabet := True;
  FAcceptOther    := True;
  FAcceptHigh     := True;
  FRequired := True;
  FDefaultValid := True;
end;

procedure TWVFieldChecker.KeyDown(Sender : TObject; var Key: Word; Shift: TShiftState);
begin
  if Assigned(FOnKeyDown) {and not (csDesigning in ComponentState)} then
  begin
    FOnKeyDown(Sender,Key,Shift);
  end;
end;

procedure TWVFieldChecker.KeyPress(Sender : TObject; var Key: Char);
begin
  if Key in ['0'..'9'] then
  begin
    if not AcceptDigital then
      Key := #0;
  end
  else if Key in ['a'..'z','A'..'Z'] then
  begin
    if not AcceptAlphabet then
      Key := #0
    else if UpperCase then
      Key := UpCase(Key)
    else if LowerCase then
      Key := Char(Ord('a')-Ord('A')+ Ord(Key));
  end
  else if (Key>#31) and (Key<=#127) then // #8=Backspace
  begin
    if not AcceptOther then
      Key := #0;
  end
  else if (Key>#127) then // #8=Backspace
  begin
    if not AcceptHigh then
      Key := #0;
  end;
  if Assigned(FOnKeyPress) {and not (csDesigning in ComponentState)} then
  begin
    FOnKeyPress(Sender,Key);
  end;
end;

procedure TWVFieldChecker.KeyUp(Sender : TObject; var Key: Word; Shift: TShiftState);
begin
  if Assigned(FOnKeyUp) {and not (csDesigning in ComponentState)} then
  begin
    FOnKeyUp(Sender,Key,Shift);
  end;
end;

procedure TWVFieldChecker.CheckValid(Field: TWVField);
var
  Valid : Boolean;
  L : Integer;
  D : Double;
  ValidChars : TSysCharSet;
begin
  // 根据CheckValid的要求检查
  Valid := DefaultValid;
  if Field.Data.IsEmpty then
    Valid :=  not Required
  else if (Field.DataType in [kdtString,kdtWideString]) and (MaxLength>0) then
  begin
    L := Length(Field.Data.AsString);
    Valid := (L>=MinLength) and (L<=MaxLength);
    if not Valid then
      Field.ErrorMessage := EInvalidLength;
    if Valid and not (AcceptDigital and AcceptAlphabet and AcceptOther and AcceptHigh) then
    begin
      ValidChars := [];
      if AcceptDigital then
        ValidChars := ValidChars + ['0'..'9'];
      if AcceptAlphabet then
        ValidChars := ValidChars + ['a'..'z','A'..'Z'];
      if AcceptOther then
        ValidChars := ValidChars + ([' '..#127] - ['0'..'1'] - ['a'..'z','A'..'Z']);
      if AcceptHigh then
        ValidChars := ValidChars + [#128..#255];
      Valid := IsValidChars(Field.Data.AsString,ValidChars);
      if not Valid then
        Field.ErrorMessage := EInvalidChars;
    end;
  end
  else if (Field.DataType in [kdtInteger,kdtInt64,kdtCurrency,kdtFloat]) and (Abs(Max-Min)>0.0000001) then
  begin
    D := Field.Data.AsFloat;
    Valid := (D>=Min) and (D<=Max);
    if not Valid then
      Field.ErrorMessage := EInvalidRange;
  end;
  Field.Valid := Valid;
  // 然后根据事件检查
  if Assigned(FOnCheckValid) and not (csDesigning in Field.WorkView.ComponentState) then
    FOnCheckValid(Field);
end;

procedure TWVFieldChecker.Assign(Source: TPersistent);
begin
  if Source is TWVFieldChecker then
  with TWVFieldChecker(Source) do
  begin
    Self.AcceptDigital := AcceptDigital;
    Self.AcceptAlphabet := AcceptAlphabet;
    Self.AcceptOther := AcceptOther;
    Self.DefaultValid := DefaultValid;
    Self.MinLength := MinLength;
    Self.MaxLength := MaxLength;
    Self.Min := Min;
    Self.Max := Max;
    Self.LowerCase := LowerCase;
    Self.UpperCase := UpperCase;
    Self.Required := Required;
    Self.OnCheckValid := OnCheckValid;
    Self.OnKeyDown := OnKeyDown;
    Self.OnKeyUp := OnKeyUp;
    Self.OnKeyPress := OnKeyPress;
  end else
    inherited;
end;

{ TWVFieldMonitor }

constructor TWVFieldMonitor.Create(Collection: TCollection);
begin
  inherited;
  FWorkView := TWorkView(TOwnedCollectionAccess(Collection).GetOwner);
  Assert(FWorkView<>nil);
  FGroupIndex := 0;
end;

procedure TWVFieldMonitor.Assign(Source: TPersistent);
begin
  if Source is TWVFieldMonitor then
    with TWVFieldMonitor(Source) do
    begin
      Self.FGroupIndex := GroupIndex;
      Self.FMonitorValueChangedFields := MonitorValueChangedFields;
      Self.FMonitorValidChangedFields := MonitorValidChangedFields;
    end
  else
    inherited;
end;

type
  PInteger = ^Integer;
procedure TWVFieldMonitor.FieldValidChanged(Field: TWVField; AGroupIndex : Integer=0);
var
  Triger : Boolean;
  Part : string;
  S : TComponentState;
begin
  if Field=nil then
  begin
    Triger := (AGroupIndex=0) or (AGroupIndex=Self.GroupIndex);
  end else
  begin
    Part := UpperCase(SeperateFieldChar+Field.Name+SeperateFieldChar);
    Triger := Pos(Part,MonitorValidChangedFields)>0;
  end;
  if Triger then
  begin
    FValid := GetValid(MonitorValidChangedFields);
    //if Assigned(FOnValidChanged) and not (csDesigning in WorkView.ComponentState) then
    begin
      { TODO : 删除 }
      {if (Field<>nil) then
        FOnValidChanged(Self,FValid) else}
      begin
        S := WorkView.ComponentState;
        //WriteLog(Format('WorkView.ComponentState=%d',[PInteger(@S)^]),lcDebug);
      end;
    end;
  end;
end;

procedure TWVFieldMonitor.FieldValueChanged(Field: TWVField; AGroupIndex : Integer=0);
var
  Triger : Boolean;
  Part : string;
begin
  // 当字段为nil并且AGroupIndex符合；或者字段名称被包括在MonitorValueChangedFields，触发处理
  if Field=nil then
  begin
    Triger := (AGroupIndex=0) or (AGroupIndex=Self.GroupIndex);
  end else
  begin
    Part := UpperCase(SeperateFieldChar+Field.Name+SeperateFieldChar);
    Triger := Pos(Part,MonitorValueChangedFields)>0;
  end;
  if Triger then
  begin
    FValid := GetValid(MonitorValueChangedFields);
    if Assigned(FOnValueChanged) and not (csDesigning in WorkView.ComponentState) then
      FOnValueChanged(Self,FValid);
  end;
end;

function TWVFieldMonitor.GetValid(const Names: string): Boolean;
var
  I,Len : Integer;
  S : string;
  FieldName : string;
  Field : TWVField;
begin
  Result := True;
  S := Names;
  Len := Length(S);
  Delete(S,1,1);
  while Result do
  begin
    I := Pos(SeperateFieldChar,S);
    if I<=0 then
      Break;
    FieldName := Copy(S,1,I-1);
    S := Copy(S,I+1,Len);
    Field := WorkView.FindField(FieldName);
    if Field<>nil then
      Result := Field.Valid;
  end;
end;

procedure TWVFieldMonitor.SetMonitorValidChangedFields(
  const Value: string);
begin
  FMonitorValidChangedFields := UpperCase(Value);
end;

procedure TWVFieldMonitor.SetMonitorValueChangedFields(
  const Value: string);
begin
  FMonitorValueChangedFields := UpperCase(Value);
end;

{ TWVStringsMan }

constructor TWVStringsMan.Create(AOwner: TComponent);
begin
  inherited;
  AddObject(WVGetStringsCategory,Self);
end;

destructor TWVStringsMan.Destroy;
begin
  RemoveObject(WVGetStringsCategory,Self);
  inherited;
end;

procedure TWVStringsMan.GetStrings(const StringsName: string;
  Items: TStrings; var Handled: Boolean);
begin
  if Assigned(OnGetStrings) and not (csDesigning in ComponentState) then
    OnGetStrings(StringsName,Items,Handled);
end;

{ TWVFieldPresent }

procedure TWVFieldPresent.CtrlToField(Ctrl: TObject; Field: TWVField;
  const ADataPresentType: TDataPresentType; const Param : string; var Handled: Boolean);
begin
  if SameText(ADataPresentType,Self.DataPresentType) and Assigned(FOnCtrlToField) and not (csDesigning in ComponentState) then
    FOnCtrlToField(Ctrl,Field,DataPresentType,Param,Handled);
end;

procedure TWVFieldPresent.FieldToCtrl(Field: TWVField; Ctrl: TObject;
  const ADataPresentType: TDataPresentType; const Param : string; var Handled: Boolean);
begin
  if SameText(ADataPresentType,Self.DataPresentType) and Assigned(FOnFieldToCtrl) and not (csDesigning in ComponentState) then
    FOnFieldToCtrl(Field,Ctrl,DataPresentType,Param,Handled);
end;

procedure TWVFieldPresent.SetFieldEventHanlder(Field: TField;
  const ADataPresentType: TDataPresentType; const Param : string; var Handled: Boolean);
begin
  if SameText(ADataPresentType,Self.DataPresentType) and Assigned(FOnSetFieldHandler) and not (csDesigning in ComponentState) then
    FOnSetFieldHandler(Field,DataPresentType,Param,Handled);
end;

{ TWVDataSource }

procedure TWVDataSource.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if Operation=opRemove then
  begin
    if AComponent=WorkView then
      WorkView := nil
    else if AComponent=DataSource then
      DataSource := nil;
  end;
end;

procedure TWVDataSource.SetDataSource(const Value: TDataSource);
begin
  if FDataSource <> Value then
  begin
    FDataSource := Value;
    if FDataSource<>nil then
      FDataSource.FreeNotification(Self);
  end;
end;

procedure TWVDataSource.SetWorkView(const Value: TWorkView);
begin
  if FWorkView<> Value then
  begin
    FWorkView:= Value;
    if FWorkView<>nil then
      FWorkView.FreeNotification(Self);
  end;
end;

procedure TWVDataSource.WorkViewToDataSource;
begin
  CheckTrue((WorkView<>nil) and (DataSource<>nil) and (DataSource.Dataset<>nil),'Error : WorkView or DataSource or Dataset is nil.');
  { TODO : 编辑状态 }
  WorkView.SaveToDataset(DataSource.Dataset,GroupIndex);
end;

procedure TWVDataSource.DataSourceToWorkView;
begin
  CheckTrue((WorkView<>nil) and (DataSource<>nil) and (DataSource.Dataset<>nil),'Error : WorkView or DataSource or Dataset is nil.');
  if ResetBeforeLoad then
    WorkView.Reset(GroupIndex);
  WorkView.LoadFromDataset(DataSource.Dataset,GroupIndex);
end;


constructor TWVDataSource.Create(AOwner: TComponent);
begin
  inherited;
  ResetBeforeLoad := True;
end;

{ TWVCustomFieldPresent }

constructor TWVCustomFieldPresent.Create(AOwner: TComponent);
begin
  inherited;
  AddObject(WVFieldPresentCategory,Self);
end;

destructor TWVCustomFieldPresent.Destroy;
begin
  RemoveObject(WVFieldPresentCategory,Self);
  inherited;
end;

{ TWorkViewCenter }

constructor TWorkViewCenter.Create(AOwner: TComponent);
begin
  inherited;
  if GlobalWorkViewCenter=nil then
    GlobalWorkViewCenter:=Self;
  FValidColor := clWhite;
  FInvalidColor := clInfoBK;
  FReadOnlyColor := clNone;
end;

destructor TWorkViewCenter.Destroy;
begin
  if GlobalWorkViewCenter=Self then
    GlobalWorkViewCenter:=nil;
  inherited;
end;

procedure TWorkViewCenter.HandleException(Sender: TObject; E: Exception);
begin
  if Assigned(FOnException) and not (csDesigning in ComponentState) then
    FOnException(Sender, E) else
    Application.HandleException(E);
end;

procedure TWorkViewCenter.InvalidInput(Field: TWVField; Target: TObject);
begin
  if Assigned(OnInvalidInput) and not (csDesigning in ComponentState) then
    OnInvalidInput(Field, Target) else
    Beep;
end;

procedure TWorkViewCenter.Loaded;
begin
  inherited;
  PropertyChanged;
end;

procedure TWorkViewCenter.PropertyChanged;
var
  I : Integer;
begin
  if ([csLoading, csDestroying] * ComponentState)<>[] then
    Exit;
  if GlobalWorkViewList<>nil then
  begin
    for I:=0 to GlobalWorkViewList.Count-1 do
    begin
      if TWorkView(GlobalWorkViewList[I]).WorkViewCenter = Self then
        TWorkView(GlobalWorkViewList[I]).UpdateWorkViewCenter;
    end;
  end;
end;

procedure TWorkViewCenter.SetInvalidColor(const Value: TColor);
begin
  if FInvalidColor <> Value then
  begin
    FInvalidColor := Value;
    PropertyChanged;
  end;
end;

procedure TWorkViewCenter.SetReadOnlyColor(const Value: TColor);
begin
  if FReadOnlyColor <> Value then
  begin
    FReadOnlyColor := Value;
    PropertyChanged;
  end;
end;

procedure TWorkViewCenter.SetValidColor(const Value: TColor);
begin
  if FValidColor <> Value then
  begin
    FValidColor := Value;
    PropertyChanged;
  end;
end;

initialization
  FieldDomainManager := TWVFieldDomainManager.Create;
  GetStringsCategory := CreateCategory(WVGetStringsCategory,False);
  FieldPresentCategory := CreateCategory(WVFieldPresentCategory,False);
  openLogFile('c:\debugworkview.log',false,true);

finalization
  FreeAndNil(FieldDomainManager);
  FreeAndNil(GlobalWorkViewList);

end.
