unit PrintUtils;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> PrintUtils
   <What> 有关打印的工具
   <Written By> Huang YanLai
   <History>
**********************************************}


interface

uses Windows, SysUtils, Classes, Printers;

type
  TKSPrinterInfo = record
    Device : string;
    Driver : string;
    Port   : string;
    FullDevice : string;
    //PaperWidth : Single;
    //PaperHeight: Single;
    //PaperSize : Integer;
    FormName : string;
    Orientation: TPrinterOrientation;
  end;

procedure GetJobs(Jobs : TStrings);

procedure GetPrinterInfo(var PrinterInfo : TKSPrinterInfo);

procedure SetPrinterPage(APaperWidth, APaperHeight : Single; AOrientation : TPrinterOrientation);

implementation

uses WinSpool;

const
  MaxJob = 200;

procedure GetJobs(Jobs : TStrings);
var
  PrinterHandle : THandle;
  Device : String;
  JobInfos : Array[0..MaxJob-1] of TJobInfo1;
  pcbNeeded,pcbReturn : Cardinal;
  Start : integer;
  i : integer;
begin
  Jobs.clear;
  //Device := TPrinterDevice(Printer.Printers.Objects(Printer.PrinterIndex)).Device;
  Device := Printer.Printers[Printer.PrinterIndex];
  i := pos(' on ',Device);
  if i>0 then
    Device := Copy(Device,1,i-1);
  if OpenPrinter(Pchar(Device), PrinterHandle, nil) then
  begin
    Start := 0;
    if EnumJobs(PrinterHandle,Start,MaxJob,1,@JobInfos,sizeof(JobInfos),pcbNeeded,pcbReturn) then
    begin
      for i:=0 to pcbReturn-1 do
      begin
        Jobs.add(format('%s [%d/%d]',
          [JobInfos[i].pDocument,JobInfos[i].PagesPrinted,JobInfos[i].TotalPages]));
      end;
    end;
  end;
end;

procedure SetPrinterPage(APaperWidth, APaperHeight : Single; AOrientation : TPrinterOrientation);
var
  Device, Driver, Port : array[0..255] of Char;
  DeviceMode : THandle;
  DevMode : PDeviceMode;

  procedure SetField(aField : Longword);
  begin
    DevMode^.dmFields := DevMode^.dmFields or aField;
  end;

begin
  Printers.Printer.GetPrinter(Device, Driver, Port, DeviceMode);
  DevMode := GlobalLock(DeviceMode);
  try
    SetField(dm_paperlength);
    DevMode^.dmPaperLength := Round(APaperHeight);
    SetField(dm_paperwidth);
    DevMode^.dmPaperWidth := Round(APaperWidth);

    SetField(dm_orientation);
    if AOrientation=poPortrait then
      DevMode^.dmOrientation := dmorient_portrait
    else
      DevMode^.dmOrientation := dmorient_landscape;
    Printers.Printer.SetPrinter(Device, Driver, Port, DeviceMode);
  finally
    GlobalUnlock(DeviceMode);
  end;
end;

procedure GetPrinterInfo(var PrinterInfo : TKSPrinterInfo);
var
  Device, Driver, Port : array[0..255] of Char;
  DeviceMode : THandle;
  DevMode : PDeviceMode;
begin
  Printers.Printer.GetPrinter(Device, Driver, Port, DeviceMode);
  PrinterInfo.FullDevice := Device;
  PrinterInfo.Driver := Driver;
  PrinterInfo.Port := Port;
  PrinterInfo.Orientation := Printers.Printer.Orientation;

  DevMode := GlobalLock(DeviceMode);
  try
    PrinterInfo.Device := DevMode^.dmDeviceName;
    PrinterInfo.FormName := DevMode^.dmFormName;
  finally
    GlobalUnlock(DeviceMode);
  end;
end;

end.
