unit BasicDataAccess_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : $Revision:   1.88.1.0.1.0  $
// File generated on 2001-3-1 16:46:40 from Type Library described below.

// ************************************************************************ //
// Type Lib: C:\HuangYL\lib\StdIntf\BasicDataAccess.tlb (1)
// IID\LCID: {198F5CA0-BB06-11D3-AAFA-00C0268E6AE8}\0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\STDVCL40.DLL)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, OleCtrls, StdVCL;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  BasicDataAccessMajorVersion = 1;
  BasicDataAccessMinorVersion = 0;

  LIBID_BasicDataAccess: TGUID = '{198F5CA0-BB06-11D3-AAFA-00C0268E6AE8}';

  IID_IHDataset: TGUID = '{92BE437B-95A8-11D3-9493-5254AB137D80}';
  IID_IHField: TGUID = '{92BE437D-95A8-11D3-9493-5254AB137D80}';
  IID_IHParam: TGUID = '{92BE437F-95A8-11D3-9493-5254AB137D80}';
  IID_IHResultRender: TGUID = '{2F149461-970E-11D3-9495-5254AB137D80}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum THFieldType
type
  THFieldType = TOleEnum;
const
  sftInteger = $00000000;
  sftFloat = $00000001;
  sftChar = $00000002;
  sftDatetime = $00000003;
  sftBinary = $00000004;
  sftOther = $00000005;
  sfCurrency = $00000006;

// Constants for enum THRenderType
type
  THRenderType = TOleEnum;
const
  rtBrowse = $00000001;
  rtPrint = $00000002;
  rtList = $00000003;
  rtPrintList = $00000004;

// Constants for enum THFieldCatalog
type
  THFieldCatalog = TOleEnum;
const
  fcResult = $00000000;
  fcParam = $00000001;
  fcSum = $00000002;
  fcAutoSum = $00000003;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IHDataset = interface;
  IHDatasetDisp = dispinterface;
  IHField = interface;
  IHFieldDisp = dispinterface;
  IHParam = interface;
  IHParamDisp = dispinterface;
  IHResultRender = interface;
  IHResultRenderDisp = dispinterface;

// *********************************************************************//
// Interface: IHDataset
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {92BE437B-95A8-11D3-9493-5254AB137D80}
// *********************************************************************//
  IHDataset = interface(IDispatch)
    ['{92BE437B-95A8-11D3-9493-5254AB137D80}']
    procedure first; safecall;
    procedure next; safecall;
    procedure last; safecall;
    procedure prior; safecall;
    function  Get_eof: WordBool; safecall;
    function  Get_bof: WordBool; safecall;
    function  Get_fieldCount: Integer; safecall;
    function  Get_outputCount: Integer; safecall;
    function  Get_returnValue: Integer; safecall;
    function  Get_bookmark: Integer; safecall;
    procedure Set_bookmark(Value: Integer); safecall;
    function  Get_fields(index: Integer): IHField; safecall;
    function  Get_outputParams(index: Integer): IHParam; safecall;
    function  findField(const fieldName: WideString): IHField; safecall;
    function  getRender(purpose: THRenderType): IHResultRender; safecall;
    function  Get_available: WordBool; safecall;
    function  Get_sumFieldCount: Integer; safecall;
    function  Get_sumFields(index: Integer): IHParam; safecall;
    function  Get_moneyFormat: WideString; safecall;
    procedure Set_moneyFormat(const Value: WideString); safecall;
    function  Get_dateFormat: WideString; safecall;
    procedure Set_dateFormat(const Value: WideString); safecall;
    function  Get_timeFormat: WideString; safecall;
    procedure Set_timeFormat(const Value: WideString); safecall;
    function  Get_dateTimeFormat: WideString; safecall;
    procedure Set_dateTimeFormat(const Value: WideString); safecall;
    function  Get_floatFormat: WideString; safecall;
    procedure Set_floatFormat(const Value: WideString); safecall;
    function  findFieldEx(aCatalog: THFieldCatalog; const afieldName: WideString): IHField; safecall;
    function  Get_maxRows: Integer; safecall;
    procedure Set_maxRows(Value: Integer); safecall;
    property eof: WordBool read Get_eof;
    property bof: WordBool read Get_bof;
    property fieldCount: Integer read Get_fieldCount;
    property outputCount: Integer read Get_outputCount;
    property returnValue: Integer read Get_returnValue;
    property bookmark: Integer read Get_bookmark write Set_bookmark;
    property fields[index: Integer]: IHField read Get_fields;
    property outputParams[index: Integer]: IHParam read Get_outputParams;
    property available: WordBool read Get_available;
    property sumFieldCount: Integer read Get_sumFieldCount;
    property sumFields[index: Integer]: IHParam read Get_sumFields;
    property moneyFormat: WideString read Get_moneyFormat write Set_moneyFormat;
    property dateFormat: WideString read Get_dateFormat write Set_dateFormat;
    property timeFormat: WideString read Get_timeFormat write Set_timeFormat;
    property dateTimeFormat: WideString read Get_dateTimeFormat write Set_dateTimeFormat;
    property floatFormat: WideString read Get_floatFormat write Set_floatFormat;
    property maxRows: Integer read Get_maxRows write Set_maxRows;
  end;

