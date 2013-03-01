unit AbsParsers;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>AbsParsers
   <What>抽象的文本生成脚本解释器
   脚本类似ASP，是文字中“<%”“%>”之间的部分。脚本是函数形式:“函数名(参数1,参数2,...)；”
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

interface

uses SysUtils,Classes, TextUtils, Contnrs, TextTags, FuncScripts;

type
  TAbsScriptNode = class;

  {
    <Class>TAbsContext
    <What>脚本运行的上下文对象。
    负责：
      1、装载脚本，分析
      2、运行脚本，输出转换的文本
    <Properties>
      Nodes - TAbsScriptNode对象列表(分析出的函数节点)
    <Methods>
      LoadScripts - 装载脚本，分析
      Output - 运行脚本，输出转换的文本
      TextOut - 被TAbsScriptNode调用，输出一段文本
      Clear - 清空


    <Event>
      -
  }
  TAbsContext = class
  private
    FProgressSteps: Integer;
    FProgress: Integer;
    FOnProgress: TNotifyEvent;
  protected
    FWriter : TTextWriter;
    FNodes: TObjectList;
    FCurrentNode: TAbsScriptNode;
    FCurrentNodeIndex: Integer;
    FNextNodeIndex: Integer;
    FScriptFile : string;
    FOutputFile : string;
    procedure   Parse(TANodes : TList); virtual;
    procedure   ParseFunc(Func : TScriptFunc); virtual;
    procedure   MakeRelations; virtual;
    procedure   DoOutput; virtual;
    procedure   Prepare; dynamic;
    property    NextNodeIndex : Integer read FNextNodeIndex write FNextNodeIndex;
    property    CurrentNode : TAbsScriptNode read FCurrentNode;
    property    CurrentNodeIndex : Integer read FCurrentNodeIndex;
    procedure   BeforeOutput; virtual;
    procedure   AfterOutput; virtual;
    procedure   DoProgress; virtual;
    function    GetNodeClasses : TList; virtual; abstract;
  public
    constructor Create;
    destructor  Destroy;override;
    procedure   Clear; virtual;
    procedure   TextOut(const AText:string); virtual;
    procedure   LoadScripts(Stream : TStream); overload; virtual;
    procedure   LoadScripts(const FileName:string); overload; virtual;
    procedure   Output(Stream : TStream); overload; virtual;
    procedure   Output(const FileName:string); overload; virtual;
    property    Nodes : TObjectList read FNodes;
    property    ScriptFile : string read FScriptFile;
    property    OutputFile : string read FOutputFile;
    property    ProgressSteps : Integer read FProgressSteps write FProgressSteps default 50;
    property    Progress : Integer read FProgress;
    property    OnProgress : TNotifyEvent read FOnProgress write FOnProgress;
  end;

  TAbsScriptNode = class
  private
    FContext: TAbsContext;
  public
    constructor Create; virtual;
    procedure   Prepare(AContext : TAbsContext); virtual;
    procedure   DoIt; virtual; abstract;
    class function GetFuncName : string; virtual;
    procedure   InitFromScriptFunc(Func : TScriptFunc); virtual;
    property    Context : TAbsContext read FContext;
  end;

  TAbsScriptNodeClass = class of TAbsScriptNode;

  TPlainTextNode = class(TAbsScriptNode)
  private
    FText: string;
  public
    procedure   DoIt; override;
    property    Text : string read FText write FText;
  end;

  TAbsBeginLoop = class(TAbsScriptNode)
  private
    FExitNodeIndex: Integer;
    FLastEnterCount : Integer;
    FEnterCount : Integer;
  protected
    procedure   InitLoop; virtual;
    procedure   ExitLoop; virtual;
    function    MarchLoopCondition : Boolean; virtual; abstract;
    procedure   InternalDoIt; virtual;
  public
    procedure   Prepare(Context : TAbsContext); override;
    procedure   DoIt; override;
    property    ExitNodeIndex : Integer read FExitNodeIndex write FExitNodeIndex;
  end;

  TAbsEndLoop = class(TAbsScriptNode)
  private
    FBeginLoopIndex: Integer;
  protected
    function    AcceptBeginLoop(BeginLoop : TAbsBeginLoop) : Boolean; virtual;
  public
    procedure   DoIt; override;
    property    BeginLoopIndex : Integer read FBeginLoopIndex write FBeginLoopIndex;
  end;

