unit PrjRepScripts;

interface

uses SysUtils, Classes, TextUtils, Contnrs, TextTags, FuncScripts, AbsParsers, TypUtils
{$ifdef ToolsAPI}
  , ToolsAPI
{$endif}
;

type
  TNewFileNameEvent = procedure (const ID : string; var FileName : string) of object;

  TPRContext = class(TAbsContext)
  private
    {$ifdef ToolsAPI}
    FProjectGroup : IOTAProjectGroup;
    FProject : IOTAProject;
    FModuleFile : string;
    FModuleName : string;
    FModuleForm : string;
    {$endif}
    FTempProperty : TProperty;
    FStringValue : string;
    FPostfix : string;
    FPostfixDescription : string;
    FFileIDs : TStringList;
    FFileNames : TStringList;
    FOnNewFileName: TNewFileNameEvent;
    FNewFileSubdir: string;
    FFilePath : string;
    FStack : TList;
    FDefaultOutputFile: string;
    FDefaultPostfix: string;
    function    GetCurrentObject: TObject;
    procedure   SetCurrentObject(const Value: TObject);
    function    GetObjects(Index: Integer): TObject;
    function    GetLocalFrameCount: Integer;
    procedure   IncludeScriptFile(const FileName:string);
  protected
    procedure   ParseFunc(Func : TScriptFunc); override;
    procedure   BeforeOutput; override;
    procedure   AfterOutput; override;
    function    NewFileName(const ID : string) : string; virtual;
    procedure   SetupLocalFrame;
    procedure   FreeLocalFrame;
    property    CurrentObject : TObject read GetCurrentObject write SetCurrentObject;
    property    Objects[Index : Integer] : TObject read GetObjects;
    property    LocalFrameCount : Integer read GetLocalFrameCount;
    function    GetNodeClasses : TList; override;
  public
    procedure   Clear; override;
    function    GetFileName(const ID : string; Relative : Boolean) : string;
    function    GetFileNameEx(const ID, NameFormat : string; Relative : Boolean) : string;
    function    GetObjectFullPath : string;
    procedure   NewFile(const ID, NameFormat : string);
    class procedure RegisterNodeClass(NodeClasse : TAbsScriptNodeClass);
    class procedure UnRegisterNodeClass(NodeClasse : TAbsScriptNodeClass);
    property    Postfix : string read FPostfix write FPostfix;
    property    PostfixDescription : string read FPostfixDescription write FPostfixDescription;
    property    NewFileSubdir : string read FNewFileSubdir write FNewFileSubdir;
    property    DefaultOutputFile : string read FDefaultOutputFile write FDefaultOutputFile;
    property    DefaultPostfix : string read FDefaultPostfix write FDefaultPostfix;
    property    OnNewFileName : TNewFileNameEvent read FOnNewFileName write FOnNewFileName;
  end;

  TPRObjectBegin = class(TAbsBeginLoop)
  private
    //FSavedObject : TObject;
    FRoot : TObject;
  protected
    procedure   InitLoop; override;
    procedure   InternalDoIt; override;
    procedure   ExitLoop; override;
  public

  end;

  TPROneObjectBegin = class(TPRObjectBegin)
  private
    FFirst : Boolean;
  protected
    procedure   InitLoop; override;
    procedure   InternalDoIt; override;
    function    MarchLoopCondition : Boolean; override;
    function    InitRootObject : TObject; virtual; abstract;
  public

  end;

  {$ifdef ToolsAPI}

  TPRProjectBegin = class(TAbsBeginLoop)
  private
    FProjectGroup : IOTAProjectGroup;
    FProjectIndex : Integer;
  protected
    procedure   InitLoop; override;
    procedure   ExitLoop; override;
    procedure   InternalDoIt; override;
    function    MarchLoopCondition : Boolean; override;
  public
    class function GetFuncName : string; override;
  end;

  TPRProjectEnd = class(TAbsEndLoop)
  protected
    function    AcceptBeginLoop(BeginLoop : TAbsBeginLoop) : Boolean; override;
  public
    class function GetFuncName : string; override;
  end;

  TPRFormBegin = class(TPRObjectBegin)
  private
    FModuleIndex : Integer;
    FSavedEditor : IUnknown;
    FSavedModule : IOTAModule;
    FModuleClassType: string;
  protected
    procedure   InitLoop; override;
    procedure   InternalDoIt; override;
    procedure   ExitLoop; override;
    function    MarchLoopCondition : Boolean; override;
  public
    property    ModuleClassType : string read FModuleClassType write FModuleClassType;
    class function GetFuncName : string; override;
    procedure   InitFromScriptFunc(Func : TScriptFunc); override;
  end;

  TPRFormEnd = class(TAbsEndLoop)
  protected
    function    AcceptBeginLoop(BeginLoop : TAbsBeginLoop) : Boolean; override;
  public
    class function GetFuncName : string; override;
  end;

  TPRUnitBegin = class(TPRObjectBegin)
  private
    FModuleIndex : Integer;
  protected
    procedure   InitLoop; override;
    procedure   InternalDoIt; override;
    procedure   ExitLoop; override;
    function    MarchLoopCondition : Boolean; override;
  public
    class function GetFuncName : string; override;
  end;

  TPRUnitEnd = class(TAbsEndLoop)
  protected
    function    AcceptBeginLoop(BeginLoop : TAbsBeginLoop) : Boolean; override;
  public
    class function GetFuncName : string; override;
  end;

  TPRCurFormModuleBegin = class(TPROneObjectBegin)
  protected
    function    InitRootObject : TObject; override;
  public
    class function GetFuncName : string; override;
  end;

  TPRCurFormModuleEnd = class(TAbsEndLoop)
  protected
    function    AcceptBeginLoop(BeginLoop : TAbsBeginLoop) : Boolean; override;
  public
    class function GetFuncName : string; override;
  end;

  {$endif}

  TPRFormBegin2 = class(TPRObjectBegin)
  private
    FComponentIndex : Integer;
    FModuleClassType: string;
  protected
    procedure   InitLoop; override;
    procedure   InternalDoIt; override;
    function    MarchLoopCondition : Boolean; override;
    property    ModuleClassType : string read FModuleClassType write FModuleClassType;
  public
    class function GetFuncName : string; override;
    procedure   InitFromScriptFunc(Func : TScriptFunc); override;
  end;

  TPRFormEnd2 = class(TAbsEndLoop)
  protected
    function    AcceptBeginLoop(BeginLoop : TAbsBeginLoop) : Boolean; override;
  public
    class function GetFuncName : string; override;
  end;

  TPRComponentBegin = class(TPRObjectBegin)
  private
    FComponentIndex : Integer;
    FComponentClassNames: TStrings;
    procedure   SetComponentClassNames(const Value: TStrings);
  protected
    procedure   InitLoop; override;
    procedure   InternalDoIt; override;
    function    MarchLoopCondition : Boolean; override;
  public
    constructor Create; override;
    destructor  Destroy;override;
    property    ComponentClassNames : TStrings read FComponentClassNames write SetComponentClassNames;
    class function GetFuncName : string; override;
    procedure   InitFromScriptFunc(Func : TScriptFunc); override;
  end;

  TPRComponentEnd = class(TAbsEndLoop)
  protected
    function    AcceptBeginLoop(BeginLoop : TAbsBeginLoop) : Boolean; override;
  public
    class function GetFuncName : string; override;
  end;

  TPRItemsBegin = class(TPRObjectBegin)
  private
    FItemIndex : Integer;
    FPropertyName: string;
    FCollection : TCollection;
  protected
    procedure   InitLoop; override;
    procedure   InternalDoIt; override;
    function    MarchLoopCondition : Boolean; override;
    property    PropertyName : string read FPropertyName write FPropertyName;
  public
    class function GetFuncName : string; override;
    procedure   InitFromScriptFunc(Func : TScriptFunc); override;
  end;

  TPRItemsEnd = class(TAbsEndLoop)
  protected
    function    AcceptBeginLoop(BeginLoop : TAbsBeginLoop) : Boolean; override;
  public
    class function GetFuncName : string; override;
  end;

  TPRStringsBegin = class(TPRObjectBegin)
  private
    FItemIndex : Integer;
    FPropertyName: string;
    FStrings : TStrings;
  protected
    procedure   InitLoop; override;
    procedure   InternalDoIt; override;
    function    MarchLoopCondition : Boolean; override;
    property    PropertyName : string read FPropertyName write FPropertyName;
  public
    class function GetFuncName : string; override;
    procedure   InitFromScriptFunc(Func : TScriptFunc); override;
  end;

  TPRStringsEnd = class(TAbsEndLoop)
  protected
    function    AcceptBeginLoop(BeginLoop : TAbsBeginLoop) : Boolean; override;
  public
    class function GetFuncName : string; override;
  end;

  TPRProperty = class(TAbsScriptNode)
  private
    AProperty : TProperty;
    FPropertyName: string;
    FObjectIndex: Integer;
  public
    constructor Create; override;
    destructor  Destroy;override;
    procedure   DoIt; override;
    property    PropertyName : string read FPropertyName write FPropertyName;
    property    ObjectIndex : Integer read FObjectIndex write FObjectIndex;
    class function GetFuncName : string; override;
    procedure   InitFromScriptFunc(Func : TScriptFunc); override;
  end;

  TPRStringValue = class(TAbsScriptNode)
  public
    procedure   DoIt; override;
    class function GetFuncName : string; override;
  end;

  TPRPersistentBegin = class(TPRObjectBegin)
  private
    FPropertyName: string;
    FDone : Boolean;
  protected
    procedure   InitLoop; override;
    procedure   InternalDoIt; override;
    function    MarchLoopCondition : Boolean; override;
    property    PropertyName : string read FPropertyName write FPropertyName;
  public
    class function GetFuncName : string; override;
    procedure   InitFromScriptFunc(Func : TScriptFunc); override;
  end;

  TPRPersistentEnd = class(TAbsEndLoop)
  protected
    function    AcceptBeginLoop(BeginLoop : TAbsBeginLoop) : Boolean; override;
  public
    class function GetFuncName : string; override;
  end;

  TPRNewFileName = class(TAbsScriptNode)
  private
    FFileID: string;
    FNameFormat: string;
  public
    procedure   DoIt; override;
    property    FileID : string read FFileID write FFileID;
    property    NameFormat : string read FNameFormat write FNameFormat;
    class function GetFuncName : string; override;
    procedure   InitFromScriptFunc(Func : TScriptFunc); override;
  end;

  TPRNewFile = class(TAbsScriptNode)
  private
    FFileID: string;
    FNameFormat: string;
  public
    procedure   DoIt; override;
    property    FileID : string read FFileID write FFileID;
    property    NameFormat : string read FNameFormat write FNameFormat;
    class function GetFuncName : string; override;
    procedure   InitFromScriptFunc(Func : TScriptFunc); override;
  end;

  TPRName = class(TAbsScriptNode)
  private
    FObjectName: string;
  public
    procedure   DoIt; override;
    property    ObjectName : string read FObjectName write FObjectName;
    class function GetFuncName : string; override;
    procedure   InitFromScriptFunc(Func : TScriptFunc); override;
  end;

  TPRFileName = class(TAbsScriptNode)
  private
    FObjectName: string;
  public
    procedure   DoIt; override;
    property    ObjectName : string read FObjectName write FObjectName;
    class function GetFuncName : string; override;
    procedure   InitFromScriptFunc(Func : TScriptFunc); override;
  end;

