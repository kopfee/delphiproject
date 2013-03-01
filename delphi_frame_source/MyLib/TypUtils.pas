unit TypUtils;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> TypUtils
   <What> RunTime-Type-Information ¹¤¾ß
   <Written By> Huang YanLai
   <History>
**********************************************}

interface

uses TypInfo,sysutils,Classes;

{ if AObject have a published property named ProperName and that type is
  in propertypes, return true.
}
function CheckProperty(AObject : TObject;
               const ProperName : string;
               propertypes : TTypeKinds;
               var propInfo : PpropInfo):boolean;
// get functions

function GetClassProperty(AObject : TObject;
               const ProperName : string): TObject;

function GetOrdProperty(AObject : TObject;
               const ProperName : string;
               var value:longint):boolean;

function GetStringProperty(AObject : TObject;
               const ProperName : string;
               var value:String):boolean;
// set functions
// if successful returntrue

function SetStringProperty(AObject : TObject;
               const ProperName : string;
               const value : string):boolean;

function SetOrdProperty(AObject : TObject;
               const ProperName : string;
               value : longint):boolean;

function SetClassProperty(AObject : TObject;
               const ProperName : string;
               value : TObject):boolean;

function SetFloatProperty(AObject : TObject;
               const ProperName : string;
               value : Extended):boolean;

function SetVariantProperty(AObject : TObject;
               const ProperName : string;
               value : Variant):boolean;

function SetMethodProperty(AObject : TObject;
               const ProperName : string;
               value : TMethod):boolean;
{
function SetMethodProperty2(AObject : TObject;
               const ProperName : string;
               Instance:TObject;
               Address : Pointer):boolean;
}
const
	tkOrds = [tkInteger, tkChar, tkWChar,tkEnumeration,tkSet];
  tkStrings = [tkString, tkLString, tkWString];
  tkFloats = [tkFloat];
  tkClasses = [tkClass];
  tkMethods = [tkMethod];
  tkVariants = [tkVariant];
  tkOther = tkAny-tkOrds-tkStrings-tkFloats-tkClasses-tkMethods;

type
	TPropertyType = (ptOrd,ptString,ptFloat,ptClass,ptMethod,ptVariant,ptOther);
  TPropertyTypes = set of TPropertyType;

type
	TProperty = class;

  TPropertyAnalyse = class
  private
  	FMemSize : integer;
    FPropList : PPropList;
    FPropCount: integer;
    FAnalysedObject: TObject;
    FProperty : TProperty;
    function 	GetPropInfos(index: integer): PPropInfo;
    function 	GetPropNames(index: integer): String;
    function 	GetPropKinds(index: integer): TTypeKind;
    procedure SetAnalysedObject(const Value: TObject);
    procedure CheckIndex(index : integer);
    procedure Clear;
    function 	GetPropTypes(index: integer): TPropertyType;
    function 	GetProperties(index: integer): TProperty;
  protected

  public
    constructor Create;
    destructor	destroy; override;
    property		AnalysedObject : TObject read FAnalysedObject write SetAnalysedObject;
    property 		PropCount: integer Read FPropCount;
    //property 		MethodCount: Read FMethodCount;
    property		PropInfos[index : integer] : PPropInfo read GetPropInfos;
    Property		PropNames[index : integer] : String read GetPropNames;
    Property		PropKinds[index : integer] : TTypeKind read GetPropKinds;
    Property		PropTypes[index : integer] : TPropertyType read GetPropTypes;
    property		Properties[index : integer] : TProperty read GetProperties;
  published

  end;

  TProperty = class
  private
    //FTypeInfo : PTypeInfo;
    FPropInfo : PPropInfo;
    FInstance: TObject;
    procedure SetAsFloat(const Value: Extended);
    procedure SetAsMethod(const Value: TMethod);
    procedure SetAsObject(const Value: TObject);
    procedure SetAsOrd(const Value: Longint);
    procedure SetAsString(const Value: String);
    function 	GetAsFloat: Extended;
    function 	GetAsMethod: TMethod;
    function 	GetAsObject: TObject;
    function 	GetAsOrd: Longint;
    function 	GetAsString: String;
    function 	GetTypeKind: TTypeKind;
    function	GetPropType: TPropertyType;
    procedure CheckType(ThePropType : TPropertyType);
    function	GetPropTypeInfo: PTypeInfo;
    function 	GetPropName: string;
    procedure SetInstance(const Value: TObject);
    procedure SetPropName(const Value: string);
    function  GetAsVariant: Variant;
    procedure SetAsVariant(const Value: Variant);
  protected

  public
    constructor Create(Obj : TObject; APropInfo : PPropInfo);
    constructor CreateByName(Obj : TObject; const Propname : string);
    function Available: boolean;
    // you must set instance before set Propname
    property Instance : TObject read FInstance write SetInstance;
    property PropName : string read GetPropName write SetPropName;
    property PropInfo : PPropInfo read FPropInfo	write FPropInfo;
    property PropTypeInfo : PTypeInfo Read GetPropTypeInfo;
    property TypeKind : TTypeKind read GetTypeKind;
    property PropType	: TPropertyType read GetPropType;
    property AsOrd : Longint read GetAsOrd write SetAsOrd;
    property AsString	:	String read GetAsString write SetAsString;
    property AsFloat	: Extended read GetAsFloat write SetAsFloat;
    property AsObject	: TObject read GetAsObject write SetAsObject;
    property AsMethod	: TMethod read GetAsMethod write SetAsMethod;
    property AsVariant : Variant read GetAsVariant write SetAsVariant;
    function MinValue: longint;
    function MaxValue: longint;
    // if not is Enum, return false
    // EnumName is string, EnumValue is object
    // not clear AStrings !
    function CopyValuesToStrings(AStrings : TStrings):boolean ;
    function BaseTypeInfo : PTypeInfo;
    // Enum is a enum or integer
    function EnumInSet(const Enum): boolean;
    procedure GetSET(var SETValue);
    procedure PutSET(const SETValue);
  published

  end;

  function	GetSetStr(TypeInfo : PTypeInfo; SetValue:longint):string;
  function	GetSetvalue(TypeInfo : PTypeInfo; const s:string):longint;

