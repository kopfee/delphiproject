unit DataTypes;
{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>DataTypes
   <What>定义了可以处理各种数据类型的对象类。
   该类可以代表不同的各种数据类型。
   数据类型在一定程度上面进行了简化，整数只有Integer和Int64,浮点数只有Double和Currency
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}


{$I KSConditions.INC }

interface

uses SysUtils, Classes;

type
  // 支持的数据类型
  // 数据类型在一定程度上面进行了简化，整数只有Integer和Int64,浮点数只有Double和Currency
  TKSDataType = (
    kdtInteger,   // Integer 32bit
    kdtInt64,     // Int64
    kdtFloat,     // double
    kdtCurrency,  // currency
    kdtChar,      // Char
    kdtWideChar,  // Wide Char
    kdtString,    // string
    kdtWideString,  // WideString
    kdtDateTime,    // TDatetime
    kdtBoolean,     // Boolean
    kdtObject,    // object
    kdtClass,     // TClass
    kdtInterface,
    kdtPointer,   // Pointer
    kdtBuffer     // Memory Buffer
  );

  // 保存数据的结构
  TKSData = {packed }record
    IsEmpty : Boolean;
    // 因为引用计数的关系，所以以下几个部分不能位于case部分
    VString : string;
    VWideString : WideString;
    VInterface : IUnknown;
    case DataType : TKSDataType of
      kdtInteger  : (VInteger:Integer);
      kdtInt64    : (VInt64:Int64);
      kdtFloat    : (VFloat:Double);
      kdtCurrency : (VCurrency:Currency);
      //kdtExtended : (VExtended : Extended);
      kdtChar     : (VChar : Char);
      kdtWideChar : (VWideChar : WideChar);
      kdtDateTime : (VDateTime : TDateTime);
      kdtBoolean  : (VBool : Boolean);
      kdtObject   : (VObject : TObject; OwnObject : Boolean);
      kdtClass    : (VClass : TClass);
      kdtPointer  : (VPointer : Pointer; BasedType : TKSDataType);
      kdtBuffer   : (VBuffer : Pointer; BufferSize : Integer);
  end;

  EDataTypeError = class(Exception);

  TKSDataObject = class;

  TDataObjectExceptionEvent = procedure (Sender : TKSDataObject; var E : Exception) of object;

  {
    <Class>TKSDataObject
    <What>数据对象。可以代表各种类型的数据
    <Properties>
      -
    <Methods>
      -
    <Event>
      -
  }
  TKSDataObject = class
  private
    Data : TKSData;
    FOnChanged: TNotifyEvent;
    FProtectedStr : string;
    FProtected : Boolean;
    FReadOnly:  Boolean;
    FOnException: TDataObjectExceptionEvent;
    FUpdateCount : Integer;
    procedure   RaiseDataTypeError;
    procedure   RaiseError(const ErrMsg : string);
    procedure   CheckDataType(TestType : TKSDataType);
    procedure   CheckModify;
    function    GetDataType: TKSDataType;
    procedure   SetDataType(const Value: TKSDataType);
    function    GetIsEmpty: Boolean;
    function    GetAsString: string;
    procedure   SetAsString(const Value: string);
    procedure   Changed;
    function    GetValue: Variant;
    procedure   SetValue(const Value: Variant);
    function    GetAsCurrency: Currency;
    function    GetAsFloat: Double;
    function    GetAsInteger: Integer;
    function    GetAsBoolean: Boolean;
    function    GetAsInterface: IUnknown;
    function    GetAsObject: TObject;
    function    GetOwnObject: Boolean;
    procedure   SetOwnObject(const Value: Boolean);
  public
    constructor Create(const AProtectedStr : string='');
    destructor  Destroy; override;
    property    ReadOnly : Boolean read FReadOnly;
    property    DataType : TKSDataType read GetDataType write SetDataType;
    property    IsEmpty : Boolean read GetIsEmpty;
    procedure   BeginUpdate(const AProtectedStr : string);
    procedure   EndUpdate(const AProtectedStr : string);
    // 释放Buffer，设置IsEmpty=True
    procedure   Clear;
    // 赋值，设置IsEmpty=False，
    function    SetInteger(const Value : Integer): Boolean;
    function    SetInt64(const Value : Int64): Boolean;
    function    SetString(const Value : string): Boolean;
    function    SetWideString(const Value : WideString): Boolean;
    function    SetChar(const Value : Char): Boolean;
    function    SetWideChar(const Value : WideChar): Boolean;
    function    SetDatetime(const Value : TDateTime): Boolean;
    function    SetBoolean(const Value : Boolean): Boolean;
    function    SetObject(const Value : TObject): Boolean;
    function    SetClass(const Value : TClass): Boolean;
    function    SetPointer(const Value : Pointer): Boolean;
    function    SetFloat(const Value : Double): Boolean;
    function    SetCurrency(const Value : Currency): Boolean;
    function    SetInterface(const Value : IUnknown): Boolean;
    // 管理Buffer
    procedure   AllocateBuffer(Size : Integer);
    procedure   FreeBuffer;
    // 管理对象
    procedure   ClearObject;
    property    OwnObject : Boolean read GetOwnObject write SetOwnObject;
    //
    property    AsString : string read GetAsString write SetAsString;
    property    AsInteger : Integer read GetAsInteger;
    property    AsFloat : Double read GetAsFloat;
    property    AsCurrency : Currency read GetAsCurrency;
    property    AsBoolean : Boolean read GetAsBoolean;
    property    AsObject : TObject read GetAsObject;
    property    AsInterface : IUnknown read GetAsInterface;
    property    Value : Variant read GetValue write SetValue;
    //
    procedure   Assign(DataObject : TKSDataObject);
    // event
    property    OnChanged : TNotifyEvent read FOnChanged write FOnChanged;
    property    OnException : TDataObjectExceptionEvent read FOnException write FOnException;
  end;