resourcestring
  ScriptError = 'Script Error.';

implementation

uses SafeCode, KSStrUtils;


{ TAbsContext }

constructor TAbsContext.Create;
begin
  inherited;
  FNodes := TObjectList.Create;
  FProgressSteps := 50;
end;

destructor TAbsContext.Destroy;
begin
  FNodes.Free;
  inherited;
end;

procedure TAbsContext.LoadScripts(Stream: TStream);
var
  Parser : TTextTagParser;
begin
  FScriptFile := '';
  Parser := TTextTagParser.Create;
  try
    Parser.Parse(Stream);
    Parse(Parser.Nodes);
  finally
    Parser.Free;
  end;
end;

procedure TAbsContext.DoOutput;
begin
  BeforeOutput;
  try
    Prepare;
    FCurrentNodeIndex := 0;
    while FCurrentNodeIndex<Nodes.Count do
    begin
      FNextNodeIndex := FCurrentNodeIndex+1;
      FCurrentNode := TAbsScriptNode(Nodes[FCurrentNodeIndex]);
      FCurrentNode.DoIt;
      FCurrentNodeIndex := FNextNodeIndex;
    end;
  finally
    AfterOutput;
  end;
end;

procedure TAbsContext.LoadScripts(const FileName: string);
var
  Parser : TTextTagParser;
begin
  FScriptFile := FileName;
  Parser := TTextTagParser.Create;
  try
    Parser.ParseFile(FileName);
    Parse(Parser.Nodes);
  finally
    Parser.Free;
  end;
end;

procedure TAbsContext.Output(Stream: TStream);
begin
  FOutputFile := '';
  try
    FWriter := TTextWriter.Create(Stream);
    DoOutput;
  finally
    FreeAndNil(FWriter);
  end;
end;

procedure TAbsContext.Output(const FileName: string);
begin
  FOutputFile := FileName;
  try
    FWriter := TTextWriter.Create(FileName);
    DoOutput;
  finally
    FreeAndNil(FWriter);
  end;
end;

procedure TAbsContext.TextOut(const AText: string);
begin
  Assert(FWriter<>nil);
  FWriter.Print(AText);
  Inc(FProgress);
  if (FProgress mod FProgressSteps)=0 then
    DoProgress;
end;

procedure TAbsContext.Clear;
begin
  FNodes.Clear;
  FScriptFile := '';
  FOutputFile := '';
end;

procedure TAbsContext.Prepare;
var
  i : integer;
begin
  for i:=0 to Nodes.Count-1 do
    TAbsScriptNode(Nodes[i]).Prepare(Self);
end;

procedure TAbsContext.Parse(TANodes: TList);
var
  i,j : integer;
  Funcs : TObjectList;
  TANode : TTATextNode;
  Node : TAbsScriptNode;
  Func : TScriptFunc;
begin
  Clear;
  // get all nodes
  Funcs := TObjectList.Create;
  try
    for i:=0 to TANodes.Count-1 do
    begin
      TANode := TTATextNode(TANodes[i]);
      if TANode.NodeType=stText then
      begin
        // just a plaintext node
        Node := TPlainTextNode.Create;
        Nodes.Add(Node);
        TPlainTextNode(Node).Text := TANode.Text;
      end else
      begin
        // there is a script tag need to parse
        Funcs.Clear;
        ParseFunctions(TANode.Text,Funcs);
        for j:=0 to Funcs.Count-1 do
        begin
          Func := TScriptFunc(Funcs[j]);
          ParseFunc(Func);
        end;
      end;
    end;
  finally
    Funcs.Free;
  end;
  MakeRelations;
