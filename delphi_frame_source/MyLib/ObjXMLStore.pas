unit ObjXMLStore;

{**********************************************
        Kingstar Delphi Library
   Copyright (C) Kingstar Corporation

   <Unit> ObjXMLStore
   <What> 用XML文件来保存对象
   <Written By> Huang YanLai
   <History>
**********************************************}

interface

uses
  SysUtils, Classes, TypUtils,TextUtils;

type
  TObjectXMLStore = class(TObject)
  private
    FHeader : String;
    FWriter : TTextWriter;
    FLevel : integer;
  protected
    function    GetTag(ObjClass:TClass; Const Tag:String):String; virtual;

    // for save
    procedure   WriteLine(const s:string; level:integer);
    procedure   WriteObject(Obj : TObject; Const Tag:String; level:integer);
  public
    constructor Create;
    Destructor  Destroy;override;
    property    Header : String read FHeader write FHeader;
    procedure   SaveToStream(Root:TObject; const RootTag:String; Stream:TStream);
    procedure   SaveToFile(Root:TObject; const RootTag,FileName:String);
    //procedure   LoadFromStream(Root:TObject; Stream:TStream);
    procedure   LoadFromFile(Root:TObject; const FileName:String);
  end;

function GetXMLText(const aText:string):string;
function GetXMLTag(ObjClass:TClass; Const Tag:String=''):String;

implementation

// use XDOM to parse XML file
uses XDOM;

type
  TXmlToDomParser2 = class(TXmlToDomParser)
  protected
    // do not convert CR+LF / CR --> LF
    function  NormalizeLineBreaks(const source :WideString): WideString; override;
  end;

function GetXMLText(const aText:string):string;
var
  i,len : integer;
  p : pchar;
  s : string;
begin
  len := length(aText);
  result := '';
  p := pchar(aText);
  for i:=1 to len do
  begin
    s:=p^;
    inc(p);
    case s[1] of
      #60: s:='&lt;';
      #62: s:='&gt;';
      #38: s:='&amp;';
      #39: s:='&apos;';
      #34: s:='&quot;';
    end;
    result := result+s;
  end;
end;

function GetXMLTag(ObjClass:TClass; Const Tag:String=''):String;
begin
  if tag<>'' then
    result := tag
  else
  begin
    Result := LowerCase(ObjClass.ClassName);
    if (Result<>'') and (Result[1]='t') then
      delete(Result,1,1);
  end;
end;

function  GetInnerText(Node : TDomNode):string;
var
  i : integer;
  Child : TDomNode;
begin
  Result:='';
  for i:=0 to Node.ChildNodes.Length-1 do
  begin
    Child := Node.ChildNodes.Item(i);
    Case Child.NodeType of
      ntText_Node : Result:=Result+Child.NodeValue;
      ntEntity_Reference_Node:
        if Child.nodeName = 'lt' then
          Result := Result + #60
        else if Child.nodeName = 'gt' then
          Result := Result + #62
        else if Child.nodeName = 'amp' then
          Result := Result +#38
        else if Child.nodeName = 'apos' then
          Result := Result +#39
        else if Child.nodeName = 'quot' then 
          Result := Result +#34
    end;
  end;
end;

{ TObjectXMLStore }

constructor TObjectXMLStore.Create;
begin
  inherited Create;
  FHeader:='<?xml version="1.0" ?>';
  FWriter := nil;
end;

destructor TObjectXMLStore.Destroy;
begin
  inherited;
end;

function TObjectXMLStore.GetTag(ObjClass:TClass; const Tag: String): String;
begin
  Result:=GetXMLTag(ObjClass,tag);
end;

// find first child for the special type
function  FindNode(Parent : TDomNode; ChildType:TDomNodeType):TDomNode;
begin
  Result := Parent.FirstChild;
  while Result<>nil do
    if Result.NodeType=ChildType then
      break
    else
      Result:=Result.NextSibling;
end;

procedure TObjectXMLStore.LoadFromFile(Root: TObject;
  const FileName: String);