resourcestring
  UnassignedString = '无';

implementation

uses Windows, Forms, KSStrUtils, SafeCode, ExtUtils, FileCtrl, Controls

{$ifdef ToolsAPI}
 ,ToolAPIUtils
{$endif}
;

var
  PrjRepNodeClasses : TList = nil;

procedure CheckNodeClasses;
begin
  if PrjRepNodeClasses=nil then
    PrjRepNodeClasses := TList.Create;
end;

{$ifdef ToolsAPI}

{ TPRProjectBegin }

procedure TPRProjectBegin.ExitLoop;
begin
  inherited;
  FProjectGroup := nil;
  FProjectIndex := 0;
end;

class function TPRProjectBegin.GetFuncName: string;
begin
  Result := 'project';
end;

procedure TPRProjectBegin.InitLoop;
begin
  inherited;
  FProjectGroup := GetProjectGroup;
  if FProjectGroup<>nil then
    WriteMsg('Get ProjectGroup') else
    WriteMsg('Cannot Get ProjectGroup');
  FProjectIndex := 0;
end;

procedure TPRProjectBegin.InternalDoIt;
begin
  inherited;
  TPRContext(Context).FProjectGroup := FProjectGroup;
  TPRContext(Context).FProject := FProjectGroup.GetProject(FProjectIndex);
  //TPRContext(Context).CurrentObject := nil;
  Inc(FProjectIndex);
