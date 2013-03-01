unit TextOutScripts;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>TextOutScripts
   <What>产生文本输出的脚本描述语言
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

interface

uses SysUtils,Classes, TextUtils, Contnrs, RPDB, RPDBVCL;

type
  {ITextOut = Interface
    procedure Print(const AText:string);
  end;}

  TScriptContext = class;

  TTOScriptNode = class(TObject)
  public
    procedure Prepare(Context : TScriptContext); virtual;
    procedure DoIt(Context : TScriptContext); virtual; abstract;
  end;

  TTOText = class(TTOScriptNode)
  private
    FText: string;
  public
    property  Text : string read FText write FText;
    procedure DoIt(Context : TScriptContext); override;
  end;

  TTOTextAlign = (taLeft, taCenter, taRight);

  TTOFieldValue = class(TTOScriptNode)
  private
    FWidth: Integer;
    FFieldName: string;
    FAlign: TTOTextAlign;
  public
    procedure DoIt(Context : TScriptContext); override;
    property  Align : TTOTextAlign read FAlign write FAlign;
    property  Width : Integer read FWidth write FWidth;
    property  FieldName : string read FFieldName write FFieldName;
  end;

  TTOForLoop = class(TTOScriptNode)
  private
    FExitNodeIndex: Integer;
    FBrowser : TRPDatasetBrowser;
    FIsFirst : Boolean;
    function    GetControllerName: string;
    function    GetGroupIndex: Integer;
    procedure   SetControllerName(const Value: string);
    procedure   SetGroupIndex(const Value: Integer);
  public
    constructor Create;
    destructor  Destroy;override;
    procedure   Prepare(Context : TScriptContext); override;
    procedure   DoIt(Context : TScriptContext); override;
    property    ControllerName : string read GetControllerName write SetControllerName;
    property    GroupIndex : Integer read GetGroupIndex write SetGroupIndex;
    property    ExitNodeIndex : Integer read FExitNodeIndex write FExitNodeIndex;
  end;

  TTOEndLoop = class(TTOScriptNode)
  private
    FForNodeIndex: Integer;
  public
    procedure   DoIt(Context : TScriptContext); override;
    property    ForNodeIndex : Integer read FForNodeIndex write FForNodeIndex;
  end;

  TScriptContext = class(TComponent)
  private
    //FTextOut: ITextOut;
    FCurrentNode: TTOScriptNode;
    FWriter : TTextWriter;
    FEnvironment: TRPDataEnvironment;
    FNodes: TObjectList;
    FDataEntries: TRPDBDataEntries;
    FCurrentNodeIndex: Integer;
    FNextNodeIndex: Integer;
    FDefaultFileName: string;
    procedure   DoOutput;
    procedure   Prepare;
    procedure   Parse(TANodes : TList);
    procedure   MakeRelations;
    procedure   SetEnvironment(const Value: TRPDataEnvironment);
  protected
    procedure   TextOut(const AText:string);
    procedure   Notification(AComponent: TComponent; Operation: TOperation); override;
    property    NextNodeIndex : Integer read FNextNodeIndex write FNextNodeIndex;
    property    CurrentNode : TTOScriptNode read FCurrentNode;
    property    CurrentNodeIndex : Integer read FCurrentNodeIndex;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy;override;
    procedure   Clear;
    //property   TextOut : ITextOut read FTextOut;
    procedure   LoadScripts(Stream : TStream); overload;
    procedure   LoadScripts(const FileName:string); overload;
    procedure   Output(Stream : TStream); overload;
    procedure   Output(const FileName:string); overload;
    property    Nodes : TObjectList read FNodes;
    property    DataEntries : TRPDBDataEntries read FDataEntries;
    property    DefaultFileName : string read FDefaultFileName write FDefaultFileName;
  published
    property    Environment : TRPDataEnvironment read FEnvironment write SetEnvironment;
  end;

resourcestring
  ScriptError = 'Script Error.';

const
  // function names
  RDataEntry = 'DataEntry';
  RForLoop = 'ForLoop';
  REndLoop = 'EndLoop';
  RFieldValue = 'FieldValue';
  RFileName = 'FileName';
  // params
  PAlignCenter = 'Center';
  PAlignRight = 'Right';
  PAlignLeft = 'Left';

implementation

uses SafeCode, TextTags, FuncScripts, KSStrUtils;

{ TTOScriptNode }

