unit MathLink;

interface

// #define APIENTRY far pascal
// It is to say that all calls are pascal-calls.

type
  mlapi_token = Longint;
  MLINK = Pointer;
  mldlg_result = Longint;
  MLEnvironment = Pointer;
  MLParametersPointer = PChar;
  kcharp_ct = PChar;
  // longp_ct = ^Longint; => var X : Longint

// begin const
// from mlinkh.bas
const
  // Packets
 ILLEGALPKT  = 0;
 CALLPKT  = 7;
 EVALUATEPKT  = 13;
 RETURNPKT  = 3;
 INPUTNAMEPKT  = 8;
 ENTERTEXTPKT  = 14;
 ENTEREXPRPKT  = 15;
 OUTPUTNAMEPKT  = 9;
 RETURNTEXTPKT  = 4;
 RETURNEXPRPKT  = 16;
 DISPLAYPKT  = 11;
 DISPLAYENDPKT  = 12;
 MESSAGEPKT  = 5;
 TEXTPKT  = 2;
 INPUTPKT  = 1;
 INPUTSTRPKT  = 21;
 MENUPKT  = 6;
 SYNTAXPKT  = 10;
 SUSPENDPKT  = 17;
 RESUMEPKT  = 18;
 BEGINDLGPKT  = 19;
 ENDDLGPKT  = 20;
 FIRSTUSERPKT  = 128;
 LASTUSERPKT  = 255;


//Messages

 MLTerminateMessage = 1;
 MLInterruptMessage = 2;
 MLAbortMessage = 3;


//Error Codes

 MLEUNKNOWN  = -1;
 MLEOK  = 0;
 MLEDEAD  = 1;
 MLEGBAD  = 2;
 MLEGSEQ = 3;
 MLEPBTK = 4;
 MLEPSEQ = 5;
 MLEPBIG = 6;
 MLEOVFL = 7;
 MLEMEM = 8;
 MLEACCEPT = 9;
 MLECONNECT = 10;
 MLECLOSED = 11;
 MLENOACK = 15;
 MLENODATA = 16;
 MLENOTDELIVERED = 17;
 MLENOMSG = 18;
 MLEFAILED = 19;
 MLEPUTENDPACKET = 21;
 MLENEXTPACKET = 22;
 MLEUNKNOWNPACKET = 23;
 MLEGETENDPACKET = 24;
 MLEABORT = 25;
 MLEINIT = 32;
 MLEARGV = 33;
 MLEPROTOCOL = 34;
 MLEMODE = 35;
 MLELAUNCH = 36;
 MLELAUNCHAGAIN = 37;
 MLELAUNCHSPACE = 38;
 MLENOPARENT = 39;
 MLENAMETAKEN = 40;
 MLENOLISTEN = 41;
 MLEBADNAME = 42;
 MLEBADHOST = 43;
 MLERESOURCE = 44;


//Tokens

 MLTKSTR = 34;
 MLTKSYM = 35;
 MLTKINT = 43;
 MLTKREAL = 42;
 MLTKFUNC = 70;
 MLTKERROR = 0;

// end const


// functions by export orders.

