Unit ZipMstr;
(* TZipMaster VCL by Eric W. Engler.   v1.40      Mar 3, 1998

   The new SFX options in this version are made possible by changes
   made to the SFX source code by Markus Stephany, mirbir.st@saargate.de.
   Please send him an e-mail to say "thanks for the hard work"!

   Quick summary of changes in version 1.40:

   bug fixes:
       Correct filenames are now given in the "skipping encrypted file..."
         error messages.  Thanks to: Markus Stephany, mirbir.st@saargate.de
 
       The SFX module now extracts more than 1 passworded file in an
         archive.   Thanks to: Markus Stephany, mirbir.st@saargate.de

       Correct progress events now generated for extraction of 
         uncompressed files.  Thanks to: Esa Raita, eza@netlife.fi 
 
   DLLDirectory property - allows manual specification of the dir
       used to hold ZIPDLL.DLL and UNZDLL.DLL.  Should NOT end
       in a slash.  This is an optional property. if used, it overrides
       the Windows search path for DLLs.  If you specify a dirname
       here, but the DLLs are not actually in that dir, then the
       std Windows search path will be consulted.
          The idea for this came from Thomas Hensle, thensle@t-online.de.
 
   In case SFXPath isn't set, DLLDirectory will also be consulted
       when trying to locate ZIPSFX.BIN.  Here's the order that will
       be used to locate ZIPSFX.BIN:
         1) location given by the SFXPath property 
         2) the current directory 
         3) the application directory (location of current .EXE file)
         4) the Windows System directory (where DLLs go)}
         5) the Windows directory (where DLLs go)
         6) location given by the DLLDirectory property 

   These are the advanced options for creating more powerful Self-Extracting
   archives.  By using these options, you can turn the new .EXE archive into
   a small self-contained setup program!

   The following three boolean options are set members of SFXOptions:

   SFXAskCmdLine     boolean   (only matters if a cmd line is present)
        If yes, allows user to de-select the command line checkbox.
        Once deselected, the command line will not be run.
        NOTE: The checkbox doesn't appear unless there is a command line
        specified.

   SFXAskFiles       boolean   (if yes, lets user modify list of files
        to be extracted)

   SFXHideOverWriteBox   boolean  (if yes, does NOT show the user the
        dialog box that lets him choose the overwrite action at runtime for
        files that already exist)

   SFXOverWriteMode  enum     dflt=ovrConfirm  (others: ovrAlways, ovrNever)
        This is the dflt overwrite option (if SFXHideOverWriteBox is true, then
        this option will be used during extraction)

   SFXCaption        string   dflt='Self-extracting Archive'
        Caption of the SFX dialog box at runtime.

   SFXDefaultDir     string   dflt=''
        Default target dir for extraction.  Can be changed at runtime.
        If you don't specify this, the user's current directory will
        be the default.

   SFXCommandLine    string   dflt=''
        This command line will be executed immediately after extracting the 
        files.  Typically used to view the readme file, but can do anything.
        There is a predefined symbol that can be used in the command line
        to tell you which target directory was actually used.
        Special symbols: | is the command/arg separater
                        >< is the actual extraction dir selected by user
        Example:
           notepad.exe|><readme.txt
        Run notepad to show "readme.txt" in the actual extraction dir. 
 
  ------------------------------------------------------------------------

   TZipMaster is a non-visual VCL wrapper for my freeware ZIP and
   UNZIP DLLs.  At run time, the DLL's: ZIPDLL.DLL and UNZDLL.DLL must
   be present on the hard disk - in C:\WINDOWS\SYSTEM or else in your
   application directory, or a directory in the PATH.

   These DLLs are based on the InfoZip Official Freeware Zip/Unzip
   source code, but they are NOT equivalent to InfoZip's DLLs.
   I have modified the InfoZip source code to enhance their
   ease-of-use, power, and flexibility for use with Delphi and
   C++ Builder.  Please do NOT contact InfoZip for issues
   regarding this port.

   To obtain the official InfoZip source code, consult their
   Web site:
               http://www.cdrom.com/pub/infozip/

   The six main methods that can be invoked are:
       Add      - add one or more files to a ZIP archive
       Delete   - delete one or more files from ZIP archive
       Extract  - expand one or more files from a ZIP archive
       List     - transfer "table of contents" of ZIP archive
                  to a StringList

       CopyFile - copies a file

       GetAddPassword  - prompt user for a password - does verify
       GetExtrPassword - prompt user for a password - does NOT verify

   NOTE: "Test" is a sub-option of Extract

   All of the methods above will work on regular .ZIP files, and
   on self-extracting ZIP archives having a file extension of .EXE.

   Various properties exist to control the actions of the methods.

   Filespecs are specified in the FSpecArgs TStringList property, so you
   can easily combine many different filespecs into one Add, Delete, or
   Extract operation. For example:

      1. Add entries directly to the FSpecArgs property:
       ZipMaster1.FSpecArgs.Add('C:\AUTOEXEC.BAT');
       ZipMaster1.FSpecArgs.Add('C:\DELPHI\BIN\DELPHI.EXE');
       ZipMaster1.FSpecArgs.Add('C:\WINDOWS\*.INI');

      2. Take the filespecs from a StringList, just assign them all over
         to ZipMaster1.
       ZipMaster1.FSpecArgs.Assign(StringList1);

      3. Take the filespecs from a ListBox, just assign them all over
         to ZipMaster1.
       ZipMaster1.FSpecArgs.Assign(ListBox1.Items);

   You can specify either the MS-DOS backslash path symbol, or the one
   normally used by PKZIP (the Unix path separator: /).  They are treated
   exactly the same.

   All of your FSpecArgs accept MS-DOS wildcards.

   Add, Delete, and Extract are the only methods that use FSpecArgs.
   The List method doesn't - it just lists all files.


   Following is a list of all TZipMaster properties, events and methods:

   Properties
   ==========
     Verbose      Boolean     If True, ask for the maximum amount of "possibly
                              important" information from the DLLs.  The
                              informational messages are delivered to your
                              program via the OnMessage event, and the ErrCode
                              and Message properties. This is primarily used
                              to determine how much info you want to show your
                              "end-users" - developers can use the Trace
                              property to get additional infomation.

     Trace        Boolean     Similar to Verbose, except that this one is
                              aimed at developers.  It lets you trace the
                              execution of the C code in the DLLs.  Helps
                              you locate possible bugs in the DLLs, and
                              helps you understand why something is happening
                              a certain way.

     ErrCode      Integer     Holds a copy of the last error code sent to
                              your program by from DLL. 0=no error.
                              See the OnMessage event.  Most messages from
                              the DLLs will have an ErrCode of 0.

     Message      String      Holds a copy of the last message sent to your
                              program by the DLL.  See the OnMessage event.

     ZipContents  TList       Read-only TList that contains the directory
                              of the archive specified in the ZipFilename
                              property. Every entry in the list points to
                              a ZipDirEntry record.  This is automatically
                              filled with data whenever an assignment is
                              made to ZipFilename, and can be manually
                              filled by calling the List method.
                                 For your convenience, this VCL hides the
                              TList memory allocation issues from you.
                                 Automatic updates to this list occur
                              whenever this VCL changes the ZIP file.
                              Event OnDirUpdate is triggered for you
                              each time this list is updated - that is
                              your queue to refresh your directory display.

   ---------------------------------------------------------------------
   Each entry in the ZipContents TList is a ZipDirEntry record:

   ZipDirEntry = packed Record
     Version                     : WORD;
     Flag                        : WORD;
     CompressionMethod           : WORD;
     DateTime                    : Longint; { Time: Word; Date: Word; }
     CRC32                       : Longint;
     CompressedSize              : Longint;
     UncompressedSize            : Longint;
     FileNameLength              : WORD;
     ExtraFieldLength            : WORD;
     FileName                    : String;
   end;

   To get compression ratio:
   (code from Almer Tigelaar, tigelaar@tref.nl)
   var
      ratio: Integer;
   begin
      with ZipDirEntry1 do
         ratio:=Round((1-(CompressedSize/UnCompressedSize))*100);
   ---------------------------------------------------------------------

     Cancel       Boolean     If you set this to True, it will abort any
                              Add or Extract processing now underway.  There
                              may be a slight delay before the abort will
                              take place.  Note that a ZIP file can be
                              corrupted if an Add operation is aborted.

     ZipBusy      Boolean     If True, a ZIP operation is underway - you
                              must delay your next Add/Delete operation
                              until this is False.  You won't need to be
                              concerned about this in most applications.
                              This can be used to syncronize Zip operations
                              in a multi-threaded program.

     UnzBusy      Boolean     If True, an UNZIP operation is underway -
                              you must delay your next Extract operation
                              until this is False.  You won't need to be
                              concerned about this in most applications.
                              This can be used to syncronize UnZip
                              operations in a multi-threaded program.

     AddCompLevel Integer     Compression Level.  Range 0 - 9, where 9
                              is the tightest compression.  2 or 3 is a
                              good trade-off if you need more speed. Level 0
                              will just store files without compression.
                              I recommend leaving this at 9 in most cases.

     AddOptions   Set         This property is used to modify the default
                              action of the Add method.  This is a SET of
                              options.  If you want an option to be True,
                              you need to add it to the set.  This is
                              consistant with the way Delphi deals with
                              "options" properties in general.

        AddDirNames           If True, saves the pathname with each fname.
                              Drive IDs are never stored in ZIP file 
                              directories. NOTE: the root directory name is
                              never stored in a pathname; in other words,
                              the first character of a pathname stored in
                              the zip file's directory will never be a slash.

        AddForceDOS           If True, force all filenames that go into
                              the ZIP file to meet the DOS 8x3 restriction.
                              If false, long filenames are supported.
                              WARNING: name conflicts can occur if 2 long
                              filenames reduce to the same 8x3 filename!

        AddZipTime            If True, set ZIP timestamp to that of the newest
                              file in the archive.

        AddRecurseDirs        If True, subdirectories below EACH given fspec
                              will be included in the fspec. Defaults to False.
                              This is potentially dangerous if the user does
                              this from the root directory (his hard drive
                              may fill up with a huge zip file)!

        AddHiddenFiles        If True, files with their Hidden or System
                              attributes set will be included in the Add
                              operation. 

        AddEncrypt            If True, add the files with standard zip
                              encryption.  You will be prompted for the
                              password to use.

        NOTE: You can not have more than one of the following three options
              set to "True".  If all three are False, then you get a standard
              "add": all files in the fspecs will be added to the archive
              regardless of their date/time stamp.  This is also the default.

        AddMove               If True, after adding to archive, delete orig
                              file.  Potentially dangerous.  Use with caution!

        NOTE: Freshen and Update can only work on pre-existing archives. Update
        can add new files to the archive, but can't create a new archive.

        AddFreshen            If True, add newer files to archive (only for
                              files that are already in the archive).

        AddUpdate             If True, add newer files to archive (but, any
                              file in an fspec that isn't already in the
                              archive will also be added).

     ExtrBaseDir  String      This base directory applies only to "Extract"
                              operations.  The UNZIP DLL will "CD" to this
                              directory before extracting any files. If you
                              don't specify a value for this property, then the
                              directory of the ZipFile itself will be the
                              base directory for extractions.

     ExtrOptions  set         This property is used to modify the default
                              action of the Extract method.  This is a SET
                              of options.  If you want an option to be
                              True, you need to add it to the set.

        ExtrDirNames          If True, extracts and recreates the relative
                              pathname that may have been stored with each file.
                              Empty dirs stored in the archive (if any) will
                              also be recreated.

        ExtrOverWrite         If True, overwrite any pre-existing files during
                              Extraction.

        ExtrFreshen           If True, extract newer files from archive (only 
                              for files that already exist).  Won't extract
                              any file that isn't already present.

        ExtrUpdate            If True, extract newer files from archive (but,
                              also extract files that don't already exist).

        ExtrTest              If True, only test the archive to see if the
                              files could be sucessfully extracted.  This is
                              done by extracting the files, but NOT saving the
                              extracted data.  Only the CRC code of the files
                              is used to determine if they are stored correctly.
                              To use this option, you will also need to define
                              an Event handler for OnMessage.
                                 IMPORTANT: In this release, you must test all
                              files - not just some of them.

     NOTE: there is no decryption property for extraction.
     If an encrypted file is encountered, the user will be
     automatically prompted for a password.

     FSpecArgs    TStrings    Stringlist containing all the filespecs used
                              as arguments for Add, Delete, or Extract
                              methods. Every entry can contain MS-DOS wildcards.
                              If you give filenames without pathnames, or if
                              you use relative pathnames with filenames, then
                              the base drive/directory is assumed to be that
                              of the Zipfile.

     ZipFilename  String      Pathname of a ZIP archive file.  If the file
                              doesn't already exist, you will only be able to
                              use the Add method.  I recommend using a fully
                              qualified pathname in this property, unless
                              your program can always ensure that a known
                              directory will be the "current" directory.

     Count        Integer     Number of files now in the Zip file.  Updated
                              automatically, or manually via the List method.

     SuccessCnt   Integer     Number of files that were successfully
                              operated on (within the current ZIP file).
                              You can read this after every Add, Delete, and
                              Extract operation.

     ZipVers      Integer     The version number of the ZIPDLL.DLL.  For
                              example, 140 = version 1.40.

     UnzVers      Integer     The version number of the UNZDLL.DLL.  For
                              example, 140 = version 1.40.

     Password     String      The user's encryption/decryption password.
                              This property is not needed if you want to
                              let the DLLs prompt the user for a password.
                              This is only used if you want to prompt the
                              user yourself.
                                 WARNING! If you set the password in the
                              Object Inspector, and you never change the
                              password property at runtime, then your
                              users will never be able to use any other
                              password.  If you leave it blank, the DLLs
                              will prompt users each time a password is
                              needed.

     DLLDirectory String      Allows manual specification of the directory
                              used to hold ZIPDLL.DLL and UNZDLL.DLL.  Should
                              NOT end in a slash.  This is an optional
                              property. If used, it overrides the Windows
                              search path for DLLs.  If you specify a dirname
                              here, but the DLLs are not actually in that dir,
                              then the standard Windows search path will be 
                              consulted, anyway.

     SFXPath      String      Points to the ZIPSFX.BIN file.  Must include
                              the whole pathname, filename, and extension.
                              This is only used by the ConvertSFX method.
                              As a convenience for you, ZipMaster will
                              look in the Windows dir, and in the Windows
                              System dir for this file, in case you don't
                              want to use this property.

     SFXOverWriteMode  enum   This is the default overwrite option for what
                              the SFX program is supposed to do if it finds 
                              files that already exist.  If option 
                              "SFXHideOverWriteBox" is true, then this option 
                              will be used during extraction.  
                                 These are the possible values for this
                              property:
                                ovrConfirm - ask user when each file is found
                                ovrAlways - always overwrite existing files
                                ovrNever - never overwrite - skip those files
                              The default is "ovrConfirm".

     SFXCaption      String   The caption of the SFX program's dialog box at
                              runtime. The default is 'Self-extracting Archive'.

     SFXDefaultDir   String   The default target directory for extraction of
                              files at runtime.  This can be changed at 
                              runtime through the dialog box. If you don't 
                              specify a value for this optional property, the 
                              user's current directory will be the default.

     SFXCommandLine  String   This command line will be executed immediately
                              after extracting the files.  Typically used to 
                              show the the readme file, but can do anything.
                              There is a predefined symbol that can be used 
                              in the command line to tell you which target
                              directory was actually used (since the user can
                              always change your default).
                              Special symbols: "|" is the command/arg separator,
                              "><" is the actual extraction dir selected by user
                              Example:
                                  notepad.exe|><readme.txt
                              Run notepad to show "readme.txt" in the actual
                              extraction directory. 
                                This is an optional property.

     SFXOptions   Set         This property is used to modify the default
                              action of the ConvertSFX method.  This is a 
                              SET of options.  If you want an option to be 
                              True, you need to add it to the set.  This is
                              consistant with the way Delphi deals with
                              "options" properties in general.

        SFXAskCmdLine         If true, allows user (at runtime) to de-select
                              the SFX program's command line checkbox. Once 
                              de-selected, the command line will not be run.
                              NOTE: The checkbox doesn't appear unless there
                              is a command line specified.

        SFXAskFiles           If true, lets user (at runtime) modify the 
                              SFX program's list of files to be extracted.

        SFXHideOverWriteBox   If true, does NOT show the user (at runtime)
                              the SFX program's dialog box that lets him 
                              choose the overwrite action for files that
                              already exist.


   Events
   ======
     OnDirUpdate              Occurs immed. after this VCL refreshes it's
                              TZipContents TList.  This is your queue to
                              update the screen with the new contents.

     OnProgress               Occurs during compression and decompression.
                              Intended for "status bar" or "progress bar"
                              updates.  Criteria for this event:
                                - starting to process a new file (gives you
                                    the filename and total uncompressed
                                    filesize)
                                - every 32K bytes while processing
                                - completed processing on a batch of files
                              See Demo1 to learn how to use this event.

     OnMessage                Occurs when the DLL sends your program a message.
                              The Message argument passed by this event will
                              contain the message. If an error code
                              accompanies the message, it will be in the
                              ErrCode argument.
                                 The Verbose and Trace properties have a
                              direct influence on how many OnMessage events
                              you'll get.
                                 See Also: Message and ErrCode properties.

   Methods
   =======
     Add                      Adds all files specified in the FSpecArgs
                              property into the archive specified by the
                              ZipFilename property. 
                                Files that are already compressed will not be
                              compressed again, but will be stored "as is" in
                              the archive. This applies to .GIF, .ZIP, .LZH,
                              etc. files. Note that .JPG files WILL be
                              compressed, since they can still be squeezed
                              down in size by a notable margin.

     Extract                  Extracts all files specified in the FSpecArgs
                              property from the archive specified by the
                              ZipFilename property. If you don't specify
                              any FSpecArgs, then all files will be extracted.
                              Can also test the integrity of files in an
                              archive.
                                If you set the ExtrTest option of ExtrOptions,
                              then ALL files in the arive will be tested.
                              This will cause them to be extracted, but not
                              saved to the hard disk.  Their CRC will be
                              verified, and results will go to the SuccessCnt
                              property, and the OnMessage event handler.

     Delete                   Deletes all files specified in the FSpecArgs
                              property from the archive specified by the
                              ZipFilename property.

     List                     Refreshes the contents of the archive into 
                              the ZipContents TList property.  This is
                              a manual "refresh" of the "Table of Contents".

     CopyFile                 This copies any file to any other file.
                              Useful in many application programs, so 
                              it was included here as a method.  This returns
                              0 on success, or else one of these errors:
                                  -1   error in open of outfile
                                  -2   read or write error during copy
                                  -3   error in open of infile
                                  -4   error setting date/time of outfile
                                  -9   general failure during copy
                              Can be used to make a backup copy of the 
                              ZipFile before an Add operation.
                              Sample Usage:
                                with ZipMaster1 do
                                begin
                                   ret=CopyFile(ZipFilename, 'C:\TMP$$.ZIP');
                                   if ret < 0 then
                                      ShowMessage('Error making backup');
                                end;

     IMPORTANT note regarding CopyFile: The destination must include
     a filename (you can't copy fname.txt to C:\).  Also, Wildcards are
     not allowed in either source or dest.

     ------------------------------------------------------------------------
     Encrypted Archive Support - new in v1.30

     Thanks to Mike Wilkey <mtw@allways.net> for his very useful source
     code and helpful comments.  He basically got this functionality
     working by himself.  I just plugged in his result to TZipMaster.
     The source for the actual encryption algorithm is the overseas link
     pointed-to by InfoZip.  I have learned that this is NOT being controlled
     by the US government, so I am including it with this release.

     GetAddPassword           Prompt user for a password.  The password
                              will be accepted twice - the second time to
                              verify it.  If both of them match, it will
                              be saved in the Password property, or else
                              the Password property will be cleared.
                                The use of this method is not required.
                              If you want to make your own password prompt
                              dialog box, you can just put the password
                              into the password property yourself.  Also,
                              you can take the easiest route by leaving the
                              password property blank, and letting the 
                              DLLs prompt the user for the password.

     GetExtrPassword          Prompt user for a password.  The password
                              will only be accepted once. It will be
                              saved in the Password property.
                                The use of this method is not required.
                              If you want to make your own password prompt 
                              dialog box, you can just put the password
                              into the password property yourself.  Also,
                              you can take the easiest route by leaving the
                              password property blank, and letting the 
                              DLLs prompt the user for the password.


     IMPORTANT notes about Password:

     - The "GetAddPassword" and "GetExtrPassword" methods are optional.
       You have 3 different ways of getting a user's password:

        1) Call the "GetAddPassword" and/or the "GetExtrPassword" methods,
           just before add or extract.

        2) Use your own code to set the "Password" property.  It's your
           choice how you obtain the password.  
             - This is useful if the password comes from a file or table.
             - It's also good for letting you enforce constraints on the
           password - you can require it to be over 6 chars, require it
           to have at least one special char, etc.  Of course, you'd only
           want to enforce constrainst on "Add" operations.  A word of
           caution: many users don't like password constraints, so give
           them the option to turn them off.

        3) Don't set one at all, and let the DLLs prompt the user.
           It's easy, and it works.

     - Passwords can not be longer than 80 characters.  A zero-length
       password is the same as no password at all.

     - To "zero out" the password, set it's property to an empty string.
       If it is zero'd out, but the AddEncrypt option is set, then the
       user will be prompted for a new password by the DLLs. So, if you
       don't want a password used, make sure you turn off "AddEncrypt",
       and you zero-out the password.  

     - If you set a password for an Extract, but it is incorrect, then
       the DLLs will NOT prompt the user for another password.

     - If the user enters a password at an automatic prompt generated
       by the DLL, then you can NOT get access to that password from
       your program.  If you want to know what it is, you need to prompt
       for it yourself.

     - To Force the DLL to AVOID decrypting an encrypted file, you must
       set the password property to an unlikely password (all periods,
       for example).  If adding, make sure AddEncrypt is NOT set.

     -------------------------------------------------------------------------
     Self Extracting Archive Support - New in v1.30

     Thanks to Carl Bunton for the actual SFX code.  This is a very big
     undertaking, and he did a great job.  He also makes good compression
     VCLs (called ZipTV) for Delphi.  They are shareware, but his profits
     go to a children's hospital.  He supports many archive formats, not
     just ZIP.  Check out his Web site:
                    http://www.concentric.net/~twojags

     ConvertSFX               Convert zip archive to self-extracting .EXE.
                              The resulting .EXE is a Win32 program.
                              Uses the same base name and path already
                              used by the zipfile - only the file extension
                              is changed to .EXE. This is accompished by
                              prepending the SFX code onto the front of
                              the zip file, and then changing it's extension.

     IMPORTANT! - before using ConvertSFX, you may want to first set the
       SFXPath property to the full pathname of the SFX code: ZIPSFX.BIN.
       If you don't set this property, ZipMaster will automatically look for
       this file in the Windows and Windows System directories.

     ConvertZIP               Convert self-extracting .EXE to .ZIP archive.
                              Converts a self-extracting .exe file into a
                              zip archive.  This is accomplished by removing
                              the SFX code from the beginning, and then
                              changing it's extension.

     WARNING: The use of ConvertZip can NOT be guaranteed to work with
        all self-extracting archive formats.  It will work on MS-DOS "pkzip"
        (product of pkware) self-extracting zip archives, and on those made 
        by "WinZip" (product of Nikko Mak Computing), but some self-extracting
        formats are not even based on zip compression.
           For example, the freeware "ASetup" program uses the .LZH
        compression format.  In fact, most setup programs use compression
        formats that aren't zip compatible.
           If you try to use ConvertZip on an archive that doesn't
        conform to the zip standard, you will get errors.  If fact, you
        can't even list the contents of an .EXE archive if it's not a
        standard zip format.

   --------------------------------------------------------------------
                       DLL Loading and Unloading

   This table show you which DLL is needed for each method:
       Add        requires ZIPDLL.DLL
       Delete     requires ZIPDLL.DLL
       Extract    requires UNZDLL.DLL
       List            none (internal code in this VCL)
       CopyFile        none (internal code in this VCL)
       GetAddPassword  none (internal code in this VCL)
       GetExtrPassword none (internal code in this VCL)
       ConvertSFX      none (internal code to this VCL)
       ConvertZIP      none (internal code to this VCL)
   NOTE: "Test" is a sub-option of extract.

   The following 4 methods give you explicit control over loading and
   unloading of the DLLs.  For simplicity, you can do the loads in
   your form's OnCreate event handler, and do the unloads in your
   form's OnDestroy event handler.

      Load_Zip_Dll    --  Loads ZIPDLL.DLL, if not already loaded
      Load_Unz_Dll    --  Loads UNZDLL.DLL, if not already loaded
      Unload_Zip_Dll  --  Unloads ZIPDLL.DLL
      Unload_Unz_Dll  --  Unloads UNZDLL.DLL

   For compatibility with older programs, and because I'm a nice
   guy, I'll handle the loads and unloads automatically if your
   program doesn't do it.  This can, however, incur a perfomance
   penalty because it will reload the needed DLL for each operation.

   Advanced developers will want to carefully consider their load
   and unload strategy so they minimize the number of loads, and
   keep the DLLs out of memory when they're not needed. There is a
   traditional speed vs. memory trade-off.
  --------------------------------------------------------------------