end;

function TPRProjectBegin.MarchLoopCondition: Boolean;
begin
  Result := (FProjectGroup<>nil) and (FProjectIndex<FProjectGroup.GetProjectCount);
end;

{ TPRProjectEnd }

function TPRProjectEnd.AcceptBeginLoop(BeginLoop: TAbsBeginLoop): Boolean;
begin
  Result := BeginLoop is TPRProjectBegin;
end;

class function TPRProjectEnd.GetFuncName: string;
begin
  Result := 'endproject';
end;

{ TPRFormBegin }

procedure TPRFormBegin.ExitLoop;
begin
  inherited;
  FSavedEditor := nil;
  if FSavedModule<>nil then
  begin
    FSavedModule.Close;
    FSavedModule := nil;
  end;
end;

class function TPRFormBegin.GetFuncName: string;
begin
  Result := 'pform';
end;

procedure TPRFormBegin.InitFromScriptFunc(Func: TScriptFunc);
begin
  inherited;
  ModuleClassType := GetParam(Func.Params,0,'TComponent');
end;

procedure TPRFormBegin.InitLoop;
begin
  inherited;
  FModuleIndex := 0;
  FRoot := nil;
end;

procedure TPRFormBegin.InternalDoIt;
begin
  inherited;
  Inc(FModuleIndex);
  CheckTrue(FRoot<>nil,'Root is nil');
  CheckTrue(TPRContext(Context).LocalFrameCount>0,'out of frame');
end;

function TPRFormBegin.MarchLoopCondition: Boolean;
var
  ModuleInfo : IOTAModuleInfo;
  Module : IOTAModule;
  Editor : IOTAEditor;
  ModuleFileIndex, ModuleFileCount : Integer;
  FormEditor : IOTAFormEditor;
begin
  Result := False;
  FSavedEditor := nil;
  if FSavedModule<>nil then
  begin
    FSavedModule.Close;
    FSavedModule := nil;
  end;
  try
    try
      if TPRContext(Context).FProject<>nil then
      begin
        while FModuleIndex<TPRContext(Context).FProject.GetModuleCount do
        begin
          ModuleInfo := TPRContext(Context).FProject.GetModule(FModuleIndex);
          if ModuleInfo.GetFormName<>'' then
          begin
            //WriteMsg('Form:'+ModuleInfo.GetFormName);
            // 打开一个form模块
            Module := nil;
            try
              Module := ModuleInfo.OpenModule;
            except
              Module := nil;
            end;
            if Module<>nil then
              try
                ModuleFileCount := Module.GetModuleFileCount;
                for ModuleFileIndex:=0 to ModuleFileCount-1 do
                begin
                  Editor := nil; // 必须及时释放掉对前一个Editor的引用
                  FormEditor := nil;
                  Editor := Module.GetModuleFileEditor(ModuleFileIndex);
                  if Editor.QueryInterface(IOTAFormEditor,FormEditor)=S_OK then
                  begin
                    FRoot := (FormEditor.GetRootComponent as INTAComponent).GetComponent;
                    if ClassIs(FRoot.ClassType,FModuleClassType) then
                    begin
                      Result := True;
                      with TPRContext(Context) do
                      begin
                        FModuleName := ModuleInfo.GetName;
                        FModuleFile := ModuleInfo.GetFileName;
                        FModuleForm := ModuleInfo.GetFormName;
                      end;
                      //WriteMsg('Root:'+FRoot.ClassName);
                      // 保存接口（以免被释放）
                      FSavedEditor := FormEditor;
                      FSavedModule := Module;
                      Break; // for loop
                    end;
                  end;
                end;
              finally
                Editor := nil;
                FormEditor := nil;
                // 不能关闭正在使用的模块! 否则FRoot无效
                if (Module<>nil) and (Module<>FSavedModule) then
                  Module.Close;
                Module := nil;
              end;
          end;
          if Result then
            Break; // while loop
          Inc(FModuleIndex);
        end;
      end;
    finally
      ModuleInfo := nil;
    end;
  except
    Result := False;
  end;