type
  TIntegerSet = set of 0..SizeOf(Integer) * 8 - 1;
  
implementation

uses SafeCode,ConvertUtils;

function CheckProperty(AObject : TObject;
               const ProperName : string;
               propertypes : TTypeKinds;
               var propInfo : PPropInfo):boolean;

var
  TypeInfo : PTypeInfo;
begin
  result := false;
  PropInfo := nil;
  if (AObject<>nil)
  then begin
    TypeInfo := AObject.classInfo;
    PropInfo := GetPropInfo(TypeInfo,ProperName);
    if (propInfo<>nil)
     and (propInfo^.PropType^.Kind in propertypes)
    then result := true
    else PropInfo := nil;
  end;
end;

function SetStringProperty(AObject : TObject;
               const ProperName : string;
               const value : string):boolean;
var
  PropInfo: PPropInfo;
begin
  result := checkProperty(AObject,ProperName,
    [tkString,tkLString,tkWString], PropInfo);
  if result
    then  SetStrProp(AObject,PropInfo,value);
end;

function GetStringProperty(AObject : TObject;
               const ProperName : string;
               var value:String):boolean;
var
  PropInfo: PPropInfo;
begin
  result := checkProperty(AObject,ProperName,
    [tkString,tkLString,tkWString], PropInfo);
  if result
    then  value:=GetStrProp(AObject,PropInfo);
end;

function SetOrdProperty(AObject : TObject;
               const ProperName : string;
               value : longint):boolean;
var
  PropInfo: PPropInfo;
begin
  result := checkProperty(AObject,ProperName,
    [tkInteger, tkChar, tkEnumeration, tkFloat,tkSet], PropInfo);
  if result
    then  SetOrdProp(AObject,PropInfo,value);
end;

function SetClassProperty(AObject : TObject;
               const ProperName : string;
               value : TObject):boolean;
var
  PropInfo: PPropInfo;
begin
  result := checkProperty(AObject,ProperName,
    [tkClass], PropInfo);
  if result
    then  SetOrdProp(AObject,PropInfo,longint(value));
end;

function SetFloatProperty(AObject : TObject;
               const ProperName : string;
               value : Extended):boolean;
var
  PropInfo: PPropInfo;
begin
  result := checkProperty(AObject,ProperName,
    [tkFloat], PropInfo);
  if result
    then  SetFloatProp(AObject,PropInfo,value);
end;

function SetVariantProperty(AObject : TObject;
               const ProperName : string;
               value : Variant):boolean;
var
  PropInfo: PPropInfo;
begin
  result := checkProperty(AObject,ProperName,
    [tkVariant], PropInfo);
  if result
    then  SetVariantProp(AObject,PropInfo,value);
end;