var
  Parser : TXmlToDomParser2;
  DOM : TDomImplementation;
  Doc : TdomDocument;
  RootNode: TDomNode;
  aProperty : TProperty;

  procedure ReadObject(Node:TDOMNode; Obj : TObject); forward;

  procedure ReadProperty(Node:TDOMNode; Obj : TObject);
  {var
    Child : TDOMNode;}
  begin
    aProperty.CreateByName(Obj,Node.NodeName);
    if aProperty.Available then
    begin
      case aProperty.PropType of
        ptOrd,ptString,ptFloat:
          begin
            {Child := FindNode(Node,ntText_Node);
            if Child<>nil then
              try
                aProperty.AsString:=Child.NodeValue;
              except
                // silence
              end;}
            aProperty.AsString:=GetInnerText(Node);
          end;
        ptClass:
          if aProperty.AsObject<>nil then
            ReadObject(Node,aProperty.AsObject);
      end;

    end;
  end;

  procedure ReadObject(Node:TDOMNode; Obj : TObject);
  var
    Child : TDOMNode;
    ToReadItem : boolean;
    ItemTag : String;
    Collcetion : TCollection;
  begin
    ToReadItem := Obj is TCollection;
    if ToReadItem then
    begin
      Collcetion := TCollection(Obj);
      ItemTag := GetTag(Collcetion.ItemClass,'');
      Collcetion.Clear;
    end else
    begin
      Collcetion := nil;
      ItemTag := '';
    end;
    Child := Node.FirstChild;
    while Child<>nil do
    begin
      if Child.NodeType = ntElement_Node then
      begin
        if ToReadItem then
        begin
          // read a item
          if CompareText(Child.NodeName,ItemTag)=0 then
            ReadObject(Child,Collcetion.Add);
        end
        else
        begin
          // read a property
          ReadProperty(Child,Obj);
        end;
      end;
      Child:=Child.NextSibling;
    end;
  end;

begin
  Parser := nil;
  DOM := nil;
  Doc := nil;
  aProperty := nil;
  try
    Parser := TXmlToDomParser2.Create(nil);
    DOM := TDomImplementation.Create(nil);
    Parser.DOMImpl:=DOM;
    Doc := Parser.FileToDom(FileName);
    RootNode:= FindNode(Doc,ntElement_Node);
    aProperty := TProperty.create(nil,nil);
    if RootNode<>nil then ReadObject(RootNode,Root);
  finally
    aProperty.free;
    if (Doc<>nil) and (DOM<>nil) then
      DOM.FreeDocument(doc);
    Parser.free;
    DOM.free;
  end;
end;

//procedure TObjectXMLStore.LoadFromStream(Root: TObject; Stream: TStream);

procedure TObjectXMLStore.SaveToFile(Root: TObject; const RootTag,
  FileName: String);
var
  FileStream : TFileStream;
begin
  FileStream := TFileStream.create(FileName,fmCreate);
  try
    SaveToStream(Root,RootTag,FileStream);
  finally
    FileStream.free;
  end;
end;

procedure TObjectXMLStore.SaveToStream(Root: TObject;
  const RootTag: String; Stream: TStream);
begin
  FWriter := TTextWriter.Create(Stream);
  try
    FLevel:=0;
    WriteLine(FHeader,FLevel);
    WriteObject(Root,GetTag(Root.ClassType,RootTag),FLevel);
  finally
    FreeAndNil(FWriter);
  end;
end;

procedure TObjectXMLStore.WriteLine(const s: string; level: integer);
var
  i : integer;
begin
  // ident
  for i:=1 to level do
    FWriter.print('  ');
  FWriter.println(s);
end;

procedure TObjectXMLStore.WriteObject(Obj: TObject; Const Tag:String; level: integer);
var
  i : integer;
  aProp : TProperty;
  //child : TTreeNode;
  aAnalyser : TPropertyAnalyse;
  coll : TCollection;
  itemTag : string;
begin
  if obj<>nil then
  begin
    WriteLine('<'+tag+'>',level);
    if obj is TCollection then
    begin
      // Collection
      // build its children for its items
      coll := TCollection(obj);
      itemTag:=GetTag(coll.ItemClass,'');

      for i:=0 to coll.Count-1 do
      begin
        WriteObject(coll.items[i],itemTag,level+1);
      end;
    end
    else
    begin
      // normal object
      // build its children for its properties
      aAnalyser := TPropertyAnalyse.Create;
      try
        aAnalyser.AnalysedObject:=obj;
        for i:=0 to aAnalyser.PropCount-1 do
        begin
          aProp := aAnalyser.Properties[i];
          case aProp.PropType of
            ptOrd,ptString,ptFloat:
              begin
                itemTag := LowerCase(aProp.PropName);
                WriteLine('<'+itemTag+'>'+GetXMLText(aProp.asString)+'</'+itemTag+'>',level+1);
              end;
            ptClass:
              begin
                itemTag := LowerCase(aProp.PropName);
                WriteObject(aProp.AsObject,itemTag,level+1);
              end;
          end;
        end;
      finally
        aAnalyser.free;
      end;
    end;
    WriteLine('</'+tag+'>',level);
  end;
end;

{ TXmlToDomParser2 }

function TXmlToDomParser2.NormalizeLineBreaks(
  const source: WideString): WideString;
begin
  Result := source;
end;

end.