end;

{ TPRFormEnd }

function TPRFormEnd.AcceptBeginLoop(BeginLoop: TAbsBeginLoop): Boolean;
begin
  Result := BeginLoop is TPRFormBegin;
end;

class function TPRFormEnd.GetFuncName: string;
begin
  Result := 'endpform';
end;

{ TPRUnitBegin }

procedure TPRUnitBegin.ExitLoop;
begin
  inherited;

end;

class function TPRUnitBegin.GetFuncName: string;
begin
  Result := 'unit';
end;

procedure TPRUnitBegin.InitLoop;
begin
  inherited;
  FModuleIndex := 0;
  FRoot := nil;
end;

procedure TPRUnitBegin.InternalDoIt;
begin
  inherited;
  Inc(FModuleIndex);
end;

function TPRUnitBegin.MarchLoopCondition: Boolean;
var
  ModuleInfo : IOTAModuleInfo;
begin
  Result := False;
  try
    if (TPRContext(Context).FProject<>nil) then
      while FModuleIndex<TPRContext(Context).FProject.GetModuleCount do
      begin
        ModuleInfo := TPRContext(Context).FProject.GetModule(FModuleIndex);
        if ModuleInfo.GetModuleType=0 then
        begin
          with TPRContext(Context) do
          begin
            FModuleName := ModuleInfo.GetName;
            FModuleFile := ModuleInfo.GetFileName;
            FModuleForm := ModuleInfo.GetFormName;
          end;
          Result := True;
          Break;
        end;
        Inc(FModuleIndex);
      end;
  finally
    ModuleInfo := nil;
  end;
end;

{ TPRUnitEnd }

function TPRUnitEnd.AcceptBeginLoop(BeginLoop: TAbsBeginLoop): Boolean;
begin
  Result := BeginLoop is TPRUnitBegin;
end;

class function TPRUnitEnd.GetFuncName: string;
begin
  Result := 'endunit';
end;

{$endif}

{ TPRComponentBegin }

constructor TPRComponentBegin.Create;
begin
  inherited ;
  FComponentClassNames := TStringList.Create;
end;

destructor TPRComponentBegin.Destroy;
begin
  inherited;
  FreeAndNil(FComponentClassNames);
end;

class function TPRComponentBegin.GetFuncName: string;
begin
  Result := 'component';
end;

procedure TPRComponentBegin.InitFromScriptFunc(Func: TScriptFunc);
begin
  inherited;
  ComponentClassNames.Assign(Func.Params);
end;

procedure TPRComponentBegin.InitLoop;
begin
  inherited;
  FComponentIndex := 0;
end;

procedure TPRComponentBegin.InternalDoIt;
begin
  inherited;
  Inc(FComponentIndex);
end;

function TPRComponentBegin.MarchLoopCondition: Boolean;
var
  TheOwner : TComponent;
  Obj : TObject;
  I : Integer;
  AClass : TClass;
begin
  Result := False;
  if (TPRContext(Context).LocalFrameCount>1) and (TPRContext(Context).Objects[1] is TComponent) then
  begin
    TheOwner := TComponent(TPRContext(Context).Objects[1]);
    while FComponentIndex<TheOwner.ComponentCount do
    begin
      Obj := TheOwner.Components[FComponentIndex];
      AClass := Obj.ClassType;
      for I:=0 to ComponentClassNames.Count-1 do
      begin
        if ClassIs(AClass,ComponentClassNames[I]) then
        begin
          Result := True;
          FRoot := Obj;
          Exit;
        end;
      end;
      Inc(FComponentIndex);
    end;
  end;
end;

procedure TPRComponentBegin.SetComponentClassNames(const Value: TStrings);
begin
  FComponentClassNames.Assign(Value);
end;

{ TPRComponentEnd }

function TPRComponentEnd.AcceptBeginLoop(BeginLoop: TAbsBeginLoop): Boolean;
begin
  Result := BeginLoop is TPRComponentBegin;
end;

class function TPRComponentEnd.GetFuncName: string;
begin
  Result := 'endcomponent';
end;

{ TPRItemsBegin }

class function TPRItemsBegin.GetFuncName: string;
begin
  Result := 'items';
end;

procedure TPRItemsBegin.InitFromScriptFunc(Func: TScriptFunc);
begin
  inherited;
  PropertyName := Func.Params[0];
end;

procedure TPRItemsBegin.InitLoop;
begin
  inherited;
  FCollection := nil;
  if TPRContext(Context).LocalFrameCount>1 then
  begin
    TPRContext(Context).FTempProperty.CreateByName(TPRContext(Context).Objects[1],PropertyName);
    if TPRContext(Context).FTempProperty.Available
      and (TPRContext(Context).FTempProperty.PropType=ptClass) then
    begin
      FCollection := TCollection(TPRContext(Context).FTempProperty.AsObject);
      if not (FCollection is TCollection) then
        FCollection := nil;
    end;
  end;
  FItemIndex := 0;
end;

procedure TPRItemsBegin.InternalDoIt;
begin
  inherited;
  Inc(FItemIndex);