resourcestring
  SDataTypeError = '数据类型错误';
  SReadOnlyError = '不能修改只读数据';
  SNoRightModify = '没有修改数据的权限';

  SkdtInteger  = '整数';
  SkdtInt64    = '长整数';
  SkdtFloat    = '浮点数';
  SkdtCurrency = '货币';
  SkdtChar     = '字符';
  SkdtWideChar = '字符';
  SkdtString   = '字符串';
  SkdtWideString='字符串';
  SkdtDateTime = '日期';
  SkdtBoolean  = '逻辑';
  SkdtObject   = '对象';
  SkdtClass    = '对象类';
  SkdtInterface= '接口';
  SkdtPointer  = '指针';
  SkdtBuffer   = '内存缓冲区';

const
  KSDataTypeNames : array[TKSDataType] of string = (
    SkdtInteger,
    SkdtInt64,
    SkdtFloat,
    SkdtCurrency,
    SkdtChar,
    SkdtWideChar,
    SkdtString,
    SkdtWideString,
    SkdtDateTime,
    SkdtBoolean,
    SkdtObject,
    SkdtClass,
    SkdtInterface,
    SkdtPointer,
    SkdtBuffer
  );

implementation

uses ConvertUtils, LogFile
  {$ifdef VCL60_UP }
  ,Variants
  {$else}

  {$endif}
;

{ TKSDataObject }

constructor TKSDataObject.Create(const AProtectedStr : string);
begin
  FReadOnly := False;
  Data.IsEmpty := True;
  Data.VBuffer := nil;
  Data.BufferSize := 0;
  Data.OwnObject := False;
  FProtectedStr := AProtectedStr;
  FProtected := FProtectedStr<>'';
  FReadOnly := FProtected;
  FUpdateCount := 0;
end;

destructor TKSDataObject.Destroy;
begin
  FOnChanged := nil;
  Clear;
  inherited;
end;

procedure TKSDataObject.Changed;
begin
  if Assigned(FOnChanged) then
    FOnChanged(Self);
end;

