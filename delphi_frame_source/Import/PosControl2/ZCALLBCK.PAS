unit ZCallBck;

interface

uses Windows;

{ Maximum no. of files in a single ZIP file (do NOT change): }
Const FilesMax = 4096;
      PWLEN = 80;

type
  PZCallBackStruct = ^ZCallBackStruct;

  { All the items in the CallBackStruct are passed to the Delphi
    program from the DLL.  Note that the "Caller" value returned
    here is the same one specified earlier in ZipParms by the
    Delphi pgm. }
  ZCallBackStruct = packed record
     Handle: THandle;
     Caller: Pointer;    { "self" referance of the Delphi form }
     Version: LongInt;   { version no. of DLL }
     IsOperationZip: LongBool; { true=zip, false=unzip }
     ActionCode: LongInt;
     ErrorCode: LongInt;
     FileSize: LongInt;
     FileNameOrMsg: Array[0..511] of Char;
  end;

type
  { Declare a function pointer type for the Delphi callback function, to
    be called by the DLL to pass updated status info back to Delphi. }
  { Your callback function must not be a member of a class! }
  ZFunctionPtrType = function(ZCallbackRec: PZCallBackStruct): LongBool; stdcall;

implementation

end.