end;

function TPRItemsBegin.MarchLoopCondition: Boolean;
begin
  Result := False;
  if FCollection<>nil then
  begin
    if FItemIndex<FCollection.Count then
    begin
      FRoot := FCollection.Items[FItemIndex];
      Result := True;
    end;
  end;
end;

{ TPRItemsEnd }

function TPRItemsEnd.AcceptBeginLoop(BeginLoop: TAbsBeginLoop): Boolean;
begin
  Result := BeginLoop is TPRItemsBegin;
end;

class function TPRItemsEnd.GetFuncName: string;
begin
  Result := 'enditems';
end;

{ TPRStringsBegin }

class function TPRStringsBegin.GetFuncName: string;
begin
  Result := 'strings';
end;

procedure TPRStringsBegin.InitFromScriptFunc(Func: TScriptFunc);
begin
  inherited;
  PropertyName := Func.Params[0];
end;

procedure TPRStringsBegin.InitLoop;
begin
  inherited;
  FStrings:= nil;
  if TPRContext(Context).LocalFrameCount>1 then
  begin
    TPRContext(Context).FTempProperty.CreateByName(TPRContext(Context).Objects[1],PropertyName);
    if TPRContext(Context).FTempProperty.Available
      and (TPRContext(Context).FTempProperty.PropType=ptClass) then
    begin
      FStrings := TStrings(TPRContext(Context).FTempProperty.AsObject);
      if not (FStrings is TStrings) then
        FStrings:= nil;
    end
  end;
  FItemIndex := 0;
end;

procedure TPRStringsBegin.InternalDoIt;
begin
  inherited;
  TPRContext(Context).FStringValue := FStrings[FItemIndex];
  Inc(FItemIndex);
end;

function TPRStringsBegin.MarchLoopCondition: Boolean;
begin
  Result := False;
  FRoot := nil;
  if FStrings<>nil then
  begin
    Result := FItemIndex<FStrings.Count;
  end;
end;

{ TPRStringsEnd }

function TPRStringsEnd.AcceptBeginLoop(BeginLoop: TAbsBeginLoop): Boolean;
begin
  Result := BeginLoop is TPRStringsBegin;
end;

class function TPRStringsEnd.GetFuncName: string;
begin
  Result := 'endstrings';
end;

{ TPRProperty }

constructor TPRProperty.Create;
begin
  AProperty := TProperty.Create(nil,nil);
end;

destructor TPRProperty.Destroy;
begin
  FreeAndNil(AProperty);
  inherited;
end;

procedure TPRProperty.DoIt;
var
  Obj : TObject;
  V : Variant;
begin
  CheckTrue((ObjectIndex<TPRContext(Context).LocalFrameCount) and (TPRContext(Context).LocalFrameCount>0),'out of frame');
  AProperty.CreateByName(TPRContext(Context).Objects[ObjectIndex],PropertyName);
  if AProperty.Available then
  begin
    case AProperty.PropType of
      ptOrd,ptString,ptFloat : Context.TextOut(AProperty.AsString);
      ptVariant :
      begin
        V := AProperty.AsVariant;
        if VarIsEmpty(V) then
          Context.TextOut(UnassignedString) else
          Context.TextOut(V);
      end;
      ptClass : begin
                  Obj := AProperty.AsObject;
                  if Obj is TComponent then
                    Context.TextOut(TComponent(Obj).Name);
                end;
    end;                
  end;
end;

class function TPRProperty.GetFuncName: string;
begin
  Result := 'property';
end;

procedure TPRProperty.InitFromScriptFunc(Func: TScriptFunc);
begin
  PropertyName := Func.Params[0];
  ObjectIndex := StrToIntDef(GetParam(Func.Params,1,''),0);
end;

{ TPRObjectBegin }

procedure TPRObjectBegin.ExitLoop;
begin
  inherited;
  //TPRContext(Context).CurrentObject := FSavedObject;
  TPRContext(Context).FreeLocalFrame;
end;

procedure TPRObjectBegin.InitLoop;
begin
  inherited;
  //FSavedObject := TPRContext(Context).CurrentObject;
  TPRContext(Context).SetupLocalFrame;
end;

procedure TPRObjectBegin.InternalDoIt;
begin
  inherited;
  TPRContext(Context).CurrentObject := FRoot;
end;

{ TPRFormBegin2 }

class function TPRFormBegin2.GetFuncName: string;
begin
  Result := 'form';
end;

procedure TPRFormBegin2.InitFromScriptFunc(Func: TScriptFunc);
begin
  inherited;
  ModuleClassType := GetParam(Func.Params,0,'TComponent');
end;

procedure TPRFormBegin2.InitLoop;
begin
  inherited;
  FComponentIndex := 0;
end;

procedure TPRFormBegin2.InternalDoIt;
begin
  inherited;
  Inc(FComponentIndex);
end;

function TPRFormBegin2.MarchLoopCondition: Boolean;
var
  Obj : TObject;
begin
  Result := False;
  if Application<>nil then
  begin
    while FComponentIndex<Application.ComponentCount do
    begin
      Obj := Application.Components[FComponentIndex];
      if ClassIs(Obj.ClassType,ModuleClassType) then
      begin
        Result := True;
        FRoot := Obj;
        Break;
      end;
      Inc(FComponentIndex);
    end;
  end;
end;

{ TPRFormEnd2 }

function TPRFormEnd2.AcceptBeginLoop(BeginLoop: TAbsBeginLoop): Boolean;
begin
  Result := BeginLoop is TPRFormBegin2;
