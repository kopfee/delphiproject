unit WHOLib_TLB;

// ************************************************************************ //
// WARNING                                                                  //
// -------                                                                  //
// The types declared in this file were generated from data read from a     //
// Type Library. If this type library is explicitly or indirectly (via      //
// another type library referring to this type library) re-imported, or the //
// 'Refresh' command of the Type Library Editor activated while editing the //
// Type Library, the contents of this file will be regenerated and all      //
// manual modifications will be lost.                                       //
// ************************************************************************ //

// PASTLWTR : $Revision:   1.11.1.62  $
// File generated on 98-12-10 16:36:32 from Type Library described below.

// ************************************************************************ //
// Type Lib: C:\PWIN98.NEW\SYSTEM\WHO.OCX
// IID\LCID: {10729823-6F09-11D2-95C8-444553540000}\0
// Helpfile: C:\PWIN98.NEW\SYSTEM\who.hlp
// HelpString: who ActiveX Control module
// Version:    1.0
// ************************************************************************ //

interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, StdVCL;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:      //
//   Type Libraries     : LIBID_xxxx                                    //
//   CoClasses          : CLASS_xxxx                                    //
//   DISPInterfaces     : DIID_xxxx                                     //
//   Non-DISP interfaces: IID_xxxx                                      //
// *********************************************************************//
const
  LIBID_WHOLib: TGUID = '{10729823-6F09-11D2-95C8-444553540000}';
  DIID__DWho: TGUID = '{10729824-6F09-11D2-95C8-444553540000}';
  DIID__DWhoEvents: TGUID = '{10729825-6F09-11D2-95C8-444553540000}';
  CLASS_who: TGUID = '{10729826-6F09-11D2-95C8-444553540000}';
type

// *********************************************************************//
// Forward declaration of interfaces defined in Type Library            //
// *********************************************************************//
  _DWho = dispinterface;
  _DWhoEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                     //
// (NOTE: Here we map each CoClass to its Default Interface)            //
// *********************************************************************//
  who = _DWho;


// *********************************************************************//
// DispIntf:  _DWho
// Flags:     (4112) Hidden Dispatchable
// GUID:      {10729824-6F09-11D2-95C8-444553540000}
// *********************************************************************//
  _DWho = dispinterface
    ['{10729824-6F09-11D2-95C8-444553540000}']
    property who: WideString dispid 1;
  end;

// *********************************************************************//
// DispIntf:  _DWhoEvents
// Flags:     (4096) Dispatchable
// GUID:      {10729825-6F09-11D2-95C8-444553540000}
// *********************************************************************//
  _DWhoEvents = dispinterface
    ['{10729825-6F09-11D2-95C8-444553540000}']
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : Twho
// Help String      : Who Control
// Default Interface: _DWho
// Def. Intf. DISP? : Yes
// Event   Interface: _DWhoEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  Twho = class(TOleControl)
  private
    FIntf: _DWho;
    function  GetControlInterface: _DWho;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    property  ControlInterface: _DWho read GetControlInterface;
  published
    property who: WideString index 1 read GetWideStringProp write SetWideStringProp stored False;
  end;

procedure Register;

implementation

uses ComObj;

procedure Twho.InitControlData;
const
  CControlData: TControlData = (
    ClassID: '{10729826-6F09-11D2-95C8-444553540000}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: nil;
    Flags: $00000000;
    Version: 300);
begin
  ControlData := @CControlData;
end;

procedure Twho.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as _DWho;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function Twho.GetControlInterface: _DWho;
begin
  CreateControl;
  Result := FIntf;
end;

procedure Register;
begin
  RegisterComponents('ActiveX',[Twho]);
end;

end.