procedure TKSDataObject.Clear;
begin
  FreeBuffer;
  ClearObject;
  // 处理引用计数
  case Data.DataType of
    kdtString : Data.VString := '';
    kdtWideString : Data.VWideString := '';
    kdtInterface : Data.VInterface := nil;
  end;
  if not Data.IsEmpty then
  begin
    Data.IsEmpty := True;
    Changed;
  end;
end;

procedure TKSDataObject.RaiseDataTypeError;
begin
  RaiseError(SDataTypeError);
end;

procedure TKSDataObject.CheckDataType(TestType: TKSDataType);
begin
  if Data.DataType<>TestType then
    RaiseDataTypeError;
end;

procedure TKSDataObject.AllocateBuffer(Size: Integer);
begin
  CheckModify;
  FreeBuffer;
  if Data.DataType=kdtBuffer then
  begin
    Data.IsEmpty := True;
    GetMem(Data.VBuffer,Size);
    Data.BufferSize := Size;
  end;
end;

procedure TKSDataObject.FreeBuffer;
begin
  if not Data.IsEmpty and (Data.DataType=kdtBuffer) and (Data.VBuffer<>nil) and (Data.BufferSize>0) then
  begin
    FreeMem(Data.VBuffer);
    Data.VBuffer := nil;
    Data.BufferSize := 0;
    Data.IsEmpty := True;
  end;
end;

function TKSDataObject.GetDataType: TKSDataType;
begin
  Result := Data.DataType;
end;

procedure TKSDataObject.SetDataType(const Value: TKSDataType);
begin
  CheckModify;
  Clear;
  Data.DataType := Value;
  if Value=kdtObject then
  begin
    OwnObject := False;
  end;
end;

function TKSDataObject.GetIsEmpty: Boolean;
begin
  Result := Data.IsEmpty;
end;

function TKSDataObject.SetBoolean(const Value: Boolean): Boolean;
begin
  CheckModify;
  CheckDataType(kdtBoolean);
  Result := Data.IsEmpty;
  Data.IsEmpty := False;
  Result := Result or (Data.VBool <> Value);
  if Result then
  begin
    Data.VBool := Value;
    Changed;
  end;
end;

function TKSDataObject.SetInt64(const Value: Int64): Boolean;
begin
  CheckModify;
  CheckDataType(kdtInt64);
  Result := Data.IsEmpty;
  Data.IsEmpty := False;
  Result := Result or (Data.VInt64 <> Value);
  if Result then
  begin
    Data.VInt64 := Value;
    Changed;
  end;
end;

function TKSDataObject.SetInteger(const Value: Integer): Boolean;
begin
  CheckModify;
  CheckDataType(kdtInteger);
  Result := Data.IsEmpty;
  Data.IsEmpty := False;
  Result := Result or (Data.VInteger <> Value);
  if Result then
  begin
    Data.VInteger := Value;
    Changed;
  end;
end;

function TKSDataObject.SetDatetime(const Value: TDateTime): Boolean;
begin
  CheckModify;
  CheckDataType(kdtDateTime);
  Result := Data.IsEmpty;
  Data.IsEmpty := False;
  Result := Result or (Data.VDateTime <> Value);
  if Result then
  begin
    Data.VDateTime := Value;
    Changed;
  end;
end;

function TKSDataObject.SetChar(const Value: Char): Boolean;
begin
  CheckModify;
  CheckDataType(kdtChar);
  Result := Data.IsEmpty;
  Data.IsEmpty := False;
  Result := Result or (Data.VChar <> Value);
  if Result then
  begin
    Data.VChar := Value;
    Changed;
  end;
end;

function TKSDataObject.SetWideChar(const Value: WideChar): Boolean;
begin
  CheckModify;
  CheckDataType(kdtWideChar);
  Result := Data.IsEmpty;
  Data.IsEmpty := False;
  Result := Result or (Data.VWideChar <> Value);
  if Result then
  begin
    Data.VWideChar := Value;
    Changed;
  end;
end;

function TKSDataObject.SetString(const Value: string): Boolean;
begin
  CheckModify;
  CheckDataType(kdtString);
  Result := Data.IsEmpty;
  Data.IsEmpty := False;
  Result := Result or (Data.VString <> Value);
  if Result then
  begin
    Data.VString := Value;
    Changed;
  end;