// *********************************************************************//
// DispIntf:  IHDatasetDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {92BE437B-95A8-11D3-9493-5254AB137D80}
// *********************************************************************//
  IHDatasetDisp = dispinterface
    ['{92BE437B-95A8-11D3-9493-5254AB137D80}']
    procedure first; dispid 1;
    procedure next; dispid 2;
    procedure last; dispid 3;
    procedure prior; dispid 4;
    property eof: WordBool readonly dispid 5;
    property bof: WordBool readonly dispid 6;
    property fieldCount: Integer readonly dispid 8;
    property outputCount: Integer readonly dispid 9;
    property returnValue: Integer readonly dispid 13;
    property bookmark: Integer dispid 7;
    property fields[index: Integer]: IHField readonly dispid 10;
    property outputParams[index: Integer]: IHParam readonly dispid 11;
    function  findField(const fieldName: WideString): IHField; dispid 12;
    function  getRender(purpose: THRenderType): IHResultRender; dispid 14;
    property available: WordBool readonly dispid 15;
    property sumFieldCount: Integer readonly dispid 16;
    property sumFields[index: Integer]: IHParam readonly dispid 17;
    property moneyFormat: WideString dispid 18;
    property dateFormat: WideString dispid 19;
    property timeFormat: WideString dispid 20;
    property dateTimeFormat: WideString dispid 21;
    property floatFormat: WideString dispid 22;
    function  findFieldEx(aCatalog: THFieldCatalog; const afieldName: WideString): IHField; dispid 23;
    property maxRows: Integer dispid 24;
  end;

// *********************************************************************//
// Interface: IHField
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {92BE437D-95A8-11D3-9493-5254AB137D80}
// *********************************************************************//
  IHField = interface(IDispatch)
    ['{92BE437D-95A8-11D3-9493-5254AB137D80}']
    function  Get_fieldName: WideString; safecall;
    function  Get_displayName: WideString; safecall;
    procedure Set_displayName(const Value: WideString); safecall;
    function  Get_fieldSize: Integer; safecall;
    function  Get_fieldType: THFieldType; safecall;
    function  Get_Value: OleVariant; safecall;
    procedure Set_Value(Value: OleVariant); safecall;
    function  Get_asString: WideString; safecall;
    procedure Set_asString(const Value: WideString); safecall;
    function  Get_asInteger: Integer; safecall;
    procedure Set_asInteger(Value: Integer); safecall;
    function  Get_asFloat: Double; safecall;
    procedure Set_asFloat(Value: Double); safecall;
    function  Get_asDatetime: TDateTime; safecall;
    procedure Set_asDatetime(Value: TDateTime); safecall;
    function  Get_asCurrency: Currency; safecall;
    procedure Set_asCurrency(Value: Currency); safecall;
    function  Get_stringFormat: WideString; safecall;
    procedure Set_stringFormat(const Value: WideString); safecall;
    function  Get_asDisplayText: WideString; safecall;
    procedure Set_asDisplayText(const Value: WideString); safecall;
    function  Get_isNull: WordBool; safecall;
    procedure Set_isNull(Value: WordBool); safecall;
    procedure beep; safecall;
    function  Get_isOnlyDate: WordBool; safecall;
    procedure Set_isOnlyDate(Value: WordBool); safecall;
    function  Get_isOnlyTime: WordBool; safecall;
    procedure Set_isOnlyTime(Value: WordBool); safecall;
    function  Get_displayLength: Integer; safecall;
    procedure Set_displayLength(Value: Integer); safecall;
    property fieldName: WideString read Get_fieldName;
    property displayName: WideString read Get_displayName write Set_displayName;
    property fieldSize: Integer read Get_fieldSize;
    property fieldType: THFieldType read Get_fieldType;
    property Value: OleVariant read Get_Value write Set_Value;
    property asString: WideString read Get_asString write Set_asString;
    property asInteger: Integer read Get_asInteger write Set_asInteger;
    property asFloat: Double read Get_asFloat write Set_asFloat;
    property asDatetime: TDateTime read Get_asDatetime write Set_asDatetime;
    property asCurrency: Currency read Get_asCurrency write Set_asCurrency;
    property stringFormat: WideString read Get_stringFormat write Set_stringFormat;
    property asDisplayText: WideString read Get_asDisplayText write Set_asDisplayText;
    property isNull: WordBool read Get_isNull write Set_isNull;
    property isOnlyDate: WordBool read Get_isOnlyDate write Set_isOnlyDate;
    property isOnlyTime: WordBool read Get_isOnlyTime write Set_isOnlyTime;
    property displayLength: Integer read Get_displayLength write Set_displayLength;
  end;

