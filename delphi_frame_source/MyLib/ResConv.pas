unit ResConv;

interface

uses Sysutils,Classes,controls,StDataStruct;

{ Theses Codes are adapted from Classes.ObjectBinaryToText}

type
  TResourceToken = (rtNone,rtIndent,rtLineEnd,rtSymbol,rtKeyword,
    rtInt,rtExtended,rtSingle,rtCurrency,rtDate,rtString,rtWString,
    rtIdent,rtBinary,rtList,rtSet,rtCollection);

  TFormResourceConverter = class
  private
    Input :         TStream;
    FNestTokens :   TStack;
    FNestingLevel:  integer;
    Reader :        TReader;
    SaveSeparator:  Char;
    FIndentNumber: integer;
    FPropLeading: string;
    FObjectLeading: string;
  protected
    procedure   Push(Token : TResourceToken);
    function    Pop(Token : TResourceToken=rtNone) : TResourceToken;
    procedure   Write(const Buf; Count: Longint); virtual;abstract;
    procedure   WriteStr(const S: string);
    procedure   WriteIdent(const Ident:string); dynamic;
    procedure   WriteKeyword(const Ident:string); dynamic;
    procedure   WriteIndent; dynamic;
    procedure   InternalWriteIndent; virtual;
    procedure   NewLine; dynamic;
    procedure   WriteLineEnd ; dynamic;
    procedure   ConvertBinary;
    //procedure   ConvertHeader;
    procedure   WriteHeader(const ClassName, ObjectName: string;
                  Flags: TFilerFlags;Position: Integer); dynamic;
    procedure   WriteObject(const ClassName, ObjectName: string;
                  Flags: TFilerFlags;Position: Integer); dynamic;
    procedure   ConvertObject;
    procedure   ConvertValue;
    procedure   WriteInt(const value : Integer); dynamic;
    procedure   WriteExtended(const value : Extended); dynamic;
    procedure   WriteSingle(const value : Single); dynamic;
    procedure   WriteCurrency(const value : Currency); dynamic;
    procedure   WriteDate(const value: TDate);  dynamic;
    procedure   WriteWString(const W:WideString); dynamic;
    procedure   WriteString(const S:string);  dynamic;
    procedure   WriteSymbol(const S:string);  dynamic;
    procedure   ConvertProperty;
    procedure   WriteProperty(const PropName:string); dynamic;
    procedure   WriteCollectionItem(Index : integer); dynamic;
    //procedure   WriteObject();
  public
    constructor Create;
    Destructor  Destroy;override;
    procedure   Start(FormStream : TStream; IsResource : boolean);
    property    NestingLevel : integer read FNestingLevel;
    property    NestTokens : TStack read FNestTokens;
    function    Top : TResourceToken;
    function    InTokenScope(Token : TResourceToken): boolean;
    property    IndentNumber : integer read FIndentNumber write FIndentNumber default 2;
    property    PropLeading : string read FPropLeading write FPropLeading;
    property    ObjectLeading : string read FObjectLeading write FObjectLeading;
    property    NestIndent : boolean read FNestIndent write FNestIndent;
  published

  end;

  TOnConvertObject = procedure (Sender : TFormResourceConverter;
                        const ObjectName,ClassName:string) of object;

  TOnConvertProperty = procedure (Sender : TFormResourceConverter;
                        const ObjectName,PropName:string) of object;

  TOnWriteConvertResult = procedure (Sender : TFormResourceConverter;
                        const Buf; Count: Longint; Token : TResourceToken) of object;

  TSimpleResourceConverter = class(TFormResourceConverter)
  private
    FNestIdents: TStringStack;
    FBeforeConvertProperty: TOnConvertProperty;
    FBeforeConvertObject: TOnConvertObject;
    FOnWrite: TOnWriteConvertResult;
    FAfterConvertObject: TOnConvertObject;
    FAfterConvertProperty: TOnConvertProperty;
    procedure   PushObject(const ClassName, ObjectName: string);
    procedure   PushProperty(const PropName:string);
    function    PopProperty: String;
    //procedure   PushObject(const ClassName, ObjectName: string);
    function    PopObject:string;
  protected
    procedure   WriteObject(const ClassName, ObjectName: string;
                  Flags: TFilerFlags;Position: Integer); override;
    procedure   WriteProperty(const PropName:string); override;
    procedure   WriteCollectionItem(Index : integer); override;
    procedure   Write(const Buf; Count: Longint); override;
  public
    constructor Create;
    Destructor  Destroy;override;
    property    NestIdents : TStringStack read FNestIdents;
    function    PropertyPath: string;
  published
    property    BeforeConvertObject : TOnConvertObject
                  read FBeforeConvertObject write FBeforeConvertObject;
    property    AfterConvertObject : TOnConvertObject
                  read FAfterConvertObject write FAfterConvertObject;
    property    BeforeConvertProperty : TOnConvertProperty
                  read FBeforeConvertProperty write FBeforeConvertProperty;
    property    AfterConvertProperty : TOnConvertProperty
                  read FAfterConvertProperty write FAfterConvertProperty;
    property    OnWrite : TOnWriteConvertResult read FOnWrite write FOnWrite;
  end;