*)

interface

uses
  forms, WinTypes, WinProcs, SysUtils, Classes, Messages, Dialogs, Controls,
  FileCtrl, ZipDLL, UnzDLL, ZCallBck;

type
  EInvalidOperation = class(exception);

type ZipDirEntry = packed Record
  Version                     : WORD;
  Flag                        : WORD;
  CompressionMethod           : WORD;
  DateTime                    : Longint; { Time: Word; Date: Word; }
  CRC32                       : Longint;
  CompressedSize              : Longint;
  UncompressedSize            : Longint;
  FileNameLength              : WORD;
  ExtraFieldLength            : WORD;
  FileName                    : String;
end;

type
  PZipDirEntry = ^ZipDirEntry;

const   { these are stored in reverse order }
  LocalFileHeaderSig   = $04034b50; { 'PK'34  (in file: 504b0304) }
  CentralFileHeaderSig = $02014b50; { 'PK'12 }
  EndCentralDirSig     = $06054b50; { 'PK'56 }

type
  ProgressType = ( NewFile, ProgressUpdate, EndOfBatch );

  AddOptsEnum = ( AddDirNames, AddRecurseDirs, AddMove, AddFreshen, AddUpdate,
                  AddZipTime,  AddForceDOS, AddHiddenFiles, AddEncrypt);
  AddOpts = set of AddOptsEnum;

  ExtrOptsEnum = ( ExtrDirNames, ExtrOverWrite, ExtrFreshen, ExtrUpdate,
                   ExtrTest );
  ExtrOpts = set of ExtrOptsEnum;

  SFXOptsEnum = ( SFXAskCmdLine, SFXAskFiles, SFXHideOverWriteBox );
  SFXOpts = set of SFXOptsEnum;
  
  OvrOpts = ( OvrConfirm, OvrAlways, OvrNever );

  TProgressEvent = procedure(Sender : TObject;
          ProgrType: ProgressType;
          Filename: String;
          FileSize: Longint) of object;

  TMessageEvent = procedure(Sender : TObject;
          ErrCode: Integer;
          Message : String) of object;

  TZipMaster = class(TComponent)
  private
    { Private versions of property variables }
    FHandle:       Integer;
    FVerbose:      Boolean;
    FTrace:        Boolean;
    FErrCode:      Integer;
    FMessage:      String;
    FZipContents:  TList;
    FExtrBaseDir:  String;
    FCancel:       Boolean;
    FZipBusy:      Boolean;
    FUnzBusy:      Boolean;
    FAddOptions:   AddOpts;
    FExtrOptions:  ExtrOpts;
    FSFXOptions:   SFXOpts;
    FFSpecArgs:    TStrings;
    FZipFilename:  String;
    FSuccessCnt:   Integer;
    FAddCompLevel: Integer;
    FPassword:     ShortString;
    FSFXPath:      String;
    FEncrypt:      Boolean;
    FSFXOffset:    LongInt;
    FDLLDirectory: String;
    FSFXOverWriteMode: OvrOpts; //ovrConfirm  (others: ovrAlways, ovrNever)
    FSFXCaption:       String;  // dflt='Self-extracting Archive'
    FSFXDefaultDir:    String;  // dflt=''
    FSFXCommandLine:   String;  // dflt=''

    { misc private vars }
    ZipParms1: ZipParms;     { declare an instance of ZipParms }
    UnZipParms1: UnZipParms; { declare an instance of UnZipParms }

    { Event variables }
    FOnDirUpdate    : TNotifyEvent;
    FOnProgress     : TProgressEvent;
    FOnMessage      : TMessageEvent;

    { Property get/set functions }
    function  GetCount: Integer;
    procedure SetFSpecArgs(Value : TStrings);
    procedure SetFilename(Value: String);
    function  GetZipVers: Integer;
    function  GetUnzVers: Integer;
    procedure SetDLLDirectory(Value: String);

    { Private "helper" functions }
    procedure FreeZipDirEntryRecords;
    procedure SetZipSwitches;
    procedure SetUnZipSwitches;

  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    { Public Properties (run-time only) }
    property Handle:       Integer   read FHandle write FHandle;
    property ErrCode:      Integer   read FErrCode;
    property Message:      String    read FMessage;
    property ZipContents:  TList     read FZipContents;
    property Cancel:       Boolean   read FCancel
                                     write FCancel;
    property ZipBusy:      Boolean   read FZipBusy;
    property UnzBusy:      Boolean   read FUnzBusy;

    property Count:        Integer   read GetCount;
    property SuccessCnt:   Integer   read FSuccessCnt;

    property ZipVers:   Integer   read GetZipVers;
    property UnzVers:   Integer   read GetUnzVers;

    { Public Methods }
    { NOTE: Test is an sub-option of extract }
    procedure Add;
    procedure Delete;
    procedure Extract;
    procedure List;
    procedure Load_Zip_Dll;
    procedure Load_Unz_Dll;
    procedure Unload_Zip_Dll;
    procedure Unload_Unz_Dll;
    function  CopyFile(const InFileNAme, OutFileName: String):Integer;
    function  ConvertSFX:Integer;
    function  ConvertZIP:Integer;
    procedure GetAddPassword;
    procedure GetExtrPassword;

  published
    { Public properties that also show on Object Inspector }
    property Verbose:      Boolean  read FVerbose
                                    write FVerbose;
    property Trace:        Boolean  read FTrace
                                    write FTrace;
    property AddCompLevel: Integer  read FAddCompLevel
                                    write FAddCompLevel;
    property AddOptions:   AddOpts  read FAddOptions
                                    write FAddOptions;
    property ExtrBaseDir:  String   read FExtrBaseDir
                                    write FExtrBaseDir;
    property ExtrOptions:  ExtrOpts read FExtrOptions
                                    write FExtrOptions;
    property SFXOptions:   SfxOpts  read FSFXOptions
                                    write FSFXOptions;
    property FSpecArgs:    TStrings read FFSpecArgs
                                    write SetFSpecArgs;

    { At runtime: every time the filename is assigned a value, 
      the ZipDir will automatically be read. }
    property ZipFilename: String  read FZipFilename
                                  write SetFilename;

    property Password:     ShortString  read FPassword
                                        write FPassword;
    property SFXPath:      String       read FSFXPath      
                                        write FSFXPath;
    property DLLDirectory: String       read FDLLDirectory 
                                        write SetDLLDirectory;
    property SFXOverWriteMode: OvrOpts  read FSFXOverWriteMode 
                                        write FSFXOverWriteMode;
    property SFXCaption:       String   read FSFXCaption
                                        write FSFXCaption;
    property SFXDefaultDir:    String   read FSFXDefaultDir 
                                        write FSFXDefaultDir;
    property SFXCommandLine:   String   read FSFXCommandLine
                                        write FSFXCommandLine;

    { Events }
    property OnDirUpdate         : TNotifyEvent   read FOnDirUpdate
                                                  write FOnDirUpdate;
    property OnProgress          : TProgressEvent read FOnProgress
                                                  write FOnProgress;
    property OnMessage           : TMessageEvent  read FOnMessage
                                                  write FOnMessage;
  end;

