unit QRNew;

interface

procedure Register;

implementation

uses Windows, SysUtils, Classes, Controls, Forms, ExptIntf, ToolIntf, VirtIntf,
  IStreams, DsgnIntf, QuickRpt, QReport, QR2Const;

type
  TNewQuickReport = class(TIExpert)
    function GetName: string; override;
    function GetComment: string; override;
    function GetGlyph: HICON; override;
    function GetStyle: TExpertStyle; override;
    function GetState: TExpertState; override;
    function GetIDString: string; override;
    function GetAuthor: string; override;
    function GetPage: string; override;
    function GetMenuText: string; override;
    procedure Execute; override;
  end;

{ TNewQuickReport }

function TNewQuickReport.GetName: string;
begin
  Result := 'Report'; {<-- do not resource }
end;

function TNewQuickReport.GetComment: string;
begin
  Result := LoadStr(SqrDesignReport);
end;

function TNewQuickReport.GetGlyph: HICON;
begin
  Result := LoadIcon(HInstance, 'QRNEW');
end;

function TNewQuickReport.GetStyle: TExpertStyle;
begin
  Result := esForm;
end;

function TNewQuickReport.GetState: TExpertState;
begin
  Result := [esEnabled];
end;

function TNewQuickReport.GetIDString: string;
begin
  Result := 'QuSoft.NewQuickReport'; { <-- do not resource }
end;

function TNewQuickReport.GetAuthor: string;
begin
  Result := LoadStr(SqrQSD);
end;

function TNewQuickReport.GetPage: string;
begin
  Result := LoadStr(SqrNew);
end;

function TNewQuickReport.GetMenuText: string;
begin
  Result := '';
end;

const
  QuickReportUnitSource =
    'unit %0:s;'#13#10 +
    #13#10 +
    'interface'#13#10 +
    #13#10 +
    'uses SysUtils, Windows, Messages, Classes, Graphics, Controls,'#13#10 +
    '  StdCtrls, ExtCtrls, Forms, Quickrpt, QRCtrls;'#13#10 +
    #13#10 +
    'type'#13#10 +
    '  T%1:s = class(TQuickRep)'#13#10 +
    '  private'#13#10 +
    #13#10 +
    '  public'#13#10 +
    #13#10 +
    '  end;'#13#10 +
    #13#10 +
    'var'#13#10 +
    '  %1:s: T%1:s;'#13#10 +
    #13#10 +
    'implementation'#13#10 +
    #13#10 +
    '{$R *.DFM}'#13#10 +
    #13#10 +
    'end.'#13#10;
  QuickReportDfmSource = 'object %s: T%0:s end';

procedure TNewQuickReport.Execute;
var
  UnitIdent, Filename: string;
  ReportName: string;
  CodeStream: TIStream;
  DFMStream: TIStream;
  DFMString, DFMVCLStream: TStream;
begin
  if not ToolServices.GetNewModuleName(UnitIdent, FileName) then Exit;
  ReportName := 'QuickReport' + Copy(UnitIdent, 5, 255);
  CodeStream := TIStreamAdapter.Create(TStringStream.Create(Format(QuickReportUnitSource,
    [UnitIdent, ReportName])), True);
  try
    CodeStream.AddRef;
    DFMString := TStringStream.Create(Format(QuickReportDfmSource, [ReportName]));
    try
      DFMVCLStream := TMemoryStream.Create;
      try
        ObjectTextToResource(DFMString, DFMVCLStream);
        DFMVCLStream.Position := 0;
      except
        DFMVCLStream.Free;
      end;
      DFMStream := TIStreamAdapter.Create(DFMVCLStream, True);
      try
        DFMStream.AddRef;
        ToolServices.CreateModuleEx(FileName, ReportName, 'TQuickRep', '',
          CodeStream, DFMStream, [cmAddToProject, cmShowSource, cmShowForm,
            cmUnNamed, cmMarkModified]);
      finally
        DFMStream.Free;
      end;
    finally
      DFMString.Free;
    end;
  finally
    CodeStream.Free;
  end;
end;

type
  TQuickReportCustomModule = class(TCustomModule)
    function GetAttributes: TCustomModuleAttributes; override;
    procedure ValidateComponent(Component: TComponent); override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

function TQuickReportCustomModule.GetAttributes: TCustomModuleAttributes;
begin
  Result := [cmaVirtualSize];
end;

procedure TQuickReportCustomModule.ValidateComponent(Component: TComponent);
begin
  if (Component is TControl) and not (Component is TQRBasePanel)
    and not (Component is TQRPrintable) then
    raise Exception.CreateFmt(LoadStr(SqrCannotAdd),
      [Component.ClassName]);
end;

procedure TQuickReportCustomModule.ExecuteVerb(Index: Integer);
begin
  ExecuteDesignVerb(Index, Root as TQuickRep);
end;

function TQuickReportCustomModule.GetVerb(Index: Integer): string;
begin
  Result := GetDesignVerb(Index);
end;

function TQuickReportCustomModule.GetVerbCount: Integer;
begin
  Result := GetDesignVerbCount;
end;

procedure Register;
begin
  RegisterCustomModule(TQuickRep, TQuickReportCustomModule);
  RegisterLibraryExpert(TNewQuickReport.Create);
end;

end.

