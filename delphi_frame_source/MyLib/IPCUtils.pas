unit IPCUtils;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> IPCUtils
   <What> 包含进程间通信的工具类
   <Written By> Huang YanLai
   <History>
**********************************************}

interface

uses Windows,Sysutils,Classes,SyncObjs;

type
  EMutex = class(Exception);

	TMutex = class(TSynchroObject)
  private
    FHandle: THandle;
  public
    constructor Create(const Name: string='');
    destructor 	destroy; override;
    procedure 	Acquire; override;
    procedure 	Release; override;
    property 		Handle : THandle read FHandle;
    function    WaitFor(MSec : Integer):Boolean;
  end;

{ This is a generic class for all encapsulated WinAPI's which need to call
  CloseHandle when no longer needed.  This code eliminates the need for
  3 identical destructors in the TEvent, TMutex, and TSharedMem classes
  which are descended from this class. }

  THandledObject = class(TObject)
  protected
    FHandle: THandle;
  public
    destructor Destroy; override;
    property Handle: THandle read FHandle;
  end;

{ TSharedMem }

{ This class simplifies the process of creating a region of shared memory.
  In Win32, this is accomplished by using the CreateFileMapping and
  MapViewOfFile functions. }

  TSharedMem = class(THandledObject)
  private
    FName: string;
    FSize: Integer;
    FCreated: Boolean;
    FFileView: Pointer;
  public
    constructor Create(const Name: string; Size: Integer);
    destructor Destroy; override;
    property Name: string read FName;
    property Size: Integer read FSize;
    property Buffer: Pointer read FFileView;
    property Created: Boolean read FCreated;
  end;

implementation

procedure Error(const Msg: string);
begin
  raise Exception.Create(Msg);
end;

{ TMutex }

constructor TMutex.Create(const Name: string='');
begin
  FHandle := CreateMutex(nil, False, PChar(Name));
  if FHandle = 0 then abort;
end;

procedure TMutex.Acquire;
begin
  if WaitForSingleObject(FHandle,INFINITE)<>WAIT_OBJECT_0 then
  	raise EMutex.Create('Wait Error');
end;

procedure TMutex.Release;
begin
  ReleaseMutex(FHandle);
end;

destructor TMutex.destroy;
begin
  CloseHandle(FHandle);
  inherited destroy;
end;

function TMutex.WaitFor(MSec: Integer): Boolean;
begin
  Result := WaitForSingleObject(FHandle,MSec)=WAIT_OBJECT_0;
end;

{ THandledObject }

destructor THandledObject.Destroy;
begin
  if FHandle <> 0 then
    CloseHandle(FHandle);
end;

{ TSharedMem }

constructor TSharedMem.Create(const Name: string; Size: Integer);
begin
  try
    FName := Name;
    FSize := Size;
    { CreateFileMapping, when called with $FFFFFFFF for the hanlde value,
      creates a region of shared memory }
    FHandle := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0,
        Size, PChar(Name));
    if FHandle = 0 then abort;
    FCreated := GetLastError = 0;
    { We still need to map a pointer to the handle of the shared memory region }
    FFileView := MapViewOfFile(FHandle, FILE_MAP_WRITE, 0, 0, Size);
    if FFileView = nil then abort;
  except
    Error(Format('Error creating shared memory %s (%d)', [Name, GetLastError]));
  end;
end;

destructor TSharedMem.Destroy;
begin
  if FFileView <> nil then
    UnmapViewOfFile(FFileView);
  inherited Destroy;
end;


end.
