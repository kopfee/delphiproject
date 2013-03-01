unit ToolAPIUtils;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>ToolAPIUtils
   <What>为使用ToolsAPI的提供辅助的对象和过程
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}


interface

uses Windows, SysUtils, Classes, ToolsAPI, Exptintf;

function  GetProjectGroup: IOTAProjectGroup;

function  GetProjectGroupFileName : string;

type
  TEnumModuleProc = procedure (AProject : IOTAProject; AModuleInfo : IOTAModuleInfo) of object;

procedure EnumAllModule(EnumProc : TEnumModuleProc);

procedure WriteMsg(const Msg : string);

procedure GetCurrentFormEditor(var FormEditor : IOTAFormEditor; var Root : TComponent);

function  GetModuleComponent(ModuleInfo : IOTAModuleInfo) : TComponent; overload;

function  GetModuleComponent(Module : IOTAModule) : TComponent; overload;

function  OpenFileInIDE(const FileName : string) : Boolean;

type
  TKSStandardExpert = class(TIExpert)
  private
    FProduct: string;
    FAuthor: string;
  public
    constructor Create(const AAuthor, AProduct : string);
    function    GetName: string; override;
    function    GetAuthor: string; override;
    function    GetComment: string; override;
    function    GetPage: string; override;
    function    GetGlyph: HICON; override;
    function    GetStyle: TExpertStyle; override;
    function    GetState: TExpertState; override;
    function    GetIDString: string; override;
    function    GetMenuText: string; override;
    property    Author : string read FAuthor;
    property    Product : string read FProduct;
  end;

  TKSModuleExpert = class(TKSStandardExpert)
  private
    FRootClass: TComponentClass;
  protected
    // 返回组件是否被修改。控制IDE的Modified
    function    InternalExec(ModuleRootComponent : TComponent) : Boolean; virtual; abstract;
  public
    // ARootClass=nil表示TComponent
    constructor Create(const AAuthor, AProduct : string; ARootClass : TComponentClass=nil);
    function    GetState: TExpertState; override;
    procedure   Execute; override;
    property    RootClass : TComponentClass read FRootClass;
  end;

  TKSStandardExpert2 = class(TNotifierObject, IOTANotifier, IOTAWizard, IOTAMenuWizard)
  private
    FProduct: string;
    FAuthor: string;
  public
    constructor Create(const AAuthor, AProduct : string);
    function    GetName: string;
    function    GetAuthor: string; // not used
    function    GetComment: string; // not used
    function    GetState: TWizardState; virtual;
    function    GetIDString: string;
    function    GetMenuText: string;
    procedure   Execute; virtual;
    procedure   Destroyed; virtual;
    property    Author : string read FAuthor;
    property    Product : string read FProduct;
  end;

procedure Register;

implementation

var
  MessageService : IOTAMessageServices=nil;

function GetProjectGroup: IOTAProjectGroup;
var
  IModuleServices: IOTAModuleServices;
  i: Integer;
begin
  //Result := nil;
  if BorlandIDEServices<>nil then
  begin
    IModuleServices := BorlandIDEServices as IOTAModuleServices;
    for i := 0 to IModuleServices.ModuleCount - 1 do
      if IModuleServices.Modules[i].QueryInterface(IOTAProjectGroup, Result) = S_OK then
        Exit;
  end;
  Result := nil;
end;

function  GetProjectGroupFileName : string;
var
  ProjectGroup : IOTAProjectGroup;
  //Editor : IOTAEditor;
begin
  ProjectGroup := GetProjectGroup;
  if ProjectGroup<>nil then
  begin
    //Editor := (ProjectGroup as IOTAModule);
    Result := (ProjectGroup as IOTAModule).GetFileName;
  end;
end;

procedure EnumAllModule(EnumProc : TEnumModuleProc);
var
  ProjectGroup : IOTAProjectGroup;
  AProject : IOTAProject;
  AModuleInfo : IOTAModuleInfo;
  ProjectIndex,ProjectCount : Integer;
  ModuleIndex, ModuleCount : Integer;
begin
  ProjectGroup := nil;
  AProject := nil;
  AModuleInfo := nil;
  try
    ProjectGroup := GetProjectGroup;
    if ProjectGroup<>nil then
    begin
      ProjectCount := ProjectGroup.GetProjectCount;
      for ProjectIndex:=0 to ProjectCount-1 do
      begin
        AProject := ProjectGroup.GetProject(ProjectIndex);
        ModuleCount := AProject.GetModuleCount;
        for ModuleIndex:=0 to ModuleCount-1 do
        begin
          AModuleInfo := AProject.GetModule(ModuleIndex);
          EnumProc(AProject,AModuleInfo);
        end;
      end;
    end;
  finally
    ProjectGroup := nil;
    AProject := nil;
    AModuleInfo := nil;
  end;
end;

function  GetModuleComponent(ModuleInfo : IOTAModuleInfo) : TComponent;
var
  Module : IOTAModule;
begin
  Module := ModuleInfo.OpenModule;
  Result := GetModuleComponent(Module);
end;

function  GetModuleComponent(Module : IOTAModule) : TComponent;
var
  I : Integer;
  Editor : IOTAEditor;
  RootIntf : IOTAComponent;
  RootIntf2 : INTAComponent;
  FormEditor : IOTAFormEditor;
