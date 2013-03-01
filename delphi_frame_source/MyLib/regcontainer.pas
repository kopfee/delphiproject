unit regcontainer;

interface

procedure Register;

implementation

uses Windows, SysUtils, Classes, Controls, Forms, ExptIntf, ToolIntf, VirtIntf,
  IStreams, DsgnIntf;

type
  TNewContainer = class(TIExpert)
  public
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

{ TNewContainer }

function TNewContainer.GetName: string;
begin
  Result := 'Container'; {<-- do not resource }
end;

function TNewContainer.GetComment: string;
begin
  Result := 'A Container';
end;

function TNewContainer.GetGlyph: HICON;
begin
  Result := 0;{LoadIcon(HInstance, 'QRNEW');}
end;

function TNewContainer.GetStyle: TExpertStyle;
begin
  Result := esForm;
end;

function TNewContainer.GetState: TExpertState;
begin
  Result := [esEnabled];
end;

function TNewContainer.GetIDString: string;
begin
  Result := 'HYL.NewContainer'; { <-- do not resource }
end;

function TNewContainer.GetAuthor: string;
begin
  Result := 'HYL';
end;

function TNewContainer.GetPage: string;
begin
  Result := 'New';{LoadStr(SqrNew);}
end;

function TNewContainer.GetMenuText: string;
begin
  Result := '';
end;

const
  UnitSource =
    'unit %0:s;'#13#10 +
    #13#10 +
    'interface'#13#10 +
    #13#10 +
    'uses SysUtils, Windows, Messages, Classes, Graphics, Controls,'#13#10 +
    '  StdCtrls, ExtCtrls, Forms,container;'#13#10 +
    #13#10 +
    'type'#13#10 +
    '  T%1:s = class(TContainer)'#13#10 +
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
    'initialization'#13#10 +
    #13#10 +
    'registerClass(T%1:s);'#13#10 +
    #13#10 +
    'end.'#13#10;
  DfmSource = 'object %s: T%0:s end';

procedure TNewContainer.Execute;
var
  UnitIdent, Filename: string;
  ContainerName: string;
  CodeStream: TIStreamAdapter;
  DFMStream: TIStreamAdapter;
  DFMString, DFMVCLStream: TStream;
begin
  if not ToolServices.GetNewModuleName(UnitIdent, FileName) then Exit;
  ContainerName := 'Container' + Copy(UnitIdent, 5, 255);
  CodeStream := TIStreamAdapter.Create(TStringStream.Create(Format(UnitSource,
    [UnitIdent, ContainerName])), soOwned);
  try
    IUnknown(CodeStream)._AddRef;
    DFMString := TStringStream.Create(Format(DfmSource, [ContainerName]));
    try
      DFMVCLStream := TMemoryStream.Create;
      try
        ObjectTextToResource(DFMString, DFMVCLStream);
        DFMVCLStream.Position := 0;
      except
        DFMVCLStream.Free;
      end;
      DFMStream := TIStreamAdapter.Create(DFMVCLStream, soOwned);
      try
        IUnknown(DFMStream)._AddRef;
        ToolServices.CreateModuleEx(FileName, ContainerName, 'TContainer', '',
          CodeStream, DFMStream, [cmAddToProject, cmShowSource, cmShowForm,
            cmUnNamed, cmMarkModified]);
      finally
        //DFMStream.Free;
        IUnknown(DFMStream)._release;
      end;
    finally
      DFMString.Free;
    end;
  finally
    // CodeStream.free;
    IUnknown(CodeStream)._release;
  end;
end;

procedure Register;
begin
  RegisterLibraryExpert(TNewContainer.Create);
end;
end.
