unit PicClip_TLB;

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

// PASTLWTR : $Revision:   1.11.1.75  $
// File generated on 99-1-22 10:37:36 from Type Library described below.

// ************************************************************************ //
// Type Lib: C:\PWIN98.NEW\SYSTEM\PICCLP32.OCX
// IID\LCID: {27395F88-0C0C-101B-A3C9-08002B2F49FB}\0
// Helpfile: C:\PWIN98.NEW\HELP\PICCLP96.HLP
// HelpString: Microsoft PictureClip Control 5.0
// Version:    1.1
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
  LIBID_PicClip: TGUID = '{27395F88-0C0C-101B-A3C9-08002B2F49FB}';
  IID_IPicClip: TGUID = '{4D6CC9B0-DF77-11CF-8E74-00A0C90F26F8}';
  DIID_DPicClipEvents: TGUID = '{27395F87-0C0C-101B-A3C9-08002B2F49FB}';
  CLASS_PictureClip: TGUID = '{27395F85-0C0C-101B-A3C9-08002B2F49FB}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                  //
// *********************************************************************//
// ErrorConstants constants
type
  ErrorConstants = TOleEnum;
const
  picOutOfMemory = $00000007;
  picSetNotSupported = $0000017F;
  picSetNotPermitted = $0000017F;
  picGetNotSupported = $0000018A;
  picInvalidPictureFormat = $00007D00;
  picDisplayContext = $00007D01;
  picMemDevContext = $00007D02;
  picBitmap = $00007D03;
  picSelBitmapObj = $00007D04;
  picIntPicStruct = $00007D05;
  picBadIndex = $00007D06;
  picNoPicSize = $00007D07;
  picBitmapsOnly = $00007D08;
  picBadClip = $00007D0A;
  picGetObjFailed = $00007D0C;
  picClipBounds = $00007D0F;
  picCellTooSmall = $00007D10;
  picRowNotPositive = $00007D11;
  picColNotPositive = $00007D12;
  picStretchXNegative = $00007D13;
  picStretchYNegative = $00007D14;
  picNoPicture = $00007D15;

type

// *********************************************************************//
// Forward declaration of interfaces defined in Type Library            //
// *********************************************************************//
  IPicClip = interface;
  IPicClipDisp = dispinterface;
  DPicClipEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                     //
// (NOTE: Here we map each CoClass to its Default Interface)            //
// *********************************************************************//
  PictureClip = IPicClip;