function SetMethodProperty(AObject : TObject;
               const ProperName : string;
               value : TMethod):boolean;
var
  PropInfo: PPropInfo;
begin
  result := checkProperty(AObject,ProperName,
    [tkMethod], PropInfo);
  if result
    then  SetMethodProp(AObject,PropInfo,value);
end;

function GetClassProperty(AObject : TObject;
               const ProperName : string): TObject;
var
  PropInfo: PPropInfo;
  b : boolean;
begin
  result := nil;
  b := checkProperty(AObject,ProperName,
    [tkClass], PropInfo);
  if b
    then result := TObject(GetOrdProp(AObject,PropInfo));
end;

function GetOrdProperty(AObject : TObject;
               const ProperName : string;
               var value:longint):boolean;
var
  PropInfo: PPropInfo;
begin
  result := checkProperty(AObject,ProperName,
    [tkInteger, tkChar, tkEnumeration, tkFloat,tkSet],
     PropInfo);
  if result
    then value:= GetOrdProp(AObject,PropInfo);
end;

{ TPropertyAnalyse }

constructor TPropertyAnalyse.Create;
begin
  inherited Create;
  FMemSize := 0;
	FPropList:=nil;
	FAnalysedObject:=nil;
  FProperty:=TProperty.Create(nil,nil);
  //FProperty.Instace := nil;
end;

procedure TPropertyAnalyse.Clear;
begin
  if FPropList<>nil then FreeMem(FPropList,FmemSize);
  FPropList := nil;
  FmemSize := 0;
  FPropCount := 0;
end;

destructor TPropertyAnalyse.destroy;
begin
  clear;
  FProperty.free;
  inherited destroy;
end;

procedure TPropertyAnalyse.CheckIndex(index: integer);
begin
  if (Index<0) or (index>=FPropCount) then RaiseIndexOutofRange;
end;

function TPropertyAnalyse.GetPropInfos(index: integer): PPropInfo;
begin
  checkIndex(index);
  result := FPropList^[index];
end;

function TPropertyAnalyse.GetPropNames(index: integer): String;
begin
  checkIndex(index);
  result := FPropList^[index]^.name;
end;

function TPropertyAnalyse.GetPropKinds(index: integer): TTypeKind;
begin
  checkIndex(index);
  result := FPropList^[index]^.Proptype^^.Kind;
end;

procedure TPropertyAnalyse.SetAnalysedObject(const Value: TObject);
var
	TypeInfo : PTypeInfo;
  TypeData : PTypeData;
begin
  if value=FAnalysedObject then exit;
  Clear;
  FAnalysedObject := Value;
  if FAnalysedObject<>nil then
  begin
    TypeInfo := FAnalysedObject.classInfo;
    if TypeInfo<>nil then
    begin
      TypeData:=GetTypeData(TypeInfo);
      FMemSize := TypeData^.PropCount * sizeof(PPropInfo);
      GetMem(FPropList,FMemSize);
      FPropCount:=GetPropList(TypeInfo,tkProperties,FPropList);
    end;
  end;
  Fproperty.instance := FAnalysedObject;
end;

function TPropertyAnalyse.GetPropTypes(index: integer): TPropertyType;
var
  PropKind : TTypeKind;
begin
	PropKind := PropKinds[index];
  if PropKind in tkOrds then result := ptOrd
	else if PropKind in tkStrings then result := ptString
  else if PropKind in tkFloats then result := ptFloat
  else if PropKind in tkClasses then result := ptClass
  else if PropKind in tkMethods then result := ptMethod
  else if PropKind in tkVariants then result := ptVariant
  else result := ptOther;
end;

function TPropertyAnalyse.GetProperties(index: integer): TProperty;
begin
  checkIndex(index);
  result:=FProperty;
  FProperty.PropInfo := PropInfos[index];
end;

{ TProperty }

constructor TProperty.Create(Obj: TObject; APropInfo: PPropInfo);
begin
	//Assert((Obj<>nil) and (PropInfo<>nil));
  inherited Create;
  //FTypeInfo := TypeInfo;
  FPropInfo := APropInfo;
  FInstance := Obj;
end;

constructor TProperty.CreateByName(Obj: TObject; const Propname: string);
var
  TypeInfo : PTypeInfo;
begin
  if obj=nil then
		Create(nil,nil)
  else
  begin
		TypeInfo := obj.classinfo;
  	Create(obj,GetPropInfo(TypeInfo,propname));
  end;
end;