implementation

{ TFormResourceConverter }

constructor TFormResourceConverter.Create;
begin
  inherited Create;
  FNestTokens := TStack.Create;
  FNestingLevel := 0;
  FNestIndent := true;
  FIndentNumber := 2;
  FPropLeading := '';
  FObjectLeading := '';
end;

destructor TFormResourceConverter.Destroy;
begin
  NestTokens.free;
end;

function TFormResourceConverter.Pop(Token : TResourceToken=rtNone): TResourceToken;
begin
  result :=  TResourceToken(NestTokens.Pop);
  assert((Token=rtNone) or (Token=result));
end;

procedure TFormResourceConverter.Push(Token: TResourceToken);
begin
  NestTokens.Push(Pointer(Token));
end;

function TFormResourceConverter.Top: TResourceToken;
begin
  result :=  TResourceToken(NestTokens.Top);
end;

procedure TFormResourceConverter.Start(FormStream : TStream; IsResource : boolean);
begin
  assert(FormStream<>nil);
  Input := FormStream;
  if IsResource then Input.ReadResHeader;

  FNestingLevel := 0;
  Reader := TReader.Create(Input, 4096);
  SaveSeparator := DecimalSeparator;
  DecimalSeparator := '.';
  NestTokens.Clear;
  push(rtNone);
  try
    Reader.ReadSignature;
    ConvertObject;
  finally
    DecimalSeparator := SaveSeparator;
    Reader.Free;
  end;
end;

procedure TFormResourceConverter.WriteIndent;
begin
  if NestIndent then
  begin
    push(rtIndent);
    InternalWriteIndent;
    pop;
  end;
end;

procedure TFormResourceConverter.InternalWriteIndent;
{const
  Blanks: array[0..1] of Char = '  ';
var
  I: Integer;
begin
  for I := 1 to NestingLevel do Write(Blanks, SizeOf(Blanks));
end;}
begin
  if IndentNumber>0 then
  begin
    WriteStr(StringOfChar(' ',IndentNumber*NestingLevel));
  end;
end;

