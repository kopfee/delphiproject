unit RPEasyReports;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>RPEasyReports
   <What>将实际的打印设备和TReportProcessor结合起来完成打印和预览的工作.
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

interface

uses SysUtils, Classes, Graphics, Controls, Contnrs,
  RPDefines, PrintDevices, RPDB, RPProcessors;

type
  TRPEasyReport = class(TComponent)
  private
    FProcessor: TReportProcessor;
    FEnvironment: TRPDataEnvironment;
    procedure   SetProcessor(const Value: TReportProcessor);
    procedure   SetEnvironment(const Value: TRPDataEnvironment);
  protected
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    procedure   Print(StartPage : Integer=0; EndPage : Integer=0);
    procedure   Preview(StartPage : Integer=0; EndPage : Integer=0);
  published
    property    Processor :  TReportProcessor read FProcessor write SetProcessor;
    property    Environment : TRPDataEnvironment read FEnvironment write SetEnvironment;
  end;

implementation

uses Printers, RPPreview, SafeCode;

{ TRPEasyReport }

procedure TRPEasyReport.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation=opRemove) then
  begin
    if (AComponent=FProcessor) then
      FProcessor:=nil;
    if (AComponent=FEnvironment) then
      FEnvironment := nil;
  end;
end;

procedure TRPEasyReport.Preview(StartPage : Integer=0; EndPage : Integer=0);
var
  MetaFilePrinter : TMetaFilePrinter;
  aPrinter : TPrinter;
  WillPrint : Boolean;
begin
  //WillPrint := false;
  CheckObject(Processor,'Processor is null');
  if Processor.Report=nil then
    Processor.CreateReportFromDesign;
  Assert(Processor.Report<>nil);
  Processor.Environment := Environment;
  aPrinter := Printers.Printer;
  MetaFilePrinter := TMetaFilePrinter.Create(Self);
  try
    MetaFilePrinter.PageLikeThis(aPrinter.Handle);
    Processor.Printer := MetaFilePrinter;
    {Processor.PageWidth := MetaFilePrinter.Width;
    Processor.PageHeight := MetaFilePrinter.Height;}
    Processor.Print(StartPage,EndPage);
    if not MetaFilePrinter.Aborted then
      WillPrint := RPPreview.Preview(MetaFilePrinter) else
      WillPrint := False;
  finally
    Processor.Printer := nil;
    MetaFilePrinter.Free;
  end;
  if WillPrint then
    Print(StartPage,EndPage);
end;

procedure TRPEasyReport.Print(StartPage : Integer=0; EndPage : Integer=0);
var
  APrinter : TStandardPrinter;
begin
  CheckObject(Processor,'Processor is null');
  if Processor.Report=nil then
    Processor.CreateReportFromDesign;
  Assert(Processor.Report<>nil);
  Processor.Environment := Environment;
  APrinter := TStandardPrinter.Create(Self);
  try
    Processor.Printer := APrinter;
    Processor.Print(StartPage,EndPage);
  finally
    Processor.Printer := nil;
    APrinter.Free;
  end;
end;

procedure TRPEasyReport.SetEnvironment(const Value: TRPDataEnvironment);
begin
  if FEnvironment <> Value then
  begin
    FEnvironment := Value;
    if FEnvironment<>nil then
      FEnvironment.FreeNotification(Self);
  end;
end;

procedure TRPEasyReport.SetProcessor(const Value: TReportProcessor);
begin
  if FProcessor <> Value then
  begin
    FProcessor := Value;
    if FProcessor<>nil then
      FProcessor.FreeNotification(Self);
  end;
end;

end.