function TProperty.GetTypeKind: TTypeKind;
begin
  result:=PropInfo^.PropType^^.kind;
end;

function TProperty.Available: boolean;
begin
  result:=(Instance<>nil) and (FPropInfo<>nil);
end;

function TProperty.GetPropName: string;
begin
  if Available then result := FPropInfo.Name
  else result:='';
end;

procedure TProperty.SetPropName(const Value: string);
begin
  if instance<>nil then PropInfo := GetPropInfo(instance.ClassInfo,value);
end;

procedure TProperty.SetInstance(const Value: TObject);
begin
  if FInstance <> Value then
  begin
    FInstance := Value;
	  FPropInfo := nil;
  end;
end;


function TProperty.GetAsFloat: Extended;
begin
	CheckType(ptFloat);
  result := GetFloatProp(instance,PropInfo);
end;

procedure TProperty.SetAsFloat(const Value: Extended);
begin
	CheckType(ptFloat);
  SetFloatProp(instance,PropInfo,value);
end;


function TProperty.GetAsMethod: TMethod;
begin
  CheckType(ptMethod);
  result := GetMethodProp(instance,PropInfo);
end;

procedure TProperty.SetAsMethod(const Value: TMethod);
begin
  CheckType(ptMethod);
  SetMethodProp(instance,PropInfo,value);
end;

function TProperty.GetAsObject: TObject;
begin
  CheckType(ptClass);
  result := TObject(GetOrdProp(instance,PropInfo));
end;

procedure TProperty.SetAsObject(const Value: TObject);
begin
	CheckType(ptClass);
  SetOrdProp(instance,PropInfo,longint(value));
end;

function TProperty.GetAsOrd: Longint;
begin
  CheckType(ptOrd);
  result := GetOrdProp(instance,PropInfo);
end;

procedure TProperty.SetAsOrd(const Value: Longint);
begin
  CheckType(ptOrd);
  SetOrdProp(instance,PropInfo,value);
end;

function TProperty.GetAsString: String;
var
  OrdValue : longint;
begin
  case PropType of
    ptString 	: result := GetStrProp(instance,PropInfo);
    ptClass	 	:
    	begin
        OrdValue:=GetOrdProp(instance,PropInfo);
        if TObject(OrdValue)=nil then result:='nil'
        else result := TObject(OrdValue).classname;
	    end;
    ptFloat	 	: result := FloatToStr(GetFloatProp(instance,PropInfo));
    ptOrd			:
    begin
    	OrdValue :=GetOrdProp(instance,propInfo);
      case TypeKind of
        tkInteger: result := IntToStr(OrdValue);
        tkChar :	 result	:= Char(OrdValue);
        tkEnumeration: result:=GetEnumName(PropTypeInfo,OrdValue);
        tkSet	 :	 result:=GetSetStr(PropTypeInfo,Ordvalue);
      else result := '';
    	end;
    end;
    ptVariant : Result := AsVariant;
  else //RaiseConvertError;
    result:='Unable convert type';
  end;
end;


procedure TProperty.SetAsString(const Value: String);
var
  OrdValue : longint;
begin
  case PropType of
    ptString 	: SetStrProp(instance,PropInfo,value);
    ptFloat	 	: SetFloatProp(instance,PropInfo,StrToFloat(value));
    ptOrd			:
    begin
      case TypeKind of
        tkInteger: OrdValue:=StrToInt(value);
        tkChar 	 : OrdValue:=longint(value[1]);
        tkEnumeration: OrdValue:=GetEnumValue(PropTypeInfo,value);
        tkSet	 	 : OrdValue:=GetSetvalue(PropTypeInfo,value);
      else exit;
    	end;
      SetOrdProp(instance,propinfo,OrdValue);
    end;
  else RaiseConvertError;
  end;
end;

function TProperty.GetPropType: TPropertyType;
var
  PropKind : TTypeKind;
begin
	PropKind := TypeKind;
  if PropKind in tkOrds then result := ptOrd
	else if PropKind in tkStrings then result := ptString
  else if PropKind in tkFloats then result := ptFloat
  else if PropKind in tkClasses then result := ptClass
  else if PropKind in tkMethods then result := ptMethod
  else if PropKind in tkVariants then result := ptVariant
  else result := ptOther;
end;


procedure TProperty.CheckType(ThePropType: TPropertyType);
begin
  if Proptype<>ThePropType then RaiseConvertError;
end;

function TProperty.GetPropTypeInfo: PTypeInfo;
begin
  result := PropInfo^.Proptype^;
