{*********************************************************}
{                                                         }
{     TExcel Component 2.4 for Borland Delphi             }
{                                                         }
{     Copyright (c) 1996, 1997 by                         }
{                                                         }
{       Stefan Hoffmeister                                }
{         Stefan.Hoffmeister@PoBoxes.com                  }
{         Stefan.Hoffmeister@Uni-Passau.de                }
{                                                         }
{   and (portions)                                        }
{                                                         }
{       Tibor F. Liska                                    }
{       Tel/Fax:    00-36-1-165-2019                      }
{       Office:     00-36-1-269-8284                      }
{       E-mail: liska@sztaki.hu                           }
{                                                         }
{   This component may be used freely.                    }
{                                                         }
{                                                         }
{   The UltraFast Excel DDE code is copyright 1997        }
{   by Stefan Hoffmeister.                                }
{                                                         }
{   The UltraFast code may only be used (and usually will }
{   only be available) if a licence fee has been paid.    }
{                                                         }
{   Unauthorized distribution of the UltraFast code       }
{   is strictly prohibited and a violation of copyright   }
{   law.                                                  }
{                                                         }
{*********************************************************}
{*********************************************************}
{                                                         }
{  Possible enhancements:                                 }
{    Improve Assign and AssignTo methods (T...XlTableData)}
{    Add example code for cell formatting                 }
{    Add more examples to the online help                 }
{                                                         }
{*********************************************************}
unit Excels;

{.$DEFINE Debug}
{$IFNDEF Debug}
  {$D-} {$L-} {$Q-} {$R-} {$S-} {$O+}
{$ENDIF}

{$IFDEF Win32}
   {$LONGSTRINGS ON}
{$ENDIF}


{.$DEFINE UltraSpeed} { this makes the high-speed code available }
{$UNDEF UltraSpeed}

{.$DEFINE SpeedDemo} { if the high-speed code is available, defining SpeedDemo
                       will cripple the component; about half of the data transferred
                       will be altered. }
{$UNDEF SpeedDemo}   { play it safe and turn it off, here, too. }

interface

uses
  Dialogs,

{$IFDEF Win32}
  Windows,
{$ELSE}
  WinProcs, WinTypes,
{$ENDIF}
  Forms, Classes, DdeMan, SysUtils,db,Math;

{$IFDEF VER100}
resourcestring
{$ELSE}
const
{$ENDIF}
  msgExcelNoReply = '*** Excel - No Reply ***';
  msgStrError = 'String transfer error';
  msgCouldNotLaunch = 'Excel could not be launched';
  msgCmdAcceptErr = '"%s" not accepted by Excel';
  msgNoRowCol = 'Could not identify letters for rol / column';
  msgBadCellFmt = 'Unexpected Excel cell format';
  msgNoMacroFile = 'No open macro file';
  msgTableNotReady = 'Table not ready';
  msgReservedType = 'Use of reserved type';
  msgArrayMove = 'Putting an array needs auto-moving cell!';
  msgNotSupported = 'Data type not supported';

type
  TCellDir = (dirNone, dirUp, dirDown, dirLeft, dirRight);

  TNewSheet = ( FromTemplate,
                FromActiveSheet,
                Sheet,
                ChartSelection,
                Macro,
                IntMacro,
                Reserved,
                VBModule,
                Dialog);

(*
    This is part old source code that has been left in for demonstration.
    Feel free to expoit it, but note that there will be no support for it.

  TExcelUpdateLinks = ( excelNoUpdate,
                        excelUpdateExternal,
                        excelUpdateRemote,
                        excelUpdateAll);

  TExcelFileDelimiter = ( excelDefaultDelimit,
                          excelTabs,
                          excelCommas,
                          excelSpaces,
                          excelSemicolons,
                          excelNothing,
                          excelCustom);

  TExcelFileOrigin = ( excelDefaultOrigin,
                       excelMacintosh,
                       excelWindows,
                       excelMSDOS);


  TExcelFileAccess = ( excelUnknownAccess,
                       excelRevertToSaved,
                       excelReadWriteAccess,
                       excelReadOnlyAccess);
*)

  ExcelError = class(Exception);

  TExcelRow = integer;
  TExcelCol = integer;

  TExcelCell = record
    Col: TExcelCol;
    Row: TExcelRow;
  end;

