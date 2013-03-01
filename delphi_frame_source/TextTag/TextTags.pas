unit TextTags;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit>TextTags
   <What>分离文本中的标记和文字
   <Written By> Huang YanLai (黄燕来)
   <History>
**********************************************}

interface

uses SysUtils, Classes, Contnrs;

const
  RuleCount = 10;
  VarStr = '@IT';

type
  //TCharDataType = (ctClear, ctConst,ctAny);
  TStatusType = (stText,stTag,stAny);
  TAppendTextType = (atEmpty,atQueue,atCurr,atQueueAndCurr);
  TSimpleString = string[1];
  {
  TRule = record
    Q0Type : TCharDataType;
    Q0 : Char;
    Status0 : TStatusType;
    CurType : TCharDataType;
    Cur : Char;
    Q1Type : TCharDataType;
    Q1 : Char;
  end;
  }
  TRule = record
    Q0 : TSimpleString; // '' match any char
    Status0 : TStatusType; //
    Cur : TSimpleString;  // '' match any char
    Q1 : TSimpleString;   // 1)'' is empty, 2)VarStr, Current char=>Q1, 3)const
    Status1 : TStatusType;
    Append : TAppendTextType;
  end;

  TRules = Array[0..RuleCount-1] of TRule;
var
  Rules : TRules
  =(
   (Q0 : '\';
    Status0 : stAny;
    Cur : '\';
    Q1 : '';
    Status1 : stAny;
    Append : atCurr),
   (Q0 : '';
    Status0 : stAny;
    Cur : '\';
    Q1 : '\';
    Status1 : stAny;
    Append : atQueue),
   (Q0 : '\';
    Status0 : stAny;
    Cur : '<';
    Q1 : '';
    Status1 : stAny;
    Append : atCurr),
   (Q0 : '\';
    Status0 : stAny;
    Cur : '>';
    Q1 : '';
    Status1 : stAny;
    Append : atCurr),
   (Q0 : '\';
    Status0 : stAny;
    Cur : '%';
    Q1 : '';
    Status1 : stAny;
    Append : atCurr),
   (Q0 : '';
    Status0 : stText;
    Cur : '<';
    Q1 : '<';
    Status1 : stText;
    Append : atQueue),
   (Q0 : '<';
    Status0 : stText;
    Cur : '%';
    Q1 : '';
    Status1 : stTag;
    Append : atEmpty),
   (Q0 : '';
    Status0 : stTag;
    Cur : '%';
    Q1 : '%';
    Status1 : stTag;
    Append : atQueue),
   (Q0 : '%';
    Status0 : stTag;
    Cur : '>';
    Q1 : '';
    Status1 : stText;
    Append : atEmpty),
   (Q0 : '';
    Status0 : stAny;
    Cur : '';
    Q1 : '';
    Status1 : stAny;
    Append : atQueueAndCurr)
   );

function  MatchRule(Q : TSimpleString; Status : TStatusType; C : TSimpleString):Integer;

type
  TTATextNode = class
  public
    NodeType : TStatusType;
    Text : string;
  end;

  TTextTagParser = class
  private
    FNodes: TObjectList;
    function    NewNode(NodeType : TStatusType): TTATextNode;
  public
    constructor Create;
    destructor  Destroy;override;
    procedure   Parse(Stream : TStream);
    procedure   ParseFile(const FileName:string);
    property    Nodes : TObjectList read FNodes;
  end;

implementation

function  MatchRule(Q : TSimpleString; Status : TStatusType; C : TSimpleString):Integer;
var
  i : integer;
begin
  Assert(Status<>stAny);
  Assert(Length(C)>0);
  for i:=0 to RuleCount-1 do
  with Rules[i] do
  begin
    if ((Status0=stAny) or (Status0=Status)) // status
      and ((Cur='') or (Cur=C))
      and ((Q0='') or (Q0=Q)) then
    begin
      Result := I;
      Exit;
    end;
  end;
  Result := -1;
  Assert(False);
end;

{ TTextTagParser }

constructor TTextTagParser.Create;
begin
  FNodes := TObjectList.Create;
end;

destructor TTextTagParser.Destroy;
begin
  FNodes.Free;
  inherited;
end;

function TTextTagParser.NewNode(NodeType: TStatusType): TTATextNode;
begin
  Result := TTATextNode.Create;
  Result.NodeType := NodeType;
  Nodes.Add(Result);
end;

procedure TTextTagParser.Parse(Stream: TStream);
var
  Q : TSimpleString;
  C : Char;
  Cur : TSimpleString;
  Append : string;
  Status : TStatusType;
  Node : TTATextNode;
  Rule : TRule;

  procedure SetStatus(Value : TStatusType);
  begin
    if Value<>stAny then
      if Value<>Status then
      begin
        Status := Value;
        if (Node.NodeType=stText) and (Length(Node.Text)=0) then
          Node.NodeType := Value else
          Node := NewNode(Status);
      end;
  end;

begin
  FNodes.Clear;
  Status := stText;
  Node := NewNode(Status);
  Q := '';
  while Stream.Position<Stream.Size do
  begin
    Append := '';
    Stream.ReadBuffer(C,SizeOf(C)); // read char
    Cur := C;
    Rule := Rules[MatchRule(Q,Status,Cur)];
    case Rule.Append of
      atEmpty : Append := '';
      atQueue : Append := Q;
      atCurr  : Append := Cur;
      atQueueAndCurr : Append := Q+Cur;
    end;
    if Rule.Q1=VarStr then
      Q := Cur else
      Q := Rule.Q1;
    SetStatus(Rule.Status1);
    Node.Text:=Node.Text+Append;
  end;
end;

procedure TTextTagParser.ParseFile(const FileName: string);
var
  FS : TFileStream;
begin
  FS := TFileStream.Create(FileName,fmOpenRead);
  try
    Parse(FS);
  finally
    FS.Free;
  end;
end;

end.