// function  MLAlert(env : MLEnvironment ; message : kcharp_ct) : mldlg_result;
//    MLAlertCast
//    MLAlign
//    MLAllocParameter
//    MLAllocatorCast
//    MLBegin
//    MLBytesToGet
//    MLBytesToPut
//    MLCallMessageHandler
//    MLCallYieldFunction
//    MLCharacterOffset
//    MLCheckFunction
//    MLCheckFunctionWithArgCount
//    MLCheckString
//    MLCheckSymbol
//    MLClearError
//    MLClose
//    MLConfirm
//    MLConfirmCast
//    MLConnect
//    MLConvertByteString
//    MLConvertByteStringNL
//    MLConvertCharacter
//    MLConvertDoubleByteString
//    MLConvertDoubleByteStringNL
//    MLConvertNewLine
//    MLConvertUnicodeString
//    MLConvertUnicodeStringNL
//    MLCountYP
//    MLCreate0
//    MLCreateMark
//    MLCreateMessageHandler
//    MLCreateMessageHandler0
//    MLCreateYieldFunction
//    MLCreateYieldFunction0
//    MLDeallocatorCast
//    MLDefaultYieldFunction
//    MLDeinit
procedure MLDeinitialize(env : MLEnvironment); pascal;
//    MLDestroy
//    MLDestroyMark
//    MLDestroyMessageHandler
//    MLDestroyYieldFunction
//    MLDeviceInformation
//    MLDisownBinaryNumberArray
//    MLDisownBinaryNumberList
//    MLDisownByteArray
//    MLDisownByteString
//    MLDisownByteSymbol
//    MLDisownDoubleArray
//    MLDisownFloatArray
//    MLDisownIntegerArray
//    MLDisownIntegerList
//    MLDisownLongDoubleArray
//    MLDisownLongIntegerArray
//    MLDisownRealList
//    MLDisownShortIntegerArray
//    MLDisownString
//    MLDisownSymbol
//    MLDisownUnicodeString
//    MLDisownUnicodeSymbol
//    MLDuplicateLink
//    MLEnclosingEnvironment
//    MLEnd
//    MLEndPacket
//    MLError
//    MLErrorMessage
//    MLErrorParameter
//    MLErrorString
//    MLEstablish
//    MLEstablishString
//    MLExpressionsToGet
//    MLFeatureString
//    MLFill
//    MLFilterArgv0
//    MLFlush
//    MLForwardReset
//    MLFromLinkID
//    MLGet16BitCharacters
//    MLGet7BitCharacters
//    MLGet8BitCharacters
//    MLGetArgCount
//    MLGetArrayDimensions
//    MLGetArrayType
//    MLGetArrayType0
//    MLGetBinaryNumber
//    MLGetBinaryNumberArray
//    MLGetBinaryNumberArray0
//    MLGetBinaryNumberArrayData
//    MLGetBinaryNumberArrayData0
//    MLGetBinaryNumberList
//    MLGetByteArray
//    MLGetByteArrayData
//    MLGetByteString
//    MLGetByteString0
//    MLGetByteSymbol
//    MLGetData
//    MLGetDouble
//    MLGetDoubleArray
//    MLGetDoubleArrayData
//    MLGetFloat
//    MLGetFloatArray
//    MLGetFloatArrayData
//    MLGetFunction
//    MLGetInteger
//    MLGetIntegerArray
//    MLGetIntegerArrayData
//    MLGetIntegerList
//    MLGetLongDouble
//    MLGetLongDoubleArray
//    MLGetLongDoubleArrayData
//    MLGetLongInteger
//    MLGetLongIntegerArray
//    MLGetLongIntegerArrayData
//    MLGetMessage
//    MLGetNext
//    MLGetNextRaw
//    MLGetRawArgCount
//    MLGetRawData
//    MLGetRawType
//    MLGetRealList
//    MLGetShortInteger
//    MLGetShortIntegerArray
//    MLGetShortIntegerArrayData
//    MLGetString
//    MLGetString0
//    MLGetSymbol
//    MLGetType
//    MLGetUnicodeString
//    MLGetUnicodeString0
//    MLGetUnicodeSymbol
//    MLHandlerCast
//    MLInit
function  MLInitialize(p : MLParametersPointer):MLEnvironment; pascal; // pass in NULL //
function  MLLoopbackOpen(ep : MLEnvironment ; var errp:Longint): MLINK; pascal;
//    MLLoopbackOpen0
//    MLMake
//    MLMessageHandler
//    MLMessageReady
//    MLName
//    MLNewPacket
//    MLNewParameters
//    MLNextCharacter
//    MLNextCharacter0
//    MLNextPacket
//    MLNumber
//    MLNumberControl0
//    MLOldConvertByteString
//    MLOldConvertUnicodeString
//    MLOldPutCharToString
//    MLOldStringCharFun
//    MLOldStringFirstPosFun
//    MLOldStringNextPosFun
//    MLOpen
//    MLOpenArgv
//    MLOpenInEnv
//    MLOpenS
function  MLOpenString(ep : MLEnvironment ; command_line : kcharp_ct ; var errp : Longint):MLINK; pascal;
//    MLPrintArgv
//    MLPut16BitCharacters
//    MLPut7BitCharacters
//    MLPut7BitCount
//    MLPut8BitCharacters
//    MLPutArgCount
//    MLPutArray
//    MLPutArrayLeaves0
//    MLPutArrayType0
//    MLPutBinaryNumber
//    MLPutBinaryNumberArray
//    MLPutBinaryNumberArrayData
//    MLPutBinaryNumberArrayData0
//    MLPutBinaryNumberList
//    MLPutByteArray
//    MLPutByteArrayData
//    MLPutByteString
//    MLPutByteSymbol
//    MLPutComposite
//    MLPutData
//    MLPutDouble
//    MLPutDoubleArray
//    MLPutDoubleArrayData
//    MLPutFloat
//    MLPutFloatArray
//    MLPutFloatArrayData
//    MLPutFunction
//    MLPutInteger
//    MLPutIntegerArray
//    MLPutIntegerArrayData
//    MLPutIntegerList
//    MLPutLongDouble
//    MLPutLongDoubleArray
//    MLPutLongDoubleArrayData
//    MLPutLongInteger
//    MLPutLongIntegerArray
//    MLPutLongIntegerArrayData
//    MLPutMessage
//    MLPutNext
//    MLPutRawData
//    MLPutRawSize
//    MLPutRealByteString0
//    MLPutRealList
//    MLPutRealUnicodeString0
//    MLPutShortInteger
//    MLPutShortIntegerArray
//    MLPutShortIntegerArrayData
//    MLPutSize
//    MLPutString
//    MLPutSymbol
//    MLPutType
//    MLPutUnicodeString
//    MLPutUnicodeSymbol
//    MLRawBytesToGet
//    MLReady
//    MLReleaseGetArrayState0
//    MLReleasePutArrayState0
//    MLRequest
//    MLRequestArgv
//    MLRequestArgvCast
//    MLRequestCast
//    MLRequestToInteract
//    MLRequestToInteractCast
//    MLScanString
//    MLSeekMark
//    MLSeekToMark
//    MLSetAllocParameter
//    MLSetDefaultYieldFunction
//    MLSetDeviceParameter
//    MLSetDialogFunction
//    MLSetError
//    MLSetMessageHandler
//    MLSetMessageHandler0
//    MLSetName
//    MLSetResourceParameter
//    MLSetUserBlock
//    MLSetUserData
//    MLSetYieldFunction
//    MLSetYieldFunction0
//    MLSleepYP
//    MLStringCharacter
//    MLStringFirstPosFun
//    MLStringToArgv
//    MLTakeLast
//    MLTestPoint1
//    MLTestPoint2
//    MLTestPoint3
//    MLTestPoint4
//    MLToLinkID
//    MLTransfer0
//    MLTransferExpression
//    MLTransferToEndOfLoopbackLink
//    MLUserBlock
//    MLUserCast
//    MLUserData
//    MLYieldFunction
//    MLYielderCast
//    MLinkEnvironment