procedure Register;

{ The callback function must NOT be a member of a class }
{ We use the same callback function for ZIP and UNZIP }
function ZCallback(ZCallBackRec: PZCallBackStruct): LongBool; stdcall; export;

function StripJunkFromString(s: String): String;

implementation

const
  LocalDirEntrySize = 26;   { size of zip dir entry in local zip directory }

{ Dennis Passmore (Compuserve: 71640,2464) contributed the idea of passing an
  instance handle to the DLL, and, in turn, getting it back from the callback.
  This lets us referance variables in the TZipMaster class from within the
  callback function.  Way to go Dennis! }
function ZCallback(ZCallBackRec: PZCallBackStruct): LongBool; stdcall; export;
var
  Msg: String;
begin
   with ZCallBackRec^, (TObject(Caller) as TZipMaster) do
   begin
      if ActionCode = 1 then
         { progress type 1 = starting any ZIP operation on a new file }
         if assigned(FOnProgress) then
            FOnProgress(Caller, NewFile, StrPas(FilenameOrMsg), FileSize);

      if ActionCode = 2 then
         { progress type 2 = increment bar }
         if assigned(FOnProgress) then
            FOnProgress(Caller, ProgressUpdate, ' ', 0);

      if ActionCode = 3 Then
         { end of a batch of 1 or more files }
         if assigned(FOnProgress) then
            FOnProgress(Caller, EndOfBatch, ' ', 0);

      if ActionCode >= 4 Then
         { show a routine status message }
         if assigned(FOnMessage) then
         begin
            Msg:=StripJunkFromString(StrPas(FilenameOrMsg));
            FOnMessage(Caller, ErrorCode, Msg);
         end;

      { If you return TRUE, then the DLL will abort it's current
        batch job as soon as it can. }
      if fCancel then
         result:=True
      else
         result:=False;
    end; { end with }
