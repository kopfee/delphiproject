{ ZIPDIR.PAS  - This is a VCL to get you the "Table of Contents" 
  of a Zip File.

  TZipDir (this VCL) should NOT be used if you will be using 
  TZipMaster. TZipDir is a subset of TZipMaster that only has 
  the List method.

  This VCL is used in Demo3, which shows how to use the Zip DLLs
  without using TZipMaster.

  This Delphi/CBuilder VCL is public domain by Eric W. Engler.
  This is based on two similar components:
     TZip by Pier Carlo Chiodi, pc.chiodi@mbox.thunder.it
     TZReader by Dennis Passmore, CIS: 71640,2464
}

(* Simple Usage Instructions:
    1. Install this VCL into a directory in your VCL search path

    2. drop this on a form, or create it dynamically.

    3. At runtime or design time, assign a filename to ZipDir1.Filename.

    4. At runtime, ZipDir1.Count tells you how many files are contained im
       the zip file.  Note: the entry numbers are zero-based, so if the
       ZipDir1.Count is 4, then the entry numbers will be: 0, 1, 2, 3.

    5. At runtime, get the contents of the Zip file. Examine the
       "ZipContents" TList, which contains a bunch of ZipDirEntry 
       records.  Here's an example that assumes you have a form with
       a TMemo and a TZipDir component:

       var
         i: Integer;
       begin
          ZipDir1.Filename:='C:\MYSTUFF\TEST.ZIP'; { List method auto-execs }
          for i:=0 to ZipDir1.Count-1 do
          begin
             with ZipDirEntry(ZipDir1.ZipContents[i]^) do
             begin
                Memo1.Lines.Add('Entry #' + IntToStr(i) + ': '
                             + 'Filename is ' + FileName);
                Memo1.Lines.Add('Filename is ' + FileName);
                Memo1.Lines.Add('Compr size is ' +
                   IntToStr(CompressedSize));
                Memo1.Lines.Add('DateTime stamp is ' +
                   FormatDateTime('ddddd  t',FileDateToDateTime(DateTime)));
                Memo1.Lines.Add(' '); // blank line
             end; // end with
          end; // end for
        end;

     6. The List method manually forces the TList to be rebuilt.  Note,
        however, it gets automatically executed whenever you set the filename.
*)

unit ZipDir;

interface

uses
  WinTypes, Winprocs, SysUtils, Classes, Dialogs; { ZipDLL, UnzDLL, ZCALLBCK }

type
  EInvalidOperation = class(exception);

type ZipDirEntry = packed Record
  Version                     : WORD;
  Flag                        : WORD;
  CompressionMethod           : WORD;
  DateTime                    : Longint; { Time: word; Date: Word; }
  CRC32                       : Longint;
  CompressedSize              : Longint;
  UncompressedSize            : Longint;
  FileNameLength              : WORD;
  ExtraFieldLength            : WORD;
  FileName                    : String;
end;

type
  PZipDirEntry = ^ZipDirEntry;

const
  LocalFileHeaderSig   = $04034b50; { 'PK03' }
  CentralFileHeaderSig = $02014b50; { 'PK12' }
  EndCentralDirSig     = $06054b50; { 'PK56' }

type
  TZipDir = class(TComponent)
  private
    FZipContents: TList;
    FZipFileName: String;

    procedure FreeZipDirEntryRecords;
    function  GetCount: Integer;
    procedure SetZipFileName(Value: String);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    { run-time-only methods }
    procedure List;  { force a re-read of Zip file }

    { run-time-only properties }
    property ZipContents: TList read FZipContents;
    property Count: Integer read GetCount;

  published
    { properties for both design-time and run time }

    { At runtime: every time the filename is assigned a value, the
      ZipDir will be read.  You don't need to call List yourself,
      unless you just want to refresh your list. Of course, if you
      set the ZipFileName in the property inspector, no auto List will
      later occur at runtime.}
    property ZipFileName: String  read FZipFileName write SetZipFileName;
  end;

  procedure Register;

implementation

const
  LocalDirEntrySize = 26;   { size of zip dir entry in local zip directory }

constructor TZipDir.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FZipContents:=TList.Create;
  FZipFileName:='';
end;

destructor TZipDir.Destroy;
begin
  FreeZipDirEntryRecords;
  FZipContents.Free;
  inherited Destroy;
end;

procedure TZipDir.SetZipFileName(Value: String);
begin
  FreeZipDirEntryRecords;
  FZipFileName := Value;
  if not (csDesigning in ComponentState) then
  begin
    if FileExists(FZipFileName) then
       { I am intentionally letting this be done again if you set the filename
         to the same name it already was.  This forces a refresh, in case the
         zip file has been changed. }
       List;
  end;
end;

procedure TZipDir.FreeZipDirEntryRecords;
var
  i: integer;
begin
   for i:=FZipContents.Count-1 downto 0 do
   begin
     if Assigned(FZipContents[i]) then
        // unalloc storage for a ZipDirEntry record
        dispose(PZipDirEntry(FZipContents[i]));
     FZipContents.Delete(i); // delete the TList pointer to the freed record
   end; // end for
   // The caller will free the FZipContents TList itself, if needed
end;

function TZipDir.GetCount:Integer;
begin
  if FZipFileName <> '' then
     Result:=FZipContents.Count
  else
     Result:=0;