// *********************************************************************//
// DispIntf:  IHFieldDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {92BE437D-95A8-11D3-9493-5254AB137D80}
// *********************************************************************//
  IHFieldDisp = dispinterface
    ['{92BE437D-95A8-11D3-9493-5254AB137D80}']
    property fieldName: WideString readonly dispid 1;
    property displayName: WideString dispid 2;
    property fieldSize: Integer readonly dispid 3;
    property fieldType: THFieldType readonly dispid 4;
    property Value: OleVariant dispid 5;
    property asString: WideString dispid 6;
    property asInteger: Integer dispid 7;
    property asFloat: Double dispid 8;
    property asDatetime: TDateTime dispid 9;
    property asCurrency: Currency dispid 10;
    property stringFormat: WideString dispid 11;
    property asDisplayText: WideString dispid 12;
    property isNull: WordBool dispid 13;
    procedure beep; dispid 14;
    property isOnlyDate: WordBool dispid 15;
    property isOnlyTime: WordBool dispid 16;
    property displayLength: Integer dispid 17;
  end;

// *********************************************************************//
// Interface: IHParam
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {92BE437F-95A8-11D3-9493-5254AB137D80}
// *********************************************************************//
  IHParam = interface(IHField)
    ['{92BE437F-95A8-11D3-9493-5254AB137D80}']
  end;

// *********************************************************************//
// DispIntf:  IHParamDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {92BE437F-95A8-11D3-9493-5254AB137D80}
// *********************************************************************//
  IHParamDisp = dispinterface
    ['{92BE437F-95A8-11D3-9493-5254AB137D80}']
    property fieldName: WideString readonly dispid 1;
    property displayName: WideString dispid 2;
    property fieldSize: Integer readonly dispid 3;
    property fieldType: THFieldType readonly dispid 4;
    property Value: OleVariant dispid 5;
    property asString: WideString dispid 6;
    property asInteger: Integer dispid 7;
    property asFloat: Double dispid 8;
    property asDatetime: TDateTime dispid 9;
    property asCurrency: Currency dispid 10;
    property stringFormat: WideString dispid 11;
    property asDisplayText: WideString dispid 12;
    property isNull: WordBool dispid 13;
    procedure beep; dispid 14;
    property isOnlyDate: WordBool dispid 15;
    property isOnlyTime: WordBool dispid 16;
    property displayLength: Integer dispid 17;
  end;

// *********************************************************************//
// Interface: IHResultRender
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2F149461-970E-11D3-9495-5254AB137D80}
// *********************************************************************//
  IHResultRender = interface(IDispatch)
    ['{2F149461-970E-11D3-9495-5254AB137D80}']
    procedure prepare(initParam: OleVariant; const bindFields: WideString); safecall;
    function  getData(rows: Integer): WideString; safecall;
    function  Get_eof: WordBool; safecall;
    function  Get_seqNo: Integer; safecall;
    property eof: WordBool read Get_eof;
    property seqNo: Integer read Get_seqNo;
  end;

// *********************************************************************//
// DispIntf:  IHResultRenderDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2F149461-970E-11D3-9495-5254AB137D80}
// *********************************************************************//
  IHResultRenderDisp = dispinterface
    ['{2F149461-970E-11D3-9495-5254AB137D80}']
    procedure prepare(initParam: OleVariant; const bindFields: WideString); dispid 1;
    function  getData(rows: Integer): WideString; dispid 2;
    property eof: WordBool readonly dispid 3;
    property seqNo: Integer readonly dispid 4;
  end;

implementation

uses ComObj;

end.
