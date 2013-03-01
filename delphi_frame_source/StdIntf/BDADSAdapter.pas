
{*******************************************************}
{                                                       }
{       Delphi Text DataSet Sample                      }
{                                                       }
{       Copyright (c) 1997,98 Borland International     }
{                                                       }
{*******************************************************}

unit BDADSAdapter;

{
   This file contains a very basic TDataSet implementation which works with
 text files.  For simplicity, the text file is interpreted as a single column,
 multiple row table.

   Currently, the notes in this source file represent the only documnentation
 on how to create a TDataSet implentation.  For more information you can
 refer to TBDEDataSet in DBTABLES.PAS which represents a complete TDataSet
 implementation and provides a good example of what methods can be overridden
 and what they should do.

   Any TDataSet implementation must provide Bookmark capabilities and
 implement all functions which directly access the record buffer.  The base
 TDataSet manages a group of record buffers, but has no requirements regarding
 what is contained in each record buffer.  The base TDataSet also manages
 the communcation with any attached TDataSource components and the respective
 data aware controls.

}

interface

uses
  DB, Classes;

const
  MaxStrLen = 240; { This is an arbitrary limit }

type

{ TRecInfo }

{   This structure is used to access additional information stored in
  each record buffer which follows the actual record data.

    Buffer: PChar;
   ||
   \/
    --------------------------------------------
    |  Record Data  | Bookmark | Bookmark Flag |
    --------------------------------------------
                    ^-- PRecInfo = Buffer + FRecInfoOfs

  Keep in mind that this is just an example of how the record buffer
  can be used to store additional information besides the actual record
  data.  There is no requirement that TDataSet implementations do it this
  way.

  For the purposes of this demo, the bookmark format used is just an integer
  value.  For an actual implementation the bookmark would most likely be
  a native bookmark type (as with BDE), or a fabricated bookmark for
  data providers which do not natively support bookmarks (this might be
  a variant array of key values for instance).

  The BookmarkFlag is used to determine if the record buffer contains a
  valid bookmark and has special values for when the dataset is positioned
  on the "cracks" at BOF and EOF. }

  PRecInfo = ^TRecInfo;
  TRecInfo = packed record
    Bookmark: Integer;
    BookmarkFlag: TBookmarkFlag;
  end;

{ TTextDataSet }

  TTextDataSet = class(TDataSet)
  private
    FData: TStrings;
    FRecBufSize: Integer;
    FRecInfoOfs: Integer;
    FCurRec: Integer;
    FFileName: string;
    FLastBookmark: Integer;
    FSaveChanges: Boolean;
  protected
    { Overriden abstract methods (required) }
    function AllocRecordBuffer: PChar; override;
    procedure FreeRecordBuffer(var Buffer: PChar); override;
    procedure GetBookmarkData(Buffer: PChar; Data: Pointer); override;
    function GetBookmarkFlag(Buffer: PChar): TBookmarkFlag; override;
    function GetRecord(Buffer: PChar; GetMode: TGetMode; DoCheck: Boolean): TGetResult; override;
    function GetRecordSize: Word; override;
    procedure InternalAddRecord(Buffer: Pointer; Append: Boolean); override;
    procedure InternalClose; override;
    procedure InternalDelete; override;
    procedure InternalFirst; override;
    procedure InternalGotoBookmark(Bookmark: Pointer); override;
    procedure InternalHandleException; override;
    procedure InternalInitFieldDefs; override;
    procedure InternalInitRecord(Buffer: PChar); override;
    procedure InternalLast; override;
    procedure InternalOpen; override;
    procedure InternalPost; override;
    procedure InternalSetToRecord(Buffer: PChar); override;
    function IsCursorOpen: Boolean; override;
    procedure SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag); override;
    procedure SetBookmarkData(Buffer: PChar; Data: Pointer); override;
    procedure SetFieldData(Field: TField; Buffer: Pointer); override;
  protected
    { Additional overrides (optional) }
    function GetRecordCount: Integer; override;
    function GetRecNo: Integer; override;
    procedure SetRecNo(Value: Integer); override;
  public
    function GetFieldData(Field: TField; Buffer: Pointer): Boolean; override;
  published
    property FileName: string read FFileName write FFileName;
    property Active;
  end;

procedure Register;

implementation

uses Windows, SysUtils, Forms;

{ TTextDataSet }

{ This method is called by TDataSet.Open and also when FieldDefs need to
  be updated (usually by the DataSet designer).  Everything which is
  allocated or initialized in this method should also be freed or
  uninitialized in the InternalClose method. }

procedure TTextDataSet.InternalOpen;
var
  I: Integer;