end;

function TKSDataObject.SetWideString(const Value: WideString): Boolean;
begin
  CheckModify;
  CheckDataType(kdtWideString);
  Result := Data.IsEmpty;
  Data.IsEmpty := False;
  Result := Result or (Data.VWideString <> Value);
  if Result then
  begin
    Data.VWideString := Value;
    Changed;
  end;
end;

function TKSDataObject.SetFloat(const Value: Double): Boolean;
begin
  CheckModify;
  CheckDataType(kdtFloat);
  Result := Data.IsEmpty;
  Data.IsEmpty := False;
  Result := Result or (Data.VFloat <> Value);
  if Result then
  begin
    Data.VFloat := Value;
    Changed;
  end;
end;

function TKSDataObject.SetCurrency(const Value: Currency): Boolean;
begin
  CheckModify;
  CheckDataType(kdtCurrency);
  Result := Data.IsEmpty;
  Data.IsEmpty := False;
  Result := Result or (Data.VCurrency <> Value);
  if Result then
  begin
    Data.VCurrency := Value;
    Changed;
  end;
end;

function TKSDataObject.SetClass(const Value: TClass): Boolean;
begin
  CheckModify;
  CheckDataType(kdtClass);
  Result := Data.IsEmpty;
  Data.IsEmpty := False;
  Result := Result or (Data.VClass <> Value);
  if Result then
  begin
    Data.VClass := Value;
    Changed;
  end;
end;

function TKSDataObject.SetObject(const Value: TObject): Boolean;
begin
  CheckModify;
  CheckDataType(kdtObject);
  Result := Data.IsEmpty;
  Result := Result or (Data.VObject <> Value);
  if (Data.VObject <> Value) then
    ClearObject;
  Data.IsEmpty := False;
  if Result then
  begin
    Data.VObject := Value;
    Changed;
  end;
end;

function TKSDataObject.SetPointer(const Value: Pointer): Boolean;
begin
  CheckModify;
  CheckDataType(kdtPointer);
  Result := Data.IsEmpty;
  Data.IsEmpty := False;
  Result := Result or (Data.VPointer <> Value);
  if Result then
  begin
    Data.VPointer := Value;
    Changed;
  end;
end;

function TKSDataObject.SetInterface(const Value: IUnknown): Boolean;
begin
  CheckModify;
  CheckDataType(kdtInterface);
  Result := Data.IsEmpty;
  Data.IsEmpty := False;
  Result := Result or (Data.VInterface <> Value);
  if Result then
  begin
    Data.VInterface := Value;
    Changed;
  end;
end;

function TKSDataObject.GetAsString: string;
begin
  Result:='';
  if not Data.IsEmpty then
    case Data.DataType of
        kdtInteger  : Result := IntToStr(Data.VInteger);
        kdtInt64    : Result := IntToStr(Data.VInt64);
        kdtFloat    : Result := FloatToStr(Data.VFloat);
        kdtCurrency : Result := CurrToStr(Data.VCurrency);
        kdtChar     : Result := Data.VChar;
        kdtWideChar : Result := Data.VWideChar;
        kdtString   : Result := Data.VString;
        kdtWideString: Result := Data.VWideString;
        kdtDateTime : Result := DateTimeToStr(Data.VDateTime);
        kdtBoolean  : Result := BoolStrs[Data.VBool];
        kdtObject   : if Data.VObject=nil then
                        Result := 'nil' else
                        Result := Data.VObject.ClassName;
        kdtClass    : if Data.VClass=nil then
                        Result := 'nil' else
                        Result := Data.VClass.ClassName;
    end;
end;