// *********************************************************************//
// Interface: IPicClip
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {4D6CC9B0-DF77-11CF-8E74-00A0C90F26F8}
// *********************************************************************//
  IPicClip = interface(IDispatch)
    ['{4D6CC9B0-DF77-11CF-8E74-00A0C90F26F8}']
    function Get__Picture: IPictureDisp; safecall;
    procedure _Set__Picture(const ppPicture: IPictureDisp); safecall;
    procedure Set__Picture(const ppPicture: IPictureDisp); safecall;
    function Get_CellHeight: Smallint; safecall;
    procedure Set_CellHeight(psCellHeight: Smallint); safecall;
    function Get_CellWidth: Smallint; safecall;
    procedure Set_CellWidth(psCellWidth: Smallint); safecall;
    function Get_Clip: IPictureDisp; safecall;
    procedure _Set_Clip(const ppPictureDisp: IPictureDisp); safecall;
    procedure Set_Clip(const ppPictureDisp: IPictureDisp); safecall;
    function Get_ClipHeight: Smallint; safecall;
    procedure Set_ClipHeight(psClipHeight: Smallint); safecall;
    function Get_ClipWidth: Smallint; safecall;
    procedure Set_ClipWidth(psClipWidth: Smallint); safecall;
    function Get_ClipX: Smallint; safecall;
    procedure Set_ClipX(psClipX: Smallint); safecall;
    function Get_ClipY: Smallint; safecall;
    procedure Set_ClipY(psClipY: Smallint); safecall;
    function Get_Cols: Smallint; safecall;
    procedure Set_Cols(psCols: Smallint); safecall;
    function Get_Height: Smallint; safecall;
    procedure Set_Height(psHeight: Smallint); safecall;
    function Get_Picture: IPictureDisp; safecall;
    procedure _Set_Picture(const ppPictureDisp: IPictureDisp); safecall;
    procedure Set_Picture(const ppPictureDisp: IPictureDisp); safecall;
    function Get_Rows: Smallint; safecall;
    procedure Set_Rows(psRows: Smallint); safecall;
    function Get_StretchX: Smallint; safecall;
    procedure Set_StretchX(psStretchX: Smallint); safecall;
    function Get_StretchY: Smallint; safecall;
    procedure Set_StretchY(psStretchY: Smallint); safecall;
    function Get_Width: Smallint; safecall;
    procedure Set_Width(psWidth: Smallint); safecall;
    procedure AboutBox; stdcall;
    function Get_GraphicCell(sIndex: Smallint): IPictureDisp; safecall;
    procedure _Set_GraphicCell(sIndex: Smallint; const ppPictureDisp: IPictureDisp); safecall;
    procedure Set_GraphicCell(sIndex: Smallint; const ppPictureDisp: IPictureDisp); safecall;
    function Get_Hwnd: OLE_HANDLE; safecall;
    procedure Set_Hwnd(phWnd: OLE_HANDLE); safecall;
    property _Picture: IPictureDisp read Get__Picture write _Set__Picture;
    property CellHeight: Smallint read Get_CellHeight write Set_CellHeight;
    property CellWidth: Smallint read Get_CellWidth write Set_CellWidth;
    property Clip: IPictureDisp read Get_Clip write _Set_Clip;
    property ClipHeight: Smallint read Get_ClipHeight write Set_ClipHeight;
    property ClipWidth: Smallint read Get_ClipWidth write Set_ClipWidth;
    property ClipX: Smallint read Get_ClipX write Set_ClipX;
    property ClipY: Smallint read Get_ClipY write Set_ClipY;
    property Cols: Smallint read Get_Cols write Set_Cols;
    property Height: Smallint read Get_Height write Set_Height;
    property Picture: IPictureDisp read Get_Picture write _Set_Picture;
    property Rows: Smallint read Get_Rows write Set_Rows;
    property StretchX: Smallint read Get_StretchX write Set_StretchX;
    property StretchY: Smallint read Get_StretchY write Set_StretchY;
    property Width: Smallint read Get_Width write Set_Width;
    property GraphicCell[sIndex: Smallint]: IPictureDisp read Get_GraphicCell write _Set_GraphicCell;
    property Hwnd: OLE_HANDLE read Get_Hwnd write Set_Hwnd;
  end;

// *********************************************************************//
// DispIntf:  IPicClipDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {4D6CC9B0-DF77-11CF-8E74-00A0C90F26F8}
// *********************************************************************//
  IPicClipDisp = dispinterface
    ['{4D6CC9B0-DF77-11CF-8E74-00A0C90F26F8}']
    property _Picture: IPictureDisp dispid 0;
    property CellHeight: Smallint dispid 11;
    property CellWidth: Smallint dispid 10;
    property Clip: IPictureDisp dispid 14;
    property ClipHeight: Smallint dispid 7;
    property ClipWidth: Smallint dispid 6;
    property ClipX: Smallint dispid 4;
    property ClipY: Smallint dispid 5;
    property Cols: Smallint dispid 3;
    property Height: Smallint dispid 13;
    property Picture: IPictureDisp dispid 1;
    property Rows: Smallint dispid 2;
    property StretchX: Smallint dispid 8;
    property StretchY: Smallint dispid 9;
    property Width: Smallint dispid 12;
    procedure AboutBox; dispid -552;
    property GraphicCell[sIndex: Smallint]: IPictureDisp dispid 15;
    property Hwnd: OLE_HANDLE dispid -515;
  end;