end;

class function TPRFormEnd2.GetFuncName: string;
begin
  Result := 'endform';
end;

{ TPRContext }

procedure TPRContext.Clear;
begin
  inherited;
  FPostfix := '';
  FPostfixDescription := '';
  FFilePath := '';
  FDefaultOutputFile := '';
end;

procedure TPRContext.AfterOutput;
begin
  inherited;
  {$ifdef ToolsAPI}
  FProjectGroup := nil;
  FProject := nil;
  FModuleName := '';
  FModuleForm := '';
  FModuleFile := '';
  {$endif}
  FStringValue := '';
  FreeAndNil(FStack);
  FreeAndNil(FTempProperty);
  FreeAndNil(FFileIDs);
  FreeAndNil(FFileNames);
end;

procedure TPRContext.BeforeOutput;
begin
  inherited;
  {$ifdef ToolsAPI}
  FProjectGroup := GetProjectGroup;
  FProject := nil;
  FModuleName := '';
  FModuleForm := '';
  FModuleFile := '';
  {$endif}
  FStack := TList.Create;
  FTempProperty := TProperty.Create(nil,nil);
  FStringValue := '';
  FFileIDs := TStringList.Create;
  FFileNames := TStringList.Create;

  if FOutputFile<>'' then
  begin
    FFilePath := ExtractFilePath(FOutputFile);
    if NewFileSubdir<>'' then
      ForceDirectories(FFilePath+NewFileSubdir);
  end;
end;

procedure TPRContext.ParseFunc(Func: TScriptFunc);
begin
  if SameText(Func.FunctionName,'#postfix') then
  begin
    Postfix := Func.Params[0];
    PostfixDescription := GetParam(Func.Params,1,Postfix);
    DefaultPostfix := GetParam(Func.Params,2,'');
  end
  else if SameText(Func.FunctionName,'#defaultfile') then
  begin
    DefaultOutputFile := Func.Params[0];
  end
  else if SameText(Func.FunctionName,'#include') then
  begin
    IncludeScriptFile(Func.Params[0]);
  end
  else inherited;
end;

function TPRContext.GetFileName(const ID: string; Relative : Boolean): string;
var
  AID : string;
  Index : Integer;
begin
  AID := UpperCase(ID);
  Result := '';
  if AID<>'' then
  begin
    Index := FFileIDs.IndexOf(AID);
    if Index>=0 then
    begin
      Result := FFileNames[Index];
    end;
  end;
  if Result='' then
  begin
    Result:= NewFileName(AID);
    FFileIDs.Add(AID);
    FFileNames.Add(Result);
  end;
  if Relative and StartWith(Result,FFilePath) then
  begin
    Delete(Result,1,Length(FFilePath));
  end;
end;

function TPRContext.NewFileName(const ID: string) : string;
var
  ThePostFix : string;
  BaseName : string;
begin
  if Assigned(FOnNewFileName) then
    FOnNewFileName(ID,Result) else
  begin
    if StartWith(ID,'*') then
      BaseName := Copy(ID,2,Length(ID)) else
      BaseName := '_'+IntToStr(FFileIDs.Count);
    ThePostFix := ExtractFileExt(Postfix);
    Result := Format('%s%s%s%s',[FFilePath,NewFileSubdir,BaseName,ThePostFix]);
  end;
end;

function TPRContext.GetFileNameEx(const ID, NameFormat: string; Relative : Boolean): string;
var
  AID : string;
begin
  AID := ID;
  if SameText(AID,'@object') then
    AID := Format('_object(%8.8x)',[Integer(CurrentObject)])
  else if SameText(AID,'@root') then
    AID := OutputFile
  else if SameText(AID,'@name') then
  begin
    if CurrentObject is TComponent then
    begin
      AID := TComponent(CurrentObject).Name;
    end;
  end
  {$ifdef ToolsAPI}
  else if SameText(AID,'@form') then
    AID := FModuleForm
  else if SameText(AID,'@module') then
    AID := FModuleFile
  else if SameText(AID,'@project') then
  begin
    if FProject <> nil then
    begin
      AID := FProject.GetFileName;
    end;
  end
  else if SameText(AID,'@fullmodule') then
  begin
    if FProject <> nil then
    begin
      AID := FProject.GetFileName + ':'+ FModuleFile;
    end;
  end
  {$endif}
  else if SameText(AID,'@fullname') then
  begin
    AID := GetObjectFullPath;
  end
  ;
  if NameFormat<>'' then
    AID := Format(NameFormat,[AID]);
  Result := GetFileName(AID,Relative);
end;

procedure TPRContext.NewFile(const ID, NameFormat: string);
var
  FileName : string;
begin
  if FFilePath<>'' then
  begin
    FileName := GetFileNameEx(ID,NameFormat,False);
    FreeAndNil(FWriter);
    FWriter := TTextWriter.Create(FileName);
  end;
end;

function TPRContext.GetCurrentObject: TObject;
begin
  Assert(FStack<>nil);
  if FStack.Count>0 then
    Result := TObject(FStack[FStack.Count-1]) else
    Result := nil;
end;

procedure TPRContext.FreeLocalFrame;
begin
  Assert(FStack<>nil);
  FStack.Delete(FStack.Count-1);
end;

procedure TPRContext.SetupLocalFrame;
begin
  Assert(FStack<>nil);
  FStack.Add(nil);
end;

procedure TPRContext.SetCurrentObject(const Value: TObject);
begin
  Assert(FStack<>nil);
  FStack[FStack.Count-1] := Value;
