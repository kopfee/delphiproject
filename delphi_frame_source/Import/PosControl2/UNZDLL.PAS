{ UNZDLL.PAS   - Delphi v2 translation of file "wizunzip.h" by Eric W. Engler }
{ Import Unit for UNZDLL - put this into the "uses" clause of any
  other unit that wants to access the UNZDLL. }

{ I changed this to use dynamic loading of the DLL in order to allow
  the user program to control when to load and unload the DLLs. 
  Thanks to these people for sending me dynamic loading code:
     Ewart Nijburg, Nijsoft@Compuserve.com
     P.A. Gillioz,  pag.aria@rhone.ch 
}

unit UNZDLL;

interface

uses Windows, Dialogs, ZCallBck;

{ This record is very critical.  Any changes in the order of items, the
  size of items, or modifying the number of items, may have disasterous
  results.  You have been warned! }
Type UnZipParms = packed record
         Handle: THandle;
         Caller: Pointer;    { "self" referance of the Delphi form }
                     { This is passed back to us in the callback function
                     so we can direct the info to the proper form instance
                     - thanks to Dennis Passmore for this idea. }
         Version: LongInt;   { version of DLL we expect to see }
         ZCallbackFunc: ZFunctionPtrType; { type def in ZCallBck.PAS }
         fTraceEnabled: LongBool;

         {============== Begin UnZip Flag section ============== }
         fPromptToOverwrite: LongBool;  // not used yet
         PZipPassword: PChar;  // password pointer 
         fTest:    LongBool;   // if true, test zipfile, don't save extracted files
         fComments: LongBool;  // show zip comment (not supported yet)
         fConvert: LongBool;   // if true, do ASCII/EBCDIC or EOL translation

         fQuiet:   LongBool;        // DLL be quiet!
         fVerboseEnabled: LongBool; // verbose flag
         fUpdate:  LongBool;  // "update" (extract only newer files & brand new files)
         fFreshen: LongBool;  // "freshen" (extract only newer files that already exist)
         fDirectories: LongBool; // if true, recreate dir structure
         fOverwrite: LongBool;   // if true, overwrite existing (no asking)

         { Count of filespecs to extract - don't forget to set this! }
         argc: LongInt;
         { ptr to zipfile name }
         PZipFN: PChar;
         seven: LongInt; { pass a 7 here to validate struct size }
         { Array of filenames contained in the ZIP archive }
         PFileNames: array[0..FilesMax] of PChar;
      end;

 type
   PUnZipParms = ^UnZipParms;

{ Main call to execute a ZIP add or Delete.  This call returns the
  number of files that were sucessfully operated on. }
var UnzDllExec: function(UnZipRec: PUnZipParms): DWORD; stdcall;

var GetUnzDllVersion: function : DWORD; stdcall;

var UnzDllHandle : THandle;

implementation

end.