end;

function StripJunkFromString(s: String): String;
var
   EndPos: Integer;
begin
   { Remove possible trailing CR or LF }
   EndPos:=Length(s);
   if ((s[EndPos] = #13)
    or (s[EndPos] = #10)) then
       s[EndPos] := #0;
   if EndPos > 1 then
   begin
      if ((s[EndPos-1] = #13)
       or (s[EndPos-1] = #10)) then
          s[EndPos-1] := #0;
   end;
   result:=s;
end;

constructor TZipMaster.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FHandle:=(AOwner as TForm).handle;
  FZipContents:=TList.Create;
  FFSpecArgs := TStringList.Create;

  FZipFilename := '';
  FPassword := '';
  FSFXPath := '';
  FEncrypt:=False;
  FSuccessCnt:=0;
  FAddCompLevel:=9;  { dflt to tightest compression }
  FDLLDirectory:='';
  FSFXOverWriteMode:=ovrConfirm;
  FSFXCaption:='Self-extracting Archive';
  FSFXDefaultDir:='';
  FSFXCommandLine:='';
end;

destructor TZipMaster.Destroy;
begin
  FreeZipDirEntryRecords;
  FZipContents.Free;
  FFSpecArgs.Free;
  inherited Destroy;
end;

function TZipMaster.GetZipVers: Integer;
var
   AutoLoad: Boolean;
begin
   result:=0;
   if ZipDllHandle = 0 then
   begin
      AutoLoad:=True;  // user's program didn't load the DLL
      Load_Zip_Dll;    // load it
   end
   else
      AutoLoad:=False;  // user's pgm did load the DLL, so let him unload it
   if ZipDllHandle = 0 then
      exit;  // load failed - error msg was shown to user

   result:=GetZipDLLVersion;

   if AutoLoad then
      Unload_Zip_Dll;
end;

function TZipMaster.GetUnzVers: Integer;
var
   AutoLoad: Boolean;
begin
   result:=0;
   if UnzDllHandle = 0 then
   begin
      AutoLoad:=True;  // user's program didn't load the DLL
      Load_Unz_Dll;    // load it
   end
   else
      AutoLoad:=False;  // user's pgm did load the DLL, so let him unload it
   if UnzDllHandle = 0 then
      exit;  // load failed - error msg was shown to user

   result:=GetUnzDLLVersion;

   if AutoLoad then
      Unload_Unz_Dll;
end;

{ We'll normally have a TStringList value, since TStrings itself is an
  abstract class. }
procedure TZipMaster.SetFSpecArgs(Value : TStrings);
begin
   FFSpecArgs.Assign(Value);
end;

procedure TZipMaster.SetFilename(Value : String);
begin
   FZipFilename := Value;
   if not (csDesigning in ComponentState) then
      List; { automatically build a new TLIST of contents in "ZipContents" }
end;

// NOTE: we will allow a dir to be specified that doesn't exist,
// since this is not the only way to locate the DLLs.
procedure TZipMaster.SetDLLDirectory(Value: String);
var
   ValLen: Integer;
begin
   if Value <> FDLLDirectory then 
   begin
      ValLen := Length(Value);
      // if there is a trailing \ in dirname, cut it off:
      if ValLen > 0 then
         if Value[ValLen] = '\' then 
            SetLength(Value, ValLen-1); // shorten the dirname by one
      FDLLDirectory := Value;
   end;
end;

function TZipMaster.GetCount:Integer;
begin
   if FZipFilename <> '' then
      Result:=FZipContents.Count
   else
      Result:=0;
end;

{ Empty FZipContents and free the storage used for dir entries }
procedure TZipMaster.FreeZipDirEntryRecords;
var
   i: integer;
begin
   if FZipContents.Count = 0 then
      Exit;
   for i:= (FZipContents.Count - 1) downto 0 do
   begin
      if Assigned(FZipContents[i]) then
         // dispose of the memory pointed-to by this entry
         Dispose(PZipDirEntry(FZipContents[i]));
      FZipContents.Delete(i); // delete the TList pointer itself
   end; { end for }
   // The caller will free the FZipContents TList itself, if needed
end;

{ The Delphi code used in the List method is based on the TZReader VCL by
  Dennis Passmore (Compuserve: 71640,2464).  This "list" code is also used
  in the ZIPDIR VCL used by Demo3. TZReader was inspired by Pier Carlo Chiodi
  pc.chiodi@mbox.thunder.it }
{ This version fixes an odd bug reported by Markus Stephany.  Zip
  self-extracting archives created by WinZip can have their first local
  signature on any byte - we normally expect it to be aligned to 32
  bits.  This fix makes it a little slower to read the dir of self-
  extracting archives, but at least it will work right in every case now! }
{ The List method reads thru all entries in the local Zip directory.
  This is triggered by an assignment to the ZipFilename, or by calling
  this method directly. }
procedure TZipMaster.List;  { all work is local - no DLL calls }
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
     Exit;  { can't do LIST at design time }

  { zero out any previous entries }
  FreeZipDirEntryRecords;

  if not FileExists(FZipFilename) then
  begin
     { let user's program know there's no entries }
     if assigned(FOnDirUpdate) then
        FOnDirUpdate(self);
     Exit; { don't complain - this may intentionally be a new zip file }
  end;

  FirstEntryFound:=False;
  Count:=0;
  FSFXOffset:=0;
  ZipStream := TFileStream.Create(FZipFilename,fmOpenRead OR fmShareDenyWrite);
  if UpperCase(ExtractFileExt(FZipFilename)) = '.EXE' then
     // The smallest ZipSfx code is a little bigger than 14K.  We'll skip
     // the first 14K, since a valid zip entry can't be so early in file
     ZipStream.Seek(14000,soFromBeginning);
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
           begin
              {raise EStreamError.create('Error reading Zip File');}
              ShowMessage('No valid zip entries found');
              break;
           end;
           Inc(Count);
           { We'll allow 50000 attempts to find byte 1 of a local header. }
           { Most variations of self-extracting code should be under 60K. }
           if Count > 60000 then
           begin
              {FZipFilename:='';}
              {raise EStreamError.create('Error reading Zip File');}
              ShowMessage('No valid zip entries found');
              break;
           end;
           if Byt <> $50 then
              continue;

           Res:=ZipStream.Read(Byt,1);
           if (Res = HFILE_ERROR) or (Res <> 1) then
           begin
              {raise EStreamError.create('Error 1b reading Zip File');}
              ShowMessage('No valid zip entries found');
              break;
           end;
           if Byt <> $4b then
              continue;

           Res:=ZipStream.Read(Byt,1);
           if (Res = HFILE_ERROR) or (Res <> 1) then
           begin
              {raise EStreamError.create('Error 1c reading Zip File');}
              ShowMessage('No valid zip entries found');
              break;
           end;
           if Byt <> $03 then
              continue;

           Res:=ZipStream.Read(Byt,1);
           if (Res = HFILE_ERROR) or (Res <> 1) then
           begin
              {raise EStreamError.create('Error 1d reading Zip File');}
              ShowMessage('No valid zip entries found');
              break;
           end;
           if Byt <> $04 then
              continue;

           FirstEntryFound:=True; { next time, we'll read 32 bits at a time }
           Sig:=LocalFileHeaderSig;  { we've read all 4 bytes }
           FSFXOffset:=ZipStream.Position - 4; { subt. size of signature }
        end
        else
        begin
           Res := ZipStream.Read(Sig, SizeOf(Sig));
           if (Res = HFILE_ERROR) or (Res <> SizeOf(Sig)) then
              raise EStreamError.create('Error reading Zip File');
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
           and (ZipStream.Read(Name, FilenameLength)=FilenameLength) then
              Filename := Copy(Name, 0, FilenameLength)
           else
           begin
              dispose(ZipDirEntry);  { bad entry - free up memory for it }
              if FZipContents.Count = 0 then
              begin
                 { test code to see if we can ignore problems with some
                   SFX code that contains a false local signature }
                 FirstEntryFound:=False;
                 continue;
              end
              else
                 raise EStreamError.create('Error 2 reading Zip file');
           end;


           if (ZipStream.Position + ZipDirEntry^.ExtraFieldLength +
            ZipDirEntry^.CompressedSize) > (ZipStream.Size - 22) then
           begin
              { should never happen in normal .zip due to presence of central dir }
              if FZipContents.Count = 0 then
              begin
                 { test code to see if we can ignore problems with some
                   SFX code that contains a false local signature }
                 FirstEntryFound:=False;
                 continue;
              end
              else
              begin
                 raise EStreamError.create('Error 3 reading Zip file');
                 break;
              end
           end;

           with ZipDirEntry^ do
           begin
              if ExtraFieldLength > 0 then
              begin
                 { skip over the extra fields }
                 res := (ZipStream.Position + ExtraFieldLength);
                 if ZipStream.Seek(ExtraFieldLength, soFromCurrent) <> res then
                    raise EStreamError.create('Error 4 reading Zip file');
              end;

              { skip over the compressed data for the file entry just parsed }
              res := (ZipStream.Position + CompressedSize);
              if ZipStream.Seek(CompressedSize, soFromCurrent) <> res then
                 raise EStreamError.create('Error 5 reading Zip file');
           end;

           {===============================================================}
           FZipContents.Add(pointer(ZipDirEntry)); // EWE: moved due to sfx code
        end  { end of local stuff }

        else
           { we're not going to read the Central or End directories }
           if (Sig = CentralFileHeaderSig) or (Sig = EndCentralDirSig) then
              break;   { found end of local stuff - we're done }
     end;  { end of loop }

  finally
     ZipStream.Free;
     { let user's program know we just refreshed the zip dir contents }
     { bug fix - moved this inside the finally clause }
     if assigned(FOnDirUpdate) then
        FOnDirUpdate(self);
  end;  { end of try...finally }

end;

procedure TZipMaster.SetZipSwitches;
begin
   with ZipParms1 do
   begin
      Version:=140;    // version we expect the DLL to be
      Caller := Self;  // point to our VCL instance; returned in callback

      Handle:=FHandle; { used for DLL dialogs - esp: password }
      fQuiet:=True;  { we'll report errors upon notification in our callback }
                     { So, we don't want the DLL to issue error dialogs }

      ZCallbackFunc:=ZCallback; // pass addr of function to be called from DLL
      fJunkSFX:=False;      { if True, convert input .EXE file to .ZIP }
      fComprSpecial:=False; { if True, try to compr already compressed files }
      fSystem:=False;    { if True, include system and hidden files }
      fVolume:=False;    { if True, include volume label from root dir }
      fExtra:=False;     { if True, include extended file attributes-NOT SUPTED }

      fDate:=False;      { if True, exclude files earlier than specified date }
      { Date:= '100592'; } { Date to include files after; only used if fDate=TRUE }

      fLevel:=FAddCompLevel; { Compression level (0 - 9, 0=none and 9=best) }
      fCRLF_LF:=False;      { if True, translate text file CRLF to LF (if dest Unix)}
      fGrow := True;        { if True, Allow appending to a zip file (-g)}

      seven:=7;             { used to QC the data structure passed to DLL }
      fDeleteEntries:=False; { distinguish bet. Add and Delete }

      if fTrace then
         fTraceEnabled:=True
      else
         fTraceEnabled:=False;
      if fVerbose then
         fVerboseEnabled:=True
      else
         fVerboseEnabled:=False;
      if (fTraceEnabled and not fVerbose) then
         fVerboseEnabled:=True;  { if tracing, we want verbose also }

      if AddForceDOS in fAddOptions then
         fForce:=True       { convert all filenames to 8x3 format }
      else
         fForce:=False;
      if AddZipTime in fAddOptions then
         fLatestTime:=True { make zipfile's timestamp same as newest file }
      else
         fLatestTime:=False;
      if AddMove in fAddOptions then
         fMove:=True      { dangerous, beware! }
      else
         fMove:=False;
      if AddFreshen in fAddOptions then
         fFreshen:=True
      else
         fFreshen:=False;
      if AddUpdate in fAddOptions then
         fUpdate:=True
      else
         fUpdate:=False;
      if (fFreshen and fUpdate) then
         fFreshen:=False;  { Update has precedence over freshen }

      if AddEncrypt in fAddOptions then
         fEncrypt := true      { DLL will prompt for password }
      else
         fEncrypt := false;

      { NOTE: if user wants recursion, then he probably also wants
        AddDirNames, but we won't demand it. }
      if AddRecurseDirs in fAddOptions then
         fRecurse:=True
      else
         fRecurse:=False;

      if AddHiddenFiles in fAddOptions then
         fSystem:=True
      else
         fSystem:=False;

      fNoDirEntries:=True;     { don't store dirnames by themselves }

      if AddDirNames in fAddOptions then
         fJunkDir:=False       { we want dirnames with filenames }
      else
         fJunkDir:=True;       { don't store dirnames with filenames }
   end; { end with }
end;

procedure TZipMaster.SetUnZipSwitches;
begin
   with UnZipParms1 do
   begin
      Version:=140;    // version we expect the DLL to be
      Caller := Self;  // point to our VCL instance; returned in callback

      Handle:=Fhandle;  { used for DLL dialogs - esp: password }
      fQuiet:=True;  { we'll report errors upon notification in our callback }
                     { So, we don't want the DLL to issue error dialogs }

      ZCallbackFunc:=ZCallback; // pass addr of function to be called from DLL

      if fTrace then
         fTraceEnabled:=True
      else
         fTraceEnabled:=False;
      if fVerbose then
         fVerboseEnabled:=True
      else
         fVerboseEnabled:=False;
      if (fTraceEnabled and not fVerboseEnabled) then
         fVerboseEnabled:=True;  { if tracing, we want verbose also }

      fQuiet:=True;     { no DLL error reporting }
      fComments:=False; { zipfile comments - not supported }
      fConvert:=False;  { ascii/EBCDIC conversion - not supported }
      seven:=7;         { used to QC the data structure passed to DLL }

      if ExtrDirNames in ExtrOptions then
         fDirectories:=True
      else
         fDirectories:=False;
      if ExtrOverWrite in fExtrOptions then
         fOverwrite:=True
      else
         fOverwrite:=False;

      if ExtrFreshen in fExtrOptions then
         fFreshen:=True
      else
         fFreshen:=False;
      if ExtrUpdate in fExtrOptions then
         fUpdate:=True
      else
         fUpdate:=False;
      if fFreshen and fUpdate then
         fFreshen:=False;  { Update has precedence over freshen }

      if ExtrTest in fExtrOptions then
         fTest:=True
      else
         fTest:=False;
   end; { end with }
end;

procedure TZipMaster.GetAddPassword;
var
   s1, s2: ShortString;
begin
   FPassword := '';
   s1 := InputBox('Password','Enter Password','');
   if (length(s1) >80) or (length(s1) = 0) then
      exit;

   s2 := InputBox('Password','Confirm Password','');
   if (length(s2) > 80) or (length(s2) = 0) then
      exit;

   if CompareStr(s1, s2) <> 0 then
      ShowMessage('Error - passwords do NOT match;' + #10#13
                    + 'Password ignored')
   else
      FPassword := s1;
end;

// Same as GetAddPassword, but does NOT verify
procedure TZipMaster.GetExtrPassword;
var
   s1: ShortString;
begin
   FPassword := '';
   s1 := InputBox('Password','Enter Password','');
   if (length(s1) > 80) or (length(s1) = 0) then
      exit;
   FPassword := s1;
end;

procedure TZipMaster.Add;
var
   i: Integer;
   AutoLoad: Boolean;
begin
   FSuccessCnt:=0;
   if fFSpecArgs.Count = 0 then
   begin
      ShowMessage('Error - no files to zip');
      Exit;
   end;
   { We must allow a zipfile to be specified that doesn't already exist,
     so don't check here for existance. }
   if FZipFilename = '' then   { make sure we have a zip filename }
   begin
      ShowMessage('Error - no zip file specified');
      Exit;
   end;

   { Make sure we can't get back in here while work is going on }
   if FZipBusy then
      Exit;
   FZipBusy := True;
   FCancel := False;

   if ZipDllHandle = 0 then
   begin
      AutoLoad:=True;  // user's program didn't load the DLL
      Load_Zip_Dll;    // load it
   end
   else
      AutoLoad:=False;  // user's pgm did load the DLL, so let him unload it
   if ZipDllHandle = 0 then
   begin
      FZipBusy:=False;
      exit;  // load failed - error msg was shown to user
   end;

   SetZipSwitches;
   with ZipParms1 do
   begin
      PZipFN := StrAlloc(256);  { allocate room for null terminated string }
      PZipPassword := StrAlloc(81);  { allocate room for null terminated string }
      StrPCopy(PZipFN, fZipFilename);    { name of zip file }
      StrPCopy(PZipPassword, FPassword); { password for encryption/decryption }
      argc:=0;  { init to zero }

      { Copy filenames from the Stringlist to new var's we will alloc
        storage for.  This lets us append the null needed by the DLL. }
      for i := 0 to (fFSpecArgs.Count - 1) do
      begin
         PFilenames[argc]:=StrAlloc(256);  { alloc room for the filespec }
         { ShowMessage(fFSpecArgs[i]); } { for debugging }
         StrPCopy(PFilenames[argc], fFSpecArgs[i]); { file to add to archive }
         argc:=argc+1;
      end;
      { argc is now the no. of filespecs we want deleted }
   end;  { end with }

   try
      { pass in a ptr to parms }
      fSuccessCnt:=ZipDLLExec(@ZipParms1);
   except
      ShowMessage('Fatal DLL Error: abort exception');
   end;

   fFSpecArgs.Clear;
   { Free the memory for the zipfilename and parameters }
   with ZipParms1 do
   begin
      { we know we had a filename, so we'll dispose it's space }
      StrDispose(PZipFN);
      StrDispose(PZipPassword);
      { loop thru each parameter filename and dispose it's space }
      for i := (argc - 1) downto 0 do
         StrDispose(PFilenames[i]);
   end;

   if AutoLoad then
      Unload_Zip_Dll;

   FCancel := False;
   FZipBusy := False;
   if fSuccessCnt > 0 then
      List;  { Update the Zip Directory by calling List method }
end;

procedure TZipMaster.Delete;
var
  i: Integer;
  AutoLoad: Boolean;
begin
  FSuccessCnt:=0;
  if fFSpecArgs.Count = 0 then
  begin
     ShowMessage('Error - no files selected for deletion');
     Exit;
  end;
  if not FileExists(FZipFilename) then
  begin
     ShowMessage('Error - no zip file specified');
     Exit;
  end;

  { Make sure we can't get back in here while work is going on }
  if FZipBusy then
     Exit;
  FZipBusy:= True;  { delete uses the ZIPDLL, so it shares the FZipBusy flag }
  FCancel:=False;

  if ZipDllHandle = 0 then
  begin
     AutoLoad:=True;  // user's program didn't load the DLL
     Load_Zip_Dll;    // load it
  end
  else
     AutoLoad:=False;  // user's pgm did load the DLL, so let him unload it
  if ZipDllHandle = 0 then
  begin
     FZipBusy:=False;
     exit;  // load failed - error msg was shown to user
  end;

  SetZipSwitches;
  { override "add" behavior assumed by SetZipSwitches: }
  with ZipParms1 do
  begin
     fDeleteEntries:=True;
     fGrow:=False;
     fJunkDir:=False;
     fMove:=False;
     fFreshen:=False;
     fUpdate:=False;
     fRecurse:=False;   // bug fix per Angus Johnson
     fEncrypt:=False;   // you don't need the pwd to delete a file
  end;

  with ZipParms1 do
  begin
      PZipFN := StrAlloc(256);  { allocate room for null terminated string }
      PZipPassword := StrAlloc(81);  { allocate room for null terminated string }
      StrPCopy(PZipFN, fZipFilename);  { name of zip file }
      StrPCopy(PZipPassword, FPassword); { password for encryption/decryption }
      argc:=0;

      { Copy filenames from the Stringlist to new var's we will alloc
        storage for.  This lets us append the null needed by the DLL. }
      for i := 0 to (fFSpecArgs.Count - 1) do
      begin
         PFilenames[argc]:=StrAlloc(256);  { alloc room for the filespec }
         { ShowMessage(fFSpecArgs[i]); } { for debugging }
         StrPCopy(PFilenames[argc], fFSpecArgs[i]); { file to del from archive }
         argc:=argc+1;
      end;
      { argc is now the no. of filespecs we want deleted }
   end;  { end with }

   try
      { pass in a ptr to parms }
      fSuccessCnt:=ZipDLLExec(@ZipParms1);
   except
      ShowMessage('Fatal DLL Error: abort exception');
   end;

   fFSpecArgs.Clear;

   { Free the memory }
   with ZipParms1 do
   begin
      StrDispose(PZipFN);
      StrDispose(PZipPassword);
      for i := (argc - 1) downto 0 do
         StrDispose(PFilenames[i]);
   end;

   if AutoLoad then
      Unload_Zip_Dll;
   FZipBusy:=False;
   FCancel:=False;
   if fSuccessCnt > 0 then
      List;  { Update the Zip Directory by calling List method }
end;

procedure TZipMaster.Extract;
var
  i: Integer;
  AutoLoad: Boolean;
begin
  FSuccessCnt:=0;
  if not FileExists(FZipFilename) then
  begin
     ShowMessage('Error - no zip file specified');
     Exit;
  end;

  { Make sure we can't get back in here while work is going on }
  if FUnzBusy then
     Exit;
  FUnzBusy := True;
  FCancel := False;

  if UnzDllHandle = 0 then
  begin
     AutoLoad:=True;  // user's program didn't load the DLL
     Load_Unz_Dll;    // load it
  end
  else
     AutoLoad:=False;  // user's pgm did load the DLL, so let him unload it
  if UnzDllHandle = 0 then
  begin
     FUnzBusy:=False;
     exit;  // load failed - error msg was shown to user
  end;

  { Select the extract directory }
  if DirectoryExists(fExtrBaseDir) then
     SetCurrentDir(fExtrBaseDir);

  SetUnZipSwitches;

  with UnzipParms1 do
  begin
      PZipFN := StrAlloc(256);  { allocate room for null terminated string }
      PZipPassword := StrAlloc(81);  { allocate room for null terminated string }
      StrPCopy(PZipFN, fZipFilename);     { name of zip file }
      StrPCopy(PZipPassword, FPassword);  { password for encryption/decryption }
      argc:=0;

      { Copy filenames from the Stringlist to new var's we will alloc
        storage for.  This lets us append the null needed by the DLL. }
      for i := 0 to (fFSpecArgs.Count - 1) do
      begin
         PFilenames[argc]:=StrAlloc(256);  { alloc room for the filespec }
         { ShowMessage(fFSpecArgs[i]); } { for debugging }
         StrPCopy(PFilenames[argc], fFSpecArgs[i]); { file to extr from archive }
         argc:=argc+1;
      end;
      { argc is now the no. of filespecs we want extracted }
   end;  { end with }

   try
      { pass in a ptr to parms }
      fSuccessCnt:=UnzDLLExec(@UnZipParms1);
   except
      ShowMessage('Fatal DLL Error: abort exception');
   end;

   fFSpecArgs.Clear;

   { Free the memory }
   with UnZipParms1 do
   begin
      StrDispose(PZipFN);
      StrDispose(PZipPassword);
      for i := (argc - 1) downto 0  do
         StrDispose(PFilenames[i]);
   end;

   if AutoLoad then
      Unload_Unz_Dll;
   FCancel := False;
   FUnzBusy := False;
   { no need to call the List method; contents unchanged }
end;

{ returns 0 if good copy, or a negative error code }
function TZipMaster.CopyFile(const InFileName, OutFileName: String): Integer;
Const
   SE_CreateError   = -1;  { error in open or creation of outfile }
   SE_CopyError     = -2;  { read or write error during copy }
   SE_OpenReadError = -3;  { error in open or seek of infile }
   SE_SetDateError  = -4;  { error setting date/time of outfile }
   SE_GeneralError  = -9;
   BufSize = 8192;         { Keep under 12K to avoid Winsock problems on Win }
                           { If chunks are too large, the Winsock stack can }
                           { lose bytes being sent or received. }
type
   TBuffer = Array[0..BufSize-1] of Byte;
   PBuffer = ^TBuffer;
var
   InFile, OutFile, SizeR, SizeW: Integer;
   Buffer: PBuffer;
   fb: file of byte;
   InTotalBytes, OutTotalBytes: Longint;
begin
   result:=0;
   Buffer:=nil;
   if (not FileExists(InFileName)) then
   begin
      result:=SE_OpenReadError;
      exit;
   end;

   InFile := FileOpen(InFileName, fmOpenRead OR fmShareDenyWrite);
   Screen.Cursor := crHourGlass;
   if InFile <> -1 then
   begin
      SizeR := FileSeek(InFile, 0, 0);
      if SizeR <> -1 then
      begin
         if FileExists(OutFileName) then
            OutFile := FileOpen(OutFileName, fmOpenWrite OR fmShareExclusive)
         else
            OutFile := FileCreate(OutFileName);
         if OutFile <> -1 then
         begin
            try
               new(Buffer);
               repeat
                  SizeR    := FileRead(InFile, Buffer^, BufSize);
                  SizeW    := FileWrite(OutFile, Buffer^, SizeR);
                  if SizeW = -1 then
                  begin
                     Result := SE_CopyError;
                     break;
                  end;
                  Application.ProcessMessages; { mostly for winsock }
               until SizeR < BufSize;

               if Result = 0 then
                  if FileSetDate(OutFile, FileGetDate(InFile)) <> -1 then
                     Result := SE_SetDateError;
            finally
               If Buffer <> Nil Then
                  Dispose(Buffer);
               FileClose(OutFile);
            end { end of try / finally }
         end
         else
            Result := SE_CreateError;
      end
      else
         Result := SE_OpenReadError; // seek error
      FileClose(InFile);
   end
   else
      Result := SE_OpenReadError;

   { Here's an independant test of file sizes }
   InTotalBytes:=-1;
   OutTotalBytes:=-2;
   if Result = 0 then
   begin
      // Get size of the input file
      AssignFile(fb, InFileName);
      FileMode:=0;  { read only }
      try
         reset(fb); { open file }
         InTotalBytes := FileSize(fb);
      finally
         CloseFile(fb);
      end;
        
      // Get size of the output file
      AssignFile(fb, OutFileName);
      FileMode:=0;  { read only }
      try
         reset(fb); { open file }
         OutTotalBytes := FileSize(fb);
      finally
         CloseFile(fb);
      end; 
   end;

   if Result = 0 then
      if (InTotalBytes <> OutTotalBytes)
        or (InTotalBytes = -1)
        or (OutTotalBytes = -2) then
           Result:=SE_GeneralError;

   if Result <> 0 then
      DeleteFile(OutFileName); // Delete the corrupted outfile
   Screen.Cursor := crDefault;
end;

{ Convert an .ZIP archive to a .EXE archive. }
{ returns 0 if good, or else a negative error code }
function TZipMaster.ConvertSFX:Integer;
Const
   SE_CreateError   = -1;  { error in open of outfile }
   SE_CopyError     = -2;  { read or write error during copy }
   SE_OpenReadError = -3;  { error in open of infile }
   SE_SetDateError  = -4;  { error setting date/time of outfile }
   SE_GeneralError  = -9;
   BufSize = 8192;         { Keep under 12K to avoid Winsock problems }
type
   TBuffer = Array[0..BufSize-1] of Byte;
   PBuffer = ^TBuffer;
var
   InFile, OutFile, SizeR, SizeW: Integer;
   Buffer: PBuffer;
   OutFileName: String;
   fb: file of byte;
   TotalBytes: Longint;
   ZipSize, SFXSize: Integer;
   i,j: Integer;
   dirbuf: array [0..255] of char;
   sfxblk: array [0..255] of byte;
   cll: byte;
Begin
   result:=0;
   OutFile:=-1;
   if not FileExists(FZipFilename) then
   begin
      ShowMessage('Error - no zip file specified');
      Exit;
   end;

   { Do a simple validation to ensure that the 3 variable length text
     fields are small enough to fit inside the SFX control block. }
   i:=Length(FSFXCaption) + Length(FSFXDefaultDir) + Length(FSFXCommandLine);
   if i > 249 then
   begin
      ShowMessage('Error - The total size of the 3 text properties exceeds 249!'
       + #13#10 + 'SFXCaption + SFXDefaultDir + SFXCommandLine = ' + IntToStr(i));
      Exit;
   end;

   { try to find the SFX binary file: ZIPSFX.BIN }
   { look in the location given by the SFXPath property first }
   if not FileExists(FSFXPath) then 
   begin
      { try the current directory }
      FSFXPath:='ZIPSFX.BIN';
      if not FileExists(FSFXPath) then
      begin
         { try the application directory }
         FSFXPath:=ExtractFilePath(ParamStr(0))+'\ZIPSFX.BIN';
         if not FileExists(FSFXPath) then
         begin
            { try the Windows System dir (where DLLs go)}
            GetSystemDirectory(dirbuf, 256);
            FSFXPath:=StrPas(dirbuf)+'\ZIPSFX.BIN';
            if not FileExists(FSFXPath) then
            begin
               { try the Windows dir }
               GetWindowsDirectory(dirbuf, 256);
               FSFXPath:=StrPas(dirbuf)+'\ZIPSFX.BIN';
               if not FileExists(FSFXPath) then
               begin
                  { try the DLLDirectory property }
                  if FDLLDirectory = '' then
                  begin
                     ShowMessage('Error - ZIPSFX.BIN not found');
                     Exit;
                  end
                  else
                  begin
                     FSFXPath := FDLLDirectory + '\ZIPSFX.BIN';
                     if not FileExists(FSFXPath) then
                     begin
                        ShowMessage('Error - ZIPSFX.BIN not found');
                        Exit;
                     end;
                  end;
               end;
            end;
         end;
      end;
   end;

   if UpperCase(ExtractFileExt(FZipFilename)) <> '.ZIP' then
   begin
      ShowMessage('Error: input file is not a zip file');
      exit;
   end;
   Screen.Cursor:=crHourGlass;

   OutFileName:=ChangeFileExt(FZipFilename, '.exe');

   { Copy the SFX code to destination .exe file }
   buffer := Nil;

   { For convenience, this code calculates the size of the SFX module.
     This way, I don't have to change TZipMaster when changes are made 
     to the SFX code. }
   SFXSize:=0;

   Screen.Cursor:=crHourGlass;
   OutFileName:=ChangeFileExt(FZipFilename, '.exe');

   InFile := FileOpen(FSFXPath, fmOpenRead OR fmShareDenyWrite);
   if InFile <> -1 then
   begin
      SizeR := FileSeek(InFile, 0, 0);
      if SizeR <> -1 then
      begin
         if FileExists(OutFileName) then
            OutFile := FileOpen(OutFileName, fmOpenWrite OR fmShareExclusive)
         else
            OutFile := FileCreate(OutFileName);
         if OutFile <> -1 then
         begin
            try
               new(Buffer);
               repeat
                  SizeR    := FileRead(InFile, Buffer^, BufSize);
                  SizeW    := FileWrite(OutFile, Buffer^, SizeR);
                  if SizeW = -1 then
                  begin
                     Result := SE_CopyError;
                     break;
                  end
                  else
                     Inc(SFXSize, SizeW);
                  Application.ProcessMessages; { mostly for winsock }
               until SizeR < BufSize;

            finally
               If Buffer <> Nil Then
                  Dispose(Buffer);
               // leave outfile open
            end { end of try / finally }
         end
         else
            Result := SE_CreateError;
      end
      else
         Result := SE_OpenReadError; // seek error
      FileClose(InFile);
   end
   else
      Result := SE_OpenReadError;

   if Result <> 0 then
   begin
      if OutFile <> -1 then
         FileClose(OutFile);
      DeleteFile(OutFileName);
      Screen.Cursor:=crDefault;
      exit;
   end;

   { Create the special SFX parameter block }
   sfxblk[0]:=Byte('M');
   sfxblk[1]:=Byte('P');
   sfxblk[2]:=Byte('U');

   { create a packed byte with various 1 bit settings }
   cll:=0;
   if SFXAskCmdLine in FSFXOptions then
      cll := 1;        // don't ask user if he wants to run cmd line
   if SFXAskFiles in FSFXOptions then
      cll := cll or 2; // allow user to edit files in selection box
   if SFXHideOverWriteBox in FSFXOptions then
      cll := cll or 4; // hide overwrite mode box at runtime
   case FSFXOverWriteMode of    // dflt = ovrConfirm
      ovrAlways: cll := cll or 8;
      ovrNever:  cll := cll or 16;
   end;
   sfxblk[3]:=cll;

   sfxblk[4]:=Length(FSFXCaption);
   sfxblk[5]:=Length(FSFXDefaultDir);
   sfxblk[6]:=Length(FSFXCommandLine);
   j:=6;

   // There are 249 remaining bytes in the control block to hold all 
   // 3 variable length strings.  This should be enough.
   for i := 1 to Length(FSFXCaption) do
      sfxblk[j+i]:=Byte(FSFXCaption[i]);
   j:=j+Length(FSFXCaption);
   for i := 1 to Length(FSFXDefaultDir) do
      sfxblk[j+i]:=Byte(FSFXDefaultDir[i]);
   j:=j+Length(FSFXDefaultDir);
   for i := 1 to Length(FSFXCommandLine) do
      sfxblk[j+i]:=Byte(FSFXCommandLine[i]);


   { Write out the SFX control block }
   Buffer:=@sfxblk;
   SizeW := FileWrite(OutFile, Buffer^, 256);
   if SizeW = -1 then
   begin
      Result := SE_CopyError;
      FileClose(OutFile);
      DeleteFile(OutFileName);
      Screen.Cursor:=crDefault;
      exit;
   end;


   { Append the ZIP file to destination .EXE file }
   { Note that the OutFile is still open. }
   ZipSize:=0;
   Buffer:=nil;

   InFile := FileOpen(FZipFilename, fmOpenRead OR fmShareDenyWrite);
   if InFile <> -1 then
   begin
      SizeR := FileSeek(InFile, 0, 0);
      if SizeR <> -1 then
      begin
         try
            new(Buffer);
            repeat
               SizeR    := FileRead(InFile, Buffer^, BufSize);
               SizeW    := FileWrite(OutFile, Buffer^, SizeR);
               if SizeW = -1 then
               begin
                  Result := SE_CopyError;
                  break;
               end
               else
                  Inc(ZipSize, SizeW);
               Application.ProcessMessages; { mostly for winsock }
            until SizeR < BufSize;

         finally
            If Buffer <> Nil Then
               Dispose(Buffer);
            FileClose(OutFile);
         end { end of try / finally }
      end
      else
         Result := SE_OpenReadError; // seek error
      FileClose(InFile);
   end
   else
      Result := SE_OpenReadError; // open error


   { Get the size of the output file }
   TotalBytes:=-1;
   if FileExists(OutFileName) then
   begin
      AssignFile(fb, OutFileName);
      FileMode:=0;  { read only }
      try
         reset(fb); { open file }
         TotalBytes := FileSize(fb);
      finally
         CloseFile(fb);
      end;
   end
   else
      Result:=SE_GeneralError;

   if Result = 0 then
     if (TotalBytes <> (ZipSize + SFXSize + 256)) then
        Result := SE_GeneralError;

   if Result <> 0 then
   begin
      DeleteFile(OutFileName); // delete the corrupted .exe file
      Screen.Cursor:=crDefault;
      exit;
   end;

   { if we're still here, all is OK }
   DeleteFile(FZipFilename);   // delete the input .zip file
   FZipFilename:=OutFileName;  // the .exe file is now the default archive
   List;                       // explicitly invoke the List method
   Screen.Cursor:=crDefault;
End;

{ Convert an .EXE archive to a .ZIP archive. }
{ returns 0 if good, or else a negative error code }
function TZipMaster.ConvertZIP:Integer;
Const
   SE_CreateError   = -1;  { error in open of outfile }
   SE_CopyError     = -2;  { read or write error during copy }
   SE_OpenReadError = -3;  { error in open of infile }
   SE_SetDateError  = -4;  { error setting date/time of outfile }
   SE_GeneralError  = -9;
   BufSize = 8192;         { Keep under 12K to avoid Winsock problems }
type
   TBuffer = Array[0..BufSize-1] of Byte;
   PBuffer = ^TBuffer;
var
   InFile, OutFile, SizeR, SizeW: Integer;
   Buffer: PBuffer;
   OutFileName: String;
   InFileSize, TotalBytes: LongInt;
   fb: file of byte;
begin
   Result := 0;
   SizeR := 0;
   InFileSize:=0;
   if not FileExists(FZipFilename) then
   begin
      ShowMessage('Error - no archive filename specified');
      result:=SE_OpenReadError;
      Exit;
   end;
   if UpperCase(ExtractFileExt(FZipFilename)) <> '.EXE' then
   begin
      ShowMessage('Error: input file is not an .EXE file');
      result:=SE_OpenReadError;
      exit;
   end;

   // The FSFXOffset is the location where the zip file starts inside
   // the .EXE archive.  It is calculated during a ZipMaster List operation.
   // Since a LIST is done when a filename is assigned, we know that
   // a LIST has already been done on the correct archive.
   if FSFXOffset = 0 then
   begin
      ShowMessage('Error determining the type of SFX archive');
      exit;
   end;

   { Copy the EXE file (starting at FSFXOffset) to the destination .ZIP file }
   Screen.Cursor:=crHourGlass;
   OutFileName:=ChangeFileExt(FZipFilename, '.zip');
   Buffer:=nil;

   InFile := FileOpen(FZipFilename, fmOpenRead OR fmShareDenyWrite);
   if InFile <> -1 then
   begin
      InFileSize:=FileSeek(InFile, 0, 2);
      if InFileSize > 0 then
         SizeR := FileSeek(InFile, FSFXOffset, 0);
      if (SizeR > 0) and (InFileSize > 0) then
      begin
         if FileExists(OutFileName) then
            OutFile := FileOpen(OutFileName, fmOpenWrite OR fmShareExclusive)
         else
            OutFile := FileCreate(OutFileName);
         if OutFile <> -1 then
         begin
            try
               new(Buffer);
               repeat
                  SizeR    := FileRead(InFile, Buffer^, BufSize);
                  SizeW    := FileWrite(OutFile, Buffer^, SizeR);
                  if SizeW = -1 then
                  begin
                     Result := SE_CopyError;
                     break;
                  end;
                  Application.ProcessMessages; { mostly for winsock }
               until SizeR < BufSize;

            finally
               If Buffer <> Nil Then
                  Dispose(Buffer);
               FileClose(OutFile);
            end { end of try / finally }
         end
         else
            Result := SE_CreateError;
      end
      else
         Result := SE_OpenReadError; // seek error
      FileClose(InFile);
   end
   else
      Result := SE_OpenReadError;


   { Get the size of the output file }
   TotalBytes:=-1;
   if FileExists(OutFileName) then
   begin
      AssignFile(fb, OutFileName);
      FileMode:=0;  { read only }
      try
         reset(fb); { open file }
         TotalBytes := FileSize(fb);
      finally
         CloseFile(fb);
      end;
   end
   else
      Result:=SE_GeneralError;

   if Result = 0 then
     if (TotalBytes <> (InFileSize - FSFXOffset)) then
        Result := SE_GeneralError;

   if Result <> 0 then
   begin
      DeleteFile(OutFileName); // delete corrupted output file
      Screen.Cursor:=crDefault;
      exit;
   end;

   DeleteFile(FZipFilename);   // delete the input .exe file
   FZipFilename:=OutFileName;  // the .zip file is now the default archive
   List;                       // explicitly invoke the List method
   Screen.Cursor:=crDefault;
end;

procedure TZipMaster.Load_Zip_Dll;
var
   fullpath: String;
begin
   // This is new code that tries to locate the DLL before loading it.
   // The user can specify a dir in the DLLDirectory property.
   // The user's dir is our first choice, but we'll still try the
   // standard Windows DLL dirs (Windows, Windows System, Current dir).
   fullpath:='';
   if FDLLDirectory <> '' then
      if FileExists(FDLLDirectory + '\ZIPDLL.DLL') then
         fullpath := FDLLDirectory + '\ZIPDLL.DLL';
   if fullpath = '' then
      fullpath := 'ZIPDLL.DLL';  // Let Windows search the std dirs

   SetErrorMode(SEM_FAILCRITICALERRORS or SEM_NOGPFAULTERRORBOX);
   try
      ZipDllHandle := LoadLibrary(PChar(fullpath));
      if ZipDllHandle > HInstance_Error then
      begin
         if FTrace then
            ShowMessage('ZIP DLL Loaded');
         @ZipDllExec := GetProcAddress(ZipDllHandle,'ZipDllExec');
         @GetZipDllVersion := GetProcAddress(ZipDllHandle,'GetZipDllVersion');
         if @ZipDllExec = nil then
            ShowMessage('ZipDllExec function not found in ZIPDLL.DLL');
         if @GetZipDllVersion = nil then
            ShowMessage('GetZipDllVersion function not found in ZIPDLL.DLL');
      end
      else
      begin
         ZipDllHandle := 0; {reset}
         ShowMessage('ZIPDLL.DLL not found');
      end;
   finally
      SetErrorMode(0);
   end;
end;

procedure TZipMaster.Load_Unz_Dll;
var
   fullpath: String;
begin
   // This is new code that tries to locate the DLL before loading it.
   // The user can specify a dir in the DLLDirectory property.
   // The user's dir is our first choice, but we'll still try the
   // standard Windows DLL dirs (Windows, Windows System, Current dir).
   fullpath:='';
   if FDLLDirectory <> '' then
      if FileExists(FDLLDirectory + '\UNZDLL.DLL') then
         fullpath := FDLLDirectory + '\UNZDLL.DLL';
   if fullpath = '' then
      fullpath := 'UNZDLL.DLL';  // Let Windows search the std dirs

   SetErrorMode(SEM_FAILCRITICALERRORS or SEM_NOGPFAULTERRORBOX);
   try
      UnzDllHandle := LoadLibrary(PChar(fullpath));
      if UnzDllHandle > HInstance_Error then
      begin
         if FTrace then
            ShowMessage('UNZ DLL Loaded');
         @UnzDllExec := GetProcAddress(UnzDllHandle,'UnzDllExec');
         @GetUnzDllVersion := GetProcAddress(UnzDllHandle,'GetUnzDllVersion');
         if @UnzDllExec = nil then
            ShowMessage('UnzDllExec function not found in UNZDLL.DLL');
         if @GetUnzDllVersion = nil then
            ShowMessage('GetZipDllVersion function not found in UNZDLL.DLL');
      end
      else
      begin
         UnzDllHandle := 0; {reset}
         ShowMessage('UNZDLL.DLL not found');
      end;
   finally
      SetErrorMode(0);
   end;
end;

procedure TZipMaster.Unload_Zip_Dll;
begin
   if ZipDllHandle <> 0 then
      freeLibrary(ZipDllHandle);
   ZipDllHandle:=0;
end;

procedure TZipMaster.Unload_Unz_Dll;
begin
   if UnzDllHandle <> 0 then
      freeLibrary(UnzDllHandle);
   UnzDllHandle:=0;
end;

procedure Register;
begin
  RegisterComponents('PosControl2', [TZipMaster]);
end;

end.