end;

function TPRContext.GetObjects(Index: Integer): TObject;
begin
  Assert(FStack<>nil);
  Result := TObject(FStack[FStack.Count-1-Index]);
end;

function TPRContext.GetLocalFrameCount: Integer;
begin
  Assert(FStack<>nil);
  Result := FStack.Count;
end;

procedure TPRContext.IncludeScriptFile(const FileName: string);
var
  IncludeContext : TPRContext;
  TheFileName : string;
  I : Integer;
  Node : TObject;
begin
  IncludeContext := TPRContext.Create;
  try
    TheFileName := FileName;
    if ExtractFilePath(TheFileName)='' then
      TheFileName := ExtractFilePath(ScriptFile)+TheFileName;
    IncludeContext.LoadScripts(TheFileName);
    for I:=0 to IncludeContext.Nodes.Count-1 do
    begin
      Node := TObject(IncludeContext.Nodes.Extract(IncludeContext.Nodes[0]));
      Nodes.Add(Node);
    end;
    Assert(IncludeContext.Nodes.Count=0);
  finally
    IncludeContext.Free;
  end;
end;

function TPRContext.GetObjectFullPath: string;
var
  I : Integer;
  Obj : TObject;
  Part : string;
begin
  Result := '';
  {$ifdef ToolsAPI}
  if FProject <> nil then
    Result := FProject.GetFileName + ':'+ FModuleName;
  {$endif}
  for I:=0 to FStack.Count-1 do
  begin
    Obj := TObject(FStack[I]);
    if Obj=nil then
      Part := 'nil'
    else if obj is TComponent then
      Part := TComponent(obj).Name
    else
      Part := obj.ClassName;
    Result := Result + '.' + Part;  
  end;
end;

class procedure TPRContext.RegisterNodeClass(
  NodeClasse : TAbsScriptNodeClass);
begin
  CheckNodeClasses;
  PrjRepNodeClasses.Add(NodeClasse);
end;

class procedure TPRContext.UnRegisterNodeClass(
  NodeClasse: TAbsScriptNodeClass);
begin
  if PrjRepNodeClasses<>nil then
    PrjRepNodeClasses.Remove(NodeClasse);
end;

function TPRContext.GetNodeClasses: TList;
begin
  Result := PrjRepNodeClasses;
end;

{ TPRStringValue }

procedure TPRStringValue.DoIt;
begin
  Context.TextOut(TPRContext(Context).FStringValue);
end;

class function TPRStringValue.GetFuncName: string;
begin
  Result := 'stringvalue';
end;

{ TPRPersistentBegin }

class function TPRPersistentBegin.GetFuncName: string;
begin
  Result := 'persistent';
end;

procedure TPRPersistentBegin.InitFromScriptFunc(Func: TScriptFunc);
begin
  inherited;
  PropertyName := Func.Params[0];
end;

procedure TPRPersistentBegin.InitLoop;
begin
  inherited;
  if TPRContext(Context).LocalFrameCount>1 then
  begin
    TPRContext(Context).FTempProperty.CreateByName(TPRContext(Context).objects[1],PropertyName);
    if TPRContext(Context).FTempProperty.Available
      and (TPRContext(Context).FTempProperty.PropType=ptClass) then
      FRoot := TPRContext(Context).FTempProperty.AsObject else
      FRoot := nil;
  end;

  FDone := FRoot = nil;
end;

procedure TPRPersistentBegin.InternalDoIt;
begin
  inherited;
  FDone := True;
end;

function TPRPersistentBegin.MarchLoopCondition: Boolean;
begin
  Result := not FDone;
end;

{ TPRPersistentEnd }

function TPRPersistentEnd.AcceptBeginLoop(
  BeginLoop: TAbsBeginLoop): Boolean;
begin
  Result := BeginLoop is TPRPersistentBegin;
end;

class function TPRPersistentEnd.GetFuncName: string;
begin
  Result := 'endpersistent';
end;

{ TPRNewFileName }

procedure TPRNewFileName.DoIt;
var
  FileName : string;
begin
  FileName := TPRContext(Context).GetFileNameEx(FileID,NameFormat,True);
  Context.TextOut(FileName);
end;

class function TPRNewFileName.GetFuncName: string;
begin
  Result := 'newfilename';
end;

procedure TPRNewFileName.InitFromScriptFunc(Func: TScriptFunc);
begin
  inherited;
  FileID:= Func.Params[0];
  NameFormat:= GetParam(Func.Params,1,'');
end;

{ TPRNewFile }

procedure TPRNewFile.DoIt;
begin
  TPRContext(Context).NewFile(FileID,NameFormat);
end;

class function TPRNewFile.GetFuncName: string;
begin
  Result := 'newfile';
end;

procedure TPRNewFile.InitFromScriptFunc(Func: TScriptFunc);
begin
  inherited;
  FileID:= Func.Params[0];
  NameFormat:= GetParam(Func.Params,1,'');
end;

{ TPRName }

procedure TPRName.DoIt;
var
  AText : string;