end;

procedure TAbsContext.MakeRelations;
var
  NodeIndex : integer;
  Stack : TStack;
  Node : TAbsScriptNode;
  BeginLoopNode : TAbsBeginLoop;
  BeginLoopIndex : Integer;
begin
  Stack := TStack.Create;
  try
    for NodeIndex:=0 to Nodes.Count-1 do
    begin
      Node := TAbsScriptNode(Nodes[NodeIndex]);
      if Node is TAbsBeginLoop then
        Stack.Push(Pointer(NodeIndex))
      else if Node is TAbsEndLoop then
      begin
        BeginLoopIndex := Integer(Stack.Pop);
        BeginLoopNode := TAbsBeginLoop(Nodes[BeginLoopIndex]);
        CheckTrue(TAbsEndLoop(Node).AcceptBeginLoop(BeginLoopNode),ScriptError);
        BeginLoopNode.ExitNodeIndex := NodeIndex + 1;
        TAbsEndLoop(Node).BeginLoopIndex := BeginLoopIndex;
      end;
    end;
    CheckTrue(Stack.Count=0,ScriptError);
  finally
    Stack.Free;
  end;
end;

procedure TAbsContext.AfterOutput;
begin

end;

procedure TAbsContext.BeforeOutput;
begin
  FProgress := 0;
end;

procedure TAbsContext.DoProgress;
begin
  if Assigned(OnProgress) then
    OnProgress(Self);
end;

procedure TAbsContext.ParseFunc(Func: TScriptFunc);
var
  List : TList;
  NodeClass : TAbsScriptNodeClass;
  Node : TAbsScriptNode;
  I : Integer;
begin
  List := GetNodeClasses;
  for I:=0 to List.Count-1 do
  begin
    NodeClass := TAbsScriptNodeClass(List[I]);
    if SameText(NodeClass.GetFuncName,Func.FunctionName) then
    begin
      { TODO : 当function数据格式不对，如何处理意外？ }
      Node := NodeClass.Create;
      Node.InitFromScriptFunc(Func);
      Nodes.Add(Node);
    end;
  end;
end;

{ TAbsScriptNode }

constructor TAbsScriptNode.Create;
begin
  inherited;
end;

class function TAbsScriptNode.GetFuncName: string;
begin

end;

procedure TAbsScriptNode.InitFromScriptFunc(Func: TScriptFunc);
begin

end;

procedure TAbsScriptNode.Prepare(AContext: TAbsContext);
begin
  FContext := AContext;
end;

{ TPlainTextNode }

procedure TPlainTextNode.DoIt;
begin
  Context.TextOut(Text);
end;

{ TAbsBeginLoop }

procedure TAbsBeginLoop.DoIt;
begin
  if FLastEnterCount<>FEnterCount then
  begin
    // first enter this loop
    InitLoop;
  end;
  if MarchLoopCondition then
    InternalDoIt else
    begin
      Context.NextNodeIndex := ExitNodeIndex;
      ExitLoop;
    end;
end;

procedure TAbsBeginLoop.InitLoop;
begin
  FLastEnterCount := FEnterCount;
end;

procedure TAbsBeginLoop.Prepare(Context: TAbsContext);
begin
  inherited;
  FLastEnterCount := -1;
  FEnterCount := 0;
end;

procedure TAbsBeginLoop.InternalDoIt;
begin

end;

procedure TAbsBeginLoop.ExitLoop;
begin
  Inc(FEnterCount); // 增加计数，以便下次识别，重新初始化循环
end;

{ TAbsEndLoop }

function TAbsEndLoop.AcceptBeginLoop(BeginLoop: TAbsBeginLoop): Boolean;
begin
  Result := True;
end;

procedure TAbsEndLoop.DoIt;
begin
  Context.NextNodeIndex := BeginLoopIndex;
end;

end.