procedure TTOScriptNode.Prepare(Context : TScriptContext);
begin

end;

{ TTOText }

procedure TTOText.DoIt(Context: TScriptContext);
begin
  Context.TextOut(Text);
end;

{ TTOFieldValue }

procedure TTOFieldValue.DoIt(Context: TScriptContext);
var
  Value : string;
  Len : Integer;
begin
  Value := Context.Environment.GetFieldText(FieldName);
  Len := Length(Value);
  if Width>0 then
  begin
    case Align of
      taLeft: Value := Value + StringOfChar(' ',Width);
      taCenter: if Len<Width then
                  Value := StringOfChar(' ',(Width-Len) div 2) + Value + StringOfChar(' ',Width);
      taRight: Value := StringOfChar(' ',Width-Len) + Value;
    end;
    Value := Copy(Value,1,Width);
  end;
  Context.TextOut(Value);
end;

{ TTOForLoop }

constructor TTOForLoop.Create;
begin
  inherited;
  FBrowser := TRPDatasetBrowser.Create;
end;

destructor TTOForLoop.Destroy;
begin
  FBrowser.Free;
  inherited;
end;

procedure TTOForLoop.Prepare(Context : TScriptContext);
begin
  inherited;
  FBrowser.Environment := Context.Environment;
  FBrowser.CheckController;
  if FBrowser.Controller<>nil then
    FBrowser.Controller.Init;
  FIsFirst := True;
end;

procedure TTOForLoop.DoIt(Context: TScriptContext);
begin
  if FIsFirst then
  begin
    if FBrowser.Available then
      FBrowser.Init;
    FIsFirst := False;
  end;
  if FBrowser.Available then
  begin
    FBrowser.GotoNextData;
    if FBrowser.Eof then
    begin
      Context.NextNodeIndex := ExitNodeIndex;
      FIsFirst := True;
    end;
  end
  else
    Context.NextNodeIndex := ExitNodeIndex;
end;

function TTOForLoop.GetControllerName: string;
begin
  Result := FBrowser.ControllerName;
end;

function TTOForLoop.GetGroupIndex: Integer;
begin
  Result := FBrowser.GroupingIndex;
end;

procedure TTOForLoop.SetControllerName(const Value: string);
begin
  FBrowser.ControllerName := Value;

end;

procedure TTOForLoop.SetGroupIndex(const Value: Integer);
begin
  FBrowser.GroupingIndex:= Value;
end;

{ TTOEndLoop }

procedure TTOEndLoop.DoIt(Context: TScriptContext);
begin
  Context.NextNodeIndex := ForNodeIndex;
end;

{ TScriptContext }

constructor TScriptContext.Create(AOwner : TComponent);
begin
  inherited;
  FNodes := TObjectList.Create;
  FDataEntries:= TRPDBDataEntries.Create(Self);
end;

destructor TScriptContext.Destroy;
begin
  FDataEntries.Free;
  FNodes.Free;
  inherited;
end;

procedure TScriptContext.Output(Stream: TStream);
begin
  try
    FWriter := TTextWriter.Create(Stream);
    DoOutput;
  finally
    FreeAndNil(FWriter);
  end;
end;

procedure TScriptContext.Output(const FileName: string);
begin
  try
    FWriter := TTextWriter.Create(FileName);
    DoOutput;
  finally
    FreeAndNil(FWriter);
  end;
end;

procedure TScriptContext.TextOut(const AText: string);
begin
  Assert(FWriter<>nil);
  FWriter.Print(AText);
end;

procedure TScriptContext.DoOutput;
begin
  Prepare;
  FCurrentNodeIndex := 0;
  while FCurrentNodeIndex<Nodes.Count do
  begin
    FNextNodeIndex := FCurrentNodeIndex+1;
    FCurrentNode := TTOScriptNode(Nodes[FCurrentNodeIndex]);
    FCurrentNode.DoIt(Self);
    FCurrentNodeIndex := FNextNodeIndex;
  end;
end;

procedure TScriptContext.LoadScripts(Stream: TStream);
var
  Parser : TTextTagParser;
begin
  Parser := TTextTagParser.Create;
  try
    Parser.Parse(Stream);
    Parse(Parser.Nodes);
  finally
    Parser.Free;
  end;
end;

procedure TScriptContext.LoadScripts(const FileName: string);
var
  Parser : TTextTagParser;