begin
  { Load the textfile into a stringlist }
  FData := TStringList.Create;
  FData.LoadFromFile(FileName);

  { Fabricate integral bookmark values }
  for I := 1 to FData.Count do
    FData.Objects[I-1] := Pointer(I);
  FLastBookmark := FData.Count;

  { Initialize our internal position.
    We use -1 to indicate the "crack" before the first record. }
  FCurRec := -1;

  { Initialize an offset value to find the TRecInfo in each buffer }
  FRecInfoOfs := MaxStrLen;

  { Calculate the size of the record buffers.
    Note: This is NOT the same as the RecordSize property which
    only gets the size of the data in the record buffer }
  FRecBufSize := FRecInfoOfs + SizeOf(TRecInfo);

  { Tell TDataSet how big our Bookmarks are (REQUIRED) }
  BookmarkSize := SizeOf(Integer);

  { Initialize the FieldDefs }
  InternalInitFieldDefs;

  { Create TField components when no persistent fields have been created }
  if DefaultFields then CreateFields;

  { Bind the TField components to the physical fields }
  BindFields(True);
end;

procedure TTextDataSet.InternalClose;
begin
  { Write any edits to disk and free the managing string list }
  if FSaveChanges then FData.SaveToFile(FileName);
  FData.Free;
  FData := nil;

  { Destroy the TField components if no persistent fields }
  if DefaultFields then DestroyFields;

  { Reset these internal flags }
  FLastBookmark := 0;
  FCurRec := -1;
end;

{ This property is used while opening the dataset.
  It indicates if data is available even though the
  current state is still dsInActive. }

function TTextDataSet.IsCursorOpen: Boolean;
begin
  Result := Assigned(FData);
end;

{ For this simple example we just create one FieldDef, but a more complete
  TDataSet implementation would create multiple FieldDefs based on the
  actual data. }

procedure TTextDataSet.InternalInitFieldDefs;
begin
  FieldDefs.Clear;
  FieldDefs.Add('Line', ftString, MaxStrLen, False);
end;

{ This is the exception handler which is called if an exception is raised
  while the component is being stream in or streamed out.  In most cases this
  should be implemented useing the application exception handler as follows. }
  
procedure TTextDataSet.InternalHandleException;
begin
  Application.HandleException(Self);
end;

{ Bookmarks }
{ ========= }

{ In this sample the bookmarks are stored in the Object property of the
  TStringList holding the data.  Positioning to a bookmark just requires
  finding the offset of the bookmark in the TStrings.Objects and using that
  value as the new current record pointer. }

procedure TTextDataSet.InternalGotoBookmark(Bookmark: Pointer);
var
  Index: Integer;
begin
  Index := FData.IndexOfObject(TObject(PInteger(Bookmark)^));
  if Index <> -1 then
    FCurRec := Index else
    DatabaseError('Bookmark not found');
end;

{ This function does the same thing as InternalGotoBookmark, but it takes
  a record buffer as a parameter instead }

procedure TTextDataSet.InternalSetToRecord(Buffer: PChar);
begin
  InternalGotoBookmark(@PRecInfo(Buffer + FRecInfoOfs).Bookmark);
end;

{ Bookmark flags are used to indicate if a particular record is the first
  or last record in the dataset.  This is necessary for "crack" handling.
  If the bookmark flag is bfBOF or bfEOF then the bookmark is not actually
  used; InternalFirst, or InternalLast are called instead by TDataSet. }

function TTextDataSet.GetBookmarkFlag(Buffer: PChar): TBookmarkFlag;
begin
  Result := PRecInfo(Buffer + FRecInfoOfs).BookmarkFlag;
end;

procedure TTextDataSet.SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag);
begin
  PRecInfo(Buffer + FRecInfoOfs).BookmarkFlag := Value;
end;

{ These methods provide a way to read and write bookmark data into the
  record buffer without actually repositioning the current record }

procedure TTextDataSet.GetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  PInteger(Data)^ := PRecInfo(Buffer + FRecInfoOfs).Bookmark;
end;

procedure TTextDataSet.SetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  PRecInfo(Buffer + FRecInfoOfs).Bookmark := PInteger(Data)^;
end;

{ Record / Field Access }
{ ===================== }

{ This method returns the size of just the data in the record buffer.
  Do not confuse this with RecBufSize which also includes any additonal
  structures stored in the record buffer (such as TRecInfo). }

function TTextDataSet.GetRecordSize: Word;
begin
  Result := MaxStrLen;
end;

{ TDataSet calls this method to allocate the record buffer.  Here we use
  FRecBufSize which is equal to the size of the data plus the size of the
  TRecInfo structure. }

function TTextDataSet.AllocRecordBuffer: PChar;
begin
  GetMem(Result, FRecBufSize);
end;

{ Again, TDataSet calls this method to free the record buffer.
  Note: Make sure the value of FRecBufSize does not change before all
  allocated buffers are freed. }

procedure TTextDataSet.FreeRecordBuffer(var Buffer: PChar);
begin
  FreeMem(Buffer, FRecBufSize);
end;

{ This multi-purpose function does 3 jobs.  It retrieves data for either
  the current, the prior, or the next record.  It must return the status
  (TGetResult), and raise an exception if DoCheck is True. }

