unit APIHookUtils;

interface

uses Windows;

type
  TAPIHOOK32_ENTRY = record
	  pszAPIName : PChar;   // 要被钩住的API名称，注意大小写
	  pszCalleeModuleName : PChar; // 要被钩住的API所在的模块的名称
	  pfnOriginApiAddress : TFarProc; //要被钩住的API的地址
	  pfnDummyFuncAddress : TFarProc;  //被钩住以后的地址
	  hModCallerModule : HMODULE;   // 需要被钩住的模块。0表示对所有模块的指定API进行钩住处理。非0表示只对这个模块的指定API进行钩住处理。
  end;
  PAPIHOOK32_ENTRY = ^TAPIHOOK32_ENTRY;

// 建立API函数钩子 HookSelf表示是否对包含HookWindowsAPI的模块也进行钩子处理。返回是否成功
function  HookWindowsAPI(const Entry : TAPIHOOK32_ENTRY; HookSelf : Boolean=False):BOOL;

// 取消API函数钩子 HookSelf表示是否对包含HookWindowsAPI的模块也进行钩子处理。返回是否成功
function  UnhookWindowsAPI(const Entry : TAPIHOOK32_ENTRY; HookSelf : Boolean=False):BOOL;

implementation

uses TLHelp32, Imagehlp;

const
  IMAGE_DIRECTORY_ENTRY_EXPORT = 0; { Export Directory }
  IMAGE_DIRECTORY_ENTRY_IMPORT = 1; { Import Directory }
  IMAGE_DIRECTORY_ENTRY_RESOURCE = 2; { Resource Directory }
  IMAGE_DIRECTORY_ENTRY_EXCEPTION = 3; { Exception Directory }
  IMAGE_DIRECTORY_ENTRY_SECURITY = 4; { Security Directory }
  IMAGE_DIRECTORY_ENTRY_BASERELOC = 5; { Base Relocation Table }
  IMAGE_DIRECTORY_ENTRY_DEBUG = 6; { Debug Directory }
  IMAGE_DIRECTORY_ENTRY_COPYRIGHT = 7; { Description String }
  IMAGE_DIRECTORY_ENTRY_GLOBALPTR = 8; { Machine Value (MIPS GP) }
  IMAGE_DIRECTORY_ENTRY_TLS   = 9; { TLS Directory }
  IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG = 10; { Load Configuration Directory }
  IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT = 11; { Bound Import Directory in headers }
  IMAGE_DIRECTORY_ENTRY_IAT   = 12; { Import Address Table }

  IMAGE_NUMBEROF_DIRECTORY_ENTRIES = 16;


type
  { Image format }
  PImageDosHeader = ^TImageDosHeader;
  TImageDosHeader = packed record
    e_magic: Word; // Magic number
    e_cblp: Word; // Bytes on last page of file
    e_cp: Word; // Pages in file
    e_crlc: Word; // Relocations
    e_cparhdr: Word; // Size of header in paragraphs
    e_minalloc: Word; // Minimum extra paragraphs needed
    e_maxalloc: Word; // Maximum extra paragraphs needed
    e_ss: Word; // Initial (relative) SS value
    e_sp: Word; // Initial SP value
    e_csum: Word; // Checksum
    e_ip: Word; // Initial IP value
    e_cs: Word; // Initial (relative) CS value
    e_lfarlc: Word; // File address of relocation table
    e_ovno: Word; // Overlay number
    e_res: array [ 0..3 ] of Word; // Reserved words
    e_oemid: Word; // OEM identifier (for e_oeminfo)
    e_oeminfo: Word; // OEM information; e_oemid specific
    e_res2: array [ 0..9 ] of Word; // Reserved words
    e_lfanew: Longint; // File address of new exe header
  end;


  PImageImportByName = ^TImageImportByName;
  TImageImportByName =
    packed record
    Hint: Word;
    Name: array [0..0] of Byte;
  end;

  PImageThunkData = ^TImageThunkData;
  TImageThunkData = packed record
    case Integer of
      0: (ForwarderString: PByte);
      1: (_Function: PDWORD);
      2: (Ordinal: DWORD);
      3: (AddressOfData: PImageImportByName);
  end;
  PIMAGE_THUNK_DATA = PImageThunkData;

  PImageImportDescriptor = ^TImageImportDescriptor;
  PIMAGE_IMPORT_DESCRIPTOR = PImageImportDescriptor;
  TImageImportDescriptor = packed record
    Union: record
      case Integer of
        0: (
             Characteristics: DWORD; // 0 for terminating null import descriptor
           );
        1: (
             OriginalFirstThunk: PImageThunkData; // RVA to original unbound IAT
           );
    end;

    TimeDateStamp: DWORD; // 0 if not bound,
                          // -1 if bound, and real date\time stamp
                          //     in IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT (new BIND)
                          // O.W. date/time stamp of DLL bound to (Old BIND)

    ForwarderChain: DWORD; // -1 if no forwarders
    Name: DWORD;
    FirstThunk: PImageThunkData; // RVA to IAT (if bound this IAT has actual addresses)
  end;

  PFarProc = ^TFarProc;

