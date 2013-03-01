unit ImageLibX;

{
  adapted from DLL95V1
}

{$DEFINE DEL32}

{$DEFINE ILTRIAL}
{.$DEFINE ILINST}

{
Written by Jan Dekkers and Kevin Adams (c) 1994, 1995, 1996. If you are
a non registered client, you may use or alter this demo only for
evaluation purposes.

Copyright by SkyLine Tools. All rights reserved.

Part of Imagelib (TM) VCL/DLL Library.
}


{$X+,I-,R-,F+,T-}   {<<<<  This is a switch. Don't delete it}
{$C PRELOAD}

interface
{------------------------------------------------------------------------}

uses
{$IFDEF DEL32}
  Windows,
{$ELSE}
  WinTypes,
  WinProcs,
{$ENDIF}
  Graphics,
  SYSUtils,
  Dialogs,
  Classes,
  Controls,
  StdCtrls,
  ExtCtrls,
  Messages;


{------------------------------------------------------------------------}
var
 {Incase this palette is <> 0 then reading images will use this palette
 This can be handy when 2 images need to be displayed on one form}
 GlobalPalette : HPalette;

{------------------------------------------------------------------------}
type
 TCallBackFunction = function (I : Integer) : Integer cdecl;

{------------------------------------------------------------------------}

Type
  PBitmapInfoHeader = ^TBitmapInfoHeader;     { Ptr to Win 3.0 DIB header }
  PBitmapCoreHeader = ^TBitmapCoreHeader;     { Ptr to OS/2 1.x DIB header }
  HGlobal           =  THandle;
{$IFDEF DEL32}
  MHandle           =  HMODULE;
{$ELSE}
  MHandle           =  THandle;
{$ENDIF}


{------------------------------------------------------------------------}

type
  TLoadResolution = (lColorVga,
                     lMonoChrome,
                     lColor16,
                     lColor256,
                     lColorTrue,
                     lAutoMatic);
{------------------------------------------------------------------------}

type
  TSaveResolution = (sColorVga,
                     sMonoChrome,
                     sColor16,
                     sColor256,
                     sColorTrue,
                     sJpegGray,
                     sAutoMatic);
{------------------------------------------------------------------------}

type
  TTiffCompression = (sNONE,
                      sCCITT,
                      sLZW,
                      sPACKBITS);
{------------------------------------------------------------------------}

Const
  WM_Trigger =  WM_USER + 1;
  WM_CTrigger = WM_USER + 2;
  WM_DBRE_MODIFIED = WM_USER + 3;

{------------------------------------------------------------------------}
Const
  {Password to use the LZW (Gif and Tiff)}
  unilzw = 'XXXXX';

(**********  PNG  ******************)

{------------------------------------------------------------------------}

{DLL call}
Function readpngfile(Filename      : pChar;
                     Resolution    : SmallInt;
                     Dither        : SmallInt;
                 var hBMP          : HBitmap;
                 var HPAL          : HPalette;
                 CallBackFunction  : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                           {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function writepngfile(Filename     : pChar;
                      Resolution   : SmallInt;
                      Interlaced   : SmallInt;
                      hBMP         : HBitmap;
                      HPAL         : HPalette;
              CallBackFunction     : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                           {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function  writepngstream(FilePoint : Pointer;
                     var Size      : LongInt;
                         Resolution: SmallInt;
                         Interlaced: SmallInt;
                         hBMP      : HBitmap;
                         HPAL      : HPalette;
                  CallBackFunction : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function readpngstream(FilePoint   : Pointer;
                       Size        : LongInt;
                       Resolution  : SmallInt;
                       Dither      : SmallInt;
                   var hBMP        : HBitmap;
                   var HPAL        : HPalette;
                   CallBackFunction: TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
 {------------------------------------------------------------------------}

 (**********  JPEG  ******************)

{DLL call}
Function readjpgstream(FilePoint   : Pointer;
                       Size        : LongInt;
                       Resolution  : SmallInt;
                       Scale       : SmallInt;
                       Dither      : SmallInt;
                   var hBMP        : HBitmap;
                   var HPAL        : HPalette;
                   CallBackFunction: TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function readjpgfile(Filename      : pChar;
                     Resolution    : SmallInt;
                     Scale         : SmallInt;
                     Dither        : SmallInt;
                 var hBMP          : HBitmap;
                 var HPAL          : HPalette;
                 CallBackFunction  : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function writejpgfile(Filename     : pChar;
                      Quality      : SmallInt;
                      Smooth       : SmallInt;
                      Resolution   : SmallInt;
                      hBMP         : HBitmap;
                      HPAL         : HPalette;
              CallBackFunction     : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function writebmpfile(Filename     : pChar;
                      Resolution   : SmallInt;
                      hBMP         : HBitmap;
                      HPAL         : HPalette;
              CallBackFunction     : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function writegiffile(Filename     : pChar;
                      Resolution   : SmallInt;
                      hBMP         : HBitmap;
                      HPAL         : HPalette;
              CallBackFunction     : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt;
                      LZWPassW     : PChar) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function writepcxfile(Filename     : pChar;
                      Resolution   : SmallInt;
                      hBMP         : HBitmap;
                      HPAL         : HPalette;
              CallBackFunction     : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function readgiffile(Filename      : pChar;
                     Resolution    : SmallInt;
                     Dither        : SmallInt;
                 var hBMP          : HBitmap;
                 var HPAL          : HPalette;
                 CallBackFunction  : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt;
                     LZWPassW      : PChar) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function readbmpfile(Filename      : pChar;
                     Resolution    : SmallInt;
                     Dither        : SmallInt;
                 var hBMP          : HBitmap;
                 var HPAL          : HPalette;
                 CallBackFunction  : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function readpcxfile(Filename      : pChar;
                     Resolution    : SmallInt;
                     Dither        : SmallInt;
                 var hBMP          : HBitmap;
                 var HPAL          : HPalette;
                 CallBackFunction  : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function readpcxstream(FilePoint   : Pointer;
                       Size        : LongInt;
                       Resolution  : SmallInt;
                       Dither      : SmallInt;
                   var hBMP        : HBitmap;
                   var HPAL        : HPalette;
                   CallBackFunction: TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function readbmpstream(FilePoint   : Pointer;
                       Size        : LongInt;
                       Resolution  : SmallInt;
                       Dither      : SmallInt;
                   var hBMP        : HBitmap;
                   var HPAL        : HPalette;
                   CallBackFunction: TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function readgifstream(FilePoint   : Pointer;
                       Size        : LongInt;
                       Resolution  : SmallInt;
                       Dither      : SmallInt;
                   var hBMP        : HBitmap;
                   var HPAL        : HPalette;
                   CallBackFunction: TCallBackFunction;
                   ShowDllErrorMsg : SmallInt;
                       LZWPassW    : PChar) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function streaminfo(FilePoint      : Pointer;
                    Size           : LongInt;
                    FileType       : PChar;
                var Fwidth         : SmallInt;
                var FHeight        : SmallInt;
                var Fbitspixel     : SmallInt;
                var Fplanes        : SmallInt;
                var Fnumcolors     : SmallInt;
                    Fcompression   : PChar;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function   fileinfo(Filename       : PChar;
                    FileType       : PChar;
                var Fwidth         : SmallInt;
                var FHeight        : SmallInt;
                var Fbitspixel     : SmallInt;
                var Fplanes        : SmallInt;
                var Fnumcolors     : SmallInt;
                    Fcompression   : PChar;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function writejpgstream(FilePoint : Pointer;
                     var Size      : LongInt;
                         Quality   : SmallInt;
                         Smooth    : SmallInt;
                         Resolution: SmallInt;
                         hBMP      : HBitmap;
                         HPAL      : HPalette;
                  CallBackFunction : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function  writebmpstream(FilePoint : Pointer;
                     var Size      : LongInt;
                         Resolution: SmallInt;
                         hBMP      : HBitmap;
                         HPAL      : HPalette;
                  CallBackFunction : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function  writegifstream(FilePoint : Pointer;
                     var Size      : LongInt;
                         Resolution: SmallInt;
                         hBMP      : HBitmap;
                         HPAL      : HPalette;
                  CallBackFunction : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt;
                         LZWPassW  : PChar) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function  writepcxstream(FilePoint : Pointer;
                     var Size      : LongInt;
                         Resolution: SmallInt;
                         hBMP      : HBitmap;
                         HPAL      : HPalette;
                  CallBackFunction : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function READTIFFILE(Filename      : pChar;
                     Resolution    : SmallInt;
                     Dither        : SmallInt;
                 var hBMP          : HBitmap;
                 var HPAL          : HPalette;
                 CallBackFunction  : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt;
                     LZWPassW      : PChar) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function READTIFSTREAM(FilePoint   : Pointer;
                       Size        : LongInt;
                       Resolution  : SmallInt;
                       Dither      : SmallInt;
                   var hBMP        : HBitmap;
                   var HPAL        : HPalette;
                   CallBackFunction: TCallBackFunction;
                   ShowDllErrorMsg : SmallInt;
                       LZWPassW    : PChar) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function WRITETIFFILE(Filename     : pChar;
                      Compression  : Word;
                      Stripsize    : SmallInt;
                      Resolution   : SmallInt;
                      hBMP         : HBitmap;
                      HPAL         : HPalette;
              CallBackFunction     : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt;
                      LZWPassW     : PChar) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function  WRITETIFSTREAM(FilePoint : Pointer;
                     var Size      : LongInt;
                         Compression:SmallInt;
                         Stripsize : SmallInt;
                         Resolution: SmallInt;
                         hBMP      : HBitmap;
                         HPAL      : HPalette;
                  CallBackFunction : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt;
                         LZWPassW  : PChar) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function REDUCEDIB : SmallInt; {$IFDEF DEL32}
                                StdCall;
                               {$ELSE}
                                Far;
                               {$ENDIF}

{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function DIBTODDB(PDib : Pointer;
              var hBMP : HBitmap;
              var HPAL : HPalette) : SmallInt; {$IFDEF DEL32}
                                                 StdCall;
                                                {$ELSE}
                                                  Far;
                                                {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function RDJPGFILEDIB(Const Filename: pChar;
                      Resolution    : SmallInt;
                      Scale         : SmallInt;
                      Dither        : SmallInt;
                  var hDIB          : Thandle;
                      HPAL          : HPalette;
                  CallBackFunction  : TCallBackFunction;
                  ShowDllErrorMsg   : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                              StdCall;
                                                            {$ELSE}
                                                               Far;
                                                            {$ENDIF}

{------------------------------------------------------------------------}

{DLL call}
Function WRJPGFILEDIB : SmallInt; {$IFDEF DEL32}
                                   StdCall;
                                 {$ELSE}
                                   Far;
                                 {$ENDIF}

{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function RDTIFFILEDIB(Const Filename: pChar;
                      Resolution    : SmallInt;
                      Dither        : SmallInt;
                  var hDIB          : Thandle;
                      HPAL          : HPalette;
                  CallBackFunction  : TCallBackFunction;
                  ShowDllErrorMsg   : SmallInt;
                     LZWPassW       : PChar) : SmallInt; {$IFDEF DEL32}
                                                              StdCall;
                                                            {$ELSE}
                                                               Far;
                                                            {$ENDIF}

{------------------------------------------------------------------------}

{DLL call}
Function RDTIFSTREAMDIB : SmallInt; {$IFDEF DEL32}
                                     StdCall;
                                    {$ELSE}
                                     Far;
                                   {$ENDIF}

{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function WRTIFFILEDIB : SmallInt; {$IFDEF DEL32}
                                   StdCall;
                                 {$ELSE}
                                   Far;
                                 {$ENDIF}

{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function WRTIFSTREAMDIB : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}

{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function RDGIFFILEDIB(Const Filename: pChar;
                      Resolution    : SmallInt;
                      Dither        : SmallInt;
                  var hDIB          : Word;
                      HPAL          : HPalette;
                  CallBackFunction  : TCallBackFunction;
                  ShowDllErrorMsg   : SmallInt;
                      LZWPassW      : PChar) :  SmallInt; {$IFDEF DEL32}
                                                              StdCall;
                                                            {$ELSE}
                                                               Far;
                                                            {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function RDPCXFILEDIB(Const Filename: pChar;
                      Resolution    : SmallInt;
                      Dither        : SmallInt;
                  var hDIB          : Word;
                      HPAL          : HPalette;
                  CallBackFunction  : TCallBackFunction;
                  ShowDllErrorMsg   : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                              StdCall;
                                                            {$ELSE}
                                                               Far;
                                                            {$ENDIF}

{------------------------------------------------------------------------}

{DLL call}
Function RDJPGSTREAMDIB : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}

{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function RDPCXSTREAMDIB : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}

{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function RDGIFSTREAMDIB : SmallInt; {$IFDEF DEL32}
                                     StdCall;
                                   {$ELSE}
                                     Far;
                                   {$ENDIF}

{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function WRJPGSTREAMDIB : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}

{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function RDBMPSTREAMDIB : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}

{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function WRBMPSTREAMDIB : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}

{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function RDBMPFILEDIB(Const Filename: pChar;
                      Resolution    : SmallInt;
                      Dither        : SmallInt;
                  var hDIB          : Thandle;
                      HPAL          : HPalette;
                  CallBackFunction  : TCallBackFunction;
                  ShowDllErrorMsg   : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                              StdCall;
                                                            {$ELSE}
                                                               Far;
                                                            {$ENDIF}

{------------------------------------------------------------------------}

{DLL call}
Function WRBMPFILEDIB : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}


{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function RDPNGFILEDIB(Const Filename: pChar;
                      Resolution    : SmallInt;
                      Dither        : SmallInt;
                  var hDIB          : Thandle;
                      HPAL          : HPalette;
                  CallBackFunction  : TCallBackFunction;
                  ShowDllErrorMsg   : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                              StdCall;
                                                            {$ELSE}
                                                               Far;
                                                            {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function RDPNGSTREAMDIB : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}

{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function WRPNGFILEDIB : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}

{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function WRPNGSTREAMDIB : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}

{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function WRGIFFILEDIB : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}

{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function WRGIFSTREAMDIB : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}

{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function WRPCXFILEDIB : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}

{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function WRPCXSTREAMDIB : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}

{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function DDBTODIB : SmallInt; {$IFDEF DEL32}
                               StdCall;
                              {$ELSE}
                               Far;
                              {$ENDIF}

{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function AQUIREIMAGE  (HWind       : HWnd;
                       Resolution  : SmallInt;
                       Dither      : SmallInt;
                       wHide       : SmallInt;
                   var hBMP        : HBitmap;
                   var HPAL        : HPalette;
                   CallBackFunction: TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function SELECTSOURCE (HWind : HWnd;
                       ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                                 StdCall;
                                                               {$ELSE}
                                                                 Far;
                                                                {$ENDIF}

{------------------------------------------------------------------------}

{DLL call}
Function TWAINAVAILABLE (HWind : HWnd;
                         ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                                 StdCall;
                                                               {$ELSE}
                                                                 Far;
                                                                {$ENDIF}
{------------------------------------------------------------------------}

{$IFNDEF ILTRIAL}
Function INITDLL(HWind : HWnd;
              Password : PChar) : SmallInt; {$IFDEF DEL32}
                                             StdCall;
                                           {$ELSE}
                                             Far;
                                           {$ENDIF}
{$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function  ROTATEDDB90(Resolution  : SmallInt;
                 var hBMP         : HBitmap;
                 var HPAL         : HPalette;
                  ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function ROTATEDDB180(Resolution  : SmallInt;
                 var hBMP         : HBitmap;
                 var HPAL         : HPalette;
                  ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}
{DLL call}
Function   FLIPDDB  (Resolution  : SmallInt;
                var hBMP         : HBitmap;
                var HPAL         : HPalette;
                 ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
Implementation

const
	ImageLibDLL = 'Sky32dem.dll';

{DLL call}
Function readpngfile(Filename      : pChar;
                     Resolution    : SmallInt;
                     Dither        : SmallInt;
                 var hBMP          : HBitmap;
                 var HPAL          : HPalette;
                 CallBackFunction  : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'readpngfile';
{------------------------------------------------------------------------}

{DLL call}
Function writepngfile(Filename     : pChar;
                      Resolution   : SmallInt;
                      Interlaced   : SmallInt;
                      hBMP         : HBitmap;
                      HPAL         : HPalette;
              CallBackFunction     : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'writepngfile';
{------------------------------------------------------------------------}

{DLL call}
Function  writepngstream(FilePoint : Pointer;
                     var Size      : LongInt;
                         Resolution: SmallInt;
                         Interlaced: SmallInt;
                         hBMP      : HBitmap;
                         HPAL      : HPalette;
                  CallBackFunction : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'writepngstream';
{------------------------------------------------------------------------}

{DLL call}
Function readpngstream(FilePoint   : Pointer;
                       Size        : LongInt;
                       Resolution  : SmallInt;
                       Dither      : SmallInt;
                   var hBMP        : HBitmap;
                   var HPAL        : HPalette;
                   CallBackFunction: TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'readpngstream';
 {------------------------------------------------------------------------}

{DLL call}
Function readjpgstream(FilePoint   : Pointer;
                       Size        : LongInt;
                       Resolution  : SmallInt;
                       Scale       : SmallInt;
                       Dither      : SmallInt;
                   var hBMP        : HBitmap;
                   var HPAL        : HPalette;
                   CallBackFunction: TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'readjpgstream';
{------------------------------------------------------------------------}

{DLL call}
Function readjpgfile(Filename      : pChar;
                     Resolution    : SmallInt;
                     Scale         : SmallInt;
                     Dither        : SmallInt;
                 var hBMP          : HBitmap;
                 var HPAL          : HPalette;
                 CallBackFunction  : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'readjpgfile';
{------------------------------------------------------------------------}

{DLL call}
Function writejpgfile(Filename     : pChar;
                      Quality      : SmallInt;
                      Smooth       : SmallInt;
                      Resolution   : SmallInt;
                      hBMP         : HBitmap;
                      HPAL         : HPalette;
              CallBackFunction     : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'writejpgfile';
{------------------------------------------------------------------------}

{DLL call}
Function writebmpfile(Filename     : pChar;
                      Resolution   : SmallInt;
                      hBMP         : HBitmap;
                      HPAL         : HPalette;
              CallBackFunction     : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'writebmpfile';
{------------------------------------------------------------------------}

{DLL call}
Function writegiffile(Filename     : pChar;
                      Resolution   : SmallInt;
                      hBMP         : HBitmap;
                      HPAL         : HPalette;
              CallBackFunction     : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt;
                      LZWPassW     : PChar) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'writegiffile';
{------------------------------------------------------------------------}

{DLL call}
Function writepcxfile(Filename     : pChar;
                      Resolution   : SmallInt;
                      hBMP         : HBitmap;
                      HPAL         : HPalette;
              CallBackFunction     : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'writepcxfile';
{------------------------------------------------------------------------}

{DLL call}
Function readgiffile(Filename      : pChar;
                     Resolution    : SmallInt;
                     Dither        : SmallInt;
                 var hBMP          : HBitmap;
                 var HPAL          : HPalette;
                 CallBackFunction  : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt;
                     LZWPassW      : PChar) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'readgiffile';
{------------------------------------------------------------------------}

{DLL call}
Function readbmpfile(Filename      : pChar;
                     Resolution    : SmallInt;
                     Dither        : SmallInt;
                 var hBMP          : HBitmap;
                 var HPAL          : HPalette;
                 CallBackFunction  : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'readbmpfile';
{------------------------------------------------------------------------}

{DLL call}
Function readpcxfile(Filename      : pChar;
                     Resolution    : SmallInt;
                     Dither        : SmallInt;
                 var hBMP          : HBitmap;
                 var HPAL          : HPalette;
                 CallBackFunction  : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'readpcxfile';
{------------------------------------------------------------------------}

{DLL call}
Function readpcxstream(FilePoint   : Pointer;
                       Size        : LongInt;
                       Resolution  : SmallInt;
                       Dither      : SmallInt;
                   var hBMP        : HBitmap;
                   var HPAL        : HPalette;
                   CallBackFunction: TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'readpcxstream';
{------------------------------------------------------------------------}

{DLL call}
Function readbmpstream(FilePoint   : Pointer;
                       Size        : LongInt;
                       Resolution  : SmallInt;
                       Dither      : SmallInt;
                   var hBMP        : HBitmap;
                   var HPAL        : HPalette;
                   CallBackFunction: TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'readbmpstream';
{------------------------------------------------------------------------}

{DLL call}
Function readgifstream(FilePoint   : Pointer;
                       Size        : LongInt;
                       Resolution  : SmallInt;
                       Dither      : SmallInt;
                   var hBMP        : HBitmap;
                   var HPAL        : HPalette;
                   CallBackFunction: TCallBackFunction;
                   ShowDllErrorMsg : SmallInt;
                       LZWPassW    : PChar) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'readgifstream';
{------------------------------------------------------------------------}

{DLL call}
Function streaminfo(FilePoint      : Pointer;
                    Size           : LongInt;
                    FileType       : PChar;
                var Fwidth         : SmallInt;
                var FHeight        : SmallInt;
                var Fbitspixel     : SmallInt;
                var Fplanes        : SmallInt;
                var Fnumcolors     : SmallInt;
                    Fcompression   : PChar;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'streaminfo';
{------------------------------------------------------------------------}

{DLL call}
Function   fileinfo(Filename       : PChar;
                    FileType       : PChar;
                var Fwidth         : SmallInt;
                var FHeight        : SmallInt;
                var Fbitspixel     : SmallInt;
                var Fplanes        : SmallInt;
                var Fnumcolors     : SmallInt;
                    Fcompression   : PChar;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'fileinfo';
{------------------------------------------------------------------------}

{DLL call}
Function writejpgstream(FilePoint : Pointer;
                     var Size      : LongInt;
                         Quality   : SmallInt;
                         Smooth    : SmallInt;
                         Resolution: SmallInt;
                         hBMP      : HBitmap;
                         HPAL      : HPalette;
                  CallBackFunction : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'writejpgstream';
{------------------------------------------------------------------------}

{DLL call}
Function  writebmpstream(FilePoint : Pointer;
                     var Size      : LongInt;
                         Resolution: SmallInt;
                         hBMP      : HBitmap;
                         HPAL      : HPalette;
                  CallBackFunction : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'writebmpstream';
{------------------------------------------------------------------------}

{DLL call}
Function  writegifstream(FilePoint : Pointer;
                     var Size      : LongInt;
                         Resolution: SmallInt;
                         hBMP      : HBitmap;
                         HPAL      : HPalette;
                  CallBackFunction : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt;
                         LZWPassW  : PChar) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'writegifstream';
{------------------------------------------------------------------------}

{DLL call}
Function  writepcxstream(FilePoint : Pointer;
                     var Size      : LongInt;
                         Resolution: SmallInt;
                         hBMP      : HBitmap;
                         HPAL      : HPalette;
                  CallBackFunction : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'writepcxstream';
{------------------------------------------------------------------------}

{DLL call}
Function readtiffile(Filename      : pChar;
                     Resolution    : SmallInt;
                     Dither        : SmallInt;
                 var hBMP          : HBitmap;
                 var HPAL          : HPalette;
                 CallBackFunction  : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt;
                     LZWPassW      : PChar) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'readtiffile';
{------------------------------------------------------------------------}

{DLL call}
Function readtifstream(FilePoint   : Pointer;
                       Size        : LongInt;
                       Resolution  : SmallInt;
                       Dither      : SmallInt;
                   var hBMP        : HBitmap;
                   var HPAL        : HPalette;
                   CallBackFunction: TCallBackFunction;
                   ShowDllErrorMsg : SmallInt;
                       LZWPassW    : PChar) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'readtifstream';
{------------------------------------------------------------------------}

{DLL call}
Function writetiffile(Filename     : pChar;
                      Compression  : Word;
                      Stripsize    : SmallInt;
                      Resolution   : SmallInt;
                      hBMP         : HBitmap;
                      HPAL         : HPalette;
              CallBackFunction     : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt;
                      LZWPassW     : PChar) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'writetiffile';
{------------------------------------------------------------------------}

{DLL call}
Function  writetifstream(FilePoint : Pointer;
                     var Size      : LongInt;
                         Compression:SmallInt;
                         Stripsize : SmallInt;
                         Resolution: SmallInt;
                         hBMP      : HBitmap;
                         HPAL      : HPalette;
                  CallBackFunction : TCallBackFunction;
                   ShowDllErrorMsg : SmallInt;
                         LZWPassW  : PChar) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'writetifstream';
{------------------------------------------------------------------------}

{DLL call}
Function reducedib : SmallInt; {$IFDEF DEL32}
                                StdCall;
                               {$ELSE}
                                Far;
                               {$ENDIF}
External ImageLibDLL name 'reducedib';
{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function dibtoddb(PDib : Pointer;
              var hBMP : HBitmap;
              var HPAL : HPalette) : SmallInt; {$IFDEF DEL32}
                                                 StdCall;
                                                {$ELSE}
                                                  Far;
                                                {$ENDIF}
External ImageLibDLL name 'dibtoddb';
{------------------------------------------------------------------------}

{DLL call}
Function rdjpgfiledib(Const Filename: pChar;
                      Resolution    : SmallInt;
                      Scale         : SmallInt;
                      Dither        : SmallInt;
                  var hDIB          : Thandle;
                      HPAL          : HPalette;
                  CallBackFunction  : TCallBackFunction;
                  ShowDllErrorMsg   : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                              StdCall;
                                                            {$ELSE}
                                                               Far;
                                                            {$ENDIF}
External ImageLibDLL name 'rdjpgfiledib';

{------------------------------------------------------------------------}

{DLL call}
Function wrjpgfiledib : SmallInt; {$IFDEF DEL32}
                                   StdCall;
                                 {$ELSE}
                                   Far;
                                 {$ENDIF}
External ImageLibDLL name 'wrjpgfiledib';
{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function rdtiffiledib(Const Filename: pChar;
                      Resolution    : SmallInt;
                      Dither        : SmallInt;
                  var hDIB          : Thandle;
                      HPAL          : HPalette;
                  CallBackFunction  : TCallBackFunction;
                  ShowDllErrorMsg   : SmallInt;
                     LZWPassW       : PChar) : SmallInt; {$IFDEF DEL32}
                                                              StdCall;
                                                            {$ELSE}
                                                               Far;
                                                            {$ENDIF}
External ImageLibDLL name 'rdtiffiledib';
{------------------------------------------------------------------------}

{DLL call}
Function rdtifstreamdib : SmallInt; {$IFDEF DEL32}
                                     StdCall;
                                    {$ELSE}
                                     Far;
                                   {$ENDIF}
External ImageLibDLL name 'rdtifstreamdib';
{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function wrtiffiledib : SmallInt; {$IFDEF DEL32}
                                   StdCall;
                                 {$ELSE}
                                   Far;
                                 {$ENDIF}
External ImageLibDLL name 'wrtiffiledib';
{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function wrtifstreamdib : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}
External ImageLibDLL name 'wrtifstreamdib';
{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function rdgiffiledib(Const Filename: pChar;
                      Resolution    : SmallInt;
                      Dither        : SmallInt;
                  var hDIB          : Word;
                      HPAL          : HPalette;
                  CallBackFunction  : TCallBackFunction;
                  ShowDllErrorMsg   : SmallInt;
                      LZWPassW      : PChar) :  SmallInt; {$IFDEF DEL32}
                                                              StdCall;
                                                            {$ELSE}
                                                               Far;
                                                            {$ENDIF}
External ImageLibDLL name 'rdgiffiledib';
{------------------------------------------------------------------------}

{DLL call}
Function rdpcxfiledib(Const Filename: pChar;
                      Resolution    : SmallInt;
                      Dither        : SmallInt;
                  var hDIB          : Word;
                      HPAL          : HPalette;
                  CallBackFunction  : TCallBackFunction;
                  ShowDllErrorMsg   : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                              StdCall;
                                                            {$ELSE}
                                                               Far;
                                                            {$ENDIF}
External ImageLibDLL name 'rdpcxfiledib';

{------------------------------------------------------------------------}

{DLL call}
Function rdjpgstreamdib : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}
External ImageLibDLL name 'rdjpgstreamdib';

{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function rdpcxstreamdib : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}
External ImageLibDLL name 'rdpcxstreamdib';
{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function rdgifstreamdib : SmallInt; {$IFDEF DEL32}
                                     StdCall;
                                   {$ELSE}
                                     Far;
                                   {$ENDIF}
External ImageLibDLL name 'rdgifstreamdib';
{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function wrjpgstreamdib : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}
External ImageLibDLL name 'wrjpgstreamdib';
{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function rdbmpstreamdib : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}
External ImageLibDLL name 'rdbmpstreamdib';
{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function wrbmpstreamdib : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}
External ImageLibDLL name 'wrbmpstreamdib';
{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function rdbmpfiledib(Const Filename: pChar;
                      Resolution    : SmallInt;
                      Dither        : SmallInt;
                  var hDIB          : Thandle;
                      HPAL          : HPalette;
                  CallBackFunction  : TCallBackFunction;
                  ShowDllErrorMsg   : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                              StdCall;
                                                            {$ELSE}
                                                               Far;
                                                            {$ENDIF}
External ImageLibDLL name 'rdbmpfiledib';

{------------------------------------------------------------------------}

{DLL call}
Function wrbmpfiledib : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}
External ImageLibDLL name 'wrbmpfiledib';

{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function rdpngfiledib(Const Filename: pChar;
                      Resolution    : SmallInt;
                      Dither        : SmallInt;
                  var hDIB          : Thandle;
                      HPAL          : HPalette;
                  CallBackFunction  : TCallBackFunction;
                  ShowDllErrorMsg   : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                              StdCall;
                                                            {$ELSE}
                                                               Far;
                                                            {$ENDIF}
External ImageLibDLL name 'rdpngfiledib';
{------------------------------------------------------------------------}

{DLL call}
Function rdpngstreamdib : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}
External ImageLibDLL name 'rdpngstreamdib';
{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function wrpngfiledib : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}
External ImageLibDLL name 'wrpngfiledib';
{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function wrpngstreamdib : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}
External ImageLibDLL name 'wrpngstreamdib';
{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function wrgiffiledib : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}
External ImageLibDLL name 'wrgiffiledib';
{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function wrgifstreamdib : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}
External ImageLibDLL name 'wrgifstreamdib';
{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function wrpcxfiledib : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}
External ImageLibDLL name 'wrpcxfiledib';
{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function WRPCXSTREAMDIB : SmallInt; {$IFDEF DEL32}
                                    StdCall;
                                   {$ELSE}
                                    Far;
                                   {$ENDIF}
External ImageLibDLL name 'WRPCXSTREAMDIB';
{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function ddbtodib : SmallInt; {$IFDEF DEL32}
                               StdCall;
                              {$ELSE}
                               Far;
                              {$ENDIF}
External ImageLibDLL name 'ddbtodib';
{This DIB DLL Call is Not used in this version}
{------------------------------------------------------------------------}

{DLL call}
Function aquireimage  (HWind       : HWnd;
                       Resolution  : SmallInt;
                       Dither      : SmallInt;
                       wHide       : SmallInt;
                   var hBMP        : HBitmap;
                   var HPAL        : HPalette;
                   CallBackFunction: TCallBackFunction;
                   ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'aquireimage';
{------------------------------------------------------------------------}

{DLL call}
Function selectsource (HWind : HWnd;
                       ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                                 StdCall;
                                                               {$ELSE}
                                                                 Far;
                                                                {$ENDIF}
External ImageLibDLL name 'selectsource';

{------------------------------------------------------------------------}

{DLL call}
Function twainavailable (HWind : HWnd;
                         ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                                 StdCall;
                                                               {$ELSE}
                                                                 Far;
                                                                {$ENDIF}
External ImageLibDLL name 'twainavailable';
{------------------------------------------------------------------------}

{$IFNDEF ILTRIAL}
Function initdll(HWind : HWnd;
              Password : PChar) : SmallInt; {$IFDEF DEL32}
                                             StdCall;
                                           {$ELSE}
                                             Far;
                                           {$ENDIF}
External ImageLibDLL name 'initdll';
{$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function  rotateddb90(Resolution  : SmallInt;
                 var hBMP         : HBitmap;
                 var HPAL         : HPalette;
                  ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'rotateddb90';
{------------------------------------------------------------------------}

{DLL call}
Function rotateddb180(Resolution  : SmallInt;
                 var hBMP         : HBitmap;
                 var HPAL         : HPalette;
                  ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'rotateddb180';
{------------------------------------------------------------------------}
{DLL call}
Function   flipddb  (Resolution  : SmallInt;
                var hBMP         : HBitmap;
                var HPAL         : HPalette;
                 ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF DEL32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
External ImageLibDLL name 'flipddb';
{------------------------------------------------------------------------}


end.