procedure TKSDataObject.SetAsString(const Value: string);
begin
  if (Value='') and (Data.DataType in [kdtInteger, kdtInt64,
      kdtFloat, kdtCurrency,
      kdtChar, kdtWideChar,
      kdtDateTime, kdtBoolean,
      kdtObject, kdtClass,
      kdtInterface, kdtPointer, kdtBuffer]) then
    Clear else
    case Data.DataType of
      kdtInteger  : SetInteger(StrToInt(Value));
      kdtInt64    : SetInt64(StrToInt(Value));
      kdtFloat    : SetFloat(StrToFloat(Value));
      kdtCurrency : SetCurrency(StrToCurr(Value));
      kdtString   : SetString(Value);
      kdtWideString: SetWideString(Value);
      kdtDateTime : SetDatetime(StrToDateTime(Value));
      else  RaiseDataTypeError;
    end;
end;

function TKSDataObject.GetValue: Variant;
begin
  if Data.IsEmpty then
    Result := Unassigned else
    case Data.DataType of
        kdtInteger  : Result := Data.VInteger;
        kdtInt64    : Result := Integer(Data.VInt64);
        kdtFloat    : Result := Data.VFloat;
        kdtCurrency : Result := Data.VCurrency;
        kdtChar     : Result := Data.VChar;
        kdtWideChar : Result := Data.VWideChar;
        kdtString   : Result := Data.VString;
        kdtWideString: Result := Data.VWideString;
        kdtDateTime : Result := Data.VDateTime;
        kdtBoolean  : Result := Data.VBool;
    else
      Result := Null;
    end
end;

procedure TKSDataObject.SetValue(const Value: Variant);
begin
  if VarIsEmpty(Value) or VarIsNull(Value) then
    Clear else
    case Data.DataType of
      kdtInteger  : SetInteger(Value);
      kdtInt64    : SetInt64(Integer(Value));
      kdtFloat    : SetFloat(Value);
      kdtCurrency : SetCurrency(Value);
      kdtString   : SetString(Value);
      kdtWideString:SetWideString(Value);
      kdtDateTime : SetDatetime(Value);
      {kdtChar     : SetChar(Value);
      kdtWideChar : SetWideChar(Value);}
      else  RaiseDataTypeError;
    end;
end;

function TKSDataObject.GetAsCurrency: Currency;
begin
  if IsEmpty then
    RaiseDataTypeError;
  case Data.DataType of
    kdtInteger  : Result := Data.VInteger;
    kdtInt64    : Result := Data.VInt64;
    kdtFloat    : Result := Data.VFloat;
    kdtCurrency : Result := Data.VCurrency;
    kdtString   : Result := StrToCurr(Data.VString);
    kdtWideString: Result := StrToCurr(Data.VWideString);
  else
    RaiseDataTypeError;
    Result := 0;
  end;
end;

function TKSDataObject.GetAsFloat: Double;
begin
  if IsEmpty then
    RaiseDataTypeError;
  case Data.DataType of
    kdtInteger  : Result := Data.VInteger;
    kdtInt64    : Result := Data.VInt64;
    kdtFloat    : Result := Data.VFloat;
    kdtCurrency : Result := Data.VCurrency;
    kdtString   : Result := StrToFloat(Data.VString);
    kdtWideString: Result := StrToFloat(Data.VWideString);
  else
    RaiseDataTypeError;
    Result := 0;
  end;
end;

function TKSDataObject.GetAsInteger: Integer;
begin
  if IsEmpty then
    RaiseDataTypeError;
  case Data.DataType of
    kdtInteger  : Result := Data.VInteger;
    kdtInt64    : Result := Integer(Data.VInt64);
    //kdtFloat    : Result := Round(Data.VFloat); { TODO : 处理Float to Integer? }
    //kdtCurrency : Result := Round(Data.VCurrency);
    kdtString   : Result := StrToInt(Data.VString);
    kdtWideString: Result := StrToInt(Data.VWideString);
  else
    RaiseDataTypeError;
    Result := 0;
  end;
end;