implementation

const
  MathLinkDLL = 'ml32i2.dll';

// function  MLAlert(env : MLEnvironment ; message : kcharp_ct) : mldlg_result;
//    MLAlertCast
//    MLAlign
//    MLAllocParameter
//    MLAllocatorCast
//    MLBegin
//    MLBytesToGet
//    MLBytesToPut
//    MLCallMessageHandler
//    MLCallYieldFunction
//    MLCharacterOffset
//    MLCheckFunction
//    MLCheckFunctionWithArgCount
//    MLCheckString
//    MLCheckSymbol
//    MLClearError
//    MLClose
//    MLConfirm
//    MLConfirmCast
//    MLConnect
//    MLConvertByteString
//    MLConvertByteStringNL
//    MLConvertCharacter
//    MLConvertDoubleByteString
//    MLConvertDoubleByteStringNL
//    MLConvertNewLine
//    MLConvertUnicodeString
//    MLConvertUnicodeStringNL
//    MLCountYP
//    MLCreate0
//    MLCreateMark
//    MLCreateMessageHandler
//    MLCreateMessageHandler0
//    MLCreateYieldFunction
//    MLCreateYieldFunction0
//    MLDeallocatorCast
//    MLDefaultYieldFunction
//    MLDeinit
procedure MLDeinitialize(env : MLEnvironment); external MathLinkDLL;
//    MLDestroy
//    MLDestroyMark
//    MLDestroyMessageHandler
//    MLDestroyYieldFunction
//    MLDeviceInformation
//    MLDisownBinaryNumberArray
//    MLDisownBinaryNumberList
//    MLDisownByteArray
//    MLDisownByteString
//    MLDisownByteSymbol
//    MLDisownDoubleArray
//    MLDisownFloatArray
//    MLDisownIntegerArray
//    MLDisownIntegerList
//    MLDisownLongDoubleArray
//    MLDisownLongIntegerArray
//    MLDisownRealList
//    MLDisownShortIntegerArray
//    MLDisownString
//    MLDisownSymbol
//    MLDisownUnicodeString
//    MLDisownUnicodeSymbol
//    MLDuplicateLink
//    MLEnclosingEnvironment
//    MLEnd
//    MLEndPacket
//    MLError
//    MLErrorMessage
//    MLErrorParameter
//    MLErrorString
//    MLEstablish
//    MLEstablishString
//    MLExpressionsToGet
//    MLFeatureString
//    MLFill
//    MLFilterArgv0
//    MLFlush
//    MLForwardReset
//    MLFromLinkID
//    MLGet16BitCharacters
//    MLGet7BitCharacters
//    MLGet8BitCharacters
//    MLGetArgCount
//    MLGetArrayDimensions
//    MLGetArrayType
//    MLGetArrayType0
//    MLGetBinaryNumber
//    MLGetBinaryNumberArray
//    MLGetBinaryNumberArray0
//    MLGetBinaryNumberArrayData
//    MLGetBinaryNumberArrayData0
//    MLGetBinaryNumberList
//    MLGetByteArray
//    MLGetByteArrayData
//    MLGetByteString
//    MLGetByteString0
//    MLGetByteSymbol
//    MLGetData
//    MLGetDouble
//    MLGetDoubleArray
//    MLGetDoubleArrayData
//    MLGetFloat
//    MLGetFloatArray
//    MLGetFloatArrayData
//    MLGetFunction
//    MLGetInteger
//    MLGetIntegerArray
//    MLGetIntegerArrayData
//    MLGetIntegerList
//    MLGetLongDouble
//    MLGetLongDoubleArray
//    MLGetLongDoubleArrayData
//    MLGetLongInteger
//    MLGetLongIntegerArray
//    MLGetLongIntegerArrayData
//    MLGetMessage
//    MLGetNext
//    MLGetNextRaw
//    MLGetRawArgCount
//    MLGetRawData
//    MLGetRawType
//    MLGetRealList
//    MLGetShortInteger
//    MLGetShortIntegerArray
//    MLGetShortIntegerArrayData
//    MLGetString
//    MLGetString0
//    MLGetSymbol
//    MLGetType
//    MLGetUnicodeString
//    MLGetUnicodeString0
//    MLGetUnicodeSymbol
//    MLHandlerCast
//    MLInit
function  MLInitialize(p : MLParametersPointer):MLEnvironment; external MathLinkDLL;
function  MLLoopbackOpen(ep : MLEnvironment ; var errp:Longint): MLINK; external MathLinkDLL;
//    MLLoopbackOpen0
//    MLMake
//    MLMessageHandler
//    MLMessageReady
//    MLName
//    MLNewPacket
//    MLNewParameters
//    MLNextCharacter
//    MLNextCharacter0
//    MLNextPacket
//    MLNumber
//    MLNumberControl0
//    MLOldConvertByteString
//    MLOldConvertUnicodeString
//    MLOldPutCharToString
//    MLOldStringCharFun
//    MLOldStringFirstPosFun
//    MLOldStringNextPosFun
//    MLOpen
//    MLOpenArgv
//    MLOpenInEnv
//    MLOpenS
function  MLOpenString(ep : MLEnvironment ; command_line : kcharp_ct ; var errp : Longint):MLINK; external MathLinkDLL;
//    MLPrintArgv
//    MLPut16BitCharacters
//    MLPut7BitCharacters
//    MLPut7BitCount
//    MLPut8BitCharacters
//    MLPutArgCount
//    MLPutArray
//    MLPutArrayLeaves0
//    MLPutArrayType0
//    MLPutBinaryNumber
//    MLPutBinaryNumberArray
//    MLPutBinaryNumberArrayData
//    MLPutBinaryNumberArrayData0
//    MLPutBinaryNumberList
//    MLPutByteArray
//    MLPutByteArrayData
//    MLPutByteString
//    MLPutByteSymbol
//    MLPutComposite
//    MLPutData
//    MLPutDouble
//    MLPutDoubleArray
//    MLPutDoubleArrayData
//    MLPutFloat
//    MLPutFloatArray
//    MLPutFloatArrayData
//    MLPutFunction
//    MLPutInteger
//    MLPutIntegerArray
//    MLPutIntegerArrayData
//    MLPutIntegerList
//    MLPutLongDouble
//    MLPutLongDoubleArray
//    MLPutLongDoubleArrayData
//    MLPutLongInteger
//    MLPutLongIntegerArray
//    MLPutLongIntegerArrayData
//    MLPutMessage
//    MLPutNext
//    MLPutRawData
//    MLPutRawSize
//    MLPutRealByteString0
//    MLPutRealList
//    MLPutRealUnicodeString0
//    MLPutShortInteger
//    MLPutShortIntegerArray
//    MLPutShortIntegerArrayData
//    MLPutSize
//    MLPutString
//    MLPutSymbol
//    MLPutType
//    MLPutUnicodeString
//    MLPutUnicodeSymbol
//    MLRawBytesToGet
//    MLReady
//    MLReleaseGetArrayState0
//    MLReleasePutArrayState0
//    MLRequest
//    MLRequestArgv
//    MLRequestArgvCast
//    MLRequestCast
//    MLRequestToInteract
//    MLRequestToInteractCast
//    MLScanString
//    MLSeekMark
//    MLSeekToMark
//    MLSetAllocParameter
//    MLSetDefaultYieldFunction
//    MLSetDeviceParameter
//    MLSetDialogFunction
//    MLSetError
//    MLSetMessageHandler
//    MLSetMessageHandler0
//    MLSetName
//    MLSetResourceParameter
//    MLSetUserBlock
//    MLSetUserData
//    MLSetYieldFunction
//    MLSetYieldFunction0
//    MLSleepYP
//    MLStringCharacter
//    MLStringFirstPosFun
//    MLStringToArgv
//    MLTakeLast
//    MLTestPoint1
//    MLTestPoint2
//    MLTestPoint3
//    MLTestPoint4
//    MLToLinkID
//    MLTransfer0
//    MLTransferExpression
//    MLTransferToEndOfLoopbackLink
//    MLUserBlock
//    MLUserCast
//    MLUserData
//    MLYieldFunction
//    MLYielderCast
//    MLinkEnvironment

end.