// *********************************************************************//
// DispIntf:  DPicClipEvents
// Flags:     (4112) Hidden Dispatchable
// GUID:      {27395F87-0C0C-101B-A3C9-08002B2F49FB}
// *********************************************************************//
  DPicClipEvents = dispinterface
    ['{27395F87-0C0C-101B-A3C9-08002B2F49FB}']
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TPictureClip
// Help String      : Microsoft PictureClip Control 5.0
// Default Interface: IPicClip
// Def. Intf. DISP? : No
// Event   Interface: DPicClipEvents
// TypeFlags        : (38) CanCreate Licensed Control
// *********************************************************************//
  TPictureClip = class(TOleControl)
  private
    FIntf: IPicClip;
    function  GetControlInterface: IPicClip;
    function Get_GraphicCell(sIndex: Smallint): IPictureDisp;
    procedure _Set_GraphicCell(sIndex: Smallint; const ppPictureDisp: IPictureDisp);
    procedure Set_GraphicCell(sIndex: Smallint; const ppPictureDisp: IPictureDisp);
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure AboutBox;
    property  ControlInterface: IPicClip read GetControlInterface;
    property _Picture: TPicture index 0 read GetTPictureProp write SetTPictureProp;
    property GraphicCell[sIndex: Smallint]: IPictureDisp read Get_GraphicCell write Set_GraphicCell;
  published
    property CellHeight: Smallint index 11 read GetSmallintProp write SetSmallintProp stored False;
    property CellWidth: Smallint index 10 read GetSmallintProp write SetSmallintProp stored False;
    property Clip: TPicture index 14 read GetTPictureProp write SetTPictureProp stored False;
    property ClipHeight: Smallint index 7 read GetSmallintProp write SetSmallintProp stored False;
    property ClipWidth: Smallint index 6 read GetSmallintProp write SetSmallintProp stored False;
    property ClipX: Smallint index 4 read GetSmallintProp write SetSmallintProp stored False;
    property ClipY: Smallint index 5 read GetSmallintProp write SetSmallintProp stored False;
    property Cols: Smallint index 3 read GetSmallintProp write SetSmallintProp stored False;
    property Picture: TPicture index 1 read GetTPictureProp write SetTPictureProp stored False;
    property Rows: Smallint index 2 read GetSmallintProp write SetSmallintProp stored False;
    property StretchX: Smallint index 8 read GetSmallintProp write SetSmallintProp stored False;
    property StretchY: Smallint index 9 read GetSmallintProp write SetSmallintProp stored False;
    property Hwnd: Integer index -515 read GetIntegerProp write SetIntegerProp stored False;
  end;

procedure Register;

implementation

uses ComObj;

procedure TPictureClip.InitControlData;
const
  CLicenseKey: array[0..36] of Word = ( $0044, $0042, $0034, $0043, $0030, $0044, $0030, $0039, $002D, $0034, $0030
    , $0030, $0042, $002D, $0031, $0030, $0031, $0042, $002D, $0041, $0033
    , $0043, $0039, $002D, $0030, $0038, $0030, $0030, $0032, $0042, $0032
    , $0046, $0034, $0039, $0046, $0042, $0000);
  CTPictureIDs: array [0..2] of DWORD = (
    $00000000, $0000000E, $00000001);
  CControlData: TControlData2 = (
    ClassID: '{27395F85-0C0C-101B-A3C9-08002B2F49FB}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: @CLicenseKey;
    Flags: $00000000;
    Version: 401;
    FontCount: 0;
    FontIDs: nil;
    PictureCount: 3;
    PictureIDs: @CTPictureIDs);
begin
  ControlData := @CControlData;
end;

procedure TPictureClip.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IPicClip;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TPictureClip.GetControlInterface: IPicClip;
begin
  CreateControl;
  Result := FIntf;
end;

function TPictureClip.Get_GraphicCell(sIndex: Smallint): IPictureDisp;
begin
  Result := ControlInterface.Get_GraphicCell(sIndex);
end;

procedure TPictureClip._Set_GraphicCell(sIndex: Smallint; const ppPictureDisp: IPictureDisp);
begin
  ControlInterface._Set_GraphicCell(sIndex, ppPictureDisp);
end;

procedure TPictureClip.Set_GraphicCell(sIndex: Smallint; const ppPictureDisp: IPictureDisp);
begin
  ControlInterface.Set_GraphicCell(sIndex, ppPictureDisp);
end;

procedure TPictureClip.AboutBox;
begin
  ControlInterface.AboutBox;
end;

procedure Register;
begin
  RegisterComponents('ActiveX',[TPictureClip]);
end;

end.