end;

function	GetSetStr(TypeInfo : PTypeInfo; SetValue:longint):string;
var
  IsFirst : boolean;
  i : integer;
  EnumType: PTypeInfo;
begin
  result:='[';
  IsFirst := true;
  EnumType := GetTypeData(TypeInfo)^.CompType^;
  for  i:=0 to 31 do
    if i in TIntegerSet(Setvalue) then
    begin
      if IsFirst then IsFirst := false
      else result := result + ',';
      result:=result+GetEnumName(EnumType,i);
    end;
  result:=result+']';
end;

function	GetSetvalue(TypeInfo : PTypeInfo; const s:string):longint;
var
  i : integer;
  Start : integer;
  EnumStr : string;
  EnumType: PTypeInfo;
begin
  //result:=longint();
  result:=0;
  EnumType := GetTypeData(TypeInfo)^.CompType^;
  if s[1]<>'[' then RaiseConvertError;
  Start:=2;
	for i:=2 to length(s) do
  begin
    if (s[i]=',') or (s[i]=']') then
    begin
      EnumStr:=copy(s,start,i-start);
      Start := i+1;
      if EnumStr='' then break;
      include(TIntegerSet(Result), GetEnumValue(EnumType, EnumStr));
      if s[i]=']' then break;
    end;
  end;
  if (i<>length(s)) then RaiseConvertError;
end;

function TProperty.MaxValue: longint;
var
  TypeData : PTypeData;
begin
  if PropType = ptOrd then
  begin
    TypeData:=GetTypeData(PropTypeInfo);
    result := TypeData^.MaxValue;
  end
  else result := 0;
end;

function TProperty.MinValue: longint;
var
  TypeData : PTypeData;
begin
  if PropType = ptOrd then
  begin
    TypeData:=GetTypeData(PropTypeInfo);
    result := TypeData^.MinValue;
  end
  else result := 0;
end;

function TProperty.CopyValuesToStrings(AStrings: TStrings): boolean;
var
  i : integer;
  TypeInfo : PTypeInfo;
  TypeData : PTypeData;
begin
  if TypeKind=tkEnumeration then
  begin
    result := true;
    TypeInfo := PropTypeInfo;
    for i:=Minvalue to MaxValue do
      AStrings.AddObject(GetEnumName(TypeInfo,i),TObject(i));
  end
  else if TypeKind=tkSet then
  begin
    TypeInfo := BaseTypeInfo;
    result := TypeInfo<>nil;
    if result then
    begin
      TypeData := GetTypeData(TypeInfo);
	    for i:=TypeData^.Minvalue to TypeData^.MaxValue do
  	    AStrings.AddObject(GetEnumName(TypeInfo,i),TObject(i));
    end;
  end
  else result:=false;
end;

function TProperty.BaseTypeInfo: PTypeInfo;
begin
  if TypeKind=tkSet then
    with GetTypeData(PropTypeInfo)^ do
    	result := CompType^
  else
  	result := nil;
end;

function TProperty.EnumInSet(const Enum): boolean;
var
	Value : integer;
begin
	CheckTrue(TypeKind=tkSet,'Error : TypeKind<>tkSet');
  Value := AsOrd;
  result := ConvertUtils.EnumInSet(Enum,value);
end;

procedure TProperty.GetSET(var SETValue);
begin
	CheckTrue(TypeKind=tkSet,'Error : TypeKind<>tkSet');
  integer(SETValue) := AsOrd;
end;

procedure TProperty.PutSET(const SETValue);
begin
	CheckTrue(TypeKind=tkSet,'Error : TypeKind<>tkSet');
  AsOrd := integer(SETValue);
end;

function TProperty.GetAsVariant: Variant;
begin
  case PropType of
    ptOrd : Result := AsOrd;
    ptString : Result := AsString;
    ptFloat : Result := AsFloat;
    ptVariant : Result := GetVariantProp(Instance,PropInfo);
  else
    CheckTrue(TypeKind=tkSet,'Error : Cannot Get Variant');
  end;
end;

procedure TProperty.SetAsVariant(const Value: Variant);
begin
  case PropType of
    ptOrd : AsOrd := Value;
    ptString : AsString := Value;
    ptFloat : AsFloat := Value;
    ptVariant : SetVariantProp(Instance,PropInfo,Value);
  else
    CheckTrue(TypeKind=tkSet,'Error : Cannot Get Variant');
  end;
end;

end.