function  _SetApiHookUp(const phk : TAPIHOOK32_ENTRY):BOOL;
var
  size : ULONG;
  pImportDesc : PIMAGE_IMPORT_DESCRIPTOR;
  pszDllName : PChar;
  pThunk : PIMAGE_THUNK_DATA;
  ppfn : PFarProc;
  lpNumberOfBytesWritten: DWORD;
begin
  Result := False;

	//获取指向PE文件中的Import中IMAGE_DIRECTORY_DESCRIPTOR数组的指针
	pImportDesc := PIMAGE_IMPORT_DESCRIPTOR(
		ImageDirectoryEntryToData(Pointer(phk.hModCallerModule),TRUE,IMAGE_DIRECTORY_ENTRY_IMPORT,size));

	if (pImportDesc = nil) then
		Exit;

	//查找记录,看看有没有我们想要的DLL
  while (pImportDesc.Name<>0) do
	begin
		pszDllName := PChar(phk.hModCallerModule+pImportDesc^.Name);
		if (lstrcmpiA(pszDllName,phk.pszCalleeModuleName) = 0) then
    begin
      // 找到一个正确的DLL Import入口。注意一个DLL可能有多个入口
      //寻找我们想要的函数
      pThunk := PIMAGE_THUNK_DATA(phk.hModCallerModule+Longword(pImportDesc^.FirstThunk));//IAT
      while (pThunk^._Function<>nil) do
      begin
        //ppfn记录了与IAT表项相应的函数的地址
        ppfn := PFarProc(@pThunk^._Function);
        if ( ppfn^ = phk.pfnOriginApiAddress) then
        begin
          //如果地址相同，也就是找到了我们想要的函数，进行改写，将其指向我们所定义的函数
          WriteProcessMemory(GetCurrentProcess(),ppfn,@(phk.pfnDummyFuncAddress),sizeof(phk.pfnDummyFuncAddress),lpNumberOfBytesWritten);
          Result := True;
          Break; //完成一个入口
        end;
        Inc(pThunk);
      end;
    end;
    Inc(pImportDesc);
	end;
end;

function  HookWindowsAPI(const Entry : TAPIHOOK32_ENTRY; HookSelf : Boolean=False):BOOL;
var
  mInfo : MEMORY_BASIC_INFORMATION;
	hModHookDLL :	HMODULE;
	hSnapshot :	THANDLE;
  me : MODULEENTRY32;
  bOk : BOOL;
  phk : TAPIHOOK32_ENTRY;
begin
  phk := Entry;
  Result := False;
  if (phk.pszAPIName=nil) or (phk.pszCalleeModuleName=nil) or (phk.pfnOriginApiAddress=nil) then
    Exit;
  if (phk.hModCallerModule = 0) then
	begin
		me.dwSize := sizeof(me);

		VirtualQuery(@_SetApiHookUp,mInfo,sizeof(mInfo));
		hModHookDLL := HMODULE(mInfo.AllocationBase);

		hSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE,0);
		bOk := Module32First(hSnapshot,me);
		while (bOk) do
		begin
			if HookSelf or (me.hModule<>hModHookDLL) then
			begin
				phk.hModCallerModule := me.hModule;
				if _SetApiHookUp(phk) then
          Result := TRUE;
			end;
			bOk := Module32Next(hSnapshot,me);
		end;
	end
	else
	begin
		Result := _SetApiHookUp(phk);
	end;
end;

function UnhookWindowsAPI(const Entry : TAPIHOOK32_ENTRY; HookSelf : Boolean=False):BOOL;
var
  hk : TAPIHOOK32_ENTRY;
begin
  hk := Entry;
	hk.pfnOriginApiAddress := Entry.pfnDummyFuncAddress;
	hk.pfnDummyFuncAddress := Entry.pfnOriginApiAddress;
	Result := HookWindowsAPI(hk,HookSelf);
end;

end.