procedure TKSDataObject.Assign(DataObject: TKSDataObject);
begin
  if DataObject.IsEmpty then
    Clear else
  begin
    case DataType of
      kdtInteger  : SetInteger(DataObject.AsInteger);
      kdtInt64    : SetInt64(DataObject.AsInteger); { TODO : 处理Int64 }
      kdtFloat    : SetFloat(DataObject.AsFloat);
      kdtCurrency : SetCurrency(DataObject.AsCurrency);
      kdtChar     : begin
                      DataObject.CheckDataType(kdtChar);
                      SetChar(DataObject.Data.VChar);
                    end;
      kdtWideChar : case DataObject.DataType of
                      kdtChar : SetWideChar(WideChar(DataObject.Data.VChar));
                      kdtWideChar : SetWideChar(DataObject.Data.VWideChar);
                    else
                      RaiseDataTypeError;
                    end;
      kdtString   : SetString(DataObject.AsString);
      kdtWideString:case DataObject.DataType of
                      kdtString : SetWideString(DataObject.Data.VString);
                      kdtWideString : SetWideString(DataObject.Data.VWideString);
                    else
                      SetWideString(DataObject.AsString);
                    end;
      kdtDateTime : begin
                      DataObject.CheckDataType(kdtDateTime);
                      SetDatetime(DataObject.Data.VDateTime);
                    end;
      kdtBoolean  : begin
                      DataObject.CheckDataType(kdtBoolean);
                      SetBoolean(DataObject.Data.VBool);
                    end;
      kdtObject   : begin
                      DataObject.CheckDataType(kdtObject);
                      SetObject(DataObject.Data.VObject);
                    end;
      kdtClass    : begin
                      DataObject.CheckDataType(kdtClass);
                      SetClass(DataObject.Data.VClass);
                    end;
      kdtInterface :begin
                      DataObject.CheckDataType(kdtInterface);
                      SetInterface(DataObject.Data.VInterface);
                    end;
      kdtPointer   :begin
                      DataObject.CheckDataType(kdtPointer);
                      SetPointer(DataObject.Data.VPointer);
                    end;
      else RaiseDataTypeError;
    end;
  end;
end;

function TKSDataObject.GetAsBoolean: Boolean;
begin
  CheckDataType(kdtBoolean);
  Result := False;
  if Data.IsEmpty then
    RaiseDataTypeError else
    Result := Data.VBool;
end;

function TKSDataObject.GetAsInterface: IUnknown;
begin
  CheckDataType(kdtInterface);
  if Data.IsEmpty then
    Result := nil else
    Result := Data.VInterface;
end;

function TKSDataObject.GetAsObject: TObject;
begin
  CheckDataType(kdtObject);
  if Data.IsEmpty then
    Result := nil else
    Result := Data.VObject;
end;

procedure TKSDataObject.CheckModify;
begin
  if ReadOnly then
    RaiseError(SReadOnlyError);
end;

procedure TKSDataObject.BeginUpdate(const AProtectedStr: string);
begin
  if AProtectedStr<>FProtectedStr then
    RaiseError(SNoRightModify);
  FReadOnly := False;
  Inc(FUpdateCount);
end;

procedure TKSDataObject.EndUpdate(const AProtectedStr : string);
begin
  if AProtectedStr<>FProtectedStr then
    RaiseError(SNoRightModify);
  Dec(FUpdateCount);
  if FUpdateCount<=0 then
    FReadOnly := FProtected;
end;

procedure TKSDataObject.ClearObject;
begin
  if (Data.DataType=kdtObject) and not Data.IsEmpty and (Data.VObject <> nil) and Data.OwnObject then
  begin
    WriteLog(Format('TKSDataObject.ClearObject Call %s[%8x].Free ',[Data.VObject.ClassName,Integer(Data.VObject)]),lcConstruct_Destroy);
    FreeAndNil(Data.VObject);
  end;
end;

function TKSDataObject.GetOwnObject: Boolean;
begin
  CheckDataType(kdtObject);
  Result := Data.OwnObject;
end;

procedure TKSDataObject.SetOwnObject(const Value: Boolean);
begin
  CheckDataType(kdtObject);
  CheckModify;
  Data.OwnObject := Value;
end;

procedure TKSDataObject.RaiseError(const ErrMsg: string);
var
  E : Exception;
begin
  E := EDataTypeError.Create(ErrMsg);
  if Assigned(FOnException) then
    FOnException(Self, E);
  if E<>nil then
    raise E;
end;

end.
