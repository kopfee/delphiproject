unit DesignUtils;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> DesignUtils
   <What> 在Delphi IDE环境中发挥作用的辅助工具
   Component Editor
   Property Editor
   Expert
   Custom Module
   <Written By> Huang YanLai
   <History>
**********************************************}

{$I KSConditions.INC }

interface

uses Windows, SysUtils, Classes, Controls, Forms, ExptIntf, ToolIntf, VirtIntf,
  IStreams, TypInfo
  {$ifdef VCL60_UP }
    ,DesignIntf, DesignEditors
  {$else}
    ,dsgnintf
  {$endif}
  ;

type
  TModuleCreator = class(TIExpert)
  private
    FComment: string;
    FIDString: string;
    FAuthor: string;
    FName: string;
    FBaseClass: TComponentClass;
    FBaseName: String;
    FUnits: String;
  public
    constructor Create(ABaseClass : TComponentClass);

    function    GetName: string; override;
    function    GetComment: string; override;
    function    GetGlyph: HICON; override;
    function    GetStyle: TExpertStyle; override;
    function    GetState: TExpertState; override;
    function    GetIDString: string; override;
    function    GetAuthor: string; override;
    function    GetPage: string; override;
    function    GetMenuText: string; override;
    procedure   Execute; override;

    property    Name : string read FName write FName;
    property    Comment : string read FComment write FComment;
    property    IDString : string read FIDString write FIDString;
    property    Author : string read FAuthor write FAuthor;
    property    BaseClass : TComponentClass read FBaseClass;
    property    BaseName : String read FBaseName ;
    property    Units : String read FUnits write FUnits;
  end;

// Units = ',abc,def'
procedure RegisterEditModule(ABaseClass : TComponentClass; const Units:String='');

type
  TCustomPropertyEditor = class(TComponentEditor)
  private
    FContinue : Boolean;
    {$ifdef VCL60_UP }
    FPropEditor : IProperty;
    {$else}
    FPropEditor : TPropertyEditor;
    {$endif}
  protected
    FMenuCaption : string;
    procedure   Init; virtual;
    {$ifdef VCL60_UP }
    procedure   CheckEdit(const PropertyEditor: IProperty); virtual;
    function    UseThisEditor(PropertyEditor: IProperty): Boolean; virtual; abstract;
    {$else}
    procedure   CheckEdit(PropertyEditor: TPropertyEditor); virtual;
    function    UseThisEditor(PropertyEditor: TPropertyEditor): Boolean; virtual; abstract;
    {$endif}
  public
    {$ifdef VCL60_UP }
    constructor Create(AComponent: TComponent; ADesigner: IDesigner); override;
    {$else}
    constructor Create(AComponent: TComponent; ADesigner: IFormDesigner); override;
    {$endif}
    procedure   ExecuteVerb(Index: Integer); override;
    function    GetVerb(Index: Integer): string; override;
    function    GetVerbCount: Integer; override;
  end;

  TUseDefaultPropertyEditor = class(TCustomPropertyEditor)
  private

  protected
    FPropName : string; // must set FPropName
    {$ifdef VCL60_UP }
    function    UseThisEditor(PropertyEditor: IProperty): Boolean; override;
    {$else}
    function    UseThisEditor(PropertyEditor: TPropertyEditor): Boolean; override;
    {$endif}
  public

  end;

  TCollectionEditor = class(TCustomPropertyEditor)
  protected
    procedure   Init; override;
    {$ifdef VCL60_UP }
    function    UseThisEditor(PropertyEditor: IProperty): Boolean; override;
    {$else}
    function    UseThisEditor(PropertyEditor: TPropertyEditor): Boolean; override;
    {$endif}
  end;

implementation

procedure RegisterEditModule(ABaseClass : TComponentClass; const Units:String='');
var
  ModuleCreator : TModuleCreator;
begin
  RegisterCustomModule(ABaseClass,TCustomModule);
  ModuleCreator := TModuleCreator.Create(ABaseClass);
  ModuleCreator.Units := Units;
  RegisterLibraryExpert(ModuleCreator);
end;

{ TModuleCreator }

constructor TModuleCreator.Create(ABaseClass: TComponentClass);
begin
  assert(ABaseClass<>nil);
  inherited Create;
  FBaseClass := ABaseClass;
  FBaseName := FBaseClass.ClassName;
  Delete(FBaseName,1,1); // delete 'T'
  FName := FBaseName;
  FComment := FBaseName;
  FIDString := 'NEW.'+FName;
end;

function TModuleCreator.GetName: string;
begin
  Result := FName;
end;

function TModuleCreator.GetComment: string;
begin
  Result := FComment;
end;

function TModuleCreator.GetGlyph: HICON;
begin
  Result := 0;{LoadIcon(HInstance, 'QRNEW');}
end;

function TModuleCreator.GetStyle: TExpertStyle;
begin
  Result := esForm;
end;

function TModuleCreator.GetState: TExpertState;
begin
  Result := [esEnabled];
end;

function TModuleCreator.GetIDString: string;
begin
  Result := FIDString;
end;

