unit VTXAuto;

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
// File generated on 2001-2-26 16:46:07 from Type Library described below.

// ************************************************************************ //
// Type Lib: C:\WINNT\Speech\vtxtauto.tlb (1)
// IID\LCID: {FF2C7A51-78F9-11CE-B762-00AA004CD65C}\409
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\STDVCL40.DLL)
// Errors:
//   Hint: TypeInfo 'VTxtAuto' changed to 'VTxtAuto_'
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
  VTxtAutoMajorVersion = 1;
  VTxtAutoMinorVersion = 0;

  LIBID_VTxtAuto: TGUID = '{FF2C7A51-78F9-11CE-B762-00AA004CD65C}';

  IID_IVTxtAuto: TGUID = '{FF2C7A50-78F9-11CE-B762-00AA004CD65C}';
  CLASS_VTxtAuto_: TGUID = '{FF2C7A52-78F9-11CE-B762-00AA004CD65C}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum SPEAKFLAGS
type
  SPEAKFLAGS = TOleEnum;
const
  vtxtst_STATEMENT = $00000001;
  vtxtst_QUESTION = $00000002;
  vtxtst_COMMAND = $00000004;
  vtxtst_WARNING = $00000008;
  vtxtst_READING = $00000010;
  vtxtst_NUMBERS = $00000020;
  vtxtst_SPREADSHEET = $00000040;
  vtxtsp_VERYHIGH = $00000080;
  vtxtsp_HIGH = $00000100;
  vtxtsp_NORMAL = $00000200;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IVTxtAuto = interface;
  IVTxtAutoDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  VTxtAuto_ = IVTxtAuto;


// *********************************************************************//
// Interface: IVTxtAuto
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FF2C7A50-78F9-11CE-B762-00AA004CD65C}
// *********************************************************************//
  IVTxtAuto = interface(IDispatch)
    ['{FF2C7A50-78F9-11CE-B762-00AA004CD65C}']
    procedure Register(const pszSite: WideString; const pszApp: WideString); safecall;
    procedure Speak(const pszBuffer: WideString; dwFlags: Integer); safecall;
    procedure StopSpeaking; safecall;
    procedure AudioPause; safecall;
    procedure AudioResume; safecall;
    procedure AudioRewind; safecall;
    procedure AudioFastForward; safecall;
    procedure Set_Callback(const Param1: WideString); safecall;
    procedure Set_Speed(pdwSpeed: Integer); safecall;
    function  Get_Speed: Integer; safecall;
    procedure Set_Enabled(pdwEnabled: Integer); safecall;
    function  Get_Enabled: Integer; safecall;
    function  Get_IsSpeaking: WordBool; safecall;
    property Callback: WideString write Set_Callback;
    property Speed: Integer write Set_Speed;
    property Enabled: Integer write Set_Enabled;
    property IsSpeaking: WordBool read Get_IsSpeaking;
  end;

// *********************************************************************//
// DispIntf:  IVTxtAutoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FF2C7A50-78F9-11CE-B762-00AA004CD65C}
// *********************************************************************//
  IVTxtAutoDisp = dispinterface
    ['{FF2C7A50-78F9-11CE-B762-00AA004CD65C}']
    procedure Register(const pszSite: WideString; const pszApp: WideString); dispid 1610743808;
    procedure Speak(const pszBuffer: WideString; dwFlags: Integer); dispid 1610743809;
    procedure StopSpeaking; dispid 1610743810;
    procedure AudioPause; dispid 1610743811;
    procedure AudioResume; dispid 1610743812;
    procedure AudioRewind; dispid 1610743813;
    procedure AudioFastForward; dispid 1610743814;
    property Callback: WideString writeonly dispid 1610743815;
    property Speed: Integer writeonly dispid 1610743816;
    property Enabled: Integer writeonly dispid 1610743818;
    property IsSpeaking: WordBool readonly dispid 1610743820;
  end;

// *********************************************************************//
// The Class CoVTxtAuto_ provides a Create and CreateRemote method to          
// create instances of the default interface IVTxtAuto exposed by              
// the CoClass VTxtAuto_. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoVTxtAuto_ = class
    class function Create: IVTxtAuto;
    class function CreateRemote(const MachineName: string): IVTxtAuto;
  end;

implementation

uses ComObj;

class function CoVTxtAuto_.Create: IVTxtAuto;
begin
  Result := CreateComObject(CLASS_VTxtAuto_) as IVTxtAuto;
end;

class function CoVTxtAuto_.CreateRemote(const MachineName: string): IVTxtAuto;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_VTxtAuto_) as IVTxtAuto;
end;

end.