procedure TFormResourceConverter.WriteLineEnd;
begin
  push(rtLineEnd);
  WriteStr(#13#10);
  pop;
end;

procedure TFormResourceConverter.NewLine;
begin
  WriteLineEnd;
  WriteIndent;
end;

procedure TFormResourceConverter.WriteStr(const S: string);
begin
  Write(S[1], Length(S));
end;

{
procedure TFormResourceConverter.ConvertHeader;
var
  ClassName, ObjectName: string;
  Flags: TFilerFlags;
  Position: Integer;
begin
  Reader.ReadPrefix(Flags, Position);
  ClassName := Reader.ReadStr;
  ObjectName := Reader.ReadStr;
  WriteHeader(ClassName, ObjectName,Flags,Position);
end; }

procedure TFormResourceConverter.WriteHeader(const ClassName,
  ObjectName: string; Flags: TFilerFlags; Position: Integer);
begin
  WriteIndent;
  if ffInherited in Flags then
      WriteKeyWord('inherited ')
  else
      WriteKeyWord('object ');
  if ObjectName <> '' then
  begin
      //WriteStr(ObjectName);
      WriteIdent(ObjectLeading+ObjectName);
      WriteSymbol(': ');
  end;
  //WriteStr(ClassName);
  WriteIdent(ClassName);
  if ffChildPos in Flags then
  begin
      WriteSymbol(' [');
      WriteStr(IntToStr(Position));
      WriteSymbol(']');
  end;
  WriteLineEnd;
end;


procedure TFormResourceConverter.ConvertBinary;
const
    BytesPerLine = 32;
var
    MultiLine: Boolean;
    I: Integer;
    Count: Longint;
    Buffer: array[0..BytesPerLine - 1] of Char;
    Text: array[0..BytesPerLine * 2 - 1] of Char;
begin
    Reader.ReadValue;
    push(rtBinary);
    WriteSymbol('{');
    Inc(FNestingLevel);
    Reader.Read(Count, SizeOf(Count));
    MultiLine := Count >= BytesPerLine;
    while Count > 0 do
    begin
      if MultiLine then NewLine;
      if Count >= 32 then I := 32 else I := Count;
      Reader.Read(Buffer, I);
      BinToHex(Buffer, Text, I);
      Write(Text, I * 2);
      Dec(Count, I);
    end;
    Dec(FNestingLevel);
    WriteSymbol('}');
    pop;
end;

function TFormResourceConverter.InTokenScope(
  Token: TResourceToken): boolean;
var
  i : integer;
begin
  for i:=NestTokens.count-1 downto 0 do
    if TResourceToken(NestTokens.items[i])=Token then
    begin
      result := true;
      break;
    end;
  result := false;
end;

procedure TFormResourceConverter.ConvertObject;
var
  ClassName, ObjectName: string;
  Flags: TFilerFlags;
  Position: Integer;
begin
  Reader.ReadPrefix(Flags, Position);
  ClassName := Reader.ReadStr;
  ObjectName := Reader.ReadStr;
  WriteObject(ClassName, ObjectName,Flags,Position);
end;

procedure TFormResourceConverter.WriteObject(const ClassName,
  ObjectName: string; Flags: TFilerFlags; Position: Integer);
begin
  WriteHeader(ClassName, ObjectName,Flags,Position);
  Inc(FNestingLevel);
  while not Reader.EndOfList do ConvertProperty;
  Reader.ReadListEnd;
  while not Reader.EndOfList do ConvertObject;
  Reader.ReadListEnd;
  Dec(FNestingLevel);
  WriteIndent;
  WriteKeyWord('end');
  WriteLineEnd;
end;

const
    LineLength = 64;

procedure TFormResourceConverter.ConvertValue;
var
    I, J, K, L: Integer;
    S: string;
    W: WideString;
    LineBreak: Boolean;
begin
    case Reader.NextValue of
      vaList:
        begin
          // write list
          Reader.ReadValue;
          Push(rtList);
          WriteSymbol('(');
          Inc(FNestingLevel);
          while not Reader.EndOfList do
          begin
            NewLine;
            ConvertValue;
          end;
          Reader.ReadListEnd;
          Dec(FNestingLevel);
          WriteSymbol(')');
          Pop(rtList);
        end;
      vaInt8, vaInt16, vaInt32:
        WriteInt(Reader.ReadInteger);
      vaExtended:
        WriteExtended(Reader.ReadFloat);
      vaSingle:
        WriteSingle(Reader.ReadSingle);
      vaCurrency:
        WriteCurrency(Reader.ReadCurrency);
      vaDate:
        WriteDate(Reader.ReadDate);
      vaWString:
        WriteWString(Reader.ReadWideString);
      vaString, vaLString:
        WriteString(Reader.ReadString);
      vaIdent, vaFalse, vaTrue, vaNil, vaNull:
        WriteIdent(Reader.ReadIdent);
      vaBinary:
        ConvertBinary;
      vaSet:
        begin
          Reader.ReadValue;
          Push(rtSet);
          WriteSymbol('[');
          I := 0;
          while True do
          begin
            S := Reader.ReadStr;
            if S = '' then Break;
            if I > 0 then WriteStr(', ');
            WriteStr(S);
            Inc(I);
          end;
          WriteSymbol(']');
          Pop(rtSet);
        end;
      vaCollection:
        begin
          Reader.ReadValue;
          Push(rtCollection);
          WriteSymbol('<');
          Inc(FNestingLevel);
          I:=0;
          while not Reader.EndOfList do
          begin
            WriteCollectionItem(I);
            Inc(I);
          end;
          Reader.ReadListEnd;
          Dec(FNestingLevel);
          WriteSymbol('>');
          Pop(rtCollection);
        end;
    end;
end;

procedure TFormResourceConverter.WriteCurrency(const value: Currency);
begin
  Push(rtCurrency);
  WriteStr(FloatToStr( value* 10000) + 'c');
  Pop(rtCurrency);
end;

procedure TFormResourceConverter.WriteExtended(const value: Extended);
begin
  Push(rtExtended);
  WriteStr(FloatToStr(Value));
  Pop(rtExtended);
end;

procedure TFormResourceConverter.WriteInt(const value: Integer);
begin
  Push(rtInt);
  WriteStr(IntToStr(value));
  pop(rtInt);
end;

procedure TFormResourceConverter.WriteSingle(const value: Single);
begin
  Push(rtSingle);
  WriteStr(FloatToStr(value) + 's');
  Pop(rtSingle);
end;

procedure TFormResourceConverter.WriteIdent(const Ident: string);
begin
  Push(rtIdent);
  WriteStr(Ident);
  Pop(rtIdent);
end;

procedure TFormResourceConverter.WriteDate(const value: TDate);
begin
  Push(rtDate);
  WriteStr(FloatToStr(value) + 'd');
  Pop(rtDate);
end;

procedure TFormResourceConverter.WriteString(const S: string);
var
  I, J, K, L: Integer;
  LineBreak: Boolean;
begin
  Push(rtWString);
          L := Length(S);
          if L = 0 then WriteStr('''''') else
          begin
            I := 1;
            Inc(FNestingLevel);
            try
              if L > LineLength then NewLine;
              K := I;
              repeat
                LineBreak := False;
                if (S[I] >= ' ') and (S[I] <> '''') then
                begin
                  J := I;
                  repeat
                    Inc(I)
                  until (I > L) or (S[I] < ' ') or (S[I] = '''') or
                    ((I - K) >= LineLength);
                  if ((I - K) >= LineLength) then
                  begin
                    LIneBreak := True;
                    if ByteType(S, I) = mbTrailByte then Dec(I);
                  end;
                  WriteStr('''');
                  Write(S[J], I - J);
                  WriteStr('''');
                end else
                begin
                  WriteStr('#');
                  WriteStr(IntToStr(Ord(S[I])));
                  Inc(I);
                  if ((I - K) >= LineLength) then LineBreak := True;
                end;
                if LineBreak and (I <= L) then
                begin
                  WriteStr(' +');
                  NewLine;
                  K := I;
                end;
              until I > L;
            finally
              Dec(FNestingLevel);
            end;
          end;
  Pop(rtWString);
end;

procedure TFormResourceConverter.WriteWString(const W: WideString);
var
  I, J, K, L: Integer;
  LineBreak: Boolean;
begin
  Push(rtString);
          L := Length(W);
          if L = 0 then WriteStr('''''') else
          begin
            I := 1;
            Inc(FNestingLevel);
            try
              if L > LineLength then NewLine;
              K := I;
              repeat
                LineBreak := False;
                if (W[I] >= ' ') and (W[I] <> '''') and (Ord(W[i]) <= 255) then
                begin
                  J := I;
                  repeat
                    Inc(I)
                  until (I > L) or (W[I] < ' ') or (W[I] = '''') or
                    ((I - K) >= LineLength) or (Ord(W[i]) > 255);
                  if ((I - K) >= LineLength) then
                  begin
                    LineBreak := True;
                    if ByteType(W, I) = mbTrailByte then Dec(I);
                  end;
                  WriteStr('''');
                  while J < I do
                  begin
                    WriteStr(Char(W[J]));
                    Inc(J);
                  end;
                  WriteStr('''');
                end else
                begin
                  WriteStr('#');
                  WriteStr(IntToStr(Ord(W[I])));
                  Inc(I);
                  if ((I - K) >= LineLength) then LineBreak := True;
                end;
                if LineBreak and (I <= L) then
                begin
                  WriteStr(' +');
                  NewLine;
                  K := I;
                end;
              until I > L;
            finally
              Dec(FNestingLevel);
            end;
          end;
  Pop(rtString);
end;

procedure TFormResourceConverter.WriteSymbol(const S: string);
begin
  push(rtSymbol);
  WriteStr(s);
  Pop(rtSymbol);
end;

procedure TFormResourceConverter.ConvertProperty;
begin
  WriteProperty(Reader.ReadStr);
end;

procedure TFormResourceConverter.WriteProperty(const PropName: string);
begin
  WriteIndent;
  WriteIdent(PropLeading + PropName);
  WriteSymbol(' = ');
  ConvertValue;
  WriteLineEnd;
end;


procedure TFormResourceConverter.WriteCollectionItem(Index : integer);
begin
            NewLine;
            WriteKeyWord('item');
            if Reader.NextValue in [vaInt8, vaInt16, vaInt32] then
            begin
              WriteSymbol(' [');
              ConvertValue;
              WriteSymbol(']');
            end;
            WriteLineEnd;
            //Reader.CheckValue(vaList);
            if Reader.ReadValue<>vaList then
              raise EConvertError.Create('Unexpected ReadValue');
            Inc(FNestingLevel);
            while not Reader.EndOfList do ConvertProperty;
            Reader.ReadListEnd;
            Dec(FNestingLevel);
            WriteIndent;
            WriteKeyWord('end');
end;

procedure TFormResourceConverter.WriteKeyword(const Ident: string);
begin
  Push(rtkeyWord);
  WriteStr(Ident);
  Pop(rtkeyWord);
end;

{ TSimpleResourceConverter }

constructor TSimpleResourceConverter.Create;
begin
  inherited Create;
  FNestIdents:= TStringStack.Create;
end;

destructor TSimpleResourceConverter.Destroy;
begin
  FNestIdents.free;
  inherited Destroy;
end;

function TSimpleResourceConverter.PopObject: string;
begin
  result := FNestIdents.Pop;
end;

function TSimpleResourceConverter.PopProperty: String;
begin
  result := FNestIdents.Pop;
end;

function TSimpleResourceConverter.PropertyPath: string;
var
  i,j : integer;
begin
  result := '';
  for i:=FNestIdents.count-1 downto 0 do
    if  FNestIdents[i][1]<>'.' then break
    else result:=FNestIdents[i]+result;
  if i>=0 then
  begin
    j := pos(':',FNestIdents[i]);
    result := Copy(FNestIdents[i],1,j-1)+result;
  end;
end;

procedure TSimpleResourceConverter.PushObject(const ClassName,
  ObjectName: string);
begin
  FNestIdents.Push(format('%s:%s',[ObjectName,ClassName]));
end;

procedure TSimpleResourceConverter.PushProperty(const PropName: string);
begin
  FNestIdents.Push('.'+PropName);
end;

procedure TSimpleResourceConverter.Write(const Buf; Count: Integer);
begin
  if assigned(FOnWrite) then
    FOnWrite(self,Buf,Count,Top);
end;

procedure TSimpleResourceConverter.WriteCollectionItem(Index: integer);
begin
  PushProperty(format('item[%d]',[index]));
  inherited WriteCollectionItem(Index);
  PopProperty;
end;

procedure TSimpleResourceConverter.WriteObject(const ClassName,
  ObjectName: string; Flags: TFilerFlags; Position: Integer);
begin
  PushObject(ClassName,Objectname);
  if Assigned(FBeforeConvertObject) then
    FBeforeConvertObject(self,ObjectName,ClassName);
  inherited WriteObject(ClassName,ObjectName,Flags,Position);
  if Assigned(FAfterConvertObject) then
    FAfterConvertObject(self,ObjectName,ClassName);
  PopObject;
end;

procedure TSimpleResourceConverter.WriteProperty(const PropName: string);
begin
  PushProperty(PropName);
  if Assigned(FBeforeConvertProperty) then
    FBeforeConvertProperty(self,PropertyPath,PropName);
  inherited WriteProperty(PropName);
  if Assigned(FAfterConvertProperty) then
    FAfterConvertProperty(self,PropertyPath,PropName);
  PopProperty;
end;

end.