function TModuleCreator.GetAuthor: string;
begin
  Result := 'Huang Yanlai';
end;

function TModuleCreator.GetPage: string;
begin
  Result := 'New';{LoadStr(SqrNew);}
end;

function TModuleCreator.GetMenuText: string;
begin
  Result := '';
end;

const
  UnitSource =
    'unit %0:s;'#13#10 +
    #13#10 +
    'interface'#13#10 +
    #13#10 +
    'uses SysUtils, Windows, Messages, Classes, Graphics, Controls,Forms%3:s;'#13#10 +
    #13#10 +
    'type'#13#10 +
    '  T%1:s = class(T%2:s)'#13#10 +
    '  private'#13#10 +
    #13#10 +
    '  protected'#13#10 +
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
  DfmSource = 'object %s: T%0:s end';

procedure TModuleCreator.Execute;
var
  UnitIdent, Filename: string;
  ModuleName: string;
  CodeStream: TIStreamAdapter;
  DFMStream: TIStreamAdapter;
  DFMString, DFMVCLStream: TStream;
begin
  if not ToolServices.GetNewModuleName(UnitIdent, FileName) then Exit;
  ModuleName := BaseName + Copy(UnitIdent, 5, 255);
  CodeStream := TIStreamAdapter.Create(TStringStream.Create(Format(UnitSource,
    [UnitIdent, ModuleName, BaseName,Units])), soOwned);
  try
    IUnknown(CodeStream)._AddRef;
    DFMString := TStringStream.Create(Format(DfmSource, [ModuleName]));
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
        ToolServices.CreateModuleEx(FileName, ModuleName, FBaseClass.ClassName, '',
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

{ TCustomPropertyEditor }

type
  TPropertyEditorAccess = class(TPropertyEditor);

{$ifdef VCL60_UP }
constructor TCustomPropertyEditor.Create(AComponent: TComponent;
  ADesigner: IDesigner);
{$else}
constructor TCustomPropertyEditor.Create(AComponent: TComponent;
  ADesigner: IFormDesigner);
{$endif}
begin
  inherited;
  init;
end;

procedure   TCustomPropertyEditor.Init;
begin

end;

{$ifdef VCL60_UP }
procedure TCustomPropertyEditor.CheckEdit(const PropertyEditor: IProperty);
{$else}
procedure TCustomPropertyEditor.CheckEdit(PropertyEditor: TPropertyEditor);
{$endif}
begin
  try
    if UseThisEditor(PropertyEditor) then
    begin
      FContinue := true;
      FPropEditor := PropertyEditor;
    end;
  finally
    if FPropEditor <> PropertyEditor then
    {$ifdef VCL60_UP }

    {$else}
      PropertyEditor.Free;
    {$endif}
  end;
end;

procedure TCustomPropertyEditor.ExecuteVerb(Index: Integer);
var
  {$ifdef VCL60_UP }
  Components : IDesignerSelections;
  {$else}
  Components : TDesignerSelectionList;
  {$endif}
begin
  {$ifdef VCL60_UP }
  Components := CreateSelectionList;
  {$else}
  Components := TDesignerSelectionList.Create;
  {$endif}
  FContinue := false;
  FPropEditor := nil;
  try
    Components.Add(Component);
    {$ifdef VCL60_UP }
    GetComponentProperties(Components, [tkClass], Designer, CheckEdit);
    {$else}
    GetComponentProperties(Components, [tkClass], Designer, CheckEdit);
    {$endif}
    if FContinue and (FPropEditor<>nil) then
      FPropEditor.Edit;
  finally
    {$ifdef VCL60_UP }
    FPropEditor := nil;
    Components := nil;
    {$else}
    FPropEditor.Free;
    Components.Free;
    {$endif}
  end;
end;


function TCustomPropertyEditor.GetVerb(Index: Integer): string;
begin
  Result := FMenuCaption;
end;

function TCustomPropertyEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

{ TUseDefaultPropertyEditor }

{$ifdef VCL60_UP }
function TUseDefaultPropertyEditor.UseThisEditor(
  PropertyEditor: IProperty): Boolean;
{$else}
function TUseDefaultPropertyEditor.UseThisEditor(
  PropertyEditor: TPropertyEditor): Boolean;
{$endif}
begin
  Result := (FPropEditor=nil) and (CompareText(PropertyEditor.GetName,FPropName)=0);
end;

{ TCollectionEditor }

procedure TCollectionEditor.Init;
begin
  FMenuCaption := 'Edit Collection...';
end;

{$ifdef VCL60_UP }
function TCollectionEditor.UseThisEditor(
  PropertyEditor: IProperty): Boolean;
{$else}
function TCollectionEditor.UseThisEditor(
  PropertyEditor: TPropertyEditor): Boolean;
{$endif}
var
  Obj : TObject;  
begin
  Result := (FPropEditor=nil) and (PropertyEditor.GetPropType^.Kind=tkClass);
  if Result then
  begin
    Obj := TObject(TPropertyEditorAccess(PropertyEditor).GetOrdValue);
    Result := Obj is TCollection;
  end
end;

end.