begin
  Result := nil;
  for I:=0 to Module.GetModuleFileCount-1 do
  begin
    Editor := Module.GetModuleFileEditor(I);
    if Editor.QueryInterface(IOTAFormEditor,FormEditor)=S_OK then
    begin
      RootIntf := FormEditor.GetRootComponent;
      if (RootIntf<>nil) and (RootIntf.QueryInterface(INTAComponent,RootIntf2)=S_OK) then
      begin
        Result := RootIntf2.GetComponent;
      end;
      Break;
    end;
  end;
end;

function  OpenFileInIDE(const FileName : string) : Boolean;
var
  ActionServices : IOTAActionServices;
begin
  ActionServices := BorlandIDEServices as IOTAActionServices;
  Result := ActionServices.OpenFile(FileName);
end;

{ TKSStandardExpert }

constructor TKSStandardExpert.Create(const AAuthor, AProduct: string);
begin
  FAuthor := AAuthor;
  FProduct := AProduct;
end;

function TKSStandardExpert.GetAuthor: string;
begin
  Result := Author;
end;

function TKSStandardExpert.GetComment: string;
begin
  Result := Product;
end;

function TKSStandardExpert.GetGlyph: HICON;
begin
  Result := 0;
end;

function TKSStandardExpert.GetIDString: string;
begin
  // 使用特殊的整数串保证名字唯一
  Result := Format('%s.%8.8x.%s',[Author,Integer(Self),Product]);
end;

function TKSStandardExpert.GetMenuText: string;
begin
  Result := Product;
end;

function TKSStandardExpert.GetName: string;
begin
  // 使用特殊的整数串保证名字唯一
  Result := Format('%s.%8.8x.%s',[Author,Integer(Self),Product]);
end;

function TKSStandardExpert.GetPage: string;
begin
  Result := '';
end;

function TKSStandardExpert.GetState: TExpertState;
begin
  Result := [esEnabled];
end;

function TKSStandardExpert.GetStyle: TExpertStyle;
begin
  Result := esStandard;
end;

procedure WriteMsg(const Msg : string);
begin
  if MessageService<>nil then
    MessageService.AddTitleMessage(Msg);
end;

procedure Register;
begin
  if BorlandIDEServices<>nil then
    MessageService := BorlandIDEServices as IOTAMessageServices else
    MessageService := nil;
end;

procedure GetCurrentFormEditor(var FormEditor : IOTAFormEditor; var Root : TComponent);
var
  ModuleServices: IOTAModuleServices;
  Module : IOTAModule;
  I : Integer;
  Editor : IOTAEditor;
  RootIntf : IOTAComponent;
  RootIntf2 : INTAComponent;
begin
  FormEditor := nil;
  Root := nil;
  if BorlandIDEServices.QueryInterface(IOTAModuleServices, ModuleServices) = S_OK then
  begin
    Module := ModuleServices.CurrentModule;
    if Module<>nil then
      for I:=0 to Module.GetModuleFileCount-1 do
      begin
        Editor := Module.GetModuleFileEditor(I);
        if Editor.QueryInterface(IOTAFormEditor,FormEditor)=S_OK then
        begin
          RootIntf := FormEditor.GetRootComponent;
          if (RootIntf<>nil) and (RootIntf.QueryInterface(INTAComponent,RootIntf2)=S_OK) then
            Root := RootIntf2.GetComponent;
          Break;
        end;
      end;
  end;
  if Root=nil then
    FormEditor:=nil;
end;

{ TKSModuleExpert }

constructor TKSModuleExpert.Create(const AAuthor, AProduct: string;
  ARootClass: TComponentClass);
begin
  inherited Create(AAuthor, AProduct);
  if ARootClass=nil then
    FRootClass := TComponent else
    FRootClass := ARootClass;
end;

procedure TKSModuleExpert.Execute;
var
  FormEditor : IOTAFormEditor;
  Root : TComponent;
begin
  GetCurrentFormEditor(FormEditor,Root);
  if Root is RootClass then
    if InternalExec(Root) then
      FormEditor.MarkModified;
end;

function TKSModuleExpert.GetState: TExpertState;
var
  FormEditor : IOTAFormEditor;
  Root : TComponent;
begin
  GetCurrentFormEditor(FormEditor,Root);
  if Root is RootClass then
    Result := [esEnabled] else
    Result := [];
end;

{ TKSStandardExpert2 }

constructor TKSStandardExpert2.Create(const AAuthor, AProduct: string);
begin
  FAuthor := AAuthor;
  FProduct := AProduct;
end;

procedure TKSStandardExpert2.Destroyed;
begin

end;

procedure TKSStandardExpert2.Execute;
begin

end;

function TKSStandardExpert2.GetAuthor: string;
begin
  Result := Author;
end;

function TKSStandardExpert2.GetComment: string;
begin
  Result := Product;
end;

function TKSStandardExpert2.GetIDString: string;
begin
  // 使用特殊的整数串保证名字唯一
  //Result := Format('%s.%8.8x.%s',[Author,Integer(Self),Product]);
  Result := Format('KSExpert%8.8x',[Integer(Self)]);
end;

function TKSStandardExpert2.GetMenuText: string;
begin
  Result := Product;
end;

function TKSStandardExpert2.GetName: string;
begin
  // 使用特殊的整数串保证名字唯一
  //Result := Format('%s.%8.8x.%s',[Author,Integer(Self),Product]);
  Result := Format('KSExpert%8.8x',[Integer(Self)]);
end;

function TKSStandardExpert2.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

initialization

finalization
  MessageService := nil;

end.