begin
  Parser := TTextTagParser.Create;
  try
    Parser.ParseFile(FileName);
    Parse(Parser.Nodes);
  finally
    Parser.Free;
  end;
end;

procedure TScriptContext.Parse(TANodes: TList);
var
  i,j : integer;
  Funcs : TObjectList;
  TANode : TTATextNode;
  Node : TTOScriptNode;
  Func : TScriptFunc;
  AlignStr : string;
  DataEntry : TRPDataEntry;
  Groups : string;
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
        Node := TTOText.Create;
        Nodes.Add(Node);
        TTOText(Node).Text := TANode.Text;
      end else
      begin
        // there is a script tag need to parse
        Funcs.Clear;
        ParseFunctions(TANode.Text,Funcs);
        for j:=0 to Funcs.Count-1 do
        begin
          Func := TScriptFunc(Funcs[j]);
          if SameText(Func.FunctionName,RDataEntry) then
          begin
            // create data entry
            DataEntry := TRPDataEntry(DataEntries.Add);
            DataEntry.DatasetName:=GetParam(Func.Params,0,'');
            DataEntry.ControllerName:=GetParam(Func.Params,1,'');
            Groups := GetParam(Func.Params,2,'');
            SeperateStr(Groups,['|'],DataEntry.Groups,True);
          end
          else if SameText(Func.FunctionName,RForLoop) then
          begin
            Node := TTOForLoop.Create;
            Nodes.Add(Node);
            with TTOForLoop(Node) do
            begin
              ControllerName := GetParam(Func.Params,0,'');
              GroupIndex := StrToIntDef(GetParam(Func.Params,1,''),-1);
            end;
          end
          else if SameText(Func.FunctionName,REndLoop) then
          begin
            Node := TTOEndLoop.Create;
            Nodes.Add(Node);
          end
          else if SameText(Func.FunctionName,RFieldValue) then
          begin
            Node := TTOFieldValue.Create;
            Nodes.Add(Node);
            with TTOFieldValue(Node) do
            begin
              FieldName := GetParam(Func.Params,0,'');
              Width := StrToIntDef(GetParam(Func.Params,1,''),0);
              AlignStr := GetParam(Func.Params,2,'');
              if SameText(AlignStr,PAlignRight) then
                Align := taRight
              else if SameText(AlignStr,PAlignCenter) then
                Align := taCenter
              else
                Align := taLeft;
            end;
          end
          else if SameText(Func.FunctionName,RFileName) then
          begin
            FDefaultFileName := GetParam(Func.Params,0,'');
          end;
        end;
      end;
    end;
  finally
    Funcs.Free;
  end;
  // create controllers
  DataEntries.CreateControllers(Environment);
  // make relations between nodes
  MakeRelations;
end;

procedure TScriptContext.MakeRelations;
var
  i : integer;
  Stack : TStack;
  Node : TTOScriptNode;
  ForNode : TTOForLoop;
begin
  Stack := TStack.Create;
  try
    for i:=0 to Nodes.Count-1 do
    begin
      Node := TTOScriptNode(Nodes[i]);
      if Node is TTOForLoop then
        Stack.Push(Pointer(I))
      else if Node is TTOEndLoop then
      begin
        TTOEndLoop(Node).ForNodeIndex := Integer(Stack.Pop);
        ForNode := TTOForLoop(Nodes[TTOEndLoop(Node).ForNodeIndex]);
        ForNode.ExitNodeIndex:=I+1;
      end;
    end;
    CheckTrue(Stack.Count=0,ScriptError);
  finally
    Stack.Free;
  end;
end;

procedure TScriptContext.SetEnvironment(const Value: TRPDataEnvironment);
begin
  if FEnvironment <> Value then
  begin
    FEnvironment := Value;
    if FEnvironment<>nil then
    begin
      FEnvironment.FreeNotification(Self);
    end;
  end;
end;

procedure TScriptContext.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent=FEnvironment) and (Operation=opRemove) then
  begin
    Environment := nil;
  end;
end;

procedure TScriptContext.Clear;
begin
  DataEntries.Clear;
  Nodes.Clear;
  FDefaultFileName := '';
end;

procedure TScriptContext.Prepare;
var
  i : integer;
begin
  for i:=0 to Nodes.Count-1 do
  begin
    TTOScriptNode(Nodes[i]).Prepare(Self);
  end;
end;

end.