end;

// Read thru all entries in the local Zip directory.
// This is triggered by assigning a filename to your ZipDir component, or
// by calling this method directly.
procedure TZipDir.List;
var
  Sig: Longint;
  ZipStream: TFileStream;
  Res, Count: Longint;
  ZipDirEntry: PZipDirEntry;
  Name: array [0..255] of char;
  FirstEntryFound: Boolean;
  Byt: Byte;
begin
  if (csDesigning in ComponentState) then
     Exit;   { can't list contents of a zipfile at design time }

  FreeZipDirEntryRecords;
  if not FileExists(FZipFileName) then
  begin
     ShowMessage('Error opening file: ' + FZipFilename);
     exit;
  end;

  FirstEntryFound:=False;
  Count:=0;
  ZipStream := TFileStream.Create(FZipFilename,fmOpenRead OR fmShareDenyWrite);
  try
     while TRUE do
     begin
        if not FirstEntryFound then
        begin
           { Bug fix for WinZip-created self-extracting archives.
             It makes archives with local headers that don't necessarily
             line up in a "mod 4" manner from beginning of file.
             Read the zip file one byte at a time until we find the
             first local zip header.  From there on, everything will
             be properly aligned. This won't slow down processing on
             non-self-extracting archives, but it will take longer to
             read the dir on self-extracting archives. }
           Res:=ZipStream.Read(Byt,1);
           if (Res = HFILE_ERROR) or (Res <> 1) then
              raise EStreamError.create('Error 1a reading Zip File');
           Inc(Count);
           { We'll allow 60000 attempts to find byte 1 of a local header. }
           { Most variations of self-extracting code should be under 64K. }
           if Count > 60000 then
           begin
              FZipFileName:='';
              raise EStreamError.create('Error reading Zip File');
           end;
           if Byt <> $50 then
              continue;
           Res:=ZipStream.Read(Byt,1);
           if (Res = HFILE_ERROR) or (Res <> 1) then
              raise EStreamError.create('Error 1b reading Zip File');
           if Byt <> $4b then
              continue;
           Res:=ZipStream.Read(Byt,1);
           if (Res = HFILE_ERROR) or (Res <> 1) then
              raise EStreamError.create('Error 1c reading Zip File');
           if Byt <> $03 then
              continue;
           Res:=ZipStream.Read(Byt,1);
           if (Res = HFILE_ERROR) or (Res <> 1) then
              raise EStreamError.create('Error 1d reading Zip File');
           if Byt <> $04 then
              continue;
           FirstEntryFound:=True; { next time, we'll read 32 bits at a time }
           Sig:=LocalFileHeaderSig;  { we've read all 4 bytes }
        end
        else
        begin
           Res := ZipStream.Read(Sig, SizeOf(Sig));  { 32 bit read }
           if (Res = HFILE_ERROR) or (Res <> SizeOf(Sig)) then
              raise EStreamError.create('Error 1 reading Zip File');
        end;
        if Sig = LocalFileHeaderSig then
        begin
           {===============================================================}
           { This is what we want.  We'll read the local file header info. }

           { Create a new ZipDirEntry record, and zero fill it }
           new(ZipDirEntry);
           fillchar(ZipDirEntry^, sizeof(ZipDirEntry^), 0);

           { fill the ZipDirEntry struct with local header info for one entry. }
           { Note: In the "if" statement's first clause we're reading the info
             for a whole Zip dir entry, not just the version info. }
           with ZipDirEntry^ do
           if (ZipStream.Read(Version, LocalDirEntrySize) = LocalDirEntrySize)
           and (ZipStream.Read(Name, FileNameLength)=FileNameLength) then
              FileName := Copy(Name, 0, FileNameLength)
           else
           begin
              dispose(ZipDirEntry);  { bad entry - free up memory for it }
              raise EStreamError.create('Error reading Zip file');
           end;
           FZipContents.Add(pointer(ZipDirEntry));

           { ShowMessage('Just found file: ' + ZipDirEntry^.FileName); } // DEBUG

           if (ZipStream.Position + ZipDirEntry^.ExtraFieldLength +
            ZipDirEntry^.CompressedSize) > (ZipStream.Size - 22) then
           begin
              { should never happen due to presence of central dir }
              raise EStreamError.create('Error reading Zip file');
              break;
           end;

           with ZipDirEntry^ do
           begin
              if ExtraFieldLength > 0 then
              begin
                 { skip over the extra fields }
                 res := (ZipStream.Position + ExtraFieldLength);
                 if ZipStream.Seek(ExtraFieldLength, soFromCurrent) <> res then
                    raise EStreamError.create('Error reading Zip file');
              end;

              { skip over the compressed data for the file entry just parsed }
              res := (ZipStream.Position + CompressedSize);
              if ZipStream.Seek(CompressedSize, soFromCurrent) <> res then
                 raise EStreamError.create('Error reading Zip file');
           end;
           {===============================================================}
        end  { end of local stuff }

        else
           { we're not going to read the Central or End directories }
           if (Sig = CentralFileHeaderSig) or (Sig = EndCentralDirSig) then
              break;   { found end of local stuff - we're done }
     end;  { end of loop }

  finally
     ZipStream.Free;
  end;  { end of try...finally }
end;

procedure Register;
begin
  RegisterComponents('Samples', [TZipDir]);
end;

end.