function TTextDataSet.GetRecord(Buffer: PChar; GetMode: TGetMode;
  DoCheck: Boolean): TGetResult;
begin
  if FData.Count < 1 then
    Result := grEOF else
  begin
    Result := grOK;
    case GetMode of
      gmNext:
        if FCurRec >= RecordCount - 1  then
          Result := grEOF else
          Inc(FCurRec);
      gmPrior:
        if FCurRec <= 0 then
          Result := grBOF else
          Dec(FCurRec);
      gmCurrent:
        if (FCurRec < 0) or (FCurRec >= RecordCount) then
          Result := grError;
    end;
    if Result = grOK then
    begin
      StrLCopy(Buffer, PChar(FData[FCurRec]), MaxStrLen);
      with PRecInfo(Buffer + FRecInfoOfs)^ do
      begin
        BookmarkFlag := bfCurrent;
        Bookmark := Integer(FData.Objects[FCurRec]);
      end;
    end else
      if (Result = grError) and DoCheck then DatabaseError('No Records');
  end;
end;

{ This routine is called to initialize a record buffer.  In this sample,
  we fill the buffer with zero values, but we might have code to initialize
  default values or do other things as well. }

procedure TTextDataSet.InternalInitRecord(Buffer: PChar);
begin
  FillChar(Buffer^, RecordSize, 0);
end;

{ Here we copy the data from the record buffer into a field's buffer.
  This function, and SetFieldData, are more complex when supporting
  calculated fields, filters, and other more advanced features.
  See TBDEDataSet for a more complete example. }

function TTextDataSet.GetFieldData(Field: TField; Buffer: Pointer): Boolean;
begin
  StrLCopy(Buffer, ActiveBuffer, Field.Size);
  Result := PChar(Buffer)^ <> #0;
end;

procedure TTextDataSet.SetFieldData(Field: TField; Buffer: Pointer);
begin
  StrLCopy(ActiveBuffer, Buffer, Field.Size);
  DataEvent(deFieldChange, Longint(Field));
end;

{ Record Navigation / Editing }
{ =========================== }

{ This method is called by TDataSet.First.  Crack behavior is required.
  That is we must position to a special place *before* the first record.
  Otherwise, we will actually end up on the second record after Resync
  is called. }
  
procedure TTextDataSet.InternalFirst;
begin
  FCurRec := -1;
end;

{ Again, we position to the crack *after* the last record here. }

procedure TTextDataSet.InternalLast;
begin
  FCurRec := FData.Count;
end;

{ This method is called by TDataSet.Post.  Most implmentations would write
  the changes directly to the associated datasource, but here we simply set
  a flag to write the changes when we close the dateset. }

procedure TTextDataSet.InternalPost;
begin
  FSaveChanges := True;
  { For inserts, just update the data in the string list }
  if State = dsEdit then FData[FCurRec] := ActiveBuffer else
  begin
    { If inserting (or appending), increment the bookmark counter and
      store the data }
    Inc(FLastBookmark);
    FData.InsertObject(FCurRec, ActiveBuffer, Pointer(FLastBookmark));
  end;
end;

{ This method is similar to InternalPost above, but the operation is always
  an insert or append and takes a pointer to a record buffer as well. }

procedure TTextDataSet.InternalAddRecord(Buffer: Pointer; Append: Boolean);
begin
  FSaveChanges := True;
  Inc(FLastBookmark);
  if Append then InternalLast;
  FData.InsertObject(FCurRec, PChar(Buffer), Pointer(FLastBookmark));
end;

{ This method is called by TDataSet.Delete to delete the current record }

procedure TTextDataSet.InternalDelete;
begin
  FSaveChanges := True;
  FData.Delete(FCurRec);
  if FCurRec >= FData.Count then
    Dec(FCurRec);
end;

{ Optional Methods }
{ ================ }

{ The following methods are optional.  When provided they will allow the
  DBGrid and other data aware controls to track the current cursor postion
  relative to the number of records in the dataset.  Because we are dealing
  with a small, static data store (a stringlist), these are very easy to
  implement.  However, for many data sources (SQL servers), the concept of
  record numbers and record counts do not really apply. }

function TTextDataSet.GetRecordCount: Longint;
begin
  Result := FData.Count;
end;

function TTextDataSet.GetRecNo: Longint;
begin
  UpdateCursorPos;
  if (FCurRec = -1) and (RecordCount > 0) then
    Result := 1 else
    Result := FCurRec + 1;
end;

procedure TTextDataSet.SetRecNo(Value: Integer);
begin
  if (Value >= 0) and (Value < FData.Count) then
  begin
    FCurRec := Value - 1;
    Resync([]);
  end;
end;

{ This procedure is used to register this component on the component palette }

procedure Register;
begin
  RegisterComponents('Data Access', [TTextDataSet]);
end;

end.