begin
  AText := '';
  if SameText(ObjectName,'object') then
  begin
    if TPRContext(Context).CurrentObject is TComponent then
      AText := TComponent(TPRContext(Context).CurrentObject).Name;
  end
  else if SameText(ObjectName,'class') then
  begin
    if TPRContext(Context).CurrentObject<>nil then
      AText := TPRContext(Context).CurrentObject.ClassName;
  end
  else if SameText(ObjectName,'inherited') then
  begin
    if (TPRContext(Context).CurrentObject<>nil) and (TPRContext(Context).CurrentObject.ClassParent<>nil) then
    begin
      AText := TPRContext(Context).CurrentObject.ClassParent.ClassName;
    end;
  end
  {$ifdef ToolsAPI}
  else if SameText(ObjectName,'project') then
  begin
    if TPRContext(Context).FProject<>nil then
      AText := ExtractFileName(TPRContext(Context).FProject.GetFileName);
  end
  else if SameText(ObjectName,'module') then
    AText := TPRContext(Context).FModuleName
  else if SameText(ObjectName,'form') then
    AText := TPRContext(Context).FModuleForm
  else if SameText(ObjectName,'projectgroup') and (TPRContext(Context).FProjectGroup<>nil) then
    AText := ExtractFileName(TPRContext(Context).FProjectGroup.GetFileName)
  {$endif}
  ;
  TPRContext(Context).TextOut(AText);
end;

class function TPRName.GetFuncName: string;
begin
  Result := 'name';
end;

procedure TPRName.InitFromScriptFunc(Func: TScriptFunc);
begin
  inherited;
  ObjectName := Func.Params[0];
end;

{ TPRFileName }

procedure TPRFileName.DoIt;
var
  AText : string;
begin
  AText := '';
  if SameText(ObjectName,'@root') then
    AText := ExtractFileName(TPRContext(Context).OutputFile)
  {$ifdef ToolsAPI}
  else if SameText(ObjectName,'project') then
  begin
    if TPRContext(Context).FProject<>nil then
      AText := TPRContext(Context).FProject.GetFileName;
  end
  else if SameText(ObjectName,'module') or SameText(ObjectName,'form') then
    AText := TPRContext(Context).FModuleFile
  else if SameText(ObjectName,'projectgroup') and (TPRContext(Context).FProjectGroup<>nil) then
    AText := TPRContext(Context).FProjectGroup.GetFileName
  {$endif}
  ;
  TPRContext(Context).TextOut(AText);
end;


class function TPRFileName.GetFuncName: string;
begin
  Result := 'filename';
end;

procedure TPRFileName.InitFromScriptFunc(Func: TScriptFunc);
begin
  inherited;
  ObjectName := Func.Params[0];
end;

{ TPROneObjectBegin }

procedure TPROneObjectBegin.InitLoop;
begin
  inherited;
  FRoot := InitRootObject;
  FFirst := True;
end;

procedure TPROneObjectBegin.InternalDoIt;
begin
  inherited;
  FFirst := False;
end;

function TPROneObjectBegin.MarchLoopCondition: Boolean;
begin
  Result := (FRoot<>nil) and FFirst;
end;


{$ifdef ToolsAPI}

{ TPRCurFormModuleBegin }

class function TPRCurFormModuleBegin.GetFuncName: string;
begin
  Result := 'curmodule';
end;

function TPRCurFormModuleBegin.InitRootObject: TObject;
var
  Comp : TComponent;
  FormEditor : IOTAFormEditor;
begin
  GetCurrentFormEditor(FormEditor,Comp);
  Result := Comp;
  if FormEditor<>nil then
  begin
    TPRContext(Context).FModuleFile := FormEditor.FileName;
    TPRContext(Context).FModuleName := Comp.ClassName;
    TPRContext(Context).FModuleForm := Comp.Name;
  end;

end;

{ TPRCurFormModuleEnd }

function TPRCurFormModuleEnd.AcceptBeginLoop(
  BeginLoop: TAbsBeginLoop): Boolean;
begin
  Result := BeginLoop is TPRCurFormModuleBegin;
end;

class function TPRCurFormModuleEnd.GetFuncName: string;
begin
  Result := 'endcurmodule';
end;

{$endif}

initialization
  TPRContext.RegisterNodeClass(TPRFormBegin2);
  TPRContext.RegisterNodeClass(TPRFormEnd2);
  TPRContext.RegisterNodeClass(TPRComponentBegin);
  TPRContext.RegisterNodeClass(TPRComponentEnd);
  TPRContext.RegisterNodeClass(TPRItemsBegin);
  TPRContext.RegisterNodeClass(TPRItemsEnd);
  TPRContext.RegisterNodeClass(TPRStringsBegin);
  TPRContext.RegisterNodeClass(TPRStringsEnd);
  TPRContext.RegisterNodeClass(TPRProperty);
  TPRContext.RegisterNodeClass(TPRStringValue);
  TPRContext.RegisterNodeClass(TPRPersistentBegin);
  TPRContext.RegisterNodeClass(TPRPersistentEnd);
  TPRContext.RegisterNodeClass(TPRNewFileName);
  TPRContext.RegisterNodeClass(TPRNewFile);
  TPRContext.RegisterNodeClass(TPRName);
  TPRContext.RegisterNodeClass(TPRFileName);

{$ifdef ToolsAPI}
  TPRContext.RegisterNodeClass(TPRProjectBegin);
  TPRContext.RegisterNodeClass(TPRProjectEnd);
  TPRContext.RegisterNodeClass(TPRFormBegin);
  TPRContext.RegisterNodeClass(TPRFormEnd);
  TPRContext.RegisterNodeClass(TPRUnitBegin);
  TPRContext.RegisterNodeClass(TPRUnitEnd);
  TPRContext.RegisterNodeClass(TPRCurFormModuleBegin);
  TPRContext.RegisterNodeClass(TPRCurFormModuleEnd);
{$endif}

finalization
  FreeAndNil(PrjRepNodeClasses);

end.
