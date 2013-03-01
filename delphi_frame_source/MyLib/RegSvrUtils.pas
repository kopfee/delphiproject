unit RegSvrUtils;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>RegSvrUtils
   <What>注册ActiveX Server的过程。更改自Borland的TRegSvr。
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}


interface

uses
  SysUtils, Windows, ActiveX, ComObj;

type
  TRegType = (rtAxLib, rtTypeLib, rtExeLib);
  TRegAction = (raReg, raUnreg);

procedure RegisterComServer(const AFileName : string; RegType: TRegType = rtAxLib; RegAction: TRegAction = raReg);

implementation

type
  TRegProc = function : HResult; stdcall;
  TUnRegTlbProc = function (const libID: TGUID; wVerMajor, wVerMinor: Word;
    lcid: TLCID; syskind: TSysKind): HResult; stdcall;

const
  ProcName: array[TRegAction] of PChar = (
    'DllRegisterServer', 'DllUnregisterServer');
  ExeFlags: array[TRegAction] of string = (' /regserver', ' /unregserver');
  
resourcestring
  SFileNotFound = 'File "%s" not found';
  SCantFindProc = '%s procedure not found in "%s"';
  SRegFail = 'Call to %s failed in "%s"';
  SLoadFail = 'Failed to load "%s"';
  SRegStr = 'registered';
  SUnregStr = 'unregistered';
  SCantUnregTlb = 'The version of OLEAUT32.DLL on this machine does not ' +
    'support type library unregistration.';
  SExeRegUnsuccessful = '%s failed.';

procedure RegisterComServer(const AFileName : string; RegType: TRegType = rtAxLib; RegAction: TRegAction = raReg);
var
  RegProc: TRegProc;
  LibHandle: THandle;
  OleAutLib: THandle;
  UnRegTlbProc: TUnRegTlbProc;
  FileName : string;

  procedure RegisterAxLib;
  begin
    LibHandle := LoadLibrary(PChar(FileName));
    if LibHandle = 0 then raise Exception.CreateFmt(SLoadFail, [FileName]);
    try
      @RegProc := GetProcAddress(LibHandle, ProcName[RegAction]);
      if @RegProc = Nil then
        raise Exception.CreateFmt(SCantFindProc, [ProcName[RegAction],
          FileName]);
      if RegProc <> 0 then
        raise Exception.CreateFmt(SRegFail, [ProcName[RegAction], FileName]);
    finally
      FreeLibrary(LibHandle);
    end;
  end;

  procedure RegisterTLB;
  const
    RegMessage: array[TRegAction] of string = (SRegStr, SUnregStr);
  var
    WFileName, DocName: WideString;
    TypeLib: ITypeLib;
    LibAttr: PTLibAttr;
    DirBuffer: array[0..MAX_PATH] of char;
  begin
    if ExtractFilePath(FileName) = '' then
    begin
      GetCurrentDirectory(SizeOf(DirBuffer), DirBuffer);
      FileName := '\' + FileName;
      FileName := DirBuffer + FileName;
    end;
    if not FileExists(FileName) then
      raise Exception.CreateFmt(SFileNotFound, [FileName]);
    WFileName := FileName;
    OleCheck(LoadTypeLib(PWideChar(WFileName), TypeLib));
    OleCheck(TypeLib.GetLibAttr(LibAttr));
    try
      if RegAction = raReg then
      begin
        OleCheck(TypeLib.GetDocumentation(-1, nil, nil, nil, @DocName));
        DocName := ExtractFilePath(DocName);
        OleCheck(RegisterTypeLib(TypeLib, PWideChar(WFileName), PWideChar(DocName)));
      end
      else begin
        OleAutLib := GetModuleHandle('OLEAUT32.DLL');
        if OleAutLib <> 0 then
          @UnRegTlbProc := GetProcAddress(OleAutLib, 'UnRegisterTypeLib');
        if @UnRegTlbProc = nil then raise Exception.Create(SCantUnregTlb);
        with LibAttr^ do
          OleCheck(UnRegTlbProc(Guid, wMajorVerNum, wMinorVerNum, LCID, SysKind));
      end;
    finally
      TypeLib.ReleaseTLibAttr(LibAttr);
    end;
  end;

  procedure RegisterEXE;
  var
    SI: TStartupInfo;
    PI: TProcessInformation;
    RegisterExitCode: BOOL;
  begin
    FillChar(SI, SizeOf(SI), 0);
    SI.cb := SizeOf(SI);
    RegisterExitCode := Win32Check(CreateProcess(PChar(FileName), PChar(FileName + ExeFlags[RegAction]),
      nil, nil, True, 0, nil, nil, SI, PI));
    CloseHandle(PI.hThread);
    CloseHandle(PI.hProcess);
    if not RegisterExitCode then
      raise Exception.Create(Format(SExeRegUnsuccessful, [PChar(FileName + ExeFlags[RegAction])]));
  end;

begin
  FileName := AFileName;
  if not FileExists(FileName) then
    raise Exception.CreateFmt(SFileNotFound, [FileName]);
  case RegType of
    rtAxLib: RegisterAxLib;
    rtTypeLib: RegisterTLB;
    rtExeLib: RegisterEXE;
  end;
end;
  
end.