type
  PExcelSelectionArray = ^TExcelSelectionArray;
  TExcelSelectionArray = record
    TopLeft,
    BottomRight: TExcelCell;
  end;

  { This is a local definition of the file extension type }
  {$IFDEF Windows}
     TFileExt = string[4]; { dot + three letters }
  {$ELSE}
     TFileExt = type string;
  {$ENDIF}

  TCustomExcel = class(TComponent)
  private
    FDDEClientConv : TDdeClientConv;
    FDDEClientItem : TDDEClientItem;
    FFileExt : TFileExt;
    FExecutable: TFilename;
    FExeName : TFileName;

    FProtocolsList,
    FEditEnvItemsList,
    FTopicsList,
    FFormatsList: TStringList;

    FConnected : Boolean;
    FOnClose: TNotifyEvent;
    FOnOpen: TNotifyEvent;

    FBeginWait: TNotifyEvent;
    FEndWait: TNotifyEvent;
    FWaiting: TNotifyEvent;

    FRowChar,
    FColChar: Char;

    FSelectionList: TStringList;

    FExecCount: cardinal;
    FBurstCount: integer;

    procedure SetExeName(const Value: TFileName);
    procedure SetConnect(Value: Boolean);
    function GetReady: Boolean;
    function GetFormats: TStringList;
    function GetTopics: TStringList;
    function GetProtocols: TStringList;
    function GetEditEnvItems: TStringList;
    function GetSelection: string;
    function GetCurrentSheet: string;
    procedure OpenLink(Sender: TObject);
    procedure ShutDown(Sender: TObject);
    procedure GetCellChars;
    function CellCharsOK: boolean;

    function ParseSelEntry(var TopLeft, BottomRight: TExcelCell; const Sel: string): string;
  protected
    function GetStrings(var List: TStringList; const Topic: string): TStringList;
    property FileExt: TFileExt read FFileExt write FFileExt;
    property Executable: TFilename read FExecutable write FExecutable;
    class function StripQuotation(const AString: string): string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Connect;
    procedure Disconnect;

    function Request(const Item: string): string;
    procedure Exec(const Cmd: string);

    procedure Poke(const Data: string);
    procedure PokeAt(Row: TExcelRow; Col: TExcelCol; const Data: string);
    procedure PokeAtSheet(const Sheet: string; Row: TExcelRow; Col: TExcelCol; const Data: string);

    procedure SwitchTopic(const NewTopic: string);
    procedure SwitchToSystemTopic;

    procedure LocateExcel; virtual;

    procedure CloseExcel;

    procedure Flush;
    procedure WaitUntilReady;

    function GetRectSelection(var TopLeft, BottomRight: TExcelCell): string;

    procedure RetrieveSelection;

    property Connected: Boolean read FConnected write SetConnect;
    property BurstCount: integer read FBurstCount write FBurstCount default 128;
    property DDEConv: TDDEClientConv read FDDEClientConv;
    property DDEItem: TDDEClientItem read FDDEClientItem;
    property Ready: Boolean read GetReady;
    property Formats: TStringList read GetFormats;
    property Topics: TStringList read GetTopics;
    property Protocols: TStringList read GetProtocols;
    property EditEnvItems: TStringList read GetEditEnvItems;
    property Selection: string read GetSelection;
    { Excel note: Excel occasionally seems to return sheet names wrapped in
      ''; to use them for DDE purposes you will need to remove the leading and
      the trailing ' }
    property CurrentSheet: string read GetCurrentSheet;
    property RowChar: char read FRowChar;
    property ColChar: char read FColChar;
    property SelectionList: TStringList read FSelectionList;
    property ExeName: TFileName read FExeName write SetExeName;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnOpen: TNotifyEvent read FOnOpen write FOnOpen;
    property OnBeginWait: TNotifyEvent read FBeginWait write FBeginWait;
    property OnEndWait: TNotifyEvent read FEndWait write FEndWait;
    property OnWaiting: TNotifyEvent read FWaiting write FWaiting;
  end;

  TExcel = class(TCustomExcel)
  private
    FMoveActiveCell : TCellDir;
    FDecimals: Word;
    FDecimalSeparator: Char;
    FFilterReturnedData: boolean;
    FStripCRLF: boolean;
    procedure SetFilter(DoFilter: boolean);
  public
    constructor Create(AOwner: TComponent); override;
    procedure AutoMoveActiveCell;

    procedure Select(Row: TExcelRow; Col: TExcelCol);
    procedure SelectRange( FromRow: TExcelRow; FromCol: TExcelCol;
                           ARowCount: TExcelRow; AColCount: TExcelCol);
    procedure SelectSheet(const ASheet: string);

    procedure Move(deltaRow, deltaCol: Integer);

    procedure Insert(const s: string);
    procedure InsertAt(Row: TExcelRow; Col: TExcelCol; const s: string);

    procedure PutExt(e: Extended);
    procedure PutExtAt(Row: TExcelRow; Col: TExcelCol; e: Extended);
    procedure PutStr(const s: string);
    procedure PutStrAt(Row: TExcelRow; Col: TExcelCol; const s: string);

    function GetData: string;
    function GetDataAt(Row: TExcelRow; Col: TExcelCol): string;
    function GetDataAtFileSheet(Row: TExcelRow; Col: TExcelCol; const FileSheet: string): string;

  published
    property MoveActiveCell: TCellDir read FMoveActiveCell write FMoveActiveCell default dirDown;
    property ExeName;
    property Decimals: Word read FDecimals write FDecimals default 0;
    property DecimalSeparator: Char read FDecimalSeparator write FDecimalSeparator default '.';
    property FilterReturnedData: boolean read FFilterReturnedData write SetFilter;
    property StripCRLF: boolean read FStripCRLF write FStripCRLF;

    { all of the following properties documented above }
    property BurstCount;
    property OnClose;
    property OnOpen;

    property OnBeginWait;
    property OnEndWait;
    property OnWaiting;
  end;

  TAdvExcel = class(TExcel)
  private
    FMacro : TFileName;
    FSourceDataSet:TDataSet;
    FStartRow:word;
    FStartCol:word;
    FShowTitle:Boolean;
    function Get_StartRow:word;
    procedure Set_StartRow(pstart:word);
    function Get_StartCol:word;
    procedure Set_StartCol(pstart:word);
    function Get_ShowTitle:Boolean;
    procedure Set_ShowTitle(ptitle:Boolean);
    function Get_DataSet:TDataSet;
    procedure Set_DataSet(pdataset:TDataSet);
  public
    constructor Create(AOwner: TComponent); override;
    procedure ExportDataSet;
    procedure OpenMacroFile(const MacroFilename: TFileName);
    procedure CloseMacroFile;
    procedure RunMacro(const MacroName: string);

    procedure StartTable;
    procedure EndTable;

    procedure NewSheet(SheetType: TNewSheet; const TemplateName: string);

    procedure NewWorkbook(SheetType: TNewSheet; const TemplateName: string);

(*
    This is old source code that has been left in for demonstration.
    Feel free to explore, exploit and cannibalize it, but note that there will
    be no support at all for it.

    procedure OpenWorkbook( const Filename: string; UpdateLinks: TExcelUpdateLinks); virtual;
    procedure OpenWorkbookEx( const Filename: string; UpdateLinks: TExcelUpdateLinks;
                              ReadOnly: boolean;
                              DelimitFormat: TExcelFileDelimiter;
                              const Password: string;
                              const EditPassword: string;
                              IgnoreReadOnlyRecommendation: boolean;
                              FileOrigin: TExcelFileOrigin;
                              CustomDelimiter: char;
                              AddToCurrentWorkbook: boolean;
                              Editable: boolean;
                              FileAccess: TExcelFileAccess;
                              NotifyUser: boolean;
                              Converter: integer);
*)

    procedure EchoOn;
    procedure EchoOff;

    procedure DisableInput;
    procedure EnableInput;

    procedure HideCurrentWindow;
    procedure UnhideWindow(const AWindowName: string);

    procedure PutInt(i: Longint);
    procedure PutIntAt(Row: TExcelRow; Col: TExcelCol; i: Longint);

    procedure PutDate(d: TDateTime);
    procedure PutDateAt(Row: TExcelRow; Col: TExcelCol; d: TDateTime);

    procedure PutTime(d: TDateTime);
    procedure PutTimeAt(Row: TExcelRow; Col: TExcelCol; d: TDateTime);

    procedure PutDateTime(d: TDateTime);
    procedure PutDateTimeAt(Row: TExcelRow; Col: TExcelCol; d: TDateTime);

    procedure PutData(const AnArray: array of const);
    procedure PutDataAt(Row: TExcelRow; Col: TExcelCol; const AnArray: array of const;
                        FillDirection: TCellDir);

    procedure SelectWorkBook(const WorkBook, SheetName: string);

    procedure RenameSheet(const OldName, NewName: string);

  published
    property StartRow:word read Get_StartRow write Set_StartRow;
    property StartCol:word read Get_StartCol write Set_StartCol;
    property ShowTitle:Boolean read Get_ShowTitle write Set_ShowTitle;
    property DataSet:TDataSet read Get_DataSet write Set_DataSet;
  end;

{$DEFINE LocalRegister}

{$IFDEF LocalRegister}
  procedure Register;
{$ENDIF}

implementation


uses
  ShellApi,
  DDEML;


{$IFDEF LocalRegister}
  procedure Register;
  begin
    RegisterComponents('PosControl2', [TAdvExcel]);
  end;

  {$IFDEF Win32}
     {$R EXCELS.D32}
  {$ELSE}
     {$R EXCELS.D16}
  {$ENDIF}

{$ENDIF}




{$IFNDEF Win32}
  function Str2PChar(var s: string): PChar;
  { Convert a string to a pchar by adding a NULL
    character to the string passed and returning
    the address of the first element s[1] of the
    string.
    This is only needed in 16bit, as in 32bit
    Delphi a string can be safely type-casted
    into a PChar. }
  var
    i : integer;
  begin
    Str2PChar := @s[1];

    i := length(s);
    if s[i]<>#0 then
      if (i < 255) then
        AppendStr(s, #0)
      else
        raise ExcelError.Create(msgStrError);
  end;
{$ENDIF}

function RScan(const S: string; Chr: char): integer;
begin
  Result := Length(s);
  while Result > 0 do
  begin
    if S[Result] = Chr then
      break;

    dec(Result);
  end;
end;

function FindExcelColon(x: integer; const s: string): integer;
var
  counter: integer;
begin
  counter := x;
  while counter <= length(s) do
  begin
    if s[counter] = #39 then
    begin
      inc(counter);
      while (counter < length(s)) and (s[counter]<>#39) do
        inc(counter);
      inc(counter);
    end
    else
    begin
      if s[counter] = ';' then
        break
      else
        inc(counter);
    end;
  end;

  if (s[counter] = ';') and (counter < length(s)) then
    Result := counter
  else
    Result := 0;
end;

{ TCustomExcel }
constructor TCustomExcel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FFileExt := '.xls';
  FExecutable := 'EXCEL.EXE';

  if not (csDesigning in ComponentState) then
  begin
    FDDEClientConv := TDdeClientConv.Create(nil);
    with FDDEClientConv do
    begin
      ConnectMode := ddeManual;
      OnOpen  := Self.OpenLink;
      OnClose := Self.ShutDown;
    end;

    FDDEClientItem := TDDEClientItem.Create(nil);
    with FDDEClientItem do
    begin
      DDEConv := FDDEClientConv;
    end;

  end;

  FSelectionList := TStringList.Create;
  FSelectionList.Sorted := false;
  FSelectionList.Duplicates := dupAccept;

  FBurstCount := 128;

  SetExeName('Excel');
end;

destructor TCustomExcel.Destroy;
var
  counter : integer;
begin
  FFormatsList.Free;
  FTopicsList.Free;
  FProtocolsList.Free;
  FEditEnvItemsList.Free;

  if not (csDesigning in ComponentState) then
  begin
    FDDEClientItem.DDEConv := nil;
    FDDEClientItem.Free;
    FDDEClientItem := nil;

    FDDEClientConv.Free;
    FDDEClientItem := nil;
  end;

  for counter := 0 to FSelectionList.Count-1 do
  with FSelectionList do
  begin
    if Objects[counter] <> nil then
      dispose(PExcelSelectionArray(Objects[counter]));
  end;
  FSelectionList.Free;
  FSelectionList := nil;

  inherited Destroy;
end;

procedure TCustomExcel.SetExeName(const Value: TFileName);
begin
  Disconnect;

  FExeName := ChangeFileExt(Value, '');
  if not (csDesigning in ComponentState) then
    FDDEClientConv.ServiceApplication := FExeName;
end;

procedure TCustomExcel.SetConnect(Value: Boolean);
begin
  if FConnected = Value then Exit;
  if Value then
    Connect
  else
    Disconnect;
end;

function TCustomExcel.GetReady: Boolean;
begin
  Application.ProcessMessages;
  SwitchToSystemTopic;
  Result := 'Ready' = Request('Status');
end;

function TCustomExcel.GetFormats: TStringList;
begin
  Result := GetStrings(FFormatsList, 'Formats');
end;

function TCustomExcel.GetTopics: TStringList;
begin
  Result := GetStrings(FTopicsList, 'Topics');
end;

function TCustomExcel.GetProtocols: TStringList;
begin
  Result := GetStrings(FProtocolsList, 'Protocols');
end;

function TCustomExcel.GetEditEnvItems: TStringList;
begin
  Result := GetStrings(FEditEnvItemsList, 'EditEnvItems');
end;

function TCustomExcel.GetSelection: string;
begin
  Application.ProcessMessages;
  SwitchToSystemTopic;
  Result := Request('Selection');
end;

function TCustomExcel.GetCurrentSheet: string;
var
  ExclPos: integer;
begin
  Result := GetSelection;
  if Result = msgExcelNoReply then
    Result := ''
  else
  begin
    ExclPos := RScan(Result, '!');
    if ExclPos > 0 then
      Delete(Result, ExclPos, length(Result));
  end;
end;

procedure TCustomExcel.OpenLink(Sender: TObject);
begin
  FConnected := True;
  if Assigned(FOnOpen) then FOnOpen(Self);
end;

procedure TCustomExcel.ShutDown(Sender: TObject);
begin
  FConnected := False;
  if Assigned(FOnClose) then FOnClose(Self);
end;

{ procedure relies on List <> nil }
procedure TABStringToStringList(TABString: PChar; List: TStringList);
  var
      StartPos,
      TabPos : PChar;
begin
  if TABString = nil then Exit;
  StartPos := TABString;
  TabPos := StrScan(StartPos, #9);
  while TabPos <> nil do
  begin
    TabPos[0] := #0; { replace #9 by #0 }
    List.Add(StrPas(StartPos)); { add format to list }
    StartPos := TabPos+1; { position to after TAB}
    TabPos := StrScan(StartPos, #9);
  end;
  if StrLen(StartPos) > 0 then
    List.Add(StrPas(StartPos));
end;

function TCustomExcel.GetStrings(var List: TStringList;
                               const Topic: string): TStringList;
  var
      Reply : PChar;
begin
  Application.ProcessMessages;

  if not Assigned(List) then
    List := TStringList.Create
  else
    List.Clear;

  SwitchToSystemTopic;
  Reply := FDDEClientConv.RequestData(Topic);
  try
    { retrieve TAB-delimited list of formats }
    TABStringToStringList(Reply, List);
  finally
    StrDispose(Reply);
  end;

  Result := List;
end;

class function TCustomExcel.StripQuotation(const AString: string): string;
begin
  if (Length(AString) > 0) and
     (AString[Length(AString)]= #39) and (AString[1] = #39 ) then { test for ' }

    Result := Copy(AString, 2, Length(AString)-2)
  else
    Result := AString;
end;
                   

procedure TCustomExcel.Connect;
begin
  if not FConnected then
  begin
    { initially use the system topic }
    FDDEClientConv.SetLink('Excel', 'System');

    if FDDEClientConv.OpenLink then
    begin
      GetCellChars; { try to find out the cell chars NOW }
      Exit;
    end;

    LocateExcel;
    if not FDDEClientConv.OpenLink then
    begin
      { ShowMessage('Exename:---' + Exename + '---'); - problems with some Excel 8.0 installation }
      raise ExcelError.Create(msgCouldNotLaunch);
    end;
  end;
end;

procedure TCustomExcel.Disconnect;
begin
  if FConnected then
    FDDEClientConv.CloseLink;
end;

function TCustomExcel.Request(const Item: string): string;
var
  Reply : PChar;
begin
  Reply := FDDEClientConv.RequestData(Item);
  if Reply = nil then
    Result := msgExcelNoReply
  else
    Result := StrPas(Reply);
  StrDispose(Reply);
end;

procedure TCustomExcel.Exec(const Cmd: string);
{$IFDEF Windows}
var
  Buffer : PChar;
{$ENDIF}
begin
  SwitchToSystemTopic;

  inc(FExecCount);
  if (FExecCount = FBurstCount) and (FBurstCount >= 0) then
  begin
    Flush;

    FExecCount := 0;
  end;

{$IFDEF Windows}
  Buffer := StrAlloc(Length(Cmd)+SizeOf(Char));
  try
{$ENDIF}
  {$IFDEF Windows}
    if not FDDEClientConv.ExecuteMacro(StrPCopy(Buffer, Cmd), False) then
  {$ELSE}
    if not FDDEClientConv.ExecuteMacro(PChar(Cmd), False) then
  {$ENDIF}
    begin
      Flush;

    {$IFDEF Windows}
      if not FDDEClientConv.ExecuteMacro(Buffer, True) then
    {$ELSE}
      if not FDDEClientConv.ExecuteMacro(PChar(Cmd), True) then
    {$ENDIF}
        raise ExcelError.CreateFmt(msgCmdAcceptErr, [Cmd]);
    end;
{$IFDEF Windows}
  finally
    StrDispose(Buffer);
  end;
{$ENDIF}
end;

procedure TCustomExcel.Poke(const Data: string);
var
  TopLeft, dummy: TExcelCell;
begin
  SwitchTopic(StripQuotation(GetRectSelection(TopLeft, dummy)));

  with TopLeft do
    PokeAt(Row, Col, Data);
end;

procedure TCustomExcel.PokeAtSheet(const Sheet: string; Row: TExcelRow; Col: TExcelCol; const Data: string);
begin
  SwitchTopic(StripQuotation(Sheet));

  PokeAt(Row, Col, Data);
end;

procedure TCustomExcel.PokeAt(Row: TExcelRow; Col: TExcelCol; const Data: string);
{$IFDEF Windows}
var
  Buffer : PChar;
{$ENDIF}
var
  Item: string;
begin
  while FDDEClientConv.WaitStat do
    Application.ProcessMessages;

  if not CellCharsOK then
  begin
    GetCellChars;
    if not CellCharsOK then
      raise ExcelError.Create(msgNoRowCol);
  end;

  Item := Format('%s%d%s%d', [FRowChar, Row, FColChar, Col]);
  { assume that the item does change - DDEItem change causes a lot of activity }
  FDDEClientItem.DDEItem := Item;

{$IFDEF Windows}
  Buffer := StrAlloc(Length(Data)+SizeOf(Char));
  try
{$ENDIF}
  {$IFDEF Windows}
    if not FDDEClientConv.PokeData(Item, StrPCopy(Buffer, Data)) then
  {$ELSE}
    if not FDDEClientConv.PokeData(Item, PChar(Data)) then
  {$ENDIF}
    begin
      while FDDEClientConv.WaitStat do { try to wait }
        Application.ProcessMessages;

    {$IFDEF Windows}
      if not FDDEClientConv.PokeData(Item, Buffer) then
    {$ELSE}
      if not FDDEClientConv.PokeData(Item, PChar(Data)) then
    {$ENDIF}
        raise ExcelError.CreateFmt(msgCmdAcceptErr, [Data]);
    end;
{$IFDEF Windows}
  finally
    StrDispose(Buffer);
  end;
{$ENDIF}
end;


procedure TCustomExcel.LocateExcel;
const
  BufferSize = {$IFDEF Win32} 540 {$ELSE} 80 {$ENDIF};
var
  Buffer : PChar;
  StringPosition : PChar;
  ReturnedData: Longint;
begin
  Buffer := StrAlloc(BufferSize);
  try
    { get the first entry, don't bother about the version !}
    ReturnedData := BufferSize;
    StrPCopy(Buffer, FFileExt);
    RegQueryValue(hKey_Classes_Root, Buffer, Buffer, ReturnedData);
    if StrLen(Buffer) > 0 then
    begin
      StrCat(Buffer, '\shell\Open\command');
      ReturnedData := BufferSize;
      if RegQueryValue(hKey_Classes_Root, Buffer, Buffer, ReturnedData) = ERROR_SUCCESS then
      begin
        { now we have the executable associated with the .XLS file extension }

        StringPosition := StrUpper(Buffer);
        { find _last_ occurence of the executable name }
        {$IFDEF Windows}
          { please note that Str2PChar is a function }
          while StrPos(StringPosition+1, Str2PChar(FExecutable)) <> nil do
            StringPosition := StrPos(StringPosition+1, Str2PChar(FExecutable));
        {$ELSE}
          while StrPos(StringPosition+1, PChar(FExecutable)) <> nil do
            StringPosition := StrPos(StringPosition+1, PChar(FExecutable));
        {$ENDIF}
        StrCopy(StringPosition + Length(FExecutable), ''); { cut off string }


        { bugfix 2.4 ? - may solve some problems detecting an Excel 8 installation }
        StringPosition := StrScan(Buffer, '"');
        if StringPosition <> nil then
          ExeName := StrPas(Buffer + (StringPosition-Buffer) + 1)
        else
          ExeName := StrPas(Buffer);
        { formerly we used this code to parse the returned string
          problems with some Excel 8.0 installation induced a change to
          the code above. Revert to this if the above code does not
          work out as expected.

        if Buffer[0] = '"' then
          ExeName := StrPas(Buffer+1)
        else
          ExeName := StrPas(Buffer);
        }

        { if it is in registry, it's quite likely that the file exists, too

          Note: writing to ExeName has the side-effect that ".EXE" is cut off;
                this is done in compliance with the Win API docs
                Because of this we need to append it here again to see whether
                the file actually exists! }
        if not FileExists(ExeName+'.EXE') then
          ExeName := '';
      end;
    end;
  finally
    StrDispose(Buffer);
  end;
end;

procedure TCustomExcel.CloseExcel;
begin
  if FConnected then
    Disconnect;

  Exec('[QUIT]');
end;

procedure TCustomExcel.Flush;
begin
  if Assigned(FBeginWait) then
    FBeginWait(Self);

  if Assigned(FWaiting) then
  begin
    while FDDEClientConv.WaitStat or (not Ready) do
    begin
      Application.ProcessMessages;   { Waiting for Excel }
      FWaiting(Self);
    end;
  end
  else
  begin
    while FDDEClientConv.WaitStat or (not Ready) do
      Application.ProcessMessages;   { Waiting for Excel }
  end;

  if Assigned(FEndWait) then
    FEndWait(Self);
end;

procedure TCustomExcel.WaitUntilReady;
begin
  Flush;
end;


{ TExcel }

constructor TExcel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMoveActiveCell := dirDown;
  FDecimalSeparator := '.';
end;

procedure TExcel.SetFilter(DoFilter: boolean);
begin
  FFilterReturnedData := DoFilter;

  if not (csDesigning in ComponentState) then
    FDDEClientConv.FormatChars := DoFilter;
end;

procedure TExcel.AutoMoveActiveCell;
begin
  case FMoveActiveCell of
    dirNone:  { do nothing };
    dirUp:    begin
                Exec('[SELECT("R[-1]C")]');
              end;

    dirDown:  begin
                Exec('[SELECT("R[1]C")]');
              end;

    dirLeft:  begin
                Exec('[SELECT("RC[-1]")]');
              end;

    dirRight: begin
                Exec('[SELECT("RC[1]")]');
              end;
  end;
end;

procedure TExcel.Select(Row: TExcelRow; Col: TExcelCol);
begin
  if (Row <> 0) and (Col <> 0) then
  begin
    Exec(Format('[SELECT("R%dC%d")]', [Row, Col]));
  end;
end;

procedure TExcel.SelectRange( FromRow: TExcelRow; FromCol: TExcelCol;
                              ARowCount: TExcelRow; AColCount: TExcelCol);
begin
  if (FromRow <> 0) and (FromCol <> 0) and
     (ARowCount > 0) and (AColCount > 0) then
  begin
    Exec(Format('[SELECT("R%dC%d:R%dC%d")]', [FromRow, FromCol, FromRow + ARowCount, FromCol + AColCount]));
  end;
end;

procedure TExcel.SelectSheet(const ASheet: string);
begin
  SwitchTopic(StripQuotation(ASheet));
end;

procedure TExcel.Move(deltaRow, deltaCol: Integer);
begin
  Exec(Format('[SELECT("R[%d]C[%d]")]', [deltaRow, deltaCol]));
end;

procedure TExcel.Insert(const s: string);
begin
  Exec(Format('[FORMULA(%s)]', [s]));
  AutoMoveActiveCell;
end;

procedure TExcel.InsertAt(Row: TExcelRow; Col: TExcelCol; const s: string);
begin
  if (Row <= 0) or (Col<=0) then
    Insert(s)
  else
  begin
    Exec(Format('[FORMULA(%s, "R%dC%d")]', [s, Row, Col]));
  end;
end;

procedure TExcel.PutExt(e: Extended);
begin
  PutExtAt(0, 0, e);
end;

procedure TExcel.PutExtAt(Row: TExcelRow; Col: TExcelCol; e: Extended);
var
  SepPos : Integer;
  ExtString: string[30];
begin
  Str(e:0:FDecimals, ExtString);
  { this will always return an "American" style number }
  if FDecimalSeparator <> '.' then
  begin
    SepPos := Pos('.', ExtString);
    if SepPos > 0 then
      ExtString[SepPos] := FDecimalSeparator;
  end;
  InsertAt(Row, Col, ExtString);
end;

procedure TExcel.PutStr(const s: string);
begin
  PutStrAt(0, 0, s);
end;

procedure TExcel.PutStrAt(Row: TExcelRow; Col: TExcelCol; const s: string);
begin
  InsertAt(Row, Col, Format('"%s"', [s]));
end;


procedure TCustomExcel.GetCellChars;
var
  SelString: string;
  CharPos: integer;
begin
  SelString := GetSelection; { get the whole lot }

  if SelString = msgExcelNoReply then { only parse if Excel replied }
    exit;

  CharPos := RScan(SelString, '!'); { find the separator }
  if CharPos > 0 then
  begin
    { remove from the existing string }
    Delete(SelString, 1, CharPos);

    FRowChar := SelString[1]; { The first char is always the row char }

    CharPos := 2;                { Find occurence of col char }
    while (CharPos < length(SelString)) and
          (SelString[CharPos] in ['0'..'9']) do Inc(CharPos);

    FColChar := SelString[CharPos];
  end;
end;

function TCustomExcel.CellCharsOK: boolean;
begin
  if (FRowChar = #0) or (FColChar = #0) then
    Result := false
  else
    Result := true;
end;

function TCustomExcel.ParseSelEntry(var TopLeft, BottomRight: TExcelCell; const Sel: string): string;

  { parse cell part into number and remove it }
  function GetNumber(var AString: string): integer;
  var
    CharPos : integer;
  begin
    CharPos := 2; { this is specialized code that knows that the first char is non-numeric }
    while (CharPos <= length(AString)) and (AString[CharPos] in ['0'..'9']) do
      inc(CharPos);

    { convert to number }
    Result := StrToInt(Copy(AString, 2, CharPos-2));

    { remove parsed part from string }
    Delete(AString, 1, pred(CharPos));
  end;

var
  SeparatorPos: integer;
  CellAddress: string;
begin
  TopLeft.Col := 0;  BottomRight.Col := 0;
  TopLeft.Row := 0;  BottomRight.Row := 0;

  Result := Sel;
  SeparatorPos := RScan(Result, '!'); { find the separator }

  if SeparatorPos = 0 then
  begin
    Result := ''; { should not happen! - but don't raise an exception }
    exit;
  end;

  { copy the cell part into CellAddress}
  CellAddress := Copy(Result, succ(SeparatorPos), Length(Result));

  { and remove it from the existing string - return value }
  Delete(Result, SeparatorPos, Length(Result));
  Result := StripQuotation(Result);

  if not CellCharsOK then
  begin
    GetCellChars;
    if not CellCharsOK then
      raise ExcelError.Create(msgNoRowCol);
  end;
  { at this point we know the following:
      FRowChar and FColChar contain valid identifiers for an Excel row / column }


  { find the colon char (R1C10:R20C15) -> array selection; or the semicolon
     -> multiple selection (R1C10;R20C40) ==> ";" + ":'

      R1C10;R20C20   [multiple selection]

      R1C10:R20C20   [array]

      R1C10

      R1             [single row]
      C1             [single column]

  }

  { find multiple selections which we are not parsing !}
  { it is safe to use "Pos" here, as a potential semicolon in the name part will
    have been removed by now }
  SeparatorPos := Pos(';', CellAddress);
  if SeparatorPos > 0 then
    { remove the parts we are not going to parse }
    Delete(CellAddress, SeparatorPos, Length(CellAddress));


  { there must be always at least ONE valid char }
  if CellAddress[1] = FRowChar then
    TopLeft.Row := GetNumber(CellAddress)
  else
  if CellAddress[1] = FColChar then
    TopLeft.Col := GetNumber(CellAddress);

  if (length(CellAddress)>0) then { still something left ?}
    { assume that Excel does not return garbage }
    if CellAddress[1] = FRowChar then
      TopLeft.Row := GetNumber(CellAddress)
    else
    if CellAddress[1] = FColChar then
      TopLeft.Col := GetNumber(CellAddress)
    else
      raise ExcelError.Create(msgBadCellFmt);


  { at this point we have parsed the left part of an array selection, so
    that at most something like ":R1..." is left over }

  {test whether we do have an array indeed (otherwise we have a problem !) }
  if (length(CellAddress)>0) then
    if (CellAddress[1] <> ':') then
      raise ExcelError.Create(msgBadCellFmt)
    else
    begin
      if length(CellAddress) < 2 then
        raise ExcelError.Create(msgBadCellFmt);

      Delete(CellAddress, 1, 1); { remove colon }

      { what follows is effectively the same code as above, only
        with "BottomRight" instead of TopLeft }

      { there must be always at least ONE valid char }
      if CellAddress[1] = FRowChar then
        BottomRight.Row := GetNumber(CellAddress)
      else
      if CellAddress[1] = FColChar then
        BottomRight.Col := GetNumber(CellAddress);

      if (length(CellAddress)>0) then { still something left ?}
        { assume that Excel does not return garbage }
        if CellAddress[1] = FRowChar then
          BottomRight.Row := GetNumber(CellAddress)
        else
        if CellAddress[1] = FColChar then
          BottomRight.Col := GetNumber(CellAddress)
        else
          raise ExcelError.Create(msgBadCellFmt);
    end;


  { we have transferred all the text into the TopLeft + BottomRight record;
    now handle the special cases }

  if (BottomRight.Col = 0) and (BottomRight.Row = 0) then
    BottomRight := TopLeft;
end;


procedure TCustomExcel.SwitchTopic(const NewTopic: string);
begin
  with FDDEClientConv do
  begin
    if DDETopic <> NewTopic then
    begin
      OnOpen  := nil; { we do not want to report this particular switch }
      OnClose := nil;

      if FConnected then
        CloseLink;

      SetLink('Excel', NewTopic);

      if FConnected then
        OpenLink;

      OnOpen  := Self.OpenLink;
      OnClose := Self.ShutDown;
    end;
  end;
end;

procedure TCustomExcel.SwitchToSystemTopic;
begin
  SwitchTopic('System');
end;

function TCustomExcel.GetRectSelection(var TopLeft, BottomRight: TExcelCell): string;
var
  DelimitPos: integer;
  CurrentSel : string;
begin
  CurrentSel := Self.Selection;
  { Parse ONLY the first item of a selection }
  DelimitPos := FindExcelColon(1, CurrentSel);
  if DelimitPos > 0 then
    Delete(CurrentSel, DelimitPos, length(CurrentSel));

  Result := ParseSelEntry(TopLeft, BottomRight, CurrentSel);
end;

procedure TCustomExcel.RetrieveSelection;
var
  DelimitPos: integer;
  CurrentSel: string;

  counter : integer;

  PAnExcelSelArray: PExcelSelectionArray;
begin
  for counter := 0 to FSelectionList.Count-1 do
    with FSelectionList do
      if Objects[counter]<>nil then
        dispose(PExcelSelectionArray(Objects[counter]));
  FSelectionList.Clear;

  CurrentSel := Self.Selection;

  DelimitPos := 1;
  repeat
    DelimitPos := FindExcelColon(DelimitPos, CurrentSel);

    new(PAnExcelSelArray);
    try
      if DelimitPos > 0 then
        counter := FSelectionList.Add(
            ParseSelEntry( PAnExcelSelArray^.TopLeft, PAnExcelSelArray^.BottomRight,
                           Copy(CurrentSel, 1, DelimitPos-1) ) )
      else
        counter := FSelectionList.Add(
            ParseSelEntry( PAnExcelSelArray^.TopLeft, PAnExcelSelArray^.BottomRight,
                           CurrentSel ) );
    except
      on E: Exception do
      begin
        dispose(PAnExcelSelArray);
        raise;
      end;
    end;

    FSelectionList.Objects[counter] := TObject(PAnExcelSelArray);

    if DelimitPos > 0 then
      Delete(CurrentSel, 1, DelimitPos);
  until DelimitPos = 0;
end;


function TExcel.GetData: string;
begin
  Result := GetDataAt(0, 0);
end;


function TExcel.GetDataAtFileSheet(Row: TExcelRow; Col: TExcelCol; const FileSheet: string): string;
var
  TopCell,
  BottomCell: TExcelCell;

  CRLFPos : integer;
begin
  if (Row <= 0) or (Col <= 0) then { if "invalid" input get current selection }
  begin
    GetRectSelection(TopCell, BottomCell);
    Row := TopCell.Row;
    Col := TopCell.Col;
  end;

  SwitchTopic(StripQuotation(FileSheet));

  if not CellCharsOK then
  begin
    GetCellChars;
    if not CellCharsOK then
      raise ExcelError.Create(msgNoRowCol);
  end;

  Result := Request(Format('%s%d%s%d', [FRowChar, Row, FColChar, Col]));

  if FStripCRLF and (Length(Result) > 1) then
  begin
    CRLFPos := length(Result)-1;
    if (Result[CRLFPos] = #13) and (Result[succ(CRLFPos)] = #10) then
      Delete(Result, CRLFPos, 2);
  end;

end;

function TExcel.GetDataAt(Row: TExcelRow; Col: TExcelCol): string;
begin
  Result := GetDataAtFileSheet(Row, Col, CurrentSheet);
end;


{ TAdvExcel }

constructor TAdvExcel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FStartRow:=1;
  FStartCol:=1;
  FShowTitle:=TRUE;
end;

procedure TAdvExcel.OpenMacroFile(const MacroFilename: TFileName);
var
  MFile: TFilename;
begin
  MFile := UpperCase(ExtractFileName(MacroFilename));
  if FMacro <> MFile then
  begin
    if FMacro <> '' then
      CloseMacroFile;

    Exec(Format('[OPEN("%s")]', [MacroFilename]));
    Exec('[HIDE()]');
    FMacro := MFile;
  end;
end;

procedure TAdvExcel.CloseMacroFile;
begin
  if FMacro <> '' then
  begin
    Exec(Format('[UNHIDE("%s")]', [FMacro]));
    Exec('[CLOSE(FALSE)]');
    FMacro := '';
  end;
end;

procedure TAdvExcel.RunMacro(const MacroName: string);
begin
  if FMacro = '' then
    raise ExcelError.Create(msgNoMacroFile);

  Exec(Format('[RUN("%s!%s";FALSE)]', [FMacro, MacroName]));
end;

procedure TAdvExcel.StartTable;
begin
  Exec('[APP.MINIMIZE()]');
  Exec('[NEW(1)]');
  PutStrAt(1, 1, msgTableNotReady);
end;

procedure TAdvExcel.EndTable;
begin
  PutStrAt(1, 1, '');
  Exec('[APP.RESTORE()]');
end;

procedure TAdvExcel.NewSheet(SheetType: TNewSheet; const TemplateName: string);
begin
  if SheetType = Reserved then
    raise ExcelError.Create(msgReservedType);

  if SheetType = FromTemplate then
    Exec(Format('[WORKBOOK.INSERT("%s")]', [TemplateName]))
  else
    Exec(Format('[WORKBOOK.INSERT(%d)]', [ord(SheetType)-1]));
end;

procedure TAdvExcel.NewWorkbook(SheetType: TNewSheet; const TemplateName: string);
begin
  if SheetType = FromTemplate then
    Exec(Format('[NEW("%s")]', [TemplateName]))
  else
    Exec(Format('[NEW(%d)]', [ord(SheetType)-1]));
end;

(*
procedure TAdvExcel.OpenWorkbook( const Filename: string; UpdateLinks: TExcelUpdateLinks);
begin
  OpenWorkbookEx( Filename, UpdateLinks, false, excelDefaultDelimit,
                  '', '', true, excelDefaultOrigin, #0, false,
                  false, excelRevertToSaved, true, 0);
end;

procedure TAdvExcel.OpenWorkbookEx( const Filename: string; UpdateLinks: TExcelUpdateLinks;
                          ReadOnly: boolean;
                          DelimitFormat: TExcelFileDelimiter;
                          const Password: string;
                          const EditPassword: string;
                          IgnoreReadOnlyRecommendation: boolean;
                          FileOrigin: TExcelFileOrigin;
                          CustomDelimiter: char;
                          AddToCurrentWorkbook: boolean;
                          Editable: boolean;
                          FileAccess: TExcelFileAccess;
                          NotifyUser: boolean;
                          Converter: integer);
const
  BoolName : array[boolean] of PChar = ('true', 'false');
begin
  Exec(Format('[OPEN("%s",%d,)]', [
                              Filename,
                              ord(UpdateLinks),
                              ReadOnly,
                              ord(DelimitFormat),
                              Password,
                              IgnoreReadOnlyRecommendation,
                              ord(FileOrigin),
                              CustomDelimiter,
                              AddToCurrentWorkbook,
                              Editable,
                              ord(FileAccess),
                              NotifyUser,
                              Converter
                         ]) );
end;
*)

procedure TAdvExcel.EchoOn;
begin
  Exec('[ECHO(TRUE)]');
end;

procedure TAdvExcel.EchoOff;
begin
  Exec('[ECHO(FALSE)]');
end;

procedure TAdvExcel.DisableInput;
begin
  Exec('[DISABLE.INPUT(TRUE)]');
end;

procedure TAdvExcel.EnableInput;
begin
  Exec('[DISABLE.INPUT(FALSE)]');
end;

procedure TAdvExcel.HideCurrentWindow;
begin
  Exec('[HIDE()]');
end;

procedure TAdvExcel.UnhideWindow(const AWindowName: string);
begin
  Exec( Format('[UNHIDE(%s)]', [AWindowName]) );
end;

procedure TAdvExcel.PutInt(i: Longint);
begin
  PutIntAt(0, 0, i);
end;

procedure TAdvExcel.PutIntAt(Row: TExcelRow; Col: TExcelCol; i: Longint);
begin
  InsertAt(Row, Col, IntToStr(i));
end;

procedure TAdvExcel.PutDate(d: TDateTime);
begin
  PutDateAt(0, 0, d);
end;

procedure TAdvExcel.PutDateAt(Row: TExcelRow; Col: TExcelCol; d: TDateTime);
begin
  PutStrAt(Row, Col, DateToStr(d));
end;

procedure TAdvExcel.PutTime(d: TDateTime);
begin
  PutTimeAt(0, 0, d);
end;

procedure TAdvExcel.PutTimeAt(Row: TExcelRow; Col: TExcelCol; d: TDateTime);
begin
  PutStrAt(Row, Col, TimeToStr(d));
end;

procedure TAdvExcel.PutDateTime(d: TDateTime);
begin
  PutDateTimeAt(0, 0, d);
end;

procedure TAdvExcel.PutDateTimeAt(Row: TExcelRow; Col: TExcelCol; d: TDateTime);
begin
  PutStrAt(Row, Col, DateTimeToStr(d));
end;

procedure TAdvExcel.PutData(const AnArray: array of const);
begin
  PutDataAt(0, 0, AnArray, MoveActiveCell);
end;

procedure TAdvExcel.PutDataAt( Row: TExcelRow; Col: TExcelCol;
                               const AnArray: array of const;
                               FillDirection: TCellDir);
var
  i: Integer;
  AutoMove: TCellDir;
begin
  Select(Row, Col);

  if (FillDirection = dirNone) and (High(AnArray)>0) then
    raise ExcelError.Create(msgArrayMove);

  AutoMove := Self.MoveActiveCell;
  Self.MoveActiveCell := FillDirection;
  try
    for i:= Low(AnArray) to High(AnArray) do
    with AnArray[i] do
      case VType of
        vtExtended: PutExtAt(0, 0, VExtended^);
        vtInteger:  PutIntAt(0, 0, VInteger);
        vtChar:     PutStrAt(0, 0, VChar);
        vtString:   PutStrAt(0, 0, VString^);
        vtPChar:    PutStrAt(0, 0, StrPas(VPChar));
      {$IFDEF Win32}
        vtAnsiString: PutStrAt(0, 0, StrPas(VPChar));
      {$ENDIF}
      else
        raise ExcelError.Create(msgNotSupported);
      end; { case }
  finally
    Self.MoveActiveCell := AutoMove;
  end;
end;

procedure TAdvExcel.SelectWorkBook(const WorkBook, SheetName: string);
begin
  if Length(SheetName) > 0 then
    Exec(Format('[WORKBOOK.SELECT("[%s]%s")]',
              [StripQuotation(WorkBook), StripQuotation(SheetName)]))
  else
    Exec(Format('[WORKBOOK.SELECT("[%s]")]',
              [StripQuotation(WorkBook), StripQuotation(SheetName)]))
end;

procedure TAdvExcel.RenameSheet(const OldName, NewName: string);
begin
  Exec( Format('[WORKBOOK.NAME("%s","%s")]',
              [StripQuotation(OldName), StripQuotation(NewName)] ));
end;

//implemention of DataExcel

function TAdvExcel.Get_ShowTitle:Boolean;
begin
  Result:=FShowTitle;
end;

procedure TAdvExcel.Set_ShowTitle(ptitle:Boolean);
begin
  FShowTitle:=ptitle;
end;

function TAdvExcel.Get_StartRow:word;
begin
  Result:=FStartRow;
end;

procedure TAdvExcel.Set_StartRow(pstart:word);
begin
  if pstart<1 then pstart:=1;
  FStartRow:=pstart;
end;

function TAdvExcel.Get_StartCol:word;
begin
  Result:=FStartCol;
end;

procedure TAdvExcel.Set_StartCol(pstart:word);
begin
  if pstart<1 then pstart:=1;
  FStartCol:=pstart;
end;

function TAdvExcel.Get_DataSet:TDataSet;
begin
  Result:=FSourceDataSet;
end;

procedure TAdvExcel.Set_DataSet(pdataset:TDataSet);
begin
  FSourceDataSet:=pdataset;
end;

procedure TAdvExcel.ExportDataSet;
var row,col,colwidth,tempword:word;
    content,thefirst:string;
begin
  if FSourceDataSet.Active=FALSE then exit;
  try
    Connect;
  except
    messagedlg('Excel not found!',mtWarning,[mbOk],0);
    exit;
  end;
  StartTable;
  DisableInput;
  with FSourceDataSet do
  begin
    DisableControls;
    first;
    row:=FStartRow-1;
    thefirst:=Fields[0].asString;
    if FShowTitle=TRUE then
    begin
      row:=row+1;
      thefirst:=Fields[0].DisplayLabel;
    end;
    for col:=0 to FieldCount-1 do
    begin
      colwidth:=Fields[col].DisplayWidth;
      tempword:=length(Fields[col].DisplayLabel);
      colwidth:=MaxIntValue([colwidth,tempword]);
      Exec('[COLUMN.WIDTH('+inttostr(colwidth)+',"C'+inttostr(col+FStartCol)+'")]');
      if FShowTitle=TRUE then
      begin
        content:=Fields[col].DisplayLabel;
        PutStrAt(row,col+FStartCol,content);
     end;
    end;
    while not eof do
    begin
      row:=row+1;
      for col:=0 to FieldCount-1 do
      begin
        content:=Fields[col].asString;
        PutStrAt(row,col+FStartCol,content);
      end;
      Next;
    end;
    EnableControls;
  end;
  EndTable;
  EnableInput;
  PutStrAt(FStartRow,FStartCol,thefirst);
  Disconnect;
  messagedlg('Transfer Successful!',mtInformation,[mbOk],0);
end;

end.
